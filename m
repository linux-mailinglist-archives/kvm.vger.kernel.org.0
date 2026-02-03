Return-Path: <kvm+bounces-69992-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAfnMG3ZgWlYKgMAu9opvQ
	(envelope-from <kvm+bounces-69992-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 12:18:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2759FD827C
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 12:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E564D30C3A29
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 11:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FF533469C;
	Tue,  3 Feb 2026 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h5s/8Wb2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BC127E049;
	Tue,  3 Feb 2026 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770117370; cv=fail; b=iqDfriXVdbMWt2S96MJJjkAjFe9ODJFvobjIB+SCtoUf5V9phidTxJpeBpZT8VnHZ0E9HC2asMNvSVpu3G2CGbovqEer+QVmFFs4/nFewFDZ6wjo7rTglMWh7WNeMRvkQ5+fD6bvWqapMvCxo6UsoiFIoqh+e/dpzXz5twoogsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770117370; c=relaxed/simple;
	bh=4+DbPOTJCKBILcThiP4/Fnz/rROH3b/F+0ZUqtfdxoQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kFjg54PaGEg4UJAEeg3WKW2nYZXqeelcY+LkbgN7SApgo88vDNQ5uctHWHaZWkcGL2xEv6ol/kADKiiUk/qQALtUjzBayqAXxcRL43CZpiRZJqy8A+JMDdiS/8Z3V7oKPivdWcav5V9wNCJCfzsO4Z9O2tRaKm8oWIk7we9FDLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h5s/8Wb2; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770117369; x=1801653369;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4+DbPOTJCKBILcThiP4/Fnz/rROH3b/F+0ZUqtfdxoQ=;
  b=h5s/8Wb2rlE9qi0fBI6w8ROESVLJDEj+CLfdwF3U2vo0819utUmp6IZN
   G3/VVHKVr+s/kms6UAihaVmvFXRUAF+QY8cxgl8ZFjxRpTgVh5KXkHpuQ
   OwXjUb03Sl+XRUmQrbHdpT2FIghOPEHI1gsq04q0V+DmQGU+I6KiXoTYy
   OuWfg7zwgh/ft9J4yy2HThXBjh+7QbaYiyg3JbnthVzfbi11XcqXLBBrU
   7Gj6qq51Rw/9g/ewbpvuaem9D9C7Gt0fNYZiQI6DBDNaQvNbYJ73RFXas
   Ea3IaS+zshFIkB5qRa1XlbiLnXBdh8Idk9UEI9PtiK94+x9uiyCOUzi3F
   w==;
X-CSE-ConnectionGUID: k9Jux44ETee9mGCtSc/GHw==
X-CSE-MsgGUID: 3zqDETCbS1SzKbtBtS1DGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71447721"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="71447721"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 03:16:09 -0800
X-CSE-ConnectionGUID: Mukgp9AfTD+NKdb/GAWqFA==
X-CSE-MsgGUID: PDpF313KQimtirI+ddnNUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209935145"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 03:16:09 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 03:16:07 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 03:16:07 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.31) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 03:16:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrVq9m5r1HW1MhlIYV9ohqmDL2N6nC3z2xO/opaCYeBSBauXYrd686MpyDqwW+L+Y8/UAvsLReho2EFmvtjZINc5fz9GXiOBPcODyFhbkA7XKXr/uYLT9xGvXNEStoW04oLQlRt0Vm1ixXnlw8zhymRlZgxDYpOU6jMKXrKPZFk5pe+LUabhKG9hz+1ujTIMdvvd/Arr1rwmtXWu5ZkGHkbPetOKwIgi3A2xL0VhEsj9QImOSfydiqxFHoQ2nmh4YfWexcuFsb6AbcVHa+Yb8uOcGAK89vQpmmqMTLCR0CylH/0vWouqu4fXE/P1aruA1o9o7BokXf/xATBn3HbK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+DbPOTJCKBILcThiP4/Fnz/rROH3b/F+0ZUqtfdxoQ=;
 b=NU9XZHgtrKklPIruEN/GhJJqLfFUSacZkQoALNl+Fjx5BpnoOuOK2EG1FQ/4uJ6VnEBf98J+F3GoeBIK0SatrasuA97Nbab3MrJaAe8GLwys3/l5Xwb1oVwGGnmL2caxJne9TG0U1wUHzzdYVks63Bj5rSvCnlBlmeIAqkS1aS/JuOwhTWULJQnXV6JrFoIRoPna/GqdGloMkrIcI2k0bTaFlE2HUOBK44IdsDj30DOXFnpbko2KNTUWg9p4+xM6oueQc3LIUSb+hE6qwZlW00eXOZH8f9lGtm3admw4LOl90f4VFILQFpDnATFWw9XLwzBuqxDXxxmXHBQx0TC5tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by PH7PR11MB7025.namprd11.prod.outlook.com (2603:10b6:510:208::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 11:16:03 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 11:16:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Thread-Topic: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Thread-Index: AQHckLzhSspC1sJAD0G07NT4Ge5PXLVw23cA
Date: Tue, 3 Feb 2026 11:16:03 +0000
Message-ID: <4fae16cdcc368d33f128c3a79c788b905b83ffe7.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-21-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-21-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|PH7PR11MB7025:EE_
x-ms-office365-filtering-correlation-id: 9111631f-242e-4a61-4352-08de63159e79
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aTlHYkxZckUyTExLZlZZUDZRZDJnWW02MFM2dTU5Z2JlK0lwMHFIeERoZm5z?=
 =?utf-8?B?cVYvRk1oWVp5SThNd25PWmVya1pBcnAvZXROUFd1cjRINEYxaEFZTGxEdGVm?=
 =?utf-8?B?NTRvT2JqK3RXQVBIb0Q2ZGFDVUt6NnQzZ1RBRm1pbXc5TVpZRHFwazRkNmJG?=
 =?utf-8?B?MFVzYmptRU5hMEhSdWpyUkVINnJUL3VzY3BLV3k4c3ZqVS9ZTnJ2K1VQUnlj?=
 =?utf-8?B?dDUrZUNzNGVnbFFvMXdsbDJuTVJIMDB1OW1NQ3FmdzcraU5zR0ZNUW5XVzU2?=
 =?utf-8?B?SzlNWGxrSWxUNFJOYWpHQTVLVTlqYzNtdU5xczhXazVsc1p2ZDhPM2ZrZE9h?=
 =?utf-8?B?ODlCeEZybVdiMkFsSDZJMHZDQUhHSDBpZW4zM0lkV2ZxZ2E2L0hxakdnbVVF?=
 =?utf-8?B?ZiswZW8yK010em5WVTdjd2E4NjlXMXFtR1NKK1BqUVZzcmxTR1phOCsrRlFU?=
 =?utf-8?B?R2t5RnNXeWU1QnVhRW1WOVJ5TWRDODcwMmJCWm9sMUxJaDlMRW9TMDlCY0Uy?=
 =?utf-8?B?WEJJR0p4N2dkUFR6UUtWNFMwTDg4WklzcGNTRGtGRnZ3aGdzVFZqdDlydXFQ?=
 =?utf-8?B?QVU5M3dwYnNNUzNvL29JcDhEY3hMWUFVQjlMdVNOTVhEUVRJZ1RJSzNsbFF5?=
 =?utf-8?B?Z3hheU51ZUpVM2tBbmhyUDV5eUN5V2liUDk2N0QzelZJZVVIT2Z0UjduQW5k?=
 =?utf-8?B?N0RuSTM5SzU5MGJyMnZ3NjBvcyttY2tqS0Y5bXFRb0VIWnMvcFdMOUdOcS9S?=
 =?utf-8?B?SGk0Um9BTkdOVXZpYXoybENVV2RzTWFkTjgyZjJQS3FncEdBcXpmMHJTbHlE?=
 =?utf-8?B?Wi9GbWtvR0gxV0lLay9wa1V6WGFkZk1LeXBkdHpMb2RmOXNobnFZT0tqR24y?=
 =?utf-8?B?a0p1YkxqbWVGdVNMSVhGeHY3enVVcVoyRUR2VzZXdmIySkdXaUo3S3VXSEd6?=
 =?utf-8?B?Tk1ja1RCcSt4cjR4MFdnZFVoeUk4WmZZQ01MakttbU95SlQyMXc3bU5vVVNn?=
 =?utf-8?B?NzNFRlBHVFBaNWRrTTJjQStPdFRXTmd2TUVxRmxybHVsTVpubCs0YVlUdysw?=
 =?utf-8?B?Um5hYmJoM29UelBCUUhLdis3a1R5OU10NHpyem1rc3B2c2EwZEVtU2x6QVln?=
 =?utf-8?B?MnN6TnVXclEwajg4T0xYRlRpeVNJekMxelcwMU9uYnFPalc3bWx5cEJxVDVL?=
 =?utf-8?B?WnNaVk1qOTNjUE9rdElmcWtQQVZNRFY5TGNVK0owL245MVJwS01LclAwR3JD?=
 =?utf-8?B?VEtvV2JuVTNQd2srSVFFTTlEK09hL2ZqdFlDS0Radmo3T0tSOVVjaXZ4dUxj?=
 =?utf-8?B?bFowdStUVGlFY3VaNm5ENXpLMDkvU2Q4dEJsendzNXp2aWlhVGxiQVV4QzlP?=
 =?utf-8?B?Vm9WZ0E3b3pibWc5QlhQanQvWVkycW9ocThKYWFJeWlORHBqVHhseFhBRWRB?=
 =?utf-8?B?SzBsdTArbllhWGFjeWp0b2d3cVA5NEFJazBrd0ZXZ2owK2U5TkpyK001ZUZa?=
 =?utf-8?B?ak9PQll1aTh6VUF0VkFKZUxVV1d6MGFqTXZqTmVmQnlWQWdjb1VmWk5MWXNC?=
 =?utf-8?B?ckp0MWgvVTlmSUp1TDZ2d3Q5MHpZWEZnYmprZmJsMVl6Rjh6VE5UOGdtaWJ5?=
 =?utf-8?B?Q3A5N2JGZ3RiTEs3d0RJQkUwemJtNElSSm96UTF0Ynh3T3pGcEJTYTJiN2xk?=
 =?utf-8?B?SDFDSEJRbFhaVk5UVllHU1BCaWlQcDhqTnU5N1hmMFlmWEczVlYya3RIaWpk?=
 =?utf-8?B?WVJyTk85c1JNYi9XeFRXeHRyQ3RhdVZvOE9LeXNSRk16bCsrT0NHb25EMFdz?=
 =?utf-8?B?Y2FWd0s0MHVxWVlKZTRjTk92VWt4b0FwV3N1QnorSnlhOVgvWjI5Z3dtWW41?=
 =?utf-8?B?blZTczY1UFlVeUk3RC8vU1NuT3ZZTVBETHRLM21FckVMZ3JlNmdzOEFLbW40?=
 =?utf-8?B?M1cwYVFYSGZzdVF3L2g1UGdIek1DaGp6QzYzS3RpY3ZVVkhBWlc1dUdlVEg1?=
 =?utf-8?B?OXV5aitWQ0J5NFUvSE84cE1TbmVCUzdRb2xYT1A0SkdNN1l2S0l6S2krVXlU?=
 =?utf-8?B?dEpvWk5xOXU4UUhSRTErbTRTajd2a2orZGdBcFFUTjFpRFBrMFBRK3pCeVpX?=
 =?utf-8?B?NVYrencxWHRKQjFKV1Mvcm9FQXBKdk8xSklSQXNXQUFja0Vobzh6MllkMWRj?=
 =?utf-8?Q?V1EE8b5Amk+0OJcnf34lUpQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1hrRnI3bDI0Q2R5NUQzL2NIU09GMDMyOFBqMkJaYVA4WmxpVzlOWkNHN1By?=
 =?utf-8?B?ejVaU28rZEU2TzR5UWJqekV1ZVB6Sm1kemFNQzJXUklRNXFiNFpVZWVsRm1P?=
 =?utf-8?B?WGlBb2VTMWVNd1dHc2R5VC9IeTRkdUk0OWdMaHhmY0tGcnduZHZHVW9MYXlh?=
 =?utf-8?B?MHE2dWo1WFpOOHB5aU9kOUxJK3BRaWlCbStYUnJMdW9KaUQ3QUVpTkV6QWEy?=
 =?utf-8?B?WGhDMlo0UjdFQUZGVzRzLzMxd1ZuNTFnQ3lLWUZramcyZjJUQWxnVUlXbmxG?=
 =?utf-8?B?RkRXOW0zYWtQK1V2M3k2OTBqQ3o3Vk5vc3UzU0JPWWFZeUlybGhFUVJjR1N0?=
 =?utf-8?B?bDhsUWp2ckd4RXV5RC85alFvZU1NTVJKV1dMbG1KeVhLWnR6VG9NK09LaEpD?=
 =?utf-8?B?eE5tZWxGVnBaWXhTSVlqdU9tV1ErVGJEdEloMzlUTzBEVGFqWG85U1dybWdV?=
 =?utf-8?B?dHlpV1NsaFh1K3VHRjJpak5EdGxOMktFWjFGWmdrKzZXaXY1RFJ4RUVsNUI0?=
 =?utf-8?B?b2kxWUhkMlprNUpUVnZlV3ZzZXl5NTRmNVpzNTFoelV2bzl4UnArdkRHbmNr?=
 =?utf-8?B?Z1FBSU1VeGY4bUNhLyt5b2FDQ1pIMW9WMkpIMXZLMjhPZXdETzVKb2ZBZFJU?=
 =?utf-8?B?STRLNms3Qi84cXBCMXVpZWovelA5Mmg5QVJ3b0pvSlhtVTdFTUhuT2pVMWRt?=
 =?utf-8?B?ZDhPdE1ZSGtXOGg2djd0enVwZG9BMjNNY0JGS2w1N292aFlrK3RFR0RTMlE0?=
 =?utf-8?B?ckNOOUk1UjFwR0RIMUdRNFJqMGVhZXFVNkhXNUkySTRXUkxTVlFQTEFIY0g2?=
 =?utf-8?B?WEQ4TzZiZmlsTzRhTU5iWUVIVnAvL2NTdVRPbWp4ZkIrQVNzNmc5TjRpMVVN?=
 =?utf-8?B?Z1AveWc0Q3krQWdBV3pURUVJYVNoY3pIQjBIRlJVUkJGWm1tRktjT1RoTmhk?=
 =?utf-8?B?RmdGeE9CMVE2Q2RBL3ZIbDZ4RDNadVUraVlTUGNDVE1jVTByZmdRYjZkdmti?=
 =?utf-8?B?L1RVQktHVGFIM0NITjN1WDFjMFRtdFFrVWxTLzE1RjYzZ05vK2NYMmM4akE3?=
 =?utf-8?B?LzVad1A1NnBuQ0g4bXJZczkxeDR0ZTI0b2ZYTFBhdEVaZ1NnZzhMVEFxSWpm?=
 =?utf-8?B?UUhjajV0V2tlR1BoYVprUXZmeFIxSG51T1hCaGx6R0FHQ3Y1OTVXTEtHVGZp?=
 =?utf-8?B?SC85YU5qS2R5Q3hEcDVoc0E0bi9DYm5oRnNWWGQ4U0NYMm16ek1HVEF5TWsy?=
 =?utf-8?B?dUtmYm5TcE1OMUtyaG5iTzJYZitpZHNMTkhrVTlsRjVGQjRncmlFRUhDa3g1?=
 =?utf-8?B?bHB2VUlxNDhDcVlWaXI3ZnhsUFZzZ25wbVBkcXY1clU4ZTVCSFNEMm9oL3FJ?=
 =?utf-8?B?UDlGZjdjaXJXMldpbWVWams4RVI4N2lGV0VVSm1oc1huaGFpWjNVN25BbzBW?=
 =?utf-8?B?NXRPdHVZajE0QzBxV2NWbXR5VTMxN29tVUwvSTBSQU4yZ0QwTEpPQktnWTg2?=
 =?utf-8?B?YnFPTUhHYXZmRHZ1N2Y0S0syZFU5YitOTkM2YzNuN3p1TDBydXZzZnJHbUpk?=
 =?utf-8?B?UFNHS29DT01KRXVtS0NpbWxhUDM5T0hIZ1h6eXRFTWRPdVcxc1BIMExxM0Rl?=
 =?utf-8?B?L3R3THV3NWJqZzBNQllERGQ5QUM5OHRtbHdoYisvK1htaXBUbSswVFBmVXNT?=
 =?utf-8?B?UVFzNW03aWVtWFBxdlprUlVuTEVmdUxQdWFHMGhqbzh3UFd2eFlTekRXUGd4?=
 =?utf-8?B?RGdIT251MUJHTCtQOGg5T2QwMk9Lc2RSZytzRjBLMkZKMEtsdVpRaFVIcGE5?=
 =?utf-8?B?S1VNdzBCaUhkcUVTZzJndWdmYUVITGNvK1Bsa3pGQ0YxdHJ2MmxhdG8xSkJ4?=
 =?utf-8?B?WlYyUG94V3JGbmdhS3MydDdxK2RUOXdkaDd3TlBWN1RqMEJaZ3ZsU3AxMTg0?=
 =?utf-8?B?S1VnWW5xMEN1aVhPOTA1N2Q2R2wzMUQxaEQ2STJUOVJ1V0xwUWhJeWdCRHp1?=
 =?utf-8?B?ODQ2MjdmL2Z0TGtkczVxb1ZSRm5Ud3hJb0hkbHA4Q0xCdHJyQ0pxRnBiN3Rs?=
 =?utf-8?B?cnBXUzJMc25LaGZzRDFQL3U1U1BZTUk1cXd3UDY3UXpYNE0xbVduNGU1S05t?=
 =?utf-8?B?SFRETm9POGIvQjliWTZ6K1ZZSzVwOWxKU1hGeXBBSTlaSjVFeWRjYlJLaWZ3?=
 =?utf-8?B?aGF3eVVyU2lYN0ZFTzZHL0gvb1l6Y2tHOEd6bnUvajdUNHFmY0ZiU1J6NkYr?=
 =?utf-8?B?T0RRK0kxM05wQW9aRnZaK21KdndKU1NJTE0vS2VDOXkyeTNuTElscWg4OFlm?=
 =?utf-8?B?eFdwNHgzejRWamhnT1RUQW4yNXlCU2E0WUsydXZJSDhrNVlyaGZXZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BAF410F5A1E624DB9EBE4089DA7712D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9111631f-242e-4a61-4352-08de63159e79
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 11:16:03.6971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wTDyOcY570z6pzjjmh+in4L7LIDhkHF4lAeusK7KQbzdZ6IZVFAXmvhIsrE4Oro+lOpBPY3hCfqnxuor50LAcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7025
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69992-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 2759FD827C
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBOb3cgdGhhdCBrdm1fbW11X21lbW9yeV9jYWNoZSBzdXBwb3J0cyBjdXN0b20gcGFn
ZSBhbGxvY2F0b3JzLCB3aXJlIHVwIHRoZQ0KPiBTLUVQVCBjYWNoZSB0byB1c2UgdGR4X3thbGxv
YyxmcmVlfV9jb250cm9sX3BhZ2UoKSAoYXJndWFibHkgUy1FUFQgcGFnZXMNCj4gYXJlbid0ICJj
b250cm9sIiBwYWdlcywgYnV0IHRoZXkncmUgbm90IGd1ZXN0IHBhZ2VzIGVpdGhlcikuICBVc2lu
ZyB0aGUNCj4gVERYIEFQSXMgd2lsbCBtYWtlIFMtRVBUIHBhZ2VzIG5hdHVyYWxseSBwbGF5IG5p
Y2Ugd2l0aCBEeW5hbWljIFBBTVQsIGJ5DQo+IHZpcnR1ZSBvZiBhZGRpbmcvcmVtb3ZpbmcgUEFN
VCBlbnRyaWVzIHdoZW4gUy1FUFQgcGFnZXMgYXJlIGFsbG9jYXRlZCBhbmQNCj4gZnJlZWQsIGFz
IG9wcG9zZWQgdG8gd2hlbiB0aGV5IGFyZSBhZGRlZC9yZW1vdmVkIGZyb20gdGhlIFMtRVBUIHRy
ZWUuDQo+IA0KPiBJbnNlcnRpbmcgaW50byB0aGUgUEFNVCBlbnRyaWVzIG9uIGFsbG9jYXRpb24g
ZG9lcyBtZWFuIEtWTSB3aWxsIGNyZWF0ZQ0KPiB1bm5lY2Vzc2FyeSBQQU1UIGVudHJpZXMsIGUu
Zy4gb25jZSBhIHZDUFUgc3RvcHMgZmF1bHRpbmcgaW4gbWVtb3J5LCB0aGUNCj4gcmVtYWluaW5n
IHBhZ2VzIGluIHRoZSBNTVUgY2FjaGUgd2lsbCBnbyB1bnVzZWQuICBCdXQgaW4gcHJhY3RpY2Us
IG9kZHMNCj4gYXJlIHZlcnkgZ29vZCB0aGUgY29udGFpbmluZyAyTWlCIHBhZ2Ugd2lsbCBoYXZl
IG90aGVyIGluLXVzZSBTLUVQVCBwYWdlcywNCj4gaS5lLiB3aWxsIGNyZWF0ZSBQQU1UIGVudHJp
ZXMgYW55d2F5cy4gIEFuZCBfaWZfIGNyZWF0aW5nIFBBTVQgZW50cmllcyBvbg0KPiBhbGxvY2F0
aW9uIGlzIHByb2JsZW1hdGljIGZvciBtZW1vcnkgY29uc3VtcHRpb24sIHRoYXQgY2FuIGJlIHJl
c29sdmVkIGJ5DQo+IHR3ZWFraW5nIEtWTSdzIGNhY2hlIHNpemUuDQo+IA0KPiBTdWdnZXN0ZWQt
Ynk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2Vh
biBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkg
SHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNClNvbWUgbml0cyBiZWxvdyAuLg0KDQoNClsu
Li5dDQoNCj4gIAlpbnQgKCpzZXRfZXh0ZXJuYWxfc3B0ZSkoc3RydWN0IGt2bSAqa3ZtLCBnZm5f
dCBnZm4sIGVudW0gcGdfbGV2ZWwgbGV2ZWwsDQo+ICAJCQkJIHU2NCBtaXJyb3Jfc3B0ZSk7DQo+
IC0NCj4gLQkvKiBVcGRhdGUgZXh0ZXJuYWwgcGFnZSB0YWJsZXMgZm9yIHBhZ2UgdGFibGUgYWJv
dXQgdG8gYmUgZnJlZWQuICovDQo+ICAJdm9pZCAoKnJlY2xhaW1fZXh0ZXJuYWxfc3ApKHN0cnVj
dCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgCQkJCSAgICBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpz
cCk7DQo+IC0NCj4gLQkvKiBVcGRhdGUgZXh0ZXJuYWwgcGFnZSB0YWJsZSBmcm9tIHNwdGUgZ2V0
dGluZyByZW1vdmVkLCBhbmQgZmx1c2ggVExCLiAqLw0KDQpUaGUgYWJvdmUgdHdvIGNvbW1lbnRz
IGFyZSBzdGlsbCB1c2VmdWwgdG8gbWUuDQoNCk5vdCBzdXJlIHdoeSBkbyB5b3Ugd2FudCB0byBy
ZW1vdmUgdGhlbSwgZXNwZWNpYWxseSBpbiBfdGhpc18gcGF0Y2g/DQoNCj4gIAl2b2lkICgqcmVt
b3ZlX2V4dGVybmFsX3NwdGUpKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLCBlbnVtIHBnX2xl
dmVsIGxldmVsLA0KPiAgCQkJCSAgICAgdTY0IG1pcnJvcl9zcHRlKTsNCj4gIA0KPiArDQoNClVu
aW50ZW50aW9uYWwgY2hhbmdlPw0KDQo+ICAJYm9vbCAoKmhhc193YmludmRfZXhpdCkodm9pZCk7
DQo+ICANCj4gIAl1NjQgKCpnZXRfbDJfdHNjX29mZnNldCkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMgYi9hcmNoL3g4Ni9rdm0v
bW11L21tdS5jDQo+IGluZGV4IDM5MTFhYzliZGRmZC4uOWI1YTY4NjFlMmE0IDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11
LmMNCj4gQEAgLTY2OTAsMTEgKzY2OTAsMTMgQEAgaW50IGt2bV9tbXVfY3JlYXRlKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCj4gIAl2Y3B1LT5hcmNoLm1tdV9wYWdlX2hlYWRlcl9jYWNoZS5rbWVt
X2NhY2hlID0gbW11X3BhZ2VfaGVhZGVyX2NhY2hlOw0KPiAgCXZjcHUtPmFyY2gubW11X3BhZ2Vf
aGVhZGVyX2NhY2hlLmdmcF96ZXJvID0gX19HRlBfWkVSTzsNCj4gIA0KPiAtCXZjcHUtPmFyY2gu
bW11X3NoYWRvd19wYWdlX2NhY2hlLmluaXRfdmFsdWUgPQ0KPiAtCQlTSEFET1dfTk9OUFJFU0VO
VF9WQUxVRTsNCj4gKwl2Y3B1LT5hcmNoLm1tdV9zaGFkb3dfcGFnZV9jYWNoZS5pbml0X3ZhbHVl
ID0gU0hBRE9XX05PTlBSRVNFTlRfVkFMVUU7DQo+ICAJaWYgKCF2Y3B1LT5hcmNoLm1tdV9zaGFk
b3dfcGFnZV9jYWNoZS5pbml0X3ZhbHVlKQ0KPiAgCQl2Y3B1LT5hcmNoLm1tdV9zaGFkb3dfcGFn
ZV9jYWNoZS5nZnBfemVybyA9IF9fR0ZQX1pFUk87DQoNCkRpdHRvLiAgTm90IHN1cmUgdGhpcyBh
ZGp1c3RtZW50IGlzIGludGVudGlvbmFsPw0K

