Return-Path: <kvm+bounces-54557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98611B23C4D
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 01:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E64FB1B63837
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 23:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1D82E0B47;
	Tue, 12 Aug 2025 23:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5q0TO2B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F592874F0;
	Tue, 12 Aug 2025 23:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755041711; cv=fail; b=UrMz0QLKfCaxDEJIWYqTjASkeK2Ja31aY5DFC6NNAKyCj2vumaAMUV/eSOupDLCPEdzbk8TWV2p2G3ms6E55X5JLzLgv53A8RItnyWMmv8jqSru1wTNKXZMAra22o6ENogr4ChvroC65fTf+k/vio7k3pQLyfxrkJ+DkY+crfvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755041711; c=relaxed/simple;
	bh=b9b66nagtG57nXVd9tx7u54E+fGsrYBfqSjON0ywcSs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VYgkrvZjmcj7Xr+GTSCLlPBNMB81m0cCsikqtVxetUktVotiYzerC+8w3WGe+QIJugtIy7YuDUtOmLigiIbIk6HbUvjimwbeTbxb4uyFqCdnWOo8LyMeNrcLVKmy2IsJEe1IkBKSCUYYTcRVFRDE4FdtUWZQadMMra4uLEOmGrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5q0TO2B; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755041710; x=1786577710;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=b9b66nagtG57nXVd9tx7u54E+fGsrYBfqSjON0ywcSs=;
  b=f5q0TO2Bgo6eAnkFKQU6hTgNtJx6OuVmvIx9UPFX8p4bCz/pvbj1Ckxw
   ztmXb9y2EFzzN1DhMNiqkBiK4mfA2RtL2+f8s1tLhZgo9ZChH20GrDul1
   rT+MIFNyv78VP6P3C6ydnrcYRRYAUCMDV2dVN/5iPVKsaCFSYMp/uVk3o
   IGnoDXo0Awx51gDRfXZiSd5WZibj8c7fsWNUvOjBAZMdgu2ssor47Wicc
   3hazc6Sp64KZ7ZUhHqhsi4HGWzXKgwOF/awoNf8WzVluC2IjxN6o6ElaK
   rf3T96y4J1GpyrCSmw+rMMpgfWcO9hptPbYGqKE/gequIaw9p/it/b98s
   w==;
X-CSE-ConnectionGUID: Agawo+NuR52XnGm9Ehd0Dg==
X-CSE-MsgGUID: bE3DfRIPT6G3DnvuLOWxIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57474341"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="57474341"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 16:35:04 -0700
X-CSE-ConnectionGUID: yxKgJYaqQoC77HK/7TwAHA==
X-CSE-MsgGUID: MZIUIp0vTG+FPRJ3h9oHew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="170524554"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 16:35:04 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 12 Aug 2025 16:35:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 12 Aug 2025 16:35:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.60)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 12 Aug 2025 16:35:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWwjRKIK6gBb9xBjSe5/hU6g/uhXkfRrgrxNzx7W8YhZF58NdXNtFmFJD8FYo0K3SFhIsUvu0dRFukTO02WcibQec7R3UE+13oHcu59eJuVuccU9ey59LLRTAItw45u2X8WNJX5w4LRnT0xnjpKIRAMMZ6eCKnzMMLEnUcfUL7UIoiExT5TBSBYwiQALF6234dsOHUbW62ZPf6YhJSwzG0XC7rX5ZX6Fa6RrbF6ogRNijrvDnSveOciiP8nt6paNvI3Ae6M2hZ3jjaf4m5OYuy6Lb7N6xE67V/MwWme7TBBAwMVHyVkfwhPj6Z0dtiuMYqajOZORf3pN4x1q+b59tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9b66nagtG57nXVd9tx7u54E+fGsrYBfqSjON0ywcSs=;
 b=NFpDOV8XogXzswffGjXbdrg/fW7h9/EChxL3frJ5//xv1j7DCGX5Z1zP70yPwC5cCm4BWAcAy1r5FtqAe6l7XwpsCNA2b6HZidt5DzZtE4hHm60Gx7bG5fRkjPKEfj6KkDwejLodvqBGAoMxiaI3E/r+xJxPUBQD5TqQ3utMft7Zk4eSMWIbmCCrfmfpsIKNMq+aA57sEyuGZuS6Jbxo7/2/FURlaG1Jj7FJgO+0MU3801m5N/fmFu1U92yS8qK0QNt3v3SUAcwRBhT3bwdgLMq8DvWXCIro+sUq/Ma+VWJrPT1+QhiAbNiPRKWuUf/LYhVj+vuhF+nmiovcTgK6jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7263.namprd11.prod.outlook.com (2603:10b6:8:13f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Tue, 12 Aug
 2025 23:35:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 23:34:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgIAAOwMAgAAILQCAAF0hgIAAd5yAgAARcACAACgtgIAAOFiAgAAaVQA=
Date: Tue, 12 Aug 2025 23:34:59 +0000
Message-ID: <b5ce9dfe7277fa976da5b762545ca213e649fcbc.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
	 <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
	 <aJqgosNUjrCfH_WN@google.com>
	 <CAGtprH9TX4s6jQTq0YbiohXs9jyHGOFvQTZD9ph8nELhxb3tgA@mail.gmail.com>
	 <itbtox4nck665paycb5kpu3k54bfzxavtvgrxwj26xlhqfarsu@tjlm2ddtuzp3>
	 <57755acf553c79d0b337736eb4d6295e61be722f.camel@intel.com>
	 <aJtolM_59M5xVxcY@google.com>
	 <6b7f14617ff20e9cbb304cc4014280b8ba385c2a.camel@intel.com>
	 <CAGtprH9x8vATTX612ZUf-wJmAbn+=LUTP-SOnkh-GTUHmW3T-w@mail.gmail.com>
In-Reply-To: <CAGtprH9x8vATTX612ZUf-wJmAbn+=LUTP-SOnkh-GTUHmW3T-w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7263:EE_
x-ms-office365-filtering-correlation-id: 3e739947-003d-4646-4356-08ddd9f8da8b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cy9OYkJEMkNtTzdUT2NNTTlBMlljRnB3YUhsNnBGdVFPVElmbitRUnpYaTM1?=
 =?utf-8?B?a1RDd1VWc3A0N29mUHZPZ1ZoL0g2dmFuUXpGMkhzVjEzVTFYM1hTMFd2SnNB?=
 =?utf-8?B?TFlaZWdSdTJMNnVVcEJjTDYxb2U5RG1rYjdrcHJTc2NvTTRsMGNZOXNldlFC?=
 =?utf-8?B?WU9hMlRVWDNBUXgxUWZXMWdMaXBlVjdDQnBTK0cxT0NIMHlqeXIvNDl6U0ww?=
 =?utf-8?B?TlVXbUM5TmlqOW1hTVk4Z3pHSEdmTnROaHBZRmNCVGo4bjF2MVBaOEdMdnls?=
 =?utf-8?B?TXZDQnVIbk5BWW4ydE4xcFBGYUtSRVNmWEhYSTlDNVowMzhHcEJuS3BTR3Rr?=
 =?utf-8?B?NDBNdmQyVEpaZThRbFBvRnFsZnFIdHdEaUlsSVh5RzNEc3ZxTGhSOTZTeFVZ?=
 =?utf-8?B?RjBwZmMyMnJlZW5xbkNWYjVQL3JJSk1EZFFsZzhZVVZjZzBOMmJyd1hEMTEx?=
 =?utf-8?B?d0RoNVhROWdmMUg1WXl3Z1RYTmdjbW1ocEZCWDFBUHlQNnpGY1lBSDFTeWtp?=
 =?utf-8?B?WTlNTmNlNVIvUXdwNHc1RGhmeHBhODBWd2J0UEVLM0NFelpQMEVFcE1saTdW?=
 =?utf-8?B?WGd1UFNSQnJyZVF4VDRJazBnWndMSTRLSEpuWE42RTFTRlZNWlduTFlmYVp6?=
 =?utf-8?B?MXJEa1RObEJZNkkzK1dmRzJYK2ErN1FWN0pDT1BOUzhRWkd6anNqdjNEVTZN?=
 =?utf-8?B?dW52U1c5SituMmM1WWVXWWNrZ3NRWmNxT0dKRnlGU2VQVC9DVFZ4RU84YWlX?=
 =?utf-8?B?VkVxU0ZtSFFRSFA3WDFac1B3a0NWNEs1QU9SbjJ6QVE1VU03SGlRdFlEMWky?=
 =?utf-8?B?WEMxMzBLamtpeVFKZ3MzN1JVSFo4bitjTjVEamdzTzRXbG5LTFdGZEhjOThG?=
 =?utf-8?B?SkkwU3hpekN5UjFsbmt4QldzSGU4MGk4SGpPeVk0UnpYZmZIS2h2REUwcDBl?=
 =?utf-8?B?R0xhT2Q3Z3JqZ1lhcWNsQ1pZaWFVZE9DenBXVUJpd3dUN0RheDBQK2Y1c2pJ?=
 =?utf-8?B?cE9VSUdjaW9yN3hzbzNHYU82Q3dMZkdPOXZjcEJxQTNiL0JicFh4dFZhWlJK?=
 =?utf-8?B?Y0twRzNnUG5MUjgvSFZoR3pXNHZYdThLTkVMNHR2REh1Z2JHUzE3c244RUVN?=
 =?utf-8?B?YzA2TmZmK1dua0N2N0NXZVdYWEx2U05HRE9jN1NoSW1lUGo1MWJqQTNKb0dj?=
 =?utf-8?B?NXVMdEk2b2xJY05FTERZRzFaZUJGNmVaR1luZUpodTI4ajd3WUhGTTY0UEVQ?=
 =?utf-8?B?RmhNK0owTzF2ZlppbzNYTmpGRGlkcGR3alk4alpzU0YzYStlK0hPMFNzR3RG?=
 =?utf-8?B?Mk85T0N6WGV5TmtOU0N2R0FQc1cwOFdkU284d1V5Y3FHdnhSakRPMTVUNy9r?=
 =?utf-8?B?d1o1NWFvU3Z1Rk9BZW1pMXJNQ3JwSVRjVHB1cXlNbDdIek53OTJnZGVwaWt5?=
 =?utf-8?B?RkJEeE13Rm9Tb1J4MGZDN1QyTS9wdHhTWmZKTjhzQXRRNTlER0lra3cyd2Fs?=
 =?utf-8?B?eGh5N3JyMGFNbzk4eEVhNjJka0RjenNpVy9kRmFrSFZHSGplSjlwNjlYWVhX?=
 =?utf-8?B?dmNmR0xtSkhrcWlST0xHTTJ2V1YxcUJLRjdPOVRodDMvZFArbVd2MWM4QU11?=
 =?utf-8?B?R0N4TFBNN0l0L2IrQkNLUnBNZTFycGRMU1ptMU1Lcmp5V2RXRnFvTVZIK1BS?=
 =?utf-8?B?RnVUVVZoM2dGNC9DZHAwR1B4S014eC9QTzZ6SmJ2NTBEMzhiblhwZVYwUUZr?=
 =?utf-8?B?UXNhSVVKUUNUNkZNUm96a2R2L1VyU3JHQXVVaWNhUGdwSGFGWVdzREI4UnFr?=
 =?utf-8?B?bzR4RDNJV3lxM1d6NFBkUEtWMWRZOWpoSmVSRzJnT08ySmpSR1o0Q01tUEVO?=
 =?utf-8?B?TnVRK2c0cWpweHduSCtaSUVVYnBEYXBrRlAyV0ltWTE5akgyTUxEbkZodzRP?=
 =?utf-8?B?MmJCaTNoZ3NIQmVkcERXR1RGWEpFcHVzQUE0UVZmY1BQbC9RSEZkTllSdCtx?=
 =?utf-8?Q?tPOSV2Hk2ToD1b0J04Icfy1Tdb/THQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0dHcktRWnJ4Z0pwSEtCZnhFVFRtUjJ3Z3FjcWtOd1BBcjdIekRMdkFHVThj?=
 =?utf-8?B?VFFXYU5qWDlIS0JSQmpJeGVDSU90UzhlcDFEa29jWENJdkFPbHlmcmlVck0w?=
 =?utf-8?B?eG9TZzd2aFBPbS9rWnN6Ti9GSmNiR0k4TFNZYkRnZFNuR0pEU1ZITUVhWS8v?=
 =?utf-8?B?NHhIWVFXaU00VzR4MWJTZ3FLSnVZQVh1cDNXOVB1Ti92eW5iYW9uWEExZC8z?=
 =?utf-8?B?YmFMNURyUVpSVWRYTmV3ajNlYk5xTVFMZDNTTStZTmhvckhXNFBqRE1vd3ZL?=
 =?utf-8?B?YnZHQVFVMUExVWpKbjF2QVV0OFhNbjJuNzlUTGp2Tm5ZNDBBR0Zlelc3Y0RX?=
 =?utf-8?B?S252OURQVy82ZTZSR3hsZDhGTXo0am5uaWtuVEZ6R2Q5M3l6QjhiMnM3OE9p?=
 =?utf-8?B?M0hDbDhmRTJPZDlUVkJ2aGFBWmJiTzBLU256ZkZPcWh2YUNZUGEzUGxHU3dk?=
 =?utf-8?B?M0JZTlJKSnFtdEJOWjVWZHRTcWF4Q1RZUm1qYTZ2c0I2V2ZZaE0zaGd6TWxI?=
 =?utf-8?B?Z2dINWVIVElndDhSamRvamNPS28rbndHdFhZN0hkMDhWRkxwRFVPYVZ3ODU4?=
 =?utf-8?B?VjJPd1VMdFd6Z1F3Rk4vUlVrRjcvVjVSTy91TWtMYXZxeEtvSVhaQTF3Lzhh?=
 =?utf-8?B?VGpuNWVjS01CT3d2cktOazUyT2JUblBuTHA1L09sdlFUT0VlMkJhdG5WNXdG?=
 =?utf-8?B?ZEFVNUJUVHpKUkdNRFZleWV6UGNlYmo0NE5BQmdCOHF1eEN2cXg4TGQzcjRq?=
 =?utf-8?B?MjF4c3p3NXRxaTZCcWMyWVpOWHZRR201eHpPQThqL2dLUGZnOE0vMWFLbE9I?=
 =?utf-8?B?b09NL3ZMdHN0SEw2dUd3eHUwTHlOM2N5dmxiclRTMHc1ZDFzVjQvV2E3WWFW?=
 =?utf-8?B?OXZncVN5ZUJBbzVIcVIyRGJ4dGtoNDhZMHJORzR0V2pqaU1wSzloMXdBWUpl?=
 =?utf-8?B?RUk3cmFzMFhoaXoxYlZKUEFKODFveXRxNjhUREl5Y2NpeGdkNjVUOHZNdkNh?=
 =?utf-8?B?NVExaGRvODJhd29oQXZCcExRMThaeE1MUEMraVdwUEc5TG1IMVR5ZllTVlJ1?=
 =?utf-8?B?anZVZmxDT1hlbWx2MXdVVFpoK1RCRVRtajErODEzOHhsVWZDWGJzN1J5UFNV?=
 =?utf-8?B?NHppR2tGQ2UxL0RRVlVGNk1qZzJ6dnVTTDBhdnczdWhlYkZBR0VyTmVTZmZH?=
 =?utf-8?B?Z2duRDBsdE8wS3pBWjcwM2RPVGlOZHExVDYzRytaU3ZCZDVpb2V0VGIyNGdM?=
 =?utf-8?B?UTJoelRJd0JTMEZUdHFLQVBXMHZVUXBCbjVoM2MxMzBBQWVZT05UWG9FWUsr?=
 =?utf-8?B?SDFMSXduNkQ3aVFaT1dPSUtDT0JoRERObEMwZEpqNGxkRDhJcFhnZ1FRZzlH?=
 =?utf-8?B?a0xTZWJEcUZwUmJlaWsweFZ5Z2crYWJENHVJNVdORDdyT1UyeENwUkFrNlFZ?=
 =?utf-8?B?WERWTEIxcFF2Y2hua3ozbyt4Y0gyZ2U5UFlCcDcvUTNvYmRGUDdFYmVwcGFq?=
 =?utf-8?B?cXQxL1N3dE1tamZxM3IvR08vaS83elA5ZjJqL2xFeDIvQ05OQks3OVR0OVZ6?=
 =?utf-8?B?MUE1eURxNm5ad3hwYi9kcTM1dUhOcG44YzdPTWhQZ211YlBjcFYzTHY3Ym1r?=
 =?utf-8?B?UFRJeDRMM2RVb2ZQRlUwb3M2OE1oZ2Q2QXNRWVVhaVRCeEZ6ZUVmV0cvbUhq?=
 =?utf-8?B?TWxHSmt1U2ZqRjA3OExFTXVaSGZybUs0ZzJaY2hlOHJFWjRwcDQ1MDhrbWd5?=
 =?utf-8?B?MTFtb0VlWHFoaE0yOWFTemRKMUVmSWU5d1BxdFA5OG1lRXd4S1drdzZJQkVI?=
 =?utf-8?B?dEJGN24wYmd2T1dsTXNKSHRtWEpYUjZhQVZ3MUNJcGdpbXg1SkN5a0NJS0RJ?=
 =?utf-8?B?T1Mwc0VHL2dva3k0MzhRQkFsbVJ4NGZQY0xZRGtibVczaStoVkFaY0dnVXVC?=
 =?utf-8?B?RWNRcUg3dVFWK3NjSTJmY3lxVHRNbHBFbHhPNlV3YUY4eUpud3htcXorSHRn?=
 =?utf-8?B?TzZrajlaUjhXS0lEeE1EOTZ0ZjVPd3hKZzlRRlUyS08wd29CbTJtYkNFdjdV?=
 =?utf-8?B?OERnSkd3SE5Ka0U1RklVUlB3dDJDdGNkL3NkbnNTdnpyOWxnYktWazhCWTRh?=
 =?utf-8?B?NllYcTFXNS81R0dHTThlRFB3S2JMMzlLRXV4SlozVzNrTTIxNklucExnSWEx?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <802347FACEA886448231C9BCFA403821@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e739947-003d-4646-4356-08ddd9f8da8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 23:34:59.7598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p/sBS3denIG1U2CIHWbKjqkOn+LSJScT2suWkJuhRrWhapBqP0wDty+f1i1M2KREXB6YsIAoy5qdPlpZeqZKNBg3iGMD9fu8s6J7EX0W9tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7263
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDE1OjAwIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBJTU8sIHRpZWluZyBsaWZldGltZSBvZiBndWVzdF9tZW1mZCBmb2xpb3Mgd2l0aCB0aGF0
IG9mIEtWTSBvd25lcnNoaXANCj4gYmV5b25kIHRoZSBtZW1zbG90IGxpZmV0aW1lIGlzIGxlYWtp
bmcgbW9yZSBzdGF0ZSBpbnRvIGd1ZXN0X21lbWZkDQo+IHRoYW4gbmVlZGVkLiBlLmcuIFRoaXMg
d2lsbCBwcmV2ZW50IHVzZWNhc2VzIHdoZXJlIGd1ZXN0X21lbWZkIG5lZWRzDQo+IHRvIGJlIHJl
dXNlZCB3aGlsZSBoYW5kbGluZyByZWJvb3Qgb2YgYSBjb25maWRlbnRpYWwgVk0gWzFdLg0KDQpI
b3cgZG9lcyBpdCBwcmV2ZW50IHRoaXM/IElmIHlvdSByZWFsbHkgd2FudCB0byByZS11c2UgZ3Vl
c3QgbWVtb3J5IGluIGEgZmFzdA0Kd2F5IHRoZW4gSSB0aGluayB5b3Ugd291bGQgd2FudCB0aGUg
RFBBTVQgdG8gcmVtYWluIGluIHBsYWNlIGFjdHVhbGx5LiBJdCBzb3VuZHMNCmxpa2UgYW4gYXJn
dW1lbnQgdG8gdHJpZ2dlciB0aGUgYWRkL3JlbW92ZSBmcm9tIGd1ZXN0bWVtZmQgYWN0dWFsbHku
DQoNCkJ1dCBJIHJlYWxseSBxdWVzdGlvbiB3aXRoIGFsbCB0aGUgd29yayB0byByZWJ1aWxkIFMt
RVBULCBhbmQgaWYgeW91IHByb3Bvc2UNCkRQQU1UIHRvbywgaG93IG11Y2ggd29yayBpcyByZWFs
bHkgZ2FpbmVkIGJ5IG5vdCBuZWVkaW5nIHRvIHJlYWxsb2NhdGUgaHVnZXRsYmZzDQpwYWdlcy4g
RG8geW91IHNlZSBob3cgaXQgY291bGQgYmUgc3VycHJpc2luZz8gSSdtIGN1cnJlbnRseSBhc3N1
bWluZyB0aGVyZSBpcw0Kc29tZSBtaXNzaW5nIGNvbnRleHQuDQoNCj4gDQo+IElNTywgaWYgYXZv
aWRhYmxlLCBpdHMgYmV0dGVyIHRvIG5vdCBoYXZlIERQQU1UIG9yIGdlbmVyYWxseSBvdGhlciBL
Vk0NCj4gYXJjaCBzcGVjaWZpYyBzdGF0ZSB0cmFja2luZyBob29rZWQgdXAgdG8gZ3Vlc3QgbWVt
ZmQgZm9saW9zIHNwZWNpYWxseQ0KPiB3aXRoIGh1Z2VwYWdlIHN1cHBvcnQgYW5kIHdob2xlIGZv
bGlvIHNwbGl0dGluZy9tZXJnaW5nIHRoYXQgbmVlZHMgdG8NCj4gYmUgZG9uZS4gSWYgeW91IHN0
aWxsIG5lZWQgaXQsIGd1ZXN0X21lbWZkIHNob3VsZCBiZSBzdGF0ZWxlc3MgYXMgbXVjaA0KPiBh
cyBwb3NzaWJsZSBqdXN0IGxpa2Ugd2UgYXJlIHB1c2hpbmcgZm9yIFNOUCBwcmVwYXJhdGlvbiB0
cmFja2luZyBbMl0NCj4gdG8gaGFwcGVuIHdpdGhpbiBLVk0gU05QIGFuZCBJTU8gYW55IHN1Y2gg
dHJhY2tpbmcgc2hvdWxkIGlkZWFsbHkgYmUNCj4gY2xlYW5lZCB1cCBvbiBtZW1zbG90IHVuYmlu
ZGluZy4NCg0KSSdtIG5vdCBzdXJlIGdtZW1mZCB3b3VsZCBuZWVkIHRvIHRyYWNrIHN0YXRlLiBJ
dCBjb3VsZCBiZSBhIGNhbGxiYWNrLiBCdXQgaXQNCm1heSBiZSBhY2FkZW1pYyBhbnl3YXkuIEJl
bG93Li4uDQoNCj4gDQo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vQ0FHdHBySDlO
YkNQU3daclFBVXpGdz00clpQQTYwUUJNMkc4b3BZbzlDWnhSaVlpaHpnQG1haWwuZ21haWwuY29t
Lw0KPiBbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjUwNjEzMDA1NDAwLjM2OTQ5
MDQtMi1taWNoYWVsLnJvdGhAYW1kLmNvbS8NCg0KTG9va2luZyBpbnRvIHRoYXQgbW9yZSwgZnJv
bSB0aGUgY29kZSBpdCBzZWVtcyBpdCdzIG5vdCBxdWl0ZSBzbw0Kc3RyYWlnaHRmb3J3YXJkLiBE
ZW1vdGUgd2lsbCBhbHdheXMgcmVxdWlyZSBuZXcgRFBBTVQgcGFnZXMgdG8gYmUgcGFzc2VkLCBh
bmQNCnByb21vdGUgd2lsbCBhbHdheXMgcmVtb3ZlIHRoZSA0ayBEUEFNVCBlbnRyaWVzIGFuZCBw
YXNzIHRoZW0gYmFjayB0byB0aGUgaG9zdC4NCkJ1dCBvbiBlYXJseSByZWFkaW5nLCAyTUIgUEFH
RS5BVUcgbG9va3MgbGlrZSBpdCBjYW4gaGFuZGxlIHRoZSBEUEFNVCBiZWluZw0KbWFwcGVkIGF0
IDRrLiBTbyBtYXliZSB0aGVyZSBpcyBzb21lIHdpZ2dsZSByb29tIHRoZXJlPyBCdXQgYmVmb3Jl
IEkgZGlnDQpmdXJ0aGVyLCBJIHRoaW5rIEkndmUgaGVhcmQgNCBwb3NzaWJsZSBhcmd1bWVudHMg
Zm9yIGtlZXBpbmcgdGhlIGV4aXN0aW5nDQpkZXNpZ246DQoNCjEuIFREWCBtb2R1bGUgbWF5IHJl
cXVpcmUgb3IgYXQgbGVhc3QgcHVzaCB0aGUgY2FsbGVyIHRvIGhhdmUgUy1FUFQgbWF0Y2ggRFBB
TVQNCnNpemUgKGNvbmZpcm1hdGlvbiBUQkQpDQoyLiBNYXBwaW5nIERQQU1UIGFsbCBhdCA0ayBy
ZXF1aXJlcyBleHRyYSBtZW1vcnkgZm9yIFREIGh1Z2UgcGFnZXMNCjMuIEl0ICptYXkqIHNsb3cg
VEQgYm9vdHMgYmVjYXVzZSB0aGluZ3MgY2FuJ3QgYmUgbGF6aWx5IGluc3RhbGxlZCB2aWEgdGhl
IGZhdWx0DQpwYXRoLiAodGVzdGluZyBub3QgZG9uZSkNCjQuIFdoaWxlIHRoZSBnbG9iYWwgbG9j
ayBpcyBiYWQsIHRoZXJlIGlzIGFuIGVhc3kgZml4IGZvciB0aGF0IGlmIGl0IGlzIG5lZWRlZC4N
Cg0KSXQgc2VlbXMgVmlzaGFsIGNhcmVzIGEgbG90IGFib3V0ICgyKS4gU28gSSdtIHdvbmRlcmlu
ZyBpZiB3ZSBuZWVkIHRvIGtlZXAgZ29pbmcNCmRvd24gdGhpcyBwYXRoLg0KDQpJbiB0aGUgbWVh
bnRpbWUsIEknbSBnb2luZyB0byB0cnkgdG8gZ2V0IHNvbWUgYmV0dGVyIGRhdGEgb24gdGhlIGds
b2JhbCBsb2NrDQpjb250ZW50aW9uIChTZWFuJ3MgcXVlc3Rpb24gYWJvdXQgaG93IG11Y2ggb2Yg
dGhlIG1lbW9yeSB3YXMgYWN0dWFsbHkgZmF1bHRlZA0KaW4pLg0K

