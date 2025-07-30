Return-Path: <kvm+bounces-53729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43DBAB15E86
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 12:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C04F563498
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 10:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD6D292B48;
	Wed, 30 Jul 2025 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kUuGo8VF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C972239E81;
	Wed, 30 Jul 2025 10:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753872937; cv=fail; b=FubMr4NfigvDnnGnXBHmPGFZ2v3Sl0ojM3qiVfPniVEzr+U1JA5SAUlKBXDI2rl6LeSsZa7ig+Tk/0EsclCBjW9oQKNurQiWnwHkYOvDGkBCJi2ePjL7DxgGMnp1NXXPp+CDw9fq322dj9+jOokb9OtZkVxctYhiRjDh9hfzWh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753872937; c=relaxed/simple;
	bh=kS7saIUXLz9fKiMO7/Gr/zpUc+n7NvY14ExK/l/0EAM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IjbcSMknhZAbGHIZucJ29rdnCaSdW+XAG3KUbx4x+A2PvqhsfoKpbqaqH3m1pOzICBcTRa+FXRWWwa5bRNwzd8JJpwTEqSb6a+6PppvOwyj2ETdSDr87j3hGXN3HURxf1Sb4TuVXZ1CtP/C67sfmZe7m3DWNgBZMAK9pFNSt7BU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kUuGo8VF; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753872936; x=1785408936;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kS7saIUXLz9fKiMO7/Gr/zpUc+n7NvY14ExK/l/0EAM=;
  b=kUuGo8VFEVRkSvyb7Rx3gKpNJLTqf2Ll+o1AOghypnXjFr7quUJjtGSd
   7dUdYIJ9cGVDoDp5OdYdv86lAygq1n0r/zsTJYQFhWgfx0/Al/xxChSVZ
   bwlqgTF81pbcK/0lFxgQXGZjl/FTHbPafPH1OPZSHp+cgmjW9apKL5DkE
   6DIN0IEN4CDX0Ek11GjPSASJyeRoGhRr9TKb7LJHBZt+PX3ZjpTo5JuFB
   GgVRYtEZEV0/Ts9nK0L4hQp1GdOYLDg5Bb9i21O9fHd+WguUy1xepCQ/A
   GuARS0/GE6Z3+39lV8d4bxzwAxs3PMBMIuUhkjwh+PbofmRzmbxDrxzIq
   w==;
X-CSE-ConnectionGUID: 1S5AEnPpTuiRq696vpB07A==
X-CSE-MsgGUID: UT7fQQpRRieEB1i2h7SlNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="66441712"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="66441712"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 03:55:35 -0700
X-CSE-ConnectionGUID: AMd5IcnoTjSqN9cX9P19eA==
X-CSE-MsgGUID: fB1bytqIR0yNXfKlcC0CJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="163406831"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 03:55:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 03:55:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 03:55:33 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 03:55:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yj9Mbf59AkrE/ax+TYfoFEjSjEbU5/XrkrCtxsNOGWmzULsf7Uy1V4ZLO72CG7NnUsRg4m1cHW5VAVAqNCy3dW9cHIGn/cIp0i9VkUH1WGDvz6RtKHegccEXTremtYtHqSC9X/qGqu89RFKEr6ADz8rJ/mOYRqQKsgTJlHeyMVhh2X15pjmidyK15xrrktEysceRXWQZApB4VrR67/nuJoZ7PF8pVFizaJdZkkT8/HyMkbSBaj7JSAgQPA1z9y9Ums0QoTudPfKKtMT+Dpow3xom8CKkfi5nwcRZADmQnQv1TslejZu2ez7pu6Fq3adMjFYJp46JSxdTfY+kubQjnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/LBIk8Eb2o/wPVuCIROQNBiy+jtolnpVfda4cIOAjI8=;
 b=X0dEa3oQBgkjIBCZe3kF/gtpVi0vH9t0e391agX5OiiFJg5agnLMj9cJ6rloust2oBmSwyRxVj5N+3T+apkz2OLqZCzLn3yw26gjklsUm4fj/dGHFRqi2ZvZO861zX43TM1pUTPPcrQATjQC8s2bGn/HXcUsJhENttVN8dfGDKiitg1H/zAjkdIxc0TK+kxRjf3Dmi/2Q869AtlsvyHjsLFYZmF8IGqIDYzqB6sfpcnF8hE9o8e1rzkaD8yIaIx8McCpcTRKVEKF7iaANNGMsG0DJx1fzqH6ulKF8Jx6NEU4shvPQJFCIu9VWaS3El6C9Q4H9/x3m58lrKwfxjYjYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by IA0PR11MB7260.namprd11.prod.outlook.com (2603:10b6:208:43b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 30 Jul
 2025 10:54:18 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 10:54:18 +0000
Message-ID: <807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com>
Date: Wed, 30 Jul 2025 13:54:11 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
To: Dave Hansen <dave.hansen@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>
CC: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
	"Ingo Molnar" <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-2-adrian.hunter@intel.com>
 <487c5e63-07d3-41ad-bfc0-bda14b3c435e@intel.com>
 <ccee2a0f-18fa-4037-bf97-f359e0791bf6@intel.com>
 <d443db90-ced5-43d0-9f85-ad436e445c3a@intel.com>
 <9a4752a4-e783-4f03-babf-23c31cee4ff9@intel.com>
 <SJ1PR11MB60836014330204B2FBCC7418FC45A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <79eca29a-8ba4-4ad9-b2e0-54d8e668f731@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <79eca29a-8ba4-4ad9-b2e0-54d8e668f731@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P191CA0028.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::19) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|IA0PR11MB7260:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d668542-4a34-41cf-91ee-08ddcf576e34
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3cxSmJiYUlFdTJ0Nks2Rjk0b0RweFNGZHdBd3NPNGtWRHBFT0s0YzVnYTQr?=
 =?utf-8?B?MUROTlZCZFhpMEVrVFpEdzkybE45OHpHSnpZWWVhN0Erd1lSMDZvVzM0SEdL?=
 =?utf-8?B?eENucmg3cXdSVW5uYy9FQTJ4VGNHZTZXK2k5dE5BNFMwNTRoeHZWZ2JQM2E0?=
 =?utf-8?B?cjNsWUpZNVZFdnNzQjREeSt6RVM5emJ6Uks3b2h0MnA4Vk84OFhMemNQcjJT?=
 =?utf-8?B?TXhuayt3cnh5Yjk2ZVRkdXBqU01Gb2lHZVoyM3pCVTI2dk5NNlVhZlFCQkZ3?=
 =?utf-8?B?N3NtZThNeDFQYXVRNFkzaUZKT2FkbkVoNzk5cWcrcmo0UmgyYkl2blJhUW5P?=
 =?utf-8?B?Ymk0dkFkNXI3Zml1S1VyN0dhY1lXNnhYUTFTUUxNM2pyM0Qxejd4ZFhDdG9a?=
 =?utf-8?B?SGxaU21GbWIwQ0JhbitwUWlBN1NYVXl2aEZTNkxFZmZpelYwNEV1cWw1d1VO?=
 =?utf-8?B?MWhZVlVBeU4yQWJpSnNob3l2cUJHdk1kNzVLclR0VkJvZm5nOG9temlMcUJa?=
 =?utf-8?B?S2RTTVVxM1BHc3dFc3VSSHg2SllPczQ4SXo4VklJaWZHVm8rVGV2TSt6K1VC?=
 =?utf-8?B?cWFRWTFoclNJN3pReHJ0TER1RHM3L1IzVzVYTjNVNVJhR3Vaci84Ulk1NE9X?=
 =?utf-8?B?djBZNVkzbXVuNnFCNjBGQzUrN0gvdTM5czArb2w2Uk1yUjRoZEUyM0xlMTNB?=
 =?utf-8?B?eUdzRWp4bWFzbTltZzU1bHoxU01KUVhHRTlYUFhKKzJiQTV3MFNtVWtmejIy?=
 =?utf-8?B?U0pXMk1BSkRkbjNPMzU2U252djYwcjhqV0tPOGl5N3hWY2NtSmcvSTV0NjZz?=
 =?utf-8?B?UlQ1c2s1RDNZdG9GeEl2amVUYm9kQ1d0QzN0VHZIQVB6NXRLNC9UMkx1c3pa?=
 =?utf-8?B?NkVSZlhmWHhRMmd0T1FJSGNtd2ZtQnY4YkpsMlY0dUJ4UVY1N1NzeVA1bTZI?=
 =?utf-8?B?WWJ6Ynh6QkxaYmZOU0twVkUwQzlycjZSdkMxZzhkTlQyc3VqQTVQaC9uS0d6?=
 =?utf-8?B?QjhHYlVFNzJxZE5JcUErbUlTNkdRSkh5cDlIZHlMbWZPSk8wRWQzZnFXZW04?=
 =?utf-8?B?ZmlCY090UEo2WnlYUXl3RSt4SEwzRFdRajRoczNQNlk2eUJLc1VtcVZDV2My?=
 =?utf-8?B?L24vazhXTjhDODgrakNZZnVkclZ4a0hvQ29nazhnNlE1VXdBRzc4TFZPRlhE?=
 =?utf-8?B?TCtCSVEvSGM5Nk5uUFE1VU5OWTVReDNESGdObFI0ZGIzNGdQazZqRnNSMWZl?=
 =?utf-8?B?NzdTakpLMGJPNUpCcy9KaHZCckRRTUFmT3pBUVA0RWNrM2pJUHFUWUNhUDFI?=
 =?utf-8?B?RGhrRWhvcUtwSlF0eTZCMDAvTFkxQ2s1TkovanVEazk2M0pPSThQT3pKN2NG?=
 =?utf-8?B?cUZ0alhQSVpxejhVWVY4NE1GN0pIM0dBRi81bzhsM2VYSlFOTEZ3VFp6dEhM?=
 =?utf-8?B?OW5IeldLdDBxUjlvL2tQWUZXbkM5cTk3VjRIcVNucE45Q3I2VFRGZUpxb1dO?=
 =?utf-8?B?eXN4eCt0SEl2eVQ3UHE1L3RCb010b2J2aE43NXA0WHIrNGZiYlFFd3JheExN?=
 =?utf-8?B?RXUxSlVjczdZV0g3YW53V2VIRStYaU1rb0E4bm5FeEdFYURxbzhUY1UwZDVR?=
 =?utf-8?B?ZjJYYzU5Sms4aGxsTzQrNDFRVmZXamxJVUNNbTNaOGNFVW1OdFZLdlRFcytq?=
 =?utf-8?B?enIvaWRsMzJPZ2llcmx5RWdDMHpIQy8rcUtsdDE1R3NvMGFQMytIL2tJQTNa?=
 =?utf-8?B?WGNoVjJhTVZqVFV6bGlsUDgrWVhYZVBYU3g3K0EwQnhsODIrd282WGhUWU5B?=
 =?utf-8?B?Mm9Id1BnbXlvbVpjUVY2czlmTlptcjduMHJYR0tUM0NPZVlPQkNhekJtZ1RV?=
 =?utf-8?B?K0IvenNQakRvR05nQkV5UEFCUzlXM1RCZnNsWjJ5RXRDV2NXRmY1MWNGWmlv?=
 =?utf-8?Q?PgtNjIicwLo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWtTdHR4bXBsMUoySnA5QnhabFVtWXh0Qyt5NmJpYlQyTGFITWxsZ1Y2UkM3?=
 =?utf-8?B?TThDRTRRbmtYdTRCay9hTzBuTEJJTCtWbXBjeHdkOFcvZElOc2l5NmY2bGtk?=
 =?utf-8?B?MFV2UU40Mk55Sk1aaVI0VmdOd0hSWVdRV3JaZDNSbm5GaWc1OGhRRDhrNmZu?=
 =?utf-8?B?ME85aXVaUE1mN052VC9YUDZHQlFvcHhmdytyeE5pS1BpZWMwSW5YeVpjQjNC?=
 =?utf-8?B?dnRJRnNiS3lFQUdVMFAxWlpDTU1rRUtOR0szMk1QNzcyR3dWVFlwLzdHeldB?=
 =?utf-8?B?M0VGa241Mmtndmw5TWRVTWFlOG1GeUdSelM2Sy93KzZ0aStRTnJkK0JxYnJ5?=
 =?utf-8?B?cVQ3VUwxTHNDY1hBSnlsRm8wbEI3V1NvUkx5a3JKbHNQMC9xeFVOaHhyNzBQ?=
 =?utf-8?B?eXJSdTh0ZjY5YWtDS2ZFenE3Y01RSE5uNnJsVURzNkIvalRQN2ZTdWEzSjVM?=
 =?utf-8?B?YmFJVTFnZmFhWmp6VjlNSGticHBNWWRLeHYxaFljZGt2clZqbHlFNEZRZUwv?=
 =?utf-8?B?a0VMa1ZaN3pUWmU0aFhyaTFUOEdiMGxnakpoRDVSbG1CVFdvaGdZeHZNeTRn?=
 =?utf-8?B?SnNjUW12NWNuSDN2UDJ1L2g0dktWeXppRWwyQnB6SWlnNXA3SlBpRi8yZkZM?=
 =?utf-8?B?VkhoS2dndU8va0Z4alVOenBlWndEUVlXUFpHL0NVRmVGVXcrQnZCV1NOZjJL?=
 =?utf-8?B?NXpic0ZTbWkwRHQ3WVEvdlg2OTBrVnhKdnFuS2dNVkxhSy9NNUYxbGNETjh0?=
 =?utf-8?B?QzA2Y1hadTh2VndXQWVWRi9EWVF0SmluQjcwTFpQeERNV3l3MkgzdWJOaERO?=
 =?utf-8?B?bFVJMGhnNkRBeTBVT0oxR2dBVG4xYTVpb1FpUVRBS3g4S3psQjJPSlA1N3pz?=
 =?utf-8?B?WXQ4SHAwWlBKYVVQOGtCR2JmQnhjQk93dlFtQW0zeUtQSlVPOE94cHQrNWVG?=
 =?utf-8?B?Q0JIbnlrVjd2SkRxVFM5T2drV2taWTJia3dqdjFPdFdrc3NaamN1eUNkaVNV?=
 =?utf-8?B?UHR5R2xKUDVWNllDOHhkSlY1Mm14R2xwWEVBckFtWCtKQUdxcVVXYktmUElw?=
 =?utf-8?B?OE5WWlRBaTd0emFTWFN4MU8rdms3TEhEaHRmYldUZVo0YjVsYjFSZE0vZlVG?=
 =?utf-8?B?RUlRQWRNd2xYRXVJVHpKVWxvVmhWOVRJVkszVXVOUUh4UjdJQWpmZ256V2xV?=
 =?utf-8?B?WmZzTFg2cFBTSFV6N2c0RVAvUmNlZ01WU2xMaDF3alFnc1pZMEpBKzRGSTMw?=
 =?utf-8?B?RnpDdVFLcWp1VExxaU9uMlp6MXpGODIyWnIvUFhZZzFOaEp0TFVJN2FvRUh2?=
 =?utf-8?B?MzVOL3M5REgxQmYrTks4dURqZWw1a3BnYTRvb0pVMlBNZUN0eVd0eUd0bVVQ?=
 =?utf-8?B?c040OEJwalByQkdhNXBBNUdaZnc5MFNQM3M4SENDcDlkVmV5ck1uOUYzZ1gr?=
 =?utf-8?B?UWtSdFJoWkFRcmM2RllLcHp6NXJIbGJXVGk0eTdEZW01clIxclNIRXRvWHRm?=
 =?utf-8?B?YWtKQXNjRDZ1ZkswVm9ZR1ZVQUpxUmFJOGRxWnBKNHJEbEVwcXlmTWd4QTRF?=
 =?utf-8?B?RVV3eWlPNDhMQzNRVnVyMFV1RVMrdThZUTZvVm5heGZud01LOExhTVVIdFFx?=
 =?utf-8?B?QXBoVE5EVDlqYnQ0WHhjODZKMDF3Rm5yRW5YTHk3dXFVa2hZdkpqR05ad1FM?=
 =?utf-8?B?U3RDbXErVjVwVE5wdWZSa3Z3RlNWdElKN2htR0lxUUFFK2FjaFpJcVB1dGVa?=
 =?utf-8?B?UnBFeWR0V1NCL0M5U3k5WVdmT2ZaODJrSWp1U09OUEdiOW1uaVlGYWY0TWps?=
 =?utf-8?B?Y08wQ0JESFVTY1lvbGtTclhNVy9aUnp6WkNFSUFrUWtPNzlkM1JVQjYveURj?=
 =?utf-8?B?eFdkZ2pVSVRwVTh1QzdsM1FJcU01blJoNDd2REl3VGFaYkFhN3pTTW1NeHpu?=
 =?utf-8?B?VjlpYnBCbnhmbkJ4dFF0dm14L2pmNmNlVCtoRXBxbDN2N2V3V0gzdGtCd1E1?=
 =?utf-8?B?WFZxMmhDY1hWOFFXMCtlR21jS0xYMGNsM2kzV25FTGRWa0Z5bU1vUVRiajhQ?=
 =?utf-8?B?NWlIV2kyT0VEbjNWcWluLy9LYllTbG1GQ2ZUTytvNEdLNnFsT0dvRmR6Q1hT?=
 =?utf-8?B?MmJza0RBdHlPRDVuVFNod3JDTnBWWkEyZG1mWWxBVnBudTBhbnFhdVVtMnJv?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d668542-4a34-41cf-91ee-08ddcf576e34
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 10:54:17.9565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMvlPzWdfK/o/lcNkilW6tndgw4Zp2dAJqFbhpWTb9iAVwGp2MW7pRlmwz6PlpYYmXGtBpFWyK0Gxq7jdixtAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7260
X-OriginatorOrg: intel.com

On 27/06/2025 19:33, Dave Hansen wrote:
> On 6/27/25 09:24, Luck, Tony wrote:
>> We've been sending a combined key+address in the "mce->addr" to
>> user space for a while. Has anyone built infrastructure on top of that?
> 
> I'm not sure they can do anything useful with an address that has the
> KeyID in the first place. The partitioning scheme is in an MSR, so
> they'd need to be doing silly gymnastics to even decode the address.
> 
> Userspace can deal with the KeyID not being in the address. It's been
> the default for ages. So, if we take it back out, I'd expect it fixes
> more things than it breaks.
> 
> So, yeah, we should carefully consider it. But it still 100% looks like
> the right thing to me to detangle the KeyID and physical address in the ABI.

Coming back to this after a bit of a break.

It feels unlikely to me that any users are expecting KeyID in mce->addr.

Looking at user space programs like mcelog and rasdaemon, gives the
impression that mce->addr contains only an address.

The UAPI header file describes addr as "Bank's MCi_ADDR MSR", but what
mce_read_aux() does tends to contradict that, especially for AMD
SMCA.

But there are also additional places where it seems like MCI_ADDR_PHYSADDR
is missing:

	tdx_dump_mce_info()
		paddr_is_tdx_private()
			__seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args)
				TDH_PHYMEM_PAGE_RDMD expects KeyID bits to be zero

	skx_mce_output_error()
		edac_mc_handle_error()
			expects page_frame_number, so without KeyID

The KeyID is probably only useful for potentially identifying the TD, but
given that the TD incurs a FATAL error, that may be obvious anyway.

So removing the KeyID from mce->addr looks like the right thing to do.

Note AFAICT there are 3 kernel APIs that deal with the MCE address:

	Device /dev/mcelog which outputs struct mce
	Tracepoint mce:mce_record which outputs members from struct mce
	Tracepoint ras:mc_event where the kernel constructs the address
	from page_frame_number implying that KeyID should not be present

I guess it would be sensible to ask what customers think.

Vishal, do you know anyone at Google who deals with handling machine
check information, and who might have an opinion on this?


