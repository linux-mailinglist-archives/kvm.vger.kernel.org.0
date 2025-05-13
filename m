Return-Path: <kvm+bounces-46402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB19AB5FC4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 01:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D09E34663D2
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 23:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F86202C21;
	Tue, 13 May 2025 23:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bH2Mgd4M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2651E5B97;
	Tue, 13 May 2025 23:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747177614; cv=fail; b=mbRBG+1EIMgo0qEUyg9dZR0KrHQaie+IqUY0RYFXoUWqcFCbghwVZZXd3cgQn7oFghX1Qf7C/n6HCwN1+C5MPeSUPXRGAMl15y1UA5vqpEbtLkvkVvtIVDB16k0nGw5KaxelfUMBbHfCx4Me1tezAseLAVy5f0Hwm1kjPEClEHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747177614; c=relaxed/simple;
	bh=OxIL7IhP4qi0bKlLPmbxbtSKfPwBj6vm5VYec56E7XA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X0ocDSArTKp06z/UzAEmYhMYHHk1GF9ZLmASfWGkfwUvyiG0X4q4T1ZU8+TlDoGHqKc6DR/KSAtsaCfVg4zy65ip+Z2mKo4QO6GydipP/tmRYitpgPprMnNeiUqfWWkIB3+/kNU4dAgupI2hr8PbKxE73AfqeZOgmQ1kpuQLWYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bH2Mgd4M; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747177614; x=1778713614;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OxIL7IhP4qi0bKlLPmbxbtSKfPwBj6vm5VYec56E7XA=;
  b=bH2Mgd4MpxOWtl4f6LYspZjTjVbdgjTdt8iEcIwaoS47RuPV5pEFJaRD
   wvjyZl03He60ylfOhGHuI5NpBmGXhGRgqKpctWOmFiiKbpm2vU09tDCyc
   f/fBl9NjZeFamLL1pgw0WWaVaNbq37o3tbCEodTgyFyNJYagAZaeO/nM+
   Qaa+ktW0IAsv+JPYaCLr1EwwGDn+Zo3JEwU6AinoN7BAt9pnkroGQ9cFq
   SB8hub53+65RXukc1GoNyXpV3Z53InCfPC7Z4MxkCXJ0T6sg/HK7hgvmz
   tHUXNaD7cV1nLhplgDo+m9lEERFfwtYCi67+Hxyoi1Es2QvHnO9zEHhEO
   g==;
X-CSE-ConnectionGUID: 1UBiUyEUQfWpV5oXc9Pq7A==
X-CSE-MsgGUID: scpnVHonT32GxYRwKo7EAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49123729"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49123729"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 16:06:53 -0700
X-CSE-ConnectionGUID: Nbu7Sj9xTCGtFvdEzjNjtg==
X-CSE-MsgGUID: pM+ySOxLS16TIr3zs/hRDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="168793880"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 16:06:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 16:06:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 16:06:51 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 16:06:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3nWcVKzlssmwZVKF3FGAU5UmC7V5mFVNQG/d95XMOt7M4QkM8Tlk0Nez7h2Fwzzqi2LuUqBc55yx/z8aXLgk1El5XNI2aF/UF7TgQ20OmouE+9VIScQC49PuW4OP7Lr1PRCBI/a/akG7kRPP4tqOWsIumCkkzq1XT4T8J6U8HMR1KDozkmYHIKy6HN9NrM1gZlWTZsQvLMfwKVI2aEUF8goEnUI2+6SEvMDis/ZaKoSyii6GoWdkSF2bOOCW4tRGToW2+TL5bvEtgmCC2An/d8yEw8vj6u9r+NPpzt5cNcwqtmA/Cs8VokKhtMh5M+e73rgj3zwiF+MY1C81XRRTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxIL7IhP4qi0bKlLPmbxbtSKfPwBj6vm5VYec56E7XA=;
 b=HeK80OzkD6sTYYvUnuJZ7gaX5MJT1+LS6Rv3mffT12WqcsBQc5mM/nMutYNQhhiwuOMXKA+RPgijSM6RNmhp48OZMgCHwe3xaPBRd2J+mT41wNSj5LGiqIlmBwrnii+j52PN2Onv0JVJA+9449p6rbOfXqMCh0EBii9m8sFyXqIuJzjUc/Jk66jG9b4iaEFlRKb5E0/riBGgcdLHxJPTOxCndLrPbkYuugp3suZsVUG6I3xjuTqKHqeIZ6B3A4IENJIHZQ5jzqecu23QrBIXNkbz32mouyGE3/AxlA2VuPZnOEpqVU666wAFD4ihaP+6ePOire199dWcZIblkycY3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB8398.namprd11.prod.outlook.com (2603:10b6:208:487::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 23:06:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 23:06:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Thread-Topic: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Thread-Index: AQHbtMZXtCmug//st0iewCdVRT7MSrPRTdqA
Date: Tue, 13 May 2025 23:06:48 +0000
Message-ID: <b5af66343b3f5d4083ee875017c7449dea922006.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030744.435-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030744.435-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB8398:EE_
x-ms-office365-filtering-correlation-id: 3f7e5589-ccbe-4a38-6603-08dd9272d70c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OFpaY29ZNkxDdytGUHBPMUNlQ29uV3NyS2VwSFlqSmdod2dCWWZZK1l6VEhN?=
 =?utf-8?B?UDk4WHQ4YWh1UUZwSDQ4Q2dIWGNObDdZTXkxQnlOQWFnREltNGM1MmloTjFB?=
 =?utf-8?B?THR2V1RjUi91b05NV2t0T1VnTitpY2ZGNlJ4UFhEUVRWcnk2R3MvVWNQKzNu?=
 =?utf-8?B?WGZXL0ZZYW9sS2ZQczF3bkhyVXFxdnhvQzB0dVA3WTlnblNYeURUeGQzWnFS?=
 =?utf-8?B?dnloTEN6d3ZiQVFEckNsQlQrT1B2K21haUpaSkxIN216R0c4dzZzQjhFdzVC?=
 =?utf-8?B?MFRWNE96UWJyUzlwSUk5R0pkdGRtTWNFT2lMdndpUHh0VDFZK1hCL0VvTGhS?=
 =?utf-8?B?bVZ6Y2JXNTllaktsOXE5M1B2bncwalgxL1lPL205NnFOQUIyMFQ0VjhiazV3?=
 =?utf-8?B?ZXBCWkNQR1lPaTNrM29xVEp4eDNHWmlIWjJQVG9vdTBWM2FWZnFETENIZ0dw?=
 =?utf-8?B?KzZhTGF3Y0NzYm51RFVLbjBMS1IzRzhEd05SbE9Femg2QVJWN3lkTW5WVGNF?=
 =?utf-8?B?d1AxNmNDSktrQUJybWF6akNPdjFtS1dLQWZLK2pGUldkYXhoMXBxZi8wMHJB?=
 =?utf-8?B?ajdibitRUFZHYUhnQVF4N1pid1V1MzJFNlBycENVRUorSmFMbXVLSWpGOXdJ?=
 =?utf-8?B?TlNPZElxOVI0THVlVnc4bnRUNTNXL1hvTFI5RXptd2MxVExnUVl5eEtWRnJo?=
 =?utf-8?B?QkxtMU5VYS9KSXR4eUNWUzFTbllpRHRMNmcwOC92Y0NWNjRZaDNwdzN1NXpN?=
 =?utf-8?B?S0NkT0VZTFNwUy9YQkNuTWFBNUgyZnZXL2w0VjVpMWcvTlN6cDFYNWVaRzIx?=
 =?utf-8?B?RXB3VzFZZ0pQNXVBRyt5TGpaRGJNUGhkOUV5dEMyRldHeGozNEdMakNCbk9m?=
 =?utf-8?B?Wk1Pb3V5SkRNZmhNbTJONjJqRHRKcTVsVzNIT2tPZDBURnpjS1VJejl1SWFU?=
 =?utf-8?B?c0lFOXdGNjErYmozWkhVc2lNbnNkcEU5STRxdHVsYlErMCtHMjEvTHdLNkhp?=
 =?utf-8?B?c1ZXNk5JRTFxWGJvN1FZWWZJWlI3d1RJbHdKcXVLVE5WSEFQeEZ0MHgxZ0Na?=
 =?utf-8?B?UldMQ3FKREdyMHdnZEtoaGtUNldYV0ZiZE9qWkg4YjZkenlvazlIdm1BbjFE?=
 =?utf-8?B?K2hMTTdMRWlIR1VNdHBlSWRLU25yMHQzQjdOY3oyL2IrRkZGL3MxR2I2OWxO?=
 =?utf-8?B?YnBqYXJzd2NFdit4amZYdUtodUlXU09QeEJwaXFteGF3S1hNaWdTWThaYzhG?=
 =?utf-8?B?dWEwQk12VUdzTlZIaDg0ald4TnBiZEkwMjFUVTRMRmF3WVRhUFNWM0RhSnJx?=
 =?utf-8?B?Y0RVME9BeGdLK0FVS2kxSDFiUFlXcDA5SnpDTEtmRW8xUTFzUjhpK1BBMWpH?=
 =?utf-8?B?NmZ3TFUvSmdwUGFNbkJQRURoWWhWMGgwRWdwR3lvN21jUUxpSWU2R0NOVlBp?=
 =?utf-8?B?L3NsN2tBZklnWjBndE11UWNQUEtZbG5JMHZjWk11UUh1U01NR29iZ2Z6NGQ1?=
 =?utf-8?B?U1VPaUlKUGtEYldWYytPM3ZFVm50aWRndkpZODFPNzE0NkNIcVpqaTl4cmIz?=
 =?utf-8?B?OWpqSS9Dc1FhL3ZCb09DWUd3Q1JRS0wrUndBUVRpY3YxYjhSU2Mvd0lNcWFy?=
 =?utf-8?B?cXhaR25OZmFPdkZadWY0d1VEWXZ0bTRHSUwwWHE4TnZ2WS9ZRERoUmpueTdz?=
 =?utf-8?B?emRUK3I1WnRWVkEydzEybndEaU8zMkRIT2YzL2d4NU9yQUlRNjNDL25iWnpa?=
 =?utf-8?B?V1NXdGtxd0FsY3pvQlM2emhqNGFvTEkzcy9oK29vL1RwZVBBKzBlcXdXVVAw?=
 =?utf-8?B?Vk9meUNCaXB0QTYzdDV2YXdsMGxVd2VzNHcxRzRDc1RVdlJleTIwS1NvN0pY?=
 =?utf-8?B?TFBNdlhzeGQvK3NXM2hrbUtNMk9qSzVmSkNzZExFb3pvWXBpVW5VQ2REcTFX?=
 =?utf-8?B?MWlQUnRyVkEzTnJXY29WZDlGU3hlUlRiTkY5WWxTWk02TFcwcXJOaU9EVzht?=
 =?utf-8?B?enBCOVhyaUd3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2NlZ0tzZkxRRURWK1pPODNPUnJVUGxxMVBUOXVFZHp6Wk9sN3hRTlV0anNX?=
 =?utf-8?B?SGkxSW5xRldyaUlvckdRelBYVzBkbE9KVzZkZ0UvTzJueEZ6RGRQemxJck10?=
 =?utf-8?B?LzlkbjNhOHd2dlQvOVJtVEJ4SldzelBCdjhBWXkzQnpwVmduK005cUx3anNQ?=
 =?utf-8?B?YVRaTTZSeFhJTFdXZFY5czNsS2dqbGRXc1hZYnA0ZWhoMFYxMEZhbTlKMHlr?=
 =?utf-8?B?bVB5UnVHUXJ3a0hZaUEzSzF1OHA5VzlQcTBIaytkUWc1TFNoOGM5ZnVwaWw5?=
 =?utf-8?B?R0Z1TjJuQWN4QnN5VDQ1ZlRVb3hscjhGQ2NpR3YwUS9WNmFYM1EwK1ZxT0hy?=
 =?utf-8?B?a2RGbjJFTUEwV1dCM25xQncxeDFReHpkK3BCT1dwTWgyZ01BMWkxK2RJUlZ6?=
 =?utf-8?B?azVKVDc3ZVNSajd6eVNUSHJMYW9PTStndWliaWU0dlJuZTNzVElZTnVScEhM?=
 =?utf-8?B?WVVpVlJSOGZ0VFNUUUdzTCtVU2k5RXNqM3RiTTBHWWJMQkYwdW9FbmR0aHZp?=
 =?utf-8?B?UHlhVkRlRzFmeVRER2YyeE1CUHhicXp0MlpVRDVUbktoUXdXYk81Nk5IVDJk?=
 =?utf-8?B?S0c3cWZKcWpBZk91UnplaFRGbjZrTHFpaGRJV0tvd0RRWnpPR3RLbHpwcVln?=
 =?utf-8?B?WDVISktUVkpzOFE5a095UXZ3OXR5NVNLUG95bVNkTk5hRGwwaWd6VUM5UTgz?=
 =?utf-8?B?ajBvRTNHSjd2aE5XbSt5NXJENmlta3pLemdvdGRodkFiZFdQN2N4RzI5UVUz?=
 =?utf-8?B?ME45RDE0dGVXV2dGandENGV3b1NxUkxnVmEyT0ZwTzFtMnBOMnNKVVpEcEo5?=
 =?utf-8?B?MFlETUUxY2dlWDRnSGt5RU1RTkk5RG92RENwU3dTcVVISDg1cXQvUHVKd2Jr?=
 =?utf-8?B?b1EwNndyNjkrcEJ6S2ZuT2loWkwwcFdwTU1QNkVFa0F3eTU1M3FEaGZFdTk2?=
 =?utf-8?B?TjQrU0E0OGNGZ205ZXJsOWYzVnlMdlpBeGZYc0VaSXNTUGlVd2RNenRNbUZY?=
 =?utf-8?B?bVpVWTJ2ZkpMZmdSb2VhMWVubW45NFRXRjZtdTFObjRYMDhkVUl6SktUUHFR?=
 =?utf-8?B?WmkxT2xZcW5UVCt2bG0vU0ZZeWtteFFxeEE3Y3o1dnlrNFVteldGM0w3clha?=
 =?utf-8?B?VndtQVVIaGhmQzNtZSt2cHZES214Rkx4T0VjRU5nc2FhQ3cvWldBNk5CSW4z?=
 =?utf-8?B?QUlENlMzaXU4ZG9HbHpyMTFyeEVoaWpoSVcxN0wxcmlMbkJ2WDIvUTlmR3FF?=
 =?utf-8?B?c1dsUUV5TlpiUkd1RjVTT3NScVpRRm9ISWQyM3FBZmZpdTRzMndmMVRjZFJE?=
 =?utf-8?B?VENmdzBWUWhzTERmMGFMbmhaRGFXOTJaTExVM0hHQ3pvVzBGRkw3QlozdzFC?=
 =?utf-8?B?RGE5SGN3elM3a1MxcmtUK2RqWG9CVUlQTVpONHprRGZjOVRxK0gvODd3b0Np?=
 =?utf-8?B?VzJlK3FvVzFTcTYvVG44S3MwVm5jMVpVanIyNEdXWkUrc3MwU0tJWStuM2Zi?=
 =?utf-8?B?U09VRWt6UXJhL2ZGYnphM1docXI5OCtBVkRXSnNSWkRKZUcybXczblFQM3dP?=
 =?utf-8?B?NDlXdGo5SmkvQlROVS9FUlo5b1FXRUxlRjB4cm5XTzVqVWlRWG82YVg5dkFJ?=
 =?utf-8?B?OFg2ZHdKWnQzYjdXNmNDRjFSQ3pOK2NNYVUxU3g0N1IwN013V3huSkJXWWwx?=
 =?utf-8?B?c3FqWGlKNk43SzFZMUluMkNEVnFQYTJWVkNKemd3QmxsaHpsTHpxZ3YyOFlB?=
 =?utf-8?B?b1Y5K0dGa2d5VmJYOHZQR2t2ZE5VdE9LYVY0b2dja3ZDQlRvL0Z6dVVseXdM?=
 =?utf-8?B?L3pLa3ptV2FJTjRuLzYyTDU2WGRDQlZpSm1sWGJaRThGTVZTWUJINDBVeWRD?=
 =?utf-8?B?d2xSN1RRVU9VRzhaUVVFS0ZMYk53SEVTcVZaQm54cVZmSGNCOGNuZXA2NXNp?=
 =?utf-8?B?Znl5QXhOWGQxMTRjYTVtREovcE9EVnFwa0tVTitIYzYwL2pETnE4ZjVQNnNx?=
 =?utf-8?B?d0M0VTdmaTJldytEMXI4d2l4aVlGMGlpYzhSZE5YWVhJNXdWRTNRWEtCS0I5?=
 =?utf-8?B?c3BQeGNkeTdoMVpwWmU1WWFJaHBoUUFWWkhnUVRqcUtJbWszT01NbTVjbzNa?=
 =?utf-8?B?VWRGRU5keWVKS1VIa2M4Y2ZYNnREUFNUVUZxeWdjSTMrMEhkV0RRRkxBWCtn?=
 =?utf-8?Q?BLvmbvq93DTWw3KBCjL0wPM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C421BEA5EDF054689081208F31BFC4B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7e5589-ccbe-4a38-6603-08dd9272d70c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 23:06:48.7805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lN7nruybIqFXxolaphFVCuYyUnz9vAaZ0WnxvcHUAa3Wz5piHlE9Y3N+rpezUBcJa0pk2R9CbIbEjGa5HxzfPM6VIxfgtJM/pzto6xoOyAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8398
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gK3N0
YXRpYyBpbnQgc3BsaXRfZXh0ZXJuYWxfc3B0KHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLCB1
NjQgb2xkX3NwdGUsDQo+ICsJCQnCoMKgwqDCoMKgIHU2NCBuZXdfc3B0ZSwgaW50IGxldmVsKQ0K
PiArew0KPiArCXZvaWQgKmV4dGVybmFsX3NwdCA9IGdldF9leHRlcm5hbF9zcHQoZ2ZuLCBuZXdf
c3B0ZSwgbGV2ZWwpOw0KPiArCWludCByZXQ7DQo+ICsNCj4gKwlLVk1fQlVHX09OKCFleHRlcm5h
bF9zcHQsIGt2bSk7DQo+ICsNCj4gKwlyZXQgPSBzdGF0aWNfY2FsbChrdm1feDg2X3NwbGl0X2V4
dGVybmFsX3NwdCkoa3ZtLCBnZm4sIGxldmVsLCBleHRlcm5hbF9zcHQpOw0KPiArCUtWTV9CVUdf
T04ocmV0LCBrdm0pOw0KDQpTaG91bGRuJ3QgdGhpcyBCVUdfT04gYmUgaGFuZGxlZCBpbiB0aGUg
c3BsaXRfZXh0ZXJuYWxfc3B0IGltcGxlbWVudGF0aW9uPyBJDQpkb24ndCB0aGluayB3ZSBuZWVk
IGFub3RoZXIgb25lLg0KDQo+ICsNCj4gKwlyZXR1cm4gcmV0Ow0KPiArfQ0KPiDCoC8qKg0KPiDC
oCAqIGhhbmRsZV9yZW1vdmVkX3B0KCkgLSBoYW5kbGUgYSBwYWdlIHRhYmxlIHJlbW92ZWQgZnJv
bSB0aGUgVERQIHN0cnVjdHVyZQ0KPiDCoCAqDQo+IEBAIC03NjQsMTMgKzc3OCwxMyBAQCBzdGF0
aWMgdTY0IHRkcF9tbXVfc2V0X3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBpbnQgYXNfaWQsIHRkcF9w
dGVwX3Qgc3B0ZXAsDQo+IMKgDQo+IMKgCWhhbmRsZV9jaGFuZ2VkX3NwdGUoa3ZtLCBhc19pZCwg
Z2ZuLCBvbGRfc3B0ZSwgbmV3X3NwdGUsIGxldmVsLCBmYWxzZSk7DQo+IMKgDQo+IC0JLyoNCj4g
LQkgKiBVc2VycyB0aGF0IGRvIG5vbi1hdG9taWMgc2V0dGluZyBvZiBQVEVzIGRvbid0IG9wZXJh
dGUgb24gbWlycm9yDQo+IC0JICogcm9vdHMsIHNvIGRvbid0IGhhbmRsZSBpdCBhbmQgYnVnIHRo
ZSBWTSBpZiBpdCdzIHNlZW4uDQo+IC0JICovDQo+IMKgCWlmIChpc19taXJyb3Jfc3B0ZXAoc3B0
ZXApKSB7DQo+IC0JCUtWTV9CVUdfT04oaXNfc2hhZG93X3ByZXNlbnRfcHRlKG5ld19zcHRlKSwg
a3ZtKTsNCj4gLQkJcmVtb3ZlX2V4dGVybmFsX3NwdGUoa3ZtLCBnZm4sIG9sZF9zcHRlLCBsZXZl
bCk7DQo+ICsJCWlmICghaXNfc2hhZG93X3ByZXNlbnRfcHRlKG5ld19zcHRlKSkNCj4gKwkJCXJl
bW92ZV9leHRlcm5hbF9zcHRlKGt2bSwgZ2ZuLCBvbGRfc3B0ZSwgbGV2ZWwpOw0KPiArCQllbHNl
IGlmIChpc19sYXN0X3NwdGUob2xkX3NwdGUsIGxldmVsKSAmJiAhaXNfbGFzdF9zcHRlKG5ld19z
cHRlLCBsZXZlbCkpDQo+ICsJCQlzcGxpdF9leHRlcm5hbF9zcHQoa3ZtLCBnZm4sIG9sZF9zcHRl
LCBuZXdfc3B0ZSwgbGV2ZWwpOw0KPiArCQllbHNlDQo+ICsJCQlLVk1fQlVHX09OKDEsIGt2bSk7
DQoNCkl0IG1pZ2h0IGJlIHdvcnRoIGEgY29tbWVudCB3aGF0IHRoaXMgaXMgbG9va2luZyBmb3Ig
YXQgdGhpcyBwb2ludC4gSSB0aGluayBpdCdzDQp0aGF0IGV4dGVybmFsIEVQVCBvbmx5IHN1cHBv
cnQgY2VydGFpbiBvcGVyYXRpb25zLCBzbyBidWcgaWYgYW55IHVuc3VwcG9ydGVkDQpvcGVyYXRp
b25zIGFyZSBzZWVuLg0KDQo+IMKgCX0NCj4gwqANCj4gwqAJcmV0dXJuIG9sZF9zcHRlOw0KDQo=

