Return-Path: <kvm+bounces-50766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D9FAE9119
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7C821C221E6
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA432FCFC7;
	Wed, 25 Jun 2025 22:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WW9+yBDN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BFA26E14D;
	Wed, 25 Jun 2025 22:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890788; cv=fail; b=T3J8JqIWBB5vHf4adyzOfLH0EGxy7E33c1t9o2Ws2ngTAkxNaUCrRCRoxvrsZ2HIH/4wwkNLp37METtVH4UOGp+u96K0zjFtpOuMGTKq18gA3sCNBJh0dBkyJKbLKIZJM8wfj+GdYYxnDG1DHlr4t76BaVAT+JO+GZbI4/nCKRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890788; c=relaxed/simple;
	bh=aJg3NNgcZGq0D3HYCt/Seo/ypDunjt/u7VcgTsxBhvM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dLFnLXnx2v6uAUm7LqDN2Hh42ttYpVkN/TO+SR63G06UUoDqIIxWEw5+Dfee8mz3zADwY+JDyKNunlqToi9XHUyN7ItDcH4ZQWmfc+e7AbV5Ae0U/1dTWIhodLB8Iqe9CnElwKk1EKNFNCT+uBJ+Xm2Lftc0fYqWYkCXO9gxdMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WW9+yBDN; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750890787; x=1782426787;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aJg3NNgcZGq0D3HYCt/Seo/ypDunjt/u7VcgTsxBhvM=;
  b=WW9+yBDNxyUZlQS4PUj4G/K8KAEpv4iXio93RniOVyMoCO8pmFpyuxD+
   POtlbPBZu7JkJnXNNX8ZjhSMrLPdfk1ga8h/oHxPbHRF2RMI2OYk1dpJr
   YfEMZRB83w4PTk1LzE8qK8i7ZVyIIaCQUwJrBt96WXGrQVrXRDhGVyV2V
   eTT7Aph/3w7qeyQkLRiMGzn2A8hOhp1YEm6yuIdOqM0DNsBnVG+IyEddW
   13xBrqh+gW2frdTVMGHAw6n7UC+N1eEOEU5ertPYoxIHVgDR5TdqwuvnV
   E0tAc+Bmrrhe5xYQaQKXiym0IDaAeQUBrZvia4np+CL6HgCS0pIvhxCAg
   g==;
X-CSE-ConnectionGUID: VGULOQAaTl2ilUXdy1msow==
X-CSE-MsgGUID: PRK4DiE1TgKY0TxjIkpl4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53048070"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="53048070"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 15:33:06 -0700
X-CSE-ConnectionGUID: seb2L5MWRjSI4UEK5ml5HA==
X-CSE-MsgGUID: HHne1eB7TYWa1IP7YS6m2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="151863189"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 15:33:06 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 15:33:05 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 15:33:05 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.45)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 15:33:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOfaTwVNNaU7tJDLNFBqsNuv4c36w0aj7K+9Zu1/i9pmmeDYZeaTD57c+9MVPE99KzTKCkdfrE1d/ELUdRo3aMIcyZaQNxEI/gI7MQDitxiJbMva1c6vtYir83sD0ly3ePTXeLAgESpmJ3KyeM3g7CWgbuvYsZRZAc0vKRVlUv89/iMCIvWkU58tzIG9z/cJxsI/AOrnQOK/zCjlFClrIxqZBdSR6aZuA9uyq+HNiI9k/FwS/7P5yLBtJok5ivO04yzQ0LRgeXJFHQQqXbAezx8rGDY9qY2FRaTBrkoNyFM3NltzKTuoXSXnJhNhgOTBKsIrHP/RqI6XffoOdH7vIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJg3NNgcZGq0D3HYCt/Seo/ypDunjt/u7VcgTsxBhvM=;
 b=EfAxfiNBDdBLYk/ek9jDtfUmZ2PelLS+3Xeu0mKDQGoWlqrVFAYF/Y0xkH5cTBqva9OWOGBIQyJuW6ZlXhYKyOYtopbxNeCmkmllNwTYnrFql6oHmlrlWtjoUsKfKQOXFjiVSP1Ii2G0uNP/IRHQSudjh9pmm4OuW6VxyLj0NOSmQFYLZ5iDXBa3K20FpfQ3LWg9Gu0AR8lSXHwa+AKWoW7Nh/nRP8xZb9qGISOU56lreYHTuqVbiKQ2WuYXe7z+ndoFIiQbKzZ6o94H/Y6y6h42L5dqele9l7l3V+M+wa5eIKiWTq8TR8P/PxfJrVw1Mb+1nFJJFnEZ0dyUBEZ5XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL1PR11MB5954.namprd11.prod.outlook.com (2603:10b6:208:385::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 25 Jun
 2025 22:32:48 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 22:32:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Topic: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Index: AQHb4EnDpX31F9fykECcZZx9vdaxeLQJAkSAgAr5c4CAAB9IgIAAZo+A
Date: Wed, 25 Jun 2025 22:32:47 +0000
Message-ID: <c315604761ad760fc29bebdb007fac239a1b45f9.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-3-adrian.hunter@intel.com>
	 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
	 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
	 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
In-Reply-To: <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL1PR11MB5954:EE_
x-ms-office365-filtering-correlation-id: 3441b44c-0479-4b86-1666-08ddb438366b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Wjg4UDF6TUo5RnZjVnR6NEVKaHlNWThsMGhhNGMzWmJ6T3JReTZtMmVlZnVW?=
 =?utf-8?B?ditsV29YMnR4cW1pdFRteEVGVW5EMlc1Z3RsUDZhK01EWDFYVkt2QVJsZzlh?=
 =?utf-8?B?VGkvS2hkY1JEWHZnR3ZURlNPd1lnTWl0cmcvVmZDQ1pyTXVIR3dIZUNnRGdJ?=
 =?utf-8?B?QU5hM05DWE84QmJDd3ByVjlLUXJrOFVGUXBZMHpZQ2p0MktZUUVkbU5WdFY5?=
 =?utf-8?B?bVFEc01odExkb3RGVS8vc3ZPZzIyZ0hibVN5NGloQmN2UUNlZjJZcWkwTXpZ?=
 =?utf-8?B?bmRoeFFzV1JjWlRiUnhHcVNLNGsxYXFVbVhMQk5FUG5nMDhpalpKb0lMUGNH?=
 =?utf-8?B?Qk1LTUF2QnFFRC8xakpBWEl2c25paEs1Y3QvYUlDbnZTK3IwdlgxWXN3R1Fw?=
 =?utf-8?B?MUZUeFg5enNjM0FOR2xDYXlvZTRMYXJ6bTdGam1XUXUzd2Nlanc4RjdwV1ZO?=
 =?utf-8?B?RFp3aFR4bm1US3FVVTNjMVFqM2tQRmZjZWpTd3lGYnJMSDY4ek5VV0FxdjJ3?=
 =?utf-8?B?QzYzYVJKZGJlVGMxTDI2ZlJQRmpZOWZuQndpVGh1RU5QN2UvK2dJanpXTG12?=
 =?utf-8?B?alo2eEVjZmNIeWxpcG94RU92V3E2aklPQ0owWTg2eGFxR1BzQU9NN2VxWGVM?=
 =?utf-8?B?enVEeXpUSVp6ekV0SSs3dGtubEZMZU5DRmdKTUVVMzRodmNVaEpuM3cxWW5L?=
 =?utf-8?B?RFFnTTFLMDRONEFScTdqVTIzV1Q3Q3loR1BKaUgwb3NBUys1Y28zV05CYmZ6?=
 =?utf-8?B?b2xPNExSQ3VrN3l0NEc1L204Y1lrbExjWUxObndTRXo3eTBSNnRaWGp6TmZY?=
 =?utf-8?B?YUc2WlF1K0xtUVp0RXFJZUpZNFhaaERQYWVEN0d4bFZ2V0VjSjFmRytKT3NK?=
 =?utf-8?B?K1dZUkZFa3pRN1VoWFVjcWlMakUxdEl4NENYK210RGFGQ1Y5YUNCWWcrUFZk?=
 =?utf-8?B?YU51NVlHTVpwaStTZU9GbmF3UEQ2MkNXWFRpU3B4ZGI0UnJQek9NdEs3SC9u?=
 =?utf-8?B?M09sNHZCY0ZGOFhqV3NlTVNLZmtLUjBMR1dPbEtZbHF2Wittd0RrME91K0Vh?=
 =?utf-8?B?R1QzTEl4MUJrdGJDcnN2T2V2RnVCWHlDV1diUGZjMzZoeFVhdkpjSEQ5MEVK?=
 =?utf-8?B?WUJiYW9LSHhuVldSQk5adDJtSjVVaG9NME1MRzA4RlhEL2lRek8zb09LR0FT?=
 =?utf-8?B?TEJoTFBaSi9QM2R5QjJxYnpheXljZjNTcmFyeC9VaFBmcDE0VUxWNll1Ti9J?=
 =?utf-8?B?bzRVQ3R2U1lFQTdXL1YzQVhObDAzbEY2aTBPRUlLMW1LYnVLUFZLNzBzUUto?=
 =?utf-8?B?L3BIZHJZdCtlemxrbVl2N09kL09ON0xZUjdMcHNNQTBWMmxLZ29jNzVNOUEw?=
 =?utf-8?B?bVhKT1VOd1dZV2J1elRwbk1wU2pyL3FVWnRNa1RFaFZPaGlnUWhaK3A1UTJk?=
 =?utf-8?B?KzQ5RXRuTnUybU54TjY5NlhjOVdDazFRYVlFbDRUUzcyMFd0Qld5TVBFZlZK?=
 =?utf-8?B?cTJyRUYybWdKaFd5OUR3b3VIcmNheC8rR05icUtyQXdUU1RId2RPczl1Z0Zu?=
 =?utf-8?B?ZWdtdWdiYzZ5RE5IaHdKYnNBUm1mcXphcEtYOCsyRHluNUJncVEwSDYvVk9i?=
 =?utf-8?B?dUtvTHg2UDJWaHAvWU1tbGV2bkpMOGVjakF0Z0lwRUpiREJZWmdiT1M5V05h?=
 =?utf-8?B?Qi9zK0d4NVhPV3p2TDlYRlhQSlRIdmJ6WWVLR0NTVkVNeTNPN0psb2M4Yk5m?=
 =?utf-8?B?V0ZMcnZhNXAvODRPdGRXcUgzOFdHSklTUWtQamFLNDZocSs0L3pzRFhjcDNm?=
 =?utf-8?B?SnZyN2VXdnExNE1zSlgyQzNwRktmc1doUU15NHVQMTQ4K25RMDhJVzY0KzE5?=
 =?utf-8?B?RTFDWjR0aSsxMnVPNklRT1FkdFVMWHV5dDc0Um5yeHlsUThPVHR4d1c0bDg5?=
 =?utf-8?B?amVKT2FKOFV5dEp2bU1Hby9GM1FoenVjNVZaWENOdzhoR0gzbllNM1hSaWhY?=
 =?utf-8?Q?p5Y3krJBzkZ3A7d6UmF3JoBacJ8E6E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEt3MUlEZ1JpeEtzOXZtVFJmRXlDN2xSdlY4TmwwbHlhcGZrdHEyYVhVVjdh?=
 =?utf-8?B?R2JyckhncHJyeU8yaTF3SlY2cUYxWGNtZVRlNmFHNngwQlQwQ3NEdk5qZEVF?=
 =?utf-8?B?MW1HbDZYUnQzUUZTRmNqcUt2MFBPMmVWUSt6Z0VURklYaHRxdVFzODhkazhp?=
 =?utf-8?B?Qlo5V2M3NXlXOWs1NWFFZzVxMlArZGl6a0lLamlNemxxM3d4K3pId3o5Q0NV?=
 =?utf-8?B?UzBjQVZSOE5PN2x4UGFhOGpVY0VudGJKMTlLYnZrUGpFcnBJTEFZazN3WVp3?=
 =?utf-8?B?YkRCZ054clZTSk5YOGJ6eUJ3MTExRDBoc20raTEzVjVtM2V6M2t3YVJzbDNI?=
 =?utf-8?B?OElXU3BoK1RVUGRzK0hQdEpXYmdoZG1SZzFQSklJZlA5cktHSXVvbUNraEh2?=
 =?utf-8?B?MWtuSzNMcEZYL0ViczVxOW0wcklQOFBzalY3MSsxcitWS1llSndSd2t0THVE?=
 =?utf-8?B?MTBQY3FOUnRtdlVVeGhYb0dYVXRiUXVKVHJtc3BKckdXZVFGdHc3cXYxUnBs?=
 =?utf-8?B?Rk9yV0RqaUtodlRiWlkxMFVHelZldVZjMGxvUnJjcStuM2Z0NVJaYktKNUtq?=
 =?utf-8?B?bWxsa3ppbTc1RDZYQk12MUNYdVc4Y3RSaEcyZ0RNMlZ5YWpMak9NYVB1RHZj?=
 =?utf-8?B?a3pIWjVRajZUL1FobWs3ZHBTTlZnd0FKdTVaMjBYRzZzbnByVHdDZ2dkV21J?=
 =?utf-8?B?bzRZaGdQckI1L3BVMXZUcVdEeHdQQ3BDcitwcDlDbzNEMXlERmdtcVl6bEt1?=
 =?utf-8?B?VjZYdDdGRlU0VzZQVVBUUWFFWnc5K2g1TUVFQkpPNWhlUTNkWm44Z0x3WmY1?=
 =?utf-8?B?Y0daUHNKZVJTbzNuYnZkU0F0Qk0wWG54ek8rTFlkUEFoYTRSTTYxOGY2UWdr?=
 =?utf-8?B?ZjlqcGtpY2ErWDJzTUJSQjNXbnVFSFdnczF3MzJwaEEyQ3RoMVh6aXhlNDZP?=
 =?utf-8?B?SW1WSGlTQmU2ZjFabGVxNlJTbzRHcmx5WEYvM2Vld1h2NnFxdDIvRnlGTTJ3?=
 =?utf-8?B?YVBXaVdWNlRlakpGVlBnTlJaNXE5Mm9hS3RCVjdkNGZtMlZZRVVrOEx0TXhP?=
 =?utf-8?B?VzJ1QllBMW05dkRhOGI2YTVnWnB0UGpaVlFvNXhRZ0NaMEpMR1UvTlVDcWx3?=
 =?utf-8?B?YTVrQysxWEJ3VmhUTFYyK1hsdGVWaFdYNXFKaGVVeGdKWUNDaXJzSDYvSkpR?=
 =?utf-8?B?cUdYemw5ZmlFcTUwVVRZc2ZSaHUyWGxVK1ZwaGZmY08rMzY2REZQMVhNbUo0?=
 =?utf-8?B?WC8zYnBrM1ljRVdSMTEyU1MzVzN3MjkvcHQ1Z2lkeTF1ek4xZHZxYzVPZVFZ?=
 =?utf-8?B?bFZGTzJ3cXVzTXBnSnJLUWxiSStjTnEvK0c1Y0pGdHRUdUpGZzdmNkVpZWVL?=
 =?utf-8?B?OUtaWDhqR2FyTXVJT25UVytTSUErVHlWd3JSbmJZUjhRZk9zR05pdFpSOXU1?=
 =?utf-8?B?ZWthVmhmemRBc3V3dkdodXdFTEpxZFlBNmZkc0YvNndxRjhTOGQxQzhidWlO?=
 =?utf-8?B?Z2s3ZWEvNWl1K1dEODFKNFJISEtWck1EN0YzRVRDVXJKMkNIQzRrSkhOQUdL?=
 =?utf-8?B?WGZLZ1JrTVB2ZUJnWmNheFVDcE5ZZkZETVRmejY1RXpxVG9GTy9BUE1DTjFI?=
 =?utf-8?B?N1J4TXlhU2RiZllqWDlzOFYrd1Y3UXBTeTVUZ3JZRDZSejhHMWcrTGRuVjRS?=
 =?utf-8?B?enZtbFFTZHkwMlVnWjlQOFVNeUhxUlRpYTZENnZOUkJFU3JuTlUydTl4ZVMz?=
 =?utf-8?B?OUxJVnp4bjlqMDIydVo2Uks3Y2FWRTZpYWYvZVNkTHB0aHRHSVlxekJYUDZo?=
 =?utf-8?B?ZmVHSVpQc24vOGNXRXJ4SVlRcjlJRmVtejRIR0FJTUNVNHVjaU5nRG1xeHNX?=
 =?utf-8?B?QjF1bUdLZGcxNnYwV2l0VUJMYnhBK2ZpQ1VETjk1TE9NeUlwNWlkekZDc1BO?=
 =?utf-8?B?OVVEblFubGsvUE5XRlo1UkVUbmJDTFJYYUhtaitxVjZ5U2k4Ky9BdVZVN3dN?=
 =?utf-8?B?Nk1GNFltSERTYjQvcHlBRndmS01uTWdhMmZFUWlTSXJsM1h4aGlxT0J5Mmcy?=
 =?utf-8?B?endHVWZsQTVQTGRiWGRTMDB4TmlzVjFOclVRVzRtZTVwVThDeVlaSFNhdUtT?=
 =?utf-8?Q?vTIs9pb1I1Xl7gT/H/TfaE20Q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11484896F1D4D14DBCC129231AC99BFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3441b44c-0479-4b86-1666-08ddb438366b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 22:32:48.0119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wuVHd/bga8FruzzNM5kh13tfCs9Ya4OozJfd4v6QLDr4YNFb8tcIi+fuXZWtrb/vb+UIWSl1zHrRS6/nAcrr4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5954
X-OriginatorOrg: intel.com

DQo+IDIuIHBhZ2UgbWF5IGhhdmUgaGFkIGFuIGludGVncml0eSB2aW9sYXRpb24gb3IgYSBoYXJk
d2FyZSBlcnJvcg0KPiAod2UgY2FuJ3QgdGVsbCB3aGljaCksIGFuZCBQYWdlSFdQb2lzb24ocGFn
ZSkgaXMgdHJ1ZQ0KDQpSaWdodC4gIEkgdGhpbmsgdGhlIHBvaW50IG9mIGF2b2lkaW5nIE1PVkRJ
UjY0QiB0byBzdWNoIHBhZ2UgaXMgd2UgY2Fubm90DQp0ZWxsIHdoZXRoZXIgaXQgaXMgYSBoYXJk
d2FyZSBlcnJvciBvciBub3QuICBJZiBpdCBpcyBhIGhhcmR3YXJlIGVycm9yLA0KdG91Y2hpbmcg
aXQgdXNpbmcgTU9WRElSNjRCIG1heSBjYXVzZSBhZGRpdGlvbmFsICNNQyB3aGljaCB3aWxsIHBh
bmljIGtlcm5lbA0Kc2luY2Ugbm93IHRoZSAjTUMgaGFwcGVucyBpbiB0aGUga2VybmVsIGNvbnRl
eHQuDQo=

