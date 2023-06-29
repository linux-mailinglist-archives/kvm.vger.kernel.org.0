Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689DF742243
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 10:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjF2Idc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 04:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbjF2Ibh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 04:31:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CC035B8
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 01:31:06 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-188-ZvKUV6J3PPaZX2o5EdTfCA-1; Thu, 29 Jun 2023 09:31:02 +0100
X-MC-Unique: ZvKUV6J3PPaZX2o5EdTfCA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 29 Jun
 2023 09:30:55 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 29 Jun 2023 09:30:55 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Binbin Wu' <binbin.wu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: RE: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Thread-Topic: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Thread-Index: AQHZqlC0uINXWfrAwkGeA7kqt5GlV6+hciGw
Date:   Thu, 29 Jun 2023 08:30:55 +0000
Message-ID: <5a130fdd3a8e4bc6a86f595653cd53cc@AcuMS.aculab.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-5-binbin.wu@linux.intel.com>
 <ZJt7vud/2FJtcGjV@google.com>
 <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
In-Reply-To: <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
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
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogQmluYmluIFd1DQo+IFNlbnQ6IDI5IEp1bmUgMjAyMyAwNzoxMg0KLi4uDQo+ID4+ICt2
b2lkIHZteF91bnRhZ19hZGRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ3ZhX3QgKmd2YSwgdTMy
IGZsYWdzKQ0KPiA+DQo+ID4gUmF0aGVyIHRoYW4gbW9kaWZ5IHRoZSBwb2ludGVyLCByZXR1cm4g
dGhlIHVudGFnZ2VkIGFkZHJlc3MuICBUaGF0J3MgbW9yZSBmbGV4aWJsZQ0KPiA+IGFzIGl0IGFs
bG93cyB1c2luZyB0aGUgcmVzdWx0IGluIGlmLXN0YXRlbWVudHMgYW5kIHdoYXRub3QuICBUaGF0
IG1pZ2h0IG5vdCBldmVyDQo+ID4gY29tZSBpbnRvIHBsYXksIGJ1dCB0aGVyZSdzIG5vIGdvb2Qg
cmVhc29uIHRvIHVzZSBhbiBpbi9vdXQgcGFyYW0gaW4gYSB2b2lkDQo+ID4gZnVuY3Rpb24uDQo+
DQo+IEluIGVhcmxpZXIgdmVyc2lvbiwgaXQgZGlkIHJldHVybiB0aGUgdW50YWdnZWQgYWRkcmVz
cy4NCj4gSW4gdGhpcyB2ZXJzaW9uLCBJIGNoYW5nZWQgaXQgYXMgYW4gaW4vb3V0IHBhcmFtIHRv
IG1ha2UgdGhlIGludGVyZmFjZQ0KPiBjb25kaXRpb25hbCBhbmQgYXZvaWQgdG8gYWRkIGEgZHVt
bXkgb25lIGluIFNWTS4NCj4gSXMgaXQgY2FuIGJlIGEgcmVhc29uPw0KDQpZb3UgYXJlIGFsd2F5
cyBnb2luZyB0byBuZWVkIGEgJ2R1bW15JyB2ZXJzaW9uLg0KSWYgaXQgZW5kcyB1cCBiZWluZyAn
eCA9IHgnIHRoZSBjb21waWxlciB3aWxsIGp1c3Qgb3B0aW1pc2UNCml0IGF3YXkuDQoNCkJ1dCBm
b3IgYSByZWFsIGZ1bmN0aW9uIHlvdSdsbCBnZXQgbXVjaCBiZXR0ZXIgY29kZSBmcm9tOg0KCXgg
PSBmbih4KTsNCnRoYW4NCglmbigmeCk7DQoNCkl0IGFsc28gbGV0cyB5b3UgdXNlZCAndm9pZCAq
JyAoZXRjKSB0byBhdm9pZCBjYXN0cyB3aGljaA0KY2FuIGVhc2lseSBoaWRlIGJ1Z3MuDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

