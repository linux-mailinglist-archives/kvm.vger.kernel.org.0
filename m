Return-Path: <kvm+bounces-25521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46DAD9661EE
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79D86B25A3D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9E219F47E;
	Fri, 30 Aug 2024 12:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KQP86tyi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A41199254;
	Fri, 30 Aug 2024 12:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725021912; cv=fail; b=hLT9wvme9jCW8bXn39BtG97Wpy9GmNJd+cn+XfDx2CBnJRMuuNJg14h3t31XoAqu9P/lmU4eV3Ads0magkZ9Zi3OfET2Rm+H478j0eZxMOiU3mdSTgF0u5f1pKcE2A3a+vVSpafMhVK9nvTyLtCB2YvjM4Sd5lAAri7ge/7jC9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725021912; c=relaxed/simple;
	bh=AecZvR/nzN5inPB4vvbwy1ftsLhjAFnxie0tCDJbdmg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ptp9qsnuXwb71tbiNSQKhPwFeIqTCRs71k9a6uEn3TLGjDb4dasZb80Aj+7VdVriVHQgMIUZt09MrFWG7GnM+M54M1M+BgWysGSXwVhTPgVd9K4Utyt9d2p2Q+2k+7iVwEg7CuDX/DGTxznBARo7O826zkF8mLrhCuVlivFnC4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KQP86tyi; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725021911; x=1756557911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AecZvR/nzN5inPB4vvbwy1ftsLhjAFnxie0tCDJbdmg=;
  b=KQP86tyifI1jGi9yKVkhynE6j1gnSgah3NQYWPPe5CbLk5wuhLLXEMmv
   cuO5982irHMpoXUuZ3E5tjxN9z/3YI/mHnjk151bNZAr6VoQB60erUeQh
   ntOd6vBUR+f5VR7XIvUff9w58Do4bwFYEyzKtvcyGrkykDCFeVcTU9Akk
   qlqdT1qLl8cjdQrGZGWtBoMwO4XLfx/RuttGYYK2I3zG5S0ENb1qeMFqN
   XiZZVb9cQ6FfUqgjha9sYKcgGIINrWAUEHwa+BayoBpi3JwtANO2bJqyl
   GSzaPmVleQrnLRE1XLwnhx/vwIbygsVS7r8zLEFmcoTLnbwo9C4Z5CVUC
   Q==;
X-CSE-ConnectionGUID: pkteE9e5TRyNPWCHo5RBCQ==
X-CSE-MsgGUID: YmVzBr9+QFCOD8YWeYs/tA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34822486"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="34822486"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 05:45:11 -0700
X-CSE-ConnectionGUID: ruKcPhvxR7OIumlKJj+2VA==
X-CSE-MsgGUID: a5xwyBNZSHCBxu1fcn8Igw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="68738681"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 05:45:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 05:45:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 05:45:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 05:45:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OBijcnq2OQId2zT4zMl5E58s1Rf+B6EVipvJk2TT1OAZy/DDFF6qGfuoT3rF+GFwh6SebKzMre9mXcS2zRWNSnmIKhZylHF8NA8m9zeGuFbWo0Rf83g5Da7rzid7l5pwUmUaKmpFDCDzm7fkuuOHVrRGsF8/WsJsvs4ivJvQSQeMdOfb2vM07u2jgLrQ5Stp7kneXQ+yJc6hejrcCUJFNkUKZPNLVM9zrFkaT+PsWLYsj8Epg03NW37w3fLl/dfAaQbQewqYXakuu8UzpX1ETc0i/k0DapEDe8qqutFg4iWewojt/HEtxkCI1iQsNbX3PufBcjRJuyiiZ/U684SatQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AecZvR/nzN5inPB4vvbwy1ftsLhjAFnxie0tCDJbdmg=;
 b=K3353ZBo5bo1F3AqX+pUABWB45IkcuzCGswFWC67PmJjLo9RUaGprtjblGsv7cZ2h5FLphrQaMyoKoMkOvGaopGKU/FHURy8VmY2VGp9odk8rWYcv06CW16e9feCtUwt7VjUq6jg9xhjA/FC/lzatJ0y+9fq5k21cTXlzQICPCVho7w+C1dMpM4rY1106T0mD2Wj70F8BS91UQpN/nwxYQTn4/PzIb9IVnMEdkIeP0T3jnmN2dNG2rgpQ6jW+oBoFO7Gal+rgpUgAaIEUdD9XdBctV9vlS/7cF1TpKOGY2Ii2eOkQ21DFRs86q6LCD1MnK2+0rokicuWYBJyM7Tauw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6321.namprd11.prod.outlook.com (2603:10b6:208:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 12:45:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 12:45:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "seanjc@google.com"
	<seanjc@google.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "anup@brainfault.org" <anup@brainfault.org>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "Chen, Farrah" <farrah.chen@intel.com>
Subject: Re: [PATCH v4 06/10] KVM: x86: Rename virtualization {en,dis}abling
 APIs to match common KVM
Thread-Topic: [PATCH v4 06/10] KVM: x86: Rename virtualization {en,dis}abling
 APIs to match common KVM
Thread-Index: AQHa+pYt/frBfi/2pEaFJFFPO//cG7I/v7OA
Date: Fri, 30 Aug 2024 12:45:07 +0000
Message-ID: <0d7c48a9d7cecb69f972bfb3abf3afe91b6ac9a2.camel@intel.com>
References: <20240830043600.127750-1-seanjc@google.com>
	 <20240830043600.127750-7-seanjc@google.com>
In-Reply-To: <20240830043600.127750-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6321:EE_
x-ms-office365-filtering-correlation-id: 7b61c415-2f2a-4522-57fd-08dcc8f193d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bjNIU2lKZkVGMGovaElVVnVlSnY5MDNOOXV0czFKaDBuM0g1dzdreGVLMkVN?=
 =?utf-8?B?UmgwR253d1FjSnQvczlUZmt3K1UzMmlGbEdNSTRkNzdmT1V4Q01JWGcvWTB6?=
 =?utf-8?B?NlZ0TVplbUFuaFRjWUwyTlZUMDVhTExoekhJSlIxU1hxNkVSckZiSGJzMFBw?=
 =?utf-8?B?ODhGaVpQSG1ZMmUxREdxWnNhanNNZmpVNlVkMEx1emZiM3l0RDVyMm5SSzFN?=
 =?utf-8?B?N0E1b1J2aFpKbDlQTm9hMTg5R09KcDB4T2JldGMxSGlPOWpoK0daRG5SSWp3?=
 =?utf-8?B?MlFTR0VCWnB0QTJqWUpQcGJRZ0lKQ1hwTk9vUE5uNytPOGt6eW14YnJDay9H?=
 =?utf-8?B?L0d1MXZ6NzZZQ2NpdlhHQjlqVkYrVmRQSjZHampVeHU4UGFYQnFlclJoU3Nj?=
 =?utf-8?B?YXAySWZrL2ZsUi9aWXhqaDZvWXdLY1hJMXpOeXJtZExEQVU5TDdZNXd5d1Y1?=
 =?utf-8?B?a1VnR1VJRWNPVXdyd0pLdGdKK0tobmpCRU9TemFhTWlrWDk3OFNmR09oWHd2?=
 =?utf-8?B?NkkxenZCVlRQUzRpTnlIVXlKOVhFUHNZMDhwdi9wMCtEWWJVYlNNdjQ0T2pz?=
 =?utf-8?B?R2JaT2o5dVM4VEdmZXE3UjFzM25jSG45TzU0NWkvYitIR01tS0hBdXJoNkxG?=
 =?utf-8?B?TTkxSjN2UTh2MjM5Zk5aU2kvcG00d2YwR1ZhZU9YUG1jZEpRb0FHY0E3SjNU?=
 =?utf-8?B?Q0VjYWhnS3MxSVpZNzFsYXM0bHdGdGQ0Q1BHUkFoaXdCd3ZRZWgwN0I2VmF4?=
 =?utf-8?B?aENsaG82TUdnaUR6VFdQcGtZdEhCQnJaUWd2L3ZuMllBM1l5OUpPcXk3VUF1?=
 =?utf-8?B?TTIydGo3ODZyQm1SWWRPWGFhUXlmY2VYcFNESEp4cXdqejJpM1cxTTl3QWVv?=
 =?utf-8?B?TWsyNU16UkY4N21pejhYNU1UdGdDNXdNdjN6SE9vT0JZSFI1MitGVWxWbHBs?=
 =?utf-8?B?ZGNvQXhFR29DdGRUL2tRVHVoWnBaTlBsRTlPcnVIM29JVDkzcGtrTHE2Q21a?=
 =?utf-8?B?SzNybE1KT2FaTnBEREVMS0F4L1A0UjhCZC84SmkweXlyMHRwVkl3SEM3cTVj?=
 =?utf-8?B?dkxIRUsyc1ZjUktvcS9zMTRXMEJWdUlqNjlqbGJmbit6MWVMemtWKzFQNlJU?=
 =?utf-8?B?Y1Y4OXF3QzMwYkVmVW56QWtCdUpxNm1hUlBIRjJ5WWQ2cWNmNnQxb1F6aWFr?=
 =?utf-8?B?SlIzUUY3cllxRnNab0xmdlVPRU0waUVEUGwyQ0ZtTTBVNzRaV3ZGWTNIcmhQ?=
 =?utf-8?B?elptT1p3WUd3eW9nVEN3UEFmekhtVWh4Z1I2dkZzTWV0R2JZbEJZcjhMMFho?=
 =?utf-8?B?aGMxY2xya2J5Q2xzSlkrSFZqaXA2bGorU1pGYksyTTR2M28wRk5KVURZbThi?=
 =?utf-8?B?VmRSVVg3NmRsN0pMMTBza3VVMjFUbUgvMW12UHZ4WXBIay94bndoeG9zT0Fm?=
 =?utf-8?B?VjNGZDJwcVB0eEI0M0NJVzdnR3AzeU55ci9DUTdiM2JXSVB4VFRxYWVyOUxU?=
 =?utf-8?B?aDg4V0hqbmtTa1ovdDNPU2FYeDJSVW1GbjRkSFBDYVpyN3A0QmM0cUZlVVhu?=
 =?utf-8?B?eDBmL29iblc4UHB2a3ZmL1gySloxR09WbUg5OUhuY1FsM0k2ZjBoY2EweUtR?=
 =?utf-8?B?akE2WkpsR2lCamdHd09yaFNJSzIxNUc0MjFFQWlkaFhTRnp6YUtwd05PQ1Bj?=
 =?utf-8?B?TjNjQWhXQmozTGNJdmRDMHB0MjYwOUFzcXc3eDJrMVM2NStHY1RyTVBZYTdR?=
 =?utf-8?B?WWFaeER1aGxnbkVvSHBsYjJzK1ViRnRQL3VoTjNwTHpWbEpXRnFJL0FLVVA0?=
 =?utf-8?B?Y0F4MXNyeXpwNzJ0NEI5Qm41Y2NLWXREaTEwM3cwTWMvNitaeHdqSjNuSnhD?=
 =?utf-8?B?L1ZKTEZ4RzdzQkdJQ2swUWY0TU1yN3crbDdxbFhDUWlWQ3dVM0ltWDJtdlg4?=
 =?utf-8?Q?bA5BcKZcQaM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eE5EaEtGdk1xazZqZU9hRVBTRlhiQWE0ck91SHN3SXBrRDl5SUMyUnpzMTRh?=
 =?utf-8?B?Ti9YWjZ2c1FUSWVOUjBrZElkZ2JJRWxRRWg1elhrK1BmMkV1RVQ3WDI5TjNw?=
 =?utf-8?B?aWVsWmxjcWowVHVXbFhKcDdicU5zZ0VzNU9OVjhGUkpyQ21VSGx3ek0wNGlh?=
 =?utf-8?B?RkFoNWsvMENMQm5meUtjMG0zNjZxS1lqejdraE1XT2pRLzlyZlJFM2gyTzB1?=
 =?utf-8?B?NGQ3eHdvNXUweU1jT0gzUW1ZLzhvMFpCV2xoSjZhRjk5UXBydE9IZnVscVQr?=
 =?utf-8?B?dzlwMERjSnYyZ0xHVTVCVElyUmFBaDFWQzBRL3ZpdVdCVTl4azVGZEFJdFNm?=
 =?utf-8?B?NXRRRzg4VERsdjc0WGkyQWZzQ0hJNzJwV0RSWkE4RUVLejd0OVFMa1VLbG5a?=
 =?utf-8?B?QjNRZ21BZ1J1UFM5UjNqcVZpQW5QU0FBRDJYRTRUUlNQaE1sMUtkejdZeVN5?=
 =?utf-8?B?WCtyWWxGMlRpYjNEd0tFL3czb2t3UDR5MFRDMFlxK0x4NWFHamI4NldDKy9J?=
 =?utf-8?B?MDBSU1JPTFlmMlhWY1JacFpYclI3RHdnNGZKRTM4WmZPSVI0RTVWK2w3STYw?=
 =?utf-8?B?dUFoQm41UE0zVUcyY3NDU0V0d0xnSWhmNW5ZUmMrWmNVZGtKWFlLVS9lWGwr?=
 =?utf-8?B?YjNHVzJqckFqTmtLUC9TSVo4Yk9WVjN5WUNWVnNnMDhSQk1ScU9nQ0thVnBB?=
 =?utf-8?B?KzFVdXVLNVIrOTdOanJaVzI2UHltWEpZak4wVmNFOFphdWo4eExZdG9yYjNy?=
 =?utf-8?B?bzZjaEhkdHlESWJOOGcrcUlqcURiMGNyQzR5bEMvQm5SWVIzUHdNbDdTWG84?=
 =?utf-8?B?aWtjU081ZU9mNk8vWmNnUkk4a3hScDFVSFJBWXdRSkNtaDcrWWhvcVJpSlVD?=
 =?utf-8?B?dHlpcUhyekNrYS9tYk9jOHFCZm45OTJwcVZaLzFpMWN6NCtJMnFnZWdGRTda?=
 =?utf-8?B?TS80WkxvNzZQbFR4VnZ3UDE3Z0tJbTNDckhyYWkxbGs5TnllZ0g2RUt2dlZF?=
 =?utf-8?B?Nm5GNGN6TFVKcVBpQ0psOFNDRlNubE4xcXJobkM0Z2ZkalNLNURxbmVUYkpH?=
 =?utf-8?B?OVpGRDN4M2wyK296NC9lK3pBTTc0aXRWOWhhZmpva2lhK1Z4ZVRLeENsSWtK?=
 =?utf-8?B?QXZDVjNqTXEzQ3hBTW9lNXYxVkgwRGczd3BKelpYRzhkbzEwVHJ1V01mTHlJ?=
 =?utf-8?B?RnlMbHB2a2RuYlBTYjJmMk96V2lvU0liQkh2N2xvZm9YSlBDMnVocGFnaDh3?=
 =?utf-8?B?SU1jUjBFWTBHQkRkUm92SEN0UU0vR2duSkR0T01kUW1hbjJkSU5ydjlOYXBa?=
 =?utf-8?B?V0tIMGlmYWNObFNtMFQ3MFR0UWRmSlp0QnhUb1JvRG9NeXhwTFp0cmdQb0VN?=
 =?utf-8?B?bWFMV3psL3c3NEg3aUV4VjIrZ1A5UG9IRmdMMm0wNUNhcE1QUThBVzR3VGNo?=
 =?utf-8?B?WHRPWGpNc0dmUTJZb2YrUGVIQzBJRVVnSm1VVzhzbS96TUkrTkRKTTBnc1M4?=
 =?utf-8?B?bElicEFFa01xaTd3WVpzZHB2V2xJZENBQjgyZjY2STBiVzJxOUdPZXlOR0Nv?=
 =?utf-8?B?V09NQ0VVN1hLa25IUVp4RVhlTm0wakRZSHFkV0Zvd2gxL1B1bFBiNVIyV0dR?=
 =?utf-8?B?cWl5Q3Y2NXJicDE3N0xhNWQ3QzBEbU1uR2t4alducWNIYWpmZkVHMys1M0Fo?=
 =?utf-8?B?RlhHYjl3RHNMUEdzcmZWUmY1c1NRVUtFTFNJa1hvUFNZeWxMdHV4S09kOVll?=
 =?utf-8?B?dGxXRmFpbGVEUktSeHh3bDFXaExhQWJlM014cGhCVkUyWnMzZUJmdUMvQStM?=
 =?utf-8?B?eFJEeGRieVhSc3BXcmhVclVtUVRYcXhQSjh4UG9YTENDUHAva29nWGhKT1BO?=
 =?utf-8?B?N2w2QTRDZG0wY2QvTGd6eFVhbytPVUNTL3FwdGlzL2VZbWZsNXhvR0VVWHU0?=
 =?utf-8?B?RUxya3hxRkNsZHA0UmVXYmlod1FwVUNPL1c3VjNDQUNqNURDa0g0WkNBdlRW?=
 =?utf-8?B?eURBUUd1R0VEc3VEWU9TMDZzTEtMRW1IQU1mcnhTZ2FqTGIwK1ZqVjNjK0tE?=
 =?utf-8?B?MlU2VHNtWktrYXpIaFpXTkZFd2p1dVVRTmRNZVJoSjhXcDBlZzJXY0REYkhU?=
 =?utf-8?Q?TRsqrUOKcM4PhbkvCG5TNAdI4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D2821CF6851D148A3B345D97CF3C711@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b61c415-2f2a-4522-57fd-08dcc8f193d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 12:45:07.2202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OFgSPt2EVDeplWO3WzOaP9A61PkpVs4ZeAa+NRtmtmOZkBcI6PuGC588j0QRj3tMIx2Twng79AS/EX0T3wYi5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6321
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA4LTI5IGF0IDIxOjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW5hbWUgeDg2J3MgdGhlIHBlci1DUFUgdmVuZG9yIGhvb2tzIHVzZWQgdG8gZW5h
YmxlIHZpcnR1YWxpemF0aW9uIGluDQo+IGhhcmR3YXJlIHRvIGFsaWduIHdpdGggdGhlIHJlY2Vu
dGx5IHJlbmFtZWQgYXJjaCBob29rcy4NCj4gDQo+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVu
ZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdv
b2dsZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0K

