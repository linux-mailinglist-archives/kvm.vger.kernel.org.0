Return-Path: <kvm+bounces-54627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB7F3B2580A
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BD92728542
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F779460;
	Thu, 14 Aug 2025 00:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mTvHFWMS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E13F366;
	Thu, 14 Aug 2025 00:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755130182; cv=fail; b=KueWhhZzl1pCGyIJbikxxBwltxbbwJtF7vJAiokBqtsk4DRFuq7nKIxVxriJCWzOJd0yGjx4ZAJ1mTaqqYwyHxuIZ93vnydJAw/YVySkVcKr4wR+OrCAU3a+OTpOCUdohzEvBU2/qWljSMv0Hz3HtD/K0DXtBdFuhndE8M+fzD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755130182; c=relaxed/simple;
	bh=KH31zH5b4WyjJ85YZFmuXKXjosmIawcHiz9IwG7mX20=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OAFlv+7C4ufaqnBfqWtW6du2W2WU12LeTqz9veJOI6584j6Fqipv/TLWO++Fre1I1NkqyuIbrucVU1OFnuqYvZvVZC17Uiqu/Q0RRCFokB7h8wbcy37nPf8T5Jo/jEBDjOTR42AxqnCWBwtcwcyMZYWVeGrtf7vD/lNo1ymlPOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mTvHFWMS; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755130180; x=1786666180;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KH31zH5b4WyjJ85YZFmuXKXjosmIawcHiz9IwG7mX20=;
  b=mTvHFWMSGcc9a63KRP7zuoxEFiC5wl0dkbGqXxVz1c5SnjG2+pA89obW
   7v7A3JBA7tCI89ARobj50S/Z2cNLfGRzyQUXphz80RpNHQz3owfaUk94/
   ktuOnKVv9Nk14jMwzU5Pwm/Pfs+UzgmDhKZittdflOItDCdZiiTrlS6Iz
   onT8b/8R06iknn3kz1WlxGRuvtfw+GaD3QeDEZ+t+BNicnGLuC/FDDbJE
   FYQ6kwJwokcob3Fi1rg00WBJqCMWK14Fm5vtUbluixqOI1uUVcBiPrndk
   2rC+hiyi7jbJ2093C95sVoH9U1cxBRekHY3wYk39StLotMlMqIQO2IIJK
   g==;
X-CSE-ConnectionGUID: X4Rj7nryQ96Bd2OrThHglQ==
X-CSE-MsgGUID: o84ObOPeRCCmk8mtCurJ0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="45018545"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="45018545"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 17:09:39 -0700
X-CSE-ConnectionGUID: 0nKSf1/FQtO4aXMtRV65tg==
X-CSE-MsgGUID: F9+pkQxESd602zosUrSoqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="197466287"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 17:09:39 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 17:09:39 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 17:09:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.87)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 17:09:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g176686jl5qytIc/I3tSoIBqoabg6AWVPi4+zdSv2Yj4/psW7BT8y4v8MuoGrXH9HO1dGmee40418RC3nAYufORWvLe87poqw3oWb2PYDiGeSNDKpJ+e5BDYp8n1xts/Lz1YILpBX2cmfsXbOYf8SlI0GAHlZKyDoStSRsAMMOncMCSDf9OcIdYXl+c1hk6oKq374biSDDASP8RrMo0+nY+m4IehS/HduiEsrJExQfsa57wWM8gw9ufSPBJE5xCdwR/J7udFHMaVRAttqQ4iuA9uyp8aZcP6M7p8S2o4IPQszgbgbTvoWVViVjbSSF40Pfi16rYpA0Rh4h+Jkam5/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KH31zH5b4WyjJ85YZFmuXKXjosmIawcHiz9IwG7mX20=;
 b=h5WP6KL8/7uuMXMh+vqsSsuQ7xDBS3b5nzWCN+Ry1Fob2q/xVcUGWsJxWZYwNNoBWG1QBPEz5+L8JpRyvw3qXf9PhqQukOMl4LLsuRmIGRV3GriQT9XBNbTICh3AxLfg6Upy5o2og9GvjoGPTSRMKIQTIu3uowReEgni8jl9uejgNI2kzYNFQPIlkH/x5e6AM9aHypj6Kvq3cjBUF4DBwGvlz/fw3VOhkxn6YJCFlLk5Px5sMKUegmGx9ar5dQWM7Lexe5Ga3ufhaqY1uhL8359mpaptXDV5Jk0sA9KB0rxESZj1GAdo43YmGbPrfGQjz231Xibc3iTJz98gct+eUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB4985.namprd11.prod.outlook.com (2603:10b6:806:111::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 00:09:34 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 00:09:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb/7MLtHK6BqodHUKBqQjOH+Kz87ReRx4AgAALXICAAw2JgA==
Date: Thu, 14 Aug 2025 00:09:34 +0000
Message-ID: <cc6aa3d9ba3f075d0d3b772491be1516c5951f6d.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
			 <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
		 <3bd5e7ff5756b80766553b5dfc28476aff1d0583.camel@intel.com>
	 <05ed4105f5cf11a9dd0fa09f7f1ff647cc513bd5.camel@intel.com>
In-Reply-To: <05ed4105f5cf11a9dd0fa09f7f1ff647cc513bd5.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB4985:EE_
x-ms-office365-filtering-correlation-id: cf0e831c-1bd3-4452-ef77-08dddac6d995
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OUVWZlMyaksxTzZNTWd6R0t1bjFRYnpwK1Rjc21oQ1FyM2poOVZuRmRXOVpn?=
 =?utf-8?B?RTJwZ2hQSjFnZ2Y1Uzh0WlJoa0FSQXZRWGJBeVN4aW04MERFT0VYMW5zT0xi?=
 =?utf-8?B?Q3QyVUVLMXlkWFM2NEloSmUyWmkyMHNzQWlwWnNacDBIODFheW5jVk83Slp0?=
 =?utf-8?B?b0ZIbDVreTBoc2o2Q3l5TzVtMkdweTd1UlZYQlFQK1dtM3FHcmdZV2g3NGVa?=
 =?utf-8?B?QjVIeGhJZ0lFVUIyT3VqdmY3Z01sOVRqSE14a2QrT1BjdWR0SndwM3F5VTZr?=
 =?utf-8?B?T2NVRWJBeUN4UWNTelVnd1YvRXU5V3RQQVE4blVsVVhXQ1NMWnZaK29OYnYz?=
 =?utf-8?B?VGhWR2c1eWpqQ3pZcHRDNnpHbzlvRXN1QjFUcEJnUHZWbllUUjNVWThTZXNS?=
 =?utf-8?B?ZHh3MC9XZGlieHk0WjRXZmtCdFBwYk1XbHVHYkNjMWM1bzJ0cytWWkRpc1FV?=
 =?utf-8?B?bFJFQ1JmaElaUGJGa0R1cStmbk1qZ29FdlNFdDQ0bUtNd3luQzFwZ2k1Umhy?=
 =?utf-8?B?Smthd0E4RkcxOUdyOUVrTko2TlV0NXFOVGhqRkhybEl0a3VMcVI3U21Xc1lo?=
 =?utf-8?B?dSt0Nk80eFJHUFVRWHF6MTdEN1FyZDRDWUNMWEVEbVR1MnVWaXFwWDdFNzdr?=
 =?utf-8?B?MjBhUWtHUXRpUUdOVERRUFAwSHYzVGVPNm4vcjJiU1VCR2RQdHlkR2M5bVdz?=
 =?utf-8?B?TW5BU3Y0dlY5a1NTTmZlQ2FUNTFIT3lhTDNEcWQ4eEVwc0x5WVFMcGx3MDF1?=
 =?utf-8?B?cGtzZk9xYVI1NVVkQzRRVEFERHI3eU0xR0NUOENxL0k3aHJGVy9uN2dYbXFL?=
 =?utf-8?B?YnMza0tUYXFiM3kvRUJCem54Z3BtZU1QOXJmUkVEMVNuVzlLekt6WkJPcjFt?=
 =?utf-8?B?a2d3cmhJc0RyaVcyYXY4ZVhTa1oxVm9MakpsakFiOUI2Y3RleVdHanM4SWJu?=
 =?utf-8?B?a2VOVUE3MUhaaEsyTmQzWDZ1WXVTa2RkVFZ4Q0M3RE56UVhpQlFaMHdBMldC?=
 =?utf-8?B?MXhlTVljdGdkRFJvQjN5eFQyd3lzNnFZSHVJSEdjekNkM09jU2hRY1lMM2li?=
 =?utf-8?B?ZDY0RFExNGw2b1B5RWY4M2trMHB0SzVHcHNJZVEyUWtpNDNKVCtBcVRETC82?=
 =?utf-8?B?Um85eGQxdTZxc0RuaHNaNmZEeHgwdEpjWWZGWnllSHFXUk5kUlBDaVlOREho?=
 =?utf-8?B?dHBqWGU3TklCZjE3cjcxdXpmV08zcUwxb1NOT1Y2RnlIQisvZ0V6UXVwUDhX?=
 =?utf-8?B?TW9ib3RSU3d0NmwrZUVHeS94SDNEVWhaa2dRSVRPdVZKZmphU25aOXlvTXRs?=
 =?utf-8?B?NmgwcWlLWVRoWmV2aGNKNy85Uy9DRVJZQ0hac2xQTVJUYXBxSDFnNWhwZzE1?=
 =?utf-8?B?S296YXNQTTNKYmVoYTJJTmpXQmJZZmdkVFZ1QW82emdoVDhkTGpFYXRKWkN2?=
 =?utf-8?B?VzVEUEdIRERqckVvVGlHUjFxSFNvdnZ6T0ZYNnhJMm13OUIrWStSenBhMFBx?=
 =?utf-8?B?elkwWmxvVWRrTnVoNFhSWDJ2WjYzcWxQVkZ1WFZybmZMOGRaekVaWHEvekhw?=
 =?utf-8?B?eXg3UENXU3FrU1d2UmgzUnhpVU13TlV4NEQ1ZlJxdnlHbGVCMTg2TURFNG52?=
 =?utf-8?B?VU9uS2dqVTc4eS93UWVSZmJ0K0J3V0pwbU4vWU50enN0bXRUTTJyUExOaFY5?=
 =?utf-8?B?c2dGSzVVU0JmQmgyZy9CVThDbTRFS2t4TDhLUWQrVklBQlZJWTY0MFA4blBj?=
 =?utf-8?B?dHgvc28rMjRXb25FWmlGNDJ0QWZVc2liaFMyWDdjUTBVSHFmbFdHVzVRNkhW?=
 =?utf-8?B?WlBFd3JCSHNpWFMwYmd6MFdHNTR5VnlreElmWElwMWx6S2dKUm5QSnJsKzFi?=
 =?utf-8?B?NG9FUXZQeW41TUpXcHBXN3NFR3FibDdrbmovNzZBb1VGNUgwV3JSWlBocUtu?=
 =?utf-8?B?ZHpsSmcyT2NOSnZHZ1JvSHdLdHZ3bGdYSHByUFN3cjBDYStrRDNnQVhCR213?=
 =?utf-8?Q?aqTvEX+Qg926nZyqLG/O29xt/Nk6F0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RE55NzFqdzFrN09lSlE3L29mQ0lDbUhoSlRvMWg4YTBWeGxqMHdvRUlrNW9a?=
 =?utf-8?B?RDBKSG9BK0RuRVpKd2x1NzZKWVhtSXFWMnVVbGVHM0IwbzZzemNaYjBKazdR?=
 =?utf-8?B?d25PLzVtM0RPWHNOR0xleWdSOFFYV2Q3Q00zZDNFZEk1Zmo0ZlNlckVRUk9l?=
 =?utf-8?B?OURnVHVUdVV2VU5VazhqRWZnVGhUZE84Z0UvZVFsTDlzajQwZnIyM1gvcTRL?=
 =?utf-8?B?STVleEQyQnRLcXYrZVhOdHFGbTNNcWgraHNkTU0xMGdpK0wwMURuV1gyKzdB?=
 =?utf-8?B?WHF0aFVXQXZFQWhDbGo5TzFYWEVoNCszYjR6SGFEcHlscE1CazhRUjJrallB?=
 =?utf-8?B?bEFrUVQxS3pMZ0V2d1IvSFYrNE5paUNiM25EaXVnWFIvYm9MMFVvVDlwYUg0?=
 =?utf-8?B?RFVsWEhSMzFCb1VLVjRwSHBRRkNkaEdzQmxrTDlFbWk4cmhhL1VGVlRZLzZF?=
 =?utf-8?B?YWEyYmlwRmIrMEdBaEFxM05oU0V1ektCRVFqdGJJN0NBZThzd25jVUcxb2ly?=
 =?utf-8?B?anIvWWhqZVhtQ0FRMzhaM3RrMXJ3UTBUNGNXek44Z0lIQS9qdlpabnlJVTBj?=
 =?utf-8?B?UU5XZmFRNVZVWXk3aVhUQWZNYmEvOU4xMy9PQUo1SURTdWxJL2RXc090cSt6?=
 =?utf-8?B?ZEs1Y2d6SVU1dHZrblpjN1BlN2pHaXRMVEpqbE82WGtFc1hQTTVZOHVJM21R?=
 =?utf-8?B?NTFWemJmZENic20vY3oxNWRTcTI1OFhNYzJKR3UvTlVtdllYRnBiKzVSQUFr?=
 =?utf-8?B?KzFHaEFpWStaRHZQeHFURlhEcTEyUWUwQVl2ZlU0cllVK2wzbmZxOG9wdnZs?=
 =?utf-8?B?NGN5aXRkQnIvN1Zza05pQ0tMVGROMDFrUWlMeGVjMkF6ZnRBMnV0Y0tBVHly?=
 =?utf-8?B?ZUhKcTJTQ0liUmdRZVlSVXl2RXY4ZlErK1AwSW9qRzZFbUhtREM3M2ZPWXZQ?=
 =?utf-8?B?ZXZFTHdRYUwvTkFJZkxmRzc1VWxkbUN1dGYwckhiR0xhUU1mR2oraUNBamJM?=
 =?utf-8?B?TStaL1E3TXZ6YytyZkNFM0UwSnY1UkJLTFliWFAwMnpuYWtNNmJyczR5cm54?=
 =?utf-8?B?L2tGVFRmaTJZdnp2bHNaRFlJVGRKN0hIM3dBeXlVYkYyNEdWSSsrVE1hc1Mw?=
 =?utf-8?B?U0ticHZSaFdYSVBpbGt6NEJ3RUZtNjNyOS81WXdvNGc1dHgxN0NpaUgzK0sw?=
 =?utf-8?B?QTVhRW44RUd3T3lIZ3hiVlhtMytsNFlxd0hFSThrK1JkVlc3RHVEcHhzd1Jv?=
 =?utf-8?B?eVlSN0RlNnBhT2lnRmNtd1ZyamRGdEhTVjd1VUVsNE1FQ1AxU3hrR000Wisx?=
 =?utf-8?B?VGVnblF4M0RzNXJLYmxmaGcyenI1Qm1Ga3NiU3Q4bm9senZ4NGJrRElIYkVW?=
 =?utf-8?B?U2VTYzdUMVcwQi83SkpWb3llQUhQVXowZUhCMThRcm9zSmNPcWxQS3NJVU5P?=
 =?utf-8?B?cU5UZ2Jza2kzYjdjRkZ1L1IzejMwYjgwN1Uva0ZiVElHSTNyVHFYRlVMdzRE?=
 =?utf-8?B?SUxnOWVSU29PejlNNFFpaW1uSkJqelJ3N1F4N0RzbTIzaHplODRibnFFd0hr?=
 =?utf-8?B?aFBRV1lRazYwMk5XWDVuaWtUeVpIKzVpVUhPNk04Sllha1ozcG9heE5vMUxV?=
 =?utf-8?B?NFBZbUJyckM1MzYycDJoQUhCeTVRd204dnZBUGhWQW5yTXdwRnVPOWtDSnRC?=
 =?utf-8?B?TDVzNys4OWtUQzEyQldZRXRrRTY1aTJLUkZNWFJ5bm03VHhQOEhBbm45cjlz?=
 =?utf-8?B?bUtWZ2x5MWdUU3RiclFJQjBHdzRVUmhTc2hudnNjU1lxVThhcXBXUEgxNVNV?=
 =?utf-8?B?ZjZadGZBekhla0JuNjBhRU90SWpnUzIyenJoRHZRd1ZvbkFDQko4TTk3aWNs?=
 =?utf-8?B?RXFHZ081eGxjQkQ1Vzlsd1ZmVFpVdi9Vd05NUFlkbDRub0pQWEtWMGRVbkVY?=
 =?utf-8?B?M09IOFBGUGhYKy9nalpwWVpZL3BHcUpRdktRVEdLRGt4WndDbUF2RHBMOWtz?=
 =?utf-8?B?WlBXcklPa0NWTjJNOFJ3V05xVllSRDQwaXJvMDNzcWszVGp6ejB6anV0dkgv?=
 =?utf-8?B?Mmc2NEgwZ3NZWUZwa2ExdEFBUUVoMGFwS1o3N0gxVTY1RXZRWEdHakxwck1B?=
 =?utf-8?Q?9m/tArtQux/Q9Iv0RmQlMrMRQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F6833040C63A043B13E7D26E09307F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0e831c-1bd3-4452-ef77-08dddac6d995
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 00:09:34.4866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1GfxHELB2hIVwgUcjpVO1ukoHy3nNSLUYFSHBc36oQgb6yB6QAo3IfvEVKF/9A5M+joK2TeOxbeYFdPBSZnYKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4985
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDAxOjMyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUdWUsIDIwMjUtMDgtMTIgYXQgMDA6NTEgKzAwMDAsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3Rl
Og0KPiA+IE9uIFR1ZSwgMjAyNS0wNy0yOSBhdCAwMDoyOCArMTIwMCwgS2FpIEh1YW5nIHdyb3Rl
Og0KPiA+ID4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdTY0IGRvX3NlYW1jYWxsKHNjX2Z1bmNf
dCBmdW5jLCB1NjQgZm4sDQo+ID4gPiArCQkJCcKgwqDCoMKgwqDCoCBzdHJ1Y3QgdGR4X21vZHVs
ZV9hcmdzICphcmdzKQ0KPiA+ID4gK3sNCj4gPiA+ICsJbG9ja2RlcF9hc3NlcnRfcHJlZW1wdGlv
bl9kaXNhYmxlZCgpOw0KPiA+ID4gKw0KPiA+ID4gKwkvKg0KPiA+ID4gKwkgKiBTRUFNQ0FMTHMg
YXJlIG1hZGUgdG8gdGhlIFREWCBtb2R1bGUgYW5kIGNhbiBnZW5lcmF0ZSBkaXJ0eQ0KPiA+ID4g
KwkgKiBjYWNoZWxpbmVzIG9mIFREWCBwcml2YXRlIG1lbW9yeS7CoCBNYXJrIGNhY2hlIHN0YXRl
IGluY29oZXJlbnQNCj4gPiA+ICsJICogc28gdGhhdCB0aGUgY2FjaGUgY2FuIGJlIGZsdXNoZWQg
ZHVyaW5nIGtleGVjLg0KPiA+ID4gKwkgKg0KPiA+ID4gKwkgKiBUaGlzIG5lZWRzIHRvIGJlIGRv
bmUgYmVmb3JlIGFjdHVhbGx5IG1ha2luZyB0aGUgU0VBTUNBTEwsDQo+ID4gPiArCSAqIGJlY2F1
c2Uga2V4ZWMtaW5nIENQVSBjb3VsZCBzZW5kIE5NSSB0byBzdG9wIHJlbW90ZSBDUFVzLA0KPiA+
ID4gKwkgKiBpbiB3aGljaCBjYXNlIGV2ZW4gZGlzYWJsaW5nIElSUSB3b24ndCBoZWxwIGhlcmUu
DQo+ID4gPiArCSAqLw0KPiA+ID4gKwl0aGlzX2NwdV93cml0ZShjYWNoZV9zdGF0ZV9pbmNvaGVy
ZW50LCB0cnVlKTsNCj4gPiA+ICsNCj4gPiA+ICsJcmV0dXJuIGZ1bmMoZm4sIGFyZ3MpOw0KPiA+
ID4gK30NCj4gPiA+ICsNCj4gPiANCj4gPiANCj4gPiBGdW5jdGlvbmFsbHkgaXQgbG9va3MgZ29v
ZCBub3csIGJ1dCBJIHN0aWxsIHRoaW5rIHRoZSBjaGFpbiBvZiBuYW1lcyBpcyBub3QNCj4gPiBh
Y2NlcHRhYmxlOg0KPiA+IA0KPiA+IHNlYW1jYWxsKCkNCj4gPiAJc2NfcmV0cnkoKQ0KPiA+IAkJ
ZG9fc2VhbWNhbGwoKQ0KPiA+IAkJCV9fc2VhbWNhbGwoKQ0KPiA+IA0KPiA+IHNjX3JldHJ5KCkg
aXMgdGhlIG9ubHkgb25lIHdpdGggYSBoaW50IG9mIHdoYXQgaXMgZGlmZmVyZW50IGFib3V0IGl0
LCBidXQgaXQNCj4gPiByYW5kb21seSB1c2VzIHNjIGFiYnJldmlhdGlvbiBpbnN0ZWFkIG9mIHNl
YW1jYWxsLiBUaGF0IGlzIGFuIGV4aXN0aW5nIHRoaW5nLg0KPiA+IEJ1dCB0aGUgYWRkaXRpb25h
bCBvbmUgc2hvdWxkIGJlIG5hbWVkIHdpdGggc29tZXRoaW5nIGFib3V0IHRoZSBjYWNoZSBwYXJ0
IHRoYXQNCj4gPiBpdCBkb2VzLCBsaWtlIHNlYW1jYWxsX2RpcnR5X2NhY2hlKCkgb3Igc29tZXRo
aW5nLiAiZG9fc2VhbWNhbGwoKSIgdGVsbHMgdGhlDQo+ID4gcmVhZGVyIG5vdGhpbmcuDQo+IA0K
PiBPSy4gSSdsbCBjaGFuZ2UgZG9fc2VhbWNhbGwoKSB0byBzZWFtY2FsbF9kaXJ0eV9jYWNoZSgp
Lg0KPiANCg0KVGFsa2VkIHRvIFJpY2sgb2ZmbGluZSBvbiB0aGlzLiAgc2VhbWNhbGxfZGlydHlf
Y2FjaGUoKSBzZWVtcyBtb3JlIGxpa2UgYQ0KaGlnaCBsZXZlbCBoZWxwZXIsIGUuZy4sIGNvdWxk
IGxvb2sgbGlrZSBhIHdyYXBwZXIgdG8gZXhpc3RpbmcNCnNlYW1jYWxsKigpLiAgV2UgYWdyZWVk
IHRvIGNoYW5nZSB0byBfX3NlYW1jYWxsX2RpcnR5X2NhY2hlKCksIHdoaWNoIGxvb2tzDQpsaWtl
IGEgbG93IGxldmVsIGhlbHBlciBpbnN0ZWFkLg0K

