Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66626C8252
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 17:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjCXQ0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 12:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCXQ0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 12:26:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7326AD06
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 09:26:15 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5458201ab8cso23584857b3.23
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679675175;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3BygzBeO2MTCLfMeql6ZjcafPn3bd3SnaE4v4H4MQkU=;
        b=Lmo53DKjjOHiluloY8fvpQdvA5OXoNOR0xeqTOr+QmLaKQNdBn5Hiff1RvKYH7RVDt
         CYFzXyX+jLumqIAvsw5kjSi4wO+aZmwd71uMjEKuePmthyRRbjaoGv2sZA05vh4GMp5G
         5iZrnFLxWoXBSA4rzRD1VMJ2wrkSa8tYJWc6TsNFnr1w4XjBh/AWPH5OgHOtvUUuVEgk
         +QHO1x0tbeJFkpo8F+jNVB+VgZeD66wc20UGF6aTBuDZvaYnm+5ZJb7kbOEvGvMRBiWJ
         nbXCvcuRzPU08fCEB4znXuU9oV42yhxBkiHdcmnFI3/xtAQTAw20kqQ7bKbgKpwQO2mt
         W8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679675175;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3BygzBeO2MTCLfMeql6ZjcafPn3bd3SnaE4v4H4MQkU=;
        b=BLQOnhkGKJ5z8fAO7fH9ro7H90XJJCzy1CiDJWHYHDa8YOQrRbOwo55GzGgjCUl7JD
         XVvQ5xYxlaZQRSRs4GDuTZ/2Kz+h06iVynD0FeH35fdWSEVQpo6dJNPOwIGWlrevZV0j
         J0YSzb4zk8AhQmLxkkKmlXWVaiKVStMB17RWD/77yd2sQknn3FbVwK/+dNeCYKcyyVjE
         NaPmUkzy+RW0Lt3R/gIcxNTE6oL8PQwS46pyZJlfkgNBqfxWX0+P0Z3+s7rT3AswZl2N
         pJkHDDLp+slKQKJgl1KqULMgroWn7jdAXlPq/EYSPQdiLN7FE+J7g96wbOqAtZIKofjK
         +Ejw==
X-Gm-Message-State: AAQBX9eqwA4o5vWWSu/dGN5VbTWZcBDbsUZVlHmDkbvW80or9UlEafTU
        HsJq4ZEj/81KFgvCi9vO9fBOI5yX2JHbX9IvYg==
X-Google-Smtp-Source: AKy350aO38ek2RhevytyHMaPjspKohOXqwUtl1uzZ0H641JLBLAr+w2yaR8Xxk3zcD95akZMnz+/TDMueMqFAEWqLw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:100a:b0:b76:3e1:c42d with
 SMTP id w10-20020a056902100a00b00b7603e1c42dmr1678796ybt.13.1679675174936;
 Fri, 24 Mar 2023 09:26:14 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:26:14 +0000
In-Reply-To: <ZBof1SkJuo3wv3HW@google.com> (message from Sean Christopherson
 on Tue, 21 Mar 2023 14:21:25 -0700)
Mime-Version: 1.0
Message-ID: <gsnt8rfmcdzt.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: Print summary stats of memory
 latency distribution
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     vipinsh@google.com, pbonzini@redhat.com, shuah@kernel.org,
        dmatlack@google.com, andrew.jones@linux.dev, maz@kernel.org,
        bgardon@google.com, ricarkol@google.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IHdyaXRlczoNCg0KPiBPbiBU
dWUsIE1hciAyMSwgMjAyMywgQ29sdG9uIExld2lzIHdyb3RlOg0KPj4gVmlwaW4gU2hhcm1hIDx2
aXBpbnNoQGdvb2dsZS5jb20+IHdyaXRlczoNCg0KPj4gPiBPbiBUaHUsIE1hciAxNiwgMjAyMyBh
dCAzOjI54oCvUE0gQ29sdG9uIExld2lzIDxjb2x0b25sZXdpc0Bnb29nbGUuY29tPg0KPj4gPiB3
cm90ZToNCj4+ID4gPiArICAgICAgIHByX2luZm8oIkxhdGVuY3kgZGlzdHJpYnV0aW9uIChucykg
PSBtaW46JTYuMGxmLA0KPj4gPiA+IDUwdGg6JTYuMGxmLCA5MHRoOiU2LjBsZiwgOTl0aDolNi4w
bGYsIG1heDolNi4wbGZcbiIsDQo+PiA+ID4gKyAgICAgICAgICAgICAgIGN5Y2xlc190b19ucyh2
Y3B1c1swXSwgIA0KPj4gKGRvdWJsZSlob3N0X2xhdGVuY3lfc2FtcGxlc1swXSksDQoNCj4+ID4g
SSBhbSBub3QgbXVjaCBhd2FyZSBvZiBob3cgdHNjIGlzIHNldCB1cCBhbmQgdXNlZC4gV2lsbCBh
bGwgdkNQVXMgaGF2ZQ0KPj4gPiB0aGUgc2FtZSB0c2MgdmFsdWU/IENhbiB0aGlzIGNoYW5nZSBp
ZiB2Q1BVIGdldHMgc2NoZWR1bGVkIHRvDQo+PiA+IGRpZmZlcmVudCBwQ1BVIG9uIHRoZSBob3N0
Pw0KDQo+IEZXSVcsIGlmIHRoaXMgdGVzdCB3ZXJlIHJ1biBvbiBvbGRlciBDUFVzLCB0aGVyZSB3
b3VsZCBiZSBwb3RlbnRpYWwgIA0KPiBkaXZlcmdlbmNlDQo+IGFjcm9zcyBwQ1BVcyB0aGF0IHdv
dWxkIHRoZW4gYmxlZWQgaW50byB2Q1BVcyB0byBzb21lIGV4dGVudC4gIE9sZGVyIENQVXMgIA0K
PiB0aWVkDQo+IHRoZSBUU0MgZnJlcXVlbmN5IHRvIHRoZSBjb3JlIGZyZXF1ZW5jeSwgZS5nLiB3
b3VsZCBjaGFuZ2UgZnJlcXVlbmN5ICANCj4gZGVwZW5kaW5nDQo+IG9uIHRoZSBwb3dlci90dXJi
byBzdGF0ZSwgYW5kIHRoZSBUU0Mgd291bGQgZXZlbiBzdG9wIGNvdW50aW5nIGFsdG9nZXRoZXIg
IA0KPiBhdA0KPiBjZXJ0YWluIEMtc3RhdGVzLiAgS1ZNIGRvZXMgaXRzIGJlc3QgdG8gYWRqdXN0
IHRoZSBndWVzdCdzIHBlcmNlcHRpb24gb2YgIA0KPiB0aGUgVFNDLA0KPiBidXQgaXQgY2FuJ3Qg
YmUgaGlkZGVuIGNvbXBsZXRlbHkuDQoNCj4gQnV0IGZvciB3aGF0IHRoaXMgdGVzdCBpcyB0cnlp
bmcgdG8gZG8sIElNTyB0aGVyZSdzIHplcm8gcmVhc29uIHRvIHdvcnJ5ICANCj4gYWJvdXQNCj4g
dGhhdC4NCg0KVGhhbmtzIGZvciB0aGUgY29uZmlybWF0aW9uLg0KDQo+PiBBbGwgdkNQVXMgKmlu
IG9uZSBWTSogc2hvdWxkIGhhdmUgdGhlIHNhbWUgZnJlcXVlbmN5LiBUaGUgYWx0ZXJuYXRpdmUg
aXMNCj4+IHByb2JhYmx5IHBvc3NpYmxlIGJ1dCBzbyB3ZWlyZCBJIGNhbid0IGltYWdpbmUgYSBy
ZWFzb24gZm9yIGRvaW5nIGl0Lg0KDQo+IFNvbWV3aGF0IHJlbGF0ZWQgdG8gVmlwaW4ncyBxdWVz
dGlvbiwgImhvc3RfbGF0ZW5jeV9zYW1wbGVzIiBpcyBhICANCj4gY29uZnVzaW5nIG5hbWUuDQo+
IEl0J3MgZWFzeSB0byBtaXNzIHRoYXQgImhvc3RfbGF0ZW5jeV9zYW1wbGVzIiBhcmUgYWN0dWFs
bHkgc2FtcGxlcyAgDQo+IGNvbGxlY3RlZCBpbg0KPiB0aGUgZ3Vlc3QsIGFuZCB0aHVzIHRvIHRo
aW5rIHRoYXQgdGhpcyBjb2RlIHdpbGwgZGVwZW5kIG9uIHdoaWNoIHBDUFUgaXQgIA0KPiBydW5z
IG9uLg0KDQo+IEkgZG9uJ3Qgc2VlIGFueSByZWFzb24gZm9yIHN1Y2ggYSB2ZXJib3NlIG5hbWUs
IGUuZy4gY2FuJ3QgaXQganVzdCAgDQo+IGJlICJzYW1wbGVzIj8NCg0KWWVzIGl0IGNhbi4NCg==
