Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150A36E5F4B
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 13:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjDRLFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 07:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjDRLFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 07:05:12 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253486A78
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 04:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1681815911; x=1713351911;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=2HnERvBgQYUpZIa5aCFslqFi29gSxf5cZ2esDYY7GpI=;
  b=GGl6L2ryNekPqzTsl6RFqKYi79zglaLF5GponXPky7qBLeA4HzXcnonh
   ODKOtY9L46Hs4CWzAP60mjIeKqvSJJsafEx0Evuqu54WfecNaHyYfUNl1
   3KGvJu5yCX+44bEsqJSgROTel5zB6k5ExIc/helnPl9kkhiZvixtlXksX
   Q=;
X-IronPort-AV: E=Sophos;i="5.99,207,1677542400"; 
   d="scan'208";a="277996201"
Subject: RE: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
Thread-Topic: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 11:05:05 +0000
Received: from EX19MTAUEA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com (Postfix) with ESMTPS id ACEC660F03;
        Tue, 18 Apr 2023 11:05:02 +0000 (UTC)
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 11:04:48 +0000
Received: from EX19D043EUB001.ant.amazon.com (10.252.61.24) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 11:04:48 +0000
Received: from EX19D043EUB001.ant.amazon.com ([fe80::e881:f31d:88bf:58d8]) by
 EX19D043EUB001.ant.amazon.com ([fe80::e881:f31d:88bf:58d8%4]) with mapi id
 15.02.1118.026; Tue, 18 Apr 2023 11:04:47 +0000
From:   "Kaya, Metin" <metikaya@amazon.co.uk>
To:     "paul@xen.org" <paul@xen.org>
CC:     "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "seanjc@google.com" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Thread-Index: AQHZcd5iZX2yQA9K00a8PYvJOdfTj68w4tGAgAACZSA=
Date:   Tue, 18 Apr 2023 11:04:47 +0000
Message-ID: <467e7c790c124cbcb98a764d4ae98ac2@amazon.co.uk>
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
 <20230418101306.98263-1-metikaya@amazon.co.uk>
 <3ede838b-15ef-a987-8584-cd871959797b@xen.org>
In-Reply-To: <3ede838b-15ef-a987-8584-cd871959797b@xen.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.82.23]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTgvMDQvMjAyMyAxMTo0OCwgUGF1bCBEdXJyYW50IHdyb3RlOg0KPk9uIDE4LzA0LzIwMjMg
MTE6MTMsIE1ldGluIEtheWEgd3JvdGU6DQo+PiBJbXBsZW1lbnQgaW4tS1ZNIHN1cHBvcnQgZm9y
IFhlbidzIEhWTU9QX2ZsdXNoX3RsYnMgaHlwZXJjYWxsLCB3aGljaA0KPj4gYWxsb3dzIHRoZSBn
dWVzdCB0byBmbHVzaCBhbGwgdkNQVSdzIFRMQnMuIEtWTSBkb2Vzbid0IHByb3ZpZGUgYW4NCj4+
IGlvY3RsKCkgdG8gcHJlY2lzZWx5IGZsdXNoIGd1ZXN0IFRMQnMsIGFuZCBwdW50aW5nIHRvIHVz
ZXJzcGFjZSB3b3VsZA0KPj4gbGlrZWx5IG5lZ2F0ZSB0aGUgcGVyZm9ybWFuY2UgYmVuZWZpdHMg
b2YgYXZvaWRpbmcgYSBUTEIgc2hvb3Rkb3duIGluDQo+PiB0aGUgZ3Vlc3QuDQo+Pg0KPj4gU2ln
bmVkLW9mZi1ieTogTWV0aW4gS2F5YSA8bWV0aWtheWFAYW1hem9uLmNvLnVrPg0KPj4NCj4+IC0t
LQ0KPj4gdjM6DQo+PiAgICAtIEFkZHJlc3NlZCBjb21tZW50cyBmb3IgdjIuDQo+PiAgICAtIFZl
cmlmaWVkIHdpdGggWFRGL2ludmxwZyB0ZXN0IGNhc2UuDQo+Pg0KPj4gdjI6DQo+PiAgICAtIFJl
bW92ZWQgYW4gaXJyZWxldmFudCBVUkwgZnJvbSBjb21taXQgbWVzc2FnZS4NCj4+IC0tLQ0KPj4g
ICBhcmNoL3g4Ni9rdm0veGVuLmMgICAgICAgICAgICAgICAgIHwgMTUgKysrKysrKysrKysrKysr
DQo+PiAgIGluY2x1ZGUveGVuL2ludGVyZmFjZS9odm0vaHZtX29wLmggfCAgMyArKysNCj4+ICAg
MiBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2t2bS94ZW4uYyBiL2FyY2gveDg2L2t2bS94ZW4uYyBpbmRleA0KPj4gNDBlZGY0ZDE5
NzRjLi5hNjNjNDhlOGQ4ZmEgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0veGVuLmMNCj4+
ICsrKyBiL2FyY2gveDg2L2t2bS94ZW4uYw0KPj4gQEAgLTIxLDYgKzIxLDcgQEANCj4+ICAgI2lu
Y2x1ZGUgPHhlbi9pbnRlcmZhY2UvdmNwdS5oPg0KPj4gICAjaW5jbHVkZSA8eGVuL2ludGVyZmFj
ZS92ZXJzaW9uLmg+DQo+PiAgICNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL2V2ZW50X2NoYW5uZWwu
aD4NCj4+ICsjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9odm0vaHZtX29wLmg+DQo+PiAgICNpbmNs
dWRlIDx4ZW4vaW50ZXJmYWNlL3NjaGVkLmg+DQo+Pg0KPj4gICAjaW5jbHVkZSA8YXNtL3hlbi9j
cHVpZC5oPg0KPj4gQEAgLTEzMzAsNiArMTMzMSwxNyBAQCBzdGF0aWMgYm9vbCBrdm1feGVuX2hj
YWxsX3NjaGVkX29wKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBsb25nbW9kZSwNCj4+ICAg
ICAgIHJldHVybiBmYWxzZTsNCj4+ICAgfQ0KPj4NCj4+ICtzdGF0aWMgYm9vbCBrdm1feGVuX2hj
YWxsX2h2bV9vcChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludCBjbWQsIHU2NA0KPj4gK2FyZywg
dTY0ICpyKSB7DQo+PiArICAgICBpZiAoY21kID09IEhWTU9QX2ZsdXNoX3RsYnMgJiYgIWFyZykg
ew0KPj4gKyAgICAgICAgICAgICBrdm1fbWFrZV9hbGxfY3B1c19yZXF1ZXN0KHZjcHUtPmt2bSwg
S1ZNX1JFUV9UTEJfRkxVU0hfR1VFU1QpOw0KPj4gKyAgICAgICAgICAgICAqciA9IDA7DQo+PiAr
ICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPj4gKyAgICAgfQ0KPj4gKw0KPj4gKyAgICAgcmV0
dXJuIGZhbHNlOw0KPj4gK30NCj4NCj5UaGlzIGNvZGUgc3RydWN0dXJlIG1lYW5zIHRoYXQgYXJn
ICE9IE5VTEwgd2lsbCByZXN1bHQgaW4gdGhlIGd1ZXN0IHNlZWluZyBFTk9TWVMgcmF0aGVyIHRo
YW4gRUlOVkFMLg0KPg0KPiAgIFBhdWwNCg0KWWVzLCBiZWNhdXNlIG9mIHRoaXMgY29tbWVudCBp
biBEYXZpZCdzIGVtYWlsOg0KIkkgZG9uJ3QgZXZlbiBrbm93IHRoYXQgd2UgY2FyZSBhYm91dCBp
bi1rZXJuZWwgYWNjZWxlcmF0aW9uIGZvciB0aGUNCi1FSU5WQUwgY2FzZS4gV2UgY291bGQganVz
dCByZXR1cm4gZmFsc2UgZm9yIHRoYXQsIGFuZCBsZXQgdXNlcnNwYWNlDQoocmVwb3J0IGFuZCkg
aGFuZGxlIGl0LiINCg0KPg0KPj4gKw0KPj4gICBzdHJ1Y3QgY29tcGF0X3ZjcHVfc2V0X3Npbmds
ZXNob3RfdGltZXIgew0KPj4gICAgICAgdWludDY0X3QgdGltZW91dF9hYnNfbnM7DQo+PiAgICAg
ICB1aW50MzJfdCBmbGFnczsNCj4+IEBAIC0xNTAxLDYgKzE1MTMsOSBAQCBpbnQga3ZtX3hlbl9o
eXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPj4gICAgICAgICAgICAgICAgICAgICAg
IHRpbWVvdXQgfD0gcGFyYW1zWzFdIDw8IDMyOw0KPj4gICAgICAgICAgICAgICBoYW5kbGVkID0g
a3ZtX3hlbl9oY2FsbF9zZXRfdGltZXJfb3AodmNwdSwgdGltZW91dCwgJnIpOw0KPj4gICAgICAg
ICAgICAgICBicmVhazsNCj4+ICsgICAgIGNhc2UgX19IWVBFUlZJU09SX2h2bV9vcDoNCj4+ICsg
ICAgICAgICAgICAgaGFuZGxlZCA9IGt2bV94ZW5faGNhbGxfaHZtX29wKHZjcHUsIHBhcmFtc1sw
XSwgcGFyYW1zWzFdLCAmcik7DQo+PiArICAgICAgICAgICAgIGJyZWFrOw0KPj4gICAgICAgfQ0K
Pj4gICAgICAgZGVmYXVsdDoNCj4+ICAgICAgICAgICAgICAgYnJlYWs7DQo+PiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL2h2bS9odm1fb3AuaA0KPj4gYi9pbmNsdWRlL3hlbi9p
bnRlcmZhY2UvaHZtL2h2bV9vcC5oDQo+PiBpbmRleCAwMzEzNGJmM2NlYzEuLjI0MGQ4MTQ5YmMw
NCAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9odm0vaHZtX29wLmgNCj4+
ICsrKyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9odm0vaHZtX29wLmgNCj4+IEBAIC0xNiw2ICsx
Niw5IEBAIHN0cnVjdCB4ZW5faHZtX3BhcmFtIHsNCj4+ICAgfTsNCj4+ICAgREVGSU5FX0dVRVNU
X0hBTkRMRV9TVFJVQ1QoeGVuX2h2bV9wYXJhbSk7DQo+Pg0KPj4gKy8qIEZsdXNoZXMgZ3Vlc3Qg
VExCcyBmb3IgYWxsIHZDUFVzOiBAYXJnIG11c3QgYmUgMC4gKi8NCj4+ICsjZGVmaW5lIEhWTU9Q
X2ZsdXNoX3RsYnMgICAgICAgICAgICA1DQo+PiArDQo+PiAgIC8qIEhpbnQgZnJvbSBQViBkcml2
ZXJzIGZvciBwYWdldGFibGUgZGVzdHJ1Y3Rpb24uICovDQo+PiAgICNkZWZpbmUgSFZNT1BfcGFn
ZXRhYmxlX2R5aW5nICAgICAgIDkNCj4+ICAgc3RydWN0IHhlbl9odm1fcGFnZXRhYmxlX2R5aW5n
IHsNCj4NCg==
