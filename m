Return-Path: <kvm+bounces-30918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10AE99BE510
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3146282C47
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FC91DE8A2;
	Wed,  6 Nov 2024 11:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y9dUAEmk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23341DBB37;
	Wed,  6 Nov 2024 11:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730890852; cv=fail; b=Hjh0xFLGjL8T/p9Xr322v3V23ar8re3Jm/oDZ5r4SchsC0F4rEb+XZchcCyfDwsKXzv3versjFYtuQVdOQp+EvS1ZQDuZd/Wz3FfNP8n1grgee067G1QTfMe1JaLU5MfZK68sn4Fsc3WZnE83mYlwb8Hc3TY2VZrIYhPZcSFck4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730890852; c=relaxed/simple;
	bh=+4z9IDJTuYOwnmyxDHTfDd+yCgKopHLcIg5nGzfppCI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VW5avQOXCMhgE7TXFHOrs1Y5baY61NboPD8oIt+YuuRh4eY3h8TPQ+KT6SqzpG1VvZrUJ/4ruSuYdYMPhb6SYzQy7Yvvj5QD2vV8acG/7dWChsIRUevVoWgXwiN7e/3+4red9x5jSAEKOuDG3yaWgcTCNOkQcyAWS6Uka4BsXcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y9dUAEmk; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730890851; x=1762426851;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+4z9IDJTuYOwnmyxDHTfDd+yCgKopHLcIg5nGzfppCI=;
  b=Y9dUAEmkj4KMEnin/sas0R/w6aklnA5iFBBlTztxJBGjO0swF5x0jKP5
   EFwfS11W86rdP7t8Jl7HV5AZrlkvAeJjTsUeYL8xGHpZE93hZ0jzBpS0V
   aeGZQ/JSBF5FK1zLHz7YuB5Tdp+D6e+nm7QgM6sVE6wg4pJQaPos1D6la
   mwyonwIfqfI9B48BmJWG1+nYObH1xjl4d3S0U7W8+Ig5OgM4Sc5EcFros
   eJDKIK4n2HxmUTousMkrFaiA+U0fD5KutfdOrYkW9/6wClnjQrtxg0qbR
   521xeLQlQAfI1BN3oFfVB02dCUW1g2zgtloJPNOd2VEW4DJTOPdm++wU4
   g==;
X-CSE-ConnectionGUID: 1iLcEMZ/RJ+P/1FSkrJb0g==
X-CSE-MsgGUID: H7JXG8YKTdOd8RmI/h9FQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30110713"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30110713"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 03:00:37 -0800
X-CSE-ConnectionGUID: PQ86N/1WStO3ce66efD+lw==
X-CSE-MsgGUID: k1YsOIDAT/OBOmaiVCVr3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="107803341"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 03:00:31 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 03:00:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 03:00:30 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 03:00:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4I7SQOkSUxlFu/Mzba2it3GGL47DXff0JnKrmLBcrtC54OdsVr28nyzr+2VhwJsT1O2fySyPvY/Td/vq3nFzNgjYqNwH8qvVV3NHVnusRcyVxl6CkqnR93UHSY69mniM7l5XL8UHEFeLLJ7cy6KPCLJEZD8tVVeUlqX2Uqa6DS3ssxt2FQniuo8LqDV0V/RZqFJ2QB/0oV/VhMcn2CsoJwdqaaGU0JfjBj9SY9yWG3si7nQ3b03w4gMtyS6xLyrsHSKt5v/kIdlnl87uOn0KciCvIoZ8m8Ai7YQ+99ujCUy3yN8HD1+8pIEUhlmL4T6NYsqPiLPW1EJ2KbtobtozA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4z9IDJTuYOwnmyxDHTfDd+yCgKopHLcIg5nGzfppCI=;
 b=FRvY5OLy3W7sM84bi6Bbu1+FeqgZoIB4BsM7ugtBc+aYoMowyz/Z/c9kNgko/8V1PAS/+IEMO6Ktt9NINz2XgRefTq+EZLcRFy+eLJ0iRUXgVowUki/iwhBjTaBLHkaSW8q+jO9y9vJ4UnV/W1DRQGaKp75WL8eMSQGRX7Q0RTX511Ls9R6Vn6CYV7eo3PopK+0UZK9DCNQPccrnkrDpPDtEJUXJli4Yvd6D8wlhcRM6YKZsV7YOqvlz6kyhB2PLLLukCqQtjK2SSTwNfl89AxlbK1wmsV6I+Cv2muSSDh6mPA2o/PlyxJ5RAEtwwscGrGhqCdzxDEIpkzYMWpSj3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by LV3PR11MB8580.namprd11.prod.outlook.com (2603:10b6:408:1ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 11:00:28 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 11:00:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Topic: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Index: AQHbKTUf1dSb4jQnekqD1cQ4TcWMP7KqI7+A
Date: Wed, 6 Nov 2024 11:00:28 +0000
Message-ID: <f2f195a2f2f78da40d94b122c5228e04a2122b62.camel@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|LV3PR11MB8580:EE_
x-ms-office365-filtering-correlation-id: e4806421-40bf-4954-6609-08dcfe523953
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?N2VyQkZXQVdqcFhrZnNLTkJKR1l5aTFGR0V5WDRpdEd3TmlQdUZOUk9TRHNL?=
 =?utf-8?B?RmVnWTNhWHpWUUNvRm51TkZNY2RmY3FVM2NRTFNaNkNwTVhMSGliQkVpV0w4?=
 =?utf-8?B?RkEwOGI4eDJBU1FOUEgvRnQxRDFUeUZjTVFnazFxTGk0djBjU3Z3WG83WEtq?=
 =?utf-8?B?RDc3ditPbVVvalE2SmxzVFpuQ1hKcU1WKzhia1dYb0ozTGlvTEtTSFErbkdM?=
 =?utf-8?B?QUlBbkNiN05DNzEyM1NVZy9LWmpsWHhjWHYvbDg1UGdQYTl0alp2aDRlTEZv?=
 =?utf-8?B?elR2Y1VXU3lWcDNKTDJWb3B2Wi9QUXBSb3FRa20wK1VObklsa29zUkUyUjMz?=
 =?utf-8?B?R2pYRUpyUjlrVllIRjlGQnhXYlNKWUFMcXZpbndrcTB3UEc3NmFmMkNUWUdZ?=
 =?utf-8?B?M04wN0JUOGxmR3lhSFM0d2h0cnRQQ3QvNzl4QW5Kb3QybTZidHJSeWZRWklN?=
 =?utf-8?B?bVhMQ3R6OXpEUGFIaUJYM1VMd3BWZzB1Ynd1TmlPemVvdU5aQXRwekFmN0Zj?=
 =?utf-8?B?ZXk4eGxNS3ViL3pmSXBYYkkzTmRZQ2hsRlV1Sm12WjRSck1ZZm8ySGFmc1lw?=
 =?utf-8?B?elJmWVdUN1pucnM5aEdKdDI3TTF0TWRJQThSc1UwZVBZQ0ZuMkZEQmxlampx?=
 =?utf-8?B?U04xMGdmQ01wZzhwR2E4U1pSbW1RZitXU1htT0wyeUdiVll4cXg0cjBpdkIx?=
 =?utf-8?B?L1RGRzUvWTh4TUc5aUZOQTdsR1BOeDZvQThnNzQ0dnZacnFheDU2Ni92ZTlC?=
 =?utf-8?B?V05wSWExSElka2lIR1dLT2lzR2EvQUd4YVdKbVpBWkJ0M3lHaGxKUDd6NnpQ?=
 =?utf-8?B?a1l5ditVR2h1d1hNZUJRdmg3WERlSE5QbEJhdHYwWS9JOStFeEJhWGRVb2pn?=
 =?utf-8?B?MFp5ZmdlLzJxQnJsa2pOdkROTGNxUjJYRVgzYXcwK0dDZmRPWkVwSm1xa3Zs?=
 =?utf-8?B?STJiNWpCYnlmSGkxQ0ZPVGdlMGE4RVo2VG1VeEZ0OXdiZm9RTE05bWcwWk1F?=
 =?utf-8?B?MUsydXFudzVEeXZrQVFYeFpFUCswOEJFb3dWY3BkN1JRME5Da1pZclM0Wm92?=
 =?utf-8?B?b0d6Q0FXa2hiSXFJSlJ6ek51MjIrU3kxN0JnR3Q4ak5XencwNHRpaGV6YWQ3?=
 =?utf-8?B?V3NPRXJ6VXM2SmlvRjB2eDhjNUo4ZDJNM2xzaHlEdFh4SHkwTmNVUGprY0o0?=
 =?utf-8?B?R3ZvbnhiUXdHRTl2ekgvMHVRUFAvTExVRWZQbGNoY0tnN0U2eW13WDlQTDRO?=
 =?utf-8?B?L0szMFQycTNiWnZpeTc3Y3JTcEx0NU0wektjb3JPSXNwQ0tiZGJtRWJxbzhC?=
 =?utf-8?B?YUpUU0FLYm5OclV5UmUzUUM2WDI1MzB6ZXo1MzRCang3Y1BZN3Y3WDdnTExo?=
 =?utf-8?B?TXZPZG82citvY0J1cGp3T2YyalFueGp1RkExNGpod2l0U3ZwOUl0NHl2aVM5?=
 =?utf-8?B?cWJGR3pxNlVUTFdaWjdERGcxS2V5eEpHMzRaeEZRNHBEZnhLd0hSS1hZb2Ns?=
 =?utf-8?B?cUxZZUdvSWQ1MUxmSEdLR2Vwa2RWN1NRMlNmT0cyaU4xMFZ0VENENHh1VnRs?=
 =?utf-8?B?UTc5TFhyUE9KTTZITlAvcFcwYnNKMi82b1RHRUtrenBybmpVMDZ6bDdzckg0?=
 =?utf-8?B?TGM5MDVKZzBTVTI5Q3hXR0VJK3ZQN2t5MnJwdmNIRkFCc21OckRBNUFXbUJ3?=
 =?utf-8?B?QlhaR0wzSVBjTmpzK3dxVXF5T0dvcE42QzRNQzZCb2NWSmRuTy9mOEIxQmlX?=
 =?utf-8?B?M3NrNmROaU4rdGViUTVJekJQTnlRRFc5UjFXUkprSWdaa3gxcEliWUVrZWR5?=
 =?utf-8?B?NkVKc0RNU0hTenFncW01dVc4Slpsc3c4S2QrWTViRzFGcUh5N1BLSmplakt2?=
 =?utf-8?Q?8yyb6DcTjfpNf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmZKaHJUVHp3OVNTZERVQ0FZUmgyRXhmN0dVK3VaOG04Vm9WK2t6bmxsYkll?=
 =?utf-8?B?Sm1hRTJiTkIrRS9yd29nNk05UU5xckw0aEZJc2taQmhrS0h2NzIvSjFlVFBh?=
 =?utf-8?B?R1NxME8ycDA4TE1UYm9mODRnajJpU0xCaUMyTWhyV1E4M3VxVzhBT3NaU2J5?=
 =?utf-8?B?aWpLdTNnSDNaeVQyNXRWQWhFOVVTYTMvVEZhY0djczk4N0lIYmw3ajRzcE1J?=
 =?utf-8?B?V2ZYeU82NlM2V1UzVVQ0bEFPMEZVL1J5c2xvQ3dhc3BvMEd3TjBJRFE2OXVF?=
 =?utf-8?B?UmY3MEpuc3dhTmhDUVk1TFVkeEZScG5sMFZyR1N1WGhZWC82cXQySGxyYXJr?=
 =?utf-8?B?T2I4czU1bVNmR3ZFQzJsb2hoSmFxMitRTzM1dzNSaldSVGdibyt1cUVwRi90?=
 =?utf-8?B?VWwvcnU4SjFKaS9VQzZReDlFSUZFUEloVmlRaEI5WDdzZTBJbWVaNHhBdlJW?=
 =?utf-8?B?dEh3WmVBalhLNVBNQWlLS1duVWd5ZDVZdnIzOFpwcEpjeXVnR1lleEdjUXZu?=
 =?utf-8?B?cTJPYzF6dHNxV2w2TmZ4bnBYR3ljMVhET0d5bkFsV0NPZTkvTVRTbVVub21E?=
 =?utf-8?B?N1BJbHJJZzU5VFRMTTBvZ0NlcUN3aXpPeHNqZVFsRVA4ODZFR2RGcjMzZzFy?=
 =?utf-8?B?R2c0TTJNVFc4UFNNL3BWOVVlcGhFN2tWb29iOWhrRW1PT2wvdENwdWZ5WURy?=
 =?utf-8?B?TlVXbURpYTVPQ29UYVhNVWJDV3dHaVVFM29ndkFYNTBscWlLTUNTTWdRU1pO?=
 =?utf-8?B?b0R3RzRHVFFYWFo0SWI1ZzdCWmFCWTdhc2diRHRGeGJUbHZ1UVVaZEZRUE1T?=
 =?utf-8?B?NzRTUjQ2ZzdRRWtwWTJZUTRzZG5YZkRXM2w5NXB3TkdsdUlhcndPOUc3eHA2?=
 =?utf-8?B?cFBwWGU3Ry9PSFRwREQ3MHBVQmk1aWd2QmZzSjdPaDNHbXF3NnBrM1JBVTRh?=
 =?utf-8?B?aXMzUGxUb0tkZWlEV0JlT2gyZ2R2QjhFcmVjWHdBUlh1M3NybndOR2NHeDR3?=
 =?utf-8?B?dG9RWFNDTll2RExPV081ZURzSG9tdEFWNnczWnNYVTZOdERsRFc2REFKeDNL?=
 =?utf-8?B?UDY3MW1WYmpIYTBMWG42ZWxORTIxNUY2NElld1ZtTFZoMDZCQ3ZiZXh3Z2FM?=
 =?utf-8?B?cmxUZlVndTQzQkdrMUxVNE0wMzYrUHc5NStqUWE2QzVHWnJNZnVsVDlpU3Zi?=
 =?utf-8?B?dGZzTXBBMWdseG9VKzY2b0pBU0hGTWpwQ0xOVitkZUlYVjU1MFMxVW9mRmhz?=
 =?utf-8?B?QTFtS0xsckZsS3BTanhXU05tMjQ0a3ZrZXF4SHQ1K25pOHdCWUorNEF0R3lo?=
 =?utf-8?B?NEgzNzlOQ25HNGk2QVZ4eG9zNDdXVWlOK2hUWTVRYytCaUZjSktTWFFmUHpi?=
 =?utf-8?B?K0tja1JRajZOU01ySWNDWjR3NjR0MUtzRXd4N05Jc2FiSTdjUCtRejBNU3E1?=
 =?utf-8?B?MTV2R0ROV3ZyeFBoN2drbkE0UEZaeTdjamZlSU1WK1pHRFJIYlBuVlgxdFB6?=
 =?utf-8?B?ZnVOMkRXSUtOWmNSa3U4cGgvVmhsY2Z5U04xNFZlUFc0emFkR2YzUGtUYkFn?=
 =?utf-8?B?djdLbDdZSnBOSmV4RDBBSHdEREtrOS9TRWFqclZ0b003blFpeENFV1VycUVU?=
 =?utf-8?B?Lys0RWI4dzhKaDdVMytJVGtObEZMTmtOeXl5WFd4Z0c4QUViYVlqMnVDKzFV?=
 =?utf-8?B?b0tReGVWMGswTE1JTHpkNHJyMHh6OU1aU041RzdWNGFEd2NzQ3VYU3lJakJD?=
 =?utf-8?B?TkQ4RFoxTlB2WUNMS3hBbnd0S0FyeTVDUnJoQi9jK21FQUJQS2I0cG5qRUZS?=
 =?utf-8?B?L21wVzROMHY4bkg0NzlWOUFJMDRicnNuOUxIWkFQSnZITGlGRlVab1NaRGlZ?=
 =?utf-8?B?dUhnUTB1aW1pZnAvV3M1SlZmdkpjV0NjakxCdnoxWVFTZ3pLbEFlRTBURFdQ?=
 =?utf-8?B?RnRheTZ2U0tiZ205NGp0OGpDMmlidFZ2TS90RTE0L0grak1kbGg5MGxHVEhE?=
 =?utf-8?B?NkZxTmlQcERldm1zb3lUeXRUTGxBa3ZHQmkxVkY3cVVkNk8zUVBtdGZXUnVw?=
 =?utf-8?B?cWFIWGZUR2E4ZnVCTnorMDNIdC9PTHlMUVhtV1NkQXk4K3dPRG9xSFpZZ2Vx?=
 =?utf-8?Q?ZvZgPO7sffqQ9lj9s68IIukiz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B58C675C0FFD1428F115A8CB35AFD59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4806421-40bf-4954-6609-08dcfe523953
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 11:00:28.1724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3F+kfpIGcD8wlm9qz+Ut//LIxVhlSPylZC1KN+69WkSEecPRy/+5IXq9Vxrigj9Hm7H9BRYvzlVCg8w/8pMBag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8580
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEwLTI5IGF0IDAxOjQxICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IFRo
aXMgc2VyaWVzIGRvZXMgbmVjZXNzYXJ5IHR3ZWFrcyB0byBURFggaG9zdCAiZ2xvYmFsIG1ldGFk
YXRhIiByZWFkaW5nDQo+IGNvZGUgdG8gZml4IHNvbWUgaW1tZWRpYXRlIGlzc3VlcyBpbiB0aGUg
VERYIG1vZHVsZSBpbml0aWFsaXphdGlvbiBjb2RlLA0KPiB3aXRoIGludGVudGlvbiB0byBhbHNv
IHByb3ZpZGUgYSBmbGV4aWJsZSBjb2RlIGJhc2UgdG8gc3VwcG9ydCBzaGFyaW5nDQo+IGdsb2Jh
bCBtZXRhZGF0YSB0byBLVk0gKGFuZCBvdGhlciBrZXJuZWwgY29tcG9uZW50cykgZm9yIGZ1dHVy
ZSBuZWVkcy4NCj4gDQo+IFRoaXMgc2VyaWVzLCBhbmQgYWRkaXRpb25hbCBwYXRjaGVzIHRvIGlu
aXRpYWxpemUgVERYIHdoZW4gbG9hZGluZyBLVk0NCj4gbW9kdWxlIGFuZCByZWFkIGVzc2VudGlh
bCBtZXRhZGF0YSBmaWVsZHMgZm9yIEtWTSBURFggY2FuIGJlIGZvdW5kIGF0DQo+IFsxXS4NCj4g
DQo+IEhpIERhdmUgKGFuZCBtYWludGFpbmVycyksDQo+IA0KPiBUaGlzIHNlcmllcyB0YXJnZXRz
IHg4NiB0aXAuICBBbHNvIGFkZCBEYW4sIEtWTSBtYWludGFpbmVycyBhbmQgS1ZNIGxpc3QNCj4g
c28gcGVvcGxlIGNhbiBhbHNvIHJldmlldyBhbmQgY29tbWVudC4NCj4gDQo+IFRoaXMgaXMgYSBw
cmUtd29yayBvZiB0aGUgInF1aXRlIG5lYXIgZnV0dXJlIiBLVk0gVERYIHN1cHBvcnQuICBJDQo+
IGFwcHJlY2lhdGUgaWYgeW91IGNhbiByZXZpZXcsIGNvbW1lbnQgYW5kIHRha2UgdGhpcyBzZXJp
ZXMgaWYgdGhlDQo+IHBhdGNoZXMgbG9vayBnb29kIHRvIHlvdS4NCj4gDQoNCkhpIERhdmUsDQoN
CkNvdWxkIHlvdSBoZWxwIHRvIHRha2UgYSBsb29rPw0K

