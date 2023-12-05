Return-Path: <kvm+bounces-3636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6EF805FE1
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 21:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 013831F21410
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E376AB96;
	Tue,  5 Dec 2023 20:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VKUBF212"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FF4181;
	Tue,  5 Dec 2023 12:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701809911; x=1733345911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MZvIdJ0+kq7bN4kLWuNMHIhttCxoMt80Ylh56TJ8RFs=;
  b=VKUBF212clDOl9wCn1dwfj9NdOD75kpxdU+9ZVHXy3dmbFyIVLAjU/Dl
   uw0SPhQ7zpK25dsiqKI6yn3mSl5h/QvfPtuF8wflZCmqcr6hFUj3N/JE6
   SLcw7FwD0ilaAmN7vrxzNloXlywPMuB1M+dndQSNDFB9nhgWQWYyONTf3
   0VaIzbv5jRf1HaM0DyZ4je1+NktIs4f3KRS6tI1JE0XuTNGMD8QGQBEUq
   0fTGYVePQe0w/amMoUhAox8DiaaLNpRNd0ijzjGZrKiL+ay0KKPo5wbMi
   W+xY3Sj6vcu35ksaBNP6dGBZ9Cr+9rZh6yRRK6zPViTXEx8Qc+RrmQiGx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="397850522"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="397850522"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 12:58:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="914935161"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="914935161"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 12:58:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 12:58:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 12:58:30 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 12:58:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cq1ERIELUpzc2Vo/oMcuf9jh9VaqH+yqLgG1rL/t7ux0Wv75O28LG308q3SkfI44HxfiysDCCQgYRZHNrKuGIqEXznCfaLTQhHLI+h0hz/D0eUwhfQpBB3keYBa3QsUWOkjnRXMgZ9gBjcVgKlc/MUIPmszReBgIroS3l72sUwiDj8utMFFDJvtysKTJoR1J9r7awH5oC5DOCb5maBLe6C52+krP/C3P5j3s75HPIexSlItsq8z33ffIvSSqVDCIjrVO7zS/s09/ZddILrB4Y5Ps0ewqTzw7twsTLEGLlhZTRnVsgJjRRFOymyKgE8Ur50faWmNXtsMq9DMIn7+MqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZvIdJ0+kq7bN4kLWuNMHIhttCxoMt80Ylh56TJ8RFs=;
 b=VgCfSYl4p02aEtVQM1NLdx4Bu76LANz8CIL07+KlhBPyt6gstbC7gcYG2HUbgfJU/ej5hA3Me9ddfhfev/6opSxv2qh6vSc0o9DaxU/Zc1slio/EboQY5JgCA8qCdeD2CMyzU/+Hq9FRWdsmnhau5nSPOsHcQ36EB55GB89FX/v+O46AIKYUGFOt+f5nJqzXRJaETSbClLlLE2IHeSxp/ongWoymZdgmY8DBJ3Fz5VHuTbHN1GsBSgNTiy/ExbaEsXsI14bhiuOzX9ZZIyKm+rwyGsy4sNNm0UTKee9kwM3G6plqORodzZqPK/iu81aAnC1LuvdLJxhQl5Yn0IGzFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6488.namprd11.prod.outlook.com (2603:10b6:930:30::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 20:58:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 20:58:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, "Luck,
 Tony" <tony.luck@intel.com>, "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"ak@linux.intel.com" <ak@linux.intel.com>, "david@redhat.com"
	<david@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Brown, Len" <len.brown@intel.com>, "rafael@kernel.org" <rafael@kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Huang, Ying"
	<ying.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCa57iAgABYYQCAAAQygIAAA1GAgAAF3ICAAAEJAIAAAlcAgAAEs4A=
Date: Tue, 5 Dec 2023 20:58:27 +0000
Message-ID: <5572f420f438a1b95224dcbbe3de780cc1458c91.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <20231205142517.GBZW8yzVDEKIVTthSx@fat_crate.local>
	 <0db3de96d324710cef469040d88002db429c47e6.camel@intel.com>
	 <20231205195637.GHZW+Add3H/gSefAVM@fat_crate.local>
	 <2394202d237b4a74440fba1a267652335b53b71d.camel@intel.com>
	 <20231205202927.GJZW+IJ0NelvVmEum/@fat_crate.local>
	 <0eca4ddc74bc849b68d2ee93411be9b7d6329f0e.camel@intel.com>
	 <20231205204132.GLZW+K/Ix5sngfmcsY@fat_crate.local>
In-Reply-To: <20231205204132.GLZW+K/Ix5sngfmcsY@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6488:EE_
x-ms-office365-filtering-correlation-id: 6425cdf4-4631-42a6-d67d-08dbf5d4ed98
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: epp+ofcuCzMmBbibA0NBdfFn4/+FJKOmZTwdIA0pyEsgPfL4grzl4kOKIBKXw0vS3cxhHv6CNen6jA7Ar3CL0xBvKlmH3MFHiuwIUxXKJ4vrz02oGrvLZyA4cJkA2fgtHQrE9Cr3RBgYEb/Jt2T5SWpq6cvc6uZpmCETVHrkUd9EBwRgx1hss0oGvvi8543QNH/vNvzgE7N+0Zkjgy3rS3MhnOOFSLVISUn4ckBo2cJIWpaWkXsbXAblUHZ4p/p0ovZMkRTRIHE+d1Yiu+YClsV0QqrMuVrUDW7sasZFO5W39GWbcZQXUS2dtgmwjKcLd9X7KmQ6I0Uiq5U0SETCO+UBy6qKDemvAVewzgOkmFWSix6Qu8e0ZQlk7jcAsLQKGXQMCR7YBhme1ACdFlMOnFyGF8A3h7YDYuNkHeZ2wTFzkh9FCjvbw4A6yRfHDd0/Tq6DCo6/Z0RJJnoqbMms+mniaIKXJbQIzwA4PrbQVnwkE5+NMOyJ+REjt0uc3Ien+YlH9Iha/WRRtlTltRpAlvUmCnYiDGk47jnfc90MXpesQ1lbhl2To2BBYJ40u81jXQs++PgCri1MF1igma+ZnbcOMKQ4MkEa/wcJMHaWuzE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(26005)(478600001)(966005)(6486002)(71200400001)(6506007)(6512007)(36756003)(2616005)(82960400001)(316002)(91956017)(66946007)(66476007)(66446008)(6916009)(64756008)(54906003)(76116006)(66556008)(122000001)(38100700002)(5660300002)(4326008)(86362001)(2906002)(8676002)(8936002)(7416002)(41300700001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkNQSytvWFhUQ2Y0cENpV3Q1Wk9raXdneTEyU3pBTzFxaEZaMXFZeUNDMjNX?=
 =?utf-8?B?MkR3ckF3VFJPYlZva2FzK21MZzhGT2xIczJPOGQxSDh3OFJjOU1FS2dQV2th?=
 =?utf-8?B?Tm1nRTVIZ1JpMG9mZmlGUGRVNmlHWUN2c2hCS2ZoVnZQMzNWL2lUSXJQYlNE?=
 =?utf-8?B?MVBQT3pxekl3WVNXM3dEclNMb2FRblhJU3VuMlBrN2dNUjZPdi9WZ2orb01Y?=
 =?utf-8?B?OWkzNTNiTjY5czRmTDEzN0N6TkhNNlpBOFNjdmlOZE1jNlArVFFXMSt6bkF2?=
 =?utf-8?B?V0xkUXJrVnlFTWpUYnEwd1g4Q293OXYwVnNUeUFqMWZvV3hQT1lKRU5mVVVz?=
 =?utf-8?B?dUN2ZnRaTVRnWTQ1SFdKcGpSQmxZVkM1T09ONVNkUUp0Q0x1Yk45cGlUZHlB?=
 =?utf-8?B?NWhkbWpoN280OFpkOUFXZEFuNFlTSjVIckV2MjlpSXhJUUFCTHJtbmJ0US9X?=
 =?utf-8?B?S0lja1BlMjB2RHpSV2Y4Y0ZkNHh5WlF5N0Vhc3NURWJiOEdGRWJ5RjQ5b0U2?=
 =?utf-8?B?VlJwV1JDU1VpOXBGMzVzUVVnVVhSM2E0MGExUE5XZzhndmFYbGU3N0JXWW9k?=
 =?utf-8?B?NUg5a3puZlMvekZYam1TcmU2ZG1zZGNIbmZhajFQNHFjdE8ybUx3VklqeDZn?=
 =?utf-8?B?WXlaMTgwMDIvMjl2b2xnSGsrYmZVd1JxeVMxRUlrZGVURlBpczdTdjBsS1dX?=
 =?utf-8?B?Q1NMdWtxOW1MVll0eS9LVy9BcXRkamJxMWFJcVRCUExQbmV6aTZGcU9td1dG?=
 =?utf-8?B?enBJSkZ2TWpJR0p3NkNlMFYraThVbUV3bXRMdjlKK0dBbjJXN3dvdU1NdVA0?=
 =?utf-8?B?QzRIUmQwUjRId0RqOUx1d0NpelJuem1SU3BNa0pmL1VSWVlQdFBObGErblRY?=
 =?utf-8?B?TE95cHljSEloeDllU0RzTm16Z3dOYnB1Q3JXdm5SWkp2U3pDWnFMUU8vcTZS?=
 =?utf-8?B?d3dIRUdVNDlDUGtBcElxSC9RckpMZW9Rc0orSDdZUGxCYWl1V2VqUXVhSFpy?=
 =?utf-8?B?VHBOcDFXN3QxL3J3L2pXdFRPdS9IOVBKVy92U2FnZmFXQVZ4b3Z3bEszQWl3?=
 =?utf-8?B?RlR3YmpWaDFaUXFyNnBDZWMvYy8wbFJSd1dxQ1p1QkxyT1lMSjlZNWNvOVJK?=
 =?utf-8?B?OXIzWS8rWmVnelV5dDN4QThidkQ3M1d0b0hsSm5mdUpCbzBzRFBSSnpyTzFp?=
 =?utf-8?B?cHppMkNscVg0U1hMMVNSWWsxNlNGNGhZdTVGL0VJQ2Z3V0RoUHNzQko4amww?=
 =?utf-8?B?aHdBWC8wdlVsbmwwY05ZZ1ZLNVlZWVk3d1RtYzQvQ1RuTW5SZUZZSzBCUTZt?=
 =?utf-8?B?aHBKb2loSTA0YkYwMXhsVkVqUE45TkZ2RjBpTDFkNVB5VnhPdnFYMnZjMzMx?=
 =?utf-8?B?MWtGSUZtNUVtbTR1aGVVYjE0K0tZV3BVTTJGbHV2Y3VtZVg4UjNVYmNXdTEv?=
 =?utf-8?B?bC9CcWhnSUVueG9GcmhaZHRFOHJYbkN4di8vUk43b0pNS3d1Q1JJYkE1dnZT?=
 =?utf-8?B?K0kxV1pBQXFTcUJXUHJYQmtJRnB5Ti9nQldySXlLYS82T05VNXNIL2dqbHcr?=
 =?utf-8?B?bnpyYUQrbVgyUzh0Ym0vWGRoQWFKWEF3TDFXei9YQXhwcENXVk5RLzRXTWxl?=
 =?utf-8?B?KzI1V3dSZUtoa2Y1S2Zya0dFMEFid2hIenNpMnR4akYwaExmOWZ5djc3L1Ay?=
 =?utf-8?B?eVNOR0UrRUFtL3BhaXcrVEtRd1J1dmlJdDF6am5OZFcxWDZSMktxZVlZYlJz?=
 =?utf-8?B?VXVGV2M4b2ZpUHVvY2k0azM0R1Y5WVY0V2dPNDNXbWJTbTVUSEFwNnloZVdh?=
 =?utf-8?B?KzZTdzhmT01kMDZxUGVLK1V6QnFLWC9YcmhkdG9PaG1lU1hsT0VJR1RZdGVr?=
 =?utf-8?B?UXZmTnk3dWZYa00rM1VPTmZneHhVRVRhNHZhQ0poamhLRnE2dGE4ZTVjd3c4?=
 =?utf-8?B?RHBZZDliR2F0WnRjcndvNHU1SjUxc20rQXlGN2dMZ0d5NmFVN2xwY2hmYlo4?=
 =?utf-8?B?d3dVaWRiWjFuVXZwNjFzZTc4TzRzWVdHOGFhSVZ1elIvdnAvcW5kSVpBdTJV?=
 =?utf-8?B?QVFIYWJxWksvQWpIL2hzOWVtSTZNTlhFZDlQM1g2UVF4dk9QY1Z1OTJBNEFr?=
 =?utf-8?B?RmUyOUhSRStPSVhzVFEzSm9EclBqK1ZERmRDb2p5d0dJZUJBcTJTRWw3ZXlQ?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A52D23A0AA3F74CA1A56C4F28FCA8E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6425cdf4-4631-42a6-d67d-08dbf5d4ed98
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 20:58:27.1109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +rJO0G6uOSi0yDLlgi/wTyg2S5SGiOQ4BqkOt1DtXOPu5dVXdQyb3RdBiPh7if674OSlPTvFUcJKVWU75chB3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6488
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTEyLTA1IGF0IDIxOjQxICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFR1ZSwgRGVjIDA1LCAyMDIzIGF0IDA4OjMzOjE0UE0gKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gWWVzIEkgdW5kZXJzdGFuZCB3aGF0IHlvdSBzYWlkLiAgTXkgcG9pbnQgaXMg
WDg2X0ZFQVRVUkVfVERYIGRvZXNuJ3Qgc3VpdA0KPiA+IGJlY2F1c2Ugd2hlbiBpdCBpcyBzZXQs
IHRoZSBrZXJuZWwgYWN0dWFsbHkgaGFzbid0IGRvbmUgYW55IGVuYWJsaW5nIHdvcmsgeWV0DQo+
ID4gdGh1cyBURFggaXMgbm90IGF2YWlsYWJsZSBhbGJlaXQgdGhlIFg4Nl9GRUFUVVJFX1REWCBp
cyBzZXQuDQo+IA0KPiBZb3UgZGVmaW5lIGEgWDg2X0ZFQVRVUkUgZmxhZy4gWW91IHNldCBpdCAq
d2hlbiogVERYIGlzIGF2YWlsYWJsZSBhbmQNCj4gZW5hYmxlZC4gVGhlbiB5b3UgcXVlcnkgdGhh
dCBmbGFnLiBUaGlzIGlzIGhvdyBzeW50aGV0aWMgZmxhZ3Mgd29yay4NCj4gDQo+IEluIHlvdXIg
cGF0Y2hzZXQsIHdoZW4gZG8geW91IGtub3cgdGhhdCBURFggaXMgZW5hYmxlZD8gUG9pbnQgbWUg
dG8gdGhlDQo+IGNvZGUgcGxhY2UgcGxzLg0KPiANCg0KVGhpcyBwYXRjaHNldCBwcm92aWRlcyB0
d28gZnVuY3Rpb25zIHRvIGFsbG93IHRoZSB1c2VyIG9mIFREWCB0byBlbmFibGUgVERYIGF0DQpy
dW50aW1lIHdoZW4gbmVlZGVkOiB0ZHhfY3B1X2VuYWJsZSgpIGFuZCB0ZHhfZW5hYmxlKCkuDQoN
ClBsZWFzZSBzZWUgcGF0Y2g6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvY292ZXIu
MTY5OTUyNzA4Mi5naXQua2FpLmh1YW5nQGludGVsLmNvbS9ULyNtOTZjYjlhYWE0ZTMyM2Q0ZTI5
ZjdmZjZjNTMyZjdkMzNhMDE5OTVhNw0KDQpTbyBURFggd2lsbCBiZSBhdmFpbGFibGUgd2hlbiB0
ZHhfZW5hYmxlKCkgaXMgZG9uZSBzdWNjZXNzZnVsbHkuDQoNCkZvciBub3cgS1ZNIGlzIHRoZSBv
bmx5IHVzZXIgb2YgVERYLCBhbmQgdGR4X2VuYWJsZSgpIHdpbGwgYmUgY2FsbGVkIGJ5IEtWTSBv
bg0KZGVtYW5kIGF0IHJ1bnRpbWUuDQoNCkhvcGUgSSd2ZSBtYWRlIHRoaXMgY2xlYXIuICBUaGFu
a3MuDQoNCg0K

