Return-Path: <kvm+bounces-26169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 462829725C1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B46DEB23660
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88ED718DF74;
	Mon,  9 Sep 2024 23:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YzyoCJaW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5078180A6A;
	Mon,  9 Sep 2024 23:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924643; cv=fail; b=gkPBCPT0gRKumPEBfQonEUqbiI+0+paH/OaImwC8lSin85vTnX274H6vi9Mp8/6Vtt/AvTCLPW5q5DkLVlvQBNMwr/jjUqZ4wQ6DV7OAB38BurB4S5mXSOcNdZBIfk60VfFh4M9I+ZXan5tIUeBqYTsBh4LQibALEheZhFQen3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924643; c=relaxed/simple;
	bh=8mh0QBThIUsH6hab179XrH4GB5ZxL7rely5FS13INEw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b87kIQ2YPtwDbaOLMq+j3yMM+3ugNH49AmDmioWFqPicplcUZXfvxmyUTtJWANSRsbS4FAxWvAPdoCpjBh2Ate9PFULjBUJaI2FvbctvPHvxivLP3jAnncRBdNXzA5t+6evKM7UETyUbX+D31pVDL/nPk26kyRjL+Kk8t4Vv2Po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YzyoCJaW; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725924642; x=1757460642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8mh0QBThIUsH6hab179XrH4GB5ZxL7rely5FS13INEw=;
  b=YzyoCJaW8/0WlBv0J58wuKorXjokIRUZSQAUAm1mu6ccdaru8UtKoPy+
   JORhqCbcPXq9WTORpIwAHiMDvUXQeknn27jqv0gfrQYhd6+yKT9UrQDTs
   3hhsoV/nF09uF8GRkKZs3JTvvKy7sELikJ9hTl3oNxNf5MlvAEcwBm8xE
   /hhtno2ojsM3AYO1a3463JguhgHTBrtLunAk8EspzapF50cFxRz9jo9j7
   V63WXAe1oc0KtPZ3TiiuuUtBY488BRJxBKnkS6aloJtpk9JEK8jqY3TZs
   O3oOYkuVAp7fUZ4ibdIp0MiMy+b9yiRLwbUJZe4blQKA+J6Nix2R6fYO1
   g==;
X-CSE-ConnectionGUID: 2pHOygKuQaWs/As2dXPM7A==
X-CSE-MsgGUID: HDMyXdtqRuC4E0W8Ec8MSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24524522"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24524522"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 16:30:41 -0700
X-CSE-ConnectionGUID: DObiUS6gRtSoFFZbaGpYRQ==
X-CSE-MsgGUID: 6txFb/HWQ+CQR/chf8EdqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="71223518"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 16:30:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 16:30:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 16:30:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 16:30:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 16:30:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OY+HDwysFGZyg7XohurISuP9f7k+0r72+G6vef/Vjrf4aR7QPocf34o8ZCIKw4+rOS36XYl36uGmOR/pH6V4R26cxgRmOT7Nm9hpbBQgFxUaIFXAQz5WqHbRndt7+saVKFwRoUzxjXvsm/GMVzffmlL3c6ZLHzGXqK1wZuAyrkP3ctcaFapZECu8MPjiKSKlNIMsHzSwqGGQrg/Ljv3ZfQZpU5+o6Xp6pKl8hzqZRr3UzywGCiyGecRzPGl6TidHP2aX+T+osQAlzZU1rtQnOQ8uyJbeCE+lg8NO8nyUrFOY6bGPQ3Mfbf5TlsleOzPdQo95FuR6/Xuizc1/fhrK8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mh0QBThIUsH6hab179XrH4GB5ZxL7rely5FS13INEw=;
 b=W+qlEjU1q2wYEdYlMIJvqG94orHue1T8+8Gy/sB6iaXifC0HktjZmJkqYMON3EfbxdYCx4WDCHM9sDilkbUM8/8Ykv70WQBXt+iY8NvEi3CwyAh7aNP161qfjQdTiej3J5I2uKG2IcgJ4iQ0n5ysRtlBkok2SbNjXNNajxE1xX89QKF/DgBSnhTmdm2Of6VJSiyUpliy9hYQchZ3GqhxK1p4Z3BJpIqBudHkJyCFueCDLRIMv2m5hRe7IJONJUwrAFEoHihQPG4NFpxAcXFYADTC9MaAYRET0M5Rzt5fS1lc/7ajf3mO1Yyp49afMKdjELUMqKIhptejWtR6GGF6ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6725.namprd11.prod.outlook.com (2603:10b6:806:267::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Mon, 9 Sep
 2024 23:30:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 23:30:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] KVM: TDX: Handle vCPU dissociation
Thread-Topic: [PATCH 21/21] KVM: TDX: Handle vCPU dissociation
Thread-Index: AQHa/ne7SX1xh76jUUONLpUuqlnIa7JPoHaAgACDJQA=
Date: Mon, 9 Sep 2024 23:30:37 +0000
Message-ID: <18661b9ae2e35c53ac0f9e7c24f509fae887cfec.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-22-rick.p.edgecombe@intel.com>
	 <4449bc94-7c5e-4095-8e91-7cd0544bb831@redhat.com>
In-Reply-To: <4449bc94-7c5e-4095-8e91-7cd0544bb831@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6725:EE_
x-ms-office365-filtering-correlation-id: 6b024f92-034b-43b6-4267-08dcd12768dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UElveXVid2hydTFxRVNGazgxVlZxMnB1aVVoNTI4WXp0MEIvQ1FPcGNHWkZL?=
 =?utf-8?B?b1FVWE4vRExZVkNoL25RY1pMaXpWdXdwd2dUQ2NvdDBNMFA0cXc0Z0VFZkhJ?=
 =?utf-8?B?eGprMTg4aHFMeE83aGhWS2xCR0ZZQlE5Nk5jZldNVTUzMDJEYkdhWWFFS1BK?=
 =?utf-8?B?UzI1bzFqbmM0azN4Z1hCMy9yUmdWMnhOMzF5cUZnTzQwc25YNDQ4enlUU2Rz?=
 =?utf-8?B?bGw2MFJ2MU1ZWXN1ZFJxVGNPZkRzOVFlckp1b25BdFV6NHFyMTNJemU0Snpw?=
 =?utf-8?B?S1IvSlpHUmNQTVNseENlWlNrV2k3MkM4SjRMclg5R0dVMTJwTFhvSHBMUE0y?=
 =?utf-8?B?amdUZ3ZING9HWWF4bnphSTJ6aWJubDFob2czVjBGR3M0K0Y1RXR5TW5xTVlz?=
 =?utf-8?B?eEhTNzRWL2FUcFVrVWtiYytsaHhUZ0hRMDRxMW96RW1YR2N3V3FabWVTdHU5?=
 =?utf-8?B?dnRxS1JwTWVGcDZvZmdkZlJaT1hLWmVxd2xPMHdVMERpditieEE1b3pZUGta?=
 =?utf-8?B?VWJlM3Jnb0l6Q3h6WjlYM3NROE5kOUZteEhQNWdOT0c0LytoMW4va2lCSmY1?=
 =?utf-8?B?V2c3ZEw5N1lpb3RpMmdGR1RaYmM4c3pFNHBKUTd6RkhnRmtSQVJCaENIbTZF?=
 =?utf-8?B?a3lGb0M1QzlZeWhtZ3dpT0svTFNMaVZFWEVKK01scHBVMEJmZVhiemo2THBp?=
 =?utf-8?B?K0FtUHdxTURqWDE1cnJWUWI2eHdMVEEyRGtsZ1Q0S3pzanpSalQ0OUxuekRw?=
 =?utf-8?B?Y21CSzBITnVYSXkxSjAyUGh5SEZxOTR3YUFZMjFFZXNvTzdiM2t5SDZ5Sk9x?=
 =?utf-8?B?dDFiZk1mUzJKdFZ6eXN4OHJrbjlaMjdYMzFwazFDNUFjeUhBaFczMEFTSGNV?=
 =?utf-8?B?ckF3STQxR0NSOHNWSzVEdXYyMmJtbVpha2pMcWdpbVhPd3dDUk1YdmNmUUhG?=
 =?utf-8?B?aHRoNktqN01XUzcvbXJKZ3NnYmIvRzN2a25wbEpZSFJabFc2cUNQNWh4WW5R?=
 =?utf-8?B?MG45S3EzNklGRGpSUjJ5UkFmb1Y2V3VxUi9OZW80MStkeEt0MkJOTWtVTDMx?=
 =?utf-8?B?MEJLSGdsRDZ0d1NUREx5Q25XZktZRzFHZFkwTGN3VEV6bkw1dkxsam5YSWNi?=
 =?utf-8?B?NFFjMy9zdzFYdUJ3L0NRWXpnN0hrYjJFcnhVYllXQ0lhRXMyeUJjZWJlVUdx?=
 =?utf-8?B?dndlckhsTld1d2lOZ2ZtVExsNTAwc3R4UmZWMTVzT0tjbjNhK09kbk5vTVBs?=
 =?utf-8?B?bUF2S3Z5NWIyNmVxMHhRWlhiTFJyY2hxYnRaTng0TU1oNFhIL2xxVHY0TUtk?=
 =?utf-8?B?VzJXRVNxZmxOMGpyYkhEcVo4ODY5WS9Kbm9OejVmTXBhcXBSTlhDY0U4ZVQz?=
 =?utf-8?B?NGx4MHVFZDZsTGhNMXJTV0RSbDZHbkViSVVxYml0cGlXYjBzVzE5UVpQZkhm?=
 =?utf-8?B?Nm9kZ2o1aSsyR0gxblNLWDE2NVYxckdIa1RER3pLdWQ0cDJqa3VPc0hJdUZX?=
 =?utf-8?B?eDBjZFVlMktOeWtYRld2R3FPTHJWYnNsK01uNWlweXZ1Y1VlUWVzN1h2bHh1?=
 =?utf-8?B?aGFZb0E5M05QdHNwSi80aU1namtoMlNPSG1GNEZGckM1OE13K3BleDBqRkVM?=
 =?utf-8?B?SUlTZloxMWtBNDRLQndsM0cyUkFldkpMRFNpV0lNOWV3UmF6SUF5OUExTWVj?=
 =?utf-8?B?RDB0anB1dlkvM0tZTXU4L20wZDV2NXVqK2thZjVEY2dVZHMrMUxEOEIyMjRu?=
 =?utf-8?B?VWFOU2lXaDJnSTl5QWtNWU00Uzc3UGgyd09Ud3V2WFc2ZU9yWWtDdUdBMVJG?=
 =?utf-8?B?RjJyUFFpMlZNQnBGSlZoamJ0N2dnSXRKWnNDZms4UGpLcEZOdU14UmcwV01J?=
 =?utf-8?B?NUx2M0xremowbEtPbEkwditFTnM4VWFiYkdLOXU0SkliVVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFYyZXZMU25tL2sycmZnam5XdDQ5eno4MUo4MkZYZ2RLZ05GdzYrWWJyQ3dy?=
 =?utf-8?B?NWoycUdTcXBhWU1OZXNMQVJIOEF2cXFMcjFZdGxRWUNHdW8xSDhwRjZOZGV1?=
 =?utf-8?B?TEJFT09ONks5akswZHdWNnhoR3NYSXZnM0RmODZDMnhSTlRLTjVwVE1JVmZB?=
 =?utf-8?B?QlNITzFIVFFld3hDOVVZM2g3ODlmRG1GRGhvQW1uSEVDSkRGNS9waXRpWDIv?=
 =?utf-8?B?RE1vbXNsZ2NWTGhXTUlCR1FPcHYyb2YxOXg1NXQxTE1FWWRxY2kvWkE4MmxL?=
 =?utf-8?B?Q0pOZzNJTFBsM1JCNFRadnE2NmovR3dvRzdKcUdKeGJ1OEpQeml5MERiSnFW?=
 =?utf-8?B?SHdod3FZVjQvTDBXRHY0MG5RZXVmaXd5SG1UREVPVjU3WXZOUG5ZUGpGd3Fw?=
 =?utf-8?B?T3J5VUs5eC94aWxnZWVzOEhtWjNjOHRTeENwUVNqREEzL2FHN1JSQ1diNHdh?=
 =?utf-8?B?bHJNRHZRclFRemh0VU1SSU44Tk9tREwwUG9HNkFvWDNwOFdWdEJhTlpjSVF0?=
 =?utf-8?B?WW94WlRMamFhc20wcHRPaG50THUvQWxtdHMyWHd2VUhEOG9FQ2tTOTBzcWRm?=
 =?utf-8?B?M2tVb0F5ODJvRlM3Nlhob29QMHVtQkZrTEVnVlVkN0Jmd0lxUnV3TFJNdEN6?=
 =?utf-8?B?OWxHendxSjAzNGNLNVdCV1YyU0daS3VzQUNBUXE0cG13cGdrS0hPR3R0bUdQ?=
 =?utf-8?B?VDhqaGtIRGgxRktRY2FMQ3h1NFBpL2wxSmdFRlRYOU9ZeG01b1hLYjhmZXBJ?=
 =?utf-8?B?Nk05Y3UrbDk2eTBxM1piUWJiVHdGSUZpZ1dLOWdoOFNlWGZlTEhpY1Z1OHBK?=
 =?utf-8?B?eDdmc01aL0hUUjF5VmJoOFJLaWZoVnlNb0lLczlMeXdzdTEzZkZTTmdFbUhF?=
 =?utf-8?B?VUdOTCs5T2p5WHljd0hVRmNMKzF6SEJFWXR3N0RxMjIvSDJYOG5jZFl2VlFq?=
 =?utf-8?B?eGdLd1hZaCtwQUpsd3F0aFB2ZytwbjMzNW1ic1NSVEhZcHFEZlRhditONjRn?=
 =?utf-8?B?WHMxMGwxLytYK3RMVkVDaG5neU02NStTUDlWSWRvckEvWUFQM0JGaXcwcHI0?=
 =?utf-8?B?dHVUSnhHTzlzaWJMMzBEWFdBSFVuRHpmdzBwVzZhc1lGUzd1ZVJWOVlodUtp?=
 =?utf-8?B?MTYyUHZybnRkYzFvWElnYlJkcHM0andLblRzcFhtRTB4NTVvd0haTDl1dkNt?=
 =?utf-8?B?MHlacHpaRkM2a3lMaXQxY0g0b2xpOGFPNURvMytvQk9jOXhPelZSZlR1VGtU?=
 =?utf-8?B?WEp5cWltUEp3bEo0MmlIcVc4eElwWjNiTGVZNXVYSXBzYVVyZDhUZXpSWlFE?=
 =?utf-8?B?ZXI2c09XNnZCUGRFVU1kWUlHdnBkWm1aUWpyYjhrMzdoTzFNNDhwdTBKMkpn?=
 =?utf-8?B?RVhHcWNoSDAwa3E1d1JtamE2UzhrMnF0eERWK3F1bi9sak5SVDZId1dlRW5P?=
 =?utf-8?B?REpSOU50dGlNSkdpZitBdW12WWpsRmVKZFprVTA2aVRUNDBkbHBFZU9VbUJY?=
 =?utf-8?B?ZjV6dCtKbGo3TUJNL2x4TXRuLyt6bFdTL0xIamQ2TTlpVGxwcklsaGJyUTN4?=
 =?utf-8?B?SFk5RDFuNHBuc3M2MEtOWEVPZ3piQkJKV09mbkMxZ3pqV3JOQTA2b2NBMTRR?=
 =?utf-8?B?OXJ2b2w5QVRGTmNOWG1FUEMxT3lxOE5acEZUZCtrc3pUWFFhN25mQ3J5aS9h?=
 =?utf-8?B?V3MzWFVaaWlkSEJXQWFXMFRjL3dRa3R3Y0FTMlBJdTZyZS9yY0FxNnpGQ2x2?=
 =?utf-8?B?Q0o4OFFFQnlyUFZoTHgvcW9FUWV2SGhtZjAzK0JYRzFiUW42WW5QMDdGSld3?=
 =?utf-8?B?R05UOUo3dEt6RzFUTDA1K3ZPc1M2c0xGck1YbXZ1a0J0VGpKNmdLMG5zQ3RH?=
 =?utf-8?B?V200cEZPanMxTmgrNWEydmtRZnNhMXRzL1UwVFFtZ1dsZCtBMHVnNlJLSVBt?=
 =?utf-8?B?UjhDRXovOUdCTHZscXdJdlBGcXdQaFU3MmY2Y29rUHAwVXBwQUk1c2ZVaXB4?=
 =?utf-8?B?NVAvamVFWU9ETGNocG5ESG10N1RHYmNQZDViVEpWUWlLZlVLa28wK0Vka01o?=
 =?utf-8?B?Y1d1Z090aWI2d2FONDdKVzE2YTVZYmlQQU9IQkZYa3liMEdlUG5SMnQrT3Iz?=
 =?utf-8?B?Q2EzRzlHVWtrS1RZN3dVSllaS3FMQXFxS2xYMUV4dFc5b1J6clJoMEZxMXhF?=
 =?utf-8?B?c0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <053B84FE102CCD45A541C27EDB33D66F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b024f92-034b-43b6-4267-08dcd12768dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 23:30:37.2886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZV098/RxVY405uJIdHyd9zTZldaEIoH8hjzN98ITeezTW2S8+l67WtkVbwwEbpPMsb0w6m6x8t6ektnHiHkamEOpPNDnjCIawJXspbqBAgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6725
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE3OjQxICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+ID4gQ28tZGV2ZWxvcGVkLWJ5OiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNv
bT4NCj4gDQo+IEkgdGhpbmsgdGhpcyBkaWRuJ3QgYXBwbHkgY29ycmVjdGx5IHRvIGt2bS1jb2Nv
LXF1ZXVlLCBidXQgSSdsbCB3YWl0IGZvciANCj4gZnVydGhlciBpbnN0cnVjdGlvbnMgb24gbmV4
dCBwb3N0aW5ncy4NCg0KVGhlcmUgd2FzIHNvbWUgZmVlZGJhY2sgaW50ZWdyYXRlZCBpbnRvIHRo
ZSBwcmVjZWRpbmcgVk0vdkNQVSBjcmVhdGlvbiBwYXRjaGVzDQpiZWZvcmUgdGhpcyB3YXMgZ2Vu
ZXJhdGVkLiBTbyB0aGF0IG1pZ2h0IGhhdmUgYmVlbiBpdC4NCg0KVGhhbmtzIGZvciB0aGUgcmV2
aWV3Lg0K

