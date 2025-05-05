Return-Path: <kvm+bounces-45415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5311FAA9381
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 14:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EB6C3AA438
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 12:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A6C250BED;
	Mon,  5 May 2025 12:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="exiU3w/T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E6C1DA60D;
	Mon,  5 May 2025 12:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746449076; cv=fail; b=BOIeHhRywHuVgSAN6mAn0NuETGsKQ4Z4UynimoZMEKhNnEYK5NoPFjv7CWSPciPREpjLGjmzyYLu6KrGWiengvadHwqP/8CZnUlnsGLdkZb4o0XRqjpEVHPzEulDBOmXXikvxA6B83InqQNypxbcOwGGjlh9ZPnuSyCloUR/fdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746449076; c=relaxed/simple;
	bh=w4Ya3+L4CfH9ZXVJJwQLYqLyzJPUeadQ9GIAKWV0KYE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LZmSEKYnVusMUx5vsdEyVVPHMfw5KQpm8qFYTFUi5PdJZ6cXcK6dcBKJk67zh5PBRm2xDwhOWjJjM/NVELzggPAQMReqqa4pQcW+ND/vmQ70DIwYDJ202LOX45rEZkFB/0aBFBb8MFKuaS/Moytl8C9nswnl/M75diyjaO2JjuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=exiU3w/T; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746449075; x=1777985075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w4Ya3+L4CfH9ZXVJJwQLYqLyzJPUeadQ9GIAKWV0KYE=;
  b=exiU3w/TUcVtzTE+TaiN/fOlWM/70glU09XSDtzZHubAYQDc1VSr7Nh8
   21Rmi5DO9q+o5q7N1mZY2wzE4r59QK+gPlOXyozi9uUQhoED8h1HFiLXh
   UI55O64OqdbFv8g+BpngiHEpYRRnqo3kQZv2oDPJMlVEWBqWR+6QQhEA0
   BKKu8YDqZ17fIDWbS3fUGLrjJB+uPlOEfdWHLWdy/AaE9IwK5TWwuUcRi
   WyJrgUo1goT4Yw3Z96p1qcmYBDGwqJEVHOsXQBYMeX24c9FAFCsa7HN50
   XlQRpoMEtUmkTgHVObkcYDT5vvS/IGOg7QQ8zLEHuK1SyK3vl9MRUQ8Og
   A==;
X-CSE-ConnectionGUID: z15quSMCTO260+VRAgmaBg==
X-CSE-MsgGUID: O81O7xYKRhe7tdwHYSIiqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11423"; a="47161050"
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="47161050"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 05:44:34 -0700
X-CSE-ConnectionGUID: vETCyqjISYWR2fcGVGdzxw==
X-CSE-MsgGUID: 152PDJoTQIGpYPKQGxYo/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="135577295"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 05:44:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 5 May 2025 05:44:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 5 May 2025 05:44:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 5 May 2025 05:44:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sgDePCUTU2wL3E5zIgN70nS79ubL0rYtFI9orSd3nHupqcti+i4f6H2vxDkWLm/qdNogwTM0ZJbxzhG5/Y4bjw7r4Z/YFibLfREzpvU+d3ajbqHyxV18BSVFdxhV9OFyMdgW//+VD+6H9wuV8PnAiffgLVflzY+vzOxtalULOQLhYQAX/+IzQkG+XCnXgp4GsKH4CTIzqLULJDaD49PAMdSGIzkek/RM6Z2iqK+D3fLSzQRlaLiDdgLYkQzn5JrWGFgwv2cuG5fzo0MmE+EdRC+DHJU14IudOXLaK/rpmXIhwQJW6gVLUWvu7RP+7lJOjUu9UkY73HgGjao492u58w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4Ya3+L4CfH9ZXVJJwQLYqLyzJPUeadQ9GIAKWV0KYE=;
 b=w2qkiP3qju+AfdNK6M8SQwDYArPywVCJnskwB5gzxaY0e9mCoTd2AGIHuaosZJhMol6W6I5mwY/vdd3a5XMQAOmx98Ggr4Xc2S68ed032i6FUtbU+k1hvXbyiKaI3DLjkaLFUzhe7cvcBvbsPw5P6edBsVFTZdtBa//0oWvPPXn9V4pAmJBULVrEbpnD3jZ96t2LQ2cuYpHlfwGjLgCVy6Jkvg/yNMsHB5SJg1Qotc2LwTYu95RjxbcKOeenuTt7ewbcwa5GMSzbxcQBR9v13HZO1nDwyIawKCrGLHu1uIWmD8lVr0Ftz49RLnSGXXMtF9CcPA7yHo94pSLICZhgCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4442.namprd11.prod.outlook.com (2603:10b6:5:1d9::23)
 by CY8PR11MB7921.namprd11.prod.outlook.com (2603:10b6:930:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Mon, 5 May
 2025 12:44:28 +0000
Received: from DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9]) by DM6PR11MB4442.namprd11.prod.outlook.com
 ([fe80::b4a2:9649:ebb:84f9%4]) with mapi id 15.20.8699.022; Mon, 5 May 2025
 12:44:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Thread-Topic: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Thread-Index: AQHbu2NfxjqKz8bI3EqBcXZ5QoA6ibPEABSA
Date: Mon, 5 May 2025 12:44:26 +0000
Message-ID: <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4442:EE_|CY8PR11MB7921:EE_
x-ms-office365-filtering-correlation-id: 215cb786-5414-4324-d676-08dd8bd29201
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dHlvMXBTQzRlWXJJU3psWFhubElscFNEOU9Cb0dnbTRUWFVPTy9FeDJaUVFT?=
 =?utf-8?B?OFJ6bHQwaThrT25UY0luVVBnZXFIcGxWMWhwMkNZZXFQYSszOTZUaER2dXVy?=
 =?utf-8?B?TWZsamdUOGMrTTVGVVc4TTVCYWtFMm9PeEh5OUZTamxWeThKTFlTMmltaGp6?=
 =?utf-8?B?bCtJcGlYR251UXFZWEV3U3pTTmo0MGpVN1IwU3hxdldVakJhTVJOc3NtVjFR?=
 =?utf-8?B?M1NFb1I4TFlkRFRUTHRUdnk0TGVaQkdjamxpQ0pnYlgxenZqQVFrSktlMkdW?=
 =?utf-8?B?djBkLzVpWERmNS90a1lTRWczYlFidjdsVmlXb3FFeTFHdjBMZml0RGxiU0Z4?=
 =?utf-8?B?bkR0SmFqNHpWVjNvOS9PQXhpMFIwYlhOTjk3NkFCRkhjTjdzaFkrUU5oZ3FM?=
 =?utf-8?B?ckhYcmRzcW9mVWMzeDBIaGVoako1NVBOeUFnUDk4ZHptUFlGYXJNbU9RaVM1?=
 =?utf-8?B?Y2hsWlcySytTbDd5di9ncng2VEV3bDVTbXdGWEhoNGZGT1VwR1pLa25yZlVy?=
 =?utf-8?B?R3AyWFlVajlMRUVOMEdlZXl4aTFkdzlvZGQ1RmNsUXJMODBVUFpuL2x6Tzla?=
 =?utf-8?B?b0IxTklTZDM1RkJJamJkQzRoQnh1ci84RTdzR1ZzcHBPWDJ1ZkVpM2l1ckto?=
 =?utf-8?B?YkIrSlhrTVQyWjN5K0xwVlY4RStyWCsrWVlHKzRnMVlqQVl4VXFid21iUXVt?=
 =?utf-8?B?KzNaSSs0UGY1UnNHUXB3VE1TZU1QYXFpTnFWeXArK3JiL2p1QURRemdaZm12?=
 =?utf-8?B?cHgyZysycEN2RmsxTENvT3B1eXAvWEtNWERMc21Rdkxnb2t4K3hWTllncjlk?=
 =?utf-8?B?cGNEZGJTU2hJTjJmTUpBMVBBcUlLUVlZUk5jZVVGdHI5RWRtenQrRDNBTHRq?=
 =?utf-8?B?S0UzTVQzQlluTzhFbmV3M0d6QVdDUm1adGhhdUxsNDh2NWd2d3FFdnV1NlY5?=
 =?utf-8?B?aUl0S3Ntb2dSVG9PT1hDdUNXUXFtVWMvcEY2R3BBZWdlOEtYTFliZGwxeEgr?=
 =?utf-8?B?L1JDaGhEdzBITytDOGx4Z0I4bGFSY3Q0cEJYektvZ1JuNW9kc2RTSjVOMDRY?=
 =?utf-8?B?NDRBS1RJQmgrbHZDT2E3VUtuenBMYXl2QTJoQUlON3Y3cXhhSDJQencreUhp?=
 =?utf-8?B?MVdhK1JZSFlOYXdlYSt6WnIwMERuNzNtTnc3YlFZWHQ0bHA2anVjN293QTU0?=
 =?utf-8?B?SklsWXR5M1AvV0ZpRVNnenkraWIwLzlCRXBtcXIxUUd1K0tKNG96dVl4Zy9Q?=
 =?utf-8?B?anpnQ09qQVVwUVJtbHlZR2ZJMFNPVnV5OUNHTjhobkZCR2paR1ZiT09KY0RO?=
 =?utf-8?B?NW92MjhFRmJIRkN3eVRPblhyMDNvZDNwbDhIc21iV2tLVWFsK2pLUXE2QXFN?=
 =?utf-8?B?K1huWTVUeVVhaHZHVEVKN1Y1R0k4bHVxL1l2WndOM3R2bjFhMlRuY3RWTWlq?=
 =?utf-8?B?MThTQnVNdFdYVTd2TlFieWgweUVocDlyVVJ6bUx4ZzBPZjU0TUZEVjU4dGJS?=
 =?utf-8?B?WURJRDhaK1lkNDQ3Nm1NVGp4N3VrYnBnaHFTMDNHUHhzVFYrVm0ycWRZYjIx?=
 =?utf-8?B?QnZYdWs3bTlyb1h6QVc5bmdQMllxa3cwTHhDdDNXdHhUNW4ybWNTRmNtRzRR?=
 =?utf-8?B?bFU5WStWNDhpNUdURFVGT25Ua0ROUUZnRmVhVUhIMXl2WDZ0Q2xjaVhKckNv?=
 =?utf-8?B?am5JTEg2c21HNWE3VVU1ckJRRFhPRFU3NFpDOTVvWG1aS1pic3JKNE0rQUhF?=
 =?utf-8?B?WE5nWTdObUhaZmZETmgyZ3hNREROcWg1YWlZUFBKSlZMTGh4WnpDZHVQbzhx?=
 =?utf-8?B?NDlSQUR6TU52NU9lYjhqTU1WUFdzTmJ5N3Y2ZC9GWFE5bWZtbXIwUERnbmdT?=
 =?utf-8?B?L1RHWXBCSXpkSFMza055YTgvVVpRWlpmanRyR0J0aWlEeGh4ZlpEVVlidDFk?=
 =?utf-8?B?RS9wdjR6K3RRTzB5dXNxRXY4YXJCaTg1WTJDQnZJM2RzeUNEOGJheHovWm9t?=
 =?utf-8?Q?F3RwjWiMatO/h1T9AM9+oS5vSfE3ZM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4442.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1UyS3VWU1lBeU1BcGU1aEFYV3dFb203UzBLalNPRlh3UWcwR1hGQmo3SjFI?=
 =?utf-8?B?bEU5Zzc5OEkybGJhSEVieWx5aFdNRWFPNUU0NG13QzdNMlhzeTgrUC9VUmhn?=
 =?utf-8?B?SGFqbkFsL3VNclRUN0crcDBldXNOUmNualpSNHY4SFFsdjVUWDM3V1Y4MlZj?=
 =?utf-8?B?eXhUam04SUhHOUNDT2NzN1N1Yk5qSmx3UWR2OVZxTUZPWml6Yk9NWGpLREt4?=
 =?utf-8?B?ekk2NWxacWxRRlhpVlZlV2R1YnFYK1hVSXZ6NGJBaDlZUTJCNGtPWkExRGFP?=
 =?utf-8?B?ODFFeDdSVE1YVXRDdUZMYVRIWkUwaFpmQjRhVGp3S00xUndKRC94emg5N0Rh?=
 =?utf-8?B?Snlzc0lwS0dRVHp0Z1JIajlVS0lvZzlyZ1hmcTJYdXJJQmd3ejNseWZ1ZEVz?=
 =?utf-8?B?QnhsOE80bitsY3pUcGR0OHRSOFpwbmM5VmFya3F1dmhvRFE4ci8zUDRrZzhn?=
 =?utf-8?B?eU04U3RFV0NyM0s5M0dJd2dvaklNTU5NZXdKaVVMY1lhOTFNWFBmSHB3YjEz?=
 =?utf-8?B?QUczSExVaGQ1bXhPNGN2YjQyQmpLRHpWY1dPYkt4MTliT0dlNFgvd0Z0MUhv?=
 =?utf-8?B?RnIxNHlHTFVtc05ISFhUZXBJclVlWFpXNnFsN2g3eDg0eHBUQ0JsMFJmNnNF?=
 =?utf-8?B?VDkzbFdjRk5TN2JSak1XNlRPSGpjSGNQNXN3dzlnZXZLL2JBQXV3cFFKTnJZ?=
 =?utf-8?B?bkJTajZDWkNiWFQvZ1pXRDNLZUw1Ui93cm5VMzNUSFh6OWY3UEpNR1VyYVNh?=
 =?utf-8?B?V2ttaXFnUmNtM1l5YWZmRlJUTU9sd0tha0xQQndTNnptVWRQQnVBUHJkdzlk?=
 =?utf-8?B?cm0zbzMxL0VZUmdPTmoxNURyR294dXBFVmtBcjRYTC8vOGxhYUpGQld2Q0NO?=
 =?utf-8?B?TGdoR1ZjRnhBRlZMZm5KZWkvZXJ6cmhxR0pvTVBYMGNEclNTOU90VkFkcnR5?=
 =?utf-8?B?QzZkSlJtVVVnS004cVlza1JEMnpzbWxuTGRlQjRkN1V3OXVqQzA1SE5DRmVF?=
 =?utf-8?B?NHgvSDdlU2E3Z3RpY2FzeHZPcDMyd0o3MkZ3d05sTFVONWtqbXNteTlsUVRs?=
 =?utf-8?B?YjRkaldtbS84bURmeGRIbFlrS3p0QWNwb09iWmFOaXYvdjB3YVpJbUdaZGJm?=
 =?utf-8?B?cDlQcmpBZE9HdEE5dW1SWm1XU0kxY05wRlNqY2VXVjk4bHVQd1hpMmg5WnIy?=
 =?utf-8?B?bW5mL3RYN1dNQVJoNmFETnFNU3VQdCtZS09sbXRxVkthamIxOU5Tb1hVamt1?=
 =?utf-8?B?aENxUXJCUGNqUHZoc1lwMThnN1V4ZzlOTXhmM01PcDFtQ0x6OEhVVW1zd1pG?=
 =?utf-8?B?ZVJuVVBpMzNMQVJWTkhFTUtINGFCM3NRWHhMbmMrN3VoQ3dDemxnelIyaXI1?=
 =?utf-8?B?aEZ3V3lGMVd0STFEVE5JZWk5RjN5azArQUNOY1lBVVZZZDJTMUFtNGRsYnJC?=
 =?utf-8?B?ZU9FZ2pRY2dORmw1bnM2Z2hBdlEyOCt3MTNlZEtEbTRuS2h1aVZlL0ZpZ1Zv?=
 =?utf-8?B?S0YzQnc0bXF6RnJ0NC9leENoSkpmQnBXdXNwL1BUY2ZBMVNEMHNLSzRBWVpx?=
 =?utf-8?B?bFhUMFJKaEpGTDFNTjF6NzZuTXlaRWIvWnFpVzFTVkl1Q20yQVB1OTRzRFBS?=
 =?utf-8?B?N0ZKZXVQemJhNyt4cVRVWTVjalJVbjJidVpBcjA0WmJoNzNHMWY0ZDBWd0Zv?=
 =?utf-8?B?TVhNWUJPRndEaUdJQXNYUmgxbndiUUNkL1g1cytCTmxGR2J4N251aHRnYlpE?=
 =?utf-8?B?S2NLcGhMSWpleTRrdllYbkhjQXdHQVJmQkdmZDJqRCtpYkQ0MjJQOTBqb3BU?=
 =?utf-8?B?bXV4MVlaZ0dHSjVaZWd2RkxEbTFCQ0xGd0Fua0pSdDFDb0hXMGVtSisxeHBO?=
 =?utf-8?B?N3B6VHowN21udHZJVStpeFFJc2lZWjlzcTJXNVlrTW1YSWZVMURGZDhkd1hI?=
 =?utf-8?B?dVJ3UUNaY1V1V1VnS2lNTHJqb1ArK2N1cHBpcFNsenFkcEZ1STU2YU9WbEhj?=
 =?utf-8?B?U09sTWFENmdvbldDUXlobzQ5azlBVGxtRUtPTzhYbHBnTGhMeE9xSk9zdjJJ?=
 =?utf-8?B?WGozRGUwRzB3dWdkbk1adFFwcGJuTkg4blpUTnJZbENSc1h4TnN5ZmNaN0du?=
 =?utf-8?Q?q6oq4IJjxeiG91oT9MV2X1/gn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D06BBDC9BAFFA44CBC3FF104FC7E1ABE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4442.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215cb786-5414-4324-d676-08dd8bd29201
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2025 12:44:26.4978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vuuV9DAAV+zbEhV+ehEqcdzq5796t2QAKC3k1LWJQcSqZiCGGoujpEeO6xm4FNWuSjUZnxx0vT5U+HOXe9e1Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7921
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTAyIGF0IDE2OjA4ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IEludHJvZHVjZSBhIHBhaXIgb2YgaGVscGVycyB0byBhbGxvY2F0ZSBhbmQgZnJlZSBt
ZW1vcnkgZm9yIGEgZ2l2ZW4gMk0NCj4gcmFuZ2UuIFRoZSByYW5nZSBpcyByZXByZXNlbnRlZCBi
eSBzdHJ1Y3QgcGFnZSBmb3IgYW55IG1lbW9yeSBpbiB0aGUNCj4gcmFuZ2UgYW5kIHRoZSBQQU1U
IG1lbW9yeSBieSBhIGxpc3Qgb2YgcGFnZXMuDQo+IA0KPiBVc2UgcGVyLTJNIHJlZmNvdW50cyB0
byBkZXRlY3Qgd2hlbiBQQU1UIG1lbW9yeSBoYXMgdG8gYmUgYWxsb2NhdGVkIGFuZA0KPiB3aGVu
IGl0IGNhbiBiZSBmcmVlZC4NCj4gDQo+IHBhbXRfbG9jayBzcGlubG9jayBzZXJpYWxpemVzIGFn
YWluc3QgcmFjZXMgYmV0d2VlbiBtdWx0aXBsZQ0KPiB0ZHhfcGFtdF9hZGQoKSBhcyB3ZWxsIGFz
IHRkeF9wYW10X2FkZCgpIHZzIHRkeF9wYW10X3B1dCgpLg0KDQpNYXliZSBlbGFib3JhdGUgYSBs
aXR0bGUgYml0IG9uIF93aHlfIHVzaW5nIHNwaW5sb2NrPw0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBLaXJpbGwgQS4gU2h1dGVtb3YgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb20+DQo+
IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggICB8ICAgMiArDQo+ICBhcmNoL3g4
Ni9rdm0vdm14L3RkeC5jICAgICAgIHwgMTIzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3RkeF9lcnJuby5oIHwgICAxICsNCj4gIDMgZmls
ZXMgY2hhbmdlZCwgMTI2IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+IGluZGV4
IDgwOTFiZjViNDNjYy4uNDI0NDljMDU0OTM4IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiBAQCAt
MTM1LDYgKzEzNSw4IEBAIHN0YXRpYyBpbmxpbmUgaW50IHRkeF9ucl9wYW10X3BhZ2VzKGNvbnN0
IHN0cnVjdCB0ZHhfc3lzX2luZm8gKnN5c2luZm8pDQo+ICAJcmV0dXJuIHN5c2luZm8tPnRkbXIu
cGFtdF80a19lbnRyeV9zaXplICogUFRSU19QRVJfUFRFIC8gUEFHRV9TSVpFOw0KPiAgfQ0KPiAg
DQo+ICthdG9taWNfdCAqdGR4X2dldF9wYW10X3JlZmNvdW50KHVuc2lnbmVkIGxvbmcgaHBhKTsN
Cj4gKw0KDQpUaGlzIGF0IGxlYXN0IG5lZWRzIHRvIGJlIGluIHRoZSBzYW1lIHBhdGNoIHdoaWNo
IGV4cG9ydHMgaXQuICBCdXQgYXMgcmVwbGllZCB0bw0KcGF0Y2ggMiwgSSB0aGluayB3ZSBzaG91
bGQganVzdCBtb3ZlIHRoZSBjb2RlIGluIHRoaXMgcGF0Y2ggdG8gVERYIGNvcmUgY29kZS4NCg0K
PiAgaW50IHRkeF9ndWVzdF9rZXlpZF9hbGxvYyh2b2lkKTsNCj4gIHUzMiB0ZHhfZ2V0X25yX2d1
ZXN0X2tleWlkcyh2b2lkKTsNCj4gIHZvaWQgdGR4X2d1ZXN0X2tleWlkX2ZyZWUodW5zaWduZWQg
aW50IGtleWlkKTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNo
L3g4Ni9rdm0vdm14L3RkeC5jDQo+IGluZGV4IGI5NTJiYzY3MzI3MS4uZWE3ZTJkOTNmYjQ0IDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2
bS92bXgvdGR4LmMNCj4gQEAgLTIwNyw2ICsyMDcsMTAgQEAgc3RhdGljIGJvb2wgdGR4X29wZXJh
bmRfYnVzeSh1NjQgZXJyKQ0KPiAgCXJldHVybiAoZXJyICYgVERYX1NFQU1DQUxMX1NUQVRVU19N
QVNLKSA9PSBURFhfT1BFUkFORF9CVVNZOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgYm9vbCB0ZHhf
aHBhX3JhbmdlX25vdF9mcmVlKHU2NCBlcnIpDQo+ICt7DQo+ICsJcmV0dXJuIChlcnIgJiBURFhf
U0VBTUNBTExfU1RBVFVTX01BU0spID09IFREWF9IUEFfUkFOR0VfTk9UX0ZSRUU7DQo+ICt9DQo+
ICANCj4gIC8qDQo+ICAgKiBBIHBlci1DUFUgbGlzdCBvZiBURCB2Q1BVcyBhc3NvY2lhdGVkIHdp
dGggYSBnaXZlbiBDUFUuDQo+IEBAIC0yNzYsNiArMjgwLDEyNSBAQCBzdGF0aWMgaW5saW5lIHZv
aWQgdGR4X2Rpc2Fzc29jaWF0ZV92cChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAJdmNwdS0+
Y3B1ID0gLTE7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBERUZJTkVfU1BJTkxPQ0socGFtdF9sb2Nr
KTsNCj4gKw0KPiArc3RhdGljIHZvaWQgdGR4X2ZyZWVfcGFtdF9wYWdlcyhzdHJ1Y3QgbGlzdF9o
ZWFkICpwYW10X3BhZ2VzKQ0KPiArew0KPiArCXN0cnVjdCBwYWdlICpwYWdlOw0KPiArDQo+ICsJ
d2hpbGUgKChwYWdlID0gbGlzdF9maXJzdF9lbnRyeV9vcl9udWxsKHBhbXRfcGFnZXMsIHN0cnVj
dCBwYWdlLCBscnUpKSkgew0KPiArCQlsaXN0X2RlbCgmcGFnZS0+bHJ1KTsNCj4gKwkJX19mcmVl
X3BhZ2UocGFnZSk7DQo+ICsJfQ0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IHRkeF9hbGxvY19w
YW10X3BhZ2VzKHN0cnVjdCBsaXN0X2hlYWQgKnBhbXRfcGFnZXMpDQo+ICt7DQo+ICsJZm9yIChp
bnQgaSA9IDA7IGkgPCB0ZHhfbnJfcGFtdF9wYWdlcyh0ZHhfc3lzaW5mbyk7IGkrKykgew0KPiAr
CQlzdHJ1Y3QgcGFnZSAqcGFnZSA9IGFsbG9jX3BhZ2UoR0ZQX0tFUk5FTCk7DQo+ICsJCWlmICgh
cGFnZSkNCj4gKwkJCWdvdG8gZmFpbDsNCj4gKwkJbGlzdF9hZGQoJnBhZ2UtPmxydSwgcGFtdF9w
YWdlcyk7DQo+ICsJfQ0KPiArCXJldHVybiAwOw0KPiArZmFpbDoNCj4gKwl0ZHhfZnJlZV9wYW10
X3BhZ2VzKHBhbXRfcGFnZXMpOw0KPiArCXJldHVybiAtRU5PTUVNOw0KPiArfQ0KPiArDQo+ICtz
dGF0aWMgaW50IHRkeF9wYW10X2FkZChhdG9taWNfdCAqcGFtdF9yZWZjb3VudCwgdW5zaWduZWQg
bG9uZyBocGEsDQo+ICsJCQlzdHJ1Y3QgbGlzdF9oZWFkICpwYW10X3BhZ2VzKQ0KPiArew0KPiAr
CXU2NCBlcnI7DQo+ICsNCj4gKwlocGEgPSBBTElHTl9ET1dOKGhwYSwgU1pfMk0pOw0KPiArDQo+
ICsJc3Bpbl9sb2NrKCZwYW10X2xvY2spOw0KDQpKdXN0IGN1cmlvdXMsIENhbiB0aGUgbG9jayBi
ZSBwZXItMk0tcmFuZ2U/DQoNCj4gKw0KPiArCS8qIExvc3QgcmFjZSB0byBvdGhlciB0ZHhfcGFt
dF9hZGQoKSAqLw0KPiArCWlmIChhdG9taWNfcmVhZChwYW10X3JlZmNvdW50KSAhPSAwKSB7DQo+
ICsJCWF0b21pY19pbmMocGFtdF9yZWZjb3VudCk7DQo+ICsJCXNwaW5fdW5sb2NrKCZwYW10X2xv
Y2spOw0KPiArCQl0ZHhfZnJlZV9wYW10X3BhZ2VzKHBhbXRfcGFnZXMpOw0KDQpJdCdzIHVuZm9y
dHVuYXRlIG11bHRpcGxlIGNhbGxlciBvZiB0ZHhfcGFtdF9hZGQoKSBuZWVkcyB0byBmaXJzdGx5
IGFsbG9jYXRlDQpQQU1UIHBhZ2VzIGJ5IHRoZSBjYWxsZXIgb3V0IG9mIHRoZSBzcGlubG9jayBh
bmQgdGhlbiBmcmVlIHRoZW0gaGVyZS4NCg0KSSBhbSB0aGlua2luZyBpZiB3ZSBtYWtlIHRkeF9w
YW10X2FkZCgpIHJldHVybjoNCg0KCSogPiAwOiBQQU1UIHBhZ2VzIGFscmVhZHkgYWRkZWQgKGFu
b3RoZXIgdGR4X3BhbXRfYWRkKCkgd29uKQ0KCSogPSAwOiBQQU1UIHBhZ2VzIGFkZGVkIHN1Y2Nl
c3NmdWxseQ0KCSogPCAwOiBlcnJvciBjb2RlDQoNCi4uIHRoZW4gd2UgYXQgbGVhc3QgY291bGQg
bW92ZSB0ZHhfZnJlZV9wYW10X3BhZ2VzKCkgdG8gdGhlIGNhbGxlciB0b28uDQoNCj4gKwkJcmV0
dXJuIDA7DQo+ICsJfQ0KPiArDQo+ICsJZXJyID0gdGRoX3BoeW1lbV9wYW10X2FkZChocGEgfCBU
RFhfUFNfMk0sIHBhbXRfcGFnZXMpOw0KPiArDQo+ICsJaWYgKGVycikNCj4gKwkJdGR4X2ZyZWVf
cGFtdF9wYWdlcyhwYW10X3BhZ2VzKTsNCg0KU2VlbXMgd2UgYXJlIGNhbGxpbmcgdGR4X2ZyZWVf
cGFtdF9wYWdlcygpIHdpdGhpbiBzcGlubG9jaywgd2hpY2ggaXMgbm90DQpjb25zaXN0ZW50IHdp
dGggYWJvdmUgd2hlbiBhbm90aGVyIHRkeF9wYW10X2FkZCgpIGhhcyB3b24gdGhlIHJhY2UuDQoN
Cj4gKw0KPiArCS8qDQo+ICsJICogdGR4X2hwYV9yYW5nZV9ub3RfZnJlZSgpIGlzIHRydWUgaWYg
Y3VycmVudCB0YXNrIHdvbiByYWNlDQo+ICsJICogYWdhaW5zdCB0ZHhfcGFtdF9wdXQoKS4NCj4g
KwkgKi8NCj4gKwlpZiAoZXJyICYmICF0ZHhfaHBhX3JhbmdlX25vdF9mcmVlKGVycikpIHsNCj4g
KwkJc3Bpbl91bmxvY2soJnBhbXRfbG9jayk7DQo+ICsJCXByX3RkeF9lcnJvcihUREhfUEhZTUVN
X1BBTVRfQURELCBlcnIpOw0KPiArCQlyZXR1cm4gLUVJTzsNCj4gKwl9DQoNCkkgaGFkIGhhcmQg
dGltZSB0byBmaWd1cmUgb3V0IHdoeSB3ZSBuZWVkIHRvIGhhbmRsZSB0ZHhfaHBhX3JhbmdlX25v
dF9mcmVlKCkNCmV4cGxpY2l0bHkuICBJSVVDLCBpdCBpcyBiZWNhdXNlIGF0b21pY19kZWNfYW5k
X3Rlc3QoKSBpcyB1c2VkIGluDQp0ZHhfcGFtdF9wdXQoKSwgaW4gd2hpY2ggY2FzZSB0aGUgYXRv
bWljX3QgY2FuIHJlYWNoIHRvIDAgb3V0c2lkZSBvZiB0aGUNCnNwaW5sb2NrIHRodXMgdGRoX3Bo
eW1lbV9wYW10X2FkZCgpIGNhbiBiZSBjYWxsZWQgd2hlbiB0aGVyZSdzIHN0aWxsIFBBTVQgcGFn
ZXMNCnBvcHVsYXRlZC4NCg0KQnV0IC4uLg0KDQo+ICsNCj4gKwlhdG9taWNfc2V0KHBhbXRfcmVm
Y291bnQsIDEpOw0KPiArCXNwaW5fdW5sb2NrKCZwYW10X2xvY2spOw0KPiArCXJldHVybiAwOw0K
PiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IHRkeF9wYW10X2dldChzdHJ1Y3QgcGFnZSAqcGFnZSkN
Cj4gK3sNCj4gKwl1bnNpZ25lZCBsb25nIGhwYSA9IHBhZ2VfdG9fcGh5cyhwYWdlKTsNCj4gKwlh
dG9taWNfdCAqcGFtdF9yZWZjb3VudDsNCj4gKwlMSVNUX0hFQUQocGFtdF9wYWdlcyk7DQo+ICsN
Cj4gKwlpZiAoIXRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQodGR4X3N5c2luZm8pKQ0KPiArCQly
ZXR1cm4gMDsNCj4gKw0KPiArCXBhbXRfcmVmY291bnQgPSB0ZHhfZ2V0X3BhbXRfcmVmY291bnQo
aHBhKTsNCj4gKwlXQVJOX09OX09OQ0UoYXRvbWljX3JlYWQocGFtdF9yZWZjb3VudCkgPCAwKTsN
Cj4gKw0KPiArCWlmIChhdG9taWNfaW5jX25vdF96ZXJvKHBhbXRfcmVmY291bnQpKQ0KPiArCQly
ZXR1cm4gMDsNCg0KLi4uIGlmIHdlIHNldCB0aGUgaW5pdGlhbCB2YWx1ZSBvZiBwYW10X3JlZmNv
dW50IHRvIC0xLCBhbmQgdXNlDQphdG9taWNfaW5jX3VubGVzc19uZWdldGl2ZSgpIGhlcmU6DQoN
CglpZiAoYXRvbWljX2luY191bmxlc3NfbmVnYXRpdmUocGFtdF9yZWZjb3VudCkpDQoJCXJldHVy
biAwOw0KDQoJaWYgKHRkeF9hbGxvY19wYW10X3BhZ2VzKCZwYW10X3BhZ2VzKSkNCgkJcmV0dXJu
IC1FTk9NRU07DQoNCglzcGluX2xvY2soJnBhbXRfbG9jayk7DQoJcmV0ID0gdGR4X3BhbXRfYWRk
KGhwYSwgJnBhbXRfcGFnZXMpOw0KCWlmIChyZXQgPj0gMCkNCgkJYXRvbWljX2luYyhwYW10X3Jl
ZmNvdW50LCAwKTsNCglzcGluX3VubG9jaygmcGFtdF9sb2NrKTsNCgkNCgkvKg0KCSAqIElmIGFu
b3RoZXIgdGR4X3BhbXRfZ2V0KCkgd29uIHRoZSByYWNlLCBvciBpbiBjYXNlIG9mDQoJICogZXJy
b3IsIFBBTVQgcGFnZXMgYXJlIG5vdCB1c2VkIGFuZCBjYW4gYmUgZnJlZWQuDQoJICovDQoJaWYg
KHJldCkNCgkJdGR4X2ZyZWVfcGFtdF9wYWdlcygmcGFtdF9wYWdlcyk7DQoNCglyZXR1cm4gcmV0
ID49IDAgPyAwIDogcmV0Ow0KDQphbmQgLi4uDQoNCj4gKw0KPiArCWlmICh0ZHhfYWxsb2NfcGFt
dF9wYWdlcygmcGFtdF9wYWdlcykpDQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiArDQo+ICsJcmV0
dXJuIHRkeF9wYW10X2FkZChwYW10X3JlZmNvdW50LCBocGEsICZwYW10X3BhZ2VzKTsNCj4gK30N
Cj4gKw0KPiArc3RhdGljIHZvaWQgdGR4X3BhbXRfcHV0KHN0cnVjdCBwYWdlICpwYWdlKQ0KPiAr
ew0KPiArCXVuc2lnbmVkIGxvbmcgaHBhID0gcGFnZV90b19waHlzKHBhZ2UpOw0KPiArCWF0b21p
Y190ICpwYW10X3JlZmNvdW50Ow0KPiArCUxJU1RfSEVBRChwYW10X3BhZ2VzKTsNCj4gKwl1NjQg
ZXJyOw0KPiArDQo+ICsJaWYgKCF0ZHhfc3VwcG9ydHNfZHluYW1pY19wYW10KHRkeF9zeXNpbmZv
KSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJaHBhID0gQUxJR05fRE9XTihocGEsIFNaXzJNKTsN
Cj4gKw0KPiArCXBhbXRfcmVmY291bnQgPSB0ZHhfZ2V0X3BhbXRfcmVmY291bnQoaHBhKTsNCj4g
KwlpZiAoIWF0b21pY19kZWNfYW5kX3Rlc3QocGFtdF9yZWZjb3VudCkpDQo+ICsJCXJldHVybjsN
Cg0KLi4uIHVzZSBhdG9taWNfZGVjX2lmX3Bvc3NpYmxlKCkgaGVyZSwgd2Ugc2hvdWxkIGJlIGFi
bGUgdG8gYXZvaWQgdGhlIHNwZWNpYWwNCmhhbmRsaW5nIG9mIHRkeF9ocGFfcmFuZ2Vfbm90X2Zy
ZWUoKSBpbiB0ZHhfcGFtdF9nZXQoKS4gIFNvbWVldGhpbmcgbGlrZToNCg0KCWlmIChhdG9taWNf
ZGVjX2lmX3Bvc2l0aXZlKHBhbXRfcmVmY291bnQpID49IDApDQoJCXJldHVybjsNCg0KCXNwaW5f
bG9jaygmcGFtdF9sb2NrKTsNCgkNCgkvKiB0ZHhfcGFtdF9nZXQoKSBjYWxsZWQgbW9yZSB0aGFu
IG9uY2UgKi8NCglpZiAoYXRvbWljX3JlYWQocGFtdF9yZWZjb3VudCkgPiAwKSB7DQoJCXNwaW5f
dW5sb2NrKCZwYW10X2xvY2spOw0KCQlyZXR1cm47DQoJfQ0KDQoJZXJyID0gdGRoX3BoeW1lbV9w
YW10X3JlbW92ZShocGEgfCBURFhfUFNfMk0sICZwYW10X3BhZ2VzKTsNCglhdG9taWNfc2V0KHBh
bXRfcmVmY291bnQsIC0xKTsNCglzcGluX3VubG9jaygmcGFtdF9sb2NrKTsNCg0KCXRkeF9mcmVl
X3BhbXRfcGFnZXMoJnBhbXRfcGFnZXMpOw0KDQpIbW0uLiBhbSBJIG1pc3NpbmcgYW55dGhpbmc/
DQoJCQkNCj4gKw0KPiArCXNwaW5fbG9jaygmcGFtdF9sb2NrKTsNCj4gKw0KPiArCS8qIExvc3Qg
cmFjZSBhZ2FpbnN0IHRkeF9wYW10X2FkZCgpPyAqLw0KPiArCWlmIChhdG9taWNfcmVhZChwYW10
X3JlZmNvdW50KSAhPSAwKSB7DQo+ICsJCXNwaW5fdW5sb2NrKCZwYW10X2xvY2spOw0KPiArCQly
ZXR1cm47DQo+ICsJfQ0KPiArDQo+ICsJZXJyID0gdGRoX3BoeW1lbV9wYW10X3JlbW92ZShocGEg
fCBURFhfUFNfMk0sICZwYW10X3BhZ2VzKTsNCj4gKwlzcGluX3VubG9jaygmcGFtdF9sb2NrKTsN
Cj4gKw0KPiArCWlmIChlcnIpIHsNCj4gKwkJcHJfdGR4X2Vycm9yKFRESF9QSFlNRU1fUEFNVF9S
RU1PVkUsIGVycik7DQo+ICsJCXJldHVybjsNCj4gKwl9DQo+ICsNCj4gKwl0ZHhfZnJlZV9wYW10
X3BhZ2VzKCZwYW10X3BhZ2VzKTsNCj4gK30NCj4gKw0KDQo=

