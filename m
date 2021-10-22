Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D60437CCB
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 20:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhJVS6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 14:58:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41070 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbhJVS6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 14:58:07 -0400
Message-ID: <20211022184540.581350173@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634928949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+gsBHgsTWzb3JlnUd8sVROYI0KvekQ22YBoQ0OW+bVQ=;
        b=EcHlTptJK1R7Y6WaAxM4lYpY/K5vnaH3Hnio7mvjEJR4/QYRNcHKjiVWM12YlIk0OA3kOu
        rhAV9eOIQSsa6o2KwU0QeLbKHW0IoGr1PCc8zSFxID/Jn1YQitOaBVUmTC2BzP7w8OZa8C
        aek04wnXEWqHg1H0oew3l6SkT4BezHNn79UO03qr8pyOO1zm6yC7UhXNnxvIz7BJ5DdL8z
        fdX1z0vKKjroPqfji1eVe6+mCtpTwApEoj0oPimLI6xCnInjW6IXy7UwFstDFy6TtNscNd
        Boa9wpLQ947fDtGFH9VlVqGXSyBokJHkIZolq+Utb7y1p1A/Zp3kPfKLJlHKng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634928949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+gsBHgsTWzb3JlnUd8sVROYI0KvekQ22YBoQ0OW+bVQ=;
        b=MUXjwNlSkahG6QtWZiNrMsZjNS6H9oRRPZ2bg2GF8gKCF28lkG/c1LBV7cN5OwiINtdn/3
        /cmZFLdxUH7N3VAQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch V2 0/4] x86/fpu/kvm: Sanitize the FPU guest/user handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Fri, 22 Oct 2021 20:55:48 +0200 (CEST)
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
bmVsL2dpdC90Z2x4L2RldmVsLmdpdCB4ODYvZnB1LTMKCmFuZCBhdmFpbGFibGUgZnJvbSBnaXQ6
CgogIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90Z2x4L2Rl
dmVsLmdpdCB4ODYvZnB1LTMta3ZtCgpWMSBjYW4gYmUgZm91bmQgaGVyZToKCiAgaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvci8yMDIxMTAxNzE1MTQ0Ny44Mjk0OTUzNjJAbGludXRyb25peC5kZQoK
Q2hhbmdlcyB2cy4gVjE6CgogIERyb3AgdGhlIHJlc3RvcmVfbWFzayBhcmd1bWVudCBhcyB0aGUg
cmVzdWx0IGlzIGNvbnN0YW50IGFueXdheSAtIFBhb2xvCgpUaGFua3MsCgoJdGdseAotLS0KIGlu
Y2x1ZGUvYXNtL2ZwdS9hcGkuaCAgIHwgICAxOSArKysrKystLQogaW5jbHVkZS9hc20vZnB1L3R5
cGVzLmggfCAgIDQ0ICsrKysrKysrKysrKysrKysrKy0KIGluY2x1ZGUvYXNtL2t2bV9ob3N0Lmgg
IHwgICAgNyAtLS0KIGtlcm5lbC9mcHUvY29yZS5jICAgICAgIHwgIDExMSArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0KIGt2bS9zdm0vc3ZtLmMgICAgICAg
ICAgIHwgICAgNyArLS0KIGt2bS94ODYuYyAgICAgICAgICAgICAgIHwgICA4OCArKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogNiBmaWxlcyBjaGFuZ2VkLCAxNjQgaW5zZXJ0
aW9ucygrKSwgMTEyIGRlbGV0aW9ucygtKQo=
