Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612A14898E0
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 13:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245696AbiAJMxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 07:53:39 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:44190 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245667AbiAJMxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 07:53:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1641819210; x=1673355210;
  h=from:to:cc:subject:date:message-id:content-id:
   mime-version:content-transfer-encoding;
  bh=2P5JGsdxinQXkZL5Ns72OulpK3E3WB0wNgOxWQG9DQE=;
  b=Qb0NeiG/I/w23Cb8JrqqZL0R6/TKmMuSeN48yEqGy+2hMwTEsRghnCjM
   06upAbQaG3wE0/8pM32E/POOepojMwOwIXRx+pK7JmvBtw06M3/ZQg+MB
   /rsjVEOsTHpx54Tft8xuJ9kIzGPXlQ780HFsTOWlbgiR22XhnmTXRsVLa
   4=;
X-IronPort-AV: E=Sophos;i="5.88,277,1635206400"; 
   d="scan'208,223";a="164439399"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 10 Jan 2022 12:53:19 +0000
Received: from EX13D15EUA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id 1CB31C189A;
        Mon, 10 Jan 2022 12:53:18 +0000 (UTC)
Received: from EX13D15EUA003.ant.amazon.com (10.43.165.94) by
 EX13D15EUA002.ant.amazon.com (10.43.165.79) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 10 Jan 2022 12:53:18 +0000
Received: from EX13D15EUA003.ant.amazon.com ([10.43.165.94]) by
 EX13D15EUA003.ant.amazon.com ([10.43.165.94]) with mapi id 15.00.1497.026;
 Mon, 10 Jan 2022 12:53:18 +0000
From:   "Barzen, Benjamin" <bbarzen@amazon.de>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Benjamin Barzen <b.barzen@barzen.io>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] ACPI: fix ACPI RSDP located before 0xF0000 is
 not found
Thread-Topic: [kvm-unit-tests PATCH] ACPI: fix ACPI RSDP located before
 0xF0000 is not found
Thread-Index: AQHYBiEKBGU1VFCQdE2oyZtQQAMQhg==
Date:   Mon, 10 Jan 2022 12:53:17 +0000
Message-ID: <6DFC2BF8-5CAC-410C-9A36-36E92FFC7817@amazon.de>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.144]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB9C9044C009DE418BEDB991438B9F73@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbSBlMTA3MzE3ZDAyOWI1Mjk4Yzg4NzAxYjRiY2M5M2JjNjRlMjgzODRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogYmJhcnplbiA8YmJhcnplbkBhbWF6b24uY29tPg0KRGF0ZTog
V2VkLCAyOSBEZWMgMjAyMSAxMjo1MDoxNCArMDEwMA0KU3ViamVjdDogW1BBVENIXSBBQ1BJOiBm
aXggQUNQSSBSU0RQIGxvY2F0ZWQgYmVmb3JlIDB4RjAwMDAgaXMgbm90IGZvdW5kDQoNClRoZSBm
dW5jdGlvbiBmaW5kX2FjcGlfdGFibGVfYWRkciBsb2NhdGVzIHRoZSBBQ1BJIFJTRFAgYnkgc2Vh
cmNoaW5nIHRoZQ0KQklPUyByZWFkIG9ubHkgbWVtb3J5IHNwYWNlLiBUaGUgb2ZmaWNpYWwgQUNQ
SSBzcGVjaWZpY2F0aW9uIHN0YXRlcyB0aGF0DQp0aGlzIHNwYWNlIGdvZXMgZnJvbSAweEUwMDAw
IHRvIDB4RkZGRkYuIFRoZSBmdW5jdGlvbiBjdXJyZW50bHkgc3RhcnRzDQpzZWFyY2hpbmcgYXQg
MHhGMDAwMC4gQW55IFJTRFAgbG9jYXRlZCBiZWZvcmUgdGhhdCBhZGRyZXNzIGNhbg0Kc3Vic2Vx
dWVudGx5IG5vdCBiZSBmb3VuZC4NCg0KQ2hhbmdlIHRoZSBzdGFydCBhZGRyZXNzIG9mIHRoZSBz
ZWFyY2ggdG8gMHhFMDAwMC4NCg0KU2luZ2VkLW9mZi1ieTogQmVuamFtaW4gQmFyemVuIDxiYmFy
emVuQGFtYXpvbi5kZT4NCi0tLQ0KIGxpYi94ODYvYWNwaS5jIHwgMiArLQ0KIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvbGliL3g4
Ni9hY3BpLmMgYi9saWIveDg2L2FjcGkuYw0KaW5kZXggNDM3MzEwNi4uYmQ3ZjAyMiAxMDA2NDQN
Ci0tLSBhL2xpYi94ODYvYWNwaS5jDQorKysgYi9saWIveDg2L2FjcGkuYw0KQEAgLTE5LDcgKzE5
LDcgQEAgdm9pZCogZmluZF9hY3BpX3RhYmxlX2FkZHIodTMyIHNpZykNCiAgICAgICAgIHJldHVy
biAodm9pZCopKHVsb25nKWZhZHQtPmZpcm13YXJlX2N0cmw7DQogICAgIH0NCg0KLSAgICBmb3Io
YWRkciA9IDB4ZjAwMDA7IGFkZHIgPCAweDEwMDAwMDsgYWRkciArPSAxNikgew0KKyAgICBmb3Io
YWRkciA9IDB4ZTAwMDA7IGFkZHIgPCAweDEwMDAwMDsgYWRkciArPSAxNikgew0KICAgICAgICBy
c2RwID0gKHZvaWQqKWFkZHI7DQogICAgICAgIGlmIChyc2RwLT5zaWduYXR1cmUgPT0gMHgyMDUy
NTQ1MDIwNDQ1MzUyTEwpDQogICAgICAgICAgIGJyZWFrOw0KLS0gDQoyLjMyLjANCg0KDQoNCg0K
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgK
MTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9u
YXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50
ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

