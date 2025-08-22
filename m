Return-Path: <kvm+bounces-55487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C08B310EB
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 932D71CE4C4C
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C684257820;
	Fri, 22 Aug 2025 07:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZlSBlY9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B622D249A;
	Fri, 22 Aug 2025 07:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849474; cv=fail; b=YQqL2a3YSycSuiU8PbcEb1r8bA84I2ExaLjntgdGRT5fueuWeAbX8d3ZAqnLMRI7Pc/jb1RlD0z68aLbZmH/9eAPpPQR0kvdhsmfiZl6jBACRsqB4oHnttRGBGqdJtoNd9eeQIDGsctB+9K0B8vBTmU6zXF9Aw6nn+AtM+6oG6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849474; c=relaxed/simple;
	bh=52xGmFUuMKmpOkNGlEi1M/Wzvlj3/yJcJCY2+wFzDzM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EBsbsZx82rtm1WOr5HrDV/ZGT5vKKjquxQlSVS5y2CKQeFeU2SQqNGNS72s2jAi55MfAJCqajxFEN49wUI2bnP8yRpMluOoBybP2DKx9mGcvRmERO1Od2ziqn47KBoIRmjdtPUtjo8H1uXWV/fPEl0PRJ3EjGO3LrtKqdsC44E0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZlSBlY9; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755849473; x=1787385473;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=52xGmFUuMKmpOkNGlEi1M/Wzvlj3/yJcJCY2+wFzDzM=;
  b=bZlSBlY9z98TE658D7Ezu8sOOTFrN0ynizHp5N+JYOcUWhAKxn3z7G+I
   1fLxQFFekPBdF87doWRNUkLIEcOHAs9K5tjZoBOMUxXe/DTBXs5VtJYgp
   IHNfJ0WdXcD5Ei26NF/CJb44WEDwVFduLox0a7okFFWI9msNoLoWlNm42
   SiNZBpXGAJ/D7wAwcVePOEbpzEBhqP5jvTEewlh/VKrLKph/64l1gxOK0
   eM2906TtaVnbOKV7z+kEM4vgAL2PhP087v8/Lmq3I869kJMheIv6TERcL
   qs8dasDSWyBtphLlLywZtCoHgF+YYzHK6TmfjfQ7uwkc2QxHwFOs0caPi
   Q==;
X-CSE-ConnectionGUID: OXEmEZiKQoGtdvuVdvN4hA==
X-CSE-MsgGUID: NEQWGSK4QheK/YMfGeAYBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="57354502"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="57354502"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:57:52 -0700
X-CSE-ConnectionGUID: swQAL1yyRPW1qSXIrqZLrA==
X-CSE-MsgGUID: 4yoo0/RxTvCsOpi/IfgrRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="167882841"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 00:57:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 00:57:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 00:57:51 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.79)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 00:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pfBsOzMx+Wteu8D4Gix8/x4RPKeUdKxXLniEpkaolVHqJ577SSYLcP2FMjq6EEQ11FMVE7Ga8bm//Wk/oEeWX6QaRiFvo+HSyUKOsRRuhEIBBTZQe1fYRsEQ9DBedKOSDgY3x6ouculrNaaDfr5iP2iDldmTHAnx0N8I3XuJmi+pm0T3S1Auz/14gbU8yf5fAZlD38fJC2ZP2fKyYNyTRY+MfRejYYY38BqmALUesW1TgaYMlO8MhBOSCAtyHLSMHAD7BINCn5U1N2DHxuHPasvjPYTX++RZjOriK/5JvVRV3mCW05eLioz3R15rBgck9xXGPq90nfYdxnrSuYTo7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rsbG8pdriAeIUD0slj/f4EC5Xq/mqkLA6nl43s0PDg=;
 b=hzME5D0V0PQOF3Gge/pgpovp7TN8dA6JuZWwcW4eC7hlOVLtONudbEVttHuwgLf7KKBwI7ERFFmiVskPIe3GHoC1MaC7RLNQVd/GRGyZo/VA+nOfrzrohPh1m4hkj4Gz3h8oNJVJiPTSTgwPm9spZ3DN74Ne8t7iwkpbkjgOq5t7/tY/ghfm5vghAOyQm3PpqiXNjXYvtqeZUfyvALC2NBfbUxvF3+hRutmdVE8aeAWUlElFtvlThLPCWcWW1nRaFslxwe46gFm9/qDSM4gDDKcCsvr7XDyz4OevaMTdHG+hANMTpCKCP5+LuvsrURT+C/XKuOhzuuTmnWNkU0kr+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by LV3PR11MB8696.namprd11.prod.outlook.com (2603:10b6:408:216::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Fri, 22 Aug
 2025 07:57:43 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 07:57:43 +0000
Message-ID: <441aaf76-977f-487e-9db8-80edcda6078f@intel.com>
Date: Fri, 22 Aug 2025 10:57:36 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
To: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vannapurve@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, Fan Du <fan.du@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, <yan.y.zhao@intel.com>,
	<chao.gao@intel.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
 <10587d02-1133-45fa-9ec8-2288a8868b68@intel.com>
 <20250821132521.GDaKceQXfEWHVwrlxV@fat_crate.local>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250821132521.GDaKceQXfEWHVwrlxV@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0074.eurprd04.prod.outlook.com
 (2603:10a6:10:232::19) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|LV3PR11MB8696:EE_
X-MS-Office365-Filtering-Correlation-Id: 1556b885-1b4a-4158-4bba-08dde15192f0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S0lGaUxBQzVZbThlWWNDdTBtWGc4ZDh4dWZqd1N3TjRibXNDQU5IUEdmQjV6?=
 =?utf-8?B?NWtid2kxTWU2WU9VMFJDMUwxSlY3M2M4cGFsbHNYbE5EVnZyL3dTeGVtV1dv?=
 =?utf-8?B?V2ZxRE5QczZjNTJ3S21HbDlsMWZITXpzY3J0Zmgra3hVYURuUy82c1pSaXg0?=
 =?utf-8?B?ZzRNekRQVEZhZTRMOWM3UUV4SGhtSDE3dkIxMU11OUhPR2RrWi9jbUM0cnRO?=
 =?utf-8?B?NHFEeXY5Zmg3ZXRNRHRuSGNIUVI4N0puTXptZHF5aGFEZDNmM1dGSUU4S0xa?=
 =?utf-8?B?amVFMUZRM2QwWnkyYU41ZTduZENXYW91TUQwTFFiSEJ4aXRwOXVKSFlKWS9y?=
 =?utf-8?B?S0NTTnpMMTJBV01ySDhrTDdqdzN1Z0FsTWZaUWNONjZLUXFCR1VFK2xRdEQ2?=
 =?utf-8?B?aHYvM3Q3bDJiVnZWQUwxMklQMEtiTmlseEdBVHlidlFiRHp3M1RkNURwNlVU?=
 =?utf-8?B?S0JWVTJFOTVFbGZ1d2xvdy9yeVdoMllSWXpzN0FORVIyL0pKVkNEem9kaVVI?=
 =?utf-8?B?cE1Yc29KczF3Nk9QZklFNjhsWC91dkV4VDFna0dxNldZbDJ5RXhUNC9MT1Jo?=
 =?utf-8?B?TU1XTWh0dllJcXFPSHhLRHVLOXFvLzNmWVZKa3pTVTVnWk5mTkNuaWxWdWIv?=
 =?utf-8?B?VDR4MXJzN1JITGNMZm9WbWRDYzVyZjNYeHpqdUhPQ3FRTVN2N2ZmaHBwNkpk?=
 =?utf-8?B?UnlZNmNEa2NzZG9oMlRqeGdhKzF3c2lJa294MkpYZ1ViRUYrdEEvTDZrczhV?=
 =?utf-8?B?L2FJN2x1WXU1ZnNQSEFJTGNEbEpXcjVOS3lzZDNNeHlmVVZGalJBbDAwQ2hX?=
 =?utf-8?B?c3pBUm90OWlOM1pHcFA4QmJtMzlkUnMwa3o1MUtIWnhMRU9tZEF4VUdJb21Z?=
 =?utf-8?B?eDBuTU9wNWkydGlLSGlBZTVxNGdWREpya21pNmY5cDlnN1Q0bFM1WGZySzln?=
 =?utf-8?B?d2V0OU8wdWkydDR2ai9MbWdkWXJGV0NjM0laKyt4amVJaW94ZEtZNXUyb3BV?=
 =?utf-8?B?NlpTTlM2SE1OMUN2aVR6dWFPL282bTFKUWNIVmNnVG5XTXNsdGhkank4bERN?=
 =?utf-8?B?VGtSVUVDVEFLdHExRU5zSnpZRW5SajN1WEs3L2tFV2plOWJqMlhydU8ySDRx?=
 =?utf-8?B?TlQrby9ZN0hxZUd2dTRmdzFjMm5xdHlHOVYrUUErT25zaVlETDN6M2I0enI1?=
 =?utf-8?B?L2hOMXNDc0VZbEhuRDMzZXZUR29YazcyaHphb2VCbkE3Tk1EeEgvMEhLRXd2?=
 =?utf-8?B?dFZ2bnkrS3lTWlEydzNzdXpxZ3VuQXgyNk0xQWd1TGQzNTRVdGNodWtBbHpB?=
 =?utf-8?B?MndGN2loWVdEbklPdFNSdnluT2xzZEhORk1tYTZKL2tPRXdtQUxJSGVmNEwv?=
 =?utf-8?B?a2MrRmExNFZxb1BnWDczZkhTT0xINkdGbjVaNWNaSG02S0JzYllacmtpVHJK?=
 =?utf-8?B?d25TbUNjWnowc1ozYk15Y3AyZkFDekhJSkpsZ2U3bGhiRURyMHJoV2hTL3dt?=
 =?utf-8?B?bSswTHZsVGtTTG5XNnhhY3h5SGVmdWxzSXBXSUIzU005My81YVErelNPTnBC?=
 =?utf-8?B?WlFERlZ2eGlzaUhYMkFwLzZXVHA1bWhCbUdoS05ZNDFZakZyNWYzRTJiM1Q1?=
 =?utf-8?B?QWlyditGdzRTeTZsbW1FcG5iRzM1cnBXeFVOTVdDWXlDRXIvVitRcHhhUVlT?=
 =?utf-8?B?ZGI3L1BIY29HSU5XK2JhTWVKL1hZcEM3YzljSzdzNVZrSjZMU0lNNlNDWWZX?=
 =?utf-8?B?UUdlSE9Pb2xJQTZoL1NNS0Ixdko5c0FFZzZTcjI5cVdRbTVkSmo4RUdDNXhW?=
 =?utf-8?B?Tzg2Q3dsRDM2ODFhaHJQTzBUd1ZMOHk0bTd6cjRpTmcvQ1dDTFo5THFGTG1q?=
 =?utf-8?B?clJIL3pMSmRvK3NNV3BUdFhwOG5PekVwck5TZmJ5dnU2U0FHb1lHRnpvR0Fr?=
 =?utf-8?Q?PQcsSj4fNgg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akxyaXFtT01xMEkzVkVLa2tpKzVmZVFielE2alVnVG5kVkpiZnJPeXZXYlBp?=
 =?utf-8?B?ZFR2UENpSUpiaXVtSkMyUHVtOVUya29TTVZmcDIrQnFyVXhQOHhaRXdVOGZs?=
 =?utf-8?B?ZVU4SUNHYWQ2T1d4d2hsRDBRcXpiNkZtY0lvWExsVjZxbDlSWGtpd2h6eVlX?=
 =?utf-8?B?Njl6Q3QvMWczaEg2Z0lSSS9WejdNMEFaNjBDd3hoU2ZCbkpxczVGdTNMTkRa?=
 =?utf-8?B?R2tHdHIxV09vRkt4b1g3bWRETU1TOWFYaTRhTEVEalcxQ1VrQ1oxU3JMRExj?=
 =?utf-8?B?SW13WnVZbWJWNGZZWlBtSmwzeWtvUnpxVnpMaVhZUFBES0RiOHZHRkRBUXlH?=
 =?utf-8?B?dzg1WWFmQ3cxYkVOYVArVlY4RTNCWi94WGwrMHJXYk5xd1B6ZmF5UUh3blNp?=
 =?utf-8?B?ZTg1YzhWSTVoOXF4SUdJUTVhMFVuRVk3MTI0bWNJK1NTSUNadFNYWDAxeU1T?=
 =?utf-8?B?WldVWjdJZTA3WDAwam8wRTgvZHRrWk9zUm53dUxuQnNyZGlQZ2NKak5VSGR0?=
 =?utf-8?B?VUtDS2dFeGFyYmVYTGpHR2N0TVVkbzVaN2RCMUNtbU1MUHpXT3g3QjMwREFV?=
 =?utf-8?B?dzFNeXJjcHVDTTdIZHdUcEdKaXRCcmpJTTVBOW40TStxVjNCRkhPRHhuZUlu?=
 =?utf-8?B?a3ExS0I4U093U1V6MkNRMHB2b2xmVTBteDdmVGFrTlVyS0MyaDZMZFhZNFQr?=
 =?utf-8?B?aVc0RVh4TEhPNzl6dmJHcGgrTVRIRjMxejFETUVUWWpOczlmWVV6cGkvbXpO?=
 =?utf-8?B?MlRkZStlRnkxcjE5Zm5sU1dKN0RtajE5b2hkUHh1LzF0cG5DSkF0TlJYRi9u?=
 =?utf-8?B?WUJ5aHFqVmZYa2pvSGM1NkUvb3FSNXVKTEF4ZzdFa3dkRWFzcVpRcGxMOHJl?=
 =?utf-8?B?cFpWaUgxSnlJWVg5QS9pS3VNWTVVemRTTTFwRlFtNVExN1EweGd4Q3dCQVc3?=
 =?utf-8?B?dmdkRjJEMy85TElGV3VRaHBpRmJoRWRCUHRNalZwQXpqSUZsbWxHNTdQS2Nt?=
 =?utf-8?B?ZEk2L1RpUUtDb2ZXUXN3TlRnZXBSbGZQQUFzNGV0dnY2WEx3bm1WaUhRR2ln?=
 =?utf-8?B?OWI1aHdiRFJkeGoxekhiZ09HeU5NUkZnTVlJcGJGVXBuc1VNSmpuSU4zUmdO?=
 =?utf-8?B?TStZT1cyWU5JU0QzeUlkdkd4Zkp6K2ovWlduc2VQRUZvS2t6NE42bmtCYjE0?=
 =?utf-8?B?bjJRZWpUaHdIRzZHYjhXbEIvV2xVeDVLQXFjYWV6KzU3QlNoOG1vVVVjZzlQ?=
 =?utf-8?B?Z1BrNEtLN0VoeENFb21NRFdReTlBWk5BVzFRbWVxakJONnBmamZIU2Fod2F1?=
 =?utf-8?B?Yng0WFhEeklsZ2w3cmRWbzRrTkt2Y1doWnVUNzBFTTJCNXFGQmFFMlBWVzlQ?=
 =?utf-8?B?dVpqWTgxK2hOR1IyK3l1MEV1Q2d6RVNnWERSYXdYemM4WDE2VFlRL1NFaFBP?=
 =?utf-8?B?KzMwY3poWWRiUXZuUU41bVJHb05sMkJBYmZidzN5THVDalpydk04R2I1M2NT?=
 =?utf-8?B?Uks4RUpVWkQwN3ZTUUlxK2JxV1FBYVpHYktjVEg4cXk1MWhDSFN2SnduQ0Q5?=
 =?utf-8?B?ZmpIZGo3YWt4WnFsbS9MZUQvdWVCazlMaUJVczFzVW5WL2o2RVJyVWNGM1NY?=
 =?utf-8?B?QnpSMVA3aGxCbUtJMnV6ZkR6QWloWUp6Zk9YRnVSa21EWVZqMjkzQXBRUUl2?=
 =?utf-8?B?L1pzOHJ2VU1IbkhsbXRlb21kc25hMTIxWVlLV0F5ajZQZGVzVnJ5VmUyeGJN?=
 =?utf-8?B?dHhheXc4YTNSYnZqZGpDZzFZbHVjQXBPekt3R2xBaTA5WW5xL1QwSWxCSlcy?=
 =?utf-8?B?Y2xDM01MN2NMZ0dVdEZDNEdmRjVzNGxPTkd5UUk0c0NDclR0Q0FOVTZ6d0F4?=
 =?utf-8?B?MlJwR3R4RkpSaHRCd2Nxd2duNnNwalZib0lqeUdXbC9OZ2Q2ZFBnVWtCazNK?=
 =?utf-8?B?ZnBNRjE0UGRvT3lUcXJEUHpHV1FmUmF2LzFBSUhaS1p4MUlGZ0wreEFsOHRQ?=
 =?utf-8?B?VXNZWk4zcE5abC82RkVrbzJ3enBzMWEwQWk5U3V1d2E3YXpjU1NTVkF6SW1B?=
 =?utf-8?B?NVowV0kwRUhXTTVMMnpRbkgzdTRPUnBOQkJTQ1pDdTc2dFpDYzVXaEpKelhL?=
 =?utf-8?B?V3grTjJaUjhSb053cVpRV0xTYWVpTlBUMWNKbEF2ZGlkNzNrWFFJOGs0Mzk2?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1556b885-1b4a-4158-4bba-08dde15192f0
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 07:57:43.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yNMoPW6NdMsT0JeWeNyR/zjXvHt4SMv53GHFwKSq7dqHAxiwggHbXFfkjH2bRs0byAMQMVIFJ7IqZaJGGwWww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8696
X-OriginatorOrg: intel.com

On 21/08/2025 16:25, Borislav Petkov wrote:
> On Thu, Aug 21, 2025 at 10:24:22AM +0300, Adrian Hunter wrote:
>> Something like below would work, but doesn't answer Dave's question
>> of why not do it in mce_read_aux()

Thanks for looking at this.

> So, let me see what I understand from all this bla: you want to zap the KeyID
> from mci_addr because it is completely useless there. So zap it.

Not exactly.  I just want to fix the bug whereby the mce handler fails
to mark the affected page as poisoned because it does not remove the KeyID
from the address before looking-up the page.

> You can't make any other changes to mci_addr because that goes to luserspace.
> 
> So far so good.
> 
> Now, all that other bla leads me to believe that there might be some need to
> dump the raw mci_addr value after all.
> 
> If so, your patch is not needed.
> 
> Which makes me think, all yall folks need to make up your mind here.
> 
> And you need to get rid of all that extraneous information in your commit
> message:
> 
> "Investigation of user space expectations has concluded it..."
> 
> No investigation needed - this is exported to userspace so you can't touch it.

It is a bit of a grey area.  No one expects to find non-address bits in
struct mce addr, and the kernel already strips low-order bits, and in the
case of SMCA, high-order bits too, refer smca_extract_err_addr().

> The one and only question you need to answer is, do you really need KeyID in
> it or not. And whatever you do, once you do it, we're stuck with it because it
> goes out to userspace.

No, the KeyID is almost useless.  It is just a dynamically allocated
number. It might indicate which TDX VM encountered the error, except the
MCE is fatal to the VM, so a fatal error is reported to the VMM anyway.

However, it is allowed to extend struct mce, so adding KeyID or
raw MCI ADDR later is quite possible.

> Especially if you want this backported to stable.

The bug exists in stable.  Ideally it would get fixed there too somehow.


