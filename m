Return-Path: <kvm+bounces-51353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C795AF666B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 01:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A4174A5F10
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A1B25D219;
	Wed,  2 Jul 2025 23:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQqbSRG+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CE0236A9F;
	Wed,  2 Jul 2025 23:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751500349; cv=fail; b=bqYzEMy0bnYdvEym+1z8+kuHuTh7jpmEODniBwO+XZieToxAooCrEjNk60a9PUKL6r38kSl7KfniNIme/L51q3K9Bd0pS/s8yEg50PIKQnWwnP/Pee5sQieM2VT8VUYC0TzbvB8ScQUnKlclX6Z95tsegKEF8ub694BFfm/fTJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751500349; c=relaxed/simple;
	bh=/W8Gcq4NjZi1BKUk+VjJp7/yQdiH9jIctpTCoS6GeoI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gWpZ9qK+iKy7L4XmBWkDoWAxTmF9SwjPV/2a/dwVwUNXAMNR9oJgEAtzvaRe6EFeKJe6+/QB466rvMWNUI+Et2nZuQLMRU4KL8ywhVY2aAH/IOsZH3lZBX9T8EhnogmZzWBK/zhOzIwUUeL7GcE4b7Cj/Le6irVmILIHBb/z4qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQqbSRG+; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751500347; x=1783036347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/W8Gcq4NjZi1BKUk+VjJp7/yQdiH9jIctpTCoS6GeoI=;
  b=IQqbSRG+NR/KF4+Vn2+Q5aIQ6gz3C5vpRYWx81DKqw9AZox6JeXk4Zpe
   mkqtPugqUkHd8rPfzMaowK9JS8ObC48lnN6ezJNDe+kvmH7W9qnSv/Ep5
   FudL6CgRptI+53C3f8lXBxbzPpOYAWq+hcrTS0uqBEGd5Y7L8+D7NV8uG
   IFzqsKo9aDFdrgeE5NoRQEV+Bebmok25bT1GhEupSHtCn/+bJsdxkUiGv
   oZjDYP0uq/o59HMnTLRusJTfKbUSdr40YUAcgrlghPDBm7JWL2IO3/DoN
   85o4QdDt5YNvTKISTG/wJebClmObh2PN0MSgey3TismXWTU1+AjlQ47gz
   g==;
X-CSE-ConnectionGUID: oyoVAPahSKOhiluS/aHJBg==
X-CSE-MsgGUID: ReClcBkCRjuPC6HE8VcFbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="57490477"
X-IronPort-AV: E=Sophos;i="6.16,282,1744095600"; 
   d="scan'208";a="57490477"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 16:52:24 -0700
X-CSE-ConnectionGUID: UO7opna4QDCtg/gMRSVk7Q==
X-CSE-MsgGUID: KYeMrfNFRESDYodHHlXxkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,282,1744095600"; 
   d="scan'208";a="185152980"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 16:52:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 16:52:23 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 16:52:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.65) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 16:52:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XooswrG5cke4IcBQgLAiSyHV2fb847HxDWoVtIC69vGfi5Y0bsU6k4hKo7GNIDr+2dpYeNYI6PDNOcwF9Tr40smkLBccJThxupLHEGOVYvzYWvo0/PTJYDFLzBRuEqmX0K01hGfdRW7G49I2mYseW2R6OwLojLYn+kRST3oxK5o5VKN+ZpAWHFRldrCzGGxVKRlghKmrp8Pt9x7AccA/cUFjlvzEq/3JamvxQgvh4noLlBDnzFYjNy2/gOcvUbljLe0FhN5sJb3rQWpNxXOET/a4sjJEEESzuwwxKv1eavgZwbtKYnpI8qYB4rjfrRDP+X7YzKOhrNf7lyStbvKBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/W8Gcq4NjZi1BKUk+VjJp7/yQdiH9jIctpTCoS6GeoI=;
 b=yVpWIuiw/2TgHwV2lIfIrhK7G1uvoRRPZZwoP38TairIO8iRA0yVjw8SF3E+57adF8e9TeQajfbgyimfV4i0tRUxPyiUYqfiVsFBT02OJ5mlveI5FSC8/cq5AKa7u4kQieqC3CzDDoCn6F7dYeO6pJT0U/P4XuhxqPwebKSTyApuh4MciTADpCoAPQI1LEUvF/B9oHmy0/yLROxkjybj8vhRQ5zxI+U2tgGQDtN0yeVR5R4VsFPRkyd94tWGFSeQuYpUorIQRRZqDa2EWZ1nB6lA47W2VrzYblj4dXP0tRdppChJT8nVWiK0Jd4WspvfhgQbhqLdI2opkfry8wugTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5119.namprd11.prod.outlook.com (2603:10b6:a03:2d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.28; Wed, 2 Jul
 2025 23:51:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 23:51:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Miao, Jun" <jun.miao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQAgAB5m4CAALvngIAAXakAgAANiACAAXZuAIAAMLoA
Date: Wed, 2 Jul 2025 23:51:52 +0000
Message-ID: <a9affa03c7cdc8109d0ed6b5ca30ec69269e2f34.camel@intel.com>
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
	 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
	 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
	 <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
	 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
	 <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
	 <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5119:EE_
x-ms-office365-filtering-correlation-id: 5dcf69f8-a291-4745-1c99-08ddb9c36b68
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VlFtREZPRTFXTVNteXEzdmJlR2syS3BCZHhzR2ZDSm1yZnkrN1RGSjFQU3Zw?=
 =?utf-8?B?YXluYWZPSHg3bnY4OU5sVEdEVThlelRtVUZtcVNKcEhxRGlBZDZOOVI5NVBI?=
 =?utf-8?B?dWQxMklvYklOZDQza3NQR1RodGZxWThWVEtwbUIxL2VoZHRqQ2hXSWw2T2Jr?=
 =?utf-8?B?Q3FwcjIyejhmMXJ5SFNJRnhGKzE1Q0p0cmUvS1BlOXMvMjBDKzdUa3FvVjgx?=
 =?utf-8?B?dkU2VEdPRGhtdklReGxFQ0l5SzJ0Z3U5cDFacUR4aENIQXNWNmxZd0VubmZx?=
 =?utf-8?B?OWE2eFdVZGVYWjhzU0dyMjVXN0w2aWhmdFdSU0ZLWndTcGxWKzdGK0hqeFFt?=
 =?utf-8?B?Q0tmMXo5M0FhL2NvQjZTTktxTjFhM2xpRklVK0FkdTBLZ2d6ODlnRHM2dmtZ?=
 =?utf-8?B?c2NpbGN2SHpPWU55QkNJNElsc1VqRjNZVE1hck9yRDQwTnVMd3BmQjloVjlR?=
 =?utf-8?B?aU9WRWlRQUJKOWlYZEE0UitubGZ6VlQxNzlTYzV3cEM2T0hSUlBHdEx3Z0h6?=
 =?utf-8?B?ckdGZmdhVExFaE41bk1EaDdPNngrVlU4bzRCYmxMdjFxRzBGTjAyVHRWaVcv?=
 =?utf-8?B?UmY3RHhhUlJqOUhPU0w0Mm0rT0RKbnJ6eTdZcWtNaUdLQ0NFY0hVT0NVTTJT?=
 =?utf-8?B?UnFYS1hhSDQxSW1uRmNFK1ZaZ2hVS2I1UUdLbTZVY1FaUUpMdzBPOEJRMFRX?=
 =?utf-8?B?dnc4cHJyMGwybllObDZSNm5nYitHUmxXYlJ4UllQYkpGeXZJUEpOVUkwV3du?=
 =?utf-8?B?bDlvbWQ2b3JkUXcwWmdKa0h4MUlxNTNwUlg0ck9ReVB3bHBrdDB3Y3ZYVkVk?=
 =?utf-8?B?Kys4cndwVk9aWmNzZjh5UXNSZjJxT2tIbTg4N0JzSVBVRUt2dTFaSHpzT1lM?=
 =?utf-8?B?ZHBoN1V0SXNrM0tLcEpsRzVhczZhZCtZcUd6QUp2azJlY0RvQTBtZHY0UHJw?=
 =?utf-8?B?dGtOVzJQZU1tcFQ5RGN1OTRsZ2dkRWkzVVVtd3JybVZCVUY3bXVaaGFha3RC?=
 =?utf-8?B?ZTRqQ0lLU3RGRTdkdFJDL2Jya2RNQjRyaWlaTjJVZWV6WVY2ZW0xc0ZLQXVM?=
 =?utf-8?B?SnFZY1ZBRTc2Q1NXdzJUeHYzcG1Na0JvVS9jVEE0bUhaMmxsbmxVeFpxYzVK?=
 =?utf-8?B?OWNvaDdpdmVIT1MyaGt3UEhxMU5uOXN6V1dDOTVXYjVDcHBsSTdGeFVVY0dC?=
 =?utf-8?B?SnB4aWV1Y0hYWEJHWmlEa0cwM1VKWHcwRStCU1dzcU1razlWbjZnOXc2U0tM?=
 =?utf-8?B?cElZSEJ4eFprSkdoRS9iQWRoK0Zab0lUai94SHpHcTZmYmxUZEErZlRYTzFj?=
 =?utf-8?B?cmVBcmhBWEx0ZTNrVGRYUlE5UWlIUzhFWGcxeUcyNCsyRGlsYXA5WWtGQisv?=
 =?utf-8?B?czdpYk9YVThTdzJhUUhneWhqNm01NGVTZ0Nsa3NkaTNVeXdzN2dic1Qxbmsx?=
 =?utf-8?B?VERnZ09wRTNDZ09kTHpHK3BadkpnT0IvQnBMa1ZmYkI4Y1NZeWdzVm9ZRzBC?=
 =?utf-8?B?eDZSWTUyb2pVWUhMS1gyU3ZqYVNGYVZMbDN6OEhGWUcxNGZKYmJzUmd0NGxs?=
 =?utf-8?B?Rlk5ZGQ1NjlHbzNqdElHcjQycGdSS2RqVlQvWk9xOGFOUlRrYjBySHg0NS9r?=
 =?utf-8?B?NWxHUzdnM2FtaDJuRU5uWE9CVWxYUTVmdnRnd1dNd3VKMFYwalJpL0E2dzNF?=
 =?utf-8?B?VnQ3ak1pWG42RXBWN1oxYjhhemM2MFh0THVFYlRISjgyZitkS01wWTFlQ3FM?=
 =?utf-8?B?N0FXa1BZVTZKaytkb2NOWnNiZ1pJY1BpWFgrWmp0dzFlYmNnVElyM0NFYVFo?=
 =?utf-8?B?M0JVVGFzbmZmZVZQV3FzV1BoaG1SQ1c5VGh5c2NkcGY0b1MwUG9oY0NnR1l0?=
 =?utf-8?B?bHNzWjdESUk4NGxsYzR1eS9XWWlVOW5RUXVGWDFqM3dONWl0SUJOclRMRHRj?=
 =?utf-8?B?V1hNdm1DOEd6WkhOYm14d0VmRlFqcnc1bXhCeGYybjdOQzVuSEliZ0dNM3VX?=
 =?utf-8?Q?g3Jw0kcibBnIx9XQ8oiCyznCPAj+Ms=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWU5MHJ1OUhFbm1vQ2tpU0JKcGJ6RS8zV0pybXZldzZTUS9aMXNhWC9KNVZ6?=
 =?utf-8?B?SjhlTE5ES0ZCZXVlYlpOQUllK0ZBSDVXTTM1NG9wcjZqUGNCak9xcGtGUkhZ?=
 =?utf-8?B?di8wK29lR2ZFZXoxZld4RUVEZTJDQTBXQjR6ZHUrNEhhWHd5UHdSaFBoQXFT?=
 =?utf-8?B?Wi9uVTJqQUV1OGVQTU5Kd3JoaWtpQmdtS2J0UVl3Um5udXFCREwrYk5ON3I2?=
 =?utf-8?B?TlZFZnoxV01ZN21GZGpDN3VNMExtTldNZkRZU1M4RUFqTXRFN0RGK2dJVzZ2?=
 =?utf-8?B?QXBOQk43WjFtT0pPMGNteDJpcHJoWnN6OWt1cXp2N2RYNzV6SVZkRnJCVlNm?=
 =?utf-8?B?dUlwY1pvT05zYkY2OEJ3ODMxTXd6cW5udjRIcDZSVkVFUlFlcW5NTVF3cC9h?=
 =?utf-8?B?UXRZeUx0clhKUW0rMzc1ZWlIc3JDWGNOUXkrYmFxTUdYU21rWjcwaWdUQjlq?=
 =?utf-8?B?V1J5OHk5ZmNWSk5jSkZ0OUdxeDN1d3RUUDlhaENpanBSTklWUUxWV08wakdK?=
 =?utf-8?B?MjJTS3AzQnZ2VDRIUithd2dMR0NSelFYZ2orbThrVmV2RnlWK1hod0VoR1ZB?=
 =?utf-8?B?UDYvR3UzN2orbFIxM1E4cE1ycElianVaZjBRMGRBY3VGa01nVWd4VVAvdjZ3?=
 =?utf-8?B?VFc3T1V1T0hyckQ2Rm45Qk9MRE9HSVJmZk8zNGkrbmtwRUFyS0tRMFdPN0E4?=
 =?utf-8?B?R01JaXZLdmdhYUJaekk3djlNaDNlYjIzNGthTHVGa2xRNCtZOUZsY2IvaW52?=
 =?utf-8?B?Wk8yZjBLcmpkTVBvSlltRHRBeXFlTitZaFMxaTVpdU8rR1k2T1Nra3ZDVlFO?=
 =?utf-8?B?M0ppZE4vOXdQbXA4Uys3YUZFWitYMXdxSU5LSjd4L29aMzFSZThSU2twdk80?=
 =?utf-8?B?VEJHeHNEZGRFR09JMlBjTXlGZk1GeG9Vd3JTek5taTYrNEdjZm9vbDRqQjdH?=
 =?utf-8?B?RXRjME50d2dIeU1qVldXM3lZcURKZDdCRGVVMTlObm1wMUs2c1ZDTkFnNXRv?=
 =?utf-8?B?dTAwc1BRaWI3VkFlUmVOVVpodGEvRUJnbElhRnZzMDRZZThKcW8zaDRsTnJu?=
 =?utf-8?B?SHJYUFNZOHVIWmdHeVJST2RaUDF3dUVjWUpRZTUxMXFjY2xIUGZyc0Yvc1VV?=
 =?utf-8?B?Nk5pMXdzYTBYaGEzVjhEVndjcHdqWWVBNEF5SjlIRWN4M3RQNEJpckg4Z0F1?=
 =?utf-8?B?MytLcnBaQ1B6dy9ybVRJck51RGRXUFZSOWIyS2NDOFBjcElPY2ZIMXYyT1Uy?=
 =?utf-8?B?Vmwra0dtOFk1VnNkeUpwWnR3UnpyTVROdTkrb3oreWZnNEpOMjhmQWc5QnBh?=
 =?utf-8?B?UVZtcmU4dTFkQ2NMc1d1Z1hCeFZzOTV2Y1p1ZXZkVEJpWXNJdC9jd2s4SzN6?=
 =?utf-8?B?SVlQQUZRQmRETzVNK2YyNGJCZUo5QlRVTDBMOHdkaVRjbU8wZ2JKT0wxejl3?=
 =?utf-8?B?cDFnWjZXdmxQZ052eVdDTklSOFM5c1hNTitzby9rbFJEK0lmakNoMngweVQw?=
 =?utf-8?B?S0psWjlzU1k0NmZtclduVlEwZ2NjVVJZSzNUUCtBVkQxWmhuUWYwaldqc2p0?=
 =?utf-8?B?Ui94ZUQ5Q1RFL0JKT1VyZDdHUjRTMkxEOE9ZSVNzZlNTYXplaXR0aVQvTDE4?=
 =?utf-8?B?NDBoSUNxYVdFajdEUWxWUVZacEI2RU5nM2lxSDk2UEZXeEF4N3dzYXVVQ09z?=
 =?utf-8?B?NjVPK0JSN09udFpzRUZ0SSt3eDJtMTlzUS9hZzg3SWtLditEMlVubU9VdGRw?=
 =?utf-8?B?ZFZ5SEU2V3hCZEJzMXF0dTdGY1A1TzVLeUJGOXJDS2xKTWt2Z1k0RWxWckpF?=
 =?utf-8?B?WXNHOU83eTR0NWc3VEtVRXVhUnFCd0l6U3g2Y01nOEFQTjdVK2oweERVNHh6?=
 =?utf-8?B?VUVtRmFWY3lVdDdiQ1VYR0J5VnJvVXNpdFpyUlJnWnJBZm03YlBWVHVRL2Zw?=
 =?utf-8?B?amhwSjhTSVp2OVdFRlRJOGUyNE1CU2Rsa3ZlTWpGVDB2c3ZlSWpHczVCTnJp?=
 =?utf-8?B?YStydHkxR0h0Qi9Sb1BBb1lWVDVIaUM4V0gyYjZYRGFncGptTi8rdVRYZlk2?=
 =?utf-8?B?T0VKaktDd0xWYng0RkpBZVlmaXczVk5kblBaSGVzS3h3VGc0R0dwcjRSODho?=
 =?utf-8?B?K3BOVE5zWjdNYm1COGJDenlEU3RRSXNLeEtpaEJqRUpjeEMrNVVJMlhxai9v?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DD77A2C007B62449A7E2BC1B950D70B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dcf69f8-a291-4745-1c99-08ddb9c36b68
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 23:51:52.7782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oyztL2OUwU0fR4bhp27S6fXgLAwc2n2RvrzE2ltAsbpgfs28+TrJXtZ2JqyKNinPi3oF8u/0dH94zNSWftbPnzbx53xUAUOl03IFE2UY+Gw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5119
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDEzOjU3IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
ID4gDQo+ID4gSWYgYSBwb2lzb25lZCBwYWdlIGNvbnRpbnVlZCB0byBiZSB1c2VkLCBpdCdzIGEg
Yml0IHdlaXJkLCBubz8gDQo+IA0KPiBEbyB5b3UgbWVhbiAiY29udGludWVkIHRvIGJlIHVzZWQi
IGluIHRoZSBzZW5zZSB0aGF0IGl0IGlzIHByZXNlbnQgaW4gYQ0KPiBmaWxlbWFwIGFuZCBiZWxv
bmdzIHRvIGEgKGd1ZXN0X21lbWZkKSBpbm9kZT8NCg0KSSBtZWFuIGFueXdheSB3aGVyZSBpdCBt
aWdodCBnZXQgcmVhZCBvciB3cml0dGVuIHRvIGFnYWluLg0KDQo+IA0KPiBBIHBvaXNvbmVkIHBh
Z2UgaXMgbm90IGZhdWx0ZWQgaW4gYW55d2hlcmUsIGFuZCBpbiB0aGF0IHNlbnNlIHRoZSBwYWdl
DQo+IGlzIG5vdCAidXNlZCIuIEluIHRoZSBjYXNlIG9mIHJlZ3VsYXIgcG9pc29uaW5nIGFzIGlu
IGEgY2FsbCB0bw0KPiBtZW1vcnlfZmFpbHVyZSgpLCB0aGUgcGFnZSBpcyB1bm1hcHBlZCBmcm9t
IHRoZSBwYWdlIHRhYmxlcy4gSWYgdGhhdA0KPiBwYWdlIGJlbG9uZ3MgdG8gZ3Vlc3RfbWVtZmQs
IGluIHRvZGF5J3MgY29kZSBbMl0sIGd1ZXN0X21lbWZkDQo+IGludGVudGlvbmFsbHkgZG9lcyBu
b3QgdHJ1bmNhdGUgaXQgZnJvbSB0aGUgZmlsZW1hcC4gRm9yIGd1ZXN0X21lbWZkLA0KPiBoYW5k
bGluZyB0aGUgSFdwb2lzb24gYXQgZmF1bHQgdGltZSBpcyBieSBkZXNpZ247IGtlZXBpbmcgaXQg
cHJlc2VudCBpbg0KPiB0aGUgZmlsZW1hcCBpcyBieSBkZXNpZ24uDQoNCkkgdGhvdWdodCBJIHJl
YWQgdGhhdCB5b3Ugd291bGQgYWxsb3cgaXQgdG8gYmUgcmUtdXNlZC4gSSBzZWUgdGhhdCB0aGUg
Y29kZQ0KYWxyZWFkeSBjaGVja3MgZm9yIHBvaXNvbiBpbiB0aGUga3ZtX2dtZW1fZ2V0X3Bmbigp
IHBhdGggYW5kIHRoZSBtbWFwKCkgcGF0aC4gU28NCml0IHdpbGwganVzdCBzaXQgaW4gdGhlIGZk
IGFuZCBub3QgYmUgaGFuZGVkIG91dCBhZ2Fpbi4gSSB0aGluayBpdCdzIG9rLiBXZWxsLA0KYXMg
bG9uZyBhcyBjb252ZXJzaW9uIHRvIHNoYXJlZCBkb2Vzbid0IGludm9sdmUgemVyb2luZy4uLj8N
Cg0KPiANCj4gSW4gdGhlIGNhc2Ugb2YgVERYIHVubWFwIGZhaWx1cmVzIGxlYWRpbmcgdG8gSFdw
b2lzb24sIHRoZSBvbmx5IHBsYWNlIGl0DQo+IG1heSByZW1haW4gbWFwcGVkIGlzIGluIHRoZSBT
ZWN1cmUtRVBUcy4gSSB1c2UgIm1heSIgYmVjYXVzZSBJJ20gbm90DQo+IHN1cmUgYWJvdXQgaG93
IGJhZGx5IHRoZSB1bm1hcCBmYWlsZWQuIEJ1dCBlaXRoZXIgd2F5LCB0aGUgVEQgZ2V0cw0KPiBi
dWdnZWQsIGFsbCB2Q1BVcyBvZiB0aGUgVEQgYXJlIHN0b3BwZWQsIHNvIHRoZSBIV3BvaXNvbi1l
ZCBwYWdlIGlzIG5vDQo+IGxvbmdlciAidXNlZCIuDQo+IA0KPiBbMl0NCj4gaHR0cHM6Ly9naXRo
dWIuY29tL3RvcnZhbGRzL2xpbnV4L2Jsb2IvYjQ5MTFmYjBiMDYwODk5ZTRlZWJjYTAxNTFlYjU2
ZGViODY5MjFlYy92aXJ0L2t2bS9ndWVzdF9tZW1mZC5jI0wzMzQNCg0KWWVzLCBJIHNhdyB0aGF0
LiBJdCBsb29rcyBsaWtlIHNwZWNpYWwgZXJyb3IgY2FzZSB0cmVhdG1lbnQgZm9yIHRoZSBzdGF0
ZSB3ZSBhcmUNCnNldHRpbmcgdXAuDQoNCj4gDQo+ID4gSXQgY291bGQgdGFrZSBhbg0KPiA+ICNN
QyBmb3IgYW5vdGhlciByZWFzb24gZnJvbSB1c2Vyc3BhY2UgYW5kIHRoZSBoYW5kbGluZyBjb2Rl
IHdvdWxkIHNlZSB0aGUNCj4gPiBwYWdlDQo+ID4gZmxhZyBpcyBhbHJlYWR5IHNldC4gSWYgaXQg
ZG9lc24ndCBhbHJlYWR5IHRyaXAgdXAgc29tZSBNTSBjb2RlIHNvbWV3aGVyZSwNCj4gPiBpdA0K
PiA+IG1pZ2h0IHB1dCB1bmR1ZSBidXJkZW4gb24gdGhlIG1lbW9yeSBmYWlsdXJlIGNvZGUgdG8g
aGF2ZSB0byBleHBlY3QgcmVwZWF0ZWQNCj4gPiBwb2lzb25pbmcgb2YgdGhlIHNhbWUgbWVtb3J5
Lg0KPiA+IA0KPiANCj4gSWYgaXQgZG9lcyB0YWtlIGFub3RoZXIgI01DIGFuZCBnbyB0byBtZW1v
cnlfZmFpbHVyZSgpLCBtZW1vcnlfZmFpbHVyZSgpDQo+IGFscmVhZHkgY2hlY2tzIGZvciB0aGUg
SFdwb2lzb24gZmxhZyBiZWluZyBzZXQgWzNdLiBUaGlzIGlzIGhhbmRsZWQgYnkNCj4ga2lsbGlu
ZyB0aGUgcHJvY2Vzcy4gVGhlcmUgaXMgc2ltaWxhciBoYW5kbGluZyBmb3IgYSBIdWdlVExCDQo+
IGZvbGlvLiBXZSdyZSBub3QgaW50cm9kdWNpbmcgYW55dGhpbmcgbmV3IGJ5IHVzaW5nIEhXcG9p
c29uOyB3ZSdyZQ0KPiBidXlpbmcgaW50byB0aGUgSFdwb2lzb24gZnJhbWV3b3JrLCB3aGljaCBh
bHJlYWR5IGhhbmRsZXMgc2VlaW5nIGENCj4gSFdwb2lzb24gd2hlbiBoYW5kbGluZyBhIHBvaXNv
bi4NCg0KRG8geW91IHNlZSBhbm90aGVyIHVzZXIgdGhhdCBpcyBzZXR0aW5nIHRoZSBwb2lzb24g
ZmxhZyBtYW51YWxseSBsaWtlIHByb3Bvc2VkPw0KKGkuZS4gbm90IHRocm91Z2ggbWVtb3J5IGZh
aWx1cmUgaGFuZGxlcnMpDQoNCj4gDQo+IFszXQ0KPiBodHRwczovL2dpdGh1Yi5jb20vdG9ydmFs
ZHMvbGludXgvYmxvYi9iNDkxMWZiMGIwNjA4OTllNGVlYmNhMDE1MWViNTZkZWI4NjkyMWVjL21t
L21lbW9yeS1mYWlsdXJlLmMjTDIyNzANCj4gDQo+ID4gPiANCj4gPiA+ID4gV2hhdCBhYm91dCBh
IGt2bV9nbWVtX2J1Z2d5X2NsZWFudXAoKSBpbnN0ZWFkIG9mIHRoZSBzeXN0ZW0gd2lkZSBvbmUu
DQo+ID4gPiA+IEtWTSBjYWxscw0KPiA+ID4gPiBpdCBhbmQgdGhlbiBwcm9jZWVkcyB0byBidWcg
dGhlIFREIG9ubHkgZnJvbSB0aGUgS1ZNIHNpZGUuIEl0J3Mgbm90IGFzDQo+ID4gPiA+IHNhZmUg
Zm9yDQo+ID4gPiA+IHRoZSBzeXN0ZW0sIGJlY2F1c2Ugd2hvIGtub3dzIHdoYXQgYSBidWdneSBU
RFggbW9kdWxlIGNvdWxkIGRvLiBCdXQgVERYDQo+ID4gPiA+IG1vZHVsZQ0KPiA+ID4gPiBjb3Vs
ZCBhbHNvIGJlIGJ1Z2d5IHdpdGhvdXQgdGhlIGtlcm5lbCBjYXRjaGluZyB3aW5kIG9mIGl0Lg0K
PiA+ID4gPiANCj4gPiA+ID4gSGF2aW5nIGEgc2luZ2xlIGNhbGxiYWNrIHRvIGJhc2ljYWxseSBi
dWcgdGhlIGZkIHdvdWxkIHNvbHZlIHRoZSBhdG9taWMNCj4gPiA+ID4gY29udGV4dA0KPiA+ID4g
PiBpc3N1ZS4gVGhlbiBndWVzdG1lbWZkIGNvdWxkIGR1bXAgdGhlIGVudGlyZSBmZCBpbnRvIG1l
bW9yeV9mYWlsdXJlKCkNCj4gPiA+ID4gaW5zdGVhZCBvZg0KPiA+ID4gPiByZXR1cm5pbmcgdGhl
IHBhZ2VzLiBBbmQgZGV2ZWxvcGVycyBjb3VsZCByZXNwb25kIGJ5IGZpeGluZyB0aGUgYnVnLg0K
PiA+ID4gPiANCj4gPiA+IA0KPiA+ID4gVGhpcyBjb3VsZCB3b3JrIHRvby4NCj4gPiA+IA0KPiA+
ID4gSSdtIGluIGZhdm9yIG9mIGJ1eWluZyBpbnRvIHRoZSBIV3BvaXNvbiBzeXN0ZW0gdGhvdWdo
LCBzaW5jZSB3ZSdyZQ0KPiA+ID4gcXVpdGUgc3VyZSB0aGlzIGlzIGZhaXIgdXNlIG9mIEhXcG9p
c29uLg0KPiA+IA0KPiA+IERvIHlvdSBtZWFuIG1hbnVhbGx5IHNldHRpbmcgdGhlIHBvaXNvbiBm
bGFnLCBvciBjYWxsaW5nIGludG8NCj4gPiBtZW1vcnlfZmFpbHVyZSgpLA0KPiA+IGFuZCBmcmll
bmRzPw0KPiANCj4gSSBtZWFuIG1hbnVhbGx5IHNldHRpbmcgdGhlIHBvaXNvbiBmbGFnLg0KPiAN
Cj4gKiBJZiByZWd1bGFyIDRLIHBhZ2UsIHNldCB0aGUgZmxhZy4NCj4gKiBJZiBUSFAgcGFnZSAo
bm90ICh5ZXQpIHN1cHBvcnRlZCBieSBndWVzdF9tZW1mZCksIHNldCB0aGUgcG9pc29uIGZsYWcN
Cj4gwqAgb24gdGhlIHNwZWNpZmljIHN1YnBhZ2UgY2F1c2luZyB0aGUgZXJyb3IsIGFuZCBpbiBh
ZGRpdGlvbiBzZXQgVEhQJ1MNCj4gaGFzX2h3cG9pc29uDQo+IMKgIGZsYWcNCj4gKiBJZiBIdWdl
VExCIHBhZ2UsIGNhbGwgZm9saW9fc2V0X2h1Z2V0bGJfaHdwb2lzb24oKSBvbiB0aGUgc3VicGFn
ZS4NCj4gDQo+IFRoaXMgaXMgYWxyZWFkeSB0aGUgcHJvY2VzcyBpbiBtZW1vcnlfZmFpbHVyZSgp
IGFuZCBwZXJoYXBzIHNvbWUNCj4gcmVmYWN0b3JpbmcgY291bGQgYmUgZG9uZS4NCj4gDQo+IEkg
dGhpbmsgY2FsbGluZyBtZW1vcnlfZmFpbHVyZSgpIHdvdWxkIGRvIHRvbyBtdWNoLCBzaW5jZSBp
biBhZGRpdGlvbiB0bw0KPiBzZXR0aW5nIHRoZSBmbGFnLCBtZW1vcnlfZmFpbHVyZSgpIGFsc28g
c29tZXRpbWVzIGRvZXMgZnJlZWluZyBhbmQgbWF5DQo+IGtpbGwgcHJvY2Vzc2VzLCBhbmQgdHJp
Z2dlcnMgdGhlIHVzZXJzIG9mIHRoZSBwYWdlIHRvIGZ1cnRoZXIgaGFuZGxlIHRoZQ0KPiBIV3Bv
aXNvbi4NCg0KSXQgZGVmaW5pdGVseSBzZWVtIGxpa2UgdGhlcmUgaXMgbW9yZSBpbnZvbHZlZCB0
aGFuIHNldHRpbmcgdGhlIGZsYWcuIFdoaWNoDQptZWFucyBmb3Igb3VyIGNhc2Ugd2Ugc2hvdWxk
IHRyeSB0byB1bmRlcnN0YW5kIHdoYXQgd2UgYXJlIHNraXBwaW5nIGFuZCBob3cgaXQNCmZpdHMg
d2l0aCB0aGUgcmVzdCBvZiB0aGUga2VybmVsLiBJcyBhbnkgY29kZSB0aGUgY2hlY2tzIGZvciBw
b2lzb24gYXNzdW1pbmcNCnRoYXQgbWVtb3J5X2ZhaWx1cmUoKSBzdHVmZiBoYXMgYmVlbiBkb25l
PyBTdHVmZiBsaWtlIHRoYXQuDQoNCj4gDQo+ID4gSWYgd2Ugc2V0IHRoZW0gbWFudWFsbHksIHdl
IG5lZWQgdG8gbWFrZSBzdXJlIHRoYXQgaXQgZG9lcyBub3QgaGF2ZQ0KPiA+IHNpZGUgZWZmZWN0
cyBvbiB0aGUgbWFjaGluZSBjaGVjayBoYW5kbGVyLiBJdCBzZWVtcyByaXNreS9tZXNzeSB0byBt
ZS4gQnV0DQo+ID4gS2lyaWxsIGRpZG4ndCBzZWVtIHdvcnJpZWQuDQo+ID4gDQo+IA0KPiBJIGJl
bGlldmUgdGhlIG1lbW9yeV9mYWlsdXJlKCkgaXMgY2FsbGVkIGZyb20gdGhlIG1hY2hpbmUgY2hl
Y2sgaGFuZGxlcjoNCj4gDQo+IERFRklORV9JRFRFTlRSWV9NQ0UoZXhjX21hY2hpbmVfY2hlY2sp
DQo+IMKgIC0+IGV4Y19tYWNoaW5lX2NoZWNrX2tlcm5lbCgpDQo+IMKgwqDCoMKgIC0+IGRvX21h
Y2hpbmVfY2hlY2soKQ0KPiDCoMKgwqDCoMKgwqDCoCAtPiBraWxsX21lX25vdygpIG9yIGtpbGxf
bWVfbWF5YmUoKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtPiBtZW1vcnlfZmFpbHVyZSgpDQo+
IA0KPiAoSSBtaWdodCBoYXZlIHF1b3RlZCBqdXN0IG9uZSBvZiB0aGUgcGF0aHMgYW5kIEknbGwg
aGF2ZSB0byBsb29rIGludG8gaXQNCj4gbW9yZS4pDQoNCkl0IGxvb2tlZCB0aGF0IHdheSB0byBt
ZSB0b28uIEJ1dCBpdCB3b3JrcyBmcm9tIG90aGVyIGNvbnRleHRzLiBTZWUNCk1BRFZfSFdQT0lT
T04gKHdoaWNoIGlzIGZvciB0ZXN0aW5nKS4NCg0KPiANCj4gRm9yIG5vdywgSUlVQyBzZXR0aW5n
IHRoZSBwb2lzb24gZmxhZyBpcyBhIHN1YnNldCBvZiBtZW1vcnlfZmFpbHVyZSgpLCB3aGljaA0K
PiBpcyBhDQo+IHN1YnNldCBvZiB3aGF0IHRoZSBtYWNoaW5lIGNoZWNrIGhhbmRsZXIgZG9lcy4N
Cj4gDQo+IG1lbW9yeV9mYWlsdXJlKCkgaGFuZGxlcyBhbiBhbHJlYWR5IHBvaXNvbmVkIHBhZ2Us
IHNvIEkgZG9uJ3Qgc2VlIGFueQ0KPiBzaWRlIGVmZmVjdHMuDQo+IA0KPiBJJ20gaGFwcHkgdGhh
dCBLaXJpbGwgZGlkbid0IHNlZW0gd29ycmllZCA6KSBSaWNrLCBsZXQgbWUga25vdyBpZiB5b3UN
Cj4gc2VlIGFueSBzcGVjaWZpYyByaXNrcy4NCj4gDQo+ID4gTWF5YmUgd2UgY291bGQgYnJpbmcg
dGhlIHBvaXNvbiBwYWdlIGZsYWcgdXAgdG8gRGF2aWRIIGFuZCBzZWUgaWYgdGhlcmUgaXMNCj4g
PiBhbnkNCj4gPiBjb25jZXJuIGJlZm9yZSBnb2luZyBkb3duIHRoaXMgcGF0aCB0b28gZmFyPw0K
PiA+IA0KPiANCj4gSSBjYW4gZG8gdGhhdC4gRGF2aWQncyBjYy1lZCBvbiB0aGlzIGVtYWlsLCBh
bmQgSSBob3BlIHRvIGdldCBhIGNoYW5jZQ0KPiB0byB0YWxrIGFib3V0IGhhbmRsaW5nIEhXcG9p
c29uIChnZW5lcmFsbHksIG5vdCBURFggc3BlY2lmaWNhbGx5KSBhdCB0aGUNCj4gZ3Vlc3RfbWVt
ZmQgYmktd2Vla2x5IHVwc3RyZWFtIGNhbGwgb24gMjAyNS0wNy0xMCBzbyBJIGNhbiBicmluZyB0
aGlzIHVwDQo+IHRvby4NCg0KT2sgc291bmRzIGdvb2QuIFNob3VsZCB3ZSBqdXN0IGNvbnRpbnVl
IHRoZSBkaXNjdXNzaW9uIHRoZXJlPyBJIGNhbiB0cnkgdG8NCmF0dGVuZC4NCg0KPiANCj4gPiA+
IA0KPiA+ID4gQXJlIHlvdSBzYXlpbmcga3ZtX2dtZW1fYnVnZ3lfY2xlYW51cCgpIHdpbGwganVz
dCBzZXQgdGhlIEhXcG9pc29uIGZsYWcNCj4gPiA+IG9uIHRoZSBwYXJ0cyBvZiB0aGUgZm9saW9z
IGluIHRyb3VibGU/DQo+ID4gDQo+ID4gSSB3YXMgc2F5aW5nIGt2bV9nbWVtX2J1Z2d5X2NsZWFu
dXAoKSBjYW4gc2V0IGEgYm9vbCBvbiB0aGUgZmQsIHNpbWlsYXIgdG8NCj4gPiBWTV9CVUdfT04o
KSBzZXR0aW5nIHZtX2RlYWQuDQo+IA0KPiBTZXR0aW5nIGEgYm9vbCBvbiB0aGUgZmQgaXMgYSBw
b3NzaWJsZSBvcHRpb24gdG9vLiBDb21wYXJpbmcgYW4NCj4gaW5vZGUtbGV2ZWwgYm9vbGVhbiBh
bmQgSFdwb2lzb24sIEkgc3RpbGwgcHJlZmVyIEhXcG9pc29uIGJlY2F1c2UNCj4gDQo+IDEuIEhX
cG9pc29uIGdpdmVzIHVzIG1vcmUgaW5mb3JtYXRpb24gYWJvdXQgd2hpY2ggKHN1Yilmb2xpbyB3
YXMNCj4gwqDCoCBwb2lzb25lZC4gV2UgY2FuIHRoaW5rIG9mIHRoZSBib29sIG9uIHRoZSBmZCBh
cyBhbiBmZC13aWRlDQo+IMKgwqAgcG9pc29uaW5nLiBJZiB3ZSBkb24ndCBrbm93IHdoaWNoIHN1
YnBhZ2UgaGFzIGFuIGVycm9yLCB3ZSdyZSBmb3JjZWQNCj4gwqDCoCB0byBsZWFrIHRoZSBlbnRp
cmUgZmQgd2hlbiB0aGUgaW5vZGUgaXMgcmVsZWFzZWQsIHdoaWNoIGNvdWxkIGJlIGENCj4gwqDC
oCBodWdlIGFtb3VudCBvZiBtZW1vcnkgbGVha2VkLg0KPiAyLiBIV3BvaXNvbiBpcyBhbHJlYWR5
IGNoZWNrZWQgb24gZmF1bHRzLCBzbyB0aGVyZSBpcyBubyBuZWVkIHRvIGFkZCBhbg0KPiDCoMKg
IGV4dHJhIGNoZWNrIG9uIGEgYm9vbA0KPiAzLiBGb3IgSHVnZVRMQiwgSFdwb2lzb24gd2lsbCBo
YXZlIHRvIGJlIHN1bW1hcml6ZWQvaXRlbWl6ZWQgb24gbWVyZ2Uvc3BsaXQgdG8NCj4gaGFuZGxl
DQo+IMKgwqAgcmVndWxhciBub24tVERYIHJlbGF0ZWQgSFdwb2lzb25zLCBzbyBubyBhZGRpdGlv
bmFsIGNvZGUgdGhlcmUuDQo+IA0KPiA+IEFmdGVyIGFuIGludmFsaWRhdGUsIGlmIGdtZW0gc2Vl
IHRoaXMsIGl0IG5lZWRzIHRvDQo+ID4gYXNzdW1lIGV2ZXJ5dGhpbmcgZmFpbGVkLCBhbmQgaW52
YWxpZGF0ZSBldmVyeXRoaW5nIGFuZCBwb2lzb24gYWxsIGd1ZXN0DQo+ID4gbWVtb3J5Lg0KPiA+
IFRoZSBwb2ludCB3YXMgdG8gaGF2ZSB0aGUgc2ltcGxlc3QgcG9zc2libGUgaGFuZGxpbmcgZm9y
IGEgcmFyZSBlcnJvci4NCj4gDQo+IEkgYWdyZWUgYSBib29sIHdpbGwgcHJvYmFibHkgcmVzdWx0
IGluIGZld2VyIGxpbmVzIG9mIGNvZGUgYmVpbmcgY2hhbmdlZA0KPiBhbmQgY291bGQgYmUgYSBm
YWlyIGZpcnN0IGN1dCwgYnV0IEkgZmVlbCBsaWtlIHdlIHdvdWxkIHZlcnkgcXVpY2tseQ0KPiBu
ZWVkIGFub3RoZXIgcGF0Y2ggc2VyaWVzIHRvIGdldCBtb3JlIGdyYW51bGFyIGluZm9ybWF0aW9u
IGFuZCBub3QgaGF2ZQ0KPiB0byBsZWFrIGFuIGVudGlyZSBmZCB3b3J0aCBvZiBtZW1vcnkuDQoN
CldlIHdpbGwgb25seSBsZWFrIGFuIGVudGlyZSBWTXMgd29ydGggb2YgbWVtb3J5IGlmIHRoZXJl
IGlzIGEgYnVnLCB0aGUgZm9ybSBvZg0Kd2hpY2ggSSdtIG5vdCBzdXJlLiBUaGUga2VybmVsIGRv
ZXNuJ3QgdXN1YWxseSBoYXZlIGEgbG90IG9mIGRlZmVuc2l2ZSBjb2RlIHRvDQpoYW5kbGUgZm9y
IGJ1Z3MgZWxzZXdoZXJlLiBVbmxlc3MgaXQncyB0byBoZWxwIGRlYnVnZ2luZy4gQnV0IGVzcGVj
aWFsbHkgZm9yDQpvdGhlciBwbGF0Zm9ybSBzb2Z0d2FyZSAoYmlvcywgZXRjKSwgaXQgc2hvdWxk
IHRyeSB0byBzdGF5IG91dCBvZiB0aGUgam9iIG9mDQptYWludGFpbmluZyBjb2RlIHRvIHdvcmsg
YXJvdW5kIHVuZml4ZWQgYnVncy4gQW5kIGhlcmUgd2UgYXJlIHdvcmtpbmcgYXJvdW5kDQoqcG90
ZW50aWFsIGJ1Z3MqLg0KDQpTbyBhbm90aGVyICpwb3NzaWJsZSogc29sdXRpb24gaXMgdG8gZXhw
ZWN0IFREWCBtb2R1bGUvS1ZNIHRvIHdvcmsuIEtpbGwgdGhlIFRELA0KcmV0dXJuIHN1Y2Nlc3Mg
dG8gdGhlIGludmFsaWRhdGlvbiwgYW5kIGhvcGUgdGhhdCBpdCBkb2Vzbid0IGRvIGFueXRoaW5n
IHRvDQp0aG9zZSB6b21iaWUgbWFwcGluZ3MuIEl0IHdpbGwgbGlrZWx5IHdvcmsuIFByb2JhYmx5
IG11Y2ggbW9yZSBsaWtlbHkgdG8gd29yaw0KdGhlbiBzb21lIG90aGVyIHdhcm5pbmcgY2FzZXMg
aW4gdGhlIGtlcm5lbC4gQXMgZmFyIGFzIGRlYnVnZ2luZywgaWYgc3RyYW5nZQ0KY3Jhc2hlcyBh
cmUgb2JzZXJ2ZWQgYWZ0ZXIgYSBiaXQgc3BsYXQsIGl0IGNhbiBiZSBhIGdvb2QgaGludC4NCg0K
VW5sZXNzIFlhbiBoYXMgc29tZSBzcGVjaWZpYyBjYXNlIHRvIHdvcnJ5IGFib3V0IHRoYXQgc2hl
IGhhcyBiZWVuIGhvbGRpbmcgb24gdG8NCnRoYXQgbWFrZXMgdGhpcyBlcnJvciBjb25kaXRpb24g
YSBtb3JlIGV4cGVjdGVkIHN0YXRlLiBUaGF0IGNvdWxkIGNoYW5nZSB0aGluZ3MuDQoNCj4gDQo+
IEFsb25nIHRoZXNlIGxpbmVzLCBZYW4gc2VlbXMgdG8gcHJlZmVyIHNldHRpbmcgSFdwb2lzb24g
b24gdGhlIGVudGlyZQ0KPiBmb2xpbyB3aXRob3V0IGdvaW5nIGludG8gdGhlIGRldGFpbHMgb2Yg
dGhlIGV4YWN0IHN1YmZvbGlvcyBiZWluZw0KPiBwb2lzb25lZC4gSSB0aGluayB0aGlzIGlzIGEg
cG9zc2libGUgaW4tYmV0d2VlbiBzb2x1dGlvbiB0aGF0IGRvZXNuJ3QNCj4gcmVxdWlyZSBsZWFr
aW5nIHRoZSBlbnRpcmUgZmQgd29ydGggb2YgbWVtb3J5LCBidXQgaXQgc3RpbGwgbGVha3MgbW9y
ZQ0KPiB0aGFuIGp1c3Qgd2hlcmUgdGhlIGFjdHVhbCBlcnJvciBoYXBwZW5lZC4NCj4gDQo+IEkn
bSB3aWxsaW5nIHRvIGdvIHdpdGgganVzdCBzZXR0aW5nIEhXcG9pc29uIG9uIHRoZSBlbnRpcmUg
bGFyZ2UgZm9saW8NCj4gYXMgYSBmaXJzdCBjdXQgYW5kIGxlYWsgbW9yZSBtZW1vcnkgdGhhbiBu
ZWNlc3NhcnkgKGJlY2F1c2UgaWYgd2UgZG9uJ3QNCj4ga25vdyB3aGljaCBzdWJwYWdlIGl0IGlz
LCB3ZSBhcmUgZm9yY2VkIHRvIGxlYWsgZXZlcnl0aGluZyB0byBiZSBzYWZlKS4NCg0KTGVha2lu
ZyBtb3JlIG1lbW9yeSB0aGFuIG5lY2Vzc2FyeSBpbiBhIGJ1ZyBjYXNlIHNlZW1zIHRvdGFsbHkg
b2sgdG8gbWUuDQoNCj4gDQo+IEhvd2V2ZXIsIHRoaXMgcGF0Y2ggc2VyaWVzIG5lZWRzIGEgbGFy
Z2UgcGFnZSBwcm92aWRlciBpbiBndWVzdF9tZW1mZCwgYW5kDQo+IHdpbGwgb25seSBsYW5kIGVp
dGhlciBhZnRlciBUSFAgb3IgSHVnZVRMQiBzdXBwb3J0IGxhbmRzIGluDQo+IGd1ZXN0X21lbWZk
Lg0KPiANCj4gRm9yIG5vdyBpZiB5b3UncmUgdGVzdGluZyBvbiBndWVzdF9tZW1mZCtIdWdlVExC
LA0KPiBmb2xpb19zZXRfaHVnZXRsYl9od3BvaXNvbigpIGFscmVhZHkgZXhpc3RzLCB3aHkgbm90
IHVzZSBpdD8NCj4gDQo+ID4gQWx0aG91Z2gNCj4gPiBpdCdzIG9ubHkgYSBwcm9wb3NhbC4gVGhl
IFREWCBlbWVyZ2VuY3kgc2h1dGRvd24gb3B0aW9uIG1heSBiZSBzaW1wbGVyDQo+ID4gc3RpbGwu
DQo+ID4gQnV0IGtpbGxpbmcgYWxsIFREcyBpcyBub3QgaWRlYWwuIFNvIHRob3VnaHQgd2UgY291
bGQgYXQgbGVhc3QgY29uc2lkZXINCj4gPiBvdGhlcg0KPiA+IG9wdGlvbnMuDQo+ID4gDQo+ID4g
SWYgd2UgaGF2ZSBhIHNvbHV0aW9uIHdoZXJlIFREWCBuZWVkcyB0byBkbyBzb21ldGhpbmcgY29t
cGxpY2F0ZWQgYmVjYXVzZQ0KPiA+IHNvbWV0aGluZyBvZiBpdHMgc3BlY2lhbG5lc3MsIGl0IG1h
eSBnZXQgTkFLZWQuDQo+IA0KPiBVc2luZyBIV3BvaXNvbiBpcyBnZW5lcmljLCBzaW5jZSBndWVz
dF9tZW1mZCBuZWVkcyB0byBoYW5kbGUgSFdwb2lzb24NCj4gZm9yIHJlZ3VsYXIgbWVtb3J5IGVy
cm9ycyBhbnl3YXkuIEV2ZW4gaWYgaXQgaXMgbm90IGEgZmluYWwgc29sdXRpb24sIGl0DQo+IHNo
b3VsZCBiZSBnb29kIGVub3VnaCwgaWYgbm90IGZvciB0aGlzIHBhdGNoIHNlcmllcyB0byBtZXJn
ZSwgYXQgbGVhc3QNCj4gZm9yIHRoZSBuZXh0IFJGQyBvZiB0aGlzIHBhdGNoIHNlcmllcy4gOikN
Cg0KWWVzLCBtYXliZS4gSWYgd2UgaGF2ZSBhIG5vcm1hbCwgZWFzeSwgbm9uLWltcG9zaW5nIHNv
bHV0aW9uIGZvciBoYW5kbGluZyB0aGUNCmVycm9yIHRoZW4gSSB3b24ndCBvYmplY3QuDQo=

