Return-Path: <kvm+bounces-17120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8E48C1123
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 16:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 518DBB213FC
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 14:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C8515E7E0;
	Thu,  9 May 2024 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jRYPMV8h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3075115E7EE
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715264527; cv=fail; b=Hm78oO9enM998N/cYo1r12vddNX9GLH+PmpffbBSuy8CmK+iPtX3OA6kzqaWJxSZRtc2QZFId6A1DiRNvZGVmR7SURK7jmcyV68cJ0+1Cv88sta8zIOg2IAbndgROjvSra8yQYUKHzw/6Uxq/gd5k9gOh+ssZc32d/Gw+82KGFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715264527; c=relaxed/simple;
	bh=UVhh3vcC4NC5TNUlLLGhiAYUGXP8fpQeoCUMv+qFrMM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fkRwq/1Fg5rK6EzOGz8ewQMQPIYPf6xao9bhVgNF5r36NUSlfeF8OH7TSxQKCQFSSJ41bRyiVcNtAMCOknuJQHEMHjo1UGmpjCoKGNBUaDsJ2pY4LfXSgU2EG4z4gJ0S086eU43VyGb1zC7SU2y6Yb68gVQWndjO2TplMnMamDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jRYPMV8h; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715264525; x=1746800525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVhh3vcC4NC5TNUlLLGhiAYUGXP8fpQeoCUMv+qFrMM=;
  b=jRYPMV8hv8+3LBiz+wgbuf9c0tGgFrlS0RL6JsWkYnDVF0BSW0k9dMSW
   STJAio60t8ldJBrJI53tiQ8rSKHn38zb5RQvrbw0gV4W6Bmj8Da/Hkjcr
   mZdwstj7w+hB10MD1DHwwJA3WB5re64IrhGtD0NLx/VR0BTt8lMs99Ii9
   6m+JDDDyW3WaCWera+Y93yVWjgkVvQGi4q0e1WZnFk6Ga4AoVFirruRNt
   yd0XeCcUXMSTawVAIOfYGpwXINaSTziHlj7Iu53JA1XE3N2+cY9RbOKSy
   0BAMV3MEw7lSiCAJ1J/tZgMzZOuvxXOWzKOHrLKWaBh3DebygmTQEjz4h
   Q==;
X-CSE-ConnectionGUID: 0AIu8ZhhTviiDaaT9qLYxg==
X-CSE-MsgGUID: 0oeFwQkjR+aIbztjWi7TyA==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="21785299"
X-IronPort-AV: E=Sophos;i="6.08,148,1712646000"; 
   d="scan'208";a="21785299"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 07:22:04 -0700
X-CSE-ConnectionGUID: Nhj6GsNtRHCjcYs5Ftt3rQ==
X-CSE-MsgGUID: z/+CxOvJQ4yvokEC6hxhOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,148,1712646000"; 
   d="scan'208";a="29332037"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 May 2024 07:22:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 07:22:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 9 May 2024 07:22:03 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 07:22:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maMIX1TMyVbTW6l8I23NzGS0A4Ac+wnHrCoxt80CkM6Fsj5eQnEA6nEZsTXxZ5eNH8KZSVSTLgv+f3huw/wx+dF+y6HGMemj4rqepfPhrQZll8rciL2zmpqKzFPRsJoccYxkMW0x3kPYopAnlVlIAbbNbh6i7DLwumOMXBzV+l+RwXKbj8hlprIEg2bmFCoZfGeGT7YQC92rQzCw3LD0R/ej/mTyhleIT6O6bIS2yVzT+/LfCK7OUI4/EPJ19KNASErQq/qddUXpu37VW0VR33FPDk8uhC2DzLkmBaVnArpiq8vSN7Crm5EVkf5qsOrpZF3Q6vQpCcg2+RvG+CBAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVhh3vcC4NC5TNUlLLGhiAYUGXP8fpQeoCUMv+qFrMM=;
 b=hstqFM2ucw3IYSXm21+gswEZ7jFeIoy5jIhF5B8bUfNoWv6G+idDqBqhC/i7DV0zrH7TVvwhsmPFOGR8HjlAaOM6bR3DBUOLG29Fw/Ie7beL8XLYz66oBLSyWjFX6FTQ2NfYR3GaRxSY5wNWzKspxhsUNYoj67RqcECbZzj1llwRptlzmSZIEVj5x2+r9HFjX8iu4LZmJhbnA3ocL+6ioAswYFg6xcjHr0y3A3bjdLoZttWxG/3ZiEY8h8/4OM1tZc0QlYa8CiUDiLV3VVwUiv5RRM62afyI27fZMW9cUdLJWDsfVWpAUCmTV9CvUHZppRYj6ZmUluDlCUA3dp3zOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB5070.namprd11.prod.outlook.com (2603:10b6:a03:2d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Thu, 9 May
 2024 14:22:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7544.047; Thu, 9 May 2024
 14:22:00 +0000
From: "Liu, Yi L" <yi.l.liu@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Baolu Lu <baolu.lu@linux.intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Thread-Topic: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Thread-Index: AQHajLGka0nKoajpJUCq41VyBd+nNbFsOOKAgBRsyQCACVLMgIAAYvmAgADXsQCAANcygIAA+QaAgABpAwCAABEBgIAADJ0AgAGSkAA=
Date: Thu, 9 May 2024 14:22:00 +0000
Message-ID: <DS0PR11MB752930FF648A3DC511183568C3E62@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
 <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
 <20240506133635.GJ3341011@nvidia.com>
 <14a7b83e-0e5b-4518-a5d5-5f4d48aa6f2b@intel.com>
 <20240507151847.GQ3341011@nvidia.com>
 <07e0547d-1ece-4848-8e59-393013b75da8@intel.com>
 <20240508122556.GF4650@nvidia.com>
 <5efdd36d-2759-4f71-92f6-4b639fc9dbc8@intel.com>
 <20240508141156.GJ4650@nvidia.com>
In-Reply-To: <20240508141156.GJ4650@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB5070:EE_
x-ms-office365-filtering-correlation-id: 18083c9d-8314-44b7-2ba5-08dc7033641e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?bi5Vt8Ke0S8pqFijsKJCENrMYIWPW9ISpeI5IX9Y6roxLZ/PZP8S6Te6U/+q?=
 =?us-ascii?Q?Ejp+7qwax2PAyj9thoR7in9lHeQVpsNK9+XFoaLtRYRm/kCwqvq2hDOY9R5H?=
 =?us-ascii?Q?1ewA+edqIvPXyOdwvwIz8vOihKta+rbGsPAlrJJELWe2jIKHI9bFrXT2liYB?=
 =?us-ascii?Q?U3N9egocil1iDdyOMXtILMMEqSvL6E+x5SO7WEByvlfNVSjNK9X9Kv1I0YOU?=
 =?us-ascii?Q?5tmDNAb5suggecGGkuXbH+5Y5nC3RxTJOwr5aFA80gMc1j0WLQSmrWjUzz3v?=
 =?us-ascii?Q?xBTTywK/lg5eZgrbTcpje+BJS2WVpg9bRoTYBZ7aS64d7avU1pN+LVxXGB11?=
 =?us-ascii?Q?MDPwh8h7gCHoQyuwINQb+2j0/1/QequKKi6XVO0wuZ5VvMEbtaohONSx4rmy?=
 =?us-ascii?Q?KcrahGi49ya1MgmJI7fg/MOdnbkhWmUXHwxkUUKJelG2C6uN1V7jlfn7Pty3?=
 =?us-ascii?Q?/F2cXVuhPmrYmWow6aPTc9CH3mFoXbsYmpdulNQ17E1YDbkASCuZyhAQwEPP?=
 =?us-ascii?Q?eimJG3JukHV0XgsO8IDSrDB197DqeqQmh1mtcWee5gWJNzXS8HXNc20ZbpU5?=
 =?us-ascii?Q?VplEx13Xz0MRoUrzbRs0LP23kKWH5BkJ01GgfHl4iejy37/7RZOxLvHZIZ9c?=
 =?us-ascii?Q?kV1F3MCyY0xY9RKMMj28q727heqedmGCg9IYdvk9p8hrNAYYB0xO5N95p34r?=
 =?us-ascii?Q?0h9TfTWuw7abFyaDqRaxuA35lF/wqBrvTvABYlD+PHKW4Tb+bUVEHZR14HCd?=
 =?us-ascii?Q?2+OlZ/NtE2Pe7/LA29ZHZLI1VqsQdf3nOH8+pgzY/1yhFg1O8DG3TGmiHkw2?=
 =?us-ascii?Q?wqrnwrhkH23ot1V5lNYnqYizTQyBiEx3xlkQeDmCxhdfAVGeM1Ihs9qDEVIJ?=
 =?us-ascii?Q?aTLH6ZOyCWS+dS0fTdxSqrhR80AnytpBFaUDRDEafKw1WCmfrRz7meURmeQu?=
 =?us-ascii?Q?QPAorHe+2IQeT6nexgCiq+aHhjm1UMVsL7LZ6jtHx/nhi5OBA2lEtz5CxWkw?=
 =?us-ascii?Q?6pwbOQH4Sy9q7RHaKJtq9luNUTExmftosKuj9krAlAdk03CeC6iqrVPnfKXJ?=
 =?us-ascii?Q?ntxxL+6PRCkdaer+CLO79MLjPNVqpe3OVHItrEQ2mwcwEf+B6PyN6YEiM3tM?=
 =?us-ascii?Q?Y9xMldrInmcMaGqcwW38KA67FqzSgKzZ/RwULlgugqOF3wmbHW0LjgxMFEM3?=
 =?us-ascii?Q?quoAyrxqWmypCKo6G9EIxvm/+TZ5A+R6b1BXOvraeBK7ndjxPazy4wYBgfsD?=
 =?us-ascii?Q?NwOYbTEZ91R2VQAHnF/BqPOA4j8oilerp/QkzoeR+PYs5lEngqyrRZpwMFTI?=
 =?us-ascii?Q?Fc9PIA/FWhufJwVAti2jnnDLpZDQzQITQc0zlDu1bBnqqg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A0iyfZ+MZVwy2ViOjkp2AUhVPRmI1XGdx57ghF82psiddMbfMVHjc+uclTID?=
 =?us-ascii?Q?Mvl30eHgEouQjRuuHpjvm6dMkAGg/4hmQOyTINZP8Mf9O7pmIFkMYkw5JLlu?=
 =?us-ascii?Q?Rlk2SdwwSjIwa+z7qnod0hpOOu0lpAopvlLgX6B4mRybVcN4usO9UDNmG5Ta?=
 =?us-ascii?Q?VMpXOH1o8CdbgKXleMie3dIlQ0IJF5EaA3TqB3zM/shTQbybecYL8JNqzR2q?=
 =?us-ascii?Q?XO7KYIekB9B9n0odTHSLBSG674zi7lC0M2IeAz260mOQQ6b3vxmnNQvmGcro?=
 =?us-ascii?Q?yJ7HSxwIrl6PzgPJ4w0AjdFLyZxAQq8iKV2DxuI3qlyhq3mRPwuERtfwcvl+?=
 =?us-ascii?Q?1+/wxjoyuEJJLVgFv5vGfLQnrN0Mt86KsKIUAtvRoMM57xq4IjCfwXX1CVz0?=
 =?us-ascii?Q?M6w5MbEw01swHTzeQJe3ewCfK1X8sVWTVQYAW34XMdi/QfD8/qnWXt2+F5fr?=
 =?us-ascii?Q?/LaOes+om7Gmh8ozR/c5eYFuit/j6CEKuwPr8p5b+9JAFJefvj39T7CNfrlk?=
 =?us-ascii?Q?0kGYCW5NT4J1bTedq6rPMjUriBHD7BgiU23ddTZ2LvTlUkgpTpZGhYNJgxks?=
 =?us-ascii?Q?o+/wzxFkvhcgLQ/XqDHtZtyRZc0ksnLf+1TREVt0h9QW+pW75Tn9PbXdAScO?=
 =?us-ascii?Q?ABBp2HMPDmOZudntw547w/5nhW0pTzBpYveCe8rlS6FAnmGGa5aSbLHMSyqT?=
 =?us-ascii?Q?95U1SRWr9qocIaJ1tg+EyVQCYUAcVSU6Z4o3AlgeaTMbHOgzuT/q1ioh/3Hs?=
 =?us-ascii?Q?fQxIU9R4p6I0UMguPQiwYBVGPtwbKmWjWJVUxRci1BcoPCnWCKPR3w5iJuBQ?=
 =?us-ascii?Q?NLy5f1H/+4wXsPMRAhZntlxO32zR9F7PAi06xEp1LO2NqfmWT6NrwwNRi26I?=
 =?us-ascii?Q?WGYlxe0xR5S6hKRZhSNALLPpxsYMCM+kmNWcd9C4pQQVk3mzaR8YLlwWZOxW?=
 =?us-ascii?Q?01X9R14ws6KFXYhGaPVB/dvLDW8m/3WpRyA3onRe/70N5YBFayrAQP+nKjgq?=
 =?us-ascii?Q?6HvOd4+BXy/SvL9+PihSEahlfflx8at7wqQiVCq6BBLuLrzRMlT5EjGGE6Yw?=
 =?us-ascii?Q?87YUGkwSWPlieAxlp8C27BAQB2hesbWeo0XnG0w3CwJnPG23671WxxprTfKx?=
 =?us-ascii?Q?Pnnj8WhVZo6ZHkrQpgkZ9xQjr4xoJfvg9Lke3XU6Lbh1/0i1bHdTT+nSp38+?=
 =?us-ascii?Q?0rWyL7W+X3Wfx4BaNuJCptwY06bjpDDUNZlVe5MQOsRphjgpE1Wbz8+6gLRv?=
 =?us-ascii?Q?/AM6+atxevS0MZTFepZxF/fwN3DKfNKeYhHbtckn+DTl8YzJisoqsw58qiKy?=
 =?us-ascii?Q?cDpA5ohp9FXCE61hCEgSi8qyw+mUQ25/wKKyEDU7KWQhLB7S9lWImzacXxoW?=
 =?us-ascii?Q?kPWKlJ/Tusq7HgwKt5rwRlEH1RccYaEsr3LXzHr4XJ8hd8SjSTRpL5BcKelU?=
 =?us-ascii?Q?9jOEfZl3XGFx9ZvlryNkzcfz7Y5NcoOgEVD2R3SWHaRv490kQl2Wdw8m0ZMv?=
 =?us-ascii?Q?7Lyw//UyeQLkbUr9sloky4Nxh8D9KTfNAvD2h4Xf27J0JFbZIRHwLT81J/uy?=
 =?us-ascii?Q?nctdbwGd1b+eYqhXQuo2CIomWR8NZMWrcPeHdatA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18083c9d-8314-44b7-2ba5-08dc7033641e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2024 14:22:00.4686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kA0X9RHcsvNYER9oQQoUsngsco6GsQ9DbpMzWpFn4x0ogBsnAzScWiQYHP4CWH5t20PeYU4frGGxkRfScH+gGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5070
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> On Wed, May 08, 2024 at 09:26:47PM +0800, Yi Liu wrote:
> > On 2024/5/8 20:25, Jason Gunthorpe wrote:
> > > On Wed, May 08, 2024 at 02:10:05PM +0800, Yi Liu wrote:
> > > > On 2024/5/7 23:18, Jason Gunthorpe wrote:
> > > > > On Tue, May 07, 2024 at 10:28:34AM +0800, Yi Liu wrote:
> > > > > > > > We still need something to do before we can safely remove t=
his check.
> > > > > > > > All the domain allocation interfaces should eventually have=
 the device
> > > > > > > > pointer as the input, and all domain attributions could be =
initialized
> > > > > > > > during domain allocation. In the attach paths, it should re=
turn -EINVAL
> > > > > > > > directly if the domain is not compatible with the iommu for=
 the device.
> > > > > > >
> > > > > > > Yes, and this is already true for PASID.
> > > > > >
> > > > > > I'm not quite get why it is already true for PASID. I think Bao=
lu's remark
> > > > > > is general to domains attached to either RID or PASID.
> > > > > >
> > > > > > > I feel we could reasonably insist that domanis used with PASI=
D are
> > > > > > > allocated with a non-NULL dev.
> > > > > >
> > > > > > Any special reason for this disclaim?
> > > > >
> > > > > If it makes the driver easier, why not?
> > > >
> > > > yep.
> > > >
> > > > > PASID is special since PASID is barely used, we could insist that
> > > > > new PASID users also use the new domian_alloc API.
> > > >
> > > > Ok. I have one doubt on how to make it in iommufd core. Shall the i=
ommufd
> > > > core call ops->domain_alloc_paging() directly or still call
> > > > ops->domain_alloc_user() while ops->domain_alloc_user() flows into =
the
> > > > paging domain allocation with non-null dev?
> > >
> > > I mostly figured we'd need a new iommu_domain_alloc_dev() sort of
> > > thing? VFIO should be changed over too.
> >
> > Would this new iommu-domain_alloc_dev() have flags and user_data
> > input?
>=20
> No, it would be an in-kernel replacement for the existing API.

Ok.

> > As below code snippet, the existing iommufd core uses domain_alloc_user
> > op to allocate the s2 domain (paging domain), and will fall back to
> > iommu_domain_alloc() only if the domain_alloc_user op does not exist. T=
he
>=20
> Oh, right. Yeah we built it like that so that drivers would have
> consistency that iommufd always uses the _user version if it exists.

Yep. This means for the iommu drivers that have implemented
domain_alloc_user op, it would not call into the new iommu_domain_alloc_dev=
().=20
So I would need to make the intel domain_alloc_user op allocate paging doma=
in
with non-dev as well.

> > typical reason is to use domain_alloc_user op is to allocate a paging
> > domain with NESTED_PARENT flag. I suppose the new iommu_domain_alloc_de=
v()
> > shall allow allocating s2 domain with NESTED_PARENT as well. right?
>=20
> No, it is just a simple replacement for iommu_domain_alloc() that does
> exactly the same thing. We don't have any in-kernel use for anything
> more fancy than a simple domain right now.

Yes.

Regards,
Yi Liu

