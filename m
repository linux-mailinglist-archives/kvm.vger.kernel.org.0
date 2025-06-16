Return-Path: <kvm+bounces-49640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7012ADBD98
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 01:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 495CD1751EE
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 23:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016F422FAD4;
	Mon, 16 Jun 2025 23:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rx9N3n0A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC822ACF3;
	Mon, 16 Jun 2025 23:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750116479; cv=fail; b=CNSXuVpYxq5NDRnTXlPBV+7YdBxnHg7/AgdfMqkB5uBSe4tW59xgZlxXfNbrpnNZxYR5TAMuUHGojGwnDxCf5n66dDol439p0+zdEFQZdT6v02ACZ47oiD8/bSXKkwMK+zOwToMdExmhe5lgW9mWdnPe9+v9Uu0G06tX2q+qZUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750116479; c=relaxed/simple;
	bh=uVMajZeweSCfKBo3DylMatgTCuH89OG1R+7zJa+dJt8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tXIqrqVpVp3nuBD3ucU4sPP1Qq0joA4xHkK1O0WW/9Q8A/jKTxcI6Dbyqxt4z9Pfj4+YhNMasqvMxua0rG04qRGsfXj/DZrXE6pJhsa2PfYGXzIoPNmkZZUM4v0XDFQ16zM+0u4adPr2K9iQs1geXijQkwlL9WUJzy1tTLutrsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rx9N3n0A; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750116477; x=1781652477;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uVMajZeweSCfKBo3DylMatgTCuH89OG1R+7zJa+dJt8=;
  b=Rx9N3n0Av2rr0jNbQvVB1zVOHULwXsvcI5ARSpxRNeiZthzlnToJXV2U
   DzdGmr6+7BoZKQ/ghicr9QXnTp4bqAs2l06xGfIQ/52EzR8xU5kQHUcpB
   2poaaaUTXtSE6Yc3YQfh8aK7fo9mAOeZr1XAH4mdks1qAS5SgV7JK+NRw
   +bPf3IsBJMdAXTnLvar2TNUlpcW5AnNl64YfGulnglNVE1qC50o6izXZJ
   b93K5UqvsPhcp9ZlIe2g+5wRNejMv8wE6cINY7LUYfXxh7HQMHAkBJKyb
   nD3zypv1chQO4oJxpQbDbc8ykfZgUAEqV30TcBKJChkOtvAqA+Uhbg/SN
   w==;
X-CSE-ConnectionGUID: 0mAtFrWYQ7K0UBlvD6uWUg==
X-CSE-MsgGUID: l0QkVb7ORvWHSSQd7+fEwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="63624754"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="63624754"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 16:27:57 -0700
X-CSE-ConnectionGUID: 4UObtCYXQjq6k9z+xUWEGA==
X-CSE-MsgGUID: YeTQBeJeRjWFApjV8Pksaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="148499565"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 16:27:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 16:27:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 16:27:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.48)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 16:27:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aZMnwuSf94eyibXcOjVbkvarQ04thCTKrfBbcQ+Wp6PMVskixFfx9Lm22Hk47/Compsb3cnoo+JkOxDbgspl1ZySo1f4QdTTeo3ewLMtyqi792nYEJn1AIuRpRcCZqGQrUhYUP3UV86pZhX2Q6lxfVs992RMQBxLEDS20/mSmXI2NgeYvqV+I/J//XKis/QIaSQYHZR5/tV/tT/J1fPqFR4N2UnZxNnkSuWvqG29cT94WSXh9TTJSh+5FHh1P8NVi59ElinMO1L7ASPAaqhhIdvZX7uQ5r0H7wT6RK0AWtPjjpePHFOVzhFfaFZqZnF+qwMpgpR9TTj7vmIIwNRkYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVMajZeweSCfKBo3DylMatgTCuH89OG1R+7zJa+dJt8=;
 b=LXByufBFoAonsyZTbWH1BGaRmcaOZ3428oOKIMMzAbSdr+49bPJWA0bJ9OZDlboxO6slETNxyMK2k/jk5OLscubdrDRTiFw/48OkgepmepF2CYZ2Y7gCQa0nVAE6JvygHwT1QBbvOIbE/rbvfLosKUPLobyRQywjAkaH7s1KCnpgFCKS4gqHZAvjDVvJqHqEBkLd1A91wDwiKEk4xiSTwayJukbjGZezOo6+b4nNcwI++iv6j+5z/e68Lk/eN0AvhN65dedKHpDpxsxI9WWMDhCdMNY16Fi4jJrG2ZT4kxfWdTih9nZPB61s4W4qxqNDop13RjSrlWoLSeZU8sHXBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB7144.namprd11.prod.outlook.com (2603:10b6:510:22c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Mon, 16 Jun
 2025 23:27:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Mon, 16 Jun 2025
 23:27:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan"
	<fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAE2MQCAEJnCAIAA1Y8A
Date: Mon, 16 Jun 2025 23:27:49 +0000
Message-ID: <b7c62e054a72fce9c43a21201e9b9d1d42d5b9f7.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <diqzldq5j3j9.fsf@ackerleytng-ctop.c.googlers.com>
	 <aE/1TgUvr0dcaJUg@yzhao56-desk.sh.intel.com>
In-Reply-To: <aE/1TgUvr0dcaJUg@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB7144:EE_
x-ms-office365-filtering-correlation-id: 446c3016-6aad-4ba1-cb31-08ddad2d68cf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T05PV2lGMTQ1L09iZkc5aHBRRCs4ZzArUzNlUkYrVEJZTEU5V1FuWXdodG1L?=
 =?utf-8?B?Yk0yc1R5U09qcW1vZmJXa21YbW5mYTlGS3lpU3F5WllkeHpWMnBoM2IxM01T?=
 =?utf-8?B?ZmdVSWZBcUdha3p5akMzbDZBemowS0VJcjVQbjJ3TDZQdlFYZHBGZ2FCOUtN?=
 =?utf-8?B?NTRaNm15cHN2cXZLL21TVm9wQnBMTWZlSHVPZWpDMDI5cEQ1ZUNJNU01d0o2?=
 =?utf-8?B?NUdmbmxtQnllSG5tNy9EcUJZZWFmcHF6c0tEWEdYZnJta2xKeitpYUxKanVu?=
 =?utf-8?B?bEdGcm1PWXNBT29QeVZvR3lhQWRtdzdzYUVFQ290VTZRK0dKNEhGZVN4NHN1?=
 =?utf-8?B?L3cxU01CbnVzR3lTc2Zac2dWNzc1QkxvT0twTzBsSnpmUWtPTGVBUVhEcnp6?=
 =?utf-8?B?L2tBbHZ0MTk5OTJ3OHJJaFh1bFpCTUIwUWg5cWFZWmdVNUJ4bDRPeHl2c0Jy?=
 =?utf-8?B?UWtMTlFYaExXd0grUDdVLzdSaDVYQWRSTXZFYVp6R1ZTZGowblNVVERvNFRG?=
 =?utf-8?B?VE45amN6TmNWeWd2UjVkcmNhR1lXMUlQcFh3dzNKTU81MVRZTm9LYWxOaEpz?=
 =?utf-8?B?eWpMVTluV2oxN2ZRbnpCeGlycTRJSXNVd1VIQjc1Ym9MWmwwNFlJdmxEdG92?=
 =?utf-8?B?blhQRDRac1JwSWZzY2t4c281TkJOTS84SHBHYys1ck43OTlpOTBrY3VlZ0JS?=
 =?utf-8?B?QzA5NEJ4RXgvY21XNEpsUzcrZm40K3pyZUpkcjJQaDI2WlZ0VFdtaTVySzNz?=
 =?utf-8?B?L0JFMWc5QjBnOG80bXBzd2ozRGtQUU4xVGRmdjAzdGRCVW9GSHpkZ2s2N0VY?=
 =?utf-8?B?ZW5sOCtiY0srN0o0ZTJ4M3NKUHJRWHZsMlVvaGVPLytsTWcwakEyZk5pSkYz?=
 =?utf-8?B?RFFHVFMxb0lOd3R3cm9HcTVxNmw4WlhtYURHNTM2clFIM2JNQXIvM3FYMzlq?=
 =?utf-8?B?a2xGQ1pPeGZlV3hkenNvTFlsYmZYckN5VlhOVGNsR3A4d1F6N2FMUDREMWZk?=
 =?utf-8?B?T0YxVDdnMGVZdjJSQ3lvZVF3U0FBYlFMczBkRXBsdTk3Rm9hN01LekVXTlJ2?=
 =?utf-8?B?QWhmTnhRR0hwbEJOZWhGbGRoWlFRb0gzTEtjN1FPNHJTSEEyQldNaUVOMWhh?=
 =?utf-8?B?SjQ3RHBBZjV3djFKelZIeUp6Ulc0N2ttMW40Vll5WUYyV3VYYkVaeGdydWJw?=
 =?utf-8?B?c0RNVEl0SGZSeVQyQm1VOTZDWUo3SzZieS9JTFdONTRMWUxCRmZDbUo4TUJr?=
 =?utf-8?B?bFFKUXJBc0VURVhWNlMycmlUdXpieVdoa1RYeGhGOGUxcjJHMmNVcHNIWmtv?=
 =?utf-8?B?YndHbXlzdFJPNXdKWVBETUVmWEcyaFdoMk1oYlJkSTlzV0lqQThBamZyWXBZ?=
 =?utf-8?B?MTdKRSthZFlDejB5dmlvbGJCZGRPMlJWZlFIeXBZUFRURTByQVJYWW5nL3Z0?=
 =?utf-8?B?TzBONmlZR3lnZVlHK1BRL2dKUjQ0eGZIK3lGS2JaVVZqdjRaa3V4ZjM0ZDdt?=
 =?utf-8?B?V1hEckczQWdyc1dUc00yMlVUTlpUUmtaWmVUeS9LWVRPbmwyblRkTHhIOFh0?=
 =?utf-8?B?eU4vaGQ4QW5UcWUvL1hWaEJsSW1TY1hOTXQxMkJweGp1SktyTGNqa1RHN0N1?=
 =?utf-8?B?RnZuVG5BVGo4WUEzcFNrRTV6NFZLeXV1aHBSUkpoSzNnWVRocUJwMnVOUGVk?=
 =?utf-8?B?bFFIamRiS3BPVGRxS1YxZDJvLy9kZTJWMW9HYitJbTFMSlRQRjlkMlRycjJM?=
 =?utf-8?B?eElTdVdPenVUOHRCZmp4TjJDZmU3Ulhjd052L29SOGJqc3Y0Y3VjdjE0Zmh0?=
 =?utf-8?B?aW94NmJZVjk2YzZtMTAxT1RVOE5QK3g2T1k3di9ubUFJWVZ2bEVBb1JnZHZl?=
 =?utf-8?B?aEN2NFZmWElKckRpaE00ejRUeUNuaUZsY3p3c3JtbTdEMXRaT3puenc2REJ3?=
 =?utf-8?B?M3hLT3ZoMXVGQXJVWDdjK2N4bWV6WGNvQjFYZG5oUW9JcmJkYkhaRnZGL2t4?=
 =?utf-8?B?NFRKeUxSdUh3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVYyMTZhTlNmK0xyR0RRNHBRakszRHRKbytMaG9STWF5WXBXOUJKMmZGVDVr?=
 =?utf-8?B?NGVVZkVsNmVmRVlnTmJFVVFHZllKRG5KZW5NMmFxZmtzVEhNNTJ4WUJPaVda?=
 =?utf-8?B?a3cyTXgwbk9FcVlCVmwrbGF6MFBrOGJOWlZSbnRXNmtxQnJaL3hqWlFZVity?=
 =?utf-8?B?M0V5YVlLS2R5eVFPUHZtaU1TYUVjMXpOTjNqVUljUW1kV3BXWjdJWkNGRGlx?=
 =?utf-8?B?M1R2MUR5dlZnVU5ub0t6RWE4WWFIRERoejdaVTZYbkJYSFB4bndkUjJJWXox?=
 =?utf-8?B?bkhXdjlhcnNBQXIrMnhZbzZYQ3JhbzVRUk1ic3FYU1JjeVozdDNuVGFOdkFU?=
 =?utf-8?B?bGRmbmJOQTByaC9pRlhjQ0dnM2lKeCtwRWRpNVdQdUpmaUkwNlBaSEFnU0Ir?=
 =?utf-8?B?SWNmMTVYamFkbDZFQSs0RGJGU05KU3M0dGh2cUFjZnV4bVVXK1V1RjNVQkhB?=
 =?utf-8?B?ZHYyRkZ6UU9IRmdZY0xDQXVnNUdHYVYrSmJtVnN4NnNzUFlxRy9SNHlXdVhN?=
 =?utf-8?B?RDEvZElmWmE1d0Z0MEdoS2JnSjhNQTYzR1dXQUEyS1pKK2YzRkxCZWZXUXdN?=
 =?utf-8?B?d1hZNUROcGRwalArdDFmblVXWm14aDNyTTVXOFhWTjVqY3h2c1hnd3l0QlJo?=
 =?utf-8?B?YTJBN0FKaitRamFBYkI0MkNZbWlBVGszRzMyRy95TSt5b1FMWTZUeEJtN240?=
 =?utf-8?B?TThscHZ5MXpIN0VyZG9mSFN5R3JDa0hINmthUk96QzVFVnd5V1RZSTd6Y29i?=
 =?utf-8?B?M2doRFcrVkJEbGZVRUZXNFpXd3h4K2ZoZGRMY3lNcEZaeE5oSnFJR3pYT0Zh?=
 =?utf-8?B?UlY3MUdEZ2FCanAwb3pPbHJGcDdJdGJ5UTdyVkc2OWFSYlNNdnVwSk9TQ1A1?=
 =?utf-8?B?UGV4OFpkRWZlNW1PdDRNOWsyWXN3aVBjOXlnazU1b0d5SUdVZFZrSFJ1a0ZR?=
 =?utf-8?B?OGNWaHdoWFMrSEhhem9VL0hjZUVha3BEc1BtdmNuR1BiUVl6M2dRODl3cy93?=
 =?utf-8?B?MVFxWitac1BsS0FuaTJ2MVhXSnRRSzNMSjdzcUI4ZkRhZkMydURZMi92ZXdY?=
 =?utf-8?B?dzkwMnE4cHFKK2U0K2NjNEo4NmVEU0xCblJLbXpSSGNHWmMrUUtSQk9Reit6?=
 =?utf-8?B?dWcwMEJseXhYQVR5Z0k5SkFuSkVkNGtxL016MmlNZDhWdUJIRTd2ZWFDTm9p?=
 =?utf-8?B?ZWJSdVRBeGtCaHBPREdRRmY2ei9aTEYrckE4T3BPbmgyZFRRa1RQajhpQnpM?=
 =?utf-8?B?eWp4Tnp2Rm9ReTYrU2FwR1czRWk2blRSR3Y2ZmtpOFFCWVpwWkFhVkJmdkk5?=
 =?utf-8?B?ZG9URkljOTNOcGlmTlYzOE1yNEFQQlFFTEdwTU9XQkZzSGdJNitOTFpOUW1a?=
 =?utf-8?B?aVE0cUdiUmJFbXV5QitJNWgrU0ZRRjNsazBCd1Ivb25ReVBnTzRFUjlINTNL?=
 =?utf-8?B?MkhNRm90Z1ZLb0VFTTF0MWI4RndIMlFLOWh5Qy85c0ZnYmxkZTJQbGdrSUhy?=
 =?utf-8?B?MEg4Mjk3aEQrT2EzVGpCU2pncFpGRnhXdlBXL2IrTjk3eEcvK2NEdTlJdDJ5?=
 =?utf-8?B?d1ZnUTJ4cTZuVWZ0OXh6OFlGV0Rld3dITXZ0OTlPcFBDZzdjd0FBL2dhazN2?=
 =?utf-8?B?aEs3eFFFQit3VFFBc2VINktBLzBJbnV1WG9EQ3BNYmgyQkVhKytudmZUZFo3?=
 =?utf-8?B?NzhuOGNxZ3JyTmd4U0VxOEVtem1LZGlnZVBENU5CYzJhK0hwV2lWS2tMUTlh?=
 =?utf-8?B?NWNNNGZOYUlrcEpEN2k5MEJZUHZKUkhVWU1CSGZBZ3JYcktqSFU2c0FsQlpw?=
 =?utf-8?B?YnUrYWlRZjliaGNXN2dGVVFRa0N3M2V2RHBzM1hrOHhYR1BraHFldWRxWXBh?=
 =?utf-8?B?ZmpmYnZxM1lhd3FNTmtFVmt0Ums1ZEV5Z1lUOWtlZGtSVWcvOFA0K1EvVk95?=
 =?utf-8?B?QkJ1V09ML1dSa0JrNEs0bGIwanRZSnZhYTJmUllUemxEWUZVajBkQThmTG50?=
 =?utf-8?B?NzVpanhoWFNiUnF2WjB4Uk1VVjdNTDlQRHA1aDMvUXErK3JnZmNSbVZsQTVL?=
 =?utf-8?B?K1ZvRDhxSERrUm14V1IyOXpWd0xiYmJVZnhTL0lFUHdUMnY4VVBGekU5cnFj?=
 =?utf-8?B?cnA2OEVqY1RlM1FObERCYlVPOXF4K3BQemxlWnFqVVlFbG9YVjRtNVM4M1RL?=
 =?utf-8?Q?RL9CBUEImi7s2FDmcTdodWQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D640BB71E54454E87C59E464F50FA5C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446c3016-6aad-4ba1-cb31-08ddad2d68cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2025 23:27:49.9752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JNP14oTbPA2bdWIaSrhLhTpCkwsPaC6JDy3xoMLwmiPTR0IDIGUikhB9tNyX5ZmkUgVaifTK8OKmAmYbGE2XCYvAMZgu98e7nDLiYiG245E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7144
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTE2IGF0IDE4OjQzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBJ
dCBpcyB0cnVlIHRoYXQgYSBidWdneSBvciBtYWxpY2lvdXMgdXNlcnNwYWNlIFZNTSBjYW4gaWdu
b3JlIGNvbnZlcnNpb24NCj4gPiBmYWlsdXJlcyBhbmQgcmVwb3J0IHN1Y2Nlc3MgdG8gdGhlIGd1
ZXN0LCBidXQgaWYgYm90aCB0aGUgdXNlcnNwYWNlIFZNTQ0KPiA+IGFuZCBndWVzdCBhcmUgbWFs
aWNpb3VzLCBpdCdzIHF1aXRlIGhhcmQgZm9yIHRoZSBrZXJuZWwgdG8gZGVmZW5kDQo+ID4gYWdh
aW5zdCB0aGF0Lg0KDQpGb3IgdXBzdHJlYW0sIGl0J3MgZ29pbmcgdG8gYmUgcmVxdWlyZWQgdGhh
dCB1c2Vyc3BhY2UgY2FuJ3QgbWVzcyB1cCB0aGUgaG9zdA0Ka2VybmVsLiBVc2Vyc3BhY2UgaXMg
ZnJlZSB0byBtZXNzIHVwIHRoZSBndWVzdCB0aG91Z2guDQoNCg0KDQoNCg==

