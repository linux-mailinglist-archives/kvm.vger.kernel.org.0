Return-Path: <kvm+bounces-59391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DABCFBB2A6E
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 08:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 952833C6905
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 06:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C55D2C08CA;
	Thu,  2 Oct 2025 06:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n19aYdnw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9816E2BDC0A;
	Thu,  2 Oct 2025 06:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759388351; cv=fail; b=UT0R0qmnbrlHQmm7VMDOCy9ikt1G+vdtWfFiUjo8vHioeERBt+gZYmhKHnPUe268Wrn85XXDjX/o+DzVP0uIlihrFZOfRdO9Jvgg5pgClOyEIDp38YiYGCo8Bska5DJcSGN9I5VyIUzoAuja9hVeb1ueoMmCEbgmyGVpu2jLSeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759388351; c=relaxed/simple;
	bh=xj09I1tEwTSLQJSEWMWDlgPgEJAUmepcPAfURjevlOI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XA/YP5e+CcRGEQsTw/Q284Q4ollCUHipN0SsdBb3K4FPfSKqwpaxcYFv+oK3VY3ssKovtE9e91BzzKEajrtGlGBipSkUu17WAC0u+vbUrmCwRsOMHxaaBoRJvvSz+DA5I9EiiUIGfGFczXNpTVSXwS2ZVjva0kPdWJWWXEZ7I6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n19aYdnw; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759388349; x=1790924349;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xj09I1tEwTSLQJSEWMWDlgPgEJAUmepcPAfURjevlOI=;
  b=n19aYdnwHUPDzCfCRZemwXcxYvCD3LjPfRxLgBGwalsg1PCTwLaysdAF
   DzAN4AFaemrXP8jNWwlW881U28KEghvtVK7fgwzGDza8Ums85PmiYeGm4
   zWW9jul1Nf4G/mmpGM2Wke0KxdR4eUrlCjAHTN7GZZRF3uP2/95VBQ/Ms
   fvQRUcAbAFRBErhke5e05u4o9ekdCPxVSnckk27GVcTN5qKMqzbwWCV3l
   sKG5calL2qR7tJq4+4x9FaZ40VhhcggE8ACXwi3nlryshEEm6x6HJBMui
   kWkjTg6qC0fxEqkOaw21qSJiBqffZbeECvSMM4qur/gIFCfZ608MOFt1Q
   g==;
X-CSE-ConnectionGUID: sRmwdpqfQISeLJs0IZDXyw==
X-CSE-MsgGUID: GNoor3GiTUGJ1jUT9VRZbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="49225751"
X-IronPort-AV: E=Sophos;i="6.18,308,1751266800"; 
   d="scan'208";a="49225751"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 23:59:08 -0700
X-CSE-ConnectionGUID: 5xu9oFRhRu2t+Pxjbfnxgw==
X-CSE-MsgGUID: LCrMiRoJT6SDw/sydiLUSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,308,1751266800"; 
   d="scan'208";a="209927245"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 23:59:09 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 23:59:07 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 23:59:07 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 23:59:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LqPRSdt2a7QabZOxkumKU6mZCVlG3svw1ZjvqacL+ylxNoBNaRteQESKzCTbZNyrYKT3P4TDhAjmyicLy1+DXiACeSCggdZEZPp1bkxLYzFhoJE2dlRBZ4PPHoA+1L352KNXKlJQfGIG1AORurMNZg+gV7krGkncARi1VxieNUcvHNRs3msMhj/rt/A4ckrCYmllHRIyHWC1/5bzcd+G3zQl03sMNlf+AkGxLXTjdSCAN78gv8Mzy0SRt5ajGaLbtShDqt/ckzMs6boET6ziP8aN6tOBOzH1voAtPGENr91MOEJZEwyTCRwEBMfZ7oySUR2uGYB4WQoA2SLmblsNLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xj09I1tEwTSLQJSEWMWDlgPgEJAUmepcPAfURjevlOI=;
 b=DgoYPINqq4Hn6/a9+UniW1TWrAZ2bhcxawhpjDY/p9hIiMCwG4l2v6t8bP590cgraKkHO2Wac6XiliIXd5Rl4UuBucpuHxYTDBrFKFEKv1kvOHA4uP7tjoqHNkHRLewftD/9/FWkiU1t799BEsdHV74JBYEsm3iCgBXMJ7nzYbQn4sGp5HaEotvr78nLwKg+a9dQEbOCd/T8qQ2sg2TgXr8tkdu7mWUiwPXxEzCnLL8XrTKCJ/X5UoQ0ze1ag/fBYflRfCV2x7/Ug6/8SeTTNV+pnZ/FWvIgXaxVBabV79EIdxqtmg8om6H7Ewkjp6sORqeeNHO7VvRqBOICH6FgYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 IA0PR11MB8400.namprd11.prod.outlook.com (2603:10b6:208:482::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 06:59:05 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 06:59:04 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "x86@kernel.org"
	<x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Gao, Chao" <chao.gao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
Subject: RE: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Topic: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Index: AQHcG1sHR09kpBppk0GYfhNVrRmfiLSrHywAgAFNloCAAExKAIAA0KKAgAAuMwCAAOKHcA==
Date: Thu, 2 Oct 2025 06:59:04 +0000
Message-ID: <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
 <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
 <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
 <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
In-Reply-To: <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|IA0PR11MB8400:EE_
x-ms-office365-filtering-correlation-id: ca41b93e-23a3-4b41-24a3-08de01812cb1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cm9mYmIzaHh5ek5BZUMzY3JlMTZ0TVBQUlZXNlRCUkFuRmJWUmdPbWJ0UG1E?=
 =?utf-8?B?QjBuc0wxQlFBOUgwR3dxS09BQzR4TkEzMFA3bzF0NWJpOUV1ZXZzMjZNZXQr?=
 =?utf-8?B?S1k5UnY2TjFSVFBxTnRQeHBIV1BTZHZ0bEtrRUF5eUphRDg1UVh2YVJaRU5J?=
 =?utf-8?B?SWNINW8xK0NkQWI0cGV6NjFsdFlaclB1K3oyejhjY0phcnNJc0pPT3dPT1pn?=
 =?utf-8?B?NkNHNVRKN1YxcHdHOURabnh2MVRpME52eWxpK3FUTlpVeFFEVXg3K09WMUxa?=
 =?utf-8?B?TkR5RkdtUnB0eU8wbkZRS25VVjBlend6WTd2QzVsVllVVGhTVEZxRVJjQ0RI?=
 =?utf-8?B?ekNoVENoamM2amxONVdOWjdzUXAzLzhWTHNzWlNyTi9KRkdsYkFZRUpHQlZy?=
 =?utf-8?B?UEN1bFBqR2dYbVVEbHUzUWhHMXZxVTMwUjlCOVlJWUQwOTRZRm94WjBmSjF5?=
 =?utf-8?B?R2xkd0RBSzFidUZzWHBxVGYvYnFGRUNOZjNwVXZrUlN5aHIvc2kwbjlIbmtQ?=
 =?utf-8?B?c1lLSDlQSnVORHo2cVZ2cWt2azRWQ2pDcjQ4TVRSTVp4TWNzSjhYNWxSRkZa?=
 =?utf-8?B?M011cGtNckJWeWtCeTJGZFB3UEF2WDAvQXVUMjF3MDlvZVR4cWt1MERML0Rk?=
 =?utf-8?B?cEpxa1grYUdMY280dWt0dDluWVRmZW9QWDBYOEE3Y1N6ZFBmaTZEaUhsMDJi?=
 =?utf-8?B?aEZydVphRHl2YnVPRDQwM2YzVTRXSDB0b0QvL29JeHJMWTErNERKV2NzdjZT?=
 =?utf-8?B?STM0MkpLeXNQMGg5MTFSRTI4KzJkZjdwdFQwNVNnM21hdUpuQnVTL3FOYnRH?=
 =?utf-8?B?b01aMmxrS25Ec2ovY3o5dXUwSDNZVGVqbzh2Q1Azay9rT09QWDZWVkFUSWV4?=
 =?utf-8?B?M2tsZUlxTloxZ0VmZUtsSjJ5aWp2WXA5WTkzQzlDcS9FaEdweDJlMmM4Ly8x?=
 =?utf-8?B?anA1cFlicVJMMytidE9FTWQwTHYyczZYYS85Q1ZvcTR6TmpFUmVIZENUTEdK?=
 =?utf-8?B?ZTJ5RDhKampoeEp0Mk5GRXhiZTZ5aEZtcWt1dEtCQUdseFRTeVcxaWkrQmY1?=
 =?utf-8?B?R0FKUGF1UFc2SFdTaHJkcTdVUytOZ3ZNTHFqTjNnQm9GS3E5c2VRUXBiYWxk?=
 =?utf-8?B?NjFVQ2krQ05sSlFqRWszekRaaTlmUkY4YlBoTW02QWlqNmZtbEZleUhmWTF5?=
 =?utf-8?B?ZEJWWmJTc21JdHRmOFpVRFR3c3BvaHJBMUdYc05zcXhGaHNFZE5DdHBDeWMw?=
 =?utf-8?B?UW9KcGN3QWdMNXl0VFppNU5Ua1NsclVZM0ZOeGlmUlJxTWM5ci91Q2Y0YnJL?=
 =?utf-8?B?R0tzY1UrR2MvV1g3dDRieTZCZHBhQkt0OTVsU0xyQVM5a0gxLy84ZGtZZVNE?=
 =?utf-8?B?ZzI2RUNOdktxNitxVVpManlEblhISU9Nc1p5K2JBMmlmL1p4K21PWHhCQkg1?=
 =?utf-8?B?NjQzK2VnK3BPWURScVNMeHYvb3U0V2sreE4weUJmbVBnc1cwYy9IOUVPaDM0?=
 =?utf-8?B?Sy9SN2RjcjYzWkMzbU9qS0V1dWRPNGVMZjVBa2REUXVnZXNOeFV6cHFLWVZ2?=
 =?utf-8?B?bDV4RGJOa2lhdC9aYkg5Zy9KTjVXVWVVNm04UjMzbk5MN1Z5eUZyQ2VKblM3?=
 =?utf-8?B?M3BwdGhISU5DM3hYN1psRHNZa3NuU0dkTlY0NEFjL1ZxV3U3U2N5N00ydlVi?=
 =?utf-8?B?b0syc2RHSmYyMHlBSTVRVURxUy8vYmxZZFNVU2VTSlN2S0p0MVpROWt3MUdI?=
 =?utf-8?B?VHN4cFRYaVBxbE9PRXJoTHI1SURQMGZIV093cDdWV0JJRW4yME4ySHNCRUg1?=
 =?utf-8?B?eTBCZ2VtQS8rTzdMUnhtMDFwMEQ2N0R1V05rT1ptNUV6WEtKU1JFZlBXdU9P?=
 =?utf-8?B?bWxBZjdtTEFQdDh2T2hjbklWTlZNUTNTNnJtYW9RbXZIVlR2L0hwNDhxd2l0?=
 =?utf-8?B?aVRiR2U1YTR2VFFuTnQxNWlrT2xYazJqZDR6eFhoNHBXcUh3WUJBUHdkbkFG?=
 =?utf-8?B?Z21DUTJsNi9DNGNsUnJhancyUll1TkpMWkNTczhDQjhvUjN4ZFBZU3MxWTRJ?=
 =?utf-8?Q?a6vNWd?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEgxM1d5VVhFTm1VZXYxWm01RWJsZDh4Mm1WRU5jbmVGSWxreFVvcUg2a2R2?=
 =?utf-8?B?UVY1RkV2cTA2b09BNWNrSGZxUDNCL0MrcSs4cC91ZWwzZitBUkNuNGdSandx?=
 =?utf-8?B?YkoyTmRSdFEzK05GUHh4RjFZOVdvRk1VSkZOSFo4VkdSMk9rai9INURvbkRl?=
 =?utf-8?B?QlhUdWU2bU1uL1I2Sk9QdDJzOXhjTnUyeTI1b2xJZDlreHlIS0J2NDNPTWh4?=
 =?utf-8?B?eVNUN250MVYvU1JvV2plYzN1cGRtSENEbEZxb3A4SVR1Mk5RSWNLNDB4VVh0?=
 =?utf-8?B?aVd5dUMrVUV1OGFZWkxVWGp0L2hzRG1UYnVvM3RiMDlSa0hPWitkNEpVWXAy?=
 =?utf-8?B?TDJsd2xEY3l2MzdZYVhBQmcrd0ZybjVZVkZVYkVnTmdmanlqaGJCdkhGZkJn?=
 =?utf-8?B?aDV2TTRhSjdnbVV1WWdqUXJkWFVZSWJxOW9jYlAyVldqek9wYU9UbnZLblVz?=
 =?utf-8?B?TTI2WUJzdERGV3licEh0M2NJNGl1ZWdyUm5MRXFkNlZZaFVlY09oYzNhODJZ?=
 =?utf-8?B?WVd6QkR2Vy9IRFB0R0hYWHFIVjRxLzhLTnNtQUVPWWFNeXNnOVc0U2VORTZ0?=
 =?utf-8?B?TENsbWt6QUZFVGIvTFBVZlVIT0ljNUcwWWtFZHZoRnNDNElCdnQwL1F3SlVD?=
 =?utf-8?B?eVZpUC91cncvdEdnTzJ5dlU4UThORFFjT3BaRWU2VEt5V3pTNG9ickk5dzE0?=
 =?utf-8?B?NzMxMkhPVVEwL0ZONmNMMnNGb2N3VDFxK2lmb1dIWVdlWnZLbndMajVCTTFH?=
 =?utf-8?B?ZklCbHFTMEljMUt0TTVhY0hjTlhSbFBJbDhObFUxNU5kNDBjSzZQQUx4M1hj?=
 =?utf-8?B?UlZLejlnNEFkQWxmcGM3M1ZZZm5TZUVtRjRkTjY4STRiN3VQVkh3ZGJhSVEz?=
 =?utf-8?B?TXVLZENHSm5EMnFvL2NLZmJYUkFaZTErbnphamxuWG1SVUh3dDVvbGN4ektH?=
 =?utf-8?B?aXVHZ1kyNnlUOUErRVpCVTFGZjNpTFVLem4rZ3B5Um5vYTA1ZUkxZ0dkUGZF?=
 =?utf-8?B?aUhlTlR4bmFyV2k2WlpaaFEweXV3d1hUb0pJMGNiaVB5YUxqV3crQlhnTzJj?=
 =?utf-8?B?b080TXdSNGl6S2ZXN2JxZ0xGVGNIWnlFM1dTS2x5aUdqMlA1T094RS9TNHdI?=
 =?utf-8?B?NTJQZGRBSW9UVzI5cENUTDdsMWRxc00yK3B1SmlJZ3M3V2NvOWVla3Bxa1Mx?=
 =?utf-8?B?eDk5M0RUM29vMjFVSENyM29oZlc0c3JSZXBsd3dNYkVwTFVrcjhXeS9rMEF0?=
 =?utf-8?B?WXc1MVdGaFNaeVJmNzl2c3FnRzh6d29pTHZhdzBxU3lxeFROdTQ4Q1liTXli?=
 =?utf-8?B?c3NMbW9mMVVTcHpLQ052ZHZObVJhaUdDSzNCcXRzQ0czYkl6Zy83V3ZhZko0?=
 =?utf-8?B?OVp6S1ozZ3hsSWRzZ2duTGhyaFlTUXdIYmIvWFdCWHkwYWJFT1dpZEZBNFli?=
 =?utf-8?B?WFk5Szl3QVdNQlV3YmdmRzdUdlZYWkRPRDBRL3lGZFo0cHZWMHU5ZTNSTUtv?=
 =?utf-8?B?QWU2R1RCUHJvQ2tSWTZhWVdoVzNPVlFsQVFvK0Niem40QS9sWWdxekgrcGw3?=
 =?utf-8?B?QWhrZm5ER1VnZkcreWZ0YjE0SUs4a3B1ZXNhRXk4UUlSVHJqOUtPcWJhNFdw?=
 =?utf-8?B?ejlVZHV2a0l5ZTFPbjhESkN1ZFdGNHlHWjB4dHZXeHBPUjAzUldhdWJOLzBy?=
 =?utf-8?B?cmQzVTY1YjRWYnEvUnd3MXVkL2s1SnlqY1lWNUxCL1NraHNwSUx5cWRhSlB4?=
 =?utf-8?B?T0N2dnQwV2tBUmNVRTIwN3lZb2hFMndsbWQxblJZNDI2ckhSWWkzcEllTXV2?=
 =?utf-8?B?c2FRdW1kK09LSmlkaGI0N1lkTE5SanRRNTRlZ3N0NkpIWTdJdFNlSlJiL2o4?=
 =?utf-8?B?bVpiYTVmL0JJbE9kMDdINDRVRzRlcnB4ZzB0bGc4aEN3cjgyd1RYTVoxWDQ3?=
 =?utf-8?B?Nm9qdDRhMG5CaWg5UUpVdlQ1RVFTaXdZVGIyRUhJOVhUY2cyelM3NVFrYWNo?=
 =?utf-8?B?M1Z2bHJVUEt1a01RTk9IU2h3SkczUGZoMm9SNjdvZW5rY25ONTNINGRGczl5?=
 =?utf-8?B?SFYxeWZyaytUNnhnWllDYTB1OTZrYTNjTDZRVzRDMFJVWFhuWm1DZTJCajhR?=
 =?utf-8?B?RUJhT1VoajNQaEs1U29KUEFrd0hObUZRcGhZcFBmL0l6TmFzeGlqeEtyWTJo?=
 =?utf-8?Q?ZwZf60f7koHQshquaCWfdTSD/LD+LCzo1tMPpAa60MUc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca41b93e-23a3-4b41-24a3-08de01812cb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2025 06:59:04.4996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atb91clyEQO60sRasQ6ZncGziBaL+60ghPHxz5HmH/rCfJefYm8a5ZTyQ9B5BMjAxT0jToVbNLj8YR113hn6nU87OLXXsmRDMxIUhaByBpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8400
X-OriginatorOrg: intel.com

PiBPbiBXZWQsIE9jdCAxLCAyMDI1IGF0IDc6MzLigK9BTSBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5z
ZW5AaW50ZWwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IE9uIDkvMzAvMjUgMTk6MDUsIFZpc2hh
bCBBbm5hcHVydmUgd3JvdGU6DQo+ID4gLi4uDQo+ID4gPj4gQW55IHdvcmthcm91bmRzIGFyZSBn
b2luZyB0byBiZSBzbG93IGFuZCBwcm9iYWJseSBpbXBlcmZlY3QuIFRoYXQncyBub3QNCj4gPiA+
DQo+ID4gPiBEbyB3ZSByZWFsbHkgbmVlZCB0byBkZXBsb3kgd29ya2Fyb3VuZHMgdGhhdCBhcmUg
Y29tcGxleCBhbmQgc2xvdyB0bw0KPiA+ID4gZ2V0IGtkdW1wIHdvcmtpbmcgZm9yIHRoZSBtYWpv
cml0eSBvZiB0aGUgc2NlbmFyaW9zPyBJcyB0aGVyZSBhbnkNCj4gPiA+IGFuYWx5c2lzIGRvbmUg
Zm9yIHRoZSByaXNrIHdpdGggaW1wZXJmZWN0IGFuZCBzaW1wbGVyIHdvcmthcm91bmRzIHZzDQo+
ID4gPiBiZW5lZml0cyBvZiBrZHVtcCBmdW5jdGlvbmFsaXR5Pw0KPiA+ID4NCj4gPiA+PiBhIGdy
ZWF0IG1hdGNoIGZvciBrZHVtcC4gSSdtIHBlcmZlY3RseSBoYXBweSB3YWl0aW5nIGZvciBmaXhl
ZCBoYXJkd2FyZQ0KPiA+ID4+IGZyb20gd2hhdCBJJ3ZlIHNlZW4uDQo+ID4gPg0KPiA+ID4gSUlV
QyBTUFIvRU1SIC0gdHdvIENQVSBnZW5lcmF0aW9ucyBvdXQgdGhlcmUgYXJlIGltcGFjdGVkIGJ5
IHRoaXMNCj4gPiA+IGVycmF0dW0gYW5kIGp1c3QgZGlzYWJsaW5nIGtkdW1wIGZ1bmN0aW9uYWxp
dHkgSU1PIGlzIG5vdCB0aGUgYmVzdA0KPiA+ID4gc29sdXRpb24gaGVyZS4NCj4gPg0KPiA+IFRo
YXQncyBhbiBlbWluZW50bHkgcmVhc29uYWJsZSBwb3NpdGlvbi4gQnV0IHdlJ3JlIHNwZWFraW5n
IGluIGJyb2FkDQo+ID4gZ2VuZXJhbGl0aWVzIGFuZCBJJ20gdW5zdXJlIHdoYXQgeW91IGRvbid0
IGxpa2UgYWJvdXQgdGhlIHN0YXR1cyBxdW8gb3INCj4gPiBob3cgeW91J2QgbGlrZSB0byBzZWUg
dGhpbmdzIGNoYW5nZS4NCj4gDQo+IExvb2tzIGxpa2UgdGhlIGRlY2lzaW9uIHRvIGRpc2FibGUg
a2R1bXAgd2FzIHRha2VuIGJldHdlZW4gWzFdIC0+IFsyXS4NCj4gIlRoZSBrZXJuZWwgY3VycmVu
dGx5IGRvZXNuJ3QgdHJhY2sgd2hpY2ggcGFnZSBpcyBURFggcHJpdmF0ZSBtZW1vcnkuDQo+IEl0
J3Mgbm90IHRyaXZpYWwgdG8gcmVzZXQgVERYIHByaXZhdGUgbWVtb3J5LiAgRm9yIHNpbXBsaWNp
dHksIHRoaXMNCj4gc2VyaWVzIHNpbXBseSBkaXNhYmxlcyBrZXhlYy9rZHVtcCBmb3Igc3VjaCBw
bGF0Zm9ybXMuICBUaGlzIHdpbGwgYmUNCj4gZW5oYW5jZWQgaW4gdGhlIGZ1dHVyZS4iDQo+IA0K
PiBBIHBhdGNoIFszXSBmcm9tIHRoZSBzZXJpZXNbMV0sIGRlc2NyaWJlcyB0aGUgaXNzdWUgYXM6
DQo+ICJUaGlzIHByb2JsZW0gaXMgdHJpZ2dlcmVkIGJ5ICJwYXJ0aWFsIiB3cml0ZXMgd2hlcmUg
YSB3cml0ZSB0cmFuc2FjdGlvbg0KPiBvZiBsZXNzIHRoYW4gY2FjaGVsaW5lIGxhbmRzIGF0IHRo
ZSBtZW1vcnkgY29udHJvbGxlci4gIFRoZSBDUFUgZG9lcw0KPiB0aGVzZSB2aWEgbm9uLXRlbXBv
cmFsIHdyaXRlIGluc3RydWN0aW9ucyAobGlrZSBNT1ZOVEkpLCBvciB0aHJvdWdoDQo+IFVDL1dD
IG1lbW9yeSBtYXBwaW5ncy4gIFRoZSBpc3N1ZSBjYW4gYWxzbyBiZSB0cmlnZ2VyZWQgYXdheSBm
cm9tIHRoZQ0KPiBDUFUgYnkgZGV2aWNlcyBkb2luZyBwYXJ0aWFsIHdyaXRlcyB2aWEgRE1BLiIN
Cj4gDQo+IEFuZCBhbHNvIG1lbnRpb25zOg0KPiAiQWxzbyBub3RlIG9ubHkgdGhlIG5vcm1hbCBr
ZXhlYyBuZWVkcyB0byB3b3JyeSBhYm91dCB0aGlzIHByb2JsZW0sIGJ1dA0KPiBub3QgdGhlIGNy
YXNoIGtleGVjOiAxKSBUaGUga2R1bXAga2VybmVsIG9ubHkgdXNlcyB0aGUgc3BlY2lhbCBtZW1v
cnkNCj4gcmVzZXJ2ZWQgYnkgdGhlIGZpcnN0IGtlcm5lbCwgYW5kIHRoZSByZXNlcnZlZCBtZW1v
cnkgY2FuIG5ldmVyIGJlIHVzZWQNCj4gYnkgVERYIGluIHRoZSBmaXJzdCBrZXJuZWw7IDIpIFRo
ZSAvcHJvYy92bWNvcmUsIHdoaWNoIHJlZmxlY3RzIHRoZQ0KPiBmaXJzdCAoY3Jhc2hlZCkga2Vy
bmVsJ3MgbWVtb3J5LCBpcyBvbmx5IGZvciByZWFkLiAgVGhlIHJlYWQgd2lsbCBuZXZlcg0KPiAi
cG9pc29uIiBURFggbWVtb3J5IHRodXMgY2F1c2UgdW5leHBlY3RlZCBtYWNoaW5lIGNoZWNrIChv
bmx5IHBhcnRpYWwNCj4gd3JpdGUgZG9lcykuIg0KDQpXaGlsZSB0aGUgc3RhdGVtZW50IHRoYXQg
dGhlIHJlYWQgd2lsbCBuZXZlciBwb2lzb24gdGhlIG1lbW9yeSBpcyBjb3JyZWN0LA0KdGhlIHNp
dHVhdGlvbiB3ZSBjYW4gdGhlb3JldGljYWxseSB3b3JyeSBhYm91dCBpcyB0aGUgZm9sbG93aW5n
IGluIG15IHVuZGVyc3RhbmRpbmc6DQoNCjEuIER1cmluZyBpdHMgZXhlY3V0aW9uIG9uIHBsYXRm
b3JtIHdpdGggcGFydGlhbCB3cml0ZSBwcm9ibGVtLCBob3N0IE9TIG9yIG90aGVyDQphY3RvciBl
eGVjdXRpbmcgb3V0c2lkZSBvZiBTRUFNIG1vZGUgdHJpZ2dlcnMgcGFydGlhbCB3cml0ZSBpbnRv
IGEgY2FjaGUgbGluZSB0aGF0DQpvcmlnaW5hbGx5IGJlbG9uZ2VkIHRvIFREWCBwcml2YXRlIG1l
bW9yeS4gDQpUaGlzIGlzIHNtdGggdGhhdCBob3N0IE9TIG9yIG90aGVyIGVudGl0aWVzIHNob3Vs
ZCBub3QgZG8sIGJ1dCBpdCBjb3VsZCBoYXBwZW4gZHVlDQp0byBob3N0IE9TIGJ1Z3MsIGV0Yy4g
DQoyLiBUaGUgYWJvdmUgY2F1c2VzIHRoZSBzcGVjaWZpZWQgY2FjaGUgbGluZSB0byBiZSBwb2lz
b25lZCBieSBtZW0gY29udHJvbGxlci4gDQpIb3dldmVyLCBoZXJlIHdlIGFzc3VtZSB0aGF0IG5v
IG9uZSBhY2Nlc3NlcyB0aGlzIGNhY2hlIGxpbmUgZnJvbSBURFggbW9kdWxlLA0KVEQgZ3Vlc3Rz
IG9yIEhvc3QgT1MgZm9yIHRoZSB0aW1lIGJlaW5nIGFuZCB0aGUgcHJvYmxlbSByZW1haW5zIGhp
ZGRlbi4NCjMuIEhvc3QgT1MgY3Jhc2hlcyBkdWUgdG8gc29tZSBvdGhlciBpc3N1ZSwga2R1bXAg
Y3Jhc2gga2VybmVsIGlzIHRyaWdnZXJlZCwNCmFuZCBrZHVtcCBzdGFydHMgdG8gcmVhZCBhbGwg
dGhlIG1lbW9yeSBmcm9tIHRoZSBwcmV2aW91cyBob3N0IGtlcm5lbCB0byBkdW1wDQp0aGUgZGlh
Z25vc3RpY3MgaW5mby4NCjQuIEF0IHNvbWUgcG9pbnQgb2YgdGltZSwga2R1bXAgY3Jhc2gga2Vy
bmVsIHJlYWNoZXMgdGhlIG1lbW9yeSB3aXRoIHRoZSBwb2lzb25lZA0KY2FjaGUgbGluZSwgY29u
c3VtZXMgcG9pc29uLCBhbmQgdGhlICNNQyBpcyBpc3N1ZWQgZm9yIHRoZSBrZXJuZWwgc3BhY2Uu
IA0KDQpJc24ndCB0aGlzIHRoZSByZWFzb24gZm9yIGFsc28gZGlzYWJsaW5nIGtkdW1wPyBPciBk
byBJIG1pc3Mgc210aD8NCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQo=

