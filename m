Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE474EEA10
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243247AbiDAJBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 05:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiDAJBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 05:01:37 -0400
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6543518EE83
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 01:59:48 -0700 (PDT)
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id EF651BEDB42E3715393D;
        Fri,  1 Apr 2022 16:59:45 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 1 Apr 2022 16:59:45 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Fri, 1 Apr 2022 16:59:45 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogeDg2OiBmaXggc2VuZGluZyBQViBJUEk=?=
Thread-Topic: [PATCH] KVM: x86: fix sending PV IPI
Thread-Index: AQHYM5CrLMEsMmoAoEC4S50ul411bKy2RcGAgCSgPnA=
Date:   Fri, 1 Apr 2022 08:59:45 +0000
Message-ID: <d2becdedf7cb4485ac823ee4b6b6586a@baidu.com>
References: <1646814944-51801-1-git-send-email-lirongqing@baidu.com>
 <c54cc8ba-a5a7-b73b-4bb4-12f766fef558@redhat.com>
In-Reply-To: <c54cc8ba-a5a7-b73b-4bb4-12f766fef558@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gaWYgYXBpY19pZCBpcyBsZXNzIHRoYW4gbWluLCBhbmQgKG1heCAtIGFwaWNfaWQpIGlz
IGdyZWF0ZXIgdGhhbg0KPiA+IEtWTV9JUElfQ0xVU1RFUl9TSVpFLCB0aGVuIHRoaXJkIGNoZWNr
IGNvbmRpdGlvbiBpcyBzYXRpc2ZpZWQsDQo+ID4NCj4gPiBidXQgaXQgc2hvdWxkIGVudGVyIGxh
c3QgYnJhbmNoLCBzZW5kIElQSSBkaXJlY3RseQ0KPiA+DQo+ID4gRml4ZXM6IGFhZmZjZmQxZTgy
ICgiS1ZNOiBYODY6IEltcGxlbWVudCBQViBJUElzIGluIGxpbnV4IGd1ZXN0IikNCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+IA0KPiBTbyBh
biBleGFtcGxlIGlzDQo+IA0KPiAgICAgYXBpY19pZCBvbiBmaXJzdCBpdGVyYXRpb24gPSAxDQo+
ICAgICBhcGljX2lkIG9uIHNlY29uZCBpdGVyYXRpb24gPSBLVk1fSVBJX0NMVVNURVJfU0laRQ0K
PiAgICAgYXBpY19pZCBvbiB0aGlyZCBpdGVyYXRpb24gPSAwDQo+IA0KPiBUaGFua3MsIHRoaXMg
bG9va3MgZ29vZC4NCj4gDQo+IFBhb2xvDQoNCg0KUGluZw0KDQp0aGFua3MNCg0KLUxpDQo=
