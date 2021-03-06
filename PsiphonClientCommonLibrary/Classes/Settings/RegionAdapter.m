/*
 * Copyright (c) 2016, Psiphon Inc.
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "RegionAdapter.h"
#import "PsiphonClientCommonLibraryHelpers.h"


@implementation Region

@synthesize code = _code;
@synthesize flagResourceId = _flagResourceId;
@synthesize serverExists = _serverExists;

- (id) init {
	self = [super init];
	return self;
}

- (id) initWithParams:(NSString*)regionCode andResourceId:(NSString*)pathToFlagResource exists:(BOOL) exists {
	self = [super init];
	if (self) {
		_code = regionCode;
		_flagResourceId = pathToFlagResource;
		_serverExists = exists;
	}
	return self;
}

- (void)setRegionExists:(BOOL)exists {
	_serverExists = exists;
}

@end

@implementation RegionAdapter {
	NSMutableArray *flags;
	NSMutableArray *regions;
	NSDictionary *regionTitles;
	NSString *selectedRegion;
}

- (id)init {
	self = [super init];
	selectedRegion = [[NSUserDefaults standardUserDefaults] stringForKey:kRegionSelectionSpecifierKey];

	if (selectedRegion == nil) {
		selectedRegion = kPsiphonRegionBestPerformance;
	}

	regions = [[NSMutableArray alloc] initWithArray:
			   @[[[Region alloc] initWithParams:kPsiphonRegionBestPerformance andResourceId:@"flag-best-performance" exists:YES],
				 [[Region alloc] initWithParams:@"AT" andResourceId:@"flag-at" exists:NO],
				 [[Region alloc] initWithParams:@"BE" andResourceId:@"flag-be" exists:NO],
				 [[Region alloc] initWithParams:@"BG" andResourceId:@"flag-bg" exists:NO],
				 [[Region alloc] initWithParams:@"CA" andResourceId:@"flag-ca" exists:NO],
				 [[Region alloc] initWithParams:@"CH" andResourceId:@"flag-ch" exists:NO],
				 [[Region alloc] initWithParams:@"CZ" andResourceId:@"flag-cz" exists:NO],
				 [[Region alloc] initWithParams:@"DE" andResourceId:@"flag-de" exists:NO],
				 [[Region alloc] initWithParams:@"DK" andResourceId:@"flag-dk" exists:NO],
				 [[Region alloc] initWithParams:@"ES" andResourceId:@"flag-es" exists:NO],
				 [[Region alloc] initWithParams:@"FR" andResourceId:@"flag-fr" exists:NO],
				 [[Region alloc] initWithParams:@"GB" andResourceId:@"flag-gb" exists:NO],
				 [[Region alloc] initWithParams:@"HK" andResourceId:@"flag-hk" exists:NO],
				 [[Region alloc] initWithParams:@"HU" andResourceId:@"flag-hu" exists:NO],
				 [[Region alloc] initWithParams:@"IN" andResourceId:@"flag-in" exists:NO],
				 [[Region alloc] initWithParams:@"IT" andResourceId:@"flag-it" exists:NO],
				 [[Region alloc] initWithParams:@"JP" andResourceId:@"flag-jp" exists:NO],
				 [[Region alloc] initWithParams:@"NL" andResourceId:@"flag-nl" exists:NO],
				 [[Region alloc] initWithParams:@"NO" andResourceId:@"flag-no" exists:NO],
				 [[Region alloc] initWithParams:@"PL" andResourceId:@"flag-pl" exists:NO],
				 [[Region alloc] initWithParams:@"RO" andResourceId:@"flag-ro" exists:NO],
				 [[Region alloc] initWithParams:@"SE" andResourceId:@"flag-se" exists:NO],
				 [[Region alloc] initWithParams:@"SG" andResourceId:@"flag-sg" exists:NO],
				 [[Region alloc] initWithParams:@"SK" andResourceId:@"flag-sk" exists:NO],
				 [[Region alloc] initWithParams:@"US" andResourceId:@"flag-us" exists:NO]]];

	regionTitles = [RegionAdapter getLocalizedRegionTitles];

	return self;
}

+ (NSDictionary*)getLocalizedRegionTitles {
	return @{
			 kPsiphonRegionBestPerformance: NSLocalizedStringWithDefaultValue(@"SERVER_REGION_FASTEST_COUNTRY", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Fastest Country",@"The name of the pseudo-region a user can select if they want to use a Psiphon server with the best performance -- speed, latency, etc., rather than specify a particular region/country. This appears in a combo box and should be kept short."),
			 @"AT": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_AT", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Austria", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"BE": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_BE", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Belgium", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"BG": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_BG", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Bulgaria", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"CA": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_CA", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Canada", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"CH": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_CH", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Switzerland", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"CZ": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_CZ", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Czech Republic", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"DE": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_DE", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Germany",@"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"DK": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_DK", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Denmark",@"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"ES": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_ES", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Spain", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"FR": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_FR", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"France", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"GB": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_GB", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"United Kingdom", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"HK": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_HK", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Hong Kong", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"HU": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_HU", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Hungary", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"IN": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_IN", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"India", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"IT": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_IT", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Italy", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"JP": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_JP", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Japan", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"NL": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_NL", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Netherlands", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"NO": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_NO", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Norway", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"PL": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_PL", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Poland", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"RO": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_RO", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Romania", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"SE": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_SE", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Sweden", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"SK": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_SK", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Slovakia", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"SG": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_SG", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"Singapore", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country."),
			 @"US": NSLocalizedStringWithDefaultValue(@"SERVER_REGION_US", nil, [PsiphonClientCommonLibraryHelpers commonLibraryBundle], @"United States", @"Name of a country/region where Psiphon servers are located. The user can choose to only use servers in that country.")
			 };
}

+ (instancetype)sharedInstance
{
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

// Localizes the region titles for display in the settings menu
// This should be called whenever the app language is changed
- (void)reloadTitlesForNewLocalization {
	regionTitles = [NSMutableDictionary dictionaryWithDictionary:[RegionAdapter getLocalizedRegionTitles]];
}

- (void)onAvailableEgressRegions:(NSArray*)availableEgressRegions {
	// If selected region is no longer available select best performance and restart
	if (![selectedRegion isEqualToString:kPsiphonRegionBestPerformance] && ![availableEgressRegions containsObject:selectedRegion]) {
		selectedRegion = kPsiphonRegionBestPerformance;
		id<RegionAdapterDelegate> strongDelegate = self.delegate;
		if ([strongDelegate respondsToSelector:@selector(selectedRegionDisappearedThenSwitchedToBestPerformance)]) {
			[strongDelegate selectedRegionDisappearedThenSwitchedToBestPerformance];
		}
	}

	// Should use a dictionary for performance if # of regions ever increases dramatically
	for (Region *region in regions) {
		[region setRegionExists:([region.code isEqualToString:kPsiphonRegionBestPerformance] || [availableEgressRegions containsObject:region.code])];
	}

	[self notifyAvailableRegionsChanged];
}

- (NSArray*)getRegions {
	return [regions copy];
}

- (Region*)getSelectedRegion {
	for (Region *region in regions) {
		if ([region.code isEqualToString:selectedRegion]) {
			return region;
		}
	}
	return nil;
}

- (void)setSelectedRegion:(NSString*)regionCode {
	selectedRegion = regionCode;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue:selectedRegion forKey:kRegionSelectionSpecifierKey];
	[self notifySelectedNewRegion];
}

- (NSString*)getLocalizedRegionTitle:(NSString*)regionCode {
	NSString *localizedTitle = [regionTitles objectForKey:regionCode];
	if (localizedTitle.length == 0) {
		return @"";
	}
	return localizedTitle;
}

- (void)notifyAvailableRegionsChanged {
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:kPsiphonAvailableRegionsNotification
	 object:self
	 userInfo:nil];
}

-(void)notifySelectedNewRegion {
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:kPsiphonSelectedNewRegionNotification
	 object:self
	 userInfo:nil];
}

@end
