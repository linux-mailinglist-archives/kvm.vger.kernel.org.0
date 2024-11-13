Return-Path: <kvm+bounces-31808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D602E9C7D87
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50C921F23A1C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCD41C9DC9;
	Wed, 13 Nov 2024 21:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PSC4VUiP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A6C1C8FC2;
	Wed, 13 Nov 2024 21:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731532690; cv=fail; b=udX55+8QH84w8+QEQcS4+DPua/9J/8FJkMdBNpp5ZGSE4iqMb/ApnN+k2Np9zW9Wu2GW1AjQxgv0ISb5FYXL5L50Z+GAaCU308G7cs+ZN0kwLUfyx954NWikznlS6eWZzVCTqFSOzW04/H/ebIEc43uDxAb6gP5Iri52vJ3VHao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731532690; c=relaxed/simple;
	bh=OT2IePtizdPQH2E4NQpCfYdNF2GxWl/pIlWvpqx6GXc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H+mVrDi471/DEtKZKpJTPNkpgSDWQEFfZN5CivEcDPnYBG4hxzs06SnA3xH70/Z5qTjHdvbe91zERjvfElsZAe7PkK/Td4LYNTED11tveJgaGoBiTAubK7oN8dSUrF3Z6y3L5I36sHnvb5LFXy+YG1XHZ3ktgOJMANl13MgHYG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PSC4VUiP; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731532689; x=1763068689;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OT2IePtizdPQH2E4NQpCfYdNF2GxWl/pIlWvpqx6GXc=;
  b=PSC4VUiPVkxIjt5tea2GzPDEO5OvtYUCYi/+2gAW229rY+M6jl113M0m
   B26yz3iJdkEHh6FyI8SGiLKtycehYFTgSE9MpXkcSbHF/RukWbe8gKEDq
   mWY5HmPQyVrPdKebgUX+O1yv6tlLLg8ZXBKobpi/h9Q3WWpWNavb44Y9c
   iBNLpglnCgwVdpW46+80O3F7wM7oylDJ0f0qFzqQgHlwz+tcpHRViRTn3
   mhZLTX8JksH4cNg3UTU4or9N26qkB7pjwHezkoQ7ZV4p68YBykJo25NlZ
   4WUsy89Q9d0xR28EsnYtx/MY6oRjCfFLq1cq8mRZqGrK82I7RM9tPLzvy
   A==;
X-CSE-ConnectionGUID: r+Z/ypsJQeqQVfnpPTxXQA==
X-CSE-MsgGUID: t/l5y27aTeipIozVkWrFPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="35156279"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="35156279"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 13:18:08 -0800
X-CSE-ConnectionGUID: grzPGoEvQv6JiRnAyOq3hA==
X-CSE-MsgGUID: 71zZ/LHgRIS7Qm2zUzhbfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="88099777"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 13:18:08 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 13:18:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 13:18:07 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 13:18:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YsFjCpFT5ln6nmfhdDLz06DcvVJWKImoiIqbKdDi376tuIbIAbhSQX1lUoXEBecAzDOlhd114rVqMHyirjDdE2615+Q2kdv1Rb5Ym2bRGBIiAPjnc7eP7o+pl8oxWvRBCHW8UTYR5ua2nTm0qJ5YNBghrY0cztS4flzCU/EDBK0HEcl/bJnhNmPLl7E1CC4QbFpevjNoPrM5lUYmbBmn3G2rI6YRCc+ElRb08cpQQLZ8vPXF8DVV78ayqa3lE9dXRgmw9sCHRQQHCc5gavmFE+b/JrCilOPXKbImwMHC1F83LCPuHzSSbLvMQYkTLPoKglrDvDdJ/clkSqTQ0JrFZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OT2IePtizdPQH2E4NQpCfYdNF2GxWl/pIlWvpqx6GXc=;
 b=yGeE8fDrAWZkedjzqsh4VgmyaZhbpsedVyf6I/9vz5hS9O+5OISpYFLF/lusozWkwU7d0OGvaEcs9whfJ0du7x+uAsK4H82XeFZa/nbIHhs5FrnHV5t00YrDuvdLL8a8nma3iNMZhxrzy0xmISX59MnOHQZNrMtD1nRs9w/J1o5zqx7+ZPTDeVzzXhyCzv3Y6EAt66ZuNz1dfrzU2FFzDBjH+ToQn0EAswQiv69F8D9DYYsji0HsMAns/q++FWUw9ybr0ACJhB/ZFCY7HZc1h85XBh4LWGjXOAydZhSEkC56ZetZUrglJLZVWxAmDl3mlMDeJGB8ApESTekpdIXkAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by DS0PR11MB8070.namprd11.prod.outlook.com (2603:10b6:8:12d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 21:18:04 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%6]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 21:18:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yao,
 Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 10/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 flush operations
Thread-Topic: [PATCH v2 10/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 flush operations
Thread-Index: AQHbKv4/8rncF8VelU6Hco9BT4aHk7K0e+6AgAFRIYA=
Date: Wed, 13 Nov 2024 21:18:03 +0000
Message-ID: <966fcd7dc3b298935b4aa9b476d712eefa9fabbf.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-11-rick.p.edgecombe@intel.com>
	 <977e362f-bd0b-4653-8d47-c369b71c7dda@intel.com>
In-Reply-To: <977e362f-bd0b-4653-8d47-c369b71c7dda@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|DS0PR11MB8070:EE_
x-ms-office365-filtering-correlation-id: c08281c9-0f0f-493e-d337-08dd0428a92a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZmlmT3J0V3RTTThwL1RjVDRmd0NiQTlQMmkvL2VKQUVPcnBPeHNIUFRaWXhS?=
 =?utf-8?B?QW9ySUhpRG9QUGQ1TTBHMFlaR2lhWklCTHZIYllWSS92cEEvMWYwL25hb3hy?=
 =?utf-8?B?aVAwVUtycllGOVFMblhhNGtScm1SVHlUM2gwOGFUY1ZORUVWSWlJdW9hQ25l?=
 =?utf-8?B?RENDaE1qbCtiK2dGU1NGMkNVWUt6R2F3Q3kxQUpQeTdLT24xOElzUlZNSUhJ?=
 =?utf-8?B?OGVrNXlYeEhWQmJEamppMWFxeFg3N29zWXdKeDlrYXNRMERIZkY5UW42Szlh?=
 =?utf-8?B?aWtIQ25NcEYzeG1WSm90SVR2eWQ3RFdoSThoRkFLZGhXUUxKdVBadVNqc2h6?=
 =?utf-8?B?QXNlRjI1dDJ6bmhPU0NtWGRGaEpCUi9qRERiMFZraFJmam80bnYyUHNrb0E2?=
 =?utf-8?B?Z21ZMUJIenRHSWRFQjliYXU2VUxjMitWRmUzWW96NkFaS0E2ZWJpZ0twb0tY?=
 =?utf-8?B?YTJLLzhXUDA1NGlYakFNZnRXL0hYNkUyV0VlRFZyZlhKRlJyRlI5SlVtV1NQ?=
 =?utf-8?B?UTl4aHBVYkRJazFpTDVlSkpaVmdObHdGZDJ4T00wUHpEVmhoWjdCSWNZMUlw?=
 =?utf-8?B?WCsyTEZRYlJhSlJqd0JrN3FaQy8yVU1zY2pETm9pQ1cyWm9ac1cvbmhNOTl0?=
 =?utf-8?B?SlV3d2YyODN3dkJHaVFCRmh1SWl0bi9mU2dNZCt6R3hGcUw4U0NMTWU0dXZX?=
 =?utf-8?B?bjJuR1B3cGxqV2Fkak9XRnFROGZrbjRLdXlOQUpJVzFnMjlDOXNVdUYvbXJO?=
 =?utf-8?B?VG1wY2hnNVU2YTNIZzhDRVFZTVNvYW5SelZiWFNTcEVjYmIxTjB6ZlpWZU9j?=
 =?utf-8?B?aTN3Zkkyb05RUDg1MEY0ekhDK2hQRFNwMW9NM3ErZ05yZCsrdGV3TVo0V3lX?=
 =?utf-8?B?QlR6K2pTczhQTksvN2xvRmlDYzdVNUU2cTl5Y3ZVRC8zbUM3alF3THBhYWhN?=
 =?utf-8?B?d2Jld1NIZ1g4REpCSlZOb25XaURlL0RxSGlrcjJoL3IvRDBac0tHUGNrR2gy?=
 =?utf-8?B?NXJERFNmZ2x2NmU1cCtMdWFVK1FzQlY3ZUgyVVpiSmhpd2JDVEh6cmJYRE5l?=
 =?utf-8?B?MDVkbDNLZmVTZUtuMk1qOWNEaHl5dHFWK01odC9YclkybURkOHBybm1yRG9L?=
 =?utf-8?B?THR6UDFwNXN5WlQvcTBjbEJyTkdjYkt3TVBMZmZTWktlc1NuTGMxQWY3Ulg0?=
 =?utf-8?B?WTVNcHh5cEhGUmVYM1RNcnB3U2hnMUh1NncvdE9URm01d1lVTEdjUm9MT1lH?=
 =?utf-8?B?LzBZZE9OdEVLUXdHRmVXODRhQUpEMGd4VWphOEJYaERobGkwTy9jendYbkEv?=
 =?utf-8?B?ZjF1K04zVnhQa1daUUxYTTBsYWdKNDUybi9GWVlxdWxYTHpNVWl2d09VaTUr?=
 =?utf-8?B?MnV2V0RBbGU4T2xGVFhPT29GckV5dnA4QUdvOFBJRXZrQzltSUVUTUpsRFB5?=
 =?utf-8?B?V1QwbHZZaDB2NWFmbzNPbGJZeUZueE9wcDJIZDl0TTN2NzB5d2JzZEwxOUwv?=
 =?utf-8?B?Ym5MaktaN3RBbkY1bGppdVA3UTNVRHlqWU1XL0Z3UlFpeElDVVU3WU9XVThY?=
 =?utf-8?B?Z2I4bGdzc0lPei9aRi9Ub1JQQ1BKZll0VHA5Qk1JTmI0dFNvMzNKcWY4Vkl4?=
 =?utf-8?B?cmZuTDV1b3M4RlF2M1ZRa29TRDV3N3ZJN1pmcmZhYjE4SEFDcStrY21ZeXoy?=
 =?utf-8?B?cHAwbmNackF6MzM0akhkd2lnUWxuUy9IZHB1cHVoUXNsSWRUaWNZYzc4c2V0?=
 =?utf-8?B?WFJjWWJFR1ZzclBrNHNGeGVMQ1paS1JIaWREd1hNemZESzc1bmpKQ0U4Q0xp?=
 =?utf-8?Q?3PVbrlJst1huGh6/nPOA6Sr6c3x7Q+DeAV4lo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0d2Y3NneVVIVGpPVG53MHhyT0hPbXZPVDBndGF1Y2txSGNscG5PbVpISmlN?=
 =?utf-8?B?TWFlM3hqVjdTK0hUTTZVeXZjNkllcVBFU3lVdXVTMk5KMUlvbTVqTnVDc1dX?=
 =?utf-8?B?Q3RFRjlqNkpEK3lxUE45ZzNwSi9pZUpOaDM2dnhYYlcrdmw0LytRZVFSZE13?=
 =?utf-8?B?Z01PTEsvME9LNWUvdktsTzB3T0NHVHFrWkt3Y0MybkN4Smk1TWZtSHhFdXZh?=
 =?utf-8?B?a2ZUa3lSaDUwdU82YTFOelA3cTNwdnJTYkcwdHhZa0R1MFU4ZTRobERpZFNC?=
 =?utf-8?B?bzdQZGdnMlRhWnZTdE8wZzdpdmdDZzVNREFLV3IzVE04SDBrT2ErOHo1T3pl?=
 =?utf-8?B?N1dpWS83VEY2eU5vTDJCRzVqZkFrejBaWGxGQnhyY2JvcXJZNi9jWlo4SzZW?=
 =?utf-8?B?UHN5VWpQMnhjUVlkOUVHZ3dwUlVLRWhkS3B6ZkNKQStZNUJNTldFTHh4RDVp?=
 =?utf-8?B?THpaZ3hOd2g4amFCSGNsNlhBTjIySXBNVW1LTUJuaEsxZjQ3bkp6VHllNDdP?=
 =?utf-8?B?aXRqR2tuNXJjQm51SjkvaE5iVEFJMlVHK2xwV3ByU0ZXQXl1d2pEelZXL0Ew?=
 =?utf-8?B?MUc5bFZpY1FwOWx6T09JWmlGMndjc3dJQXhJcjdobE5xOUZkUkZMd0pybWlR?=
 =?utf-8?B?MUlWU1dmU0FrVjhyYU1GUWVLZmVBbGRZTGRrdHVtUjhuZEVEcjhjd2JUMEVP?=
 =?utf-8?B?ZXFMa0NENGlucUoyNk1DYW9JQ0htYUZkek5YVkFBNDgwY0JCcHRxRks2Mngw?=
 =?utf-8?B?bUIrcDVBdnMrT1huTThTUlVwdlpqV1JVTWtHUzdkQWJYYldhZkcxWEZPOExs?=
 =?utf-8?B?Q3BhY0RjK1Q3T3pKMWhJbkpscUVJbUt3dGtnRUNTakx0czQ5cHErOWJsa2NJ?=
 =?utf-8?B?eUtoSGpvY0xGWDNOZ0trOCtzKzNGMFVaU3k1b1NLUS9SQkx4eU5vMUNEVW51?=
 =?utf-8?B?WnZWTXA5U1ltZjJhRlZBcEVXemRmRmlEbEJ4ekZHMHhBcHdLVjFzMGxJbm1n?=
 =?utf-8?B?cEZSYmtHeTR0ZG13RFBySHI5UHMyVDFBNUZNQVp4WmZjVUt5bmVXNWlmWHFy?=
 =?utf-8?B?NkF4TE1KRDVOR3lVUWZkU21nekhsbGt1dCszQUlsb1BOZ01EQTVpb2JNQm9w?=
 =?utf-8?B?N1JQdHhTcXJSWVhEM2lUWjZ3eDh3d2NUeGpqakRXaVZDWEtDaG5Ud1htRm9V?=
 =?utf-8?B?ajhmR01lZnJ1d3diaU1wckllek50bnZVMHdTMUdPMzQxVUhPREJ1MUNZWnFx?=
 =?utf-8?B?dXNFRWQ4NkFsTlI3ZXZmcGpueDBXZy9JMG85bENQRkNSOWYrN092VUVVZGRV?=
 =?utf-8?B?VzdjQzhmYnZrQ243NWwxenRwUDdCN0dPejdYOUVWem5oaGZqVTFIMU50NldC?=
 =?utf-8?B?WGFFTGZ0eHlEY3Mwa2lNb2RlZG83TjBEVDd1RXhtMVRqUzc1NTZmUnlUNFU5?=
 =?utf-8?B?VEJpTTQwU1hHbjlmSXBWdGVtOGxvY1VKb2ZadUt3ZUhMSkd4T0hManVrZzdO?=
 =?utf-8?B?eGFyR015YmxiUnJHc2NWWlA1REFBd3dTc2JjM0IxeUcvQUVOTUNVQ3hadE9s?=
 =?utf-8?B?R2hBTE9XSVBkTExieHB2QllQdjF0YUdnY2c4dms3NUFlMHZLUm9qOFpOWUtx?=
 =?utf-8?B?YUo2dlBnZHF6MmJ3c2x6d2lTKy9UVk83Mk5xN1JRVnJzQjJBTFBpdXRSV0c2?=
 =?utf-8?B?LzFhcDNRY1N5MkNPcENtSEJWTWZ1NzVYK0xuTmRXSExaVDN1eEVBTWhkcVdC?=
 =?utf-8?B?bUdRRXRUT3gvQ2gzQlpvaWs0V1JiMmRBTHBCZzd5bWdLSm5hVkJKb0Jxb2o4?=
 =?utf-8?B?MjlBTEhveFU3VForaFBkdmNmUGU2K01EMHcycEcrWHVIZmZFNzlLOFM2TUgr?=
 =?utf-8?B?STFIUHE4QjE0aGNpVzdmQlVEalZNOE13d1lYd3BtOHIyL1lTY2VUd1FMeHgy?=
 =?utf-8?B?clY2aTI1ZktxZ3pHWDd6TXFhNW1sWWZuTDNKZi92U012aWZPWEliNFFQbXJK?=
 =?utf-8?B?cGN5NU12NG54K2E5aWlXcm1obFZvVmhqMGZzajFkbUIwVzhic3VsU3F3MVd4?=
 =?utf-8?B?Tms5UFZoK251eEtVcjFpQnVCby9saSsrcG5SWm1IWjBjYnYrTS8xOVZ4U05C?=
 =?utf-8?B?dWJUUjRiYzRxcmsvOGdWWFdPSTRFVUI0WEhxWkl4Zmt5dllHbElOOW1iWHVl?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40EEDF585FA8D8429A9D00294D03831F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08281c9-0f0f-493e-d337-08dd0428a92a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 21:18:03.9345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SeBCc0vskamsGvE0ysqT4cAcXrsRfucp1/Fg/3yp8bVZPt4KGNVyOz4qlGotBLT1hdC38wDOFwfqKBaeOM71m7BJBFGO2x1A7P6gi+Y755M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8070
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTExLTEyIGF0IDE3OjExIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMzAvMjQgMTI6MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+ICt1NjQgdGRoX3Zw
X2ZsdXNoKHU2NCB0ZHZwcikNCj4gPiArew0KPiA+ICsJc3RydWN0IHRkeF9tb2R1bGVfYXJncyBh
cmdzID0gew0KPiA+ICsJCS5yY3ggPSB0ZHZwciwNCj4gPiArCX07DQo+ID4gKw0KPiA+ICsJcmV0
dXJuIHNlYW1jYWxsKFRESF9WUF9GTFVTSCwgJmFyZ3MpOw0KPiA+ICt9DQo+ID4gK0VYUE9SVF9T
WU1CT0xfR1BMKHRkaF92cF9mbHVzaCk7DQo+IA0KPiBUaGlzIGFsc28ganVzdCBpc24ndCBsb29r
aW5nIHJpZ2h0LsKgIFRoZSAndGR2cHInIGlzIGEgX3RoaW5nXy7CoCBJdCBoYXMgYQ0KPiB0eXBl
IGFuZCBpdCBjYW1lIGJhY2sgZnJvbSBzb21lIF9vdGhlcl8gYml0IG9mIHRoZSBzYW1lIHR5cGUu
DQo+IA0KPiBTbywgaW4gdGhlIHdvcnN0IGNhc2UsIHRoaXMgY291bGQgYmU6DQo+IA0KPiBzdHJ1
Y3QgdGR2cHIgew0KPiAJdTY0IHRkdnByX3BhZGRyOw0KPiB9Ow0KPiANCj4gdTY0IHRkaF92cF9m
bHVzaChzdHJ1Y3QgdGR2cHIgKnRkcHIpDQo+IHsNCj4gCS4uLg0KPiANCj4gQnV0IGp1c3QgcGFz
c2luZyBhcm91bmQgcGh5c2ljYWwgYWRkcmVzc2VzIGFuZCB0aGVuIGhhdmluZyB0aGlzIHRoaW5n
cw0KPiBzdGljayBpdCByaWdodCBpbiB0byBzZWFtY2FsbCgpIGRvZXNuJ3Qgc2VlbSBsaWtlIHRo
ZSBiZXN0IHdlIGNhbiBkby4NCg0KRWFybGllciB5b3UgbWVudGlvbmVkIHBhc3NpbmcgcG9pbnRl
cnMgaW5zdGVhZCBvZiBQQSdzLiBDb3VsZCB3ZSBoYXZlIHNvbWV0aGluZw0KbGlrZSB0aGUgYmVs
b3c/IEl0IHR1cm5zIG91dCB0aGUgS1ZNIGNvZGUgaGFzIHRvIGdvIHRocm91Z2ggZXh0cmEgc3Rl
cHMgdG8NCnRyYW5zbGF0ZSBiZXR3ZWVuIFBBIGFuZCBWQSBvbiBpdHMgc2lkZS4gU28gaWYgd2Ug
a2VlcCBpdCBhIFZBIGluIEtWTSBhbmQgbGV0DQp0aGUgU0VBTUNBTEwgd3JhcHBlcnMgdHJhbnNs
YXRlIHRvIFBBLCBpdCBhY3R1YWxseSBzaW1wbGlmaWVzIHRoZSBLVk0gY29kZS4NCg0KT3Iga2Vl
cCB0aGUgVkEgaW4gdGhlIHN0cnVjdC4NCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCmluZGV4IDAxNDA5YTU5MjI0
ZC4uMWY0ODgxM2FkZTMzIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgN
CisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQpAQCAtMTM3LDcgKzEzNyw3IEBAIHU2
NCB0ZGhfdnBfY3JlYXRlKHU2NCB0ZHIsIHU2NCB0ZHZwcik7DQogdTY0IHRkaF9tbmdfcmQodTY0
IHRkciwgdTY0IGZpZWxkLCB1NjQgKmRhdGEpOw0KIHU2NCB0ZGhfbXJfZXh0ZW5kKHU2NCB0ZHIs
IHU2NCBncGEsIHU2NCAqcmN4LCB1NjQgKnJkeCk7DQogdTY0IHRkaF9tcl9maW5hbGl6ZSh1NjQg
dGRyKTsNCi11NjQgdGRoX3ZwX2ZsdXNoKHU2NCB0ZHZwcik7DQordTY0IHRkaF92cF9mbHVzaCh2
b2lkICp0ZHZwcik7DQogdTY0IHRkaF9tbmdfdnBmbHVzaGRvbmUodTY0IHRkcik7DQogdTY0IHRk
aF9tbmdfa2V5X2ZyZWVpZCh1NjQgdGRyKTsNCiB1NjQgdGRoX21uZ19pbml0KHU2NCB0ZHIsIHU2
NCB0ZF9wYXJhbXMsIHU2NCAqcmN4KTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90
ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCmluZGV4IDJhODk5N2ViMWVm
MS4uZDQ1NmUwYjBiOTBjIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5j
DQorKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCkBAIC0xNzg1LDEwICsxNzg1LDEw
IEBAIHU2NCB0ZGhfbXJfZmluYWxpemUodTY0IHRkcikNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwo
dGRoX21yX2ZpbmFsaXplKTsNCiANCi11NjQgdGRoX3ZwX2ZsdXNoKHU2NCB0ZHZwcikNCit1NjQg
dGRoX3ZwX2ZsdXNoKHZvaWQgKnRkdnByKQ0KIHsNCiAgICAgICAgc3RydWN0IHRkeF9tb2R1bGVf
YXJncyBhcmdzID0gew0KLSAgICAgICAgICAgICAgIC5yY3ggPSB0ZHZwciwNCisgICAgICAgICAg
ICAgICAucmN4ID0gX19wYSh0ZHZwciksDQogICAgICAgIH07DQogDQogICAgICAgIHJldHVybiBz
ZWFtY2FsbChUREhfVlBfRkxVU0gsICZhcmdzKTsNCg0K

