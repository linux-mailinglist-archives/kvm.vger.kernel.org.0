Return-Path: <kvm+bounces-12481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD64886B33
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 12:20:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAB59B20FD0
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 11:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89F3A3EA9F;
	Fri, 22 Mar 2024 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aflntwNF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF47617552;
	Fri, 22 Mar 2024 11:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711106407; cv=fail; b=AAvgcO5f0MqIrV4q3+XoJhDVsVkR6mvDpBGIJNIuQMyjQIN1YQM7viFIw9y+6ByTxJXfSKYJ0dUXvmaKCfOoTyq95YcNVrbKKJfaCjqt/dfFhVqB8UGS8XlY959lOZuWlqUGptbacwl+PGRQWuuaxFzLjcNbIoXFZWIDcSN1ASI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711106407; c=relaxed/simple;
	bh=Eg/wWDE8vUxAVEz/Yw1Ak3SGsO5AB3dL2xAu4Hq5P3E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cgpXDiNNEzr+GNQ/rZyIFociQJH+++j4V6jDw/lAZRmk9jVUQVY2UtMnf5fuy3dQR9vGP5fRq5iXRG4g9MvC7Rds5Dyp/42+juGmAW+BK9BJx17Keuqovq3sJJCs8SO1MgJgHv/o8UFl5Or/fq66QOeDwraayaVS4DXvwOYbXyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aflntwNF; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711106406; x=1742642406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Eg/wWDE8vUxAVEz/Yw1Ak3SGsO5AB3dL2xAu4Hq5P3E=;
  b=aflntwNFGrDnqcE1B0q7x35anpGl+2868gCuIHsCxdMXxblX3vFQnEfI
   kCRLv5hIK9Jya7XkpmoHPznVBdsRfVgivYd37vd+rQbPsPm/ESwPA0Ghs
   oAwekVqNVwnLOcnYefbhnMU+1PMl/EPA04NyWNjWxHctIjLhd6Mvxmedv
   EexUOQasTKHi0laH7o9Fr7i5Zeorfa8CvOeLIItM3zBT7g7gUSNwKi1fe
   qb1qJ7hnVHqlQkVrqGpWp9kpHCrsg4ck6Oh3FIOcAsfXk0aa9gGD8AXqS
   JWsjNkOICNrEXfJohAoPQNE2ZOTNbtEgnM/KOHFzPGDXlGi0B30TS4NZ2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="17296197"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="17296197"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:20:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="19570008"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Mar 2024 04:20:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 04:20:04 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 04:20:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Mar 2024 04:20:04 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Mar 2024 04:20:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/XAN1evXHFtCk14p6Qhyi+ObHj6IZEDMsOcFcRue8VYfgIUWEQv/avEi1vKs4hCee6rUAq3TzT4iPbGXmLHAPDHA5pPrWc9YfOUlfhY1Jl6s0fLTO2XJLob/MFnsGXL4e3ql0n36UNwsQDR4eXtxGgCCaQCHufAzTD7dZsELY0SLdOfAmczXw8y/ngGG3CN0W/k2risFwvBQUGi2vLSHen/NOAHYoiT7zGY8bYxI7U6i7ZRjkBZL5/SYeHSI/JAgBc6/wTkBl/WzA8eNhTRxR9QhZwVMG/SRhhWvg98FhTRds7OV+FCSTwJi3Rjco1YXh71QNuCLqWZHGmYTYSxVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eg/wWDE8vUxAVEz/Yw1Ak3SGsO5AB3dL2xAu4Hq5P3E=;
 b=djBHL4uGJr6HVYs09YpcKiSuOBrlZvIhIvvuSuNXFPoJbkV2XPYe259Gg+KJyiRWqqw2prbl+xU6atFNBjZLUQPEqJ9sEPOrjVluK8gb3GUMdRScgpY384ai/uqclOaXqOcYPmKvpLbMp7M1nljiKF+0g9kAO8Cs53/YGUobXPaTC832Z6aDSLYBDg7elMwZWruEA6Cmi4oV26pZFeze08P/Iqr0huxx3t0yZLKfI8djd3aqVKwiXJAxo6gBmsDTCV8cObX8yvt3KcoQarfY+sG4tLASJs7aLasZ/Cog2w5IEG7/fywOMpkyi5ymsmGZGo10cDWSPWWaarhNAVmCfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8597.namprd11.prod.outlook.com (2603:10b6:510:304::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.23; Fri, 22 Mar
 2024 11:20:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Fri, 22 Mar 2024
 11:20:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHaaI27+nW2+xDcBUuwRQ1CzA45brFDxKKA
Date: Fri, 22 Mar 2024 11:20:01 +0000
Message-ID: <5f0c798cf242bafe9810556f711b703e9efec304.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB8597:EE_
x-ms-office365-filtering-correlation-id: 014bb4be-8411-4c03-e9ae-08dc4a6203d5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KgHIgmoCl5o6LWRl261lVaGZhqvg+0Xg5AxraKuK65q9vif9V5ZhkIG7xDVjoj4/yFynTkWIhKnKrN/w49SBYtgZdzVEsQ8HClwORuLDhfMQL+jQu84AEQTA40DVuiW3Ay66KIsAxDIylHR6lehnKfBseQA3bP0ou/7Y/GqcCiVzDGMTmq5bK2zMysEDo5bVVfXkVHSM2iS7U+miBppwGtflYd2l1K7xBZOsNJ7FsnqSOyZjfDOmZTE3j7jfMmSh97vd7KHGJuQrFyonI3tP6m4e3vG2+pX7FcvnErJ2EnWQ/PXzUiMnXeYbIymbcZlcGbVf0TNw7a6QzEGbriklYGaXq9lF06zj+5uc5G9u2f5GebV0187nUuaYnWA8z1aU/F9wXekC82KycqHcvOOUkumbpEWPblwmzWZP4sZXbNxQmm2w7cVu08oLH5LNegn6iJSLZJHkr9KQX2zW5zq7nDlHRIVrDH4k8usmGWOL/UJPoh34u4Jr9SHGq7LeAUMQY29HlwZtPWk9lgOYH58APchO6mhYxr9XqSU9+rp97d/nFeSVzdGWzamZJvBJSDVU1t2DjlMScLGRm6V3U/lOgWmETgLMpS03MMKpvKCiqA8qWoekJjMZMA3b8LBPrzJhVw/U48wb76nrVlx9HBAfWpJH8Alq1ecJxkhP0iV47cIXxeMzT9GLmvykcMkkztWL5f9S1KytSrz8vrUzOCFr2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1htVmxZUFJTaFFtUUNqRVJJTzdPa3JxQjREODVSLzViSTlFU0hpTXhSbnVo?=
 =?utf-8?B?WmE0aXNIOFdQazdCQ09QbzJiWkZHSGlLSmd0cE5aMVpocC9rczZ0cTJkZndH?=
 =?utf-8?B?TjFtOG0rTndtZ1JJeElsd1p5MXFoNmRyT2laV1hoZnRYMHNlRW91dElOdXpa?=
 =?utf-8?B?bE9ibENhOVdYZGk3Z000Umc1eXgwbERyeVkxaEVKYkVHakl0eWJGQ0ZYVDJW?=
 =?utf-8?B?bG9nbWZDa0JrNnN3VDU3TngwUHc2U1JxWGI2YjRzNnZIakNFcm5ucG9NazA1?=
 =?utf-8?B?LzhvMWhHMVBRTlhUUkhQZThCMGRacTRla3VMeitmMktCc3REN1lTSWRUODlY?=
 =?utf-8?B?Wm51SUNodU1ONWI0SXluaDRpZVlMYnUrRlYrN01BYW1FdVZvaU04K2VnMllU?=
 =?utf-8?B?RXpJczhjYnZXQ1FEMjdnOUxMOXlGMmU2RENPVy9pYWtOYjB2bElvMmJ4TFh1?=
 =?utf-8?B?aTFNb0ttMk5BdTVmbkhRWC9Fc1NIdlJOcHVCYXIrNGVFZktZR0grdW9YVmww?=
 =?utf-8?B?bFg5bU1VaVBQMkp6eEZ1UUxWL2syMXprOWxSNWFRMnM3RUdhUXA3VGwxK2Rt?=
 =?utf-8?B?dGJJWkFoQ3NsSnpsMmV3Q1BMWG4wRU1KRlU4bE0wSnBUc21QWlQ1NHNuVEd1?=
 =?utf-8?B?TWxuOHFIYlV5QnYrRndHTkthVWtYNWZ1SkFTdXpuYlB0NWM0M3RSZkJsOVNJ?=
 =?utf-8?B?a3d4WVo5SjFVY2NROFF6M0Zodm1SLy96UjhOeDRuRW05NGRUWnhGb0N2RmEw?=
 =?utf-8?B?OFFLdUpETXJmaHNDbTllUDQzOXZyU0N5ZUtrRUUwQXNFa21OUnB1cG5lQlFy?=
 =?utf-8?B?bGY0UjdKSUl5VnhSazZvUlBuL0l3akc3SFNid0hJS2pRdXJhSVVQQkl3R2xB?=
 =?utf-8?B?ekJ6a3FRampBczVpQkNhQ0lWYjZaWmZPbTVBVlBLZVVpeVF2aWVPcWg3dHpj?=
 =?utf-8?B?dEIwVEIrMnJXajQrbW5rYU9Zb292SE1ZTWtaSnZHSWNrd25JMCtacXgybGwz?=
 =?utf-8?B?QVg5eC9VdjV2K2tleEZYZ1Z5MVBjZWxoZDhpSHdRR0c5K1pIUFpOOTR0S1dN?=
 =?utf-8?B?V2E2NERDNUZNa0xvbHgyQ2pmckd1cjcwOGl5a0xnbXRIK0JZRzJDNVlibEZ6?=
 =?utf-8?B?cHRCUEprZURjSFJ5cGtNaFg2TUxidW9WYTNiQVVPNVFPOXV2c1hEdlRzanZ4?=
 =?utf-8?B?bmdDY0dXbUQ5OWpJQVp1RnJvQzhONFZ4cWhRbWVvUXorSG1EekpoQW1YL1p3?=
 =?utf-8?B?NEUyWDFTVFJTZzk5b25DN2ZxWU5IeXVGN0duS3lmQ0JhUjRTZlZoRDhZREp5?=
 =?utf-8?B?Y0hJbGRqVVpleUVDN0hxbitiNUQrdkFCVmFTampmSDA4bXI3MDN0WXlSSTd4?=
 =?utf-8?B?STQrcjcyZDVYekcxOTRZRS9EdDI3UFRSdVFRVTIzYkR4UjdvbmVzd0oxazNJ?=
 =?utf-8?B?YVhMWG02SytyMjVxT0ZHdzJ1d0thcUUrT01PaXFNQTJaRktGenFBc1lIS09B?=
 =?utf-8?B?aTRTUmdWK0FXdEU1cHd2bHB6V0NHUERtSjd2Sk5EVzZRVEZLbGZ0b1BrZk1q?=
 =?utf-8?B?TitPMmJWVTFwd2tlU3EvU0h4Nkx2TVdaQi9WOWxuNGtIZFlmUXJsN1pRRDlF?=
 =?utf-8?B?cGFub0dCTGNNNFJibk5zQUIzeGtUMlp5aU5NSXUvMTd5UVdwbzZzWm9FQmpC?=
 =?utf-8?B?bjRJbUlSVm5za25BemJUcmpEamtBQjlLb012Y1pMNlhRNTlmNFM5N2UrWGgy?=
 =?utf-8?B?Rmd0cEp1dnNOU2xzMndQYkZ0d2huMG5qd21iaDNzOTRubGphdHUrYy9yQ0ZZ?=
 =?utf-8?B?WDc5M0w0UTZZaWNFc004ODJBb1hrS3BGbzZzU1diMmRVQWQ2Z0FJd1YzRFpn?=
 =?utf-8?B?TExuckFtRHM2Q0M1bkNMMGI1ZFc1TzZyTnV5NDhxaEZ2dFVHNzlKak5VNVl6?=
 =?utf-8?B?L2xTOWNFZzZpZkhxeEFCcURxbTJwQ1NLTzZnelBjZHVlY0ViRERBb3hKSE1t?=
 =?utf-8?B?ZnhrM0FBMytRbUdydkl4RVJ3YWZHTEhISGxWTy92bmJ3RTFncDh6NWljKzIy?=
 =?utf-8?B?N2IwS3FBMk42cy9DdGlUZDFnZ3VYVXJZd3JPVmZWZXpCSkJ1cGRQT2s2Y3E0?=
 =?utf-8?B?a3Q3QXlhQSszZGp2d2Zndk14VVpXYXhTbVp2cGVjaUl5NCsxdUZvUHUzalc1?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A47A2CAE88E9DD4FAC482C759685FC23@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 014bb4be-8411-4c03-e9ae-08dc4a6203d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 11:20:01.1171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3TxbHUuhfaQmy2vlIXDWN+V7uPnX0RPOvbQNAL7uZb6hENvYrFA0UF53p/LS7/68xurPZpDN/1X2WK5e9cOwJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8597
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICtzdHJ1Y3Qga3ZtX3RkeF9pbml0X3ZtIHsNCj4gKwlfX3U2NCBhdHRyaWJ1
dGVzOw0KPiArCV9fdTY0IG1yY29uZmlnaWRbNl07CS8qIHNoYTM4NCBkaWdlc3QgKi8NCj4gKwlf
X3U2NCBtcm93bmVyWzZdOwkvKiBzaGEzODQgZGlnZXN0ICovDQo+ICsJX191NjQgbXJvd25lcmNv
bmZpZ1s2XTsJLyogc2hhMzg0IGRpZ2VzdCAqLw0KPiArCS8qDQo+ICsJICogRm9yIGZ1dHVyZSBl
eHRlbnNpYmlsaXR5IHRvIG1ha2Ugc2l6ZW9mKHN0cnVjdCBrdm1fdGR4X2luaXRfdm0pID0gOEtC
Lg0KPiArCSAqIFRoaXMgc2hvdWxkIGJlIGVub3VnaCBnaXZlbiBzaXplb2YoVERfUEFSQU1TKSA9
IDEwMjQuDQo+ICsJICogOEtCIHdhcyBjaG9zZW4gZ2l2ZW4gYmVjYXVzZQ0KPiArCSAqIHNpemVv
ZihzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MikgKiBLVk1fTUFYX0NQVUlEX0VOVFJJRVMoPTI1Nikg
PSA4S0IuDQo+ICsJICovDQo+ICsJX191NjQgcmVzZXJ2ZWRbMTAwNF07DQoNClRoaXMgaXMgaW5z
YW5lLg0KDQpZb3Ugc2FpZCB5b3Ugd2FudCB0byByZXNlcnZlIDhLIGZvciBDUFVJRCBlbnRyaWVz
LCBidXQgaG93IGNhbiB0aGVzZSAxMDA0ICogOA0KYnl0ZXMgYmUgdXNlZCBmb3IgQ1BVSUQgZW50
cmllcyBzaW5jZSAuLi4NCg0KPiArDQo+ICsJLyoNCj4gKwkgKiBDYWxsIEtWTV9URFhfSU5JVF9W
TSBiZWZvcmUgdmNwdSBjcmVhdGlvbiwgdGh1cyBiZWZvcmUNCj4gKwkgKiBLVk1fU0VUX0NQVUlE
Mi4NCj4gKwkgKiBUaGlzIGNvbmZpZ3VyYXRpb24gc3VwZXJzZWRlcyBLVk1fU0VUX0NQVUlEMnMg
Zm9yIFZDUFVzIGJlY2F1c2UgdGhlDQo+ICsJICogVERYIG1vZHVsZSBkaXJlY3RseSB2aXJ0dWFs
aXplcyB0aG9zZSBDUFVJRHMgd2l0aG91dCBWTU0uwqAgVGhlIHVzZXINCj4gKwkgKiBzcGFjZSBW
TU0sIGUuZy4gcWVtdSwgc2hvdWxkIG1ha2UgS1ZNX1NFVF9DUFVJRDIgY29uc2lzdGVudCB3aXRo
DQo+ICsJICogdGhvc2UgdmFsdWVzLsKgIElmIGl0IGRvZXNuJ3QsIEtWTSBtYXkgaGF2ZSB3cm9u
ZyBpZGVhIG9mIHZDUFVJRHMgb2YNCj4gKwkgKiB0aGUgZ3Vlc3QsIGFuZCBLVk0gbWF5IHdyb25n
bHkgZW11bGF0ZSBDUFVJRHMgb3IgTVNScyB0aGF0IHRoZSBURFgNCj4gKwkgKiBtb2R1bGUgZG9l
c24ndCB2aXJ0dWFsaXplLg0KPiArCSAqLw0KPiArCXN0cnVjdCBrdm1fY3B1aWQyIGNwdWlkOw0K
DQouLi4gdGhleSBhcmUgYWN0dWFsbHkgcGxhY2VkIHJpZ2h0IGFmdGVyIGhlcmU/DQoNCj4gK307
DQo+ICsNCg0KDQo=

