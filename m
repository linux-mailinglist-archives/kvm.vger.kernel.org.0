Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D089E70CE85
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 01:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjEVXLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 19:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjEVXLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 19:11:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF38EC6;
        Mon, 22 May 2023 16:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684797105; x=1716333105;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=c2Os5caKhpc1w0EPPzKgoOhiPkU7Z76hEH2IR5MQ5yY=;
  b=QJ/6O3rk1Uh2BkBv0atR1tzklyTK24DVAZLzcyLBUDcjaHcv2lHmfW7p
   n2XyfyCVtPoSDEZBRi0S6x3GCg6owfVw/C4FxPvQz2hPEbwJ6jYrow3WT
   KNrIjgMbRHxlsnmvw3t0nfTWQuJhKuOgZambgAVYbXBxu/gwAEMDblTbu
   xVZ7TVkTfAZXZOEHu8vALvOBdk9z8tf3nrBYo0PlUeHIvxfk1kr1EcU55
   iX25mIbHv1olq7HmZFkORDRwZLF3j/TxG1aMvZFbvCiHWoZRlLrEoXNwX
   /nGQh0Sd/+99PB0wO9slQ58Pr9yTMfsLkNA/jPiGtZXhjlTc5PDz22Qro
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="353094602"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="353094602"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:11:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="877953808"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="877953808"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 22 May 2023 16:11:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:11:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:11:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 16:11:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 16:11:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PA6hPpYtGv7vdvuEnYmWOeXF1x6c+8SfXXJjFZHZg3qW21V16mcxVgYKpukeij8LS6GDiyCSbn8z177BUsfL5BmzQY8RPcZuu9W7QzCi3/3fIcMQ4iencdFy4DY6IRnN9oI136ZilFXxrpjVnGB9r/NZuLMZY/NwYaxtsdiv+fmxr9dIoARvgEpoZ0zMNDdV7iQ9Er3+vdEx3RtIhmFpsmp5oBapsdHJGpt5k+FUCx4sUnM6MofOTZq5XDkeMHSyGiICLudma22smRMtMvmpkihwyzoeajAJ629SMInBrvb7FXpwVberVuvFxVMcLXNP8aZOVfwl9Px5b2Cxf1z1Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2Os5caKhpc1w0EPPzKgoOhiPkU7Z76hEH2IR5MQ5yY=;
 b=Ee4qYGqY4yswyeSqiTNXCPETFK3GlsHNhtXIEY9/M5AXZSsT6b6UIX6RcbJjaq1fSOWKgCcFSVVykAu+tOVpGADD9dlVxdki0Qo8FJ6IA3/UoPQFAXbmI4UnsZH8DuGoRJY5XsOvGHGIhlPd4pyDnwI1MVG+qQm4Jq7v3TtVn26FjVZDjMmBDNv8Epg/B7xz9Soa6SdRSpuK2kGyOlvklB0U3LJKDHkydb7UDpdirZP7Ya35+H3I2Hpa+eIJMAVvRDFAOZvDZ+CH+c908hjN7UTWIVkhrKpdFRrKrx/lpvcZk6hy3NLQEHYm3IYN2Vb9AKlpkdKQwXgNmQnNaeKGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4847.namprd11.prod.outlook.com (2603:10b6:a03:2d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:11:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:11:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 03/18] x86/reboot: KVM: Handle VMXOFF in KVM's reboot
 callback
Thread-Topic: [PATCH v3 03/18] x86/reboot: KVM: Handle VMXOFF in KVM's reboot
 callback
Thread-Index: AQHZhSyZF/oiSVHqKEGDwdWF74Ok0K9mTyMAgABUeoCAAFeMAA==
Date:   Mon, 22 May 2023 23:11:38 +0000
Message-ID: <d2c5e826d4c136234500d26b48b9e48737ba389b.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-4-seanjc@google.com>
         <0f683245388e36917facbda4d0b69934fce7b0a8.camel@intel.com>
         <ZGutN1cylVw7ICB9@google.com>
In-Reply-To: <ZGutN1cylVw7ICB9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4847:EE_
x-ms-office365-filtering-correlation-id: 36d1d891-4c35-4cd8-8e07-08db5b19e5c5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vlygzXELlXCRA3LRxHJ3YPvPCrUm/uTRSyJ/roMuoM9EqV+wHgvFa30Lel3xdy+XonGv2OvXDYKGASJR/VYZGUONIc+DyhoVOV+MKweuxVpqTqTlsXfOESotOlUcLmO0x7PaTIkaC6fOY3LouCcnFtrf5uDrmyDIE10MbPl6ZL9GtOBABl+Hpt/qBxCSNCYRxTgwkQS7Lhw5ZyoHZ5M+LE+1emaxa4jUvG1CFwYGnSwgvwhZQ8rAX1oKxXHKxb4COS3nmmE4LKUSzFjyqZvIdzjcG0He6kiyy3gPp0hpzq1XSOdAC7C2N+m4FEV2MILyE17lo36B3Jx5J/ciB9KjMVl5Zc9c/9s333fqFouv+AuwVMpjox2rkKlDkpxjlcQrlcGdaYYkorQ+EDDJJOXXHZ7cj7eG482BoUMm1DrG8ojhW0UUi1FQczIF8tPmVocCGJwHW7tUN2Ywv7bHVx1lBckNc9OPnIZQP6oOoh4WJY4BUrgnaEhicx0SpflUw1Entlj9Cu7kQB6j76Y+rgf8EGVLDc4J0YiZjCXtCuZZU4wLJV8g8ZmTI6Y+mwi/YrcstKtJqWg97BmFi3FPiuCq/Dzj87sxueIBymS68cv0UyljNN5UlDzZHcBSm9/Nq9+j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(2906002)(5660300002)(8676002)(8936002)(91956017)(66446008)(76116006)(36756003)(66946007)(66556008)(6486002)(66476007)(6916009)(4326008)(54906003)(316002)(41300700001)(478600001)(71200400001)(64756008)(86362001)(26005)(2616005)(122000001)(82960400001)(6512007)(186003)(6506007)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWZTTksyL1hXeUd6alh1eGRuUHM4aXgvSUwwYzdnQThkdWUvbmN1UGVDeG9a?=
 =?utf-8?B?R0IydzM3cnppNlorMFd4V2w3cXljeHI5QkUzRlJDd0dFb1ZLZXg1aWRidUdH?=
 =?utf-8?B?MGY4MTVHYlNyUUwwRTFkZ1RLZlBCTjUvb2NabVlheUx6WVM1R1Y1c3RUazJl?=
 =?utf-8?B?MzBjdFh4VEpiRjQvQzVSUWhLY09wQU1weEpJdHFWanNXSFNPVytMbjRkVEF2?=
 =?utf-8?B?NEVaNXhSUGsySnB2cVpOdXZLeWFUVnFJYnprZmVzY3JySkJQTnVNR1hUN3NH?=
 =?utf-8?B?dzV4V0VtTlFzR0tqdE5udktwb3lSdk93VXF2N2ZxeTJjbGx6OUkwQUNpNndQ?=
 =?utf-8?B?TFZiWjcwczRLSTYyRnZkclc0WEtNTThCbUl3NTlnV1RlK1lhQUxCbWxycXJs?=
 =?utf-8?B?VWFCcVFQQ0RTVnh6aUtZS2ljTTRlRG40MEN1aHZ6cWZIS0ZNWFBzMlh5aXBM?=
 =?utf-8?B?N0E4bkhVM2hrN3RtL3pmNzJyOUQrNWJvNVRTZjNOemhCdWcvMmM5cUhtcFJa?=
 =?utf-8?B?MHpwS2VNamlFaTVPS1hUY3B2SDNFN1ZxRHlrem5xMTI1dWJWWUk5NFB4SFVy?=
 =?utf-8?B?RHlzSU1SUzlPMFRKTGFMeW5pYlRRMkduSmNCTFd2Z1dma2V4dHhFRzlDTUFU?=
 =?utf-8?B?Vk1kbUp5QStEUFBsWE9VaXFIdmlacW0wWVpyVGxtVllONzF1aXJwRlNSd05D?=
 =?utf-8?B?VWlDUjlKaEdkTFMxN3NvbnNJK2dXalAvZ3NZODZYYkN6U3owYXp1K09hOWpC?=
 =?utf-8?B?RlBrUTI4QWNMUjZ6cWVhelNvZHBiQW5mKzlmQXUxZ2VZQlF1clRZTHgzQVI0?=
 =?utf-8?B?bW9EeXI4TXB4dVdrcitFT3FkY3ZCdFBNQXpSa2Z6TlQrd2xwVmFtNnd4b1BQ?=
 =?utf-8?B?MC9FM0IrOEpBVG1NUUtIUGFEQ09UVUhnQmYxeWk4MGxTSWN3V2d1cXg2dmZ6?=
 =?utf-8?B?UmxXNGduMWFzYmQxa1BnZGpOSFpUdXcyZWlKM00xTVNjb3RJVFRqdDhUMDJy?=
 =?utf-8?B?ekxONitJdC8weEozRkQ4RXlzL1JKR3Y2MzZRZG1kZ0E3cHVyT3dCbU16eENk?=
 =?utf-8?B?N2NKbENNdDY5YUhSYnRJRWhNWHIyOEp2M1RsVUQwZUdmNnN2ZGx3anpWaVk5?=
 =?utf-8?B?V1VrZmVlMXJYL21vZzZiS3RtMjQ5V2dvM3NIdDJWT1NYZFY1QUxCSG9xV3lm?=
 =?utf-8?B?ZHBNS0wzaCtuWWdEYW5ZN2lNNmxxd0lXNDVlajNnSllWTVNaYUZMeTlsamgx?=
 =?utf-8?B?aWxmWEkrOUlGck9FWG9udWo4VllaUEQ4ZXF2TEZPTUpjSU9YdHZxVXZBNVQ2?=
 =?utf-8?B?R0M1UytQZTQ3TVRFMTljQllLalp6RTJUamdYTUxnc282ejBpRWZBck1hajR3?=
 =?utf-8?B?Y09RU3lnWXZMdGJPdUpjdmdrbUkya1IwM0lXNFhCeDhLSkNqeHFRN1NRTjJF?=
 =?utf-8?B?eXRnTkZ4WHZVZC91NzZoL2JwLzRxdzBWSno0RDhvNHJEaWJqSUFYZ1N4blgr?=
 =?utf-8?B?T2pTV00zNkFDd0NyUmY1Q0drbFBoU3BjL2IraTRseW1HRitPcFBDNCttWUlj?=
 =?utf-8?B?WjJBWUJWM1RkOHlPMTVIYW1qck5yQ3Q4K1VDVXIwS0VmY083dmUzNEduWk13?=
 =?utf-8?B?aWxJaG9sTWErUjQ1QlpHcmEydVlOYWVvQVhzZGJyRWt4ZU9XTUg0eU43cDlW?=
 =?utf-8?B?WXBadm9pRnZuaGlqUktMUWVtYWIzZFRQaThtN2duMVVFMGJTVDlzMjFaNW02?=
 =?utf-8?B?WGN5Ujh6R1RtcUhZeWpSdko2aW5pMmk2NlpTSmJpWDY4WlRVQ1h0R3JrNnp5?=
 =?utf-8?B?SkxHejhMYy94c1V1YWMxS3hlUzdjRnczUTc4ZUxEM1Uvd29HcWhaZ28yV1hN?=
 =?utf-8?B?ckNSbTRmcG9qQWZKRTg0UEU0UEhuOWRmSS9OZzZMY20yTDlmOVFrcDlhblR5?=
 =?utf-8?B?S1ZHTVZrcFNBVWN1c0oyVWc4SHJ2M2FNaGs4a3dsQ1daM0FVNXMwZ1N5S2RE?=
 =?utf-8?B?QmtxK3Jqdm9ZcXJUVXIwVkpaeFZ3MWFKNnBQYkdBeUc1eS91QUFDS05pRG15?=
 =?utf-8?B?aG01SEluNFYyd2dKM05LQk8rNjkvcFBRRjRwbnQvY1lWMlBLc3dtRmhuOE1I?=
 =?utf-8?B?eGZLcUNhVDducERLdmdzd2pVdmFiaktDQjdVZTRuSW1kc3NqRVZKMDNJOEli?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCA5C043E1544241A39EC6E08ABADC9A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d1d891-4c35-4cd8-8e07-08db5b19e5c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 23:11:39.0033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pPmcOtDXLzNIn9JhikFGyOenL1NI240elbMgudWx2/kDHpc8a9L9+F0RAkt5Hfvy/RLCs2xO6d/OrOehTz7Vxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4847
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA1LTIyIGF0IDEwOjU4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1heSAyMiwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMjAyMy0wNS0xMiBhdCAxNjo1MCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IFVzZSBLVk0gVk1YJ3MgcmVib290L2NyYXNoIGNhbGxiYWNrIHRvIGRvIFZNWE9GRiBp
biBhbiBlbWVyZ2VuY3kgaW5zdGVhZA0KPiA+ID4gb2YgbWFudWFsbHkgYW5kIGJsaW5kbHkgZG9p
bmcgVk1YT0ZGLiAgVGhlcmUncyBubyBuZWVkIHRvIGF0dGVtcHQgVk1YT0ZGDQo+ID4gPiBpZiBh
IGh5cGVydmlzb3IsIGkuZS4gS1ZNLCBpc24ndCBsb2FkZWQvYWN0aXZlLCBpLmUuIGlmIHRoZSBD
UFUgY2FuJ3QNCj4gPiA+IHBvc3NpYmx5IGJlIHBvc3QtVk1YT04uDQo+ID4gPiANCj4gPiA+IFNp
Z25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+
ID4gLS0tDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gv
eDg2L2t2bS92bXgvdm14LmMNCj4gPiA+IGluZGV4IGZjOWNkYjQxMTRjYy4uNzZjZGIxODlmMWI1
IDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ID4gKysrIGIv
YXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ID4gQEAgLTc0NCw3ICs3NDQsNyBAQCBzdGF0aWMg
aW50IHZteF9zZXRfZ3Vlc3RfdXJldF9tc3Ioc3RydWN0IHZjcHVfdm14ICp2bXgsDQo+ID4gPiAg
CXJldHVybiByZXQ7DQo+ID4gPiAgfQ0KPiA+ID4gIA0KPiA+ID4gLXN0YXRpYyB2b2lkIGNyYXNo
X3ZtY2xlYXJfbG9jYWxfbG9hZGVkX3ZtY3NzKHZvaWQpDQo+ID4gPiArc3RhdGljIHZvaWQgdm14
X2VtZXJnZW5jeV9kaXNhYmxlKHZvaWQpDQo+ID4gPiAgew0KPiA+ID4gIAlpbnQgY3B1ID0gcmF3
X3NtcF9wcm9jZXNzb3JfaWQoKTsNCj4gPiA+ICAJc3RydWN0IGxvYWRlZF92bWNzICp2Ow0KPiA+
ID4gQEAgLTc1Miw2ICs3NTIsOCBAQCBzdGF0aWMgdm9pZCBjcmFzaF92bWNsZWFyX2xvY2FsX2xv
YWRlZF92bWNzcyh2b2lkKQ0KPiA+ID4gIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KHYsICZwZXJfY3B1
KGxvYWRlZF92bWNzc19vbl9jcHUsIGNwdSksDQo+ID4gPiAgCQkJICAgIGxvYWRlZF92bWNzc19v
bl9jcHVfbGluaykNCj4gPiA+ICAJCXZtY3NfY2xlYXIodi0+dm1jcyk7DQo+ID4gPiArDQo+ID4g
PiArCV9fY3B1X2VtZXJnZW5jeV92bXhvZmYoKTsNCj4gPiANCj4gPiBfX2NwdV9lbWVyZ2VuY3lf
dm14b2ZmKCkgaW50ZXJuYWxseSBjaGVja3Mgd2hldGhlciBWTVggaXMgZW5hYmxlZCBpbiBDUjQu
ICANCj4gPiBMb2dpY2FsbHksIGxvb2tzIGl0J3MgbW9yZSByZWFzb25hYmxlIHRvIGRvIHN1Y2gg
Y2hlY2sgYmVmb3JlIFZNQ0xFQVIgYWN0aXZlDQo+ID4gVk1DU2VzLCBhbHRob3VnaCBpbiBwcmFj
dGljZSB0aGVyZSBzaG91bGQgYmUgbm8gcHJvYmxlbSBJIHRoaW5rLg0KPiA+IA0KPiA+IEJ1dCB0
aGlzIHByb2JsZW0gaW5oZXJpdHMgZnJvbSB0aGUgZXhpc3RpbmcgY29kZSBpbiAgdXBzdHJlYW0s
IHNvIG5vdCBzdXJlDQo+ID4gd2hldGhlciBpdCBpcyB3b3J0aCBmaXhpbmcuDQo+IA0KPiBIbW0s
IEkgdGhpbmsgaXQncyB3b3J0aCBmaXhpbmcsIGlmIG9ubHkgdG8gYXZvaWQgY29uZnVzaW5nIGZ1
dHVyZSByZWFkZXJzLiAgQmxpbmRseQ0KPiBkb2luZyBWTUNMRUFSIGJ1dCB0aGVuIGNvbmRpdGlv
bmFsbHkgZXhlY3V0aW5nIFZNWE9GRiBpcyBub25zZW5zaWNhbC4gIEknbGwgdGFjayBvbg0KPiBh
IHBhdGNoLCBhbmQgYWxzbyBhZGQgYSBjb21tZW50IHRvIGNhbGwgb3V0IHRoYXQgQ1I0LlZNWEUg
Y2FuIGJlIF9jbGVhcmVkXw0KPiBhc3luY2hyb25vdXNseSBieSBOTUksIGJ1dCBjYW4ndCBiZSBz
ZXQgYWZ0ZXIgYmVpbmcgY2hlY2tlZC4gIEkuZS4gZXhwbGFpbiB0aGF0DQo+IGNoZWNraW5nIENS
NC5WTVhFIGlzIGEgImJlc3QgZWZmb3J0IiBzb3J0IG9mIHRoaW5nLg0KDQpZZWFoIGxvb2tzIGdv
b2QuDQo=
