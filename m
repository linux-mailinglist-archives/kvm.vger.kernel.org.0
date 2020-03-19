Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8963A18AF10
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCSJO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:14:28 -0400
Received: from 8bytes.org ([81.169.241.247]:51930 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgCSJO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:26 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1C4F32D5; Thu, 19 Mar 2020 10:14:18 +0100 (CET)
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
Subject: [PATCH 12/70] x86/boot/compressed/64: Add IDT Infrastructure
Date:   Thu, 19 Mar 2020 10:13:09 +0100
Message-Id: <20200319091407.1481-13-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add code needed to setup an IDT in the early pre-decompression
boot-code. The IDT is loaded first in startup_64, which is after
EfiExitBootServices() has been called, and later reloaded when the
kernel image has been relocated to the end of the decompression area.

This allows to setup different IDT handlers before and after the
relocation.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/Makefile          |  1 +
 arch/x86/boot/compressed/head_64.S         | 34 ++++++++++
 arch/x86/boot/compressed/idt_64.c          | 43 +++++++++++++
 arch/x86/boot/compressed/idt_handlers_64.S | 75 ++++++++++++++++++++++
 arch/x86/boot/compressed/misc.h            |  5 ++
 arch/x86/include/asm/desc_defs.h           |  3 +
 6 files changed, 161 insertions(+)
 create mode 100644 arch/x86/boot/compressed/idt_64.c
 create mode 100644 arch/x86/boot/compressed/idt_handlers_64.S

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e186cc0b628d..54d63526e856 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -81,6 +81,7 @@ vmlinux-objs-$(CONFIG_EARLY_PRINTK) += $(obj)/early_serial_console.o
 vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/kaslr.o
 ifdef CONFIG_X86_64
 	vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/kaslr_64.o
+	vmlinux-objs-y += $(obj)/idt_64.o $(obj)/idt_handlers_64.o
 	vmlinux-objs-y += $(obj)/mem_encrypt.o
 	vmlinux-objs-y += $(obj)/pgtable_64.o
 endif
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 1f1f6c8139b3..d27a9ce1bcb0 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -33,6 +33,7 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 #include <asm/bootparam.h>
+#include <asm/desc_defs.h>
 #include "pgtable.h"
 
 /*
@@ -358,6 +359,10 @@ SYM_CODE_START(startup_64)
 	movq	%rax, gdt64+2(%rip)
 	lgdt	gdt64(%rip)
 
+	pushq	%rsi
+	call	load_stage1_idt
+	popq	%rsi
+
 	/*
 	 * paging_prepare() sets up the trampoline and checks if we need to
 	 * enable 5-level paging.
@@ -465,6 +470,16 @@ SYM_FUNC_END_ALIAS(efi_stub_entry)
 	.text
 SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
 
+/*
+ * Reload GDT after relocation - The GDT at the non-relocated position
+ * might be overwritten soon by the in-place decompression, so reload
+ * GDT at the relocated address. The GDT is referenced by exception
+ * handling and needs to be set up correctly.
+ */
+	leaq	gdt(%rip), %rax
+	movq	%rax, gdt64+2(%rip)
+	lgdt	gdt64(%rip)
+
 /*
  * Clear BSS (stack is currently empty)
  */
@@ -475,6 +490,13 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
 	shrq	$3, %rcx
 	rep	stosq
 
+/*
+ * Load stage2 IDT
+ */
+	pushq	%rsi
+	call	load_stage2_idt
+	popq	%rsi
+
 /*
  * Do the extraction, and jump to the new kernel..
  */
@@ -628,6 +650,18 @@ SYM_DATA_START_LOCAL(gdt)
 	.quad   0x0000000000000000	/* TS continued */
 SYM_DATA_END_LABEL(gdt, SYM_L_LOCAL, gdt_end)
 
+SYM_DATA_START(boot_idt_desc)
+	.word	boot_idt_end - boot_idt
+	.quad	0
+SYM_DATA_END(boot_idt_desc)
+	.balign 8
+SYM_DATA_START(boot_idt)
+	.rept	BOOT_IDT_ENTRIES
+	.quad	0
+	.quad	0
+	.endr
+SYM_DATA_END_LABEL(boot_idt, SYM_L_GLOBAL, boot_idt_end)
+
 #ifdef CONFIG_EFI_MIXED
 SYM_DATA_LOCAL(efi32_boot_args, .long 0, 0)
 SYM_DATA(efi_is64, .byte 1)
diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
new file mode 100644
index 000000000000..46ecea671b90
--- /dev/null
+++ b/arch/x86/boot/compressed/idt_64.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <asm/trap_defs.h>
+#include <asm/segment.h>
+#include "misc.h"
+
+static void set_idt_entry(int vector, void (*handler)(void))
+{
+	unsigned long address = (unsigned long)handler;
+	gate_desc entry;
+
+	memset(&entry, 0, sizeof(entry));
+
+	entry.offset_low    = (u16)(address & 0xffff);
+	entry.segment       = __KERNEL_CS;
+	entry.bits.type     = GATE_TRAP;
+	entry.bits.p        = 1;
+	entry.offset_middle = (u16)((address >> 16) & 0xffff);
+	entry.offset_high   = (u32)(address >> 32);
+
+	memcpy(&boot_idt[vector], &entry, sizeof(entry));
+}
+
+/* Have this here so we don't need to include <asm/desc.h> */
+static void load_boot_idt(const struct desc_ptr *dtr)
+{
+	asm volatile("lidt %0"::"m" (*dtr));
+}
+
+/* Setup IDT before kernel jumping to  .Lrelocated */
+void load_stage1_idt(void)
+{
+	boot_idt_desc.address = (unsigned long)boot_idt;
+
+	load_boot_idt(&boot_idt_desc);
+}
+
+/* Setup IDT after kernel jumping to  .Lrelocated */
+void load_stage2_idt(void)
+{
+	boot_idt_desc.address = (unsigned long)boot_idt;
+
+	load_boot_idt(&boot_idt_desc);
+}
diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
new file mode 100644
index 000000000000..3d86ab35ef52
--- /dev/null
+++ b/arch/x86/boot/compressed/idt_handlers_64.S
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Early IDT handler entry points
+ *
+ * Copyright (C) 2019 SUSE
+ *
+ * Author: Joerg Roedel <jroedel@suse.de>
+ */
+
+#include <asm/segment.h>
+
+#include "../../entry/calling.h"
+
+.macro EXCEPTION_HANDLER name function error_code=0
+SYM_FUNC_START(\name)
+
+	/* Build pt_regs */
+	.if \error_code == 0
+	pushq   $0
+	.endif
+
+	pushq   %rdi
+	pushq   %rsi
+	pushq   %rdx
+	pushq   %rcx
+	pushq   %rax
+	pushq   %r8
+	pushq   %r9
+	pushq   %r10
+	pushq   %r11
+	pushq   %rbx
+	pushq   %rbp
+	pushq   %r12
+	pushq   %r13
+	pushq   %r14
+	pushq   %r15
+
+	/* Call handler with pt_regs */
+	movq    %rsp, %rdi
+	/* Error code is second parameter */
+	movq	ORIG_RAX(%rsp), %rsi
+	call    \function
+
+	/* Restore regs */
+	popq    %r15
+	popq    %r14
+	popq    %r13
+	popq    %r12
+	popq    %rbp
+	popq    %rbx
+	popq    %r11
+	popq    %r10
+	popq    %r9
+	popq    %r8
+	popq    %rax
+	popq    %rcx
+	popq    %rdx
+	popq    %rsi
+	popq    %rdi
+
+	/* Remove error code and return */
+	addq    $8, %rsp
+
+	/*
+	 * Make sure we return to __KERNEL_CS - the CS selector on
+	 * the IRET frame might still be from an old BIOS GDT
+	 */
+	movq	$__KERNEL_CS, 8(%rsp)
+
+	iretq
+SYM_FUNC_END(\name)
+	.endm
+
+	.text
+	.code64
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 726e264410ff..062ae3ae6930 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -23,6 +23,7 @@
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/bootparam.h>
+#include <asm/desc_defs.h>
 
 #define BOOT_CTYPE_H
 #include <linux/acpi.h>
@@ -133,4 +134,8 @@ int count_immovable_mem_regions(void);
 static inline int count_immovable_mem_regions(void) { return 0; }
 #endif
 
+/* idt_64.c */
+extern gate_desc boot_idt[BOOT_IDT_ENTRIES];
+extern struct desc_ptr boot_idt_desc;
+
 #endif /* BOOT_COMPRESSED_MISC_H */
diff --git a/arch/x86/include/asm/desc_defs.h b/arch/x86/include/asm/desc_defs.h
index a91f3b6e4f2a..5621fb3f2d1a 100644
--- a/arch/x86/include/asm/desc_defs.h
+++ b/arch/x86/include/asm/desc_defs.h
@@ -109,6 +109,9 @@ struct desc_ptr {
 
 #endif /* !__ASSEMBLY__ */
 
+/* Boot IDT definitions */
+#define	BOOT_IDT_ENTRIES	32
+
 /* Access rights as returned by LAR */
 #define AR_TYPE_RODATA		(0 * (1 << 9))
 #define AR_TYPE_RWDATA		(1 * (1 << 9))
-- 
2.17.1

