Return-Path: <kvm+bounces-69327-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FmxE42peWl/yQEAu9opvQ
	(envelope-from <kvm+bounces-69327-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:15:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B32BC9D60C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC6A03016EE4
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 06:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768B4337110;
	Wed, 28 Jan 2026 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A51ofLJ7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F152ED846;
	Wed, 28 Jan 2026 06:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769580920; cv=fail; b=JH/fW4+yCNu8L99X1P8ryGU+neoMcKwUkP+7XCpm0+nr4/5c8+fCnBOQ5QgC45L5TGLfkSIhXr83/wX8eNVqAS1aqAZD6BiYLdgu1u1nscNaR7hf8B/GLGkUwTryXeafLBMqVKt8XRdEekFiiQYVf8QWo3fqf5lvOPmOr03desU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769580920; c=relaxed/simple;
	bh=87ObeyVC8+i80CYtU4hePXPdaWkAkhI9Og331j9mX6U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Om7GvJq9UywLDXdSBi4YUdAgXz+Jq1xIazyjJOjLFNR/sFXtsHcyOrsGffGtyE16eB704i7YTpuREePH6mUyfNGkZ+WVTk35cgJz9c0c+VsHZXW27pxj0VlsTrgPP/ORGKHXG77k6HHBZ1F/gj9ITrsdkWdrJxoQ38oL6WW+2zY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A51ofLJ7; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769580918; x=1801116918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=87ObeyVC8+i80CYtU4hePXPdaWkAkhI9Og331j9mX6U=;
  b=A51ofLJ7GBVSTHl1A6txJueM11sbDK/w+mPrU57K+qrYHyA1h1Q03WWv
   LVj2iMq/6pLNw8IW7rOrKKXLkF4qK+P2Ql1xW1xD34Gpu9X6nDtnNEsuD
   p6GOp1aDU8ihdiRBZkAa26uRrhhRmATSO8eH99GAgQXvNGRde69SJlxfV
   3vMzLP2CoRwdoUoVXv2of8APShm2EPvb9mMGxbYk6Na+bgqsgWX0C8OsI
   JM3/yvn7XWffWEW5n2ZKxRttkaLkQQi6+/GGQGIIJnj65EYWsl1FU/Fzq
   LCRvoJpNWtE9Z1vYcmKZocnsejHuODbw08ossrhCGVetTMv7a6NHxs3DQ
   Q==;
X-CSE-ConnectionGUID: E/1kAQHwR/+AasOLseyLYQ==
X-CSE-MsgGUID: 9VGmhy1zTlCmtb7kTk4XXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="81509104"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81509104"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:15:17 -0800
X-CSE-ConnectionGUID: 2MNAwuC6SvqvXjPQx4f3/A==
X-CSE-MsgGUID: GrvR9llXRS63w3YQVKXN8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="212280577"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:15:16 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 22:15:15 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 22:15:15 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.60) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 22:15:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vw8zzezgBG5ynD/lxWURZP7wfU7UFu1uhGTufNvw2bQIs34yeSJsCQha/bi6GDCTvaDuZxcdhsoqJ2Gd0Frodbkqg9ugmKOeQhj2r0wg2qTKraNn3QZGFOjhZ3CBduGbh8j5SDkC3d5IgVLwuWqo22068yCId5KLJYA2BN4KeEQxT47WIX/eCcKG+BRaVfqB4/dRg+SOqJx9GlJVrMqpKQgFUiDdb58j15f3lFZCwvZRh6/0BizAu4jmnWmdlvpsBvdoLvCJolxyuWEGLi3xdZoA+Rl4J9Ec5PjD0PxerOxWBNiw/m8ivb6ViVB+/nne9qz3JL8o/xUX3MOF28ZaMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87ObeyVC8+i80CYtU4hePXPdaWkAkhI9Og331j9mX6U=;
 b=vqsKlbR8WcQMxUxI/RrV8tVYc9G/h1RdujiGF/5HIfemCjKsAyBd4jpy135OXACgqhtIPAqxu31qMTzNqPgJI4IZ4Yd4E8Umvn142u30GIWmRJQnoEU2EkBlMWBPGkJgmsDiXFUbyT3ecKgYy2U/l5i/z5iGWDzTXLdxksBTYrFpiLZoMtsuYV10GiMujPUnZKZ3qyHDBL4lex1cCBpapKkoQGDlyhf3S0l/yleHz3aQx3uDw8FvIxsBd37l05squQiT8HV6szH1iQbaaIqQC4fMt445ulFzsjG7UihV4WFYZJjCFr+QGUpe+bkM1OKQD94GF2Xq+4WEcnm844LJQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA4PR11MB9081.namprd11.prod.outlook.com (2603:10b6:208:56e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 06:15:13 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 06:15:13 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "dwmw2@infradead.org"
	<dwmw2@infradead.org>
CC: "Kohler, Jon" <jon@nutanix.com>, "khushit.shah@nutanix.com"
	<khushit.shah@nutanix.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcjGf2hzr1Aefe/EG2AzLgdqhXDbVmiYUAgAALLICAAA1igIAAPvyAgAAYH4CAACjrAA==
Date: Wed, 28 Jan 2026 06:15:13 +0000
Message-ID: <62f9bdb9f3c7f55db747a29c292fa632bb6ec749.camel@intel.com>
References: <20260123125657.3384063-1-khushit.shah@nutanix.com>
		 <feb11efd6bfbc5e7d5f6f430f40d4df5544f1d39.camel@infradead.org>
		 <aXkyz3IbBOphjNEi@google.com>
		 <ea294969d05fc9c37e72053d7343e11fa9ffdded.camel@infradead.org>
		 <699708d7f3da2e2a41e3282c1a87e6f4d69a4e89.camel@intel.com>
	 <c7eab673dd567936761a8cc6e091a432b38d08da.camel@infradead.org>
In-Reply-To: <c7eab673dd567936761a8cc6e091a432b38d08da.camel@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA4PR11MB9081:EE_
x-ms-office365-filtering-correlation-id: 4cdfe48f-c775-4638-a413-08de5e3498fb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Z1d1WVJxbVRnYkthbGFSRVdTRlFiMnZ5TERkNVhkODAzbWwzV1FCN3hsSFBC?=
 =?utf-8?B?b2RqYUU5QjRIYVhSbGUzWVlJaTdOMHlmTHIvM0o5bkZmSjZSSDlUSUlEam9Y?=
 =?utf-8?B?bm90Sis0SDNORkQ2SUNYS2RQTk9LeG5PSzBwaWhNd3NVWURXZllTV2F0RXlj?=
 =?utf-8?B?YkJmYS82N0hMbE53NXVDTWVKalVUSFBWYXhMQVZZWGJ5eG9xZ0ZKMFFVOEtO?=
 =?utf-8?B?cDR4Rm50SFc0SUZkRDNjZkJONWJGSlhSTi9TNjRhOU9JNkxEV3F3aVl3WFZR?=
 =?utf-8?B?L3piRGdMU0UweDU3Q3luR3V6OG93bWpJTi9XTFVFSDRqN1dNYTI5OUZvcC9S?=
 =?utf-8?B?dUFtZGc3SE9VT1pIYTViaHRrYVd1ak96dm9leUF4MkE1dWhqOVRndXhVUWdr?=
 =?utf-8?B?OUFYQkliVFBVSXpjbUFSZ1pBOXhuQUlQa01vZXNEc3R6cG5hY29oY2pVak1y?=
 =?utf-8?B?Mkk4VEZ6UGVPZHdDRWZwK1FPTGU5MkdQUSszTm1WeWxIMU51MXZMZ1ZCVjJu?=
 =?utf-8?B?eHJNY0FUc2FXYTN0Mk8zOHArQTVnTmhjZHNUN2dvUnRuNVIxM2djRUdkNlR3?=
 =?utf-8?B?RXJCRHpwbWFMWExoS1d1WDBnV3lybjc5YzU5TUJJb1M2cjVRbFZ3RGdiTllP?=
 =?utf-8?B?NWdtb2dVYjExRUk2SDN0cC9abHZXMDdlVGdybng4Qzd6enVCNUVMcGtHdFlO?=
 =?utf-8?B?Sm05YWh4QlR6Q2Z3bllPN3d0cVpJNmUxUHBRQTJuWjhwdXBSc1cyT2RWTTRG?=
 =?utf-8?B?MFcvRThtUVVUSFNxZEsvUGtxM0dPZVhqZ3hQTXJYNFlLV2pOYVgzTnRVSDE5?=
 =?utf-8?B?V2xqQjBhZGUzYWdzbkIxWm1IdzVkMW1HLzZkZDJjN3dtV3VZWGFJYmY2U2NF?=
 =?utf-8?B?NklzVTY1NGtVWWxUUDVDMFU2b0tXUHZ5T1Q2K0pSNlJQVjN5QUtqWjBMRzk0?=
 =?utf-8?B?cENlMEw0djlZQXdwQmVPYzZHMkxCOGs3ZXQ2ejFZSktCbnUrSFhVQkxJRjg2?=
 =?utf-8?B?OFlBdVp2TVk3VE41dzZIa0xBT3RNekI0RU9PamxMVE1SeExKTmxTWDViSUdK?=
 =?utf-8?B?ZkZUWVhtdFRDWFg2ZktCQjgvakxrTXFiMjcxUWptZ2E3emM5bkdyRmN6SXg5?=
 =?utf-8?B?Wm1PV0l5RCtlRGM5bDFMWTgxaXUyd1ZDeFU5TnZaSGtpRmp0cURONm9NbE1G?=
 =?utf-8?B?U3loWGtZc25udUd4MWlwUGVyR2Y5Z08xNUtwS096NjlLSk92MHdLQTVXS0FJ?=
 =?utf-8?B?OU9xd25rQlp0dGlUWjZWZ3ZPdmxXZUxKdklaV2E5aTBhU1kvTVdPUXI5Mlpx?=
 =?utf-8?B?TDJHK2VGMVZHTldEMENjQkhJZGdxTGdyaTFweEhOR3hDTW11VU1KRFpROWtT?=
 =?utf-8?B?eVJISkMxSkdETExKZzg1R2Q1c05UTktycE5GQUJuQmpQTHdKaE1saisyeTZN?=
 =?utf-8?B?N0Nqb2sxWmFKSnpRdE9OSERNYjdiZ2ZBcDYvb3VSUi9XZUVtYkM1V3BFM2F2?=
 =?utf-8?B?aXdITDl4bHdNOVoveFV1cGlLTEtOM0JMQlBrWTkvanRsSmtjTi90S1hsNDdW?=
 =?utf-8?B?VGZEMFlrZUMreW4zaHZqME54RXI3OW9TalJCc3g4aFlaWFpMTkVxNjQzdmts?=
 =?utf-8?B?R3d5ay8zUDFHOHhZZGdhUVR2TmlKT0xFVnhGK1g0VW1VNmJKSE5GbVdhd0do?=
 =?utf-8?B?WGE4MGtpdFZkSFJuT3p0NEk1b1MyaXZkV3FxV2R1cW9CY3J5MVNUbUlQZkhV?=
 =?utf-8?B?M0VZNytTQmdVZXN6dmkxMTB1QVptR3YzTloza1NGZGgvRnhSR3duYmg1N3o4?=
 =?utf-8?B?czMvVGlNYWgxcy9zWFVIampmcU5zZ0tVd29oS0g1d1YxeC93T3c4ZitGYllj?=
 =?utf-8?B?OW1ZT20yTEpLQzhxTVdMZk0xYkUvclFnR2F5L3BsYXA3aUdNNnNuaTdkblhs?=
 =?utf-8?B?YXBIVFlMNDJ1Rm5hRGtQQTJMTldTT0I3RUM4OEdobllOZkxoVjJybnVVMnNi?=
 =?utf-8?B?ZGgwZW9DMk9vc2x3a2VZQWZnaytUd1cvNGN5bmI0enpBd1BqMFBlT3E0K3VU?=
 =?utf-8?B?emhHQzlNNzl6L2FPb1JCdUMxQmdKVjhlUTVraHFqdnF5UG96MTY0enVFc2U1?=
 =?utf-8?B?ZVI0MnZ2UzFhS1g1bnpXVlQ5V050MThiZ0QrWFZobm03OWV2N21PbzhvVFo0?=
 =?utf-8?Q?CfA5S9TGg5Svax2Gt1rSNQQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWd5U1FFOE5EcFdidnZ0N0RYY2hxdi9Rd2gzdS8vbTlVK2k2N0h6Rk1OelJZ?=
 =?utf-8?B?eUxOcGRmaGtoeGlqK0s2bmhmZVBaTEpGSGZudk9LSGNZK3VjWUloOEtSNitV?=
 =?utf-8?B?WDVzMGVCTkJ6QzNKTVFRamJ1UUJ0SW0rVDgvTlV3Y2lsNnUyZW5xZVJDLzdy?=
 =?utf-8?B?Z1FaL0UxdE5Dd2c1YWdnN2Qvcld2dDFCRklKRmlBNStTUGlPYmJlQnE1eXVI?=
 =?utf-8?B?LzRXU0JFeXUvQ2hFazZNc0ZjeTZ5MUV2RURkTERDVWFSSXZ3N2lONEwyWllX?=
 =?utf-8?B?cDV3MDFiSkpRNStTSmxUNEJkbUdzY1N5MmpiYkxvTFRBS0dRbzk0Zlh0bHlT?=
 =?utf-8?B?YjdyUWFxQm5TcFJOdXN6dDhuYTBiQnFOcEJlaUl3bzY3U24zRTlBVUIzSVZy?=
 =?utf-8?B?bk93SS9IRUd0bnY1YkNteU1pYlpnUDVzVHZESkFuK2E3c1N2cU5ITnJHck52?=
 =?utf-8?B?Rng2cFhHOWplWDl5dWQvR3E1WXZNQnh1TEJtSktkeEp3UUU4STN5TDFSWXFQ?=
 =?utf-8?B?cHZ2dGF1aWx2cWd5S1FxZXFmNlVONFBVMU11ak8wZit3eDJaOTg2NGtqU01T?=
 =?utf-8?B?TTB0dlJ3Mm1tNm9Cc01vUTdrdXhvcktUTkQrNUFsd0NCckM0ZktUS1FKYWxV?=
 =?utf-8?B?ZjJ1U1BWV0lRN1F5TUZ2clNtakVvQVpQQnlFWnV4eUNoRzBOc29FQ0dKYTYy?=
 =?utf-8?B?VnZDSVFVZ1BaaEdoMzJFN1h2M1RvVXBSK2xOcmZTb3d5akZYdm4xRnRPRFlZ?=
 =?utf-8?B?K0pLOHEyOEtYYnRLcVJWSjNNeEtQczNIdktySUxHZTZxdU9nd05FVFRrWlFm?=
 =?utf-8?B?L05sWFZ6LzAzTnpNem8vVVRxMmVxYVNydjYyMzZNWHpURmZTMkVFeGthYm0z?=
 =?utf-8?B?cExrRjBrMUJhcUpOV1BvWElneWs0dDQ0WFRXZi9TUmhkZ1hmWkRyb0dINnBP?=
 =?utf-8?B?NmpBNk5tTE43WGJYZ3MvWHhuQnJ5K2xNNnk2NmZydVZDYUJCTHQrd2V0c3pu?=
 =?utf-8?B?R1ZMZE1mVHNxaWpsMU9CeFlTM0xtQmNwamtqbjhIKzB0M2Z0MWUvMERrSU05?=
 =?utf-8?B?WUdOVlRRVFBrU3FSYnRKZjJSWTVTeUNhVUNLYXYxd0FGV1lLTTRDNk1uNzBU?=
 =?utf-8?B?ZExBMk5mZmUvRFo0dk50Z2c3TTgyY3RlbTRTRVMvR0ZWV2EwY0x3dTU3ekY2?=
 =?utf-8?B?czVkaU0yYjBHTTIxa0krVWM1RGZwdlZLcDVUQXJQdS9JZWJUcFdyVXdoTWVZ?=
 =?utf-8?B?aFJOWXhSeEYwY3lxQ3JPdmR6VUh1c3NGRWQ3VXljUktFbFA2NTRsTFFwWi9x?=
 =?utf-8?B?bXJhM1QzZGlUdGM5SzRTUjB3V09SU3FnY00vWmVmRHJJUENxQWJYUDRhZ1dx?=
 =?utf-8?B?S3BwWVR2WHhUakF5T1pYbTE1NUlreVA4Y0pzMFc2clFhdDRITDdRZnVxYWc3?=
 =?utf-8?B?cEF1YktLQUVzOG5iWkdWdzRvVlJhNjlGK0hXdTQ2WkZneGQrM2Q0dWMvUkIr?=
 =?utf-8?B?anNad0FuWlI5WmFSSTZXbzRibDFIZ1BjMWpJcU92bkpjR0dqR3dudHNuVmZX?=
 =?utf-8?B?b3Q2Z0Nxd1ZsWlpRRmxZT1FCUlNoVG9qMlVMRVFrdktURERNZjA1TEx0QWZs?=
 =?utf-8?B?WlBTVGRWMjBVbEVPb3ZFMnQ5aitoZldWaVMwYmJReXBwYk1EcHpPVmoxOUVT?=
 =?utf-8?B?TU5XRVpZR1BJbVpuQ0o3SUIybVN2aTVWeEthVFJLRi85d0RBalJsWFZvMXR6?=
 =?utf-8?B?Zk1NeEsvTWd0SitvSzM0aEZaVWk3MW9WN1V5NE04Wllodlorb29zanN1T2c5?=
 =?utf-8?B?d1Qwdk1hbjVMOENPU08yWjYzYjF4T3hUcnpjbzkyQ0FJbGtPM3MrRkRMSEEy?=
 =?utf-8?B?Qm5jZmdZWnl1MFpQTHppTzVRc3ByOTAxc3ZxcGxYNGNwM1QzZVNIZzhlNHVr?=
 =?utf-8?B?MG9PQzRaWld4QU9NcnhLUmFvU2Vzdk80YTdYVGNtT3B5Z1NqQkdDNDJuWVdO?=
 =?utf-8?B?VERXZElZa1J5Y3pOM2RISmltbGJWK3Q0VktQbnpSc2xpbEtFMGx4WXdTNnF5?=
 =?utf-8?B?MEREdlFtN3ZzaHJrTE5zaG9zT0x3TUdkWGlJc3pBcEFxcmFmT1FsYXpJUGgy?=
 =?utf-8?B?RGNibmxiZEUrU3ozaXcvTVcyak9SZDRoWmZRM2pvS3NPTmFIWnd3QUVneTV5?=
 =?utf-8?B?Mml3MzAzVk5GQWNJWGMvUU9LVk1ydmx2MEdkOW95bTJmaW5uUHVITG1qRFlM?=
 =?utf-8?B?RXc4cFVLK0VKaysybStCc1B6SjBnd3pjU0hndmthVGZJbVM0K0lPM2Fid3Rq?=
 =?utf-8?B?c2pqYVl2WjZnSzhmQStUSWxmejJwcDkwbytQWURqSnNGYmdUYlVMdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22F54911F631E6439B0F831F68D999EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdfe48f-c775-4638-a413-08de5e3498fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 06:15:13.1077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uHQnB3R/FFJBbl7DiZ3au4E/FHLyeGtgHsmKhYMNDnp+n33FTOP6aOseFU3PqOHNfEhvjdG2X8KYhssQIoXuhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9081
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69327-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B32BC9D60C
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAxLTI3IGF0IDE5OjQ4IC0wODAwLCBEYXZpZCBXb29kaG91c2Ugd3JvdGU6
DQo+IE9uIFdlZCwgMjAyNi0wMS0yOCBhdCAwMjoyMiArMDAwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiDCoA0KPiA+ID4gQWgsIHNvIHVzZXJzcGFjZSB3aGljaCBjaGVja3MgYWxsIHRoZSBrZXJu
ZWwncyBjYXBhYmlsaXRpZXMgKmZpcnN0Kg0KPiA+ID4gd2lsbCBub3Qgc2VlIEtWTV9YMkFQSUNf
RU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1QgYWR2ZXJ0aXNlZCwNCj4gPiA+IGJlY2F1c2Ug
aXQgbmVlZHMgdG8gZW5hYmxlIEtWTV9DQVBfU1BMSVRfSVJRQ0hJUCBmaXJzdD8NCj4gPiA+IA0K
PiA+ID4gSSBndWVzcyB0aGF0J3MgdG9sZXJhYmxlwrkgYnV0IHRoZSBkb2N1bWVudGF0aW9uIGNv
dWxkIG1ha2UgaXQgY2xlYXJlciwNCj4gPiA+IHBlcmhhcHM/IEkgY2FuIHNlZSBWTU1zIHNpbGVu
dGx5IGZhaWxpbmcgdG8gZGV0ZWN0IHRoZSBmZWF0dXJlIGJlY2F1c2UNCj4gPiA+IHRoZXkganVz
dCBkb24ndCBzZXQgc3BsaXQtaXJxY2hpcCBiZWZvcmUgY2hlY2tpbmcgZm9yIGl0PyANCj4gPiA+
IA0KPiA+ID4gDQo+ID4gPiDCuSBhbHRob3VnaCBJIHN0aWxsIGtpbmQgb2YgaGF0ZSBpdCBhbmQg
d291bGQgaGF2ZSBwcmVmZXJyZWQgdG8gaGF2ZSB0aGUNCj4gPiA+IMKgwqAgSS9PIEFQSUMgcGF0
Y2g7IHVzZXJzcGFjZSBzdGlsbCBoYXMgdG8gaW50ZW50aW9uYWxseSAqZW5hYmxlKiB0aGF0DQo+
ID4gPiDCoMKgIGNvbWJpbmF0aW9uLiBCdXQgT0ssIEkndmUgcmVsdWN0YW50bHkgY29uY2VkZWQg
dGhhdC4NCj4gPiANCj4gPiBUbyBtYWtlIGl0IGV2ZW4gbW9yZSByb2J1c3QsIHBlcmhhcHMgd2Ug
Y2FuIGdyYWIga3ZtLT5sb2NrIG11dGV4IGluDQo+ID4ga3ZtX3ZtX2lvY3RsX2VuYWJsZV9jYXAo
KSBmb3IgS1ZNX0NBUF9YMkFQSUNfQVBJLCBzbyB0aGF0IGl0IHdvbid0IHJhY2Ugd2l0aA0KPiA+
IEtWTV9DUkVBVEVfSVJRQ0hJUCAod2hpY2ggYWxyZWFkeSBncmFicyBrdm0tPmxvY2spIGFuZA0K
PiA+IEtWTV9DQVBfU1BMSVRfSVJRQ0hJUD8NCj4gPiANCj4gPiBFdmVuIG1vcmUsIHdlIGNhbiBh
ZGQgYWRkaXRpb25hbCBjaGVjayBpbiBLVk1fQ1JFQVRFX0lSUUNISVAgdG8gcmV0dXJuIC0NCj4g
PiBFSU5WQUwgd2hlbiBpdCBzZWVzIGt2bS0+YXJjaC5zdXBwcmVzc19lb2lfYnJvYWRjYXN0X21v
ZGUgaXMNCj4gPiBLVk1fWDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUPw0KPiAN
Cj4gSWYgd2UgZG8gdGhhdCwgdGhlbiB0aGUgcXVlcnkgZm9yIEtWTV9DQVBfWDJBUElDX0FQSSBj
b3VsZCBhZHZlcnRpc2UNCj4gdGhlIEtWTV9YMkFQSUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9B
RENBU1QgZm9yIGEgZnJlc2hseSBjcmVhdGVkIEtWTSwNCj4gZXZlbiBiZWZvcmUgdXNlcnNwYWNl
IGhhcyBlbmFibGVkICplaXRoZXIqIEtWTV9DUkVBVEVfSVJRQ0hJUCBub3INCj4gS1ZNX0NBUF9T
UExJVF9JUlFDSElQPw0KDQpObyBJSVVDIGl0IGRvZXNuJ3QgY2hhbmdlIHRoYXQ/DQoNClRoZSBj
aGFuZ2UgSSBtZW50aW9uZWQgYWJvdmUgaXMgb25seSByZWxhdGVkIHRvICJlbmFibGUiIHBhcnQs
IGJ1dCBub3QNCiJxdWVyeSIgcGFydC4NCg0KVGhlICJxdWVyeSIgaXMgZG9uZSB2aWEga3ZtX3Zt
X2lvY3RsX2NoZWNrX2V4dGVuc2lvbihLVk1fQ0FQX1gyQVBJQ19BUEkpLA0KYW5kIGluIHRoaXMg
cGF0Y2gsIGl0IGRvZXM6DQoNCkBAIC00OTMxLDYgKzQ5MzMsOCBAQCBpbnQga3ZtX3ZtX2lvY3Rs
X2NoZWNrX2V4dGVuc2lvbihzdHJ1Y3Qga3ZtICprdm0sIGxvbmcNCmV4dCkNCiAJCWJyZWFrOw0K
IAljYXNlIEtWTV9DQVBfWDJBUElDX0FQSToNCiAJCXIgPSBLVk1fWDJBUElDX0FQSV9WQUxJRF9G
TEFHUzsNCisJCWlmIChrdm0gJiYgIWlycWNoaXBfc3BsaXQoa3ZtKSkNCisJCQlyICY9IH5LVk1f
WDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUOw0KDQpJSVJDIGlmIHRoaXMgaXMg
Y2FsbGVkIGJlZm9yZSBLVk1fQ1JFQVRFX0lSUUNISVAgYW5kIEtWTV9DQVBfU1BMSVRfSVJRQ0hJ
UCwNCnRoZW4gIWlycWNoaXBfc3BsaXQoKSB3aWxsIGJlIHRydWUsIHNvIGl0IHdpbGwgTk9UIGFk
dmVydGlzZQ0KS1ZNX1gyQVBJQ19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVC4NCg0KSWYg
aXQgaXMgY2FsbGVkIGFmdGVyIEtWTV9DQVBfU1BMSVRfSVJRQ0hJUCwgdGhlbiBpdCB3aWxsIGFk
dmVydGlzZQ0KS1ZNX1gyQVBJQ19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVC4NCg0KQnR3
LCBpdCBkb2Vzbid0IGdyYWIga3ZtLT5sb2NrIGVpdGhlciwgc28gdGhlb3JldGljYWxseSBpdCBj
b3VsZCByYWNlIHdpdGgNCktWTV9DUkVBVEVfSVJRQ0hJUCBhbmQga3ZtX3ZtX2lvY3RsX2VuYWJs
ZV9jYXAoS1ZNX0NBUF9TUExJVF9JUlFDSElQKSB0b28uDQoNCj4gDQo+IFRoYXQgd291bGQgYmUg
c2xpZ2h0bHkgYmV0dGVyIHRoYW4gdGhlIGV4aXN0aW5nIHByb3Bvc2VkIGF3ZnVsbmVzcw0KPiB3
aGVyZSB0aGUga2VybmVsIGRvZXNuJ3QgKmFkbWl0KiB0byBoYXZpbmcgdGhlIF9FTkFCTEVfIGNh
cGFiaWxpdHkNCj4gdW50aWwgdXNlcnNwYWNlIGZpcnN0IGVuYWJsZXMgdGhlIEtWTV9DQVBfU1BM
SVRfSVJRQ0hJUC4NCg0KV2UgY291bGQgYWxzbyBtYWtlIGt2bV92bV9pb2N0bF9jaGVja19leHRl
bnNpb24oS1ZNX0NBUF9YMkFQSUNfQVBJKSB0bw0KX2Fsd2F5c18gYWR2ZXJ0aXNlIEtWTV9YMkFQ
SUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1QgaWYgdGhhdCdzDQpiZXR0ZXIuDQoNCkkg
c3VwcG9zZSB3aGF0IHdlIG5lZWQgaXMgdG8gZG9jdW1lbnQgc3VjaCBiZWhhdmlvdXIgLS0gdGhh
dCBhbGJlaXQgDQpLVk1fWDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUIGlzIGFk
dmVydGlzZSBhcyBzdXBwb3NlZCwgYnV0IGl0DQpjYW5ub3QgYmUgZW5hYmxlZCB0b2dldGhlciB3
aXRoIEtWTV9DUkVBVEVfSVJRQ0hJUCAtLSBvbmUgd2lsbCBmYWlsDQpkZXBlbmRpbmcgb24gd2hp
Y2ggaXMgY2FsbGVkIGZpcnN0Lg0KDQpBcyBhIGJvbnVzLCBpdCBjYW4gZ2V0IHJpZCBvZiAiY2Fs
bGluZyBpcnFjaGlwX3NwbGl0KCkgdy9vIGhvbGRpbmcga3ZtLQ0KPmxvY2siIGF3ZnVsbmVzcyB0
b28uDQo=

