Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D74430AFE
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 19:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344303AbhJQRF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 13:05:26 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33388 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJQRFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Oct 2021 13:05:25 -0400
Message-ID: <20211017151447.829495362@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634490192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aZ3sxqmD6RAQ9ctUnJs4ASYjd0+zZLz5efI/2VlHMX4=;
        b=N2M5sFkB/bp1P5+BoivbWpr/0yTg/aossEy1KRjBoLEpBfhaAjqrmJiVf1GdhqSCu8vMh4
        6CWRjbXIlLW05Sf5xbpd1d1+BcIxEz2ILASptSJxbL6I0H2wJzNnaDXyBRRypNnaJj/uSx
        uJsrYt2u9q4J5bciSYfN62mRXCF86HgYUaJY3GBEj5cc4gVKOLVvN5A/op3ZztkoiAORTW
        oBes1EUw+NfIyqtl5ORvbpzbaP+XCQduPPHwXN2qCdHnnUpwRX2eBBGHpfgOGrQDYR8ZnR
        rZbwvQbeieJL6P9llrR/7bq5g6/eGXJbEHdP24cEoNw+Zg3Yx3Phkk9RYAp7vw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634490192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aZ3sxqmD6RAQ9ctUnJs4ASYjd0+zZLz5efI/2VlHMX4=;
        b=WHnlM8vgwmIJc+EdU7fl+eoNw3DR6UJ7IzZTBrnP1dGBJtfXv2Vkahnga0RTaxtjhq5q1u
        c7VSklZYYowMtXCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch 0/4] x86/fpu/kvm: Sanitize the FPU guest/user handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Sun, 17 Oct 2021 19:03:11 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Q3VycmVudGx5IEtWTSBhbGxvY2F0ZXMgdHdvIEZQVSBzdHJ1Y3RzIHdoaWNoIGFyZSB1c2VkIGZv
ciBzYXZpbmcgdGhlIHVzZXIKc3RhdGUgb2YgdGhlIHZDUFUgdGhyZWFkIGFuZCByZXN0b3Jpbmcg
dGhlIGd1ZXN0IHN0YXRlIHdoZW4gZW50ZXJpbmcKdmNwdV9ydW4oKSBhbmQgZG9pbmcgdGhlIHJl
dmVyc2Ugb3BlcmF0aW9uIGJlZm9yZSBsZWF2aW5nIHZjcHVfcnVuKCkuCgpXaXRoIHRoZSBuZXcg
ZnBzdGF0ZSBtZWNoYW5pc20gdGhpcyBjYW4gYmUgcmVkdWNlZCB0byBvbmUgZXh0cmEgYnVmZmVy
IGJ5CnN3YXBwaW5nIHRoZSBmcHN0YXRlIHBvaW50ZXIgaW4gY3VycmVudDo6dGhyZWFkOjpmcHUu
IFRoaXMgbWFrZXMgYWxzbyB0aGUKdXBjb21pbmcgc3VwcG9ydCBmb3IgQU1YIGFuZCBYRkQgc2lt
cGxlciBiZWNhdXNlIHRoZW4gZnBzdGF0ZSBpbmZvcm1hdGlvbgooZmVhdHVyZXMsIHNpemVzLCB4
ZmQpIGFyZSBhbHdheXMgY29uc2lzdGVudCBhbmQgaXQgZG9lcyBub3QgcmVxdWlyZSBhbnkKbmFz
dHkgd29ya2Fyb3VuZHMuCgpUaGUgZm9sbG93aW5nIHNlcmllcyBjbGVhbnMgdGhhdCB1cCBhbmQg
cmVwbGFjZXMgdGhlIGN1cnJlbnQgc2NoZW1lIHdpdGggYQpzaW5nbGUgZ3Vlc3Qgc3RhdGUgd2hp
Y2ggaXMgc3dpdGNoZWQgaW4gd2hlbiBlbnRlcmluZyB2Y3B1X3J1bigpIGFuZApzd2l0Y2hlZCBv
dXQgYmVmb3JlIGxlYXZpbmcgaXQuCgpUaGUgcmV3b3JrIGlzIHZhbHVhYmxlIGV2ZW4gd2l0aG91
dCBBTVgvWEZEIGJlY2F1c2UgaXQgY29uc3VtZXMgbGVzcyBtZW1vcnkKYW5kIHdoZW4gc3dhcHBp
bmcgdGhlIGZwc3RhdGVzIHRoZXJlIGlzIG5vIG1lbW9yeSBjb3B5IHJlcXVpcmVkIHdoZW4KVElG
X05FRURfTE9BRF9GUFUgaXMgc2V0IG9uIHRoZSBnb2luZyBvdXQgZnBzdGF0ZS4KClRoZSBzZXJp
ZXMgaXMgYmFzZWQgb246CgogIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC90Z2x4L2RldmVsLmdpdCB4ODYvZnB1LTMKCmFuZCBpcyBub3cgcGFydCBvZiB0aGUg
ZnVsbCBBTVggc2VyaWVzOgoKICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvdGdseC9kZXZlbC5naXQgeDg2L2ZwdQoKT24gdG9wIG9mIHRoYXQgSSd2ZSBpbnRl
Z3JhdGVkIHRoZSBLVk0gcmVhbGxvY2F0aW9uIG1lY2hhbmlzbSBpbnRvOgoKICBnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGdseC9kZXZlbC5naXQgeDg2L2Zw
dS1rdm0KClRoZSBsYXR0ZXIgYnVpbGRzLCBib290cyBhbmQgcnVucyBLVk0gZ3Vlc3RzLCBidXQg
dGhhdCByZWFsbG9jYXRpb24KZnVuY3Rpb25hbGl0eSBpcyBvYnZpb3VzbHkgY29tcGxldGVseSB1
bnRlc3RlZC4gSSB3YW50IHRvIHNoYXJlIHRoaXMgd2l0aApLVk0gZm9sa3Mgc28gdGhleSBjYW4g
c3RhcnQgdG8gbG9vayBob3cgdG8gaW50ZWdyYXRlIHRoZWlyIFhGRC9YQ1IwIGFuZApyZWFsbG9j
YXRpb24gc2NoZW1lIGFzIGRpc2N1c3NlZCBhbmQgb3V0bGluZWQgaGVyZToKCiAgIGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL3IvODdtdG45M3U1OC5mZnNAdGdseAoKYW5kIHRoZSByZWxhdGVkIHRo
cmVhZC4gSXQncyBhIHRpbnkgaW5jcmVtZW50YWwgdXBkYXRlIG9uIHRvcCBvZiB4ODYvZnB1ICg2
CmZpbGVzIGNoYW5nZWQsIDE4MyBpbnNlcnRpb25zKCspLCAzNiBkZWxldGlvbnMoLSkpIHdoaWNo
IHJldXNlcyB0aGUgaG9zdApzaWRlIG1lY2hhbmlzbXMuCgpUaGFua3MsCgoJdGdseAotLS0KIGlu
Y2x1ZGUvYXNtL2ZwdS9hcGkuaCAgIHwgICAxOSArKysrKystLQogaW5jbHVkZS9hc20vZnB1L3R5
cGVzLmggfCAgIDQ0ICsrKysrKysrKysrKysrKysrKy0KIGluY2x1ZGUvYXNtL2t2bV9ob3N0Lmgg
IHwgICAgNyAtLS0KIGtlcm5lbC9mcHUvY29yZS5jICAgICAgIHwgIDExMCArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0KIGt2bS9zdm0vc3ZtLmMgICAgICAg
ICAgIHwgICAgNyArLS0KIGt2bS94ODYuYyAgICAgICAgICAgICAgIHwgICA4OCArKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogNiBmaWxlcyBjaGFuZ2VkLCAxNjUgaW5zZXJ0
aW9ucygrKSwgMTEwIGRlbGV0aW9ucygtKQoKCg==
