Return-Path: <kvm+bounces-31804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83BF19C7D25
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42D40283DE3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 20:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615AC206E9A;
	Wed, 13 Nov 2024 20:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g7SJ9vtX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3354917DFE4;
	Wed, 13 Nov 2024 20:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731531096; cv=fail; b=NpNSsaBvPF/tVV+C962SEMv+PQFSQsGxsIvrhbEMqcy9OsAroBTsnK0WDvtLbh04zwVgKSJbEUxv/WrPdV16iSvXgDuD8URyf0za8dUUyKpZe4MhGcp2TXSX9oFmDnmUPW+WSLZARGITeGPgtri9yLbamG66DRH0lMoAgkbPL0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731531096; c=relaxed/simple;
	bh=+JHkZ78WQDyxJhiUm400RSNZruC9ySofjNe/rJFxbPs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UR+XvgXQOxpwkV0whWd4lKBOzK+UCAwl1VqgE/oGoNcHN/XqhWpQqdo+wFtYeYZUw4ydXcWrRqNNtNGHWIMizt7Hrv5mW7cZgnd9HgC+qOAxUAE78PwaGFP/WLXGSTxFGIK6bxWxvgX47B1tEpd8McgVEpgtEu7loA8hHF5QFNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g7SJ9vtX; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731531095; x=1763067095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+JHkZ78WQDyxJhiUm400RSNZruC9ySofjNe/rJFxbPs=;
  b=g7SJ9vtXanbzP7dS0rUOVL4ybaxLhFn3gEk1sZRXXM6fKhnaaFrk4Q/J
   LTTzkwAKytyYMe+WNIexMWeqqb0Z5mSquy2fa7OjXr7NJQCe6gFudOlMB
   eeTU1aZYlcARvZdmMHS0PkjrjB12JyECLBJAqc3g22o60rAGjrXE+GDWy
   CrQu118/Ih4JriNMQfOGRjzBN8doSFOjYyb/pVZQpRdHlgbt2KVNHJZ7m
   m5eckpVeR28SHhPEnaeXyWtWUglYLKtRTnUC1xjKwQXeSbAiENCDJ8xz5
   YnXT2mgAWWUGiqdLd2NMlL7WFACTKk7Iebow4igB1jrYt9aJKB0LC52Dg
   w==;
X-CSE-ConnectionGUID: r0yLF71aT1CiZm2GG0h/AA==
X-CSE-MsgGUID: OPCmTjavRbKQP39faQIQ7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42832548"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="42832548"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 12:51:23 -0800
X-CSE-ConnectionGUID: HfzWlYSAQTa+QEMONWTHtg==
X-CSE-MsgGUID: S2lAco6fTLeIfTvVrw7mpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="118808259"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 12:51:19 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 12:51:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 12:51:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 12:51:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vJqtEn4an8yi+z3OErRRRIZpKGO3QaFWZo28sRLhypL5DGC+KTznD5GpG/JnqhuLaqIAGHBLRJvVHMQdvolG0JaIFJnBZac5dCdnvhgqzCNDqa8U303iR6tJJMlY/KXszH3Kne3pGmU7G6pMWc/Q/e48HkTbeZ+7gsbtotzXy/nALWngvoKjbVtUWENYMVcpAbASOnYSUriQ4OigkN/DipKPk+v1cHoqAt7/vB3rYiYeyihqctSZydEqszZ8MHSK1qqLPd2oPPbd53AqXSS0G6AfxzfXCJ/Kq8wj4NSskRC3oBxtIFvvlohcRsHDLc8nA0GP/QGrdVc3OpCdjfk2YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+JHkZ78WQDyxJhiUm400RSNZruC9ySofjNe/rJFxbPs=;
 b=NC5DypE8mZlknX452FoHInGlQ7pmROUrSPaec0qtrZUhYwt9rdq4VN5z6HcS8PwMP810qjfs0bAgHlLx/0ygltMpahIDUz0WBWUuzdLDMVyHc1YyHom5fEyhzcWm1s80hAg00+sS9690iFRAH0UR8F5zOJmvXb8ewlOgDL2bupz+KCSqQ6JgxzMlxLC5uNh+fMr7HzhP6Oeff6c/tkLTlTX9wBvUI+wWLOC1hY3PlrAQ+AmXEqTFOItBIf17E4Gnpmp7Op+rvFx6MZffKQEylc1PtSK4duo02M0JA67PUcF3LMryy3P9RFJbwHhIkSYuoGN2A45ad/0sUzu3fYLurQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by IA0PR11MB7305.namprd11.prod.outlook.com (2603:10b6:208:439::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 13 Nov
 2024 20:51:13 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%6]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 20:51:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yao,
 Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
Thread-Topic: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Index: AQHbKv4rca7tZFwUNEOLKBi110Inj7K0baeAgAFX54A=
Date: Wed, 13 Nov 2024 20:51:12 +0000
Message-ID: <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
	 <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
In-Reply-To: <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|IA0PR11MB7305:EE_
x-ms-office365-filtering-correlation-id: 3da08996-d629-43e2-58d7-08dd0424e8e2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TkFwQ3NkU3ltZ25zQVUxYmJXamhHcGRWbHd2NTN2Znc3U2NOLzNzWTYva2x4?=
 =?utf-8?B?cTJBWEF3aHhYSTdneG9ZMnJuSzVmbERWaEVrM2U5WndzbFBkK1pHMUtyVGFn?=
 =?utf-8?B?OUF3YmtZdmRFNUMzWS92STlwZm1hQytPQURQa01vUmY4NE1BVHhGTXI5aEh4?=
 =?utf-8?B?eVBqN0V1VnhBS0tpTFZBZUE1Q0V4MFFpTFVNTnJXTkphcDJERGVwQklzUlNu?=
 =?utf-8?B?aTJ6TmxMbE9FaC9Nc0RQSm1uMlVjOGtIbWdCenVXbUU1STVRZTkxZTFFeW1D?=
 =?utf-8?B?R3c2d2hFbEpoQUltOTFrOXlUbGxONFVkdzkyUU80TVFWbndPNE96SzdjYnov?=
 =?utf-8?B?aFN6bVN4Y0xGTWtpeHdqcU1yWEZpbHIrN2xURUpCcXo0azVMaTdLalJYY3lG?=
 =?utf-8?B?bTBmNG5zQTJxZFZsWmVwSjhxNXNFUXgxcGJKcklKV2k1ZmFHd0pvNDB0ZVps?=
 =?utf-8?B?TC8zZ2hDR0Z2WFVSa3BrbksrRE1kNXEzUXNKd0FtRVd5eXo2SE1MZFF0d3R0?=
 =?utf-8?B?dnY5MXJ0SmRvZXd4VXRUeTh3eElMM0xNM0FOdjlCcm5jS0tra2xLdjNxeGVw?=
 =?utf-8?B?SW5weFBIS2RUKzByQ2hVUEh2ZFBMOVZnVXBzbjZCWXNqTzhlc0xPL3YxVm5l?=
 =?utf-8?B?eG9CQWhNb3dua3ZFeHpsWVNaQXlGNDRLU3NqSE5yUzUrUnIrMkhxZHZlTEsv?=
 =?utf-8?B?NjlObzhTOG1ySDl3UzdNcmtMTzFROGRwNWhTVm9RVzhBMW5mOW9sclJiajZV?=
 =?utf-8?B?YVpETmhJZStYNnlkZEpZdk45WURzSjN2K1dkWUw0aDJNMXNFWlQvd0ZVMXpi?=
 =?utf-8?B?NnNLOS9aR1VmZm1ZVm5maHNHNjc5QXR1Q0srVWlaQ3RkYnp5eEswbUhyQmZZ?=
 =?utf-8?B?czF5ajlvL3pFaXZuU2VDdjYzUjdVempuSjBjY0VkVngvN2UrMEFhcXVwVHVY?=
 =?utf-8?B?K0taaStPb1RxNDFwME5DZVNnTmtoQjUyY3pYNXpMWUtna2dpZ3E4VkJuMWZm?=
 =?utf-8?B?WUozdVp1bjVuRkVJSzZ3cWREL1BIRnRma1VTZkRsTmJIcVpaZEZQdk5GUlN2?=
 =?utf-8?B?VExEd2pZRDlRR2FtQ2JpZ1hicFdJc2hFVkd0MnY1VmIzS1h3b1RaZUJ5anBt?=
 =?utf-8?B?UVYzM0hVRVYvTTVTOE9IQnBURGtPd0lBRlN6M3BLSHVIUzRSSDRkZDVwaStj?=
 =?utf-8?B?UE95K3gzZmZjL0NkaHpqTGhiUmZkZGorc2lFRU1uL1gwTzdwYXJIamI0a1pK?=
 =?utf-8?B?Rm1ySW1BaTd4VmpiWHNWRm8vcEpJdGpPNVVsT1VrREFDWGV3d3YwbG9mV1BV?=
 =?utf-8?B?M3JkRW5CeXF2QXZCbitRNk1KODJPMFhKQVRuZ2pyMUlqWVR2aTJVekRjTjdo?=
 =?utf-8?B?U2JwSmllTXhiQkVqQWl2amczbGRZNVdBMjlIazN5TXZPUEpXWnFJbWx4V3Zz?=
 =?utf-8?B?T09vYUVJaEREVEFTVUtVMm55Q2thYzJoWmt2UWRPZmI0MnRMM1duVVV4SXpF?=
 =?utf-8?B?ZUl2UzhJWG5WaTR3YTdXNU5rbEp3YjdBWnpraTdUbkZUZ2FYU3hWdnZBaWxZ?=
 =?utf-8?B?dWlncU51ZE04Ykp0ditiN1BMdlJHRlprcHdKTy9kajBscE5pQjNaZjlmSlpS?=
 =?utf-8?B?Q1h3NVp5SzZRc1crNVN3NUo0VGtxNmo3N1BadTBTd204c0pLUVk3NDdDUWd5?=
 =?utf-8?B?cVZLQ25hWUdUQTFORjJRVUY3TVVxbEYzQ3FRY1FDZ1VlR25ORDNNQm1GRWFT?=
 =?utf-8?B?M2MvRDd1dnFTM3F4RWZieC85VmtEYTQ1Q1JsQ2RFRkw4c1dwMnNJdTdwZ1Fs?=
 =?utf-8?Q?61pddhjNjoCbyCKwUTkGueu9zRvDDEaJjMvr4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MEZZb2JKSVVOcjVpR1h3RjlIdGZ6WXNHYitlWkxsVGFDc2k3d2RIOEZRbUJ1?=
 =?utf-8?B?QURTNTJzU09vZ3lIRzZaU3UvdWJoRFdWZStGRXdzeDVBUTN0M3dscW5OR2l5?=
 =?utf-8?B?UDk2aU14TWxhYTZBVVc4SlRYMHR1dldwV01qaFR0Q0RjcTdhMFFNM0R1djIy?=
 =?utf-8?B?UzlJSmpvVldYRTJ0TFpzOTBFOFhSNC9CYmFvMDhJTnZNcU5XZUZRdEsrM3RI?=
 =?utf-8?B?MW1kWXhXTGRvWGQ3dzRUemN1Umw5YjNKUjhCVnFnd1RSajQ2RTU0QmdIMUtH?=
 =?utf-8?B?RlZvdTV0dWJidEJGU1Vob280VHZaY0pJaUgzS3BvUXBXQjNoQmFxVm1WSVN3?=
 =?utf-8?B?aDV4Q1V2OWJwN2NoNzhOYkgrZG1NV2RFUnNCOW1uRWx2VmxReUsyTkpQQWZV?=
 =?utf-8?B?dXRxME54bXpvZnd1aDB0ODMwQ0Jqc1VMVytHZ3FPTzRaYlc5djVJYmtqRGZ3?=
 =?utf-8?B?OU9OSlcwVzdOVHZsR0R3cGd1K1F2dW8rOVVSU09wM0dhY0hxdVROa1h5NE83?=
 =?utf-8?B?YVhiSU5OenpPaHNEMVpxVGZsSFE0Zm5DMkRybXhlMHp2VGpNcWdXWHRGRWV4?=
 =?utf-8?B?R1RIeW8yMXd6cmNBcm1rK095UlMrT2lLNHhUekQ1TGVQc00yZEVON1FyL3pk?=
 =?utf-8?B?VVMzblVBaXhISHNJSXJGeFVGK3NTYk5BTmtvdm5PdkwwNVZyR2MwOUJidXVF?=
 =?utf-8?B?SzNNdE5vZGxEdEduZFJKNEN1VlNid3NrSEJNR0FpY0VkbEhTODcrZmZpeU0z?=
 =?utf-8?B?b21mY2ZvUzZtdUdjUU5NSEkzR3YvdjlMNmN3Vmg4SDZpc0w4ZVRhVkh0c3Vy?=
 =?utf-8?B?V2xYTldCQmpqeU1yeEozdjd2em9zU1ljTG1qSVI2RVkyL1JaZ0d6cTZCaHhP?=
 =?utf-8?B?MXR5YUl4WFM2eGtiUksvS25GenNPWGZSbWo3aTBFRVdPMDNiNjNnTk9KSkwx?=
 =?utf-8?B?ZE9sL1ZDcVBHUXJhbm9xb0NsZGRPYlIzVmRYRWViTjczTGpRME9VYjlBQVpX?=
 =?utf-8?B?WXoyUmpiVjh6dWVpUGJQVFlyenZYc2RXR2lRcUZDNTIvOTc5QmQ4Y3UvNTBH?=
 =?utf-8?B?cnoyY2cySWZFNTBWaTBjTUlkb21jTkluMUo2T2NMNW5wdUYwZTZ3ZlErWFRh?=
 =?utf-8?B?ZU5GSUlOWlg1SVdzZ0pVY3pQQ3RKb3YvLzlTUlNpUkdwemNoZkxWaXJvSTZQ?=
 =?utf-8?B?S0FrMVdlelFvNzM5dFlhTUNVUk5JSjh0dGo5ZjJHdE9pRnF5cmpFTll1Q3k0?=
 =?utf-8?B?dEJhcWliMWswM3JpZFZqckp3V21wdmQwenpBQnhYZHVkZXFHeHZ2V3Y0Z3g5?=
 =?utf-8?B?TWZpSnJ4cEdNSDh5QnpDblV2TUNJaFFWaGZ1Slh6Lysvb05qOVBKV3dFYkhW?=
 =?utf-8?B?SXIzL2kvNXZIbUUxQTNtZTNWKzU4Mm42TmhveTJDRExzVzVJVXRPVUloVjhO?=
 =?utf-8?B?aU5WaTIzY080RzZzbjU1NEF0SldySGxqZXJmVjYxT1FBZ1NSM3I5NWhZUWgz?=
 =?utf-8?B?aUJQM2dqMUQ2d24zcFBvY25kWkpINlNZRnJIOUZqY1Iwemd4cDB5bUt2QW9C?=
 =?utf-8?B?TmZMSjdwYi9FNElyVDVsK29PWEJlRHVGZElvOXNGbG1QUEtyM2VQQm9ReUtR?=
 =?utf-8?B?TjdCZWVDM2hwb2h3dnVQN0RRcHhJVUd6am4wVnZId2V5Sk5wcU5pcnc0MmlH?=
 =?utf-8?B?NFF5M3AwR1hqRGw4OU5hK2FvbkE4Vzh2Q0x2eWZLYXc4bk1tY1RrdE1LOFpE?=
 =?utf-8?B?Qm5XY2cxUnFnVTVYbTQ3ekdiSkVDcUZCN3E4TGZFbnk3T2ZMa2I3MWRaNm0r?=
 =?utf-8?B?aVRWV0xSbGpkM01vTU1GV0FreTNJN3RrZkRMdDQwVElTTTZpZ2VLemFsV0Zt?=
 =?utf-8?B?NU84SUZSbmIvdnRiaHlsYWV1MG1UUlhWZlNFaERnWjEwcStoQk0za2VSb1NI?=
 =?utf-8?B?eHkwRjFtMkNvNU01M2RjbGdHd1A3a0U5QmcwNjNWeWFEeWdMaTdsc0trcDRN?=
 =?utf-8?B?ZVJEbXhxZEdId0VETmhHajZTaDZWZVRyUS9hNGZkeUREOVRYMFJBa09yQjEw?=
 =?utf-8?B?RXozRzNzRTBSZ1VhOVk2b2l4N1ptTG9ZdWVDd2VXUmJ5OU9SdDk4RnkzVUx3?=
 =?utf-8?B?MzVwdkd6ZlQzK3djcVVxMTBFSnFlL0FEcFUvQVlaUTViUGtQaVpkMzR3Kzls?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D203C0169C25D74D9058D9E62DB2AE39@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da08996-d629-43e2-58d7-08dd0424e8e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 20:51:12.8789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pmItrnMWBjjlA8Yg75/HR6Nb6KCaoA0Cl2jgNM2y+oMd/PWuxyiyabnQ+u+IraOyj52vl+LCJgb6gd4TAjJOqq62jkF6UoEK/WT4f+2ZhjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7305
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTExLTEyIGF0IDE2OjIwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
SWYgdGhpcyB3ZXJlLCBpbnN0ZWFkOg0KPiANCj4gdTY0IHRkaF9waHltZW1fcGFnZV9yZWNsYWlt
KHU2NCBwYWdlLCB1NjQgKnR5cGUsIHU2NCAqb3duZXIsIHU2NCAqc2l6ZSkNCj4gew0KPiAJLi4u
DQo+IAkqdHlwZSA9IGFyZ3MucmN4Ow0KPiAJKm93bmVyID0gYXJncy5yZHg7DQo+IAkqc2l6ZSA9
IGFyZ3Mucjg7DQo+IA0KPiBUaGVuIHlvdSB3b3VsZG4ndCBuZWVkIHRoZSBjb21tZW50IGluIHRo
ZSBmaXJzdCBwbGFjZS7CoCBUaGVuIHlvdSBjb3VsZA0KPiBhbHNvIGJlIHRoaW5raW5nIGFib3V0
IGFkZGluZyBfc29tZV8ga2luZCBvZiB0eXBlIHNhZmV0eSB0byB0aGUNCj4gYXJndW1lbnRzLsKg
IFRoZSAnc2l6ZScgb3IgdGhlICd0eXBlJyBjb3VsZCB0b3RhbGx5IGJlIGVudW1zLg0KDQpZZXMs
ICpyY3ggYW5kICpyZHggc3RhbmQgb3V0Lg0KDQo+IA0KPiBUaGVyZSdzIHJlYWxseSB6ZXJvIHZh
bHVlIGluIGhhdmluZyB3cmFwcGVycyBsaWtlIHRoZXNlLsKgIFRoZXkgZG9uJ3QNCj4gaGF2ZSBh
bnkgdHlwZSBzYWZldHkgb3IgYWRkIGFueSByZWFkYWJpbGl0eSBvciBtYWtlIHRoZSBzZWFtY2Fs
bCBlYXNpZXINCj4gdG8gdXNlLsKgIFRoZXJlJ3MgYWxtb3N0IG5vIHZhbHVlIGluIGhhdmluZyB0
aGVzZSB2ZXJzdXMganVzdCBleHBvcnRpbmcNCj4gc2VhbWNhbGxfcmV0KCkgaXRzZWxmLg0KDQpI
b3BpbmcgdG8gc29saWNpdCBzb21lIG1vcmUgdGhvdWdodHMgb24gdGhlIHZhbHVlIHF1ZXN0aW9u
Li4uDQoNCkkgdGhvdWdodCB0aGUgbWFpbiB0aGluZyB3YXMgdG8gbm90IGV4cG9ydCAqYWxsKiBT
RUFNQ0FMTHMuIEZ1dHVyZSBURFggbW9kdWxlcw0KY291bGQgYWRkIG5ldyBsZWFmcyB0aGF0IGRv
IHdoby1rbm93cy13aGF0Lg0KDQpGb3IgdGhpcyBTRUFNQ0FMTCB3cmFwcGVyLCB0aGUgb25seSB1
c2Ugb2YgdGhlIG91dCBhcmdzIGlzIHByaW50aW5nIHRoZW0gaW4gYW4NCmVycm9yIG1lc3NhZ2Ug
KGJhc2VkIG9uIG90aGVyIGxvZ2ljKS4gU28gdHVybmluZyB0aGVtIGludG8gZW51bXMgd291bGQg
anVzdCBhZGQNCmEgbGF5ZXIgb2YgdHJhbnNsYXRpb24gdG8gYmUgZGVjb2RlZC4gQSBkZXZlbG9w
ZXIgd291bGQgaGF2ZSB0byB0cmFuc2xhdGUgdGhlbQ0KYmFjayBpbnRvIHRoZSByZWdpc3RlcnMg
dGhleSBjYW1lIGZyb20gdG8gdHJ5IHRvIGV4dHJhY3QgbWVhbmluZyBmcm9tIHRoZSBURFgNCmRv
Y3MuDQoNCkhvd2V2ZXIsIHNvbWUgZnV0dXJlIHVzZXIgb2YgVERILlBIWU1FTS5QQUdFLlJFQ0xB
SU0gbWlnaHQgd2FudCB0byBkbyBzb21ldGhpbmcNCmVsc2Ugd2hlcmUgdGhlIGVudW1zIGNvdWxk
IGFkZCBjb2RlIGNsYXJpdHkuIEJ1dCB0aGlzIGdvZXMgZG93biB0aGUgcm9hZCBvZg0KYnVpbGRp
bmcgdGhpbmdzIHRoYXQgYXJlIG5vdCBuZWVkZWQgdG9kYXkuDQoNCklzIHRoZXJlIHZhbHVlIGlu
IG1haW50YWluaW5nIGEgc2Vuc2libGUgbG9va2luZyBBUEkgdG8gYmUgZXhwb3J0ZWQsIGV2ZW4g
aWYgaXQNCmlzIG5vdCBuZWVkZWQgdG9kYXk/DQo=

