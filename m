Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B3B1590DB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgBKNx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:53:26 -0500
Received: from 8bytes.org ([81.169.241.247]:52426 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729538AbgBKNxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:25 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 19891E69; Tue, 11 Feb 2020 14:53:13 +0100 (CET)
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
Subject: [PATCH 33/62] x86/sev-es: Setup early #VC handler
Date:   Tue, 11 Feb 2020 14:52:27 +0100
Message-Id: <20200211135256.24617-34-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Setup an early handler for #VC exceptions. There is no GHCB mapped
yet, so just re-use the no_ghcb_vc_handler. It can only handle CPUID
exit-codes, but that should be enough to get the kernel through
verify_cpu() and __startup_64() until it runs on virtual addresses.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/desc.h      |  1 +
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/include/asm/sev-es.h    |  2 ++
 arch/x86/kernel/head64.c         | 17 ++++++++++++++++
 arch/x86/kernel/head_64.S        | 35 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/idt.c            | 10 +++++++++
 6 files changed, 66 insertions(+)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 8a4c642ee2b3..cc2db0325f9f 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -388,6 +388,7 @@ static inline void set_desc_limit(struct desc_struct *desc, unsigned long limit)
 
 void update_intr_gate(unsigned int n, const void *addr);
 void alloc_intr_gate(unsigned int n, const void *addr);
+void set_early_idt_handler(gate_desc *idt, int n, void *handler);
 
 extern unsigned long system_vectors[];
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 09705ccc393c..4622427d01d4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -768,6 +768,7 @@ extern int sysenter_setup(void);
 
 /* Defined in head.S */
 extern struct desc_ptr		early_gdt_descr;
+extern struct desc_ptr		early_idt_descr;
 
 extern void switch_to_new_gdt(int);
 extern void load_direct_gdt(int);
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 512d3ccb9832..caa29f75ce41 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -75,4 +75,6 @@ static inline u64 copy_lower_bits(u64 out, u64 in, unsigned int bits)
 	return out;
 }
 
+extern void early_vc_handler(void);
+
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index d83c62ebaa85..eab04ac260d4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -38,6 +38,7 @@
 #include <asm/fixmap.h>
 #include <asm/extable.h>
 #include <asm/trap_defs.h>
+#include <asm/sev-es.h>
 
 /*
  * Manage page tables very early on.
@@ -516,3 +517,19 @@ void __head early_idt_setup_early_handler(unsigned long physaddr)
 
 	setup_early_handlers(idt);
 }
+
+void __head early_idt_setup(unsigned long physbase)
+{
+	gate_desc *idt = fixup_pointer(idt_table, physbase);
+	void __maybe_unused *handler;
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	/* VMM Communication Exception */
+	handler = fixup_pointer(early_vc_handler, physbase);
+	set_early_idt_handler(idt, X86_TRAP_VC, handler);
+#endif
+
+	/* Initialize IDT descriptor and load IDT */
+	early_idt_descr.address = (unsigned long)idt;
+	native_load_idt(&early_idt_descr);
+}
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 81cf6c5763ef..13ebf7d3af2c 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -86,6 +86,12 @@ SYM_CODE_START_NOALIGN(startup_64)
 .Lon_kernel_cs:
 	UNWIND_HINT_EMPTY
 
+	/* Setup IDT - Needed for SEV-ES */
+	leaq	_text(%rip), %rdi
+	pushq	%rsi
+	call	early_idt_setup
+	popq	%rsi
+
 	/* Sanitize CPU configuration */
 	call verify_cpu
 
@@ -364,6 +370,32 @@ SYM_CODE_START_LOCAL(early_idt_handler_common)
 	jmp restore_regs_and_return_to_kernel
 SYM_CODE_END(early_idt_handler_common)
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+/*
+ * VC Exception handler used during very early boot. The
+ * early_idt_handler_array can't be used because it returns via the
+ * paravirtualized INTERRUPT_RETURN and pv-ops don't work that early.
+ */
+SYM_CODE_START_NOALIGN(early_vc_handler)
+	UNWIND_HINT_IRET_REGS offset=8
+
+	/* Build pt_regs */
+	PUSH_AND_CLEAR_REGS
+
+	/* Call C handler */
+	movq    %rsp, %rdi
+	call    no_ghcb_vc_handler
+
+	/* Unwind pt_regs */
+	POP_REGS
+
+	/* Remove Error Code */
+	addq    $8, %rsp
+
+	/* Pure iret required here - don't use INTERRUPT_RETURN */
+	iretq
+SYM_CODE_END(early_vc_handler)
+#endif
 
 #define SYM_DATA_START_PAGE_ALIGNED(name)			\
 	SYM_START(name, SYM_L_GLOBAL, .balign PAGE_SIZE)
@@ -505,6 +537,9 @@ SYM_DATA_END(level1_fixmap_pgt)
 SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
 SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 
+SYM_DATA(early_idt_descr,		.word NUM_EXCEPTION_VECTORS * 16)
+SYM_DATA_LOCAL(early_idt_descr_base,	.quad 0)
+
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
 SYM_DATA(phys_base, .quad 0x0)
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 84250c090596..1bfee6981e9b 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -393,3 +393,13 @@ void alloc_intr_gate(unsigned int n, const void *addr)
 	if (!test_and_set_bit(n, system_vectors))
 		set_intr_gate(n, addr);
 }
+
+void set_early_idt_handler(gate_desc *idt, int n, void *handler)
+{
+	struct idt_data data;
+	gate_desc desc;
+
+	init_idt_data(&data, n, handler);
+	idt_init_desc(&desc, &data);
+	native_write_idt_entry(idt, n, &desc);
+}
-- 
2.17.1

