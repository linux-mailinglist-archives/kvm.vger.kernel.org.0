Return-Path: <kvm+bounces-57839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0D8DB7ED25
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88E63325BE7
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 10:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2171F305975;
	Wed, 17 Sep 2025 10:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BjQKf1gt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3568E2DF71E
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 10:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758104908; cv=fail; b=OaTvDlj2gBp3/H7MoZKoeuklXDxLAoX7+3AbWtkoW/XN75KSflMRQD2DAcTvX4GNvBuAmRqJnlxtxsbSPDBa9Cm2PL9zJR2iAHw/zyb/pnixDn+4WALmRYYSjWpJwfKwJUQvfl9Oq3OTFxDyag4hgJwKq8xbcC9tnfLFTZspccQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758104908; c=relaxed/simple;
	bh=8okWySPUW2MsVsccKxOglW23g1oxiE7JUDtNf7b1Mys=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mHHpvTyixPnFPcyW0R9TIuMaJP4q8nPk5cf87gC2uApU7dgVpuuBGwnd7dMzmo+uGDcGaLj10fgyN4PSkv+kP7svad5uAMiStuWhxZeFNcs8yyyikVkhIX7ahNGZZVF7Fm5J0Gek3q3lXOUVOQq+A1+7B9ozJ926VFvMAd2PFFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BjQKf1gt; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758104906; x=1789640906;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8okWySPUW2MsVsccKxOglW23g1oxiE7JUDtNf7b1Mys=;
  b=BjQKf1gt4jle91WaAaBrMJx1RTxRfMovXh0dvYL66IFVc7d22/zf6nOL
   /xLsDnzQBPAOxkFR6Qvp6X0HyX/kQiDKBJZsL2/cl/OzNMpPf8AIwP7x/
   tEn2vhR8n2HyiNpN1lTbg6Mf7E0EvIW02rFCAvjquay/OT6extbpuYw+E
   UwanRq7hXSeMlq+4rtiA5m5FTuKbUF+khRNc7RXIcdhjEvZQSoOmxJSJJ
   93Rwwsy7MhwZssF4VuwLpSpZKscZ1er96v5dF+BEJe6CjgsZ/bMvU7Qda
   m/FbdlHBSCUvcDEdRCA2DBEJAsGQ7IRBqb17KCV20ucycDWgN0AIW9xo/
   Q==;
X-CSE-ConnectionGUID: a30FEQakSleMqWj+GyfZRg==
X-CSE-MsgGUID: lCq2VGWDQhuomzks/y0tGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="64225570"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="64225570"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 03:28:25 -0700
X-CSE-ConnectionGUID: jCdGrddGSmG0HY12rsNPyg==
X-CSE-MsgGUID: rEb9YgTXROS8SIXbITLXXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="206150742"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 03:28:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 03:28:24 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 03:28:24 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.8) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 03:28:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WaVbot07mYLjhksd75hKp54fPw67Subx5lvu9ph66wBUznSPr9AMALTx8WovRFZtjAdLFrmg89r0s14K2keVcZgHvqVej8iLGYCKgh1UukWbAAGTPLz/fOynW18WRRO6s6wALw5os3vP2gvCb+cEkbU1Fz9qLcFSCcoXOpOPIGmwcATEUyjPWYkd0Az4DvXG5buvTBu4qtkmoRuV/bs2rV0BSVJWLzWDkSsxy1lCfhWBYjMDcAY/ZeTjfbqE5fDoJGjMuFx0A94VTL0Gp2Q2cvf2fHnfQSnhAhJy3qlpiZoFMnpwl1ZhEW8/w+4JrBM3R/rz3yw2HoySXqIhPB3BeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8okWySPUW2MsVsccKxOglW23g1oxiE7JUDtNf7b1Mys=;
 b=DLz5aa80jV60SQ0rvlhh8YIBuZq/mV8+e13yZKQByVYjNNmrdb/b+8En0ftUZh6Uc5tXXu30NtmexJggrjcVTuapfW5eLhNhDPae6QqSKyMZnM5ChE/SipCyjwXYtDKQ/t8EJBFwbRGkM5L4i92OKChYbYJ0FnSYueDb92HMQpybFs7SgYn8AJurFzZvm5RAfXZ2b7ttVE3KmGDqCT/c2TidnaNgnI9etORUsqGudclk3rN8R4aRYenwM7kGreFds0J3WsBPbYLk7gbFFw39C/rmVGSBpqzraou8ADp0vHzMvPUr9TSnemNMFvpMshdNfo7V7snllo941nb9gljDgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA3PR11MB7655.namprd11.prod.outlook.com (2603:10b6:806:307::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 17 Sep
 2025 10:28:21 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 10:28:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch
 structure
Thread-Topic: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch
 structure
Thread-Index: AQHcJh86omC9Nm5qh0mOG0q54ZAePrSVnKGAgAEeJoCAAHBHAIAAASMAgAADIQA=
Date: Wed, 17 Sep 2025 10:28:21 +0000
Message-ID: <b8948521640844298345d86237f915434f1e7bed.camel@intel.com>
References: <20250915085938.639049-1-nikunj@amd.com>
	 <20250915085938.639049-3-nikunj@amd.com>
	 <fa0e2f42a505756166f4676220eff553c00efb1e.camel@intel.com>
	 <80fd025b-fd3b-4cf1-bcab-20d5b403666a@amd.com>
	 <5e6c276181bdfab55de1e5cd5c0d723e76cfbbea.camel@intel.com>
	 <7d7c3d4f-eb27-49a4-91ad-b6c3aef17237@amd.com>
In-Reply-To: <7d7c3d4f-eb27-49a4-91ad-b6c3aef17237@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA3PR11MB7655:EE_
x-ms-office365-filtering-correlation-id: 89bb5d15-1da9-4952-a38e-08ddf5d4eccb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?c0JnMk9iL2FnM3pKTFRpOThVTU4rc2dNczgvSlllc0QrQXNkNlRBb0ttR2lV?=
 =?utf-8?B?NUZVOG9QTkJodkFFYTNKSWlpelFGdzZjdG9wRGttbDJGTC9QU2FzdHl3ZVh2?=
 =?utf-8?B?dm9kYkpPTnRhNnpSU3JFYS9MZGd0ckladFBVcTlrREpIL0tESktSUmVVWGZP?=
 =?utf-8?B?Z1ByZzNFaklVeDBkQ0x6bHRucjNKNjNYeHFIeE5WM1VuandycjNOSnRlVkpi?=
 =?utf-8?B?NVdOeGF0aGkwRUZ5bk5Oa3lWczZPTDc0d1pydXBrMm1MZWphNVZWRFo0bkQv?=
 =?utf-8?B?SUVIbEVuWjRxRm1MblVwYW1QKzUwREhia1VMQ0V6eFFSY3hwaUthSkNESyt3?=
 =?utf-8?B?clNKTFphR25VRHBsM1pIaGM0amZyUnhmNEdaWGNFUWtIMG50c3Ewc3lIcVNJ?=
 =?utf-8?B?SXhoR0pWSUZYSyt3enVWRFBIaU9TVmJvUlFNR1NtQjRzMStYaFhzWHR3YW5m?=
 =?utf-8?B?SkJnaC9IMGc1djVhdERJcHdNa09sR2xNQWxTdkxldUo5WjdhdWk1aWMraXRu?=
 =?utf-8?B?NTNJQWtwU2t0V1BqKzVFRjdLcmxQVDFoS1Rna0x3aHFiZisxSkJYeW9vd3dM?=
 =?utf-8?B?REIwMWNtVXlnUnIwNGYvZFFoVmU3eEJYMy9KNEQ1Tm1TV2VoRXhMOVhDczVB?=
 =?utf-8?B?SGY4ZXQva1hYUU5aSjZOSDNRUEp6aGdJY2hNVWZtbmUzWDdsU3hRZEwyQUhU?=
 =?utf-8?B?RVpqUXA2SnkzVzRnbHY3alVYNitKNXNoQndJMnd0QndOZFBFRGVYeHNHbTNZ?=
 =?utf-8?B?b0JXV3psY3RYQitnZ2RTTXpUbFRPZExOV1dZaGx0ZndLRXhnNlpTajJybXlM?=
 =?utf-8?B?ekxqSFlSVUFXa096MFkzclFKRnlWOUs1OFZ1YWxtT3dzRnR3WVNXaENVSDE0?=
 =?utf-8?B?eEhMaFI1bW5iaXdRNzNpd0Y3QU1TOFVHUmtlQVJIb0ErbnZoYnRTNkFFWXVo?=
 =?utf-8?B?NGQ5Wk5mR09oWklGWHhsampZd0w4RzRBQ0tuRVl0c1N5Uk90d0ZWUFBpZkZT?=
 =?utf-8?B?c25BWlpUZGpDeTBjVVIzQ1BpaGpIUytUQXZzallUR2ZLN3RPdVFTdmpidHNW?=
 =?utf-8?B?OWM1cHNmeGthSnpDUTRpTWhMNUtWdDVuWDlmOWhQeTRZeXJ2SFlXcW0vQ2p1?=
 =?utf-8?B?aU5lSnZWMlY4OTk4b2FGQ2k1Z0FTd041WVp6ekNDYkFjcGpsN1dtL3NiQ1RE?=
 =?utf-8?B?dzhlVGwxS0ZNc1I4cS9FUEJtb2QwbFp1bmFuQXRxbSt1aEpKUkZtalpNdnRM?=
 =?utf-8?B?MzlZL2xZMS9xa1FPRkJsN3BvQXB3N1RsRlpnWFBCRW85UlphNFEva3BnK3ps?=
 =?utf-8?B?Q3lxVVhkb0NDeFZONFJRTGVSRW5wc2kzZi9aeTcyOGs3cmNOdVl6T1p5Y2dT?=
 =?utf-8?B?ODRTYXFnelQ4UnFYTWNneEdvdlJ0SGNLNGM1bm96MGN0VERKajEyQjB6OW1Q?=
 =?utf-8?B?MHUzZ2NJcEVhNWlJRVZIOGFMMFdKT3gzUnlaZkZjTlBRT09RM2JXeGdhMnZB?=
 =?utf-8?B?cG9TNzg2dUFtNkZweTN2QWs3WGo2QkxnR1RYQk9LMXhtdjBOUUJ4VXZtTkJP?=
 =?utf-8?B?NGtNK25IUUZsT2NjYnA3Zjd0cGwycDlkNUFCNElmR1pwNFFlSFQ0ODIvUC9O?=
 =?utf-8?B?SXBoS25XVlNhanppQWg3NjJlNk1qblIxSjA2b25aMmtvUWJWOUxuZHRoMkJ1?=
 =?utf-8?B?UWFFR3J2L3luaVMrTSsvVTJsVDV4b3ljRXpzYzgxYWg3OFB4MlZPTEs1eXRZ?=
 =?utf-8?B?VWdrUVpjTkhqZUV3Z3lwZVVXckYwcE9NbHI4Uk1hRTlMYmw2TW9VRnFLb2Ri?=
 =?utf-8?B?aVdxU1RlU3pic2Irb1ErRUhCSUUwTWp2VzJRdXNySlYySStjTitDdkRhYVVU?=
 =?utf-8?B?eGpjMHhETUdFdnVmQkRnM1c0cWs2bERDQm9UbDdBMExva3JCNHVlaUlEZ3d6?=
 =?utf-8?B?Q0xnTE5GVTR3VFNwZmdVWmw4ZWZDejNlSWZrZkhaYWFhZjB1Y0o0b0JUdmRB?=
 =?utf-8?B?WUYvVjRsWm5nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2hsMVFnRmQ4aG81RVVNZm9WK2Z5TnFBdDRDKzk3R0RoS2hBRXJYVFhBcE41?=
 =?utf-8?B?SWRCaUdoMldkWWJlenlRTGxCdHlIQWdyd05ZMkpEaWdnbTB1c3B1bm1ERmRv?=
 =?utf-8?B?dVRJQ0psZDQ0NERPa01RTDdWQVBZaDlCalJNV3RLTmpwaVJCUlRjQUJGbE0w?=
 =?utf-8?B?bjdidy9XM1h6UmtxN013Y3VDQ1lvRkk4UEJtS3FJcHlTMG1NN3FDMzYxcVZt?=
 =?utf-8?B?dWpGS3lscGU3YkhvTEFVdTVxRHM0ZnFGQktOWTBFNE1oUENvSDZXdGhRalBS?=
 =?utf-8?B?R2xqcmU5akl3QXpRTFNMSXBNenhURTFTVzFtUmY1RnB4NlRESmRvalR0bTBn?=
 =?utf-8?B?YnJNRzJIaDhZcmsydmQrdGRzYkJVRXhaUi9xM0tJdEFYRldxaSszS0xBV2RE?=
 =?utf-8?B?WWFnWVlNMGxIZm1XblNIWEVwNUt6WnpUckMxcHE3Ykcram9pcnBIZ0I1T3JY?=
 =?utf-8?B?V2x0clI0Y0F5cEd1M0FicDVuTEZwWCtCek1GSGYyRHJmSks5M0hMR2ViT0hX?=
 =?utf-8?B?dGVsTTlTVDcwc1Azc3RpMXpheTJHZVFSVHEvQXU5b3p0dEU1M2NHZm9zUGsy?=
 =?utf-8?B?dms5SGxxS0pQdmJvYXBNY1ZmdHI3RDBTcDVGSnR0bXl2RE9XeXRXeXpDT2ZQ?=
 =?utf-8?B?NmpUNFpXc3RVbUlsRndrWktLcDlHa3EyMnBncHhxWWg1bEk0ejZsbE84cVZ1?=
 =?utf-8?B?TTdTWm4ySUYyUmhTOWxkL1VKUjVXci9SZitxSVQwd2Vxd2hrOW1Va1lqbXhJ?=
 =?utf-8?B?ZEtzelRNU013bit2WWNiOTJtMlRMVloyZ1BGMUwxRndFeU5lb0puNk9OVGxl?=
 =?utf-8?B?VWVIaHFabjRMSCtRaThBWXFIWHhTeG5YekhobW5hUHRURkp0ME5Veng1aVh3?=
 =?utf-8?B?NXhuTXlVOTRWbksxS2llcEJTN3kvZzYzdDdNUHQ2UENtUnc4K1N4WHdETGxm?=
 =?utf-8?B?S0xObzJndElwa2s5THJvb2lEZFVQWWIrQXJYWVZXNTFnaExJcURrbzlWUmRm?=
 =?utf-8?B?RDZsU2x1TTBGV0g1a1Zra1o2TWM4VkczN1JMeUZEMldEbW9NVFZ2REJFc2Rt?=
 =?utf-8?B?UEFwWndJdDlJNlpyS2Mwdkt3RndUTWIyNU95RU53Z3dBejZjcW44cG1oRTMz?=
 =?utf-8?B?dmp5ZTJLVHBYYWl0QzRjdEh4RkxkWkJmMjQxN1BWbUZUZnBUdjlWYlpXcURR?=
 =?utf-8?B?YlNLOFNpRVlEb3VuNFpvT1diMFF6NjZqdlFlK0dPUDR4U1NZZ1RHREFvVWNj?=
 =?utf-8?B?bnlWRTlDa09Td0MzRlg0U2hJOFBHanhEc1A4eVEvOXNBNS9FaVRpbkZzWENz?=
 =?utf-8?B?bUlTM3BEZjBLd29GRHpZR3lLc3RKby9wRjVKK3NMbEFJSlBVdDVvNTUrZkxV?=
 =?utf-8?B?cTFyanFtYjJaR2FFb3g4ZE9lNExDRjExYWMrTnN3d0FveVIvc0U4dHBxOWl3?=
 =?utf-8?B?dkFWY3NEZGJ1WVd1Y3JmZFcwWlpaZW9xaGpibG95NFZURkRkc2dhcjgyY3RT?=
 =?utf-8?B?TE54M0czS2s3QXVmOHBLNiswUjdjcFVDdnpYT2lLRHpXYzJ4UUlXWWNTbTF4?=
 =?utf-8?B?Nkg0MzM1c0txVHQvSlFYNk9YZExjUGU2dklhQmV4UU83L1B4dXR1ZG9TRHJ5?=
 =?utf-8?B?djFXVGxwaC9xVStETlVkVlBueDhacnEyZ2xVeU1oenl4dDhFczVKdWd2VWcv?=
 =?utf-8?B?SDh2NkpxeVdxQUE0OVhWc2toZlA5Tm9RRzZjVG9KYzZjS05tN3BWa2diTkFw?=
 =?utf-8?B?QWhaSkJVYVI4d0VMUndGZTZNWlBtRm5uYStMdkdBRjNhK0pZRnhjQnRGT2xk?=
 =?utf-8?B?aGtYNlBPMWoreEVRUW45MkllV1o4YkdxSWFta0tYQjgvL3A2UG1EcHNzbFhp?=
 =?utf-8?B?SzA4OEN5c0gyUkY0TCtwU3Y1bDV1aEJ0ODR5M2FuUjl5bXpOVGVIQWJUSXU4?=
 =?utf-8?B?QVNFa3ZkTy91amxkdHU5bkJ5bFppWHFpclYyNWw2cXJJc1BORlhna0J5THlY?=
 =?utf-8?B?dkQxZ25PVnRSVFBYd2VETkRPU1RWWHJvM0dRM2Q0aUdML09VZSt1cWhOSjR1?=
 =?utf-8?B?Z2dDRW1mWVZHWlRsNUtCWEN2SU0wTUVvdXJScWZERkZ0dURPVTg0b21teDdH?=
 =?utf-8?Q?+/hpbAF4Y7D9xbW2mbL6PVK9M?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E27E26918E7D3E45B40317282A675FCA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89bb5d15-1da9-4952-a38e-08ddf5d4eccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2025 10:28:21.0859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rE8F9aUlFo/3UlsgWrRe9o6Mg9ReyX7LPSdhKX2zJhzdvZWxq/iOD8BNCy/Xhf3x2uxjYFCAAjmsuKdDdAeU0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7655
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA5LTE3IGF0IDE1OjQ3ICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiA5LzE3LzIwMjUgMzo0MyBQTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBP
biBXZWQsIDIwMjUtMDktMTcgYXQgMDk6MDEgKzA1MzAsIE5pa3VuaiBBLiBEYWRoYW5pYSB3cm90
ZToNCj4gPiA+IA0KPiA+ID4gT24gOS8xNi8yMDI1IDM6NTcgUE0sIEh1YW5nLCBLYWkgd3JvdGU6
DQo+ID4gPiA+IE9uIE1vbiwgMjAyNS0wOS0xNSBhdCAwODo1OSArMDAwMCwgTmlrdW5qIEEgRGFk
aGFuaWEgd3JvdGU6DQo+ID4gPiA+ID4gTW92ZSB0aGUgUE1MIHBhZ2UgZnJvbSBWTVgtc3BlY2lm
aWMgdmNwdV92bXggc3RydWN0dXJlIHRvIHRoZSBjb21tb24NCj4gPiA+ID4gPiBrdm1fdmNwdV9h
cmNoIHN0cnVjdHVyZSB0byBzaGFyZSBpdCBiZXR3ZWVuIFZNWCBhbmQgU1ZNIGltcGxlbWVudGF0
aW9ucy4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBVcGRhdGUgYWxsIFZNWCByZWZlcmVuY2VzIGFj
Y29yZGluZ2x5LCBhbmQgc2ltcGxpZnkgdGhlDQo+ID4gPiA+ID4ga3ZtX2ZsdXNoX3BtbF9idWZm
ZXIoKSBpbnRlcmZhY2UgYnkgcmVtb3ZpbmcgdGhlIHBhZ2UgcGFyYW1ldGVyIHNpbmNlIGl0DQo+
ID4gPiA+ID4gY2FuIG5vdyBhY2Nlc3MgdGhlIHBhZ2UgZGlyZWN0bHkgZnJvbSB0aGUgdmNwdSBz
dHJ1Y3R1cmUuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UsIHJl
c3RydWN0dXJpbmcgdG8gcHJlcGFyZSBmb3IgU1ZNIFBNTCBzdXBwb3J0Lg0KPiA+ID4gPiA+IA0K
PiA+ID4gPiA+IFN1Z2dlc3RlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
PiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IE5pa3VuaiBBIERhZGhhbmlhIDxuaWt1bmpAYW1kLmNv
bT4NCj4gPiA+ID4gDQo+ID4gPiA+IE5pdDogSU1ITyBpdCdzIGFsc28gYmV0dGVyIHRvIGV4cGxh
aW4gd2h5IHdlIG9ubHkgbW92ZWQgdGhlIFBNTCBidWZmZXINCj4gPiA+ID4gcG9pbnRlciBidXQg
bm90IHRoZSBjb2RlIHdoaWNoIGFsbG9jYXRlcy9mcmVlcyB0aGUgUE1MIGJ1ZmZlcjoNCj4gPiA+
ID4gDQo+ID4gPiA+ICAgTW92ZSB0aGUgUE1MIHBhZ2UgdG8geDg2IGNvbW1vbiBjb2RlIG9ubHkg
d2l0aG91dCBtb3ZpbmcgdGhlIFBNTCBwYWdlIA0KPiA+ID4gPiAgIGFsbG9jYXRpb24gY29kZSwg
c2luY2UgZm9yIEFNRCB0aGUgUE1MIGJ1ZmZlciBtdXN0IGJlIGFsbG9jYXRlZCB1c2luZw0KPiA+
ID4gPiAgIHNucF9zYWZlX2FsbG9jX3BhZ2UoKS4NCj4gPiA+IA0KPiA+ID4gQWNrDQo+ID4gPiAN
Cj4gPiANCj4gPiBCdHcsIGp1c3QgYXNraW5nOiB3aHkgbm90IGp1c3QgbWVyZ2luZyB0aGlzIHBh
dGNoIHRvIHRoZSBmaXJzdCBwYXRjaD8NCj4gDQo+IEp1c3Qga2VwdCBpdCBzZXBhcmF0ZSBhcyBW
TVggYW5kIFNWTSBpcyBub3Qgc2hhcmluZyB0aGUgcGFnZSBhbGxvY2F0aW9uIGFuZCANCj4gaWYg
d2UgZG8gbm90IHdhbnQgdG8gaGF2ZSB0aGlzIGNodXJuIG9mIG1vdmluZyB0aGUgcG1sX3BhZ2Ug
dG8gdmNwdSBzdHJ1Y3R1cmUuDQo+IFdlIGNhbiBkcm9wIHRoaXMgcGF0Y2guDQo+IA0KPiA+IEkg
ZG9uJ3QgaGF2ZSBzdHJvbmcgcHJlZmVyZW5jZSBidXQgc2VlbXMgcGF0Y2ggMS8yIGFyZSBjb25u
ZWN0ZWQgKHRoZXkNCj4gPiBib3RoIG1vdmUgVk1YIHNwZWNpZmljIGNvZGUgdG8geDg2IGNvbW1v
biBmb3Igc2hhcmUpIGFuZCBjb3VsZCBiZSBvbmUuDQo+IFNhbWUgaGVyZSwgSSBjYW4gc3F1YXNo
IHRoaXMgd2l0aCBwYXRjaCAxLg0KPiANCg0KQWxsIHJpZ2h0LCB1cCB0byB5b3UgKGFuZCBTZWFu
L1Bhb2xvKSA6LSkNCg==

