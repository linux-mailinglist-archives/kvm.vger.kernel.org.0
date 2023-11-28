Return-Path: <kvm+bounces-2546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 404FB7FAF90
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 02:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 634B81C20C35
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 01:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C7F20F6;
	Tue, 28 Nov 2023 01:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8/knSIo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EA81B8;
	Mon, 27 Nov 2023 17:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701135132; x=1732671132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VL1KyR4WQR5qK+7XJxChhIc14KSvV1PKB+4cTAgXos0=;
  b=Z8/knSIoy3Rh7OV5PC/n2MznhbGwv7u8oUeUEpNvDmsSYc+4kpMi59Pc
   A1fRen10t/u8aiJBgdXalPHVARq6mm3Jsul1FB7bj8qDFpRdLE4EK1tJB
   FgMfRHGqZVYAj1b6T89WI70Na6DrkEh570/xemQQ2RKNHoKrjoR6gO7Nq
   oQIwIZCyclFs+kpckImsA9v5fk8F/KcPpGrpoVwbDpt8hzKTW9OH+ZGhy
   HlP/F23ysv7KSROeIoIIZz8ecENYhL9Z/mxFt73du9vEGCnuFGQtJP75v
   fBlh5UkL7EKG1KIt0ChvGD9Mqu6RLPJ9I54rctiHiqJKzya6RLYOMIxDD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="389981711"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="389981711"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 17:32:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="744757752"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="744757752"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 17:31:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 17:31:18 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 17:31:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 17:31:18 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 17:31:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdQE+Z8yxEU7KYmGSZM2GFdelQB04GEntEfsuUENGLtP51XEkVl7M3tvaiHerDQ16IRbR0HhnbGtWhMBv/YpVEjkyHmdD6iOCvB0J5eKo/UTYdNwhwzOdyaMAz0L+YKPdC1Xkvow1+ucx7Xl7YlEiy2QQPlEwPpBcBBlYNNw4UDKQWuvaccGGvtYO/G2/rf2NQWkKEIojf4MDnq5e7ZFfufMy+Jqnl/9jK/Jq/oF4iQnomh8QA13FovK/bye+/dw1NfD5JLW+o/tHkPwROzSsAmgb3EKbyekAegZrggtllP9ffBD/Ov2NHqmJNzdic6HyD2dZ8Ti+18UvIFMRILb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VL1KyR4WQR5qK+7XJxChhIc14KSvV1PKB+4cTAgXos0=;
 b=ZoU6KRy8kcO8ZHenvYjrVSoT/TEF+Bj/ol78D8sPqRfDBdv5Hyi7PO0CHm5mspuXqfYRaXOkAotyMdQd5ZqX7xd3js6yhi8OUS94yFnLd0nOtFTKBXHkFaiUi+g4mqIInXVTDNiJd7wFlIzxZp/9xYgYynvnNHQ2p751eJJ2G8HymLSX2Pi81gc921I1owcfgxARqlziR7pZ5UF03mR8QGqsGhZYn7aiTSxFKiDBzeXepSIjvpkz7GpufwEsNkhWFcKjrQ9WywRI3DTz94MdmtjEA6PxPLzXfX5trz0D8ZcoutwgoJEobUp1KiH3SmvL7JHq0CIYM+5I3iFjbMYErw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4564.namprd11.prod.outlook.com (2603:10b6:5:2a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28; Tue, 28 Nov
 2023 01:31:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9%6]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 01:31:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "john.allen@amd.com"
	<john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
Thread-Topic: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
Thread-Index: AQHaHqwJhO6d42WHGEKS+emnbAz9lbCJNy2AgAXAoIA=
Date: Tue, 28 Nov 2023 01:31:14 +0000
Message-ID: <a45c2e25aaa1f195e7fccff6114374994ffbc099.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-3-weijiang.yang@intel.com>
	 <20231124094029.GK3818@noisy.programming.kicks-ass.net>
In-Reply-To: <20231124094029.GK3818@noisy.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4564:EE_
x-ms-office365-filtering-correlation-id: 03e50990-d4d5-4bb0-21a2-08dbefb1b608
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2qpi6+V9Fhx0Xce7uYl5WNRZ703zuc7HSZhgRinO0T3L4vpOXoXfroWmAaAyVa2ovrIWcmFirXASZS6OtAh9T0ANLDW4jEHpRKuJYJJt4BScB5cXsXIaXubt0jofJMhTWwY52Tkqy3cWotreICFXb7hrtjppv1SzDg81+GgJCf+A+/A8nNoIl4X+roTq2UhOitmGSeH+9NSUu3oZ8aRv0A/1K56lqRhOFn4pErhj3aGTiHtZXSMcWt0J9a0ZtzCS/bRDSfJQYyFuVLL9EufgCrA2EPdRrXnF5pbk/CdLmDLeboW907056JktTWh63z4qIhoW8X1SAF/PDoi31kCVgSnzStAJZA0av2u4UudLerQ+fVajZXVGuJZUZu8lqtyWS+M4PF6n5hISYmEtVkMq8ZXHYDtHV2DrD+DGZqxY0M+lM30Z8Yjto/FA58TkFBWThpdWnD5Qe02dbj0BvEXqtn2HcUSAaZOV1nfQfod9UZ6U5zSfikIsbrrfGm1QCLhAb2oT2JN4dM69uMqVvvEwGAi4ZsluBq23ZMWsUTDeC3ZjJJwwjJOXHkBZZW5wSXGgThcXfG6PWf+ZXG2FcbVuoxwvbspSgr4iT935m1mIbsAZogdQJikw7VcVI21cXXX4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(39860400002)(366004)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(38100700002)(41300700001)(36756003)(86362001)(4001150100001)(38070700009)(122000001)(4744005)(5660300002)(82960400001)(26005)(2616005)(2906002)(71200400001)(6512007)(6506007)(8676002)(4326008)(8936002)(478600001)(6486002)(66446008)(66946007)(64756008)(54906003)(110136005)(76116006)(91956017)(66476007)(66556008)(6636002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2FMRVR2NlJHUlNlcXJ4bHoyOGswdmFQNTNGN0VRS1hmbm5WdWIzbzgwSWdO?=
 =?utf-8?B?YzdtQnExdForcXBmR2IwVFpLRmoyOUkySXpRVmtZdFFrQk1mVU9BL2pnTUdI?=
 =?utf-8?B?RkhmeWErdE9zRWtrSk00ZytaekQ0TUlhTzBxbjBaaTVEU0F4SnQ0WHBuQXRJ?=
 =?utf-8?B?MDRxbUFKZERxRWFmUHlEbVFaMDB6eS8zZ0dCY1pFWnhseFhsU1JlWHpvVXNB?=
 =?utf-8?B?Vy85ejEyRlZ3ZnJ1VjNsR2N5eHdBTXNaRHY1QnRHUEhURWtvQXRzTU5mc3Ax?=
 =?utf-8?B?UTAvZmxzRGo1QkwvT1JlTzhTRFJUZ3JPUjVRYlNzWExRa3RRQWduYUU3aVd3?=
 =?utf-8?B?eW1XV210UmNJTTg5NWtYN0sybEpQYWcyZFZaWTdINEt2dlpaSklKalJ5ZXBF?=
 =?utf-8?B?MWNKYS8xN09nRHF2S3NmZy9lbVQrMjBxS1BJYnJIWUxTODNESERLVVgyZXVU?=
 =?utf-8?B?ckc0T3VJSzQ5djVpcXhIUkpCcjl2c0E0TUg0aTdlSVZmNXI2TVNzNnhSdVBW?=
 =?utf-8?B?SnIzYmJhS1NRZUtKdm8wRlpkT2RRWU5zQWxKTVhOckFybE1vQXA4Q2krWE5p?=
 =?utf-8?B?ajZqRTAvblRKTS9BSnFXMjJZSDYwOWlPRkpiNDVzVGpwS1FsMEp6WEJiY3VN?=
 =?utf-8?B?MVFwK1FHRVFRdmpFQjViZjM5TVNlSjNlRUVTYkR3NHIrZ09CZldtRUh1dTNV?=
 =?utf-8?B?akR5TDNxMGx4bFdRelVzdFhISGcva1ZTZm1jeHVWdzhhMEZtU3RKSWxSclVO?=
 =?utf-8?B?VXgyclVVa2F2UlZVWUFqNkpJMlFuTTU1cG90OUExcVV6WUI3UXc3bUcwbkVJ?=
 =?utf-8?B?bmFCSXR3RFNNejhCajNUbjc3NWtnRjZEVnNKZzRCaExVcmhLUjgrRXNKajNx?=
 =?utf-8?B?YVU2TGRjZmx2aTdkZExTaUtXbEU2dHB4d1J2cTJINWpCaEJrbjJVenFXeEJJ?=
 =?utf-8?B?VEIxdTR5c3RkaE1SUktjTjlnd1NUaU16anhHRTZ2YVJHbVlzV3pVYmJ1Znlj?=
 =?utf-8?B?S2Raa1IvODV4SEFZdWVObUZ6QnN3K2V2RHZxYy83ajd6ZFNHVmdTK2NOdnQr?=
 =?utf-8?B?RytOQm15LysyZ2pnSjZvM01vZ2tITmdlV01ZM3Z1ZFpIQTBDeUQyK3VMSDZv?=
 =?utf-8?B?QW4wNUFER2tIOWdDa3BqVlF3Qlc4NHdqRllidjFLK0dhU3YxbVRLNjMyQlMy?=
 =?utf-8?B?MFRSYU5BWjF1bzUxNWNkdlMwcHM1a2VGVkZZM3lIWExvSEFDUTRSNnYwZnVl?=
 =?utf-8?B?dzJZMjc3VVd1Nm5NUEJhY3luL2dXSi9rdnhWa09ZY0wxZmhieU9IK1ZGb3Z2?=
 =?utf-8?B?MEVlaS9QSkRoMUhyT0d0T0dzeG44UzRFWlRiZEhrUGUwZXRIL0dYNWdzUXJC?=
 =?utf-8?B?U0tQUTd3a0swcFZYNWl3VEhsb2U5R0VTTWl1QUdSQ1QzNjhzeTJwWHA4U3dk?=
 =?utf-8?B?K2srMjAzT0s1Tk1BSXFBOWwrWWxxcFFOZmwySnRTQjNmQWFsOTlaSW05ek1r?=
 =?utf-8?B?ZVdvUGNlWUFNUVVER0JvYnhQWitxM1J5SDNVOU00MnVrODBDSkxCMytqUjZz?=
 =?utf-8?B?NWpYVWJMRUI3NkN1Z0xsd29WQU10QkE5d1g3RzNLcE11ay9sMmdLSlUwdFJV?=
 =?utf-8?B?cTZJeUd2Y0tJc0JxVmorUGtYNEswaGhGb1h0Q1ZiOGFqTk04cU9XZXVOVUZT?=
 =?utf-8?B?dVB2eGlodFNxNUFQQWhkOHNOcXlIV2Rpb3lZTVQ5WER6SnI2NjUxM0xuRUwx?=
 =?utf-8?B?Sm5RUW9hcmVIZ1h1enRvV3VFRnNsNDVBZXRZVTRFOUtPbGZHWVBUckZRWDZS?=
 =?utf-8?B?bi9aTjgvRXoxcXR2S0dNSUZlaG1YZ1U0ZW5iYmpBTGVyVFhTcGxuNjUyektF?=
 =?utf-8?B?dnd2VXRCa1I2MzhUQ3lya3VsdEtXc1RPRnVwMTkwazBEcVVmSDFQSWlPTnU5?=
 =?utf-8?B?M05kbGoxbk8vM0ozcGhpTi9EYXNDZXg3NkJpVDExTm5JTmZrMmhxck9jR3pB?=
 =?utf-8?B?YmR0ZTFLN0ozRWhjVDhRclRNVjFwSHpkNVRnaURobFpvTUIvT3NFaUgxVEtB?=
 =?utf-8?B?OXZpRDFWZjRmOU5lcmVHS0pZaGloajR3YXRSS3UrRVNmMkF4czB5RmJIRVZP?=
 =?utf-8?B?bkpQZGtneHpNa3Y1T0pOUzJJRUtGUG93aXNOU2VGbTVTY2F4dC80czlEUWNV?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71A9D33C2E710646A11EDDFD560E6D27@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e50990-d4d5-4bb0-21a2-08dbefb1b608
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 01:31:14.4887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e2CHwPB2xgvZNw/NQ2vRrJbfUp5XKrH3dMKtK3PhlsA+SI+Tgc57PLTO3bQ+UVeRv+rq86AacaXjP0C+pi4ISOaKKT/8rifSPETrYR8bgwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4564
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTExLTI0IGF0IDEwOjQwICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gU28gYm9vdGluZyBhIGhvc3Qgd2l0aCAiaWJ0PW9mZiIgd2lsbCBjbGVhciB0aGUgRkVBVFVS
RV9JQlQsIHRoaXMgd2FzDQo+IGZpbmUgYmVmb3JlIHRoaXMgcGF0Y2gtc2V0LCBidXQgcG9zc2li
bHkgbm90IHdpdGguDQo+IA0KPiBUaGF0IGtlcm5lbCBhcmd1bWVudCByZWFsbHkgb25seSB3YW50
cyB0byB0ZWxsIHRoZSBrZXJuZWwgbm90IHRvIHVzZQ0KPiBJQlQNCj4gaXRzZWxmLCBidXQgbm90
IGluaGliaXQgSUJUIGZyb20gYmVpbmcgdXNlZCBieSBndWVzdHMuDQoNClNob3VsZCB3ZSBhZGQg
YSBTVyBiaXQgZm9yIGl0IHRoZW4/IGlidD1vZmYgc291bmRzIGxpa2UgaXQgc2hvdWxkIGJlDQp0
dXJuaW5nIG9mZiB0aGUgd2hvbGUgZmVhdHVyZSB0aG91Z2guIEl0IGRvZXNuJ3Qgc291bmQgbGlr
ZSBrZXJuZWwgSUJUDQpzcGVjaWZpY2FsbHkuDQo=

