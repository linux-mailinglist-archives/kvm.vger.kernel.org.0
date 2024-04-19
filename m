Return-Path: <kvm+bounces-15361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A618AB54E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:56:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2140E1C22314
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A95413AD08;
	Fri, 19 Apr 2024 18:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D6mPOkp3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF051DA26;
	Fri, 19 Apr 2024 18:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713552957; cv=fail; b=r/SqB2IzhH+TNiwRaTyafQLzbIGJ/5U1Tx6a/s6zV/Z70xTXN3AXfu35GYrIPJ+rnH8g3unx0nDVMPL9WiBk6XQEI/jDeQfbuO12dL9qaThnhrKv2d2Mye2rfqn3rYcMfM0wwtSfQR8478K8e37bldwPxYA0NpvRyRt43wzGq1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713552957; c=relaxed/simple;
	bh=hQWtkv5BDEdyQ+i6Ie1p9/Ysl8p+Uf7XMSP4o+C873Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jb4GrSkb+qLGKtYnUllIzn//9Iy95uV3M7pcsaGg1U1fbuUHkxiHt3Ig9bg4AOefi0SLQEUaTuBYGtfNP2qT1qETKsj9RhvxXMSHMY/9cdAvVbm35/dSuPlS9aKx3UYlbwhjwSUSbQylI5h6Ki5PbVn6672W+CxpJPEW2iq8bCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D6mPOkp3; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713552955; x=1745088955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hQWtkv5BDEdyQ+i6Ie1p9/Ysl8p+Uf7XMSP4o+C873Y=;
  b=D6mPOkp3S6CVnbhyvaju84pLJ1lRSFrJl8Kc7K4eltCFbxwnY7/mnJCQ
   05UMN9KHfa7oxSKSA3biCWhyRUiU0l8AKdixwW5k32Q4/17QgK2YudVD2
   UZmlRfZNpGoIJijph6pnmK7VvFRm4yYs1T8ZuJsVcUA66VJjfbLIoeLLP
   /+p4jDwoKTeFhtgxxN0J3W+2PQRNckVwo8OvgCgmwNHF9wDkKLpDHz9q4
   uSpiLdxPBgPsnzpYF6jiqW3YR5mLtD2yRmFEUpkzmlrpd9ktzvbTi4OQ4
   KqR62n9iXo7B/upKXZ3Ay7sUHN3mrkJqGamYyCciY9zENm61PqWTZRmVO
   Q==;
X-CSE-ConnectionGUID: AbZ+wT4WTeWIn48F+pBRog==
X-CSE-MsgGUID: Zfki6fDhRBmaZJgQJtrrkA==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="9041088"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="9041088"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:55:55 -0700
X-CSE-ConnectionGUID: ZWAjPGaFRPqDSSsaTd+bWw==
X-CSE-MsgGUID: EO9CiliCS2ikqRQSzsZtZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="23395375"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Apr 2024 11:55:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 11:55:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 11:55:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Apr 2024 11:55:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 11:55:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKOV0HZ2e/+8DV1Zo0iD4YaBv6UB9usY/wWvBdLHgpitlIexMmvppSvPPJNUnIRRhmmYKjBK/kotgkXIw3arj77no7mUFVtCwxj6JeDmzvZudfkbnho4Ir7P0t5AQT16Y0ARNz1IEH6xh/Ti0uexJy0yHXMtFRu89A2y0iVV+b4tznpJGpGE47LskBEZFF5C1fQ9ZzVRTgfF7vRKrol71mOxIawzM2KAXIFB6XDN1FpjcL8jhFlms33z6lZJVDnVirv0IRxtHQ4NHzr4x0s2wtCYzkUQBVqAIAfzbeSEI55MxEFEVklWPg6QevEYRhUEAH/Dxnx+YnJu57F4xB5LqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQWtkv5BDEdyQ+i6Ie1p9/Ysl8p+Uf7XMSP4o+C873Y=;
 b=bPghuqweBEOFFxxqe43XFg3cGKQRnUwVLR+V9Z+hh518CQEyM8fJpVimXr4wTfPbMiD5dR0MMc9qJHX5fPFm/MtJAwelWxjFWwICUcTtJQoF70g7aPdqfX83ahHKJKJqyNia0W6jdK0AJV/mdUc0t9DQ43UBCpT5jRO5V8AtIQPlNQ7zw+6D3faIumgknTyNHOkaDhJ0QSMKHZNohZBDBtaAb1/YRPkGUAOdoCupg2LVx1TZOLlE/6zBWqjIzmiNUaDrfWlR4sSnmHWICOuFKwlHAlTotwq6IwDgTSVoYwam32cjryFN5l5ePOfkbUob2Xs4vi5SyCZ/lm4NBjBhiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7184.namprd11.prod.outlook.com (2603:10b6:8:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.42; Fri, 19 Apr
 2024 18:55:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.015; Fri, 19 Apr 2024
 18:55:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private mapping
 for TDP MMU
Thread-Topic: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Thread-Index: AQHadnqsibQeLxqb/U2XJgNL61wQ37FGCaEAgALn1ACAACoJgIABSBaAgCXF2YA=
Date: Fri, 19 Apr 2024 18:55:50 +0000
Message-ID: <26486ffd7ee198a397ae2b854a6d3cc100987595.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
	 <7b76900a42b4044cbbcb0c42922c935562993d1e.camel@intel.com>
	 <20240325200122.GH2357401@ls.amr.corp.intel.com>
	 <ad203761cf0f93e9feb4ea7037c9b9c1f39714ae.camel@intel.com>
	 <20240326180605.GC2444378@ls.amr.corp.intel.com>
In-Reply-To: <20240326180605.GC2444378@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7184:EE_
x-ms-office365-filtering-correlation-id: 910fe30d-b28e-464b-1188-08dc60a254fc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?bHVTczNhSVVudlltcFJoUThTakcrZ1BIMUdnMHQ2T1VMVG1UZ3hKUHQ3VXFm?=
 =?utf-8?B?QWptN0phVGR4VE4wWW1KWHJBTU1lcUpvUnJvV2o4bTEwNHo1cld4QzRtMm50?=
 =?utf-8?B?cjJXRDFVZWFVY24zRnp4TWlPMSsvSDhoS0h0Z25OdStsbzdXbk5rUzRWWXUz?=
 =?utf-8?B?aUYvM0Q3dXh4ZUJiUmtsdmFEOXJ4Q1JUMWU0eS9UYlFFdzFvbFNNMkxLR3ZE?=
 =?utf-8?B?WGEwVUhrMkFIMmlhY1A4VnZuOFc3UHVHRHBmejd6YkVhWlRqTWRBM3M1SGJk?=
 =?utf-8?B?MTRsUHRCU2k0T3hBZnkvZ0FYU2tPNEI1Z1p0NnBEZXpoa0ZhaW5lSnU5aWps?=
 =?utf-8?B?RUpISWdhZ0p3WDBMd2xoT1IycHpHSUxTaVNNaHVwNjkySXp4SWFoVjByQmps?=
 =?utf-8?B?dGVRM1dvYm9vdEFHR2pPd3Rrck4rbG1TczFoU3BVbzBSc1JabkZTcjlJMGx6?=
 =?utf-8?B?akNVN09BUUFOODVTWVF3dXpUazV3ZDBmMDB0OFc4RmwxeUNtQkd0dmxXVWNn?=
 =?utf-8?B?cXIyTFhUdWgyVnc2R0habFN2d1FMcW83VjA4Q21TSU1EalNnb25nNjJnVUJX?=
 =?utf-8?B?Z0xydDBWTmRjWDZ0cXlyRFd6Q3JOVzVxUlZTYk9QNmdrTTJobUZuVEx5ZnNm?=
 =?utf-8?B?NXZkZTFjc0pTQXBrUXhJVjF3MjR6MFUxR2Jac0dEdnRkOHZ0VjVNM3B2bG9k?=
 =?utf-8?B?RnBIYWpJVTM3dE1RTmZNLzhGSVByU2ZKL3cxd01ZK0NONkVQTlRiM09EWVRS?=
 =?utf-8?B?WHNjQU8xdHNiY0J5SlR4SWxHU1pRM1UzVHQ0TVJwK3hEdGdvRWQxYUsvSDl2?=
 =?utf-8?B?WmZBamFWWEZFaEw4OFlPa2Z5NUdIUkNpZ2ZSeU1FQTFoYlBNaGdYQjhLS2NO?=
 =?utf-8?B?N2JWNmlOTlFYb1Y3MG5Ca09aaXNybzJqNzF0WUF0VEdGOVZLVGpiM0pSWFJ3?=
 =?utf-8?B?R3diN0diRkpPY1V4UnR1VlhiYVlCdGhYejQvOSsydjVNU3IwMHR3SGh2NGl0?=
 =?utf-8?B?OGtFK1RwY1FhOG1nT2xydkllNFQvcjU5N0xwa3pDc0U1RUQwS09VTkRNL2w0?=
 =?utf-8?B?bEx3RmVRTEF3QnR6Yjg1NktKdUpOeFBZN2hML2c5d2RSMFhCd1FpY2U3Yllj?=
 =?utf-8?B?UVNZRlIzL244VSswWDYvaHZQaTk4NnJReU9hYnliUUNQVEprdTRlTFJPNkFy?=
 =?utf-8?B?bWh6ejRmYzN3RDl0NkdjelFFcmsxamRYMHJMSlNlbWJUY1hKeXZCVWN1M1Z5?=
 =?utf-8?B?cU1LUjBsZGVTMjdyVG9oQlExa1dWWHZubWhhNkJ2a29ZbEJkVkZucE1mdklp?=
 =?utf-8?B?dFNZdlk5VnZQK1dtZTdkR0hyakhNY21vYmZRNFMzOU0xWWJlTWhERzI4UWMy?=
 =?utf-8?B?OWp3VVNwWXhVZXc5VUVJWnJnS1FodlhvanBiZzhDUnpMSTFUTGVHbUZDYW14?=
 =?utf-8?B?Y0I0NUlRcVBQZUd2SDlLbnlNZkhLd2JJVUdWd1pCVVlzc2NjWmdyMkUvalZw?=
 =?utf-8?B?bEx3THdvaHhXUkhMVXhJblRweThtd3dQM1lybHpDeXBKaDg0bUJ4SVJ3RUtV?=
 =?utf-8?B?Y0UxUlRsSzBzN0pLSnNLenBVUVY5dnV0bHJtbkI1QU0wRHIzRWsyb3dsSEJp?=
 =?utf-8?B?Q0h0QWxYZStmWDhpMFJIalZTRVR1aEpPUWhMT2d1UWM2OE1YTHhTNmFMSnZW?=
 =?utf-8?B?TzhIUmZmODlHei9MQXRxVjNORmlKc0RhTjR4cEd3cnVITzYwcFFZRldBbmp2?=
 =?utf-8?B?WmNwNWk4YU9rMkdvMUZUL3BpYXdpMTVWRWFINWdtL3NkZkZBWHFuZGZ5RGox?=
 =?utf-8?B?QnROY2xKYk1DbjV1RVAxQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUlhL20vaVp4UkVXa05JbHRBRzVrUXdzMTV5Qm1lMmFGc3VRVnowSm80Tllz?=
 =?utf-8?B?K1hqbzQ5UDFrMU1ZM3NOV0xzVm93UktSRHJNMU9rSEZmbXNhWVFYUTdva1Fp?=
 =?utf-8?B?YTY5Y0U1b01MWWNMcnZFMDlBdjlGMjR4dDBFOUFmNUNkK2NtbnhEc3IrdDN2?=
 =?utf-8?B?cVV0TG44M0RjaTFibndEa0dqTnZhYTNkTS83WUIrQndhcXBDdVpJOXNmRlRW?=
 =?utf-8?B?MTNnQ2JUdlpFMVFVbjh1Y3RQc3NPck5IWWFPRGVORmExbWkxeGRnMlZaR09I?=
 =?utf-8?B?MG5KWmZMTWhlV05NbnRvOTlsdk9MWVNmeVpvNFUxc3p5cHUveXg0OVdHSTN1?=
 =?utf-8?B?WVM0bjdFRkR0UUVRcE1kTUhFWThIc01leXcydnZlMkdnR24vdUpqQ1pId05l?=
 =?utf-8?B?VXBEQmp4TVltS1RGYWRJZ1NtOTVSa3paVVBQQThkbnJQRU04R1JQQ1J0VjhH?=
 =?utf-8?B?T3FndVgyMytrd1U0UTVUT2FxQmpMYjhHck8xaCsxWW9UVElkYmtVYnMwanZw?=
 =?utf-8?B?UWlvVkdIbnVlL0dsdTFuMFRrd29BekhJSzRVM2hFbGV6aHFsRHdhV3JycE5k?=
 =?utf-8?B?NzVXaDhlNUxwZFRKdjF1bnZUbUZQaXFZWXFJcWZkTitWUGx3cG9scVZDUnlp?=
 =?utf-8?B?Y2Q5MGFodzZOSGliNlpPd3BMZFAzS1JjZXEwVFM5cldmL2lPSEQ4SXFBNWFM?=
 =?utf-8?B?RmxSYnRGL0tRaWlYOGl5UWxLRngzM3lyTEZCQ2p4bGtJSW8vWVA1YlovbndU?=
 =?utf-8?B?cHVnYUM2Nkl0aW1nWkc3ekNpOHQyNVZad1RaZER1U2FTSUtENTNNK1h5ZklO?=
 =?utf-8?B?SUJ1YnBOS3hvckxraFNzUEJSd2pyVkxvQU1STUJaaWdGNlVqSWJhYi84U2xC?=
 =?utf-8?B?eUFBUCs1ckNSdVoyelVDUE91VWdJQU1nd3lzbTB0c053b1RlK0prMDU5d3h5?=
 =?utf-8?B?MnJ4Q3ZGZWNuNEdDd2svRVRHQ2tYL2QvU1J3S0hvWGpqMnhucmZWSGVzcldx?=
 =?utf-8?B?OGZjY2RsQWRWbUxYZkg1Z0NYUlljeWhHSkdFRERMV29CMVk2TWg4ZlhLYWd6?=
 =?utf-8?B?UHRoaXkyVHl6Y1lxVDdkQWExdlVkdmNLMVdTanl5aUFyenAxVFIwZnBxVkxI?=
 =?utf-8?B?L09FZG50TUlkTzRIUTJYK0VvbCtOeHJ1WTZ2Wk1pTlNXcllBOFZRR0d5c1dH?=
 =?utf-8?B?QXJKWmQwdmxNNVJNYzF0R05VQS9QQnZ3TzJLZE9BOEJJWXlYMmp3cUhNSmhM?=
 =?utf-8?B?RFFWWGpIQStoSVZzekFsRzBnWUdvYTFtTnNIaHIvZUM4eUVpNkZVY1VJVGFV?=
 =?utf-8?B?SCtsblZ0a2FiMzZVb1lwczB2T0VIM0tzYnByTWVZTW9GUm9nRTArNGdRUTV5?=
 =?utf-8?B?dnp4TVZIY0pTakdrNTB3am00SXp4VzdLcm0zSnA1ZXVLRHFlRW1sSldzYzBx?=
 =?utf-8?B?UzhCWU9DaFlpQlB4bW5WSW1zYTduRXpvc093TGw1TU4xdnVmbmxTVU81M3pU?=
 =?utf-8?B?b2ZKUm1meHNPZkdMcktVQWY1RjM3RVRqWC9hMVJtRExIalJiSWxKeno1S1NQ?=
 =?utf-8?B?UGpvQkhlN3U5b2Z3TFRIQ0MxeHBxaFk0OUFJeG1VbUVESUtSUlFxQW5jendl?=
 =?utf-8?B?TSszTVppS0tCejcyVngyT1ZnOWxGTFlZRTVkTUgzblduZml5V0RTUGdVb3I0?=
 =?utf-8?B?bEd4TmhPUlVhWWJNbnZZT0M5MnNQMHZkMnd3djBxSUhIMjBidnBYenNBQURV?=
 =?utf-8?B?S0M4cWNyK1hjLzdUYlZLdlpoQmlwRmtTNkxGTTlPTVU1UkZUK1FiTGVOekwy?=
 =?utf-8?B?cmZVZU9mZm40aHFXaCt1QVVnZitEdjZkUzZTcWt4TGNkZTAraVlUWjBTVEk2?=
 =?utf-8?B?Nk1qbTRrU3hDZzZFZWIwWGMyZm4rZzM1Y09ML1VRNUNUM3NlVk1GbnVVL29q?=
 =?utf-8?B?VkpTZm1iSzhtNlJid3FtVHY3RmtwMkc5ck90ZWl6bCtEbC93Yi9Tc0NiV2Q4?=
 =?utf-8?B?bUJZUE91c1VnNnNIRzF6WmRieEZZL1dYdWxqZ2ttUFYyN3EvL2V4c0RCYkVl?=
 =?utf-8?B?d0tKc3dsSnZEMGRtb3hTUlBJSDdBTnA3VGdaK0phT3Exc3FYbUYzWUx5SjE2?=
 =?utf-8?B?VE1sdW0zc21OZzZPUlBOQjlSS1Q4R3MzbGFvZUVzeDI2UzdFaGQ2akxidEtQ?=
 =?utf-8?Q?AkmActPzS7SOo2z4yjXC3oc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8A3832711FA3B488EB730A0634219FD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910fe30d-b28e-464b-1188-08dc60a254fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2024 18:55:50.6396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k8Pl8SNe5B5Gd39e16bGssV93GwsZfpIsde770BKmERJKN8E8Ti0CypOzueGWj7zTCACxp5fMvhabo4E/qT4jEi9Wm2nNUlAL3Wr6Etngvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7184
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTI2IGF0IDExOjA2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBJIHdhcyB3b25kZXJpbmcgYWJvdXQgc29tZXRoaW5nIGxpbWl0ZWQgdG8gdGhlIG9wZXJh
dGlvbnMgdGhhdCBpdGVyYXRlIG92ZXINCj4gPiB0aGUgcm9vdHMuIFNvIG5vdA0KPiA+IGtlZXBp
bmcgcHJpdmF0ZV9yb290X2hwYSBpbiB0aGUgbGlzdCBvZiByb290cyB3aGVyZSBpdCBoYXMgdG8g
YmUgY2FyZWZ1bGx5DQo+ID4gcHJvdGVjdGVkIGZyb20gZ2V0dGluZw0KPiA+IHphcHBlZCBvciBn
ZXQgaXRzIGdmbiBhZGp1c3RlZCwgYW5kIGluc3RlYWQgb3BlbiBjb2RpbmcgdGhlIHByaXZhdGUg
Y2FzZSBpbg0KPiA+IHRoZSBoaWdoZXIgbGV2ZWwgemFwcGluZw0KPiA+IG9wZXJhdGlvbnMuIEZv
ciBub3JtYWwgVk0ncyB0aGUgcHJpdmF0ZSBjYXNlIHdvdWxkIGJlIGEgTk9QLg0KPiA+IA0KPiA+
IFNpbmNlIGt2bV90ZHBfbW11X21hcCgpIGFscmVhZHkgZ3JhYnMgcHJpdmF0ZV9yb290X2hwYSBt
YW51YWxseSwgaXQgd291bGRuJ3QNCj4gPiBjaGFuZ2UgaW4gdGhpcyBpZGVhLiBJDQo+ID4gZG9u
J3Qga25vdyBob3cgbXVjaCBiZXR0ZXIgaXQgd291bGQgYmUgdGhvdWdoLiBJIHRoaW5rIHlvdSBh
cmUgcmlnaHQgd2UNCj4gPiB3b3VsZCBoYXZlIHRvIGNyZWF0ZSB0aGVtDQo+ID4gYW5kIGNvbXBh
cmUuIA0KPiANCj4gR2l2ZW4gdGhlIGxhcmdlIHBhZ2Ugc3VwcG9ydCBnZXRzIGNvbXBsaWNhdGVk
LCBpdCB3b3VsZCBiZSB3b3J0aHdoaWxlIHRvIHRyeSwNCj4gSSB0aGluay4NCg0KQ2lyY2xpbmcg
YmFjayBoZXJlLCBsZXQncyBrZWVwIHRoaW5ncyBhcyBpcyBmb3IgdGhlIE1NVSBicmVha291dCBz
ZXJpZXMuIFdlDQpkaWRuJ3QgZ2V0IGFueSBtYWludGFpbmVyIGNvbW1lbnRzIG9uIHRoZSBwcm9w
b3NlZCByZWZhY3RvciwgYW5kIHdlIG1pZ2h0IGdldA0Kc29tZSBvbiB0aGUgc21hbGxlciBNTVUg
YnJlYWtvdXQgc2VyaWVzLiBUaGVuIHdlIGNhbiBqdXN0IGhhdmUgdGhlIHNtYWxsZXIgbGVzcw0K
Y29udHJvdmVyc2lhbCBjaGFuZ2VzIGFscmVhZHkgaW5jb3Jwb3JhdGVkIGZvciB0aGUgZGlzY3Vz
c2lvbi4gV2UgY2FuIG1lbnRpb24NCnRoZSBpZGVhIGluIHRoZSBjb3ZlcmxldHRlci4NCg==

