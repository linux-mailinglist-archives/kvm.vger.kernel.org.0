Return-Path: <kvm+bounces-17753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7A78C9B17
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34C3E1F217E0
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 10:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C8C4F895;
	Mon, 20 May 2024 10:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HYDzzWrk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B7F1CABA;
	Mon, 20 May 2024 10:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716200221; cv=fail; b=DPpWDtYxHdHmrtXZn5T9kH3IB+bQlThMO1qgWrWmc8/agtCPE5vYsT2YkrElrA61J5MBJTP4X2yji07U//1F1Fpvpt+pwLjhKuvCgQAUG2MZ3+IGWp0AG6QI2v304j+DaXUHcVwJc55VQdXht7+FU221R72jP/872xAaa9PXz6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716200221; c=relaxed/simple;
	bh=IhXf5cXRr/cLUayF4iCnYqVjTdy8LTmQAxX08YcfySM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uF3AF+p4VLDDJfde9uDtFF283h9eA+lIA+iCGwDl8rWzhIRqV2p78lEmF1pLkLy6PRmzCebB6XQ+5EUU8vin+fms2oXrRWHaQ+KVyuEFYLizMn+Hgm/26lIIqfxLpaKwSWOitOwB3G+UpqZ+iRgya1ykjZaU0KhyQO6e4hIXMBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HYDzzWrk; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716200219; x=1747736219;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IhXf5cXRr/cLUayF4iCnYqVjTdy8LTmQAxX08YcfySM=;
  b=HYDzzWrkBjFq+U+mP2t+xNZZCrnHzWO/Sv2YgKTT3KPuecYPLuJq7R/l
   JY3U8yZDSdvxVekzzQCb4ymHSDxnSNSP9E0EMiDAK0q+blKL9uRkh0JaP
   CNMinrCTkNOfJvSLy+hVG/KbkFNsym/EfqTPPA1bmofoI5tanwhZ8tIVk
   c2tJ/UGTJ0arcrOR1iqFugoogwRhGzNaweCsP+CWj158N39yLuX2ayGqA
   713g7PQ8o8J3feTl2VAAEQ3G1s5BWP5BPcL6OJljqIlGwD2hiRFYp8huF
   mnMzzhnj8z51rz3KQoPbIEDyGIQNvQDDSqRi1/TuTbxhFmHyd0GD1eFXm
   Q==;
X-CSE-ConnectionGUID: pBxGzhS3Rdma2+A/awM/qg==
X-CSE-MsgGUID: Z0j0HT8SQLSusaYIt6Qiow==
X-IronPort-AV: E=McAfee;i="6600,9927,11077"; a="22897343"
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="22897343"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 03:16:58 -0700
X-CSE-ConnectionGUID: NvzV5t6XR6aTQfS5BNtWMA==
X-CSE-MsgGUID: l4QFjB4bQ9yf5TODZMBfWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,174,1712646000"; 
   d="scan'208";a="63321073"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 03:16:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 03:16:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 03:16:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 03:16:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 03:16:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4LpqfaJqI69H4HJKUituEl0XdxffIUyhJXnKp6vITO1O72GYeiseqmiAt84yd5yeh2BkAjEXkgByo2CmKSwZaD/isG85wGOZkHIIZ9mAVXnkLYoYuHn1W6SlkzICurrFI8KnTerkqysDAGN2mInNsWWNaG3yH7sz93JWFQpxwWBs8Abp1+R5IbUS9Z81Gf/LGs9+zGkBJi8Uk/rnUiswsdhOjKnKhO0ONRGFr/i1NjeJdiTIir8sTfx1BvvW6m63Z5r2bdirwJ0YnNnSG0TRXYgA0hHbjmvDx7F1/Jjbi+z6wZJnRnz1xJVY+jA/JO6bQEOqM+Jt7xJaBTj7STH0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhXf5cXRr/cLUayF4iCnYqVjTdy8LTmQAxX08YcfySM=;
 b=oMzF406xNgUXTcsrn1a2YtwHo91tK751juxXDCqD51YnBGB834naWOevnemzJa2biMRREojtD2MZr0a+YEmi7UNp0V2QkyayRRfSGhl9Fyk07PM+l5URo/ECOvNzJuOHyH8TyWS5MXm9TSxdy8mPJU7uDDAFbRZTUWeE1yy8iuA5bf9DD3WSSgj0G/gFHVOIcAGFZocnZ9atEZqBpZVAqMmm8TvDM9BIZiICpWLhFSZRdphf/8Kw348Ot7TXGlnKoXLDMaHhhpXcAqzt/ZJuMJHo6XgjOXem2yn6zSCsObwlU1domLgtKdmrHw/fgxvckgK759iP0KQ4TwirFc1mfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB8013.namprd11.prod.outlook.com (2603:10b6:510:239::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 20 May
 2024 10:16:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 10:16:54 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>
CC: "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "tobin@ibm.com" <tobin@ibm.com>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "alpergun@google.com"
	<alpergun@google.com>, "Luck, Tony" <tony.luck@intel.com>,
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org"
	<luto@kernel.org>, "ak@linux.intel.com" <ak@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "pgonda@google.com"
	<pgonda@google.com>, "srinivas.pandruvada@linux.intel.com"
	<srinivas.pandruvada@linux.intel.com>, "slp@redhat.com" <slp@redhat.com>,
	"rientjes@google.com" <rientjes@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dovmurik@linux.ibm.com"
	<dovmurik@linux.ibm.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"nikunj.dadhania@amd.com" <nikunj.dadhania@amd.com>, "Rodel, Jorg"
	<jroedel@suse.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "kirill@shutemov.name" <kirill@shutemov.name>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "ardb@kernel.org" <ardb@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH v15 13/20] KVM: SEV: Implement gmem hook for initializing
 private pages
Thread-Topic: [PATCH v15 13/20] KVM: SEV: Implement gmem hook for initializing
 private pages
Thread-Index: AQHam6aOns/LzK9t3kqEu3Lp87ntJLGgBlyA
Date: Mon, 20 May 2024 10:16:54 +0000
Message-ID: <41d8ba3a48d33de82baa67ef5ee88e5f8995aea8.camel@intel.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
	 <20240501085210.2213060-14-michael.roth@amd.com>
In-Reply-To: <20240501085210.2213060-14-michael.roth@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB8013:EE_
x-ms-office365-filtering-correlation-id: 1063172f-37cd-430c-df98-08dc78b5f8fa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NFplNUN3WG1KN29RcllWckdDallZazdXQ1QzTGw1b2ZncUdBV0pYdVN5Y1Vv?=
 =?utf-8?B?NEowMXhpS2hRdXNZWlNlQ01ldXkrRkxzWG1jL2RTK2JLVUw1dXdIYmJVTm9H?=
 =?utf-8?B?dXlidzEzRXlLb3NIWlNpbGU2TVdYTElOdXl1Y3hDN3ZQODkyMzE4L2RHZWNi?=
 =?utf-8?B?SVVaei9hRldudTNpVlA3V05YekZjMzBVbEk0eCtsanF5N0NBWDhoLzVWSE9I?=
 =?utf-8?B?M3BQV29OaVVIdGF5dEJvZmFCTnBIdS96RHJuMzVNTzFhOWorcHdvQ1VaU2Vk?=
 =?utf-8?B?UEp3Zjl4MDdVVjFzRzlwdFlrZEpSWEdCYVFaSnhZRlV5ZVBORkZ4R3lLSFhm?=
 =?utf-8?B?WkpJaFN3WG9NVm1sS1RNMkVWN0xydmoxK3dQcEVuTXlsMUFIbElNY0hsd1Bn?=
 =?utf-8?B?TUE2a0dRRU9FZlV3OGx6OVVzMWNFbkJ3dEJjejlhcXExTXFhMU9qS25DVXVF?=
 =?utf-8?B?SDJDTm43TStLYlVsYXY0VEpIc3o4ejVqbm1INFhnQ0ZGNkxKdEhkSG0xQUpP?=
 =?utf-8?B?bzBHSnA5VVZ1N2NEbFNTUEFHeCttRDJmaW9paFVwdUROamdVMFd3bHpBb3Ja?=
 =?utf-8?B?dEdoSmZ3NnFmSVY1MFB1dWZaTFN4QktnUldXdWc3YmVjZEVScE5qOWZkVFlX?=
 =?utf-8?B?NUpPYUhCZTlvb0lSUm9ObCtRb285VTNuKzgwQXJ2WFBEUEIxKzNSemFwT2dO?=
 =?utf-8?B?NG44K01CbUlVTCtaekZzeEp4RnR2cXFESXhaRWpBOUd3dHVCRjgySHhzcC9y?=
 =?utf-8?B?VTFsUkpPM3hoMGNBWWtIb2w0QkpUenpXUVBhTWIrT2VVNjAwMkZIYjY5VzQw?=
 =?utf-8?B?SjdpaUFFdWE5TitIWFc3cUNNc3JRNjhuUnVJdW8xRnpVRjRKTXJFZTBVdHAr?=
 =?utf-8?B?cEd2anlvSVNVTWNha0N0Sm51dVp1ZDBqajdHakR2YTd5YzUxdkJKUit5Tm5K?=
 =?utf-8?B?ZVBpN2xLN3NRU3NpTCtWRlVwYmo5alRJb1R5NXFTV0RxUFR4ajF5WVIzYzlu?=
 =?utf-8?B?YXVoWHJ0VGhoaitLQWllQStvd2NNS2Y1TTN5cXdDcWw2c3QxRE1qS1FERWxq?=
 =?utf-8?B?c200NEV1Umh3ZmhMeVltSHJvVlhQRHUvbmpjR2puOS9KbEVqUXZXRENQS0cy?=
 =?utf-8?B?WDltTk9lYy9leFdYdFg2eVJ3dXY5Tm0rQ1NNaTNocU5TVlpLRnppRFdLSXkx?=
 =?utf-8?B?d3owQmxCdDRlM05oV1g5YTBMdWhFTFFsaGVuRjM2VGlGc3c4dzYrK2tiZDd4?=
 =?utf-8?B?ZzNlRk5zaEdUZGY4OTBWdXlHMTZkOExpYzliOVpoYm40WE8xZGMzZTU5S083?=
 =?utf-8?B?NUNhd1E3aHpLLzJiMzdFSWZYbDU1eGZUa1BKcXhFOFBORVZUV0R1ZG01bDR4?=
 =?utf-8?B?K1R3TTRncXZKa3VqZGk5VlV6WEFVM3VSb3NjVTdmZjRyK2lvczRwWWFST0cy?=
 =?utf-8?B?N2pyTmxvN3hRby9CUE5sZCtaSkpCMFNqUHNzcHlmNXF4UHdHT0syYXJ5VE5H?=
 =?utf-8?B?Q21oenRFcHFXZkFXNVlZR1FERnBLc2NFRG00N1hYdlcrSFE3ZUZnSmxnU044?=
 =?utf-8?B?WDEvNm9rS0h6ZndZY0wxbklTVWgzbjAyNlkwcXQ5STJwTVhnT2hScndYa25P?=
 =?utf-8?B?UUg5WkR5cVhaajNzSEtEWkpWa3NUZmhvVk96VHZyUTFYdzQ0R1cvWS93Z3pv?=
 =?utf-8?B?M041YUppMHNYUzV0a1BGRkxnR05pWTJsaldZRGdNL0RQQU5XVEJpYkRORlVk?=
 =?utf-8?B?VXJzMnRLekZqNzFsdHBKdU56OEhGeGdNOUJNTVcrRmpzdWpwT29lbmlSaHZp?=
 =?utf-8?B?eGhYQjZhUjBKUE9yWVllUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjYxNVlSeVdIbGp1NTF1MExzdC9ndnRabWQraVFqQ1JhTDBNMnpSR1ExTHpF?=
 =?utf-8?B?d2hmeXRYS0RjYUpXS3poN0YrM2ZKdDVla1pZTW5pY0J0aWFiU3h1ckcrM1dV?=
 =?utf-8?B?SWRVdndQd2t3ZS82U0ZMaUVGTHlGM1dpRVNZU1JEUFcrd0p1Zll6S1NSTlU0?=
 =?utf-8?B?Rk5hRnUxYklqZFpsTEd2UWZFR0pqUE1EdlQ1aC9iSTMvUkx1bTlGZkpxK1hF?=
 =?utf-8?B?UCt6SXoxaUJNTjVlYjd1UGoybFFOUDZieUQ1SU1aaC85UXRuVldQa20vTDNj?=
 =?utf-8?B?Y2hLYnFPYWJremI3L3V1elFOd29oZHY4cG9reXJtQkNJdGwwbWNjL3RITlds?=
 =?utf-8?B?YnNVaWNvOHpneUgyQkJJYXA3b0Zjb1Awb1BNUUUveTJseHAzVUFqbGhDZWFK?=
 =?utf-8?B?SklLN1RCeHE2UTFiR0QxdGtiZWtjMG9WdjRpdW8rd1dwdmhKZTBzUWpVKyty?=
 =?utf-8?B?bmk1bUQ4azZ6eEVyVnNrTW5hdTZOd1RvZTdNd0oxRFR3c3BhNER4UUtlY3lo?=
 =?utf-8?B?d3V0ajNOTnJDblJYbXpGZk93eitlY0I3d2MrVzhIYU10VVdWclR0TTU5T2w1?=
 =?utf-8?B?UW00aXhFVEF4dHRhQ0dZSTFWQk5YVjBNbnNHVDBUdklZUHNXdU42cG14RHFx?=
 =?utf-8?B?VVh6Wk1ibVAyZzRqajNaaXVSZ1BpTWRmeUpSWmQvN1gweC9ZbFI4aGVKNXJU?=
 =?utf-8?B?N0FrZ1dKZlJOSjlEZUxtdDNkQUpwdmVycFhXbE1YZlhLOTFwRXhaVFFuZ0RE?=
 =?utf-8?B?ZHQxdEFmU1lsSmNaSCsvZEl1cUhqWnNVNnNtUUk1WGpkMGY5aU9xK0FoQ2kx?=
 =?utf-8?B?WCtGSklXVXkxTXFNcVNhVjFrbDU1SmhEOEFaTmZnMDlXcmJ1V0NCZDhZL0Ur?=
 =?utf-8?B?b01nSTFZMHBtYmNtQm9WV0NDR2FMWmQ0TVQySmdmbm5hbi83djBvY2JLTXlj?=
 =?utf-8?B?bEtxZ3BIUVMzb1Y0SWIrOXhaUWV6QWQ1TFl2UlRrdWFBL2NmRWxOV2pJTmtP?=
 =?utf-8?B?dEtiVmFHdUFoTGx6R3VFbHo0K1NjUTVyTThQTmY0N1dranRiTCtFZXU2dWgr?=
 =?utf-8?B?S2x1SjlIcml0ZzQ4REVnYVBXNkZtWnlwTGVwcmVRQnMxTjJHS3FiNDRsWWxz?=
 =?utf-8?B?UFBtZXA2dHZ1V1p4YXBUa2ZLSkVFR0xPQlJnWkZJZEo3ak5DYnVUR2EwNENC?=
 =?utf-8?B?K0xLTjM1S2xHSmxZNkI0WElOQ2MwcEtJamhESVdpYWZNaDI2cnMrL0tVOUlQ?=
 =?utf-8?B?S2dJZGlwRHBTT3laVENXS0twOTljcVJsN0FKWjk3aEpTMHlscm5KK0VRanBL?=
 =?utf-8?B?UnN1Qlh0SVpGU1RZL0JsVGprWWFIclQ0azZjNTc4YU9pMGRaNUV6NU85aGpi?=
 =?utf-8?B?S1FoNElHQ2RveDF5OUhlRnp4TzBSSitja0pkVUhWQi9DK0szQk5uU1FmS3BP?=
 =?utf-8?B?RXV0MnhmMWovWVNQUno2VnY1Nm14UCtQSnRJQk8wNXRqUmo3QmVOUnJSSmJI?=
 =?utf-8?B?VlkxQ29ORW0zaVFWQlJVYkRFRFJvQU5yRUhwQ3FOdENwMjNvcnU1TXdRNUpt?=
 =?utf-8?B?aUswWk4zL3R1K2ZKYytXNzcvN1RlMVVEaDJkWUlTOGMzaEljSkZIa1E1THk1?=
 =?utf-8?B?Rm5TdlpMSjQ3elNqNVJzdzYySVdvODVvMkIwZ1E5WDNHL1RTQXdUcWtwZkZy?=
 =?utf-8?B?OVJ4eXJwOGZjYUF3V2M5cmxZRS9GU3BpN0J3SWRSVE9La1o1b1lZd2x0aFlT?=
 =?utf-8?B?TGpZL1dYd1RTNkozVUFHcHVLRFljQVY5NnB2QnBDaWJwZEhNL25BUkhkY3My?=
 =?utf-8?B?YzZsUGZRTnZSVlNEL2play8rVEdHYUYvNXdYKzFWYTRTTUlpTklqMk8vZHl5?=
 =?utf-8?B?NEtXK0ZtWk5icFllV1BrZGRrdFc0V0YxSFhKSDJiQXhKS1pCVlhhREtoNXZW?=
 =?utf-8?B?STVaV1NhUk9UdmVNTy9PRERVdHJyTVJ2SkVUT1E0Z2ZUdHRSOHhHZkFuUFdD?=
 =?utf-8?B?Y2VlSTh4T0l0cUtxNnBQemJrWmxZRlBtUXcyU2NKQ0IvY2dLV1pUK1ZVYlZa?=
 =?utf-8?B?VjAwZFBJSHh1M1lucStuR3NRSS9keTB0N3ZDdDlwaXg1ZVVyUDZqazVoNDA2?=
 =?utf-8?Q?+JBur9rxU1sSlEz/8dJ7dhmIw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DDE07AAF42BA847A66598B8BB7A9286@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1063172f-37cd-430c-df98-08dc78b5f8fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 10:16:54.0979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97VR1VTVoCtBgVsJ02NZ+mCct2mwaZBVOR3K6UtcNWaPufU6IHxrg4SmtvwDN6QY9c7fqIDr4fEdYG0e3rmcNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8013
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTAxIGF0IDAzOjUyIC0wNTAwLCBNaWNoYWVsIFJvdGggd3JvdGU6DQo+
IFRoaXMgd2lsbCBoYW5kbGUgdGhlIFJNUCB0YWJsZSB1cGRhdGVzIG5lZWRlZCB0byBwdXQgYSBw
YWdlIGludG8gYQ0KPiBwcml2YXRlIHN0YXRlIGJlZm9yZSBtYXBwaW5nIGl0IGludG8gYW4gU0VW
LVNOUCBndWVzdC4NCj4gDQo+IA0KDQpbLi4uXQ0KDQo+ICtpbnQgc2V2X2dtZW1fcHJlcGFyZShz
dHJ1Y3Qga3ZtICprdm0sIGt2bV9wZm5fdCBwZm4sIGdmbl90IGdmbiwgaW50IG1heF9vcmRlcikN
Cj4gK3sNCj4gKwlzdHJ1Y3Qga3ZtX3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bShrdm0pLT5z
ZXZfaW5mbzsNCj4gKwlrdm1fcGZuX3QgcGZuX2FsaWduZWQ7DQo+ICsJZ2ZuX3QgZ2ZuX2FsaWdu
ZWQ7DQo+ICsJaW50IGxldmVsLCByYzsNCj4gKwlib29sIGFzc2lnbmVkOw0KPiArDQo+ICsJaWYg
KCFzZXZfc25wX2d1ZXN0KGt2bSkpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJcmMgPSBzbnBf
bG9va3VwX3JtcGVudHJ5KHBmbiwgJmFzc2lnbmVkLCAmbGV2ZWwpOw0KPiArCWlmIChyYykgew0K
PiArCQlwcl9lcnJfcmF0ZWxpbWl0ZWQoIlNFVjogRmFpbGVkIHRvIGxvb2sgdXAgUk1QIGVudHJ5
OiBHRk4gJWxseCBQRk4gJWxseCBlcnJvciAlZFxuIiwNCj4gKwkJCQkgICBnZm4sIHBmbiwgcmMp
Ow0KPiArCQlyZXR1cm4gLUVOT0VOVDsNCj4gKwl9DQo+ICsNCj4gKwlpZiAoYXNzaWduZWQpIHsN
Cj4gKwkJcHJfZGVidWcoIiVzOiBhbHJlYWR5IGFzc2lnbmVkOiBnZm4gJWxseCBwZm4gJWxseCBt
YXhfb3JkZXIgJWQgbGV2ZWwgJWRcbiIsDQo+ICsJCQkgX19mdW5jX18sIGdmbiwgcGZuLCBtYXhf
b3JkZXIsIGxldmVsKTsNCj4gKwkJcmV0dXJuIDA7DQo+ICsJfQ0KPiArDQo+ICsJaWYgKGlzX2xh
cmdlX3JtcF9wb3NzaWJsZShrdm0sIHBmbiwgbWF4X29yZGVyKSkgew0KPiArCQlsZXZlbCA9IFBH
X0xFVkVMXzJNOw0KPiArCQlwZm5fYWxpZ25lZCA9IEFMSUdOX0RPV04ocGZuLCBQVFJTX1BFUl9Q
TUQpOw0KPiArCQlnZm5fYWxpZ25lZCA9IEFMSUdOX0RPV04oZ2ZuLCBQVFJTX1BFUl9QTUQpOw0K
PiArCX0gZWxzZSB7DQo+ICsJCWxldmVsID0gUEdfTEVWRUxfNEs7DQo+ICsJCXBmbl9hbGlnbmVk
ID0gcGZuOw0KPiArCQlnZm5fYWxpZ25lZCA9IGdmbjsNCj4gKwl9DQo+ICsNCj4gKwlyYyA9IHJt
cF9tYWtlX3ByaXZhdGUocGZuX2FsaWduZWQsIGdmbl90b19ncGEoZ2ZuX2FsaWduZWQpLCBsZXZl
bCwgc2V2LT5hc2lkLCBmYWxzZSk7DQo+ICsJaWYgKHJjKSB7DQo+ICsJCXByX2Vycl9yYXRlbGlt
aXRlZCgiU0VWOiBGYWlsZWQgdG8gdXBkYXRlIFJNUCBlbnRyeTogR0ZOICVsbHggUEZOICVsbHgg
bGV2ZWwgJWQgZXJyb3IgJWRcbiIsDQo+ICsJCQkJICAgZ2ZuLCBwZm4sIGxldmVsLCByYyk7DQo+
ICsJCXJldHVybiAtRUlOVkFMOw0KPiArCX0NCj4gKw0KPiArCXByX2RlYnVnKCIlczogdXBkYXRl
ZDogZ2ZuICVsbHggcGZuICVsbHggcGZuX2FsaWduZWQgJWxseCBtYXhfb3JkZXIgJWQgbGV2ZWwg
JWRcbiIsDQo+ICsJCSBfX2Z1bmNfXywgZ2ZuLCBwZm4sIHBmbl9hbGlnbmVkLCBtYXhfb3JkZXIs
IGxldmVsKTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL3N2bS9zdm0uYyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gaW5kZXggYjcwNTU2
NjA4ZThkLi42MDc4M2U5ZjJhZTggMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0vc3Zt
LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiBAQCAtNTA4NSw2ICs1MDg1LDgg
QEAgc3RhdGljIHN0cnVjdCBrdm1feDg2X29wcyBzdm1feDg2X29wcyBfX2luaXRkYXRhID0gew0K
PiAgCS52Y3B1X2RlbGl2ZXJfc2lwaV92ZWN0b3IgPSBzdm1fdmNwdV9kZWxpdmVyX3NpcGlfdmVj
dG9yLA0KPiAgCS52Y3B1X2dldF9hcGljdl9pbmhpYml0X3JlYXNvbnMgPSBhdmljX3ZjcHVfZ2V0
X2FwaWN2X2luaGliaXRfcmVhc29ucywNCj4gIAkuYWxsb2NfYXBpY19iYWNraW5nX3BhZ2UgPSBz
dm1fYWxsb2NfYXBpY19iYWNraW5nX3BhZ2UsDQo+ICsNCj4gKwkuZ21lbV9wcmVwYXJlID0gc2V2
X2dtZW1fcHJlcGFyZSwNCj4gIH07DQo+ICANCj4gDQoNCitSaWNrLCBJc2FrdSwNCg0KSSBhbSB3
b25kZXJpbmcgd2hldGhlciB0aGlzIGNhbiBiZSBkb25lIGluIHRoZSBLVk0gcGFnZSBmYXVsdCBo
YW5kbGVyPw0KDQpUaGUgcmVhc29uIHRoYXQgSSBhbSBhc2tpbmcgaXMgS1ZNIHdpbGwgaW50cm9k
dWNlIHNldmVyYWwgbmV3DQprdm1feDg2X29wczo6eHhfcHJpdmF0ZV9zcHRlKCkgb3BzIGZvciBU
RFggdG8gaGFuZGxlIHNldHRpbmcgdXAgdGhlDQpwcml2YXRlIG1hcHBpbmcsIGFuZCBJIGFtIHdv
bmRlcmluZyB3aGV0aGVyIFNOUCBjYW4ganVzdCByZXVzZSBzb21lIG9mDQp0aGVtIHNvIHdlIGNh
biBhdm9pZCBoYXZpbmcgdGhpcyAuZ21lbV9wcmVwYXJlKCk6DQoNCiAgICAgICAgLyogQWRkIGEg
cGFnZSBhcyBwYWdlIHRhYmxlIHBhZ2UgaW50byBwcml2YXRlIHBhZ2UgdGFibGUgKi8NCiAgICAg
ICAgaW50ICgqbGlua19wcml2YXRlX3NwdCkoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4swqAN
CgkJCWVudW0gcGdfbGV2ZWwgbGV2ZWwsIHZvaWQgKnByaXZhdGVfc3B0KTsNCiAgICAgICAgLyoN
CiAgICAgICAgICogRnJlZSBhIHBhZ2UgdGFibGUgcGFnZSBvZiBwcml2YXRlIHBhZ2UgdGFibGUu
DQoJICogLi4uDQogICAgICAgICAqLw0KICAgICAgICBpbnQgKCpmcmVlX3ByaXZhdGVfc3B0KShz
dHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbizCoA0KCQkJZW51bSBwZ19sZXZlbCBsZXZlbCwgdm9p
ZCAqcHJpdmF0ZV9zcHQpOw0KDQogICAgICAgIC8qIEFkZCBhIGd1ZXN0IHByaXZhdGUgcGFnZSBp
bnRvIHByaXZhdGUgcGFnZSB0YWJsZSAqLw0KICAgICAgICBpbnQgKCpzZXRfcHJpdmF0ZV9zcHRl
KShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbizCoA0KCQkJZW51bSBwZ19sZXZlbCBsZXZlbCwg
a3ZtX3Bmbl90IHBmbik7DQoNCiAgICAgICAgLyogUmVtb3ZlIGEgZ3Vlc3QgcHJpdmF0ZSBwYWdl
IGZyb20gcHJpdmF0ZSBwYWdlIHRhYmxlKi8NCiAgICAgICAgaW50ICgqcmVtb3ZlX3ByaXZhdGVf
c3B0ZSkoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4swqANCgkJCWVudW0gcGdfbGV2ZWwgbGV2
ZWwsIGt2bV9wZm5fdCBwZm4pOw0KICAgICAgICAvKg0KICAgICAgICAgKiBLZWVwIGEgZ3Vlc3Qg
cHJpdmF0ZSBwYWdlIG1hcHBlZCBpbiBwcml2YXRlIHBhZ2UgdGFibGUswqANCgkgKiBidXQgY2xl
YXIgaXRzIHByZXNlbnQgYml0DQogICAgICAgICAqLw0KICAgICAgICBpbnQgKCp6YXBfcHJpdmF0
ZV9zcHRlKShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCgkJCWVudW0gcGdfbGV2ZWwgbGV2
ZWwpOw0KDQpUaGUgaWRlYSBiZWhpbmQgdGhlc2UgaXMgaW4gdGhlIGZhdWx0IGhhbmRsZXI6DQoN
Cglib29sIHVzZV9wcml2YXRlX3B0ID0gZmF1bHQtPmlzX3ByaXZhdGUgJibCoA0KCQkJa3ZtX3Vz
ZV9wcml2YXRlX3B0KGt2bSk7DQoNCglyb290X3B0ID0gdXNlX3ByaXZhdGVfcHQgPyBtbXUtPnBy
aXZhdGVfcm9vdF9ocGEgOiBtbXUtPnJvb3RfaHBhOw0KDQoJdGRwX21tdV9mb3JfZWFjaF9wdGUo
Jml0ZXIsIHJvb3RfcHQsIGdmbiwgZ2ZuKzEsIC4uKSB7DQoNCgkJaWYgKHVzZV9wcml2YXRlX3B0
KQ0KCQkJa3ZtX3g4Nl9vcHMtPnh4X3ByaXZhdGVfc3B0ZSgpOw0KCQllbHNlDQoJCQkvLyBub3Jt
YWwgVERQIE1NVSBvcHMNCgl9DQoNCldoaWNoIG1lYW5zOiBpZiB0aGUgZmF1bHQgaXMgZm9yIHBy
aXZhdGUgR1BBLCBfQU5EXyB3aGVuIHRoZSBWTSBoYXMgYQ0Kc2VwYXJhdGUgcHJpdmF0ZSB0YWJs
ZSwgdXNlIHRoZSBzcGVjaWZpYyB4eF9wcml2YXRlX3NwdGUoKSBvcHMgdG8gaGFuZGxlDQpwcml2
YXRlIG1hcHBpbmcuDQoNCkJ1dCBJIGFtIHRoaW5raW5nIHdlIGNhbiB1c2UgdGhvc2UgaG9va3Mg
Zm9yIFNOUCB0b28sIGJlY2F1c2UNCiJjb25jZXB0dWFsbHkiLCBTTlAgYWxzbyBoYXMgY29uY2Vw
dCBvZiAicHJpdmF0ZSBHUEEiIGFuZCBtdXN0IGF0IGxlYXN0DQppc3N1ZSBzb21lIGNvbW1hbmQg
dG8gdXBkYXRlIHRoZSBSTVAgdGFibGUgd2hlbiBwcml2YXRlIG1hcHBpbmcgaXMNCnNldHVwL3Rv
cm4gZG93bi4NCg0KU28gaWYgd2UgY2hhbmdlIHRoZSBhYm92ZSBsb2dpYyB0byB1c2UgZmF1bHQt
PmlzX3ByaXZhdGUsIGJ1dCBub3QNCid1c2VfcHJpdmF0ZV9wdCcgdG8gZGVjaWRlIHdoZXRoZXIg
dG8gaW52b2tlIHRoZQ0Ka3ZtX3g4Nl9vcHM6Onh4X3ByaXZhdGVfc3B0ZSgpLCB0aGVuIHdlIGNh
biBhbHNvIGltcGxlbWVudCBTTlAgY29tbWFuZHMgaW4NCnRob3NlIGNhbGxiYWNrcyBJSVVDOg0K
DQoJaWYgKGZhdWx0LT5pc19wcml2YXRlICYmIGt2bV94ODZfb3BzOjp4eF9wcml2YXRlX3NwdGUo
KSkNCgkJa3ZtX3g4Nl9vcHM6Onh4X3ByaXZhdGVfc3B0ZSgpOw0KCWVsc2UNCgkJLy8gbm9ybWFs
IFREUCBNTVUgb3BlcmF0aW9uDQoNCkZvciBTTlAsIHRoZXNlIGNhbGxiYWNrcyB3aWxsIG9wZXJh
dGUgb24gbm9ybWFsIHBhZ2UgdGFibGUgdXNpbmcgdGhlDQpub3JtYWwgVERQIE1NVSBjb2RlLCBi
dXQgY2FuIGRvIGFkZGl0aW9uYWwgdGhpbmdzIGxpa2UgaXNzdWluZyBjb21tYW5kcyBhcw0Kc2hv
d24gaW4gdGhpcyBwYXRjaC4NCg0KTXkgdW5kZXJzdGFuZGluZyBpcyBTTlAgZG9lc24ndCBuZWVk
IHNwZWNpZmljIGhhbmRsaW5nIGZvciBtaWRkbGUgbGV2ZWwNCnBhZ2UgdGFibGUsIGJ1dCBzaG91
bGQgYmUgYWJsZSB0byB1dGlsaXplIHRoZSBvcHMgd2hlbiBzZXR0aW5nIHVwIC8NCnRlYXJpbmcg
ZG93biB0aGUgbGVhZiBTUFRFPw0KDQo=

