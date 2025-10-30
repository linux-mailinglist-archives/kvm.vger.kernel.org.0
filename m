Return-Path: <kvm+bounces-61595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5860C228DE
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 23:27:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 143B51886F49
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 22:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B1733B6E4;
	Thu, 30 Oct 2025 22:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fDdvd+/T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FD9324B3F;
	Thu, 30 Oct 2025 22:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761863193; cv=fail; b=sXKSoIdjrpWXvhSJQP7pGVX/q9mDHy5BnvCqFkGMenM/8Cj6DiJt+TDM/8Ksa42f2JrxlkMMBWrqz2c+++j/LOkOj8/e2GxmK2v2BvUT/ai/ve1SrDR6FOOtOws55Eu5cDhlMY8i/24JxH80BYCo0NJwE6cxYB0qvKwbgRsQTsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761863193; c=relaxed/simple;
	bh=9sm8dsyiRBWANtslthonX/P61p3HACWM27KPcyFSaiM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nA+t3iVUEtw439MUafHNyWtbPS2D3qXJdWCmGjif1/xGMx6WxaSCC2lOk4yA3OHIjtAmJNqqGv8bkgVIW0hymk+bBo24kFR1G5q+pjG/cyequsLqqOTevu9L5FNDU8WCy0PuJFKiuWKIczVYiRfZmoYtoOOFpNJdl6J2QHvYysA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fDdvd+/T; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761863192; x=1793399192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9sm8dsyiRBWANtslthonX/P61p3HACWM27KPcyFSaiM=;
  b=fDdvd+/T+Mt3MfJ81MEPWKhIaoBdQhvNN+WNbzsHqOW34jyCFhEClxAr
   qZkLBMVRuaRk05tdIhbzFg2CBDeuPP8pzihoo6M4ZCclOQ4iIL/QQvr9+
   R5xMvYpu1/lLuzvbVRxCpUQaoY773Ys0Xgui7FPn9asPhCunOkw3tNrl7
   KIzCTml/mw2in61y5BcMfwxgLDhi6x5VPZuJP0vxqgdqC8q+Ot6mcGVDd
   KHTf4RxwIrLiKeOUxBUAeoWRQseId+tbY85kcBYVeK2tqUduT2xuiFezC
   bu1zdipfbiTC6tGJnwcdckbrqm1O5dBuklCimCPxlyBizEFHXiPlbXFRy
   w==;
X-CSE-ConnectionGUID: BAjHC3PvRM6MYKaOxOMz/A==
X-CSE-MsgGUID: xuR+NI67QDmGfadA3Vt8og==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="67672519"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="67672519"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 15:26:31 -0700
X-CSE-ConnectionGUID: r+XsEHRLROSD7//Myb+2xg==
X-CSE-MsgGUID: r6agalMcRECCCtzqFD36Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185734438"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 15:26:30 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 15:26:30 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 15:26:30 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.46) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 15:26:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cLTL3CGbcxaCzz84ZQ3Lmvk23Bj5yNP/aYK0jkEfirsMjVSJQBl7lxzZys/IaCDMHYerfWT2gyBhItzvifRjl9tnyZZYzv+CHAnPiDYgxdLE9NZst0aXaFT4AKGdkRlcL77ZjWFzTBFCEtIWDe0v+JwUhsKhenG/z+iO4y8DYujKfOU/J1xOpecL+cg8zPR8nFr/FQA+cbYrynfcC3kHuVf8REiuVOj74UlIZKggUhEMz8ApTt9gG7yrrlW/DINmrJ2T9OS++N9sfi6/vrjZ3GNaRfAVWec7ZJfaLSUYKptC14tzSQqli13uEug8JqL/cgqvTadtLviaArYeAmUjrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sm8dsyiRBWANtslthonX/P61p3HACWM27KPcyFSaiM=;
 b=d8lCBWYekJGo3FL5tcGbfZYmOY/VKUtbNCVQx0m2e10q3jw+nn3ZXRRr54Yoyuk88+yanPuFRP0811E9v8ZaYsalVFCOhjq2pNmEzXgIR9gdp0WNt70F4kOSqNEj1jopNFqRY6dPPfbkC4XFpjXOEijqi70UjV0WhcTrjcFsuYaOL3YMPVBwHwMpWc6AbPAPU8Phc6SU555QRqwGX3cK+3L9YlVlopKInS6TnYwFN07H8gACLs/uklJkwLTHeGNo7GyXpvuA9Ep5J4GteADhdV83zaOi4P2OBVLl4nhEhXL+8BWSecWIoaaJkcD35VvXwt+6zszV7Yc4yi28AItWTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 22:26:21 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 22:26:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com"
	<frankja@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 11/28] KVM: x86/mmu: Drop the return code from
 kvm_x86_ops.remove_external_spte()
Thread-Topic: [PATCH v4 11/28] KVM: x86/mmu: Drop the return code from
 kvm_x86_ops.remove_external_spte()
Thread-Index: AQHcSdlEAq+D2EE8TkO1lXV6ieAl8LTbRLiA
Date: Thu, 30 Oct 2025 22:26:20 +0000
Message-ID: <1a3921b518073b2a35af7ea517cfad95c078533c.camel@intel.com>
References: <20251030200951.3402865-1-seanjc@google.com>
	 <20251030200951.3402865-12-seanjc@google.com>
In-Reply-To: <20251030200951.3402865-12-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB5819:EE_
x-ms-office365-filtering-correlation-id: 95003656-f731-41a6-1a18-08de18035a31
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?SE5Xek1HajIyWHd2ZVhGWjU5c1hWMEtGNkNoeUQ5dGsvcElKdHZwdmlWbVMv?=
 =?utf-8?B?Q2NlMWlXZHpIL2w5MHBNZUZaS2FtT3NUamdrdWxVOGpwNHByY2gyVUg5NWRp?=
 =?utf-8?B?WXZ4eTZaL0thVml6YWxvbEJvVHVqR01EbWI1WmJEcVYvL1U3dGEvNWN3TU52?=
 =?utf-8?B?WFVYdVZqSHh3bDFlRXhQOTk3dFFEWUVlUktPK1gvSGJYaWtXcUJUdGNxd251?=
 =?utf-8?B?VzU0cGFnOWp6U0hUd2xkQm9pNFRRcExuWVpaU0FuVDBxbkJxZXZzRUprZFo3?=
 =?utf-8?B?SXk2a0toc1lVSVB4QlQwYktOQU5qZ2ZraFhTK3hhcUdTYlhYajNKMHFwMStM?=
 =?utf-8?B?bTBmTm15aFlLcEg1MzJwUXNLVDUzanV1bXQzMm1BNldEWXdVT05rZkJWUmRP?=
 =?utf-8?B?dXJlSEUxYjI1T2FyblJGYkN6WkNYeVJ4RnN3cFh1ZllqWDlha0k4ZGdnREFq?=
 =?utf-8?B?UE9aUjlHTWpDbjJueHlKVFo4NWxDQmVhWnJ0M1JqSnpRZ2twd216MGpWRTlO?=
 =?utf-8?B?dFJHUGp0THJieHcwd3FuRGdQZ0pRR2IyWEc2S0dBSVQyb1IzbDFOb3NPUGVV?=
 =?utf-8?B?NGRvQXg3T1IrTDRNQnZRcTBEMCsxS3l1Vk0wSXdjcU1NbWYrQ1J3WG9hN2d0?=
 =?utf-8?B?cDltd0xXekJEWXNEa1dYSEsraTRMdUpieTkwZkFwZTZja1llU0dVeStRN20v?=
 =?utf-8?B?d3VSbW9YbzhmbEdSZFl1ZTQ1Zmp2MGNVRm5tTFlZWXR0eG1Ib2tGc25pVEV4?=
 =?utf-8?B?NmU5MW9ONFBUck1DUExvaXdpS2VIdENKS1dlQ0FVMVh0RWxOTGN6K1RMazlE?=
 =?utf-8?B?U2c3Qk85eXc5bEltbk84MFNacjJ5YUtuQy9HcDB4aDE1V2grR3VpcndEWmRq?=
 =?utf-8?B?N3ZGdU5IenNlZkZpcHhoVWxiVmR5cDZ3QjlwS25TeFZaeGh1VDhkVnBabUd0?=
 =?utf-8?B?a3BKb2FUckVXRnE2TW1uWGtTMUxYNHBEUUJrbTVvWHliTkFCd3NvQXZ2N1dJ?=
 =?utf-8?B?bEphUkFRK3poOXRiWlYyUFJsdEZqWG9FM0JNWkt2QXAvWTFDcEpMTlpDb3pS?=
 =?utf-8?B?dHI5Y2l3bFJzTU5UaVhoZ0laZ0xTVmZoL2twcm9FR1hiT3REVnU3NWtnN1lH?=
 =?utf-8?B?dWJ5TWtTcGladHVGS3BiKzZBZ2s4TVNyWVRHSy9QWVMzbTB6Q3Q0eXpLUVVY?=
 =?utf-8?B?YjR5bEk0Y0MrblBvVGc3T2poWjdIU1UyaXlFTEh6TVBtYW1nYlE4Tmd4UHpW?=
 =?utf-8?B?c0tXZjNVd3JEY3NSOStSL2VxVGxqd2MzOHhGcmh4Y25hODE1cHpib1o0V3Jt?=
 =?utf-8?B?TUFrYzBIZjNJUXFuUnVXTEFYeFFLeFdXdkhRMFF0ZTQvWXhnNHF0dlRlVVBx?=
 =?utf-8?B?UUFsMnA2bjR1UnZpUWxkMjVsVDBaTlY1TzJpWlQ2UVdJVDFtTFhxNHRvMWZv?=
 =?utf-8?B?MVNubWp3eGtoNnBQSm92RGhlNG9WeTJuZjYvaElvUFBrVlZLMUNESUxZWisy?=
 =?utf-8?B?Z3NHclhHZjk4V2VCemEwYXpTL3VWTzg5VENXbXVZb3BXVzhTU29YNDgwZ1oz?=
 =?utf-8?B?eDJSdDlSb0VSMUhoT2FHcDZvalBveXBMYkxSb1JsWDV4a2c5blRjOGJ3ZzBn?=
 =?utf-8?B?NC9RaWlEdVhDR1RDQzBUVjEyU3ZPU0JiVjY1Zm9rd3pQN3Vya1VIYm9YVlF6?=
 =?utf-8?B?OWRTLzB5YUtqS2JKcmdETzF4TkZwbXNhN29pRDlFaVU5RGNsZDlJOFd6ZjZL?=
 =?utf-8?B?R2hCQ0lPWlhoWnlZeEIwak92SWlYRk1DQUxNWWtleVlza0VEK01tcElaakVh?=
 =?utf-8?B?K2Z3MGNHZ3RGSC91Mk81Vk93UEhpWmxNbTRHdFhQQlM5dXg5cU5KWEtuSkti?=
 =?utf-8?B?UTFZeGRpWUl4WGw3S0lZMTJjSjNTVjJiMDdqR2NFZFkrRCtlZnRPTXpGQ0d1?=
 =?utf-8?B?V2dVTVpuVVdzb1lQS0hPZndWR1Y3NW5sdXhab3RtV1Q0RE05dmRZTllRdkhH?=
 =?utf-8?B?djNUZVBycEVtU3ZZMkpTZ0ZiRHpNTng5ZUt3ZFVRWXBoSlJ2eEEvbDdQTVlQ?=
 =?utf-8?B?a3Jyby9vQ1p5Vm5UUUszL2pHQzZCQ0I2dnV0UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?am5zWEh6aVRIcTV2MGVNZmJKMkwyU0Y3eU5WVHVQaG9vN29kNXZ2c004dFJ4?=
 =?utf-8?B?bzgrZlpTRWUrc2tqVWdGeFF4SGFtZzF5dE5yK0dKa3YvOTRpclZWaVU5ZnBQ?=
 =?utf-8?B?ZkszTElhekxlVGQwUGlvamtGaXFiWUZBOWxxSWprMW5qM3phNk5PRGp1aEg1?=
 =?utf-8?B?ZStYT3d1SVRjN0tLY2dBaHdOaEpZZEo3VUtHa2szTUN1amV3b2lLN1IzSjIy?=
 =?utf-8?B?cEhMR0xHU1BTbUxYRzd6YmltUndOYmg3MFNjQUJyeHA4NlpXaFhsWVViYnZF?=
 =?utf-8?B?a2JtRExaWXVmOEs2YWU1SXA0bjBxNzdoa1ZaMGNPUncxVUo1QjJFUDJqQk5K?=
 =?utf-8?B?V2lBNEZRZFJBMm1mYzlPYmdSUzFrNzRjSmsrcHhzKzBvWVZ4VDlzVG1xbHRl?=
 =?utf-8?B?amRpMzJaTEswbDJNVGplblpKa1I5Q1BRNGEyZHBJbnZTWXlGMTVKeURvdmFk?=
 =?utf-8?B?a3B6ZWJJOUM4SVgwMklUZE5OU2J6Ukg3WGlXRmc1bHo0dk4zS2l3N0ZYRjFj?=
 =?utf-8?B?RW5ZaVlNYXY3dTh4b0Z0K3AxNDlLdWNWV0hKMi9Vdk40NzcvQzZoblBjUUdO?=
 =?utf-8?B?M09kSTJkdjQwYzNWZDJTdS9oaHVhTklxSTR6ZDhFRXVlVnprdTJ0eEswZDA1?=
 =?utf-8?B?Ulo0OExQNTBiZkVxY05nejBZeExXWWxENWM0S2VSZlQxNmM0SFRrZTJiSjRx?=
 =?utf-8?B?emkzdDB1VlIvL2lSZXVzaVg2Z1hyUUY2MGFiOVN4NmZsRzZwUzBpRTVrZ3JF?=
 =?utf-8?B?dmFBL0pXaGNjVDRTTHRvNGU4dDEvZlZtZDEvVTR5ajZPY3NhTXlvTWhTakNj?=
 =?utf-8?B?dEVqNTFuN3pTYXNYVXlMWHhPMzZheTRjdUhHWUR2VHN1T3I0RWlRTGZ2MVJG?=
 =?utf-8?B?RHp0Rm12dERYQUsvNkxWQVdOOUNlT1FUOXZ6MGl1OUZOcHFQbmJwSi9zMnR5?=
 =?utf-8?B?YjBFZE90VFdGa3VaaHNJbVhNOUsxYVNab2laU2ZTSWtYYytMRTZPUlNiL2dU?=
 =?utf-8?B?d3hhZkdHcy9IUm9IMXRxellWTndjbXh0dDgxbHVFdi9vd0lLeklRa2kwQVlS?=
 =?utf-8?B?T0RUWmVGeWtBSVo2dHlMcUtaWVRyNmhFSGJBTWtab0pJdTV5ZmtBK1dFTGRW?=
 =?utf-8?B?STdOOWxSVlljYXJwMWxYNU91U3RnbmhaSFJ4dE54cHV4K0czcEJsZHBZUGds?=
 =?utf-8?B?R1kyZHVpNDZGdG1yUGNYMWk5WW4ybkFHd2p5ME9hWXJobHhaSjhXWklZdXBq?=
 =?utf-8?B?anVxVzJxQ3VrV1V4YW1KWVg3YWszN1hFTmZWQ0M1ZkRWUTQ4aEhDT1djd1dm?=
 =?utf-8?B?OC9uZjVGaytaS1h6UFlldm82eEo0UkNvRVlOSW9mZ2JmZjBwSU1zTFN1cklq?=
 =?utf-8?B?MWozb3FyRHhLMnhnZFJmalk4SWRmNjVZL1lwUXNQRVpLR3lCTVBQZlZkc3pl?=
 =?utf-8?B?M1dKTkJkS3JHTXJ4OWRPL2N2c0k2LzJzK3M5Q3BEOGpLeDk0V0U1Nk5EOHV0?=
 =?utf-8?B?TDIyUS9XMWdKUzNFYmVRdW1hS3FvLzlaYzloUXlHRnhJUTlUeU5TREJaUVlt?=
 =?utf-8?B?UXduZmgzdnNRNnRtbWh3bjhYVlRsbDNTM2I2WUErMk9mQzBHeXoyY1VVNU1E?=
 =?utf-8?B?NmJBdUZZRS95UjNpTU02SG5mU0VjcERtMnZwZi9HenpoSnllTUVWYmhxcFhO?=
 =?utf-8?B?TExUYTZZUlBXeTh1SzJOaEMxMVJhWGxWS1RiRlViUTNyMnVxN05GUWF6N3hn?=
 =?utf-8?B?QWo1WFBuRmRmOWZSUCsvUG5DWUJZYStwM2dVdkI0cDFtYWdMR2JDVjJaZTRD?=
 =?utf-8?B?N1lldjg1OEVGVi9BSFllK1dKS0wzTDl6WFNLUUhkclNYQWM3ZU11WDFhVmpt?=
 =?utf-8?B?eUlyTW1YVk5CZk0yV0hQR0xKTHNTQVp3R0JpVGRRN3ZndkxGSHdZelRILzJo?=
 =?utf-8?B?YTlCQkM2aWFzbWE5Sjk5S1VpWjBhMFV5UUVaZ3R3ZWJaOW0yU2tZWktZUzh1?=
 =?utf-8?B?S0EzZjlCQnBZZUZJQTBWMVFaOWpIeHVTT2J2Um1obHRZTXhNVU14NUU0eVVY?=
 =?utf-8?B?Sys2djNzYW9CUDdTdkxDZCtvNHRuVzNLTC9qcU1LOElwR0hIeEZ3RVpyY3V2?=
 =?utf-8?Q?J6y8yuGvS4QeNNSvFU+eMCjHe?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34B97B9C0D9BCC4EBC19B42C7EF4DAF1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95003656-f731-41a6-1a18-08de18035a31
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2025 22:26:21.0017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PogEfgjbBXDUrlNLjvp0+Ms6B3tjf9zwVPcG7a5aA+RpXT3ap5e76zS8sfFFP1BjkHbBntocFcyp756SHLK2Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5819
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTMwIGF0IDEzOjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEcm9wIHRoZSByZXR1cm4gY29kZSBmcm9tIGt2bV94ODZfb3BzLnJlbW92ZV9leHRl
cm5hbF9zcHRlKCksIGEuay5hLg0KPiB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKCksIGFz
IEtWTSBzaW1wbHkgZG9lcyBhIEtWTV9CVUdfT04oKSBmYWlsdXJlLA0KPiBhbmQgdGhhdCBLVk1f
QlVHX09OKCkgaXMgcmVkdW5kYW50IHNpbmNlIGFsbCBlcnJvciBwYXRocyBpbiBURFggYWxzbyBk
byBhDQo+IEtWTV9CVUdfT04oKS4NCj4gDQo+IE9wcG9ydHVuaXN0aWNhbGx5IHBhc3MgdGhlIHNw
dGUgaW5zdGVhZCBvZiB0aGUgcGZuLCBhcyB0aGUgQVBJIGlzIGNsZWFybHkNCj4gYWJvdXQgcmVt
b3ZpbmcgYW4gc3B0ZS4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2su
cC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogQmluYmluIFd1IDxiaW5iaW4u
d3VAbGludXguaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQo=

