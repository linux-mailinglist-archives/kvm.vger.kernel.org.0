Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C6D87F25
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437068AbfHIQO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:14:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52860 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407425AbfHIQO5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:14:57 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E0CC5305D36B;
        Fri,  9 Aug 2019 19:01:44 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 97C8A305B7A1;
        Fri,  9 Aug 2019 19:01:44 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 92/92] kvm: x86: fallback to the single-step on multipage CMPXCHG emulation
Date:   Fri,  9 Aug 2019 19:00:47 +0300
Message-Id: <20190809160047.8319-93-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

There are cases where we need to emulate a CMPXCHG that touches two
pages (4 in one and another 4 in the next, for example). Because it
is not easy to map two pages in the kernel so that we can directly
execute the exchange instruction, we fallback to single-stepping.
Luckly, this is an uncommon occurrence making the overhead of the
single-step mechanism acceptable.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0e904782d303..e283b074db26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5671,6 +5671,12 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 #define CMPXCHG_MAX_BYTES 8
 #endif
 
+	gpa = kvm_mmu_gva_to_gpa_write(vcpu, addr, NULL);
+
+	if (gpa == UNMAPPED_GVA ||
+	    (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
+		goto emul_write;
+
 	/* guests cmpxchg{8,16}b have to be emulated atomically */
 	if (bytes > CMPXCHG_MAX_BYTES || (bytes & (bytes - 1)))
 		goto emul_write;
@@ -5678,12 +5684,6 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (bytes == 16 && !system_has_cmpxchg_double())
 		goto emul_write;
 
-	gpa = kvm_mmu_gva_to_gpa_write(vcpu, addr, NULL);
-
-	if (gpa == UNMAPPED_GVA ||
-	    (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
-		goto emul_write;
-
 	if (((gpa + bytes - 1) & PAGE_MASK) != (gpa & PAGE_MASK))
 		goto emul_write;
 
@@ -5772,6 +5772,9 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	return X86EMUL_CONTINUE;
 
 emul_write:
+	if (kvmi_tracked_gfn(vcpu, gpa >> PAGE_SHIFT))
+		return X86EMUL_UNHANDLEABLE;
+
 	printk_once(KERN_WARNING "kvm: emulating exchange as write\n");
 
 	return emulator_write_emulated(ctxt, addr, new, bytes, exception);
