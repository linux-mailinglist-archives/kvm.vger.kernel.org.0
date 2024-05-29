Return-Path: <kvm+bounces-18251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B19498D2A1C
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E8801F267D4
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 01:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8646D13E40C;
	Wed, 29 May 2024 01:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xc7WyWno"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CBA3D6B;
	Wed, 29 May 2024 01:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716947476; cv=fail; b=a7nwV6lACZLLhvEjA83lEotkEO2+8lDCUgRgTBQzwkLnp0+KkXP7DO9X0p4NuxQUH3W1Q5ja+rGK1Ah/Nj+KIStNZ26fYSoacGrKkVeAsygHzBNlpzUuHzBY/PFccpSo0ggw6xd4eaSJb97K1xQ0FlOi5pMFk0RrCCaemicLwVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716947476; c=relaxed/simple;
	bh=3xwUOg5v9Q51unuihSHKuO5df4+G9nemWamKH2biCYM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q1v5HnrNyemvU5TsGMcCQ2A87NorDjzOd+XnaDOJLqvZBhfBgwlNxafMy/mvk4jpiTiZL2n5qvtfpYHrLrxUcv5llwdnZylbFfWZGyOseLQtwM/DWRpGQ4iQbUrfpEiPbzpIscgMOgk8O6htzEGaARViPstpbGkAY2C5Qphhf1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xc7WyWno; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716947475; x=1748483475;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3xwUOg5v9Q51unuihSHKuO5df4+G9nemWamKH2biCYM=;
  b=Xc7WyWnokKf1UVx1WQB6JYQxciZ87Y3jMfH6XKikA1AapS5kA3jhgrFk
   2bRvhvoaDW6FZoFJLubSUQeD4u7hco3MMYe7EW4Wqec3K9GwlSUJUE2V8
   KqeUbKwEFXG+Yrl1mFYCKWl/59LBmilM0zo0JICWJ3WnRt5YQoa8EBTzq
   Vxz8yxrFRTkyW/xfdqZnbagamF4UYUzLxwM1xzLw3zAm7zW7p9wjEziTq
   RdIYE8FfOY6vsSxyjNWCBqTgXQcqQxL1392qrRJdQn43oecPztuV14EsS
   9Jm+R41LWlKN8Im6t71p4Yc0KbL/yCmHlgOdx1tdf7goqaVP3ZhTZV1+t
   A==;
X-CSE-ConnectionGUID: 4RVox1s3TISREK50huqczA==
X-CSE-MsgGUID: zg65uAaHTwKcoyD3Q8DkyQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30853490"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="30853490"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:51:14 -0700
X-CSE-ConnectionGUID: 8Rb26gt6SlKUeykzVaJnYg==
X-CSE-MsgGUID: 2FcMP6rPR/WA6gNWo0RTNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="39701170"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 18:51:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 18:51:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 18:51:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 18:51:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXfxVJp7NCkLf0VwM+d9cJ2R5np2pwQygCT1YoIENh9PDCYjbnU7QHK5FpvoGUxFYZ2Fq+XFvHBIWC21tyoPwYAWNio4h5DWQGL15Myr93OUyhmJ7Kl7Qdz4KW3PG4wKzw+UCaEw9h/6XEh3I/4JkWSQUE3ao3T5IGLImhaxlvzsInXadkIaYwewDX6xQ4tjJdN+upvtwD8mJdhQe7SxyD3XpxHMHg3eI3mAxLlZFEKQ/naNCLvkLEtdgK/NsZBF+J8Tm3hVUtEKXplFiad3WuvmoXIlw+l1kz3NaZqMkCx+B7lQeieFgcZ5hhFnsiFDAkG1r/Naq5yiq1FsaJppYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xwUOg5v9Q51unuihSHKuO5df4+G9nemWamKH2biCYM=;
 b=Z3f4FrnzEnM6G88UwjBsyDLZDuomjQm36Cgku449q+LfnFsqjaodzMhZG1dFGQP/YVJWK1tMGT9ZsEn8Rpb+jfrRtDdqdyVZEX6Eu6DEOgjr+r6YPgU1FoCeFlwnFnN9Xg5DxlWwZMK3BTBauC7BuCutj9cBzmU4Uh2gwBXEpQfnNsrrvWRdc4FbdnXkuL9NRtjPCgf8sQ0myMSlCQH4dGCQLCiUd4tZ6yueoOII6q8Lj83w88PjauQN1Ob7PFNMwBU4m4n0B6brNbYMyguzhdj4p+Ieo2aF0KPcIV9NW1ODp3MZkHWEgDgej0ypeapKk+jinqwMOLtrN4ZeSxpaxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN6PR11MB8193.namprd11.prod.outlook.com (2603:10b6:208:47a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Wed, 29 May
 2024 01:51:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 01:51:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABzkACAAGxrAIAAmmaAgAAQyQCAESg3gIAAFG4AgABuyYCAAAx8AA==
Date: Wed, 29 May 2024 01:51:11 +0000
Message-ID: <c4dde72d66499c45fb3bfba640b72350abed3d67.camel@intel.com>
References: <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
	 <20240517090348.GN168153@ls.amr.corp.intel.com>
	 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
	 <20240517191630.GC412700@ls.amr.corp.intel.com>
	 <CABgObfY=RnDFcs8Mxt3RZYmA1nQ24dux3Rhs4hK0ZfeE_OtLUw@mail.gmail.com>
	 <3fa97619ca852854408eec8bb2f7a0ed635b3c1d.camel@intel.com>
	 <20240529010629.GC386318@ls.amr.corp.intel.com>
In-Reply-To: <20240529010629.GC386318@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN6PR11MB8193:EE_
x-ms-office365-filtering-correlation-id: 7d7bab4a-eb5a-4081-f74a-08dc7f81d0e9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?OWlRb3c5NHp6bThhZHVnUnEwUlZna2x5MW1rV3RMYXlkc1hHRFVCS1Jxc2tM?=
 =?utf-8?B?RTczZGVMZFgzVGFkL3ROemtiMDNEbjhmVExLNTk5WDJSRjJBSkZLcFF3M2VP?=
 =?utf-8?B?Ni8yOVlpb1hpbWVoRTNoc1d3TWVzQVplTjg5MUNYMm9pNjBRMXV5WmFTYmts?=
 =?utf-8?B?WkMwZkRYajVxUmFpN0xrZGRzQXN5aXhUaVhQK3N4UzBlTWNUUUpFVjBKdFNU?=
 =?utf-8?B?SHJMUXY1cnpvS1E2cFo1OTRIcVFqWTVtV3hzbUdMZHdjYWZUMXpTVmwzbjJj?=
 =?utf-8?B?c0pnS2d2em5hU3g2bGRJTkwvSVJZNndwcWt5RmtsV05RelVHb1BscmNReVJN?=
 =?utf-8?B?aFVsczBUZ3RYWHdkZlJwdHIwNWN3ZlBrOGJ4Q0w0Y20yVXNucUNNT2RsaENV?=
 =?utf-8?B?c1QvRU0rbVJqcVpRRDlKMGtpYk4wVFFMbDgwYmtiSmhuY0Y2U0lHZHZVb2FK?=
 =?utf-8?B?UDIxREFYSmVkeGl1Y0U3cjZjU3RoR0gvblRsVjV0ZzJMWmJLM1dmQnBFdGtD?=
 =?utf-8?B?WlozUjdwdVRERC9KQjNwUlNnbjlWdjluSE1QUWsyTFlTZ09QRXVmOUYyVnNB?=
 =?utf-8?B?Z1ZZcU1Vdit1YWVRZU95WkJGRmRRQUJGWmFKYkZLcitCL2hWYTN1TnRxVXVp?=
 =?utf-8?B?cTRvdlB2MGZLalhTSVB6eWlvNVdxd3Y3Ti9iajlQaWpRdkt4M2VYUFJYYzJ3?=
 =?utf-8?B?alJqdHd1Rlc3cU82d0c3NjcrN09JSUlTOVJicXF0S0QxclY5NW00aXVoeGZY?=
 =?utf-8?B?RkJ4WHgzOFRXMGFBcGh3YTlkbmVTdUthWE9SWFdtR203SG9IdDdsRDZ2d2ll?=
 =?utf-8?B?SXdTL3BrYUFuRmM4RUdBYTFlM0FLTUVMM3NqcnpPemIybzV4MUlJQ3FYY1RC?=
 =?utf-8?B?OUREUHRYMHgzS3dNMkVYaXNML2ZYVGtJSE9pb0puQ0tEeEtQemN2Rmd2TndF?=
 =?utf-8?B?ZXR4elVYR3lwaHMrYXNtYWFVeWMvQ2R4MlcwbnZyVDB6MExQWGFXWFZQZ051?=
 =?utf-8?B?SjdUNkh5TXRvYWc2NVVXWFV1ZUR1Qlpsc1lTdTZOckI3QWg0TkNOMkV2cE92?=
 =?utf-8?B?MUlnK0xINVZKOVNURFphWThhdEttekV6NVhDUGVRK1VRZGFKK0NlZUFhcEU4?=
 =?utf-8?B?R0hVUU00ckNCdXlTSzd6emhjMWVSbmFwL3Z3Ny9EWE5GRXFCTGpPVFFKd0Rp?=
 =?utf-8?B?ekZpOVBJcVN6dHF1Mm9FdzExcnBIK1R6MjYyVlRxeVl0VTVUTjRLb0JKanpu?=
 =?utf-8?B?T080dVh0c0o2a0RuRnNuWUxxV2JuZ2pFdVduV3NLbEIzL1hwZElJTFU0NDZj?=
 =?utf-8?B?U3g5dGhsV3hjbDRDT0Q1TVNJdyt6QzRvWmdCNGhObUV2d3QvTk5nalFUQk11?=
 =?utf-8?B?d21pUjFzTTI2OEczUzVLSFZuZVdGemVNUy96cHNYL1JzUUVYc1RzeDUrMENG?=
 =?utf-8?B?UnkyM1ZjdGt1a09IemNReW5zMzdsaFBkdUx4MVJtMnJDdjF0b2N2d2FCNWNL?=
 =?utf-8?B?bEd6N0dMa2tKMmVFS2dLVlA2RFJ2TStNK2lUZE1pRGZLcm8yRUlTTWZrU3dH?=
 =?utf-8?B?RW51aHVDbVFmRGhIbkY0bUlYcUQvdlNmY0NYSHR5MzM2dUFFZjh2VFNZa1hE?=
 =?utf-8?B?MjUzcndjZXoxN2x1L2FvQUNoZzdwL0I3dWFLOWhldFRpVVVIZUt0dk8zYVNK?=
 =?utf-8?B?OFB5TGgzbzVGSFV3VzQxcmd5eWY3M3VDRTVOWlYzVjVqUFplUGZmendzVytM?=
 =?utf-8?B?VmhzekdUVTR0UkQ4eC94YkFBdUZzc21LdDZUVXh1TThUOFVwY1N4M3Y2UUlK?=
 =?utf-8?B?aElRcG54bmV3MlJKS3U0UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmNZc201aVpxTThrd0JKd083OGtoR3BUSXpwQzQvNThPYTJqaVpPYVdTSmxO?=
 =?utf-8?B?ZkhVV2lMOU5mWWYwL2FSMC81THI3STVnQ3AzZ3hFTGFvdDQ1c3Iwa1REa0hK?=
 =?utf-8?B?dC80RFZJNW5UbGoyZVVmN09iMS9KSXdkdzU5c2h3b0lKTUVtOXVrcmNYRW1j?=
 =?utf-8?B?Z09Yb1hZUFltM2NFSGc3dTZPUWRNU1k5bXlickF2MnVjVVkrU1VIU1pFNHVO?=
 =?utf-8?B?c2x2VFhIT0UzWXoxUlUvNXpLd2d1SXFwRkwzMTlqMVVoa28zVmJnWVRZM1dr?=
 =?utf-8?B?UDV6YXd3Ti9XSGFiZ2s4ci9nc1FyYTBudlpycDduYUJ5L0VDSlMzOTQ5TVBl?=
 =?utf-8?B?bG9pQ1RHdVRwQ0xIMEZmTERvQjgvMjY4ZkZzL2Q4Mi9BbmFmTEN3bWxPUy8w?=
 =?utf-8?B?Q2NDM0ZRaGRCbnBiNk9scTJCNEd2WjJtQklKQXhTdms5TmtJSW5TaURpTHBX?=
 =?utf-8?B?dFJXL0RpU0Fsa2VqVDRIc2tkQTk3NlVaT3pNWEZwUUNncFpTamxpdVpKS0hT?=
 =?utf-8?B?c3FxWkVicWFQdXh4ZWdRVFc0Y0V2SEs3WEJPS2FKdUE2SHorWUFKK1JKMFQr?=
 =?utf-8?B?WjBvOFk5bzdPMUZ2ZE1sMGRmdmVpTjBuY1JVZW1YVWNSUVRibE9IaXN2VEMr?=
 =?utf-8?B?SW9ISjhhSHROWEpEUlhIKzViM1QvSTY4VzE4dHFsMitKSXo2Nkt2R1ZPUlZm?=
 =?utf-8?B?QWljWkVza3JxMnRPZGt2bVdRNG03QlJlcXVoTlRPUmJMYlBMRWhQM0ZkbWZl?=
 =?utf-8?B?K1NMR2s2TW9Ud1QwVXo0bE40RmFhaHJETHB6TTJIc2tXT2VlWTFaUWpMaC9u?=
 =?utf-8?B?bHd3VVFMbDVrT29hRzU5T0dQL1orRHcyLzBNVk5NUk91S2IvUUI0ay94VG1i?=
 =?utf-8?B?Y0dUd3RlVnc2T0UzMVdnNWlTeXZZMDVpQUhRZnlUdUl1cmw5eDVvMDJSaUM4?=
 =?utf-8?B?Z0NVYUNKTGRTZ1RjQy9FUzVsMllxbDNNYmtEOXBBc0lsSFBNbnBCbU0yMzJx?=
 =?utf-8?B?RmNjZlJoTmlQallXUFI4U0lDQjg0UGVVaGhGeC9ja2Z5TTRzYUxTWEdhZG1F?=
 =?utf-8?B?Uys4d1VoWVFGU0YvMU1NUFZ2aTBJMlNJQVBQOTU3dmRKU0k2TXhPRTM5YTc4?=
 =?utf-8?B?bStSK3VoblNVb21KV3NwMitSdGJMRHQ4bnF2Z2kyZGlScUR6NUc4M3pZRFpG?=
 =?utf-8?B?eGJCeHBZMTNhMC90ZkplQm9kYjFyakpsZ212TEVEeHZSMkVDQkdTWkNkQTUv?=
 =?utf-8?B?aFpnMG5pNjVkMEIwaHVCMkM3OWlKYUVIcmw5WTkzdXM0MUlraEJ6WGRIU0g5?=
 =?utf-8?B?RjJKZDVlYmtSK2I1N2k0eFh2ZUE1dmhDMm9MaEFERDJleldBYzY0V2ZNcXdi?=
 =?utf-8?B?cWtQQW1OQUJzeGJxWFJsRU1RTTRqRzJNWFNDWE40YUcyejk1TnFKTHIzaWoz?=
 =?utf-8?B?bHRWN1pSQVpTcnVVNG5sb3BlYzRUTS9XUmVUVXladmxSM2NVUjhTd282SGxj?=
 =?utf-8?B?K0x2cDFJTzFQb3BJNm9jVU1GaFV5amNWNUo4bWNVb3ZLSHIyV1ZVUzlRNlRw?=
 =?utf-8?B?QVFJa2JFWnh6S3I0QlpHVjFNZEhacEh6VFBkc1I5MVVXTVN3VW1wRmcwV1My?=
 =?utf-8?B?YS9aQ0hxNTUwR0NPcXZPSDBXQWM5Tjd0bnd1V3RGUEJLRmZRNXVYMkI2OUYz?=
 =?utf-8?B?dU9NYWZiZXlxOVZiUmFxNC9McXBXTXJhNDJydXBrTDdsUHQ1QytQY1UvSkNx?=
 =?utf-8?B?Qk1BcmhaOFJIZEh4N2tsNC9YVURSR2dlN0E1QmtVSlZveXZMUHRqUG5MbW1B?=
 =?utf-8?B?cTh0eHdkNFBnSnJ4N0hwa0c5dGw5TDU2YS9YeGdUVXVIZE14cFZYVUVwWGp2?=
 =?utf-8?B?dnE0UmoxVWNNdUVKZzB3d2oyYkwzLzZqdjFHRW9Fb1JLelRBNjhQTlY4eW1W?=
 =?utf-8?B?eUk5KzJqQ2FEcEFkL0t1c0haQ2liVndoWDdqSlgyYWg4NFpWc3NPYWJYSkFX?=
 =?utf-8?B?Z1NCNjB0YlJwR1hvb0ZKTkkzZ21TbUNUV0R6bEtpb1lmeFBhN1dIeGRTbzJy?=
 =?utf-8?B?MEdUSys2Nmtrd1ViNUlJdFRGSXY1RUp0aGFJcllDUVhoUUo1dXlka0hXUmZL?=
 =?utf-8?B?enpuTDJ1NUNCK3l1WU5wN0Ewc3A2aGRXTEhHYVlhYzRlSXNqbmVEQjk3TEV3?=
 =?utf-8?Q?Gn4C+skdNo/HjYYZC/5yv9U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C61E209A99C5E247935BB5C37EC9810F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7bab4a-eb5a-4081-f74a-08dc7f81d0e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 01:51:11.2165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MxLbkK2il6/9867wTW7u/ghm16znH67a7Age0FjgiyN0MycAtEQ1UNMHv6pSzFYQBns/FRFc6oKR5osBqxtotsJPX0criPwM0xs86oPlV+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8193
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTI4IGF0IDE4OjA2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gDQo+IGt2bV94ODZfb3BzLmZsdXNoX3JlbW90ZV90bGJzX3JhbmdlKCkgaXMgZGVmaW5lZCBv
bmx5IHdoZW4gQ09ORklHX0hZUEVSVj15Lg0KPiBXZSBuZWVkICNpZmRlZiBfX0tWTV9IQVZFX0FS
Q0hfRkxVU0hfUkVNT1RFX1RMQlNfUkFOR0XCoCAuLi4gI2VuZGlmIGFyb3VuZCB0aGUNCj4gZnVu
Y3Rpb24uDQoNCk9oLCByaWdodC4gVGhhbmtzLg0K

