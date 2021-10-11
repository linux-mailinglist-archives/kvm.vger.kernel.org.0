Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D70B429A49
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhJLAMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:12:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51580 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhJLAM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:12:26 -0400
Message-ID: <20211011215813.558681373@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633996798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cgnHMtEUbUyM+EMhZJ3l2NJVcGUEpwYRDLW5rNxhu3k=;
        b=ypMIKqk6O5/bLCi1N97KFt70CsC1IKbvaCnI8sUOf1sYoE7UpdzcS2ZkGql5PHGJq3dBvM
        7YJ40j/rKKE94oJ0nCVQqc02Ee8SrZERxY/RC0ZBPBA9HPIhqTacdP30WnSy6lQlriLaSt
        Pwjn4ExECEEQfjSD1JEC2vdpy9f9wpa20ao43U8p2+8IRWGtUWODfhcZAd6hQgA8HOTpXv
        Q79hjc1PPByJj/U/xJhmBkXrMowAnyLiFR9D2igNs2oAXrBOOfNQHlKRsejjXS+8X32SMG
        /gGB0ebm9nLoknQxyclUQGuuaBEt//jEfAGCdx94TuK+n+4jn8x+UvvusdcU3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633996798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cgnHMtEUbUyM+EMhZJ3l2NJVcGUEpwYRDLW5rNxhu3k=;
        b=mF6YWl5TYZdZgl4sW8n3y1NXyXlZT99+hdYe1PwRJBcWa2lLpc7g7MRl3hdr6A8GMm9BST
        NS2sFzyIkLhVT5CA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 00/31] x86/fpu: Preparatory cleanups for AMX support (part 1)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Tue, 12 Oct 2021 01:59:57 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIHJlY2VudCBhdHRlbXB0cyB0byBzdXBwb3J0IHRoZSBuZXcgQU1YIGZlYXR1cmUganVzdCB0
cmllZCB0byBib2x0IGl0CmludG8gdGhlIGV4aXNpdGluZyBGUFUgY29kZToKCiAgICAgaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIxMTAwMTIyMzcyOC45MzA5LTEtY2hhbmcuc2Vvay5iYWVA
aW50ZWwuY29tCgpBcyBkZW1vbnN0cmF0ZWQgd2l0aCB0aGUgc3VwZXJ2aXNvciBiaXRzLCB0aGF0
J3Mgbm90IHJlYWxseSBzZW5zaWJsZSBhbmQKbGVhZHMgdG8gc2ltaWxhciBpc3N1ZXMuCgpJJ3Zl
IHdvcmtlZCB3aXRoIENoYW5nIGFuZCBEYXZlIGluIHRoZSBwYXN0IGZldyBkYXlzIG9uIHNvcnRp
bmcgdGhpcwpvdXQuIE1hbnkgdGhhbmtzIGZvciB0aGVpciBlZmZvcnQgYW5kIHN1cHBvcnQhCgpU
aGlzIHNlcmllcyBpcyBhIHJlbmV3ZWQgZWZmb3J0IHRvIG1ha2UgdGhpcyBtb3JlIHBhbGF0YWJs
ZS4gSXQncyB0aGUgZmlyc3QKcGFydCBvZiBhIDQgcGFydCBzdWJtaXNzaW9uIHdoaWNoIHdvcmsg
dG93YXJkcyBhIGNsZWFuIEFNWCBpbnRlZ3JhdGlvbiBpbnRvCnRoZSBGUFUgY29kZToKCiAgMSkg
Q2xlYW5zIHVwIGV4aXN0aW5nIG1lc3MuIEhpc3RvcmljYWwgbGVmdG92ZXJzLCBzaG9ydGNvbWlu
Z3MgYW5kCiAgICAgZXNwZWNpYWxseSB0aGUgdW5pdmVyc2FsIGtpdGNoZW4gc2luayBhc20vZnB1
L2ludGVybmFsLmggd2hpY2ggaXMKICAgICBpbmNsdWRlZCBhbGwgb3ZlciB0aGUgcGxhY2UgZm9y
IHRoZSB3cm9uZyByZWFzb25zLgoKICAgICBUaGlzIHNlcmllcyBoYXMgYSB2YWx1ZSBpbmRlcGVu
ZGVudCBvZiBBTVgsIGJ1dCBhbGxvd3MgdG8gbWFrZSB0aGUKICAgICBpbnRlZ3JhdGlvbiBhbmQg
Y29udmVyc2lvbiB0byB0aGUgbmV3IHdvcmxkIG9yZGVyIG9mIGR5bmFtaWNhbGx5CiAgICAgZW5h
YmxlZCBmZWF0dXJlIGJpdHMgc2ltcGxlci4KCiAgMikgSW50cm9kdWNlcyBhIGNvbnRhaW5lciBm
b3IgdGhlIGFjdHVhbCByZWdpc3RlciBzdG9yYWdlIHdoaWNoIGNhcnJpZXMKICAgICBpbmZvcm1h
dGlvbiBhYm91dCB0aGUga2VybmVsIGFuZCB1c2VyIHNwYWNlIGZlYXR1cmVzIGFuZCBzaXplcwog
ICAgIHN1cHBvcnRlZCBieSBpdCB0byBlYXN5IHRoZSBpbnRlZ3JhdGlvbiBvZiBkeW5hbWljYWxs
eSBlbmFibGVkIGZlYXR1cmUKICAgICBhbmQgdGhlIHJlc3VsdGluZyBkaWZmZXJlbnQgYnVmZmVy
IHNpemVzLgoKICAzKSBSZXBsYWNlcyBhIHRvbiBvZiBzdGF0ZSB2YXJpYWJsZXMgYnkgaW50cm9k
dWNpbmcgc3RydWN0dXJlcyB3aGljaAogICAgIGNhcnJ5IHRoYXQgaW5mb3JtYXRpb24KCiAgNCkg
VGhlIGFjdHVhbCBBTVggYW5kIGR5bmFtaWMgZmVhdHVyZSBlbmFibGUgYml0cyB3aGljaCBoYXZl
IGJlZW4KICAgICBzaWduaWZpY2FudGx5IHJld29ya2VkIG9uIHRvcCBvZiAjMSAtICMzIGFuZCB0
byBhZGRyZXNzIHNob3J0Y29taW5ncwogICAgIG9mIHRoZSBwcmV2aW91cyBzdWJtaXNzaW9ucy4K
ClRoZSBjdXJyZW50IHNlcmllcyAoIzEpIGlzIGJhc2VkIG9uOgoKICAgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAuZ2l0IHg4Ni9mcHUKCmFuZCBh
bHNvIGF2YWlsYWJsZSBmcm9tIGdpdDoKCiAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90Z2x4L2RldmVsLmdpdCB4ODYvZnB1LTEKClRoZSBmdWxsIHNlcmll
cyB3aGljaCBoYXMgIzEtIzQgaW5jbHVkZWQgY2FuIGJlIGZvdW5kIGF0OgoKICAgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RnbHgvZGV2ZWwuZ2l0IHg4Ni9m
cHUKClRoYW5rcywKCgl0Z2x4Ci0tLQogYXJjaC94ODYvZXZlbnRzL3BlcmZfZXZlbnQuaCAgICAg
ICAgfCAgICAxIAogYXJjaC94ODYvaWEzMi9pYTMyX3NpZ25hbC5jICAgICAgICAgfCAgICAxIAog
YXJjaC94ODYvaW5jbHVkZS9hc20vZnB1L2FwaS5oICAgICAgfCAgIDMxICsrCiBhcmNoL3g4Ni9p
bmNsdWRlL2FzbS9mcHUvaW50ZXJuYWwuaCB8ICA1MzAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUvc2lnbmFsLmggICB8ICAgMTMg
CiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUveGNyLmggICAgICB8ICAgMTEgCiBhcmNoL3g4Ni9p
bmNsdWRlL2FzbS9mcHUveHN0YXRlLmggICB8ICAgIDYgCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9w
a3J1LmggICAgICAgICB8ICAgIDIgCiBhcmNoL3g4Ni9rZXJuZWwvY3B1L2J1Z3MuYyAgICAgICAg
ICB8ICAgIDIgCiBhcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jICAgICAgICB8ICAgIDIgCiBh
cmNoL3g4Ni9rZXJuZWwvZnB1L2J1Z3MuYyAgICAgICAgICB8ICAgIDIgCiBhcmNoL3g4Ni9rZXJu
ZWwvZnB1L2NvcmUuYyAgICAgICAgICB8ICAxNjMgKysrKysrKystLS0KIGFyY2gveDg2L2tlcm5l
bC9mcHUvaW5pdC5jICAgICAgICAgIHwgICAyOSAtCiBhcmNoL3g4Ni9rZXJuZWwvZnB1L3JlZ3Nl
dC5jICAgICAgICB8ICAgIDYgCiBhcmNoL3g4Ni9rZXJuZWwvZnB1L3NpZ25hbC5jICAgICAgICB8
ICAgMjEgLQogYXJjaC94ODYva2VybmVsL2ZwdS94c3RhdGUuYyAgICAgICAgfCAgMTY0ICsrKysr
Ky0tLS0tCiBhcmNoL3g4Ni9rZXJuZWwvcHJvY2Vzcy5jICAgICAgICAgICB8ICAgIDYgCiBhcmNo
L3g4Ni9rZXJuZWwvcHJvY2Vzc18zMi5jICAgICAgICB8ICAgIDUgCiBhcmNoL3g4Ni9rZXJuZWwv
cHJvY2Vzc182NC5jICAgICAgICB8ICAgIDUgCiBhcmNoL3g4Ni9rZXJuZWwvcHRyYWNlLmMgICAg
ICAgICAgICB8ICAgIDEgCiBhcmNoL3g4Ni9rZXJuZWwvc2V2LmMgICAgICAgICAgICAgICB8ICAg
IDIgCiBhcmNoL3g4Ni9rZXJuZWwvc2lnbmFsLmMgICAgICAgICAgICB8ICAgIDEgCiBhcmNoL3g4
Ni9rZXJuZWwvc21wYm9vdC5jICAgICAgICAgICB8ICAgIDIgCiBhcmNoL3g4Ni9rZXJuZWwvdHJh
cHMuYyAgICAgICAgICAgICB8ICAgIDIgCiBhcmNoL3g4Ni9rdm0vc3ZtL3Nldi5jICAgICAgICAg
ICAgICB8ICAgIDIgCiBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jICAgICAgICAgICAgICB8ICAgIDIg
CiBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgICAgICB8ICAxOTIgKy0tLS0tLS0tLS0t
LQogYXJjaC94ODYvbWF0aC1lbXUvZnB1X2VudHJ5LmMgICAgICAgfCAgICAyIAogYXJjaC94ODYv
bW0vZXh0YWJsZS5jICAgICAgICAgICAgICAgfCAgICA0IAogYXJjaC94ODYvcG93ZXIvY3B1LmMg
ICAgICAgICAgICAgICAgfCAgICAyIAogYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUvc2NoZWQu
aCAgfCAgIDY4ICsrKysKIGIvYXJjaC94ODYva2VybmVsL2ZwdS9jb250ZXh0LmggICAgIHwgICA4
NSArKysrKwogYi9hcmNoL3g4Ni9rZXJuZWwvZnB1L2ludGVybmFsLmggICAgfCAgIDMwICsrCiBi
L2FyY2gveDg2L2tlcm5lbC9mcHUvbGVnYWN5LmggICAgICB8ICAxMTUgKysrKysrKwogYi9hcmNo
L3g4Ni9rZXJuZWwvZnB1L3hzdGF0ZS5oICAgICAgfCAgMTk4ICsrKysrKysrKysrKysKIDM1IGZp
bGVzIGNoYW5nZWQsIDgyMiBpbnNlcnRpb25zKCspLCA4ODYgZGVsZXRpb25zKC0pCg==
