Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE3565887F
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 03:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbiL2CA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 21:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiL2CAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 21:00:24 -0500
X-Greylist: delayed 467 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Dec 2022 18:00:11 PST
Received: from mail4.tencent.com (mail12.tencent.com [61.241.47.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8051FBC9B;
        Wed, 28 Dec 2022 18:00:11 -0800 (PST)
Received: from EX-SZ018.tencent.com (unknown [10.28.6.39])
        by mail4.tencent.com (Postfix) with ESMTP id 3B180BA31F;
        Thu, 29 Dec 2022 09:52:22 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1672278742;
        bh=IT5RZfT5T334qVeq2A/RSbr1MuPROR0hLfXMCIZCR+o=;
        h=From:To:CC:Subject:Date;
        b=VAITQT+B4wjIJ24YQuIEAMVlpM2ZD9YsCynLp56lUHDiCXkrKEtN2ETo2u1xpogf8
         SiHLYM11/MJ/JkDtGKkIkchBfhRb8s8DLML6LmyQo/NNUxswL6jtcuwwvWzy2lnnIo
         V3MCzDygWV4cmSrGms2vRyYNFvWY034cjautQQ3c=
Received: from EX-SZ052.tencent.com (10.28.6.108) by EX-SZ018.tencent.com
 (10.28.6.39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 29 Dec
 2022 09:52:22 +0800
Received: from EX-SZ049.tencent.com (10.28.6.102) by EX-SZ052.tencent.com
 (10.28.6.108) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 29 Dec
 2022 09:52:21 +0800
Received: from EX-SZ049.tencent.com ([fe80::a50b:1c86:c1f2:8cf4]) by
 EX-SZ049.tencent.com ([fe80::a50b:1c86:c1f2:8cf4%8]) with mapi id
 15.01.2242.008; Thu, 29 Dec 2022 09:52:21 +0800
From:   =?utf-8?B?Zmx5aW5ncGVuZyjlva3mtakp?= <flyingpeng@tencent.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH v2] KVM: use unified srcu interface function
Thread-Topic: [RESEND PATCH v2] KVM: use unified srcu interface function
Thread-Index: AQHZGygwmEDfKOhCQ02bKVr49C7THQ==
Date:   Thu, 29 Dec 2022 01:52:21 +0000
Message-ID: <C1483DFC-94D2-4515-95E5-FCEEC0B2A250@tencent.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.213.112]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D873D5F5A08BEB42B5C1EA4350589402@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_PASS,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

a3ZtLT5pcnFfcm91dGluZyBpcyBwcm90ZWN0ZWQgYnkga3ZtLT5pcnFfc3JjdS4NCg0KU2lnbmVk
LW9mZi1ieTogUGVuZyBIYW8gPGZseWluZ3BlbmdAdGVuY2VudC5jb20+DQotLS0NCiB2aXJ0L2t2
bS9pcnFjaGlwLmMgfCA5ICsrKysrKy0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMo
KyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9pcnFjaGlwLmMgYi92
aXJ0L2t2bS9pcnFjaGlwLmMNCmluZGV4IDFlNTY3ZDFmNmQzZC4uZDNjY2ZlOTIyODgwIDEwMDY0
NA0KLS0tIGEvdmlydC9rdm0vaXJxY2hpcC5jDQorKysgYi92aXJ0L2t2bS9pcnFjaGlwLmMNCkBA
IC0xOCw2ICsxOCwxMCBAQA0KICNpbmNsdWRlIDxsaW51eC9leHBvcnQuaD4NCiAjaW5jbHVkZSA8
dHJhY2UvZXZlbnRzL2t2bS5oPg0KDQorI2RlZmluZSBrdm1fZ2V0X2lycV9yb3V0aW5nKGt2bSkg
XA0KKyAgICAgICBzcmN1X2RlcmVmZXJlbmNlX2NoZWNrKChrdm0pLT5pcnFfcm91dGluZywgJihr
dm0pLT5pcnFfc3JjdSwgICAgXA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb2Nr
ZGVwX2lzX2hlbGQoJihrdm0pLT5pcnFfbG9jaykpDQorDQogaW50IGt2bV9pcnFfbWFwX2dzaShz
dHJ1Y3Qga3ZtICprdm0sDQogICAgICAgICAgICAgICAgICAgIHN0cnVjdCBrdm1fa2VybmVsX2ly
cV9yb3V0aW5nX2VudHJ5ICplbnRyaWVzLCBpbnQgZ3NpKQ0KIHsNCkBAIC0yNSw4ICsyOSw3IEBA
IGludCBrdm1faXJxX21hcF9nc2koc3RydWN0IGt2bSAqa3ZtLA0KICAgICAgICBzdHJ1Y3Qga3Zt
X2tlcm5lbF9pcnFfcm91dGluZ19lbnRyeSAqZTsNCiAgICAgICAgaW50IG4gPSAwOw0KDQotICAg
ICAgIGlycV9ydCA9IHNyY3VfZGVyZWZlcmVuY2VfY2hlY2soa3ZtLT5pcnFfcm91dGluZywgJmt2
bS0+aXJxX3NyY3UsDQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9j
a2RlcF9pc19oZWxkKCZrdm0tPmlycV9sb2NrKSk7DQorICAgICAgIGlycV9ydCA9IGt2bV9nZXRf
aXJxX3JvdXRpbmcoa3ZtKTsNCiAgICAgICAgaWYgKGlycV9ydCAmJiBnc2kgPCBpcnFfcnQtPm5y
X3J0X2VudHJpZXMpIHsNCiAgICAgICAgICAgICAgICBobGlzdF9mb3JfZWFjaF9lbnRyeShlLCAm
aXJxX3J0LT5tYXBbZ3NpXSwgbGluaykgew0KICAgICAgICAgICAgICAgICAgICAgICAgZW50cmll
c1tuXSA9ICplOw0KQEAgLTIxNiw3ICsyMTksNyBAQCBpbnQga3ZtX3NldF9pcnFfcm91dGluZyhz
dHJ1Y3Qga3ZtICprdm0sDQogICAgICAgIH0NCg0KICAgICAgICBtdXRleF9sb2NrKCZrdm0tPmly
cV9sb2NrKTsNCi0gICAgICAgb2xkID0gcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZChrdm0tPmly
cV9yb3V0aW5nLCAxKTsNCisgICAgICAgb2xkID0ga3ZtX2dldF9pcnFfcm91dGluZyhrdm0pOw0K
ICAgICAgICByY3VfYXNzaWduX3BvaW50ZXIoa3ZtLT5pcnFfcm91dGluZywgbmV3KTsNCiAgICAg
ICAga3ZtX2lycV9yb3V0aW5nX3VwZGF0ZShrdm0pOw0KICAgICAgICBrdm1fYXJjaF9pcnFfcm91
dGluZ191cGRhdGUoa3ZtKTsNCi0tDQoyLjI3LjANCg0K
