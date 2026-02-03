Return-Path: <kvm+bounces-70084-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CZmMKVbgmlhSwMAu9opvQ
	(envelope-from <kvm+bounces-70084-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:33:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BE0DE852
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 44F50309B46F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 20:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8428230BB8C;
	Tue,  3 Feb 2026 20:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TVx77m7W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E0A28D8DA;
	Tue,  3 Feb 2026 20:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770150811; cv=fail; b=udww8o+JSz7LPyNonX+1Qftc5mHm4DBm24LzJoS7sWbX9rXUlewCAwteS4RJIUPv7BMIgtfJGi9LDRRKRW9ymHREn7sPvyJGtm8UoFiqFoAqz32rB1tNMXlGkm9KGKFZzJVO9itw8KtGIRqY4OIINyOkW6lBgzUSJDsP3/Ale3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770150811; c=relaxed/simple;
	bh=nqiAKJ3IAwyIXuBzFgGaoneZQwCH7n5ZhZ1tYm4XnX8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eH8q27Ack49vWbQigQaBj5JAVCYBoKKzg3lYJir1GDscPom/PJlvNs1Opv9Ih+cHHXjiKMKjkSb8OipkBQKEQpzgOg71FkOQp1RHjr4nU4iGJXWI/Khn1vaZ9Ln1CR8UBnouneqDrfvIihfmMeouzi/obHRqyXW8UyRIGgPit9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TVx77m7W; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770150811; x=1801686811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nqiAKJ3IAwyIXuBzFgGaoneZQwCH7n5ZhZ1tYm4XnX8=;
  b=TVx77m7Wpe5LBAzPIRHJUUw4fq4T7Rpna/KJgd+LVb/XUK0Q7r0hY8sD
   s0zNwQWvB7qmnOxb+SIJjOJEqyg7kjStkHJni77nI+6xraOAuVtpmofiB
   xSvw2oq2BjRohY7GDwQcYZjBga0QNbonJB3bktd3tLBvy6AT4FjqJmgy+
   oEOu27O9Fapz//+7taQK0klzAsqnCR1UgPdT1osCQmzR/0qcGYemch+zd
   fhS9h+4KWyNe5O+bWk7byLM4yaacuDsYWpAqDsph41Z/c108y3r90YO5a
   Tqs7si+3Bb5e2SHVLE6rNJAsJPrH9hfLfeUsa8v8RAk/oaT8LCLZMZ1Vk
   A==;
X-CSE-ConnectionGUID: F7AgvZnrRI+/rlqg9G/wyg==
X-CSE-MsgGUID: o8ZXNlIlTXu+06c2D2L8BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71312086"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="71312086"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 12:33:30 -0800
X-CSE-ConnectionGUID: QbOOuT1pR8S2d3PGfn08uQ==
X-CSE-MsgGUID: qKLecWa7S7a8F9gNZ6h+AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209065351"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 12:33:29 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 12:33:28 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 12:33:28 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.60) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 12:33:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbhJa3j3FscwCwqQziBTUbJmmPIs8Yyqf4g4asWGveN1THS00ABVvBZSwsbkCzYtIh2rMolPXx6S6024nd2L6BhqSiyxdfUtkaWpWMIABoVWh7vB1wnOnE3FniaPevQ0Mc9ocKE6rXcqWfCSStjZFSNJn85PO3uCB3b9wmx1vybxGLO6cbfo70K86jdtAp5N3/8m9ORa2oL7LPxtm5JuJl69PRrQZ9PHd/mB3g0T54yPR9QataIuscNQ1m0bm5OunZoo6sJKcZ9QXSwY9TBelmJE8s9mu7ZWqMDFgD+yPjgB5XyPfXpnnGs2Heju2C7kaLUEm1WIiEe9SYvAs5CBSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqiAKJ3IAwyIXuBzFgGaoneZQwCH7n5ZhZ1tYm4XnX8=;
 b=idi0yrEf5DsS3lDzTyKpmyxi5A/IOcqYq2NReElrqTEi9Kt2+AvM9pI1SkgapQ3PstYtC7mcdqOpAfj+o31PYCCa/yXBPr0jWE2dAM02t2Kzsa7bOfDoyMZ8BWZPmHS/+IYyMZJpYSbuY2M0Q82utWfqRSEl0jXA6iYKUkkqjkpZ77l0Ic+TNWvC+Xhsjl2dwHGTNOGJWu4RSCo662as0kdDZKdk1ILUuoqPsNH3KbD3VjnVixFb8LOgkvKKFb7jD8PB4WU2zyIgNZGBFTQbrbFIyicsBd/xAuER9PPQQVJFtU55QUNm7XE0V/mIYDXRa1jj7Ks1/Z9mQmePJFTfMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7604.namprd11.prod.outlook.com (2603:10b6:806:343::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 20:33:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 20:33:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "sagis@google.com" <sagis@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"Annapurve, Vishal" <vannapurve@google.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
Thread-Topic: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
Thread-Index: AQHckLzuLsU6EOs1zU6VcZuBnZdGibVw1fMAgACbfACAAAXHAA==
Date: Tue, 3 Feb 2026 20:33:24 +0000
Message-ID: <c01b2f81e025dd38be90d3820260c488c7eb22ce.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-20-seanjc@google.com>
	 <de05853257e9cc66998101943f78a4b7e6e3d741.camel@intel.com>
	 <aYJWvKagesT3FPfI@google.com>
In-Reply-To: <aYJWvKagesT3FPfI@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7604:EE_
x-ms-office365-filtering-correlation-id: 28762899-69be-4593-f0ad-08de63637b01
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bVhSUUVwOVZNeXNWQXRCOGRTUTY0dGtkNitTY241Q014YzRTZERTVnFBMG9Y?=
 =?utf-8?B?RnBhdVE5ZFBVQjhDd3FSbFVPZzMyL0thcDZwR2NxaUw1cXR2bHZUaTBXczd4?=
 =?utf-8?B?Y29wRXhJOFB1Q3lOTTlqa0Jjb0tCODc1UVA5bGs1YnlRcmRYNE1FVCsvS3JM?=
 =?utf-8?B?Q1JyNUNHNUdUaTlYZGkvU0ZzQlFFT0IwZTFzWXl0UWN5QXliZHUrTVFIaFJK?=
 =?utf-8?B?MzFYZ1c2ZjlBZ0UxMFJWQk1GNlBOSHM5VjViNWZTUWVENjNRZjh5U0dJd0RG?=
 =?utf-8?B?cjh2ZnlsNnBlSWc1Snc5cUVqQ1ZEYnhPd1FDQjhPdEx2RE4wVXVnL1RkSGhI?=
 =?utf-8?B?c0hMa2pVVUZQQzZSS0FyU0l3bnBJUlBQN0w4dngxN20rUUVTTER6c3h2MS9n?=
 =?utf-8?B?RHpLVkRmQi9qTjd2ZFBMVzR4S0MwMU15SSs0blRjQ1dtanNZSjdTb05nc0x6?=
 =?utf-8?B?NVcrTjFRWXN4RTJCbnpINmpFbytSM3JqdU1KcC85ajBYU2wwTDkzYlVMZWpV?=
 =?utf-8?B?N29NUjNZK1AwS2piem1veGgzcHFkQ0lqbHNUR2hCNWFYakVpWE9xemJDenBX?=
 =?utf-8?B?QlVvV3FDVERYck54NmsxRnoxWnI0VjJPdjVRMkN6SHA1NWZFMGt5b3YvakhD?=
 =?utf-8?B?QVlWN2tLc3N0REdtWWM5eFkwWlhORnZ1Qm4xalNRcDFLWDF3aUVQMks0V2xJ?=
 =?utf-8?B?UHlwY2ZodmVGdmI0QWF1bFBjTXd2eHRCakxJNEZ2VFBiUXhReUM5L1ZCWTRt?=
 =?utf-8?B?REM1MkEySmxuN1NIMWdZTGtiZE9TOXVJUTNZQ05LM3FDSGN1ekNoYVRHbXAx?=
 =?utf-8?B?ZnI1Z205SEJ0c0haZWJWQStlZnpNMXBzVGVocWRzZFpUaFNuR1hpLzBSZm5I?=
 =?utf-8?B?MnhoZUZvQjJkOU9CbjA5bTBQMThOamU3ay9IMnZnQ25hVDNYemNWNWVHQUlT?=
 =?utf-8?B?MC9uaUtvR01zdTMycmNDZWtQU05wb3BiS0pjd0VuTHh2WlE1OWtoZkFnQlFC?=
 =?utf-8?B?YnRldlREYkNyRFJCNE41QWRwMktEUEhwR0tEMmxFM3lWcXZmS3lhNncxK1lD?=
 =?utf-8?B?N1lGWk9HQUV5NnpxUkFWckdTTDdSYS94Z3VtVk9YWEZGNnc5bHN2RmtXYmVu?=
 =?utf-8?B?UDg5bGxOZnR3aHoxSE5wSUgzTVhiNFBwV2gzNWpWb2N4NFNEY1NRVCt1QVdn?=
 =?utf-8?B?Z2kwam5wZ1dmNkJ2ejNnMEt4ZWtxdnlXN0NhNXRiUEtWTHA1ZXlXeEZLMlVG?=
 =?utf-8?B?T0twUklBdVRJNG5kSlM0OGRlbzlkNHdVTStyTi9LdFBucFJJWVJtKzkrSm1D?=
 =?utf-8?B?aXAyKytRU2k3Qll6cFF2aHZIcHVyc0hESjlYSnBuN1k1UFIrMTJtVnk1RnBN?=
 =?utf-8?B?MnQxYi94MFE0aWtodzN6WG1Qd04xbmowWDVsK0I5NnV5NXF6YmowRmdkWGNX?=
 =?utf-8?B?OVJTY3BzaDFiQmxvaUw5RVlkOUswajFPMjUxMnY3QS9LSmtadEJHczVmY1A2?=
 =?utf-8?B?bURtYzkybFYyWklIL3RuQnliUDFEbFl5em9hM2RuS1NBaHVRTHdYc3EveHZK?=
 =?utf-8?B?aDZkZ3BzL2NFcEJmSlpZb2xKRmlXNWtQMG4vb0c0OTFGenVDU0pUdnp6dUY5?=
 =?utf-8?B?TENVSXFlQXYyU243ZGh1QTh0Q3BHcVQ0ZDNZdjZxSDVuOVdxdUIwKzhSYjlD?=
 =?utf-8?B?Y0xkYVduMXV6dUVxN2c0b3lYaHluT0dlaDZ4bFJzcEFpQ1R2WDFFT3hIWW1C?=
 =?utf-8?B?eFkrVlN0RStGWElxYzNkS2hPOWZabkVDMjFzS0dQZGE3Q2dPL2tMRXJwTnBK?=
 =?utf-8?B?ZE4zNUpzZS8vdEFLMldReTBuek1DWGJLYXVKU25UVHh3dkdIeXk5ZFFYbm9Z?=
 =?utf-8?B?VFdRVG1pY3RIZVFNajQzbzVqY0Vxb21BVkcybEtHZlBvdno5RDUxSjYxaXM5?=
 =?utf-8?B?UFEvQXlFT0ZVMUc0U1M3cVR5azg4QTIyTEd5ZkZsZzh2RmxxdlFjQkhuUEFo?=
 =?utf-8?B?ODNGSFVyYkk0Q2VLMVlPaVIrbTk1L055bDZSL3NRRzVkZmR1czh4WDR4eDEx?=
 =?utf-8?B?dHlXLzFnOGtNbWVhNUtzeGZSQUtpVXkxbG04dDFQTzB0Z1RLZE5tek9nSXhR?=
 =?utf-8?B?WlcyNThLSVNmYmExb3JlWGVHa2RvZGhPV0F1UkV4YTByMkU4S0RDbmk3b2Rl?=
 =?utf-8?Q?c/1GegTX5LcRaFj06OeYcww=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0ZSRkNXTVpqOTdoamlhdEtsLzZ4TVRieUo2T09SZ3lSKzlhVWNKdlpJczc1?=
 =?utf-8?B?cU1DU3RZTCs3M1FRMElnYXdadEZMcmdqSmhGQ2swdlNKVlhnMU9zM1JhSEdz?=
 =?utf-8?B?M0d1RVVqU3pGck1LcUhyaFllTWVlOFd1b2JNaklrTnA2RlB3VU9FZ0hrdGlx?=
 =?utf-8?B?d0lxVENPR0NtaThUdkwzYWorY0dIUnVKT1ZacFB5VnNrdHYwanhveUp4MEZh?=
 =?utf-8?B?WEhlQmVPY08zYk5hYzRHaE16djFGUUNYRk5SYXhFVkdKK2lNc3h0emo1Rktt?=
 =?utf-8?B?Z0pZcEZnV0JUdkZWTWIwSVNETDljcHR1V1ltcFZ1SG0xZWhQeGo1Wjh6TlR3?=
 =?utf-8?B?NHBlaXpiMlpnTyt6MklnMlNFM2diMHhnWXlmcDI3NWl0aEw4MmJGQ3IxWkpO?=
 =?utf-8?B?MWV3Zk5oZURTTTRDS1hiTjRhSDdXR3NxYm1LZDFZR3NMVXduRzJteFo5cGF1?=
 =?utf-8?B?NzJ5Q1lKSXh4bTYwanlSczRtVWRLZUNwMWFmdGxtVHBqVnZaVUE5ZWlYeWI2?=
 =?utf-8?B?Tm5hVlN3aitvNG5KdHpBbVFxV0ZNcC9teGtTUm80RkY0YmVkZnIzazRub0xw?=
 =?utf-8?B?MG1tOUgzbm8vTW5SaklTMStOamNwM1c5bEVMbTVQTzl1cnpRRW1abWt4NWhh?=
 =?utf-8?B?UUo4UDRrMXAzMVd4d0lmMUpZTHg3dTQ3RjF3Q0M3U2VxaEpFRndSNm81dDhM?=
 =?utf-8?B?QjdFcmovQnZLdWJFcmtaMGZFTHJvclpuR1VwMTJlRFZubzQvTnJBd1pCZXhE?=
 =?utf-8?B?anpQRXVzRXh5NWVrOWRpdjE5cHcyQ2NvYnFveGJ1WTVETG52TGpmVEdwOEpt?=
 =?utf-8?B?WUR4ZnVGRzdLeTA2MlJsYWZzeWxFL2F3UEUyYVhsVFhVZlk2bm1DbW5mcjRW?=
 =?utf-8?B?V3RzU0hyek42OWJTUFkvbENLNk5GY0RmaTNBNEk5SGk3Qm9EV1lxRWdIb216?=
 =?utf-8?B?d3FidGZRMExjbmFvQ1cyRmxFUW83aGt2elltalJQU0Qrbi9FOVZTWlkrcHV2?=
 =?utf-8?B?eW5yTmtaQ3NhaDdFOXJ1SVRvUzF1Zzk3cHhmN1VPKzcrc3N3ZWxTc0tPWDZF?=
 =?utf-8?B?ZFV0MU43cGZvbjY2WTluTVo4QUJQanNxWGFzbDZqZkZ3ZDJyL0c3NHdCV1pw?=
 =?utf-8?B?OFU2cURmd0crQVl2dGhKU2Y3NjR2aUsxRlo1YjM4ZHNiaWlBME5wbURoaEg3?=
 =?utf-8?B?ZmRxa0E3RUVMSVNYQWtZV292dEJ4UDhhMzl0ZnEwcmVoTmRIaUpVTkRoem9z?=
 =?utf-8?B?QXlrVm4vMERDNjJFWlZPYmFUQkJleGMyMDBVL1ZDSXFaUGI3Skw0ck5ZVXZJ?=
 =?utf-8?B?NkJYSnZQNThKbDVMWEZkUk0xeTRnVVA3dmRSTHJScW9KdWpzL3NpMWNnQk4x?=
 =?utf-8?B?dHFFb2tpWDdweWVwSEJ5RHRkZWQ5amxiVDBueHRaV2g3akZVTCt1WVNmTng1?=
 =?utf-8?B?WFhISE9TVjI3WWpFUm5lalJNRldpLytLNW10bi9EamZGK3BYamxoOU16U09M?=
 =?utf-8?B?TW1rUkpJSW9DNGR5M1dWdnJXNy95Z1RKRHhORGo0OUhEWFVlNzNJVXNhd0JJ?=
 =?utf-8?B?ejhUV09sdzczQkdVelB1N1NCRTk3MFd4MTRLLzhpa0RwTFZQdHpJSEF0VGt1?=
 =?utf-8?B?K0ZnOURuR3R3c2wvNWhQeU4vT2tWMVM5M2w3ZWFEam40aHpDbXRwNmJ4d1Bq?=
 =?utf-8?B?Sm03RDdCQ0phQmxxeWg2MUZrZzBRRkhFZDEwNmdncFFhNUNjVjN6UHZqNG1P?=
 =?utf-8?B?MndRdWo5bHptQldHYUY2VW1CMUJhTFFRZHRHUU9adjFEOFdvNWV4QkxLMDBE?=
 =?utf-8?B?SURTY1A1RnhkdGdJVFI0dmZpaFRabUEvT3REdVRJUU1PSURuTDREUnhHVGxp?=
 =?utf-8?B?ME51M0hud0hWcFI0cHRRSlNIVkE2SHNTcGxWdlp0VS9jK3VQYTR0MEhYdGFL?=
 =?utf-8?B?QmJKUXNFeDB6SU4xK01rZ2NncDF3ZlBmMlBSb0diZmd2SEM0c1QxWHpKTjB2?=
 =?utf-8?B?YTJmT2g0V1BYODhOYmIxUkZqa1AwOXFFeEhxeTRPVm93ai9wdE5iVVZVeENL?=
 =?utf-8?B?ek5CYVBEOUhyYjAyWHdlTGpaQ2Z5U0RQVmVSa2wyaElQSEJZWmRkZDQ4WGt2?=
 =?utf-8?B?RllkMzB0M2QzMHU0RFVJQlFBeGh4STJSMkhhbEN1RzN1VmJ3WVBwcFdPU1hs?=
 =?utf-8?B?T3BQdmlCTHpvQ1pkcW5Eb3ozTzNCdHJPaStjUVF4WEpPa3huaDNrTGJUalNB?=
 =?utf-8?B?d3IzdTdkQkprNHhpUVF0cUh1WFFJUWJoWDRXb2tIZ0oyc0x0aXFGT2RSVzRh?=
 =?utf-8?B?REpreTZ5WTdOMXRQdlA5aGNvVG5IUTd4SHF3NGhFN2tVanFjQW9jYkhGTU1E?=
 =?utf-8?Q?K8RhjRVE4VGZ5D8A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A98D4A42C8EA0C469E11DD98B1E703AC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28762899-69be-4593-f0ad-08de63637b01
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 20:33:24.9786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bSAoRBrtsNe4C8rDSNPSTIR8vrSqC3GwW6u5ceLp2+kK+rrwKr96R1l4m/QKDkuFmI/irrD7QCmQ1BEn98k/1NXurnImFHOv0YoUVbaA8+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7604
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70084-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 42BE0DE852
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTAzIGF0IDEyOjEyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEUuZy4sIEkgdGhvdWdodCB3ZSBtaWdodCBiZSBhYmxlIHRvIHVzZSBpdCB0byBh
bGxvY2F0ZSBhIHN0cnVjdHVyZSB3aGljaCBoYXMNCj4gPiAicGFpciBvZiBEUEFNVCBwYWdlcyIg
c28gaXQgY291bGQgYmUgYXNzaWduZWQgdG8gJ3N0cnVjdCBrdm1fbW11X3BhZ2UnLsKgIEJ1dA0K
PiA+IGl0IHNlZW1zIHlvdSBhYmFuZG9uZWQgdGhpcyBpZGVhLsKgIE1heSBJIGFzayB3aHk/wqAg
SnVzdCB3YW50IHRvIHVuZGVyc3RhbmQNCj4gPiB0aGUgcmVhc29uaW5nIGhlcmUuDQo+IA0KPiBC
ZWNhdXNlIHRoYXQgcmVxdWlyZXMgbW9yZSBjb21wbGV4aXR5IGFuZCB0aGVyZSdzIG5vIGtub3du
IHVzZSBjYXNlLCBhbmQgSQ0KPiBkb24ndCBzZWUgYW4gb2J2aW91cyB3YXkgZm9yIGEgdXNlIGNh
c2UgdG8gY29tZSBhbG9uZy7CoCBBbGwgb2YgdGhlDQo+IG1vdGl2aWF0aW9ucyBmb3IgYSBjdXN0
b20gYWxsb2NhdGlvbiBzY2hlbWUgdGhhdCBJIGNhbiB0aGluayBvZiBhcHBseSBvbmx5IHRvDQo+
IGZ1bGwgcGFnZXMsIG9yIGZpdCBuaWNlbHkgaW4gYSBrbWVtX2NhY2hlLg0KPiANCj4gU3BlY2lm
aWNhbGx5LCB0aGUgImNhY2hlIiBsb2dpYyBpcyBhbHJlYWR5IGJpZnVyY2F0ZWQgYmV0d2VlbiAi
a21lbV9jYWNoZScgYW5kDQo+ICJwYWdlIiB1c2FnZS7CoCBGdXJ0aGVyIHNwbGl0dGluZyB0aGUg
InBhZ2UiIGNhc2UgZG9lc24ndCByZXF1aXJlIG1vZGlmaWNhdGlvbnMNCj4gdG8gdGhlICJrbWVt
X2NhY2hlIiBjYXNlLCB3aGVyZWFzIHByb3ZpZGluZyBhIGZ1bGx5IGdlbmVyaWMgc29sdXRpb24g
d291bGQNCj4gcmVxdWlyZSBhZGRpdGlvbmFsIGNoYW5nZXMsIGUuZy4gdG8gaGFuZGxlIHRoaXMg
Y29kZToNCj4gDQo+IAlwYWdlID0gKHZvaWQgKilfX2dldF9mcmVlX3BhZ2UoZ2ZwX2ZsYWdzKTsN
Cj4gCWlmIChwYWdlICYmIG1jLT5pbml0X3ZhbHVlKQ0KPiAJCW1lbXNldDY0KHBhZ2UsIG1jLT5p
bml0X3ZhbHVlLCBQQUdFX1NJWkUgLyBzaXplb2YodTY0KSk7DQo+IA0KPiBJdCBjZXJ0YWlubHkg
d291bGRuJ3QgYmUgbXVjaCBjb21wbGV4aXR5LCBidXQgdGhpcyBjb2RlIGlzIGFscmVhZHkgYSBi
aXQNCj4gYXdrd2FyZCwgc28gSSBkb24ndCB0aGluayBpdCBtYWtlcyBzZW5zZSB0byBhZGQgc3Vw
cG9ydCBmb3Igc29tZXRoaW5nIHRoYXQNCj4gd2lsbCBwcm9iYWJseSBuZXZlciBiZSB1c2VkLg0K
DQpUaGUgdGhpbmcgdGhhdCB0aGUgZGVzaWduIG5lZWRsZXNzbHkgd29ya3MgYXJvdW5kIGlzIHRo
YXQgd2UgY2FuIHJlbHkgb24gdGhhdA0KdGhlcmUgYXJlIG9ubHkgdHdvIERQQU1UIHBhZ2VzIHBl
ciAyTUIgcmFuZ2UuIFdlIGRvbid0IG5lZWQgdGhlIGR5bmFtaWMgcGFnZQ0KY291bnQgYWxsb2Nh
dGlvbnMuDQoNClRoaXMgbWVhbnMgd2UgZG9uJ3QgbmVlZCB0byBwYXNzIGFyb3VuZCB0aGUgbGlz
dCBvZiBwYWdlcyB0aGF0IGxldHMgYXJjaC94ODYNCnRha2UgYXMgbWFueSBwYWdlcyBhcyBpdCBu
ZWVkcy4gV2UgY2FuIG1heWJlIGp1c3QgcGFzcyBpbiBhIHN0cnVjdCBsaWtlIEthaSB3YXMNCnN1
Z2dlc3RpbmcgdG8gdGhlIGdldC9wdXQgaGVscGVycy4gU28gSSB3YXMgaW4gdGhlIHByb2Nlc3Mg
b2YgdHJ5aW5nIHRvIG1vcnBoDQp0aGlzIHNlcmllcyBpbiB0aGF0IGRpcmVjdGlvbiB0byBnZXQg
cmlkIG9mIHRoZSBjb21wbGV4aXR5IHJlc3VsdGluZyBmcm9tIHRoZQ0KZHluYW1pYyBhc3N1bXB0
aW9uLiANCg0KVGhpcyB3YXMgd2hhdCBJIGhhZCBkb25lIGluIHJlc3BvbnNlIHRvIHY0IGRpc2N1
c3Npb25zLCBzbyBub3cgcmV0cm9maXR0aW5nIGl0DQppbnRvIHRoaXMgbmV3IG9wcyBzY2hlbWUu
IENhcmUgdG8gd2FybiBtZSBvZmYgb2YgdGhpcyBiZWZvcmUgSSBoYXZlIHNvbWV0aGluZyB0bw0K
c2hvdz8NCg==

