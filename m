Return-Path: <kvm+bounces-3623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48152805E4C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66C201C2106F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 19:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A8469286;
	Tue,  5 Dec 2023 19:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m+kkNoFe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC3FB0;
	Tue,  5 Dec 2023 11:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701802998; x=1733338998;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IbHSdREHgd7O1FQ/47PudSb0sVl21m0Dz/eFmLG5FP0=;
  b=m+kkNoFe6HunFm2ZEXxnr9hQGzhdli9u0f91VczeUWnMaoE+a2/q+DD7
   E64GGObXnKPmDmx4kZnD4fNCUtZ1yx3MWFkeTpA54b4yeNf5jVN05PPTx
   VdBDCKaPm5KKsOdhSU/K9wXePxHEp+x2cyFow3wUW3VlOMEpQYOGV9TFS
   5TdVkLKaL7PWJUCJytpOPe6wfKuAbB6xV20pvQtHdnq4+NFASTNxRL7ey
   794UkdDYvkRG3Gy27sLawOr8kq5I5W6Y6Dk2809AqRuKAb2kcny2EuoP4
   M7s2u5AlAmvCR8oN3BBGMyBG0DKDo+8fAJ0jCYcD6gf51FJFooF9eUJKJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="480138636"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="480138636"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 11:03:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="19059575"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 11:03:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 11:03:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 11:03:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 11:03:14 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 11:03:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsI/2HWKNzM8FlVVPU4k2cO0Yg8vEAXksF9uu0OAxdV+pOTqquw4QhU8dLBQVTzCgz+JgDGbJvAaAMn8WHl4iN/e7jMTUmdBUC19V6Y0oissOM1rKCeXUiqFk6DTmiv7ua8HSwLVxwbhgaARTSQMpRIlGbnWXamJ0luBJDIr0CGOhWKsjWzTZLGaruTvENVqrp0awXBya4gltxw34aE0Blth8wy6Bit9EkMfisK52W8PTcQE235DmSYTXFN2OXqZYk8MGwqaF5r9sBypJECzsyfMqxtQbI0MkIlJKL68CsiaLzISspQlFJVy4z1DdORulqi/uM/TlCduQcgTIkXzsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbHSdREHgd7O1FQ/47PudSb0sVl21m0Dz/eFmLG5FP0=;
 b=iOwj7/AuM1Xagq4v+CMbDtie/yVSVtN82Qwu8zlb7bA8iw8qh+i1Mb1X1gkdjJKodsePunZ/uwpI3G853BHFv4I20J1FScv+o+mZJUpfkuvgQwwHuEs/U+DT8hrHbyq6SHkma794Tnk2IZfWk1y51M0mCTkI6PMme9yAQyn/gexjh3I+cPIJL80QMDUvBsGSivrybY8tkAJYLsfy4EL+Kw7gd+LsdDSAIWYQALI8ok5oX11FfC1sbOL7ZKL9xmJKWqMM1IVfOSin/CYRXNMRQCpYsxEZtrL17inJZ/ZyCjhAcYLyG7GuAtao/Ga8hZAaU0bLcAwPjpFT6OO5mftJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by BL3PR11MB6484.namprd11.prod.outlook.com (2603:10b6:208:3bf::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:03:11 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:03:10 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Lutomirski, Andy"
	<luto@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gross, Jurgen" <jgross@suse.com>, "Shankar, Ravi V"
	<ravi.v.shankar@intel.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>,
	"jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v13 26/35] x86/fred: FRED entry/exit and dispatch code
Thread-Topic: [PATCH v13 26/35] x86/fred: FRED entry/exit and dispatch code
Thread-Index: AQHaJ215PhEOYu43sEObVSTXzfHZOLCanWSAgABu2VA=
Date: Tue, 5 Dec 2023 19:03:10 +0000
Message-ID: <SA1PR11MB67340C4246F7BED4D0B09837A885A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-27-xin3.li@intel.com>
 <f260ddf9-be67-48e0-8121-6f58d46f7978@citrix.com>
In-Reply-To: <f260ddf9-be67-48e0-8121-6f58d46f7978@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|BL3PR11MB6484:EE_
x-ms-office365-filtering-correlation-id: 0ae2fddd-1399-4091-2058-08dbf5c4d300
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Myh7rlO5no9CkAaaWvDg9XNOm5kuzJpdruAkVAdjJiBkyDfmnfRcUz6UhABCCm7fexgY/T7ArHpW73lK/pUDoocOoK4HVa6ULsbV2b+81+ypZ1695ew9cjmAk5R6w9wpAVjR6ryIeI2H1eCvRaozWBQnPyxBwxII+PnUuYc/FLvlT0MRw/U9RSDLCxSKZ5+MfmqD6jI3va+LAQmbkSeNt4xt6DfENQ4OTXCCXBPgEhDeAek8WWlJ/IQApldL4HoEMM8e08UAn1iRv6Nyna/8N1KKv1Z5/8FDlXYB/zntIfvOd8s65R+RVZbxRyQzaa7ZhAtUvw4xC3ugMo9is5dmn9bcjDU0BUYz3lPx6Rj3+Vi66yHUdoc2vcvONGISeOQcKsxdEv7B7tigIUzcwBvHAiZkFoD8DjSjTeZJHwtRT87fsOXn2jbgQQnSADpHbbJbN77/DlYfy0DNaRpoJJpIGDfh4vs+nSqYwDClVz2aRnwKLZRQOtwtbQ1EiRHpJIs5xJKF8YFw4SdGiM/pjvGN9i0ZHrJ0gz3Xi7tt+JnMzy4Zhy6UGb52dzo2QNo+1S5yxCS+rCu5TluFhQ3UiyJBuAKOYd014bbeXOKKxeSJLIibRGGVXH4EavIysNB2TNZ/paaOv9PIUxVchNUhDdbAUkIJZLRzc9cndXCAUO7jYH4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(376002)(396003)(366004)(230922051799003)(230173577357003)(230273577357003)(186009)(64100799003)(1800799012)(451199024)(7416002)(2906002)(33656002)(110136005)(316002)(66476007)(54906003)(64756008)(66446008)(66556008)(38070700009)(76116006)(8676002)(86362001)(66946007)(55016003)(52536014)(41300700001)(8936002)(4326008)(5660300002)(122000001)(38100700002)(82960400001)(83380400001)(478600001)(26005)(71200400001)(7696005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzFMMXFYbGZNaHFPSUZTUlh4NktMOFlsdS9kRVFONU1RN3RYK0RicmgwN1l4?=
 =?utf-8?B?V1FBWXp6QkREUHB2NGpQaFVFQ0xEdEF6SGhtcEwwblRkY0IrMmZXYm9MT1dj?=
 =?utf-8?B?MWY5ZGw2TjRIelVUTWJRR1JNWjdjTFJiV3pKZ3pqQm9uVmtYSCtEQTI4b1Fs?=
 =?utf-8?B?SCswZWIyTEp5M1UwNHJveTNtWUhaaFBnYUtLQ1YzNDNJeXhQR3MxYTJYWGRm?=
 =?utf-8?B?NDNwRkRsQVo1eEZwQzNadWdUMHJraE0xcVl4K0xRaGd1S0FPSzFNY2t0MjVR?=
 =?utf-8?B?VEt5dHBDUFgyMDZUOW51OW9jcHJmdjR1c3FJdlJWZjJ3RW91QWVDKzVqbzBK?=
 =?utf-8?B?K2JxNDNzZWFMVUxoZVBsbGZmQ2hxQXlaTWZtN0kxUEs0d2djTS8rUzJaWkNt?=
 =?utf-8?B?QWdOVXMxYnpuRnRKeDJKQUQ5ZEs1WHpOTkxsUEM2VjJtcW16a3JURzJ6NXFn?=
 =?utf-8?B?VUxwYWkxZzB6eHdWS3BFQnpuNnEyNjRZc2hqYlpFcjNqSjV2bHg1cVhrdWpB?=
 =?utf-8?B?UzB1VkFuV3dCQzRGMXRDOGtIZFovNk1UYnFxZnlDTzVCbCtWSTdLTWdiTkt0?=
 =?utf-8?B?dXNwdTVrTytXRXo2UFlKSVFxTVRjUEEwd2ZnZGptSTZkczNYSitkUTZhZ0V2?=
 =?utf-8?B?U1E0VkpsWWduVkNQa3JmQXBldzd1OU4rUmRqelRGNVhwTllVZkJQUHY1Nzdk?=
 =?utf-8?B?ZU5OUTgrbFZ4cDZIYk9CZWViVE1wa1E3cDRzSEFoR3lIOUVReDJaR0FhcFFj?=
 =?utf-8?B?S0c1dVVDNGczY0JRNFF5STNZbUJBcmIxU0FKRmxjTW0reDhyNlpuaUJoMytT?=
 =?utf-8?B?SENMamVmSnZOSS9pNlYrZklYOHNHMXBaZ0pldklMcjVNVHI5Y2RqSnkyWkxw?=
 =?utf-8?B?Y2JTdFBXOVdXMjRqT2h2RVlES3ExOTJpeHZ2TzZyUnAvWFMrNmxveWZYOHY2?=
 =?utf-8?B?bU5Ed3AveFg5MGdHVDUzQ2tHVzgzT3VOeFN4R0hMZWJvUHVOc2Y1YklzK3NX?=
 =?utf-8?B?cGdJVlNRS2VpaFh5NGpHQm9aRWFjdzhkY2RyN2FCWjhFa0tscENOL2tSaXdE?=
 =?utf-8?B?NnZXSUZNSXd3dHNjeURYM3kxSmhOSmJFQ1Rha1NyeWRINklxbW83RUxoZHN0?=
 =?utf-8?B?R21aV1dBdDhwWm10ZjY3RTFWTzJRbEo5NFJLc1pJUC8yanhrRkNBclI2QnlE?=
 =?utf-8?B?VU53Y1ArOVhka1VKNm5jQ2Y5OHNJcThvN2ZOY1dTeHlXYjBoNUlQMzd6T2dK?=
 =?utf-8?B?LzI5RWlPTmZLN1pMYlR3NjdYdy8rTDhHYXI5QzRXb2NnVS9JR2xWZkRVT1Rm?=
 =?utf-8?B?NktIeTdUd0lQN3RxVGswWElLZXJOTitndHBJdDREM2tjVWxVbzVJNDF0azEv?=
 =?utf-8?B?c0JQaW9uSGRUTnBGTGtzQ0JNaXlqOXZDeGhDby93eUROZDZ0U0FOTkE1Vk9l?=
 =?utf-8?B?eVc1OVVQM1lHZWgvamxJcGw4SnBaeE84bWFvbThQZ3BUNUltWWUwNXk4K1NI?=
 =?utf-8?B?N2ozWTQyOUpIWksvbzd4dllQdGdMY2tUUVNFODNiTXZMbGFyK0JlOG5CeEN0?=
 =?utf-8?B?cUFtV2tnakRYK1lwdkJkeStjckZWazdRQk9VN1VoMFhOTUV5b2tUZzZhdlF4?=
 =?utf-8?B?ajROS3JLNXBob2FQKzBLRG9DM1RTSFpFS1l6UmZ4emVqRktxRllocXR6dXdG?=
 =?utf-8?B?amY4UUJKRjVWR1NDNVlUTWcrTTlySW81UlhjNC9mUEd4S0hrdGpsZC85Y1NK?=
 =?utf-8?B?d1BveTdrQy9xZldvMzV3bzlGdjVrK1hWZVVEd2RVMHpzOEUrRkg2V29aV2Ir?=
 =?utf-8?B?c3NkaUhNSXJTRy9ablJMM285dWhRUmR3WGpOdUZxNlRYTTAvT3hCN0FCMTUz?=
 =?utf-8?B?S29FcUxDM3ozdlFPVCtDekJjR2pVdDZqRkh2VElEY1F1emxTVUtjd3ZkWm9k?=
 =?utf-8?B?Y3VkTGxNcUJjLzY1elByc0RWbm1jVDNCNWlmcjNRNmFubE9LaSsvdUJmS0tC?=
 =?utf-8?B?OW5POW5XMnk3VGl1YWdQR0x5TWtyWXdQbUdlMENYbFYzSE9TaGRlemtaOE92?=
 =?utf-8?B?RWE0c0JsWnVCWjNCU1UzMnFBM0MzeU9ZWEQxL2p3ZHJmQTlGZ0ZIYTRhajdG?=
 =?utf-8?Q?gE4U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae2fddd-1399-4091-2058-08dbf5c4d300
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 19:03:10.5372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQ3Xyz2tASN1Ng3UgXyBkestW0RIZw6sfPBAzs90REklTrIKtn7dtFmViCP9yRQPxRGEglvYrpMg5TWIjBE5ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6484
X-OriginatorOrg: intel.com

PiA+ICtzdGF0aWMgbm9pbnN0ciB2b2lkIGZyZWRfaW50eChzdHJ1Y3QgcHRfcmVncyAqcmVncykg
ew0KPiA+ICsJc3dpdGNoIChyZWdzLT5mcmVkX3NzLnZlY3Rvcikgew0KPiA+ICsJLyogSU5UMCAq
Lw0KPiANCj4gSU5UTyAoZm9yIG92ZXJmbG93KSwgbm90IElOVC16ZXJvLsKgIEhvd2V2ZXIuLi4N
Cj4gDQo+ID4gKwljYXNlIFg4Nl9UUkFQX09GOg0KPiA+ICsJCWV4Y19vdmVyZmxvdyhyZWdzKTsN
Cj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJLyogSU5UMyAqLw0KPiA+ICsJY2FzZSBYODZf
VFJBUF9CUDoNCj4gPiArCQlleGNfaW50MyhyZWdzKTsNCj4gPiArCQlyZXR1cm47DQo+IA0KPiAu
Li4gbmVpdGhlciBPRiBub3IgQlAgd2lsbCBldmVyIGVudGVyIGZyZWRfaW50eCgpIGJlY2F1c2Ug
dGhleSdyZSB0eXBlIFNXRVhDIG5vdA0KPiBTV0lOVC4NCj4gDQo+IFNXSU5UIGlzIHN0cmljdGx5
IHRoZSBJTlQgJGltbTggaW5zdHJ1Y3Rpb24uDQo+IA0KPiA+IC4uLg0KPiA+ICtzdGF0aWMgbm9p
bnN0ciB2b2lkIGZyZWRfZXh0aW50KHN0cnVjdCBwdF9yZWdzICpyZWdzKSB7DQo+ID4gKwl1bnNp
Z25lZCBpbnQgdmVjdG9yID0gcmVncy0+ZnJlZF9zcy52ZWN0b3I7DQo+ID4gKw0KPiA+ICsJaWYg
KFdBUk5fT05fT05DRSh2ZWN0b3IgPCBGSVJTVF9FWFRFUk5BTF9WRUNUT1IpKQ0KPiA+ICsJCXJl
dHVybjsNCj4gPiArDQo+ID4gKwlpZiAobGlrZWx5KHZlY3RvciA+PSBGSVJTVF9TWVNURU1fVkVD
VE9SKSkgew0KPiA+ICsJCWlycWVudHJ5X3N0YXRlX3Qgc3RhdGUgPSBpcnFlbnRyeV9lbnRlcihy
ZWdzKTsNCj4gPiArDQo+ID4gKwkJaW5zdHJ1bWVudGF0aW9uX2JlZ2luKCk7DQo+ID4gKwkJc3lz
dmVjX3RhYmxlW3ZlY3RvciAtIEZJUlNUX1NZU1RFTV9WRUNUT1JdKHJlZ3MpOw0KPiANCj4gYXJy
YXlfaW5kZXhfbWFza19ub3NwZWMoKQ0KPiANCj4gVGhpcyBpcyBlYXN5IGZvciBhbiBhdHRhY2tl
ciB0byBhYnVzZSwgdG8gaW5zdGFsbCBub24tZnVuY3Rpb24tcG9pbnRlciB0YXJnZXRzIGludG8N
Cj4gdGhlIGluZGlyZWN0IHByZWRpY3Rvci4NCj4gDQo+ID4gKwkJaW5zdHJ1bWVudGF0aW9uX2Vu
ZCgpOw0KPiA+ICsJCWlycWVudHJ5X2V4aXQocmVncywgc3RhdGUpOw0KPiA+ICsJfSBlbHNlIHsN
Cj4gPiArCQljb21tb25faW50ZXJydXB0KHJlZ3MsIHZlY3Rvcik7DQo+ID4gKwl9DQo+ID4gK30N
Cj4gPiArDQo+ID4gK3N0YXRpYyBub2luc3RyIHZvaWQgZnJlZF9leGNlcHRpb24oc3RydWN0IHB0
X3JlZ3MgKnJlZ3MsIHVuc2lnbmVkDQo+ID4gK2xvbmcgZXJyb3JfY29kZSkgew0KPiA+ICsJLyog
T3B0aW1pemUgZm9yICNQRi4gVGhhdCdzIHRoZSBvbmx5IGV4Y2VwdGlvbiB3aGljaCBtYXR0ZXJz
IHBlcmZvcm1hbmNlDQo+IHdpc2UgKi8NCj4gPiArCWlmIChsaWtlbHkocmVncy0+ZnJlZF9zcy52
ZWN0b3IgPT0gWDg2X1RSQVBfUEYpKSB7DQo+ID4gKwkJZXhjX3BhZ2VfZmF1bHQocmVncywgZXJy
b3JfY29kZSk7DQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXN3aXRjaCAo
cmVncy0+ZnJlZF9zcy52ZWN0b3IpIHsNCj4gPiArCWNhc2UgWDg2X1RSQVBfREU6IHJldHVybiBl
eGNfZGl2aWRlX2Vycm9yKHJlZ3MpOw0KPiA+ICsJY2FzZSBYODZfVFJBUF9EQjogcmV0dXJuIGZy
ZWRfZXhjX2RlYnVnKHJlZ3MpOw0KPiA+ICsJY2FzZSBYODZfVFJBUF9CUDogcmV0dXJuIGV4Y19p
bnQzKHJlZ3MpOw0KPiA+ICsJY2FzZSBYODZfVFJBUF9PRjogcmV0dXJuIGV4Y19vdmVyZmxvdyhy
ZWdzKTsNCj4gDQo+IERlcGVuZGluZyBvbiB3aGF0IHlvdSB3YW50IHRvIGRvIHdpdGggQlAvT0Yg
dnMgZnJlZF9pbnR4KCksIHRoaXMgbWF5IG5lZWQNCj4gYWRqdXN0aW5nLg0KPiANCj4gSWYgeW91
IGFyZSBjcm9zcy1jaGVja2luZyB0eXBlIGFuZCB2ZWN0b3IsIHRoZW4gdGhlc2Ugc2hvdWxkIGJl
IHJlamVjdGVkIGZvciBub3QNCj4gYmVpbmcgb2YgdHlwZSBIV0VYQy4NCj4gDQo+ID4gKwljYXNl
IFg4Nl9UUkFQX0JSOiByZXR1cm4gZXhjX2JvdW5kcyhyZWdzKTsNCj4gPiArCWNhc2UgWDg2X1RS
QVBfVUQ6IHJldHVybiBleGNfaW52YWxpZF9vcChyZWdzKTsNCj4gPiArCWNhc2UgWDg2X1RSQVBf
Tk06IHJldHVybiBleGNfZGV2aWNlX25vdF9hdmFpbGFibGUocmVncyk7DQo+ID4gKwljYXNlIFg4
Nl9UUkFQX0RGOiByZXR1cm4gZXhjX2RvdWJsZV9mYXVsdChyZWdzLCBlcnJvcl9jb2RlKTsNCj4g
PiArCWNhc2UgWDg2X1RSQVBfVFM6IHJldHVybiBleGNfaW52YWxpZF90c3MocmVncywgZXJyb3Jf
Y29kZSk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX05QOiByZXR1cm4gZXhjX3NlZ21lbnRfbm90X3By
ZXNlbnQocmVncywgZXJyb3JfY29kZSk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX1NTOiByZXR1cm4g
ZXhjX3N0YWNrX3NlZ21lbnQocmVncywgZXJyb3JfY29kZSk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQ
X0dQOiByZXR1cm4gZXhjX2dlbmVyYWxfcHJvdGVjdGlvbihyZWdzLCBlcnJvcl9jb2RlKTsNCj4g
PiArCWNhc2UgWDg2X1RSQVBfTUY6IHJldHVybiBleGNfY29wcm9jZXNzb3JfZXJyb3IocmVncyk7
DQo+ID4gKwljYXNlIFg4Nl9UUkFQX0FDOiByZXR1cm4gZXhjX2FsaWdubWVudF9jaGVjayhyZWdz
LCBlcnJvcl9jb2RlKTsNCj4gPiArCWNhc2UgWDg2X1RSQVBfWEY6IHJldHVybiBleGNfc2ltZF9j
b3Byb2Nlc3Nvcl9lcnJvcihyZWdzKTsNCj4gPiArDQo+ID4gKyNpZmRlZiBDT05GSUdfWDg2X01D
RQ0KPiA+ICsJY2FzZSBYODZfVFJBUF9NQzogcmV0dXJuIGZyZWRfZXhjX21hY2hpbmVfY2hlY2so
cmVncyk7ICNlbmRpZiAjaWZkZWYNCj4gPiArQ09ORklHX0lOVEVMX1REWF9HVUVTVA0KPiA+ICsJ
Y2FzZSBYODZfVFJBUF9WRTogcmV0dXJuIGV4Y192aXJ0dWFsaXphdGlvbl9leGNlcHRpb24ocmVn
cyk7DQo+ID4gKyNlbmRpZg0KPiA+ICsjaWZkZWYgQ09ORklHX1g4Nl9LRVJORUxfSUJUDQo+IA0K
PiBDT05GSUdfWDg2X0NFVA0KPiANCj4gVXNlcnNwYWNlIGNhbiB1c2UgQ0VUIGV2ZW4gaWYgdGhl
IGtlcm5lbCBpc24ndCBjb21waWxlZCB3aXRoIElCVCwgc28gdGhpcw0KPiBleGNlcHRpb24gbmVl
ZHMgaGFuZGxpbmcuDQo+IA0KPiA+ICsJY2FzZSBYODZfVFJBUF9DUDogcmV0dXJuIGV4Y19jb250
cm9sX3Byb3RlY3Rpb24ocmVncywgZXJyb3JfY29kZSk7DQo+ID4gKyNlbmRpZg0KPiA+ICsJZGVm
YXVsdDogcmV0dXJuIGZyZWRfYmFkX3R5cGUocmVncywgZXJyb3JfY29kZSk7DQo+ID4gKwl9DQo+
ID4gK30NCj4gPiArDQo+ID4gK19fdmlzaWJsZSBub2luc3RyIHZvaWQgZnJlZF9lbnRyeV9mcm9t
X3VzZXIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpIHsNCj4gPiArCXVuc2lnbmVkIGxvbmcgZXJyb3Jf
Y29kZSA9IHJlZ3MtPm9yaWdfYXg7DQo+ID4gKw0KPiA+ICsJLyogSW52YWxpZGF0ZSBvcmlnX2F4
IHNvIHRoYXQgc3lzY2FsbF9nZXRfbnIoKSB3b3JrcyBjb3JyZWN0bHkgKi8NCj4gPiArCXJlZ3Mt
Pm9yaWdfYXggPSAtMTsNCj4gPiArDQo+ID4gKwlzd2l0Y2ggKHJlZ3MtPmZyZWRfc3MudHlwZSkg
ew0KPiA+ICsJY2FzZSBFVkVOVF9UWVBFX0VYVElOVDoNCj4gPiArCQlyZXR1cm4gZnJlZF9leHRp
bnQocmVncyk7DQo+ID4gKwljYXNlIEVWRU5UX1RZUEVfTk1JOg0KPiA+ICsJCXJldHVybiBmcmVk
X2V4Y19ubWkocmVncyk7DQo+ID4gKwljYXNlIEVWRU5UX1RZUEVfU1dJTlQ6DQo+ID4gKwkJcmV0
dXJuIGZyZWRfaW50eChyZWdzKTsNCj4gPiArCWNhc2UgRVZFTlRfVFlQRV9IV0VYQzoNCj4gPiAr
CWNhc2UgRVZFTlRfVFlQRV9TV0VYQzoNCj4gPiArCWNhc2UgRVZFTlRfVFlQRV9QUklWX1NXRVhD
Og0KPiA+ICsJCXJldHVybiBmcmVkX2V4Y2VwdGlvbihyZWdzLCBlcnJvcl9jb2RlKTsNCj4gDQo+
IFBSSVZfU1dFWEMgc2hvdWxkIGhhdmUgaXQncyBvd24gZnVuY3Rpb24gYW5kIG5vdCBmYWxsIGlu
dG8gZnJlZF9leGNlcHRpb24oKS4NCj4gDQo+IEl0IGlzIHN0cmljdGx5IG9ubHkgdGhlIElDRUJQ
IChJTlQxKSBpbnN0cnVjdGlvbiBhdCB0aGUgbW9tZW50LCBzbyBzaG91bGQgZmFsbCBpbnRvDQo+
IGJhZF90eXBlKCkgZm9yIGFueSB2ZWN0b3Igb3RoZXIgdGhhbiBYODZfVFJBUF9EQi4NCj4gDQo+
ID4gKwljYXNlIEVWRU5UX1RZUEVfT1RIRVI6DQo+ID4gKwkJcmV0dXJuIGZyZWRfb3RoZXIocmVn
cyk7DQo+ID4gKwlkZWZhdWx0Og0KPiA+ICsJCXJldHVybiBmcmVkX2JhZF90eXBlKHJlZ3MsIGVy
cm9yX2NvZGUpOw0KPiA+ICsJfQ0KPiA+ICt9DQo+IA0KPiB+QW5kcmV3DQoNCg0KVGhhbmtzIGEg
bG90IGZvciB5b3VyIHF1aWNrIHJldmlldywgd2lsbCBhZGRyZXNzIHNvb24uDQogICAgWGluDQo=

