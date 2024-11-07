Return-Path: <kvm+bounces-31050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF199BFC4D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 03:06:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE3F91F23AE8
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 02:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA4613C3F6;
	Thu,  7 Nov 2024 02:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RXWxVvbj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF69168BD;
	Thu,  7 Nov 2024 02:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730945133; cv=fail; b=Qy7emlH7TkIoJHrFZeNOh2YWWmqFThF/u3Na8zxZDXC3g9RbuXVqpUnYk5VhSF4vd7ckbGNaMjqW3P8VhHY7/lk/FCekROLtKIUFrY/C87cebAc3JDmn++TrH6mBn5McotbxmcaPJjmp9/iZwd7ASDiV59nQtsf84VI4NITomgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730945133; c=relaxed/simple;
	bh=8L+2e63EHiyIxtGs8k4j78eCWOBkc22tQBT10lA3SCM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k5D8+eNjFhv/zoDQEs9uhzCAtwyc80OBygFGlA2JM92pBJFShKuvnNsHpRjA6poTuw9Oi6A9EshLAK6dOIp0p/vGLoIcY3644bzs7udwHGiS++25g+6B+AHyQj+xP5HQvc8w+0NGsCqn6YCf7rjcW7hEzb5yg9VTpj2U+ABWXz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RXWxVvbj; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730945132; x=1762481132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8L+2e63EHiyIxtGs8k4j78eCWOBkc22tQBT10lA3SCM=;
  b=RXWxVvbju788xZGZlik/h+Zz0ZMCqC2ZxfbPlLdzvZmq+Jd4olMS1dTx
   3grhAOFl1BF37oYUVADchTupKP+BjOW9e+7fNIc82QieYoyB7uwJOKIe0
   HxCYPnp1NA9BgKm30tusbsCJRZ9YRSLp8Mi9BzDQBPcoeIO05wz+Mo7mN
   tdRzbkSnfZC0nUfeUQUZrMw3SmDaIxBPwGrqnkWRZEJ6xI2oifapR7Obq
   02KV3ali+oP6UGkW9RkUmb6fmqFDdbQYm6wyu1qfq07DmIqeEZWt1JNtM
   QmJHNwLFK6ND2m8JFAoijngEZ0c8E0WdbgZ0/a9PitU1L9LCGdIbjQrbA
   A==;
X-CSE-ConnectionGUID: 74j975dkThSzwiyQtUCnGg==
X-CSE-MsgGUID: /jW1Wt/yTwu4pRI0l8xVTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="42149511"
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="42149511"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 18:05:31 -0800
X-CSE-ConnectionGUID: IHlBfsWMTlS487N3iXYViw==
X-CSE-MsgGUID: 0BcG/34wR2aPzooPFuH/Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,264,1725346800"; 
   d="scan'208";a="85035923"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 18:05:31 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 18:05:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 18:05:31 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 18:05:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M9nxgDdFDDxQ+QHeLp9YbfbjPmd8HnGJMJqrHSg0cUOOeZ7+wJ0L64XE45VEO4uN6zvRyFoSl+wp7aEwNwBl9Saw4wnVPKq+XfXdeqyL971cwFIyaM41/DR8TU+57bTblINycNUz6PJbzmCDAVFdTsAo8LKbsO44IThwOv2fbqKoFB1qB2OD+w51AolTtu/KB5fn9y1hW6oBWKBdfLBNU3qZp7lWYADaydzn+xxryJv91clEIE+e0Ei3sjviwzZWIE62RPuovQloCSzSpgFXnVtFiqi6a4SZ56C1MhP123Y6hyTsB8jqndSFXparHqCINAuiISLSjMLy0pnQ469gNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8L+2e63EHiyIxtGs8k4j78eCWOBkc22tQBT10lA3SCM=;
 b=y8UIO+VPhFOyV9fLOPK5TKdR4vk3e3Bfn2OqQzCIn74YEvLoMOk9F4h6YN2CYYQPUak4p9EPjQ7PpRdrdM2OnN3sBlHXBKXVJGDqpiux46actaBnnbo5VjlZQaat39KeqldUsjn8/e6eGU+TuwvIokTDnniQjENoQOheuuglimx1r6e2bWuhGB0wM4N9Vltw3ihOQDTlpQsGqIDgQo2KugOg55af5ZeQjrsN/XM0lttbZPFfAifJdihm3Hy3ISIRKxQO/miuz+smpzq2+jntqWl8KIzgQu0TvEXq+hO3aMyw456ChgUSJ1YnCaeKRJeBA1q4G/hmOruwAPIQknobmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6971.namprd11.prod.outlook.com (2603:10b6:806:2ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 02:05:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8114.028; Thu, 7 Nov 2024
 02:05:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"john.allen@amd.com" <john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
Thread-Topic: [PATCH v10 00/27] Enable CET Virtualization
Thread-Index: AQHaYwfwUq77Vfr47kSTqCeNyaqv3bGDeEgAgAbx4wCBIC/lgIAAeyGAgAAahQCAAN0fgIAAoBqA
Date: Thu, 7 Nov 2024 02:05:22 +0000
Message-ID: <548b564e8084eec9f1c0d0b7bb3dc080f1715818.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <ZjLP8jLWGOWnNnau@google.com>
	 <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
	 <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
	 <8e9f8613-7d3a-4628-9b77-b6ad226b0872@intel.com>
	 <00a94b5e31fba738b0ad7f35859d8e7b8dceada7.camel@intel.com>
	 <ZyuaE9ye3J56foBf@google.com>
In-Reply-To: <ZyuaE9ye3J56foBf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6971:EE_
x-ms-office365-filtering-correlation-id: db447655-c4ab-4839-6407-08dcfed0a35d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RHlLK0o3WXgwcUFxeGRERFFIREdVdnQ5bWN3bngvQ29adkhCWVBhNjhKc2w4?=
 =?utf-8?B?K2hpTGxIZWg0bmRhS3dlVUVPY2xXMVk4YUpySTk4QWN1ZFZkVU0wamg4aStz?=
 =?utf-8?B?MWl6WUR4NGZNdlVQU09tRmk4TTFZQi8xVkRpajloTERjRzBVU1BLZTIwS3A5?=
 =?utf-8?B?OG1aSWVURnlmWTVnME1YQ2VMWWpsRTdiSUtJMzJzbmY4R0xzdEJtdkJqSm9Q?=
 =?utf-8?B?dm43cklIblFDZjlPdURRVjdLOTU5ZjZoVDFJckdSMHlvKzdZV3ovVlpyVGQr?=
 =?utf-8?B?WjI0dFZXZ21sKzZrL21Fd084bEVIazU0TnFlWmNiSHh4VDEwb1BlUnpqZ0I0?=
 =?utf-8?B?VGt2Ujc1bXh0ZGlhbVZzLzVMbW5ESnQ0bGc2OTlNaEtYNXl5K3FSYUVTclZ2?=
 =?utf-8?B?ZHNNTmE0UDFUVThMV0lpS1dJOWMybHM1Y3FWRjM3ZW9SV2pDaWpiV3FGVWZR?=
 =?utf-8?B?RVpPVi83R3N0Rmx6VnJlcEI2LzBCc1FIVTYxRkNpVjU3K2hRa1NwT3lEMlFK?=
 =?utf-8?B?U1dNbzRmNXZGVHJyOE9sZkl0V29JN21KYmloT2xqMGRTdklMSkY5OTQ4NVEx?=
 =?utf-8?B?UjRjM0lWMzFKaDJHbDRYalRrblE3cXZ2RWRNbG5SOGxGZXdFbUZEL2tQSHB4?=
 =?utf-8?B?dUI4Um9BOTZBOWlFMjk1MUhQZmRVSG8rZXNycG1FeDlrdzJYb3V2V2ZXbVow?=
 =?utf-8?B?UVJndlp4eTdhbUlrNXFXVStRR0w4SENhelh2M0ZOZkhTSldxQWFzaHdpVHBs?=
 =?utf-8?B?MmRqbnBlbm93cFQyTjIzczFkcGJnNDgxbEwxclBTa094WUxidmJsNzEySlB0?=
 =?utf-8?B?UG8zS2tIWEZXazVaQ3lMeWc2cGdZNmFORWEvUUg1bDVDbERIcWQ5aEVISUxZ?=
 =?utf-8?B?Q0dXVWw1U1VBU09yY2RaNzlhVWd5SVNkQlJQbUszYWlLc2tjbk1iRHVabVRO?=
 =?utf-8?B?b2J3R0FzWWpWQzBBeVo2SGhkUXk5YzNxV1VDNEQrZFBFRjB0WnBlbTFiS2hC?=
 =?utf-8?B?UnloeHN0anVHdzNEbHl4RkhXV2dIbExGQUYySi9EalU1dlFJMHpMZHBzV3Ar?=
 =?utf-8?B?bWs1MFBNcE5yRkVJbWU5VktDNWZhK1dLWUxHdEpMQktFWFlyemtCRjllSXRZ?=
 =?utf-8?B?OExzZUI3UThiZGR1M2Q2dXJLUXF4dGVZTlJnbFh4WEdvVTg2bHdiMG1xNVJY?=
 =?utf-8?B?YS9SaHo4UGlSUHJOa1FhU1Jmck9abHBvZkNXaDE4NHhhYW1oN2Y4WUtWUWta?=
 =?utf-8?B?ZTQ3RWJQWG5UbXJySy9lQWlVb3hEcTBPVkdJQXpSQk4zNkhGc3lYRDZ5Q05Z?=
 =?utf-8?B?UFBLVW9yYjR2MGVMRUFNVVp1alRRRUd1bkxnMkJwdnFERkpmclhtKzdLUXpL?=
 =?utf-8?B?QktDc1AyaTY4V0MwUkNZMFYraS8wQnNlLzZBMS9rdnNybVppTWIzUVFrazRQ?=
 =?utf-8?B?YzRyZFlvalV6OXp6T3Z1eE01SEpDd2NjVUxBMS9kTU9uNDE4LzFra2txT2dI?=
 =?utf-8?B?Wmg3Y2cxL3FzMDVZeHB6OWZ0ZFN3VVc0SHU4VEcvZ051SGRDSEhqRWFRUlFH?=
 =?utf-8?B?T25JMEdwWTA0bUJOMXNNOWFncmtHWEVFck40NzA2VElZY2kySDFoRFpLeWF5?=
 =?utf-8?B?VHBZT3dJYU04dSswMkQ3WkZuN3puTmZDV0hBa3JMcHVBV1J3MW5MWEUvblBG?=
 =?utf-8?B?Q0YrdjRTWGU1aXc2VUNTdUpQOU12ZGg3TUwzRXdid0RSVUJYRFdjRTVaM2R6?=
 =?utf-8?B?TWFTek9RMXJ0ZEpCQVNWcUJsRUZ4YmJSNUt5WklqY3F3MHIxWXl3czRXWU5h?=
 =?utf-8?Q?yKjzHqKzXalAW6ACbUF7VBaTpSuh/GUYMzEPA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHc4N2ZCSWh5QmRIN2pFSmlyMyttWXc3dm9IbkVnVDdyR0x1dXR0M0pZbXlE?=
 =?utf-8?B?YkxSd0hHWDBEVEJ0TGUrVSthYWNBclVoOG45ZlQ0Q2NiaXdLM1N4TkFncnV2?=
 =?utf-8?B?dU5lS05uL3I3TU1xbnY3Y3VIK1RPZXFkeGhPeVRvM0xMbjU1WmVla1lrWGN3?=
 =?utf-8?B?K2E0bVVvUGVqWEhNaHplcnY3NUYvVDRPeWNmdm1uWS91czVnd1BKcnJOWFUr?=
 =?utf-8?B?S0kxUDg0T296TStJREtUR3JUSkZOWVhkR244ZEhnQ2J6UFZtclU5bG5MejBP?=
 =?utf-8?B?STMybU5LVjR3OWprVC9Ob2VQWGVrKzhMcXVjUlJpVmFsZmROZVR0dXgxWEZQ?=
 =?utf-8?B?M3EzR0o4UUZvMHJKR01vWWg1YzBKSkVCbVphengvemRQMlNkVjVSN3N4Kzlp?=
 =?utf-8?B?VWF3YUlxZmEwM0d5WkxjbEU5M0ZCMDluZ21ITk43dDYwb28xWElMTWY1OC9C?=
 =?utf-8?B?bXZybVNoci9KR2xtMzZONXNpYkRwTWo4TUJYSmFHbmZXaURXYWFJTkpWNnNN?=
 =?utf-8?B?cWdiWVp0cVIzdENrMDllVUlMNGt6Uktkb1h5cHFDdWJSc0laS041aVVLWDdo?=
 =?utf-8?B?WHNhRW5QbytySTZ5SG5aSG5NNU1reUFUcjE0YUIxOU4zOGlYbTA1T1dQb0FJ?=
 =?utf-8?B?bDV6cHhOUldPK0hFanJJeXEyd3RmcWcxUlloVi9lUVNSN3c4dlBtVENCTStI?=
 =?utf-8?B?dHJqYUVxOWRaWjUvN2s1Z1JISTR3QXhKUzdEL1duVUFWbjMyeUdaTmZGMEVs?=
 =?utf-8?B?d0xKc3V5QWtKaGN2S1dYVFkyblExUkZCWDhDNEpMNjg1aEJXMENEWldoR0Z2?=
 =?utf-8?B?bThHN3I2cXpqM0xKSTRaeWFZQnRjcW85djJNSTBRcno4ME03anNFbUlUTk1k?=
 =?utf-8?B?RU4vbW95KzhXR1JmSzdkcWhob0Q2d0VrOXFNWXI4aWlKSDdEeGJYOE9KZHhE?=
 =?utf-8?B?SFpkQlNaSnZJZklQTGVyZVZXTFFXRXJFWEFRazBQbDFGSmVDRTZpM0xpNkpx?=
 =?utf-8?B?V0JOUGpNanhpb3RkTUlzSEZnc1Jic2poU2RkUDVGQkgveHA5MHlReGxMSXB1?=
 =?utf-8?B?dDFObmprdXZUV3hsS0hRTjQ4WFFXOWNqMloxa3dUQW1xcFFuN0hmK2ZzSUFX?=
 =?utf-8?B?dWFqdi9veitHSlVoUWZlcnlmQldWbUpMUUdVc3hoUk9KY0NMdEFEQmJNRHdk?=
 =?utf-8?B?ekRGU2JOOHRkdmQ0amx4MEFvMDNFTVpxTWhySk5TcDFHNlFWU2lsTlJxT0pD?=
 =?utf-8?B?V1ZNVktWNFczVjE2bnZSSUg3K0c4NGF6TkhtMVZFZDZwK1l4R3VFVGtJS0tk?=
 =?utf-8?B?NStvUlgvTU5HVVBQMit6SGRVOW52NUtkaTFnbWVxWGxuYmxSYlFFL0pSVVQ2?=
 =?utf-8?B?Yy9LdWdXTUhDSVIxMTc2bVc1SU0zRTVBZWFRM3Vwd2lRSGpIbGIwcml3U0hm?=
 =?utf-8?B?TzFESVBjUmtJTGVjYmpqZnJ4T2tqRi9adlRsMFVybEhEeHUyWk5BMUVIbmhN?=
 =?utf-8?B?ZzZXN2txa2QvYTdGWVkrL3Bpa3JtclhlZjFDTFZRdkJPVldZZEtwVVZ5dGRy?=
 =?utf-8?B?QmlGMmpJVkRDZVRRRnFrbTVpY0crTU1vMVZpNys0SERtbzNWUGNnOVFrblhy?=
 =?utf-8?B?VXhBY0NocWhJM3JGUmhHQVUyc002VXhFZDBkWitBa1JiM0Q3VjRUd1RRNk5o?=
 =?utf-8?B?U3FSMW9lS3VIdTBqeTRPUXl6ZjgveFRGQTNFcDYyWUxGNkU4bkFJdC9saklr?=
 =?utf-8?B?UkUzcVI1MlY5OVpWZmpTQ3lQUHIxTWdKUFQvWFdVUmc5T2p5bncyazJtYmtk?=
 =?utf-8?B?SmVycGRqeVdjVHhvOFJJY3g2d2FiL0kwc3ZIdFUzalZhK3ZGMWVFR2NxV1hm?=
 =?utf-8?B?MUE0NDRYRUFBc3NYNHUwdmRoNjM5ZHlSV3RKUU9uZk5la2lPYUdld1lQS01j?=
 =?utf-8?B?dDZqSWFyQlVFTmxxeFNxZ01odmtHVytpTG1DT0pObU9ZY2pwUXZDNGFrcU5F?=
 =?utf-8?B?UHVtUGtjenlqemRHeVJmOGg0NGgycElxZzlYdDVCQWZucmtmbVF5Wk5yYkRO?=
 =?utf-8?B?RXZscmNseTNmak1wb3lWYU5VUFhhU1dTeGlZbXNGWHRNMUVGbzVManpPeXZB?=
 =?utf-8?B?NjNqNWFWRFMvQ2pKMkxVeC9HUkJmZ01pcHFJbGV3WUhzbE1BdmFxaDcyYUJS?=
 =?utf-8?B?aUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CEF2D011052F24DAEE204C2C4A14258@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db447655-c4ab-4839-6407-08dcfed0a35d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 02:05:22.7172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WRRMKitgnTsY01tEZ/yrDC8j8gog8PC58AsJ9JrjCfERMTamwFPwiLsHFw/aPCNkGe1htIuXhizG6LwejOlajtvbXZ42YoJCDPxNakmgA0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6971
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTA2IGF0IDA4OjMyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IA0KPiA+IE5pY2UsIHNvdW5kcyBsaWtlIGFub3RoZXIgdmVyc2lvbiAod2hpY2gg
Y291bGQgYmUgdGhlIGxhc3QpIGlzIGJhc2ljYWxseQ0KPiA+IHJlYWR5DQo+ID4gdG8gZ28uIFBs
ZWFzZSBsZXQgbWUga25vdyBpZiBpdCBnZXRzIHN0dWNrIGZvciBsYWNrIG9mIHNvbWVvbmUgdG8g
dGFrZSBpdA0KPiA+IG92ZXIuDQo+IA0KPiBPciBtZSwgaWYgSW50ZWwgY2FuJ3QgY29uanVyZSB1
cCB0aGUgcmVzb3VyY2UuwqAgSSBoYXZlIHNwZW50IHdheSwgd2F5IHRvbyBtdWNoDQo+IHRpbWUg
YW5kIGVmZm9ydCBvbiBDRVQgdmlydHVhbGl6YXRpb24gdG8gbGV0IGl0IGRpZSBvbiB0aGUgdmlu
ZSA6LSkNCg0KU291bmRzIGxpa2UgV2Vpamlhbmcgd2lsbCBoYW5kIGlmIG9mZiB0byBzb21lb25l
IGFuZCBiZSBhdmFpbGFibGUgZm9yIHF1ZXN0aW9ucy4NClNvIHNvbWVvbmUgd2lsbCBwb3N0IGEg
djExIHdpdGggYSBwcm9wZXIgdHJhbnNpdGlvbi4NCg0KV2Ugc3RpbGwgbmVlZCB0byBjb2xsZWN0
IGFuIGFjayBmcm9tIERhdmUgb24gdGhlIEZQVSBwaWVjZXMuIEknbGwgc2VlIGlmIEkgY2FuDQpy
ZXN0YXJ0IHRoYXQgaW4gdGhlIG1lYW50aW1lLg0K

