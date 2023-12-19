Return-Path: <kvm+bounces-4797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E052681856E
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 11:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E72261C22DC4
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B29D14F82;
	Tue, 19 Dec 2023 10:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dOkM6SLO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFDA14ABF;
	Tue, 19 Dec 2023 10:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702982357; x=1734518357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TvF0dSaeYo7yK4ceQwKvga7BsqDI+D/pAy2pxzsQCYw=;
  b=dOkM6SLOdor+ZX7JrIayuCU5s9+hw/uSlZsx0RpGnqPXHQOMuKI3kiUo
   QZZCdLsONmxu+SbR2ddzrJcILvMO8NpvL5ga9KO92QMQZj/Lefwgpq6qA
   NoGWSYYVE/TAfjiABpJM3mDkjLDO9yg8N6KkFAYCDP6oaw47AsDgAvP2K
   Zk1gdtwI7PL3W1rDpuXZqXEExYiTdCsAtKjyDcg444IwctthRpZgJ5OHr
   tA/32MD23Fd/ZWLonL+10JBNQdbXEz0ecmlPu9hD7lmMXW+u80x497/x4
   tVCnz8+lmsnKZjJP9rO+CgZiA/f01BZnZHVSYc9PZPoiKJAeHD2o1yTrL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="2868070"
X-IronPort-AV: E=Sophos;i="6.04,288,1695711600"; 
   d="scan'208";a="2868070"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 02:39:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="810189267"
X-IronPort-AV: E=Sophos;i="6.04,288,1695711600"; 
   d="scan'208";a="810189267"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Dec 2023 02:39:16 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Dec 2023 02:39:16 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Dec 2023 02:39:16 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Dec 2023 02:39:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXjRQoPo7o6JiAbcNsWH+hSkNC2HUyiKwMmei/DfgaoBqHNbLT6WVCT25oB9DDQZ+mbhOsVeVZ3wOEyoBhxIvWZfamGegGebC2WXsoVT7/1RUWrUfk4naGCYE7w67a2a9lZKmugfTJrgaU4dKdDJZ9UqlLnl4KP6XHfcdyDgRKMPumC9wRDMJy1Sr5T2nh8NxLuQUDP8Sl7um2buB4zpflozZ3OtFVAQ74v2b6F3nD02QEDhKqaYg7DaFRFJiJ1LgAWURQKFFdLzcNltDxJsckBxlwaAd4zYpuYCjHgsapdp0jr7smbv5aCecU5dO3E6ZbRIzoNZSySboP6aEceRrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvF0dSaeYo7yK4ceQwKvga7BsqDI+D/pAy2pxzsQCYw=;
 b=HPF+mgMdghYKWeuR/wdAkMS4jNsJxpz8L/sMrHy95ZZXRYXtDLMWFVFtlS/CrQ6BsOZu1LG3si/05XqBmio6u+1oazoJ593DiPU5Ds/fmRAd/E4HLykL2u8U5QjjVZNAoeyPyjcRYgaldWh6D7nHnVm5alVLiYQc8xZlEOgOqplb3aD6jLwiRhhaj7uVL0gv8d5ZetlPO8t2rCFhYpQ/EUc1VvPC4fNPMFah1V0JIPZ6uspO4JlZJMDrM0Ttt0lGM5jOs+cFYpdx2jPFjIDh3LD8ieZqTjSlKH6IgmNraICKzTIKRwYpI/Q6wijL6YRPUgVR6ah60zdE29H/QD3ijw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5862.namprd11.prod.outlook.com (2603:10b6:510:134::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Tue, 19 Dec
 2023 10:39:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 10:39:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "zhi.wang.linux@gmail.com"
	<zhi.wang.linux@gmail.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v17 011/116] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Topic: [PATCH v17 011/116] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Index: AQHaEYrSO3RPt7pxrkOB0sTgVj+GA7CwrBmA
Date: Tue, 19 Dec 2023 10:39:12 +0000
Message-ID: <4eaaa842d7bccfe242eb8671f2ab87a647b02b7e.camel@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
	 <27d60b4bf79499c3bcda00cdb969ea215ecf05e9.1699368322.git.isaku.yamahata@intel.com>
In-Reply-To: <27d60b4bf79499c3bcda00cdb969ea215ecf05e9.1699368322.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5862:EE_
x-ms-office365-filtering-correlation-id: 697a01f1-be9d-478c-7ea3-08dc007ebd89
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDgHjkZ0w7bT71LsiLrOYsM9XXb4yhsJ1V39PcYxcs4sa3oZsqTjYy2qx6fsmRg7ymUCNrtRoWaCdqiS7b3I9H6apYXLrIKFwJWL96rG54oCCs5KWFVyI23nWLf+Gdlygu4dUsrLTl9LMicDhXHGfk7fJFaALiLgsdQYZDYhQrS7Mbz4Ob9Ya9vwYLk6Pr7ZJ1Bb00wYKfnoFFOKjr6L4WNeLJ0elgygwzFXRCdSWxr9Dn4x+yodE1kpGiLTy2zzMdyn6OQxrhWY70gnsFW2DIodxGOQlhM6tKmIvJK9KQwuiIGJ6QwNuwSLJK5O59DoW/JA/oURPR+YtY3lJmbPRlfH6BoxFlBipE3r3/wd9Mmdg4gX716louIiVX4r2cTwqFVi5LcskaVVi5sLbSvwoVZZz7zoXChzIT94nWG/a5NWNdNfB2SgXCynRcwUi1DjwglXiptWpLAaumxxwHFyZ6SAA9+tsQQOQLoYsOAUOct5ey3nsP9nxHiWLvlLUXNR9raR9KmrZT8hewIhHs1Ydha8Syhnr4pJP/O4b9HZOkFlqZseZ4oryKWwikXhovcTTWYSjflP6yDk9qByUO2jP+ez3VwnUsJspTUPOR7iVSik/BncHF9/J2jcBCMzTjkv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(316002)(6636002)(66556008)(76116006)(91956017)(110136005)(8936002)(4326008)(8676002)(66946007)(66446008)(64756008)(66476007)(54906003)(26005)(41300700001)(2616005)(82960400001)(122000001)(83380400001)(38100700002)(107886003)(5660300002)(6486002)(6506007)(86362001)(36756003)(6512007)(71200400001)(2906002)(478600001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUsxRFY0SjdHemVrUlA1akIxVVZzTmF2WTJkS1d3U2RQUHJSbU1TKytuaUJS?=
 =?utf-8?B?TzBnVk1keUJ4QWVZMWd6QWlSaUFuUG9ydkRIMHQ0ZmM4RWRUY3JXUllLTlA2?=
 =?utf-8?B?dnAvQTd1NGFiQzQ5QVNDK1M0eGowbngvdlltSmQ0SlY3RDhBRkprL2lqOXd0?=
 =?utf-8?B?V0xyTXl1djVmSWtvNkZ4bDhnaE1uSzhTemZiaUtWNXN2Z2Q0aTFpeUtNUWhR?=
 =?utf-8?B?M1ZJUkV3MWpsbDhacG84UUZZL1ROMk9uQ290ZDE0aTZUQ0xQd3F0NGtVRFFo?=
 =?utf-8?B?SmNCZk04VXVIcDVxMHk1QzYyVGNnMnAxdDZ1V1NjWFNqQ2g4alVZVHA1ckhI?=
 =?utf-8?B?SlJ2SzFSRzZWWGg5aG15TytrTkhETGQ4N0twTmVjRlRyRFpzNTFtek9ERzlZ?=
 =?utf-8?B?SlhveGxZRXFQOXdjNmpXSDhVaXBKQVo1ZllxUGNUWnQ0aFV1NVVFeDhpWVhq?=
 =?utf-8?B?YVQ2US81SjFZSFpWblNmN0h1c2luQ2FNRFdIMzRiMzBEMG1Db3IvVk00NGVX?=
 =?utf-8?B?VFdyZWhqL1NsVnBVNjA5WnhLMU8rczdSd2hIR1E2MVhKMkJNdmV4OEY4SlFt?=
 =?utf-8?B?Vm1iZFNpa3ZzZHFwSXBXTlNqMU5WNUVnYWYyWjgzd2YzOUVKcktQc04rUGdk?=
 =?utf-8?B?QW9CVGZyVHpSWGdnR1F0ZXQwNm10Ly80dGo0clJKeHRoSmFsdWJZUjZuMktm?=
 =?utf-8?B?TWQ5Z1h6aTVMTXZ1a0IyRVJGWU51WDNjV211YVdrYlpaalJ1MHlkZnFydjJr?=
 =?utf-8?B?NUVTTnZ6VVJITkFQRFp3WkxFVWg5N0J6bU14Q1VoWXRrQWkyNnFGdVJLQXJP?=
 =?utf-8?B?RUhtKzJQWnZkWm9EZHVVWFE1V1o5eTlMa05uQXdkVkgvRGJoWWs4UHMyeXdD?=
 =?utf-8?B?MWJrWjBtSnJlOWhHQ09oYlZJZTR5MnZUb3EyVHpzWmt3SDRQUjdzL0ZpRWtv?=
 =?utf-8?B?RENyUkVPL3NHQUR0eW4xOU41MzExblkzZnhRSXNCUHRiRmw5bDQwU3ZoU014?=
 =?utf-8?B?ZEI3bUxja2R6MGNJRmtjS2xjSExxUVNCVTJSODRtQWpJdHA1UDExOWxyS2hh?=
 =?utf-8?B?Q3k3THJyNFVKeFlxZjRUY1hoeUpGRDdweW82RUZwbXoyV0Z0dnRsaEdRb1RB?=
 =?utf-8?B?UXplU1oyUnNXLzB2TzloOUwzTE44NCtTVFY4UXlWZzJQek50dHg4cXNZZ2FN?=
 =?utf-8?B?cC8yYkpCeWNwWklVM2xkM1ZjYm9HdTZ0clZ2NVpNdjVjR1AzMjJkSFpMV3B5?=
 =?utf-8?B?eXNvWVVDcld3ZGhOZmRvVkxzcmY4Tk5OMFNIc0FnTU1tUCtJejVyOEdkVG5y?=
 =?utf-8?B?aGdCRm5QRy9sUEhEVndVek9qU3lIVEZyR2MvKy9JSXhxMlJPZUt5U2tyNElZ?=
 =?utf-8?B?Z1FEN0gyazloZjlDNGpJYXNpTzBCWjNQMHAwOUhIMFVTTGc1dEdBNFhZVWdk?=
 =?utf-8?B?UjJnNFN2bnNBeGxXL0VyNXZVVEc1VDA2QWNjcGF6WWh6NHpCQXh6dVJwdWJD?=
 =?utf-8?B?NmNsM2dVTFpnUjAxVEpCOU9SSWgvWGRmL2RnaS96TjAxRmFEL3pLM2x1OXJl?=
 =?utf-8?B?Z3FtVHJjRGJGSW5UZVdqR0JWWFVlWEF4a01JTTRZZllOLzFieG9XYVVhYTlh?=
 =?utf-8?B?VzhQL1VCUWpPVWpZWWpaSmZMSXU1K1BuMEV4MkRtdk5Bd2o1Q1p3MmNockp2?=
 =?utf-8?B?M2NzemtIRTNoNHZzeFVMbFdSVExPQTBtUDUxTnIwYjF3SmNUTzZJVm5JN2hF?=
 =?utf-8?B?ZEd4RkorYWpqcUIxaUVhajRwTUFTa1VOSE5seWlhdGtudzhWQTZiZEw0UkpG?=
 =?utf-8?B?Ym5iSkdjeVRuSkNMZGtZb3BIanE3ZXhRZHc2QmNvZDRDZG16dHpTRTgyMUI0?=
 =?utf-8?B?U1BYU3doS3EreEVJTW9tbXpFYjV6ZXVtRVdBTEZ6QkFGU1ppMFJCUWY2MC92?=
 =?utf-8?B?Mk8zOWpSL1pzY3RaNW5LUjU2SjNUejdxZUcrOTh1V1VxZmlYWkY2QjZYeWdq?=
 =?utf-8?B?cDJhb0ZRWmpqeXpaY3ZKdUxKOXhYanhvd0xPN1d1cXM5MXZJaGdBbVZHTWlU?=
 =?utf-8?B?OHlESWE1ZzZIV21Sd09uTXp5T2JCOUcrYzVDWlFSMCs5S2JzM2NNQUpwaGky?=
 =?utf-8?B?K2FvNHZSQ1ozcHZ2akVBRzFsaTlJRjJDQUJRTWsyMWZoek5rWWhqc1YxWDNi?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE425AAA48F1884F87663E7A868D8604@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697a01f1-be9d-478c-7ea3-08dc007ebd89
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2023 10:39:12.5477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XXp8U5mZqNn3zFS2vLi9SxEOsw08rIRduIUmsc7UUnhijhp2Q8ebt9X9tvlF9wOdTSEmYiJ15zgrxkrvWi6hEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5862
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTExLTA3IGF0IDA2OjU1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICtzdGF0aWMgaW5saW5lIHU2NCB0ZHhfc2VhbWNhbGwodTY0IG9wLCB1NjQg
cmN4LCB1NjQgcmR4LCB1NjQgcjgsIHU2NCByOSwNCj4gKwkJCcKgwqDCoMKgwqDCoCBzdHJ1Y3Qg
dGR4X21vZHVsZV9hcmdzICpvdXQpDQo+ICt7DQo+ICsJdTY0IHJldDsNCj4gKw0KPiArCWlmIChv
dXQpIHsNCj4gKwkJKm91dCA9IChzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzKSB7DQo+ICsJCQkucmN4
ID0gcmN4LA0KPiArCQkJLnJkeCA9IHJkeCwNCj4gKwkJCS5yOCA9IHI4LA0KPiArCQkJLnI5ID0g
cjksDQo+ICsJCX07DQo+ICsJCXJldCA9IF9fc2VhbWNhbGxfcmV0KG9wLCBvdXQpOw0KPiArCX0g
ZWxzZSB7DQo+ICsJCXN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHsNCj4gKwkJCS5yY3gg
PSByY3gsDQo+ICsJCQkucmR4ID0gcmR4LA0KPiArCQkJLnI4ID0gcjgsDQo+ICsJCQkucjkgPSBy
OSwNCj4gKwkJfTsNCj4gKwkJcmV0ID0gX19zZWFtY2FsbChvcCwgJmFyZ3MpOw0KPiArCX0NCj4g
KwlpZiAodW5saWtlbHkocmV0ID09IFREWF9TRUFNQ0FMTF9VRCkpIHsNCj4gKwkJLyoNCj4gKwkJ
ICogU0VBTUNBTExzIGZhaWwgd2l0aCBURFhfU0VBTUNBTExfVUQgcmV0dXJuZWQgd2hlbiBWTVgg
aXMgb2ZmLg0KPiArCQkgKiBUaGlzIGNhbiBoYXBwZW4gd2hlbiB0aGUgaG9zdCBnZXRzIHJlYm9v
dGVkIG9yIGxpdmUNCj4gKwkJICogdXBkYXRlZC4gSW4gdGhpcyBjYXNlLCB0aGUgaW5zdHJ1Y3Rp
b24gZXhlY3V0aW9uIGlzIGlnbm9yZWQNCj4gKwkJICogYXMgS1ZNIGlzIHNodXQgZG93biwgc28g
dGhlIGVycm9yIGNvZGUgaXMgc3VwcHJlc3NlZC4gT3RoZXINCj4gKwkJICogdGhhbiB0aGlzLCB0
aGUgZXJyb3IgaXMgdW5leHBlY3RlZCBhbmQgdGhlIGV4ZWN1dGlvbiBjYW4ndA0KPiArCQkgKiBj
b250aW51ZSBhcyB0aGUgVERYIGZlYXR1cmVzIHJlcGx5IG9uIFZNWCB0byBiZSBvbi4NCj4gKwkJ
ICovDQo+ICsJCWt2bV9zcHVyaW91c19mYXVsdCgpOw0KPiArCQlyZXR1cm4gMDsNCj4gKwl9DQo+
ICsJcmV0dXJuIHJldDsNCj4gK30NCg0KV2h5IGlzIHRkeF9zZWFtY2FsbCgpIHN0aWxsIHRha2lu
ZyBpbmRpdmlkdWFsIHJlZ2lzdGVycyBhcyBpbnB1dD8gIFRoaXMgaXMgbm90DQpleHRlbmRhYmxl
IGZvciBzdXBwb3J0aW5nIFNFQU1DQUxMcyB0YWtpbmcgbW9yZSBpbnB1dCByZWdpc3RlcnMgc3Vj
aCBhcyBsaXZlDQptaWdyYXRpb24gU0VBTUNBTExzLg0KDQpJdCdzIE9LIHRvIHRha2UgaW5kaXZp
ZHVhbCBpbnB1dHMgZm9yIHRoZSBTRUFNQ0FMTCBsZWFmIHdyYXBwZXJzIGxpa2UgLi4uDQoNCj4g
Kw0KPiArc3RhdGljIGlubGluZSB1NjQgdGRoX21uZ19hZGRjeChocGFfdCB0ZHIsIGhwYV90IGFk
ZHIpDQo+ICt7DQo+ICsJY2xmbHVzaF9jYWNoZV9yYW5nZShfX3ZhKGFkZHIpLCBQQUdFX1NJWkUp
Ow0KPiArCXJldHVybiB0ZHhfc2VhbWNhbGwoVERIX01OR19BRERDWCwgYWRkciwgdGRyLCAwLCAw
LCBOVUxMKTsNCj4gK30NCg0KLi4uIHRoaXMsIGJ1dCB0aGUgdGR4X3NlYW1jYWxsKCkgc2hvdWxk
IGp1c3QgdGFrZSAnc3RydWN0IHRkeF9tb2R1bGVfYXJncycgYXMNCmFyZ3VtZW50Lg0K

