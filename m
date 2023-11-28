Return-Path: <kvm+bounces-2643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F667FBDF8
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 16:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4D69283A1C
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69FE45D4A4;
	Tue, 28 Nov 2023 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kzfvpFEm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4247310EB;
	Tue, 28 Nov 2023 07:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701184787; x=1732720787;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gBaBh6I5PICX0d8uuGugkA4L//csroftTsZJLN5TBYE=;
  b=kzfvpFEmfnAoGaVZTSjdcVlUlFz8zhbfjscodxtlPylFd+CWTuSsVuuU
   LZdarzId8vDtklZIKpUstS7NVBvb585C7yEjQBnm0YMyVYNtQrkCD2CJc
   IxLEgWDyU+LG5K2ce4v06VqZVMIWOpL0E1k6ZkJOtErURB1ET54Nji93W
   MxITNlyrKMdzHE3ELMHNA0kQaKY/ksR8Ma2NgoGRFWYoUfVg0RQV5fEaS
   M1v+UPHrhcKmsjuEQC/w66fj+J1iv8tcA+AlYV5d2DR+eOHWhQcD3gGqu
   l62rLxf29dxVBdWvtjWBGaMC1ljuZtgUf+lja5B+Oo5+dP5O8T5rAVk/y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="396846984"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="396846984"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 07:19:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="761962947"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="761962947"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 07:19:46 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 07:19:45 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 07:19:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 07:19:45 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 07:19:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHhxd36X0/XPIzZOlG1e656Byi4swQPHzZvR7VuaDEaC9MG7Usnw7xExo9sNSAzvGprgxKRH6vGNFDZrvFX+VPuPF8vwjSJxHc5OXmF8rUrhMU1F1D32jRxVzN0US6fHKEPFwn962t4Y6cl3vCibO/7vv9GSUdYo/+urzik0qq7t1XD5Upb288OsKuQVaJ5N6AZT8unHeJqrgk8a8smri6Ch2Fd2Oq9Dggeu7qBS4JDo4scGvp37by8i4Lj2nuRHfCedqsPDs7H6/T1MIhaWAO5I9xCB9kI6FORAonsLc6VcbEpMNvuQf8X5aH99Ms6lkBBTDjJ+wZNJsY5dydyozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBaBh6I5PICX0d8uuGugkA4L//csroftTsZJLN5TBYE=;
 b=OT1W0+jgOoTki2NbXeJ3auyDwYAFPkJobSQdfzNoGDYNE4y+qh8IOxusYMQ41RbD/yf09dFEHLC0sv1eFEqkjf0KTW3180h8vgCtBgSQofI0k7oYrnY/4rmk+MwcNDhgTzF+PtZvcN1SY/fbPaQWKBPOUVKpYTZaJHSjqtP+AY5ScpdN3H72wSfeq2crPJ82tb7JwGNus8/fEL4fyggr6DJtZ8ILTBqczNjlU/CaRpAsiTl0HyMqVoajBU3+hcnrC+6u1dJlV6IPP0iOqw7EHJWHqX3pXsmw72o+u593VMbd5MYjOVKOCxcHOPC8FhaEoceJu5RfJMruPKymX/DgsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8740.namprd11.prod.outlook.com (2603:10b6:8:1b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 15:19:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9%6]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 15:19:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v7 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Thread-Topic: [PATCH v7 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Thread-Index: AQHaHqwUOOYKgBs+Pkm7sTfelkxgOrCP3zgA
Date: Tue, 28 Nov 2023 15:19:42 +0000
Message-ID: <cf078e1600a1ead27ee382ae184aa9ac168205ad.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-7-weijiang.yang@intel.com>
In-Reply-To: <20231124055330.138870-7-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8740:EE_
x-ms-office365-filtering-correlation-id: b3be3c3b-84c8-4c73-cc56-08dbf025723c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XKinhAB0xncyCLTPHVA1HOa/GKovlMWm1iosQdDAygQ6TmnWoep7Z8XZYK4X7QukIB08KGyCe0EmYEYwE2vi53RUZoTs2cB1vUUuLfF6pPnTH+DhoDAEegH4lxn60YXosgqha89YgGN0rQE9gmv+khRfsi5wv4ohPMj0jEG7x9WbJY95d7d73FtGXbn2JqS7BLaMNIUQ8RnLBdvKYYExsSBuy3KKllCkSmBxxZ+0ykAVos3iYkpOOH8mmLp7aqj0i3G2pc8EvnVZq2X0rvquL0BqB1vUywG829tSZEgVHQPk3EDrUgj5zcRIuzh9zITwLpFHT7/w7srZu7ckv9WvCTCajo+5TCQJHeqOsdXdFQ3EzBAkwR+XrohD25/EaNSCqRSOeCPxKN/I7XZLVR2CJgSiGoJ4OOKSW7YJLVjcBaqo0korPaqO1J51+ABsdWZ6P3GNaWEsactxZNXCOr/Doa16pMMa74WtrE5iRzK/QT7oNeG7zJxvYStvgHLTMoEsFJ3m5Bj0S/lsD4XpUM3I931bt4BeUYab2SIQpfyXWjntshqAP/r3PrWd29kdM5Ne6bXGKg/sdrSfgvFgit2sfR4iNdzxXYfhS2LYdUTOGinV6lBXVU/uCT4vz6uI4uOT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(376002)(366004)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(38100700002)(41300700001)(36756003)(4001150100001)(86362001)(38070700009)(122000001)(4744005)(5660300002)(82960400001)(26005)(2616005)(2906002)(6512007)(6506007)(8676002)(4326008)(8936002)(478600001)(6486002)(71200400001)(66446008)(64756008)(54906003)(91956017)(66556008)(76116006)(66946007)(66476007)(110136005)(6636002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGVGd2VKSUZMN2UvU3AxcVBNbVBPMU1WeWFqcEc4RG0ydnVEQnNFa05iM2I3?=
 =?utf-8?B?V095dmdTdmRqMmNhdlpSR1JKbFFRQ3RrbVFieUMxN1lnMm9WV2tnWlJMRlJO?=
 =?utf-8?B?amJtd2JDY0pXY01LYWRmTDdDV3M2ZVpJRjFvSktrZ3JnTm5oNUwyMjByQVJF?=
 =?utf-8?B?ckpCeWRDcHFmZTllbHIxNlJ6R1ZyTkF4blYyakFPcjVacDBQelV6a1lsQW9o?=
 =?utf-8?B?WXYvb2ZvbHJVTVZmWFpYazI5ZXExVTFsN1l6b2ljK3o5REhIdDR6T3BLQXIv?=
 =?utf-8?B?TWMycTJrcVRFYnk3SzhMMGZqVE53ZVgvYU1yTnllK01DKzNVR2UwVys3VEwy?=
 =?utf-8?B?VlRiNDNxTXFMNm8vRmZlRy9kNjhjczRIb0FPalpJMzhseEhaL2tnSW1iMGVs?=
 =?utf-8?B?QVBoejloYkZrenhmT0ZxSlN3QTJyMFdlaktTTTlhT0RpQlk3QlVVcW5OZk4z?=
 =?utf-8?B?c0pNZ2YyQmEyWExITXdER25ieW9VeEtRbG9zc21Yd0NTQXQ3VGwwQXZJMUlC?=
 =?utf-8?B?VmFaT05yTVhWa1ZEOHZvZmwxcVlRYlJxd3hYcWVWMzhyN0RzdHZRaG85Slp4?=
 =?utf-8?B?UjllT3BaVm9CRGZGOUJuN0pQOFdueHpnci9kMnd1aUpkcmNvcEtMZmREUVp2?=
 =?utf-8?B?S29CY1RlZEUxdWk2OUNiaDNRamNKVHYvZ3I3WURCTHdaQ2l5ZUZjYnhDcDND?=
 =?utf-8?B?dkNnTjh4dmpoNWhzeTVqN2FwS1JqakE3eGc1TUtZRzR4Ums4bXZIWERIUnFv?=
 =?utf-8?B?bHFrMXJnNnpLM1BnNUhvWm5DVkxhNEdFQWsveVdYcVJ1V0JZQ0FTeFhaOUFm?=
 =?utf-8?B?V3c0Smo4RTJ0ck5JOUNoeHFuMlZUUHAxTW1nNW54Z2lQTEtZaU50WXZJUmRa?=
 =?utf-8?B?SUUvdW5NTHdVMFdDMzhpSWt2NTc2ZU8xOWExVmhnaElKNFdnUytwTHFyc0h4?=
 =?utf-8?B?bUZoaTJ6a1NHVFZDN28yZUxoeVVTOUo2VE10S1F5UzhpdzAzcVlnalFwRWxZ?=
 =?utf-8?B?dHF4TkhpU1B6T1ZrMkJFOFk0R053Y2J0OFgzNlJoV3NRVDFCZGxQazRLRmNH?=
 =?utf-8?B?ZlRJQ2RGK1o5MUpoR09hN2QrZEJtT0tKNUZ4WmF4WnhKaHVoMmVkbE9NdEdI?=
 =?utf-8?B?cC9hS3MxMStzZGhEd0RqdGhuWFFlb0xHdmQvQ2JJeWxSaEphOE5vOWVuN0pH?=
 =?utf-8?B?RXhQdFFJRXZxQjRlaHh1dThoL2g5U21tSXh3c1dDMnc2T3RXcm5MbWdyUVF4?=
 =?utf-8?B?ZGNxNFc2MUVPMVVIQmd2VWVzck5Zd0gzR1pmVGpaOHA5YU11WVNJTlQwRXQ5?=
 =?utf-8?B?aDJPcHpiM2NLWmtKZjNlODJBOVpnejJQOFdSb1JxMmtXNWtkT25Od3ZFSE85?=
 =?utf-8?B?WXhSUm1qMDlHUEplbXlwNVhHTXp6ZW1saXFLSFhFbHlPU3Z2SloxM2ZhajRs?=
 =?utf-8?B?UDRzdDAydVFHK0tKY0Rxc3JYTmJoS2x4dEdLT2wyZEYzbjFVeDFlaFBlalBW?=
 =?utf-8?B?YXYyVEV6U3BPbDlkeEVWQ0c0Yk93TVBhRXNFWFMzdmZQVWZKWFhPTmtHa3lo?=
 =?utf-8?B?N240SURWWkpGQ2RIZlFxUmdCQXpjSXBBbjk3QnpWbk9qMFkzMU5kUEdVSkhT?=
 =?utf-8?B?THc1a1gxdWY2bk5DV05tZFJFTVpCUlBlZ3I0L0Z3M282UlJhMFN6ZWZKR2NU?=
 =?utf-8?B?WFl2RXJHQncycyswZ0p5SGp0V2hyWlNpcEIvQ2RFQlFLdHZBeEFRd2xVZTJw?=
 =?utf-8?B?ODV2OHdteXlXRzBlL3FXZWsvS1luTUI1N216ZzZwWHI4YkUzOXlMaVIxVFlj?=
 =?utf-8?B?Yk5RTDg1RnBFVVpQSllIdjhNR2d4Y01Xc0hJMERXQjJlenFpT3BzSEdEM1Yz?=
 =?utf-8?B?NVBPK1YrMGZxdTJIMVFFeFhpTlNqeS9xOXBDLyt2NDhRYVlaemxDem9adHMr?=
 =?utf-8?B?M3NpL1VwOUFxZjl0OWZOMUpSV0NQbG9YdXp2RlZLVUlHS0QxMm1PQ2JDNHpi?=
 =?utf-8?B?OWRIaDZSanIrZW1tMXQybkJCZ01tRmYvOXZtV1dESklBYWZFZWdOaGt1aW9D?=
 =?utf-8?B?UzZHakJobGVUMWczbDE2MW1xM1lzMGYyVlJmQzhaQ0txSnRmbGNOQVBjQmw5?=
 =?utf-8?B?MXNNUllhSEp3ajlha0c1azQ5bGRJUHhjMjhBenpTME9yT0lZZ3YwNzBWUGVa?=
 =?utf-8?Q?DvlAwfFwxNjx4JyRmDVVX6c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4B53950BB3B7846A5D627E9E98D10C1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3be3c3b-84c8-4c73-cc56-08dbf025723c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 15:19:42.3880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sIqLdsNgkkqRG0JcuJ9b8khwElw9/OqT9cmonUkvtRUkJAmkyKN0U0kCiOwa0MuSlYxlkXscRCOHadb3fy6XX6PKIPjwLH9ThqRDDbJwVl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8740
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTExLTI0IGF0IDAwOjUzIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOgo+
ICtzdGF0aWMgc3RydWN0IGZwc3RhdGUgKl9fZnB1X2FsbG9jX2luaXRfZ3Vlc3RfZnBzdGF0ZShz
dHJ1Y3QKPiBmcHVfZ3Vlc3QgKmdmcHUpCj4gwqB7Cj4gK8KgwqDCoMKgwqDCoMKgYm9vbCBjb21w
YWN0ZWQgPSBjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1hDT01QQUNURUQpOwo+ICvC
oMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCBnZnBzdGF0ZV9zaXplLCBzaXplOwo+IMKgwqDCoMKg
wqDCoMKgwqBzdHJ1Y3QgZnBzdGF0ZSAqZnBzdGF0ZTsKPiAtwqDCoMKgwqDCoMKgwqB1bnNpZ25l
ZCBpbnQgc2l6ZTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHNpemUgPSBmcHVfdXNlcl9jZmcuZGVm
YXVsdF9zaXplICsgQUxJR04ob2Zmc2V0b2Yoc3RydWN0Cj4gZnBzdGF0ZSwgcmVncyksIDY0KTsK
PiArwqDCoMKgwqDCoMKgwqAvKgo+ICvCoMKgwqDCoMKgwqDCoCAqIGZwdV9ndWVzdF9jZmcuZGVm
YXVsdF9mZWF0dXJlcyBpbmNsdWRlcyBhbGwgZW5hYmxlZAo+IHhmZWF0dXJlcwo+ICvCoMKgwqDC
oMKgwqDCoCAqIGV4Y2VwdCB0aGUgdXNlciBkeW5hbWljIHhmZWF0dXJlcy4gSWYgdGhlIHVzZXIg
ZHluYW1pYwo+IHhmZWF0dXJlcwo+ICvCoMKgwqDCoMKgwqDCoCAqIGFyZSBlbmFibGVkLCB0aGUg
Z3Vlc3QgZnBzdGF0ZSB3aWxsIGJlIHJlLWFsbG9jYXRlZCB0bwo+IGhvbGQgYWxsCj4gK8KgwqDC
oMKgwqDCoMKgICogZ3Vlc3QgZW5hYmxlZCB4ZmVhdHVyZXMsIHNvIG9taXQgdXNlciBkeW5hbWlj
IHhmZWF0dXJlcwo+IGhlcmUuCj4gK8KgwqDCoMKgwqDCoMKgICovCj4gK8KgwqDCoMKgwqDCoMKg
Z2Zwc3RhdGVfc2l6ZSA9Cj4geHN0YXRlX2NhbGN1bGF0ZV9zaXplKGZwdV9ndWVzdF9jZmcuZGVm
YXVsdF9mZWF0dXJlcywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb21wYWN0
ZWQpOwoKV2h5IG5vdCBmcHVfZ3Vlc3RfY2ZnLmRlZmF1bHRfc2l6ZSBoZXJlPwoKPiArCj4gK8Kg
wqDCoMKgwqDCoMKgc2l6ZSA9IGdmcHN0YXRlX3NpemUgKyBBTElHTihvZmZzZXRvZihzdHJ1Y3Qg
ZnBzdGF0ZSwgcmVncyksCj4gNjQpOwoK

