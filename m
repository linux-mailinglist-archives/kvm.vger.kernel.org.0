Return-Path: <kvm+bounces-33167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A659E5D07
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 18:26:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2297E16740E
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 17:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC23224B1D;
	Thu,  5 Dec 2024 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oCnq+10P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD152EB1F;
	Thu,  5 Dec 2024 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419562; cv=fail; b=FEkzljVNJSul9jwNJE7wWERgf4ph7xU9IoXBmZO39jpmhcdRVuF/0GjwxhzeEKQ5ouiOthW5ARzaR0y7feFzL7BgUusuD10QHgtYQPJPVLWFYM/qWwxbSHu2PwlXq4rUNTQZGoktx1zO7Gmb88MGBsDnFA4cmW1TM/NU4pDNvdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419562; c=relaxed/simple;
	bh=kCtjmNXtfnkMRxbyniXzBxIYD02Nn9lfwL5UzmB0pgE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UBKZOfFO1oSLrsUegtZvhiL5lAE1AeAuuIl1YNKp/Y0Qi7kojAH09V3W4fbHSWf07nqnEhNh7arFqqNJbLRqMgC7U1RckEk4GNCO1H3Ka+0rFYUvwjqbIWBkD0vQJL9WxojhTNm18nBAxeC+Y3cyuKwaYB4fav0yLvPEA91j0wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oCnq+10P; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733419561; x=1764955561;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kCtjmNXtfnkMRxbyniXzBxIYD02Nn9lfwL5UzmB0pgE=;
  b=oCnq+10PAqaVUDiV+RjGbj6EGJFbMZwyP/aEFfNdpq6L35iUPb7cAAyB
   dzyakmAhGF5k5/ULNi7g/4ed4FxgS+XIfhTPsk/3+ZoMJvSAYf9pWY4TS
   linuVW7fmS9dmkU9ndNAuS6WweL6kuO/ykD9t8vWFpC2BUFZYL+iWk4fl
   ugup/sP4rHItR7XTOTTlEBS+ChuNwpCtash78iRXNMtcouWbh1+BgXEXX
   eqiIuqsBEAKTofhF+ESe8T8HKaq15OoUCgAoIDKGlMYtvMGb3GGtASyLH
   yrEbV94pqf+3+sqmVuafPAMRWGPz+y59ZBGiMpCvYyA6JGhhyMmfR9Sv4
   g==;
X-CSE-ConnectionGUID: Bn46kucGTCWw5QyL2p12/g==
X-CSE-MsgGUID: CIg+p1CNRb+XM5VQV9U16Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="45127355"
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="45127355"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 09:26:00 -0800
X-CSE-ConnectionGUID: PzQUUrxsRUetOrvh0rUlAw==
X-CSE-MsgGUID: X4je+C69TpSfX4C/hpz9BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="99200300"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2024 09:25:59 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Dec 2024 09:25:59 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Dec 2024 09:25:59 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Dec 2024 09:25:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=igyLASj6YoytIwgWRzizOjqttP4qyLJItGjrG2byGXXuwpn72WC7fq7nXSoFBK6lZw+Yrw10KtMhAWcykZ5JDIFrRN4VWyB+r18/gYt8EXbBfRs6aZPhov32vusNIgDfOcPH5YVVLOFCi4tg/hhVudsTI8sz5+mApsByLBcSETO+RYfLUwNXyfuCPZcreL6iBjV+fHtEowftS9isdovsqwy2RN0tvr2ZCOzsZvnnpCbhQNcmYLV9mSpNyxc6idieHaY53NLPNwsWmR6nwcE+NQ53YU1+lpilmUbakCVwuE+pY+eGQW8p2TnDDS35brYTdgMAiU9FM/M4RROZW6G3rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCtjmNXtfnkMRxbyniXzBxIYD02Nn9lfwL5UzmB0pgE=;
 b=xay3jEVWY4jpnx1HGlOvWbBOCXo/QONvsxQPAKAPHowQ3lmGs93pMD3rST4dqYMUpAL1/PHJ1V0yPx40ZodBvHNaXC48yW19/fafmR2cCi6aDbSHy16JFpP0tkMYotH8QigX+9cGjugltAIXhmk+CslB8SwYkpYmeCBNnDUTvvuHelpmQ0s5OGGEgFIAMReF6+W7B65DlMPGvh17lviKTr53+fZOOpfvsZhSA2N1GQvvkkC5FOt54tAea4ug4FUK6faKhUmM9DlKqizicKGKNQsr4AMXPYskanqYOajdAL7Wfkz+IqVXp9rN9TAgStI3t80dz0ozVrhw3tivaNEAMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB7117.namprd11.prod.outlook.com (2603:10b6:510:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.16; Thu, 5 Dec
 2024 17:25:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 17:25:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "yuan.yao@intel.com" <yuan.yao@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v2 2/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD
 creation
Thread-Topic: [RFC PATCH v2 2/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 TD creation
Thread-Index: AQHbRR86MNs4refpEU2Wtl2ccm6Cc7LWglUAgAFo5gA=
Date: Thu, 5 Dec 2024 17:25:55 +0000
Message-ID: <090da4a7e0184ec86a127e1d463aa7dd5076b8eb.camel@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
	 <20241203010317.827803-3-rick.p.edgecombe@intel.com>
	 <0070a616-5233-4a8d-8797-eb9f182f074d@intel.com>
In-Reply-To: <0070a616-5233-4a8d-8797-eb9f182f074d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB7117:EE_
x-ms-office365-filtering-correlation-id: 87742c3b-92f3-4bee-9e8e-08dd1551e042
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NHF2dlh0SGNqU2cwZnc4YUVvbzhSRWFXQytVK1dwZ2lzSHhZTHBkK2RmYVdI?=
 =?utf-8?B?RjhTQ0MzYUVjekxEWnVOYmpid0VVdkxWRm5ZOXltNHhIem0zaWI2V1ZkOUFU?=
 =?utf-8?B?d1FJTjFQM0VjZThSdU9wUDY0VXo3NkYzTE9EN2dTbUcrMExqZFVuc0xBTlVG?=
 =?utf-8?B?bzNnYW5iZTlsNEd5Nmhic1FIS25mK2Vvc1dsT0ZGZkFxbW1ORjI4UzJPS0lV?=
 =?utf-8?B?OC9mclA0TkRGUHh1UTAvYnBDN3RheGRkVEdMbFVRcmxHZEZGZXk2aTN1cjVE?=
 =?utf-8?B?OUdNT2Q3VXJyK3QxYVRvRHRpNmpKVWFPczRHdDN6RjZQcnVzWDE4bWxqTUpY?=
 =?utf-8?B?amV3TUozQ1N2RzI4NS9EMnRLZHNxbEhRd0hMSzlremR5cnk4UEhxZFR3Mmx5?=
 =?utf-8?B?Tmd6L2ZuTExkUmJuRTBzeVptYmpEQlJicVdzODhBZDMvTTFWZzIwN1g0a3pZ?=
 =?utf-8?B?eURqeGhpWEQ4eC9FSG1nbnZYWHFmUzkwUzhEY0oybDF6ck8zRFlaeHlDS2R0?=
 =?utf-8?B?N2ZCN1RBN0pJUHVXV3pJc3BsSWx6b0pQN3V1UHd0SWpxUDBSWXo1OXQ0TWE5?=
 =?utf-8?B?V0FhOFBwK3RSczFLZmdtaE1iUzVsWmlBNFZQTk5WUVdIWjJEYW1paFROR1JY?=
 =?utf-8?B?MU93N2drb25SOFE0bFpSSlVEcSt5VEluZ2x4R2QxYzIwZHRKWnFxTjRGc1lx?=
 =?utf-8?B?OFN6ekpSR2RhUGJManVTZTRiY0g0bjBjTm52UzhsRnhhbWhPVGx0QkJCWkEy?=
 =?utf-8?B?WUxQRHVCSVJMaVN5cU5HZWQ2NlpTVTY1bUphdHZUNjd2ZmM5aVJkQ1NhenFL?=
 =?utf-8?B?MjhOcUNXNGxCV1JQTGtkY3E1OXUwSFVKUVJSdGw3dDNkS25aWHRzOXVmVXVV?=
 =?utf-8?B?ZTFNVnlRazJCK2NiUEt1NEZFem5zcHdTb0p5TTYyM0RLNzZsUUd1YUcwMHd4?=
 =?utf-8?B?NU9VK3h3Q3Aremo5UTY0eVdiaUVRMHhpTGhHdGhGa1lneHpkRHk0KzVwc0tJ?=
 =?utf-8?B?Z0huZ0paempEaXo3RDRRNTdNbWwxSzVLRFppN01HTzh0Nk9jMnVGTUFZVGdq?=
 =?utf-8?B?azNEc3ZXTDE1Y0c1MkV4NFJqa1BXMHZjTXdqakZ0aHByMmpBNHZYQ1JSNnNR?=
 =?utf-8?B?RkpuaUNod09LU0RWTUExUFNFWCtrU2NBQ2o5anRKUU9KYjJDMm9TcnNRTlFT?=
 =?utf-8?B?ZVlQNEdBZHNwZndMZ2VIN1FicE42NzFHU0V1Z2YyMHNrZkJOTVZjcFJMbmhn?=
 =?utf-8?B?WmxGWFZWT3QySnJnTnhaYk5raVVEN3lXZTVQc3pLMlhmL0ZnaFR2MFJlUFZW?=
 =?utf-8?B?UjVXTmQ4UEVaVHBIRW1ZWVJZR01lT0dmZnJZcEo2OS9OakJMWFcycXJnY1VS?=
 =?utf-8?B?eGFZV3BEeUFEUHVFNjE1dUV5ZCtDZFExK0ZCUHhHdGRRdDd2WmlSV2swSUd6?=
 =?utf-8?B?UUF6N285aUg1K1dIUnpZNFRlcHlTY2s4WW5UTUt4Z21jWXpZV1U4ME01dGp0?=
 =?utf-8?B?OVZvVGdEMWJiY1NBNXEvWlhHZSsyWHhsUlpHQzRhMWkwMkJwbjdlSFozd25V?=
 =?utf-8?B?bVYvWldqVHU0UWlJblBHN3hlazQ2SFg3TzUvejBFNjJHZytxN2ZaUHJvZnJ3?=
 =?utf-8?B?L29PV3IrbG95ZlFSUTM3OXhFVEtkOHBsQjN6ZWRXVHFVenFJV2Y2RzdZKzVv?=
 =?utf-8?B?VkJWZjllMEI2Mmplbzc1K2xPSFg1djI2ekJYYVk2dkpRcW1IYzB3K1BqUkxF?=
 =?utf-8?B?bE8rMWJzaStRN0NWR1MvYVkvc3lnbndLTUt0aFpLYnNKUmJCbkNYMC9NcGZm?=
 =?utf-8?B?QkFOZnVYYXdaOE5UWThhSkRKU1lDUGlpNG9kNC83b01qNEYyMTRwaEUvZE1y?=
 =?utf-8?B?akdabW9Tazl0ZGdZTzR6b204ZkVMb3ZtSXBQU2xBNm1ocEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTFKSVB3NmMxRnNEYitXbytySFVaWXJUVG51MUV3TE5QMkhvVER4dDF5MFVq?=
 =?utf-8?B?N0xrUDlCa1Y0R29SWjFVd2J6UXBWODgxZjdXSU51eUl6d3lFOFV3RnlvaW1l?=
 =?utf-8?B?K1VSK2ZnZEZtK2FnZUt3ZHJHMm1POXpVM1kzZ1lsbTliSHp5R0RocmNoNEw4?=
 =?utf-8?B?Skg4eFAzUld6K1U0WWErZHVGQUNJaFRrUFgyZk1MTnFKUTYrejRKdUhPelll?=
 =?utf-8?B?OXBTZDhycjY3UHRXck5Jd0F2djZtNjJyRG5XaHZlZGhDRUYyZDVnK3J5UE1l?=
 =?utf-8?B?VldoaHNpRXVNb21NL0txZnFZK1pEWXZBODhPT2t2d2tJUWtrN29qSFlLdlk1?=
 =?utf-8?B?eXZLN2JuQlJVcHdLejRjcDNWcWtlVFdRNUsvSng2QXpNb3NwbXoxT3h4Z3NN?=
 =?utf-8?B?QWU1dHVkUGZ3aFRQaEFDb3JyZVo1Vjl0aEg3RHljVkJIWElEWVpjcGxvZTRs?=
 =?utf-8?B?UFEzbjRyMy8zOHN3SmlFSllxU0J6RWlkcUZQK003dmVScU8vdTlUOU9MV3NB?=
 =?utf-8?B?NjdGc1hCQ1dDRkd4UEkwZ1djK2M4cmp3STFKV1M4UGZVQzg3Tm5qM3U4dHdF?=
 =?utf-8?B?NjltWU44UmdXQ1RBcVRtQVVhb0dOckhwSE9TNk1RZ2NYL216MlluTnAxUStr?=
 =?utf-8?B?QVBVYUNQdkxQbG5lSW1aU3JwajI5TEZXSExnV0prVWVPYk42dzdaNmx0VDZw?=
 =?utf-8?B?S2NhVW5oelAvSVljcFNiUDhqVWtyTHdoNGJQUEpCbjFwSnYvMWI4Q3VlNHlw?=
 =?utf-8?B?bEFvVmFKRjMxYU1MZjR5U3ZLTFJyNkl2SUYrM25Dakh3Yi8xKzlTUzVvRHBZ?=
 =?utf-8?B?SkJWVkpmd3oyR3FRVWhBODNrMnBUQktGdFRvUmJSYllWRVRRc2ZHMnZoN2ZU?=
 =?utf-8?B?dVRPQi9iYmZ1a1JsNFdzU1pOKzUvekJyL3JrUEg1Vy81Qzc5cG5rQ0RRSHB0?=
 =?utf-8?B?MVdNQ2poTlpsOTBTVG52b2FFa1BtSUJ0SUJTSHdXcmM2UWtLeE5qNklGT2c1?=
 =?utf-8?B?cUZDMWlPVG9uUFZTMS8wMi9hMjdCWms1ak9iN1VuR1FBaC93NGdmamFKQmx5?=
 =?utf-8?B?eW9RNDlzWGF0QlNGZGJsdGpVaGxnMVBobWRXeDRNVzM4NE5OSlI5amlwcnN3?=
 =?utf-8?B?U1dLNHUrZVRWSnExQTh0QzBKaENMUHlXWWkzVzRsWmZWaCt6VFQzQytlSS9K?=
 =?utf-8?B?RkY2YzRQT3BNMm8rOTg1c0RjeTI3cUFINEZCUWxlS3Z3N015L0JzZFZEREhy?=
 =?utf-8?B?T3dZMUJMK0E5RWFMZjFWUmhvNWtCeTVieitOS0ZYMFVHci92WC9oeFUyK1NV?=
 =?utf-8?B?TTBMbzEvbnBuOXQrSXBOQVkydjZYeDRob3JkTGtJSkNZZ3NrWldDQnhrOGQ0?=
 =?utf-8?B?UkZ0dDZnZ01FUWtjeGM2SDBYUldkdkJMUzdIdTdMNlhDZllHb2hGQVVIa3pR?=
 =?utf-8?B?SzJnUkdkdS85d2poV09mME5XNXRLTDB0YW0zK0tIdmtrT2t1c2tVeUNYQ0RD?=
 =?utf-8?B?TFREYzBFZm02YkxaQzZJbGFrR2dEdzVyQWZIT2U2cmI3NHROUGlZQzkzVWJ6?=
 =?utf-8?B?NUdNSlh0YWFTZVI5d3ErWEVFems3UlM0VDdMamJjUnhBMDh4N0FlUmRxZnBH?=
 =?utf-8?B?R1F2TnZkQmpnMUdSNGQyUzVHaGk4TWQ3TzJXd05XWGw2KzVxZ0tTOXc4TlpI?=
 =?utf-8?B?bTEzc0ExWk5zc1Zja212UEFoT0E2NndCTTlwcnZpSDcxL1F5VWlXVS9yZ0pE?=
 =?utf-8?B?eE1ZUFgwY3EyMVF1Z0xrUEhQQjlsN1ZLcWNIcGRvOCtLeDYzQ2JJeWltMlRY?=
 =?utf-8?B?Y0VvUTF0bzBtTVJsMVNhV3BFR1RYQW16cTRFMW5pRGdsbU91RGZYTFhVV0sy?=
 =?utf-8?B?cjZJM0tSeG4rQmZjSy9WcTFUTXFzbGR0QXJtNzFzend2WXgrbmdLeWtrSjlQ?=
 =?utf-8?B?a1NjV0cza3dOSzdNMlNkaUd1T0s3SHZoM05lSktoYUdJT0ZqQXBCTFoxblp4?=
 =?utf-8?B?ZEJQR0tHSXArbi9GdmtvelIycVpBbGxId05aUUg5N2VSWmdObnJzcXA2NHZS?=
 =?utf-8?B?UUFtNDh0TGxURnpCN3hYYkRPbVFZbkNnc3R6TloxcGsvam5iblhJSnorRXNp?=
 =?utf-8?B?Z1p5d2pHczVUSk1hMGg3TVAzRVFOTjN3SVJhVVJXUGFBLzBJZjNGSWI3YVJE?=
 =?utf-8?B?L3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78F1627F8636F948895E193954D62F5C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87742c3b-92f3-4bee-9e8e-08dd1551e042
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2024 17:25:55.5345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +MkhAymk6IJWe6llZ4JprhXBu8+WrKg5n7Hp9NhCpfaWl+SzkblNHUEZcPUoz3wV/Np3B8Ij6JdPLMhJ8p4R6nahBneLvue0nVSAntt34Ac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7117
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEyLTA0IGF0IDExOjU0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvMi8yNCAxNzowMywgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gK3U2NCB0ZGhfbW5n
X2FkZGN4KHN0cnVjdCB0ZHhfdGQgKnRkLCBzdHJ1Y3QgcGFnZSAqdGRjc19wYWdlKQ0KPiA+ICt7
DQo+ID4gKwlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+ID4gKwkJLnJjeCA9IHBh
Z2VfdG9fcGZuKHRkY3NfcGFnZSkgPDwgUEFHRV9TSElGVCwNCj4gDQo+IFRoaXMgaXMgYSBuaXQs
IGJ1dCB0aGVyZSBpcyBhIHBhZ2VfdG9fcGh5cygpLg0KDQpJIGFsbW9zdCB1c2VkIHRoYXQsIGJ1
dCB0aGUgbWFjcm8gY2FzdHMgdG8gZG1hX2FkZHJfdCB3aGljaCBkaWRuJ3QgcXVpdGUgZml0DQp0
aGVzZSBjYWxsZXJzLiBTZWVtcyBvayB0aG91Z2guDQo=

