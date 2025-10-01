Return-Path: <kvm+bounces-59236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 469AABAEE2E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 02:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F05E03B4B02
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 00:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA98D1DE2D8;
	Wed,  1 Oct 2025 00:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZKzpgwmC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C0319CC3E;
	Wed,  1 Oct 2025 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759278793; cv=fail; b=au/SJMLtovWsr4E1QufQ/O7D4Sdr1TlQ/c7peYXOI95HDSldCoLZCIpFjsGeCqH7KG2npnrQAfEsv1uI4OGNCaFNkkT8UG0Q2Dd1rxMlUQnXEw6pTHQyQz9jQM+Mf1F8FV99ERB7lq+AbYDfBcVk0Rx6Zj38l2Qf8mIGGu4pWug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759278793; c=relaxed/simple;
	bh=zhmJsUybgQQ2lczlW2bTUj5/VzbCzAMu5OwGnk0Qz50=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UKmwD2try85hKeNH0LStUc5yDJvMfXQ4VSgdLMTTXfkQhuVsj5MitUyz9vnS76GcezXFt8FANMMK/DBujT3pxSdeWsr0hAZQ+xH80RvKonjFzfBh+WW9ZGQ8A0l1u2zE+DVwp7+l++NBlyM92Oue4rzKCuQCZbcppJr3bIqZX8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZKzpgwmC; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759278793; x=1790814793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zhmJsUybgQQ2lczlW2bTUj5/VzbCzAMu5OwGnk0Qz50=;
  b=ZKzpgwmC5RviQUTIt036zDfsbztpTbEi/UrTnvHC06ZhmVjxE2UXx2Uv
   mwAU6/7fO22a02X0hhrWAOuWSOLRaj52tqfaqjGWcXnBFlaz/46X+IaUX
   qasNhz/TTeAv8+oB5dELo7aZKD4dl2p110ky1DzocInrV4Ak6bsn3zrWH
   TcxlgZFTtXiLMc5kCBloUUxj0JIxiedreORor537/XLMYe8o2iyl8SCRA
   wK59MxZOO9Zvh2HjQHjmlPQD7hPyDizI4NjvB9/z/cE8pgeWD2l2QXD5+
   lLYWfcdFXZVNalIgSii4bRp/++xRwyYJTbAiPM7fy2No0NcAYeVqYDN3X
   A==;
X-CSE-ConnectionGUID: 2oi4GsoZRKat+5xLeYzsxg==
X-CSE-MsgGUID: /CftkJYBRNaRBsTEDvT1aA==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="86993971"
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="86993971"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 17:33:12 -0700
X-CSE-ConnectionGUID: u05D5kXdS4WYnwvg8nPl1w==
X-CSE-MsgGUID: IDgzuIvyS1qaXF5g34gy3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="178698648"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 17:33:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 17:33:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 17:33:10 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.13) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 17:33:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=akjLB1CcFRPkQ1f8jJQDMMUmRTJpSv2h2GQkQcaYca2oACQBPy/rI5xcsJwXtHXL+oMYxzTQCAnu9AtwMZ4kCCEQaNFV7vpGc2UtOaiDd1+nD239eXuId6C7PxNJq03PMCQBNLUOTIGW88u9or3Xl/ftlKt3/PrA+dnlFTvItBnkk3N8X7lTuTMF5+DNhfjZYENi614zOg1pszFt655l2aJ9BwG+bz6eEBQ/JjJO/AevzZUjGqxqd7I1WdvhuDAIcgcKKJQAGoHwHRyDn1rf1ORN6a7x5WJJ9VT/7uDNmhIOh74jC+c3qItQ5GcAsWBvmovWke3lq8ARDETUit2uGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhmJsUybgQQ2lczlW2bTUj5/VzbCzAMu5OwGnk0Qz50=;
 b=uAsDQ/FMMhkc7zG/toIC44iOsjYcPFxV8GrU5tZxuqDXRq99ezP9E9iJD6dC6KHxo9NxUbPK7c3qbs+EprgrpGY3h8bHctVSvUGLBeRoiDIve2Nv5JQ/A1ewyvsNTZNz6KvcLsNL7DtJgjYyUU7kKqrkVvFcDvgKLx1J5TYw7LM1BOe4RfFRXbsnfg/Z7kwVXY2N+OWpUCCrKhCBM5zdKtoHBU8WJKLMLMjEB5VcOQ/DjaUOfDhvYbj5tWD9kv6MtuepkmQGMWN7W3KC9gsDaIalSmkOGE7k10Cke6yFS8nK+v5zkjoOZxjG/lHP+xOJ2UD3jmrptjL+PoB93h3vqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7177.namprd11.prod.outlook.com (2603:10b6:610:153::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 00:33:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 00:32:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Topic: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Index: AQHcKPM0eZqFwOSc+ES1GzTBQe5/Z7SaG0KAgAZudgCAAWNPAIAAI4MAgApzb4A=
Date: Wed, 1 Oct 2025 00:32:59 +0000
Message-ID: <ca13c7f77f2d36fa12e25cf2b9fb61861c9ed38c.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
	 <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
	 <e455cb2c-a51c-494e-acc1-12743c4f4d3f@linux.intel.com>
	 <7ad102d6105b6244c32e0daebcdb2ac46a5dcc68.camel@intel.com>
	 <19889f85-cfd0-4283-bd32-935ef92b3b93@linux.intel.com>
In-Reply-To: <19889f85-cfd0-4283-bd32-935ef92b3b93@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7177:EE_
x-ms-office365-filtering-correlation-id: 505a886b-4c5f-4574-5428-08de00821312
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MU16MWRIK1pzenV4akZpQW9iSU9VTmVlOWlZb1RHdjBSYWp3c3R4UVlCMVBZ?=
 =?utf-8?B?YkVFckdsRnFSN3NkTzZZVFVEaS9RcGx5NlhJVFhHcDhPb3A0UDUzVHBzSzE5?=
 =?utf-8?B?NzIzYVMrMStBeEFqT28vc0J1VGZVc3BWRGZCQWxWWS9qT3o1RDdMbHNxT2tN?=
 =?utf-8?B?TUxzckJCVkYrMHhZNmxRdU5xd3dOaWREZHkxS01aWmpsc0xobVYzdzJTbTJN?=
 =?utf-8?B?MjNEYjVEYWd0MVhJUnpSalZpUTlzU3BLOHZwNnJzYXp2OWs4OXFGQlhXRnJR?=
 =?utf-8?B?eDloY3JXTzZzcjJvbjhHdzFVdnFIRk9oeXVyU04wV3FnbDZFRTk3MHQ4cFZa?=
 =?utf-8?B?MFNWTHVTajNHall5YXR0c1cwM3FKRHV0ZktzdGh4U09tbzUzckN2akVUZ0RZ?=
 =?utf-8?B?RllzT3d3M0FVMVdJcFV3c3NUTVQ0TXNCYTA5bU5sQ1dwZ0s0NEpNcndTTjFE?=
 =?utf-8?B?eWM1ZE11NVFua3Q1NFZsWmZMaC9GS2tyNlpDQjlJbUZ3alR6blFBNlJQMzVn?=
 =?utf-8?B?NFNEZjR0MklOZkVJLzJXSUp6NmY2UkM0Q21YNHoxejhPWW5VSUN2NURMaFdp?=
 =?utf-8?B?NVVMWEU5ZURFakdjWEhYb2xnSWoyWE5WcWhQWGpQVzAvKzE4Zm5OcVREUnFr?=
 =?utf-8?B?TklsdkZ2bWZjZ3p6ek5XQXNINDlRWXZYcC82aEZZNHBrUmRBaDZnVGpJZ0Vs?=
 =?utf-8?B?VjA5OGsvQUZ4TkY0ZkRYdk5SejZsYnh1UHZ0UTlCY0I4S054WFo4UElJMGpK?=
 =?utf-8?B?dTdDN2h6NmQzZ0JCM0RnbEJQOGhtM0V0VVVub1pRaCtMM2dmcFhxKzRJYWt0?=
 =?utf-8?B?amcxZmpRdmNCRmF1cXdoOUhHWDQ1Ni9VZlpLOGNnejJjdjZ0bEx6dW4xQ0hJ?=
 =?utf-8?B?ckhVa2JLb0Npa3AxZWxhQ3RwakM2Y1hCck5iY2tBQ3NDeHFlc3RGZnRPRDg4?=
 =?utf-8?B?Q2VTQ2kwaWQzVE05M1BuditjNHdPTmZMQ1BlVEVxeW85OXhUOGpPU0xXQk9N?=
 =?utf-8?B?bDNhMGRHeXpMaldEekRJcDQ1UHgySERKUjdtNGZKN2gydXBhVFdZN2pmeUhp?=
 =?utf-8?B?RXY3QnYzMjNxUjEyL254UXh0T3UvMk5iQ1dDTzc2WE0zMXBCdlRnc1hjclVX?=
 =?utf-8?B?L1lOaXVUbFFQNzJ6R3RSeVMwOW9ydDhERGlJMXdsZzFHeVllL3duZTc0b3o3?=
 =?utf-8?B?OTRPNld5WUtwN0NpbHdrTnh0ZktiM3BxbXpvTGwzMzVZbXNhYzI1QVZKdkt5?=
 =?utf-8?B?bEZ4VjlIeUx2aUtnMlhMbVZMWUdIRk14bWo4a0NIcm83RC9tbUh2dGZST3Nj?=
 =?utf-8?B?WVg3ZHB0dFltWTFrR0dvVWgrOUdOeElVRVFjYmVFOGhXaTdIMG42ZFVUaENx?=
 =?utf-8?B?ejdLRDJRd0tOQWVWYldSTm9XTUhuem1GbWF0SWtldlVSTVpNTWhrRnZSTkVT?=
 =?utf-8?B?WE9mTGZFYWJYc2V5OWhRWlB2WDBOS0xqWkE1enpCQzh1dXkrcnB4aldFanF3?=
 =?utf-8?B?a0lLMmR3ckZHWlZOaFVQNHVMNjljR043cVo5Z0JhR0J4R2RKeWttTW8wL0l6?=
 =?utf-8?B?NGJYcFZyVWU5SG9uaFdjUGhrMUsrS1lvYjVxVWc4T0E2QU03VkNzczR6KzZu?=
 =?utf-8?B?SkhsdGpVWXYzeTVCdXVaM2Q2VnNXQkxJdTdadjNES25hbVF2eUNZWERnUCt2?=
 =?utf-8?B?OGlRRjd5UmFHekt6b2FpTEhxcTArSk1SNFY4cmdXcjJBMGVOdjZJYkdwZ3Z3?=
 =?utf-8?B?S0R0MzVFMnlIOFNZYmJwa2tDdUdzMjZ0N1JTeDYrL1gzWk5JUnFOMlRvamFR?=
 =?utf-8?B?NWR4ZEx2clkvcVZKS1Zsc25RakMrdEV3RW5YZXNsRW5tTWdLdW9ETHZUa1dG?=
 =?utf-8?B?N29KYnk0UU5XaG9CdWplbWxqalE1ZjlkU2NsbUMxQkhpMmVPSXhjWmZ5clhy?=
 =?utf-8?B?Q2VyaXkrRnlsdWhwSThxVGFNbnNwamxXSlc1Mk8xb2RJUUhhK0s2TjFucUhM?=
 =?utf-8?B?ajh3akt0R1A0NW1nNVdnRmN4Rm4vZmZPaThpRWs1Q01zbXJuejhrU0d2Rkxo?=
 =?utf-8?Q?9Bo5X7?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUhPaUNNUUZ2MUthd2hrMFB2anQ1SERZaTMwZmtMUFJtRzVKZFhYUFE1R3pu?=
 =?utf-8?B?Q0FGc2lkTlFDRWd2eVZUMzRoQXppN2Naejd2TGN6a0NoYzhkZUVhc3U1eUNJ?=
 =?utf-8?B?eW1Da0pEQTFObjQ0OE51OGorbmdmM0w0VkswQW5yWkxtMzJXdEtEY01sZ2RX?=
 =?utf-8?B?ZlptdmtUVlkxVVExenVjam5mN1BPLzRJdE9VVWUvSGVoSVhRRjJNL1Y4V1pL?=
 =?utf-8?B?cmV2Y2syS2QrdHA2Mm9Eay94QzZSM1o3YXIvcE05ZHVmeUI2M1lEMlNUZlBw?=
 =?utf-8?B?L1gwTW14eDhRSkQ3Rm1kaDdXbHJCdTNjWkF0ZDVnWWpuZDAreHZBMytrRjBN?=
 =?utf-8?B?Z1M0bGUyS2pqUjVKbDZSQ3ltSzJoalNLbHluUTdHUkJhQ0xqbE9ydmxmS2dq?=
 =?utf-8?B?QmE2dk5GOGpBcTZaT0VWV1E3aUlOeEtHSXY3cGx0VnFQeVJ1eEhyYXV1Zk1n?=
 =?utf-8?B?K3lUQ01WRnFhV2gzK1dVYlBnTzVjaThvQXpZWTJ5SldmR3pwbW1jWE0xS1ZO?=
 =?utf-8?B?M2szRnV0dE9JcDFreUZWaGJ6ZUJXUkc4U2FQdkVpMUlPSUx2OHhhZ2pTNTZU?=
 =?utf-8?B?QlZVb0FUb2pObHdGT1pKTnB4bDYzQ2VGMFpJckpDTlBRZytLdGhUQU1tZTZ6?=
 =?utf-8?B?RDlTNWtvZVlHSDRCVTErQ3JhVmNrWHFsS3VmR3I2U2FvMVRTTHVMdkNZS2ZP?=
 =?utf-8?B?dzVKYWJEeElqeWZzVnlBemNXa0J3SUZDb3ptQ0Frb09Sa2xQQXJ0cnFMbm96?=
 =?utf-8?B?Y1FoMXNJWlpCeDZvdmUxaFlMY05GdVBBS2gyR2pubnVjV2V1UC9FL0dVcXVq?=
 =?utf-8?B?RWdXb2NKeXN5N3laTVBZM2xsZmpkT2t2UFE1QXFIMFBHaERiTzFIUnM1Yk9V?=
 =?utf-8?B?a0ZoR0J2Y3hGMDlQSk8ycURQVDdJa1ZPS2FlYThMbkp2T2h1UVlqRHRaeTg2?=
 =?utf-8?B?N01weS9lSVhBb1NaRThxb2w5dC9JQjRaSXR3QmJ3azE5SVNnTmNEVXFLdTNN?=
 =?utf-8?B?STNKenlJSXlVRWRVR3ZKQThFOWFYZURyM2tNSmU1STJrZEZISHpiRUREazlO?=
 =?utf-8?B?Tzh2S1BMRWpqSzgvSGhqK21vL2lSa2IxWERYSXl0QUNTcVhaYzhjbUlkUTl5?=
 =?utf-8?B?MHRtRzhrSHJQeGJWY0pKb1RmUHRuOHJISFhTYnB6RFZnbkIzeFIvSjdOcDh2?=
 =?utf-8?B?U05KTUtSOVZTVjl1aVdGUkRHeHgzUGFoNmFSMXVnaFM0SlArTlNoQXB4N2hZ?=
 =?utf-8?B?U0FHVythS0lnUVBZcDhaMFdmOExPVEFVK28xVkRFQ0h0ajRMR2wrQ2FlUU1j?=
 =?utf-8?B?U0NYdTZ5TTBXNmFXRjNRSWgxcDZDMVZ0d3dDa3FmWUZEMGZPK0E5NjE1M2Rq?=
 =?utf-8?B?QThOakhoNkRGK2YvT2Nvb3J6ZkNDaUk1TjFTaGJHMFpLU1pUME5vV1VxNUwv?=
 =?utf-8?B?RHZ1eGlyZnFscnpDdGFRd2JBS1BLWE91SlVIRm1qYzFRdWptM0FMWmFBUzRR?=
 =?utf-8?B?d0RZbU5pUUx0SXhVL0tRRXhRTmZzVXJpSXFTMHV3ZDYyaUxYemExMDM3OGRZ?=
 =?utf-8?B?bUQ2RDNJOUxQbkd2WmRuZnU0R0MxcVNlWkwzdklsUnJITmFuSCs1NkFnZ3Y2?=
 =?utf-8?B?SGVCSDBJUHd6NmVYZkd5aDZPR3g1N2pvNmJnY0Z4Y2liQmx2UDFCanQ0NGpL?=
 =?utf-8?B?Uk9nWFoya29Dcngxc1JYdXE4R1NIdXB5Z1FDMGQzQ3hqTm1JVnkzczd3dDRm?=
 =?utf-8?B?N09rMWpFV1ZJdUZxK2dwWS9VTFVqTFl0TFZPY3BPWVRkTTRoQkovVXJrM0hy?=
 =?utf-8?B?RmlFc1FLem5SS01vSWlGdTBZYThXdlFIQkxlQ0xNeGNsYStqOXJuRXdUZXR6?=
 =?utf-8?B?cWVVYlk2bnNETDBBcThxczdheVFDMnJYUFNJTjdqVU0rVTBXSlRhMzZ2b3Aw?=
 =?utf-8?B?aTg3TjZzZFZKZE96aTdva284SlAwK21kM01vUytNTURQdmpaa0hPT1JJZlpD?=
 =?utf-8?B?bitWSnZ5R001VzIxRXNqbHhFdFg1L1JZc1pPTW8zOVVoN0x3TnRaYy91NURE?=
 =?utf-8?B?L3RTVzFPcXNLQlZRQW5aTXRYenRMN3hkaE5rVno3dFVVN3Job2cyNDNwdERJ?=
 =?utf-8?B?V2F5dU52RkwwYXhPTHRWUnd2MnJ3amkvZWFuVGNqY2pIbWNWT2ZSRXBhb3pM?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <607BD7C296622748B13951462658F747@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505a886b-4c5f-4574-5428-08de00821312
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 00:32:59.8704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DdvicMypDn0IgCoIgUQnxc4BMJhndbuQZv2+zJYs8LQH6WvihahV1uEa54k/nzK26W+H+YMcLgLl79CwiDsjr1asxAtYcWLsl95IsjyxFmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7177
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE2OjU3ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
VGhpcyB3aWxsIHJlc3VsdHMgaW4gQHN0YXJ0IHBvaW50aW5nIHRvIHRoZSBmaXJzdCByZWZjb3Vu
dCBhbmQgQGVuZA0KPiA+IHBvaW50aW5nIHRvIHRoZSBzZWNvbmQsIElJVUMuDQo+ID4gDQo+ID4g
U28gaXQgc2VlbXMgd2UgbmVlZDoNCj4gPiANCj4gPiDCoMKgwqDCoMKgIHN0YXJ0ID0gKHVuc2ln
bmVkIGxvbmcpdGR4X2ZpbmRfcGFtdF9yZWZjb3VudChQRk5fUEhZUyhzdGFydF9wZm4pKTsNCj4g
PiDCoMKgwqDCoMKgIGVuZMKgwqAgPSAodW5zaWduZWQgbG9uZyl0ZHhfZmluZF9wYW10X3JlZmNv
dW50KFBGTl9QSFlTKGVuZF9wZm4pIC0gMSkpOw0KPiA+IMKgwqDCoMKgwqAgc3RhcnQgPSByb3Vu
ZF9kb3duKHN0YXJ0LCBQQUdFX1NJWkUpOw0KPiA+IMKgwqDCoMKgwqAgZW5kwqDCoCA9IHJvdW5k
X3VwKGVuZCwgUEFHRV9TSVpFKTsNCj4gDQo+IENoZWNrZWQgYWdhaW4sIHRoaXMgc2VlbXMgdG8g
YmUgdGhlIHJpZ2h0IHZlcnNpb24uDQoNClRoYW5rcyBib3RoIGZvciB0aGUgYW5hbHlzaXMuIEkg
bGF6aWx5IGNyZWF0ZWQgYSB0ZXN0IHByb2dyYW0gdG8gY2hlY2sgc29tZSBlZGdlDQpjYXNlcyBh
bmQgZm91bmQgdGhlIG9yaWdpbmFsIGFuZCB0aGlzIHZlcnNpb24gd2VyZSBib3RoIGJ1Z2d5LiBD
bGVhcmx5IHRoaXMgY29kZQ0KbmVlZHMgdG8gYmUgY2xlYXJlciAoYXMgYWN0dWFsbHkgRGF2ZSBw
b2ludGVkIG91dCBpbiB2MiBhbmQgSSBmYWlsZWQgdG8NCmFkZHJlc3MpLiBFeGFtcGxlIChzeW50
aGV0aWMgZmFpbHVyZSk6DQoNCnN0YXJ0X3BmbiA9IDB4ODAwMDANCmVuZF9wZm4gPSAgIDB4ODAw
MDENCg0KT3JpZ2luYWwgY29kZTogc3RhcnQgPSAweGZmNzZiYTRmOWUwMzQwMDANCiAgICAgICAg
ICAgICAgIGVuZCAgID0gMHhmZjc2YmE0ZjllMDM0MDAwDQoNCkFib3ZlIGZpeDogICAgIHN0YXJ0
ID0gMHhmZjc2YmE0ZjllMDM0MDAwDQogICAgICAgICAgICAgICBlbmQgICA9IDB4ZmY3NmJhNGY5
ZTAzNDAwMA0KDQpQYXJ0IG9mIHRoZSBwcm9ibGVtIGlzIHRoYXQgdGR4X2ZpbmRfcGFtdF9yZWZj
b3VudCgpIGV4cGVjdHMgdGhlIGhwYSBwYXNzZWQgaW4NCnRvIGJlIFBNRCBhbGlnbmVkLiBUaGUg
b3RoZXIgY2FsbGVycyBvZiB0ZHhfZmluZF9wYW10X3JlZmNvdW50KCkgYWxzbyBtYWtlIHN1cmUN
CnRoYXQgdGhlIFBBIHBhc3NlZCBpbiBpcyAyTUIgYWxpZ25lZCBiZWZvcmUgY2FsbGluZywgYW5k
IGNvbXB1dGUgdGhpcyBzdGFydGluZw0Kd2l0aCBhIFBGTi4gU28gdG8gdHJ5IHRvIG1ha2UgaXQg
ZWFzaWVyIHRvIHJlYWQgYW5kIGJlIGNvcnJlY3Qgd2hhdCBkbyB5b3UgdGhpbmsNCmFib3V0IHRo
ZSBiZWxvdzoNCg0Kc3RhdGljIGF0b21pY190ICp0ZHhfZmluZF9wYW10X3JlZmNvdW50KHVuc2ln
bmVkIGxvbmcgcGZuKSB7DQogICAgdW5zaWduZWQgbG9uZyBocGEgPSBBTElHTl9ET1dOKHBmbiwg
UE1EX1NJWkUpOw0KDQogICAgcmV0dXJuICZwYW10X3JlZmNvdW50c1tocGEgLyBQTURfU0laRV07
DQp9DQoNCi8qDQogKiAnc3RhcnRfcGZuJyBpcyBpbmNsdXNpdmUgYW5kICdlbmRfcGZuJyBpcyBl
eGNsdXNpdmUuIENvbXB1dGUgdGhlwqANCiAqIHBhZ2UgcmFuZ2UgdG8gYmUgaW5jbHVzaXZlIG9m
IHRoZSBzdGFydCBhbmQgZW5kIHJlZmNvdW50DQogKiBhZGRyZXNzZXMgYW5kIGF0IGxlYXN0IGEg
cGFnZSBpbiBzaXplLiBUaGUgdGVhcmRvd24gbG9naWMgbmVlZHMNCiAqIHRvIGhhbmRsZSBwb3Rl
bnRpYWxseSBvdmVybGFwcGluZyByZWZjb3VudHMgbWFwcGluZ3MgcmVzdWx0aW5nDQogKiBmcm9t
IHRoaXMuDQogKi8NCnN0YXJ0ID0gKHVuc2lnbmVkIGxvbmcpdGR4X2ZpbmRfcGFtdF9yZWZjb3Vu
dChzdGFydF9wZm4pOw0KZW5kICAgPSAodW5zaWduZWQgbG9uZyl0ZHhfZmluZF9wYW10X3JlZmNv
dW50KGVuZF9wZm4gLSAxKTsNCnN0YXJ0ID0gQUxJR05fRE9XTihzdGFydCwgUEFHRV9TSVpFKTsN
CmVuZCAgID0gQUxJR05fRE9XTihlbmQsIFBBR0VfU0laRSkgKyBQQUdFX1NJWkU7DQo=

