Return-Path: <kvm+bounces-64704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B67C8B5C4
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 18:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 586FE34F8B2
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9892130E82D;
	Wed, 26 Nov 2025 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fHu/ZWZD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2392B23BD17;
	Wed, 26 Nov 2025 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764179806; cv=fail; b=ul72L4YFpEQNeeERwudSloA6IPOG5kFltclMpgTzAGAB1PJGoE32/WEnHG7BGXx02jgdNwKTpkHz8deQKeBwkZDJ3g6fp3qx4iJThGYPOZGV+lGeMBfRJLPyGdWr7YHh0kvZqqTdHVb7HB0QEvuKSAvJVkCxjBSsRc+G0O8x8Eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764179806; c=relaxed/simple;
	bh=ZlmU0LdOURmgQgGCdv4VudNRxMKdZ9ESkwWUPEqBsS8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ToosfaFcYiOP7XIPHfKvQvxFzFtxpFNiVnXkfShaB02ceuG7sEAIap1hGoNW6fUFIiqpPpQXLkjsrhoe8vT4wyR6Rcl7AJTuXghTCTukA/vFoch3B5cl0u/gCQ3P6ml6fsx9e+tcgQwb4a9GCcNHC4f7Nrn/ZcUQeDg4ofBkewY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fHu/ZWZD; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764179805; x=1795715805;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZlmU0LdOURmgQgGCdv4VudNRxMKdZ9ESkwWUPEqBsS8=;
  b=fHu/ZWZDmf4kzjVtSUlkza8yEg0JFF3ObsgOFaEewLX2CCUan4w9oo0C
   lEF/ZwSeSbdcPNEKyS7dRgXxRRFCFQsOd0rO12rAIQ4cXvTWx/1hjXMOO
   JplQOg5hK/2evCYnVtEq45stZDQBoq2I7KOPzl+SiKeNo14uAbHWCGG4o
   vths7LPpebzjGVRSM/6DbPRgqyhP+pouD3gjw6m53dP1fkSyC1ZrH8EO5
   usYIr+f2KSO9CYpBLEBN2y1SJtfdiW58PW/N+lQuhbQ0ufUW7OVnka4Ot
   M4EOIXpVWm/PHLFzV0zO29zNssB8KMhhxs8GG262mofZ5j6EZt3CuaXi/
   Q==;
X-CSE-ConnectionGUID: IAosd7xxSgmI2V97w62YBg==
X-CSE-MsgGUID: mN4iwsKGT5qW2ZUDFleY5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="91707355"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="91707355"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 09:56:44 -0800
X-CSE-ConnectionGUID: XramvzXsSKaSxubGlcfvGA==
X-CSE-MsgGUID: rpcR71HISuqN5W8f1mq+hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="223711694"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 09:56:44 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 09:56:43 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 09:56:43 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.55) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 09:56:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lK7CeOyU6kMV0Q637CmObfKboNKfE8DmyGDAwQDB637kcrU8swAgllQwjUAcVAaGeqr6fT3pQSFXL0Ad9HdmpgV+utR4GXP4uAZVSENavdVcyXZaFX4xGc1OFA3TvLN2QGknRpsEY6G5UhgBU+wN9oz0clFrqJR6X2ac7V/opkUk48ZDwjv6djke2KJj7RTy7Aa0oey9lWXYWvbQVIKXS3naXWb+O/a69UNBoDteAHWXfqCHuSOuN7HK7Bzw8Q9B6loO6q/xVPc6X69T2vMG4MvvuAleV6CnMoq/rMDb4WOQ2q+eJavfCBANNU+dwIT/Zeyphp7mVFjckemOJVVTIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlmU0LdOURmgQgGCdv4VudNRxMKdZ9ESkwWUPEqBsS8=;
 b=yIXZTyuLxuNAH0IpaClkUoNXUXiQJKY265IJW8/Vv6dEa2deRCz6UpwUQPtqyQzOdn8uvDdgTanhuFB15GZQ5d11Avn8VLBO42VTHW0zbuPqKYKM4jLTg8x+fI8pcGMr4pn8b12kiqoaH79Heov01AfwIjK4fXPDz8W500hz/ZL06lSYSDKKGElAzrxw5VsVaKRyEvCPAAWAWfANKIQ4kx3AkMRa16fa+dhl6TIXc/akUwqhBKqLFyNb9BbmN00Ul5QjFHOrmC9shijayzQe5Ogc/FRI4PoJOO02WtHPQ55wSUCnyCryO+NgwQ4olVk9WDt/p7ESoLbaKh9S5qguUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYXPR11MB8664.namprd11.prod.outlook.com (2603:10b6:930:e6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 17:56:39 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 17:56:39 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcWoEG0U6tpU/nuka5qLmVaBAkzLUCpq6AgAKgVgA=
Date: Wed, 26 Nov 2025 17:56:39 +0000
Message-ID: <cf8074a66b1fb7059035f2b1820163bda6e63443.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
	 <51dc2009-ff3e-4419-9dab-b46db7b2e15d@linux.intel.com>
In-Reply-To: <51dc2009-ff3e-4419-9dab-b46db7b2e15d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYXPR11MB8664:EE_
x-ms-office365-filtering-correlation-id: 67101486-bf5f-47b6-0c47-08de2d152678
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NXNEZUFyZUxmL25QcDJ1RHEyWklMKzNxZytuZFNEM1JTNFFuSHJLVXhXL1Uz?=
 =?utf-8?B?bnk0ellCY1Znb3R0dWZ6di9wcXdCM2FZVzdEalVHLy9PNkY0TGNKSGswL05N?=
 =?utf-8?B?UDB5OUo1NEs2dVBFbkMzTldzQWQ3NUhiVnJGM1YxeUhZNXhtMWZEWUV6TVI0?=
 =?utf-8?B?c1VRQjlYenVxT1dIa2RPRUtGTnBaY3pHTnExbWdHWVVaRFBaaXcxeW9vQWZw?=
 =?utf-8?B?SEFYNEdiekpuVGlDUmhRaUYvRm1hRjl3YXZ5bUVNRTNBV281TU02eFVrd0h6?=
 =?utf-8?B?Y3RiWlE0YVJxdDdLUGhEQ1dWa28rbUlCUGozQmdxTDhaNEUwTUR3bDVsUk5t?=
 =?utf-8?B?QUgwZTlZYlB5YlBKOGdlQVdWVU5PekwrTWVnclNzWjZxZ0RyZlMvWllpOWxz?=
 =?utf-8?B?RlVKemFuVVF0bWhPUVp3WUIrMGpDNlFqTng3SThzMWZZNkJWL3VjZSt3SkZi?=
 =?utf-8?B?WFkzZmRSaXlzWUhGcDkwWWRjOWUzYzdHcFVGeDMrSldDVy9RaG9keTUrcWQx?=
 =?utf-8?B?alhyUjl1WnBXSFY3b2tINmJzbFRlOE1EZ01VQ2RXcXlibDdRYlpjaTk5RGJq?=
 =?utf-8?B?b3E2NGovQmlMUk53SDZZc3VLUzRudkQ2ejJKVHZ4TG5FekFSTTJDVW5GU0Jv?=
 =?utf-8?B?YzVTdWhvV1c0b2RNUCs1TnBUMTBEeXBzSDRuZmh5VHZUK1BQVm9BaWowdmNs?=
 =?utf-8?B?Z1VZUjZKZ1VYeUJGdFg5OW5RMzVMeWdVTUtZcXVWdVk5d3NNQzB1QjdqTU8w?=
 =?utf-8?B?eTFrVjYwazdWTW9jc1J5aGVhZkhEZVNVY2dzZ1BLdmhSVGVFWHc1Qk1rd3ZF?=
 =?utf-8?B?Zzl3UklLRXpFaG5lSVhJQ2tPVHV1ZmpTajBrRVNpSVpaSDVJT2k0VVlwa1NI?=
 =?utf-8?B?cnNMdXUweERlTzBsZkU2SGVRQ2R4bkN1TkpTM0wyeDE2NzMvYjFqa1VEN2NC?=
 =?utf-8?B?bGU3UmN0QURLdmhtTlNmN3RqcU9OK3VheFlYL0hLeVJYQXk5SU02OFRiN2xj?=
 =?utf-8?B?Qk1RR2ZRWjh1bUIxK0VRejBpVkt2N01qL0JtbC9yKzRGd1d2UEh5d2pPejNX?=
 =?utf-8?B?R3ZtK0VxejdteVhpRm5sRjFId0pJTnVZSGlidHNXN1VMUGhzWTFKTy9GUThl?=
 =?utf-8?B?WjQ0VUZoSWJXcmN5NlUyWGNPK0ZvNnFxT2RlYi8yYkkvVHhkKzdLRXAxSTg2?=
 =?utf-8?B?RjgvcWJ0cDF4WGRUWVpWS2c4UklvMkF4REF3WWhXRDcrYm9kY2xkWU5hdGFE?=
 =?utf-8?B?YnFVY1pyRnRyRGhtU1cxeTdTaGR6dEhDUFE1dzBrVGkyNWFETGQraDlDWHNK?=
 =?utf-8?B?L1hSc3JJSXl5dGFxa1RCMWVJVnJibW1YVlRseE92N2hmd2RiQ2UvNEZoTkZk?=
 =?utf-8?B?T2U1SnlBaC8yVk94S0d3NGlrdjJsVEdjZWc0RTJBQkI2S05aTllMYkgrVURq?=
 =?utf-8?B?STlPSkM4VERleWNKeVdJRmRHMnNlN1dWNGxYL2RYNGZ3clJjTnhMZVJ4SUhL?=
 =?utf-8?B?OU8wL1ZTbnZnQndDU1J5ZUpGQnpJKzFTN0MxT3NmdHcwMU1kMGRKTGhES01u?=
 =?utf-8?B?Rk5CejRPRmhtaGJ6c0ZGTU1QVkNWYjI4anhaVVBNVFExUCtkandRL3NFREIv?=
 =?utf-8?B?MEN1OHcwR2hSUDk0ais0bG8ySnF0ODBDcmVlQjBJVW5kZkVDQzRHYzh0b2JE?=
 =?utf-8?B?N3Z1OUo4VVVCaSt6NHNEMGVJSlNtZzcvTUNiTFRWdi90VGFJVEdKeERmMHB1?=
 =?utf-8?B?NXF1QUt3cWVGMFloSGdzK3IySjRhWkIzNUVLOURGTDNNQ2JQajRiS0tna3Zv?=
 =?utf-8?B?NjQ2bXRLWnk4ZGJmNlF6Qks1eGl1OTVSUThIZi8vb2w2ZGJtbHZHb3VXVmtm?=
 =?utf-8?B?VXJyVEJHNG54M2xrdTF2U1BZK2pBWWU2dHM2SG1oeEpmQ0tPRXUzSmhzVXNz?=
 =?utf-8?B?aEsxTkJaamt3WWRMMnA1b2F0ZTRUSnZDYmNGalVEdlBLSldPSzAya0NsTm1x?=
 =?utf-8?B?ZVBteGJqNElmM0ZyVW1LY2YxWTdaMyszVmE0cUpsYnh0RHE2ZG9LaEIvMmtI?=
 =?utf-8?Q?96EPaV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnNBaUt3dmxpTFJzdGx1YmdmK0xVOHV0Q1F0MDVYM3JwckRmcUMxWmJ4K3hW?=
 =?utf-8?B?T3FmNU9vTk5DRkV0dnpGbnlPZzkxc3k0L1FWU2poNWIxZ1c2c2VmeVdLYXRo?=
 =?utf-8?B?dy9tZEFDbFhDeVU4Y2g4UHhBb3lJZnRNMk40ZWJ1aFZ1SzV0dnp4OFpxeVpL?=
 =?utf-8?B?T25PTXh2SkV4anpoNitCbS9BYUR6aytPK3V5SFZ5Tm0zbmg1K0RFTXRRMHpv?=
 =?utf-8?B?aDJPbGl5TTlhZU9FaFJmOGJ1dTY0U2FqcG43Q0grRy9hVlVMdFc5Ry82ZXV3?=
 =?utf-8?B?alJYYjdrM2plenhtMmZLZWJLTTdPWTVLZnpmZXFMdER3eFhsa3FrNzNHNUts?=
 =?utf-8?B?L0xWWW9GWHpKUnVCeHljRUJYb3AyL0ZqZFJiZGpyN2k2SVg0TmJOa0hVWHRw?=
 =?utf-8?B?UzR1MlFKY3hLQldZTHZCb1dYY0dPV1FnK3Q5SDVLbXd1R1VWd3pndnpiSFFK?=
 =?utf-8?B?cXUxbFhTelZkOHFXS3F2aVFKTG9sRTlIU0JhUVJ5dWZCamkxNmcvUC93RVl3?=
 =?utf-8?B?KzgyZDhpMkpXU1lKdjFBL2RhUkJERHcwQlk5cGJRd0ZPR01Ib09HRXhnN3pN?=
 =?utf-8?B?YWc3UkNFQkVNejlRNlYwbDVwa1FPUmZWSXBxR29TTlpFemlKWlorVmYvMEJv?=
 =?utf-8?B?a0l3M1ZiRUF5M0ZJeGxrTjhoTDd5a2xZSk9Gbkk0SWc5TTh6elhScG9DNTVv?=
 =?utf-8?B?Y1dwVXRGeU9ySDFjR2pWSTFYQXZNWUdJRWJCZ3BzVzlXNjJydTlLQjhGU0s5?=
 =?utf-8?B?T0JOSEhUa3JpMTRIcWJualpneW9Rc0trSHE4QzlOSDN6THRwNmhMb1hHNjBo?=
 =?utf-8?B?N2RZbC9zZWNqMlhMYk9jcHZCWGpKMHpkUGdtUCt4Slk3cXlXaWQwTzExZ3Jp?=
 =?utf-8?B?MnAxdlY5anVQalRaMVh4RnNTcWZ6cElRWEVZQ1lyekZzYUFDRVBlS1Z6dnRW?=
 =?utf-8?B?blhvSGIxU2dydUoyc2ZUMDc5SmlKTzBzVU0wdDRXRXBBMEU1aGpuT2VvSENO?=
 =?utf-8?B?Z1BPamZzcVFReTExYys3eHZSOGUvRlhPbnRwZlphR2huMWxhNmtGSGJrakoz?=
 =?utf-8?B?d2tsSlc1UytjRFdhdHp1UWNETFVtQitZNWMwV3pLNGV2dHVTTU5NaTNDb3Iv?=
 =?utf-8?B?UzR1M1RLd3hsU0RCcVl2RloyMXpiSmFKMzNBbGg4U0s1Y25VaTljR2NhbDdF?=
 =?utf-8?B?OWU4SnUyVVptbTA2anNVcXN6ODVWK3Z2dnJuMVBkSlE4R2k2S3pwV0tQeERp?=
 =?utf-8?B?TmlmMW1UVSs0bmxRb1ZSejF4bVo4eFcxUU5ZNk5CcXl2QnBwYjFnK3QvNmcv?=
 =?utf-8?B?ZkZzY2t2c2JKbWZTTnJvNGF6RkFOdkl0Ukk5OUpXZ2VzU0k5ZkVHQzBaK2py?=
 =?utf-8?B?MkdQRlZSMUEyMHZuZTQ1SVhjNTZUTnNXK0xBV3MrUFZEMS9qTVJteEM4NWoy?=
 =?utf-8?B?c25HdWxhcjdoOThqM0NsazdTNWZHR1FyVGlUN2N6L2I0emlMNnlaNzRRQ0J5?=
 =?utf-8?B?ck1ndEVzdzNYNnY2cHQrdnNDNm1CT01CR2JlOTBNKzhESDNzbWRFYjVFdmVY?=
 =?utf-8?B?eWhZSkpDWkN6eHAwRVRscVRtVWpUV1pzSlhNeXpoeXkvWGtiUXRSMjMvYVhl?=
 =?utf-8?B?ZTlqODZHNlp0RmllREVGWWxiR0VuMGpIc0NWWWR6RmpSZm8zODlJMmJqZGxk?=
 =?utf-8?B?Qjk2TUwrRVllQU16WklZaExueGx2NVNPQlNibXh4WmNoait4eWd3RkdoNk5E?=
 =?utf-8?B?RTBYNVlwdkhGYmJaVDlvZ2JRdXFTQkNmYUFwektSUkhybDBEVFNXRk5TaHl1?=
 =?utf-8?B?Ry9zTTBreTJiWm8xc0JubVlydWhHOUZxSUYvMFFWMWtSbUZwangwRnQ5RmhX?=
 =?utf-8?B?WFJBRk93TzVDYTJmbW9MNklxSmtMN3Z6eUJMUkJsUlF1bXBKYVhKVS9YUU95?=
 =?utf-8?B?ZDE5bkV4b2V4RXkyMkZCdHdIK0p4dWM5eWNNeGozTFRjK2I1KzZTT3lRUDZl?=
 =?utf-8?B?bkRTTXBSWWl4eUR5dWhqMzlLaG55T1BVMnJtYkNKQ2FNTURaSElONzhVdURr?=
 =?utf-8?B?SXlxbmhmcnd4MU5xVTRlc2RNOFlSdW9vNVlsNVVDVEFsR0xhNWd5TzRTa2c1?=
 =?utf-8?B?dlU0M2xGNHk3Sm5kbFQyNGRDTys3TlJvWm1hL08ycGt4a1h2SzNnZFlNeE4z?=
 =?utf-8?B?SEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <491FC38BBBADF046A3D10EC966F93BDD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67101486-bf5f-47b6-0c47-08de2d152678
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 17:56:39.5584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KB04NFmOva9O8HvtvC0sXmTRtU+9hj2TZV5VoS0fb1dH+Mr224LRBT63b+lQvSuAK+eoYockMVrIaRVYRjt0yrrO9bAzLU8o023OkoaI5Yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8664
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTI1IGF0IDA5OjUwICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IFJl
dmlld2VkLWJ5OiBCaW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+DQoNClRoYW5r
cy4NCg0KPiANCj4gT25lIG5pdCBiZWxvdy4NCg0KDQo+IA0KPiBbLi4uXQ0KPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4X2dsb2JhbF9tZXRhZGF0YS5jIGIvYXJjaC94
ODYvdmlydC92bXgvdGR4L3RkeF9nbG9iYWxfbWV0YWRhdGEuYw0KPiA+IGluZGV4IDEzYWQyNjYz
NDg4Yi4uMDBhYjBlNTUwNjM2IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHhfZ2xvYmFsX21ldGFkYXRhLmMNCj4gPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgv
dGR4X2dsb2JhbF9tZXRhZGF0YS5jDQo+ID4gQEAgLTMzLDYgKzMzLDEzIEBAIHN0YXRpYyBpbnQg
Z2V0X3RkeF9zeXNfaW5mb190ZG1yKHN0cnVjdCB0ZHhfc3lzX2luZm9fdGRtciAqc3lzaW5mb190
ZG1yKQ0KPiA+IMKgwqDCoAkJc3lzaW5mb190ZG1yLT5wYW10XzJtX2VudHJ5X3NpemUgPSB2YWw7
DQo+ID4gwqDCoMKgCWlmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQo
MHg5MTAwMDAwMTAwMDAwMDEyLCAmdmFsKSkpDQo+ID4gwqDCoMKgCQlzeXNpbmZvX3RkbXItPnBh
bXRfMWdfZW50cnlfc2l6ZSA9IHZhbDsNCj4gPiArCS8qDQo+ID4gKwkgKiBEb24ndCBmYWlsIGhl
cmUgaWYgdGR4X3N1cHBvcnRzX2R5bmFtaWNfcGFtdCgpIGlzbid0IHN1cHBvcnRlZC4gVGhlDQo+
IA0KPiBBIGJpdCB3ZWlyZCB0byBzYXkgImlmIHRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQoKSBp
c24ndCBzdXBwb3J0ZWQiLCBob3cgYWJvdXQNCj4gdXNpbmcgImlmIGR5bmFtaWMgUEFNVCBpc24n
dCBzdXBwb3J0ZWQiPw0KDQpZZXMsIGdvb2QgcG9pbnQsIEknbGwgdXNlIHlvdXIgc3VnZ2VzdGlv
bi4NCg==

