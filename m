Return-Path: <kvm+bounces-49969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B326AE049B
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 13:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA34017D130
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 11:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EE223F42D;
	Thu, 19 Jun 2025 11:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wf+IsB0l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615CC23B621;
	Thu, 19 Jun 2025 11:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750334258; cv=fail; b=dTI7Jrb/SJ6241Gsmwrfr6wT30k7/5BhqKvnWNEaNW3vCa7QfTOsUL7aLOC2FwwLx8XHTAp6c0JQJ0aFD8PIwv64swgnI3v37KOZgj0SsDf11CLE043+8rV/84nhbLJtI6pywKwpT41lMl7GC2AFeglrkz6PpmihqTD2t0u0I9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750334258; c=relaxed/simple;
	bh=K4K5S1poaLskyGgd+Pv8HKVCuHiQV2nyAKdZlZ0kJHQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=isSJZXuCBzxekKOxZDtWNcvT0nzLN+2Yke0IplZJ33vc2tFHISW/x4HRN0wNx0F9HbFhZZpEujDDxEHVXKeLAqSwoTgxkB7iAQQCavk8j1bIqcypJxlcO/CncXv+vuBkir/1YCdAjSfpmz1jZRuHnV1LWWs4NpL9wpZnVXQGYho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wf+IsB0l; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750334258; x=1781870258;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K4K5S1poaLskyGgd+Pv8HKVCuHiQV2nyAKdZlZ0kJHQ=;
  b=Wf+IsB0lnIVa8KMy5Yd2qQ9Oo0TLL5/bCPiOlkTVMAntUQrrvyhXG4qj
   5ecypY/seyehaG+4ngQPKuX+t7mZFpzAg2qMW6DApjmRWKYRTxEy6GdPf
   wbo/jGDDsWbutsutT/71jQfZaJIAeTXn1ht6EgLFkIyxipzeUTV+tapsN
   mcwY0afZ8gPfGMNjXNsWF2XA6W+GRSBdp3yGgxJVDYOzHSDEsjz3u2nH1
   SO5rNVEqGZgH6n/xxQ7MagCobMNKrDyb+KIF/rgaNOpdFv69/GQzwXDwD
   C+lYjJ3bWHpMLxu2bFA9CJN1UIcSrDvpzka5db39H8BcEoAIGk5hKIOcE
   A==;
X-CSE-ConnectionGUID: akyF3gUiT4qQMZ1vgrlfEA==
X-CSE-MsgGUID: YRrz4TUkRJCwq3RQX+NW+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="64014594"
X-IronPort-AV: E=Sophos;i="6.16,248,1744095600"; 
   d="scan'208";a="64014594"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 04:57:37 -0700
X-CSE-ConnectionGUID: ivUGQndaT+WCFz7PoqqzYQ==
X-CSE-MsgGUID: 848l5QFyT1a1jf/Sz+tx2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,248,1744095600"; 
   d="scan'208";a="155191839"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 04:57:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 04:57:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 04:57:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.61)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 04:57:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TpT8qVafk3vamEsamxkNRG3KgQFXZ006o0/cQWIPPeMoihCOulSslbPJBvsmVtZl530gOCBA8GatzaaZULbgjlktV6gb/Z1tPfJo3MJg20G5AR4F7YJBRAUFslH8hWwid8mwPBWG/x12m7vv1fLYWFYZQWlyWZPF8AT8zFYjU8O0dk1zbSkpJ/XDxMq9GiJz8XiyG6ntIb7g0eSlkPPkZIpdq48q/LMOP+I/mhkRjN8J42n2l98fPzLHZo5hlRtVe9al1pyoACHmwb6VwnS/k3BW2m+wvFnf1DctyAbCnyJzxJU+E5WJ1iIRYUKFmpZp9dwAAulOUCg3BL1TYMHrpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hLaDEFebn+3jcMzS46ebq+E62G4EFtKHDEijKt3ABc=;
 b=lLcqX8cMHXSN1lLluwtOdlfrKXhuPl+3BG6Dwxfkz6K5FD/2OzbzhEiN6hFX31lepjftjsKW4ycN6AVWaxZuCgu3FVtW8hyFR06PLYQ08Xed3caUb7bIbgq8Ex9LuJ8HA/xxZsoNZWcXhI7SZi9hum2GZVAap1VhP+RtM5S1dERDdgod/dkdtCQYf7Z7q9jYRJWllBeyVKudiIDRb9JFEcJW6gyYNr7HCY7dFvijYQO1ksOKH+E2DizPBx8Sdd/1LOSG6Q9YJ2xJKgWtfml+RqppqqwEFLsqIXrTHlUQfIiaCk0bkQPOgiILQH40YPd0EB+R4RX1NvB4FJuUIfq7zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3206.namprd11.prod.outlook.com (2603:10b6:a03:78::27)
 by CH0PR11MB5249.namprd11.prod.outlook.com (2603:10b6:610:e0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Thu, 19 Jun
 2025 11:57:27 +0000
Received: from BYAPR11MB3206.namprd11.prod.outlook.com
 ([fe80::4001:1e6c:6f8d:469d]) by BYAPR11MB3206.namprd11.prod.outlook.com
 ([fe80::4001:1e6c:6f8d:469d%4]) with mapi id 15.20.8857.019; Thu, 19 Jun 2025
 11:57:27 +0000
Message-ID: <ccee2a0f-18fa-4037-bf97-f359e0791bf6@intel.com>
Date: Thu, 19 Jun 2025 14:57:18 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
To: Dave Hansen <dave.hansen@intel.com>, Tony Luck <tony.luck@intel.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>
CC: <vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, H Peter Anvin
	<hpa@zytor.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-2-adrian.hunter@intel.com>
 <487c5e63-07d3-41ad-bfc0-bda14b3c435e@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <487c5e63-07d3-41ad-bfc0-bda14b3c435e@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0039.eurprd04.prod.outlook.com
 (2603:10a6:10:234::14) To BYAPR11MB3206.namprd11.prod.outlook.com
 (2603:10b6:a03:78::27)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3206:EE_|CH0PR11MB5249:EE_
X-MS-Office365-Filtering-Correlation-Id: c32a27b1-2f3d-4eaa-0df1-08ddaf2875ff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RkFYSWNkS0lieWJ6RjdaTjl2L2d1TllaS21TKytoMkl1VkU3OXl2VTErbVox?=
 =?utf-8?B?ZWFjVUduKzNKMzBPSkQxSmJlUnZpdmtBeVZhTWlKZmZpbjJCaEhIanE4VWNN?=
 =?utf-8?B?dFF1aS9TS1VtSi9iTCtDZUtUMXprWjM5Si9McVBQWEJkSUZITHpVZURpTW1Z?=
 =?utf-8?B?dWZaWE1PNFlXb1VIa1IvYnR4N1NNVEFvd253cW9NMTN5NjgvdVNpQU9FUTM0?=
 =?utf-8?B?cEdxK05rWE9NcEdxRTlnd0h6VVBDdVQvdzdsNlVNYnBvaU90Q3VuUlFCR3Zk?=
 =?utf-8?B?ZkdwazFUUVVPOElqNWFmSVN4NHVEbTlteUVEU200dGtVeFBhZ01PUENVMHMz?=
 =?utf-8?B?WXFoOWZqbjRxWHlJN0RkN2Q1YTYvRWRYN3hMdjBLZkhLVzRaRWg5K3V4dWVp?=
 =?utf-8?B?bUVad3VkMUk1Z3Y3NHRHd05KcmRVZVhVbGd4ZFlMNFJPeHRST2xMdFR1bS95?=
 =?utf-8?B?aVNJY2ZjM2NjdEVMdTIxWXQwakFzRnpVNVE4RTFrbWF1eG8ydTB3eUx6N3RV?=
 =?utf-8?B?Ym02SXJNcWFjQTcxL3h6WGdCSlRoVUYzMXQ3clhDMEhmVEE3MTl6VjFWVmdi?=
 =?utf-8?B?ZzFnM1RGNXN4VDlacUtOTXFGSFV4Tk1vb2RNV3h1aHV1bXVsUzVoSVI4WkxR?=
 =?utf-8?B?bHplV0RLdkFIc2xrTTdtM2NucSthVER6cnNrdUljVkdycnpDQm5yQis5bEtm?=
 =?utf-8?B?V3BGR2dtWkZxYkU0TzNhWml4S1RiQkE5ZFdNVHcyTkU3TGlzaE1NRlErVUF3?=
 =?utf-8?B?cWR2djFBSWFiUVZWQ1p5QzBzeDV4OWdva2VqaWxOdWpYeUMxdzhiYzFIQ3lr?=
 =?utf-8?B?RkV0SUJqbFA3R3Z0WTArZWpSM2lrTjE1VTZUNnVZbE5FQnBIVlV6SGxRK3cv?=
 =?utf-8?B?dUx4L3VCeUZSZW5UN0tKTldLazkvM1lyS2NsUENqOWZkbTBmMEdFdUdmYWtU?=
 =?utf-8?B?Y2pOZ2xnTkpCWHNFOVptSS83Z2R1ZSt5L1VTY0IwY2VOZ1NCZ3kwbkp5dnRz?=
 =?utf-8?B?cEo0VkpoM05EMy9qWUFBOE12SGU3YWNjTkprOHUrMUg2Zkh0WXgwOW91aEFt?=
 =?utf-8?B?anpleHcrNnJidXhnSElNbitGa0F4d2lRcTlyUm5OWEorUkhyM3AzZDl3eHdQ?=
 =?utf-8?B?MC9WQndrTnNudkY4STkrR0FVZE00OE90cXRtT0JzWTBjYmlocnR3OUZEeDNK?=
 =?utf-8?B?QWFYN2svMEt2eGlRS3I0VG9zNE0yc1g2eExpdTBkbnZZbkI4c2tmUzBlblQy?=
 =?utf-8?B?Q2JoNVBwTFloRHRvUE9ST2lxaUVSMW4yQWJ1Mm9rcmQrVGhmaUxRNW1NWVY2?=
 =?utf-8?B?b0RaVnZNdnZhQ3JSM0NsbVo1MXVWbGVoVlBkc2FqU2FhU0cwL21PRHRjMldQ?=
 =?utf-8?B?YlUzUFRLSFFyQ1Z0OEhFTUdIQ01scXF2OW1Ua05CdGtpRDErLzNiVTNiZGdV?=
 =?utf-8?B?eUhONEFxWitqNFdGdDB1VlZ2Z2dPU0xZZzBzaTVwa09mY2lhcDJSS1ZyVWhw?=
 =?utf-8?B?TmxxQUpZM2ZNS3U2V1lWMTlUa3VQZFVieWJKNGxyWDE4bE0rSjNGL2FLVGpU?=
 =?utf-8?B?RDBacmVZMGZLWlkzSWJrVjRacmd4NEpUOUhNZVJOVDUyU21tSGg2b00wblEr?=
 =?utf-8?B?bVowazV2MXlWZEI3R3NBN3JDQkJIN0FEeC9XeHhJcWlLWlE5bGUveWlOR0Ja?=
 =?utf-8?B?enpOYjBOeVZkUHVwZGNjVkkwbzVWS0NJSUFYNTJLeTZXVzJ2RXQ4LzVvMjVa?=
 =?utf-8?B?UDlMU2RxbXlBSjdwL1hCQUZkMGlyNjRZa0ZYL0IvL3dSNUg4VndGaW5md2RZ?=
 =?utf-8?B?eEZZS3hiYVBVTmFtc1NzZFJOclBqcDFQTE9DTHpEa3JrYk9zYU1naWEzQm1B?=
 =?utf-8?B?WG9nOWJNSm8wdVF3eVV4UTZqRFcvclRYRndPZEpZREphNlE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3206.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnFOZlE1cnNqdE9OcmhIM2NTVlc2Rm5KT0pJeGx0eU1DK1RFUTZsZVRrVEcw?=
 =?utf-8?B?NVczR084QUtHRFR5SVg3TkVMM2V3TCtsYm5XVjloRmZvZlpBNHNXSVNCT1Nh?=
 =?utf-8?B?SUpjdEZnVlNYVmZpWmtUanhPemhTOGMvRHlFOTFvUzFvUk9USlh4ZjBEMWk1?=
 =?utf-8?B?VEYrQk1QZjVwaHp1RTlCY1NKVTN2R3AxUW9yQ3V4eGxLQ081RU1pRkZFRFI2?=
 =?utf-8?B?NmRIdUM2SldQYkRlbTBEZmRKeVpqajJQaUNMNEk2YVY0YzZ5bmRSaU16ZUEy?=
 =?utf-8?B?Q0F5a1lpMHRzSlBabUFIYTRla0xTSFlYelVEeVI4dTB3ZzYwajFvV01LQ0dU?=
 =?utf-8?B?VkRvRlduRnZzcy93RSttR0FiU3hTbWgydG1kUHRDRzQ5a1M5bHpkMmhZcHFY?=
 =?utf-8?B?U0Z1RnpQN1h1VDhPV0tHdVlFNysyVjRCVTg3MVc2REU1S3MycUJTMm9Ld1p0?=
 =?utf-8?B?OWdlRzZldUI4a3ZUSHUvWllzVTYxRkNXMnhOQ1JqeVVuNFhPR01hYm1UT0Zj?=
 =?utf-8?B?bE95UkswSHdySC92eWpWd0pNc25ubkhJRlZrQjVjSHhnMXEzUGpla0R2L0Q3?=
 =?utf-8?B?TGdCNFVTVHkrbFZXNFJneks4dC91Z2hrM1VnR1h0OERvSUl4SDdzOUkyNnpn?=
 =?utf-8?B?dVMzaTA3VVRNcitXemF4Z1dwWHQ4LzdWdnJMZXN3SHMyYWNTdTNnRUwrM0tw?=
 =?utf-8?B?aTZ3TlMzL2NWSHdpYU51U0pFOGZZN0crZHVrVXZGOFlSNWFMbnlXblJPSjlo?=
 =?utf-8?B?emN5VVdPR1hFTmdQb2VXV0RaSkJiVE5aaEY0Z2lzR3lWWExDMnYxTjdOamM2?=
 =?utf-8?B?emFWenBCZ2QyWTBRU29MUDcyZkdxVE1lUVpJbGZMbGJpWE1VcjlmSWhZdG1a?=
 =?utf-8?B?OEI3MFBqdzJCZE1kWlJYU0dBUzA2RjhBL3ZNNnp4TkFHQ05qcSs4aWpudEd1?=
 =?utf-8?B?TFJ1d0dhT2pJWW5LdlNtbHByRGozNDVGZ0NJNVJwRlQxYmh2NDA1MG9HZTVQ?=
 =?utf-8?B?VnV6UzdMbWVGbjlQd0lMcUd0WlZXOVZHT3puaFVReWlFMmdiR3h0eFdOL08z?=
 =?utf-8?B?WU9WcklIZUR5U2h4MVVVRldsRTZLMTV2SFNOS1JYL3huMUJXYWZSb3pDYUU5?=
 =?utf-8?B?Q2doajlzclg5eTlGc2EwTHVzNTEycVkxRTNmZlBBOUkzTG1WWThEM0pTN25T?=
 =?utf-8?B?S2cyRkwrNCt1M3BFcWNBQnZEWG1WTjhGb2NEY2p2RzUyUlhNalRCNFE2WWhH?=
 =?utf-8?B?SFRpTmljUFg5UktEMmxWS0pFUDZKRkZMRFFjakppdEVVMVpFUStjQW1QVmRp?=
 =?utf-8?B?cGVndjZxcU94d25mdmgxL1kyL2V3VTdTWk9jeU8rb0gzZGtHcisxck1pK3ZI?=
 =?utf-8?B?QmNweEMzY0RvL21zcU9Ea0pIbjFGclVkWFF3cVlya0RRNThyWW1tSzd0KzJi?=
 =?utf-8?B?WDl0cHZTV1pFQk5JU0pocFhkYnBxUjdsRC9BM2E1YzJTKzI3YWxZVXF4VDEz?=
 =?utf-8?B?VndRTWYxWU5iWkFLT2lIMDVOUWUwQTNxays4ME1yVitrY1RxQmZPd1JWRjNa?=
 =?utf-8?B?S0ZpTTRIZWZhM1IvdTA3OTIxRW9sZSs1UnNHNi9RR1RERUtIMFJhaGFlMnEw?=
 =?utf-8?B?QzlZTzZiZTd0QWFxUWRWNEJZZzFDeXFJNHg1TTBrTFJGcTlMWm5FNXpEaEdy?=
 =?utf-8?B?aW1pSGVmQ204bXJobHFHZzdnOU5qYzNWUlNiaFRSWVAzeUdESGI5NWhMTEFW?=
 =?utf-8?B?Nkw3QWxkMXgwbm9sRFg5eDBZaWg2ZGFXNDNETjZyWk40TzhtNmIyRTByZkNu?=
 =?utf-8?B?M2ZKUittVjQzU01Xbk1UdzdXdE5sYXhobWFlanFGTW9Ua24rRElGU1ZWbm5l?=
 =?utf-8?B?Y1lqY2dqcVNsalUzMWErS1d2TXFvUUpVSDRZNmlFNXUzdHIwVXhDSGFJczVk?=
 =?utf-8?B?bGNLdVBCaFdOS1BtWVROT2FYdENGTnNEb0gxMGxsRmpVRmxVRzg3ckM5Z0Vs?=
 =?utf-8?B?emZzT1VacHUrSmJjaHRlbXB5WXpvam1nbzdSNXk4Rzlrc3B6V0IwVStZM1Uy?=
 =?utf-8?B?VmJKcUpxVWZsYzdRQUZqUjRRdkJ2TWJXYzVhcUdlUnpLU2hPT1NXZFByYjdi?=
 =?utf-8?B?VCtwWEtuL3VyQ2FGL3JxL1dTTm9WUTdHVExkdUxBdE5VdXNreGg1UHdTZ28w?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c32a27b1-2f3d-4eaa-0df1-08ddaf2875ff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3206.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 11:57:27.2884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gflt0ZJX+NYatQpRQSM3Onj45NQ3a+XAUIkoYo/eZI76dg3wI/0y7P0P+70N3102iH1Vfnn7IQzKlRJgeBoioA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5249
X-OriginatorOrg: intel.com

On 18/06/2025 17:55, Dave Hansen wrote:
> On 6/18/25 05:08, Adrian Hunter wrote:
>> --- a/arch/x86/kernel/cpu/mce/core.c
>> +++ b/arch/x86/kernel/cpu/mce/core.c
>> @@ -1665,7 +1665,8 @@ noinstr void do_machine_check(struct pt_regs *regs)
>>  		 * be added to free list when the guest is terminated.
>>  		 */
>>  		if (mce_usable_address(m)) {
>> -			struct page *p = pfn_to_online_page(m->addr >> PAGE_SHIFT);
>> +			unsigned long pfn = (m->addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
>> +			struct page *p = pfn_to_online_page(pfn);
> 
> If ->addr isn't really an address that software can do much with,
> shouldn't we mask MCI_ADDR_PHYSADDR off up front, like in mce_read_aux()?

Would that mean no one would know if the mce addr had KeyID bits or not?

> 
> Maybe we should break it up into address and KeyID _there_.

Could we deal with any tidy-ups in separate patches?


