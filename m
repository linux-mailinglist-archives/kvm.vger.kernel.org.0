Return-Path: <kvm+bounces-46907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11A13ABA5BE
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88053A208F6
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 22:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE44230BD5;
	Fri, 16 May 2025 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VvwKwSmn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA2F21E097;
	Fri, 16 May 2025 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747432970; cv=fail; b=WYC1fAwNo5z6DQiD91ooqHJCtS0O/qD3xfzLU5SVsFVUi6lqT7PCAHxm3N8p3NFqlAh3HDke52G1yJLLHdgAxdk+9gxAApgKFgfuEDrVdCK24m0oG/XDFx3PxURtAAEjFKJapwHXb+yu2iZTfBL6qp+odDXhhLAhdvVrlJnvt9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747432970; c=relaxed/simple;
	bh=suvgCH8HtF5MuTrvaQHoD3bGAkK5emj1V7tDRY/WPF0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gqtUp8Dc8E4LGqZqjRMzkGAI/VgrcY6612gAD9FCh/ehxV24zZv2YNyjbdesWUn6h2Pkin1zXyP6fpPmNVBBJfAjSN4YkpFkTw653yZmuYj+yJWttFFyaBkPI9Xlir7Ejk4BxdVfUG2xO78hyWjH+9FLlasNFQUcVGUfENwhJcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VvwKwSmn; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747432969; x=1778968969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=suvgCH8HtF5MuTrvaQHoD3bGAkK5emj1V7tDRY/WPF0=;
  b=VvwKwSmnKl4CNRXD0Fyp0gPyA18bs8mcBf/clayLZOMN60oLJbqblrDC
   Pxr69zQprGlujMh8W5LGjVapnPJfC9if4jJAwYghO+BBjxmP6O3Erwz/S
   DAPRv7tnsn2PRc0cEaP33WmEvbcfZEiqILP+M5dB832VbNycBr4LUToHT
   756wZU8sfpwvle7j1Q1CSIAkA1qzqyBdZhfA3wvxEgNBuS0Go7Mmfuew4
   oDCLbKtp83ZtbEJ3y+AhS0w70aWTTLnYHTj3TlXfIH/FBIPedc1DsJ2fF
   BEm7ARdTsTb7zFbsF2iKb5aggPwM+DWgr0lx6bEpl9PvbprSgbWSyHoCv
   Q==;
X-CSE-ConnectionGUID: 5+DwvWzMTYee+C5CDLVoEw==
X-CSE-MsgGUID: sqFcc8/1QVaQrnJY5DkaQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="60759145"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="60759145"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:02:48 -0700
X-CSE-ConnectionGUID: jzzWL5QNQ5iSZSDxblZp3A==
X-CSE-MsgGUID: WbXO0E84SIOLSVAo4aklMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="143790402"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:02:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 15:02:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 15:02:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 15:02:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fj4sqyYTZAxozXTCchT0cBTA1mwhsJ1l55jdMWU2mXvWBbiRnlnim7/TsdLpMiCq+ISGKRyjRK3buq/lcPmH8K4g9XMhf/YsCntjXscqL4CxUnjJFvLfcMn7y9qtsCVbLiox7QL/BNCA88yjfeEJAKOicR2AsflL95WhRO7sTASkF3AP21kszizkKVsVRk3idlZUlLxyWvXG3DVrFrnYQS2u+P5X7MFtPc+LAXjhvu27RCu0JUDzCf3jPVKeO8wVufQkcrSmiwvS5rCi1mRD9e4bJemB/hOPGqBfw/dbzmD8FC8e7OQlbHiVdwgTZhpgrkOh2jkDqDWaD1bpghTuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=suvgCH8HtF5MuTrvaQHoD3bGAkK5emj1V7tDRY/WPF0=;
 b=ZIS+TWniCBhUTfNgRz2w1wqM/QywgJAggZcpkvkWvrFP7E3eTrkOcpA6OhBZkBEpCxESCAqdyCrD7syU95/J+HIMc75hFZ6kYn54OWGwzDG1xwBhUilJdLfvq0LhccN2C5UAP3a/AUJqDJLw1OitRB5vBmFwTvFVf5mI4OKswdgXCjeRPGDcR1wgA5KtkFHvJS31IX5GYouaG9MaXfCXCNC/J7Jc5rDBgxui6jgEtuEhuFar3UtNGv9LHtG00+2VVy+rYv/H+DbWXOTqQsqcqdKtilM8u8nhnLNHDHsk09HPNDI5tnRRmvf67sY2FI/JK1EWA3tzjJk+WghqBnADQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB7533.namprd11.prod.outlook.com (2603:10b6:806:306::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Fri, 16 May
 2025 22:02:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 22:02:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level according
 to vCPU's ACCEPT level
Thread-Topic: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level
 according to vCPU's ACCEPT level
Thread-Index: AQHbtMZGizk+eJuph02+8m+gmHBwDrPRMAQAgAO+hQCAAQRFgA==
Date: Fri, 16 May 2025 22:02:14 +0000
Message-ID: <f94e752bfedb9334ffc663956a89399f36992ed8.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030713.403-1-yan.y.zhao@intel.com>
	 <7307f6308d6e506bad00749307400fc6e65bc6e4.camel@intel.com>
	 <aCbbkLM/AITIgzXs@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCbbkLM/AITIgzXs@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB7533:EE_
x-ms-office365-filtering-correlation-id: 1b536d41-542e-4ce9-3935-08dd94c5514e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?LzNRczZiZklVVm5UYmVJalBXZzdoNm5UUlM3Nk42MTl1TjNjbWx2OXI3Y0pI?=
 =?utf-8?B?UFhFQ2g1TENqck5GaDFXcllIRnpZMmo5cWdlM2xTcmttTHdjYVBlMTUxYjY5?=
 =?utf-8?B?N3UwaStuK1c2T1pKZ1ZyWnpGbDZyT25VQnRBU29RTHBtOEpzR2VCaDdGdDM1?=
 =?utf-8?B?N3R3SzVzbFFnRk1nbmZ1eUxNSm1GUlFHcEd3MmJpbFBtRUlDOE5nS0lWSnZ1?=
 =?utf-8?B?RWpjdzMwYWd1TnZrOVprVXZYSnRhVzMxSDByZGcvL2FPSU41SElnV29IUkQy?=
 =?utf-8?B?cmZzUFh0YnZHQWloemtsNGNJc2xUcGg3STRQYmpEUFN4V2tDcnBjSU5rcGEv?=
 =?utf-8?B?MzZGUjQ0SkRLMnJ4SjJhQjczMWU1VXN3di80c3hROEVLVmNpSTFpNUloYlBU?=
 =?utf-8?B?RVBZd1ZRckFRRUVBc2hEWVFUT0RCNFNpWExCS0dhbDlEQlpYdTFyaUtiZStq?=
 =?utf-8?B?K1FoSGZXYk9PR0h5MlNqY3MveGJLd2ZaekxYT3ljR1FHeGhoRkNmVmNEb0pN?=
 =?utf-8?B?aFlTSzdrTFVzR2VUUWIwR05GS0E5cFlJMGZjME9DYTJ0L2dxNmNPaUpmb1JP?=
 =?utf-8?B?cnBMV3hHSWdwbmluTEJHeGRWRDJqY1Q2aktMWEFzWmNzOEtwZTdHeWxlTVdC?=
 =?utf-8?B?eDZCNUFMeUYwdHliclhjaDdtSlVYM1ZGdnU3TkVINEFlUnBKOUNLK3lCOEtu?=
 =?utf-8?B?R3dBRHpjZXFjZzJCRjNrU2FUTy96R3JTRm5nMk1TUkJXT0hBSjFGUDNyUzgz?=
 =?utf-8?B?YS9uOXBrRWlhYjlVQWJaRGRKTGl5ZXFyZmJIRjZXcTRaUWlrcG1Vb2ZSVits?=
 =?utf-8?B?UWUycnZ5S2ZWclp0ejE0ejRBOEFvNTl1Q1lxMEY5bWJTL2MzRjJvY1ljRHZo?=
 =?utf-8?B?YUtyOElyL0hGNFI4VWhlbFRHYnN6Q2Z1NjFMdE9yM0pOQ3k2QllGUEVhd21v?=
 =?utf-8?B?c0orbEZVa25XMUUydkQvbElXeWNkamxoaUNKVFdUczhUYVl2QUhtaThDOWRU?=
 =?utf-8?B?MWlocUtPNkFwTUVsWG5GOG94NzM1Q3Z6SlFPR3VRN25SUzJBMXFHeHNDVytL?=
 =?utf-8?B?b0toWkE4dUxET2dESXFabUlpM3hYRGNNOHRUWmExd3MxL1hUSm5GazkvdXEx?=
 =?utf-8?B?QWVGN2xnL0JoYTR1VVlJTTZOMm9TUXVZbWhOSk4yWGhRZ3c4ZDZRVFFtWkJL?=
 =?utf-8?B?RGxZU0xEaHRDUlB0Y0htRHlHbzVmVVVHYlF4eVpaajZ3S0tWRFdPWHgwTHFz?=
 =?utf-8?B?dSsvZzc0cFFPMGd2eUs1cVhtdUlMbitsbmhDbTBkeklCNGduUkMvVjRYWTJ1?=
 =?utf-8?B?c2hhTzN0SXhkeXNCS1VrdGJLU1FzZFZVam1KTHh5S2JlSEluVGdEd0dnZzJN?=
 =?utf-8?B?SER0dVlGeXVHYUJ3cVE3V0pieFR0K2FuY3hYNWlJTGs0UkladWd5Z3VHNk54?=
 =?utf-8?B?d0JrV041L1UvM1RrYVEvQnVoNTdlUlJPcDJLNHRPbFQyOUkza2xPZjlXV2pS?=
 =?utf-8?B?SUEyL29VTjUzZnNnSmlFSUlhTGFVOGJCaCtPc0ZPMWFYeWR2UW4vV21XWUpH?=
 =?utf-8?B?Zit4R2xVSFdBNkVRN3h4L3ZLK0NLZ29YcEs5dllBd3BZWDJQWFNvekNvR0lh?=
 =?utf-8?B?cmpPQ0RScnNLNjZzaVdpakhOdVQ4T29YVzJHNEJlalpCK0RwcVlMdGxqdXZD?=
 =?utf-8?B?czYzWUJFRHZ1M203dFgzUFFsM0Q2N0dlY1RKMFhiQnB1MFZPSFdnajY5Tm1F?=
 =?utf-8?B?WURnMlJ6SWNDK2FTTHFvemF1bjE1bU9yNm1KY2FISERoSzZHZmxlOWJaRVBO?=
 =?utf-8?B?RHJwTzRHSkVleXVjMXJUVVcwbzcxbjY5cTZIaFllaHlFNGVCYTBNd1hFTDBJ?=
 =?utf-8?B?OVdQWGJxWFdBTzY0Z2VVaFVCRXVZZHBnWnIxQjlyT3AxaGY0RGlLQ2dBYitL?=
 =?utf-8?Q?LGFV+GlSEv067s5HZC+HejbfXOUf8rlc?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFVjMXNvUzN4NkVjLzZoYkZodjhOYjdBemxYbEd4bVdWRUVVNW11TWp6MG14?=
 =?utf-8?B?R2NMZDYrbGI5bTl0MHMveXVYZnJ4V2hTbWJFWC8rOFpJcHZiU1lOUm4wMzFP?=
 =?utf-8?B?ZHFXdlk0WnFCZWtvckRzWmhqemcvSG1lM0JFancvZ2NyNkRZa1pVNVQwSC9w?=
 =?utf-8?B?UTF1VjNWMENXaTJ4bkVZMGgvbUw1NzVpVjJHaElvR0gwR0FZb2FJZU05K21M?=
 =?utf-8?B?QjhiQkxPb2F1R0M3TG9QM2MrbXlKU2o0SVpMMzVXMlBRU1lNV2ZHbUx0SkJz?=
 =?utf-8?B?QzR4dGJtdlY0RW96aFFtdGxhRnkxNHlxTkJWTWFlM3k2dlljV2YyaWQxRFFv?=
 =?utf-8?B?aFBLTWVSNzNXLzZpbjJYdHJVM1c3d1RJTkRpQ0tqanNReUpMMEgzYy92QVBY?=
 =?utf-8?B?VllLN3JueWZoampBZTh5Mkt1YnhXZ1pDVnZqMFdwUDZyNmpMSW9EQmFXUi9t?=
 =?utf-8?B?THJ6ZlVVQ3RCQWtFb0l6emoxWkxwbVprc0ZrcmYzWTJUVTY5L3pqcUd2S1J0?=
 =?utf-8?B?Y2NCYzhFQUtUcTJYb3RLeHNTUnlmZXFRU2Y5Q3FJeG12ZVBVbUFYQ20zWXov?=
 =?utf-8?B?R0oyZG5YMjdVSVN6MllnSHYweDJGOWlMaUZEWmRvakNsVkk2ZjBDRVB3c2lj?=
 =?utf-8?B?bk82Wml2MHB4VEJaSHBjR3JtaGthdnZCWFRZb1I4dGNVUmdhbzFXMEs4WEY3?=
 =?utf-8?B?Q1p3aU1OOXBJSG5FNlljUDJoVnVxdXdDamJ2SUgzLzZyS1F3QlJ4dDR0V1Zx?=
 =?utf-8?B?T0RBa2RsVCs4QTZKb1g1aC9xQ1VMRlRtN2lxTmZrejFXMjdHZjZ6MmdHTTN5?=
 =?utf-8?B?OThDdGhkZ0p3K3hiZkplMW92K1FSRXNBTWpIL0ZMZHhsRVVBRXIxOU0vaDYr?=
 =?utf-8?B?WXlqWEg3K2d1d2EyU0dmVGd6TVZzRXAwTUtVTFN3NVRlQSt0NG1NZDJZeVRm?=
 =?utf-8?B?V1NkM2sxZ0NMbmFISGpBNzdUcndhWnp5aFIweTdMWmFJMWsxVTVhemNkS3dW?=
 =?utf-8?B?VDByVU5SMnRwa1B2S2pEdDJiYkpub0VkVUo5NEFPeHpzNTZEcGtOQk9xVW1h?=
 =?utf-8?B?ZUJOOVFqUWhaaXB1M2xlQThYREp0M1pkbXN3L0gzbFBQbk15RGpPcDVxb3c0?=
 =?utf-8?B?ejlpOWxpd252SkNUS3dIUmVsN1dBNnJkRWVNOWFPTnk5WTFzK050TTRCR20x?=
 =?utf-8?B?R2p5YVhkbldTcG9qSjQ4ZHpScEpVa0tGSWhlY1QrOUJwY0JhazE5ZHdGZnZT?=
 =?utf-8?B?QnJlTWNsR2JTY0pvOHRMYXl0N29GWWx2ZWpNYW45cXRDUy9nNVkyL0Jmdkh6?=
 =?utf-8?B?b1prSWl3bm43QlVqYTR3bmNtYU9VRHdNcHRpZWVpV3RkYlplTTlJWFZBS2pn?=
 =?utf-8?B?R0EwMlRlVytiVTE3SUw5S1NKZ2xxQnlvQllmMmtMblBFaU5kbkY5N0pzK1Z2?=
 =?utf-8?B?NzF5Rk1ZamhCT0ZndFd6ZjFQeEFyZURiZ2czRDl4ZTNVRXVqUUt1OVpnUkZh?=
 =?utf-8?B?ck1XMU9mZVRMWWtXK2k3MWx5bDF1QXpQYTFmelNOTWhWYUczNzhvNElaUEd0?=
 =?utf-8?B?Zk1LOFd6RmZGRnNNYnV2U1NWejFoSGNpMHBOMUtjanNuMEVkd2thM0ZmR25C?=
 =?utf-8?B?cDBHejBzclpJSGd3TktGbWtEK3Vzb2JXbHBweTRCaUd6cmZqRUhSVXZFOFc4?=
 =?utf-8?B?M1hiQ0FOb3hkendwaVdaRUMxVERqVVVWQkFBNUdvQ0IxNTVqRU1zQjFnQjdQ?=
 =?utf-8?B?d3FsemhQMVcxOTJ4byt4KzZEcVNsOFgvbjdqNERmbVVtT290TEZGc2ZWcDht?=
 =?utf-8?B?WWdHTmVkUTZmdnZIV2hxYlZrdTR6NlQ3bjdFWUVmRVRzMEpVSjA5dThoYjhU?=
 =?utf-8?B?UUNaemhiMll1bFQ1M3ptOEpJWk45eEpGUmFtRGZZbVN1ZllyS1ZRTzl2NUV3?=
 =?utf-8?B?Zy9jYjI1MFlTS054RGtXMEpLdDJWRE55LzV1RVFDbERWUWovUDRnRkhqUXJE?=
 =?utf-8?B?cmNueGw3Tm5FWXdxZFE0WnZhclgrZURUNjdwNWNSbGJMZ3owTnpSaTA0Vlk3?=
 =?utf-8?B?S3hxMllFR0VIRTFPYVlaQTVPbjBTVjFJa0dOdmlURjdQS2kvdEppdkk4UTFD?=
 =?utf-8?B?MXIxQ01OS1hmK2hxb21sQnFGRmJiL2RyWnRLZThNVFRnUzVZWFZrQlliQnIy?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51B4087241A27B449123137BB1AD2D80@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b536d41-542e-4ce9-3935-08dd94c5514e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 22:02:14.9484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5EwAXueHZ/19K5/9G9hROfdN2Xo2wF281r85ljWA//fKljJCKaFSXpZHClrSpuCiP0IUOV8sy4LLBvPmYamYjXLGd+0JnQlGMsOI94xXNII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7533
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDE0OjMwICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBM
b29raW5nIG1vcmUgY2xvc2VseSwgSSBkb24ndCBzZWUgd2h5IGl0J3MgdG9vIGhhcmQgdG8gcGFz
cyBpbiBhDQo+ID4gbWF4X2ZhdWx0X2xldmVsDQo+ID4gaW50byB0aGUgZmF1bHQgc3RydWN0LiBU
b3RhbGx5IHVudGVzdGVkIHJvdWdoIGlkZWEsIHdoYXQgZG8geW91IHRoaW5rPw0KPiBUaGFua3Mg
Zm9yIGJyaW5naW5nIHRoaXMgdXAgYW5kIHByb3ZpZGluZyB0aGUgaWRlYSBiZWxvdy4gSW4gdGhl
IHByZXZpb3VzIFREWA0KPiBodWdlIHBhZ2UgdjgsIHRoZXJlJ3MgYSBzaW1pbGFyIGltcGxlbWVu
dGF0aW9uIFsxXSBbMl0uDQo+IA0KPiBUaGlzIHNlcmllcyBkaWQgbm90IGFkb3B0IHRoYXQgYXBw
cm9hY2ggYmVjYXVzZSB0aGF0IGFwcHJvYWNoIHJlcXVpcmVzDQo+IHRkeF9oYW5kbGVfZXB0X3Zp
b2xhdGlvbigpIHRvIHBhc3MgaW4gbWF4X2ZhdWx0X2xldmVsLCB3aGljaCBpcyBub3QgYWx3YXlz
DQo+IGF2YWlsYWJsZSBhdCB0aGF0IHN0YWdlLiBlLmcuDQo+IA0KPiBJbiBwYXRjaCAxOSwgd2hl
biB2Q1BVIDEgZmF1bHRzIG9uIGEgR0ZOIGF0IDJNQiBsZXZlbCBhbmQgdGhlbiB2Q1BVIDIgZmF1
bHRzDQo+IG9uDQo+IHRoZSBzYW1lIEdGTiBhdCA0S0IgbGV2ZWwsIFREWCB3YW50cyB0byBpZ25v
cmUgdGhlIGRlbW90aW9uIHJlcXVlc3QgY2F1c2VkIGJ5DQo+IHZDUFUgMidzIDRLQiBsZXZlbCBm
YXVsdC4gU28sIHBhdGNoIDE5IHNldHMgdGR4LT52aW9sYXRpb25fcmVxdWVzdF9sZXZlbCB0bw0K
PiAyTUINCj4gaW4gdkNQVSAyJ3Mgc3BsaXQgY2FsbGJhY2sgYW5kIGZhaWxzIHRoZSBzcGxpdC4g
dkNQVSAyJ3MNCj4gX192bXhfaGFuZGxlX2VwdF92aW9sYXRpb24oKSB3aWxsIHNlZSBSRVRfUEZf
UkVUUlkgYW5kIGVpdGhlciBkbyBsb2NhbCByZXRyeQ0KPiAob3INCj4gcmV0dXJuIHRvIHRoZSBn
dWVzdCkuDQoNCkkgdGhpbmsgeW91IG1lYW4gcGF0Y2ggMjAgIktWTTogeDg2OiBGb3JjZSBhIHBy
ZWZldGNoIGZhdWx0J3MgbWF4IG1hcHBpbmcgbGV2ZWwNCnRvIDRLQiBmb3IgVERYIj8NCg0KPiAN
Cj4gSWYgaXQgcmV0cmllcyBsb2NhbGx5LCB0ZHhfZ21lbV9wcml2YXRlX21heF9tYXBwaW5nX2xl
dmVsKCkgd2lsbCByZXR1cm4NCj4gdGR4LT52aW9sYXRpb25fcmVxdWVzdF9sZXZlbCwgY2F1c2lu
ZyBLVk0gdG8gZmF1bHQgYXQgMk1CIGxldmVsIGZvciB2Q1BVIDIsDQo+IHJlc3VsdGluZyBpbiBh
IHNwdXJpb3VzIGZhdWx0LCBldmVudHVhbGx5IHJldHVybmluZyB0byB0aGUgZ3Vlc3QuDQo+IA0K
PiBBcyB0ZHgtPnZpb2xhdGlvbl9yZXF1ZXN0X2xldmVsIGlzIHBlci12Q1BVIGFuZCBpdCByZXNl
dHMgaW4NCj4gdGR4X2dldF9hY2NlcHRfbGV2ZWwoKSBpbiB0ZHhfaGFuZGxlX2VwdF92aW9sYXRp
b24oKSAobWVhbmluZyBpdCByZXNldHMgYWZ0ZXINCj4gZWFjaCBpbnZvY2F0aW9uIG9mIHRkeF9o
YW5kbGVfZXB0X3Zpb2xhdGlvbigpIGFuZCBvbmx5IGFmZmVjdHMgdGhlIFREWCBsb2NhbA0KPiBy
ZXRyeSBsb29wKSwgaXQgc2hvdWxkIG5vdCBob2xkIGFueSBzdGFsZSB2YWx1ZS4NCj4gDQo+IEFs
dGVybmF0aXZlbHksIGluc3RlYWQgb2YgaGF2aW5nIHRkeF9nbWVtX3ByaXZhdGVfbWF4X21hcHBp
bmdfbGV2ZWwoKSB0bw0KPiByZXR1cm4NCj4gdGR4LT52aW9sYXRpb25fcmVxdWVzdF9sZXZlbCwg
dGR4X2hhbmRsZV9lcHRfdmlvbGF0aW9uKCkgY291bGQgZ3JhYg0KPiB0ZHgtPnZpb2xhdGlvbl9y
ZXF1ZXN0X2xldmVsIGFzIHRoZSBtYXhfZmF1bHRfbGV2ZWwgdG8gcGFzcyB0bw0KPiBfX3ZteF9o
YW5kbGVfZXB0X3Zpb2xhdGlvbigpLg0KPiANCj4gVGhpcyBzZXJpZXMgY2hvc2UgdG8gdXNlIHRk
eF9nbWVtX3ByaXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwoKSB0byBhdm9pZA0KPiBtb2RpZmljYXRp
b24gdG8gdGhlIEtWTSBNTVUgY29yZS4NCg0KSXQgc291bmRzIGxpa2UgS2lyaWxsIGlzIHN1Z2dl
c3Rpbmcgd2UgZG8gaGF2ZSB0byBoYXZlIGRlbW90aW9uIGluIHRoZSBmYXVsdA0KcGF0aC4gSUlS
QyBpdCBhZGRzIGEgbG9jaywgYnV0IHRoZSBjb3N0IHRvIHNraXAgZmF1bHQgcGF0aCBkZW1vdGlv
biBzZWVtcyB0byBiZQ0KYWRkaW5nIHVwLg0KDQo+IA0KPiBbMV0NCj4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzRkNjExMDRiZmYzODhhMDgxZmY4ZjZhZTRhYzcxZTA1YTEzZTUzYzMuMTcw
ODkzMzYyNC5naXQuaXNha3UueWFtYWhhdGFAaW50ZWwuY29tLw0KPiBbMg0KPiBdaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsLzNkMmE2YmZiMDMzZWUxYjUxZjdiODc1MzYwYmQyOTUzNzZjMzJi
NTQuMTcwODkzMzYNCj4gMjQuZ2l0LmlzYWt1LnlhbWFoYXRhQGludGVsLmNvbS8NCg0K

