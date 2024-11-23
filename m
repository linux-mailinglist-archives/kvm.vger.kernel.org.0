Return-Path: <kvm+bounces-32392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF4D9D6726
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2024 03:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA477B22431
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2024 02:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C420770FE;
	Sat, 23 Nov 2024 02:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/++62YX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E0120E3;
	Sat, 23 Nov 2024 02:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732327594; cv=fail; b=eraVN2ls3Q1Tjn5g2Yq6DkotafloLiJpACStb9O8sJyYCvWlztdo+KOdu5ymINsHs8glkcooFhiMqMb+CxDqHiIteSUYrYFoOn2BPlle2NoGUhc78uOTurICTjRsOzA0gC7YQy/GwFBa0Zut98qxEv6V24cnvoKmqPJSskiVHns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732327594; c=relaxed/simple;
	bh=enF8jZvEB0NLwd5FpFJOmPbI7IZNUT85jEX/eX04oDA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f0obOSzUY1hN2SrLccJXupaXXY6YLbKJHzOOq0y7EfQbAfYdkrkjl1fey2qLsaBB7Ss34Zyj/NIUrKf4mg71VE213Jhl4i4fOzrOX9I2iu1n/B8KAR0/Z11wQxFcYKJtGJ0R8SylfgZVcK98Y0j4vLUMaCASAW964mmnE9E8438=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/++62YX; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732327592; x=1763863592;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=enF8jZvEB0NLwd5FpFJOmPbI7IZNUT85jEX/eX04oDA=;
  b=h/++62YXEGDNgBxezolL9rjoCBRJwEFr0plCAzoM4KVy873lqvhhg6Vw
   Ab60w7J64qrmhMIAjHJ64dUJ0fdLrbbqDmUPtgonYkVEh6d+WY9NgFB2W
   MuPJb1F9snpPce3pG+cUDNg3F9MWGRQeqnDrHu98PVBUJCEHI5tFwWy4M
   teK+cWoU6WlAOYAj/3i7SaRv6RM1WmL7Fwy8aLJuKI2x4WsGf7I32wR4j
   3AVZ7yatNuv8qx22gN/QJxz6lnoLIHdOjF//DMYeio2sDxAF7rWUItBy1
   ppfwxe9vUAqHs+Pkt7kvpfsGp8aHnvMuEjc9xKynwteN3dkVGwlVXqwdw
   w==;
X-CSE-ConnectionGUID: FK0BiW17SA6dNysjDVyUAA==
X-CSE-MsgGUID: NdLNitXjSHyvP4JjNsBLpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32616366"
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="32616366"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 18:06:32 -0800
X-CSE-ConnectionGUID: B9lnz+qVRQOemqnbPTV3tw==
X-CSE-MsgGUID: cSYAKorCRO6ynkJe5aFHng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="95510592"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Nov 2024 18:06:32 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 22 Nov 2024 18:06:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 22 Nov 2024 18:06:31 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 22 Nov 2024 18:06:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zx/WXwIq60zoS23R76sCO8rw6GDFsJtyJJ+vq78trvo1znqhZZGzVJBaZ4vf3m/qXgfF35h4awq3BeQxcLheh0mloRLUYf8OSnW4y0A+wyID6PCjxK1Dn/YokzldB09iezJky+0K4ZDQreR9yoby6Q2gmK7L58/hGc4wWJntfPzgHLGFmC3DFQV+hOGXpX8UHYQkHXNT0DukHNPOo401LexKjnM5mS1tkzk1X/68KJcMyOq5k6PTpXlcf17pV4oeiuyF8gUnnzxgARI7GbbhSav5HaIamEqe3hpKvNSpXy7S60ED3rOPfwIAIZXGEwpOszoXmJVLJbacQ8r7fkZgpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enF8jZvEB0NLwd5FpFJOmPbI7IZNUT85jEX/eX04oDA=;
 b=e2bg7riyhhY9cU4Rg/XMgOf41GVG0rsUdrJ+/yy8l5lsL9wZZP5MSOa/KfBIcXSTwlub9VsRQIl/vRJH+fCkDR7wYT67rMDoAL6o9XfA8Z7RdGUWKWI76G2GlK6K1dGXs3UcxSpECnv6K2WQZSnBEJOvkNtHTttV74s7MPGjvMCo7Frg7kJgvan9VvR3ZrHNchw/vxAGIezHZz+b5+mngA+7DhfJLSFsBCjwypiCSXEqvtK2yOqxGTkG6OrTltR4j6o6A0UWjqakmV6uSprNKGJ3Pxntg+BTB+pnDXIOrYgUbxKB7YQQqCxCwFxAHN37nl7/+BZOyQ+5c2IAoNe6+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4556.namprd11.prod.outlook.com (2603:10b6:303:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Sat, 23 Nov
 2024 02:06:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8158.023; Sat, 23 Nov 2024
 02:06:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "yuan.yao@intel.com" <yuan.yao@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>
Subject: Re: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID
 management
Thread-Topic: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 KeyID management
Thread-Index: AQHbN5vgtMhvA2xrukuV6jMhm30vmLLDop8AgABiGwCAAAO6AIAAIO+A
Date: Sat, 23 Nov 2024 02:06:28 +0000
Message-ID: <92547c5fea8d47cc351afa241cf8b5e5999dbe28.camel@intel.com>
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
	 <20241115202028.1585487-2-rick.p.edgecombe@intel.com>
	 <30d0cef5-82d5-4325-b149-0e99833b8785@intel.com>
	 <Z0EZ4gt2J8hVJz4x@google.com>
	 <6903d890-c591-4986-8c88-a4b069309033@intel.com>
In-Reply-To: <6903d890-c591-4986-8c88-a4b069309033@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4556:EE_
x-ms-office365-filtering-correlation-id: 0f08ef5f-9e85-4a2e-b3f5-08dd0b6370ff
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Ull6V0xLRDZLUWs1cGp3TzVDUjEzUTd4YUdOMWcyNE90NU9TZUo4SGtlWFpl?=
 =?utf-8?B?aFVlQ3hURmZ4bmo0TGhwcUUrVGVIcTh1bEhlWTRCdmhtK28yTEROM3pRUVBF?=
 =?utf-8?B?VUtaY2R6SUxZSTQ5dU5ITkgyc3ZXRStQRmJHdTNGMFdxUjM2a2UraFJGYmw3?=
 =?utf-8?B?Q2xMV2dQU3VHU3lqZmhvMHQvU2VGak93NGs3cVNNd1lRUzI3dm5GRzRoU0Vp?=
 =?utf-8?B?ZTIwME1MTHFuMlhwNWNYL0hTREtQcVJHMDhHTDRlSWROSW5nZndQMlg2MTBP?=
 =?utf-8?B?WmdTT3R2bkhPakcxdHhMK1R2ZVFNYzlBN0ozdW1ZY3lqaEJPMllvdE9MTVNP?=
 =?utf-8?B?RDdvUzF1R2tsZzl5dTNsaU9rbGMyS2JoTHBGd2VnNUxlOFZ0aUJudm1OdGpv?=
 =?utf-8?B?RTU3emV0N0ZIOUR3Y3R6bGpoRmhFQnFQRWNpR1M3aStrTktCOFdtZ2pPMDh2?=
 =?utf-8?B?TzhZblV0SW1CdURIaWYxdlovZk9CTSt0TnpublNQNUV1ajdzaU42STZMN0ZQ?=
 =?utf-8?B?VUJtWkJyTDcyMWRwc283dGpENDQ3b1NmdWtDMC9FcEdvZFU1Snl3ODN6d3E3?=
 =?utf-8?B?ZWpBclZBdlkyQzBodzBDVGl5aW5BNXFzMmZMYk8zWlpSenFtV1FkYVJwN25I?=
 =?utf-8?B?MzdzYkFDN1BIcDhDM3QvZ0FkSGVPTVNJM2dqZXJQeUhuZ0dPdFRWekF2VkJM?=
 =?utf-8?B?VjdZcU5uMzN3MUw1eTBabTRrQ0VnUkZXQlRTdXhvVHZoOXhJUDFsSXdaR21x?=
 =?utf-8?B?YXNqb2xFN2QrRHpWaTNIbG93cmU0YlJlajc3NmlNVzFKNUE0VWRTUmFSb3Vz?=
 =?utf-8?B?S3o0dW9OM2NQY1poL3A3WlBNRXdGN3Q1bFZKTHQzME5COWFZLzFoanJKYlJi?=
 =?utf-8?B?UnkvcFZJT2MvMElRSmJuOUg0RHYrbTA4eEZ6dk9PeHVmRms0ZnZVQlBlcFdl?=
 =?utf-8?B?OENMdjNmbHhqSFkvNXVDcTlJRzkvWWo2V1hOaGEwNWtjQTlHYW9jeU8wQUdC?=
 =?utf-8?B?V0ZHbVhNWUhpTzVRNFREY1ZTZ3ZQRjFwdmN2WStWMDVIeWpxb0xyNmRvOExa?=
 =?utf-8?B?Wjl3TERDZEJqNEljNk4xS0NrM2MzWU5tRDQ1L083VjBmMHR0M2NNREtZVU9P?=
 =?utf-8?B?dWo0RmFnbUF4NjhQUlRFb1ZPZHZVK2FKN1JHYTkrMERVM3o1dFdkVlZDdFp5?=
 =?utf-8?B?dzVrMmFDUEdoR29qT3YxaUcxKzZPN0JYT0lCS29EbUJjZG9PRFpxNTg5K25k?=
 =?utf-8?B?MTVud1J0TGZ1c0R4cmw3UFB2a3BYUnljdVo5K1FwQ3hMUzIxbm5kTFJNNlJq?=
 =?utf-8?B?TmVkN0lvYmkySlhXcHNqemFQMnB6bmx6eFBaMHNCUnJIWlQxc0xVVUhhUDI0?=
 =?utf-8?B?b0VtZ09ZN2JkOVZVeHZyS2EyNDFxT1h4bloxRE1hbjUxbTVObHQvVDM1R0M0?=
 =?utf-8?B?MWNzNjNnN1pYQzRTTU0vT0MrdnBhVEdmOWNwTE8wRHVBc2NXdENCWm5kT05z?=
 =?utf-8?B?cXJwWUMvZDJTbityWUdGdjlnM2RSMld2MDNsOEdRUStjYVJEV1VCNTQyUHRi?=
 =?utf-8?B?c09PcHJsWGtiakhjVG82R1hQanRqR0Frbml3aWdXcytUSndpc20xa3grK1Vz?=
 =?utf-8?B?OExta3dYWHFEcllMRXJsRkk1eHFpcytTOStnZXI4a0VOUEc0VEJvUytWYWRl?=
 =?utf-8?B?V0RBYXBXYlYzZVlSUDVYcWNrTTF6ZkhnSTMycmJlY0dDSlZFV3p1SDhlOXhC?=
 =?utf-8?B?TG1raXFtNEtCQ1NiWFhQNU9ZeU9Ta3V2RGFaWU9iL3NrbnVNejMybEh5aUVC?=
 =?utf-8?Q?060sHTTgZwK/Wm+26crpZblweEqy+rgh6wbqY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGNGcE0wZ21qRlpLQmN5dHp4RkZrSWtiNUxwVEpFdmFSTzgzZ0NMV2VHbFRl?=
 =?utf-8?B?Q2tJb3JLQ2l4LzRjM1hHcnZ6TCttZHlsY3ZsWkRwTkpiMmtYelFsVmdkbzg1?=
 =?utf-8?B?UGxCYm1WQnBuWGdNOVgwVlBBS1l4TDVqbDJvWnhZTG9telVKbitNT3NkYnMw?=
 =?utf-8?B?dXIwMzJHYUM4Mnc1OGZWMktaWGVpYXdNRSs5a1B1UWZzOHpNQi9QRkY5VjJM?=
 =?utf-8?B?VnNIeCsra0Z0NFJtTlFnelNPVFR6VWtXeTlkc0FpL21aNW1Bd3FVb2p3YUhT?=
 =?utf-8?B?cjhWN3I0MXVyTjFmQ241QTRNWHEwRUVQellvMHhQcjI4eCsxTFRnQ25RNGdw?=
 =?utf-8?B?N2RaQ2pBTDZCSGlHQ0FyOTU4dmZxaGRLK1hwTElGS1ByRk90b0ZpaS9aNDl6?=
 =?utf-8?B?S255dUJaQ09Qdm1wSVRXN0ZjblBlNU9YWlpOVlZWcllLQUMxMy81bEpFYmxL?=
 =?utf-8?B?NXZwbktBOTVYYmlnWDN0SzZMY2NVNjk0MXVId01MNVFPN3E4VUNkV2F5ZndR?=
 =?utf-8?B?emJBOXZUOTdwRms2ZWdBdTZYVDF3c0dDS0EraXAwWDcxakZzRVJsMndPcSs2?=
 =?utf-8?B?aDVCUXROSTgzNFRQeG03MXdwZnR3MWZJNmtZdG13SXczZUx0bmxrd0RGelJn?=
 =?utf-8?B?WGJ6WTZhNDFhclRlODg4OHdrRlV4K1U2dnpPcHhSQmh5ZE1iQWk4T3liQ0FT?=
 =?utf-8?B?d09wdjF5MmVONGlhVUJXaXl1VzQrSGgybTBmaytkUUNKZWdsM1g2NUgrQVNS?=
 =?utf-8?B?ZjZKL3J0TkZhTDFzMjhiczlDZWxGVU5rdkRSMkVmSkptZ3BmWmlqUjhNdS9o?=
 =?utf-8?B?bkkwSXJsWG1yVkZQenNCbzZHZ0VkZ2FBTHArN0ZXSzRpTmZtQzZlWmI4RFNQ?=
 =?utf-8?B?UXBncmJVYkswR0V3d0FITnd0c2xUaERZakVyMVBtcHJwSUR1YStQMW5RWU5H?=
 =?utf-8?B?amJSZ3k2OFF5T3V4TktDN200QTFIbkd5N2VTRTNvbmc0a1NsSTVPS1JRUTZk?=
 =?utf-8?B?MXJkZkpJYmxYZk10RENaTGVCNUJONVBia1dKZHlwNXpQMHlkSTFBazN5Vnhv?=
 =?utf-8?B?QWtuaWNyY0FVMlRwVVdoa3ZrNVhyeWpnYVI5MGNpWGFRMTNPdUVTdU9xa0l4?=
 =?utf-8?B?YlhjUXZVTWRUMXB5aUVoK3d5WHk5NU15S1g0VmFaekxWUGl0NFR5Q1o4YUJt?=
 =?utf-8?B?YUdJd2hRNnRSa3FYMFVDbVZhTVM3ajZvV1lzNTlxckFHdXBQK0pLdm5FeFlP?=
 =?utf-8?B?akFlVHlZOWFmeVVmZ3BKak1UQXk0QzFQQnlpUkx2SGpLM1VoQlVjMWVwY2Jj?=
 =?utf-8?B?Z3JvSUJVc3hoRXE3K2h3L0kxYURUOXNCbWNqT3JNYkd2TXgzd2tTVExqTklO?=
 =?utf-8?B?d2JWRWNSa2t5ZTZsdjVrcWdlL3VMd0ZTTWNka0N1d0JoczFpK1R0WTVROUlX?=
 =?utf-8?B?dFBqNVVrVWhLQW0vR0EwUHZKZ0pzMUlkVUZJMkkySFdONWFCeEdXdVdBOUJw?=
 =?utf-8?B?WEV0Rm8vK1MrQlJGeUY1ZWZqVk9NQXVvQ2djeWJodThHZTd2SzlLdDh4Y2U3?=
 =?utf-8?B?VlN6K0ZYVGhTcmJSNE1oRTl4REoxOFRlMCsrb2Z3MUd3UEIvc1llVk1zTUQ1?=
 =?utf-8?B?VWxLMFNlWWE2NXdwOG5BZUkvVjVQNnl0cGJvOE5pZ1lQbHAxNkpTbFlSVUlS?=
 =?utf-8?B?ZUVDTldaYmF2MklMc0JDcWVqaXZpWjVvZndLZnVyNmxHOGFpSVkvWmg4dm9a?=
 =?utf-8?B?bGRnSG1JVFUxb0NXMXVyZmh2OE0vM1dEYUMvczFJOTd0WEhNMjRLMVRhcEtU?=
 =?utf-8?B?Yys5UXZxeVN3Nk1hWFl2L3duemlFUm4zbmZMdjVqYjB1M09lRU12NUI0WEV2?=
 =?utf-8?B?eUV4SUZ2c1d5N25wMDhxNkE5UjhuK1g5L3NURE1ZblQ3WlNwT3FFUlNqNVFs?=
 =?utf-8?B?MmNIaEFuQzNuZjR0U1hLclVVRmpCZWtjWU91TXY4UDRsaGFFQVkxZklLVE9W?=
 =?utf-8?B?ZG1YS0s0dDFjdnUzWWl6YktnQkVXMkJNVTYzSWsyZmVvdTFWVTR4TUhpdlZO?=
 =?utf-8?B?QXdaMFVFNkVnSTJEV2pCQk8yeVllam5hd1R3RFF5ZWtRbHVOdFJCdHFseW54?=
 =?utf-8?B?bXFwWUp5bVhDNThLd0E0VnNkcFJ4RDlsbG9OM3ZJbEJBeFI2YjJGMUhWaGVT?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <144EBB43FFE51543B3B52FF3427E644F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f08ef5f-9e85-4a2e-b3f5-08dd0b6370ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2024 02:06:28.1398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B0aDJJIyGmaZ9W5RkpfUIUxOsRkqq4hFIwy8pezuuS6vdhwfs/SOzD3UPBzzLVdfLLHvQqZr6V0jX7gfOn5q87Ymd9JnlCyEo2IuHSwqRKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4556
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTExLTIyIGF0IDE2OjA4IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjIvMjQgMTU6NTUsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gT24gRnJp
LCBOb3YgMjIsIDIwMjQsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+IEkgZG9uJ3Qga25vdyB0aGUg
ZnVsbCBjb250ZXh0LCBidXQgd29ya2luZyB3aXRoICJzdHJ1Y3QgcGFnZSIgaXMgYSBwYWluIHdo
ZW4gZXZlcnkNCj4gPiB1c2VyIGp1c3Qgd2FudHMgdGhlIHBoeXNpY2FsIGFkZHJlc3MuwqAgS1ZN
IFNWTSBoYWQgYSBmZXcgY2FzZXMgd2hlcmUgcG9pbnRlcnMgd2VyZQ0KPiA+IHRyYWNrZWQgYXMg
InN0cnVjdCBwYWdlIiwgYW5kIGl0IHdhcyBnZW5lcmFsbHkgdW5wbGVhc2FudCB0byByZWFkIGFu
ZCB3b3JrIHdpdGguDQo+IA0KPiBJJ20gbm90IHN1cGVyIGNvbnZpbmNlZC4gcGFnZV90b19waHlz
KGZvbykgaXMgYWxsIGl0IHRha2VzDQo+IA0KPiA+IEkgYWxzbyBkb24ndCBsaWtlIGNvbmZsYXRp
bmcgdGhlIGtlcm5lbCdzICJzdHJ1Y3QgcGFnZSIgd2l0aCB0aGUgYXJjaGl0ZWN0dXJlJ3MNCj4g
PiBkZWZpbml0aW9uIG9mIGEgNEtpQiBwYWdlLg0KPiANCj4gVGhhdCdzIGZhaXIsIGFsdGhvdWdo
IGl0J3MgcGVydmFzaXZlbHkgY29uZmxhdGVkIGFjcm9zcyBvdXIgZW50aXJlDQo+IGNvZGViYXNl
LiBCdXQgJ3N0cnVjdCBwYWdlJyBpcyBzdWJzdGFudGlhbGx5IGJldHRlciB0aGFuIGEgaHBhX3Qs
DQo+IHBoeXNfYWRkcl90IG9yIHU2NCB0aGF0IGNhbiBzdG9yZSBhIGZ1bGwgNjQtYml0cyBvZiBh
ZGRyZXNzLiBUaG9zZQ0KPiBjb25mbGF0ZSBhIHBoeXNpY2FsIGFkZHJlc3Mgd2l0aCBhIHBoeXNp
Y2FsIHBhZ2UsIHdoaWNoIGlzICpGQVIqIHdvcnNlLg0KDQpJbiB0aGUgY2FzZSBvZiB0ZGhfbWVt
X3BhZ2VfYXVnKCksIGV0YyB0aGUgY2FsbGVyIG9ubHkgaGFzIGEga3ZtX3Bmbl90IHBhc3NlZA0K
ZnJvbSBhIFREUCBNTVUgY2FsbGJhY2ssIGZvciB0aGUgcGFnZSB0byBiZSBtYXBwZWQgaW4gdGhl
IGd1ZXN0IFRELiBJdCBpcw0KcHJvYmFibHkgbm90IG5pY2UgdG8gYXNzdW1lIHRoYXQgdGhpcyBr
dm1fcGZuX3Qgd2lsbCBoYXZlIGEgc3RydWN0IHBhZ2UuIFNvIHdlDQpzaG91bGRuJ3QgYWx3YXlz
IHVzZSBzdHJ1Y3QgcGFnZXMgZm9yIHRoZSBTRUFNQ0FMTCB3cmFwcGVycyBpbiBhbnkgY2FzZS4N
Cg0KV2hhdCBpZiB3ZSBqdXN0IG1vdmUgdGhlc2UgbWVtYmVycyBmcm9tIGhwYV90IHRvIHBmbl90
PyBJdCBrZWVwcyB1cyBvZmYgc3RydWN0DQpwYWdlLCBidXQgYWRkcmVzc2VzIHNvbWUgb2YgRGF2
ZSdzIGNvbmNlcm5zIGFib3V0IGhwYV90IGxvb2tpbmcgbGlrZSBhIHNwZWNpZmljDQphZGRyZXNz
Lg0KDQo+IA0KPiA+ID4gWW91IGtub3cgdGhhdCAndGRyJyBpcyBub3QganVzdCBzb21lIHJhbmRv
bSBwaHlzaWNhbCBhZGRyZXNzLsKgIEl0J3MgYQ0KPiA+ID4gd2hvbGUgcGh5c2ljYWwgcGFnZS7C
oCBJdCdzIHBhZ2UtYWxpZ25lZC7CoCBJdCB3YXMgYWxsb2NhdGVkLCBmcm9tIHRoZQ0KPiA+ID4g
YWxsb2NhdG9yLsKgIEl0IGRvZXNuJ3QgcG9pbnQgdG8gc3BlY2lhbCBtZW1vcnkuDQo+ID4gDQo+
ID4gT2gsIGJ1dCBpdCBkb2VzIHBvaW50IHRvIHNwZWNpYWwgbWVtb3J5LsKgIElmIGl0ICpkaWRu
J3QqIHBvaW50IGF0IHNwZWNpYWwgbWVtb3J5DQo+ID4gdGhhdCBpcyBjb21wbGV0ZWx5IG9wYXF1
ZSBhbmQgdW50b3VjaGFibGUsIHRoZW4gS1ZNIGNvdWxkIHVzZSBhIHN0cnVjdCBvdmVybGF5LA0K
PiA+IHdoaWNoIHdvdWxkIGdpdmUgY29udGV4dHVhbCBpbmZvcm1hdGlvbiBhbmQgc29tZSBhbW91
bnQgb2YgdHlwZSBzYWZldHkuwqAgRS5nLg0KPiA+IGFuIGVxdWl2YWxlbnQgd2l0aG91dCBURFgg
aXMgInN0cnVjdCB2bWNzICoiLg0KPiA+IA0KPiA+IFJhdGhlciB0aGFuICJzdHJ1Y3QgcGFnZSIs
IHdoYXQgaWYgd2UgYWRkIGFuIGFkZHJlc3Nfc3BhY2UgKGluIHRoZSBTcGFyc2Ugc2Vuc2UpLA0K
PiA+IGFuZCBhIHR5cGVkZWYgZm9yIGEgVERYIHBhZ2VzP8KgIE1heWJlIF9fZmlybXdhcmU/wqAg
RS5nLg0KPiA+IA0KPiA+IMKgwqAgIyBkZWZpbmUgX19maXJtd2FyZQlfX2F0dHJpYnV0ZV9fKChu
b2RlcmVmLCBhZGRyZXNzX3NwYWNlKF9fZmlybXdhcmUpKSkNCj4gPiANCj4gPiDCoMKgIHR5cGVk
ZWYgdTY0IF9fZmlybXdhcmUgKnRkeF9wYWdlX3Q7DQo+ID4gDQo+ID4gVGhhdCBkb2Vzbid0IGdp
dmUgYXMgbXVjaCBjb21waWxlLXRpbWUgc2FmZXR5LCBidXQgaW4gc29tZSB3YXlzIGl0IHByb3Zp
ZGVzIG1vcmUNCj4gPiB0eXBlIHNhZmV0eSBzaW5jZSBLVk0gKG9yIHdoYXRldmVyIGVsc2UgY2Fy
ZXMpIHdvdWxkIG5lZWQgdG8gbWFrZSBhbiBleHBsaWNpdCBhbmQNCj4gPiB1Z2x5IGNhc3QgdG8g
bWlzdXNlIHRoZSBwb2ludGVyLg0KPiANCj4gSXQncyBiZXR0ZXIgdGhhbiBub3RoaW5nLiBCdXQg
SSBzdGlsbCB2YXN0bHkgcHJlZmVyIHRvIGhhdmUgYSB0eXBlIHRoYXQNCj4gdGVsbHMgeW91IHRo
YXQgc29tZXRoaW5nIGlzIHBoeXNpY2FsbHktYWxsb2NhdGVkIG91dCBvZiB0aGUgYnVkZHksIFJB
TSwNCj4gYW5kIHBhZ2UtYWxpZ25lZC4NCj4gDQo+IEknZCBiZSBiZXR0ZXIgdG8gaGF2ZToNCj4g
DQo+IHN0cnVjdCB0ZHhfcGFnZSB7DQo+IAl1NjQgcGFnZV9waHlzX2FkZHI7DQo+IH07DQo+IA0K
PiB0aGFuIGRlcGVuZCBvbiBzcGFyc2UsIElNTkhPLg0KPiANCj4gRG8geW91IHJ1biBzcGFyc2Ug
ZXZlcnkgdGltZSB5b3UgY29tcGlsZSB0aGUga2VybmVsLCBidHc/IDspDQoNCkhtbSwgSSdtIHRy
eWluZyB0byB0aGluayBvZiBzcGVjaWZpYyBzY2VuYXJpb3MgdGhhdCAidGR4IHBhZ2UiIHR5cGVz
IGNvdWxkIG1ha2UNCmJpZyBzYWZldHkgZGlmZmVyZW5jZSBvbi4NCg0KU2VhbiwgZG8geW91IGhh
cHBlbiB0byByZWNhbGwgYW55IHNwZWNpZmljIGJ1Z3Mgb24gdGhlIFNFViBzaWRlIHRoYXQgdGhp
cyB3b3VsZA0KaGF2ZSBoZWxwZWQgd2l0aD8NCg0KSSBoZWFyIHRoZSBpbnR1aXRpb24sIGJ1dCB3
aXRob3V0IHNwZWNpZmljIHByb2JsZW1zLCBpdCBkb2Vzbid0IHNlZW0gd29ydGggZXh0cmENCmNv
ZGUgdG8gbWUuIE5vdCBhIHN0cm9uZyBvYmplY3Rpb24gdGhvdWdoLg0KDQo=

