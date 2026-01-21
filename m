Return-Path: <kvm+bounces-68774-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kOPLLgg2cWnffQAAu9opvQ
	(envelope-from <kvm+bounces-68774-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:24:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 944F45D22D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EDC9A7ED647
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC4A3559F8;
	Wed, 21 Jan 2026 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PTS+nqHn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056493E9F6B;
	Wed, 21 Jan 2026 19:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025594; cv=fail; b=qUeU0mEsOhQNwWxcJcnhdrTbrodH8yXRjXcRGOq2lWoX15Bc0VdK/l/jBEoLr/b1wealZT2igilRS9TArPyuXoZqPXR7G9ucgqjDoRsfhIzu9JxGmkcm/G5xgIh+KTy2MXAStIkv6g7jFddntiw0kltprphDqOtmtq38JqE1AjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025594; c=relaxed/simple;
	bh=a29byeOkfbjv/GonMfPxTRw5UHzXp7LOWr48YkiVd4g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G7IYEftw3k/DWQtVDDnGwHarNcUa0tbAbhd41QCCL7ugd5na/qs7JPB20c96eRT12bwAZXa7QwEfoBXUuy9KGl8mB1sVuKAC8EpUZi02nuYmNx0bus6j4l48h4Vv2MNN5fzNy3EQE9iO055kwFGH3ms3/MEclegW4kZLTEwhMTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PTS+nqHn; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769025591; x=1800561591;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a29byeOkfbjv/GonMfPxTRw5UHzXp7LOWr48YkiVd4g=;
  b=PTS+nqHnuv0m9cYkGvf/BdvqdjK/i4gO0GHb2t/fDmuCstvjQFHYGHIP
   dEdYX2NnieaAUgj4a+4NS/pfTtUMg0sh20Bvak2o59ZJUL69amTDFQt2A
   ouRIBAY3+pHLACc+f+vs0x61SXpu1qHNoWhjsOqUL276j+o657cAVN6FD
   9Nb4nphBS0fnSUaH+hyqJu65b/pqboJzt6/9jClcwgpzbOqLSrZQNhRmM
   yH596K/IxmnIo279T81TMYWUBhQqWuy4i8Z1cZ+FcjmoIyzxeTd4b6OYW
   e/XAK+xq0R4Xzv/ska1tYkffTOqQ02iHNdj6o9dCvogI0T51a6DusciB4
   A==;
X-CSE-ConnectionGUID: CZ2vsBkJSn+jjwhy3LKLqA==
X-CSE-MsgGUID: Fo6DF/0MSkefDPnX+8P+fA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="92926520"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="92926520"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 11:59:47 -0800
X-CSE-ConnectionGUID: TMAXjJCvTBuefPsvPLpoyg==
X-CSE-MsgGUID: eL2plV3CTbmAc8vxbEeWJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="244119566"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 11:59:47 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 11:59:46 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 11:59:46 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.5) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 11:59:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wUzEyrAFamFB96gKOSYd7f9BL6TT84PZR4r8QHGpK/O20c147tfl14kGQpgua2Vvt4+7ANvUyMPYMnEehp9Iv/oy7y3iRlyDHcK//S4Erw3jt3QNi2LOET3tK40luQjLgYMXE5ysOs7ldXPLv45/zDAWoKEfqv/NroHSDxE4HTbhm29iP/8fy5PDXI9DsrMBbkLcihwQEKLPiIHNveFEJDptKV4wxAtOwVcHupsAv9NMNl29+XRvkXs5tLLdhRvNknCCXeEHGOTWFRDdMYm9+K9AWnebWxDsaO/d8DoZedPFnFddaOIjM99HuML0cA6J61M+nf3yASndvXBJNugbbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a29byeOkfbjv/GonMfPxTRw5UHzXp7LOWr48YkiVd4g=;
 b=EPUdMF1VAMfxEjmVG6rD0cbumBI7qQhs1AiWYaJNahmt0jjlxlbtyj9256h62tus7NcyRz2qRbClvkEp16qwwsZhE0AEpiFq1IzOSu69KzBhfZXbdvyq+2JjFEZraxR3qkuZnMz5rtkonS428XSVBhu/uttTvi8xwvriJpNO3nt3DPjGi9cMhNENnSZyFrdAldYDWN/jO2bu2X80TsBZzkuu/2bngIUb0nWjp2SkuKB8/wJbaIAHvG2JB2nFlxYTnpdb9rDgODkqYTD4WDa5Y5bIfjFAnne8timcyBMx27brtsXB8grc8HxHzju60KzAGBlvm2SfKVMnAp7KpAVnpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7943.namprd11.prod.outlook.com (2603:10b6:208:3fc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 19:59:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 19:59:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Bae, Chang Seok"
	<chang.seok.bae@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Fang, Peter" <peter.fang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 14/16] KVM: x86: Expose APX foundational feature bit to
 guests
Thread-Topic: [PATCH v2 14/16] KVM: x86: Expose APX foundational feature bit
 to guests
Thread-Index: AQHciQhPajoUy38nHUuePUWMi6isZrVbXSAAgAAtuYCAAYQNAA==
Date: Wed, 21 Jan 2026 19:59:43 +0000
Message-ID: <3b75db7610b50b8f4277d75ad7a736213d9eb5c5.camel@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
	 <20260112235408.168200-15-chang.seok.bae@intel.com>
	 <2dd73d71-ae88-4b17-8229-2cebecca7782@intel.com>
	 <ecde45c32b56b4954d2220b8686effd6622866cb.camel@intel.com>
	 <48bc5534-05f0-4d5f-ae21-4ee7f7a15cad@intel.com>
In-Reply-To: <48bc5534-05f0-4d5f-ae21-4ee7f7a15cad@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7943:EE_
x-ms-office365-filtering-correlation-id: 04ff4152-0793-44ee-c356-08de59279f22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?b0xlZ1N5anQ0Y2FUTnJaSG5zQXpRbEZjODEvTkFablJTSzVDOVE4ZU1adzB1?=
 =?utf-8?B?VUFlNGhzUnU4eVNjTFdsb2s0WEtFY2ZHVlBYa2tjeW8xNEhZV2xoRWNVWlRQ?=
 =?utf-8?B?a3dBVytYNXNjRjJKeENYMmF3dXd4TncxR3JMZldaN25yQ2RTRnpoYzZZU2lI?=
 =?utf-8?B?T0VQQWRpTmlKckNqdk9sazNpYUtVeHhvVlYvUitZekI5ODdoN3ZURGNwQktj?=
 =?utf-8?B?N3kzL2JDU0lEODhya09ROEdjV3F0eWxCK25sTWJGRWFrM0hVQVZSaGhtT3pw?=
 =?utf-8?B?QXpxc0J0TWdqNEt5cy9Zb25QQkNYU1djakExaVE3T2NUa2JBU3ZUWXVEWkli?=
 =?utf-8?B?aG90aUFpVm84bENnd1BSc0laZkVmeEhnMHRWc3loK2t3bkRzMmZvVGVGWSsz?=
 =?utf-8?B?a3NjM3hmUkxhc3FIWHNXVVhDZUFJMEQ1a20vL0d4RXlRaTkwbzU1V09OLzBi?=
 =?utf-8?B?WmNvOFZvb2hEclFKZnRoVTFpeDRJYncxSFJVMEV0ZVpKMHl3UGV1WHFpRFF0?=
 =?utf-8?B?R0NpeUUrdThOejdxTGFmL3ROWWhhRUs2Y1R1NFdwTXl0MlppNHhOUkJpaDlr?=
 =?utf-8?B?Y3kyQVhhaG1KZiswN2NVVURKazJpS3dhaUwxWG1JZGxJbml6R3RQWFU1YnJ3?=
 =?utf-8?B?Z1JDdU5FMmVMbExwRCs5K1AzaEtVSTZxQjJqeTlrSWx6bEpLQWR1RWNGM3NR?=
 =?utf-8?B?Q3VROXZJWWM3dTNyWXM0NWIyNTUvZWR4Y2lMRU5neGlseTNaN0VScTJZcE5p?=
 =?utf-8?B?MUV4dHc0L25ycmIvWFRwcWYzeWRySmxyamVwdlQ0KzZldG40cnk5VkJwNWlG?=
 =?utf-8?B?dmdKUm9DYks0cFZjOFEvTnA3N3NmaU9wcGwrOTdIdnUvbTd4UVhacmtiL1pD?=
 =?utf-8?B?VVdUS3piSSt3ZTZXckR5REJmdGhscFowUWp1QnBFRGhxT1BzU1BrZmFUUDho?=
 =?utf-8?B?cEYwdmVOZnRKSzZDSDlncFdUMk9zV3A0WWloRUhMbWtMSlRpUmtwdVNQaURs?=
 =?utf-8?B?ckVyejl3eUl4aXh0eDM2RTZocTlmaWxtTzhyNk9mWTl6Z3h2azBHajNTQkd1?=
 =?utf-8?B?TVoybmRHQk50c0ZFYXRlRURESlhyQUNzdGM5Vnh3WU9CVGtBWU1PQzBKNlZ4?=
 =?utf-8?B?UnFGUjZCS2ErbVpETnIyYk44NGU1WFB5Zi9lVVJELzVNclkvamZGczQ5WkFX?=
 =?utf-8?B?cFBIUlFEQk5uNE00MXNTMVQzTGgybnhXdmdyaVZtcitpMWw2bjc1aGpqNzNK?=
 =?utf-8?B?cmpjRkZKbEdCbHBLMHpmRjR5U1BRcDZ0RGdtK1YyNlFwOHJVMVpnZW42Nko0?=
 =?utf-8?B?TkIvWHBEaG15dVZxMkxHT2tQaXA5WXM1aFNqb1htMys1L1VZVm0yS011VnNI?=
 =?utf-8?B?MkFOVnd5OUk2czBVangvaGFlaGtpaVdHU1dmeGh2ZlhTK3VMWEFOQkRDQW5O?=
 =?utf-8?B?U3VGcnVRM2tNZFQ2dXZ3TFdlbkxFMEJKUFNUNmVPRTNYOWVpVEk3RGpscGpa?=
 =?utf-8?B?eEEyQUhQbW9lMC9KQ1pLZG82alpMUWtRRFNCL3o4YUlGRmlsM1p2dFQ3K052?=
 =?utf-8?B?dkJCVG9nQlkvV2VPM3Zta1JCajZTS2x5VVBTM0d4cTZVeFBwSmdaTUU3Smpj?=
 =?utf-8?B?MWxpemNuTHhncTJNanpBNjRyWkFnbW1xdVYxSU1kay9qbnB3ZnZVc3UvaGNt?=
 =?utf-8?B?STdYa1hlM2VFcDVzZlk2VzNrUmRyTGY4YUl3Y0Yyb1JoRlFkZlhFNHRHYnpC?=
 =?utf-8?B?ZzQ2OE00Umt3SUR6NWdpb2dseXFOQ0pDeE1ZNGNwMkJLTzBqTWpOc0ZDRUkv?=
 =?utf-8?B?KzFyMS8yd2dGVTBuTkRjZmtjVHVjRm94bVA4SE1iRTZLdnFWQUFuNURpaEhL?=
 =?utf-8?B?dU14NUIrbW9jQmFDQ3JaZ3RRbVp3WEh3bHJJS3RoSk5nY0FhWVM5ZndETjh5?=
 =?utf-8?B?VTNlN29UeU8rb0l4S1Y3U1U4eWdScmNwa045eXFuRm1va05RK1lqNG9GZFFW?=
 =?utf-8?B?VHFXV2R2YksvUFFXblp4Ym9tZk1sQjdFV0IwUFBTaGRVd3I1RzlDUkY5ZUJQ?=
 =?utf-8?B?dmtMV2M5Y2ZjbENiZVBkOGR2MisydmhVVCtraWZZc2F4RlNwQWVSWHJsN2Fr?=
 =?utf-8?B?ZFZEb2Jmd0FjWWROVnF3OWY4OExzczh3UStOYlBUbUtra0VKZXdHMjF3WlNn?=
 =?utf-8?Q?FM98l+lISRIC+AiRMT/DSxA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZE1ZWUErZnFqSnRvazlHTHFyTDNsNWNRRjBjaTdkWXNObjg5bkhRZjRQdkUy?=
 =?utf-8?B?aWM3WGtzSGNCL2JiMVFWRnNrTVpndVZ0YXNVamY1dkphZXA0UGpRYis1WlVq?=
 =?utf-8?B?Ty9rcXhhckFLS1ozai83bURyeWF0TmhnRjd5b1Y4RldMM2t1K3RpMFZHdjg4?=
 =?utf-8?B?VXZlOFA3ZUdMWjM2NnlCdUQvb1FrSjdEa3ZqMUsxZXA4QVVFVGFKSERIeTFu?=
 =?utf-8?B?VEw1aDJKbHowTTk4MG0xS2l6MDdkZC9hMytRRWg3R1Frc3JjRGUvM2t0YzJu?=
 =?utf-8?B?eHhycnBMbVlzUE1PT1prVlFTbFhSNGViNEFadEZadHdyMVlPK1dVT3lZajFY?=
 =?utf-8?B?Z1BweVZtUklOQWloV3NOeVZKQll3YTJvanQweTRNZXViWkVxYWJ1eW04MXF4?=
 =?utf-8?B?V0dwckFYZHJyV1RQSlNKTXJ4SGJYOFVhZytpTjlIRmxKSmVyRjFOUWV0enlt?=
 =?utf-8?B?VzJQKzRINkp6ZXpoV3ZNbTgyMUlIUDdPclVzV0JFMU81cHJEMFNrRkJuY2hI?=
 =?utf-8?B?RXhTTE9RYjhoc1dnMElnekJja2RvK1AvR3dBeDRPWmdwTUJEL3ovMFFPOWRx?=
 =?utf-8?B?bHNuQWJORWlBYUoxbk9kWUI4QXFKRVcyV25oSXFhRzgzTzIvODBNUVkweDFw?=
 =?utf-8?B?MGZ0QmpXb1BlWmdRdmtJSHVsa3F2V1lEUlJ3QndLd0UwdXM5VmVhZXE3MmI3?=
 =?utf-8?B?bjJNS3libWhPYzM5ZHRJdWFpMnBDclRZV0VuMzZBUG5rVUNEY1M1emRwdy9x?=
 =?utf-8?B?OUpDQmtqZWNUTnlPQjBZbmxIOG5INWxoRkhUL2lINmI5cit3TmJJQWVkNTJq?=
 =?utf-8?B?em5RWXpQL3o1VFFFd2FEbVJ0aFNRSlFPZkRZalBOeFNjOSs4RGg2TWRHUU5U?=
 =?utf-8?B?TmVOWXVhUTk1Mm1tZnYzcndvbjNRbjVVbHhxbGZZUjdrR2lBUm8wajZrYlAz?=
 =?utf-8?B?bVpxMGhhVjJaOEZtSlpvWk5aRU02Q0Mwa1hJakxRREhQNVE2VEtEWWdpSUt6?=
 =?utf-8?B?aVBYeGN1T3dGQ2VWNjVXMXpxbFE4L2lhSExoNW1DVU9OTnpMTlRJS0hXcUJF?=
 =?utf-8?B?NDgyL2RpWDRTRWEvL3AzUG9rcVM1eFJjK2Vuam5sdnhDREJJV09UZ0szYVFT?=
 =?utf-8?B?eU43VUZ2d0ZtVndQb1JCUmh2SkxFVnd4M3BwT2pYVWIwUVBocWpJVUhMb3N4?=
 =?utf-8?B?OTBYS3FTblViUm92Q0Q2V0ZwcDVITERGeXZSUGwxS3BFOEUxcVd4UWovRUhF?=
 =?utf-8?B?Q3FnNy95REhwN3E5RTROa2VEYTM3SFZtZXpXUFBNT1VsakNkR0VVSCtZUFox?=
 =?utf-8?B?V3pPa2E3UzcvMGtlS1pEc3FpOHFuTThEOVl5cmRxYlRMc1RiWUxJZlRkQkF5?=
 =?utf-8?B?NTV5L2JqaUVwRjZmaXJjWmJISXBoRmRrRlhFRXlTVW5QQUZQQnk5OHNET2h6?=
 =?utf-8?B?dGVodlU3Vkt5Y3ovSjJ6Z3ZqN0NrY3YyUE0rRDZzVXNuSWxXa2lFOU43alNT?=
 =?utf-8?B?UnRNdVozaURnbkVnSjN2ekhhckNNYnJTMzh3WDV3UzExVlFhdTJSbkk0MnBX?=
 =?utf-8?B?T243bHpEbVJwczFFNHJLODRCaG9CV3N1YkFTMWVhUUtjSEZkU1JjRmllNTRo?=
 =?utf-8?B?SDgzNnRQaHk5RkRlVW1qY2JKYWZML25EV1hUcGx3UUsxTDRDa1piL2FxcEJS?=
 =?utf-8?B?VE1SLy9vbFdaQXpXLzh0UzBBczhETE5HY2NZaCtWbjRvK1VWRzR6TWVOQytS?=
 =?utf-8?B?R01Ed1JabUcvQ0JYUWd6SHpMSFIvQVFQRXJsVXBUbzJCQUlEcmhvazExa05C?=
 =?utf-8?B?TklIZ3FuUXY0c0F4eFVqU0E5Si80WWkyMjV1Z1dONGU1Z0w4Q2tKVmhCc0Jm?=
 =?utf-8?B?cFpBM3NCSlMvVW9EdEEyTWxETm0zRGlsSUZTcEJhVzdGQjBIL25EdUNEam1B?=
 =?utf-8?B?L2tQcHIrNDB6V2wzRGZlS2JzamY4ZTBCbytoMDZCeVlDRWFaNy8vMG1oTy8z?=
 =?utf-8?B?U2wyVFpWTHdKa3dsOFdWSTNlWlR4eVJiblVTdk1RZHIzaXF2LzhvSnhhWHdY?=
 =?utf-8?B?aXFYaW1vTmpHcG9aNVNhV2ptMTF0WWc3cy8yRlFlUE5ZRGN3L2F3RnBkUVNJ?=
 =?utf-8?B?SUh0a3JoS2F0WkZwOWxnaGRHR3BaYnZMZDFtRUNqNlFjdzdBVytJbjc2TTkv?=
 =?utf-8?B?MTgwSFRXTzFQYWFwWTlWUG5YVDVHUVFyWk9iaDNDSnV0TnluRGtzRkNTZitF?=
 =?utf-8?B?eW13bnFnNkVlNFFvQnA0ZkdycDZDeEV1UDNpNTg1Szl5SFg3cjRGcmJBZlpP?=
 =?utf-8?B?ait5bTFGZldEMEhhMEZ1WVhzZ3VlNFVZZy94NnpNd0pFVVl2TkNMQTNFZEJ4?=
 =?utf-8?Q?Ui41UUeyFtkZx8Pw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1AAAB4EA6889F941BB1F8ECD31D1672E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ff4152-0793-44ee-c356-08de59279f22
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 19:59:44.0479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Xjt5ctjBcbY85xhdLNW/piS1s4pKuqpscOGdk39FjE7PhZQcJwVQPZcgIVjF22k7yPybIHWR+N3WlqXPzc8jXwtD+eN4aS0O37XjK4NinM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7943
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [1.14 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68774-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 944F45D22D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

T24gVHVlLCAyMDI2LTAxLTIwIGF0IDEyOjUwIC0wODAwLCBDaGFuZyBTLiBCYWUgd3JvdGU6DQo+
ID4gQ2hhbmcsIGxldCdzIGNpcmNsZSBiYWNrIGludGVybmFsbHkgYW5kIGZpZ3VyZSBvdXQgd2hv
IG93bnMgd2hhdC4NCj4gDQo+IEknZCBjb21lIGJhY2sgaGVyZSB3aXRoIHBvc2l0aXZlIFREWCB0
ZXN0IHJlc3VsdHMgb25jZSBhdmFpbGFibGUuIEZvciANCj4gbm93LCBJIHdvdWxkIGxlYXZlIGFk
ZGl0aW9uYWwgZ3VhcmRpbmcgb3IgZ2V0aW5nIG91dHNpZGUgb2YgdGhpcyANCj4gZW5hYmxpbmcg
c2NvcGUuDQoNCkFmdGVyIHNvbWUgZGlzY3Vzc2lvbiwgSSB0aGluayB0aGlzIHdpbGwgYmUgYWRk
cmVzc2VkIHdpdGggZnV0dXJlIFREWCBtb2R1bGUNCm9wdC1pbiBjaGFuZ2VzLiBTbyB3ZSBjYW4g
c2tpcCB0aGUgVERYIHRlc3RpbmcgZm9yIHRoaXMgc2VyaWVzLiBUaGFua3MuDQo=

