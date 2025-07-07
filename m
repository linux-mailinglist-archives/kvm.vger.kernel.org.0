Return-Path: <kvm+bounces-51692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12290AFBA75
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 20:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49FF33B5660
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 18:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8762620FC;
	Mon,  7 Jul 2025 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lgfnP69y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22BD13A244;
	Mon,  7 Jul 2025 18:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751912159; cv=fail; b=Nzim9Z25oIIAKuMCj/nmvoO7Tywqk4DoVK2s3hiC84zcECzI/2NArBFk0bJ4puqO6r6oYUKhoqpNj8envPgN9D1avhPP8ynB3wrXkVzAe3a6PAU9wyie2P0YLxSPmdwETJvoRDaeSMwtgaqpYtXIJta5v+OnIB0CSIx1TQni0SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751912159; c=relaxed/simple;
	bh=Q0fTPpVf2+A4c6N3bYIl3NJK+4NkUX8UAPDjnLim8rA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rzoR6wFgNJ0J/XlIsvktmR4MM6XadgBlidf6wAcApwX4S+UZ/9DJWy/97rgRp3XRUViYB1Zzmvj0dq8sVkkdhq0+i9NaWDWSYdOjkF5vzor782zdBXx5IVSlVMgoayZ7pp9C9T5JkWmcjnnrDFIMnMlpuLVZ6BRDWgmm+f0XfLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lgfnP69y; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751912158; x=1783448158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q0fTPpVf2+A4c6N3bYIl3NJK+4NkUX8UAPDjnLim8rA=;
  b=lgfnP69yVdOmudNEiwYKzQGpLsJmXnJuckpqUJlMDh2Eya3e1MZJUS8P
   ODnlKsrVdZ7BjB5ft77kUx4mpBcx2VuxJmGQZ10Z9wxqDvTqv2DxtQeOS
   RSziCO3VFiPm46IReK+N74fDPjFMmEsLjUozTX6vx9NBUhe07UXSTotbt
   DHuPB8i7Cp7qAg+SL9wNIH2XcKMT0xO0xs7jPxW9cmghMhkq0hNaK8kwZ
   Wzx40WbP7K6989LuCfuKthHdY3/2CaShnrJEHMb+0jlY73CA0/1D3wE/9
   EBABKqCS0YYBw0FjvMZYIKzC08zUmk2zByw1Z330Zw3sG7NON4CsuWBst
   w==;
X-CSE-ConnectionGUID: G1qEdtahTB6z2gxuFaaAlg==
X-CSE-MsgGUID: bhqDY90dRhi0FO819oZtZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="56753733"
X-IronPort-AV: E=Sophos;i="6.16,295,1744095600"; 
   d="scan'208";a="56753733"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 11:15:57 -0700
X-CSE-ConnectionGUID: zP9wdvR2RPyNbaenAXY3pw==
X-CSE-MsgGUID: lueuGgtcS+eLUNexluZBDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,295,1744095600"; 
   d="scan'208";a="154698239"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 11:15:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 11:15:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 11:15:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.62)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 11:15:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xjThh0Sh1AKWsLmo0QpFNJdv5eQoi1GqtCTPgTlahcsz4r0aWlQ2nqBe85NsKnjfY1ceIBcWJjGpNxXJARAkZmYPP5qrzDr4U3CeNWmVdJtGZo6YHiE1+TcMXcXXdmfx5GfHb4Cf6NIfyL9ycg0aBKDXVU6uvzSOkNeRRTeuC5kNf3QndVjRY6vRZISvQnaWT2DNm92cfp5qLw8HX8Zb7lawej3zcQKDkMlT0aAkW9f3jBbUW5cGHX2s47wjZb00hG9PU5brFTAqRgsPEIRBh/LOCC8p6yzemz2q2/VzWHb1Een+BGpXWHAraMQUCt4hXEuNj2h/J0IyxfpwAq1pWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0fTPpVf2+A4c6N3bYIl3NJK+4NkUX8UAPDjnLim8rA=;
 b=b+r1q+TUm8DyJu+E6da3iH++kA/FL2FjlyEzUDvJjQ1LhCxTivK4ycD1ZVpEXmGDk/6f9qz5bnC8kgN320xeSYGRZdu7Sqx/E9bpYAj9y1+6HujueDT+8Gedx2aBvBfYAVLjmT8J1h19Cd/Hcpocvtpfw8DUj3pOAoqQdLp6ETH8+Vd/YkCFZTgzQzJD3Z0dKkhi1j2tDjcUyd2xEYYhFBaJ8RMem98HjvDWohYZ+3z9VbB7bp/+wtMOvy8hzorBT/8JDlNGeaBqWl4EV/+oiKdoKY1k8pyNO7zCXf5Be+z5UGk1rWRH6Hx0BNF/jImAPtrmzZe1jbyXwoR2pfkhmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7663.namprd11.prod.outlook.com (2603:10b6:510:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Mon, 7 Jul
 2025 18:15:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 18:15:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Topic: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Index: AQHb7DBwTFQonAPAp0CU/cV67lKauLQmApoAgAASsICAADAIAIAAejoAgAA+V4A=
Date: Mon, 7 Jul 2025 18:15:36 +0000
Message-ID: <5705fff914dec6f34cf5e1053e4802ee3dff9edb.camel@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
	 <20250703153712.155600-3-adrian.hunter@intel.com>
	 <aGs7/C0W58nEUVNk@intel.com>
	 <ca275d32-c9fd-4f60-9cf4-cd88efc77d78@intel.com>
	 <aGtz9KfszwNKBrZb@intel.com>
	 <a8d517f5-80fc-4225-969d-1191564aceb3@intel.com>
In-Reply-To: <a8d517f5-80fc-4225-969d-1191564aceb3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7663:EE_
x-ms-office365-filtering-correlation-id: 48fdf0d1-7817-4611-974e-08ddbd82452f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bzJxSTB4MHFNZkJlVkdJZnM1SkozbVpNTThHaEpQbW4vbjBmcVRlbVJxSHNm?=
 =?utf-8?B?TWJHR0NiWkVrSVp1QlJpUm1xWDJCMWdITDBrcExaV2hvb0FSYmNncmlVVUpm?=
 =?utf-8?B?VFNJSVNiZS9hSEt1WEliRStQR3pFS1RmQTN1cERBWFRyVzRMeDFpN2h6QjB5?=
 =?utf-8?B?NGlMTEV0aUg0eVBraDRCMms1MGpOK2ZvelhGVDZhK3lKejc5S3NJejBXOUp4?=
 =?utf-8?B?REFlTmd2M1M3YS82Q2Q0ekJ1RXJCTmlZN2lRbEFlK3lGTm1PejhhYmdCT09j?=
 =?utf-8?B?NWdnRHdTZERiNFlFMzNpVXUvdEpjWDZBcjc0UXF0c0FUeXVIQmYwU0oxVUJK?=
 =?utf-8?B?N3JjenplREZuL0xuazhqUk5Zb1lkMUpneWEvK0ZibmhNWXhJNlJ6aFpmT1JJ?=
 =?utf-8?B?SmpyTC9kOWVPOGIzRlI1VDB3TFY5aXhTZ256Qm15YTBEenpndnJCaGdYckt3?=
 =?utf-8?B?cFBqQXJIRUwyNk82RnVJd0VpYWJtRWR5VGxhbFl2MGh6cmVBV05xVHB1WjAx?=
 =?utf-8?B?VnRLZ1BIdHp4WHZFdUY2RTJlZjZ0YUdvMi9aQzQ1ZTI3U0FxT0kvRkdEVXh6?=
 =?utf-8?B?WVNvWVFSVGRtRlNqTExCbm9TbFBTWitBWE4rQ3NIN2ljV0tRUlJTQ2xPakRj?=
 =?utf-8?B?aDJqWkdTZGowd2J6NmRDUGRJU1dETUtKVGo2eDJ0Lyt4ZlJtZHorQjd5NTVx?=
 =?utf-8?B?Q0d4Q0hXRkxLSE1NOWorQ3JHM0pWRVAyOTRXTEtIQVhNeUQxR1h1KytqZTY4?=
 =?utf-8?B?MzlXNjlpdWxwS2xxZUdlZ0ZHbXBFd242UVh0UThqNUdqYmN4MXJjZXllUXdl?=
 =?utf-8?B?cVJ1VHhBamRQQ1ppR2wvVVNWQ1d4QlhSQkViRFhtbUVyL09NR2pBWmNXUFVZ?=
 =?utf-8?B?UzdEUWxtRk9ZUmgwNjlhRGI3SytNQWVzaFdMWW95U0V6QXcxVEd5TXoyRlJv?=
 =?utf-8?B?dXV6MFlMSUwraEswWXJoVTJhK2IvTEtxSkZhMTQzR2tWY3VPdVhCL1BJNkls?=
 =?utf-8?B?WHpkY3RCcm9pWU9MSXZYRFEwUjFPcTFaYmg5Uzg0RDJlOGtjV1dCM2U4MGMx?=
 =?utf-8?B?SGhMTDZRTTBVZnROUFd1Q1J5UkRjdmRkMWlqandxSlFCNUE4R1h4REFkbE1K?=
 =?utf-8?B?UTc1Zld2L2tqT0Vyc2xERWlwbFhDeHFkL2tYcnY4N2xxZHkvQWJ2MHJNaFVB?=
 =?utf-8?B?NnNEZm1Xd2I2QktzYU1XTXVCY0t5VWdhNUFBMjlMTEFYRC9qVmx1anJSUlhj?=
 =?utf-8?B?aHJtc3BaTkZTZWdwaDZWWDEvNUgyQzVGQ3dUUzhrY1pKellnZGZvTlM3NUNQ?=
 =?utf-8?B?Z2hYYmpqWWVra2l2NHlmRmxjUjZIejB6YS8wMVhoSWo5S3puTDNwWDVGL3hK?=
 =?utf-8?B?U0lqdThkQUl4MXUrN3BwYXRpZ3htRUtRdU1YWmk1aEhYM3I3RzJJd0tiQTFk?=
 =?utf-8?B?cHBCazVheW0yLzRuUU90NWZyZndGSEJsWVN5NC92U2RQNExnazFwL1pXM1dv?=
 =?utf-8?B?SlhleEtWeTZ0cXJrcjlkWU1UVW9sQ09OekVhMWl1R0JCbkRucFd2TjRQb0xy?=
 =?utf-8?B?Y1FhamxLMUNmcGV0WHJXaTBFMHc4MUJBdnhDdzNyZ0FDVGJ1a0tPYXlMMFcx?=
 =?utf-8?B?bG8zNm5ReUJRMFlRcjVCdFdmN2Z2ZjJENDkzRnJ2VHlETFVXcGdpclgxWXh2?=
 =?utf-8?B?SXZWaE05enBSSTdlZjVxdVFGUWpQTEtOMmx2NDlDMnhFQnB6c3VsZHFtMkor?=
 =?utf-8?B?WW96Ympud3MzSEJLRWoxMzI2SEtjd1Nud3grSGVIU3BveUxxSlArN09LUXdV?=
 =?utf-8?B?ZVlZNWErd0VxN2JrL25EanpXUEN0N3RleDBrb1dOcUJrT2FLQmNuSlI2K1lq?=
 =?utf-8?B?WUdrRzFwbEJoaVUwSWZWRDdqeldQdGFCWENUSFNWOFhsYkVURmlpZFdOSXh6?=
 =?utf-8?B?cys0ejhmRmdORVhPNERNWlRXdC9IbWNMb3NVNHUrSEhMVGpnZzJZQ3RZbFd5?=
 =?utf-8?B?dksxb1R5U3hnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkZlUTFvdTAzSDFDaTUwTmlkcDFIV09DNkszTlhraTc1OENIcnNrYU1GdGZF?=
 =?utf-8?B?eW1mMEM1blljMWgxR2oyYUlQTVNPVDVHR3RwWkJGZ0pyZThNc3FTR0NuY0Jo?=
 =?utf-8?B?T2thaHBHSThtYlhNZjliRWdCblpvdUc4NTl2Rkt4WVJ1azZ6WHlwVDNxbm5J?=
 =?utf-8?B?UkJKTHc3SkpvZU9ZWlIvU1NoR09qLzh1bzNZUW9OL2J2b2VEZ04rVnd5bVZ3?=
 =?utf-8?B?WkNFRGtTSU55YXBkbVVEdDFiT1hOUnk1YnVLcWRSUVBjVWJ4b21pYTdMeGxi?=
 =?utf-8?B?MGtxYkl4ZDhNcC96UGZBTzZvaFRlWmdtWk9KT2pDSkxJN211VlBReUZvNHRM?=
 =?utf-8?B?eVNJdlJKNnQ3VDZodXJ6clpxbmRHeXBvQ3JJazhXbFVwNTM4aTdnWWxBNnNM?=
 =?utf-8?B?MzdhekMzSmh5QW45Qi9mcGE4RkY1dzJUS0pwTDFacDh3cmIwZ0RLWE9VNGRE?=
 =?utf-8?B?TUNZV29pcmorNmhwSXRNaG9TNjJQM3ZUWHlySGsxYkN2R2dmUGtjSDFaYmxy?=
 =?utf-8?B?MGpiVTBrRlZORkhWQTlwd0tJYUhSUXRsb2ErOFJWOGovdFRBbERVaHlpRWxv?=
 =?utf-8?B?dUNzLzMrTWVXbVQwZEducC9qbHNDcllyaFlPZnI0YXBPc0REQkFRWHRYR24y?=
 =?utf-8?B?cW1uRHkrN1FHYmVjMUt0eVJITTBNT1FpQ0tWK1c4M1NXaDdsYlJmMVVPMG5y?=
 =?utf-8?B?UUpkamllTGdPVEwxVzA4UGwxNHRLdzRrT1kyTmNCNWV1MGNOdGI5eHFhSzRE?=
 =?utf-8?B?a2xaMmJPTGFzTDk4TUxWelkxOWpXaVpOOXoyZHdiNEJpL29aMzlzYnlBS0Fw?=
 =?utf-8?B?M3VXQUxFNWY1TDNjTlVvVnVDM2tsR1A2cEtWTk9NaEJTbFFzWVkyRWc5ZWJl?=
 =?utf-8?B?WW50VFVUKzZ1NmU4d1VudVI0MDBmeTljVE9CclV0UDBNS3N5TUZqUGNpYzJj?=
 =?utf-8?B?eHVqSjJheGgyamdjNTR5bVBVWTFlWmNTU1pGcHpyTHp0ZC85MU8vMnJieFBv?=
 =?utf-8?B?aXdVY1JicjVqQTh0Y3NmTkRlNDlJcytESFZtSy8xRm52T1lEVUxxWXdDd3Na?=
 =?utf-8?B?QTlpVkM4bVlYV0pldXQwTnY5c3d6eEpxY0thRnFhUU1pODhCK3lLd2dyV21w?=
 =?utf-8?B?V2cwNUplOHQ0TEErOEZWTGx4WjEwTG05c0RUd0NHK3ZjRHk2U1NFbnVueWJZ?=
 =?utf-8?B?VFcyN0swUzRjQkxDT3lETC83OWl3ZGJGVnFuSGxkN1BTYTFQTUNlVVpMQ0pS?=
 =?utf-8?B?Q2tYMFNKYktYYVkvUDFRb011MGV2U1ZBR1lZRzI0SUx1cFRjNmZZenJEdTdO?=
 =?utf-8?B?cHBCblV0NWtzWTlxMWVzeTdCYUs3dEJ2dnV0blFJeURtcEF0YVRYYi82cE5H?=
 =?utf-8?B?Ym9jUU1GSk5WdnE4NkwvaEpvcXVVNS9GM0YxWVhjZnhxOSswNGxCcitkUUJa?=
 =?utf-8?B?azlod3lZWUd1UTZ1SDJZcEhqSFVCNEpHQUJGSGFCUmRRVGk5S1YwL3ZBUVc1?=
 =?utf-8?B?MGtLZlZidG41eUU5OUd5S0NPOUVwZS9zS0luWmtFN2hVY0RPR0R5TlhCbUpn?=
 =?utf-8?B?L0l4bnMzRUZnRVN1YW8zVlVmZC9PQVhKZysrN25FMkFmL1krMVNCd3JRL0hr?=
 =?utf-8?B?c09oSENjNE5jclh6T1lhSE14VzhhYWhpZ1I1U2ovL1FXL1UxTXA4K3c5TC9i?=
 =?utf-8?B?MVV2eFNiUTBqcmZzcmNQSEs2b2VVWjlWditWSnY2QzZRQVJOSDQ1S2dBRHhF?=
 =?utf-8?B?M0Y3Vm9jRzlLZ2RvN2dLeVFiLzI1cTJaTWJmRUxqVTIrQXZmU21xWEF1Skdi?=
 =?utf-8?B?eFZPcnN3T0kyREo4TUJuTktacmN4LzFGaEVPY3RWOGJoZGx6LzRQK0hTUlBO?=
 =?utf-8?B?TnVGakUvUWtub01GaytZaGNnTUpwSVRReFc4a0hYRkhjRnZMTlNxa2JyRmlP?=
 =?utf-8?B?TnZkRzhVMkxXTC9BaC9kSTNUcXdFMUpLZDNBTE03YnZnVE56QlJEWFhodnk1?=
 =?utf-8?B?TmJBOTVpdDVQbnNrK2ZFZ1BIK2ZERy9CNFpLd0NGK25vaEllaVd5Rm56NHZK?=
 =?utf-8?B?cWx0SHlSZVNGTFpZWlZsa0RGZkJ4NUpuZW5ZZkc0TzRxOXJXTm9scStkdC8r?=
 =?utf-8?B?ZThCek05S05Pcnk2QjE0citLUXhCeEFHRllnT0sxa3h0b0ZmZFVIVWdOdXA5?=
 =?utf-8?B?ZWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AED66A67CA2D8D448DDD4DFF1FEE8646@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fdf0d1-7817-4611-974e-08ddbd82452f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 18:15:36.0290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1bqJQ+aLysnO4CLzKhkfPA8Eg+Jz4fDauC/Yq2cGG4RNnE3zJG8MjrKy8ISKTocZ6bIs2h2zaxx87l1EXBYomV+EIIO1SEfuw+2HuAPj2N0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7663
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTA3IGF0IDA3OjMyIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNy83LzI1IDAwOjE1LCBDaGFvIEdhbyB3cm90ZToNCj4gPiA+IFdoeSBzaG91bGQgdGhpcyBz
cGVjaWZpYyBraW5kIG9mIGZyZWVpbmcgKFREWCBwcml2YXRlIG1lbW9yeSBiZWluZyBmcmVlZA0K
PiA+ID4gYmFjayB0byB0aGUgaG9zdCkgb3BlcmF0aW9uIGJlIGRpZmZlcmVudCBmcm9tIGFueSBv
dGhlciBraW5kIG9mIGZyZWU/DQo+ID4gVG8gbGltaXQgdGhlIGltcGFjdCBvZiBzb2Z0d2FyZSBi
dWdzIChlLmcuLCBURFggbW9kdWxlIGJ1Z3MpIHRvIFREWCBndWVzdHMNCj4gPiByYXRoZXIgdGhh
biBhZmZlY3RpbmcgdGhlIGVudGlyZSBrZXJuZWwuDQo+IA0KPiBJdCdzIG9uZSB0aGluZyBpZiB0
aGUgVERYIG1vZHVsZSBpcyBzbyBjb25zdGFudGx5IGJ1Z2d5IHRoYXQgd2UncmUNCj4gZ2V0dGlu
ZyB0b25zIG9mIGtlcm5lbCBjcmFzaCByZXBvcnRzIHRoYXQgd2UgdHJhY2sgYmFjayB0byB0aGUg
VERYIG1vZHVsZS4NCg0KRXZlbiBpZiB0aGlzIGhhcHBlbnMsIEkgdGhpbmsgaXQgd291bGQgYmUg
Z29vZCB0byBsaW1pdCBrZXJuZWwtc2lkZSBzYWZldHkgY29kZQ0KdG8gZmluZGluZyBURFggbW9k
dWxlIGJ1Z3MuIE5vdCB3b3JraW5nIGFyb3VuZCB0aGVtLg0KDQo+IA0KPiBJdCdzIHF1aXRlIGFu
b3RoZXIgdGhpbmcgdG8gYWRkIGtlcm5lbCBjb21wbGV4aXR5IHRvIHByZWVtcHRpdmVseSBsZXNz
ZW4NCj4gdGhlIGNoYW5jZSBvZiBhIHRoZW9yZXRpY2FsIFREWCBidWcuDQoNCkFuZCBsZXNzZW4g
dGhlIGNoYW5jZSBvZiBjYXRjaGluZyB0aGUgYnVnIGFuZCBmaXhpbmcgaXQgaW4gdGhlIFREWCBt
b2R1bGUuDQpPdGhlcndpc2Ugd2UgZGV2ZWxvcCBhICJ3b3JrcyBieSBhY2NpZGVudCIgc29sdXRp
b24gdGhhdCBjYXVzZXMgY3Jhc2hlcyBmb3INCnVua25vd24gcmVhc29ucyBpZiBhbnlvbmUgcmVt
b3ZlcyBjb2RlLg0KDQpUaGlzIHBhdHRlcm4gb2YgYWRkaW5nIGRlZmVuc2l2ZSBwcm90ZWN0aW9u
cyBhZ2FpbnN0IFREWCBtb2R1bGUgYnVncyBjYW1lIHVwIGluDQp0aGUgVERYIGh1Z2UgcGFnZXMg
cGF0Y2hlcyBhcyB3ZWxsLiBMZXQncyBtYWtlIHRoZSB0eXBlIG9mIHJlYXNvbmluZyBoZXJlIHRo
ZQ0Kbm9ybS4NCg==

