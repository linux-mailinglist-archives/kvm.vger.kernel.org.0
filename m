Return-Path: <kvm+bounces-20418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D202B915A45
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CF021F244DD
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 23:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44251A2C04;
	Mon, 24 Jun 2024 23:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DJiGv0MM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8349F1A072E;
	Mon, 24 Jun 2024 23:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719270916; cv=fail; b=pLOZgHaL+VPXRXt5gPAJ7GhlqmTIksNQF4vEogbWB8qTJZ9ccyk5Fwbba+/bHwO+8LFREBPs8DvW4FGLsbQpt4/xedQVl2D2Wz8g8+UvWNwSIomjm+ZalBvN83DiLqaGY8yln5SP8jOfazpKQBGwY96zdORItFqwTm8mGItnRAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719270916; c=relaxed/simple;
	bh=W5brrJkamc9IXoM3cHG8Npq20ou5AM4XsdTU3ZB1+lE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NEWV6O7xDAT64A8ibOwJfq4jateh4FAmHv6sf9L7BSQsQiMcgwtIGeBsVdcxB/F+oGDWlHeutijXkJYiK1c4clSL7hFUuGhmvr+PV7KJc2tSrRF9J6xrlJzb/krvg5D8zlctMh3ewWm/LR/NDtLH7DH3grpnfr2XtgxPyXFeeBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DJiGv0MM; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719270915; x=1750806915;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=W5brrJkamc9IXoM3cHG8Npq20ou5AM4XsdTU3ZB1+lE=;
  b=DJiGv0MMlL+y5Pu8zT2XG+l9q3Yir8+TrcaZK8z09rhG0CcHT3L3hWNO
   euCoB8Y7dLleFXvx+7XM8X4F7jJTe+GZSfFzZna65Cd+yaeqYmZJaKLgS
   GmdO9iEsk8XzrsMiP9Y36QeyRJG+9zfFdoVnsJdBrEoKKLAcPRNP/xpJy
   OI2rQ11fXa0OLHa/EyQCpX7ZU7cIPrhKh1ERjJu55/LdJLpH6RWGlFBBx
   6std/oGiGHYWN4lmdUAgleAP6d0LwbnTIX38mtfm7/nwkbNCpOJeuitYc
   14x4qfXblnLPoUUujwS8dB+mOM7awmLKvmY9lhvliKuh2pOyFppeM0Iju
   g==;
X-CSE-ConnectionGUID: rLAPiSJsSweXG9pNZEXqmA==
X-CSE-MsgGUID: Hc1IxUb0RimUMh9Yg+QqUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="16092362"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="16092362"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 16:15:15 -0700
X-CSE-ConnectionGUID: 90XUvY0IT/64dmbfpOYFHg==
X-CSE-MsgGUID: NI5pw81jQ1GGBC6fa8ZFpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="43550934"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 16:15:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 16:15:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 16:15:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 16:15:13 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 16:15:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAe41OaQzWhT1mHkLOlhO40hYqiyfgOTz6s4aTbd5vr23PGoQjpesQSmSbWoKwKqQYuPuglCQLM3gDSYlh4RC73s+bhJo8nCUEVCGT2apw0IKJi9AJKrmtX7tr7jBjBti4rTZUKyAQNM8s86De1tcyAzgbNbMXbem31P23UzGB8IIGeLzn9sL735Vd2JTJb5Oyf8pAKuC7feMl+e/l4+BLIdht97+OKIJe/nUxAK7DAlJlXXPQo4YYxiijKqOnkRwOlN9CGIxO8hi0HtkjKpsgQy+B0ldnNmkYeEwjyNTxbHao2jilJ9vx7VXJv1n4f3bjcgum6Gpy+Dwk43XG8WUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5brrJkamc9IXoM3cHG8Npq20ou5AM4XsdTU3ZB1+lE=;
 b=Pi1C/0Y88rYzimfA7acUcAfyqTKVFPoPSR8FzdAT/DijE+OKA+T8IL5GVfVVOCvLP/NSREYix/FZeRFvYVjloT3phhwu8YqyovZVcR2VbmkQtNsCQaDteKaNj0PHbj6AbCqsZB4OdO/ZZ9abOIp7TtIGURNREQWOtuljxDEMlalck+VknwGpC02wlN7j+4soOZdQYjZfbWv8L38jcHs0wNWA9fDNxaFTvrMU8r66z9tyhT6divXJpRPuREhuEoA9301Viv8GXklgVBw3QjpemtLrHpHpN2vPwve3TrbG3+jQat1ZJYbj5SNqzM40riCSzGLSbIMDdV4eAymaJiJgpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8502.namprd11.prod.outlook.com (2603:10b6:510:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Mon, 24 Jun
 2024 23:15:09 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 23:15:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Topic: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Index: AQHawpkmqvK9+rV8gk+Fb4hYJXFjCLHRzw4AgADIg4CABASjgIAA908A
Date: Mon, 24 Jun 2024 23:15:09 +0000
Message-ID: <d12ce92535710e633ed095286bb8218f624d53bb.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
	 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
	 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
	 <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
In-Reply-To: <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8502:EE_
x-ms-office365-filtering-correlation-id: 930f190d-bf19-4bc1-d4a4-08dc94a37e42
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?OG5GMlR1dERxNE5SSVlGZy9UVzRYdlkyeTdaUGR0TFVCOFNIdTNaUWZGVEk2?=
 =?utf-8?B?TklSdjVpalNnaE1nc0JrekFha1VzYUxtcnRYenczUitBcEdCNGt6Mm5JbEl6?=
 =?utf-8?B?eHlwdWFqVDcwbXp5czc0VU5IQW84ZkN0NFptMVJ2OUtzaUlwczRtdXQrNGNC?=
 =?utf-8?B?U2pqQTNZOUtMU2lJeFl1SFNaanRUZlpISkJtVUFpelFCUFJSWXVwUUhVMU1L?=
 =?utf-8?B?SjcxS3ZGV2RMTnpPdzU3YVhrejNKMEl0dTFLSDdpUkhPYU5WMFlKU1o5bWhw?=
 =?utf-8?B?azBUems5M1BmSC81S3NUR3pTOCs4TURFd3o2VGVLd1A5RHFiMVpRc2ZmQ3g4?=
 =?utf-8?B?YUk2aVFiQmJJYkRibWJrU2hDMGNLM3YrYmxlaC91djhzWkF3Tmhkb0R0YmpY?=
 =?utf-8?B?SlkvaitRWXQ2eXkxRFpKTDNWRVFiS3ByaWtxNTVCOHBrK2FiNTEyc0JkUThr?=
 =?utf-8?B?WDcvTEhmUnhYYlRJVFpjQ3F2TjJlTXJacGNtSWEveTBxeTZHMkFNb09aZ3Q3?=
 =?utf-8?B?UVlXaFF2eXB0aXF5dzRzWmxlQ29XR3FWVjNVVU8yYzhma01jSU0zUk1MSlRr?=
 =?utf-8?B?c3JCclRtRnRSRlBnQ1hpNE8wVkFnSnZpd3h3U3pjSzZJMng3UlRLTWd5K2tC?=
 =?utf-8?B?YlBXc3ZhV1VEUFBvdGxLSnY4SVM1SDBhSzRvWis0SW13LzdZNm9kbk9QNlUy?=
 =?utf-8?B?Y2R6TTVQOXJya0NXSHlnR1JHYnYxeDVDdWZaa1hQRXFvVlBmYU1EUS9FVGUx?=
 =?utf-8?B?UmQ4d090OUltYVoxLzFueTRtRStYbjFVMzJLYnV4WkUzdkVFeWVhUFBTMGpO?=
 =?utf-8?B?Q1krLzdPUTFoWkVKRWM3NjFpeFdyeU9yUGUvK1Btdi90bG55RmhQdXdkaUJG?=
 =?utf-8?B?UmRwSmYzRUlRWkhIeVBRN3RtblRRcVFqZjI2ZWIrU29wamhRM1BrdWlVQnd1?=
 =?utf-8?B?YjlocmtxSFNyWE9uRGpqS2t2VlM4WTBlYWh2MFdyUkx1N293Wi9HdUI2RzEw?=
 =?utf-8?B?Zk1ZNzR3cTZ1U2JQdE5WRTNsNjRyQXNwTGhSN2hlV0tVcGxtTHpsVjBBb3pW?=
 =?utf-8?B?aFZSY3JUUHZVUGhpcVg5b3RLVjBSa0FLL3VrWVE3eVJkL2xrakhQUWRFczlH?=
 =?utf-8?B?Q0RxRFkvQWJqUlJha0p5SitWelAySXlHb2J1NTBWUnNnSWZBOUZNc08ySjFB?=
 =?utf-8?B?U2VnM1dnYytwS0gxNzR0OE9PazNDbFVseS83RGpQYXlHbllDcDZHWHhOblRi?=
 =?utf-8?B?ZmpHY2luTmRpb09NL1MrbHg4M3crTElOQS80L1l5ZXFncnY5WGJPVGsrb0Fi?=
 =?utf-8?B?cmdCaURGbE1VakJnbTRBUFdQeUY4UUdaL2pUMnhRUjhrRHhoQ3ZJTTJrZWdX?=
 =?utf-8?B?RUlUZHRtbkdyb2x2alg5cTQ4RENMQ0V5dVl0Mk9VemE4M3dUczBPYi9lTXJh?=
 =?utf-8?B?aElQZUw3Vm1TeDBHd3R1bVFKb0JHSmJkTUhwL0d5eks0RHhKN2tUV2ZnQ1l2?=
 =?utf-8?B?NTlqSDJwMFVqcmk2RlJiVklwWXNBUjR4SWVlLzNEVzJuSnVMaWtIYWFxTHUv?=
 =?utf-8?B?NmZ4NW1DTWRLK3lRZjIzMy9xaGdzdi8wTmxUR1dRMnowNnJocURPR3VlR2Y5?=
 =?utf-8?B?Y0xYNW1sN0E0SW5Rb3hmL2VuR3RtK3JSajNZOENWd0wrOXZoaXRIbVkrQ0Zl?=
 =?utf-8?B?Ykc1Snk1RWNJZ3o0bUo3TkhKTm9NNm14Q3lsRFVHQStGUVFOMm9leVpLcHNI?=
 =?utf-8?B?eC9mY0NhMjR0cEhSekNYU1FYSjZTSVhHT1ZuZUlQc1hEc0UvUEdyN2MrMWsx?=
 =?utf-8?Q?EstSdd1YjvxvcKHMExDbQJZsE1bA7TXh9tlCE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXhJWklqYVI0dmVBdzdBM3F0d1NVYUxZdjl5MEFzNWFvQ3N0RFpFWC9kOC9U?=
 =?utf-8?B?aFl6eDhMWDQxQ21vSEdlb3hLZm1rU3hSZG9ucHdqSFpkK0xvZ1ZBN1gyNEdB?=
 =?utf-8?B?NmJ0LzVGV0JLdzVLbCt4V0ZxYlhDaUpWUGFEaUg2VVNwVkRpa3A5anEyRVFy?=
 =?utf-8?B?cGQxeEp0L0JobHZ2ZEV4M2hSWkVXSVJqdVpqdE5LalJ1L01nbHZHZjVsbHBs?=
 =?utf-8?B?M1dHdnFPK052UXVTcU1HaWNuY1A0MElMZjh5dmRCR3pKaXZJajMwVDlrczI1?=
 =?utf-8?B?NmQ4TXZCaHhFbUpRd05HaVpObStMY2pleUFFZW1ZRHE4MW9JMDBMWS9nNm9r?=
 =?utf-8?B?Y2tvSzh2U3NNNVpoZG9hV1NOYnBaWkF2RW1Hd1IweWxiVTJ5Q3JHN3IrOTNp?=
 =?utf-8?B?Ym14dUNkSFZZbUJyS1cwTXMzK0lWUkNXYVFZWEpURGM4V3BxSmN0bUI1Wi9Y?=
 =?utf-8?B?MlBiZTFRMVdXZHNtWS83Z2lSVFFpZVFKLzVxYXh1bkhGb0xCVE5kd0tTZlJa?=
 =?utf-8?B?MDkzQkdKMG1CUU9TaS9KK05LWlhaVVc5NjRjeSthSGlCVXd4V2lDNWtZV1Ux?=
 =?utf-8?B?em9FY2orejlNVG9pVHJrbjJyRDZIVlo1Z2toS1kyMy9JN2tOdHBMNXJFZ09o?=
 =?utf-8?B?VXBUTTdWNS9ieG9yYmJ0SWZ6YnVremlWSVJDL2diZWxSeDM2d0FySm9xVmhy?=
 =?utf-8?B?R21DcjdRSHhxaGs4QjkxaE9IYUdSZWxRL3BGMVJkYXBHUFoxcm5FL3FsSk9l?=
 =?utf-8?B?QkZ6ZWRaQXJ2RDFUUHFjRitObmRIbnQzUTFpZit2d0d5V3FhaDRxQ0FmVzc1?=
 =?utf-8?B?ZGtvR25aWTlHVDFmSnE5aGJSUERPcGlnOTlld1l2UnJpbHhxaWlEUDE4QkVW?=
 =?utf-8?B?OWI4SE84WVpHdklzdDBYbnZBalhoaFdoVTkwZlVlbDBsVHJZN3BpcUIrUGJ0?=
 =?utf-8?B?YVJpMFdtM1ZPOG81MUZuK1dnbytPZXA1anNQUkJQZkk2UnllU1pSMGtiTmhW?=
 =?utf-8?B?ak9tUnYxV3BlNTh3c1hDcHhWR01sZm15Z2FjRzd0cjZOSWN6ZWxTbHNnZ0hW?=
 =?utf-8?B?QzhLTEYvNEhBM1paa3h0VDZhK2lvUVNmR01IV1pnMHNzUENFZVVOcHVZbyt6?=
 =?utf-8?B?VUdvamtlUVF4dm5GczdxZ1UvcGdHWUQrVGJSSmszcHN6aENvOUxQNEJBODR2?=
 =?utf-8?B?NTVPamtaYytwZHJjTS9iYU5TcmpwRk1TZDlCL2FoeTdsNTZhKzI4blk0citJ?=
 =?utf-8?B?TkJBaUh2c3RsVUZ1QlEwV09DaVlWZkZsem5HdGZORDMweEJPcWpxMHhLQWE3?=
 =?utf-8?B?WDJvWVBpWUlxR2piYWV6cFFLSFcyd3lFTzlCcklxWHRyMFFhY1dsdXhScE9E?=
 =?utf-8?B?K1NzVVZXeGFJbW5FN0ZaU1VDbG9tdEV3cW0vNEF1NTE5NTVOMERkK2dCT0tY?=
 =?utf-8?B?ZFlLWDlnajA0ekRnbW90M3BjYXJWcnBYMVdydjRGdVhILzQ3VjMwQVA5TmhF?=
 =?utf-8?B?ZjJ6Y0NNOVFaVjBtcjYrUDErQ3ZLM0RKbWo5M0tCVmg5dkNvWnRiazk2OUht?=
 =?utf-8?B?RC8vaGU2SDNibmk0STF0bXhicGlBVFpGRFh6aStWcTFsVkZBOHlJbEsxMldE?=
 =?utf-8?B?VFF1Q2FaMnhTMGRma3NxWlFXWnd3OFJNaUloRUd6dEJlUEhXYzUxYXlLcktk?=
 =?utf-8?B?VU5CZTlrakFabUtSL1E1cDU1ejB1VG5vL2FhYXVrbWE1VHEvUi95OHF1WWZ5?=
 =?utf-8?B?Tm5sV1RrV0NvZzY3NTZkeWhNYjlKZ0JvUzBxejRrbWJRS3lMOWJTeSsycEI2?=
 =?utf-8?B?R29FNWxlRDdXcnFzUTRDUHVtQ1lBcUo0Wkl3MS9FMERZcFoxTC9RL0FrQ3Vj?=
 =?utf-8?B?amVPQ2l3UmpIdVgrWDFMME41bEs2S1hjYk85WVV6Yk5qTUxVUFZDMExoUGdm?=
 =?utf-8?B?THBWa0t6WnZ3RFRjY09tTFFSZmNSd0o5QjdxUzg2K0dNaC90T1dySVBXUm8z?=
 =?utf-8?B?WjRIeFY1U3lVcFdjMHNTalZaQjhjbW4xUEtUUTJKSklHSjcrbm5vemRFZjhn?=
 =?utf-8?B?YW5uangwZ0FnaU9uQ1cySU1tWkJibmhZM1pHczhsbWd3ZVNJNlF2VnNlbmNM?=
 =?utf-8?B?ZFNGdUhuUVNxRkJEenhSZEw2WS94MXQybUN6WVdqeVhMZFp6cmhneU1OcjJD?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09EA52BFCAF7BB4BB595A10AFEC94829@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 930f190d-bf19-4bc1-d4a4-08dc94a37e42
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 23:15:09.8198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MgtESvDs23RnBcKECVulbe4n67x071LJWEoLclaisBU7EMwhBxVeItuJ6M4CVvrP6C/Un8TGQzfoPChG55C3UcMcXhMEBa3P138qer9jdIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8502
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA2LTI0IGF0IDE2OjI5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBA
QCAtMTA1Nyw3ICsxMDU3LDcgQEAgdm9pZCBrdm1fdGRwX21tdV96YXBfYWxsKHN0cnVjdCBrdm0g
Kmt2bSkNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgKiBLVk1fUlVOIGlzIHVucmVhY2hhYmxlLCBp
LmUuIG5vIHZDUFVzIHdpbGwgZXZlciBzZXJ2aWNlIHRoZQ0KPiA+IHJlcXVlc3QuDQo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgICovDQo+ID4gwqDCoMKgwqDCoMKgwqDCoCBsb2NrZGVwX2Fzc2VydF9o
ZWxkX3dyaXRlKCZrdm0tPm1tdV9sb2NrKTsNCj4gPiAtwqDCoMKgwqDCoMKgIGZvcl9lYWNoX3Rk
cF9tbXVfcm9vdF95aWVsZF9zYWZlKGt2bSwgcm9vdCkNCj4gPiArwqDCoMKgwqDCoMKgIF9fZm9y
X2VhY2hfdGRwX21tdV9yb290X3lpZWxkX3NhZmUoa3ZtLCByb290LCAtMSwgS1ZNX0RJUkVDVF9S
T09UUykNCj4gbml0OiB1cGRhdGUgdGhlIGNvbW1lbnQgb2Yga3ZtX3RkcF9tbXVfemFwX2FsbCgp
wqANCg0KWWVhLCBnb29kIGlkZWEuIEl0J3MgZGVmaW5pdGVseSBuZWVkcyBzb21lIGV4cGxhbmF0
aW9uLCBjb25zaWRlcmluZyB0aGUgZnVuY3Rpb24NCmlzIGNhbGxlZCAiemFwX2FsbCIuIEEgYml0
IHVuZm9ydHVuYXRlIGFjdHVhbGx5Lg0KDQo+IGFuZCBleHBsYWluIHdoeSBpdCdzDQo+IEtWTV9E
SVJFQ1RfUk9PVFMsIG5vdCBLVk1fRElSRUNUX1JPT1RTIHwgS1ZNX0lOVkFMSURfUk9PVFMuDQoN
CkV4cGxhaW4gd2h5IG5vdCB0byB6YXAgaW52YWxpZCBtaXJyb3JlZCByb290cz8NCg==

