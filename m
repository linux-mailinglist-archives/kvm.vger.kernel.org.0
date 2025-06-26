Return-Path: <kvm+bounces-50914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5467AEA97B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:20:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A3BF16591F
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F013C260570;
	Thu, 26 Jun 2025 22:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NRpOabUO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C72213E74;
	Thu, 26 Jun 2025 22:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750976396; cv=fail; b=XvoNrHMIH8xSr+HElZRzkEIfPperVtTAJuIHSVQVFyS5Dl4OAKkMkDmuZ1fC5J4sVfTil5uGJty5DbA0dcSaJw5gzzgDhHm2dOBhAh36TrS6Vdq+sVOtm2rMiJCsLCtnkgnZipQkc6W+GRGVc3qY37yJy3fdPv2fJRglrEGYuyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750976396; c=relaxed/simple;
	bh=FCslCXNDHzMMGLR0TOhIYCeJZ8U/OcYpMPr7FCe1/8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JpFXGE4H/4OhljqOCSF8/oavfJgNvFrfnta0iWD3UDutBrO3/aCiJGWMm5phMAXEmb1H32dkTD5r5PsVI8JCRiTX8+pNMglFdUXPEDt3mF/CwjIqHU1JLtNoJE7xBdBcW2AAsHPRslvggbfc2+sRx7QxGd1mQG5GKMxb7koC3k8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NRpOabUO; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750976394; x=1782512394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FCslCXNDHzMMGLR0TOhIYCeJZ8U/OcYpMPr7FCe1/8k=;
  b=NRpOabUOWlVCLRATQQQHcmh1JuTAKvwKaJRvV3N8D8sa6kAdO5jj3pwd
   ETETn/vFgqEWH7pVNNKu2Cl+HVG7vxxPuhufWmmSZO92HZv6urLY377f9
   8FdSFktq6zUFlFQv5K4g2eYu7VkqNPg7L4ohOtusUMEaJdoHc7a4KLlhG
   jpzuIylLYxdEqKibMeq83ZFOdx6CvaRMBQLazzB+vETFZPEMymcovy1sq
   pDZZiysDannQVIcEB5WDwm2Gsc63oACa1ZBCgLKqiRcWzMe9vVGZ4aymq
   Rf5Dv4rYDGfneRgdbGMpajUl7I8gvBTozIOiHZBaipwsoOPEs1xp8OA+3
   g==;
X-CSE-ConnectionGUID: q3BvGnN+T96zhfwNarUviQ==
X-CSE-MsgGUID: 9/xewtbRSTq4BNiY8Q1gfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="78725056"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="78725056"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 15:19:54 -0700
X-CSE-ConnectionGUID: rLAYxx2XTnacWGV37v/v3g==
X-CSE-MsgGUID: whUhHg5VSpyH5F013JYpiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="152922615"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 15:19:53 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 15:19:52 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 15:19:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 15:19:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnqMFMyR15SgEy50n+wUrKXkajhWmw/XZ3aJj7t4LU7Nz9F3uZ0VMA6W2k1y+tDLGk7Ezp7t1KTY6cO4rMZza1Lr8xcIJnYENeXeTc+w/T5la7lQGAWdZponZXN0thYWDgGlpOA3BLeD+zx9q+3GbOlyJVxVnJk6vKOmwti6hbcORANiEa5gV6rMSo6Fe53Xpkw03T7ewS0/0ltvLxeW2ktnsrkCu8jacaPmJggD4ArJYJ9XJ5qpmkJ30074SSiIVaVwLp1I3Y9KNOlep6Q8SIBEVUy4hSS72ooc1Ay1Vw8QDYogxsC9X/jxLXcoAimzFnalm4P78IZ2SPr2ITk5Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCslCXNDHzMMGLR0TOhIYCeJZ8U/OcYpMPr7FCe1/8k=;
 b=oh7dxCrAbkuCI8UQJuh60nXEA6+Qgn3POJeRDH6iyQcZ1gFjc9ZUEDHku7uLYBFowMwUqzNS2jUK1PYTqtWmIgzDy8gERIp+vgZyfvknJHtqiUAkeU5BeIf4NhCKRKSuhmVwM6oCb10Bu/HVJk2HqEiBdgirUZ5XF6WFwa+dKuLf9Zhdt+Ohn6o97aPLZFq6JjzWAPdsWktFrkLLZnSmxCL/pYbPHioGl2rOAX3rLJ5QaDh4ymIba7ALCr0Tl8cgFlusFMBBPLkSs556Klf/mHBoTQahHaSKUZlWFuh2JkPwVEKNmV1gcLjPj36HL1Dju995V3Wlh5h2Epi4LXSnwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4672.namprd11.prod.outlook.com (2603:10b6:806:96::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Thu, 26 Jun
 2025 22:19:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 22:19:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Shutemov, Kirill" <kirill.shutemov@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoA=
Date: Thu, 26 Jun 2025 22:19:34 +0000
Message-ID: <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
References: <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
	 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
	 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
	 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
	 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
	 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
	 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
In-Reply-To: <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4672:EE_
x-ms-office365-filtering-correlation-id: 26f0b324-2706-41b9-7f2f-08ddb4ff881c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UU42aGdEdi9IVXZ6djlSSTBxQk1zSjZkZmtCb1JRNmhoVGtzWVJpcW5jb1lh?=
 =?utf-8?B?UTNEM1NiOG84cUpZVzFpYmxCQktqanhKZ0NKR1JKaGtqM09CS3owdGdaZGdp?=
 =?utf-8?B?VXJJNURJKzNLckFuaWl6Zm1KTWFhcGNoa2s0NUN0RTlWZGRhNndONjg2N1Fa?=
 =?utf-8?B?R2xneSs0cnN4M3I2TnQ3RUptaUVkN2srNk1ZN3pWSDFBZTdkaEliUnNEa1NF?=
 =?utf-8?B?aytYOTZaR1FsSU8vZmtyVDFGckdPY0EwTERFUndSRHFXK1FCWEpzZ0hhQ3dB?=
 =?utf-8?B?Z2hnR3NGczI1NzN2eGhQb1JEaGgySUI2ckZXWm54Tk9jNkhtcDluQ0Eycjh0?=
 =?utf-8?B?VGY4OGc1ckgwVlUvU3V1b1pOWitQRDZNNUJMMUFiVVBHZzBLOEhMWVhxalNV?=
 =?utf-8?B?VVhMajN2WHJxV1gwbUhoL3VZdSt3bmVBT3ptN1N2M2IzcXhCaTVxc1hDZ3pm?=
 =?utf-8?B?cDZSTUV6OEc1VFlMdGo0RG5oc0dNNU1ZUGFRTTA3cG5yZUNBS3NFN1ZMNEc1?=
 =?utf-8?B?SysxUlg5RzFWRitlNmNMSDdrWUtGcFgwVkU4TzJ5bVFDVFpOUnVhSmYvbWpw?=
 =?utf-8?B?aVdXV2VOVWlUZ3A2dGcwRnc5UlBVOTJrdnp0ZzBsSnlwZUhjZWorNmM5K3Zq?=
 =?utf-8?B?WUlmQklGbFo5bWRPY2Q4TTYyUy9nL3o2aGU5K1RIYlpKYkUrS0FHWHM3ekpP?=
 =?utf-8?B?bWpiRlNLMzRlYmdIZCticmV5UHI3N01NVGJoa0RzczJTcDdIcVJRSkpWRSta?=
 =?utf-8?B?bmZJcS9qSit1N2phRmVINDIxdzByVXlZSnQwbnFDSUkrS3lGMXBoNlJoTlZa?=
 =?utf-8?B?YUd0c3JlaHV6VnVyZzNyRzdFcUU4US9idkNIZnhVa2hrWWRZaUhxbXZhZGpI?=
 =?utf-8?B?ajNvUktQR2tiK2pmNGFoQVRzYjBXUUJlc0tVMnhnbERON3RYMWhjY1VhT0NC?=
 =?utf-8?B?cUJhRFliYVRMWGFDQnBweno2ZDR3bU9FL2FSZEorTEVieHpYWnNBamZBN1ht?=
 =?utf-8?B?Q1lONFl0UHdhSEh4blN3QWh1TVl6RWxVSktZcTVybjVUZlF2dy9ER1VQVzY4?=
 =?utf-8?B?K0FxNitxYUsxQ3drb1J4cy85VlFzcExyUHR2Q0ZZTFZBSzVhMCtteklXdktm?=
 =?utf-8?B?RW5TRGRjMXRVRHJIZ0pZejVVSDhVd2ZjYWdKT3lncTNyYURoQUdqY3JFWHJj?=
 =?utf-8?B?MHo1VGRlUEpIbFNtNEVKeC9FTHNSN1ZObEJTNjR0RXp1R29OYzdXS2RqdUQw?=
 =?utf-8?B?cXQycVIzK0FlKzBmZmpua3FyWW5ua1FRMjZ6ZFp6ZTV5bDJHbXJrZDVhNnc4?=
 =?utf-8?B?Y3NobHprMDdHc1NPdXY0T3orWVIvNjJDY3ZaemtyQ2k3S0xoTnpROHc3QW5C?=
 =?utf-8?B?OSt0V1pCVTNmeWVxaVVGdnhweUtGWFNwNmNRRE1OdHBFaVdoUllxWVhuc01B?=
 =?utf-8?B?S0FBb2xYMGo3TXlRTzBHVmpsblg2SWdNbVpQZWNJMW1XQ1I2R2dIckZESTNE?=
 =?utf-8?B?SFpHZFoxSzRzZm9vQlorSTRyUGpqWEJ6YmpXL2RtbEZ0M0F3d2FwQ3dSQ2pk?=
 =?utf-8?B?R3JGK04zVE9mbWdVbkRUSUJhcytZRC94dVd4MnhQaDJCRVRQd3pJZjN4aWkw?=
 =?utf-8?B?QXFlTndBRnF2VjZ3cUltQTcveGcyY0RrRFZOcE96YTJtQlFyenY1cnJIeEZk?=
 =?utf-8?B?VFdyZ0hjUzhrbFlaSzZkeG5NUWFHdk9OL1VldEZTTVIrU2NuSEpCZFJCSjQ3?=
 =?utf-8?B?Q2dsTWtGNG9hOHN3R2xaU1IzLy9CNlFlQUFpck5Oa2NZN2ZaeDJNSXNSZ2Zi?=
 =?utf-8?B?WnUxRVoyU1pDME5abUtnNUtjNm80K0ZucUlEekF1QjdWbG85d0RGOVczL0oz?=
 =?utf-8?B?UkFScHFHcEIvVjhPWjQ0V2g3ZG9FRTk3aXdUbmNCdzEwRFZUai9mOUJrbWs2?=
 =?utf-8?B?Z3YvTmFhYlVqeWIxVDFycnh6Vm9mMWNDMXRvTjdxYmE2elU2NEFRK0pvTG44?=
 =?utf-8?Q?TbbR0y+7QCKoH679Kjs5zZmS0NDAuc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkwzZndsbCtkUHBmekhyYnV0bjBWM0lPYUZVQUxUTnZOTGloUzl1RU00SmVT?=
 =?utf-8?B?Q0Ixd3ZFQTVoSGk5ZEpnR21TWHpuMk8zVmMxMEc3djQ1VVZDc01uTmFCdExt?=
 =?utf-8?B?TzR3d3N6VnVtbC8wMmhVMGtIRlV0ZXkzVVBYNnFKZmdkTGF0Q0lNWUF4V3ov?=
 =?utf-8?B?MGxiWjZyakFqSzQ2VkFJT3ExdEFlRjZObS9Ia3NYOGtNRXl0THlPUUdocklr?=
 =?utf-8?B?Undrb1RKNCs5RDY2bVFKQnJNb0xPckxYVGFaSEtNaG9RcGNoQitxMHVITm1N?=
 =?utf-8?B?UXB5RVFCelVWdDNMNmlrVmFwd0tlRmpiNm5LcmorM3ovSW9lczRKOUFtVFBK?=
 =?utf-8?B?YjJvcHpuZzBtekVFdTJHTWZqelNBUklTRUgyREZ2dThvU0x1V0hjNW1iQUNS?=
 =?utf-8?B?aGRyZkhpRDJrbzFVU1JVUy9jb1h5aDUvc2x2QmFzZ0JKb3JKbmNlK3czcEcx?=
 =?utf-8?B?R2lhanhudkRVZlFYaDRRMDdjSk9ZeFBSZ2hGSzhjdTU0eUcrTkRoK1ZRQ041?=
 =?utf-8?B?SlZpZW1JRlIyWnJtNjdTSnRCa3djM0tmc2hycVdGNEZNZndHMmFRcC9CSXFj?=
 =?utf-8?B?N3RDV2kzUHpDRytEcTg2SGlvTDJDQ0Zzdk5DN0k1SzkyQnRqZVJmRXhKRlVu?=
 =?utf-8?B?SVRFeVNkeG9pcEgzN1E2cXlYOUF4NnVpb0ovRkNMQVd4NjVEcEJUVmN4Ykw2?=
 =?utf-8?B?SXhyV25Sb0xFM1BqUWJqL1ZyYkdkd1puVU52RGRQN2VIS0FvNEo0c3h6ZmY0?=
 =?utf-8?B?OVZhd1pzZHFMMzlwQnNMZHptRU0yeFJlRmx3T1ZXQTVwWWRnTVcxZVlMdDc0?=
 =?utf-8?B?TElNVmZCQURya0lEOFpoMTRIRm02MkdXbHBQTk9HY3pVU1I4SHE2SU0yMzlF?=
 =?utf-8?B?ZlB3MlZ0WFhCSzA2YTQxSzY0bGVmL2FCaE5xbjVNY0N4UlFlUHgwUVFzZHVk?=
 =?utf-8?B?VUVDUzJDV1ZMZVZqNG1vaXl5VEtJdVl2aDA5MFgxYkZ5K1puc1dBcXN1aVd2?=
 =?utf-8?B?SmFXQmFydGVjeUM2bERaSEFWYm01UTJxTTJoL3ZLVlgyYUd5STN6Tmh0dTlQ?=
 =?utf-8?B?LzNpMko0dnhTMnd1TjBtNmh6ZGExS0VXTnI2bFZxcmhZS3lGUzR3bFFEV3Bx?=
 =?utf-8?B?U3haQXpiMHFSSlB2b25aaEFURXMvem91M3NGU2E5L2RFWVNBYkZTMi8zdzhS?=
 =?utf-8?B?eUlLUXRjTXd3Rms0YjJMYzFLblBSTmxYWC9zNjljR1lHckQxWkNuWnVVdEFF?=
 =?utf-8?B?TGhrR29GczJ2aGd0WFYyeHViTVZGT1BJZzBjaWpubnNGNFlCYW8wcktvOEtk?=
 =?utf-8?B?Mm9VUmlSSFdsUVZEZzA0MjR3YjM0RENrc2dXNUc4NUJ4SUI2Y3ZUcXNUbWdn?=
 =?utf-8?B?SnVCREQrdUVOdGhpVFpyNWdHS3ZhNy9WM3ZzV1I3bDgyN2ZyM2t0bHdHU24w?=
 =?utf-8?B?REVGSkJOMU5YNFI0dTdVK2haZWtPeFBXc3lCU3NseDlPWVZlWmxXam93aWlF?=
 =?utf-8?B?OWJORkphd2l1R29BbzhjcTVEVTR3L3oxZnA2UDV3MmJON0hBbldQVDNIVFFC?=
 =?utf-8?B?L2QvaFpHbEdjeCtpeGVXdno4SEJKaVoxemcyUUNsaWN2SGo2d3VWWDZGM0xS?=
 =?utf-8?B?U242S1FyMkp0YUpuOWxyajRzVmhmcWYzVHNDNW1XVW5pSnBkZXY0VEVnOTVy?=
 =?utf-8?B?NU9kOGF2dG9EbmFZS2tnNmZRZURmNCtLT1o5aFVSWGJUYkMyKzc4L2JUNU4x?=
 =?utf-8?B?ZTliRkozTnkwWHNrVU16NzBmbWdlZVFhT1lUeTZpV3QvL21OY1VVbUYwVTVW?=
 =?utf-8?B?YjkxdVBvTDlZNWMvNUZBVlp1RnZGZW9iVkQ3TWd3dDZYVkJQYVpQYXB1Yklq?=
 =?utf-8?B?eWwzTjVNdHJjK3ZGcGVkaE9RdmZkQTZIL2g4TzBBY1lmWEdjRVE4SitxTlFL?=
 =?utf-8?B?Z3N0Z1V5QmRtQXVTUy9abXRQK3FKdkdncVdGYVBDUDBDN3prUDMySzVqWlJ2?=
 =?utf-8?B?UWlYeHVxMjVUZTJ2YXpCZ1gzV3p1Z1dlQi80aUxaNFVmWEVsSjllU21acEh3?=
 =?utf-8?B?S3BiRFNwL3l2ZmJlV3pLaUx0QU5kcWZqTmVadmdXTDFtK2I4YVhtNDdpalI2?=
 =?utf-8?B?Um9KOHlOakhUUFJWNmFoYWozdE1ZQUY4Y2U0MjJJRWVmVjUrRFFOSXc2dnZa?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDF2B63C4B8ADA448C169F6A199353D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f0b324-2706-41b9-7f2f-08ddb4ff881c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 22:19:34.9145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T477KmcFcPnAKm4ODoBpN3M9ngNKkSJicBgVzgtHMjJH62D7eYoRN0aBg2H8E0CjXv6CZjB3kTUiN4yhPRKoEn+KbkGifW2MjICCGDIqIro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4672
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDE4OjE2ICswMzAwLCBTaHV0ZW1vdiwgS2lyaWxsIHdyb3Rl
Og0KPiA+ID4gUGxlYXNlIHNlZSBteSByZXBseSB0byBZYW4sIEknbSBob3BpbmcgeSdhbGwgd2ls
bCBhZ3JlZSB0byBzb21ldGhpbmcNCj4gPiA+IGJldHdlZW4gb3B0aW9uIGYvZyBpbnN0ZWFkLg0K
PiA+IA0KPiA+IEknbSBub3Qgc3VyZSBhYm91dCB0aGUgSFdQb2lzb24gYXBwcm9hY2gsIGJ1dCBJ
J20gbm90IHRvdGFsbHkgYWdhaW5zdCBpdC4gTXkNCj4gPiBiaWFzIGlzIHRoYXQgYWxsIHRoZSBN
TSBjb25jZXB0cyBhcmUgdGlnaHRseSBpbnRlcmxpbmtlZC4gSWYgbWF5IGZpdA0KPiA+IHBlcmZl
Y3RseSwNCj4gPiBidXQgZXZlcnkgbmV3IHVzZSBuZWVkcyB0byBiZSBjaGVja2VkIGZvciBob3cg
Zml0cyBpbiB3aXRoIHRoZSBvdGhlciBNTQ0KPiA+IHVzZXJzIG9mDQo+ID4gaXQuIEV2ZXJ5IHRp
bWUgSSd2ZSBkZWNpZGVkIGEgcGFnZSBmbGFnIHdhcyB0aGUgcGVyZmVjdCBzb2x1dGlvbiB0byBt
eQ0KPiA+IHByb2JsZW0sDQo+ID4gSSBnb3QgaW5mb3JtZWQgb3RoZXJ3aXNlLiBMZXQgbWUgdHJ5
IHRvIGZsYWcgS2lyaWxsIHRvIHRoaXMgZGlzY3Vzc2lvbi4gSGUNCj4gPiBtaWdodA0KPiA+IGhh
dmUgc29tZSBpbnNpZ2h0cy4NCj4gDQo+IFdlIGNoYXR0ZWQgd2l0aCBSaWNrIGFib3V0IHRoaXMu
DQo+IA0KPiBJZiBJIHVuZGVyc3RhbmQgY29ycmVjdGx5LCB3ZSBhcmUgZGlzY3Vzc2luZyB0aGUg
c2l0dWF0aW9uIHdoZXJlIHRoZSBURFgNCj4gbW9kdWxlIGZhaWxlZCB0byByZXR1cm4gYSBwYWdl
IHRvIHRoZSBrZXJuZWwuDQo+IA0KPiBJIHRoaW5rIGl0IGlzIHJlYXNvbmFibGUgdG8gdXNlIEhX
UG9pc29uIGZvciB0aGlzIGNhc2UuIFdlIGNhbm5vdA0KPiBndWFyYW50ZWUgdGhhdCB3ZSB3aWxs
IHJlYWQgYmFjayB3aGF0ZXZlciB3ZSB3cml0ZSB0byB0aGUgcGFnZS4gVERYIG1vZHVsZQ0KPiBo
YXMgY3JlYXRpdmUgd2F5cyB0byBjb3JydXB0IGl0LiANCj4gDQo+IFRoZSBtZW1vcnkgaXMgbm8g
bG9uZ2VyIGZ1bmN0aW9uaW5nIGFzIG1lbW9yeS4gSXQgbWF0Y2hlcyB0aGUgZGVmaW5pdGlvbg0K
PiBvZiBIV1BvaXNvbiBxdWl0ZSBjbG9zZWx5Lg0KDQpvayEgTGV0cyBnbyBmL2cuIFVubGVzcyBZ
YW4gb2JqZWN0cy4NCg==

