Return-Path: <kvm+bounces-2783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC877FDE05
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 18:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B671B210ED
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 17:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B6140BF1;
	Wed, 29 Nov 2023 17:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KWCKAfV2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB42BC;
	Wed, 29 Nov 2023 09:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701277910; x=1732813910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=W8jKWFpWh48Gp4S7rRieH3fZ+TWGvcpWhmwR2rQhvIo=;
  b=KWCKAfV2rm86zFnTJIDLEspjz2DZeBeOrgk6OQ6Aigh3m1KR9sEK6vQa
   oMFthBZ3v2qctpU3/oZx+SJ7+TLhQosuL5bkkuDgvFvx6Q8CgK46APE5e
   8J1NSESnufGz965tsZ6I/sqGwgaxsuWauETNhGQ36XJ3LR5A4/zHj7Dk6
   c7p+S/Kxofc2j/lb5kOU0zNrdBt2XimXE/6v/03+dGV5V0hOPFnwragoe
   KUn11WU93L+yyZeH3/ZuOtCzeMj/F+KrTQmcG9bR8gAKF/H12xLXV1Scu
   WsObaJAhmCbbVsnjIrtI1UEFnvZsIzxEuxIbgB200rLMu5TL9BnVDBrTJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="6407751"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="6407751"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 09:08:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="942393366"
X-IronPort-AV: E=Sophos;i="6.04,235,1695711600"; 
   d="scan'208";a="942393366"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Nov 2023 09:08:37 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 09:08:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 29 Nov 2023 09:08:36 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 29 Nov 2023 09:08:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIJ0mu5U7NevgUE0VRhqvJbNamKGaVBRAAKb6XZhaErSBGVdDrT9BhtJKpTOuVhKwjbQdRM/LTrITXxEgjC9s8AP3zWVL7bNQqo/TZEalfzaao3sZ72371AgEXF0fTcyvULWk9q/1CRXXc4rJycLLvCfwb9Bd63DqbMc0HBxttOl80jna0FBvzLRqecF2VoNmDj7gh/7WJ5fcXQCFDr+ucIuYFAqavbZdxIG8s/REnJYeru72h2qhtGKIYg7qojACryTfrz9dHJ1XgqQbTOlU+OLxpUAYy7fVCqVyKXVFdUEWUj1kJTVVd8xDOHa3Yjpm9WjHIVEQoBApoDiwrlKqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8jKWFpWh48Gp4S7rRieH3fZ+TWGvcpWhmwR2rQhvIo=;
 b=Wp4CtAS2P3KVkzb6pG1bhdhUUNzvbmMN85BttrEEifNK7ZVEcBIHvksqdJI4gGxGLM3OFQnlbxf+p1YWek7MY0plg9jYA6r46gd4muX0HMd+5xG3HGurrN7OENLxgCHzmvNvIKbFwL1DWn87ytRUZ6YXvABGNN/zVGiKMovTPUnKKg3F542zmfbU15gSPrUESz8dp+F9a3/1V0/eWM/l0R1kxJHzVRIs805iMb/1neqLDqe7oSZ6AC5JYmd7jCTAenvATXCV271LIaBNJLqpANTcBHwa/kfZLWDbm7VeAyFpP21FGuIoqjAlSDh4qFzvj9naRzIYoKbwe8gN83WW6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB7782.namprd11.prod.outlook.com (2603:10b6:8:e0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.27; Wed, 29 Nov 2023 17:08:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7046.023; Wed, 29 Nov 2023
 17:08:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Topic: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Index: AQHaHqwJcLbwxqusyUagEZmr+deVnLCP2VSAgAGFo4CAADD8AA==
Date: Wed, 29 Nov 2023 17:08:19 +0000
Message-ID: <a8ee5217a98b261a2eace9a0b543e43796607156.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-6-weijiang.yang@intel.com>
	 <742a95cece1998673aa360be10036c82c0c535ec.camel@intel.com>
	 <e8b77875-d7a2-4898-94d2-248e32b6ebf4@intel.com>
In-Reply-To: <e8b77875-d7a2-4898-94d2-248e32b6ebf4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB7782:EE_
x-ms-office365-filtering-correlation-id: a43ae66e-4265-4225-6694-08dbf0fdc8e9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Vni9mzkmD03B2Oy4h/cdxTfrfdbi/fSOHaN1LlblK//nKBIY7hYtCiB3eC67XUL3Z+dm0EV9HsQgQ9HM55H6GEILn/Db/rpiK4ACOj9hitYW+uP0WDUItoPiXk4l3o/f9rez974SSEZKoqQWv7fj2kP01TKLB/ZTifJjH9AWRQboikbPTF4776mk11dwAfGRcxhQAIc2PPk9m5xTHkmVzOvYnC2+pesYwrl0u5dDTAnmbr2zu0Qfc+fiGQ4MnF0y46mQlDBgDy+72/KHrCP5rrhi1O8NhpuTebPA089OFGdkdb8Cz8bR4fmDSwRp4NyoDi3vPwoNjKO67evo+DUex2xovhUNHZ3nQ0RqJLX5VZ7lcCdUSUChvPeKs85qgqEGOMwhwkM80ndp1UuaHaus6Kc+O6xX7vaNSUjYx6BypSD3ZELyR/ALGkdFWKAGBpziCJeU82Hjw0JHeE78SZmoHCMeAj8WspJvIByudRdalRIYE9hGjaQ6U76lNsBl0pal+bK6wG2mSfMCjNlPa8/Np9kfyZVH0vyBs8IuwabRI/K2cCllt8LkDlQqpGiNGZtjFGVEFbbgovIUcFOaO0kKOT8sjzmvYKunoLrgwQieLvZziKXWvA6Xw/bCPz5zIX5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(346002)(136003)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(26005)(41300700001)(53546011)(6506007)(6512007)(2616005)(82960400001)(122000001)(38100700002)(36756003)(38070700009)(86362001)(8936002)(4326008)(4001150100001)(4744005)(76116006)(6486002)(8676002)(316002)(6636002)(66476007)(6862004)(54906003)(5660300002)(66556008)(64756008)(91956017)(66446008)(71200400001)(478600001)(2906002)(37006003)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXdSMHEreVFVL2FsQXEzMmJPaDVzZDBmaHQ2ZGZzeExSbGREM2VOVGUzRXc0?=
 =?utf-8?B?WkMvQVc4NjRmREdyYWxJUytNWFlmQWcwQWJJUjl5ZmtMM0N1dC84VHpKRG1s?=
 =?utf-8?B?MFRBT3VVZ3hYQ3dSTUh4VEt4ak1Ocm5WcW8zaDRXK3hRazh3clk5NEYyUXV6?=
 =?utf-8?B?NWdxSzJrdUFrUWpIOWY1RE5RYmlkQjIwK0V3TFFWMnRqekVFdmFnc0hHd05w?=
 =?utf-8?B?SGFCd21SSnB4K2p2RU9mUnRnbThzbzZ5TzJNS2NTZytmR2Q4MFhmcC9xaCtC?=
 =?utf-8?B?RHJoWnhvbHZsQXU4WWxySkNrZ2ZoejhoUUdNVkdTdUlHcHBJSzcrYi82V1J4?=
 =?utf-8?B?S3dmaUdwUjNCSytxR0pET3pQODJEUHNyR3VJYXYwQ2pCRWdRUExoREhWUzZk?=
 =?utf-8?B?M1F0anRLL1k3SDYvY0VBU0VXSEVMMFJyaDF0UUFsY3R1cmo2U0M5aHVENUF0?=
 =?utf-8?B?MVQrb0dhcklFcGdvU3RCbi8xenFYUlpGZXR2QXA5ZjdteVRMQXhUbC9TaDMz?=
 =?utf-8?B?YmJZeTYxY2pmVkVFeVZQZk1ld3NDa0MrYnpEajF0bDlDaUF5eldkWm9lUzQz?=
 =?utf-8?B?TDgwV0Y5MHVwSkJYekg1ZElnSTZQNUFXVjlLZ2dIaUVwM2ZMTng4MnpUUE9v?=
 =?utf-8?B?NVRjcyswbE5XS2kzYnl3cmJsNG9DK2VwR3hXR3JWYWs1ZDVObVZUQ2VOMDQv?=
 =?utf-8?B?S0xOb0NONVNzY3c4TmVsWkFwVGxtSHp3QndLeWZtSEdZYWZBQ3NuUlBXYzZh?=
 =?utf-8?B?NmZzeExTMU16UlhtQzhGbktvc2QyU21FV0ZQWTJ2M0xDVVZSZDlyQlp0M1k4?=
 =?utf-8?B?cUVreFJaQWRTV1NKRFNuNnV0UitsMmdvcEZOQW9ueExuQTc1YjQzamNMU05L?=
 =?utf-8?B?V1QxL2NxWDd4ejVITDNwcm1oUko0KytkZWM5eldHWjE4RVhZb1p3blpFTnhX?=
 =?utf-8?B?R0Vaa2FoUk5BYUpFNGRJaDlQVGFCNnYwa2FpUHR2cnFSOHBreUx0SUJRN3FN?=
 =?utf-8?B?dGhFM1BNZGxaUXJEWS8rUmNJajAwWDByaUNlZElVUGh1ZnhtdXZUd0M2UWwz?=
 =?utf-8?B?OXZYUTJLZUl0eU5ZOVZsOGJkMDNZOVFaSEtsWnUvZCtkWkNCbUpUUjJDOUJ3?=
 =?utf-8?B?UHMwUnVuZlViY1liakpKZnRUdy9ibWM1VmZjM3BkbjVZS004ZVBUZEIycmkz?=
 =?utf-8?B?TEU0cURRYWVGTEF3WEJGSksvZW95bWRvSVNHNFZERXh1MjVwWjludnMyMkR6?=
 =?utf-8?B?bVh2cTdrYWUwZVFuRTlJby9RREYwNGRQRlVyaHkxNis1Z01WZndFM2NQL1dx?=
 =?utf-8?B?NiszTUV0RCtjUUpsd2ZSMlVDQTNkSEZiV2NjU3hWVDRXUUlsR1VpQ0VoRmU2?=
 =?utf-8?B?YW1zUUJVaG9HNFF6RTBhZ0dhbU5ZN0lxbkR5azFTTUZQK3ZPTm44VW9Ybmhq?=
 =?utf-8?B?VUkzZ0JrTzlUOFRKU1FqRnN1R2xqeDJCNWRRZDFvaWwxdDRwdkZYU2JlRnEw?=
 =?utf-8?B?bldTdXJ2SmFWbm91WmJBVXZkM0k0cUdseU9sYlN0S1JVQytoU1duY1Z0QkZL?=
 =?utf-8?B?bGltbVhYenZZRnpoUkxCc0VLeHJsTHRxRDFLSjJFK1c4aHdRcmRBVjdySHkx?=
 =?utf-8?B?aEM3UHRrcnorWGpuSDR1QzZXTTlrVGIrYTlyWEVTMHJWZTZ2aHp0VlRFY1lZ?=
 =?utf-8?B?ZGxGeWFxVWVPR28xTG41cWJmenMwdkJvaFJkaHlnbDJ4aTZNQzZDeTVhajRO?=
 =?utf-8?B?ZC9mQ3V3K2V6d0JSSU5QK293R2Q2MzAvRERha0lVQTFUanhkNjV2NGhQc1FP?=
 =?utf-8?B?dVdRSm5TLzBRYnRUUTVMaWJxL0kzWmY1YVVKT2l4RDdUd0ZRYzJiT2RhNG9P?=
 =?utf-8?B?a05HbzlhRit6djZ1NElkT09PZS90ZFNVYzVYZ2hmdkZYbG14T1lSREd3Mmo3?=
 =?utf-8?B?WktBcW5hQTRuVitvRC9VcnFXNVhIZlFjeEdieFZFSEFFZm9MY1RXMFZjR3pp?=
 =?utf-8?B?RUw4QXpna3NTWDVTNTFLQ09CNDg0RmxEZjRXVHhkcUdvRVpYVnpLYTJZbzdw?=
 =?utf-8?B?eWgzemtaUG1HZVc2ZWN0MHhqN1FOUjZ5RXRwUG9lVHp2czBvcnRoSGgyODNm?=
 =?utf-8?B?ZjF4cUxTa2FNcWNyRlc4OHdHT3pLeWI1ZlBhOGRNbE11OVdieUwvbmVXNTFP?=
 =?utf-8?B?SlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <957978A3D4B5734584B82C15C3D7E0DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43ae66e-4265-4225-6694-08dbf0fdc8e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2023 17:08:19.1137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVqtbUK4YWqegK2mfTUKuHWFiUiNJi9m8WreqmtVSbrsrXQ2Q3kFa8yLhykE+Nvn01AlXqvEsw4BBWgwTPGHk9oHGFZmyjDUn2jpL0rKRJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7782
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTExLTI5IGF0IDIyOjEyICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gT24gMTEvMjgvMjAyMyAxMDo1OCBQTSwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+ID4g
T24gRnJpLCAyMDIzLTExLTI0IGF0IDAwOjUzIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgLyoNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCAqIFNldCBndWVz
dCdzIF9fdXNlcl9zdGF0ZV9zaXplIHRvDQo+ID4gPiBmcHVfdXNlcl9jZmcuZGVmYXVsdF9zaXpl
DQo+ID4gPiBzbyB0aGF0DQo+ID4gPiArwqDCoMKgwqDCoMKgwqAgKiBleGlzdGluZyB1QVBJcyBj
YW4gc3RpbGwgd29yay4NCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCAqLw0KPiA+ID4gK8KgwqDCoMKg
wqDCoMKgZnB1LT5ndWVzdF9wZXJtLl9fdXNlcl9zdGF0ZV9zaXplID0NCj4gPiA+IGZwdV91c2Vy
X2NmZy5kZWZhdWx0X3NpemU7DQo+ID4gSXQgc2VlbXMgbGlrZSBhbiBhcHByb3ByaWF0ZSB2YWx1
ZSwgYnV0IHdoZXJlIGRvZXMgdGhpcyBjb21lIGludG8NCj4gPiBwbGF5DQo+ID4gZXhhY3RseSBm
b3IgZ3Vlc3QgRlBVcz8NCj4gDQo+IEkgZG9uJ3Qgc2VlIHRoZXJlJ3Mgc3BlY2lhbCB1c2FnZSBv
ZiB0aGlzIGZpZWxkIGZvciB2Q1BVIGluIFZNTQ0KPiB1c2Vyc3BhY2UoUUVNVSkuDQo+IE1heWJl
IGl0J3MgbWFpbmx5IGZvciBBTVggcmVzdWx0ZWQgdXNlc3BhY2UgZmF1bHQgaGFuZGxpbmc/IEZv
ciB2Q1BVDQo+IHRocmVhZCwNCj4gaXQncyBvbmx5wqAgcmVmZXJlbmNlZCB3aGVuIEFNWCBpcyBl
bmFibGVkIHZpYSBfX3hmZF9lbmFibGVfZmVhdHVyZSgpDQo+IC4NCj4gDQoNCkluIHRoYXQgY2Fz
ZSB0aGUgInNvIHRoYXQgZXhpc3RpbmcgdUFQSXMgY2FuIHN0aWxsIHdvcmsiIGNvbW1lbnQgc2Vl
bXMNCm1pc2xlYWRpbmcuIE1heWJlICJ0aGlzIGRvZXNuJ3QgY29tZSBpbnRvIHBsYXkgZm9yIGd1
ZXN0IEZQVXMsIGJ1dCBzZXQNCml0IHRvIGEgcmVhc29uYWJsZSB2YWx1ZSI/DQo=

