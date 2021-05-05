Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F983746F6
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 19:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhEERgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 13:36:05 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:8810 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbhEER2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 13:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620235627; x=1651771627;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=a/Yz9LYY31a7mng3cULMsmTwelyZPWDQTB/uMgpmPWs=;
  b=JEzMhIN4nI+jBxK8WXd7PaBwzGVvOmHY2NtoVLWttcrB/qm2ozcwEroB
   dYj/br9sF6JF8JuDWMBA7RRR7eUm1GMyjoDLrXaZo+jpbBokySzFMkAVF
   nmF9LwJrIP0/zwpDjjdMm6b9HbywhynweVkTjr9yrYGn0Cn5DNtd+jYPw
   g=;
X-IronPort-AV: E=Sophos;i="5.82,276,1613433600"; 
   d="scan'208";a="105957263"
Subject: Re: [PATCH 0/5] x86/kvm: Refactor KVM PV features teardown and fix restore
 from hibernation
Thread-Topic: [PATCH 0/5] x86/kvm: Refactor KVM PV features teardown and fix restore from
 hibernation
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 05 May 2021 17:27:05 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 75F2F228B41;
        Wed,  5 May 2021 17:27:03 +0000 (UTC)
Received: from EX13D12UWA003.ant.amazon.com (10.43.160.50) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 May 2021 17:27:03 +0000
Received: from EX13D18UWA001.ant.amazon.com (10.43.160.11) by
 EX13D12UWA003.ant.amazon.com (10.43.160.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 May 2021 17:27:02 +0000
Received: from EX13D18UWA001.ant.amazon.com ([10.43.160.11]) by
 EX13D18UWA001.ant.amazon.com ([10.43.160.11]) with mapi id 15.00.1497.015;
 Wed, 5 May 2021 17:27:02 +0000
From:   "Aboubakr, Mohamed" <mabouba@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "Chen, Xiaoyi" <cxiaoyi@amazon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHXMSrPZBZbFiAqX0uajcToUSuZ2qrR/ugAgANGe9s=
Date:   Wed, 5 May 2021 17:27:02 +0000
Message-ID: <9D70AF46-F8CA-4CF4-8FB6-A1E3148F16C0@amazon.com>
References: <20210414123544.1060604-1-vkuznets@redhat.com>,<1134cd5c-29f4-c149-4380-1f6bff193398@redhat.com>
In-Reply-To: <1134cd5c-29f4-c149-4380-1f6bff193398@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGVsbG8sDQoNCkNvbmZpcm1lZCBjNS4xOHhsYXJnZSBhbmQgYzVhLjE4eGxhcmdlIGlzc3VlIGhh
cyBiZWVuIGZpeGVkIGJ5IHRoaXMgcGF0Y2guIA0KDQpUaGFua3MgDQpNb2hhbWVkIEFib3ViYWty
DQo+IE9uIE1heSAzLCAyMDIxLCBhdCA4OjI2IEFNLCBQYW9sbyBCb256aW5pIDxwYm9uemluaUBy
ZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IO+7v0NBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRl
ZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBjYW4gY29uZmlybSB0aGUgc2VuZGVyIGFuZCBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUuDQo+IA0KPiANCj4gDQo+PiBPbiAxNC8wNC8yMSAxNDoz
NSwgVml0YWx5IEt1em5ldHNvdiB3cm90ZToNCj4+IFRoaXMgc2VyaWVzIGlzIGEgc3VjY2Vzc29y
IG9mIExlbm55J3MgIltQQVRDSF0geDg2L2t2bWNsb2NrOiBTdG9wIGt2bWNsb2Nrcw0KPj4gZm9y
IGhpYmVybmF0ZSByZXN0b3JlIi4gV2hpbGUgcmV2aWV3aW5nIGhpcyBwYXRjaCBJIHJlYWxpemVk
IHRoYXQgUFYNCj4+IGZlYXR1cmVzIHRlYXJkb3duIHdlIGhhdmUgaXMgYSBiaXQgbWVzc3k6IGl0
IGlzIHNjYXR0ZXJlZCBhY3Jvc3Mga3ZtLmMNCj4+IGFuZCBrdm1jbG9jay5jIGFuZCBub3QgYWxs
IGZlYXR1cmVzIGFyZSBiZWluZyBzaHV0ZG93biBhbiBhbGwgcGF0aHMuDQo+PiBUaGlzIHNlcmll
cyB1bmlmaWVzIGFsbCB0ZWFyZG93biBwYXRocyBpbiBrdm0uYyBhbmQgbWFrZXMgc3VyZSBhbGwN
Cj4+IGZlYXR1cmVzIGFyZSBkaXNhYmxlZCB3aGVuIG5lZWRlZC4NCj4+IA0KPj4gVml0YWx5IEt1
em5ldHNvdiAoNSk6DQo+PiAgIHg4Ni9rdm06IEZpeCBwcl9pbmZvKCkgZm9yIGFzeW5jIFBGIHNl
dHVwL3RlYXJkb3duDQo+PiAgIHg4Ni9rdm06IFRlYXJkb3duIFBWIGZlYXR1cmVzIG9uIGJvb3Qg
Q1BVIGFzIHdlbGwNCj4+ICAgeDg2L2t2bTogRGlzYWJsZSBrdm1jbG9jayBvbiBhbGwgQ1BVcyBv
biBzaHV0ZG93bg0KPj4gICB4ODYva3ZtOiBEaXNhYmxlIGFsbCBQViBmZWF0dXJlcyBvbiBjcmFz
aA0KPj4gICB4ODYva3ZtOiBVbmlmeSBrdm1fcHZfZ3Vlc3RfY3B1X3JlYm9vdCgpIHdpdGgga3Zt
X2d1ZXN0X2NwdV9vZmZsaW5lKCkNCj4+IA0KPj4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9w
YXJhLmggfCAgMTAgKy0tDQo+PiAgYXJjaC94ODYva2VybmVsL2t2bS5jICAgICAgICAgICB8IDEx
MyArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KPj4gIGFyY2gveDg2L2tlcm5lbC9r
dm1jbG9jay5jICAgICAgfCAgMjYgKy0tLS0tLS0NCj4+ICAzIGZpbGVzIGNoYW5nZWQsIDc4IGlu
c2VydGlvbnMoKyksIDcxIGRlbGV0aW9ucygtKQ0KPj4gDQo+IA0KPiBRdWV1aW5nIHRoaXMgcGF0
Y2gsIHRoYW5rcy4NCj4gDQo+IElmIHRoZSBBbWF6b24gZm9sa3Mgd2FudCB0byBwcm92aWRlIHRo
ZWlyIFRlc3RlZC1ieSAoc2luY2UgdGhleSBsb29rZWQNCj4gYXQgaXQgYmVmb3JlIGFuZCB0ZXN0
ZWQgTGVubnkncyBmaXJzdCBhdHRlbXB0IGF0IHVzaW5nIHN5c2NvcmVfb3BzKSwNCj4gdGhleSdy
ZSBzdGlsbCBpbiB0aW1lIQ0KPiANCj4gUGFvbG8NCj4gDQo=
