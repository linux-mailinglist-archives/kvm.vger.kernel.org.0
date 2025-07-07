Return-Path: <kvm+bounces-51686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B87DAFB9F2
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4110D17FD51
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 17:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3257238D53;
	Mon,  7 Jul 2025 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eF4HCtyA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1021E1F4E4F;
	Mon,  7 Jul 2025 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751909621; cv=fail; b=TjnS4MxUQ5Dw1qdckeGXdskO9L4FwDzU6m4uHWgerzGcADQDvbRt8vmsnRkZyUzO+ODI3uYAddkl+wstbC9DR1EAerCtDzPQLpDYWcp/ltTsQR/SBXNXcPNaYsBZL73Hl4RCn1nPVpKuCXWd+UsdlKQ6d5VZz9jmgR7zP8hYgsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751909621; c=relaxed/simple;
	bh=CCN8UXOxD26oZ6jBFDq0EwOgnb8UY200CVjO5lIc/c0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nRCiPtX2/sOhizQ02DjNrCi6C+V9onGCUMfJ9PKin2p7EbHBaet+pV5i0i2RvWAsZ9IKxYSqqPAayczHAT0zncF6UdAAhaEYpYg/qW9h+S7UB35OKYVpvrC5PlA1wQ3aGlum6zorTRtW1/9eBZQMk/1fzzksGquchcH4E/Wqh+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eF4HCtyA; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751909620; x=1783445620;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CCN8UXOxD26oZ6jBFDq0EwOgnb8UY200CVjO5lIc/c0=;
  b=eF4HCtyAGm1Z+peYY7mYdWkmtOOHohroeEGadxVLHa+aNUVE5niFOfDP
   CPog3lLwnNNaZxUzFTaGjrri5Bxx9jegfZD2LIut6zuUIePAt0iICzr15
   orUj80/k31nl5Oy0G3C7Sygm1RK+IzmhGhZbPgG/DzvbYd9imO8MkwiXc
   5RPMLXrYOaB2lHWynl3xnbhVZHsNGWDdMOGFlQMJHibEW62dQlmdCsR45
   zPr0cxacqnFXgDIMxE6WHYWmCaIG0giGtUZr8e+N/8Dmhpe1a2CrKUJqb
   shEHOnAb+67rTaqwl4Cky70zN4Z4MnFL1K1ixzjWDNkvj1V1ZK9qsLDx+
   w==;
X-CSE-ConnectionGUID: Lr1AcV+DRh6HaPTyaP5rAQ==
X-CSE-MsgGUID: vu5qsllWTXe49Xbfe6oHyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54262768"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="54262768"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 10:33:37 -0700
X-CSE-ConnectionGUID: 77JMHSuLRUKS1He3pnwOjg==
X-CSE-MsgGUID: uwlEsPIbTIyt7dNBKGiGnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="159605651"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 10:33:37 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 10:33:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 10:33:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.41)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 10:31:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RkW5CFvSAruxupgXlV4h1dZTHwEPq+VvIvlAc4zVKzbSr0G4OGoDyWOlWfmxwy5xepXihHmZD1xoFz8O1LgagZD9R3njrRypE31Ig4iPZnZzV3JcbL/aXdXTwL0U8kJoHPBfSX+GO+0TcEzOpSDvuq5RyTgwJ3EDwUhTB/D5m/0JHDqOKCIpmWMvjBgQfLEgYPeT7XsW8LW0pPSc/r5poIkpz/UwG6Qg0pAxRbj81F2qKCMnZIwTc/mLITBCFMUFdEq84+oeCof/0NXfwn6DMfFKCbomT63nEMNocwFsxcG2piKxSNLa5vMJ8TgMQv1wen1+T9BmBLDJT5aUc6SnYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCN8UXOxD26oZ6jBFDq0EwOgnb8UY200CVjO5lIc/c0=;
 b=QfbPpmY0vz2cuTTN+Rx3D3ZdNOzuaz9xloxkRmEgAlZ0gUL9ADZIvf9m7QoE9ImKPiMVUgatVuYwPnpzPmkwEi2B7BsFjloIdLIEdPkwIXwxlFo87UZ1A0bojJKznS6PtUN8gXEY1x9sWz4epWWSocKeHiMPuPoMdfi5EGODUR7BbzNib+bpYnLY1+ArU/JBC+iiDmW3auaE/bhZOXevmt+FdojvBHtX7f/WA4/5AsKkPCr7je4N9AoRYIIFF1C7+jINluC4JvGWafaEJMTA3IKwt4fbT25DMwcnlGCSYP9o8sY28hH4ehdFX8xEC9lnqsH1cfuJvP1d030Q/nDSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4936.namprd11.prod.outlook.com (2603:10b6:510:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 17:31:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 17:31:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH V2 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V2 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb7DBrzFeCQwmHLU+JPM4jkGckqrQm8YMA
Date: Mon, 7 Jul 2025 17:31:19 +0000
Message-ID: <3a2805d43cababb922dbe339d73ac8efa638243a.camel@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
	 <20250703153712.155600-2-adrian.hunter@intel.com>
In-Reply-To: <20250703153712.155600-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4936:EE_
x-ms-office365-filtering-correlation-id: b6031226-93f3-4d1d-17d8-08ddbd7c15e7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UGUyL2dwQ3B6Q0N0azlPdHk5bDR0c2dSbm54TG5uRXVpeDRENE44bmVlNkk3?=
 =?utf-8?B?YWJUR2I5SjJPY3RJK0NMQm5rNkVXSUtDZ1I2NHVtTDd3TEtnUWhubXcvQ0VF?=
 =?utf-8?B?VlV6c1FIdDlaaGZHMkRxZXVkeDd6LzM0VTVDak5kbEJPOE1xUXFVWS9kTmZO?=
 =?utf-8?B?VmZVWlMyR1kvaGN0c09nS3d1S3FrNHAxb1k3MWNCNWVDYWN5NmdHS0M0Q0JQ?=
 =?utf-8?B?WEtmYk50aVk2V0dqR2lhY1VWbi9wcFREdWJ0WmpZTjc1Y1hoM0dwNW8zV3NG?=
 =?utf-8?B?bVIydStSLzhqUEV2M1lOSCtkZmdkMERLSE1PMzBObnZFNEdrbzNuWFVsd3ZB?=
 =?utf-8?B?bXZYM1lJMFk5WTVBdTVqNVY4aXVrdW13eVgrQjBjbmtNbkF3NzNLUlc1YmVM?=
 =?utf-8?B?KzRubi9QQnJPaVg1QWpUeVhZY3JZUmRtb3VZand2UWFSQlJoWkkrVEpUODBk?=
 =?utf-8?B?WFVidFZJMERRdkROT1Y5elo0SlFKdG9MaVNVVmFyc0d2SnhseTJlaW5Vdk9p?=
 =?utf-8?B?dWVFeHNFVk8xQTVhQkkxS3FBWWlSNzZjQzZKa0dNL1F2UVdxQmR6bW1tMWI0?=
 =?utf-8?B?ZEpLMlVFbVRwZlM3Zk1ieDZMOUhXVW92MXFYODdKeDZBM2pKY2ZZRU16WHky?=
 =?utf-8?B?NVh3MnNjWWpxYzZBUU9wSjJXVVFDd3lMVDFtZTl3a3NPMXNpSVB1Vmk3VzdW?=
 =?utf-8?B?NFdJTjlOdzFtdFlSK05Icm1VZ0MxUFJtbnRQQWdxNWlMWlNJaGp6YlRFTEVo?=
 =?utf-8?B?M2cxOWF3Tnk1SU1FWWcyd016a3ZWaFVxcmNrbHJiakx4eWR2UEFSK2RSd2pF?=
 =?utf-8?B?ajdyZEk0TmJaQmRaU1dpTWo2RWJoZ0lYOTFRTUxXTWtIM1RmVWt4VjczRXVy?=
 =?utf-8?B?UUh6VGI3NEh2TVIvL3lWOTAvSEpkZTFqZncxd0xBQktlalVQTk5BakJZY0c1?=
 =?utf-8?B?ZW1LM2hmcko2ZUJOY1FxL0lKdjk5K09KSk1ROEZEMzhDN2htcFRKSHRiRlFR?=
 =?utf-8?B?bDNIczR6MDdRckFvSWp0eWg4S0dTTU5iTExFS1d6ejhwMFhYc0hwaWQ4cU5x?=
 =?utf-8?B?bDV1bitGVjMwUFBKM3R2cE5GWko4RnFyRWk3TDNRYWlmMVkxY0xkTTZzaXNG?=
 =?utf-8?B?ODNsL2U5bjdnRFZuY0RIQ3ExVDQ1Ri9PN08zVEpOK1pKeUo1RlNoWmUxajVX?=
 =?utf-8?B?RkdOK1g1cjJqNXdJT0IvdFlEdktWMVBRNnJucGNENHZnK3RHc3BQN3Vtbjdm?=
 =?utf-8?B?UUREQVF6am00Z3o3MnNtQy9hMVlKYWpSeFo2UkcyNFNPN2NNSmEzWm92TkM3?=
 =?utf-8?B?cGsra25jejBMaDBYY2dLU0hQVE9EeWc4NTdsQ3ZXbk40cTBSTi84WTJ4a1ZJ?=
 =?utf-8?B?Y1ovV2lzdGF6cmcvZnhUQjgvc0ZwSDQ0MWZmQ0hValMyREptVUpKRlNEYUkv?=
 =?utf-8?B?MkgydGtNWlV0S0gvMFFkU3hWTVRaQkZFdm9HakREWldqNEt2RzQ5RW1BTXZB?=
 =?utf-8?B?VE5JZjN0eWpWSU1yMUhrZzlpd2twZmpzaDAyeXJJc05rRUxnbFhlcXFjelhh?=
 =?utf-8?B?WXdIKy9qbFg1NjRORzEyTDZGSkhHNjA3ZU8zS0lVU0p6WWNLTlU1eXJQVUtD?=
 =?utf-8?B?UGZpRWFnVmF6SFNCbGtCdGhVY25SWk9SMjBGb1Rzek1KKzRwRHVjYkdSRkFa?=
 =?utf-8?B?eHNMQWRzcWYvTnF3VlIrTjR3OCtCd1VVRmtXeVRiMzJRMjZjNVZCaC81OUU5?=
 =?utf-8?B?VnducWJ5cmh1Tk1FckMzSCtkYXdJVG8xRHJrcno1QitidWg4Q29tR3hNaW5s?=
 =?utf-8?B?RmlCeUNNMWo1ZXI2VDYva29pYStSVGl1NDQvN1NIZTZsb3A2TnNTMTZNS3FL?=
 =?utf-8?B?a3U0WVhobExkYU9GZEgzcEJJK2FXWVdSQ3ZpMERhbERhNHN5MXpwV2tsUGZ0?=
 =?utf-8?B?NGxyZnFTajVoMmsvVTJndFRGbEJnUmhXMEIxNmVLR0VJUHNBb3NYVFZsNk9p?=
 =?utf-8?B?VEluZXU3RjZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enRnWjkvVXJaWTY2MzAyOWZydy84NEdGYVc3bjVGMk5ncTVSUktSRGNNV053?=
 =?utf-8?B?RFZndm55N1lISm8wWC9RS2FRMEFHeGhJMGhrWCtMdGszblVubXo4L0tOcFZ2?=
 =?utf-8?B?Y1R4MFB1bEN4cGgwYSt3b1BRbEdURmd0Skx4bFMvd2hrODJjSVloekNBelBv?=
 =?utf-8?B?N3pDVG9odUROK3k4ZjBEeUJuNU5uakZac0F5c2RlOS9GMGJxVSt5eGpFNksr?=
 =?utf-8?B?SkRvZnNUcHdlWFVrN0dHSGo2a1FLLy8xVi83R2NmUmFUdWlaUDJPNlNoak5a?=
 =?utf-8?B?TjZLSjd0UG5xcEpNVS90S3N2Vi9FZjc1VU0rdWFZQ3dLSGpSUVM2Zm5rU0hC?=
 =?utf-8?B?Ukl0K3cvS2VtZmc1em05MWtuZ3FXaWFmbDd1R3E3UjBTWUhOTDYyMDJiRzQ2?=
 =?utf-8?B?ck5vVmxhSm0vaEhXK2lqTmxjckJrUW9qb1J3Z1VxUGhvT0t1dHNmcHZvUUtG?=
 =?utf-8?B?c1g5aVYwWE1jdWtVSmtHVE9FVEFrUkI4NUp6TW1XSTVrQ0dEMGtQQXkyYlNz?=
 =?utf-8?B?VjlwTUtqS1RPT3lMUSsxRExEZWxCeW0rNTJPOUE5bDlsR0ttd3VLLy9pMEFN?=
 =?utf-8?B?cFIzQkVGVVNoaTlKT1IvN2VTLytYdWVVa0dIM2p5Y2dOL1pTNWc1UFJiSHlN?=
 =?utf-8?B?TlV4aDFmbGNJb0RnWVljL2VuUnRZRzdYMHBQeDJaYk1SenJvZTRrSEdqbmVj?=
 =?utf-8?B?L2NGaEFNZjZpTDZwVFRJZ2VzK0x3WkFHVWVYTnB1eXJWTHFYVDkyTHAva0hk?=
 =?utf-8?B?dXF6bWZVelgxYlJpYnJqTFFsNEtqSDdFcFZTdFMyYjNJS2VyYWZiWjNhYU1J?=
 =?utf-8?B?d1Y3dFJCek5qSjB4czFnNnlsOUpLN3paVWV1VHVKM1B4SVhkcUl4UEU4SlNp?=
 =?utf-8?B?ejkybjY4MjZWUWkxWXNRWUFpeVlaYVJUWFVFQ1JudW5mMnBwakkzbEVjR2tm?=
 =?utf-8?B?VHVHOHAzdWpIZE5qbmFLSnJQdEw1L09iaEhFemVOTlIxWXZDREY4cktPdUF5?=
 =?utf-8?B?Wjd4ejJ1Mi80Qmp3ZUFLNlQ0aTRmQzZRZmF3KzYyQk1pUFpDZnA2cTRTZ0FJ?=
 =?utf-8?B?SFdDcFpCWXo2TDB2b0drMTFoNjJxRGhoMjQ0VHozOVFISE5CUjI0Yko1NHRs?=
 =?utf-8?B?SnNOdWhnWnJiWmVaeEU5U0Q2Ri9qQ3FudGRMS0ZSNmVFcXUvVkJOem12c0lC?=
 =?utf-8?B?Y05za1gzVFhReVpVZFFPbU9YeFlFQWh4UERWOFlTOWVIWVBQTW45R2tjOHhI?=
 =?utf-8?B?cmhNSmhyTFBNUVZaYlpRQVhWdWZwYmd4b1IxbmNVakRNT2gzM3c4Zmlrb004?=
 =?utf-8?B?NEYyQmppZjMyR3Y5SjluWFIyZ0QwTWIxcWIrazFGMHZJWGYvZ2VVaEJ3djZj?=
 =?utf-8?B?N2tDcms1eFJxUUlxVFhhdk9JTDRjcFM3UE1RK2djbDZNVlZwTUZPN1JGc0RL?=
 =?utf-8?B?RlBsd3FjdGtDRk0ySnpSTVc3VElFckdwTDJHcHBnMnlLdXVaUGc1SDMwZUJr?=
 =?utf-8?B?RldFR2hHOHcyTkgwZnZLVjJSdGRNWTZJd0pKTjdHYWxiRXcvZmxrRlp3cWx2?=
 =?utf-8?B?cWNrTk1qODZodGRka1FaRThHUWxmalE1cisvOU1JbHhuRjA1UExXOUFkUExi?=
 =?utf-8?B?OFRPRmJwYlRydWlUVnRWRWZJU0paeHY3SElLNmwzNE92NnNyWWNwRlJKRUJ4?=
 =?utf-8?B?emx4Y0dEQmo5NUNkd1AzbzZCeFl5U1pJSUJGZ25iQnlyMUkySzFMZHFSSC9o?=
 =?utf-8?B?WVNhMEhDdXowcGtpallvb1h2TWl1c1VKdEszVUNyQjdqbG41M0FPOHF6QS9R?=
 =?utf-8?B?cERvQklGd0FCQS94WGtncFJoSE03WTErT3hlQW9zQUdlVkxJWFlZV285dHB1?=
 =?utf-8?B?NzRNNEV6N2NKbnFBOTd3OWhhcXR2Rzk2UkhHWWZPQUtNVnY0b2taNmNFWHBK?=
 =?utf-8?B?R25uNFVCdEEzdXlNck5Ja3lTSE5UMFpRVyttbnhReFJaT2NoSmpzMFhlME1w?=
 =?utf-8?B?SlBFVUdlZGlpZmg1YTdRYW1PSTdUeUJ1MUVkUXpONkxRNG1xTU1uenNMOFgy?=
 =?utf-8?B?cEpPc0hIRnZkUS9hSTJENWxKS0F0UWZHY3V4UzNXdHZpQWkyTUFzZGFFekFO?=
 =?utf-8?B?TmtBVXBuQVpXWlMrYngvN0szMGszOUxTUGtvV2FzcldiSm8zZmdwLzBhLzFo?=
 =?utf-8?B?L2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B99DE6BFED9A8244B838AAC6D934E454@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6031226-93f3-4d1d-17d8-08ddbd7c15e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 17:31:19.7233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +bVctYNWOegNNik5wWHys4mSTbf8T4ZmfvcoHQEOPlUNWtzfyPnHEdI5oG2YpORu9h/7nga3/Wn4mXX/yvkfEpBPerKcexS3AdvfFUmMe4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4936
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTAzIGF0IDE4OjM3ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiB0ZHhfY2xlYXJfcGFnZSgpIGFuZCByZXNldF90ZHhfcGFnZXMoKSBkdXBsaWNhdGUgdGhlIFRE
WCBwYWdlIGNsZWFyaW5nDQo+IGxvZ2ljLiAgUmVuYW1lIHJlc2V0X3RkeF9wYWdlcygpIHRvIHRk
eF9xdWlya19yZXNldF9wYWRkcigpIGFuZCB1c2UgaXQNCj4gaW4gcGxhY2Ugb2YgdGR4X2NsZWFy
X3BhZ2UoKS4NCj4gDQoNClRoZXJlIGlzIGEgdGlueSBmdW5jdGlvbmFsIGNoYW5nZS4gcmVzZXRf
dGR4X3BhZ2VzKCkgdXNlcyBtYigpLCB3aGVyZQ0KdGR4X2NsZWFyX3BhZ2UoKSB1c2VzIF9fbWIo
KS4gVGhlIGZvcm1lciBoYXMgc29tZSBrY3NhbiBzdHVmZi4NCg0KVGhlIGxvZyBzaG91bGQgY2Fs
bCB0aGlzIG91dCBhcyBhbiBvcHBvcnR1bmlzdGljIGNoYW5nZS4NCg0KPiBTaWduZWQtb2ZmLWJ5
OiBBZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT4NCj4gLS0tDQo+IA0KPiAN
Cj4gQ2hhbmdlcyBpbiBWMjoNCj4gDQo+IAlSZW5hbWUgcmVzZXRfdGR4X3BhZ2VzKCkgdG8gdGR4
X3F1aXJrX3Jlc2V0X3BhZGRyKCkNCj4gCUNhbGwgdGR4X3F1aXJrX3Jlc2V0X3BhZGRyKCkgZGly
ZWN0bHkNCj4gDQo+IA0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggIHwgIDIgKysNCj4g
IGFyY2gveDg2L2t2bS92bXgvdGR4LmMgICAgICB8IDI1ICsrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0NCj4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8ICA1ICsrKy0tDQo+ICAzIGZpbGVz
IGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMjQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90
ZHguaA0KPiBpbmRleCA3ZGRlZjNhNjk4NjYuLmY2NjMyODQwNDcyNCAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20v
dGR4LmgNCj4gQEAgLTEzMSw2ICsxMzEsOCBAQCBpbnQgdGR4X2d1ZXN0X2tleWlkX2FsbG9jKHZv
aWQpOw0KPiAgdTMyIHRkeF9nZXRfbnJfZ3Vlc3Rfa2V5aWRzKHZvaWQpOw0KPiAgdm9pZCB0ZHhf
Z3Vlc3Rfa2V5aWRfZnJlZSh1bnNpZ25lZCBpbnQga2V5aWQpOw0KPiAgDQo+ICt2b2lkIHRkeF9x
dWlya19yZXNldF9wYWRkcih1bnNpZ25lZCBsb25nIGJhc2UsIHVuc2lnbmVkIGxvbmcgc2l6ZSk7
DQo+ICsNCj4gIHN0cnVjdCB0ZHhfdGQgew0KPiAgCS8qIFREIHJvb3Qgc3RydWN0dXJlOiAqLw0K
PiAgCXN0cnVjdCBwYWdlICp0ZHJfcGFnZTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92
bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IGluZGV4IGEwOGU3MDU1ZDFkYi4u
MDMxZTM2NjY1NzU3IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsr
KyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gQEAgLTI3NiwyNSArMjc2LDYgQEAgc3RhdGlj
IGlubGluZSB2b2lkIHRkeF9kaXNhc3NvY2lhdGVfdnAoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0K
PiAgCXZjcHUtPmNwdSA9IC0xOw0KPiAgfQ0KPiAgDQo+IC1zdGF0aWMgdm9pZCB0ZHhfY2xlYXJf
cGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkNCj4gLXsNCj4gLQljb25zdCB2b2lkICp6ZXJvX3BhZ2Ug
PSAoY29uc3Qgdm9pZCAqKSBwYWdlX3RvX3ZpcnQoWkVST19QQUdFKDApKTsNCj4gLQl2b2lkICpk
ZXN0ID0gcGFnZV90b192aXJ0KHBhZ2UpOw0KPiAtCXVuc2lnbmVkIGxvbmcgaTsNCj4gLQ0KPiAt
CS8qDQo+IC0JICogVGhlIHBhZ2UgY291bGQgaGF2ZSBiZWVuIHBvaXNvbmVkLiAgTU9WRElSNjRC
IGFsc28gY2xlYXJzDQo+IC0JICogdGhlIHBvaXNvbiBiaXQgc28gdGhlIGtlcm5lbCBjYW4gc2Fm
ZWx5IHVzZSB0aGUgcGFnZSBhZ2Fpbi4NCj4gLQkgKi8NCj4gLQlmb3IgKGkgPSAwOyBpIDwgUEFH
RV9TSVpFOyBpICs9IDY0KQ0KPiAtCQltb3ZkaXI2NGIoZGVzdCArIGksIHplcm9fcGFnZSk7DQo+
IC0JLyoNCj4gLQkgKiBNT1ZESVI2NEIgc3RvcmUgdXNlcyBXQyBidWZmZXIuICBQcmV2ZW50IGZv
bGxvd2luZyBtZW1vcnkgcmVhZHMNCj4gLQkgKiBmcm9tIHNlZWluZyBwb3RlbnRpYWxseSBwb2lz
b25lZCBjYWNoZS4NCj4gLQkgKi8NCj4gLQlfX21iKCk7DQo+IC19DQo+IC0NCj4gIHN0YXRpYyB2
b2lkIHRkeF9ub192Y3B1c19lbnRlcl9zdGFydChzdHJ1Y3Qga3ZtICprdm0pDQo+ICB7DQo+ICAJ
c3RydWN0IGt2bV90ZHggKmt2bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+IEBAIC0zNDAsNyAr
MzIxLDcgQEAgc3RhdGljIGludCB0ZHhfcmVjbGFpbV9wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQ0K
PiAgDQo+ICAJciA9IF9fdGR4X3JlY2xhaW1fcGFnZShwYWdlKTsNCj4gIAlpZiAoIXIpDQo+IC0J
CXRkeF9jbGVhcl9wYWdlKHBhZ2UpOw0KPiArCQl0ZHhfcXVpcmtfcmVzZXRfcGFkZHIocGFnZV90
b19waHlzKHBhZ2UpLCBQQUdFX1NJWkUpOw0KPiAgCXJldHVybiByOw0KPiAgfQ0KPiAgDQo+IEBA
IC01ODksNyArNTcwLDcgQEAgc3RhdGljIHZvaWQgdGR4X3JlY2xhaW1fdGRfY29udHJvbF9wYWdl
cyhzdHJ1Y3Qga3ZtICprdm0pDQo+ICAJCXByX3RkeF9lcnJvcihUREhfUEhZTUVNX1BBR0VfV0JJ
TlZELCBlcnIpOw0KPiAgCQlyZXR1cm47DQo+ICAJfQ0KPiAtCXRkeF9jbGVhcl9wYWdlKGt2bV90
ZHgtPnRkLnRkcl9wYWdlKTsNCj4gKwl0ZHhfcXVpcmtfcmVzZXRfcGFkZHIocGFnZV90b19waHlz
KGt2bV90ZHgtPnRkLnRkcl9wYWdlKSwgUEFHRV9TSVpFKTsNCj4gIA0KPiAgCV9fZnJlZV9wYWdl
KGt2bV90ZHgtPnRkLnRkcl9wYWdlKTsNCj4gIAlrdm1fdGR4LT50ZC50ZHJfcGFnZSA9IE5VTEw7
DQo+IEBAIC0xNjg5LDcgKzE2NzAsNyBAQCBzdGF0aWMgaW50IHRkeF9zZXB0X2Ryb3BfcHJpdmF0
ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgCQlwcl90ZHhfZXJyb3IoVERI
X1BIWU1FTV9QQUdFX1dCSU5WRCwgZXJyKTsNCj4gIAkJcmV0dXJuIC1FSU87DQo+ICAJfQ0KPiAt
CXRkeF9jbGVhcl9wYWdlKHBhZ2UpOw0KPiArCXRkeF9xdWlya19yZXNldF9wYWRkcihwYWdlX3Rv
X3BoeXMocGFnZSksIFBBR0VfU0laRSk7DQo+ICAJdGR4X3VucGluKGt2bSwgcGFnZSk7DQo+ICAJ
cmV0dXJuIDA7DQo+ICB9DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gaW5kZXggYzdhOWEwODdjY2FmLi4x
NGQ5M2VkMDViZDIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0K
PiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gQEAgLTYzNyw3ICs2MzcsNyBA
QCBzdGF0aWMgaW50IHRkbXJzX3NldF91cF9wYW10X2FsbChzdHJ1Y3QgdGRtcl9pbmZvX2xpc3Qg
KnRkbXJfbGlzdCwNCj4gICAqIGNsZWFyIHRoZXNlIHBhZ2VzLiAgTm90ZSB0aGlzIGZ1bmN0aW9u
IGRvZXNuJ3QgZmx1c2ggY2FjaGUgb2YNCj4gICAqIHRoZXNlIFREWCBwcml2YXRlIHBhZ2VzLiAg
VGhlIGNhbGxlciBzaG91bGQgbWFrZSBzdXJlIG9mIHRoYXQuDQo+ICAgKi8NCg0KDQpGdWxsIGNv
bW1lbnQgaW4gdGhlIGJhc2UgY29kZToNCg0KLyoNCiAqIENvbnZlcnQgVERYIHByaXZhdGUgcGFn
ZXMgYmFjayB0byBub3JtYWwgYnkgdXNpbmcgTU9WRElSNjRCIHRvDQogKiBjbGVhciB0aGVzZSBw
YWdlcy4gIE5vdGUgdGhpcyBmdW5jdGlvbiBkb2Vzbid0IGZsdXNoIGNhY2hlIG9mDQogKiB0aGVz
ZSBURFggcHJpdmF0ZSBwYWdlcy4gIFRoZSBjYWxsZXIgc2hvdWxkIG1ha2Ugc3VyZSBvZiB0aGF0
Lg0KICovDQoNCkknbSBub3Qgc3VyZSB3aHkgaXQgaXMgc3VnZ2VzdGluZyB0aGUgY2FsbGVyIHNo
b3VsZCBtYWtlIHN1cmUgdG8gZmx1c2ggdGhlIGNhY2hlDQppbiB0aGUgb3JpZ2luYWwgY2FzZSwg
YnV0IHRoZSAidGR4IHF1aXJrIiBmcmFtaW5nIG1ha2VzIGV2ZW4gbGVzcyBzZW5zZS4gQ2FuIHdl
DQp1cGRhdGUgdGhlIGNvbW1lbnQgdG9vPyBNYXliZSBzb21ldGhpbmcgYWJvdXQgd2hhdCBxdWly
ayBpcyBiZWluZyByZWZlcnJlZCB0bz8NCg0KUHJvYmFibHkgdGhlIGxvZyBuZWVkcyB0byBleHBs
YWluIHdoeSB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCAicXVpcmsiIHRvby4NCg0KPiAtc3RhdGlj
IHZvaWQgcmVzZXRfdGR4X3BhZ2VzKHVuc2lnbmVkIGxvbmcgYmFzZSwgdW5zaWduZWQgbG9uZyBz
aXplKQ0KPiArdm9pZCB0ZHhfcXVpcmtfcmVzZXRfcGFkZHIodW5zaWduZWQgbG9uZyBiYXNlLCB1
bnNpZ25lZCBsb25nIHNpemUpDQo+ICB7DQo+ICAJY29uc3Qgdm9pZCAqemVyb19wYWdlID0gKGNv
bnN0IHZvaWQgKilwYWdlX2FkZHJlc3MoWkVST19QQUdFKDApKTsNCj4gIAl1bnNpZ25lZCBsb25n
IHBoeXMsIGVuZDsNCj4gQEAgLTY1MywxMCArNjUzLDExIEBAIHN0YXRpYyB2b2lkIHJlc2V0X3Rk
eF9wYWdlcyh1bnNpZ25lZCBsb25nIGJhc2UsIHVuc2lnbmVkIGxvbmcgc2l6ZSkNCj4gIAkgKi8N
Cj4gIAltYigpOw0KPiAgfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwodGR4X3F1aXJrX3Jlc2V0X3Bh
ZGRyKTsNCj4gIA0KPiAgc3RhdGljIHZvaWQgdGRtcl9yZXNldF9wYW10KHN0cnVjdCB0ZG1yX2lu
Zm8gKnRkbXIpDQo+ICB7DQo+IC0JdGRtcl9kb19wYW10X2Z1bmModGRtciwgcmVzZXRfdGR4X3Bh
Z2VzKTsNCj4gKwl0ZG1yX2RvX3BhbXRfZnVuYyh0ZG1yLCB0ZHhfcXVpcmtfcmVzZXRfcGFkZHIp
Ow0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgdm9pZCB0ZG1yc19yZXNldF9wYW10X2FsbChzdHJ1Y3Qg
dGRtcl9pbmZvX2xpc3QgKnRkbXJfbGlzdCkNCg0K

