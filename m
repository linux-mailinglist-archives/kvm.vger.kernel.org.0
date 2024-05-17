Return-Path: <kvm+bounces-17565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B71D18C7FA8
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 03:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DBE12843AF
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 01:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9374F4C6B;
	Fri, 17 May 2024 01:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fBHjWpGw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFDE17D2;
	Fri, 17 May 2024 01:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715910670; cv=fail; b=aScF/MlJSO5gfQZGPoF4FXSE+khXkjRR/K8z5hJQfgkTaChlh8sK+CiRjuYfOlBqofRBWT0rYy56R3DAsal+SmQ4XI5VUuxai1zQiPxUPqVeXPydujt0AdY70V4ALE5lQwGkUbuEOVOYA/uEgz4AyAFsqilljryWik+rtC3Uom4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715910670; c=relaxed/simple;
	bh=6V1Eely0tCMaUhP7jxGDoOFYdyOezkkh5FJeB/MUbeQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CGYSyuTIap8O9xfrzSEM4OoGGGuok4YXxM+gtiMD0Quj7qJjTtsq2q4dL2FX+HtS6tEbSc/NcT3rmh1bEbdH3oPDSJNGHN2AtuGtlrMniqbhMgPYALWSZPTBrfMTeAjFfBuVib5EfIO9ajIMumKoAQJM9FeZBH+7QEzSMeD4gAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fBHjWpGw; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715910668; x=1747446668;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6V1Eely0tCMaUhP7jxGDoOFYdyOezkkh5FJeB/MUbeQ=;
  b=fBHjWpGw+po+s81gLlahZCJxGJB+CZerJui+PTGyam+QO+2t8buXUl2o
   BeSTC0rm/hgc+HsN9faIiMMBy3xpNnWr72LDA/wIya7q9pzuyLTGhNnj9
   M6Le1g2HQ6lmumRD8AuJV4+Pxv/ksgTTh8rtb7ct7vEXJbxfIdelW37eZ
   PWGur5nhIUUpdCZlhjIy7c1oMH4mqMFZxa7mUNVW0PcbQZi4OzkwuM1DI
   +reB5/stV0II19j/HDzOIv06nXMhDA/Fc6fIv5co057bZjXD/dAEOndy4
   ekX/CRNkw3GInVAzt0A0FBZn55me5dulh+cdI6BXqHzd2KxowFEnNpWSE
   A==;
X-CSE-ConnectionGUID: y6Ze772oRPypT45OGVtI6Q==
X-CSE-MsgGUID: EIndvETbQuOlPadE9aVrQA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12010307"
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="12010307"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 18:51:08 -0700
X-CSE-ConnectionGUID: Exyd7mpmTzSXwdVb4RzPwg==
X-CSE-MsgGUID: YSFKP56RQiSPdDF+FZg5zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="69090252"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 18:51:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 18:51:07 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 18:51:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 18:51:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 18:51:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0X9sTUXSEf8DlcuMIC4I9Lp3Tbms5VWuaOAe53fpq1Fhb4OydNCeaegebzHE8vUJrXOTL+sTN4MUo6crWUIs5YeFKSy8WgVBjjZKyaWcI+5G6DW3GUkiNNygRTwSPIWuyxWGPQyx+dB8DiCZi25eL1D68hrknk13mCzAG8Tjx2fM4wvut0ojRfCIaCiY3VAgflPWl14SRhqqtEXQD6iTFQG4MeR/1yrdRn6NG41EFSWh1ia4yl3uJz3fyyNYLw9XK04caKsCPl5K2lRLauhX2Ib76YZmeA/AhmrP/SXzc4vKBySVp3By0EE83NDYuv19MoczxME75iiJw1DtGc9Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6V1Eely0tCMaUhP7jxGDoOFYdyOezkkh5FJeB/MUbeQ=;
 b=G+O4BTdAtNtrrXfau/3U/fC5sW3zlbig0oPEI/Ysj5IdW10+Tu3NuHt7+8nHvj3pW8Jv+266Te+EXSHz9go+aqSYS4LApdQ1JPXBmRkaEaEpTexDU8DW9X9JYhrUNqOq1ZDe5dsRsA4dLs+M6tdBxaRhRKS/QDw6SQWVMYBOyieO8u1Xcpdkw+qSBOwFc1YmdvUOBOMwM0ZhnAafrME8fYS2O+5pXgx3PlXIIWhh1bDWx6Jr8c/BCFhWlbVkpIlKnMvXtL4sbBLmZAb3Gmb4NThoptuq5LXVQcUZfNEJvlzLYnXbseNEDf0t9YXAPAgAdt4aU33pDf5nxfTJh9u/pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5995.namprd11.prod.outlook.com (2603:10b6:8:5e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 01:51:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 01:51:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaAgAAByoCAAAQqgIAAA6mAgAAB7ACAAAHNgIAAAriAgAAH94CAAAR+AIABbXYAgAAZCoCAABR2gA==
Date: Fri, 17 May 2024 01:51:03 +0000
Message-ID: <240f61b5da5015a8205de414a87c3c433b1c09a0.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
	 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
	 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
	 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
	 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
	 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
	 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
	 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
	 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
	 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
	 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
	 <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
	 <9556a9a426af155ee12533166ed3b8ee86fa88fe.camel@intel.com>
	 <d9c2a9b4-a6b8-4d29-9c22-ebdce77f3606@intel.com>
In-Reply-To: <d9c2a9b4-a6b8-4d29-9c22-ebdce77f3606@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5995:EE_
x-ms-office365-filtering-correlation-id: c502f5d1-f708-4440-7c4d-08dc7613cf97
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cmhJSW4zeGdNcjdFQldkSFNwOTNxSlRzWW5PYVFrekIxZ1FpUkxGeGplelZt?=
 =?utf-8?B?aHo2MUNtN1FiVVYyNEZxWk04ZkhLS2FaSHNRaFZEdzRNRzl3Y1VOY3dMWDZt?=
 =?utf-8?B?b290QjFhMVh1WHdIYmtaemdkQlltd24wd2MyZmVTcnRqbWcyS0dVTHdVMU5E?=
 =?utf-8?B?UmJSWml2c1hVRlFTeWZWMnRLL2s2c2JKRnBWM3lTWG8rckNIdGsyTlhHYndm?=
 =?utf-8?B?dm1hbk1FbVAvY0lIdjA5RmpwR2xPU0NQd2gxR01CZ09GK3VnSkc4RGhKcGdt?=
 =?utf-8?B?cFppeUdKcitJVWMxRi9YZUZFc1ZTR0t5NE12Q0E1V0p5dnVhaGdTNUdqNnpa?=
 =?utf-8?B?a0g5QS80QkpRdE93cjhGdWtqa1Z4cUFldWx1NERic1V5dGtuVDR2UVN3NG9O?=
 =?utf-8?B?bjhjTldBRXZhS3pEeVZIL0NGbitmWU1KYjhJSnBxRXgwNFFoaGNId1gwRlRV?=
 =?utf-8?B?YzZvNkJDdG90L3lYQVI0cTB4RmR0cW4zZmU1d2lXZWlFWkljcGtLSWhzV28y?=
 =?utf-8?B?bC9IS1l4eTB2cDg3ZXppQW5KTGIzUEZGU0M1K1hqeHV3eUtqN1FRK3VNcDFP?=
 =?utf-8?B?VXFJdFB0elBIUlpiRmtpSGVpclhELzF3eVhLbWNpVlRYblh4b1d0bm4yVENm?=
 =?utf-8?B?S3hlMHVyYUdWb3JhelhUYzNSZ3paWUJHVVE1Rk1CZnI4TjZLT2JHSVVFWXg0?=
 =?utf-8?B?THpRNE9tRHAwUHVZQTRGMGV1R0xub1V3UmZNa2c5UDZ0Q2VuS1B2N1AybTBx?=
 =?utf-8?B?T0tIbkc1ejQ1cEJVbEx6RDhjbXNhQ0NCcDNYZmlQdmpia090SE45NGNuV3Zv?=
 =?utf-8?B?OG5PQWxPZExtSGR4Qm9Bb2c0US9ZQWs1Q3gzWUhNM1RWWmlhWEpOdzJleVhp?=
 =?utf-8?B?dVNGWE4zMWxWaHZkRWVHWktCUW0rcHJHby9DWWZneVhaNGZjS2VrZVU4ZU5J?=
 =?utf-8?B?TE5YRElGdWlQZmE3V3o0QVlWT1VzRHBOUTJSeHZ3TzFuZzN6ME1rNDJkYVpz?=
 =?utf-8?B?dS9YMGozVHcxcWszU1IxNmNkaVFwenpObXNQM2xPNFNFV0RsYmhkazdHTEMw?=
 =?utf-8?B?R3ZRa0dsaGM1OTNBb25QWEJqVFVlWWZ3M0d4MFFWL016ZXNHTHJrSDg3anFL?=
 =?utf-8?B?L0tVWUVPTDVUS3NJcDcrT1NEU1lBa1JGSXdIVlBzTHptamVJZko1YUdRbzRl?=
 =?utf-8?B?RmMxS0dhZzVkTlppVkNvVi82Rm9KWU1qL3YzWCtTVjg5M0Y0bnFZNnFYMXZP?=
 =?utf-8?B?cTJmQ0NXNlZqVnhEamVMaXEwQUtNdEg4VkM3T3l6SU9nRjJBc2Y5RGJJYStm?=
 =?utf-8?B?QnlTQzUxb3FBektRNDU0b0pjWG92RlQ1S3RPSWgvY1B5YyswVXc4Uy9OTWhy?=
 =?utf-8?B?dDVsU0g5em8vaDlUTHpVWnFWVEZyV0RadC9Wd094dVFrN3J1K2pDa0hjZDRI?=
 =?utf-8?B?U29ER08wMjM5WXh3MEJxNklIZ2NMeWNYbDBhamg1T0o2V1pJMzc1R2FBMWY3?=
 =?utf-8?B?a051TjE5am5ERDlqWVE0WDBsS3lsK0VjVmRnUDNBWlE5U0dtTkFaekpJT0pW?=
 =?utf-8?B?ZTNWV1hCVkdjdUlYVngrR3Yrd0IvWkRrSndmV2Q5SnJXTU9FWlp0ZWVJcTJt?=
 =?utf-8?B?RE9iNjJsdDFqYit2TFhHdG0yWDhJM3AwWUxHc2hzajczNFBsck8wWHNqeFhX?=
 =?utf-8?B?cWpEa3JzWEhlUWE5VVFJd0NhVHh0K2NFNjE0Z2hRZytYbUtTWms3dlFWNlJj?=
 =?utf-8?B?VWVvK1N0YThDM0RpZW9yVklXdlYwa2hoMG96R0Y1a084RXo3VTFJZnMxRjh1?=
 =?utf-8?B?bldhQ3U0aGpJMlJBM0g0dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHRIQWxyMGF0NnhBTUZpa3Y5WVhaWFJJdVlpMGdlcGZKN21oV3MzVjNncGZS?=
 =?utf-8?B?QURFRS9zQVpySFliMCtHUEtSZUdzemJENG1CclpLK3pDR0FBeFNOU2ZvQlF1?=
 =?utf-8?B?aWlIUE9iNUdyMXpROVc2SUxCSkN6RTRRVW5aYlZObHAwN1k1WmxuS3pveXhX?=
 =?utf-8?B?UkZOdzA2U3VURGIrNk1yY3h0T3VGaHh2d25URWg4SFJ1L3F1VmZyMW5wTHdW?=
 =?utf-8?B?bnhSRjFpa3BvWGtwMEx0YmFseWNqcDB4bG9heU1EamdUWFBORlZ4aTRoNnNH?=
 =?utf-8?B?YWRLNkdRSGM0WU1GZnQ0RGxGSkhHOStFQmY0d0Z5VjdacCsyL3RyUEVweHFj?=
 =?utf-8?B?Y0VCbDFtYnFmMUFHQjBKaERlNkhzUW9FcDAySElOREZwaHFNVUxISG1QdkZP?=
 =?utf-8?B?USs1Nit6MVR2b0VOZ3JjbzVUUExucFVWN3Z4UjhUUm8zTkJQdE5DUzVPQW9v?=
 =?utf-8?B?Z2I5ZWFzbDJxM0NOSUxNSWZ3WXZFUFJWSmRpSW5DSEJLUXIybUF4a0tGYzhw?=
 =?utf-8?B?MlpUN2M2U0VWWmVodVk1VFA5M2NBeVkrMFlzL2pZd3hjU3h6aDcyWVBZVDJM?=
 =?utf-8?B?c2c4OGtkZ0Z3UEVuLzJBdXFUcTZ4eEZOOThKbHhJVDdscVVrUW93WEE5SmN0?=
 =?utf-8?B?QXZCQkR6dHpNSnU0bW56UlNVUUNoNXFRUDlTVWo4VXQwU1JGVXh3R3N3ZVRo?=
 =?utf-8?B?M3RBK1E2RlhQdTJpeHdMbmVNV0FJaVZVUHJoTGFERHJMS3lrTnFxUWdsenRk?=
 =?utf-8?B?U2FnZFI4WlpiTC9JT28yVWpTL3ZPc05qdXFYVHVKcnJQQUp5WXdjaTN4aWlr?=
 =?utf-8?B?NW9aVHNLenA2b3M1K2VvSkdIc0tXT2RWNU95TDVyem1DQUhObVhrc3hrZEtL?=
 =?utf-8?B?QUtDOGYyRlY0Qlc3UEdDMGJCbzBVa2VlOWw4THhuSFpCdUE5SWY3bU9qZWZU?=
 =?utf-8?B?bFZQSzlEdTc3dUEvVllpOGFXNUpiYWtTak5mdnNrR2pYTXpKV3puUUkrdFBT?=
 =?utf-8?B?Nk1oRWhEQW41SDU3NkRPQUtXT3ZpekFOYlpUTW1FYjFuQWNIZi9MOVdOTnNQ?=
 =?utf-8?B?LzB3SE85UmZUUitpbEFOZVhub0xGMGpnY1FkYm1hSFBrR3kyb29zZDQ3Tk5l?=
 =?utf-8?B?ZDFMU094bERpSG9KNm5BWWlxNmg3OVovYUFocTFpRnJHRnl3bHh6TWsyRHZo?=
 =?utf-8?B?V0tPbU1IWlhma3JLd3U4ZjVqTEZ4MjZjamhNUEttYUs4bkdlWUN0RXhQeVR2?=
 =?utf-8?B?dXA0TENnSE9KQXVpeGZlWUU5dXBtNEdqakRveFAvK3RxeklQMzgwYUlRUFBx?=
 =?utf-8?B?QXRDc293M0tqVmtkU2JIU1RFVTA1a2dtUmUzcklRdHY1bEZnR29iMDdSTWNP?=
 =?utf-8?B?ZkFQTTRWUjcyak9pL3NaUEVVZkp5WGRRK2R6ellwQ2p3M0hFK1VZYjJxbis4?=
 =?utf-8?B?WktJT0l6RW9JRnFIUklxZU8vbjlrSm1OV1JqV0Q0eUoxQ0Z2dG9XaUVJd2NE?=
 =?utf-8?B?SDlLZ1FIZWFEamtPcWJ1Vm54RzY0MTZmTHRmRDJFZjk2ZFMzbGVqRmxrVlZR?=
 =?utf-8?B?UjI1eXR3Y3VHVGUxeHVjSTE5bXc5aFVDOTduZ1hYRnc3RnV1T1MxWS9raXlE?=
 =?utf-8?B?YzVoODZabzdEbENDekRjTGdubWxXZmFPeGlyZWtTakxERFN3TDQrZm1VTnA0?=
 =?utf-8?B?VVlMbmRyVmZNeWJzNmxaS3A2TVlOTTRmdFh3bnAxMWJBR05aZzU1U24vMlBz?=
 =?utf-8?B?OWo4c3JLaTBnakRuak9vSjYyMlNVb25lOUJDSzN3NlFndmtYQnZ1Y1dubWlJ?=
 =?utf-8?B?RkUrdUpXc21lM1RZc284TmVsU01uTXp3Q1ZMTlVGaHdkcG5CTjQvYmwvZGxJ?=
 =?utf-8?B?TFVDUkpjL0pUdTBSaVpuVVFjYW5mSDBjM0NvRWVsMFhHSjlDc3B3K0t3VGJZ?=
 =?utf-8?B?WU1ROGxWTlhhc2sxSkpveVhQUVhrV21uS21rbGdsMlMyMzIvVmtGTjZjTmE0?=
 =?utf-8?B?ODJDMWJyaENwbkhoajkzcVdaR2hhMDYyMVgvSWhLV2Njakl4N0lGWnk2VFBI?=
 =?utf-8?B?SFBBMytqV0NOVklCdGVsNDJDN0dzUmUwZExPMXBKdXY0cFRpZ2xpNndydXZN?=
 =?utf-8?B?Zzcyczg1cGJ4RjFXNllFNzRYZHFmU2lJd0U2UFhTcWd2YW5tNldRcVBsVU1E?=
 =?utf-8?Q?fuDNZj3tfhMXo56cLSjtXoo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9631226F32AD244E8C5E2CD6F6A276F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c502f5d1-f708-4440-7c4d-08dc7613cf97
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 01:51:03.8924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HsLC5fx3BD+qlNWsuuTnrOmOKvR1Jm4UwFkka2e1x9UpS4IXYiNWMtooakA5Cz4+ClAJFFl22V8Xzy72R3BV2K8owxnXrL3HAJDY5ez3XXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5995
X-OriginatorOrg: intel.com

V2UgYWdyZWVkIHRvIHJlbW92ZSB0aGUgYWJ1c2Ugb2Yga3ZtX2dmbl9zaGFyZWRfbWFzaygpIGFu
ZCBsb29rIGF0IGl0IGFnYWluLiBJDQp3YXMganVzdCBjaGVja2luZyBiYWNrIGluIG9uIHRoZSBu
YW1lIG9mIHRoZSBvdGhlciBmdW5jdGlvbiBhcyBJIHNhaWQgSSB3b3VsZC4NCg0KTmV2ZXItdGhl
LWxlc3MuLi4NCg0KT24gRnJpLCAyMDI0LTA1LTE3IGF0IDEyOjM3ICsxMjAwLCBIdWFuZywgS2Fp
IHdyb3RlOg0KPiBUaGUga3ZtX29uX3ByaXZhdGVfcm9vdCgpIGlzIGJldHRlciB0byBtZSwgYXNz
dW1pbmcgdGhpcyBoZWxwZXIgd2FudHMgdG8gDQo+IGFjaGlldmUgdHdvIGdvYWxzOg0KPiANCj4g
wqDCoCAxKSB3aGV0aGVyIGEgZ2l2ZW4gR1BBIGlzIHByaXZhdGU7DQo+IMKgwqAgMikgYW5kIHdo
ZW4gaXQgaXMsIHdoZXRoZXIgdG8gdXNlIHByaXZhdGUgdGFibGU7DQo+IA0KPiBBbmQgQUZBSUNU
IHdlIHN0aWxsIHdhbnQgdGhpcyBpbXBsZW1lbnRhdGlvbjoNCj4gDQo+ICvCoMKgwqDCoMKgwqDC
oGdmbl90IG1hc2sgPSBrdm1fZ2ZuX3NoYXJlZF9tYXNrKGt2bSk7DQo+ICsNCj4gK8KgwqDCoMKg
wqDCoMKgcmV0dXJuIG1hc2sgJiYgIShncGFfdG9fZ2ZuKGdwYSkgJiBtYXNrKTsNCg0KTm8sIGxp
a2UgdGhpczoNCg0Kc3RhdGljIGlubGluZSBib29sIGt2bV9vbl9wcml2YXRlX3Jvb3QoY29uc3Qg
c3RydWN0IGt2bSAqa3ZtLCBncGFfdCBncGEpDQp7DQoJZ2ZuX3QgbWFzayA9IGt2bV9nZm5fc2hh
cmVkX21hc2soa3ZtKTsNCg0KCXJldHVybiBrdm1faGFzX3ByaXZhdGVfcm9vdChrdm0pICYmICEo
Z3BhX3RvX2dmbihncGEpICYgbWFzayk7DQp9DQoNCj4gDQo+IFdoYXQgSSBkb24ndCBxdWl0ZSBs
aWtlIGlzIHdlIHVzZSAuLi4NCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqAhKGdwYV90b19nZm4oZ3Bh
KSAmIG1hc2spOw0KPiANCj4gLi4uIHRvIHRlbGwgd2hldGhlciBhIEdQQSBpcyBwcml2YXRlLCBi
ZWNhdXNlIGl0IGlzIFREWCBzcGVjaWZpYyBsb2dpYyANCj4gY2F1c2UgaXQgZG9lc24ndCB0ZWxs
IG9uIFNOUCB3aGV0aGVyIHRoZSBHUEEgaXMgcHJpdmF0ZS4NCg0KVGhlc2UgaGVscGVycyBhcmUg
d2hlcmUgd2UgaGlkZSB3aGF0IHdpbGwgZnVuY3Rpb25hbGx5IGJlIHRoZSBzYW1lIGFzICJpZiB0
ZHgiLg0KVGhlIG90aGVyIHNpbWlsYXIgb25lcyBsaXRlcmFsbHkgY2hlY2sgZm9yIEtWTV9YODZf
VERYX1ZNLg0KDQo+IA0KPiBCdXQgYXMgeW91IHNhaWQgaXQgY2VydGFpbmx5IG1ha2VzIHNlbnNl
IHRvIHNheSAid2Ugd29uJ3QgdXNlIGEgcHJpdmF0ZSANCj4gdGFibGUgZm9yIHRoaXMgR1BBIiB3
aGVuIHRoZSBWTSBkb2Vzbid0IGhhdmUgYSBwcml2YXRlIHRhYmxlIGF0IGFsbC7CoCBTbyANCj4g
aXQncyBhbHNvIGZpbmUgdG8gbWUuDQo+IA0KPiBCdXQgbXkgcXVlc3Rpb24gaXMgIndoeSB3ZSBu
ZWVkIHRoaXMgaGVscGVyIGF0IGFsbCIuDQo+IA0KPiBBcyBJIGV4cHJlc3NlZCBiZWZvcmUsIG15
IGNvbmNlcm4gaXMgd2UgYWxyZWFkeSBoYXZlIHRvbyBtYW55IG1lY2hhbmlzbXMgDQo+IGFyb3Vu
ZCBwcml2YXRlL3NoYXJlZCBtZW1vcnkvbWFwcGluZyzCoA0KDQpFdmVyeW9uZSBpcyBpbiBhZ3Jl
ZW1lbnQgaGVyZSwgeW91IGRvbid0IG5lZWQgdG8gbWFrZSB0aGUgcG9pbnQgYWdhaW4uDQoNCj4g
YW5kIEkgYW0gd29uZGVyaW5nIHdoZXRoZXIgd2UgY2FuIA0KPiBnZXQgcmlkIG9mIGt2bV9nZm5f
c2hhcmVkX21hc2soKSBjb21wbGV0ZWx5Lg0KDQpZb3UgbWVudGlvbmVkLi4uDQoNCj4gDQo+IEUu
ZyzCoCB3aHkgd2UgY2Fubm90IGRvOg0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoHN0YXRpYyBib29s
IGt2bV91c2VfcHJpdmF0ZV9yb290KHN0cnVjdCBrdm0gKmt2bSkNCj4gwqDCoMKgwqDCoMKgwqDC
oHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4ga3ZtLT5hcmNoLnZt
X3R5cGUgPT0gVk1fVFlQRV9URFg7DQo+IMKgwqDCoMKgwqDCoMKgwqB9DQo+IA0KPiBPciwNCj4g
wqDCoMKgwqDCoMKgwqDCoHN0YXRpYyBib29sIGt2bV91c2VfcHJpdmF0ZV9yb290KHN0cnVjdCBr
dm0gKmt2bSkNCj4gwqDCoMKgwqDCoMKgwqDCoHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4ga3ZtLT5hcmNoLnVzZV9wcml2YXRlX3Jvb3Q7DQo+IMKgwqDCoMKgwqDC
oMKgwqB9DQo+IA0KPiBPciwgYXNzdW1pbmcgd2Ugd291bGQgbG92ZSB0byBrZWVwIHRoZSBrdm1f
Z2ZuX3NoYXJlZF9tYXNrKCk6DQo+IA0KPiDCoMKgwqDCoMKgwqDCoMKgc3RhdGljIGJvb2wga3Zt
X3VzZV9wcml2YXRlX3Jvb3Qoc3RydWN0IGt2bSAqa3ZtKQ0KPiDCoMKgwqDCoMKgwqDCoMKgew0K
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAhIWt2bV9nZm5fc2hhcmVk
X21hc2soa3ZtKTsNCj4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gDQo+IEFuZCB0aGVuOg0KPiANCj4g
SW4gZmF1bHQgaGFuZGxlcjoNCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZmF1bHQtPmlzX3By
aXZhdGUgJiYga3ZtX3VzZV9wcml2YXRlX3Jvb3Qoa3ZtKSkNCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAvLyB1c2UgcHJpdmF0ZSByb290DQo+IMKgwqDCoMKgwqDCoMKgwqBlbHNl
DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLy8gdXNlIHNoYXJlZC9ub3JtYWwg
cm9vdA0KPiANCj4gV2hlbiB5b3UgemFwOg0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoGJvb2wgcHJp
dmF0ZV9ncGEgPSBrdm1fbWVtX2lzX3ByaXZhdGUoa3ZtLCBnZm4pOw0KPiDCoMKgwqDCoMKgwqDC
oMKgDQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAocHJpdmF0ZV9ncGEgJiYga3ZtX3VzZV9wcml2YXRl
X3Jvb3Qoa3ZtKSkNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvLyB6YXAgcHJp
dmF0ZSByb290DQo+IMKgwqDCoMKgwqDCoMKgwqBlbHNlDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgLy8gemFwIHNoYXJlZC9ub3JtYWwgcm9vdC4NCj4gDQoNCkkgdGhpbmsgeW91
IGFyZSB0cnlpbmcgdG8gc2F5IG5vdCB0byBhYnVzZSBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkgYXMg
aXMgY3VycmVudGx5DQpkb25lIGluIHRoaXMgbG9naWMuIEJ1dCB3ZSBhbHJlYWR5IGFncmVlZCBv
biB0aGlzLiBTbyBub3Qgc3VyZS4NCg0KPiBUaGUgYmVuZWZpdCBvZiB0aGlzIGlzIHdlIGNhbiBj
bGVhcmx5IHNwbGl0IHRoZSBsb2dpYyBvZjoNCj4gDQo+IMKgwqAgMSkgd2hldGhlciBhIEdQTiBp
cyBwcml2YXRlLCBhbmQNCj4gwqDCoCAyKSB3aGV0aGVyIHRvIHVzZSBwcml2YXRlIHRhYmxlIGZv
ciBwcml2YXRlIEdGTg0KPiANCj4gQnV0IGl0J3MgY2VydGFpbmx5IHBvc3NpYmxlIHRoYXQgSSBh
bSBtaXNzaW5nIHNvbWV0aGluZywgdGhvdWdoLg0KPiANCj4gRG8geW91IHNlZSBhbnkgcHJvYmxl
bSBvZiBhYm92ZT8NCj4gDQo+IEFnYWluLCBteSBtYWluIGNvbmNlcm4gaXMgd2hldGhlciB3ZSBz
aG91bGQganVzdCBnZXQgcmlkIG9mIHRoZSANCj4ga3ZtX2dmbl9zaGFyZWRfbWFzaygpIGNvbXBs
ZXRlbHkNCg0KU2lnaC4uLg0KDQo+ICAoc28gd2Ugd29uJ3QgYmUgYWJsZSB0byBhYnVzZSB0byB1
c2UgDQo+IGl0KSBkdWUgdG8gd2UgYWxyZWFkeSBoYXZpbmcgc28gbWFueSBtZWNoYW5pc21zIGFy
b3VuZCBwcml2YXRlL3NoYXJlZCANCj4gbWVtb3J5L21hcHBpbmcgaGVyZS4NCj4gDQo+IEJ1dCBJ
IGFsc28gdW5kZXJzdGFuZCB3ZSBhbnl3YXkgd2lsbCBuZWVkIHRvIGFkZCB0aGUgc2hhcmVkIGJp
dCBiYWNrIA0KPiB3aGVuIHdlIHNldHVwIHBhZ2UgdGFibGUgb3IgdGVhcmRvd24gb2YgaXQsIGJ1
dCBmb3IgdGhpcyBwdXJwb3NlIHdlIGNhbiANCj4gYWxzbyB1c2U6DQo+IA0KPiDCoMKgwqDCoMKg
wqDCoMKga3ZtX3g4Nl9vcHMtPmdldF9zaGFyZWRfZ2ZuX21hc2soa3ZtKQ0KPiANCj4gU28gdG8g
bWUgdGhlIGt2bV9zaGFyZWRfZ2ZuX21hc2soKSBpcyBhdCBsZWFzdCBub3QgbWFuZGF0b3J5Lg0K
DQpVcCB0aGUgdGhyZWFkIHdlIGhhdmU6DQpPbiBUaHUsIDIwMjQtMDUtMTYgYXQgMTI6MTIgKzEy
MDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gV2hhdCBpcyB0aGUgYmVuZWZpdCBvZiB0aGUgeDg2
X29wcyBvdmVyIGEgc3RhdGljIGlubGluZT8NCg0KPiBJIGRvbid0IGhhdmUgc3Ryb25nIG9iamVj
dGlvbiBpZiB0aGUgdXNlIG9mIGt2bV9nZm5fc2hhcmVkX21hc2soKSBpcyANCj4gY29udGFpbmVk
IGluIHNtYWxsZXIgYXJlYXMgdGhhdCB0cnVseSBuZWVkIGl0LiAgTGV0J3MgZGlzY3VzcyBpbiAN
Cj4gcmVsZXZhbnQgcGF0Y2goZXMpLg0KDQpTby4uIHNhbWUgcXVlc3Rpb24uDQoNCg0KPiANCj4g
QW55d2F5LCBpdCdzIG5vdCBhIHZlcnkgc3Ryb25nIG9waW5pb24gZnJvbSBtZSB0aGF0IHdlIHNo
b3VsZCByZW1vdmUgdGhlIA0KPiBrdm1fc2hhcmVkX2dmbl9tYXNrKCkNCg0KVGhpcyBpcyBhIHNo
b2NrIQ0KDQo+ICwgYXNzdW1pbmcgd2Ugd29uJ3QgYWJ1c2UgdG8gdXNlIGl0IGp1c3QgZm9yIA0K
PiBjb252ZW5pZW5jZSBpbiBjb21tb24gY29kZS4NCj4gDQo+IEkgaG9wZSBJIGhhdmUgZXhwcmVz
c2VkIG15IHZpZXcgY2xlYXJseS4NCj4gDQo+IEFuZCBjb25zaWRlciB0aGlzIGFzIGp1c3QgbXkg
MiBjZW50cy4NCg0KSSBkb24ndCB0aGluayB3ZSBjYW4gZ2V0IHJpZCBvZiB0aGUgc2hhcmVkIG1h
c2suIEV2ZW4gaWYgd2UgcmVsaWVkIG9uDQprdm1fbWVtX2lzX3ByaXZhdGUoKSB0byBkZXRlcm1p
bmUgaWYgYSBHUEEgaXMgcHJpdmF0ZSBvciBzaGFyZWQsIGF0IGFic29sdXRlDQptaW5pbXVtIHdl
IG5lZWQgdG8gYWRkIHRoZSBzaGFyZWQgYml0IHdoZW4gd2UgYXJlIHphcHBpbmcgYSBHRk4gb3Ig
bWFwcGluZyBpdC4NCg0KTGV0J3MgdGFibGUgdGhlIGRpc2N1c3Npb24gdW50aWwgd2UgaGF2ZSBz
b21lIGNvZGUgdG8gbG9vayBhZ2Fpbi4NCg==

