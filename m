Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CC1700862
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 14:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240822AbjELMtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 08:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbjELMtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 08:49:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3641C10FD;
        Fri, 12 May 2023 05:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683895754; x=1715431754;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=L05XyHpc+DE8+m18CxD5EcSM4taNfDnaY7f1f3Z+IGE=;
  b=UgEaKCeRrFgG5o+5JPyA4PWWB1j8PkraHmeQ35vKdBjljzQEzSq1Y3fK
   fzpKp5KJSFACZXLyp1MizE/JzdQ9yiaMc7FvDrcvwuaMDzlB4z+WAEZ3B
   6Zexz9ZKhtdZFNonA4+s9Dc+7n92qihyLuFw3fJ65YUDgLX2DMijuvJSw
   jM2OFMXDKQ8QDoYye5Ig/aEQww74ft8y4kC8BBk1nTYvfy6FM/ruPcXfR
   k+ZKB3n+E8JAsCW25LWmjF9KID7gkFzbGXBhTXIVRQn+xo8pFpZc5qbgt
   x9lTXKWtZp9DNro1THsHnsOIrpDeqe7I9vpnR0HR9Y9pKNPRHOYrU0vvf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="330399333"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="330399333"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 05:49:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="694227991"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="694227991"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 12 May 2023 05:49:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 05:49:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 05:49:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 05:49:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 05:49:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGZ1472EJbpZagkN+7g3BoouUtZiKKqpujI1K2XD8ky5CsNgfUTrkG5RBWH4cpscMsEntiy1xhHFLcUY+xZrSIPSL+3MkI6szBUBIZEhSQ7nwd1Ngy31aRW5sNjAHEDdKeZOcQQjCVCybgkxVmmhN08rVaCbSPG7ZzdKfSsJ+gHSaWF6OKxiOHMsZgmiB7Zztqhgw+rX8d+edQUOk8j5kzk8jBPhhL/mLO3Mk0ksFXoKpzZWXz+MdQgIxVdhWCWhBDjk9wDsrkO7dZIXJQoTv40CpQVelin6FIE5Lh3OTlbsjahHdUjcEdPbRKi/OAIgRXmvk4WB3rfzMU3zOrLwUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L05XyHpc+DE8+m18CxD5EcSM4taNfDnaY7f1f3Z+IGE=;
 b=KIJAr/CQkqEwDk1ZroAZGXfZW5ag2C+gST1nSX1qFCcF3sW/79gL4W8CF/jXZJj/FXlHE2Ts9o8rq/PzJGOXs7dPeFMGYeq0YbEpVODyZnHrf3oP88h1q/8sZ93/vs83l5/UqiEVzOr1wKgcD8O9pvPIF1ayJHwlMUlZLo159JVk9YW6+64V6oEUWlKP7bY5lCzBO50VTMDQ39rqW5OEb+9X35y6OHY6AlaP7ItsTzIB+3/P3VsvCxW1MM40TqXBajZjBtM2kCAnJqVjqEP5zRa9ePSojXuGmoRI8ATjTS6ud7juyiV3FKdxvJq7FckCH5ccS61XGceVl2h8I57wLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6053.namprd11.prod.outlook.com (2603:10b6:510:1d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Fri, 12 May
 2023 12:49:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 12:49:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v8 6/6] KVM: x86: Expose LAM feature to userspace VMM
Thread-Topic: [PATCH v8 6/6] KVM: x86: Expose LAM feature to userspace VMM
Thread-Index: AQHZgwWgTO/gtQ4SrEuIuKE0uNDLR69WmjyA
Date:   Fri, 12 May 2023 12:49:09 +0000
Message-ID: <cee713c15a4d9c4b8dabe6cfd8b9e689a8bdf375.camel@intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
         <20230510060611.12950-7-binbin.wu@linux.intel.com>
In-Reply-To: <20230510060611.12950-7-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6053:EE_
x-ms-office365-filtering-correlation-id: 491e7e30-1299-4721-c0df-08db52e747eb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YoRgI9i+i3Lcul9pBYE/N98AkTZgCUNXam6Not+47Po6yZov+BP9iCkZIzCctN5YlF0e+QW8r/yjAy2pzpczjpiy6kPvNTNJA/7BsHYri3dTN87wqO+8tFnbGa2gGT6R3UE4wJjUv00YYcO/LqdV9kAfeZggIooSY4/C5umsosH8t6xzkeSx4ZSfDWiF8/QDi9lTQBmMsl/qT8K0YHtpjbTmWzwt/vVXR5n5a3bgOuZa0nkMi2SqAXEdLz10Xm2QHO0WpCqLLHa2PBIktJUcPuGWs+swtRmPQ4WgEgpKgemm9TkL8+hNX7m1LC9Dsluf1AUizgYLVJxuaQI2frHzDYQ5he6KLPuVrdU10IPNXnMF7I0r7g24cl8e+0kXeTIbbA1fVA5JzFBLvJF8KD7OKDSgQYnJoEMl6K3z6N2nmQmMKAbXhevdJFsGw0ltXeTzv4cy97ejmgp2N9v26Ya/NkbLHCIvSWgJWKBWS/swSeXkBS3EKd2m/A3lUWAwPCmViUtaMjqDunQgg+QvWOOSbpkuFk8TeV3mDALPbe2x7V+cSxaeZC0GNCSSkocahYdS8dpl24WNgP/L+DOZV3g77q1U0jwDeURrdFYK0thfGgXSYODzGHoWapi4XCwZmOAZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199021)(91956017)(4326008)(316002)(110136005)(82960400001)(122000001)(66446008)(83380400001)(76116006)(54906003)(36756003)(5660300002)(66476007)(2906002)(41300700001)(71200400001)(6486002)(86362001)(66946007)(66556008)(64756008)(26005)(6512007)(38100700002)(6506007)(2616005)(8676002)(8936002)(38070700005)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2RiQTBkRTRuU01UZ0wxY0o2b212clNhajhpQ2lPM3ExUExEWjJEUVFBVGZ3?=
 =?utf-8?B?YUZNdnplSGZaeHNYb1E1aWFGWWdpeGZwTUhLZmdodTZxdGNTWGlZeVljU3or?=
 =?utf-8?B?MUlWVGROYm1UMDQxL29LNVNaUk52V3VGL0hHYXVMTjFrRXFvS09jZ0FnS1JR?=
 =?utf-8?B?K3k3Qmc5VkNmM1RydUdtOUxJSmtMaloyOERQaWtYM0tXM1B4VGJWN2pFMG40?=
 =?utf-8?B?RnJuVjdHU2tXT1Voemc0bVl4RVB5LzkyaWNsODYzc1pZMzRRcDVrZ2ZzMjEx?=
 =?utf-8?B?dFhPOHYxMU9XR3pjczBwaVNEQXFFVHZsY0N4VmNtVjM4RGZxRFpBOW9EdFhJ?=
 =?utf-8?B?NzZHTlF5aUhYc0wxOEIxLzJJQjh6V1puYWc4MVQ4ZGRaNzlxOFU4VGpXMjVH?=
 =?utf-8?B?UFl3RjFMZGdnNkFCSzd1QmFhZFhYVUlQZXZHTER0Z1FySVgxcWlQQzg2UVlj?=
 =?utf-8?B?cnIxbHMwdXE4d3IrRm16dmFnaXhSVnFXb2RJV25wRU5FYnRTd3JoMktwVy9C?=
 =?utf-8?B?VW14bEtQajlxUEpYL1Rsa2sxVm9ycmlNM244djJpYmNPZm0yK3B4MDdmbWY2?=
 =?utf-8?B?aTZic3R2Z2hOeS94NGFRSDdER25vWDNKUmRiVEZDSUNKNzNIVDdYcXVmdWpq?=
 =?utf-8?B?WjVHdWsyeWgvdXhYQ0EzTFZ2Sk9DUFJZajRmdmdobkljWFBuTGhLb1lmREVz?=
 =?utf-8?B?cFhHYVZwWFJIR2dOZkkrUmQ2aElIaHBwRnZieFB0dFBqZUxaRkNrMlRuRmVN?=
 =?utf-8?B?aGprUnFLSUd6MThKUDFQYlpCRXMzZytkTjl3elhPSHEwSnE0OXoxbzJRU0t5?=
 =?utf-8?B?a004UFRiLzJQTEM2TlR6dmE0bmtta2tHSC9uaytPTE9GdlErWVh4RXdjeDVj?=
 =?utf-8?B?N1Nhc1B5Uzl6dUpIZERzVzVoeDlyM3RrTld1ekhsTitWMDhRVXdGNnV4Y3Zv?=
 =?utf-8?B?amxKR0FJZjVnV0VlNGZhYVVlZTFvcGhPN1VJUnBPemJxVGNya3QrQVdWVDYx?=
 =?utf-8?B?WFpUMjVTVkkxWlhOb0RYTk9Ud1c2ZW5RVHJ5UWpvWm1xeG5ZaHd0blFDSGtU?=
 =?utf-8?B?UzB3UDN2UzFYVTM5SCtXSXZSU2dNWjZlSWlNWGlldnlMb3pOeE5KRjFtUnI2?=
 =?utf-8?B?MncxZjVqelZSUW9JS2txdmhjakpRS0lrZHN6V2JpbmxHNGMrbDVvRjJXalBz?=
 =?utf-8?B?OStuem1qeFhicmdDMzV4aE5LbU1qQVFxaHJFeWZ3cjl2M3pJQUdNaGFwU3c1?=
 =?utf-8?B?OTBLMWRkdlUrakdyR0RYUnBqUnZtUWRrWVBlVmliSEhadVYvQUN0NC8zR2h0?=
 =?utf-8?B?ZHVhTktlL2g1TGNZOTZXa2xOKzN2Qkl3SGs5OG9vem9EVTE0UUhmT2dyZGlK?=
 =?utf-8?B?SUN1TG9rclpvbnlJNEpJUVE3aGNDK0orV2JDYVJwV2JIMFFOU2s3djduUlls?=
 =?utf-8?B?UFFYaTlVNVZadWladlpaM2ZKZWZIeDlJTTN4OVhjTStZcGh0SjZFTDFxbHRj?=
 =?utf-8?B?WG4zaDljaXVSVnA1K1N3Z2hZVS9Vb2oxN1hEWUxIdW1RZjRPWlNESktPU2p5?=
 =?utf-8?B?NGZFUUdGSXlvbi90c0RTRW1DZW1aQk9oT09ZNE1icklscUEyMjVDcE91Q0Fz?=
 =?utf-8?B?SDc4bSt3MGU3ampadGc2bmlvazZwVEVKRE1GelNWT2hpTENYM0N0cjhNQzVw?=
 =?utf-8?B?aUJaY2FuVkRtVm16aGhmekJZaWtoNGZRSzd1bDBacXI1eElBMHVCSWJ5M2Fu?=
 =?utf-8?B?UndOayt2enpNN1lqeUtMTlcrdGFjQmdBVjJWd3lKbDRaYkhuSjNiZ2h4UFhz?=
 =?utf-8?B?MGxZdUUvR09lRnhrUWZ2aDd6TnJEV2VVWHhqMnZRWW1HM3JaMTdaeVlPcS9j?=
 =?utf-8?B?ZHJCNnVKVng0Uk5kQ0s5MlZPSVZ0ZnJXV2tKRGtSUWdNU1J0STdYNFl2NG1h?=
 =?utf-8?B?cUJOUElZWUlGMHF3dzVJUTVqOWJ2VnpLYVhUbFM5ckVLTDdqOHNqeXhwanRG?=
 =?utf-8?B?UVFaYzJOb0dxKzRVcGlDK0NuUGRLUXZnK2hyaGJ1WEE1QVB0a3kzYm10azM5?=
 =?utf-8?B?T3d2cTFuN1p2QWN1R2Z1dHUwNU1YWEhuQkFiUUhGOW9GaUFTak5TZSt2R3h1?=
 =?utf-8?B?OG1Oa3hjSzRoOVNDM285WnZBQ3gvMnpOZkY3ZTV3Y1FnZTBYWndDeHZyK0tS?=
 =?utf-8?B?Z3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6626B5E25B77534891D7709FB911B483@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491e7e30-1299-4721-c0df-08db52e747eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 12:49:10.0200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iNODeQ7RKp7kDNY3PHqry8R/25h/9Y4ADDHUCvJvWJYGnrsT5iLfutfS/Awnqv7EK/4RJHta/EZrfIVrbR0Nwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6053
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTEwIGF0IDE0OjA2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEZy
b206IFJvYmVydCBIb28gPHJvYmVydC5odUBsaW51eC5pbnRlbC5jb20+DQo+IA0KPiBMQU0gZmVh
dHVyZSBpcyBlbnVtZXJhdGVkIGJ5IENQVUlELjcuMTpFQVguTEFNW2JpdCAyNl0uDQo+IEV4cG9z
ZSB0aGUgZmVhdHVyZSB0byB1c2Vyc3BhY2UgYXMgdGhlIGZpbmFsIHN0ZXAgYWZ0ZXIgdGhlIGZv
bGxvd2luZw0KPiBzdXBwb3J0czoNCj4gLSBDUjQuTEFNX1NVUCB2aXJ0dWFsaXphdGlvbg0KPiAt
IENSMy5MQU1fVTQ4IGFuZCBDUjMuTEFNX1U1NyB2aXJ0dWFsaXphdGlvbg0KPiAtIENoZWNrIGFu
ZCB1bnRhZyA2NC1iaXQgbGluZWFyIGFkZHJlc3Mgd2hlbiBMQU0gYXBwbGllcyBpbiBpbnN0cnVj
dGlvbg0KPiAgIGVtdWxhdGlvbnMgYW5kIFZNRXhpdCBoYW5kbGVycy4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFJvYmVydCBIb28gPHJvYmVydC5odUBsaW51eC5pbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IEJpbmJpbiBXdSA8YmluYmluLnd1QGxpbnV4LmludGVsLmNvbT4NCj4gUmV2aWV3ZWQt
Ynk6IEppbmdxaSBMaXUgPGppbmdxaS5saXVAaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogQ2hh
byBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCj4gVGVzdGVkLWJ5OiBYdWVsaWFuIEd1byA8eHVl
bGlhbi5ndW9AaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS9jcHVpZC5jIHwgMiAr
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2NwdWlkLmMgYi9hcmNoL3g4Ni9rdm0vY3B1aWQu
Yw0KPiBpbmRleCAxMjNiZjhiOTdhNGIuLmZjODI4NmY3NDdhYyAxMDA2NDQNCj4gLS0tIGEvYXJj
aC94ODYva3ZtL2NwdWlkLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL2NwdWlkLmMNCj4gQEAgLTY2
NCw3ICs2NjQsNyBAQCB2b2lkIGt2bV9zZXRfY3B1X2NhcHModm9pZCkNCj4gIAlrdm1fY3B1X2Nh
cF9tYXNrKENQVUlEXzdfMV9FQVgsDQo+ICAJCUYoQVZYX1ZOTkkpIHwgRihBVlg1MTJfQkYxNikg
fCBGKENNUENDWEFERCkgfA0KPiAgCQlGKEZaUk0pIHwgRihGU1JTKSB8IEYoRlNSQykgfA0KPiAt
CQlGKEFNWF9GUDE2KSB8IEYoQVZYX0lGTUEpDQo+ICsJCUYoQU1YX0ZQMTYpIHwgRihBVlhfSUZN
QSkgfCBGKExBTSkNCj4gIAkpOw0KPiAgDQo+ICAJa3ZtX2NwdV9jYXBfaW5pdF9rdm1fZGVmaW5l
ZChDUFVJRF83XzFfRURYLA0KDQpQZXIgc3BlYyBMQU0gc3VwcG9ydHMgU0dYIGVuY2xhdmUgbW9k
ZSB0b28gKGNoYXB0ZXIgNi44IElOVEVMIFNHWCBJTlRFUkFDVElPTlMpLg0KDQpQZXIgbXkgcmVh
ZCwgd2hldGhlciB5b3UgY2FuIGVuYWJsZSBMQU01NyBvciBMQU00OCBjYW4gYmUgZGV0ZXJtaW5l
ZCBieSBiaXQgOA0KYW5kIDkgb2YgQ1BVSUQuKEVBWD0xMkgsIEVDWD0wMUgpOkVBWC4gIFRoZXJl
IGFyZSBzb21lIHNwZWNpYWwgcnVsZSBvZiB3aGV0aGVyDQpMQU0gaXMgYXBwbGllZCB0byBjZXJ0
YWluIGxpbmVhciBhZGRyZXNzIHRvbywgaS5lLiBwZXIgbXkgcmVhZCBTRUNTLkJBU0VBRERSDQpp
c24ndCBzdWJqZWN0IHRvIExBTSBpbiBFQ1JFQVRFLg0KDQpNeSBmaXJzdCBnbGFuY2UgdG8gZXhw
b3NlIExBTSB0byBndWVzdCdzIFNHWCBlbmNsYXZlIGlzIGp1c3QgYXMgc2ltcGxlIGFzIHdoYXQN
CnlvdSBkaWQgaGVyZSAtLSB3ZSBqdXN0IG5lZWQgdG8gZXhwb3NlIHRoZSB0d28gbmV3IGJpdHMg
dG8gdXNlcnNwYWNlIGluDQpLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRC4NCg0KQnV0IEkgdGhpbmsg
dGhpcyBjYW4gYmUgZG9uZSBpbiBhIHNlcGFyYXRlIHNlcmllcywgZXNwZWNpYWxseSBhcyB0aGUg
c3BlYw0KZG9lc24ndCBzYXkgd2hlbiBMQU0gaXMgYXZhaWxhYmxlIGluIENQVUlEKDB4NywgMHgx
KTpFQVgsIGl0IHdpbGwgYmUgYWx3YXlzDQphdmFpbGFibGUgaW4gQ1BVSUQoMHgxMiwgMHgxKS5F
QVguDQoNCkJ1dCBjb3VsZCB5b3UgaGVscCB0byBjaGVjayB0aGUgaGFyZHdhcmUgaGVoYXZpb3Vy
IHdoZXRoZXIgdGhleSB3aWxsIGFsd2F5cw0KYXBwZWFyIHRvZ2V0aGVyIGluIENQVUlEPw0K
