Return-Path: <kvm+bounces-53141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC2BB0DF91
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0878B1C80DE4
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B222EBDC8;
	Tue, 22 Jul 2025 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CFEAcCFy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3550B2E3B1C;
	Tue, 22 Jul 2025 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195725; cv=fail; b=gBkvfoNGcDn9SauoDK2OsQfoTbUjAa6w6oey4nYukvIU1bdXHycFwA0k1BeLQpk78uzQfchPyYcZSC24cSLar8/2qHyKeHIyp6/YVdCUpb9agUM4FkSy0LaB4LxiYOIrAqnocbb7EgA27Ee9iQK13udHSxYNm0jKTm45HZpB9yY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195725; c=relaxed/simple;
	bh=NkUE6t9mZB/gnCu6mPVEmBfk6LmzwprTPFZb2blS76c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Cz1huNKpq01mjsURL2TYcliuSNJ/PDztmLodi0wu8dQGLpD52zfOohzTcxNu11oBZm/Pz1ZvnraqRMBebySGU2rblozzu06PUT664cyNumxxjStqPnbWELjPM5o5k72Y0v4GwngeD4b4MB+nGtMHUqxpij/BLKOOkdkBOpiRNjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CFEAcCFy; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753195714; x=1784731714;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NkUE6t9mZB/gnCu6mPVEmBfk6LmzwprTPFZb2blS76c=;
  b=CFEAcCFynw6jqFPuh/L3Nh6EupprfRSS1m6v1xhlsF1yht1f8p+ZqUOi
   AvMOY6/XhPQpG1ght9aaT4jC3DJyzpRBX7KJRtZjY1dNtXU7e3MDvpyOd
   xAeKLsTQT0SZ8JJnS4O0LM4UNoeFjevqS/Npm9z7uxjrJbEnEUpK+K3lB
   g10M6b0YOXu92k+mdySe7Fx/OZ0u00FbeJjr3/ZOtdgWvpjoDAdPSlnDr
   6b4LmbF9Te1Jirf95ys8N8HdleJdmKsmOSJ53DihPw1Ru+gcs5R0gIEC4
   rEKQMhLN2budJ0K12KO3u8AW/YTIhnZ7xt2T4vq70mIFbwG/Wnsztd0xf
   g==;
X-CSE-ConnectionGUID: m8gUK4UkQFG6MvbTwTbNqw==
X-CSE-MsgGUID: SsEF2OtKQauN1u034xJ7KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="66015193"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="66015193"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 07:48:34 -0700
X-CSE-ConnectionGUID: R2DX491+Tyq9TM1gG+K3VA==
X-CSE-MsgGUID: neZOeYTkSrSJxI2d8AY1pQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="163201466"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 07:48:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 07:48:32 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 07:48:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.45) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 22 Jul 2025 07:48:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MF3XwJosU+Y8yOWsZVDOIj5dohGFnjmK8C5ftN9yK3MSnCerzWFzofDd4I63Ye46OkEDncqSIcdxw1kWBi2WNsUXdQEAHTdmD/s+dYZTYxS8Oqd0e7UOR2U4vLnKCMAd2LDXRNbFhO1yYLGQ0QYkOxnwNY4jyYxx0E3VuwJySPTe+CQ5W+0Xsv/EGWjeqf9k8GLHAxgSqoZrZbdF8dfclv6pIGxUVSvRbgz1ic6azzU8ZHOD5+RWlgc9UaosWSBcySiVxfU3hN0Tx0yj6Nb6VMyxubkuwshALMxx1PkqBAUQqWRHqaRWPucUs4FVzqAVUjQxF/VKz2a5XKb2CCVtSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3qUXwheNIp8RLmrjb0XXmruq/kVfNsAf/3h+++CgF8=;
 b=t7nNJz9iF2/IUNhapa4aJNQAOAChaR/VGDkOOB2UWcG55spkI4rUqODdrET5LqTMMssxaiQFAdZ5N+QKJkbZ9gwVd5VYqRhXa0xC925KVqp8WnwAqshTzsabcc9T1P+hMK+/j5925KJM7aOmZFGbXl/mNI3F3BoLb2qyMaEHhl8liz+XsK3AAvfr4+PYSwRPyBI1SjMTRoyCANngWRgZmOKuRWuauNwpiM7tIuKxXy/yMEJZhQHimd3YPGrJtzftvXgH4J+fb9ZeMhdtEXx04J/OHLu1f2E1Xu4ztj8Yeg+c8RFGTeC2SflicdDeL/t2uyrufkuQ3mziPxFZCnu5Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by CY5PR11MB6092.namprd11.prod.outlook.com (2603:10b6:930:2c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 22 Jul
 2025 14:48:29 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%4]) with mapi id 15.20.8922.037; Tue, 22 Jul 2025
 14:48:29 +0000
Message-ID: <d0a42336-89ba-4317-9e0b-7d51a09b1567@intel.com>
Date: Tue, 22 Jul 2025 17:48:22 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
To: Sean Christopherson <seanjc@google.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>, <pbonzini@redhat.com>,
	<vannapurve@google.com>, Tony Luck <tony.luck@intel.com>, Borislav Petkov
	<bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250722131533.106473-1-adrian.hunter@intel.com>
 <20250722131533.106473-2-adrian.hunter@intel.com>
 <aH-b5UAkokFocLvG@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <aH-b5UAkokFocLvG@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0300.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::24) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|CY5PR11MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e669830-db9e-4482-a741-08ddc92ed211
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N29ZREZ6OUJETUNHbURDc0prZlk1ZDlXaEdnNnNqbll6UGhCRjkzN212ekQ1?=
 =?utf-8?B?dFlGbktHcFNXNElmM25wcU44VkxhSDk4TWNueUZyUTMxRlhjaWpWSHVnWTZE?=
 =?utf-8?B?UkFHV3J5ek5VQXNZdU9GV3ZNdW9iNkRIUDZwY0QyNEFGNm1YMnVzQXM5Wi82?=
 =?utf-8?B?blh0SXY4dG5pOW5TV3pKT2NhTksrN3NwS2taYTAxQ0Nlck0yRzFtWGJreHlm?=
 =?utf-8?B?bml5VWlseXk3cEVqQ0VIZjgrWUQ4UXFaZHFQVUdyYWQ1SWI1ck5vT3FZUU5R?=
 =?utf-8?B?RlF4MFlCeGFNWjJaZDh6TFpKOWxSbWg2a0s0UGxXSExtSUp2a1J3QTQwTzYy?=
 =?utf-8?B?Q0N4S2NjakpELzdxZDRhRXgrMUZxTmR3cnFXMlhHZmNDamJ2YzZvVmFyUU95?=
 =?utf-8?B?Q1g0R2ZZSnp6S0o1a29nWUlGUE1KRUs3MnF1a29QNjBPZ0VsWVRHb3ZXOGlr?=
 =?utf-8?B?d1d6ei8zemc2dTUxck5EYUhGRlFRMER6Wnp5VXd3VEcwenoydWJqQTE5dEx1?=
 =?utf-8?B?MFFmWjZaUDV5ZGpFTGRKNDFRdlEvNUVHVVRsMTZNVHBrV1hoWmxGLzVNMmh1?=
 =?utf-8?B?ZEFSVmY2VlQ1bHJCZDkzY1h2RjRHSnd1bnpYVFJ3bFo5L1lLOURTTFlxMU8y?=
 =?utf-8?B?blRyRWZadEE0SjRDeS9nWXRCVmdyd3phMjEzVDN4L0ZCSWl4TzlHWGN5a0V5?=
 =?utf-8?B?NTQvd1NlbVZJZ0NJZWpEMFcwb0RzTVZQTmljREJpeHJHek9HQ1dnL1BTNDlB?=
 =?utf-8?B?QWFrM1V2RHkyRWlzQ2Z6STdtM3VnNWl3OGNBR3NsdUo0dk0yZ01YcjQxZENw?=
 =?utf-8?B?NWNLL0x3U3B2MTEzUEFqNzVKYTc0Kzl6MWh1RWtVVW5DQmJRdW5ybDduZFlR?=
 =?utf-8?B?VnFKSG1LUDZrb2hCNmNXdWdzbnhVSU5ZZmdEN292NEg0NjNVMjRQc1N3WlBL?=
 =?utf-8?B?cS9qbk5QR0FjTitNK0xIK3NudzR4YzVBa0o3TUYzT0cyMzdwTzBYb3hIL2hQ?=
 =?utf-8?B?eGNLdjVwNW5SY2NFMzVkZ1BOaUNtdUpONGJ4cmg4RHJXUlBGMGNmYy9ZV3dH?=
 =?utf-8?B?bHU3bGVEVlFWa042Yk9odm1TdW5DODN3b1hnNWEwVmoxaTFBcEZMRU15djBU?=
 =?utf-8?B?cVFCTlZMWUlZRGNpZmNIcjlmZlpzYnBQTE5YSE5xTzJ4b0VwODZaZXZBRTk2?=
 =?utf-8?B?TVlWNzBEWnFyUldtem1tTHQ5TzJFb0h4NWlpWit2amIzamhPMW5ydzRmYzJr?=
 =?utf-8?B?UHdNNE40TUtMVTdzYjBPRG1DWm14cE4rRjRoaThDZDNmUWt4WWJRYWlITEdP?=
 =?utf-8?B?Tmp4Wk1Ca2VUSTFUbVR5ci9Ydm55ZzVrNlRlcHVVSTFwQ09IZDBGNlUrM2lS?=
 =?utf-8?B?a3ZuR1lSOHB6QVFiUXp1ejBRdjhSbTRnKzBNZVBBSElWaUF5OXZNZ0xZUUJ2?=
 =?utf-8?B?clV2UmxpbEZabGowTVJTaENtRkt6L2dJa3RONFZxc0QyZ1VTd2Y4ekJaT0kx?=
 =?utf-8?B?WEo5RGNIbTVhUUdTcCtadFJRNlN1RlZ2QXFzVVJpZW9rME5yT2VkTHRDS2NF?=
 =?utf-8?B?VFAraXRuaTdmaTA2TU1rUGxXUzF4MmZNcHE0SVcvcVQzM0l5ZGlPTVE0cklm?=
 =?utf-8?B?QlpTY24xQUtjK3h5MkRuejVJUkMxU1ZHTTl0bTZteXdiL0JlQ0syUis3dmdy?=
 =?utf-8?B?YzlJQXZ0UFlqMSttN2pkem5LQ2h4cDRhY3NHUy8vVXlTUng3aVkzaVVIRXZx?=
 =?utf-8?B?YTZLMkpOcm43WHo3RSszdGNYZm5QKzVra3I0NmNOZGl0aHBvUXI5SmxJaHgr?=
 =?utf-8?B?R2IzMzlIak9vdWtmdXBBNlVqYm1vT05jNG9jeURLb0N4NUZqekpqcU1CaXgy?=
 =?utf-8?B?S2JicTJtTFZsTzc1VUMxQmJOL21zdHdPZkw2clpPZzczclpUVndHWXByMFdK?=
 =?utf-8?Q?hXyXLCllKu4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnpQbmx5R3JUMnZvZHRNdm1yellwNjZraXdPN2xWNGswRm9Xb2pmajdEcThx?=
 =?utf-8?B?bDltY1hMUHlNdmQ4S0h5bVN2ZE15bmw0dHdUbE9HNDRnSkhwQWxXZHdnUmEz?=
 =?utf-8?B?QzFvM2U1SXJrNjZvMURxOHl1QVNjWVprRnpnY1lhM2tvK1Q3c3loS2kwWCtY?=
 =?utf-8?B?MDZsWU1RZldKdFc3S1pyeEhTWHYzTlNma042alZOZjZMV0dSWE5zeEg0cmtE?=
 =?utf-8?B?eWE3UFhwRVo3V3hhdnBFZEhmSks5dnBFaUpqVkRiUEQvOS9scjZlVy9CUDdV?=
 =?utf-8?B?Y0lybVMxaXlXMkdKVzBXZ1NsTDZrdWRQUFNyN281U1dDN2gyY2lwNUVTVjFE?=
 =?utf-8?B?MFJVcXNFS2NJdllIRkVya3AwdzVpcHFhRkpmd2RlR01LZW4zSkQ4Zm5yUWZo?=
 =?utf-8?B?c2dvQTloL09BL2NUVndETGVhMlRWT04wakFzK2pNZklORzFUMzBzVm50bDZO?=
 =?utf-8?B?aG1CQm1adTI3YllsbWNYY2dCbEs5akJ3QzFnTUFNNCt3dVBmQk1YZmY3NDZ4?=
 =?utf-8?B?bC9nSGVESTZDNlhyT1ZDQkUxMFJIOGltZWhlOERnYk5pRG1ZQ3V0ajV6eDBB?=
 =?utf-8?B?TmJ0ZXNsTWl3SUd6UFFMMlhJU1JhR29HQkNML3RGbVI3ZFBtNlB1UlNTVTJM?=
 =?utf-8?B?RkZFWkQrWEkxelNsZGtsL1g5b1F4aUFHRzgwbUE5VjJmZGxpempPV28wUGhH?=
 =?utf-8?B?cWtFMjhIcWRSQzBMUFZTUFNsOUNzVFBNb2tPd0Y4N0FVZGxnZEh6bjZkVnFm?=
 =?utf-8?B?N203MXpKVWxUTFhlNXlQYU0rZ0FSdDN1WTU1a2FCOEdVZHVlbFFvUlhXS2tr?=
 =?utf-8?B?V0hnWlArWk5jN2pFd0JHUFk5RGVONEMva2JHZUNQTnRuaU11d3FmcDhvVHpH?=
 =?utf-8?B?UDRUclNSUGJzYTVrOFdPaHN6eGI3WFp4eUxhUGdTK0dlcDBlM1VoOFpXcGU1?=
 =?utf-8?B?NUxXN0NxWGFmeDNzWGd4VHg0ZWlqMjNoNHZEaWlYYmFFVUM3cmNNb3ZiYlRL?=
 =?utf-8?B?T3NhdWtENi9sQVhkTy9Fd041OTBuc2sveUtRdjdWaFptdHhTYkJ2Q25xVUxB?=
 =?utf-8?B?ZnFCQURlNFk4VjFkR3c1ZHVad2hkUUE2UDNwUCtHSGFNRE0rOFhObG5lNFc4?=
 =?utf-8?B?T0dyVHR4VmpBM1gvYTJUd3F0L2J2MjBOTjV1Sno2WEg1K0ZlMnhXTkpNNXcx?=
 =?utf-8?B?bUUzYjdaMTREZlpmNUs1VUlDL2ZGZ2RLdTZhTDhOeXF4SGZIUlY3Z1dwcEFn?=
 =?utf-8?B?aWd1UUhxRWlyUDM0aHdKVElmVUZvY1FuRmx0VVhrd09OR3Y1L3RKU0xGNEN1?=
 =?utf-8?B?TVZUWTlvcCt4a1FkUjd1T1VodVMxdXNBSjZ0M0cwZExCZXd4OThmUkFnOW5F?=
 =?utf-8?B?T0U2MGxYWk1FK09EL1FtY3FEVXFGcVByTzAwU3R4SnBrQm9rbkJUaTVJZnkz?=
 =?utf-8?B?dlg3QkJ1TXVrNzl6MXNpYU83ZzJYQlgzb2dPams4Z1UyQzJ2M0FwWlgzRkVN?=
 =?utf-8?B?cUZYaW9DTzIyMzVKWmtqSS8zVjFPRHdCeXBuM0xkVHV3ZGRGUlJoVW90bUtm?=
 =?utf-8?B?SGh3QmcyWXRzMUQ0TmpuUzhMVWxPS1lVNkZLQ05OdHlpME1HdTZQYXVzSklv?=
 =?utf-8?B?Sno0RE1pOHNLV3NvUGZhTkJBWUtkdnFhdlQ2ZmtSV2J0RHdveXJYOWR3UHVw?=
 =?utf-8?B?VEM1ZVRXR0p0czhXcVlUUmk1cmZVbkxRYmxNaFVpTEduWkJDWEJQT3hhSUJD?=
 =?utf-8?B?N3BheE42SVpTR0p5U3N4Zk55d0R5MUtza1BFLzkvaENvTVJHSndObVdwa0Nv?=
 =?utf-8?B?OG9tUlZmRjQ2WHpTMlZxc1o1b0NidG4wd1JVSS80QVpLeStQb2s1TXlDNTVu?=
 =?utf-8?B?ZVFFakVkRXRtb3BUb05WQW9UOHJTRkVTT1hOb1JHOUJZOVlrZnoxcGpORFdL?=
 =?utf-8?B?cjZjZW92QWI0em40bkljM290cTNLWjFJYjlOT3llTURrK0xmQ3lGcFNuZHRU?=
 =?utf-8?B?NmMrbnRsSTJDUFpmUHZZUEJOZlVVRW5pRFZUN2Q4ZlRSU3dwTC9ycXBrTGxU?=
 =?utf-8?B?SFFqU3BrMXUwR0Y2VHVDb1JDZjIzaVlSeC9GU0tYYTJ3d0VheU9hMzNGRkZu?=
 =?utf-8?B?Q3RGdFZqR1Jmcmg4YXRER3k1OXNWSkhYb2VicFppWWVtdmMxb0o3Q0FadGVE?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e669830-db9e-4482-a741-08ddc92ed211
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 14:48:28.8774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Tf3UJ1Eib+od9hmZa2RavtMPI4U3RhYVhaUlRS/xI+Wf1T9IKeV6aoayabRiRw6IXk0BimHxZuwq8Xpjni+Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6092
X-OriginatorOrg: intel.com

On 22/07/2025 17:11, Sean Christopherson wrote:
> On Tue, Jul 22, 2025, Adrian Hunter wrote:
>> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
>> index 7ddef3a69866..f66328404724 100644
>> --- a/arch/x86/include/asm/tdx.h
>> +++ b/arch/x86/include/asm/tdx.h
>> @@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
>>  u32 tdx_get_nr_guest_keyids(void);
>>  void tdx_guest_keyid_free(unsigned int keyid);
>>  
>> +void tdx_quirk_reset_paddr(unsigned long base, unsigned long size);
>> +
>>  struct tdx_td {
>>  	/* TD root structure: */
>>  	struct page *tdr_page;
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 573d6f7d1694..1b549de6da06 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -283,25 +283,6 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
>>  	vcpu->cpu = -1;
>>  }
>>  
>> -static void tdx_clear_page(struct page *page)
>> -{
>> -	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
>> -	void *dest = page_to_virt(page);
>> -	unsigned long i;
>> -
>> -	/*
>> -	 * The page could have been poisoned.  MOVDIR64B also clears
>> -	 * the poison bit so the kernel can safely use the page again.
>> -	 */
>> -	for (i = 0; i < PAGE_SIZE; i += 64)
>> -		movdir64b(dest + i, zero_page);
>> -	/*
>> -	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
>> -	 * from seeing potentially poisoned cache.
>> -	 */
>> -	__mb();
>> -}
>> -
>>  static void tdx_no_vcpus_enter_start(struct kvm *kvm)
>>  {
>>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>> @@ -347,7 +328,7 @@ static int tdx_reclaim_page(struct page *page)
>>  
>>  	r = __tdx_reclaim_page(page);
>>  	if (!r)
>> -		tdx_clear_page(page);
>> +		tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
> 
> This is silly.  Literally every use in KVM is on a struct page.  I agree with
> Dave that having a wrapper with a completely unrelated name is confusing, but
> that's a naming problem, not a code problem.
> 
> And FWIW, I find tdx_quirk_reset_paddr() confusing, because it reads like it's
> resetting the address itself.  But if KVM only ever uses tdx_quirk_reset_page(),
> I don't care what you call the inner helper.

As you say, Dave's second option was:

	"The alternative would be to retain a function that keeps the 'struct
	page' as an argument. Something like:

		tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
	and
		tdx_quirk_reset_page(struct page *page)"

So I will do that for V4 unless there are further comments.


