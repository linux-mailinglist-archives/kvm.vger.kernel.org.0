Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D34159102
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgBKN5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:57:07 -0500
Received: from 8bytes.org ([81.169.241.247]:52122 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729522AbgBKNxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:24 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 7C652E49; Tue, 11 Feb 2020 14:53:12 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 30/62] x86/head/64: Move early exception dispatch to C code
Date:   Tue, 11 Feb 2020 14:52:24 +0100
Message-Id: <20200211135256.24617-31-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Move the assembly coded dispatch between page-faults and all other
exceptions to C code to make it easier to maintain and extend.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head64.c  | 20 ++++++++++++++++++++
 arch/x86/kernel/head_64.S | 11 +----------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 7cdfb7113811..d83c62ebaa85 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -36,6 +36,8 @@
 #include <asm/microcode.h>
 #include <asm/kasan.h>
 #include <asm/fixmap.h>
+#include <asm/extable.h>
+#include <asm/trap_defs.h>
 
 /*
  * Manage page tables very early on.
@@ -377,6 +379,24 @@ int __init early_make_pgtable(unsigned long address)
 	return __early_make_pgtable(address, pmd);
 }
 
+void __init early_exception(struct pt_regs *regs, int trapnr)
+{
+	unsigned long cr2;
+	int r;
+
+	switch (trapnr) {
+	case X86_TRAP_PF:
+		cr2 = native_read_cr2();
+		r = early_make_pgtable(cr2);
+		break;
+	default:
+		r = 1;
+	}
+
+	if (r)
+		early_fixup_exception(regs, trapnr);
+}
+
 /* Don't add a printk in there. printk relies on the PDA which is not initialized 
    yet. */
 static void __init clear_bss(void)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 0af79f783659..81cf6c5763ef 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -357,18 +357,9 @@ SYM_CODE_START_LOCAL(early_idt_handler_common)
 	pushq %r15				/* pt_regs->r15 */
 	UNWIND_HINT_REGS
 
-	cmpq $14,%rsi		/* Page fault? */
-	jnz 10f
-	GET_CR2_INTO(%rdi)	/* can clobber %rax if pv */
-	call early_make_pgtable
-	andl %eax,%eax
-	jz 20f			/* All good */
-
-10:
 	movq %rsp,%rdi		/* RDI = pt_regs; RSI is already trapnr */
-	call early_fixup_exception
+	call early_exception
 
-20:
 	decl early_recursion_flag(%rip)
 	jmp restore_regs_and_return_to_kernel
 SYM_CODE_END(early_idt_handler_common)
-- 
2.17.1

