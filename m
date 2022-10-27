Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80996101F2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 21:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbiJ0Ton (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 15:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbiJ0Tom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 15:44:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4906766A
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 12:44:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h9-20020a25e209000000b006cbc4084f2eso2409756ybe.23
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 12:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F5969g91dbqgEFpLHK1C1AqmZtJ3yQW2LjM/1ius4g0=;
        b=j5bFedNI3CnPqGiaeGxDEb8Ku8KLmT/ae9RgFpw7bC/u7kwsmaNVAB/qyNrJ6/01NR
         +LPmOZ01qE/CXR9+t/5U919qoYKHsQ62/YcaIAnNzJZnxMnh026V5rmpA1Dm1NwSQPIA
         9V5g9r2cc6RcgQnUym6KYel1nmDGkvN70C0XBhUVyRPEbA8wme/23k2Oqiq1wgOQXKob
         yToPtLP769u8BISXX3MzbJB+CDfde8QrUUtAE+U4t/02ImJs4SIwNZyt2S0u2mzWpFhd
         HLIAHkcPtYC8wdEHlCRsWr8GHsjydBQ4kuyPO4rQYvCZNXcUkXL6vuQ+1lR8GVlZDGvQ
         gECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F5969g91dbqgEFpLHK1C1AqmZtJ3yQW2LjM/1ius4g0=;
        b=qEkpssuuRpLsLRhp64L7R9SobdMZ69S1Nw9Sanm/llRS9NCM6b4i367YD/i6vdWu/y
         LKdrphNM7B1TWFQGM/YQhGC4Ynq7KXdcOKrnwZVyNzXxIK//iViP4Pe09VWJCVdd427R
         l9I+RVmOjdxdP7m/z82hHni0nkDk2VurqEEFUD1Zik+QGcvA1ceECv1kgWnmqYAhiBVS
         dzDU7q4FmHl0C1hoP2cZNGP70Pgjl2t7QvvkdfH7QluER3uVr7sO6LK47cYVeU2k2YGe
         irYmCb/+m5okf2dpVYDaX9vKYUc7yx0ngURi7GPKNqaBqEMZxwRDIkyjBG8XcHok0APp
         QoEw==
X-Gm-Message-State: ACrzQf1D9dBspQyHNdtq9tEMo6ALi+vgqAGvN3r+ai7aD/7Fyvm9LAIw
        AXD6uuvvqiYqEwdz0mHzvrQOxPwfTxEkHb0HIw==
X-Google-Smtp-Source: AMsMyM5rv+jZAFTPSSrxgqj/Yh9HCEa4wKqKC5AoZa8aP73WwBM6bQiSKiwTgWyRSIFWHTf4gqx536qJIOakgIaE2w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:58d:b0:36b:682f:a7cf with
 SMTP id bo13-20020a05690c058d00b0036b682fa7cfmr2ywb.120.1666899878644; Thu,
 27 Oct 2022 12:44:38 -0700 (PDT)
Date:   Thu, 27 Oct 2022 19:44:37 +0000
In-Reply-To: <Y1miBTa4cID5yH3Z@google.com> (message from Sean Christopherson
 on Wed, 26 Oct 2022 21:09:25 +0000)
Mime-Version: 1.0
Message-ID: <gsntv8o5126y.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 1/3] KVM: selftests: implement random number generation
 for guest code
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IHdyaXRlczoNCg0KPiBPbiBX
ZWQsIE9jdCAxOSwgMjAyMiwgQ29sdG9uIExld2lzIHdyb3RlOg0KPj4gSW1wbGVtZW50IHJhbmRv
bSBudW1iZXIgZ2VuZXJhdGlvbiBmb3IgZ3Vlc3QgY29kZSB0byByYW5kb21pemUgcGFydHMNCj4+
IG9mIHRoZSB0ZXN0LCBtYWtpbmcgaXQgbGVzcyBwcmVkaWN0YWJsZSBhbmQgYSBtb3JlIGFjY3Vy
YXRlIHJlZmxlY3Rpb24NCj4+IG9mIHJlYWxpdHkuDQoNCj4+IENyZWF0ZSBhIC1yIGFyZ3VtZW50
IHRvIHNwZWNpZnkgYSByYW5kb20gc2VlZC4gSWYgbm8gYXJndW1lbnQgaXMNCj4+IHByb3ZpZGVk
LCB0aGUgc2VlZCBkZWZhdWx0cyB0byAwLiBUaGUgcmFuZG9tIHNlZWQgaXMgc2V0IHdpdGgNCj4+
IHBlcmZfdGVzdF9zZXRfcmFuZG9tX3NlZWQoKSBhbmQgbXVzdCBiZSBzZXQgYmVmb3JlIGd1ZXN0
X2NvZGUgcnVucyB0bw0KPj4gYXBwbHkuDQoNCj4+IFRoZSByYW5kb20gbnVtYmVyIGdlbmVyYXRv
ciBjaG9zZW4gaXMgdGhlIFBhcmstTWlsbGVyIExpbmVhcg0KPj4gQ29uZ3J1ZW50aWFsIEdlbmVy
YXRvciwgYSBmYW5jeSBuYW1lIGZvciBhIGJhc2ljIGFuZCB3ZWxsLXVuZGVyc3Rvb2QNCj4+IHJh
bmRvbSBudW1iZXIgZ2VuZXJhdG9yIGVudGlyZWx5IHN1ZmZpY2llbnQgZm9yIHRoaXMgcHVycG9z
ZS4gRWFjaA0KPj4gdkNQVSBjYWxjdWxhdGVzIGl0cyBvd24gc2VlZCBieSBhZGRpbmcgaXRzIGlu
ZGV4IHRvIHRoZSBzZWVkIHByb3ZpZGVkLg0KDQo+PiBTaWduZWQtb2ZmLWJ5OiBDb2x0b24gTGV3
aXMgPGNvbHRvbmxld2lzQGdvb2dsZS5jb20+DQo+PiBSZXZpZXdlZC1ieTogUmljYXJkbyBLb2xs
ZXIgPHJpY2Fya29sQGdvb2dsZS5jb20+DQo+PiBSZXZpZXdlZC1ieTogRGF2aWQgTWF0bGFjayA8
ZG1hdGxhY2tAZ29vZ2xlLmNvbT4NCg0KPiBUaGlzIHBhdGNoIGhhcyBjaGFuZ2VkIGEgZmFpciBi
aXQgc2luY2UgRGF2aWQgYW5kIFJpY2FyZG8gZ2F2ZSB0aGVpciAgDQo+IHJldmlld3MsDQo+IHRo
ZWlyIFJldmlld2VkLWJ5J3Mgc2hvdWxkIGJlIGRyb3BwZWQuICBBbHRlcm5hdGl2ZWx5LCBpZiBh
IHBhdGNoIGhhcyBpcyAgDQo+IG9uIHRoZQ0KPiBmZW5jZSBzbyB0byBzcGVhaywgaS5lLiBoYXMg
Y2hhbmdlZCBhIGxpdHRsZSBiaXQgYnV0IG5vdCB0aGFhYWFhdCBtdWNoLCAgDQo+IHlvdSBjYW4N
Cj4gYWRkIHNvbWV0aGluZyBpbiB0aGUgY292ZXIgbGV0dGVyLCBlLmcuICJEYXZpZC9SaWNhcmRv
LCBJIGtlcHQgeW91ciAgDQo+IHJldmlld3MsIGxldA0KPiBtZSBrbm93IGlmIHRoYXQncyBub3Qg
b2siLiAgQnV0IGluIHRoaXMgY2FzZSwgSSB0aGluayB0aGUgY29kZSBoYXMgIA0KPiBjaGFuZ2Vk
IGVub3VnaA0KPiB0aGF0IHRoZWlyIHJldmlld3Mgc2hvdWxkIGJlIGRyb3BwZWQuDQoNCg0KSSB0
YWxrZWQgdG8gUmljYXJkbyBwcml2YXRlbHkgYW5kIGhlIHRob3VnaHQgaXQgd2FzIG9rIHRvIGxl
YXZlIHRoZQ0KbmFtZXMgaW4gdGhpcyBib3JkZXJsaW5lIGNhc2UuIElNTywgY2hhbmdpbmcgdGhp
cyBpbnRlcmZhY2UgZG9lc24ndA0KY2hhbmdlIGFueXRoaW5nIGltcG9ydGFudCBvZiB3aGF0IHRo
ZSBwYXRjaCBpcyBkb2luZy4NCg0KTmV2ZXJ0aGVsZXNzLCBJJ2xsIGRyb3AgdGhlIG5hbWVzIGFu
ZCBhc2sgdGhlbSB0byByZWNvbmZpcm0uDQoNCj4+IC0tLQ0KPj4gICAuLi4vdGVzdGluZy9zZWxm
dGVzdHMva3ZtL2RpcnR5X2xvZ19wZXJmX3Rlc3QuYyB8IDEyICsrKysrKysrKystLQ0KPj4gICAu
Li4vc2VsZnRlc3RzL2t2bS9pbmNsdWRlL3BlcmZfdGVzdF91dGlsLmggICAgICB8ICAyICsrDQo+
PiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9pbmNsdWRlL3Rlc3RfdXRpbC5oIHwgIDcg
KysrKysrKw0KPj4gICAuLi4vdGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYi9wZXJmX3Rlc3RfdXRp
bC5jICB8ICA3ICsrKysrKysNCj4+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYi90
ZXN0X3V0aWwuYyAgICAgfCAxNyArKysrKysrKysrKysrKysrKw0KPj4gICA1IGZpbGVzIGNoYW5n
ZWQsIDQzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCj4gSSB0aGluayBpdCBtYWtl
cyBzZW5zZSB0byBpbnRyb2R1Y2UgInN0cnVjdCBndWVzdF9yYW5kb21fc3RhdGUiICANCj4gc2Vw
YXJhdGVseSBmcm9tDQo+IHRoZSB1c2FnZSBpbiBwZXJmX3Rlc3RfdXRpbCBhbmQgZGlydHlfbG9n
X3BlcmZfdGVzdC4gIEUuZy4gc28gdGhhdCBpZiB3ZSAgDQo+IG5lZWQgdG8NCj4gcmV2ZXJ0IHRo
ZSBwZXJmX3Rlc3RfdXRpbCBjaGFuZ2VzIChleHRyZW1lbHkgdW5saWtlbHkpLCB3ZSBjYW4gZG8g
c28gIA0KPiB3aXRob3V0IGhhdmluZw0KPiB0byB3aXBlIG91dCB0aGUgcFJORyBhdCB0aGUgc2Ft
ZSB0aW1lLiAgT3Igc28gdGhhdCBzb21lb25lIGNhbiBwdWxsIGluICANCj4gdGhlIHBSTkcgdG8N
Cj4gdGhlaXIgc2VyaWVzIHdpdGhvdXQgaGF2aW5nIHRvIHRha2UgYSBkZXBlbmRlbmN5IG9uIHRo
ZSBvdGhlciBjaGFuZ2VzLg0KDQoNCldpbGwgZG8uIFdhcyBhdHRlbXB0aW5nIHRvIGF2b2lkIGFk
ZGluZyB1bnVzZWQgY29kZSBpbiBpdHMgb3duIGNvbW1pdA0KYWNjb3JkaW5nIHRvDQpodHRwczov
L3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9wcm9jZXNzLzUuUG9zdGluZy5odG1sDQoN
CiJXaGVuZXZlciBwb3NzaWJsZSwgYSBwYXRjaCB3aGljaCBhZGRzIG5ldyBjb2RlIHNob3VsZCBt
YWtlIHRoYXQgY29kZQ0KYWN0aXZlIGltbWVkaWF0ZWx5LiINCg0KPj4gZGlmZiAtLWdpdCBhL3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9pbmNsdWRlL3Rlc3RfdXRpbC5oICANCj4+IGIvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2luY2x1ZGUvdGVzdF91dGlsLmgNCj4+IGluZGV4IGJl
ZmM3NTRjZTliMy4uOWU0ZjM2YTFhOGIwIDEwMDY0NA0KPj4gLS0tIGEvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMva3ZtL2luY2x1ZGUvdGVzdF91dGlsLmgNCj4+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2t2bS9pbmNsdWRlL3Rlc3RfdXRpbC5oDQo+PiBAQCAtMTUyLDQgKzE1MiwxMSBA
QCBzdGF0aWMgaW5saW5lIHZvaWQgKmFsaWduX3B0cl91cCh2b2lkICp4LCBzaXplX3QgIA0KPj4g
c2l6ZSkNCj4+ICAgCXJldHVybiAodm9pZCAqKWFsaWduX3VwKCh1bnNpZ25lZCBsb25nKXgsIHNp
emUpOw0KPj4gICB9DQoNCj4+ICtzdHJ1Y3QgZ3Vlc3RfcmFuZG9tX3N0YXRlIHsNCj4+ICsJdWlu
dDMyX3Qgc2VlZDsNCj4+ICt9Ow0KPj4gKw0KPj4gK3N0cnVjdCBndWVzdF9yYW5kb21fc3RhdGUg
bmV3X2d1ZXN0X3JhbmRvbV9zdGF0ZSh1aW50MzJfdCBzZWVkKTsNCj4+ICt1aW50MzJfdCBndWVz
dF9yYW5kb21fdTMyKHN0cnVjdCBndWVzdF9yYW5kb21fc3RhdGUgKnN0YXRlKTsNCj4+ICsNCj4+
ICAgI2VuZGlmIC8qIFNFTEZURVNUX0tWTV9URVNUX1VUSUxfSCAqLw0KPj4gZGlmZiAtLWdpdCBh
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYyAgDQo+PiBi
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYw0KPj4gaW5k
ZXggOTYxOGIzN2M2NmY3Li41ZjBlZWJiNjI2YjUgMTAwNjQ0DQo+PiAtLS0gYS90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9rdm0vbGliL3BlcmZfdGVzdF91dGlsLmMNCj4+ICsrKyBiL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYw0KPj4gQEAgLTQ5LDYgKzQ5
LDcgQEAgdm9pZCBwZXJmX3Rlc3RfZ3Vlc3RfY29kZSh1aW50MzJfdCB2Y3B1X2lkeCkNCj4+ICAg
CXVpbnQ2NF90IGd2YTsNCj4+ICAgCXVpbnQ2NF90IHBhZ2VzOw0KPj4gICAJaW50IGk7DQo+PiAr
CXN0cnVjdCBndWVzdF9yYW5kb21fc3RhdGUgcmFuZF9zdGF0ZSA9ICANCj4+IG5ld19ndWVzdF9y
YW5kb21fc3RhdGUocHRhLT5yYW5kb21fc2VlZCArIHZjcHVfaWR4KTsNCg0KPiBsaWIvcGVyZl90
ZXN0X3V0aWwuYzogSW4gZnVuY3Rpb24g4oCYcGVyZl90ZXN0X2d1ZXN0X2NvZGXigJk6DQo+IGxp
Yi9wZXJmX3Rlc3RfdXRpbC5jOjUyOjM1OiBlcnJvcjogdW51c2VkIHZhcmlhYmxlIOKAmHJhbmRf
c3RhdGXigJkgIA0KPiBbLVdlcnJvcj11bnVzZWQtdmFyaWFibGVdDQo+ICAgICA1MiB8ICAgICAg
ICAgc3RydWN0IGd1ZXN0X3JhbmRvbV9zdGF0ZSByYW5kX3N0YXRlID0gIA0KPiBuZXdfZ3Vlc3Rf
cmFuZG9tX3N0YXRlKHB0YS0+cmFuZG9tX3NlZWQgKyB2Y3B1X2lkeCk7DQo+ICAgICAgICB8ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+DQoNCj4gVGhpcyBiZWxv
bmdzIGluIHRoZSBuZXh0IHBhdGguICBJJ2QgYWxzbyBwcmVmZXIgdG8gc3BsaXQgdGhlIGRlY2xh
cmF0aW9uICANCj4gZnJvbSB0aGUNCj4gaW5pdGlhbGl6YXRpb24gYXMgdGhpcyBpcyBhbiB1bm5l
Y2Vzc2FyaWx5IGxvbmcgbGluZSwgZS5nLg0KDQpVbmRlcnN0b29kIHRoYXQgdGhpcyBpcyBpbXBs
aWVkIGJ5IHRoZSBwcmV2aW91cyBjb21tZW50LiBBcyBmb3IgdGhlIGxpbmUNCmxlbmd0aCwgY2hl
Y2twYXRjaCBkb2Vzbid0IGNvbXBsYWluLg0K
