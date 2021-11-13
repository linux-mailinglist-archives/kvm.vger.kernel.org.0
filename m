Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3F544F275
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 11:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbhKMKiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Nov 2021 05:38:24 -0500
Received: from smtp4.jd.com ([59.151.64.78]:2049 "EHLO smtp4.jd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhKMKiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Nov 2021 05:38:23 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Nov 2021 05:38:23 EST
Received: from JDCloudMail06.360buyAD.local (172.31.68.39) by
 JDCloudMail08.360buyAD.local (172.31.68.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Sat, 13 Nov 2021 18:20:19 +0800
Received: from JDCloudMail06.360buyAD.local ([fe80::643e:3192:cad7:c913]) by
 JDCloudMail06.360buyAD.local ([fe80::643e:3192:cad7:c913%5]) with mapi id
 15.01.2375.007; Sat, 13 Nov 2021 18:20:19 +0800
From:   =?gb2312?B?u8bA1g==?= <huangle1@jd.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in
 vcpu_load_eoi_exitmap()
Thread-Topic: [PATCH] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in
 vcpu_load_eoi_exitmap()
Thread-Index: AQHX2HeasmdWyt4tWUajKJXYCzbqzA==
Date:   Sat, 13 Nov 2021 10:20:19 +0000
Message-ID: <1300eda19bce40d5a539bc431446da5e@jd.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.31.14.18]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SW4gdmNwdV9sb2FkX2VvaV9leGl0bWFwKCksIGN1cnJlbnRseSB0aGUgZW9pX2V4aXRfYml0bWFw
WzRdIGFycmF5IGlzDQppbml0aWFsaXplZCBvbmx5IHdoZW4gSHlwZXItViBjb250ZXh0IGlzIGF2
YWlsYWJsZSwgaW4gb3RoZXIgcGF0aCBpdCBpcw0KanVzdCBwYXNzZWQgdG8ga3ZtX3g4Nl9vcHMu
bG9hZF9lb2lfZXhpdG1hcCgpIGRpcmVjdGx5IGZyb20gb24gdGhlIHN0YWNrLA0Kd2hpY2ggd291
bGQgY2F1c2UgdW5leHBlY3RlZCBpbnRlcnJ1cHQgZGVsaXZlcnkvaGFuZGxpbmcgaXNzdWVzLCBl
LmcuIGFuDQoqb2xkKiBsaW51eCBrZXJuZWwgdGhhdCByZWxpZXMgb24gUElUIHRvIGRvIGNsb2Nr
IGNhbGlicmF0aW9uIG9uIEtWTSBtaWdodA0KcmFuZG9tbHkgZmFpbCB0byBib290Lg0KDQpGaXgg
aXQgYnkgcGFzc2luZyBpb2FwaWNfaGFuZGxlZF92ZWN0b3JzIHRvIGxvYWRfZW9pX2V4aXRtYXAo
KSB3aGVuIEh5cGVyLVYNCmNvbnRleHQgaXMgbm90IGF2YWlsYWJsZS4NCg0KU2lnbmVkLW9mZi1i
eTogSHVhbmcgTGUgPGh1YW5nbGUxQGpkLmNvbT4NCi0tLQ0KZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KaW5kZXggZGM3ZWI1ZmRkZmQzLi4wNjk5
ODMyNTA0YzkgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCisrKyBiL2FyY2gveDg2
L2t2bS94ODYuYw0KQEAgLTk1NDcsMTEgKzk1NDcsMTQgQEAgc3RhdGljIHZvaWQgdmNwdV9sb2Fk
X2VvaV9leGl0bWFwKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiAJaWYgKCFrdm1fYXBpY19od19l
bmFibGVkKHZjcHUtPmFyY2guYXBpYykpDQogCQlyZXR1cm47DQogDQotCWlmICh0b19odl92Y3B1
KHZjcHUpKQ0KLQkJYml0bWFwX29yKCh1bG9uZyAqKWVvaV9leGl0X2JpdG1hcCwNCi0JCQkgIHZj
cHUtPmFyY2guaW9hcGljX2hhbmRsZWRfdmVjdG9ycywNCi0JCQkgIHRvX2h2X3N5bmljKHZjcHUp
LT52ZWNfYml0bWFwLCAyNTYpOw0KKwlpZiAoIXRvX2h2X3ZjcHUodmNwdSkpIHsNCisJCXN0YXRp
Y19jYWxsKGt2bV94ODZfbG9hZF9lb2lfZXhpdG1hcCkoDQorCQkJdmNwdSwgKHU2NCAqKXZjcHUt
PmFyY2guaW9hcGljX2hhbmRsZWRfdmVjdG9ycyk7DQorCQlyZXR1cm47DQorCX0NCiANCisJYml0
bWFwX29yKCh1bG9uZyAqKWVvaV9leGl0X2JpdG1hcCwgdmNwdS0+YXJjaC5pb2FwaWNfaGFuZGxl
ZF92ZWN0b3JzLA0KKwkJICB0b19odl9zeW5pYyh2Y3B1KS0+dmVjX2JpdG1hcCwgMjU2KTsNCiAJ
c3RhdGljX2NhbGwoa3ZtX3g4Nl9sb2FkX2VvaV9leGl0bWFwKSh2Y3B1LCBlb2lfZXhpdF9iaXRt
YXApOw0KIH0NCiANCg==
