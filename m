Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4E718AF92
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCSJRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:17:41 -0400
Received: from 8bytes.org ([81.169.241.247]:52340 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727372AbgCSJOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:37 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 726327AB; Thu, 19 Mar 2020 10:14:23 +0100 (CET)
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
Subject: [PATCH 38/70] x86/sev-es: Setup early #VC handler
Date:   Thu, 19 Mar 2020 10:13:35 +0100
Message-Id: <20200319091407.1481-39-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Setup an early handler for #VC exceptions. There is no GHCB mapped
yet, so just re-use the vc_no_ghcb_handler. It can only handle CPUID
exit-codes, but that should be enough to get the kernel through
verify_cpu() and __startup_64() until it runs on virtual addresses.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/desc.h      |  1 +
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/include/asm/sev-es.h    |  2 ++
 arch/x86/kernel/head64.c         | 17 +++++++++++++++
 arch/x86/kernel/head_64.S        | 36 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/idt.c            | 10 +++++++++
 6 files changed, 67 insertions(+)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 80bf63c08007..30e2a0e863b6 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -388,6 +388,7 @@ static inline void set_desc_limit(struct desc_struct *desc, unsigned long limit)
 
 void update_intr_gate(unsigned int n, const void *addr);
 void alloc_intr_gate(unsigned int n, const void *addr);
+void set_early_idt_handler(gate_desc *idt, int n, void *handler);
 
 static inline void init_idt_data(struct idt_data *data, unsigned int n,
 				 const void *addr)
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
index 8ccca109750d..b8613fc0a364 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -38,6 +38,7 @@
 #include <asm/fixmap.h>
 #include <asm/extable.h>
 #include <asm/trap_defs.h>
+#include <asm/sev-es.h>
 
 /*
  * Manage page tables very early on.
@@ -515,3 +516,19 @@ void __head early_idt_setup_early_handler(unsigned long physaddr)
 		native_write_idt_entry(idt, i, &desc);
 	}
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
index bc0622a72d6d..b3acecdabd34 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -92,6 +92,12 @@ SYM_CODE_START_NOALIGN(startup_64)
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
 
@@ -370,6 +376,33 @@ SYM_CODE_START_LOCAL(early_idt_handler_common)
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
+	movq	ORIG_RAX(%rsp), %rsi
+	call    vc_no_ghcb_handler
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
@@ -511,6 +544,9 @@ SYM_DATA_END(level1_fixmap_pgt)
 SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
 SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 
+SYM_DATA(early_idt_descr,		.word NUM_EXCEPTION_VECTORS * 16)
+SYM_DATA_LOCAL(early_idt_descr_base,	.quad 0)
+
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
 SYM_DATA(phys_base, .quad 0x0)
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 4a2c7791c697..135d208a2d38 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -341,3 +341,13 @@ void alloc_intr_gate(unsigned int n, const void *addr)
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

