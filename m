Return-Path: <kvm+bounces-24994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09DC595DD34
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 11:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6784C1F22894
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 09:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1649415574F;
	Sat, 24 Aug 2024 09:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DS6l9uJv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4165154C04;
	Sat, 24 Aug 2024 09:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724492485; cv=fail; b=TAKoz6zs5Szppurfmh5MZRSq3l+HT5dGzsAYtePMPN0fuNUgiYSd8w+2NgUrGORC3xJeyZBZj7JQ+lUvXmJAuDAQo709pSDjDvo+8ARnxlFYpyzsGKN5QdxlwAHBiSHrphSF7GKvl/0Dh+btQH3T94S7bIfrbSiPSJHQKHJkSf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724492485; c=relaxed/simple;
	bh=u4tYv2UDHr4M7skseV64OBpn4Gc6RzVsL6n6POsLvMk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EGrnonS6iOAj6WUjSIk7NRE+ETpI2+oB+U3UkQlPnOaPDmlBVt0K2UZuMkOuGUgzOwWd3YIl5d3ZbFWAIaYuIY4fCEb12EbhOp08AaI4+kNF44nEZK/usTINwYjS0LV2Z99S0UycSMMohaF1XKtXK+esKOQmoA5epFjY+8zBeNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DS6l9uJv; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724492484; x=1756028484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u4tYv2UDHr4M7skseV64OBpn4Gc6RzVsL6n6POsLvMk=;
  b=DS6l9uJvNuyl18iHlBMGpsOmPBI50EAy5BMusnTkaL9pV7iPrBOb/1Mn
   91r+oPLCd0d5EYkWnMZl7FcUzKkvPvWfvHkv28uJQQbIvqBvKNh9mhhi9
   aozB2qm1OfP4jsRLPBRkps9lrTV4IPi0HQj2tExT2vj4KyCya6AY4bU2Z
   B/QS/QQ42UbRWN8/6R6FoNfFb8KlofaGdSXAJzX0ER0B44Mfv5zVxu2Zk
   Y11qrXKjzRShqymQZUrq/QO00kYhQPmMLXrtipC8XOcQMGHmFlXul2QkB
   +UMWylWzm4t6yoGHigoqCwydpnz1VHtQmwoqslfm+nvduZxa9Xuqfvfdy
   A==;
X-CSE-ConnectionGUID: TyQSqXJ2R4GZFk1j3xN+iw==
X-CSE-MsgGUID: uuTvKA7cTvmmPCp1KTc4mw==
X-IronPort-AV: E=McAfee;i="6700,10204,11173"; a="26767396"
X-IronPort-AV: E=Sophos;i="6.10,173,1719903600"; 
   d="scan'208";a="26767396"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2024 02:41:24 -0700
X-CSE-ConnectionGUID: oiSTPCKHQoWIcUQTjAIVtA==
X-CSE-MsgGUID: BHI08EUOS4eHBG5DCxgN0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,173,1719903600"; 
   d="scan'208";a="61727014"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Aug 2024 02:41:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 24 Aug 2024 02:41:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 24 Aug 2024 02:41:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 24 Aug 2024 02:41:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HiY3OGlA0sTDRES+nNhJ+zFwaICopgTZAHPop1MWuVFFs72uZtB6xCD29krJwB6LMTOohH0v9f5DtEhNMGHHO/V5363GLHhY2Fi39gyFtMQCaGpV5DdQ71xzdlTx3dpEYf4OHWSbuuFJTGUP/cdDzymXC4EMvHzh+bRP/ecAdC+St9ES9oUPOUlETLnw14Ddo7Pb2uCNqrhCZLe/ETinGr0GpBZnGIML/dUZT2CHiL8bHlvo5BCp1Zk8Po3GPB5oThRPnld1ImQlHppjoSXnQGLl0wl88xcN1R8NrioHbJ3bhaFPoMD9NV/rzn2+VZ5yyyvUXxO2PGRbEntShKBCVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4tYv2UDHr4M7skseV64OBpn4Gc6RzVsL6n6POsLvMk=;
 b=IxIpBdLo5U6zo1cJaXNjg6j1r3HJ4aALpD0NQfNVxhEjRe5D7XskEb6rqwQEg+SbALXaVN0Q9qDNifZLr+SgcroGc5ylLiD49Ip5G05qmUHyj+XxyRx84PO3lHSg8SqaAet6oycn12WKdjxmxL/G8O0DtOyTc/YMfWD+bU6GAuGSDvaU8gv/p9hL4pOpkhGVRRgxsxAdPG7oB8avHLzeP1/vX1FtqKXK5lJRzBwjxCoiZRBaXtH+8ktb4NVRX3sdQXxmCwpDHIRJdsa2MYB5Ff5qKn/jELN/il7KjuYOsBN20WJ1lamrUOcldc6hw18FfTikkuDUhfyiYEgRJbOq0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Sat, 24 Aug
 2024 09:41:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7897.021; Sat, 24 Aug 2024
 09:41:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"jmattson@google.com" <jmattson@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Liu, Zhao1" <zhao1.liu@intel.com>, "Li,
 Xin3" <xin3.li@intel.com>
Subject: Re: [PATCH v8 00/10] x86/cpu: KVM: Clean up PAT and VMX macros
Thread-Topic: [PATCH v8 00/10] x86/cpu: KVM: Clean up PAT and VMX macros
Thread-Index: AQHat57T38nkbC61fkG2xQ78jsH58LI1/oKAgAClyYA=
Date: Sat, 24 Aug 2024 09:41:20 +0000
Message-ID: <7f15288693d0ebaa50e78e75e16548d709fe3dc5.camel@intel.com>
References: <20240605231918.2915961-1-seanjc@google.com>
	 <172442184664.3955932.5795532731351975524.b4-ty@google.com>
In-Reply-To: <172442184664.3955932.5795532731351975524.b4-ty@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6054:EE_
x-ms-office365-filtering-correlation-id: 3f6c5c88-869c-46c7-a50b-08dcc420e8d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Zlc5Q3RvSGtJcnBIRUJOWmluNnllNlZ3bWhiWCtEUHN1eWUzTStzdDZ0NHUw?=
 =?utf-8?B?WnJHS3ZNOVJ2ak9YZE9IWlV3SVdiMXo0RmpmSTBNTmRwVzBXZ20vTjZ6Y0Zw?=
 =?utf-8?B?Wk80cjc4TWlzUlhXRGxPaWswck5EdlJNVEpob0ZmUnJDQVBtSzlEQlZkbTly?=
 =?utf-8?B?S2xtQTU4OVN0disvRzl2c0wwOGZiSGlZTm5VYWoxWlpsUDZOcDFyQzRBS1R4?=
 =?utf-8?B?a1JBbE5uNkRqRWRPTFFIdXFaQ0hGQk9XMEJKUFhSSE5OQWxOWm9VU0NCQkNH?=
 =?utf-8?B?Ui9mbFNDMFZCRzdwcWlLN3NLeVRyeHlPSDhmNk1jV2dESEdtaTZIV0xLZDhy?=
 =?utf-8?B?UVZEdWs2OGdUbk1SWlNva0dzcm5iZnNEQTdPMXVsQ1kwcnQzU0JlWXdiQkxl?=
 =?utf-8?B?U2Zub01qY0IrQ3lGU2Q0M1hMUkJmU04xNElXSDNaVVBRNC9BOWpCdlRwYjNO?=
 =?utf-8?B?Z0I5M1NpMEt0UERkVmVXbVpQQ3kveVhRTzJnNW1ZUWRzSUwrMVlTNTNkQXhV?=
 =?utf-8?B?NEpEdGJuR0d4RXc5SG42R1REdzdudjdHREpSZnNWSTY1MUYwWDA0RG8wcnN1?=
 =?utf-8?B?SVhCUU9uQUUwTTkzMHFiYWJmREVkZGNldG5DM1ViUzhVT2txN0MwVGp1ZEt0?=
 =?utf-8?B?NTJ4UlpsS2hyU0NVejVhOWxmTExPUmc4SnhyRDBKNlVZNVR2ZGl2cFZpOEZz?=
 =?utf-8?B?SVJZSTdTeHVFOEZ1SFJ3dUUxbU4vcWMycVBKcWRZZitKamxMelpnTnNKaTRs?=
 =?utf-8?B?cWFlZzRUYkd6R2hsOG5tTWM5VEcvWEsrcWxJWVVDMU1zaDFhVHJmRG82WU91?=
 =?utf-8?B?c29peHN4S3E2RTZ4Rk4xOU9YaktoSmFKYnY4dFBHQjRsb09jL3VXUDhWWll5?=
 =?utf-8?B?QTlZS3JOcnBGckdLWkF3MS8wODNhZUdjck03RG43VmpZMUcxMitmc3VjSGtG?=
 =?utf-8?B?QXRUV05jR0NOUm9mMnVmWXpQVFhEYUNzcWMvT21Zbktqc0dZUDl3bjFXVU1D?=
 =?utf-8?B?VFNrc2RXRXNlaURsay9DVjZEOXBTRHRWTnBSYWpDOFZRQ3VQUjJETHdXNzlo?=
 =?utf-8?B?ZnZmKzVFK09IdXE4aDhhQXRYU0tqQVVjYWg0VFFHMDhIY29qWExxd1F0S1k4?=
 =?utf-8?B?Rkp4QkF1bFJXbUFWVms5Zmo5ZUliRVpaYUZzN1RSdWlCV1RCR3RZTXdxblVI?=
 =?utf-8?B?WkZOZElFK2c5ZTlUNUVnMkJqMGJRcGlYdDV3cGhwQW8wMEVnMGFqYXVtTTl1?=
 =?utf-8?B?R0dYTk5PQnVDb1p1Q3VFRnpGckN3YzE1eHU4TC9nYWRIS1RSYlRtRXV6T2pz?=
 =?utf-8?B?WU1DNENsSjN0ZXM3Vkp6RjYzTyszYWNVQWNHUUpqRmErd1dpL0Z0U095Wngx?=
 =?utf-8?B?VFNFdXBTT05OZWNBL0lFcEhvK3craUM2ajR6MlY4VWxwT2s0Qk5QOWN4YlYv?=
 =?utf-8?B?MC85SlVSbVVLYmVsaEhlRHE0a0ZzTkJkSUJpOHVoc1RUa0x6dER3cDcyTWtS?=
 =?utf-8?B?OFlVbCtIazNoUXFucUZYT0ppUTRoUjNLamsrMUlhZ3BIekZ1cGtEaFhBZmZy?=
 =?utf-8?B?TE96RDViajUwU09FZmZuSHNzV3I0SGZ5bWI0WkJ5dEtuc1FtUVJ4S3piWFFB?=
 =?utf-8?B?M0NzSjRWVndZenp0Tjh6RDNUbHlBWlVCbEEzbFBXUGo3cFZmbG1PU0I4dEgw?=
 =?utf-8?B?QWVSMkNEV3FWdVhrV2RZMCtvc3FXbVF5bDJVZVc1K25majV1TGNNYkJXdlFC?=
 =?utf-8?B?ZUw5c2xJa1Z6VXl5QTRIWkhYN2ZxRFMyZXRVWXg4ZUg5dDhrNDM0a3JmRnJ6?=
 =?utf-8?Q?/Cbricv+zIGeLRZ40AY4sgzyiX25tWri0B3+A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXIrcDVWMWM2YWNnNllkU3U3cStvVkI5U1BQT3hDYVovbTZiRUtNWm5tbGQ3?=
 =?utf-8?B?NFpCZXVWY1YrYXg4dThhOWRmRjkveERhbjI2dGRoaEtHanYwTno0ZUdsWUNM?=
 =?utf-8?B?ZWhUVWJQTlJ2MW5FNFFLMy91emhNVjdtRVVkVmlqdFAyZjFOZUxjNURkSWFM?=
 =?utf-8?B?Z3hua21nR1RZMjFpSHo2clg2MHVMckQvT0RiamRKU1Y5Y3JQS2E0dUhVeEwy?=
 =?utf-8?B?cVEyTlBud2VteVZHbHA1UFc0Sit0Y2RjRUxzK3dwU2dSRFlCUElLRDVPNjYw?=
 =?utf-8?B?N1lURmhqV2NEVnJKZ2NIVitobVAxS0lEMVVPcVdkTEU3TEtHc1FrNHRvTFh3?=
 =?utf-8?B?aDRLalNOcDRzOWNnYXRhbXNmTGp2SC9aTHdNLzFUNTQ2VWJDa081NHh2T2Zq?=
 =?utf-8?B?aFNTVGhrNS9tSGV4TG9QS3VzQVQ2RUxkSFUweDBQblpNU01SMW1YUHBPUVR5?=
 =?utf-8?B?MnlTM2luUUdraVNua1cxYk5KaGZIeStyQk1IbFZkaEV2RlN0UlZEZmZYZGQw?=
 =?utf-8?B?eFVOc2g2QWFCbVNaZDQ1YS9EWlYvNlgvbWwvSlBBdUp5T3JCQnExTVAyNDZx?=
 =?utf-8?B?cnlpT011SGdIQWN3MDV0QzYrdzlianJmS3dTWC9UbzN4d1pYaXphYXNQT2pu?=
 =?utf-8?B?MXZCcDF6SzNRLzVYcGxhSnNPSENCbVBFNXR5TllhTHY3aCtpZDcrS0hIR09F?=
 =?utf-8?B?K1dhM2ZodVV4VGZ0MXRPZ2wzTXlnT0pmOENVSmFuNGhFUFF3d0VQNVBWUURB?=
 =?utf-8?B?R2NQaFlwRE0za200KzV2N05oS3YzemRPQTFLRGI5WnRSaDB3U0JwMktrYWwz?=
 =?utf-8?B?eUdtV2RCelVhN1l6b2NvSVljNE9LeE5NNEVEZ04yVkRQVGNoT0Y5czJrVHhU?=
 =?utf-8?B?eDg4SzRyM1JRZjF1cEh0UFF3T3ZMQjdUeVBFVGdKZ3RmS05GVEZKMi9zU0pY?=
 =?utf-8?B?eS9kenliSVlkbFFBM1B3N0J4RDlXSmYrbitrL1ZkN1hydmFjd092TzNRUWh2?=
 =?utf-8?B?aXd1WkVjc1VTa3dqVmM2SVMwaHdFRVNsMy94ZWwyKzduaVU2Z1NqcERpMXRQ?=
 =?utf-8?B?cEkyc2MxcnQ3eElzKzJUemhTZ0RmUWNJUEQ5VCtjc09TQUZNZW42MjR2WmU4?=
 =?utf-8?B?Z0FCaUlEa1lxL0FwMFhockRzWitkOFMxbzVIa0VUbGh1ZWp2SzRscEl2Z0dE?=
 =?utf-8?B?YnFmNksvYlA3YUg0ZHBZUnlWd3ArcUtJdmZSWEtYWjRNakVYbGdVQXptbzJo?=
 =?utf-8?B?dGdVeGxEMU43aXdrVUF0WUYyaUlEVzNZd2tUY3grOXFjbWo1a2RucExPQ25t?=
 =?utf-8?B?UnhDSXJMYWVIVWhVQVpRbXE4M0hqeHNMUWRtaWtCL1Z2OTA3UWw1Wk82QUFN?=
 =?utf-8?B?cEVWeXVUY1ZyQ1ovU1VwN0xFMHM0dlVvbktvSmVNbGZJWEJGSXRwTUhLZjZm?=
 =?utf-8?B?Y2NCWS9LaitWYTF0ZE5qRHpoRmVhVVc3NEoxa0NENkJwNXZPNWRKMnB2OEtJ?=
 =?utf-8?B?TWpTQ3JGS1JnYUFUdGMyWE9qbEhmMHRncXVxUDhNcm1NeXN6YWc2Nlo3UDQv?=
 =?utf-8?B?T3JpSWJqT1FDUE8xQzExQ0daZHczbEJiMHRoNFVNMEtjQnZRZGVrVFp1bjAr?=
 =?utf-8?B?WnhaeUtJSXdubW9jZXpaZWJpT2lGNUpXUmJvK2ZtWE1xYzJLbVQvaVpWMlBT?=
 =?utf-8?B?anZoaXlJcmVKY1pyT055UWFuMXBYWlg3OGw2eFM4QUtRM216Rnk2WUM4Z1h4?=
 =?utf-8?B?YzUrQjFCWFp4YzR5Y3hGSlJ5S2k3Ti9HRTFzd0RrMjVGTmhMUG1KLytJdis0?=
 =?utf-8?B?U1hZbnRhTmF0eGlCUHNGc3EwTkdyTW95V2tUL1RGM3Zsd2J5aWlnelpyUGtV?=
 =?utf-8?B?MFZGcEZiMytPd3E5NEJ5NWVkMzVkUWdrK3RMUzBUQ3RlWXR0K21OZ05ERm9J?=
 =?utf-8?B?RDhCM0ZPU0p1RTh0OUZFWXkzMWt5V0R6YzJHR1ZoT3Ixb3h2TkZSUFhodEtn?=
 =?utf-8?B?N1Bzek9mTEJ0VmQrRzViSFVvT3Bub3VscytxRmVIdlNBRVBZb3ZidXdGSlVO?=
 =?utf-8?B?OFYrUDBRcTdHWXh5KzZ4c3dTTXcwa3VIRE1ZMlhpWXYyZ29MWGNEKzZMWTU0?=
 =?utf-8?Q?ldrd4LufBX4m5RGmBenLkxO4N?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01FE1535A7A4D44CA5F447BBDB8D15E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6c5c88-869c-46c7-a50b-08dcc420e8d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2024 09:41:20.3473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rZ5vN11QgRuJyemcSTOm+tdclDh1zmRkgsmClwVymXUQmTZS9/b0YpZ/eXKbNPng/QEJbIrkzxiWO+q0ZXUS2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6054
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTIzIGF0IDE2OjQ3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBcHBsaWVkIHRvIGt2bS14ODYgcGF0X3ZteF9tc3JzLsKgIEkgd29uJ3QgcHV0IGFu
eXRoaW5nIGVsc2UgaW4gdGhpcyBicmFuY2gsIG9uDQo+IHRoZSBvZmYgY2hhbmNlIHNvbWVvbmUg
bmVlZHMgdG8gcHVsbCBpbiB0aGUgUEFUIGNoYW5nZXMgZm9yIHNvbWV0aGluZyBlbHNlLg0KPiAN
Cj4gWzAxLzEwXSB4ODYvY3B1OiBLVk06IEFkZCBjb21tb24gZGVmaW5lcyBmb3IgYXJjaGl0ZWN0
dXJhbCBtZW1vcnkgdHlwZXMgKFBBVCwgTVRSUnMsIGV0Yy4pDQo+IMKgwqDCoMKgwqDCoMKgIGh0
dHBzOi8vZ2l0aHViLmNvbS9rdm0teDg2L2xpbnV4L2NvbW1pdC9lN2U4MGI2NmZiMjQNCg0KVGhp
cyBvbmUgaGFzIGJvdGggQWNrZWQtYnkgYW5kIFJldmlld2VkLWJ5IHRhZyBmcm9tIG1lLiAgWW91
IGNhbiByZW1vdmUgdGhlDQpmb3JtZXIuDQo=

