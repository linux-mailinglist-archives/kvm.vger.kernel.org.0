Return-Path: <kvm+bounces-33131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEB19E5554
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 13:25:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9DC61883C17
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF092185A2;
	Thu,  5 Dec 2024 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b98kFFKO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CF01C3C03;
	Thu,  5 Dec 2024 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733401516; cv=fail; b=d19F6s911Yir8c4nVGoLY+8Zxa65hLGDBgLtSPxcUFazBpVUsQKSfXZeKNWLdeHiNXTEElP1xnypff079oI+CxhBV0KgFDU/eG2aUExFNPQaLIdDbMz/uPMLKQYd++vFCAEMBDT7UIo1X0d7ZUd4DRchWMOTWkvwlOhX62pUem8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733401516; c=relaxed/simple;
	bh=tn+iVz8PLXZ2afsEhmgW38yV9aHgndQRU4meFwkN/RY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u87Ka8N57paGsQlrVIcdjzRm6KguXj2N8G3OLQ6P1SNxBfoMrB4tkcK58ThSn9rT5CzjwZwZ6KzFMERfJVDYlnB1i7zDyGbBITpMUz4V1EM17vY9ZC/B5G0VDgl6zZZEIXFsHt52mkdpHsWksMOxnHKcxltgl7HSbaP92PPTlnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b98kFFKO; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733401515; x=1764937515;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tn+iVz8PLXZ2afsEhmgW38yV9aHgndQRU4meFwkN/RY=;
  b=b98kFFKOsCAyFiRvwd7lGAX4TP0YGeGufP8/+K6ObL0B2nRb9Aby1Y9B
   wXMUo3fiabv8twR7hXZGCYvJM68u4m++eHbuOcSalj97F25N3Lfpp1uV5
   7k95AD4bXZJfHQvlmUoG0IeiGfb9D1EyNEmWnHWYfcPnOB+5/r3WhTjsO
   wcY3gaPqYd/LBJNA6K/Gl1QGBvGRYNMA8kRUf5mZ1VqnXZoRABuzUeDzV
   Qfzv0iZ6XAbNje7t3+iuIFtQhDXPwEmRvltQ4ZclElwl3PqPWcQwIZtJO
   ZKDfuFnT4Xs/85/vw8i7T0pMsYjQzknwmBxFWB8YhDWoAi3AOi9JwPzG5
   w==;
X-CSE-ConnectionGUID: EmWojSLSTyimXxt+ASPM2g==
X-CSE-MsgGUID: 79guEusZTm+2K0Mzg8agEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="33628210"
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="33628210"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 04:25:14 -0800
X-CSE-ConnectionGUID: z1WvABO+SISeAkdg1gdSMA==
X-CSE-MsgGUID: BO4KSWyZTv2hHOK3RzOXyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="94519962"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2024 04:25:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Dec 2024 04:25:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Dec 2024 04:25:13 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Dec 2024 04:25:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0+3kHwxSXDPWQ84Un+eprwGXPbZ+3PTyGSQpZjnriqXlqRhHlbIw4qm52+tNqOYOmI+k5Jblu7ZH/VAYYTrjoF3o5NubOvUEMXNglrmrWXrfGO6aRaRmRIApiKR5dH7JcyZkvO+Zj50eYvitV7Hc7FsuGWrWl7Ny0BhlGh29UR9J5Cxeafml4WIAeK8PF0/4WOIriUB4na6/xQ9PyZrPc+kbLm1UK93gKAZEg337pg5Fm4KL9yBkVZf7b8RKAvWLZTX6Y/ZKoK5TOs2LHX5b82XiA+ewekXcdHMcGRXHoW0Zu1bgRpAgnXXQZWxo79EEhQAPah4MQ2dArR3f4ZRtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tn+iVz8PLXZ2afsEhmgW38yV9aHgndQRU4meFwkN/RY=;
 b=ggHddeCAEJvEjqgB6m5o/RCeILDy8c6XBZ/NzpEf6OpXfHP3qjkCmlRwTs+Q308MuP8g3cwRbW70WK7OudEXtv1YTmm7FAxnC2STL+4NBuqARuA2di1WrnLE3SytISgTz1dr49I1Qcn1UIUOUlSbMmyl9tMFTIjfX96fSGlgGLeF06BuAJwfSE3TnwRPkxXDqPQ9S01wn55NFQGiU7dd0fwFHRQxzuWdos0WhULN6W9XPvWB4svLpuw7Eh6gy4JvveA4H5cnRsqV01nTe9gfVBmwkCqjQhoAp7jXEAM8Zv5xw5Ygd8yWCIoAwqFIoSkcAOF4Gxtqiy3bWVq46nMD7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6781.namprd11.prod.outlook.com (2603:10b6:806:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Thu, 5 Dec
 2024 12:25:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 12:25:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>, "rppt@kernel.org"
	<rppt@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "Luck, Tony"
	<tony.luck@intel.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"rafael@kernel.org" <rafael@kernel.org>, "Brown, Len" <len.brown@intel.com>,
	"ying.huang@intel.com" <ying.huang@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 08/23] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v15 08/23] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHbRut0nrPrDfQeVUKUffdkssdSU7LXXAuAgAA3hQA=
Date: Thu, 5 Dec 2024 12:25:10 +0000
Message-ID: <2f869946fc0ab5b03d53598b252b79be50a6d0ed.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <87e19d1931e33bfaece5b79602cfbd517df891f1.1699527082.git.kai.huang@intel.com>
	 <Z1Fc8g47vfpz9EVW@kernel.org>
	 <62539c75-8f4e-4e12-bcb4-55c46cdf646d@suse.com>
In-Reply-To: <62539c75-8f4e-4e12-bcb4-55c46cdf646d@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6781:EE_
x-ms-office365-filtering-correlation-id: dd92404c-96b5-4f76-d85a-08dd1527dc76
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dWQ4U2RxWTlxUDZiVEJPYS9idEUrdTJzRXpMT3JCT0hKRWp3WUtyWUZUb0hK?=
 =?utf-8?B?dmZVOEZlZXdjWVh0K1NGV2REUTJNdTJDT0M3cEcyQVdtM29DOFdOaHAxb1lz?=
 =?utf-8?B?emc3bXpaUzhwc3Ridnc1ZGRtMm9STU0rU1pEV2tOM0tCNjN5eG42NVlORjN5?=
 =?utf-8?B?Ykl5RUFJMFZKOWd5SGluK3AyQWZURFZMcWJoSDB3eVpmUjRKek5jcFlmTVV3?=
 =?utf-8?B?SGlLdk1meSsyK0w4S3VPOU10L2MxaklzOWJicjBFYW5XenZrK2duYWlrRHZK?=
 =?utf-8?B?c2o0ZFJ2VXhaUm44b0FLaHZRS3J1Qk9UMjV2bEpzOXBLRGpCTndUMFRlZXl6?=
 =?utf-8?B?TThBZ1ppSjNFN0ZsM2wyVUxaSWN4cUNlUVhsMElwUnBSL0FLb1EvUW82LytJ?=
 =?utf-8?B?NVNLRGxvejRJOTFmZzJ6UndzcVJYekxNVytNU2F5MTUwYXhaQWVXS0I0Qm1k?=
 =?utf-8?B?Zy8zQ2FWMlBuOGRnRnZQYUJHREsxVy9XZWc2TDM1TGtXV0ZYcEtHbUVZYk5i?=
 =?utf-8?B?V2ZVNUM3bktkbHgyQ20vL09qcHdSTHFia1Z6QTdSUXI3V2RTdWhzZVArNExQ?=
 =?utf-8?B?SW54LzloR3ZtWFdVVG1uOW0zWXQzMmp1YzJFbU9Jejc5U3pEaVNlTWM3OStD?=
 =?utf-8?B?ZkpFczQ5K25hd3hpaGswWkJLMXgrU0o1Zk1pUmNYNHdRQVNoNVBTa1dUKzkx?=
 =?utf-8?B?d2hEaWljNmErYjlqbmI1SkE1OUlJZy9pT1VSc1dmRzhUaW9qajRuU0o3dDRo?=
 =?utf-8?B?aFo5UU5YaWFoaTcwVy9nMWpXVWMyb0EzZzE4aXhSTWtrMUpvYWc5cUlVRnRu?=
 =?utf-8?B?UkdaaWxiN0ZxLzVvZkFqME5NNUIrL2xkM1VMdW9HZHJjM3c0SGp2aUU4Q1pl?=
 =?utf-8?B?TnFKUzVIajk3TGE2VkdnaHNVczhJdFZhRVZvTCtpYW9YdjZUdVprRHBaZ2VB?=
 =?utf-8?B?MkxFRlphQ2JwTFVsNmpQaWQ0TW9wejF1QlFQdVJScm1OMGpIL2pERGhINklN?=
 =?utf-8?B?R3BaR3BRb3RhMHFwZEh0Mms3RGJMTEYzcHNjcCtabHZmUmI3QTRmUkRRbXRr?=
 =?utf-8?B?ckI5N0hQTkJxNUg5ci8vVTN3VUs2ZFZhRkt3cENWZVF3dkJOYmFQS281cktC?=
 =?utf-8?B?OWcrRDJ1TStsMDNOTzliQzVTUFppeGUvdEpGQ1Bua0JxTDVkQ2FnZi84K2Nk?=
 =?utf-8?B?OXZpa2Y4WkIvMSs0TXg2WXJud1doNmUvc1JESDIzeTV3RDg5d1NybTJ3UWUr?=
 =?utf-8?B?YzdaQUlpSGtOdzhMd2Z6dWl6QzJrWUhxWk05emR0aTRXMGJZejlKcTBudjJP?=
 =?utf-8?B?TDBzVUJ4SHZETks5QmtWT0ZRcVJJbXdpcUc1UkdTV0IzVUZqenFyV2pzZnYy?=
 =?utf-8?B?NDlaQU5JMFRMaDhiYWI5aVY2anZ1azhMdHNLYVpkQWtvSkpuVDNzcCtibmth?=
 =?utf-8?B?VVdIa3MyWWh0Q2lyazZ1a2R1YXBKcnFFZWU2REdmdEFEemtsN0pCM3N4OU9O?=
 =?utf-8?B?ZTdCbEZUNFdNWkRXT2h1NjJ6UDErK09BK25QcDFzR21idm13eEU2MFRIcnBU?=
 =?utf-8?B?UXR6VVNJOHNxZUZ3UldxNVN6ZTRGQSt5NVRjMTM3Und3R05CVDY1cXRia3Ro?=
 =?utf-8?B?UTBFZytQUm1WeFk0MTVVTElHMDNvb3hHUDExRTdIelZtSjhHMzJvT3lYVmwr?=
 =?utf-8?B?cXRqRmx5cEJNQWFrdjg1djFRUmhoZ0Z2QmJEY2h4a214N1lISHM0dEk5S291?=
 =?utf-8?B?UWRYY0c4TFZCamFMNUROc1FjNXR6V2UwYjhkNitHVzZ4UGlWd2U5amxqMHh0?=
 =?utf-8?B?VjRUTURxR3pJMjE1Yi9GQ0xrQXltUW84ajBSdmhncVFxS05PZHRITDdsMDhQ?=
 =?utf-8?B?bUM0REYyaHkxWktua3oyODRkVVBRTmpSMU4rbk9RT0ZkRXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVNtdWNQeko2bWlESk8xNXVLZGk1anZwYUpKd2pacVVpSlUvbTYvVCt3UXNr?=
 =?utf-8?B?UWRscnNweVZEN3d3OHltRTFQQkQ5WWFXS1hSdklwdytJbFp2bVVobGNMZFBH?=
 =?utf-8?B?SHhoVXlaWU8wZ0lFbGkzNUF1UEU4YUlUODRoM1h2RlRnRWpiaWJtdCtqNGp3?=
 =?utf-8?B?Zm9UZTBkYkxDLzFoVjFTdStEZmk4UEFoZ2Rkek51d2JCZEdjd2ZOYjBhemN4?=
 =?utf-8?B?MDlZZGowTnRYcUdOWCs4TDIyOU16bFZHM2pRRGtrdVdoMFI0SzArbjdrMTFU?=
 =?utf-8?B?L3l6aU93VitscGJsYk5BRHI3NndrNC83bytrSjFpZjNwYVkzZTgvMXZTd2Jx?=
 =?utf-8?B?NElKaUdaSm10cUkrOTJxVk84MjIzeUlBYkhpMlBJbng5ZzZmZFNYZDl0ZXlo?=
 =?utf-8?B?Yjk4NkU3WHBYd202d21naFdWSDMvS0RTdlpTckh6K1ppNGYvRUY0YkRIWit0?=
 =?utf-8?B?cGVEY3UvSXBvdXZWeWgxa1BKTWhaVlRjSlJEbzZkUENieElkMTJxR3RyNFVl?=
 =?utf-8?B?SzNpMFI2aGRIL1pYcUlZTE9uZE54UDZ0aTRjbWNzb3RsNlFlbW93cGJMc2d4?=
 =?utf-8?B?cHpqeHV6a2pnbTRiSzBEdlRSbUUvdFR0emFPenN5RDRsSEVLTUw1YlFpOGh2?=
 =?utf-8?B?OHFoQkdsc28xOHRRUSszMlNxWHJUTzFDbzk1K3FKMThmWVh0bVJleFcrMkdS?=
 =?utf-8?B?TU9KclY5U0phOVBKbDZsUkF4UmdRanUwSXNMKzkxK0kwcmd1MFh5dm9sZFJl?=
 =?utf-8?B?VXEyejNnLzBhc25pRytIZkhpT1l1c3lWQ3NmYTN5dHhKWGxRRXhTT3lpZTd4?=
 =?utf-8?B?a0gyNGxDOXk3ZGxFSSt1OFZVbnRzUkhDb3UyV1JLWGNrbWdzTk4wcm1ZQ3By?=
 =?utf-8?B?THF5MllnSjl2Y0xwdWUySHgweVJMZVoxQVFkcmI0WldLRUJma04zWWp1UVNu?=
 =?utf-8?B?Q0RyTmg4SGE4VTJZUG1iVm5MM0JEUXg5aHlSRWREbGtnaVpGV3VvWHc0NFl3?=
 =?utf-8?B?Y1o0bUFhWGVQUVVlYm4wd1JucTlEZ2R3YnlhRktzY3UrUjNIc0Y0N3V3cUI2?=
 =?utf-8?B?VGFLVVE4ZWRwekFWV2E2cUo3TVNoQ016dEd5ZXpiSUpDSDBRK3NXSlhHQkw1?=
 =?utf-8?B?Q0xGV1BmQVVTWWtJVUVLMHRRL01GYnlmM2ZTa3dIUWtqYWJCRkpwZk03a2dv?=
 =?utf-8?B?MXkwN0NqdVdZLzRJM2U0WTViN0N5cmFlVlFVL3ZDbUlJS2dPeXE4SUFlVHpM?=
 =?utf-8?B?aTVpTG5RRHd5bk5YTmxNNDFqM0ZWWUZjd3hnYThOZ3NQNnBiZ0dpbHdJTk9Q?=
 =?utf-8?B?d1cwWkoxL29pc2E5T0JqSVZoM0ZCSDc3VjNZbmx3N2dTdjA4cUZYYkVCQzNo?=
 =?utf-8?B?ZmpUWVphKytRWXN6dXdDcStvdWxPZmdpU1JBOGVVWG42R05WYStJaDQvUHlo?=
 =?utf-8?B?bFAwQU9jTlcyRzRQT2dFMDFCWDNmOVdsQnozaFJ2U05NZWV4dEZmWW1ISEts?=
 =?utf-8?B?YXRJV1NFT2d2dFhUdUF3STV4cEczTGJ6d3hsUFlqVThzN2tHZG90WmpWejJ0?=
 =?utf-8?B?U1RYK3dyVGhtSm1Ed2o0QjB3M0JFU0YyNmZ0RFg2c2lYOEU4RzgrZGhaY0dY?=
 =?utf-8?B?VjQ1aDdvVHFqRnNLb0JvTm1tSWt3blRidXNXcVUveHZvdnJFVjQ1MmRRbkha?=
 =?utf-8?B?WjIxcnFGb3orVlA5cGNWajRrVzZYaVkvVnl5eHdXMW1zM2kzQ1YzN1AxVmVx?=
 =?utf-8?B?czd0UlNoOHU3UE9hSWpicUo0SEtSc2twVnlORXBVUk4yR09ESXdudUFkMWRl?=
 =?utf-8?B?Y21pM3RnRG1hYjArb3NPMlBXakhRd20ramkvOFdNQ0JrSmJhK1JYOU5WQ0V2?=
 =?utf-8?B?azBJRm5hRTNCbFM3UHFuYXlWT1lheVBhU3RTak84eUdnVW9KUlFVelliOEpT?=
 =?utf-8?B?akozWE54bXBJYkkyTk5YNzRWUm1wNE1uaU01MURYRUNVa0o2TGIzb09iMEtW?=
 =?utf-8?B?MGxkQ0FJVmFKZDlrb3lRL3dKV1RBekR5d3BEekxZTWVDd3I4S2lIek9qdkRr?=
 =?utf-8?B?OE4rMHRuR3BFUVd6M2VQSkRlcHZpczNpTGJ1OFFTaVBjZ2JqdHVMRkNLTlhq?=
 =?utf-8?Q?q5xZYN7tJfBRaAOrmBSdcs2Zn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5571D7ECAE371D4083D8D86996FED61F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd92404c-96b5-4f76-d85a-08dd1527dc76
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2024 12:25:10.2930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M4PK+0fLdr7QbskuKvodG7PKhit1D407bp/nHFWKqKsZeem/sKTQZS/cnrbQDM7SsbBNjejvwvMEdaEyLnrcJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6781
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTEyLTA1IGF0IDExOjA2ICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gPiArLyoNCj4gPiA+ICsgKiBFbnN1cmUgdGhhdCBhbGwgbWVtYmxvY2sgbWVtb3J5IHJl
Z2lvbnMgYXJlIGNvbnZlcnRpYmxlIHRvIFREWA0KPiA+ID4gKyAqIG1lbW9yeS7CoCBPbmNlIHRo
aXMgaGFzIGJlZW4gZXN0YWJsaXNoZWQsIHN0YXNoIHRoZSBtZW1ibG9jaw0KPiA+ID4gKyAqIHJh
bmdlcyBvZmYgaW4gYSBzZWNvbmRhcnkgc3RydWN0dXJlIGJlY2F1c2UgbWVtYmxvY2sgaXMgbW9k
aWZpZWQNCj4gPiA+ICsgKiBpbiBtZW1vcnkgaG90cGx1ZyB3aGlsZSBURFggbWVtb3J5IHJlZ2lv
bnMgYXJlIGZpeGVkLg0KPiA+ID4gKyAqLw0KPiA+ID4gK3N0YXRpYyBpbnQgYnVpbGRfdGR4X21l
bWxpc3Qoc3RydWN0IGxpc3RfaGVhZCAqdG1iX2xpc3QpDQo+ID4gPiArew0KPiA+ID4gKwl1bnNp
Z25lZCBsb25nIHN0YXJ0X3BmbiwgZW5kX3BmbjsNCj4gPiA+ICsJaW50IGksIHJldDsNCj4gPiA+
ICsNCj4gPiA+ICsJZm9yX2VhY2hfbWVtX3Bmbl9yYW5nZShpLCBNQVhfTlVNTk9ERVMsICZzdGFy
dF9wZm4sICZlbmRfcGZuLCBOVUxMKSB7DQo+ID4gDQo+ID4gVW5sZXMgQVJDSF9LRUVQX01FTUJM
T0NLIGlzIGRlZmluZWQgdGhpcyB3b24ndCB3b3JrIGFmdGVyIGZyZWVfaW5pdG1lbSgpDQo+IA0K
PiBURFhfSE9TVCBhY3R1YWxseSBzZWxlY3RzIEFSQ0hfS0VFUF9NRU1CTE9DSzoNCj4gDQoNClll
cy4gIFRoYW5rcyBOaWtvbGF5IGZvciByZXBseS4gIFNvbWVob3cgSSBtaXNzZWQgdGhpcyBvbmUg
eWVzdGVyZGF5Lg0K

