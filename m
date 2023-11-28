Return-Path: <kvm+bounces-2642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 208EC7FBD86
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:58:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8981BB21ABE
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F205C088;
	Tue, 28 Nov 2023 14:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G8m6nXRr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB5F127;
	Tue, 28 Nov 2023 06:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701183514; x=1732719514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IemFHGu39HfTp3TydwzgSC43ZViUrrVPta7WzXfFrQU=;
  b=G8m6nXRrWL75QWOqMsSiVH/WXn5VTTivWd0IE8fru45UkR8eVXIrOIrw
   SZF3D7G6G0ewkmSfSL2b1mlGtEvX8QS3dnSRvOM6+a637QsncR0l1rf61
   gdWP+vAY1CycDT4x30low09RtMaxAV5E0e3FXhspp7PGLkHJIgtncOJ+7
   60TfanuJqzgKUnFZ9lp6zTsnRL/6wjMSc1qSQnTH85VEoBJoh1fXUMKC9
   Z1UpkZZ6+a+r4ha1VOrPbLRa38oO16Z+mPaDsdxNnbQ61rIqyyb68v+GK
   uY30vW53XS9FJH1HGsrIJ8XvNIyefEPYtMwkG2ka74a0KyVs4KAvyhLgX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="11633611"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="11633611"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 06:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="744928202"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="744928202"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 06:58:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 06:58:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 06:58:31 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 06:58:31 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 06:58:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqPi6cb8D8iJfgyYlcxydBXrf6hrXbbGIXy3+hituLa8SumabQr45d2zWxdAZoqdxuOPyQIO1aZMUoBCrVE9qeFH5834psMedfrn/WQ8lxGryj8uNMrlL/I40POcrW/SJd0LUsJq9QTbXO91LwU5YR1gq6cAcYyjC23SXhR4HrWzQCnyGSL3pa0d9QPKYuqaOtB+ZDLMfMQIMqqP/OU7eKS0ZbdxL5cmuJdus0rmqKnU+PLgiQlg/r/r8xRgIJjv2Q5vJWbR3n+iyEOYKlsXZSYITYGg2zIyezUI7quP7GptWyFcDGXUfHcTOrm2AeIF/K/xF7XMvn6sZabP5hDJrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IemFHGu39HfTp3TydwzgSC43ZViUrrVPta7WzXfFrQU=;
 b=JS4bmV+KJvsHOJ2fHBOaw3Go2NKL/tpVk7UVabWgKWvPcWS5JKSsJjYEEyR+iIGvbv0PJ10KSgZt0iz+/Pq84jTq1c3YGcG1GCtHf6yA2OzrACIOtkm4chwQ1MnXzYWjguslVJoBfzTzWtCaj4IJwWmi3lZpI6na6a65lz4qWjN6PvASzbkCRx8s/bS8x32UYV5obtH67DTYM0TU+MxmhXJn/Ej/5WEhW1tdQVcjTs8JpRhtbrXJRS/FeJjULr7j+QYE0X4YvGuNdHE/cx2/xRerHXPn/Eink6pgI5oO1wRtj3mJLqyFv0Sc64Vc5GbCZq7DJS9R2wJBRBbhzswvxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6700.namprd11.prod.outlook.com (2603:10b6:510:1ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 14:58:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9%6]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 14:58:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Topic: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Index: AQHaHqwJcLbwxqusyUagEZmr+deVnLCP2VSA
Date: Tue, 28 Nov 2023 14:58:26 +0000
Message-ID: <742a95cece1998673aa360be10036c82c0c535ec.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-6-weijiang.yang@intel.com>
In-Reply-To: <20231124055330.138870-6-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6700:EE_
x-ms-office365-filtering-correlation-id: a9b382f8-77b9-4049-8d3b-08dbf02279b5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xEe7EM+V8oGUHUFPFoyNek7Bnh4QN9Vwcro+s2A1wrIGvo/ICEDKdR9EKYUF3CU54Iwzfogl/AOv1Sc8ScrCCF7eA63s/qQW0HqmS9O/Q4//AQ0kYsSA3/XJNYBRYl//4rEa/EgEBj7jSDLtjtUURaTOfRZrOpYaAgcaYkPQ5jxT6wlGCdoG0NeGFNib+62OzqmhSD33m198rWhyJNEohuu7BO7PUg0uhum5jTVqgeQw2gaQG82Dxh11b6ZZET6D0eZ94sRLC5X6TyrPfSK55bZdrcaelV83f2tUHF3w8MmSnDaEl4QV1rVJdpnqGQjhUaknyRAs1ybQ566hszkgjEsp1HqqNTr3PtnbBqZII9iF5eY4hyyQJDIcm0cfgbZfhYcoKRnv0ZTAZxxFL4Q1VMjJ1Tsklv59z9I7UP7TgBwVOTmv8MN8QNVjqiGxmIQ0DuKWxJoSxvWpb2u42i/phNTmMssXIsky/9HaYMN/umhIYZqGgpmTwqPYrVVzjjqfUKJToBW1laRMMiWP+BrRN08dVHTZXSTUyfpv6PkU5QhdWqbtuQHCzH1fNz3liXrCH8OyRmIj+q7S5UUxBekR0o0vp9BGU+s7/t/wi6LgPt0v18U0IRLpW+x9KX3ulcMn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(230922051799003)(1800799012)(451199024)(186009)(38100700002)(36756003)(4001150100001)(38070700009)(122000001)(2906002)(4744005)(5660300002)(82960400001)(26005)(86362001)(66446008)(2616005)(6512007)(6506007)(71200400001)(8936002)(8676002)(4326008)(6486002)(508600001)(66556008)(66476007)(91956017)(110136005)(66946007)(76116006)(64756008)(54906003)(316002)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1hhOHhndXNsUzI4Z3ZvTklxb0hqemxXbjFqYWE0NmpJYkc2aGtiWEpWaWdZ?=
 =?utf-8?B?YzQxWndyZFVhaEFpV085d25VWVZiWWlwQWIwWjM3OEt3WmxkMGhLSzZvaCta?=
 =?utf-8?B?S0VRN3ExM1o3YU0rTHdLakpmOUhNK0pSSmFqbWRkeEs4UGxvVkIzdVZiV04v?=
 =?utf-8?B?Y0NnZDdOM2VOU1R6WWhBbWxNcUp3SXVlcEgvRE5qS0JxTGFnZVBDVExib1Bv?=
 =?utf-8?B?UUlSQjNacWtmbGhkcmNaMjNteGIzMXJFRk9mMldSUFdwbkxyRm9xRW1HbWVr?=
 =?utf-8?B?QWN6ZnAzZDNsZzJPQ0ZwcS9BTkVFYU1MOE05Yk9EY0dKR0ZGTGpIVGtjK0xI?=
 =?utf-8?B?UHYrcFB3WEpXWFpYWU5DdjhxMVh3QmRmT285TzBhTklSQ3FOMmtzZnkyamdj?=
 =?utf-8?B?Uks5dEJTS3ErT0M5eDZvT3NBU1hiaUZydVE3c3YzR2xsOGYrcmhRRlZKYlU2?=
 =?utf-8?B?Y2IzZXJFMDZiZndkdjdjMk5vNlhQRG12bzVhVDIyT1hMdHdUL3RKQm9ud0Er?=
 =?utf-8?B?eFk0UVYzb1pLY1VPNlJkbldOOWI0ZEI1ZmM1cmwxTjZFaC83Vlp2MEQzaENn?=
 =?utf-8?B?MS9tYktXRDUxVWY0dFJVUHBVcWpVNmNRcXBTQWkrU3MxZUZocWc2WEc4WEtP?=
 =?utf-8?B?ZFZ1enVZOUY5ZGJZRzVwV2lyNUdsUTBYa3hZRldGZEdpbzA0WUdSNWUyV0xT?=
 =?utf-8?B?NWZlcmQ0dDBpOVU4Sy9mSFFrRnY0UjI1R2o2VUlxOXpGLzhpL201cVFIV1Z4?=
 =?utf-8?B?M2dHbzJzMlFHVmVFVERJbWNuTkcvcy9WZTE2aW4yNER0UldmYm5vZzNBMGJn?=
 =?utf-8?B?OFd4dVEvTXptSGF2aFd3Y0NNVWNzNjk4ZXkwZHF2MndTMytMNkxxU0RBUjVH?=
 =?utf-8?B?WEIzWmJyVjIxNGxac29EYklWdHBCOGI1OUtETjRLakJsMzVhaU1LQjBiTThp?=
 =?utf-8?B?MUp6RWRsSG1zQ2VtZkVESzlwVzVEYk9vd0tNNmFtYkFuRnJRUjNXR2VCS21h?=
 =?utf-8?B?VGpadEQzUXU5UExrRGg0UjNzS0V4YUVkMlhqNVo1eDNkY1ZCLzYzRjZYdWRF?=
 =?utf-8?B?YWlmSzgwTVMvdFVlME1WUTF0UW1VN0dodUNRSWlaTktDSDVMejlqajhVbFlJ?=
 =?utf-8?B?NWZUc1pBQ3hoMy9pa2F0R2VLVnRORG9rK2lrSmVucHNsNm9KM2dYS2ljbzUz?=
 =?utf-8?B?dzNoVytlSmc0WmVka3N3UktGd3YwNno5NGVpNm1oa3IrOEN1Qis3WmdxR1JB?=
 =?utf-8?B?Y2pPOFM5UDBnTHdzRnI5ZVkyVUcwT3psSFRMeTNCTEEvU3hrTHkxTG1TazBa?=
 =?utf-8?B?YnRpVzFxYXR4aE9CN05ocmREQkROem5YVEVtemRHM3NaUVJIVVZ0ZEQvSVls?=
 =?utf-8?B?VWI4S2lZbDJHRklJaGdkaktuUHk3YTdOM3p0WG9iSXhKZnVVT01GQ2NKZDRl?=
 =?utf-8?B?WHgrVUlwa1ZvVmJUaWlLUFU4QjM4VklONzlGNUNqS1dUdmJlcS9GUWhrUEt6?=
 =?utf-8?B?Vi95aEY4S1pjbVBveHYvck5ObGxialFFN2g5aFdyejM0bnl4WSs2MG5mM2hh?=
 =?utf-8?B?c09qTE9CZU5HcW9TTWMzQmVVTGFEcGUzc0FUd1V6QktRWVNkYk92VjhaeHFO?=
 =?utf-8?B?K2c3WlJ0eFJnNkx1UnQ5Qzh6UDU1d29UWlJkcmdXUGxUQXFZcC8wNEJwMVRO?=
 =?utf-8?B?amlEaWtSVFNYYTlTdVNRcE11eURYS2ErcUJ6REd1QXh3OEZpSGxaeUhrSlRr?=
 =?utf-8?B?bmFCQjZXQnFobyt3N3Z0aEJ2aENONzIrWlBvWkZLdlVadjF6TlZzOHpRYUJZ?=
 =?utf-8?B?eDN4Vzc2amNuc0YzZXQxTHdqVGhIcEdXdTgyL2swcy9VWStLVmlLbTcxYTRt?=
 =?utf-8?B?UEQ0NExDc081bDBKUldsck9KUmVQRUNEWmtlbTVpK2hEMVhldk5NVGo5MG1Z?=
 =?utf-8?B?TmQrSEFBSDQzcjNrTDVGZU5nL3BSdTZLejRFWWsxRFRaR3krMzhvUUozU1ZK?=
 =?utf-8?B?OG9YNW5QNndhYTZ3b1pwa0pjUGlZUVZGYk9IZ3JTU0xZTGp1Q2FlTFVGSGwr?=
 =?utf-8?B?VDllZGxXQ3VIbG9BcUNpa2xtZGc3SndUaWxXZnZZTktUVDVZc1JLc2ZlMnU4?=
 =?utf-8?B?L0VVdEQ1aDU2c0UxRE14OXNsSUVMdDdwaklxR2htMDl5RTQ0a09SSmMrTUV6?=
 =?utf-8?Q?ffbEXPWXcE19zVrOxPGP4s0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2C958484015AB40853471AAD36EAB79@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b382f8-77b9-4049-8d3b-08dbf02279b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 14:58:26.4461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ywFK8Az+U4SzKrBJyj6d1tq7cwwzK41J9tzBJy3tu/E46AqTDec4IaH4QSyEqz1vfNr6QWJEksNTE1R5R92XCY+v1bUgnYwcvTboqyV+pp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6700
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTExLTI0IGF0IDAwOjUzIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiArwqDCoMKgwqDCoMKgwqAvKg0KPiArwqDCoMKgwqDCoMKgwqAgKiBTZXQgZ3Vlc3QncyBfX3Vz
ZXJfc3RhdGVfc2l6ZSB0byBmcHVfdXNlcl9jZmcuZGVmYXVsdF9zaXplDQo+IHNvIHRoYXQNCj4g
K8KgwqDCoMKgwqDCoMKgICogZXhpc3RpbmcgdUFQSXMgY2FuIHN0aWxsIHdvcmsuDQo+ICvCoMKg
wqDCoMKgwqDCoCAqLw0KPiArwqDCoMKgwqDCoMKgwqBmcHUtPmd1ZXN0X3Blcm0uX191c2VyX3N0
YXRlX3NpemUgPQ0KPiBmcHVfdXNlcl9jZmcuZGVmYXVsdF9zaXplOw0KDQpJdCBzZWVtcyBsaWtl
IGFuIGFwcHJvcHJpYXRlIHZhbHVlLCBidXQgd2hlcmUgZG9lcyB0aGlzIGNvbWUgaW50byBwbGF5
DQpleGFjdGx5IGZvciBndWVzdCBGUFVzPw0K

