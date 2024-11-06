Return-Path: <kvm+bounces-30900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB1949BE369
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69B01283F9B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAC01DC730;
	Wed,  6 Nov 2024 10:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E/QagPqe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8AA1DA112
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 10:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887337; cv=fail; b=DJYsrsWlvxtiUUUOibmG3tbsXzkggm3pKj48nfslM4ptoh48aZ2AwNvcw6+E4eS9GAWZynuuOJRwPz7FOKvLE/pYshjj9MHd/KY2E1qxqEwmjWV93El+b5k/6BM63wir/+xRzXQtkl+dZU3B3XXEnaMG+l2mOoymYcJ5xjG4q/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887337; c=relaxed/simple;
	bh=Yumo2XhVokzakhNq2/cgX5/eMJ/GhAyn/3RaUngSACk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l3hQVtcergfE3tSgJhDMpD50dZm6/8uXTzTa6o6/CD2Xvlb5Ns1/9AmoKJ4YGRxOIStE3YbaSRbLu64CC+cjQvhyRF+BKlUsJhCIdeUu68nH8gZu2VefZo4Zoyr9/rEc7adMN2h+aRvbE5ARKSxUyXv3O8CqrMIQh8FVE8BFu7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E/QagPqe; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730887336; x=1762423336;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yumo2XhVokzakhNq2/cgX5/eMJ/GhAyn/3RaUngSACk=;
  b=E/QagPqexjZzBIXmGNh/kkDEcXQXIZkAQdPAQCRFTgab5xEF9SSvJNlq
   NGU4y/jvJ3PnleSWCtDFOY89QA/nvQCXe3VkcDaUmbZq/pPNS1YR5wCRt
   QpbCE5xdUFDFktG+HDqxPrxoz3gHIEkd0ODCEK8Ab16h+OAVuUpCpYWdh
   cdZ36l6JwGOlmb0aUjQbblme7J3m4JBqu7GHor+f1t2MHEyamEJYU/jo7
   joV0hN6hjCeolkhSBoNGX+fZWKF+wf1ksNm6zVTZYZMJIsZAttsznnC+y
   OldxDb1kZ/uYK151X8ivylR5W8+7WSWLpEhgyh9mvwiio462LZuKnip9V
   w==;
X-CSE-ConnectionGUID: ygDb1FK8SBqTk1YLHW8Tow==
X-CSE-MsgGUID: AxQ6hSMCQ86/IpvGzBlMXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="48193105"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="48193105"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:02:15 -0800
X-CSE-ConnectionGUID: r3nC/cnjQgOF9NKkStJC8A==
X-CSE-MsgGUID: 4aZQhdW1SauonWnE9+TAZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84577643"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 02:01:57 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 02:01:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 02:01:56 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 02:01:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TvseL8/AicNvZ/3LGQPLE8lyvOyuRKyPAQE+PDL1FAcQf1abQ6qFOmn1GtEPKx4qMQFakBbOswJQ1pVevw7q/FEGMhXk6kDo17dwgpODVVw+Ppn3/kgsxkNZxUg6SCOdCmDCYFgTmWAiZ5v33hMF50M2DP3s/A78hsUc9WzRzzk5e401wApi9YFKJICPM8rBINv2/HZG4OJQe3hiRt7JLTMYb7jzYM2M19/2vD+wcF8a05vy2WuARhFcYa1bfnSXNXJOnFr7wfVCOMdb1D1p37/rvelFz61cZxTM2JW1W4zwsveJ9qhYw5zrhX654s54G+dITkTXBYczSR/NeLC0mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yumo2XhVokzakhNq2/cgX5/eMJ/GhAyn/3RaUngSACk=;
 b=bqALoO69d6OC+WbE8Q9WeK03boalw32G0BSJicL0BqmPIQC6SVaomvcAIEtDEE9jgCvT8tN3sfnyJK0yswObVCjCeOIG0mFS3DvECd9Cqb2rymbuj8dNjw13027YDcXH4HKC6tmNY8DlvT6QQMVV5vBQjLOsekupzZOqpWfTzLpF0SkfCIAN9aZJY5fpgP6GWAdt34yqu46ntAMQyOgu1c5tTg953uCWKkY11FGd5pxGjIUgvpNMZYqpSa6MIPIPUi4bvgXJPkhey0KfXbE6oIKennQ8BIZW+j0gfVj20rAFBWI0lx6pZOpTlanfSAGGVbqu6zYHGDE9nJHq8xccag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7438.namprd11.prod.outlook.com (2603:10b6:806:32b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.28; Wed, 6 Nov
 2024 10:01:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 10:01:53 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 02/13] iommu/vt-d: Add a helper to flush cache for
 updating present pasid entry
Thread-Topic: [PATCH v4 02/13] iommu/vt-d: Add a helper to flush cache for
 updating present pasid entry
Thread-Index: AQHbLrwctIjgbShWBEe3vvkahqtBGLKp111AgAAbtoCAAA6R0IAABT0AgAAA4pA=
Date: Wed, 6 Nov 2024 10:01:53 +0000
Message-ID: <BN9PR11MB52760B5C45AD8D7B553404A98C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-3-yi.l.liu@intel.com>
 <BN9PR11MB5276D12FF07A6066CEAAF4308C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b6442ba7-7979-4619-8b47-87ee90792517@intel.com>
 <BN9PR11MB5276DC217F91F706C0100A738C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0edd54a4-b8ee-423c-9094-af0c841ea140@intel.com>
In-Reply-To: <0edd54a4-b8ee-423c-9094-af0c841ea140@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7438:EE_
x-ms-office365-filtering-correlation-id: a964bb13-7a64-4b5b-3f8b-08dcfe4a0a4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Rm9qNW5aQ1FRSnlXRk0rNmNmZ0RraEROOWpkWklsMElNMVBSclMvQ3lqcThK?=
 =?utf-8?B?Vks1UHNlYkVHVTBGVHQySGw4VEh6OFZwY0QyNElvdWlObFRoQWo5N0NZZTRn?=
 =?utf-8?B?aW1qaWJvRW84eUtlb1NqNjdWMmRPWGM3bW1pSGRMMGo2a2dVVXZCU1p4NXZD?=
 =?utf-8?B?ZHJ5WnI3SGpFb3JKc2M0VldzMUFvTm9iWVY1aFZOUXZub1gvQkxtbUhiQzNW?=
 =?utf-8?B?SWVCd2ZYOFRxa3BvdTN1cS9yY1phamhYa1VnRDhoaWEwNlpqNUVpallaVklp?=
 =?utf-8?B?Z1FwV1VLbDBHeFVXNllIaG4rbnl4VjRvZHI5TkJ0NTRJQmJGMEwrbENHNUxC?=
 =?utf-8?B?dnNLcUF5SC90RENIOEZhQUJvN0J6bDVsZkJ6T2tqZGhveTZmdFVzTVFHbDUz?=
 =?utf-8?B?amI1NWYrdTJ3ZXZqVGxWY0dkOGEreGt1a05vbmNiZnllWm11aDZJU1V2UEFF?=
 =?utf-8?B?WEdXV0hzUkVSNnltVytKWVFjOUYrSzY1Ui9CcVF1eTM3WitNOHk5YS90MmJS?=
 =?utf-8?B?dVBuTEp6ZWRUTm1VY29UTHlhMmVHLzhreVRPTjBxVWxtZjJUTXpueSt5anhh?=
 =?utf-8?B?QkFzU2p3K2hNOE0wNmU2N2MwYi9tQ2RFU0dYbWZCeEl0MEE1U01iaEJGTDhp?=
 =?utf-8?B?YXkwbUhUc1QrYnlRWGJYYWEzYnlMY3hOTlpkdjI5NUhtV2R4SVZ2Z2wwOXFX?=
 =?utf-8?B?dUxsVmtxN20yazM2aXl4M3l0QVZlY0kyMkdZNGpISmVlNDNqcG9aanpUdG9y?=
 =?utf-8?B?akE2R21mWmRxbWorZTdtZk5kWmdlejlSNFJMSXZIa0c4T0l3NGljK29tanhM?=
 =?utf-8?B?SG5tK0lYelBMTnZDOEgrU3NnVlhGTlI4S1RJY254RU0vWjI0VSt5NEhqWWx5?=
 =?utf-8?B?ZTk2andxWC8ySkRkRmVGSjA1TzQ1RGQyWHo3b1VldE9ESk5nS3lqRDU1anFV?=
 =?utf-8?B?WWd0Y1VPcjdaSHZUVFUzVitBdkxvWU5WWDBCSlNWZ3pBMXJQaTY5Y3pSOHo3?=
 =?utf-8?B?TTkrWHk0Nm5TRk9VM1VRSjVZVmVrQStnaEY2SHE2ZjJnekRRc2c1YTdpL3Vr?=
 =?utf-8?B?UzJSdmNkS1FSaHFUZ1NDaTRHUzhIcjI1SS91eHZqaDA3VkkvTkdFMWZpMWJa?=
 =?utf-8?B?YVBkai92YURTQ0VLN1dJaWl1K2h4VHlmSkVHdmdzcVVWWDEyd3VyREJya0Y3?=
 =?utf-8?B?a2tCWjVRUE9ZOUp1WkJNK1hGMTFzVG5YYyt5TkNRYWVqakV4cXdiUysvdVo0?=
 =?utf-8?B?R1BVS21yaGJRRC9ya2tPT3JxclFFUUNpWW5uenFQb3EyNjdEaHBwTkJRUXpP?=
 =?utf-8?B?Tnp5OFZsdk51QmJUR1RKbWhnVGxxTVgvZWIydEMvQmplTkNwU3Jhb0JkK1R1?=
 =?utf-8?B?ZWh5Rk9IK1VwWjdyR1d2N2NkZVdJVWFORDJiaFJMemVBdUpRNjEvQ2N1RHNR?=
 =?utf-8?B?RlVIcEJhU2JDZ25qbGRHUUZvSHI3UFptVHY2QjNXaDhqaHlRU2htR2NPdUdJ?=
 =?utf-8?B?N3R3Q3RHaHlpRlpyazBnNDgxV1g1UlFKaVlNOXhGL05iV256eTl5dFdoMUs5?=
 =?utf-8?B?eG0yc09mUHVTejB5TUhCbmN3Slh4WDJFWTg4WStVWTNJMlNhRjdoeUZBTXVM?=
 =?utf-8?B?WU40N0trS3RCQlVrQlNXUjd1VlAvTDFTSEVyTGpETG1tcFI2UHEzQVAwMzFF?=
 =?utf-8?B?c3J1MTdvQ3JmY29MWVNyYlpmM1gxVElQUkR1K2N5Njg1TzhNSGg0d2RIMUFZ?=
 =?utf-8?B?VnYzQXphUVRTRXUzYUloT25aRE1DNXVRWjN3bStaRzRNWlAvbjBRU0gvRExO?=
 =?utf-8?Q?5ILzCUGZmROhj+86BU7bKV3q4/wrK+A1C6+Kc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjdDOGd4Z0lYVHBGeWNoVnM0L1hNdm1HYlhnWjZMTTdNMmhRVzNtYjNTZDNz?=
 =?utf-8?B?MmxoNE5TWCtxU1N3cDFxTkdYYXJpTFRBSGsvdW1Ncy8yWEloMGFIOEFGQlNh?=
 =?utf-8?B?MXc3SGhBc3J2U3BlNEozbFpUNEJUZW56UktZV2VKQllPVUM0ellMOW9nVkpE?=
 =?utf-8?B?YjVrdk5DelpFVnNDajViWkVLeGpUNlNSQzJrNmg0eTRxUk5oVlVNK2taeGkx?=
 =?utf-8?B?b09Qa2trc0g4MlpBWkJ5RlpnSGV6U0dQbFhIaDZFOG9uY0N2TStwRlY5bzJJ?=
 =?utf-8?B?dVVQcm5aaTY1aUpTcXpDckhvN3MxSUFrVExzL09MSXE0VnFCanZ3dVAyVEhi?=
 =?utf-8?B?MHcxbk94OUsvR0V5T0YxcHdRZWx0dWloQXpDSkdGZFVGM2U1M2I5QkJ0bGZE?=
 =?utf-8?B?YW4vbHgrU0Y0anYzM3g2QzhYZXcxTmNIU3QvbHRuaHpHTVdmYW5JekpzY3Bz?=
 =?utf-8?B?bTBWOUtkZTNmb1EvS01KWjM0VzB1Y0tTWWt1bFgzeEJhdjA5YW90aFY4eHVZ?=
 =?utf-8?B?cmJoOEREU1UxUG14Ri9CdEVDSXNGRjBQNjYwL2N1TzB0ZzBHUVZSeVcyU0Z4?=
 =?utf-8?B?bVJpbVdoMGN5amZIemhPbzlPNFg5cmUwVjd1ODFMOUc1OE1LNFU2RG5adGl6?=
 =?utf-8?B?cmtCNmlPMkdKUDBDUkUxSU1aUnVFSWxRZC8yVXl5Z2s2czhVRWh1K1hLNTNW?=
 =?utf-8?B?RjV6bGFwOVFRSU9WTlBYT1E2bm11blNTSnRuZmozMDdFTElRdTdtQ1N5RGND?=
 =?utf-8?B?c09USUhFaGNhZDFoRk5ZSVNzRkdYYTNIOS9xNTFxMC9YRUZ4VDl2dldnUGZm?=
 =?utf-8?B?UUpPMS91Q2tMdVY5OU5KOExrVmlLVVBnYTI2VEsvVXhUSUp6cFkrbjQvUkMv?=
 =?utf-8?B?NVNwSjVlbDk4ZVY4SGVSRStWMXR2L01QYzVINzZhbHh5R1kyd1AwZ1JQbVU4?=
 =?utf-8?B?MWxxTERBdjgyb1lrQkhEcUs4VjdjVmIrR3hSbmF0RmEwSjI0dFF5SStKb05l?=
 =?utf-8?B?VUtxMXVoZlhVRW1NRzhRN3pWOUhsdHl1eTJZeVg0WWkzTDJwZTVFZ29oTFdI?=
 =?utf-8?B?WmdDYVMrdTNKV3Q1Sllkb0hINldhMmkzSmF0T3A4QkxUSFpXVmFOVjRqRW1x?=
 =?utf-8?B?YkRYV3ZLN1V2dGNnbTY3M2xORUpqa256eGhOQlIxZUVwb0ZiQW55NldEVDhM?=
 =?utf-8?B?ekpRdGMyQlQzVWkycTdySXNtdWRRRVBtdVRxVWdIUFVGSXNxWXV3Z0trRmFE?=
 =?utf-8?B?YnkwUzRVVVZtaVRSQVlPdUlKL245dmUybVJHOGZ2Q2VnTEFGUE92TWp5R05F?=
 =?utf-8?B?d3RtK092a0d5Q1g0Y0tXbENHM04zMS94bU9kVGUrOE0zOGtUZWdOR1FVQnRC?=
 =?utf-8?B?OUNTdlp0aVRDUG02dE5JQVppdzkrY0xUUmU5bmdvOFdBR293eHEwZVNLQks4?=
 =?utf-8?B?azZYckRkZFBTdEhOenQzdm5LbGRsNUV2TVRZZ0xkU1ZFQXk2MTloSmFMVVlk?=
 =?utf-8?B?YW1oaU5Ya0hSUkRLSEdvQjJ5YVJrTy8za281bUVHQm9iTk5HaXJTbHYwUWkz?=
 =?utf-8?B?a0t6OSt1TkY1bjc3aU5tY3BGYnJBeEVXcmE1RnNnV1VxRkliWC9HQkgvYTBV?=
 =?utf-8?B?ZjBPa0d0S1BKYjhEVGlpbXI1anBUb0loUmhKaldWOHg0MEJaZVZKblQwT0Zp?=
 =?utf-8?B?K2doSkp2QVRKaGVZZXN3ZDFPalh2ZmVwMElVcHJaM0ZuSE4weThzTGg5ZE53?=
 =?utf-8?B?NEJXK0VSV21FemlRK25OZ080S1JQVmNGMWc3a2hoNVZQMU5TMVMzOXVtSUhv?=
 =?utf-8?B?QndxNFJBSEYvN1dvVnpJQ3ZBSnRya2VwSEVqZWpQbGZqZ3ZsTzlsdFdKdDFo?=
 =?utf-8?B?N0hNa0dlUXNhMEEzS3VkMGEvZWk5bkt3aDhvTjNVSEwrNFVuZmtJLzhjMDY4?=
 =?utf-8?B?bnQ1eXZxd1lvaXY0M3BlRmMvRTVPV3NYcHc3WXppblZCNnlRR3kxUEZJNS96?=
 =?utf-8?B?eldSelNmTURkNHFiTWhvMktTL2tlL0NaUHZQRGZwRE40dG5WeStGbktBaU5h?=
 =?utf-8?B?Y1pSWlR4VVdENnQyOGRaQUs0RVdFREtmYkNLQUNIRktvTGlOTEFSMFRyOFNU?=
 =?utf-8?Q?1gkb+D1LYZRGiC2IFx6by1XAE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a964bb13-7a64-4b5b-3f8b-08dcfe4a0a4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 10:01:53.3452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bY7kOQSZg/YT6i++6T/zGmzYaJbN2ftitHC/wgVJS9+b4M0BmHpxBncHamlVFfv48xKoR8e8bN8ms/d+2kcAOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7438
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBOb3ZlbWJlciA2LCAyMDI0IDU6NTcgUE0NCj4gDQo+IE9uIDIwMjQvMTEvNiAxNzo0MCwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDYsIDIwMjQgNDo0NiBQTQ0KPiA+Pg0K
PiA+PiBPbiAyMDI0LzExLzYgMTU6MTEsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+Pj4+IEZyb206
IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+Pj4+IFNlbnQ6IE1vbmRheSwgTm92
ZW1iZXIgNCwgMjAyNCA5OjE5IFBNDQo+ID4+Pj4NCj4gPj4+PiBUaGVyZSBhcmUgbW9yZSBwYXRo
cyB0aGF0IG5lZWQgdG8gZmx1c2ggY2FjaGUgZm9yIHByZXNlbnQgcGFzaWQgZW50cnkNCj4gPj4+
PiBhZnRlciBhZGRpbmcgcGFzaWQgcmVwbGFjZW1lbnQuIEhlbmNlLCBhZGQgYSBoZWxwZXIgZm9y
IGl0LiBQZXIgdGhlDQo+ID4+Pj4gVlQtZCBzcGVjLCB0aGUgY2hhbmdlcyB0byB0aGUgZmllbGRz
IG90aGVyIHRoYW4gU1NBREUgYW5kIFAgYml0IGNhbg0KPiA+Pj4+IHNoYXJlIHRoZSBzYW1lIGNv
ZGUuIFNvIGludGVsX3Bhc2lkX3NldHVwX3BhZ2Vfc25vb3BfY29udHJvbCgpIGlzIHRoZQ0KPiA+
Pj4+IGZpcnN0IHVzZXIgb2YgdGhpcyBoZWxwZXIuDQo+ID4+Pg0KPiA+Pj4gTm8gaHcgc3BlYyB3
b3VsZCBldmVyIHRhbGsgYWJvdXQgY29kaW5nIHNoYXJpbmcgaW4gc3cgaW1wbGVtZW50YXRpb24u
DQo+ID4+DQo+ID4+IHllcywgaXQncyBqdXN0IHN3IGNob2ljZS4NCj4gPj4NCj4gPj4+IGFuZCBh
Y2NvcmRpbmcgdG8gdGhlIGZvbGxvd2luZyBjb250ZXh0IHRoZSBmYWN0IGlzIGp1c3QgdGhhdCB0
d28gZmxvd3MNCj4gPj4+IGJldHdlZW4gUklEIGFuZCBQQVNJRCBhcmUgc2ltaWxhciBzbyB5b3Ug
ZGVjaWRlIHRvIGNyZWF0ZSBhIGNvbW1vbg0KPiA+Pj4gaGVscGVyIGZvciBib3RoLg0KPiA+Pg0K
PiA+PiBJJ20gbm90IHF1aXRlIGdldHRpbmcgd2h5IFJJRCBpcyByZWxhdGVkLiBUaGlzIGlzIG9u
bHkgYWJvdXQgdGhlIGNhY2hlDQo+ID4+IGZsdXNoIHBlciBwYXNpZCBlbnRyeSB1cGRhdGluZy4N
Cj4gPg0KPiA+IHRoZSBjb21tZW50IHNheXM6DQo+ID4NCj4gPiArCSAqIC0gSWYgKHBhc2lkIGlz
IFJJRF9QQVNJRCkNCj4gPiArCSAqICAgIC0gR2xvYmFsIERldmljZS1UTEIgaW52YWxpZGF0aW9u
IHRvIGFmZmVjdGVkIGZ1bmN0aW9ucw0KPiA+ICsJICogICBFbHNlDQo+ID4gKwkgKiAgICAtIFBB
U0lELWJhc2VkIERldmljZS1UTEIgaW52YWxpZGF0aW9uICh3aXRoIFM9MSBhbmQNCj4gPiArCSAq
ICAgICAgQWRkcls2MzoxMl09MHg3RkZGRkZGRl9GRkZGRikgdG8gYWZmZWN0ZWQgZnVuY3Rpb25z
DQo+ID4NCj4gPiBzbyB0aGF0IGlzIHRoZSBvbmx5IGRpZmZlcmVuY2UgYmV0d2VlbiB0d28gaW52
YWxpZGF0aW9uIGZsb3dzPw0KPiANCj4gb2gsIHllcy4gQnV0IHRoZXJlIGFyZSBtdWx0aXBsZSBQ
QVNJRCBwYXRocyB0aGF0IG5lZWQgZmx1c2guIGUuZy4gdGhlDQo+IHBhc2lkIHRlYXJkb3duLiBI
b3dldmVyLCB0aGlzIHBhdGggY2Fubm90IHVzZSB0aGlzIGhlbHBlciBpbnRyb2R1Y2VkDQo+IGhl
cmUgYXMgaXQgbW9kaWZpZXMgdGhlIFByZXNlbnQgYml0LiBQZXIgdGFibGUgMjgsIHRoZSB0ZWFy
ZG93biBwYXRoDQo+IHNob3VsZCBjaGVjayBwZ3R0IHRvIGRlY2lkZSBiZXR3ZWVuIHBfaW90bGJf
aW52IGFuZCBpb3RsYl9pbnYuDQo+IA0KDQpUaGVuIGp1c3Qgc2F5IHRoYXQgdGhpcyBwYXRjaCBn
ZW5lcmFsaXplcyB0aGUgbG9naWMgZm9yIGZsdXNoaW5nDQpwYXNpZCBjYWNoZSB1cG9uIGNoYW5n
ZXMgdG8gYml0cyBvdGhlciB0aGFuIFNTQURFIGFuZCBQIHdoaWNoDQpyZXF1aXJlcyBhIGRpZmZl
cmVudCBmbG93IGFjY29yZGluZyB0byBWVC1kIHNwZWMNCg==

