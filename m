Return-Path: <kvm+bounces-17501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7597F8C6FF6
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE3A71F236DF
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0FB137E;
	Thu, 16 May 2024 01:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W3VkLhYF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EEBA47;
	Thu, 16 May 2024 01:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715822420; cv=fail; b=IE9gF7WPPsGlLjtxLjCvuUfKMqXHpzcbUxvu3PkQqWm5mv6K1uGytB+p6fBOEZ7KwP4sFBUO3MnXLacICc4+lzj+bGI/CYAOstLu8NLRFDMVBLQj1+oXlnyQ0t/OLTPqUh45ZpVYL+v5HkOD0dqG7q0efRAl5iTDePU1IvjNEuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715822420; c=relaxed/simple;
	bh=imt+hNXR7krlb21FhvyYbmorCkAhpeVEYibohW2xYho=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KwabNCVPXjPpxOWPT/cb0sOQwSRkf+QYgz5Ag2Dccjxxijp0WwuHlDujHZg2ywD1OMiG+71rrzd/3F3sdrCWhlBcUWTh3mBVkQOkV7HWVCqTWLCQRBVPhvgbVK/BthKX4wyo5KDHXTse+9MxGrU2eO7AjCCJ+1xfrma+gDeku6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W3VkLhYF; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715822420; x=1747358420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=imt+hNXR7krlb21FhvyYbmorCkAhpeVEYibohW2xYho=;
  b=W3VkLhYFVYgypC7+n11+zyClpa9RePpzVIGKkzzDDaUhQKTr78NbJw6v
   RkKOrSNAnAf+7Jz6cD3ln60wb/rHW2+IInk8VM+KS7Svhs9h0ggkZF1la
   brqvG9NKzhpITjg1aOOZffm3j1MZLqozL/zd4jWxSUPtT+6erZZg0XVV8
   O3OPPjPCu4UBH0SHywFyiYB/HhEnR9Kwx86aE/8ANEZrzX2Huqgxwunn+
   yNFzqCgYC3VXDlkJJkf3yE/kJ8mvKZonvX4ZjWEiMrRQ/ZUhRMy9F/Ewp
   XsrtOMflnRkHydXiLrvoBm241dckQwKa2LXsFAwx0L19zS4E3YH7gBkKo
   g==;
X-CSE-ConnectionGUID: XD1i9t2mSouk+cuPfgFghw==
X-CSE-MsgGUID: KCbbKpkTT1uTWddUQ5Qv/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22485990"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="22485990"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:20:19 -0700
X-CSE-ConnectionGUID: IdndbVkYR1KT8gdG8ZMPCg==
X-CSE-MsgGUID: Bj4sFTDHSumBoyswICncvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31312284"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 18:20:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 18:20:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 18:20:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 18:20:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 18:20:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmZ+O+1xT3kYauQmShLIckaq7Qwn4QWUbB5dN8GVjMoKYajcE/u8tqVgQ27GbnD8Rlyk7hy5Ar8ayBZfnCHd5eO7+5fXIjHH4Qmt2hQeDRIAfeG2TN5POXNRLLv8SyKmRnElaMJ7K0gcJgBYeHPg+OZ7JWQwv7IVFR/zF3OCLjA7IcmktLfI6ivIDpBHLrgOrINICiUar5AaNUFfMf0Pxadx2XgBh/Kj/+hGlfS2i92qzoV6CcJXubnwMKuvFnNw5dYOfUMhs+68PJClOoR1ctjds3PTUYPy+L4hSugJRmdB+9FKo/bcxEqDroz07N9yYmOKAmtOCi7zTMDS/t2j7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imt+hNXR7krlb21FhvyYbmorCkAhpeVEYibohW2xYho=;
 b=OkYQiJ+qapn2QFZ3NvlwF+WWtlJxsRSMNMu2g+fGYwfoKOsIJXYH1B8371thI10Yd70SyKzwOb5feQVB3D6xRWEMdPpwUmmbq5pweCCALpaTCKDp3TN1WgZobbvoGbVswgK9oFyJ8aiguUShl6pt+6LUcfVmZmnRTXHQr+QNc/Mpc5qNBUXJ038vBlJTsqqUuq8Zrz6GB7HzGddEsXMMmI6n3/PfQX9ZqYzImUH3iA6E2DOk7uVSuDCdRMTmUXGzom8N/gsV/9Ni2FmmTz8hPCbE5kZeSluGn+bfbetlySC/0YS6qk8aNNahQ3MDeY0Fd8h/SuvN/+UFCKoTLDUOAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6212.namprd11.prod.outlook.com (2603:10b6:930:24::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.25; Thu, 16 May
 2024 01:20:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 01:20:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com"
	<dmatlack@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaAgAAByoCAAAQqgIAAA6mAgAAB7ACAAAHNgIAAAriAgAAH94CAAAR+AA==
Date: Thu, 16 May 2024 01:20:11 +0000
Message-ID: <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
	 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
	 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
	 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
	 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
	 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
	 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
	 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
	 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
	 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
	 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
In-Reply-To: <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6212:EE_
x-ms-office365-filtering-correlation-id: a57740a1-11af-4851-a374-08dc75465511
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Ri90V3RINjMrbyt2T3FKalg1VEUrM1p5U0grN0pqdnNSM3NOcURFVzB0Rm14?=
 =?utf-8?B?eEthaWEyenJ3NTBzOWZ1a05FVkx2alY1NmJWR2pJOWpWL1FHNlZCd09pTU5n?=
 =?utf-8?B?L3FkVnpPZ2gwR05RbGFSMHZ4OXV3cFIwVWpjQlhrS2hLRzFaYkRNYk9jMWw5?=
 =?utf-8?B?RmlEQVpCZ09hL2NnLzJJRmlsdmhkMjNRREJQNHVzRWlyT0NXK2pMbk5pYTVS?=
 =?utf-8?B?RGNoSndiazNXZlR4VVM5MXBRaHJUV2hXM1VlVTFMcndtVXREcXZzcGVXUE5u?=
 =?utf-8?B?MWJ2K2tteFdBeTZlVUYrbDJZaEFBajRtck5rYm5JenVsQ2R1VUk0ZWlZWmhL?=
 =?utf-8?B?bHdTL29WNk1xRnczRWZNUWNWTnVNVjlBVzM2c0hIaURFaTZSTS8zdzRFbzBN?=
 =?utf-8?B?STFEZERuZlZqK3ljNUJkaFdRbk0wSHlCZXYrNi9zV0RVNFh3S1kya0xOTTRq?=
 =?utf-8?B?eWw5amxCTkxSOTMzY1JHQkpVOHdzd3BHWm1zM1gxVDBsNWpIRllobUNOeXph?=
 =?utf-8?B?YTU4a0k0TnVLUGhNZ05QMnZ2bWt4VUFHSnlvWDI5T2RpOElwRmEzQjVDSWRJ?=
 =?utf-8?B?RllURFQ1RFZuR0c5dzVRNk9sNGhxb3NuTXBqWWxxV3pUTXR2WUFXZ1NSbGZu?=
 =?utf-8?B?VGU0SkpHTVBVZHlXdnYwTGd2RElaWllyaWExRktLSWd3ZnUvK1NJMTNxUktP?=
 =?utf-8?B?K1lQRWhoSHVXZEM4MUJiYVp2TzlhSHk5Q0tkd3pHME0rc2F3NS9ETjlSMWdu?=
 =?utf-8?B?TEMxSTVQbVRHRGJMR2lxYTU2ck5nS2ZCNkt0NHJWdlc5cDRzU3JheGJzVDNi?=
 =?utf-8?B?eUNkdDZxWnlOV25RV2tyaUx0MVBPc0RkT2h5K1BVTGp4OEhtYU50cHFHbU50?=
 =?utf-8?B?NktyejExbkhNR01jd3FORFhQZmlud0tlSXNRVlFDczhhVTBuekFZWWVCeUd6?=
 =?utf-8?B?bWdISVdVRS9jRkZTcHdsRCs2RG5FUE9lTzBad1J2eXhEQUduTnZ5RmJtY2xP?=
 =?utf-8?B?NGhrbkxJakpGaS9LVWNDcEoyT2RIZW82QUtwTGNiRlh1K3BldkZmc1krT1Fr?=
 =?utf-8?B?L3A1bWVkZ1FTN0tGOThKOFFaQnZJR0c3SWM3L1FubmJ5N3NDeWdUMDFpREs2?=
 =?utf-8?B?dUpEbThjcWJxVElhZ1dSS3QxbU5TZ3dGSXBkbDRZNmxCck11SjFTREhHTFRj?=
 =?utf-8?B?NVI5RHRzN01JdE8wQU9SK1h2K2x2eFBpWmpNUnpyc0ZwcUhkenFrZDRGUGVU?=
 =?utf-8?B?VjgySDFDMnF6ZzZWeFVucFNPcmdPeTdPeFdseVhPN1ZzQ01VODJqQkNlMVlj?=
 =?utf-8?B?cUZQSVZuVk9Ba1c3SmZWTWVXOG1tbWVENFZLNklOTHN6VTdBTEtqWldCMHRC?=
 =?utf-8?B?U3RQcUNVWDhyODh0ZlRyNGxBMmZzdU9CYllHTkp5WlAvZlRHL1JRaVE3Mk9D?=
 =?utf-8?B?ckJJNWJOZ3BCMmRmZ2R0K1JILzNjZVB0UHlsMlc1NTZJMkpMME5qMFB0UXJF?=
 =?utf-8?B?MWtKcWFuN1lDYWwyUkxEUkJyV21ELy9ndEs4U0RJdnBaVzlOVlltWC9UNFZC?=
 =?utf-8?B?dEs4cWtvcHVkM2xtc0JqN1R4ZEorR2UxZVhRZWtjaStvWlZPM3dSQWdpYjFq?=
 =?utf-8?B?dTViUWdoL2NXL20xd0JsMkJuSVkvVmlmaUNDS1Q3Qm9JL2FWRHdyQWtxbmlC?=
 =?utf-8?B?bEJEdWJFNzdqeWJOTjZscjVmdHYvSUZOZ2VzMFJtSWhzVng4T1JtNnNWeXZS?=
 =?utf-8?B?UVBDQWNDMXMzMDJVY0M2aHdYK1VIQ1UveEkyQ3FCWUROdGNSM3ZrRS9QQ1Q2?=
 =?utf-8?B?dlRYaENBaGVyejZQbHhndz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVBTSVhLOEpBR3RPN3FJM2hCam5ObE9ITUNBa2FhZ05KTldKM1lEdHJnNkFI?=
 =?utf-8?B?Vy9iZ3RIUFNTdDJlMkw2cFZyeDc3QTFrVWkrdy84c3hmVExadUU3bWVsaVRr?=
 =?utf-8?B?ZjJ2bllQL3BwK1dQMG1JOURrZ3ZkckFLZ3MwRTFtNXFvTU9Lcm5DZExSOVdM?=
 =?utf-8?B?SlZQUHAyZVRkUlk1RmJiUENHQmRxa2pPU2hXN3JQUlU0dWd5dmVraXQwT1Y4?=
 =?utf-8?B?UGdkL0NkUXNTUUg0WWhOL0g0NGM3T09aOUgySGZHUGR3cDBiNE5mdnFGeFVS?=
 =?utf-8?B?WFJXRHVxaVFTVFBvM0JUb3RMdmg0WGljdVE3dzYrdVBRVXdpT0txemdXbzYv?=
 =?utf-8?B?MFcrdUFuSlNLV2tEL241ZWlUTE9kNlFQRzhnVHNIYStieTJ4MEFvUSs2V1Yy?=
 =?utf-8?B?a3RUZG01YU5vK01yOUlRd1FBNXQrb2U1WEM3cWk0Z3J1SGllb2ZFYVB0KzV2?=
 =?utf-8?B?QzROYkxPYXFsMmgvcVJEM2VvRXhsYitULzlkRVNaclJqVnFlSjFlQjFNdEMy?=
 =?utf-8?B?K3ZYWENnRGJRRGdTUWVtazBEMVBYZjNrQk9UOVpIeVNRY00wcnJsYXVmN0lK?=
 =?utf-8?B?ZGh1NmhlUlI1M3BFVkNDR0lUT2FYSndsY3lkR1hmZFNuUG9kMjlnSHJESFNZ?=
 =?utf-8?B?OXRsMWhTNTEyeXVMUlZRL3JVRnhIbDVxVzlmUUsrMndTQXEyWGYxbHNxdnBT?=
 =?utf-8?B?bXEvK1d6cWo3UFJ2MDA0OEgvbllXY0o1bGY3SWo1ZE5jWktCK3BxRlErYVpq?=
 =?utf-8?B?bmpZVkRzaEhhTG5OeSt0MFJUZ01tRGNzd3hiNzV3aTRWRkVQbHMxUGhEOWNr?=
 =?utf-8?B?T21LR3FzSUtXZjNmNG8ycVYwdmRhVjhKTzM3bk0vZnQwTGlaOVc0RjJ5U0E3?=
 =?utf-8?B?SXFmOUt0Z3hqeW8xOHhCOUl5eXJ5dEQ4SHNhSGM5R3d0Z3hnUm1ENXZDbUlB?=
 =?utf-8?B?M3B3QVdreHc3UE5tZzI1a0VqVjM0M0hXME9qekxia1BFRmgrK0FXdUFxK0NX?=
 =?utf-8?B?Sm4xMEtrY2cyS3k1WEJ1YXNqd0RyRlZWU011bURqRHk5a3dyWVpYMlFsazVZ?=
 =?utf-8?B?dGFXemVodm1nU3NOdGNiQktvbHdVcFFUbXRvZVphT1JyNW1tMXpxbzBGaEwz?=
 =?utf-8?B?M3F5Mm9IRmJ6RmNkU1RDcnJHVHJ6c3BvQ2NHdDFtUmlaMFY1Vm5qUWVKRFJm?=
 =?utf-8?B?ZmpoOG8zWUg0SFUxRld6dldQc21SSW9xdHFCdmtwcUhNcXYvWjAybkVHRXpV?=
 =?utf-8?B?M2hwbU1BNE1PeGRvSmoxOUkvRXNrdDV0MytENWg3SGVGdzdQRXZIUlBreVdJ?=
 =?utf-8?B?dDBieUwxYmZaNTllbVIvcExIaGEzNmZXancxMFRKMWRieUFWUDZsZ3NHYitY?=
 =?utf-8?B?cUQ0NC9QdHd5eVBtNXF4NHZEWUhPMzF0NDFOaFpieHhnVEh4MHpGZXJadFor?=
 =?utf-8?B?T2wrcEo5VzF6WU4wWGFKSzBNMzV2K0JVQXJ6azhya1RwcDY4bWdjc1NCWXpu?=
 =?utf-8?B?ajNJdCtHWXFkSkp4UEw0cE5pU2dlVXV0eWpwQ0RsbjZ6cTlrL29mMHA5TDIz?=
 =?utf-8?B?ZkVMendndE9aYWxPanlDSW1OTytLQk1CUEt5N2s4YllhR0Q5L2RBZXQzWnRE?=
 =?utf-8?B?bDRzTU5OeUFVanQ2SWhncDY0RVBrYWdxaEt0SUJwaytua0pIQ29OTm1xYk56?=
 =?utf-8?B?UGhJY2MyS05yT2xmNTMrby9xeEcxSmYvSGVHVUppS1UwdE8wQUduZks4Vy9l?=
 =?utf-8?B?cUpWaENHWlkzTHNvUUNDbmxhTG9NTEw3cGxOemptTHRlRXJXdzVMK0pOWXlj?=
 =?utf-8?B?SkxIMGg1VXZZZnA1dGtaM1FNS2NMMmVmaFU5VGlobU9jR2l6SGRiZGI0bGx0?=
 =?utf-8?B?T2ZrM3B5bDZIa25mSU1mdzVaV2t1bCs1NWdiN3pOQ0FzMkI1eFpIMEJtTnZx?=
 =?utf-8?B?ZjAzSVNlMWtrdWVhVUVXNCtKSzByaStLVnA3RGd0Y01TaDdGc1FPU0pZZ2Fv?=
 =?utf-8?B?V3BuRDg0a2NtWGswd3dVbE5DNTZtci9IdkMwU3NVWUo2eW5hNnlHeWxScnR0?=
 =?utf-8?B?bmRTa241a1hxT09EdVdYZDdnWWlMVUhMZDZJZy9mL1VhZWZtczZWck5vc1FH?=
 =?utf-8?B?UkVnY1NIZkpmQ01wa0dnR3BWZUFaTGdXL0tWWFF2cXNmVzd2dStGbEVTM3hx?=
 =?utf-8?Q?d6llOULjWLLucotl87k4IPw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99C48306DC247F4395EC5C0752442F46@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57740a1-11af-4851-a374-08dc75465511
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 01:20:11.4842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a5DV7jtTwsVpWDAwmO5FEIntom1mKimDjnOrNzYjak3ZrLZTrn1hjItFRX9Q56MGjuYInoSIEhoul/klpaUnxRWvS0MuqUwdWshoWWTjLNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6212
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDEzOjA0ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gSSByZWFsbHkgZG9uJ3Qgc2VlIGRpZmZlcmVuY2UgYmV0d2VlbiAuLi4NCj4gDQo+IMKgwqDC
oMKgwqDCoMKgwqBpc19wcml2YXRlX21lbShncGEpDQo+IA0KPiAuLi4gYW5kDQo+IA0KPiDCoMKg
wqDCoMKgwqDCoMKgaXNfcHJpdmF0ZV9ncGEoZ3BhKQ0KPiANCj4gSWYgaXQgY29uZnVzZXMgbWUs
IGl0IGNhbiBjb25mdXNlcyBvdGhlciBwZW9wbGUuDQoNCkFnYWluLCBwb2ludCB0YWtlbi4gSSds
bCB0cnkgdG8gdGhpbmsgb2YgYSBiZXR0ZXIgbmFtZS4gUGxlYXNlIHNoYXJlIGlmIHlvdSBkby4N
Cg0KPiANCj4gVGhlIHBvaW50IGlzIHRoZXJlJ3MgcmVhbGx5IG5vIG5lZWQgdG8gZGlzdGluZ3Vp
c2ggdGhlIHR3by7CoCBUaGUgR1BBIGlzIA0KPiBvbmx5IG1lYW5pbmdmdWwgd2hlbiBpdCByZWZl
cnMgdG8gdGhlIG1lbW9yeSB0aGF0IGl0IHBvaW50cyB0by4NCj4gDQo+IFNvIGZhciBJIGFtIG5v
dCBjb252aW5jZWQgd2UgbmVlZCB0aGlzIGhlbHBlciwgYmVjYXVzZSBzdWNoIGluZm8gd2UgY2Fu
IA0KPiBhbHJlYWR5IGdldCBmcm9tOg0KPiANCj4gwqDCoCAxKSBmYXVsdC0+aXNfcHJpdmF0ZTsN
Cj4gwqDCoCAyKSBYYXJyYXkgd2hpY2ggcmVjb3JkcyBtZW10eXBlIGZvciBnaXZlbiBHRk4uDQo+
IA0KPiBTbyB3ZSBzaG91bGQganVzdCBnZXQgcmlkIG9mIGl0Lg0KDQpLYWksIGNhbiB5b3UgZ290
IGxvb2sgdGhyb3VnaCB0aGUgZGV2IGJyYW5jaCBhIGJpdCBtb3JlIGJlZm9yZSBtYWtpbmcgdGhl
IHNhbWUNCnBvaW50IG9uIGV2ZXJ5IHBhdGNoPw0KDQprdm1faXNfcHJpdmF0ZV9ncGEoKSBpcyB1
c2VkIHRvIHNldCBQRkVSUl9QUklWQVRFX0FDQ0VTUywgd2hpY2ggaW4gdHVybiBzZXRzDQpmYXVs
dC0+aXNfcHJpdmF0ZS4gU28geW91IGFyZSBzYXlpbmcgd2UgY2FuIHVzZSB0aGVzZSBvdGhlciB0
aGluZ3MgdGhhdCBhcmUNCmRlcGVuZGVudCBvbiBpdC4gTG9vayBhdCB0aGUgb3RoZXIgY2FsbGVy
cyB0b28uDQo=

