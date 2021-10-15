Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A22C42E5CA
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhJOBSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbhJOBSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DE8C061570;
        Thu, 14 Oct 2021 18:15:56 -0700 (PDT)
Message-ID: <20211015011411.304289784@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gpcv+9WEhV29vUM+2+8FV2exABfnYFtsORbVPtdlE/A=;
        b=gTs4apZg4243x1+jDiccYwtxvqfm/DBh14lm5i2JKqJ3f9v8wsk1GANDkL8s25orXI3CSd
        r8aGS7C32d/igkryNiMsmLZlw1gUfSMMHdO2EXw1EKzMAxFifF+3MD+K+9vNoOCVT+FEBS
        hksCYFyIdJYz/qRp4kzjFGr1gmIlqjqfm8pTda7zReOZwmLucnukuU1iWkmXccMoP1L5GG
        ULDst54P59dQph0y/JtqQRaCEOeN+7TONkfGvBDgEIYVonBgOUXnq1K4F5uSZlFUuqEwOu
        PUaSAeJsf0vMMouQBunDw521kx7i5etQyriG6xWLF6g8FhL24W6iHjA+GNFYdA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gpcv+9WEhV29vUM+2+8FV2exABfnYFtsORbVPtdlE/A=;
        b=BoyR+p/glWR/6NZF9c751BO3Oi+zQ776UlZVLNsAxdhfQ7lxr92NRLjbecdBEwI7JQ8fzI
        xeRDNb3WUypCv6DA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 00/30] x86/fpu: Preparatory cleanups for AMX support (part 1)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Fri, 15 Oct 2021 03:15:53 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhpcyBpcyB0aGUgcmV3b3JrIG9mIHRoZSBWMSBwYXJ0LTEgc2VyaWVzIG9mIHRoZSBlZmZvcnQg
dG8gc3VwcG9ydCB0aGUgbmV3CkFNWCBmZWF0dXJlOgoKICAgICBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9yLzIwMjExMDExMjE1ODEzLjU1ODY4MTM3M0BsaW51dHJvbml4LmRlCgpUaGlzIHBhcnQg
Y2xlYW5zIHVwIGV4aXN0aW5nIG1lc3MuIEhpc3RvcmljYWwgbGVmdG92ZXJzLCBzaG9ydGNvbWlu
Z3MgYW5kCmVzcGVjaWFsbHkgdGhlIHVuaXZlcnNhbCBraXRjaGVuIHNpbmsgYXNtL2ZwdS9pbnRl
cm5hbC5oIHdoaWNoIGlzIGluY2x1ZGVkCmFsbCBvdmVyIHRoZSBwbGFjZSBmb3IgdGhlIHdyb25n
IHJlYXNvbnMuCgpUaGlzIHNlcmllcyBoYXMgYSB2YWx1ZSBpbmRlcGVuZGVudCBvZiBBTVgsIGJ1
dCBhbGxvd3MgdG8gbWFrZSB0aGUKaW50ZWdyYXRpb24gYW5kIGNvbnZlcnNpb24gdG8gdGhlIG5l
dyB3b3JsZCBvcmRlciBvZiBkeW5hbWljYWxseSBlbmFibGVkCmZlYXR1cmUgYml0cyBzaW1wbGVy
LgoKVGhlIHNlcnJpZXMgaXMgYmFzZWQgb246CgogICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcC5naXQgeDg2L2ZwdQoKYW5kIGFsc28gYXZhaWxh
YmxlIGZyb20gZ2l0OgoKICAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3RnbHgvZGV2ZWwuZ2l0IHg4Ni9mcHUtMQoKVGhlIGZ1bGwgc2VyaWVzIHdoaWNoIGhh
cyB0aGUgZnVsbCBBTVggc3VwcG9ydCBpbmNsdWRlZCBjYW4gYmUgZm91bmQgYXQ6CgogICBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGdseC9kZXZlbC5naXQg
eDg2L2ZwdQoKQ2hhbmdlcyB2cy4gVjE6CgogIC0gRml4ZWQgdGhlIGlzc3VlIGluIHRoZSAhWFNB
VkUgY29kZSBwYXRoIG9mIHRoZSBrdm0gVUFCSSBjb3B5IGZ1bmN0aW9uIC0KICAgIFBhb2xvCgog
IC0gUmVuYW1lZCB0aGUgS1ZNIGZ1bmN0aW9ucyAtIEJvcmlzLCBQYW9sbywgU2VhbgoKICAtIEZp
eGVkIHRoZSBjb21tZW50cyBhbmQgY2hhbmdlbG9nIGlzc3VlcyAtIEJvcmlzCgpUaGFua3MsCgoJ
dGdseAotLS0KIGFyY2gveDg2L2V2ZW50cy9wZXJmX2V2ZW50LmggICAgICAgIHwgICAgMSAKIGFy
Y2gveDg2L2lhMzIvaWEzMl9zaWduYWwuYyAgICAgICAgIHwgICAgMSAKIGFyY2gveDg2L2luY2x1
ZGUvYXNtL2ZwdS9hcGkuaCAgICAgIHwgICAzMSArKwogYXJjaC94ODYvaW5jbHVkZS9hc20vZnB1
L2ludGVybmFsLmggfCAgNTMwIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQog
YXJjaC94ODYvaW5jbHVkZS9hc20vZnB1L3NpZ25hbC5oICAgfCAgIDEzIAogYXJjaC94ODYvaW5j
bHVkZS9hc20vZnB1L3hjci5oICAgICAgfCAgIDExIAogYXJjaC94ODYvaW5jbHVkZS9hc20vZnB1
L3hzdGF0ZS5oICAgfCAgICA2IAogYXJjaC94ODYvaW5jbHVkZS9hc20vcGtydS5oICAgICAgICAg
fCAgICAyIAogYXJjaC94ODYva2VybmVsL2NwdS9idWdzLmMgICAgICAgICAgfCAgICAyIAogYXJj
aC94ODYva2VybmVsL2NwdS9jb21tb24uYyAgICAgICAgfCAgICAyIAogYXJjaC94ODYva2VybmVs
L2ZwdS9idWdzLmMgICAgICAgICAgfCAgICAyIAogYXJjaC94ODYva2VybmVsL2ZwdS9jb3JlLmMg
ICAgICAgICAgfCAgMTYxICsrKysrKysrLS0KIGFyY2gveDg2L2tlcm5lbC9mcHUvaW5pdC5jICAg
ICAgICAgIHwgICAyOSAtCiBhcmNoL3g4Ni9rZXJuZWwvZnB1L3JlZ3NldC5jICAgICAgICB8ICAg
IDYgCiBhcmNoL3g4Ni9rZXJuZWwvZnB1L3NpZ25hbC5jICAgICAgICB8ICAgMjEgLQogYXJjaC94
ODYva2VybmVsL2ZwdS94c3RhdGUuYyAgICAgICAgfCAgMTcyICsrKysrKy0tLS0tCiBhcmNoL3g4
Ni9rZXJuZWwvcHJvY2Vzcy5jICAgICAgICAgICB8ICAgIDYgCiBhcmNoL3g4Ni9rZXJuZWwvcHJv
Y2Vzc18zMi5jICAgICAgICB8ICAgIDUgCiBhcmNoL3g4Ni9rZXJuZWwvcHJvY2Vzc182NC5jICAg
ICAgICB8ICAgIDUgCiBhcmNoL3g4Ni9rZXJuZWwvcHRyYWNlLmMgICAgICAgICAgICB8ICAgIDEg
CiBhcmNoL3g4Ni9rZXJuZWwvc2V2LmMgICAgICAgICAgICAgICB8ICAgIDIgCiBhcmNoL3g4Ni9r
ZXJuZWwvc2lnbmFsLmMgICAgICAgICAgICB8ICAgIDEgCiBhcmNoL3g4Ni9rZXJuZWwvc21wYm9v
dC5jICAgICAgICAgICB8ICAgIDIgCiBhcmNoL3g4Ni9rZXJuZWwvdHJhcHMuYyAgICAgICAgICAg
ICB8ICAgIDIgCiBhcmNoL3g4Ni9rdm0vc3ZtL3Nldi5jICAgICAgICAgICAgICB8ICAgIDIgCiBh
cmNoL3g4Ni9rdm0vdm14L3ZteC5jICAgICAgICAgICAgICB8ICAgIDIgCiBhcmNoL3g4Ni9rdm0v
eDg2LmMgICAgICAgICAgICAgICAgICB8ICAxOTIgKy0tLS0tLS0tLS0tLQogYXJjaC94ODYvbWF0
aC1lbXUvZnB1X2VudHJ5LmMgICAgICAgfCAgICAyIAogYXJjaC94ODYvbW0vZXh0YWJsZS5jICAg
ICAgICAgICAgICAgfCAgICA0IAogYXJjaC94ODYvcG93ZXIvY3B1LmMgICAgICAgICAgICAgICAg
fCAgICAyIAogYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mcHUvc2NoZWQuaCAgfCAgIDY4ICsrKysK
IGIvYXJjaC94ODYva2VybmVsL2ZwdS9jb250ZXh0LmggICAgIHwgICA4NSArKysrKwogYi9hcmNo
L3g4Ni9rZXJuZWwvZnB1L2ludGVybmFsLmggICAgfCAgIDMwICsrCiBiL2FyY2gveDg2L2tlcm5l
bC9mcHUvbGVnYWN5LmggICAgICB8ICAxMTUgKysrKysrKwogYi9hcmNoL3g4Ni9rZXJuZWwvZnB1
L3hzdGF0ZS5oICAgICAgfCAgMTk4ICsrKysrKysrKysrKysKIDM1IGZpbGVzIGNoYW5nZWQsIDgy
NCBpbnNlcnRpb25zKCspLCA4OTAgZGVsZXRpb25zKC0pCg==
