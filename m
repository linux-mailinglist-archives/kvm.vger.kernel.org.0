Return-Path: <kvm+bounces-283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ECAA7DDCB4
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 07:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8F21B2125F
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 06:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC4463DC;
	Wed,  1 Nov 2023 06:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y/0KwHnm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C093663A8
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 06:34:24 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9CBDA;
	Tue, 31 Oct 2023 23:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698820460; x=1730356460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+HGt1XIFMSYlh2IPMAi0K5sT7tSLhTEC9F22reZNJsA=;
  b=Y/0KwHnmU6Ija0Wc2qHupce7eNeABj/oB6AQVAsnTLJuIv7GziJum/OY
   aQ0jntnKwRRAcRrxxCa7Ip/F2DMPyPNAzjBZ5avazP+3ijuRvzY0Kd65G
   BDt+QBoKt3/Mbo0q7peJZeCrNHtnxk/AvwZua/4Po0TwBBmpNde7Kk6Xw
   4snGKTmyHg0/8uSYiUcvOh2LfdOwLjg7vmXwHQFBk67SFEDDC7uHdKaVX
   9ujyPpLhvGW3uDUunZ18u7NQDXCIdvdlR9qjWGShJlsBJsLYdTJDsJPy0
   dwnKCqOdex5G5XH2smvVQY7TzRQVBiMGVSaqzyJT9qhevdEtegeB6V8Vj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="368653167"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="368653167"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 23:33:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="764479635"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="764479635"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 23:33:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 23:33:09 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 23:33:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 23:33:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 23:33:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpczcZBgC3qy98zegrdgbUbJuh0kY2bOF7qZHjG87Jj5JMyXCttyWRIjOhSDmNm5ZDfFsNYk+qbM0pfnKJ45zzyipln+9ec7iyqGm9DyjZP79VWxAzvi5UkPHuDMOFsL7y1+I3x6qZpSLceoAxYbgoUtNjLSABxsWlc9ZCgKbAMlxObfQfwIUTnCF7oMSi6gJmpXHFKClY+oUe+y2aIKYxxzPlBVTv3o4bC+UIU2ATQ4p+d66c8hxSYb0FTaoNAd5nL/fFxYpCUoHoR6YxxdW6uuJPQek5yjcAzR+/Z4kTXu0+IJPYH8M+ZoApWc01NOOTkS6dOl2jFK3JdVHqZpbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HGt1XIFMSYlh2IPMAi0K5sT7tSLhTEC9F22reZNJsA=;
 b=bLtM7w0NZz8iX0g4o4VwodDs6tLdwqX00gL5Bumax0khAeOsNEON0iOm4ME/71en1bMWZmjjgTu2ojyuV2WDsj4CMfipWbr39Whz3XSjm5tZkSnbPsx607R55iZ53BXU5KWW02aN3kEj0aehB0OR3NyQvT1sDTThYIHON3Usv45HhTew+5zKCIixmolA4er61tdMVL/62hTeaf9+Kcft62FCgnHtUc26e7X9IPaA3RnOMyhhe2SEy+gYiyT+BuKhZWAtPvNQusMUu6ir/2XC9J98XE87L+VTE8FubCX3MtOu1VyuDYaSXUm0U+v3lSO9nCkIeEnoqROnDFSUK2s9ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7910.namprd11.prod.outlook.com (2603:10b6:208:40d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Wed, 1 Nov
 2023 06:33:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%6]) with mapi id 15.20.6954.019; Wed, 1 Nov 2023
 06:33:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>, "Christopherson,, Sean"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] KVM: x86: User mutex guards to eliminate
 __kvm_x86_vendor_init()
Thread-Topic: [PATCH] KVM: x86: User mutex guards to eliminate
 __kvm_x86_vendor_init()
Thread-Index: AQHaCzvbFYoiNLot0U2A2ap87mJsprBif9gAgAACyACAAoFtgA==
Date: Wed, 1 Nov 2023 06:33:05 +0000
Message-ID: <4ac8bf2c4a977a7756228b9abafe4aeac50abe28.camel@intel.com>
References: <20231030141728.1406118-1-nik.borisov@suse.com>
	 <ZT_UtjWSKCwgBxb_@google.com>
	 <d0a37147-ff96-44b3-bee4-7004f0af5199@suse.com>
In-Reply-To: <d0a37147-ff96-44b3-bee4-7004f0af5199@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7910:EE_
x-ms-office365-filtering-correlation-id: 41207435-fd1e-4495-e994-08dbdaa4683f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zhPbMcl/wcjSnqkicsdSaqmZJIpR+uYrxh/6EMBSAI0dRJv8zM1+SOIpSJv/L9LTHPDeIjOaAqYl3pvVu3mPvzfYQeRzvHefR8a0KpPeYcfmjfNqAHMFvxCP76VilndaQ39aJwddwwYqXsk9D8awCiX/NPh34R3ueUwxWnzafdyXvdpuTjH8UCI+4a3J+ur7dAWjWwQXfe33MTmVSZ4Gv5SNEph8ioq76GWIYq/B1h16zpWeuFQOU1O21597gadyXY2MUTilLNO8xTFTo9iK7ej2VfWfaLxG3XAIQTVLw/GcLQDTQbiKCx+bPb21fFaJjZJUe3EwLofLuuTnCHu37S5ceRH8SOeqgBbasGpw4tsdrscPtgSuzo8BEHfX97bJTfXcqyNmiHVjXBQmpHn92Pr07pi9kjPPt51faj7wxwSQRDw00OMBHbpxjc4Sx0CHmc6GbLv5l++IYoLj7i3J87WIcCef4umciwbF4XlridqC6lqMhXkmKmc6Pe4r8k5DwyaeT7TZn7Pyt5hK9fF25xUYbgWGZJdFxGQuHe7CLK1mMsK2Tml6qQCogbviiuXovrytKlmLaJ9stnvT0Plrd80WQnKGWI3GWYwbdTAIlB18uPrDhDomTL5fCp5Xl/xx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(2616005)(6512007)(26005)(478600001)(71200400001)(6506007)(83380400001)(5660300002)(2906002)(4001150100001)(41300700001)(91956017)(76116006)(110136005)(6486002)(54906003)(66946007)(8676002)(8936002)(4326008)(64756008)(66446008)(66476007)(66556008)(316002)(38070700009)(82960400001)(122000001)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWNPU1JIYitmY2JjWkdBMUQrdWIra1lEeGgxS2RyL0xncTVKTW5LWUU0eGJn?=
 =?utf-8?B?WlRIbWZzWUNSMDZ2OUpSLzNNOVlTZmtmd2wzallaeGdFdFcrSG9heFhvTGtI?=
 =?utf-8?B?M0cvLzFhTzFIZHlUNjIyZld4bmtPeGxTallMaGx0ZlUyc3NsQ3MwZ2JiTkpW?=
 =?utf-8?B?U0p6a3RNRGxEUWkzWjVkbVhQVWhURWhJaDNJaUFkL1hiUnFHNTZ4R0s5YU4v?=
 =?utf-8?B?R05jdktqRWxUMENoRHJiZW10UTVmMm5pSm5RZ3NEM1ZsRVA5cnlpUk9HSTRI?=
 =?utf-8?B?SmFGeFVxNE1pdUVXbE95d1ZhS2pVLy92azZMSnlNdG1oaDJRSjFlQnRBQVFL?=
 =?utf-8?B?elFYTkRqZ0U5R3VhbUp3QU1iSnNsUytDY1JWSUdPcUtaTlJPek5PbFBoVmJO?=
 =?utf-8?B?MzRLNWUwRGxYTzdqcCsrRGJOYlEyOUtsaDRvMTVGWmRuS1VEM2JMY2dpb2Yz?=
 =?utf-8?B?QkJYZEN3YWZQaFNYZXhYSGNFbGR0N1JoZ1hmQWU3N3hEblQvc3VsWHlKMjMz?=
 =?utf-8?B?TEhjMmJ0QUpPNjVHYmtHM3RjTkw4dHF0MkZ1N1BWWnk1WjZtdEpzZnN4bFJv?=
 =?utf-8?B?NkYrNTJ0NGtQdFc0NnRsWGxYLzgyRHVHVkYxejBxTXpNTkJPU0hSSUE4RUp4?=
 =?utf-8?B?a0c3ck85RHZwaXEydElqU3RTOXk1bkxud0xqaFhLekJVajVYMjc3TkxidWVL?=
 =?utf-8?B?MUFRb2FTbG8yRkVjUVhVU2NMeTZ0YVRlajFGMlViMllzdCtqU1k4d3E3MHpy?=
 =?utf-8?B?VmJQVW16bE9TOWN0WE1POUM1ayt4WEMyVUJjRUErYUF5Qk12U0NiK1AxVmVm?=
 =?utf-8?B?Vi93NHZ1Mll6b3ViOWhZYzZzTHdyMU41RjJvcy95ZmZpc01va01NejRmdWRB?=
 =?utf-8?B?Z3lYNzZPTlQyWWxTNnRiQWFSbU5VS285ak5GazQ3R3NSdVk4Smp6V2tJTDMw?=
 =?utf-8?B?V0o5MTg5WGVwRXNRejE1bjBiS3F0M3NmRDYrekJJdG0ybnFvOWJkR0dib05x?=
 =?utf-8?B?bkFtTzNQZVVoN3FNZ25scjZkb2lxUVVWYWVtdnZTRytQcEduRkxJNnhuUDZl?=
 =?utf-8?B?TitYcEhyMFBYVGc3blRtTnQ5Mll0dmNWbzlVWWNRWUs4RGJ1TGZMNDI3em05?=
 =?utf-8?B?TlJQenRCSVVpNE05cGtpOUE5K2pzZWJZRW1oVXJYZG5lSnA1VEhVU1cwK2Rj?=
 =?utf-8?B?RnRlWUg5RmVCYzZJK2hWd1dKUklkd2huck9ZQ1VDS3JGdVoyeTRSMHRZeXZV?=
 =?utf-8?B?aHo3RXFXbXI2SFFvVUlGcmtiMWFXenNHQ01kd29HYTIvK0h2ZDArbWxqaUJo?=
 =?utf-8?B?TDVJWWd5N2dIVGpnUHZuU1VGenBXcWlNZXFpdWlqZGt5SzFhck8zRkxsdHFU?=
 =?utf-8?B?Z3V1akZKZXl3NkdtVjh2KzdIMUE1YVJBeVh6L1EwOVhHd204NzhhNWdRZ1E1?=
 =?utf-8?B?Y0UyTVk1M3VFVWVwNm9mclF5bHZLcVFGOTNnWlZ0em00bnBSSGQxRjVnMkhB?=
 =?utf-8?B?TlpwdjR6MlRZNkxYNUh1Qmttb3c2R0tGTkpCOCtHdEhRYldIQkVjdEdLZmJn?=
 =?utf-8?B?dStQWG5LdUIxa1N5eGZzeUFaZzNYTjhXdm5NY1RRSUI1OUxtdUVGWUcyYUdQ?=
 =?utf-8?B?MGthOU5oUHQ4VGFFdGFUeFF5SW53S2dtOTVwTXFhZHRISmpVMjVXLy9uZVpp?=
 =?utf-8?B?dTRYVS8xbUx6bjdDK1lIUy9vK0NzZW9rNXZteG9JaUFNc0xuV0ZrUjdQdUZy?=
 =?utf-8?B?MGJPR21hYzEzWTVWVktBdDZEc1BXRzN0dFk0RllFd1RPWjR0KzI3RElUckdS?=
 =?utf-8?B?K1VoZ0hIbTJzejU1U2FnRVhZSThWVTErczVaRXdObjFOT2d0MjYyYlg4cnFW?=
 =?utf-8?B?d0hrWGFvWWMwcWpBb0o2V3pGVGQvbzl4QjhqSnc2d3BjSldLRlVVYyttZkcr?=
 =?utf-8?B?VUlNbE12RUxNdnhwOVg0K2drc2hFaXdTVHYzWW5ZUThFTE01a3YyQ2NLTXRm?=
 =?utf-8?B?enhPQU1SeVJINEh3WmRVNGcvZENWQlFQZVZPV2V6d0dsSnF1Zk5hODNqd2s0?=
 =?utf-8?B?Z3VVRmdNcWJzeXhheWZFZjFwS1V1akMvanlCTFM1aGU1OGxhejc0ZkJLemNl?=
 =?utf-8?B?NkxCYzQ4T1RYVzIzOTZ6N05EQ2hRbEVHVldmQVJNZ21FTkNjNTRGcG5ka2Ni?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5206DC275787264DBAFC0BF3EA7141E7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41207435-fd1e-4495-e994-08dbdaa4683f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2023 06:33:06.1024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kwujP5mgdw6xox84r3M6HbUlf2v6FWibY1Zl/BsDJMeLcJg+ZLHnJBM5ok9j4eD+UNw46tORQfrAnxga1+U6jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7910
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTEwLTMwIGF0IDE4OjE3ICswMjAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAzMC4xMC4yMyDQsy4gMTg6MDcg0YcuLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IE9uIE1vbiwgT2N0IDMwLCAyMDIzLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6DQo+
ID4gPiBDdXJyZW50IHNlcGFyYXRpb24gYmV0d2VlbiAoX18pezAsMX1rdm1feDg2X3ZlbmRvcl9p
bml0KCkgaXMgc3VwZXJmbHVvcyBhcw0KPiA+IA0KPiA+IHN1cGVyZmx1b3VzDQo+ID4gDQo+ID4g
QnV0IHRoaXMgaW50cm8gaXMgYWN0aXZlbHkgbWlzbGVhZGluZy4gIFRoZSBkb3VibGUtdW5kZXJz
Y29yZSB2YXJpYW50IG1vc3QgZGVmaW5pdGVseQ0KPiA+IGlzbid0IHN1cGVyZmx1b3VzLCBlLmcu
IGl0IGVsaW1pbmF0ZXMgdGhlIG5lZWQgZm9yIGdvdG9zIHJlZHVjZXMgdGhlIHByb2JhYmlsaXR5
DQo+ID4gb2YgaW5jb3JyZWN0IGVycm9yIGNvZGVzLCBidWdzIGluIHRoZSBlcnJvciBoYW5kbGlu
ZywgZXRjLiAgSXQgX2JlY29tZXNfIHN1cGVyZmxvdXMNCj4gPiBhZnRlciBzd2l0Y2hpbmcgdG8g
Z3VhcmQobXV0ZXgpLg0KPiA+IA0KPiA+IElNTywgdGhpcyBpcyBvbmUgb2YgdGhlIGluc3RhbmNl
cyB3aGVyZSB0aGUgInByb2JsZW0sIHRoZW4gc29sdXRpb24iIGFwcG9hY2ggaXMNCj4gPiBjb3Vu
dGVyLXByb2R1Y3RpdmUuICBJZiB0aGVyZSBhcmUgbm8gb2JqZWN0aW9ucywgSSdsbCBtYXNzYWdl
IHRoZSBjaGFuZ2UgbG9nIHRvDQo+ID4gdGhlIGJlbG93IHdoZW4gYXBwbHlpbmcgKGZvciA2Ljgs
IGluIGEgZmV3IHdlZWtzKS4NCj4gPiANCj4gPiAgICBVc2UgdGhlIHJlY2VudGx5IGludHJvZHVj
ZWQgZ3VhcmQobXV0ZXgpIGluZnJhc3RydWN0dXJlIGFjcXVpcmUgYW5kDQo+ID4gICAgYXV0b21h
dGljYWxseSByZWxlYXNlIHZlbmRvcl9tb2R1bGVfbG9jayB3aGVuIHRoZSBndWFyZCBnb2VzIG91
dCBvZiBzY29wZS4NCj4gPiAgICBEcm9wIHRoZSBpbm5lciBfX2t2bV94ODZfdmVuZG9yX2luaXQo
KSwgaXRzIHNvbGUgcHVycG9zZSB3YXMgdG8gc2ltcGxpZnkNCj4gPiAgICByZWxlYXNpbmcgdmVu
ZG9yX21vZHVsZV9sb2NrIGluIGVycm9yIHBhdGhzLg0KPiA+IA0KPiA+ICAgIE5vIGZ1bmN0aW9u
YWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gVGhhbmtzLCBJJ20gZmluZSB3aXRoIHRoaXMgY2hh
bmdlbG9nLg0KPiANCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQoNCg==

