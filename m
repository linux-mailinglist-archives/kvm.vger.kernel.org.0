Return-Path: <kvm+bounces-46952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 004C0ABB44B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:06:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9163C172FFE
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 05:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387EC1F12E0;
	Mon, 19 May 2025 05:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0+5mpZb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4541E9905;
	Mon, 19 May 2025 05:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747631200; cv=fail; b=CY5EFawz+FIDGlxOdnOy7ycOOuIDFDhmXBafnSUI5xpKLo1Vsg4p1C7STBuT9LII7iMHQVMk1TxKRfLjJheYxdc0fpy0CkoCwcdX1aXIu2lAj87CAK2Ip3KBSB/05p/i2ua5DhvLAA8bstCId2IrslS0aG7styR13rfa2OtIGFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747631200; c=relaxed/simple;
	bh=7rJkAJf4FSMFI98d5GtYe0ywXtkKZlV79UqismkjYkQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O5NWp6fxXMN/DqiGEF9g0XJjTP6X57o4wn/VBajIQnU4NUD7HqmgLBq07HhIzpgZt0jXVivHys603onE5vu3OksaV8bIh5jiU7REvtTV2EnszG63AQ9ROGO13Ku0DlEC31rcs8oPZEVqnFK17lwLqiMp6rFJav7WhVNYVBXVqqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0+5mpZb; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747631199; x=1779167199;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7rJkAJf4FSMFI98d5GtYe0ywXtkKZlV79UqismkjYkQ=;
  b=J0+5mpZbQHURDHw9cWnzaGALrD7Q6bsbLdkN5bS7nUMRHbdMBimcReG3
   xcYiub+83W9UYzpUHMNwMGsYI2HJOie5Syh1dHijl0KbbNDPCrNVHHuph
   Iz1zCP7x1AX4A48x78trdnWeuJjHXdXixTacJvabZV5CCgS9/+OS5PS9T
   PVxxAsVq4XYejhG3JBytSaX23iux+kq1MsGyRVWUqGrjASbDtgXPjJ2LC
   Rv1lZ2HjSrw6fzCphqem7U0dGvFw8uIZaeMWYbN40cNK2CIxOVKfhupGZ
   Nqx8FW36UNq+TofqjdSiLLkVus0pery7tJNQHa9UIqexJ04ndXvnY1tmc
   g==;
X-CSE-ConnectionGUID: p1E5Ypo6SEK/rR9S1JU0eQ==
X-CSE-MsgGUID: FPbok1giRWKgRvU5gkdyig==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="60858929"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="60858929"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 22:06:37 -0700
X-CSE-ConnectionGUID: CNNnuINbQY6IPjzx6EfDAQ==
X-CSE-MsgGUID: RQhmEyA3TC6O01cT2Ve4jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="140278299"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 22:06:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 18 May 2025 22:06:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 18 May 2025 22:06:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 18 May 2025 22:06:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAKJpj8rCCYdiMloTlX7FpEk+VQDFjVuIBnfYyEHu9lijkU7ebrSW3975IFmSdv1AWhBRQE3PklDGKxUT9i20cMayC7uDe+pY0hKuzY3bunl47v6+FNUYwF6vhs+PIteUgwyc6KQGOqbIqXSUixOBy/gsrCQTxlG2QKFrj8gCNRrkBeVH1N5R31uH0ZKaQVQ2U33nWq99cLKQF6UGI8VN8gIx8cl+xbiuMSkmhlFrKg8Yq2PZvWm1kgdNdq0htPeUJ8388GrC4jSjIAeMxLnhfU1Ib346RJEEvR+4Cf01nwYZAVKdo3MxrMHNJ0Bnsgva7Bt9FL93uYC53ux4eD/Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rJkAJf4FSMFI98d5GtYe0ywXtkKZlV79UqismkjYkQ=;
 b=OUm2lWep9H9Ogge/4P6bTPY/oG5JcBp+rsfWd9oPHD3pIBljufr7xl1Ywd+sTtqFSznSTGL6XjngUsKcJnj8H2HnZKjPYpHiff6VeM/uz22QD/f5Mh2a2JLZoFvOqkejQ+CXxkF0pTi1OzlMHrCwfUVXVMROeogC4ZtioAg0QhQemMl3X1BmupSNMwdsyYEE6VnTzS1QineoOdUCmKlHj9UPvJgLhPcwWBgOY6AYxwTIU6z8iT9jcXhGZ/DOedZSKK0V2I5Q9v48jOBbIdmIwGptAtMzvRZwrBqzky2smtLAR/y9NC7mD+ouI62n5oJng5s2YdjCGRA2ZDBWPDAiCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 05:06:02 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 05:06:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>
Subject: Re: [RFC, PATCH 11/12] KVM: TDX: Reclaim PAMT memory
Thread-Topic: [RFC, PATCH 11/12] KVM: TDX: Reclaim PAMT memory
Thread-Index: AQHbu2NbezdtfbtG5USTt48T1yhTw7PRY3mAgADtfgCABy+sAA==
Date: Mon, 19 May 2025 05:06:01 +0000
Message-ID: <0994611acde70db0ee57910e6874708916f6cda7.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-12-kirill.shutemov@linux.intel.com>
	 <6a7f0639-78fc-4721-8d84-6224c83c07d2@intel.com>
	 <CAGtprH--e6i6b9grOLTUwYXKSNb=Ws5sNPniY+oJpyctM1cdTA@mail.gmail.com>
In-Reply-To: <CAGtprH--e6i6b9grOLTUwYXKSNb=Ws5sNPniY+oJpyctM1cdTA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL3PR11MB6316:EE_
x-ms-office365-filtering-correlation-id: 0b4d43e7-5053-4850-5ffc-08dd9692d9be
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Ry9ESmVqZXpvSkwyaldrSFo5cmJhWTNNUmxJZVBCMDMwN1dSN0w0Tm1vbnFR?=
 =?utf-8?B?RUlpVTBXSEpvRXVoRXZXWXVuS3JydFVldkVJZWxWeWJUTjdpc255bFRVYkJs?=
 =?utf-8?B?dVRUREZGd2NHQW1ZaFY2SENydDVwV0ptb1RReC9CZUJYTy95T0lCRGNGNE5X?=
 =?utf-8?B?a3J2Si84dTBhQkZQT2JzWmUwUGxKelg1N2ZnRmRIbDBTNGo3MW1WQmdUSnBk?=
 =?utf-8?B?ZVRORjRrWmV5SUovdEc1dnZtcks0bnRkMkY1OHMxSURGSXZLc1ZGbGh2RnlU?=
 =?utf-8?B?SHQxYlYxTDRqcXhHRkQ0eW5MeFAyVEdianN5a1U5dlZqQmY0RHM5bFVsNUtk?=
 =?utf-8?B?dkZ0VW11MjhYZTNmQkJGOHo1QUVaaW9zaCtndGcwb2phVE5uc2FHTWlHWmlS?=
 =?utf-8?B?SnZLTGxvalR4WFFtZ1lpYm1GbkdDUTh3OHR2SEJmcU9lVElnNUd4Ym9NaEI4?=
 =?utf-8?B?SmF4WVpBVWcxTlpqYkhDdnpJRmt5TCtaV2xXR0xadG85RFViOHdEMW5UK1lW?=
 =?utf-8?B?enFvbWZtTG9xblc4TGYxRGZlM0hyRWxZaG8yVWtjbDhUOWtUVElpL004bm1J?=
 =?utf-8?B?bVVpWnlRaDR3WENjRFRFV1lOb1NUdzNwTmxFQ25odlpHa0N1Y1RUSkJzOExM?=
 =?utf-8?B?NVVEcy9pOUs3V2FKZ1YyODFPM1pSSS8zdFdITHhRQUFkaTlDVkhJcHp0T2RH?=
 =?utf-8?B?NURVTjMrSzZ4VWM5NXNuWi9rU0VWMUNjTllaTW44Z0tNa1VmcDE1SllEZGpJ?=
 =?utf-8?B?TXFRVVY0NDE4UXBzMnk5QnJVQzllaFFxaWF5UTIwcEpTSFlyWXU2bEkvKy9M?=
 =?utf-8?B?cW5qZ2xaY1FhTzVoZ05xU1RjamVrRTlvdHpSclQ3YWhsRGVkbytkN1drdFlC?=
 =?utf-8?B?NmJSYTFEY0FILzZXMDYzc25RT0h4cnVGY3NIalBJQXlyQVpzcHFFamtMckhp?=
 =?utf-8?B?RkJ3QXU4MitTeEhWbEpiQWZsL2RLTGFlQUE4Y0JFQndRcUdudUNpbHIyQzhT?=
 =?utf-8?B?U2trTG9RZHFoMG1zejRNOGF5dS9KeGkzUkRxS1NoemRFbnVjRWJucW1lNTNO?=
 =?utf-8?B?ZFFNdENwV1V2cElHczFBYk9meGZqSitzUDZHbGFNb3kxYzB4cm5NNmdjVXRw?=
 =?utf-8?B?V3didjZHaGd1K3gxaEN3YlNOSWxuN0JMYWJMN2d4WVBnNHZNdDI1Y1dVbEs5?=
 =?utf-8?B?ZVAwdVd6VDRSK2VFOGdxb2VneTFLWVB3Zm9iQ3pQUU9aVG9ReERScmdDcGVI?=
 =?utf-8?B?T010RUNPRlJuNGNmb1YzajF4R2htU2hxYnRncCs1Um55M2FGRURJQ01oSlNY?=
 =?utf-8?B?K2FQK0xxdkZmWUVoWTg0SktuRnkraThuV2F1TzZpRmt4Zzd6dW43bjB6MUpQ?=
 =?utf-8?B?QVhNeXdENnNmUHBRakRmL2dBVE82NUZId05rR2lQWDFJaXQyWmkvTm1mNGxM?=
 =?utf-8?B?MUtHd1RjaEx5TDBDQTViUVBpTVdrbGhxOTRCMnRWTFJZZXdodEIxWE1IMitl?=
 =?utf-8?B?RUNwRmJRTUloeTlTcmthWXZYUTZpT1Z5WWh5R1BnQ21IbGZER29DaUZDMEl3?=
 =?utf-8?B?ay83UW1yODl5a1dDVE9WOSs1cWVsWEJoUnp6czgvYS9zNHFWWW1HK1VFV1dG?=
 =?utf-8?B?eFllM1JXeW1tS2hEV3AxSmVrSU5Yejc3dEtGbzFvd3dQRjJDQ3MyKy85eDYy?=
 =?utf-8?B?aG9vR2NtUGtxRHZMbTgwUzFBWEFVaTVCYWZ2dlMzeWpUUmZ0MTdQS2RmcHdE?=
 =?utf-8?B?cG0zUE5IbEFXazNQK2ZndHJpcytkYmJIdWxyS3RuT0s2WXVLWGFjYkg4OE1m?=
 =?utf-8?B?WFowdWp5Y0xGeExwWVBMUlJSTlJmZDBDWVNwZjBQYzJDZWcyTjNWQ2Z1Nzh5?=
 =?utf-8?B?MlppZ1dNbnl5Z1hJbWo1bjBhclo1RGFuSEEwQ041QmpMQTJsdVo1TmpKdHh1?=
 =?utf-8?B?dnppWDVUeG9hOWh5dHZkeVlueldKNWIzT3VYcm1xQU03MC8rUXIvS2VySjU4?=
 =?utf-8?B?RUFoZE9heU93PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUlXTFhHaEtFU2hVUTBoRFM0YUp0Q2tGTk15cnQwb1Q5VFJYY0xEc1Nadnkv?=
 =?utf-8?B?Zk1lYUxWMEY3WkRzZE1mRUFNMXl0M1NHR3M4K3BVTTM2MVVtUEdJKzBqeC9v?=
 =?utf-8?B?M0tlRnNPb3g0MzY4aFRtM2tWcWQzc211cFVNZmJ0VkRBdjd4YTFwL1h4Tll3?=
 =?utf-8?B?dXd3SFdkUzhWeS90Mm9CSUYyTmlZSkRZY3JCVFgwVUNqZDNlYXlsNVpZK2t6?=
 =?utf-8?B?OStSN1ZVM3Q1NG9sSERYS3dNVXBpZm4ydjVLSlY5TGdFa0ViY2g0dHhyeGNP?=
 =?utf-8?B?eUxySkJMNGxSMGd4SFNEMzBpVjR0STF3OVBHaXp0Rmpibkt5dlJ1NVlEZW9C?=
 =?utf-8?B?TEFxWm9GdUttQ1kwbEh6dXI0dTlzeExlMXBjbkJNd2lzZDdHNWEzRVRqV29p?=
 =?utf-8?B?U2R6TlhwRVNWY1dSckVkdDQ3VGY5cnY1WEVYUEc4M2tlOWh4Sk8vSzlWakNh?=
 =?utf-8?B?SmJJT1VEN29HeTRqS2RpZkhzOXdTQnRUampYWFM5L2VvVjF3cUV2Zk1SWVd2?=
 =?utf-8?B?VEJjM1IxUkVNdnN3dGxjRXoxdWZtclg1ZHo4bE5IVm1yZWJxbXFyMW9qenlK?=
 =?utf-8?B?emdTUGlicXZ5N0x6Y3VQY1JCUFZLcTQzcTduRkNTNjdFdVRZY0tyTTl0L1Vu?=
 =?utf-8?B?OHB0U05zQ1hwS3pSSkZ5dTc3dDVIR0s1NUcyUko3OFYwLzlPbU9zV3JOMEhr?=
 =?utf-8?B?YUJKRjNRTmgrTFVLdFBSL1dwc0NreXdIRDcwK1UvUU5Gak5lZ1ZPYjdLTWZu?=
 =?utf-8?B?bTBtNEgrL0FKQ05pTE4weVhWcVpBeitCdWtZQzVEUytTbmgvR2xXZHBtZXJr?=
 =?utf-8?B?NzlqMUs3RjFCbWtGYU9OVzE0dVQ2Unl5WlNTY1lUSm1mL2JmUktaajRXYVVM?=
 =?utf-8?B?ZnVCTFhleEZrT1hKalkwN2x2MDBlWHpvcllnT1VtT0FUWEFDRWd1enF0V0ZZ?=
 =?utf-8?B?N0ZzcjczWW5tUzY4N2RmazBMdldYdTMrSHR2Nm5rWithR09IYUt4d1d3WWRk?=
 =?utf-8?B?Mzg4RHlKWmhkVHFYR2FubS84WUF5T1JVZXE4elpqNUpGNkRvTncyc3hDSDFl?=
 =?utf-8?B?MGFobjZKSTRLN2dzWUVFSlQ1SzRQTFpSQ1RVNzhhdTVoMXRCaXloNVB6Q09H?=
 =?utf-8?B?V25YTlBhUjI5Y3dRSTdGY1ZZSHQ1bFNzQ2lyNzUyNEhkVDlML2lyU08zbjFl?=
 =?utf-8?B?ZEx5NGgzcWhjYmppNzRVOGEzRlRGWFhBckpzYUhEMHhlUi90V0JmR08xWVZa?=
 =?utf-8?B?YmdmdnpGUXArQ3JNM3BGVXBZbnNZbWpzcGExamZncDBCandGZENNamZrM2FX?=
 =?utf-8?B?elQrRU1ONzI2ZlBScW9wZnVBUG1EVWdTWjlERWlCSnVud3MxbndabDFkbTBa?=
 =?utf-8?B?eHExby9YbmJ1VEE5c1AwekdMSUFEdUxKVGxHd0VDejlXSEcyT2ZkMUtZa3Ey?=
 =?utf-8?B?YXNhMDRhcnNNZDg3R01SZmFrTjU5dGE1MzRXSUZTNFNMazZCOFA4dXMrSEJ6?=
 =?utf-8?B?QmVWZTBJK0RZU0F6UTdHZUhqcFc0d0I4ZXpTNTlJU0gvdnRqcTFjaXJYQ0Zh?=
 =?utf-8?B?R0hVYWdYR3JJTmgrYzJIUTZzdXV0QmhiUXBBayt3UHI4bE5qNjA1TUdBNm9J?=
 =?utf-8?B?Qmd1TVVCei9RSjVCZHI3ZmMrWmNPTGlZcEFJVDZaZWFTb0pZK2VOcms2eVJJ?=
 =?utf-8?B?QnBzZlZqdjM2SGsxTlF6MkNCUjdTeWFIYjh0a200Wk8wdmZVVW5KZzBsR3FX?=
 =?utf-8?B?R1ZaZkZpM1FXcHA3K3p4ZHpJcC9JcENXN3d3UnllZ1Y3ZjJBdU1QS2F5SlAv?=
 =?utf-8?B?YTMzbllyZ21UNllHRzNKdVZJdm1lZGVkQm5jWTEveGFSN2lwVXdNb2NMV0w5?=
 =?utf-8?B?Z3lmdFlVdmhGMVhXTGQwVGJndTJpTWtrL1JMN21GOXNZSC9VWjFKeWRyNnEv?=
 =?utf-8?B?Q1NPTXdxVjJrMDRxemRVUllFT3NSNDRnR3VHUWQvb0l6dmt0RkNnUngwNTBt?=
 =?utf-8?B?RmxKL0RtWEcrbWl3RlZaZ1hvc2hPTStMZUxXekJkMlNucWtwclpBZWRsTzBH?=
 =?utf-8?B?WWtRMDUrUFgvazZxWlQzVGxjMDJKZmQrWmF1M0ttV25FL3NJNzZ1NVk4Y2Js?=
 =?utf-8?Q?vdW94veSSl37TaGTeqiPWdwnN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4429C811AB644849ABE12D2CF0A0DB68@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4d43e7-5053-4850-5ffc-08dd9692d9be
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 05:06:01.8361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Ciu/OX+YYiFvpnMQfjkIo94/QM+4hTtw1E9bn4phan1DozwWFanY2hpoM1twYjBos8yHu3p2co0JnsobdluIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA1LTE0IGF0IDA4OjIxIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBPbiBUdWUsIE1heSAxMywgMjAyNSBhdCA2OjEy4oCvUE0gSHVhbmcsIEthaSA8a2FpLmh1
YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gDQo+ID4gDQo+ID4gT24gMy8wNS8yMDI1
IDE6MDggYW0sIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gPiA+IFRoZSBQQU1UIG1lbW9y
eSBob2xkcyBtZXRhZGF0YSBmb3IgVERYLXByb3RlY3RlZCBtZW1vcnkuIFdpdGggRHluYW1pYw0K
PiA+ID4gUEFNVCwgUEFNVF80SyBpcyBhbGxvY2F0ZWQgb24gZGVtYW5kLiBUaGUga2VybmVsIHN1
cHBsaWVzIHRoZSBURFggbW9kdWxlDQo+ID4gPiB3aXRoIGEgZmV3IHBhZ2VzIHRoYXQgY292ZXIg
Mk0gb2YgaG9zdCBwaHlzaWNhbCBtZW1vcnkuDQo+ID4gPiANCj4gPiA+IFBBTVQgbWVtb3J5IGNh
biBiZSByZWNsYWltZWQgd2hlbiB0aGUgbGFzdCB1c2VyIGlzIGdvbmUuIEl0IGNhbiBoYXBwZW4N
Cj4gPiA+IGluIGEgZmV3IGNvZGUgcGF0aHM6DQo+ID4gPiANCj4gPiA+IC0gT24gVERILlBIWU1F
TS5QQUdFLlJFQ0xBSU0gaW4gdGR4X3JlY2xhaW1fdGRfY29udHJvbF9wYWdlcygpIGFuZA0KPiA+
ID4gICAgdGR4X3JlY2xhaW1fcGFnZSgpLg0KPiA+ID4gDQo+ID4gPiAtIE9uIFRESC5NRU0uUEFH
RS5SRU1PVkUgaW4gdGR4X3NlcHRfZHJvcF9wcml2YXRlX3NwdGUoKS4NCj4gPiA+IA0KPiA+ID4g
LSBJbiB0ZHhfc2VwdF96YXBfcHJpdmF0ZV9zcHRlKCkgZm9yIHBhZ2VzIHRoYXQgd2VyZSBpbiB0
aGUgcXVldWUgdG8gYmUNCj4gPiA+ICAgIGFkZGVkIHdpdGggVERILk1FTS5QQUdFLkFERCwgYnV0
IGl0IG5ldmVyIGhhcHBlbmVkIGR1ZSB0byBhbiBlcnJvci4NCj4gPiA+IA0KPiA+ID4gQWRkIHRk
eF9wYW10X3B1dCgpIGluIHRoZXNlIGNvZGUgcGF0aHMuDQo+ID4gDQo+ID4gSU1ITywgaW5zdGVh
ZCBvZiBleHBsaWNpdGx5IGhvb2tpbmcgdGR4X3BhbXRfcHV0KCkgdG8gdmFyaW91cyBwbGFjZXMs
IHdlDQo+ID4gc2hvdWxkIGp1c3QgZG8gdGR4X2ZyZWVfcGFnZSgpIGZvciB0aGUgcGFnZXMgdGhh
dCB3ZXJlIGFsbG9jYXRlZCBieQ0KPiA+IHRkeF9hbGxvY19wYWdlKCkgKGkuZS4sIGNvbnRyb2wg
cGFnZXMsIFNFUFQgcGFnZXMpLg0KPiA+IA0KPiA+IFRoYXQgbWVhbnMsIElNSE8sIHdlIHNob3Vs
ZCBkbyBQQU1UIGFsbG9jYXRpb24vZnJlZSB3aGVuIHdlIGFjdHVhbGx5DQo+ID4gKmFsbG9jYXRl
KiBhbmQgKmZyZWUqIHRoZSB0YXJnZXQgVERYIHByaXZhdGUgcGFnZShzKS4gIEkuZS4sIHdlIHNo
b3VsZDoNCj4gDQo+IEkgdGhpbmsgaXQncyBpbXBvcnRhbnQgdG8gZW5zdXJlIHRoYXQgUEFNVCBw
YWdlcyBhcmUgKm9ubHkqIGFsbG9jYXRlZA0KPiBmb3IgYSAyTSByYW5nZSBpZiBpdCdzIGdldHRp
bmcgbWFwcGVkIGluIEVQVCBhdCA0SyBncmFudWxhcml0eS4NCj4gUGh5c2ljYWwgbWVtb3J5IGFs
bG9jYXRpb24gb3JkZXIgY2FuIGJlIGRpZmZlcmVudCBmcm9tIHRoZSBFUFQgbWFwcGluZw0KPiBn
cmFudWxhcml0eS4NCg0KQWdyZWVkLiAgVGhhbmtzLg0KDQpJIHN0aWxsIHRoaW5rIGFsbCBjb250
cm9sIHBhZ2VzIGFuZCBzZWN1cmUgRVBUIHBhZ2VzIGNhbiBqdXN0IHVzZQ0KdGR4X3thbGxvY3xm
cmVlfV9wYWdlKCkgdGhvdWdoIChiZWNhdXNlIHdlIGFsd2F5cyBhbGxvYyBhbmQgdXNlIHRoZW0g
aW4gNEsNCmdyYW51bGFyaXR5KS4NCg==

