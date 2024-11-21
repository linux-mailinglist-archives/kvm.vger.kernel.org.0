Return-Path: <kvm+bounces-32224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E2E49D44E9
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 01:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4A81B22A58
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 00:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEBE44C6F;
	Thu, 21 Nov 2024 00:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kquhiNVY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C123098E;
	Thu, 21 Nov 2024 00:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732148956; cv=fail; b=ArdklyqgGQ4THxyiahDeM7liMQVqj2NVVJdCNiBAD4q40wUtavCShJMoONOdVZ+nHGADSn9Z3wJWBecFlj1XKpn6gEXhdDP3n42Jf2AG36LsyWiB4aoihKrjAJk442cJTrZO4IGiOrLQ1kdZIj2kdZkfWPv/TGR+3hOcwjN6s5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732148956; c=relaxed/simple;
	bh=HWGRCxJ9a4xfOWfup7A8A00nSp8ZSRpxjiujpTaU9Vw=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hrxj2VU9Zcg3WqARqn8ek2t7eqDztLMHL+1haRnzL9h1aY5+89LC4kL+/WD0A4nv2AS8cKkf+dCc1BVf346FOz16634c3o+UMnR67Gtbk0C4TI2Dk4w8AkIxRJXE4Tlxn8jSD94Nqxm4R6Hzz11zVc/28Z96Ip/4Y+9FAm14fR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kquhiNVY; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732148955; x=1763684955;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HWGRCxJ9a4xfOWfup7A8A00nSp8ZSRpxjiujpTaU9Vw=;
  b=kquhiNVYsEl/m2/cbv3qPcdDRrjrwzo/X1Ai1cZfShFa28xo4SahVDVA
   wDSPDEZr2Ai4J05vGfhtUM8SZoqP8ntMM5u9s1l/XBlN8xaExAVFt/YEd
   5ntZoe+hi6EIlJ1C8EabqH62cE4+IzYc4YEnBm+HOM8YfWU6HgBbnv6ew
   nVAj+uZRaJARz9qDMPLnFPJRvfYKvCoswQMDZzHE/+rE0cF7GG3OyAtty
   NGwoPj6U7yo3gJBLdNLD+0ThwZmt2QWCELZskiS+OZ8ICPC3tEx5eZGYp
   KUeKQNVeUa1N2FYQdU/UQbuhpEIJyI4kgWntp5jWXb8YdeBckp1oSaD2z
   Q==;
X-CSE-ConnectionGUID: sdthBuFzQd6g9mPrIsTY+g==
X-CSE-MsgGUID: JtyZ2b/oQeOfejvLtyfFuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="32169930"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="32169930"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 16:29:13 -0800
X-CSE-ConnectionGUID: 5dd9jcXiTHegyzcFbVrGEw==
X-CSE-MsgGUID: uOIRW7iZS+C1EYlKTp2Q3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="94141749"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Nov 2024 16:29:13 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 20 Nov 2024 16:29:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 20 Nov 2024 16:29:12 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Nov 2024 16:29:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hym9hnnTw2U1PUQLApx4xbLAubqosVtnL8R2DWVqQ6BMHZzaXBELMTyio2LYE88nqku41VDUleqOYUwezHXxz2yyTPAfBubdQqtUhuICK4LHhfZzUQJ5iWl9wsuByZo2JlEbQIpWbzs4x5Icc6FU9BFeam2GAyYmOR/q0HOqiNF2PCRAkCMUZaOk2R8JCTQpwf8ag3NYUoOW0u4KaZVSoD/maU682cmFTU/CPrzIdaAOqJ+7j8/1BfqRxcwLXMuiByQrm9hxpivpqzhxt+Z6u+aOmSGEo+vEmq5BRSJn9+vU0T3r44JrZWrhQzAZhogYeyFILaeMVDeh+okUpHCNig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCCYgerDMiSUa08y41EGlCsK9Odz/TZsqnWUd/mGauM=;
 b=WNpL4vn2f085pVrqfws0pCJ2pYH05GYc+LrJaZv5CHdlJX/ObkGLWHI+2jO7D7CYkc+MPxsMuWqmsAe3cQsrt/TUvT4Ky9w74B9gASbeSISbLMJwp+Az4atIFxbeLOqLGCGgv3rDxVEioHeAeyoNGVzUAqAtnflg+XAZcwJHnuQLlukY/7daYJPSXm/SiiCA7CYm47PDD439dyRbQgkRLZqmXb92bpcxPUWfqhBipzgze16MAtWCiWGZk7mwX1hp+e+jgNDn8t4ZTzaAZajX0Mtl8OahlolxiGbNsXMnNw28FqqAkDfQxQIOVcfSSv8eUogghkCY+hJJxIjGPZLCIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7524.namprd11.prod.outlook.com (2603:10b6:510:281::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 21 Nov
 2024 00:29:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.014; Thu, 21 Nov 2024
 00:29:02 +0000
Message-ID: <5927eaf9-d9ac-4056-85af-39bb90eabed3@intel.com>
Date: Thu, 21 Nov 2024 08:28:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] KVM: VMX: Initialize TDX during KVM module load
From: "Huang, Kai" <kai.huang@intel.com>
To: Chao Gao <chao.gao@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<reinette.chatre@intel.com>, <binbin.wu@linux.intel.com>,
	<xiaoyao.li@intel.com>, <yan.y.zhao@intel.com>, <adrian.hunter@intel.com>,
	<tony.lindgren@intel.com>, <kristen@linux.intel.com>,
	<linux-kernel@vger.kernel.org>
References: <cover.1731664295.git.kai.huang@intel.com>
 <162f9dee05c729203b9ad6688db1ca2960b4b502.1731664295.git.kai.huang@intel.com>
 <ZzrdL5iSu7/DNoBG@intel.com> <eb37d3fc-7d19-4dc2-bac4-6e0cb5c8aa1e@intel.com>
Content-Language: en-US
In-Reply-To: <eb37d3fc-7d19-4dc2-bac4-6e0cb5c8aa1e@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGXP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::18)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: 77698725-4093-4e00-501c-08dd09c37fa2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWtXTnNiaTg4T2w2WXVzU2RwTHl6MUhLNUh3VHlicFNQZ2x4SDdOOVlvbTR6?=
 =?utf-8?B?alFmYSt6VmRwSHFYQTJhQlJRN0czbUI1SDdEUTFhdzVNQ3ZhSWJoWmRKR2tv?=
 =?utf-8?B?UVlZYkxLajlES0NkcEN2eEhYeEZyMXEzT2Z1QWdROU1kVnBlbXZxSWt6NDdP?=
 =?utf-8?B?blRYVWV4L05lQ2I1S1pONFBHeDFUTkNqRGViNk9MUjlQS0NHZ2dhZjhzdzNw?=
 =?utf-8?B?Uk1UTFhGTXluMU83TEowcTcwVEo1WUIyMUt3REY0UlFhS2RGdmNaT2gvSjA5?=
 =?utf-8?B?SDFPSmszQnFESklQQkphendLUXBsMW5yM2Y2N20wYlpISG9WbWVicnE5ZlRv?=
 =?utf-8?B?cEhhVlJjY2JZRFdZbmdXZys2Q1R6aXJEd3JvcVlZNnltSTkwTjVxMDFHN2xC?=
 =?utf-8?B?WkhQL1loODRnK1hMOFMwKzNkQ2dGK2p3Y0FSd0R1VXl2d3ZsdDNYZStNZzVG?=
 =?utf-8?B?VWJMVkQvRjBYVi9hU2FJcXNqRU9MSXBabjRLdTgvREVoeHRrK1d6SGhSbklX?=
 =?utf-8?B?NGMzTXAzNSsrTkNkcG02cGNBaUtrTXZlNGo1aXlGNVFjeTRKYU15c2lPQlRx?=
 =?utf-8?B?VlBnRFZobTNVRWIxc2VjZFpNTDRSbzVjL2pVNlNBd3pPN2hRcHJMWHo2TGRm?=
 =?utf-8?B?eWxaK1JUUEhYKzZHbWUwblp4K0FVSTZFNGpkMnhsZktVbjRYWisvRWhWRWdr?=
 =?utf-8?B?RWVxaGpzK0hSVldvUGRhZE5IM0tEUVhZajB1Mm5JZWJ3R09MUFMvVm1tR0pH?=
 =?utf-8?B?dFAwVExqejZNMFlzclBmMlRIclExVXUxYyswb1NhU0RRejUzdC9BTklsQW1x?=
 =?utf-8?B?aFBOWGozcGtvOVQzZGsvbC93cm5hV010S1liOUM2QnFEaTZOR2xZLzJoTWhp?=
 =?utf-8?B?by9odCtPSVY4dVVLaEk4cTdCQUhIbzRhdDVha2UzTFAxWDBmYnR6cWZxaXNt?=
 =?utf-8?B?MkgvZ1NUSmlnTWFPcUxSazBhbGJzakpKWjlVT3BRSHpZNlJ2MnZBdFE5UWJJ?=
 =?utf-8?B?L1k3cWNpT3ZVNElOK3JIYno3cFI5WlpxQUM5TGo5QzVXYytQVkI2SXEzU1F0?=
 =?utf-8?B?YXlNclhNSGhyWUpBNmRFTTJvazRIWU50SGZMRUdoQTR5cHBjdG1GejUxbVVW?=
 =?utf-8?B?ZEU2YVBOWHl0b3ZWd2JSYjVUQzJqSEZuMSt1T2Y5aHM3RE5NSWpIK01LbGgv?=
 =?utf-8?B?OFQvblZOenBYaEdZclhMTkFKRU1ma0lzUlhKc0RydGc1c0lZeTJuKy82Mnd4?=
 =?utf-8?B?NTUxcitRdU5ESkFsMG9Mb2xQdFAxZFI2MDJ0NEM2OTQyUk43b3Bkczc3VXBY?=
 =?utf-8?B?OFpSazB2WDJsQ2xIeXdMQllkSDBPbDBubFNKNFJva1U3ZnF1SHJJYzFwKzMr?=
 =?utf-8?B?blRWN21Ia3ZVSnZUcFdDMTR6a29wdXdGVElUVVV6dFp6VnNoK1kzeU5Za2pU?=
 =?utf-8?B?cUhKdlVHZWdEbS9LYUdtOUJMV2h6UXVZYzNUT1RubnhVa2ovVzdIbTJIUHdE?=
 =?utf-8?B?SllocnpGQlRNTTdsTzRUUlJqYlhYM01uWmJQc24vSTB6U3R1NnZIM1c0NHFw?=
 =?utf-8?B?Z2tZVEExVFRFR1VjeWFRQVVTSWttRHRIckIrTjNtbXc1eFBOWEk0RGhCNHF3?=
 =?utf-8?B?ZHlpcVQxNTJRY0cvbmlKaCswT0VoZFRnUWJ2Y1lvaTU2QTZrbVZ6Uk9GV2pF?=
 =?utf-8?Q?ddvr6TS2NLTJGAWVFmZE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWEzZXZYL3E4K0pYNUQ2b204STM3endYWFdPSi9ialdsQ3d4TXh0OE5JNFds?=
 =?utf-8?B?dkdCMDlReHVnWGRZRFZHOWFvcEJjbkNkUk1LeWxGMHI3WFY5QmVWZmJ4QUxQ?=
 =?utf-8?B?Y3IvdFJvRC9jaHJESXQ5cTNmNXl5amphRnA1bmpudEg3b0JJQVZMR3d4VVBy?=
 =?utf-8?B?bWFJbnBSNWJSTG1EbXV3YVpmVDhPZi9tRElqcXMzL1ZRL0dqbWVEV21Kalds?=
 =?utf-8?B?KzlCVWlrYVZnN0srUUJNZmZzSFFhVi91d0xDMkgzU3JaNURVQ1dSUnBIWUUr?=
 =?utf-8?B?SnQrY2Q5TTVDbEVzV01BbFFJMERobmt4MEo4VDFhd0tNYTBYN0QzYUFtNEJS?=
 =?utf-8?B?WUZzR20yNEF4MkZEblViWElxNCsrcE5jQ1ZGZTd3QTVaTkFML1VHNnVKQWhL?=
 =?utf-8?B?M01QK2ozek9kUHVaYis1aVlRTG40eHVWcVRsa1h5cUgvQnJvWlZ3N3NQV0FX?=
 =?utf-8?B?MlFqOWVxdE5DVUlFeUlUWll4RUd6cnBMSVZ3ZDJPNXZNY24xZTQxbExTS1dW?=
 =?utf-8?B?dG5ySFEwcHliT2NCM2JnbHVlbEoyQXZnYk1OOU05aHBHUitNSkFYTU4rWE1p?=
 =?utf-8?B?WGdEZnJCMzZGb2tzeEd5OGhlK1l3WUFJZDB5ck4rVk96UWVLR08xMW9rT3pl?=
 =?utf-8?B?cjl5dTlCbklyd0t6ZUJVcHEvY3YxUWp5ckFzUytyUEpjdlB3b0JJV2tMN2dq?=
 =?utf-8?B?bUZvSXlRUEUzeGFXYUdxKzFOWGlDVzVVTkExRHRJK09FUWpyOXF5cERmU3k4?=
 =?utf-8?B?QXF2RFRWb09UTWh6U2tpeE9FZittUHMxOFprZzhPSCtLUGZKbTJ3Q3lnMWVT?=
 =?utf-8?B?ellkRmpPTUNoSEQyZVZYQks3T1lKd1A3cjhTekswZnVZWkNlRGtTUWNPdTdY?=
 =?utf-8?B?Ti9JL242RDhKSmFzTUJwRUxsUmFIOXJkc0hoNnZTZWg3MEtTSW9qdnRJK25r?=
 =?utf-8?B?Y1JacC9Ycnh6bU9uaklPRWI5TDhwaCsxbExuRmFJY1h3emlVRVpaT091TW9l?=
 =?utf-8?B?WS9KMFNyUGFvczVXZUY0VE5EOWx0SEM0amV4eDkxby95Ymt2bzJIZzlGWmdj?=
 =?utf-8?B?N0xLeGVsc0hFaHJaMllIV0Z3QTQ3ay94bUJoMkxKK3ZyYnd2eXdScmV5TWpJ?=
 =?utf-8?B?UGphMFN0dHF1Tm1talNGK1BOYUtlRmlOMVczUVFMYzR1Z3gxTEEzYk5OakMy?=
 =?utf-8?B?SzVhZEhmUnRqUmdXd3MrVzZkR2k0ejM0M2NWZi9DdDJGOHIrbTlwL2pEVGRI?=
 =?utf-8?B?QjlRdWpqZitQQjR4bERjbC9oMGhGTFh3cXRPbVFxN3ZuVmVXWXBtN2p2TVhI?=
 =?utf-8?B?Q21mekV3VzQ0RUZmRFUvUSthNHRZZCt1TjBpWFZUNTZXMnRmSVZCODl6RmF1?=
 =?utf-8?B?NDRoWThaSW4rekZVSG5GRERWQlplelFlRUM2aHJDdmQ3V2Z2OFlNWUNLc3hD?=
 =?utf-8?B?V1F6YzJrbnFFWHQ2b0J6TDAwRWowOGFWcFc3b1JNQVpvcEx2R2F1S2JNMXFZ?=
 =?utf-8?B?S3JhSTZaVXh4a210bllMV3lqQ0FNQWh0TUZ1R2pLTWhtcEovWEhHK2NaV0Rz?=
 =?utf-8?B?WVRKU1dwYksxSGVaQnlVc1FoeCtlK1dLejVmdTJPV05LTFFLVkR0V0V2bTRu?=
 =?utf-8?B?WlhKeDMxZkFZY2pIZUFNY3MvZkY2R05HdnpQQkxnaVMvNEJIbWppSG1TbzZV?=
 =?utf-8?B?WllPNW9Hd3haRTdOTyswd1ppcVN6SmNwekhLTlFUSnJtT1VUSHhaQTBlcmc2?=
 =?utf-8?B?MjY1d0lic2pmOGlhVDRDSlFuYVgzelNvOGpXZys3T3kzdHNJWUlIbjlTd1l6?=
 =?utf-8?B?RnBRN3JTZExiOXFlV3ZzVUtlVDdSVU5jeW9EYVZaZmlyZEc5a3VYc3p3MFAw?=
 =?utf-8?B?cllIQmlLYU05THVxY20xeHhVMVBUckFPYlA2Si9DblFKeENCSHBRby9wKzVm?=
 =?utf-8?B?MFBpcTFaampRaERMVWN3dERMSlJ5NVMzTW0wcEsvNFMrUHNTTW5vQUhOcTFs?=
 =?utf-8?B?NW5VN0c3TS9ra0sxeDFJMmdoeU9xTFYwUmtkMWRUN1o4V1lpNjBCbkNERlRY?=
 =?utf-8?B?cEFudVl2b1oyUU90aWFRbWg2cm14S3RnRHpIZVBQWnhzMEZyZU1XL0VhYkU0?=
 =?utf-8?Q?tCBiMxmORmjYI2Sa1EhVnojfx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77698725-4093-4e00-501c-08dd09c37fa2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 00:29:02.4397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7fqGPDSs1rQw3w7AZbc0rf+yc/BJ0L6t4B2P/rgCdLGgpKGYJLsFHeLV9K23LiZZl7k7USOKboGL5YCCZbaxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7524
X-OriginatorOrg: intel.com


>> Shouldn't we make enable_tdx dependent on enable_virt_at_load? 
>> Otherwise, if
>> someone sets enable_tdx=1 and enable_virt_at_load=0, they will get 
>> hardware
>> virtualization enabled at load time while enable_virt_at_load still 
>> shows 0.
>> This behavior is a bit confusing to me.

Forgot to reply this ...

>>
>> I think a check against enable_virt_at_load in kvm_can_support_tdx() 
>> will work.
>>
>> The call of kvm_enable_virtualization() here effectively moves
>> kvm_init_virtualization() out of kvm_init() when enable_tdx=1. I 
>> wonder if it
>> makes more sense to refactor out kvm_init_virtualization() for non-TDX 
>> cases
>> as well, i.e.,
>>
>>    vmx_init();
>>    kvm_init_virtualization();
>>    tdx_init();
>>    kvm_init();
>>
>> I'm not sure if this was ever discussed. To me, this approach is 
>> better because
>> TDX code needn't handle virtualization enabling stuff. It can simply 
>> check that
>> enable_virt_at_load=1, assume virtualization is enabled and needn't 
>> disable
>> virtualization on errors.
> 
> I think this was briefly discussed here:
> 
> https://lore.kernel.org/all/ZrrFgBmoywk7eZYC@google.com/
> 
> The disadvantage of splitting out kvm_init_virtualization() is all other 
> ARCHs (all non-TDX cases actually) will need to explicitly call 
> kvm_init_virtualization() separately.
> 
>>
>> A bonus is that on non-TDX-capable systems, hardware virtualization 
>> won't be
>> toggled twice at KVM load time for no good reason.
> 
> I am fine with either way.
> 
> Sean, do you have any comments?
> 

... and yes I think we should make TDX depend on 'enable_virt_at_load'.

And by doing this, I think we can still do kvm_init_virtualization() 
inside kvm_init():

'enable_virt_at_load' still reflects its behaviour -- TDX just enables 
virt earlier than other cases, but it is still "enable virt at load".

It's perhaps not perfect, but it saves unneeded separate call of 
kvm_init_virtualization() for other ARCHs.




