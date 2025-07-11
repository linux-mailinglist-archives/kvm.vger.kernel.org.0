Return-Path: <kvm+bounces-52215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71026B02758
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 01:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D9F91C843B7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 720AB2222AA;
	Fri, 11 Jul 2025 23:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tb4exxhZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255581F5852;
	Fri, 11 Jul 2025 23:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275096; cv=fail; b=WqmIe11Y7YJGugQe+60fjoQiewhZpiJhlVLR3Qly6XVRQT1Q2ndsceRb4n+Fux8SX192ZA0toyym09f77nWINPv8Vvd9Nq9qSUD+Gv4v+FUL1B4/GeJuzsFAQKUbm6NiK2eodE/FEn2BWEN4VQme0xnQBNUmdVVCdUGxjBKv5PA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275096; c=relaxed/simple;
	bh=dFa2g01qf31JQvzrdgAKllJZeaiwv8UXXuAhTqamf+U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ecC04Y/lDtQsWq5EHLqmHYXq0SqxdysFt6c2nv/KoTcLtjRlyi6xBqWH/qNbndpvE+V+LLx1vLhFWkBOGJPIEM5ZT7wli0q9tQBi1lIznZ8fEhntVBH63upgixnbQzT8JkUgxIPsTLdMFWLshK10x5Gm5aW9IR6QPjwmEYaTlgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tb4exxhZ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752275095; x=1783811095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dFa2g01qf31JQvzrdgAKllJZeaiwv8UXXuAhTqamf+U=;
  b=Tb4exxhZAILJH93o8v6cq2Tu/o6TuOxhQAQmPTME3O3AFRXvyeeebjOL
   5GFHybSDg1u8wmi9sMvjNZT1q64rin1Nw9P0uLz80z9aC15zW4EzQuL2T
   UFfDdEDjj70Lk2HgziGMClwKOQL5m427N5NHrIVUqCQIebN03X5+j1p0/
   qUfNI/0YqjLDaH2hGqKfMjRdrIVSMuympPF8abfaYp4inoEG8Qz/n7mv2
   SsFPLZGkSeQnm3uHlP3N3e6zE9LjeOdzNyEvTr3729IgUgzRrpnUSAHNE
   g4Q3mnmhQoH1fgPV7I1RQoMd3GllssPrXjSSN7dcTN9lTrAchLs3GRTKg
   w==;
X-CSE-ConnectionGUID: S8oP55JVRXCS1VHNpmEokw==
X-CSE-MsgGUID: XEDlyWlxRmSECDcSGOPnGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54734222"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="54734222"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:04:54 -0700
X-CSE-ConnectionGUID: DgTbv6vQTaSbyLxu2/ueNg==
X-CSE-MsgGUID: pFoJpFVrRsSz0iH86ithkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="156810106"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:04:54 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 16:04:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 16:04:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.55)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 16:04:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S56qoSRhgxsGJFiM8yI5GuXpHJjPP/PRbQgZDc94NpU1AjAi+irezzezUCX8RnM0Ljp829hCQAd1+XWgVwCvMlorlokqEYaSDYcztJLQ4bygHS72f4ArXLjwy0UgDlIkZwlm7Ll/rssfywwFtc6oAtTNXGofrnqR/L/gjGKPesIT2+UI+jcQPnbaPjXfkH2BhjmkbakMZWCLTz0Dkk3HbUjK58nbdiZsCXDYtQXrCS+56tAzI9hQWsKUFQUwzCFr5OUkknO6USXoOp01Jxffnf9nTEStxZ7B4BtJGC4bB5SZ2VNeWdQMlaBl5YzH48Q4eHCxQev4vqLvr+MivYlMPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFa2g01qf31JQvzrdgAKllJZeaiwv8UXXuAhTqamf+U=;
 b=w/A99of88pt1zXjEEiRANqKcFZM0lGnjuv+ncaYL3P+l1n/BXxFrOASmhsVsOgBMtxtt9q26UG3IYNp2o6lQvg6RvalHuuH02tkctH9u0pSs2oPZVcCoucb2dmIcymiFULHhbXwpdYvT5vTPFJaISpxTH5yC5kmteRdYBnIDUBTywTCVwifUU5rZx2QMPCqa/CmJ4HUhjou8wXsqhKyP/Lwf5Z+L8f9v/wrjRz8aFc/Rcv7zWsi/jfy3CvvLvi5t8ejeNeI4h59Hcj+XO7cHa27yBTXpaRRlLm+WNeR9moUVNOM4dKHWQAHaOoxocCvzvhcQcfSmIaGtxbuxouwG2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW5PR11MB5859.namprd11.prod.outlook.com (2603:10b6:303:19e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Fri, 11 Jul
 2025 23:04:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 23:04:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Thread-Topic: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Thread-Index: AQHb2raNt52nCBW150es8dK7MAv5xrQUisKAgAEmNgCAFxzJAIAARa4AgAAJ4YCAAAr4gIAAiT8AgAAGjYCAAALGgA==
Date: Fri, 11 Jul 2025 23:04:23 +0000
Message-ID: <0bd315344080e71ace8f517f8f45e41c1a7badf0.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <175088949072.720373.4112758062004721516.b4-ty@google.com>
	 <aF1uNonhK1rQ8ViZ@google.com>
	 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
	 <aHEMBuVieGioMVaT@google.com>
	 <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
	 <aHEdg0jQp7xkOJp5@google.com>
	 <08cef2fec1426330d32ada6b2de662d8837f2fb1.camel@intel.com>
	 <aHGWI5_BsFg1JJCx@google.com>
In-Reply-To: <aHGWI5_BsFg1JJCx@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW5PR11MB5859:EE_
x-ms-office365-filtering-correlation-id: e0d3b20a-c07f-435e-7dd6-08ddc0cf46fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NXVLSHZ3c0t4bnBXL1pUeVVua0IzaXRURiswckozQU1MTVRDM2s1VXdFZXJo?=
 =?utf-8?B?Z1AxYzJGaE9DaFhsQW96bzJSd1ZTWERaQlJuZ1EzUmYxc0NKeE5CNmNrOEFV?=
 =?utf-8?B?dnZ5bk92bm1pSHFWUHVmTWhvVFBjN3pPc25uZ2dEanJ4bmE1cmx6cUVLZ2lw?=
 =?utf-8?B?bzg0QXROVTBLM0ZOTmtBcUVXbTFscnozY3haOFJtdG5ILzJBV05WNERZQ3Rn?=
 =?utf-8?B?b2RjaWx2Y3Q0NlhZc1N4VllQd3ZqY1F5SEtmSDFuU05ycmxwSFczNXFZcVov?=
 =?utf-8?B?WWFyL2VUK0w4VVNHNmN1Nks4VWcrRHFXWmRHVTBHcjlBNGFBU1VHMHpHUXBD?=
 =?utf-8?B?RGN2OUFIUm9OMGwvb2xIRkRCTFFxbUJac1V5a0gzZDIvZ0t3V2V1eWpLWjJN?=
 =?utf-8?B?U2x0QkFuczFicUxaZDRIMzNIT2k5TDlyTTNlYlZOKzVyeTRWT3hTa1pLdHVY?=
 =?utf-8?B?Uk5JcHNZb21BVkdLZ1dTaFo4WDh6clE0c1pZQ01zM08yQWZUc3ZjYmtOUnhk?=
 =?utf-8?B?eUN0V0QwQ2dwZDd2UTBMeit6VnFrNHJOQnRFcER3Vks1NUFNaVF6MzhXa0F1?=
 =?utf-8?B?YjN3YjRMMlFjNXBDemRhNUp3Y0VKQlJPUWliS0UyZUtpdTJsNFg2SjlVWkFS?=
 =?utf-8?B?OS9nVXliUFBmZXR3SUJKdjU2bVdzM2ZVb2lRM25yMzAxTDdsVEVaNXc1enRK?=
 =?utf-8?B?Ri8xRWlyUW9xdzAzeGREckRBYi9hbk5lVnlVSlBycEtMTkEyVGxlMENmejYy?=
 =?utf-8?B?VXZSUFhmNVVoSDJIaWVqeUpSdFZPTUxlRnZsc2IwYmlSSlBObnJvamZKNDQy?=
 =?utf-8?B?bTNIT2hvbVBXcTFtd2FpeHM0bWF2cHNnU01HMUtMZzNXWjNnOXBFMWpaVlNV?=
 =?utf-8?B?cGtWSE5kS2VwbnlGQzNlOVBiTm9JMi9FUnpPemRqa2gvZHg3TmxralRtUVUz?=
 =?utf-8?B?R2RqS3hTM3M3MmJzakZUQUJySnhhZWFlR2VvQmRkM3BZbXJ5bUNWd1F2VmxC?=
 =?utf-8?B?c1l1elpDSUgySXA3VWhhMU5hUk8xcjBydmR5anhLMXpCbTJMdGhQWlBaYVd2?=
 =?utf-8?B?QllvOXVtcnpkNUczTUROeVhrYm1RNUY4L2twY3F6L1BEeFB0REtMUUc0ajZ6?=
 =?utf-8?B?YndOTGlkK0ZjU0JiMWQxbFAwMzFGelNRQzZUUTJnbS9qMFY5YzVwYVdKZ3R2?=
 =?utf-8?B?NlZsNzAvRjdYbUt6QytSU0p0dG0rL0FkUmQ3ZW1OcFlsblUwdlBlRTNlVC80?=
 =?utf-8?B?T2c3QklVWkdpbVpTWFlDakhGTEVQeTlaUEswSkpmTEZEK2FDaGgram96eDY2?=
 =?utf-8?B?YkVsR3UvdXVmdTVwZUpNZDdndGUvUWVBMWlkQjhZbnVpN2xrUDc2cmJ2V2d1?=
 =?utf-8?B?MDVDekl4bW0rNUZHRkFLVDA1WEdhNjRiMnlrRzhXTGVZdEZWS05DQ29SRWMr?=
 =?utf-8?B?VThjMExJWko1aitjbW5GTnpLUERTeGdoczk1WFdZWGdkbzZna1JJUWlHcEpI?=
 =?utf-8?B?WXhyczBCVDl2WXc1Nllic08zOGVrV1JNamVlM3FjOUE5WSs4cVpWekVsSGJV?=
 =?utf-8?B?MStybnlBWXJKQkNMQVFUTTRJN05IK1VPMmhZQjIwOEVvU0ZSWExaZUF2emVY?=
 =?utf-8?B?Q2MrUlhOWTcwRDJtbFJnL3BtejlSRFpXSTdURGhkVmFQenlHUktySkRqS0pJ?=
 =?utf-8?B?dUVick5VbWljTjVZQ3F4bTA2cXRTeThPdjF1UFZLeHQ3aXl4YXRVeHJqc3J2?=
 =?utf-8?B?TENVRXZFZCtmM0Z6YWt5am0vem5abDBzaGRJZUdqc2lJTjU3MXhkT2k4bUt0?=
 =?utf-8?B?WHp1akFZbXhUSmpjcUpZS3pReitzRjBxajFmMm82RFJTK1dlbzJnb3hhcUVK?=
 =?utf-8?B?M3Y2QXNCWlJNb24vV0M0S0c5MURFK3AyNWczWm9xQTF4cE0rNEFqSHlLelNJ?=
 =?utf-8?B?TldBOGlyVjhuV3ZnTHJKN3M4UlNFSHlFNFdPMlBZd1pMUVpYNlFGSDBtc2M0?=
 =?utf-8?B?WHlQejUxYnNRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnA2MjFiNzR2aEltSjJyUEFTVFRDQUNtcmNRaVdrcmF0ZzkyVjJlbzNUek8x?=
 =?utf-8?B?QWpUejZKSU5GUnR3VENjeGxrb1ErbVlMVUdUd3QzeGttUnhBRjNVTCtMZjJG?=
 =?utf-8?B?LysyaWF6QzhYTlZzVzVuRXNNaU9vbEZEcms3bTR4eCtrMDBzSzJFM0lqTnJI?=
 =?utf-8?B?TXkzTGg4byt1N2NqOEFveWRraGVtdDRxWjdOVURYbFkrektnM0dXWlpXaytG?=
 =?utf-8?B?SDBqd2Z1V3RITG9qem9lT255TEJKVlZJcll3VzBFZVFyVVJpUFJnNkxiUEc1?=
 =?utf-8?B?UHFmWXRIR2luQm1rSWRORU5pUzYxMXA3a0l5cnlnNXRpVnVtZUhDUGxPZ3Ja?=
 =?utf-8?B?clU3Y1NXNlE5QjJEN0E1QkpBb3RxVTRPSTIvNjJWK2c5bEh3TERXS1Bxb3Mx?=
 =?utf-8?B?YmZLdkpmVDJNY053Yjk1Z0wwcllsZmVaRHFRbTU3TGRhOFpnbWRoWHduZzVY?=
 =?utf-8?B?b3NqM1E0c3BUS3ZrSHNBWWNENGRLUWNHL2JZV1VYTDVZZTkzQ2ZFSkJ4cFRz?=
 =?utf-8?B?c2lUcW5Qbm84MFZrdlBuUFl0ZGpRaVB2T3VuZTU2QmpKTkVYKzFjNU1xSzRj?=
 =?utf-8?B?QndGV3F6aFRoYzgwSEdNYkl0cEpvQ2g2WE5MN1RwRy93eVV0OHZ1d3o0SzFO?=
 =?utf-8?B?RkFUZENoOTVrZ3RPT2E0YklzNXNud3NGNkNpQ2ZPaEgyRHBUY1lqTDhkb05k?=
 =?utf-8?B?N3FWT2xKVWZxR0tuZzBQVVRNWVkwN2NzcmRmOGYxTDFSMTBJTENDTjNHcSsv?=
 =?utf-8?B?QmhRWldmcjZybkc3VmV2YzhTeVBnMzBja1BLVExURTJRWnFWNkd4WUxKNGtY?=
 =?utf-8?B?SnBDRkM3NWU0cW1Eb3VSV3A3dVpWdlNCZUFZOWpyNWdLSEhGbDArSVRuMElW?=
 =?utf-8?B?OEhkVmp3WGN3L1hDRUZDeFBLcVhidnpRV09uRUhnY1lhK1dIRzNSNTRWNEU3?=
 =?utf-8?B?YzBGOEljRmZyNWdsQzdmaUtSSlljUmpOOFFIZXZzeGlEQVdSVHI5bDBCTUVh?=
 =?utf-8?B?M01Oa3d0Nm1mOHNHZkFUdHhPT1RsVGs5WHgyR2NYMkhiandBMnVpK0VwcFhT?=
 =?utf-8?B?YWQzOHd0QVdYVEJ5T0didDRweUVmWlo2eHE5dC8vQjJxU2JDcTM0UEpXT1dm?=
 =?utf-8?B?ZUpXeXE5c2dRd0JwQ2FjNk9kdG4zMjM2VXR4QVdqcTlEbSs1TGNOYXdWOE4y?=
 =?utf-8?B?eHowalIrcnBnTUcxK1VpTzJpclBKd0M3T0w4WjJUajRZZjdmTkw4RkpKbCtR?=
 =?utf-8?B?MTI2eWs1TjE5Zm5mdzFvbTRqelA5L0JBSXJUR0s2aUF2TDcxQVJNSEhWUWU1?=
 =?utf-8?B?TUp5UXQrR09XdlVub1ZWWmtDZ2kzaUc1YVFEWjNxNzA4MStVTDA0dzZRTC8w?=
 =?utf-8?B?VS9nUkhFZFo0RDFoKzZ3WUIvNnF5UHhXZG9WOVR1cU05ZHlNVG5Sc3Y3cGQ3?=
 =?utf-8?B?VTFoRkxKODFjQ2FMcWNaY2RoemV5cDlsbXVwdzRCKzNFdTh2RDlpVEZwelEy?=
 =?utf-8?B?TE02U0RDMlJSK3ZpbEFYWDdNaHVzdTF3c0NWeXdaSjNzUEVhREFZNllua1Ba?=
 =?utf-8?B?eWpwTk0wRytUdUlCOHE3c1FrWCszMGlDUzNNMWNZdDFlU0xCZ3pCRzdPQkdr?=
 =?utf-8?B?bytOSDh3Q3JkLzBVZ0tBbTRGSENzdGtvQ1llRWlnakVaRHBoNkRMTHBHUWxr?=
 =?utf-8?B?K0t4SHdTNUhOaXh0R3dHMlRsRnhGamNTaUpMSFAwVmlhdDdaOUMxb0gwcXhH?=
 =?utf-8?B?VW4yQVNLdXpJeXVHc2cvbVQ3Z043bWJ6SDZKT1BOUUhCaEwxcDliSk9TRGFK?=
 =?utf-8?B?VVNoS2hmblRkdXp5UkdQWXEvd3FGdWd2dkNZY3Fhc0NNQmQ2dnMvTnp0SXhQ?=
 =?utf-8?B?RzNtbTFlTWVxQ2I2MGVHd3Z0Z0hpZnFCVHpHOE5hemE0ajErV1R1cDBQNHor?=
 =?utf-8?B?cDMvd1FQblpXN2VnYVBaRWp4QUhVVm9tSmZGUWpiK3RTT2ZETnhBcXFCMnA4?=
 =?utf-8?B?c3pSL2NzcWFGL2pwOUlTSFBQVkw2UlVobDVVcUEwMFRwc0p1TlpURkpkWndX?=
 =?utf-8?B?aE53eWdqd3NoQ1N4MVgyZ3NOK01xblpYQTZkSWJrclNXNS9CZUR5ampLK1BP?=
 =?utf-8?B?aUcwT2UyNTdodmZESUlZeENSazF0a3BvRUg0YnY5dkl2ZVNiN2FvU25Zckpu?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E01BF6909D07A6408EC831B08088057A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d3b20a-c07f-435e-7dd6-08ddc0cf46fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 23:04:23.7927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oc7/msBED8+LC3QeK3EjRW/B2NpT848j9ZqnLfwe2ev7MtncB+ltdPuHNXBUqrYU5FMoKrMNAQF+HjV/fDcW2t4eXrlY+G6O0ZfgkLE8kTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5859
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDE1OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEhvdyBkbyB5b3UgZ3V5cyBzZWUgaXQgYXMgd2FzdGVmdWw/IFRoZSBoaWdoZXN0
IGNhcCBpcyBjdXJyZW50bHkgMjQyLiBGb3IgMzINCj4gPiBiaXQNCj4gPiBLVk0gdGhhdCBsZWF2
ZXMgMjE0NzQ4MzQwNSBjYXBzLiBJZiB3ZSBjcmVhdGUgYW4gaW50ZXJmYWNlIHdlIGdyb3cgc29t
ZSBjb2RlDQo+ID4gYW5kDQo+ID4gZG9jcywgYW5kIGdldCA2NCBhZGRpdGlvbmFsIG9uZXMgZm9y
IFREWCBvbmx5Lg0KPiANCj4gSXQgYmxlZWRzIFREWCBkZXRhaWxzIGludG8gYXJjaCBuZXV0cmFs
IGNvZGUuDQoNClRoZXJlIGFyZSB0b25zIG9mIGFyY2ggc3BlY2lmaWMgY2Fwcy4gQ2FuIHlvdSBo
ZWxwIG1lIHVuZGVyc3RhbmQgdGhpcyBwb2ludCBhDQpsaXR0bGUgbW9yZT8gSXMgVERYIHNwZWNp
YWwgY29tcGFyZWQgdG8gdGhlIG90aGVyIGFyY2ggc3BlY2lmaWMgb25lcz8NCg0KPiANCj4gPiBU
aGUgbGVzcyBpbnRlcmZhY2VzIHRoZSBiZXR0ZXIgSSBzYXksIHNvIEtWTV9DQVBfVERYX1RFUk1J
TkFURV9WTSBzZWVtcw0KPiA+IGJldHRlci4NCj4gDQo+IEJ1dCB3ZSBhbHJlYWR5IGhhdmUgS1ZN
X1REWF9DQVBBQklMSVRJRVMuwqAgVGhpcyBpc24ndCByZWFsbHkgYSBuZXcgaW50ZXJmYWNlLA0K
PiBpdCdzDQo+IGEgbmV3IGZpZWxkIGluIGEgcHJlLWV4aXN0aW5nIGludGVyZmFjZS4NCg0KSSBn
dWVzcy4gSXQncyBuZXcgcGxhY2UgdG8gY2hlY2sgZm9yIHRoZSBzYW1lIHR5cGUgb2YgaW5mb3Jt
YXRpb24gdGhhdCBjYXBzDQpjdXJyZW50bHkgcHJvdmlkZXMuIE5vdCBhIGJpZyBkZWFsIGVpdGhl
ciB3YXkgdG8gbWUgdGhvdWdoLg0KDQo+IA0KPiA+IFhpYW95YW8sIGlzIHRoaXMgc29tZXRoaW5n
IFFFTVUgbmVlZHM/IE9yIG1vcmUgb2YgYSBjb21wbGV0ZW5lc3Mga2luZCBvZg0KPiA+IHRoaW5n
Pw0KPiANCj4gUmVxdWlyZWQgYnkgVk1Ncy7CoCBLVk0gYWx3YXlzIG5lZWRzIHRvIGJlIGFibGUg
ZW51bWVyYXRlIGl0cyBuZXcgZmVhdHVyZXMuwqAgV2UNCj4gYWJzb2x1dGVseSBkbyBub3Qgd2Fu
dCB1c2Vyc3BhY2UgbWFraW5nIGd1ZXNzZXMgYmFzZWQgb24gZS5nLiBrZXJuZWwgdmVyc2lvbi4N
Cg0KT2suDQo=

