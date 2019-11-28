Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEA410C7CE
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 12:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfK1LQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 06:16:31 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:47858 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfK1LQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 06:16:31 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id B517DF91447D49C6887B;
        Thu, 28 Nov 2019 19:16:29 +0800 (CST)
Received: from dggeme765-chm.china.huawei.com (10.3.19.111) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 28 Nov 2019 19:16:29 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme765-chm.china.huawei.com (10.3.19.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 28 Nov 2019 19:16:29 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 28 Nov 2019 19:16:29 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Steven Price <steven.price@arm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "will@kernel.org" <will@kernel.org>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: vgic: Use wrapper function to lock/unlock all
 vcpus in kvm_vgic_create()
Thread-Topic: [PATCH v2] KVM: vgic: Use wrapper function to lock/unlock all
 vcpus in kvm_vgic_create()
Thread-Index: AdWl3KlyTD6n4fFd4E+DqrFstDRVng==
Date:   Thu, 28 Nov 2019 11:16:28 +0000
Message-ID: <49f3dec1fa65498c84d0344e0ea629ce@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U3RldmVuIFByaWNlIHdyb3RlOg0KPj4gICANCj4+ICAgCWlmIChpcnFjaGlwX2luX2tlcm5lbChr
dm0pKQ0KPj4gQEAgLTkyLDExICs5Miw4IEBAIGludCBrdm1fdmdpY19jcmVhdGUoc3RydWN0IGt2
bSAqa3ZtLCB1MzIgdHlwZSkNCj5FeHRyYSBjb250ZXh0Og0KPg0KPgkvKg0KPgkgKiBBbnkgdGlt
ZSBhIHZjcHUgaXMgcnVuLCB2Y3B1X2xvYWQgaXMgY2FsbGVkIHdoaWNoIHRyaWVzIHRvIGdyYWIg
dGhlDQo+CSAqIHZjcHUtPm11dGV4LiAgQnkgZ3JhYmJpbmcgdGhlIHZjcHUtPm11dGV4IG9mIGFs
bCBWQ1BVcyB3ZSBlbnN1cmUNCj4+ICAgCSAqIHRoYXQgbm8gb3RoZXIgVkNQVXMgYXJlIHJ1biB3
aGlsZSB3ZSBjcmVhdGUgdGhlIHZnaWMuDQo+PiAgIAkgKi8NCj4NCj5UaGF0IGNvbW1lbnQgbm8g
bG9uZ2VyIG1ha2VzIHNlbnNlIGhlcmUgLSB0aGVyZSdzIGEgdmVyeSBzaW1pbGFyIG9uZSBhbHJl
YWR5IGluIGxvY2tfYWxsX3ZjcHVzKCkuIFdpdGggdGhhdCByZW1vdmVkOg0KPg0KPlJldmlld2Vk
LWJ5OiBTdGV2ZW4gUHJpY2UgPHN0ZXZlbi5wcmljZUBhcm0uY29tPg0KPg0KTWFueSB0aGFua3Mg
Zm9yIHlvdXIgcmV2aWV3LiBUaGF0IGNvbW1lbnQgbm8gbG9uZ2VyIG1ha2VzIHNlbnNlIGFzIHlv
dSBmaWd1cmVkIG91dC4gSSB3aWxsDQpyZW1vdmUgdGhhdC4gVGhhbmtzIGFnYWluLg0KDQo+PiAg
IAlyZXQgPSAtRUJVU1k7DQo+PiAtCWt2bV9mb3JfZWFjaF92Y3B1KGksIHZjcHUsIGt2bSkgew0K
Pj4gLQkJaWYgKCFtdXRleF90cnlsb2NrKCZ2Y3B1LT5tdXRleCkpDQo+PiAtCQkJZ290byBvdXRf
dW5sb2NrOw0KPj4gLQkJdmNwdV9sb2NrX2lkeCA9IGk7DQo=
