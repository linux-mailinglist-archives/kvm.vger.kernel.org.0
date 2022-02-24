Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F634C34F6
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 19:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiBXSqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 13:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiBXSqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 13:46:14 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4A625293D
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 10:45:43 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id j7so5454506lfu.6
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 10:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Sc7gWJVNIP6uwWHZSQQACovvVoJZicyDfdIk+MU1FYs=;
        b=m3Tk/kRpYoELm1Zuw97xzvxRcX+nQR1d7aZTPZt21nPFb6+5eJPCqkGoeITZuQoo4Y
         jP6E/ITEVSlbGGFoGQbgCFC4IBJpA2/+FIpTlTeffZ+/9EEKU4YUWumnwcKl8axxBhX4
         yupvQt9pu/8WIrYvjFUVuQEoAMSDy+S+eZ6SzjSfNOH2yhudrTmkQYd9mn8NqBL0Sl5b
         fguhP2R30ZMkM0pXNKryqXMk1xVuzTr2XtPsD6TL4UNPUom0R3VEAmhn7ZamNO9xPyeD
         1W1NAdYiJA7aOnBmOsUhV+kZYvrJ8YQJXT2UONJ8SZEKTVwOdyfWkIkCDGLNVSQ+Yhbm
         Ip1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Sc7gWJVNIP6uwWHZSQQACovvVoJZicyDfdIk+MU1FYs=;
        b=kbJ6HgNFP4XHx+CIi4532qAGoNzCCzP541rzkpx1kcqoRJpYd40LMbFiH/6fNX3s18
         qO8gLlSFonXMCSaLjwwFnKtarUM46Iyyt/veO6vjS+nivZInruf0F2SBvx/b36MuUk2X
         o8+/GcMS+RfTwYG5fVGMfi1hH7p2iZoPI6Hwi/d7iV+iRBiU+WhVvtW/p8JmSpm7zTFD
         KluPvepBBm8qwOwie+1OmCCp6mlD7KiG1FbY2lAYTt/DGMZTJbWgdAfyq9Ic4B34y+5H
         9ge/ZoJKGWh5pW+zMuOc1ATAh+qlOEAUvtecYBl2ahwsAIT5zJRwzDuiX+3BJ2ScdUKW
         KSIQ==
X-Gm-Message-State: AOAM530l6IyrXjdPis9qJaVlELXi9dQ34aaiEtXwCyulBvVLmTWpaGkI
        1G5beKOJu4DkkA0ybpu+7MQhn8pJ6M4D9Ej2VDjHxg==
X-Google-Smtp-Source: ABdhPJwTeq4uZiK3U1FTNZVPp10ZeXLly1Wi+Td8oFiOvPS5bSqbS+jCx8gcs7dgqTUj+fPl7hIOwBS5E+RUg2iCfIo=
X-Received: by 2002:a05:6512:3341:b0:433:b033:bd22 with SMTP id
 y1-20020a056512334100b00433b033bd22mr2603417lfd.190.1645728341624; Thu, 24
 Feb 2022 10:45:41 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-3-dmatlack@google.com>
 <YhBEaPWDoBiTpNV3@google.com>
In-Reply-To: <YhBEaPWDoBiTpNV3@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 24 Feb 2022 10:45:14 -0800
Message-ID: <CALzav=dt+qSAyO3D5uXdEBObZ37iBAaDsDGQUpWFdjfn3B0ojw@mail.gmail.com>
Subject: Re: [PATCH 02/23] KVM: x86/mmu: Derive shadow MMU page role from parent
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCBGZWIgMTgsIDIwMjIgYXQgNToxNCBQTSBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+DQo+IE9uIFRodSwgRmViIDAzLCAyMDIyLCBEYXZpZCBN
YXRsYWNrIHdyb3RlOg0KPiA+IEluc3RlYWQgb2YgY29tcHV0aW5nIHRoZSBzaGFkb3cgcGFnZSBy
b2xlIGZyb20gc2NyYXRjaCBmb3IgZXZlcnkgbmV3DQo+ID4gcGFnZSwgd2UgY2FuIGRlcml2ZSBt
b3N0IG9mIHRoZSBpbmZvcm1hdGlvbiBmcm9tIHRoZSBwYXJlbnQgc2hhZG93IHBhZ2UuDQo+ID4g
VGhpcyBhdm9pZHMgcmVkdW5kYW50IGNhbGN1bGF0aW9ucyBzdWNoIGFzIHRoZSBxdWFkcmFudCwg
YW5kIHJlZHVjZXMgdGhlDQo+DQo+IFVoLCBjYWxjdWxhdGluZyBxdWFkcmFudCBpc24ndCByZWR1
bmRhbnQuICBUaGUgcXVhZHJhbnQgZm9yY2VzIEtWTSB0byB1c2UgZGlmZmVyZW50DQo+IChtdWx0
aXBsZSkgc2hhZG93IHBhZ2VzIHRvIHNoYWRvdyBhIHNpbmdsZSBndWVzdCBQVEUgd2hlbiB0aGUg
Z3Vlc3QgaXMgdXNpbmcgMzItYml0DQo+IHBhZ2luZyAoMTAyNCBQVEVzIHBlciBwYWdlIHRhYmxl
IHZzLiA1MTIgUFRFcyBwZXIgcGFnZSB0YWJsZSkuICBUaGUgcmVhc29uIHF1YWRyYW50DQo+IGlz
ICJxdWFkIiBhbmQgbm90IG1vcmUgb3IgbGVzcyBpcyBiZWNhdXNlIDMyLWJpdCBwYWdpbmcgaGFz
IHR3byBsZXZlbHMuICBGaXJzdC1sZXZlbA0KPiBQVEVzIGNhbiBoYXZlIHF1YWRyYW50PTAvMSwg
YW5kIHRoYXQgZ2V0cyBkb3VibGVkIGZvciBzZWNvbmQtbGV2ZWwgUFRFcyBiZWNhdXNlIHdlDQo+
IG5lZWQgdG8gdXNlIGZvdXIgUFRFcyAodHdvIHRvIGhhbmRsZSAyeCBndWVzdCBQVEVzLCBhbmQg
ZWFjaCBvZiB0aG9zZSBuZWVkcyB0byBiZQ0KPiB1bmlxdWUgZm9yIHRoZSBmaXJzdC1sZXZlbCBQ
VEVzIHRoZXkgcG9pbnQgYXQpLg0KPg0KPiBJbmRlZWQsIHRoaXMgZmFpbHMgc3BlY3RhY3VsYXJs
eSB3aGVuIGF0dGVtcHRpbmcgdG8gYm9vdCBhIDMyLWJpdCBub24tUEFFIGtlcm5lbA0KPiB3aXRo
IHNoYWRvdyBwYWdpbmcgZW5hYmxlZC4NCg0KKmZhY2VwYWxtKg0KDQpUaGFua3MgZm9yIGNhdGNo
aW5nIHRoaXMuIEknbGwgZml4IHRoaXMgdXAgaW4gdjIgYW5kIGFkZCAzMi1iaXQNCm5vbi1QQUUg
Z3Vlc3RzIHdpdGggc2hhZG93IHBhZ2luZyB0byBteSB0ZXN0IG1hdHJpeC4NCg0KPg0KPiAgXO+/
ve+/ve+/vSAgIO+/ve+/ve+/vVzvv73vv73vv70g77+977+9XO+/ve+/ve+/vQ0KPiAgICAgICAg
IFDvv73vv71c77+977+9YA0KPiAgQlVHOiB1bmFibGUgdG8gaGFuZGxlIHBhZ2UgZmF1bHQgZm9y
IGFkZHJlc3M6IGZmOWZhODFjDQo+ICAjUEY6IHN1cGVydmlzb3IgcmVhZCBhY2Nlc3MgaW4ga2Vy
bmVsIG1vZGUNCj4gICNQRjogZXJyb3JfY29kZSgweDAwMDApIC0gbm90LXByZXNlbnQgcGFnZQ0K
PiAgKnBkZSA9IDAwMDAwMDAwDQo+ICDvv73vv73vv73vv70NCj4gIE9vcHM6IDAwMDAgWyMxXe+/
ve+/vTzvv73vv73vv73vv70gU01Q77+977+9PO+/ve+/ve+/ve+/ve+/ve+/vTzvv73vv73vv73v
v73vv73vv70877+977+977+977+9DQo+ICDvv73vv70877+977+977+977+9Q1BVOiAwIFBJRDog
MCBDb21tOiBzd2FwcGVyIO+/ve+/vTzvv73vv73vv73vv71HICAgICAgICBXICAgICAgICAgNS4x
Mi4wICMxMA0KPiAg77+977+9PO+/ve+/ve+/ve+/vUVJUDogbWVtYmxvY2tfYWRkX3JhbmdlLmlz
cmEuMTguY29uc3Rwcm9wLjIzZO+/vXINCj4gIO+/ve+/vTzvv73vv73vv73vv71Db2RlOiA8ODM+
IDc5IDA0IDAwIDc1IDJjIDgzIDM4IDAxIDc1IDA2IDgzIDc4IDA4IDAwIDc0IDAyIDBmIDBiIDg5
IDExIDhiDQo+ICDvv73vv70877+977+977+977+9RUFYOiBjMmFmMjRiYyBFQlg6IGZkZmZmZmZm
IEVDWDogZmY5ZmE4MTggRURYOiAwMjAwMDAwMA0KPiAg77+977+9PO+/ve+/ve+/ve+/vUVTSTog
MDIwMDAwMDAgRURJOiAwMDAwMDAwMCBFQlA6IGMyOTA5ZjMwIEVTUDogYzI5MDlmMGMNCj4gIO+/
ve+/vTzvv73vv73vv73vv71EUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzog
MDA2OCBFRkxBR1M6IDAwMjEwMDA2DQo+ICDvv73vv70877+977+977+977+9Q1IwOiA4MDA1MDAz
MyBDUjI6IGZmOWZhODFjIENSMzogMDJiNzYwMDAgQ1I0OiAwMDA0MDYwMA0KPiAg77+977+9PO+/
ve+/ve+/ve+/vUNhbGwgVHJhY2U6DQo+ICDvv73vv70877+977+977+977+9ID8gcHJpbnRrZO+/
vXINCj4gIO+/ve+/vTzvv73vv73vv73vv70g77+977+9PO+/ve+/ve+/ve+/vW1lbWJsb2NrX3Jl
c2VydmVk77+9cg0KPiAg77+977+9PO+/ve+/ve+/ve+/vSA/IDB4YzIwMDAwMDANCj4gIO+/ve+/
vTzvv73vv73vv73vv70g77+977+9PO+/ve+/ve+/ve+/vXNldHVwX2FyY2hk77+9cg0KPiAg77+9
77+9PO+/ve+/ve+/ve+/vSA/IHZwcmludGtfZGVmYXVsdGTvv71yDQo+ICDvv73vv70877+977+9
77+977+9ID8gdnByaW50a2Tvv71yDQo+ICDvv73vv70877+977+977+977+9IO+/ve+/vTzvv73v
v73vv73vv71zdGFydF9rZXJuZWxk77+9cg0KPiAg77+977+9PO+/ve+/ve+/ve+/vSDvv73vv708
77+977+977+977+9aTM4Nl9zdGFydF9rZXJuZWxk77+9cg0KPiAg77+977+9PO+/ve+/ve+/ve+/
vSDvv73vv70877+977+977+977+9c3RhcnR1cF8zMl9zbXBk77+9cg0KPg0KPiAg77+977+977+9
77+9DQo+ICBDUjI6IDAwMDAwMDAwZmY5ZmE4MWMNCj4NCj4gIO+/ve+/vTzvv73vv73vv73vv71F
SVA6IG1lbWJsb2NrX2FkZF9yYW5nZS5pc3JhLjE4LmNvbnN0cHJvcC4yM2Tvv71yDQo+ICDvv73v
v70877+977+977+977+9Q29kZTogPDgzPiA3OSAwNCAwMCA3NSAyYyA4MyAzOCAwMSA3NSAwNiA4
MyA3OCAwOCAwMCA3NCAwMiAwZiAwYiA4OSAxMSA4Yg0KPiAg77+977+9PO+/ve+/ve+/ve+/vUVB
WDogYzJhZjI0YmMgRUJYOiBmZGZmZmZmZiBFQ1g6IGZmOWZhODE4IEVEWDogMDIwMDAwMDANCj4g
IO+/ve+/vTzvv73vv73vv73vv71FU0k6IDAyMDAwMDAwIEVESTogMDAwMDAwMDAgRUJQOiBjMjkw
OWYzMCBFU1A6IGMyOTA5ZjBjDQo+ICDvv73vv70877+977+977+977+9RFM6IDAwN2IgRVM6IDAw
N2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjggRUZMQUdTOiAwMDIxMDAwNg0KPiAg77+977+9
PO+/ve+/ve+/ve+/vUNSMDogODAwNTAwMzMgQ1IyOiBmZjlmYTgxYyBDUjM6IDAyYjc2MDAwIENS
NDogMDAwNDA2MDANCj4NCj4gPiBudW1iZXIgb2YgcGFyYW1ldGVycyB0byBrdm1fbW11X2dldF9w
YWdlKCkuDQo+ID4NCj4gPiBQcmVlbXB0aXZlbCBzcGxpdCBvdXQgdGhlIHJvbGUgY2FsY3VsYXRp
b24gdG8gYSBzZXBhcmF0ZSBmdW5jdGlvbiBmb3INCj4NCj4gUHJlZW1wdGl2ZWx5Lg0KPg0KPiA+
IHVzZSBpbiBhIGZvbGxvd2luZyBjb21taXQuDQo+ID4NCj4gPiBObyBmdW5jdGlvbmFsIGNoYW5n
ZSBpbnRlbmRlZC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IERhdmlkIE1hdGxhY2sgPGRtYXRs
YWNrQGdvb2dsZS5jb20+DQo+ID4gLS0tDQo=
