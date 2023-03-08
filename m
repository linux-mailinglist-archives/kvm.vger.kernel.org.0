Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F916B06B8
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 13:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjCHMQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 07:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCHMQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 07:16:11 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D249BA4A
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 04:16:07 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-27-ZwokEwwKO2-vd15XSZuFEA-1; Wed, 08 Mar 2023 12:16:04 +0000
X-MC-Unique: ZwokEwwKO2-vd15XSZuFEA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Wed, 8 Mar
 2023 12:15:56 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Wed, 8 Mar 2023 12:15:56 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Woodhouse' <dwmw2@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Usama Arif <usama.arif@bytedance.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "brgerst@gmail.com" <brgerst@gmail.com>,
        "Rapan, Sabin" <sabrapan@amazon.com>
CC:     "piotrgorski@cachyos.org" <piotrgorski@cachyos.org>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>
Subject: RE: [PATCH v13 00/11] Parallel CPU bringup for x86_64
Thread-Topic: [PATCH v13 00/11] Parallel CPU bringup for x86_64
Thread-Index: AQHZUZ1JrrsGLfc9/UqVDEYgWl/q367wy8Sw
Date:   Wed, 8 Mar 2023 12:15:56 +0000
Message-ID: <5aef7e908e1d492386d568ef36b75493@AcuMS.aculab.com>
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
         <faa0eb3bb8ba0326d501516a057ab46eaf1f3c05.camel@infradead.org>
         <effbb6e2-c5a1-af7f-830d-8d7088f57477@amd.com>
         <269ed38b5eed9c3a259c183d59d4f1eb5128f132.camel@infradead.org>
         <0c56683a-c258-46f6-056e-e85da8a557db@amd.com>
         <3bfbbd92-b2ed-8189-7b57-0533f6c87ae7@amd.com>
         <1975308c952236895f2d8f0e56af9db288eaf330.camel@infradead.org>
         <39f23da7-1e77-4535-21a6-00f77a382ae5@amd.com>
 <ba8aae2eafdeb09ec1a41d45ab3c2e4cdaf7a28f.camel@infradead.org>
In-Reply-To: <ba8aae2eafdeb09ec1a41d45ab3c2e4cdaf7a28f.camel@infradead.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogRGF2aWQgV29vZGhvdXNlDQo+IFNlbnQ6IDA4IE1hcmNoIDIwMjMgMDk6MDUNCi4uLg0K
PiBodHRwczovL2dpdC5pbmZyYWRlYWQub3JnL3VzZXJzL2R3bXcyL2xpbnV4LmdpdC9zaG9ydGxv
Zy9yZWZzL2hlYWRzL3BhcmFsbGVsLTYuMi12MTQNCj4gDQo+IExvb2tzIGxpa2UgdGhpczoNCj4g
DQo+IC8qDQo+ICAqIFdlIGNhbiBkbyA2NC1iaXQgQVAgYnJpbmd1cCBpbiBwYXJhbGxlbCBpZiB0
aGUgQ1BVIHJlcG9ydHMgaXRzIEFQSUMNCj4gICogSUQgaW4gQ1BVSUQgKGVpdGhlciBsZWFmIDB4
MEIgaWYgd2UgbmVlZCB0aGUgZnVsbCBBUElDIElEIGluIFgyQVBJQw0KPiAgKiBtb2RlLCBvciBs
ZWFmIDB4MDEgaWYgOCBiaXRzIGFyZSBzdWZmaWNpZW50KS4gT3RoZXJ3aXNlIGl0J3MgdG9vDQo+
ICAqIGhhcmQuDQo+ICAqLw0KPiBzdGF0aWMgYm9vbCBwcmVwYXJlX3BhcmFsbGVsX2JyaW5ndXAo
dm9pZCkNCj4gew0KPiAJYm9vbCBoYXNfc2V2X2VzID0gSVNfRU5BQkxFRChDT05GSUdfQU1EX01F
TV9FTkNSWVBUKSAmJg0KPiAJCXN0YXRpY19icmFuY2hfdW5saWtlbHkoJnNldl9lc19lbmFibGVf
a2V5KTsNCj4gDQo+IAlpZiAoSVNfRU5BQkxFRChDT05GSUdfWDg2XzMyKSkNCj4gCQlyZXR1cm4g
ZmFsc2U7DQo+IA0KPiAJLyoNCj4gCSAqIEVuY3J5cHRlZCBndWVzdHMgb3RoZXIgdGhhbiBTRVYt
RVMgKGluIHRoZSBmdXR1cmUpIHdpbGwgbmVlZCB0bw0KPiAJICogaW1wbGVtZW50IGFuIGVhcmx5
IHdheSBvZiBmaW5kaW5nIHRoZSBBUElDIElELCBzaW5jZSB0aGV5IHdpbGwNCj4gCSAqIHByZXN1
bWFibHkgYmxvY2sgZGlyZWN0IENQVUlEIHRvby4gQmUga2luZCB0byBvdXIgZnV0dXJlIHNlbHZl
cw0KPiAJICogYnkgd2FybmluZyBoZXJlIGluc3RlYWQgb2YganVzdCBsZXR0aW5nIHRoZW0gYnJl
YWsuIFBhcmFsbGVsDQo+IAkgKiBzdGFydHVwIGRvZXNuJ3QgaGF2ZSB0byBiZSBpbiB0aGUgZmly
c3Qgcm91bmQgb2YgZW5hYmxpbmcgcGF0Y2hlcw0KPiAJICogZm9yIGFueSBzdWNoIHRlY2hub2xv
Z3kuDQo+IAkgKi8NCj4gCWlmIChjY19wbGF0Zm9ybV9oYXMoQ0NfQVRUUl9HVUVTVF9TVEFURV9F
TkNSWVBUKSB8fCAhaGFzX3Nldl9lcykgew0KPiAJCXByX2luZm8oIkRpc2FibGluZyBwYXJhbGxl
bCBicmluZ3VwIGR1ZSB0byBndWVzdCBtZW1vcnkgZW5jcnlwdGlvblxuIik7DQo+IAkJcmV0dXJu
IGZhbHNlOw0KPiAJfQ0KDQpUaGF0IGxvb2tzIHdyb25nLCB3b24ndCBoYXNfc2V2X2VzIGFsbW9z
dCBhbHdheXMgYmUgZmFsc2UNCnNvIGl0IHByaW50cyB0aGUgbWVzc2FnZSBhbmQgcmV0dXJucz8N
Ck1heWJlIHMvfHwvJiYvID8NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtl
c2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBV
Sw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

