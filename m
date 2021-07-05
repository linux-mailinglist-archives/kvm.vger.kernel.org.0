Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E693BB929
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 10:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhGEI3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 04:29:14 -0400
Received: from 8bytes.org ([81.169.241.247]:59092 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhGEI24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 04:28:56 -0400
Received: from cap.home.8bytes.org (p5b006775.dip0.t-ipconnect.de [91.0.103.117])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 07D7D9D9;
        Mon,  5 Jul 2021 10:26:17 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 08/12] x86/sev: Park APs on AP Jump Table with GHCB protocol version 2
Date:   Mon,  5 Jul 2021 10:24:39 +0200
Message-Id: <20210705082443.14721-9-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210705082443.14721-1-joro@8bytes.org>
References: <20210705082443.14721-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

GHCB protocol version 2 adds the MSR-based AP-reset-hold VMGEXIT which
does not need a GHCB. Use that to park APs in 16-bit protected mode on
the AP Jump Table.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/realmode.h    |  3 +
 arch/x86/kernel/sev.c              | 48 ++++++++++++++--
 arch/x86/realmode/rm/Makefile      | 11 ++--
 arch/x86/realmode/rm/header.S      |  3 +
 arch/x86/realmode/rm/sev_ap_park.S | 89 ++++++++++++++++++++++++++++++
 5 files changed, 144 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/realmode/rm/sev_ap_park.S

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 29590a4ddf24..668de0a8b1ae 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -23,6 +23,9 @@ struct real_mode_header {
 	u32	trampoline_header;
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	u32	sev_es_trampoline_start;
+	u32	sev_real_ap_park_asm;
+	u32	sev_real_ap_park_seg;
+	u32	sev_ap_park_gdt;
 #endif
 #ifdef CONFIG_X86_64
 	u32	trampoline_pgd;
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 0946ef732a62..2147ebd0e919 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -27,6 +27,7 @@
 #include <asm/fpu/internal.h>
 #include <asm/processor.h>
 #include <asm/realmode.h>
+#include <asm/tlbflush.h>
 #include <asm/traps.h>
 #include <asm/svm.h>
 #include <asm/smp.h>
@@ -695,6 +696,35 @@ static bool __init sev_es_setup_ghcb(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+static void __noreturn sev_jumptable_ap_park(void)
+{
+	local_irq_disable();
+
+	write_cr3(real_mode_header->trampoline_pgd);
+
+	/* Exiting long mode will fail if CR4.PCIDE is set. */
+	if (boot_cpu_has(X86_FEATURE_PCID))
+		cr4_clear_bits(X86_CR4_PCIDE);
+
+	asm volatile("xorq	%%r15, %%r15\n"
+		     "xorq	%%r14, %%r14\n"
+		     "xorq	%%r13, %%r13\n"
+		     "xorq	%%r12, %%r12\n"
+		     "xorq	%%r11, %%r11\n"
+		     "xorq	%%r10, %%r10\n"
+		     "xorq	%%r9,  %%r9\n"
+		     "xorq	%%r8,  %%r8\n"
+		     "xorq	%%rsi, %%rsi\n"
+		     "xorq	%%rdi, %%rdi\n"
+		     "xorq	%%rsp, %%rsp\n"
+		     "xorq	%%rbp, %%rbp\n"
+		     "ljmpl	*%0" : :
+		     "m" (real_mode_header->sev_real_ap_park_asm),
+		     "b" (sev_es_jump_table_pa >> 4));
+	unreachable();
+}
+STACK_FRAME_NON_STANDARD(sev_jumptable_ap_park);
+
 static void sev_es_ap_hlt_loop(void)
 {
 	struct ghcb_state state;
@@ -731,8 +761,10 @@ static void sev_es_play_dead(void)
 	play_dead_common();
 
 	/* IRQs now disabled */
-
-	sev_es_ap_hlt_loop();
+	if (sev_ap_jumptable_blob_installed)
+		sev_jumptable_ap_park();
+	else
+		sev_es_ap_hlt_loop();
 
 	/*
 	 * If we get here, the VCPU was woken up again. Jump to CPU
@@ -762,8 +794,9 @@ static inline void sev_es_setup_play_dead(void) { }
 static void __init sev_es_setup_ap_jump_table_data(void *base, u32 pa)
 {
 	struct sev_ap_jump_table_header *header;
+	u64 *ap_jumptable_gdt, *sev_ap_park_gdt;
 	struct desc_ptr *gdt_descr;
-	u64 *ap_jumptable_gdt;
+	int idx;
 
 	header = base;
 
@@ -773,8 +806,13 @@ static void __init sev_es_setup_ap_jump_table_data(void *base, u32 pa)
 	 * real-mode.
 	 */
 	ap_jumptable_gdt = (u64 *)(base + header->gdt_offset);
-	ap_jumptable_gdt[SEV_APJT_CS16 / 8] = GDT_ENTRY(0x9b, pa, 0xffff);
-	ap_jumptable_gdt[SEV_APJT_DS16 / 8] = GDT_ENTRY(0x93, pa, 0xffff);
+	sev_ap_park_gdt  = __va(real_mode_header->sev_ap_park_gdt);
+
+	idx = SEV_APJT_CS16 / 8;
+	ap_jumptable_gdt[idx] = sev_ap_park_gdt[idx] = GDT_ENTRY(0x9b, pa, 0xffff);
+
+	idx = SEV_APJT_DS16 / 8;
+	ap_jumptable_gdt[idx] = sev_ap_park_gdt[idx] = GDT_ENTRY(0x93, pa, 0xffff);
 
 	/* Write correct GDT base address into GDT descriptor */
 	gdt_descr = (struct desc_ptr *)(base + header->gdt_offset);
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 83f1b6a56449..a7f84d43a0a3 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -27,11 +27,12 @@ wakeup-objs	+= video-vga.o
 wakeup-objs	+= video-vesa.o
 wakeup-objs	+= video-bios.o
 
-realmode-y			+= header.o
-realmode-y			+= trampoline_$(BITS).o
-realmode-y			+= stack.o
-realmode-y			+= reboot.o
-realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
+realmode-y				+= header.o
+realmode-y				+= trampoline_$(BITS).o
+realmode-y				+= stack.o
+realmode-y				+= reboot.o
+realmode-$(CONFIG_ACPI_SLEEP)		+= $(wakeup-objs)
+realmode-$(CONFIG_AMD_MEM_ENCRYPT)	+= sev_ap_park.o
 
 targets	+= $(realmode-y)
 
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index 8c1db5bf5d78..6c17f8fd1eb4 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -22,6 +22,9 @@ SYM_DATA_START(real_mode_header)
 	.long	pa_trampoline_header
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	.long	pa_sev_es_trampoline_start
+	.long	pa_sev_ap_park_asm
+	.long	__KERNEL32_CS
+	.long	pa_sev_ap_park_gdt;
 #endif
 #ifdef CONFIG_X86_64
 	.long	pa_trampoline_pgd;
diff --git a/arch/x86/realmode/rm/sev_ap_park.S b/arch/x86/realmode/rm/sev_ap_park.S
new file mode 100644
index 000000000000..0b63d0569d4d
--- /dev/null
+++ b/arch/x86/realmode/rm/sev_ap_park.S
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/page_types.h>
+#include <asm/processor-flags.h>
+#include <asm/msr-index.h>
+#include <asm/sev-ap-jumptable.h>
+#include "realmode.h"
+
+	.section ".text32", "ax"
+	.code32
+/*
+ * The following code switches to 16-bit protected mode and sets up the
+ * execution environment for the AP Jump Table blob. Then it jumps to the AP
+ * Jump Table to park the AP.
+ *
+ * The code was copied from reboot.S and modified to fit the SEV-ES requirements
+ * for AP parking. When this code is entered, all registers except %EAX-%EDX are
+ * in reset state.
+ *
+ * The AP Jump Table physical base address is in %EBX upon entry.
+ *
+ * %EAX, %ECX, %EDX and EFLAGS are undefined. Only use registers %EAX-%EDX and
+ * %ESP in this code.
+ */
+SYM_CODE_START(sev_ap_park_asm)
+
+	/* Switch to trampoline GDT as it is guaranteed < 4 GiB */
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
+	lgdt	pa_tr_gdt
+
+	/* Disable paging to drop us out of long mode */
+	movl	%cr0, %eax
+	btcl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
+	ljmpl	$__KERNEL32_CS, $pa_sev_ap_park_paging_off
+
+SYM_INNER_LABEL(sev_ap_park_paging_off, SYM_L_GLOBAL)
+	/* Clear EFER */
+	movl	$0, %eax
+	movl	$0, %edx
+	movl	$MSR_EFER, %ecx
+	wrmsr
+
+	/* Clear CR3 */
+	movl	$0, %ecx
+	movl	%ecx, %cr3
+
+	/* Set up the IDT for real mode. */
+	lidtl	pa_machine_real_restart_idt
+
+	/*
+	 * Load the GDT with the 16-bit segments for the AP Jump Table
+	 */
+	lgdtl	pa_sev_ap_park_gdt
+
+	/* Setup Code and Data segments for AP Jump Table */
+	movw	$SEV_APJT_DS16, %ax
+	movw	%ax, %ds
+	movw	%ax, %ss
+
+	/* Jump to the AP Jump Table into 16 bit protected mode */
+	ljmpw	$SEV_APJT_CS16, $SEV_APJT_ENTRY
+SYM_CODE_END(sev_ap_park_asm)
+
+	.data
+	.balign	16
+SYM_DATA_START(sev_ap_park_gdt)
+	/* Self-pointer */
+	.word	sev_ap_park_gdt_end - sev_ap_park_gdt - 1
+	.long	pa_sev_ap_park_gdt
+	.word	0
+
+	/*
+	 * Offset 0x8
+	 * 32 bit code segment descriptor pointing to AP Jump table base
+	 * Setup at runtime in sev_es_setup_ap_jump_table_data().
+	 */
+	.quad	0
+
+	/*
+	 * Offset 0x10
+	 * 32 bit data segment descriptor pointing to AP Jump table base
+	 * Setup at runtime in sev_es_setup_ap_jump_table_data().
+	 */
+	.quad	0
+SYM_DATA_END_LABEL(sev_ap_park_gdt, SYM_L_GLOBAL, sev_ap_park_gdt_end)
-- 
2.31.1

