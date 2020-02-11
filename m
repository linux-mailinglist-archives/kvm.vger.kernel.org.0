Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98DAF1590F6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgBKN4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:56:48 -0500
Received: from 8bytes.org ([81.169.241.247]:52178 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729518AbgBKNxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:24 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5B59EE48; Tue, 11 Feb 2020 14:53:12 +0100 (CET)
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
Subject: [PATCH 29/62] x86/head/64: Load IDT earlier
Date:   Tue, 11 Feb 2020 14:52:23 +0100
Message-Id: <20200211135256.24617-30-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Load the IDT right after switching to virtual addresses in head_64.S
so that the kernel can handle #VC exceptions.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/desc.h |  1 +
 arch/x86/kernel/head64.c    |  7 +++++++
 arch/x86/kernel/head_64.S   | 17 +++++++++++++++++
 arch/x86/kernel/idt.c       | 22 ++++++++++++++++++++++
 4 files changed, 47 insertions(+)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 68a99d2a5f33..8a4c642ee2b3 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -440,6 +440,7 @@ extern void idt_setup_apic_and_irq_gates(void);
 extern void idt_setup_early_pf(void);
 extern void idt_setup_ist_traps(void);
 extern void idt_setup_debugidt_traps(void);
+extern void setup_early_handlers(gate_desc *idt);
 #else
 static inline void idt_setup_early_pf(void) { }
 static inline void idt_setup_ist_traps(void) { }
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 206a4b6144c2..7cdfb7113811 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -489,3 +489,10 @@ void __init x86_64_start_reservations(char *real_mode_data)
 
 	start_kernel();
 }
+
+void __head early_idt_setup_early_handler(unsigned long physaddr)
+{
+	gate_desc *idt = fixup_pointer(idt_table, physaddr);
+
+	setup_early_handlers(idt);
+}
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index eefd6838b895..0af79f783659 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -98,6 +98,20 @@ SYM_CODE_START_NOALIGN(startup_64)
 	leaq	_text(%rip), %rdi
 	pushq	%rsi
 	call	__startup_64
+	/* Save return value */
+	pushq	%rax
+
+	/*
+	 * Load IDT with early handlers - needed for SEV-ES
+	 * Do this here because this must only happen on the boot CPU
+	 * and the code below is shared with secondary CPU bringup.
+	 */
+	leaq	_text(%rip), %rdi
+	call	early_idt_setup_early_handler
+
+	/* Restore __startup_64 return value*/
+	popq	%rax
+	/* Restore pointer to real_mode_data */
 	popq	%rsi
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
@@ -194,6 +208,9 @@ SYM_CODE_START(secondary_startup_64)
 	 */
 	movq initial_stack(%rip), %rsp
 
+	/* Load IDT */
+	lidt	idt_descr(%rip)
+
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 7d8fa631dca9..84250c090596 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -347,6 +347,28 @@ void __init idt_setup_early_handler(void)
 	load_idt(&idt_descr);
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * This function does the same as idt_setup_early_handler(), but is
+ * called directly from head_64.S before the kernel switches to virtual
+ * addresses.  PV-ops don't work at that point, so set_intr_gate() can't
+ * be used here.
+ */
+void __init setup_early_handlers(gate_desc *idt)
+{
+	int i;
+
+	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
+		struct idt_data data;
+		gate_desc desc;
+
+		init_idt_data(&data, i, early_idt_handler_array[i]);
+		idt_init_desc(&desc, &data);
+		native_write_idt_entry(idt, i, &desc);
+	}
+}
+#endif
+
 /**
  * idt_invalidate - Invalidate interrupt descriptor table
  * @addr:	The virtual address of the 'invalid' IDT
-- 
2.17.1

