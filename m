Return-Path: <kvm+bounces-49105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2DAFAD6003
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67266189C8BA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F0523C8A4;
	Wed, 11 Jun 2025 20:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqQnn8F5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D711DE4CD;
	Wed, 11 Jun 2025 20:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749673541; cv=fail; b=LJ3sfEwAdsNBSLZ42K/0J0k3fvamVkEmI8TtRkISD1F1tkq/LSpSE+b2vIOInIY7TC+Vz85iuELz6p4ZaT78wxIYFWMv4ZSuwZBO7m5KDTs6uc2cHByuFpRkvw59nSrEoEWBc5Usy9f6o9STAPXKQAk3TPZG53Ze9kn0gQHNOjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749673541; c=relaxed/simple;
	bh=JU7R7z7Ru2lzLJR5wfm8Unqenb1xul0WeRMuUZ9QCUo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j5MDk+P1wb92IlIoeSesX+0XY/TMB7cD+RFU5sUdIByPl3mdu9Cby+d5fS7lRn1xnMb7EVlF03+Wqdnfi0P6GZ4Rh50np5M3NNCXq/PoZJtLrGZ7uwgiUhBJJYChulwho4iXmFmLH/aXIFqPBFyApiGsWpq4jqvq91uzb5CbWJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqQnn8F5; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749673540; x=1781209540;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JU7R7z7Ru2lzLJR5wfm8Unqenb1xul0WeRMuUZ9QCUo=;
  b=gqQnn8F5fCl2tusT7B822Ukb0eHT0BhGlS70mfo5JSBNsVSTqaNZ4dRM
   F9LZSY4VElVFdxwsvC86sFMFPK2OGCjyAvaAchc/qum0IzxT6Qk8wSMDP
   QbUxq6zamsKOYJAG6tuy9DcQNm5WiUxOSSKvWhkXF0ULPhM/EXh9rjonV
   bzpFkUoBm8232IdD/M5NrbwC41muNaQdxfpPB3pN4zgRxZy+AkT7yrY4y
   sGvE9jN7MOEc7WbP0sw/2DxoIDOAY8F2jBtmxwVfLUXREcni7TXBQhekS
   SJ+FC1RP5uVvvVIowkfbh5inS8JXZuXCGKvjNF4heOO34tt1DuLMNKo92
   Q==;
X-CSE-ConnectionGUID: 8z5rLMeeSiifTmdKWrJZjw==
X-CSE-MsgGUID: l/RJ/IoXSbGga2SrMz6jIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="55502912"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="55502912"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 13:25:39 -0700
X-CSE-ConnectionGUID: xNSp/BUjQ7SkrSIikrQUCQ==
X-CSE-MsgGUID: 7RqvUz7zTzCxNYqjURg7Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="147201765"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 13:25:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 13:25:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 13:25:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.54)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 13:25:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+72pWc3EAVIfSXIr0HH3bdMQr/q2tCTIRbABVSdt5PiQ3lJLofZGQbWWEeydEROjkgQ1gOh77x6ATNl6+N9qIB96fS7xQPif2Mm/+6kO19yj6jCeDClGduHTyhyoKd88st3c7HOqzYADLqOwmfd9+SEvP/eV3TN64SZgvFU9Wb5+sJmdNcyTVJkgb3NKrbDltdEkCU1sfj98fWiuo/OfGeg6MtkmFn2TCPFg3I4t5yGVkbjqQHrhxhEe2PtD9Hte0YK7GG2TpE4UPy9cmy+B3CuXXOOWXAkg+ueUeh+JbuwuIz1LOYEAYhl7lXwpNXOLyGB1QoPRFKNqzvKWoO2zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JU7R7z7Ru2lzLJR5wfm8Unqenb1xul0WeRMuUZ9QCUo=;
 b=eJMBxMFbhjwMiE/5XPqFbOLe+osMpyBnKxHUo0fRYPYj8zaJL1JOIiq4vOpl/RwMC4LWMt6DsYT7MLuZbMYvx6+tardBz017OxiWJR323xX37B8c7rxts6//mQJDnaFDr3NpNu+KGVrxxTfas0FSxlvUAr1arNovqUNBYhUWIQQFidUErn0Oa9vlkichxbgnS9PqM9iqkV6Ex5IArucaAAk33CYNssKtQX4v9x7zoLqNLI2WZ3azjyeBJRFHJ+k5KgJK7B5DavxD6NFe4SYL/iginFyZ29pVVqOmn+tcomMZYKEaPghT1WJDJvsaOXVpcc0XxqWqBz+YTBYF9PkjSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7956.namprd11.prod.outlook.com (2603:10b6:208:40b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.27; Wed, 11 Jun
 2025 20:25:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 20:25:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Topic: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Index: AQHb2mYn9dWQDgvWTEqusObPtA6y57P+Q2SAgAADDACAABVmgIAADVSA
Date: Wed, 11 Jun 2025 20:25:33 +0000
Message-ID: <7de83a03f0071c79a63d5e143f1ab032fff1d867.camel@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
	 <aEnGjQE3AmPB3wxk@google.com>
	 <5fee2f3b-03de-442b-acaf-4591638c8bb5@redhat.com>
	 <aEnbDya7OOXdO85q@google.com>
In-Reply-To: <aEnbDya7OOXdO85q@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7956:EE_
x-ms-office365-filtering-correlation-id: d66f0d79-11cc-4e2a-36fd-08dda9261e52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aGRJNCtPV1NxalNsQlArcmRCMXRFWm1HNmszdk9iMW9kVjNBOXpzYUNWbmFy?=
 =?utf-8?B?OCsxYzVSUVo0d0w3RFJOcW90cUJrMVozS1lLN0ZjZ0Z5d2FuNTNUc3Btd0dJ?=
 =?utf-8?B?ZlA3ckZrY0VsbjNKNWNNN0kySkp2TjNjQzQxSEZlbTgrOEVUcFpWN3ZBdkV3?=
 =?utf-8?B?V1pJRkd1WFA4YUhZZjFnM0hLNThtM3pselNSMXY0eDl3MG5HLzRkQ243SUlm?=
 =?utf-8?B?OVM5WjZSN0lQRDdROEk4SmFsMU9yck0wSys1VStDREt0bzg3Z3pzV2lOOUZT?=
 =?utf-8?B?ajRSYk5FQWQ1QlpBSmo2alRSZHBUdEpwKzJhQ3VYUjVsR3czbWdaSkNTclM3?=
 =?utf-8?B?TEJaTGh5cWJkVzZWbVFTWDZWWDJiTDhXTHk1UFk5K3F6WUovWDFtTjBPbTN3?=
 =?utf-8?B?bVNzNmM0ZjF2bm0vbzZ1dXZLOEdqUUZSRndiK25Vd3lxcDdxZ05hY1JDRFl2?=
 =?utf-8?B?S1BmRWVjbXo1TncvdWx4L3FBVndlOEpSY25mQjRxQ2hvU2JNYzVUby9sbjAv?=
 =?utf-8?B?TWxub0VBRTJEMXZVckkrRjJzTzl2N2pYeEtiUS8rdFhsc3piVkFTVTROZ1RB?=
 =?utf-8?B?MWFSL1JGcUxWZ3l1Wmg2NTRIc0lOUnR5YUhWMjRkbGNlNXNxd2VqRXFOSmVh?=
 =?utf-8?B?YWswOGoyV2crL1pmU1VHRm5qQUF1VVRLRzBCS3gvcmFOMGFOUStob3AvVVFG?=
 =?utf-8?B?UzViRFBQRzVBYmlJQ3Q5RmFaTjhDUVdVdHZhM1B0VHFhKzFreG1tOHA5SHhM?=
 =?utf-8?B?Q1NySGorSDlWd0ZiQTVjNWxNWjdIZ3c5VSszUllKcjBXUjhvZFc1MmQ1aCtn?=
 =?utf-8?B?djdCNStsZGd5SWgrYUxBN2tmRWk1aEFRaWdtWm02Y1paSEE1M3JVTjB5TWJG?=
 =?utf-8?B?YlhUcVF5WXBGa3I3U0p6WXgxRHY3RWJTaWZ6a0ZqSk9XL0xjZ2wrQ2NyVHlW?=
 =?utf-8?B?MU5sNkh5RGp1S29LeTFHT25JYzdObUNGNG5zRDFrREM1emxTd2hXR3N5M2U3?=
 =?utf-8?B?YUh2NTlDQUppNFpxNWRrQytiQzl4aVhDTWJPM3Z2Z3ArQ2JjaVVJcm4rSENH?=
 =?utf-8?B?dUhGY2VLVWtWYm1NcXFzeklTMFdWTnE1Z0IwODY1TkY4bDZDUm8weTU5NTdK?=
 =?utf-8?B?aXBYbkx1cVlWVFZVWHI4WGZTZVlLYlMxVW5TWktIL3FhbEpOYkhQL2JMc1hj?=
 =?utf-8?B?UEZuVkVKcERPalArOVVITlZZREFZdkh2UDBrSit0OXVESHBiWElyWFZmb2gy?=
 =?utf-8?B?ZmxVYzFXelkzZk9WaGVOL1FMK1U3YXhuOXd0NXBSNytGT3F4UlBjakc2dU5x?=
 =?utf-8?B?SFJPbldlVW5kNytMUUtUVnZ6RzVJSEJja2V0RzNQczNDRTI2ckttYWUxY0R1?=
 =?utf-8?B?Nk4vdGY4YmNsVW5kbW90OTZIaDFZN2E2UVBsb2NBU3E2NG5Uck1SOCsrRW0y?=
 =?utf-8?B?UjhhRDE1UVZXcExubDZ5MTNybUVmZ01BSW90eFFTN1NMeUp2WThOeFI1YVVM?=
 =?utf-8?B?VHFiOWRTT01Ya0lpSWxwdVR2eSt4WXBXVzY5cUZ1Z2lvVnN5MEFaZ1UxcWNy?=
 =?utf-8?B?Qng2R21wUWVkQUVDbnRMQkpQam5VWTB4M3pYTGtDYVYwZDViNXh3UHVPTElX?=
 =?utf-8?B?QWlsNmRSamxielR6ZDZNVDBRNkxjeFowNDZ4YjdpUmE3NFVVYnR6cDIwWVA2?=
 =?utf-8?B?QWpSZk5tamFndldJTmRHeDdwdkVUUS9BOVA0V3RwTUk3M0ZwVnBHLzBqRDNT?=
 =?utf-8?B?SWRXYkx4L1Q1aWR0bGxDaVhvMlJlMjNmK01UU2VsdWtlNlBLb24wL0NDQ0xE?=
 =?utf-8?B?ekhRLyszeGl4Ylg4aVpGa21TWmt5RVNwM1FVeGZFZTFsMVRwM3JaK3ZURGgw?=
 =?utf-8?B?b2RKRWxYV2pDWkQwekV5MW02cnhuemdMVEZVSkFETXdCNnFzZU12dkd2cEpS?=
 =?utf-8?Q?Niw+EGq3hPo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VE5vTzB2dHlsS0dQc29kNlJMMFh5QTRCaWx1Tm9MQzQwdS9DcE1KOVcrUkpr?=
 =?utf-8?B?dFYxSFBpeG9vYmFDTVBGK0dEdzVQSGFuMVRaMEh0SEN6bXJEZFI2b0pPbm5R?=
 =?utf-8?B?S29vSWlQQkFuSUxmMWdPUElSZXN4TGljNmlISWNmZ2Vhd1JPOUY1YkY3TVpu?=
 =?utf-8?B?SUxSVkt1OVhPZVoxd0xSZlVEUHozbUp5c0JuUUduVFlpdXM0NjZxdGxETjZm?=
 =?utf-8?B?ZFNPaEx0bEY2d1UzMFZ4TTI0TEhwNm1SQXFsbjNjREt5YURLUUI3a2NycTBo?=
 =?utf-8?B?NU5PK0d0N2ZRSFZ2NVJobms4dlkvZ0k1NWZqV1FHcVJad2JoS2lTd05Rc0Jz?=
 =?utf-8?B?QWhNR1NESVZ2ZGpHVW5icVFndy9RSGZlenpLTmRFbjNZYlBpTldrV01Ka0ts?=
 =?utf-8?B?WmF5emQwc2lqSWc4TXFOTitvTUp2c3pRcWE5eWZEK0l6SEZ5TEtSOXdhQU8z?=
 =?utf-8?B?YkJ5WTg5M0ZudFpJM0U3Z0hUd0ZuRGF5dzhJYkRQR2h3VTBiS040Y09sTm83?=
 =?utf-8?B?dExiUHNZTzIzRytuam5MOUZSR1VsVjJWM0VFTDdtbmdvS29IRlVRNHZpMkZo?=
 =?utf-8?B?T2dTdkJPbFAxZmVFVVd4MklJUDE5NEtOTHZ2UXhIUzF1ZU10SlhrNEFvdjFI?=
 =?utf-8?B?NWd3Tk9YbXhHSUtsT01zNWpXRUtwbUJ3V3J0WEo2cFU1dHVMVS9yUVNBb3ZO?=
 =?utf-8?B?MVhCbmxia3FFQm14cnczODVqMENWeVFGVFZMKzczelh3dkZRTy9oQXlqSzRm?=
 =?utf-8?B?R1pTVURENDJxTlRhZm52SnM4VXJDa0RhUVBUNEp1SEtXSEtDbDNjUzE4cmVw?=
 =?utf-8?B?dmFvQzZPNGdoeDJjNkRpSks5UVQwWnRueDhoNmdoS1BUdmFoVUxvc2JGN0E2?=
 =?utf-8?B?NUZBOGExcXFEb3dyTDQ5aHA3Vkd5N2FIRnM1Rkd2VU1VTUFadGNyUWJCTnFn?=
 =?utf-8?B?bTZJNWVXSG8wUmxzVlVRK002WHV0Q2QxODBoUjB0K3Q5bSt1WlBoMFJMQ0Ro?=
 =?utf-8?B?UDJuRWpOT3hDYVBrRTg3R0pBdG9ZWVV2b3RMMzV3NVhMYUlDY1lYRnlDUXFa?=
 =?utf-8?B?UEZLb0RLWUdSSk94QTNzMExHN0NkZkpJSDBOVkFlRXJ0byt2VU0vcm5KYVJM?=
 =?utf-8?B?cjh4bGdwT0xTRVJhSmJLdk9ZSlNha2phd0REUkNaZjFkL1pmb0cwbHdGdkt6?=
 =?utf-8?B?cGlObXRYR29WNEpGakIxREJ1bWpVTmxXSVpDY053TjA4ZS9OYlAxRUdoQWls?=
 =?utf-8?B?LzN2Um5WR3B5eXBzclVKNUphNVVaSFc5NFJhNEN6eEVEM0NQTFk3ZlhhdzFy?=
 =?utf-8?B?QUJmeXc1bGRWZ0t1QkkySXM1UXR6N3RKS0tRS3NWNmVteTJLRDFNRVYyVmRs?=
 =?utf-8?B?aEtZNGh0VSt5b3NOSUw0Z1g5MEEzTWJIRjAweGhycUQ0TXR3Qyt2U3p2N3dO?=
 =?utf-8?B?dEdoVi9ObzdXVWRvZFBqMDlPUWZxY1VRMUlKbURDUHhjaUpVMkt2Q1RxT3RI?=
 =?utf-8?B?d2Y3LytPUmhOYmlOVVJUek1XU1poWEpKb0FDOWRwVHdMMVRaM3R4K0paeVV3?=
 =?utf-8?B?L0pQSDN5Mis4YWR2MmsrWTBzMnNzWGNlYzNqOCtkVlNVcVlkTWJzdVg1amxZ?=
 =?utf-8?B?UFMyS1UyZ0YrVS9LM1Z1WGh0R3VOUFo3QWZaM1Fyc1NMRGJSR1hBSXhXWDN5?=
 =?utf-8?B?V3VZNEVYcnNJNUlsNVFCcTFuM3lscHpEOXJZZTdZUldCWkdWaDY5ZEtMUm1W?=
 =?utf-8?B?SVdqM2g2Q3FsQUQvckZmU3dBWncvanpKV3kvQlVDWmZTSzgzcUVaNFdQNWxH?=
 =?utf-8?B?RmRFZUJKVFRuMjhwSHJjUFdnRWxQTHNLUExtK1NnVTJ3TFkxNitLaWhJWTgx?=
 =?utf-8?B?dVgxZUc2YnJIMytqTFFQV1ZYQWNCU3E4NHZmNUJEcHkrYmljeUlkNEliR212?=
 =?utf-8?B?VjEyc01YVjZ0YWFwdXJOYS96NTRUK04ycVVaeXNyeW00NDJlN0VKZWl2OEwz?=
 =?utf-8?B?YXNNVzJscXVoSGJJVkF1Y1pWNTRNWmY0L05sUlF5WlYwcU55eEIxWFNxNzgw?=
 =?utf-8?B?R0NHb01vZ0Z1OXJvb1RmWnExWEFEd0VtcEFTeFJ2eFlaWUE2R1M2M1FQdTlZ?=
 =?utf-8?B?NURJY01XUmNUa0RuMVlvY2ZwV2NZSGx6d3NveVhjWHhDL2d1anFSRU9aQ0E1?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CE2887899F7244CBBC6725E0A5CB974@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d66f0d79-11cc-4e2a-36fd-08dda9261e52
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 20:25:33.8465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6DwfekdF3XdjcVc9t1uf8otzG7QfI7QVSBUzL8SvZ3HEbTbfwFjBfOr1S8p0QsDssJPr5x3s1l4h8Ls02Lvx+8Rg7NgEZkl7akxQQnxaSU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7956
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDEyOjM3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVZ2gsIGFuZCB0aGUgd2hvbGUgdGRwX21tdV9nZXRfcm9vdF9mb3JfZmF1bHQoKSBo
YW5kbGluZyBpcyBicm9rZW4uDQo+IGlzX3BhZ2VfZmF1bHRfc3RhbGUoKSBvbmx5IGxvb2tzIGF0
IG1tdS0+cm9vdC5ocGEsIGkuZS4gY291bGQgdGhlb3JldGljYWxseSBibG93DQo+IHVwIGlmIHRo
ZSBzaGFyZWQgcm9vdCBpcyBzb21laG93IHZhbGlkIGJ1dCB0aGUgbWlycm9yIHJvb3QgaXMgbm90
LsKgIFByb2JhYmx5IGNhbid0DQo+IGhhcHBlbiBpbiBwcmFjdGljZSwgYnV0IGl0J3MgdWdseS4N
Cg0KV2UgaGFkIHNvbWUgZGlzY3Vzc2lvbiBvbiB0aGlzIHJvb3QgdmFsaWQvaW52YWxpZCBwYXR0
ZXJuOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2QzM2QwMGI4ODcwNzk2MTEyNmEyNGIx
OWY5NDBkZTQzYmE2ZTZjNTYuY2FtZWxAaW50ZWwuY29tLw0KDQpJdCdzIGJyaXR0bGUgdGhvdWdo
Lg0KDQo+IA0KPiBPb2YsIGFuZCBJJ3ZlIG5vIGlkZWEgd2hhdCBrdm1fdGRwX21tdV9mYXN0X3Bm
X2dldF9sYXN0X3NwdGVwKCkgaXMgZG9pbmcuwqAgSXQNCj4gc2F5czoNCj4gDQo+IAkvKiBGYXN0
IHBmIGlzIG5vdCBzdXBwb3J0ZWQgZm9yIG1pcnJvcmVkIHJvb3RzwqAgKi8NCj4gDQo+IGJ1dCBJ
IGRvbid0IHNlZSBhbnl0aGluZyB0aGF0IGFjdHVhbGx5IGVuZm9yY2VzIHRoYXQuDQoNCkZ1bmN0
aW9uYWxseSwgcGFnZV9mYXVsdF9jYW5fYmVfZmFzdCgpIHNob3VsZCBwcmV2ZW50ZWQgdGhpcyB3
aXRoIHRoZSBjaGVja8Kgb2YNCmt2bS0+YXJjaC5oYXNfcHJpdmF0ZV9tZW0uIEJ1dCwgeWVhIGl0
J3Mgbm90IGNvcnJlY3QgZm9yIGJlaW5nIHJlYWRhYmxlLiBUaGUNCm1pcnJvci9leHRlcm5hbCBj
b25jZXB0cyBvbmx5IHdvcmsgaWYgdGhleSBtYWtlIHNlbnNlIGFzIGluZGVwZW5kZW50IGNvbmNl
cHRzLg0KT3RoZXJ3aXNlIGl0J3MganVzdCBuYW1pbmcgb2JmdXNjYXRpb24uDQoNCj4gDQo+IFNv
IHRkcF9tbXVfZ2V0X3Jvb3RfZm9yX2ZhdWx0KCkgc2hvdWxkIGJlIGEgZ2VuZXJpYyBrdm1fbW11
X2dldF9yb290X2Zvcl9mYXVsdCgpLA0KPiBhbmQgdGRwX21tdV9nZXRfcm9vdCgpIHNpbXBseSBz
aG91bGRuJ3QgZXhpc3QuDQo+IA0KPiBBcyBmb3Igc3R1ZmZpbmcgdGhlIGNvcnJlY3QgR1BBLCB3
aXRoIGt2bV9tbXVfZ2V0X3Jvb3RfZm9yX2ZhdWx0KCkgYmVpbmcgZ2VuZXJpYw0KPiBhbmQgdGhl
IHJvb3QgaG9sZGluZyBpdHMgZ2ZuIG1vZGlmaWVyLCBrdm1fdGRwX21hcF9wYWdlKCkgY2FuIHNp
bXBseSBPUiBpbiB0aGUNCj4gYXBwcm9wcmlhdGUgZ2ZuIChhbmQgbWF5YmUgV0FSTiBpZiB0aGVy
ZSdzIG92ZXJsYXA/KS4NCg0K

