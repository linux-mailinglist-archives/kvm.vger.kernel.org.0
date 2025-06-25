Return-Path: <kvm+bounces-50705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8BBAE8704
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E768D16BEDF
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142F225C702;
	Wed, 25 Jun 2025 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nL6iJ82E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B7F1D5CD4;
	Wed, 25 Jun 2025 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750862888; cv=fail; b=W7Lt6xMdQg2t7hxYBrl7S725v5sW+8BULA1JZ1vGlieb5XRDvJ4r2lM2udNZBSItfUDfTzj2bQcXfMD2DbmZT+RhGVTFFKwY4lGkiyKeOGQM3/VBTHFr1687Qfivve6NZ/kffxHrKthf9wwCt9QGT1qZWHF1vqesCwLTkgYZbQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750862888; c=relaxed/simple;
	bh=PsuKogmTdGEwBYWvHYbA0wipOoRmLXowirQRM3ntgNA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S0eBGfdKmakc2VK1tj22Y2w5sj0xCnjEMcTCH7jtmjTW7pkciCUAVsUzbRfGXdEnwr0pXmSEkvwb4m/LElt+hFP1L1WoD9g7Q1Dpv04TuEYurMsFfFpiuVhHzz+PI8QbOTIdEWb3IazOPPi2sNGEhScHTKrbyIFM20OdOl18/Sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nL6iJ82E; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750862886; x=1782398886;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=PsuKogmTdGEwBYWvHYbA0wipOoRmLXowirQRM3ntgNA=;
  b=nL6iJ82ELPNNafVIfkE7laucIkraagSQZmVgVOMbsRD0BA55pWFhI9ep
   FUvC90oYZkJvoyrPgx+Qq/faYlLFvXj9UeCVWCdubTzQCd2YkGrLmAhCB
   pAATbvaHxuHXE8zayMs0XpBeFAyJWn4uxJFVLjK9YJxqwbK5U8xuWB7Et
   nOlhf7lCEQKvj2IXkofa64NdEnEWVPvIQUwb92dvoAjdnc3LHwEmtAQ7I
   /DshAVWt+Pe/1BCtsYGHCgMW5UfHsw7TA+rlp9IwB1N9oFlrt7+iWRq92
   MvXJGQlT/yeNLpuEsdk3WiYLHWUF0BoYYi6fRNBpDL6dkcUw9KjnLbNnb
   Q==;
X-CSE-ConnectionGUID: d9Lb88TfTaaaopfbZgWoQg==
X-CSE-MsgGUID: oypenBItQy+TSKLsPRT4hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53201211"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="53201211"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 07:48:04 -0700
X-CSE-ConnectionGUID: fiwUGwy6SemCn4N+FvSC/A==
X-CSE-MsgGUID: uJu6awQPQzmoRnMSTcMH4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="157736617"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 07:48:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 07:48:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 07:48:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.67) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 07:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lkwyfLOKQTtwL7O4QkcyJecPBImwrlTkqi3rrL3/dufOygqhIp7MbkBJNCh+F0YjnyERfVc91KMfhXguiwV002K5dFLzk8WA0oha1tvLIgOb0OJXyeTguXzEE34vSTDogPh19PApuM5s4DdvdmPlV/XXkig7fQm5X1k4Je0t9z428Vpykl5cBhFqzFhPHMMm+Eam3waBVCCntwN76kntIre2g83Y7dI9wCv+h49ZpKHep+xCdzIy1F3Of3BrIyaaZyfxzk0GTpA6G0uF3IyWgSZcK8ZcaFjzxWrRKcUcWS/B+ouli+e4aJEcJcICnTzdq/pZmZ569avrxauT9eGRvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsuKogmTdGEwBYWvHYbA0wipOoRmLXowirQRM3ntgNA=;
 b=H3exZomDh/xyJc6TVR9TUgrsO2nvtvxkeyA+4C4/alSECkBAFD/Edyr7ie1AraYVdrFySd3GThcZeA/BMNBeN5cR4iOPvibtD6InBRP2pk1Dt3iKNekjpoVmp3BaaZx32FIH7A8M0jWP+Vu8QljkpUExmihMreIvb9m2CbCsJ4fg1ceTDW35RXXHMhDeYKmaecRUytA6oqPWsqjDHcTIFpuXDZ1O2c9g5vWZM0qzBN5Ywphz94PLTovg/nbsdf6G2EJwOqboEqeBT0Sz5qWQKtffFEkaVkVTDpc5XY1MkXLLkF42Xs7fHvdn1rg3AeVBQsL9lpo+Y3AQ+syUUTwhJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6126.namprd11.prod.outlook.com (2603:10b6:8:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.19; Wed, 25 Jun 2025 14:48:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 14:48:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABjCaAgAQxHwCABQ5egIAAzNwAgACQ3gCAAPlVAIAAAkgAgABXBYA=
Date: Wed, 25 Jun 2025 14:48:00 +0000
Message-ID: <97cdcbd6ba0305fd3875813e46b6f625dde0d0d3.camel@intel.com>
References: <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
	 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
	 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
	 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
	 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com> <aFWM5P03NtP1FWsD@google.com>
	 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
	 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
	 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
	 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
	 <aFvDIDZ+Y3ny/WuF@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFvDIDZ+Y3ny/WuF@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6126:EE_
x-ms-office365-filtering-correlation-id: ce6b216d-322b-496f-f76a-08ddb3f747fa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?RmdYNWJmWkZGanFBLzl2M1RSd1VSeXRKcGxIWTBzbTN3VzBRdVEyS0gvRTA1?=
 =?utf-8?B?M010b2hjNmhzaklFZ1Y1QUt2a25jYU5FNWxzYWsrS2RuS05XcDczaE90b2N5?=
 =?utf-8?B?WlJHQXhWRVhyOTRtU05XenNSbHkwRk5DSksrUjhMbGtwUlpRVVg4UFNHZVNR?=
 =?utf-8?B?bGZLMkRaUEdkRFptaDIxMGN0M1dIbUtkSFlXaU16UU9HL3Erd2NYOGladVFt?=
 =?utf-8?B?ZkRYRU1RMGFZOGNPZWI2VlFIdFhtbTNWQVdxczFjNGdQZndSNWg2YVlLSGRi?=
 =?utf-8?B?ZnFHMjhyeUhaelBETkJMZWxBWDZITnBRai8rWm1aZCtpc0o5Nkwrdy9zSUov?=
 =?utf-8?B?NEFaUXhzSVZzWUJ0S1JVaU5pc01IZkNtaEx2SHdYMFJCaFZFTU5xcXMxNHI5?=
 =?utf-8?B?OStISzQydGZhb3EwaDZRQXB3NTFKUlRVUUxoTmt3SkJnSnNvL04zTXJZNHI1?=
 =?utf-8?B?YWtpazFFRTBDWE5FYnc4bjJzUE9Md01kbGNMMzNWekJBT3N0dnBiMTkxN3Vo?=
 =?utf-8?B?emhobHF5RERucThIVFJoSjc2V25pQUdDVnY5VTdoY281REJZQkFrWis0TFd1?=
 =?utf-8?B?YkNCVnNudFg4N1k0VlI1ek4xbzM5djc4TzB2NWJueTErOUZFOHFZQlRISVhO?=
 =?utf-8?B?YWRJdGRleHpDSlZDbkI5WjdvV25MTVo2ZS8xaTVucm1nb0V3Qy9xZzRGYUxR?=
 =?utf-8?B?Qm1meW0zYTR3M080WVR6eGMzQ2FmNUx5bmhlb29WSUQ0SHc1a2dqWnk2a0dH?=
 =?utf-8?B?bnpzMTE5MkZQQzJncTBYbmpteVQrYThjTVdUR3ltYmVIVDF4QnpLcUVTMFBt?=
 =?utf-8?B?QzRYbzYzaHJIbFdKdjh3THFKeUhNbllzQTJVNGplMVd6dlFhT0JEa0srN3p6?=
 =?utf-8?B?UzB5TmEyejFNNzI1NUdiMGNaa0lwaElENmpreEdtU2dOYlNZbzVoSUJxUUds?=
 =?utf-8?B?TmpteUhBSE11Y1hlS0x5bDNhdGdDa1IzeTZLQjJqMW9FOWJnTlF0UVl1T2J3?=
 =?utf-8?B?QThwNDVLUDRWaU9Dcm1IeEFYblpmdXdPM214UUhJQnVwSkVQY2l1bGNDMmwv?=
 =?utf-8?B?RkRGZW9Uazl3MHB0MklRKzdMUE1NejYzSXlDdE5CVXp4ZnhSOTRxSG45bmpx?=
 =?utf-8?B?dU9Md1RuREhFNy91eHl4U29MZkdPVTNmR0JFc2lsOTUrRFRXVGRiR3gydEZo?=
 =?utf-8?B?VVVzZERSMGQ4bmkzOHNDTllwdFJlSDZwMVk1eDQ3V2lkRmxFMHFHNi80czZp?=
 =?utf-8?B?MkF0Vm5lSTNrTTFYaEtXM3J0TXJjZVVBelR4M1NwRzhvVk50NXE1REwrVjFX?=
 =?utf-8?B?L2hsRFpjR0o1QW9Bem4zMXBiU2FWSmFQM0xFQWlvcTBXbFRHbXI2dkwxVFRK?=
 =?utf-8?B?SUphMlhIeGM2SE0rNVhBWTQzd2gvNHRMK0crc3ZEeUtJaU0xWFl3WE1MN3hU?=
 =?utf-8?B?NTFuMm9UYTJpRHd5c0JwUzJ1aXFKSnJJdGhSZG9Cd040SlpDaDV1cmpuRFZs?=
 =?utf-8?B?cFpPaFRyQk50UnVvUXUzUzRZZndFS3dhM1U2SXN1eWptckZpRGZSaldTSVNZ?=
 =?utf-8?B?c2IzUDFvdXdwNEFCK0dhWXE1ZC9LN2MrU0FrU2tKa1k3VUtlWHpQVmh0R2VH?=
 =?utf-8?B?Zmx3V2JuQW9QbEd3UVBneFBGbDY5VVNqMnJkQXA3YnhGVng3WE81L1U3VUFK?=
 =?utf-8?B?aFlTeWNJeXMzS2w0UndRNHpGdXZUcmIrc0ZXdHdENXErZTJUVlQyTy9iYmQr?=
 =?utf-8?B?RnhmR1RQbU5OVHNxNy9DaWZ5dFJyVDB4WmtVcTV0Ny9aZTRMWlRML1BMNFBq?=
 =?utf-8?B?NGtHaUs3My9PNjZLaUtnUWp1TGo1UXRhS2x3V2grMGlDOHVUaE5tVVVXRFg5?=
 =?utf-8?B?NW9nVUkwaXR4R2E1Tlh1UFFNSVdueG1WL2pHNGpFeVgvQjl3VTdHQUVXcGow?=
 =?utf-8?B?ajdPTW54VEowMXFaZTdXa0tJSzNmYzBTcHJYUURRN25XY2RZQXpkNU9BcXM1?=
 =?utf-8?Q?Lro0QxtyWQTUlGrHdfvWzv+hHlJzys=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXRnWjJSL2ZmUjErMHJ6dktXbURFMFlITHZnRFhpWi8zSVNJcUovakR2N3Fw?=
 =?utf-8?B?QTI5V3pFamZFUk5aWDhPa3hRS21IbGZSVVF0UVAvVldnL2RPbkptbTI4YzNG?=
 =?utf-8?B?RXRNMnZ6Rm0yWkdnODVPdW9CQlBYRGl1aWVBbUg0YkVwWFlYQmFoZ2VNZGZP?=
 =?utf-8?B?ZTRrM29lZjdRRnFUdzZTVGxvVHE4WnpPa2hEZUZCd2NRSFRyTURNckZLL0g1?=
 =?utf-8?B?S2FuMUJWSW5QS3NuanNvMk9NdEtGTEdRRzNqL2lXU0hCbU91UnJPVjFsRE9Q?=
 =?utf-8?B?cGpRTGxHci9SMVVzZnNnUE1oWTlSRVNzdDIrUmEwcS94WlcvblJvc3BTdHhD?=
 =?utf-8?B?TUpSTUFSYzh1SVFVRVVWK3NsL09XeGNYOThnOVFLSmVMWmlYTk9NL1B4d0pv?=
 =?utf-8?B?TlNoMndtR1ZOd0EyLzBsNWJlc3F3bU84dFpGWUovV0FPaGJpTy9RTzh4T21M?=
 =?utf-8?B?Ujg1cTNmUDRmek83azFVV3NZaEVwcm5keGlMTXJST1k2QnVGejkrUjd5ekQ4?=
 =?utf-8?B?by8yM0lSOFAvREFQTUcwNVl1bWZYVTlqbnZMSWdoZTJHdW9CajJRV2hVWUpv?=
 =?utf-8?B?R0xFbFVqVitKTExnUXAzaG95aEIveGpwVEJQV1pFay9vSE8xdlN0LzltWmt0?=
 =?utf-8?B?ekloeE5DdjFLekFNbURDajNNb2QrbDJubXRFbGdxNkJKZ1dmUHh5UUQxOXNT?=
 =?utf-8?B?L2xjWUQxZzJFR2s4alAvNGNWYUJtVEwwN243bkpiMUMvNmQ3bUtpMzQ0YVFl?=
 =?utf-8?B?WGlkTDNiZlQyaEEyYXp6Q2YwelFSMFRkSUw1RDA5cnd1OHlZRzE1N2IrNkRU?=
 =?utf-8?B?M0NBeVFuWU9nSjk3eUFxWGdZZWp0Qnp2TTJ6MkMvZTFYVytjZ1lSenNqcGVM?=
 =?utf-8?B?VGlPcWtVcDlkZXdmV0xuRmNxdWFwVFNqc0lVZ3A5UEFTSUpuWHRuYUQ0cHNl?=
 =?utf-8?B?OUNNWHliTWs3R3dLVU9UK2tRdWNWLy9mMGh1SWVIZ0g1Q2M2WE5CRzd3ZTlU?=
 =?utf-8?B?OU45VHM1c2ViZmVub0V4c05TUHRTR2w5WWtMTmNGdFNFSnFOVzdZL242T0dM?=
 =?utf-8?B?WU1PWmpBYzJoMFRIZEh1RlZhbEtBeFY3bkFPcDBJRlZPc1Yvc252aVYwZStt?=
 =?utf-8?B?VHVDdW5UOU5mSHFpSlVzVStyVVlPMU50U25EbGtLdklraXQ4c1NpWGNkZ0tE?=
 =?utf-8?B?WHBoU0RxSEUzUGN2aTJKNG9yd1VqSTB1blYvczhJVlZ4Nkc0azRqTGIrZ1Bj?=
 =?utf-8?B?WHdNaFA0N3gyT2pqeTJFN1ZsS0NYRWROQ2F3ajl1RnJXQ09sUnNzeWZ1Qmx0?=
 =?utf-8?B?dGdMeUJvNEZqT1ZpeFUvQW1mcXdDRUVzTlpGK0hzV1FyeTMyTW4vaU1tMCs2?=
 =?utf-8?B?OVBNbkpFZ3FDOG1QUFQ2TEdHMWhlYmt0N1pzUkw0azJ4d20vcTZ0TlZFWjlN?=
 =?utf-8?B?TWRrRjlrZjNZdHo4L0IxSmFOeWhBd3UxVUdZa0VlM3NKeXVQZzBjVkoyUmZi?=
 =?utf-8?B?VGxlNENEd3I2ZzZBRGNRUnhFRXpWQzV1dFcrb2xDL3pRQUxKVytjc3ltOGpm?=
 =?utf-8?B?S2NhOVk3T3NkcFdiOW9PQXV2UEdjbVgxeVordFFsWnpNeStRK1VvWCs5QTh5?=
 =?utf-8?B?enYvVEZlSHBpQ0Y0cWVDU1g1elByNGNhN1JhYjV6cFhnekVmVHRBcWN1Vit2?=
 =?utf-8?B?dVZsbHhkQnd3WE5lVWRnZXlBVS9aM0ZsUHVFTlk2N0toaG5Fb2puY2c0T2RH?=
 =?utf-8?B?WEp3V3Y3bUFDb3VqTDJsZmx2VDdINzFEVk5mYlZTWHZrQzFpR0R6QWxWWnBi?=
 =?utf-8?B?dURiODVINHFOV3dRVUpNZjdQZVIzS3k3L0UwUTNKelovU3V5WDBreUJXYjhJ?=
 =?utf-8?B?U1B6RTdRUSt4MU5Fa0xQSFJYamlMeG1RZFNtUjNxQVZmTHhGUEFZdTdoajRL?=
 =?utf-8?B?YXhoZUFSTWowenBMZUNQS1hSSnAxdzhDRFcyZVhLVldUcEhyL3pld2MzUFEy?=
 =?utf-8?B?WXRDSUhIbmdUWTI5V0FTdXJFT1o0S3R4ZVB3L2Nka2JCaDQyaW1iM0ZjOE5l?=
 =?utf-8?B?dHdLdHMraURFK0JHK3pEcmE1ZGhVKzVIRENLd3h1SUNkWlZmZjM5YjArNCtz?=
 =?utf-8?B?c1hXRlJUZXI4bnFlWW1KQWJndXFYVXFpeDNFd2NGemlDK1UzNS9pNmExdUls?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1DEE05EDEB3C84A84FA848FDFF014CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6b216d-322b-496f-f76a-08ddb3f747fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 14:48:00.1787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MulbWL8LehpYzwdTg/odPf+i6fpc++UCkk+7Zr7RnLgpmmFmEs4IHl3JBVA2pLhjshiuU2+Is+YnogU7FvcGPNKFQAJzJ0xmMkmTZLCaDiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6126
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDE3OjM2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
V2VkLCBKdW4gMjUsIDIwMjUgYXQgMDU6Mjg6MjJQTSArMDgwMCwgWWFuIFpoYW8gd3JvdGU6DQo+
ID4gV3JpdGUgZG93biBteSB1bmRlcnN0YW5kaW5nIHRvIGNoZWNrIGlmIGl0J3MgY29ycmVjdDoN
Cj4gPiANCj4gPiAtIHdoZW4gYSBURCBpcyBOT1QgY29uZmlndXJlZCB0byBzdXBwb3J0IEtWTV9M
UEFHRV9HVUVTVF9JTkhJQklUIFREVk1DQUxMLCBLVk0NCj4gPiDCoMKgIGFsd2F5cyBtYXBzIGF0
IDRLQg0KPiA+IA0KPiA+IC0gV2hlbiBhIFREIGlzIGNvbmZpZ3VyZWQgdG8gc3VwcG9ydCBLVk1f
TFBBR0VfR1VFU1RfSU5ISUJJVCBURFZNQ0FMTCwNCj4gU29ycnksIHRoZSB0d28gY29uZGl0aW9u
cyBhcmUgc3RhbGUgb25lcy4gTm8gbmVlZCBhbnkgbW9yZS4NCj4gU28gaXQncyBhbHdheXMNCj4g
wqANCj4gwqAoYSkNCj4gwqAxLiBndWVzdCBhY2NlcHRzIGF0IDRLQg0KPiDCoDIuIFREWCBzZXRz
IEtWTV9MUEFHRV9HVUVTVF9JTkhJQklUIGFuZCB0cnkgc3BsaXR0aW5nLih3aXRoIHdyaXRlIG1t
dV9sb2NrKQ0KPiDCoDMuIEtWTSBtYXBzIGF0IDRLQiAod2l0aCByZWFkIG1tdV9sb2NrKQ0KPiDC
oDQuIGd1ZXN0J3MgNEtCIGFjY2VwdCBzdWNjZWVkcy4NCg0KWWVhLg0KDQo+IMKgDQo+IMKgKGIp
DQo+IMKgMS4gZ3Vlc3QgYWNjZXB0cyBhdCAyTUIuDQo+IMKgMi4gS1ZNIG1hcHMgYXQgNEtCIGR1
ZSB0byBhIGNlcnRhaW4gcmVhc29uLg0KDQpJIGRvbid0IGZvbGxvdyB0aGlzIHBhcnQuIFlvdSBt
ZWFuIGJlY2F1c2UgaXQgc3BhbnMgYSBtZW1zbG90IG9yIG90aGVyPw0KQmFzaWNhbGx5IHRoYXQg
S1ZNIHdvbid0IGd1YXJhbnRlZSB0aGUgcGFnZSBzaXplIGF0IGV4YWN0bHkgdGhlIGFjY2VwdCBz
aXplPyBJDQp0aGluayB0aGlzIGlzIG9rIGFuZCBnb29kLiBUaGUgQUJJIGNhbiBiZSB0aGF0IEtW
TSB3aWxsIGd1YXJhbnRlZSB0aGUgUy1FUFQNCm1hcHBpbmcgc2l6ZSA8PSB0aGUgYWNjZXB0IHNp
emUuDQoNCj4gwqAzLiBndWVzdCdzIGFjY2VwdCAyTUIgZmFpbHMgd2l0aCBUREFDQ0VQVF9TSVpF
X01JU01BVENILg0KPiDCoDQuIGd1ZXN0IGFjY2VwdHMgYXQgNEtCDQo+IMKgNS4gZ3Vlc3QncyA0
S0IgYWNjZXB0IHN1Y2NlZWRzLg0KPiDCoA0KSW4gdGhpcyBvcHRpb24gYWNjZXB0IGJlaGF2aW9y
IGRvZXNuJ3QgbmVlZCB0byBjaGFuZ2UsIGJ1dCB0aGUNClREQUNDRVBUX1NJWkVfTUlTTUFUQ0gg
aW4gc3RlcCAzIHN0aWxsIGlzIGEgbGl0dGxlIHdlaXJkLiBURFggbW9kdWxlIGNvdWxkDQphY2Nl
cHQgYXQgNGsgbWFwcGluZyBzaXplLiBCdXQgdGhpcyBpcyBhbiBpc3N1ZSBmb3IgdGhlIGd1ZXN0
IHRvIGRlYWwgd2l0aCwgbm90DQpLVk0uDQo=

