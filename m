Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9E96CCFC3
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 04:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjC2CEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 22:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjC2CEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 22:04:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8461FC1
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 19:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680055478; x=1711591478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DAQmNNN5KT75Q+inXGtHvYWjUL4komSe3FPvudU3x9U=;
  b=ijdKnRvEBo3gzoDa+XdqSujQiRw1dFdOgOIYNE1j8cQv3RT2N9YQr0kN
   goROv4PjvF4DokZy78xAR1CjelNXPQ+W9ooaPF0spRemwi8i0AcfgCf8x
   PIewyyDdvw0RLNVeND6v4PpFVHs+5BZXrkEkIAaIvvfaHDb7vJREOWeUp
   pfHXY/aPvjJUKIGN9qo7kONOcoedOi11LREyT6yCj2EAFFrdooMyKjjxv
   s1xvqxEhuICrQ+YcG3Bpl+7zaOGJ12ZOrgGGf0oK1KtioqRywWQ4Z1qM0
   7I09tIbC1rYIftIbALFWJOZhapkKHW4Gfoaui+I1KmY+VPlB6GAMibTAx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="343163057"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="343163057"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 19:04:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="634302458"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="634302458"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 28 Mar 2023 19:04:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 19:04:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 19:04:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 19:04:15 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 19:04:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSXYhutnaGa+vbg/Oat/5Q5zU/DFo6DEKRofWdiBp9BLrSeQuRMGHkIV98GfJcrhKT4E6D9JHeo4Xfi+5ojBzuJfx7DBJQTDI8P+qyKghyRdQ/FP72xTY+Baic2IdgJVzIjIjBBHb1aNNvhE4uhx5mcVUMWA8rNLB7ROPZLTRUkfd91oh3uA76v8XuKnJjc5iHvTFFLF0AKtznbk4ly1Nw7OVSUy9LM5opsvHaSepFvlVZN6/Q5mQ35rxk4Ji4be7U/h+hZM3eMmSHr9oDxUSnty9tuKl4o5zWbh41u7HyT/ogAlJIann5khcq2ykSH3zJZrHdIHLSR6CQ6XLVOxyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAQmNNN5KT75Q+inXGtHvYWjUL4komSe3FPvudU3x9U=;
 b=lGOod86IwTPNLVypBOVHm0lLzHnQaM7icMCVmawEJ/qi+7sAf56HQc9hVKFwW2hqa+fpPNHnd6xHq3UOptgJdPG7Unb+dOp+7jSIin/eOyoq87G0ZPw/QEHTCgWxuZq+pKXCsceP+IVm+EcDVhT4L1s7VYzbeql1uTQUJQyWyzp1LUl/9GVqiI8zwz98cevN3LRPszcZ3/2la0V1ENp1u+hGjN4zYwuvK6nRqD/q4gAVSVKp4BD/bc+1UKCEhDzHc1mQ1qHGmbO0I59uFjpcsicctsLkAeE7GbVG+sonGJb4dimlsDUc04SzHfYhWtcrDaIdwb2dto5CbV5kH4yBmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6920.namprd11.prod.outlook.com (2603:10b6:806:2bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Wed, 29 Mar
 2023 02:04:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%6]) with mapi id 15.20.6178.038; Wed, 29 Mar 2023
 02:04:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Topic: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
Thread-Index: AQHZWj/xX+6sX0Ji9kGqSs4peyRxha8DnNOAgAIo0ACACyFUgIAAH6+AgAAKWgA=
Date:   Wed, 29 Mar 2023 02:04:12 +0000
Message-ID: <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
         <20230319084927.29607-3-binbin.wu@linux.intel.com>
         <ZBhTa6QSGDp2ZkGU@gao-cwp> <ZBojJgTG/SNFS+3H@google.com>
         <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
         <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
In-Reply-To: <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6920:EE_
x-ms-office365-filtering-correlation-id: 662d89c7-4405-465f-ff75-08db2ff9e456
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dtDFYTf3evSfT/E8Eyjn3796DmyJrpVWPR/iLsSPj5WjRpM9Dl+ojtIe+qJVJhotDTdKymFMtbbwfT/xkp0YdL/PBAI8vccdVn4U4a0GGF6b/uSo8LSJEwTlD26++HRwoh29Ff9GordoEkwPqcZ7rF7HHxvgxS5nzp2xow8+T8fpg+DMSPCvV/5LgVrSXvpbB4u5u9iSFE1Ur9kHrFUSDZ3iGSyOogSVa+PyzTGqGJs8215IGq4HNog9WpGM22A9o7eIR46QQ8XCeUV6+hI7q7NXdfi9GQMcAiRem4d6RSSksLZJaTArbr2hVcX2zLsR/qg5RVwvyfKtbKcQ+wXIQch/3YUk4pQmpU54SqRvvYCn4zM5x9tekS4iU99IpJ+gGaifbTnXKdiJckHAFCDpqG7eDlHuhbU/nSFiUHJcW6gTDcwxX140Ls+gDaJ/Oz5vHcuRLC4CFQTFwr1+WDUjHRZjPri2M32d9SqcMgSCmnZu17QWIYmbJ6S7WY1rF4ttqYqgWr5ucP0iKjMRtYUmYJrlWWQfNpDz+Z7zdD+UQFCzPr+Yldtl4KUNl7XkqIPFbJzwLg6rkx1F00xsXbWaxuVvyZKEpCZMNTBBnt8+19zyeFU2C11+Dm7dWCrt/cyg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199021)(91956017)(2906002)(2616005)(64756008)(6512007)(66556008)(8676002)(66946007)(4326008)(66476007)(478600001)(6636002)(54906003)(76116006)(71200400001)(38070700005)(110136005)(26005)(316002)(53546011)(6506007)(186003)(86362001)(38100700002)(36756003)(41300700001)(122000001)(5660300002)(82960400001)(6486002)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZndpYnNmaVlFcTZRaVMzYlNIMDk4OWJQVUVyQU42UzNIdlByTVdxRmt0STR4?=
 =?utf-8?B?dkVrSUFTL2dvaWhYakE1TG9VN21JTUE0OVZOaVBQWkRnc3JHTkI3TlM2K3dY?=
 =?utf-8?B?MlZRV3d6b0RqYmtrODgvZFB1dzRaTURLc05DZTJmRVlGcnhIMEppMWpKQzFV?=
 =?utf-8?B?dmwyUHYrV2UwSDBSTkhqRVFUOW5sZDQ5VWJlbjFWNmZMZGVtRnhsb0pjQUlP?=
 =?utf-8?B?aE0rbGxzTWNqMmZ6OE5maFdpazVRc3dweGJpcjNMRFNOVy85Rk5ZaHBFMU5r?=
 =?utf-8?B?bzBWNHFDR2lpa00xUU5oQUk5ZitOWUlOSWM1MnFVRW1DUVZ0cUlzUk9WUHNN?=
 =?utf-8?B?ekZBSTFDbGJCRDFHckc1M1JYL0g3SVZrb3FoMFlkZC8rSnN2aGJXTUZ1TDRw?=
 =?utf-8?B?VG5aMDgzdll2OCtQV0d0ZUJpVG1yWmExVkhSMFgyRkpSY1Z1Qk9ibmd4MndZ?=
 =?utf-8?B?ckYvK2FiRmhNeERlbVpsZk0wN2F0dkFIY0VkeVp5VU1XT2FQREtqYkRNc2ZS?=
 =?utf-8?B?V0tEQytIR3o1MEhNclQ4SzJzbzFGS0d5bWdqYjBsT3RLcWRFTXNRaCsrRUY2?=
 =?utf-8?B?QmVKWnc5VlIyb00zQ0pscUtZbmhCZzhsWURWZ3M0S1hzTkExUVNMZGR4U3Zx?=
 =?utf-8?B?eGw3bXdJYkpQRmZUZEFtVDM5Vk55R2ZUaFJuU2xJVktpb0xTenNGeFN5TDdK?=
 =?utf-8?B?b01qSmdVdk9TdlNYK2VqeEV1WEtMQ1UwMU5JdnA1NzZsMUtrSzJJUmt2aUh4?=
 =?utf-8?B?SmtUZWF2dDUvZEJvb1dYNWlsdEMwZjFGQlloakg5SDM1M1dDS2NMak5vK3JZ?=
 =?utf-8?B?cjF5MFhmcDg4OGdFazdSU3lWQS9DMnpMNlBoTlhGUkpVc1lWZnVqNmg4QzFJ?=
 =?utf-8?B?R3J5S212QURaTDB1ZU40UUc0SHJyamFMQUFnS0hVVXFzWm9kZHh3eTNnREdQ?=
 =?utf-8?B?eXhmVDNhTnlhVWprYm9rKzFOcEpQTy83NlpERk5JUklEbk1KNlpkRVMvVzRx?=
 =?utf-8?B?dW9NVEV1U2xzdTBzc0Y1dUFHaVFEeldHSmgveVB5NG1yanRpREJsYXFLbW5I?=
 =?utf-8?B?MmZ3WGNZb0VHN0VJemFEcGFyN3ZJZi9vTTYyd3EvRXEvME1ld2pLL09DSGRl?=
 =?utf-8?B?ck83MCtCTGNCVlVxb1BkVEp4N3dGYWxSMGQwKy9BUUNSUm5IV0xLWExvZi9s?=
 =?utf-8?B?VDVwZm12SEJuWXJjM2JGa05PeEE2VDFzKzJVRHh6NEE2SUZ4aUlnMll4c3VG?=
 =?utf-8?B?NTZKdE85RU5sUDhJTVZJZzZ1RWh2R2I4WjlSd0cwKzd1dVFNL3RiMmFUbUw3?=
 =?utf-8?B?ZFpjUmtGSVlsM0lzaUxZNjVrcE5uYWlkZHB0Z0VwZXVzMmRTRENjUWZQZUpE?=
 =?utf-8?B?SGpGUzZTbXVDc3ZPUmxYdzNRL1NYMStnRzIrWCtydzZMS21hNFRIV0tDQ0Vx?=
 =?utf-8?B?Q01xT0h2SEovTkJrbHdMSTJacWsxTnVMYnZPTkhOV1RYbk8wUmRxbSt6a1NN?=
 =?utf-8?B?K044WFlFbVVTSjltbUZpMERyQkQwSWdnT2lUVzljOERHYituVE95S293cGpL?=
 =?utf-8?B?QmtEampKcy9UY0hTUXFzdm14NWhGd0R1K0ZXUzN2eTdKbEU2N3BBcklwWlFD?=
 =?utf-8?B?VUFtNkRYcU1tVkNDNWk3Z2hscDQ2WWNkaXlialZQR2JJN1lsZmcra2dSYU40?=
 =?utf-8?B?bTRrdFFHb0QvZDRiajlEYmxNMCtJSjZzY05aVVdqWDRqb3FXU00vTlE4RzZH?=
 =?utf-8?B?bHdVZys5ck5yZS9icExVd2l2Z3pXQUI5NVBuMXNqUW1uRjVaeDFjanRaTlUy?=
 =?utf-8?B?T2dGa0xDVnJDa0lPckZBMEU4dnhRUkhtMFdMTmJhZElUdmdsY0NLVzV4b3U0?=
 =?utf-8?B?dTNlMFZXZmUxckpNcHh4U2RpWVROTkRZNlBsV2xaTHpnRy8yNEhoZXJya2hB?=
 =?utf-8?B?a2ZHNGR1NFpIb2doeE91UDJrSlRmem53WU5qb1hQRDMxRlFiVjEyM3NIa1k3?=
 =?utf-8?B?cTJiUVRIS2Y4S3FLUXlvd1BiQUd1dFJYdEdQT3c5anJiR1RUSThLRUM4UHBy?=
 =?utf-8?B?aUFSKzlWckFrTjlOZkQxdnBmcEJDWFVieStUaktjZ3Z0OW9Qcjl4M0NUaW13?=
 =?utf-8?Q?JicWodf/bL4j/3U65Ce7jHjKU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4D52753E3F428408DA86ECB1204EF80@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 662d89c7-4405-465f-ff75-08db2ff9e456
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 02:04:12.6857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6dhrUj39SsjBZvGJjBDH011bu/f9o+JU7WgBuoyk+j8ci2ONpmV66MYh7ZsHnbKTWUMwFYu6QzfGQ74vW8eEKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6920
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTI5IGF0IDA5OjI3ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE9u
IDMvMjkvMjAyMyA3OjMzIEFNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMy0w
My0yMSBhdCAxNDozNSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+IE9u
IE1vbiwgTWFyIDIwLCAyMDIzLCBDaGFvIEdhbyB3cm90ZToNCj4gPiA+ID4gT24gU3VuLCBNYXIg
MTksIDIwMjMgYXQgMDQ6NDk6MjJQTSArMDgwMCwgQmluYmluIFd1IHdyb3RlOg0KPiA+ID4gPiA+
IGdldF92bXhfbWVtX2FkZHJlc3MoKSBhbmQgc2d4X2dldF9lbmNsc19ndmEoKSB1c2UgaXNfbG9u
Z19tb2RlKCkNCj4gPiA+ID4gPiB0byBjaGVjayA2NC1iaXQgbW9kZS4gU2hvdWxkIHVzZSBpc182
NF9iaXRfbW9kZSgpIGluc3RlYWQuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gRml4ZXM6IGY5ZWI0
YWY2N2M5ZCAoIktWTTogblZNWDogVk1YIGluc3RydWN0aW9uczogYWRkIGNoZWNrcyBmb3IgI0dQ
LyNTUyBleGNlcHRpb25zIikNCj4gPiA+ID4gPiBGaXhlczogNzAyMTBjMDQ0YjRlICgiS1ZNOiBW
TVg6IEFkZCBTR1ggRU5DTFNbRUNSRUFURV0gaGFuZGxlciB0byBlbmZvcmNlIENQVUlEIHJlc3Ry
aWN0aW9ucyIpDQo+ID4gPiA+IEl0IGlzIGJldHRlciB0byBzcGxpdCB0aGlzIHBhdGNoIGludG8g
dHdvOiBvbmUgZm9yIG5lc3RlZCBhbmQgb25lIGZvcg0KPiA+ID4gPiBTR1guDQo+ID4gPiA+IA0K
PiA+ID4gPiBJdCBpcyBwb3NzaWJsZSB0aGF0IHRoZXJlIGlzIGEga2VybmVsIHJlbGVhc2Ugd2hp
Y2ggaGFzIGp1c3Qgb25lIG9mDQo+ID4gPiA+IGFib3ZlIHR3byBmbGF3ZWQgY29tbWl0cywgdGhl
biB0aGlzIGZpeCBwYXRjaCBjYW5ub3QgYmUgYXBwbGllZCBjbGVhbmx5DQo+ID4gPiA+IHRvIHRo
ZSByZWxlYXNlLg0KPiA+ID4gVGhlIG5WTVggY29kZSBpc24ndCBidWdneSwgVk1YIGluc3RydWN0
aW9ucyAjVUQgaW4gY29tcGF0aWJpbGl0eSBtb2RlLCBhbmQgZXhjZXB0DQo+ID4gPiBmb3IgVk1D
QUxMLCB0aGF0ICNVRCBoYXMgaGlnaGVyIHByaW9yaXR5IHRoYW4gVk0tRXhpdCBpbnRlcmNlcHRp
b24uICBTbyBJJ2Qgc2F5DQo+ID4gPiBqdXN0IGRyb3AgdGhlIG5WTVggc2lkZSBvZiB0aGluZ3Mu
DQo+ID4gQnV0IGl0IGxvb2tzIHRoZSBvbGQgY29kZSBkb2Vzbid0IHVuY29uZGl0aW9uYWxseSBp
bmplY3QgI1VEIHdoZW4gaW4NCj4gPiBjb21wYXRpYmlsaXR5IG1vZGU/DQo+IA0KPiBJIHRoaW5r
IFNlYW4gbWVhbnMgVk1YIGluc3RydWN0aW9ucyBpcyBub3QgdmFsaWQgaW4gY29tcGF0aWJpbGl0
eSBtb2RlIA0KPiBhbmQgaXQgdHJpZ2dlcnMgI1VELCB3aGljaCBoYXMgaGlnaGVyIHByaW9yaXR5
IHRoYW4gVk0tRXhpdCwgYnkgdGhlIA0KPiBwcm9jZXNzb3IgaW4gbm9uLXJvb3QgbW9kZS4NCj4g
DQo+IFNvIGlmIHRoZXJlIGlzIGEgVk0tRXhpdCBkdWUgdG8gVk1YIGluc3RydWN0aW9uICwgaXQg
aXMgaW4gNjQtYml0IG1vZGUgDQo+IGZvciBzdXJlIGlmIGl0IGlzIGluIGxvbmcgbW9kZS4NCg0K
T2ggSSBzZWUgdGhhbmtzLg0KDQpUaGVuIGlzIGl0IGJldHRlciB0byBhZGQgc29tZSBjb21tZW50
IHRvIGV4cGxhaW4sIG9yIGFkZCBhIFdBUk4oKSBpZiBpdCdzIG5vdCBpbg0KNjQtYml0IG1vZGU/
DQoNCg==
