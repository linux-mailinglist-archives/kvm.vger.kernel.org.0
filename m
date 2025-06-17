Return-Path: <kvm+bounces-49727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD69BADD418
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFF1A189F955
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E282EE5FE;
	Tue, 17 Jun 2025 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KVemupDr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45092ECE8F;
	Tue, 17 Jun 2025 15:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175603; cv=fail; b=MZPIuU2vlntpNepbSrmiW8WnKOM++i89FCedz7aROR4zNxdGuOoPVg9CNNRXZNv0RhjWWODxhg2EeyG5tT4bMn5fKdh5osZThASHnbXWyqild87pJTqQ4Rp87NRonehOXfm1imGMX/RMsftinYmpefKz0UoXxF3epbSMwUQTSbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175603; c=relaxed/simple;
	bh=K7buNEw9lbnqHtCpgvDws1z8JFNZsMOmEcWM9LdrALc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NS0CZ3NPc8+VDNYA3D8hn7f21JA4109JmKAli3vzSLtBH2Ssrvsnjf4xBUUD600HbCeSHeocONg6UaGiuXZGIhTpIsAXIGtL6wJkeTebIv0uHre56EirC/nlBHLYfHreEMqMollnIR1Ak0bofgE04k0G6dB8hG2dpNtctpbLI5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KVemupDr; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750175602; x=1781711602;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=K7buNEw9lbnqHtCpgvDws1z8JFNZsMOmEcWM9LdrALc=;
  b=KVemupDrcF/xArn6phbDKtZnuMqYaM5JvG5zMgpnkP6wRLxYg+X6usIg
   XJFfXUdxQCWwJMgZn7ys/3Ia/JNHgNy3Y7SJ3ciAg5raXqZjanGi15E0v
   JXcPBDhgdQrh6ZuSFni/VQp6epPfTgUtrb8gQO+kQSvWlVLz6m5cEUgqk
   GGPtcCLHI7b4dArvkmoqZIKBByJH76GmVV0nwg/2Xc5xrZt0nFaI30ryO
   dMCmF88kG+2VMceCxibNlb/WsLXxTwFX0Jz8v9JbtHUBTgf+BiVmn/9EN
   yhc+1XpjAynUIRFuR1HwI/IhsBUjZC2lKDjmlxSUXNhR+XhSZGOgbiIGN
   A==;
X-CSE-ConnectionGUID: 26R20GZHTwSiIQCHU+io2w==
X-CSE-MsgGUID: vMnricizT32Wh5h8Plj4/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="56039526"
X-IronPort-AV: E=Sophos;i="6.16,243,1744095600"; 
   d="scan'208";a="56039526"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 08:53:19 -0700
X-CSE-ConnectionGUID: z+/2K8p2Ruen2Ga2iKhaxg==
X-CSE-MsgGUID: FLXd363ZSP+slIWmC9wdkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,243,1744095600"; 
   d="scan'208";a="172069448"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 08:52:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 08:52:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 08:52:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 08:52:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U6kUPpTeVhTcPbQY0mEbc4XEVLsV9Q+miqzNdQ9BCcAKg3JusxShYKBBkXdyQmPbA7R7cTjEdxdduMl/QhtonN6ny+VZJkhFlu4cGQvCI58co12NX3im5+ZDqNvW5xwvVc7vXwfZULV5EqPc09CRR7ZcYPIWnRFFI4XIcIG640Is4Jtoru7M0ZUAzppUDy6jX9ukVV9uk5ghGTe39ZkIXyEdD7cCagaskwqXdHpHl95N5jEuNagn7qfOwkMsRPHeL3N8sOlgFjvF+py4jNOe6U0fth5fPcTBjlmfKsVBFyhLcZAxAPrE4WNttm+m/CpE4XVIL5DYpd2Ow08NJlSOVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7buNEw9lbnqHtCpgvDws1z8JFNZsMOmEcWM9LdrALc=;
 b=kNCozH/XG1wTVSoEZZt7/xBQQA2DLNnuZfuBI7VVcv1OAMZgVG2upvDw7UOMOrXgkoWwtGC93ScjRwJsITVPSwsQIq2p/edRbtvl/8TEgcePNWFV9HtqLyVVU26C1pL4wNu9PunsMSxBPawFtJ9KrfSAPDL9VUFUbTIMW5XEiEJqe4a/aYWItwrJqxYzS8qKTwEfblo5r/cPvkNpwAEqsgDsSIh8TqumyDfBw59jDR33loa0sEx6OEk59E/Hl5Fo0piKvu6iZ7XUn+4QH6hxNnnGSUDqIgnoeiTTvMwmOcNZZp33CBA4JL8LKLPyeki5Nd41ikIGzmskNP7RJKTTCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL4PR11MB8798.namprd11.prod.outlook.com (2603:10b6:208:5a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Tue, 17 Jun
 2025 15:52:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Tue, 17 Jun 2025
 15:52:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAA==
Date: Tue, 17 Jun 2025 15:52:48 +0000
Message-ID: <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
	 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL4PR11MB8798:EE_
x-ms-office365-filtering-correlation-id: ac2526fc-c260-468a-3f9c-08ddadb70204
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TTZocTJkVWZOV1dJaHdUNEk3a1haLytQNUxjR2I5NFFPNDJ4dDEvWEthaWNh?=
 =?utf-8?B?TzV0dWY0c254eXI1Z0RQY3YyeFptYzFKSG5UWEVmM2wzeW1CZ2liWHNFcS9x?=
 =?utf-8?B?cWVwSkhwK3JTOEdnU1cyM05zeU9VKzQyTXV3THplbitzMi9hd0QwdjNmelpV?=
 =?utf-8?B?SnZWYi9lcXJzSDZ5UEtvTTlRQVVrSkEyZ1pML2ZTTDg5UEJNZmN5bUJ3MGVI?=
 =?utf-8?B?NXI0VkNvT2VZaG85cGVzZks4dUhHcHZOd2hFVzJra3hoRVNhOGk5bTZZeFJp?=
 =?utf-8?B?dnIzb2FvVjAvWnAzVlIwYmhIOXdSYzhqdUprS2w4VWx2NHFCc0kyaDhpV0lE?=
 =?utf-8?B?ZXdKcGFvZ3Z2MmNhNVQwMW5UVjR3a2F0QWVXMkRDZkhMWk5qcGhPTjVyalRB?=
 =?utf-8?B?MkxGVFRvb3ptRzJWeGhsZ1lteVNzK2VjNnZ6OFBBRDBDQkYxdnVmdzlBY1oz?=
 =?utf-8?B?RVhabUdyODUzaG5uTHhRWTlGaU1Pb3JSN21UaHZmNnVYVDR4N3pkNHNIaTZt?=
 =?utf-8?B?MVJkbUxqTDdyOUMrakRUelRaTWkrbWxIa2V1WXZLdnhxUjdiVGtsRWF6NEtj?=
 =?utf-8?B?MEh3K0Q4QkJIL21UUDJMQWZxSUJVVGhFNzZOWTNCbk05eTBTMk1OWHJHaU4x?=
 =?utf-8?B?RDBhemFyVE5ESTErYUNydUN5NWNrcG5TTVhoNEtzQWJ0UFlZTGhuRzNPK3ho?=
 =?utf-8?B?MVFlUmxGS0l4aEwvbFhOdlFMZENpWWNXU3hoRnRzZmc2UnNMY3EyMFMzcVNP?=
 =?utf-8?B?TTVZVE16VmYzZndZeHdJRjVXWkpITnZuMXdrQUVUSUlvRUZOenFGYk9MY0hj?=
 =?utf-8?B?QzB3d0RnVVN6S05UV3EySmdZdGpsQ2lZTW1Vc1prR1dFNURXbVVGWGRWNit6?=
 =?utf-8?B?RFdWOHAzOXhGWkhVRUQrdksvaTBudmRYbUdnMStsempaQzJpMElRRzROa2la?=
 =?utf-8?B?a1RtaENmSXFuM09CWFcvR3V4dVNDL0h0L0xyei9aR3lNSThzSWZKNHRWV2Nl?=
 =?utf-8?B?c1RFblc2SXZMYVFlQ0J1MW1LR1VpTWdXSUI4Qnh1ZHBydFpqdTRyLzBkQmtE?=
 =?utf-8?B?c2VaL0JRaWpNMDRWNzFhZ1gyclAxMHNTU2Y3N2hDSTZCdG0rejhxZ2J1aHFD?=
 =?utf-8?B?cU41M0RUb1RRVy9RcC9WMEJYcE1wZW5MV1JBNmRyK2l0NkZxZjBSL3ZnK1NJ?=
 =?utf-8?B?ZGVSd2IxNDN4RDcwNERFYjg4d2xPdVZDa3Y5VWtPRjduYk9hT1VWeS9IVjZ4?=
 =?utf-8?B?T2kyYklSNGRyZkdrK0tqQUdadkRQRG4yM2tCNXBVcjYyWm5Icm5PbWRIZ2dL?=
 =?utf-8?B?Y05KMXVYQmQ0Wkw5MElPSkl1OEd4bnNWRVRSQ1hra1hUZkYwZlg2cS9vSWFE?=
 =?utf-8?B?R0pJdkV3TlVLRkVPZ3Q2MTdIMVMybkpHM29IUlEvYWRvY3A3TVZqL3F6Q3VP?=
 =?utf-8?B?SklOSy84L2c2Snp2a0EyejFlTUpnT29UUFRKb25KOGVxbFkwc2VFdno4RkF4?=
 =?utf-8?B?cGpBR1FZR1RZVStqL1JjKzR2bjZubjVONThGWC9qVmp1MkNSMUduRWVrUXJw?=
 =?utf-8?B?cm1rMjJQV2NQcUtGMWNDSkJsd1Q3MjlHYWhpbHJzQUJlUFdQOWpmaWllWStR?=
 =?utf-8?B?cWpnS1VLVnRLUVF6U1NWWVVIemJJek0xM0xycjZ5RUJKeHNXS2lieGhRWTBW?=
 =?utf-8?B?ekwzWmJxL0dYOTRmZzFNNjJyZWZFZkR4WFFYZXUvQ24wcmtxU0lnRHZUbHpi?=
 =?utf-8?B?UXRLTTJOanNVK0EyMmx6TVhOTDdRYkZyUSsrZTN3M28wNys2N0pzTlFLVUZw?=
 =?utf-8?B?VFZBY1NvbUJTVGJmVGxibm4rQVFLeHcveUlUQlJSblBOZmxxaFRDc0JKMDBq?=
 =?utf-8?B?MDFKR0ttdFhDbFVlN0tXc1JTOGFyV3JrU0NBWWtmaG45dDA0MWRWYWZTMzBq?=
 =?utf-8?B?b2lUMjdPVGZLaXh4VHdQekFtVGFUVlVwNXFiak5ic290bm0wMG9qVDFMOGhk?=
 =?utf-8?B?RExMWFdaYnZ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rys4SFlNbWE5bERNTTFyeWJFT3lJLzM4SU4yS25BN0szTVZRUzEzT2VySjc3?=
 =?utf-8?B?WWp2bHorVjlxMUFRd2JEbzlmeVpqa3BCVFpJTEN2R1poYld4MWo0Y1I3WEpC?=
 =?utf-8?B?dnhlTXMwRnpmeGpFWHp1UkZKM2xKTmdOUVB2UlN4WC9CeXJxdVhTNzIwa0xK?=
 =?utf-8?B?R2habk5MRlRPU2tReEplOWhmaTRZOVFXd1pPeVpabDIvTVNKeTJhbkowK2R5?=
 =?utf-8?B?Tk9jTWZabk80L0JKeHVFTE9uZGVTWWovdC8wOW9OdFQ5S2xaVE9pRm1wWkwr?=
 =?utf-8?B?Z2dBaHRoWG5acVo1MHcyN1VweUdYYVRONjh3NWYydUJuY2tXUzh6L1BtQXVN?=
 =?utf-8?B?cEZjSmEwTWlTVG5TbTJpVmtSNVhqTEhzeW5UZVdBOW81d1I4Mm5BUGYxOWlT?=
 =?utf-8?B?SkRkMm1BSDg0SzJMQ1E4YkhBbzNoSUswK05GcTNWbFNFT3VZWlloUXBXUjdh?=
 =?utf-8?B?M1kxbmJSOXVRbW55c0N2c0k1YmpXYlpMc1I4M2ZEZTFnYmxYSXMyMlo3bG1B?=
 =?utf-8?B?ZWNsdmlFbEI3QUFraU1ueDIyQnd1WDhRYUhYZ2wrRlMzSzRNQzRDOFc3RG50?=
 =?utf-8?B?YXFhNWtTa1hEU3NYbWQ4K2FvQm85TUNJQ3Npb1h3dWNTNTVsWnJPYytpNW9J?=
 =?utf-8?B?dm1yV1VqRTRTSlVRRjkvVWhnQWw4SG9rUmpQNGh5N0p5YTVJY00zRUYwdXh4?=
 =?utf-8?B?V290WUZSYWxxVFF4K2VWSERnZVFscGxsNEsrc0FyQzVWUEwrcEErUkU3cGhW?=
 =?utf-8?B?Tm5qWm0zOU44MUtOVW1BNXYvRktqd0I4ZmVrS1hxMzhWNlJFR094K2E2K1Z1?=
 =?utf-8?B?N3dvR3B1d2kxek1hVGpmN3V5YjVja1pQeUdJVHNvbE5ZYk5vMTFYYThZVEVC?=
 =?utf-8?B?bU9NOHpGNFdxSFIrTHU4SFh1L1FkTU9TemRaTVkwcGZUUFJEVW50Sk5DdzM3?=
 =?utf-8?B?Z0pBUTZ2bzF1alhqSnRTT1R5MThTZlh3bTBKMWRMcmN4eEJpdFB5WmxsUExT?=
 =?utf-8?B?RktCV09ibjMzcUg3ZG45TDBQamlkeXpvVXpweEdkY0VCUFcweXAvZkhDWWlU?=
 =?utf-8?B?ZE1GNERkU25kR3lKVkNvclFHbFYrNml4Z0p1a0lRYUZkZEtTNU5sTlBPMWto?=
 =?utf-8?B?T2RKcUZKeElSbUQ1TWtVM1JkT3FlOVhBZ0FqYWxNakdXb2hQMUpxUkQwQWl2?=
 =?utf-8?B?VktDZFl3WmZ0VXlYS3d5UFhLRC9uTDdCdFNLcVAyUUp1SE5NaEMvTEFrTDAz?=
 =?utf-8?B?OXRSeUpobU93RXUwMTZsU05TQVNjM3RUbXB0NTJ0RUJER21xTmpkcHhoT1lm?=
 =?utf-8?B?bitGSEdiTkh0S0V3RkxvWkhkNVM5SDVZUmhKTFBPcGNxNVlBRERCMTlIUmNW?=
 =?utf-8?B?cGkzVm96V05mOS9Wd3NKcmFadkJMQXdFNHhrc2ZHeU9rc0RyY3VOT3kxMzdp?=
 =?utf-8?B?a1U1VTkrZUdYdGNPOTZqakQwQTdNNm1Cb01UV210bVBGWk50V3F3eTJ6NG54?=
 =?utf-8?B?aC85TU9nM2FNM0RpeElKbUNJUmJhay8yd1BjT2pDeTJwN0d3ZkZpclpTNjRq?=
 =?utf-8?B?bUV2N3hIVnB6WDFScSsrOU1tZkRRbWZhNlVmWXpwdURmNjA2VUN0SWNsT3NS?=
 =?utf-8?B?dXFtVFhFMEVlNmw5cWxDKzNvT3lwaThjckphWjM2SzZuckRocGNNVkJDU2Nk?=
 =?utf-8?B?eWhzR1dUdFBEUDBEQVJoYWZzR2VhYWc5NkR4Qjc1QnVBTlNoeDg3UllibG5N?=
 =?utf-8?B?cVFtRDJkcXJPQm9vMnVXeEZxck5MRmZtU1lPQmZ3cjVJb25XQUtld1hZbnBF?=
 =?utf-8?B?MGNtemZkN09SYmsyaTRNeHNkaVpiVEhkQldRSDVwb285cHZQMlBMdjlxcnBw?=
 =?utf-8?B?cnl0aVhaanhKR0k4dHl1Y21MNU8rNG9NbUowUUJVTUs4TFZtOE9wYTFFMFRU?=
 =?utf-8?B?Mi82QWI3ZWFxTlVlNkc1QzV3dXMrRnZYclRlZFJxYmM2ZUlJUWY1N2pxZE0v?=
 =?utf-8?B?a2lOTzBZd1NVTDhDRGJBWWhXZkR4SVhMKytoL2RYNHpUdm0vYTdvdTVkc2l4?=
 =?utf-8?B?VXhNeCt6OFloRUJCdU8zOElyazFvL2k1WXBQUWtqU2RCTzI2OUdFUG5Cb0Y2?=
 =?utf-8?B?MmF5U3NsM0p2Vnk4VTN1ZDEyTkZqa2xYazdsRGorWUl3ZEoyVmcwOGVpazFF?=
 =?utf-8?B?emc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E610BBBFBF03E34DB9D82DA1CB666FA7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac2526fc-c260-468a-3f9c-08ddadb70204
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2025 15:52:48.0387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3QEognnVTU5cgw3kurfQAl7MqtQ4ZxR2K2uW4UOsrbYodD5MVW/uqyPF2r33yrC2ufSzkd33EBJC2ecDUri0QgfAeSDnzzQJvGkwXqs3Bu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8798
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTE3IGF0IDA5OjM4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBX
ZSB0YWxrZWQgYWJvdXQgZG9pbmcgc29tZXRoaW5nIGxpa2UgaGF2aW5nIHRkeF9ob2xkX3BhZ2Vf
b25fZXJyb3IoKSBpbg0KPiA+IGd1ZXN0bWVtZmQgd2l0aCBhIHByb3BlciBuYW1lLiBUaGUgc2Vw
YXJhdGlvbiBvZiBjb25jZXJucyB3aWxsIGJlIGJldHRlciBpZg0KPiA+IHdlDQo+ID4gY2FuIGp1
c3QgdGVsbCBndWVzdG1lbWZkLCB0aGUgcGFnZSBoYXMgYW4gaXNzdWUuIFRoZW4gZ3Vlc3RtZW1m
ZCBjYW4gZGVjaWRlDQo+ID4gaG93DQo+ID4gdG8gaGFuZGxlIGl0IChyZWZjb3VudCBvciB3aGF0
ZXZlcikuDQo+IEluc3RlYWQgb2YgdXNpbmcgdGR4X2hvbGRfcGFnZV9vbl9lcnJvcigpLCB0aGUg
YWR2YW50YWdlIG9mIGluZm9ybWluZw0KPiBndWVzdF9tZW1mZCB0aGF0IFREWCBpcyBob2xkaW5n
IGEgcGFnZSBhdCA0S0IgZ3JhbnVsYXJpdHkgaXMgdGhhdCwgZXZlbiBpZg0KPiB0aGVyZQ0KPiBp
cyBhIGJ1ZyBpbiBLVk0gKHN1Y2ggYXMgZm9yZ2V0dGluZyB0byBub3RpZnkgVERYIHRvIHJlbW92
ZSBhIG1hcHBpbmcgaW4NCj4gaGFuZGxlX3JlbW92ZWRfcHQoKSksIGd1ZXN0X21lbWZkIHdvdWxk
IGJlIGF3YXJlIHRoYXQgdGhlIHBhZ2UgcmVtYWlucyBtYXBwZWQNCj4gaW4NCj4gdGhlIFREWCBt
b2R1bGUuIFRoaXMgYWxsb3dzIGd1ZXN0X21lbWZkIHRvIGRldGVybWluZSBob3cgdG8gaGFuZGxl
IHRoZQ0KPiBwcm9ibGVtYXRpYyBwYWdlICh3aGV0aGVyIHRocm91Z2ggcmVmY291bnQgYWRqdXN0
bWVudHMgb3Igb3RoZXIgbWV0aG9kcykNCj4gYmVmb3JlDQo+IHRydW5jYXRpbmcgaXQuDQoNCkkg
ZG9uJ3QgdGhpbmsgYSBwb3RlbnRpYWwgYnVnIGluIEtWTSBpcyBhIGdvb2QgZW5vdWdoIHJlYXNv
bi4gSWYgd2UgYXJlDQpjb25jZXJuZWQgY2FuIHdlIHRoaW5rIGFib3V0IGEgd2FybmluZyBpbnN0
ZWFkPw0KDQpXZSBoYWQgdGFsa2VkIGVuaGFuY2luZyBrYXNhbiB0byBrbm93IHdoZW4gYSBwYWdl
IGlzIG1hcHBlZCBpbnRvIFMtRVBUIGluIHRoZQ0KcGFzdC4gU28gcmF0aGVyIHRoYW4gZGVzaWdu
IGFyb3VuZCBwb3RlbnRpYWwgYnVncyB3ZSBjb3VsZCBmb2N1cyBvbiBoYXZpbmcgYQ0Kc2ltcGxl
ciBpbXBsZW1lbnRhdGlvbiB3aXRoIHRoZSBpbmZyYXN0cnVjdHVyZSB0byBjYXRjaCBhbmQgZml4
IHRoZSBidWdzLg0KDQo+IA0KPiA+ID4gDQo+ID4gPiBUaGlzIHdvdWxkIGFsbG93IGd1ZXN0X21l
bWZkIHRvIG1haW50YWluIGFuIGludGVybmFsIHJlZmVyZW5jZSBjb3VudCBmb3INCj4gPiA+IGVh
Y2gNCj4gPiA+IHByaXZhdGUgR0ZOLiBURFggd291bGQgY2FsbCBndWVzdF9tZW1mZF9hZGRfcGFn
ZV9yZWZfY291bnQoKSBmb3IgbWFwcGluZw0KPiA+ID4gYW5kDQo+ID4gPiBndWVzdF9tZW1mZF9k
ZWNfcGFnZV9yZWZfY291bnQoKSBhZnRlciBhIHN1Y2Nlc3NmdWwgdW5tYXBwaW5nLiBCZWZvcmUN
Cj4gPiA+IHRydW5jYXRpbmcNCj4gPiA+IGEgcHJpdmF0ZSBwYWdlIGZyb20gdGhlIGZpbGVtYXAs
IGd1ZXN0X21lbWZkIGNvdWxkIGluY3JlYXNlIHRoZSByZWFsIGZvbGlvDQo+ID4gPiByZWZlcmVu
Y2UgY291bnQgYmFzZWQgb24gaXRzIGludGVybmFsIHJlZmVyZW5jZSBjb3VudCBmb3IgdGhlIHBy
aXZhdGUgR0ZOLg0KPiA+IA0KPiA+IFdoYXQgZG9lcyB0aGlzIGdldCB1cyBleGFjdGx5PyBUaGlz
IGlzIHRoZSBhcmd1bWVudCB0byBoYXZlIGxlc3MgZXJyb3IgcHJvbmUNCj4gPiBjb2RlIHRoYXQg
Y2FuIHN1cnZpdmUgZm9yZ2V0dGluZyB0byByZWZjb3VudCBvbiBlcnJvcj8gSSBkb24ndCBzZWUg
dGhhdCBpdA0KPiA+IGlzIGFuDQo+ID4gZXNwZWNpYWxseSBzcGVjaWFsIGNhc2UuDQo+IFllcywg
Zm9yIGEgbGVzcyBlcnJvciBwcm9uZSBjb2RlLg0KPiANCj4gSWYgdGhpcyBhcHByb2FjaCBpcyBj
b25zaWRlcmVkIHRvbyBjb21wbGV4IGZvciBhbiBpbml0aWFsIGltcGxlbWVudGF0aW9uLA0KPiB1
c2luZw0KPiB0ZHhfaG9sZF9wYWdlX29uX2Vycm9yKCkgaXMgYWxzbyBhIHZpYWJsZSBvcHRpb24u
DQoNCkknbSBzYXlpbmcgSSBkb24ndCB0aGluayBpdCdzIG5vdCBhIGdvb2QgZW5vdWdoIHJlYXNv
bi4gV2h5IGlzIGl0IGRpZmZlcmVudCB0aGVuDQpvdGhlciB1c2UtYWZ0ZXIgZnJlZSBidWdzPyBJ
IGZlZWwgbGlrZSBJJ20gbWlzc2luZyBzb21ldGhpbmcuDQo=

