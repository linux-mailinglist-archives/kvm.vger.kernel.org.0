Return-Path: <kvm+bounces-11564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37AAB8784E4
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2200B20E32
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB895577C;
	Mon, 11 Mar 2024 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSoX3YlU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7722947F63;
	Mon, 11 Mar 2024 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710173864; cv=none; b=u37mP00ADJ/btr6tDBKYJsa+e80oKMMrq9nw+EjCwaQIqDO5F960itgLUmYoJAIEt+YMRjzh1Oz6IhwrqK3aZIh7vmy1T3HI2EnDaV1poSA/Oi5vId1PS8lawK1AQfjMeiq3no/bnXwITzV/vccCY98NUdxrBNj0sgYjf5iOXOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710173864; c=relaxed/simple;
	bh=ijzu9O0b+YU1WXbixfglMbDKEC4eJ7EcwwFQkwgwSVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ngmrE2XEbZ+eFsX8czCIL94YwAU35ojNrtfpo+7rCWQLiD6VlEJPpgkd/hs4w7fk8S+SNEFgIBxbLiQdNn4Mz1gvKspW7lrVeBZOdywQ7mvE352lfX61t/iovN1O0vzaL3PVcb0+t1M7GOqMWb3pkxTszbYhB3AI+bFQw83KRVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MSoX3YlU; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d29aad15a5so50882181fa.3;
        Mon, 11 Mar 2024 09:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710173859; x=1710778659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zGCarDGFCcgtDjI7LZjJSVS0seEYtNWQr2sVWo8KxLA=;
        b=MSoX3YlUCxQq8/3LaS+asVig0rlC6uvx4Y4Avzb7ZGLciBBhdW57CS0i/Rj3qh4hiy
         4k4/nmkl9VsIOlPT85X4WeeIkiCzIkG2ZIWDtQZssfRbargFS/94I3cg4fE0CJyzTnt4
         4WRImuaiHP9Q56jGo+qTgC/yMJIHIcWs7cGWfSu7zSX+GyXJKnpMNWOQiuwtjpErPo0O
         7/nQN5Hr1M5XWAFUkAAS6Z27hITPmRQaYqBzpfe61HGYEAeR9h6u84Hpta3RsXcvUJab
         H6P1/eGJsHTQY9KsFfoLQIRPaBOKVwGg8kEO68yMg76CokbOriLpaKa4K3tEsXIFFgnV
         MqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710173859; x=1710778659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zGCarDGFCcgtDjI7LZjJSVS0seEYtNWQr2sVWo8KxLA=;
        b=Wu/TLVVoPgomgGWSFR7y8uXexRuTBTPHTB56cbUgQ5b4BtZTbqfIlwlOqDBUamYzgA
         rSPyg8SET7ZTc6CVTWlPZ/0Fvn/N95+SEk/tr3CzeaeMuDXOCE9+oQB79elQWwwE1JrO
         yKzhVle8/uyrXdWVA8LX3Rkwj7t5iuP6wCeuisupmS8rQ0wUDc7j6rO3mA123+Kj4abq
         dlgRpDkjcYxDVjc2JtZ++S/iVbjEQDdo+lVWSvZbljDlZZK7+2PNeLGy7Bmi3LWvQwlS
         ExIWHgN50U9JmctLdVuN038kaWZdrb6rCcXxsNBzulAXxTXAjeTi7qin6ph3QTYQjIU5
         Tg/w==
X-Forwarded-Encrypted: i=1; AJvYcCWVKPgWtSiltrqpsKDNEycm8o86Z4UPbl4k5Z33ztjMbGEBPXdoloRNEjxnB0tcdXOxmyx6PjwZLRWFvl/0SHKkRBqNtj/i9b+Mw4xfZpFvDBC1/2Lnq1bpCQuu62sFOETnwnUXLsK/XuI6azOUV53NxqgcVHp+8AGJ
X-Gm-Message-State: AOJu0Ywi3HkZB520zWstbZlmPXBWa3m1hKQdHIAnTj+Nvp1MEbP3RR8N
	I2Eco1ElTG/JXlaKfHuS42Qykq+zbeJ6Zb5k1iy4bX7e+MaSI/ai
X-Google-Smtp-Source: AGHT+IE6XtOKsKp8hms95TDqCZHHhSaLSvqKyZ0PcsiqeEoPEFE6tP731EMdoQVlS080lK8XfsaJxA==
X-Received: by 2002:ac2:53b6:0:b0:513:af26:8cd0 with SMTP id j22-20020ac253b6000000b00513af268cd0mr1413426lfh.68.1710173859482;
        Mon, 11 Mar 2024 09:17:39 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab47:8200:c3b9:43af:f8e1:76f9])
        by smtp.gmail.com with ESMTPSA id ba14-20020a0560001c0e00b0033e96fe9479sm2823815wrb.89.2024.03.11.09.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 09:17:39 -0700 (PDT)
From: Vasant Karasulli <vsntk18@gmail.com>
To: x86@kernel.org
Cc: joro@8bytes.org,
	cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
	jslaby@suse.cz,
	keescook@chromium.org,
	kexec@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	luto@kernel.org,
	martin.b.radev@gmail.com,
	mhiramat@kernel.org,
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	Joerg Roedel <jroedel@suse.de>,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v4 5/9] x86/sev: Park APs on AP Jump Table with GHCB protocol version 2
Date: Mon, 11 Mar 2024 17:17:23 +0100
Message-Id: <20240311161727.14916-6-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240311161727.14916-1-vsntk18@gmail.com>
References: <20240311161727.14916-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <jroedel@suse.de>

GHCB protocol version 2 adds the MSR-based AP-reset-hold VMGEXIT which
does not need a GHCB. Use that to park APs in 16-bit protected mode on
the AP jump table.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/include/asm/realmode.h |  3 ++
 arch/x86/kernel/sev.c           | 55 ++++++++++++++++++---
 arch/x86/realmode/rm/Makefile   | 11 +++--
 arch/x86/realmode/rm/header.S   |  3 ++
 arch/x86/realmode/rm/sev.S      | 85 +++++++++++++++++++++++++++++++++
 5 files changed, 146 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/realmode/rm/sev.S

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index bd54a48fe077..b0a2aa9b8366 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -23,6 +23,9 @@ struct real_mode_header {
 	u32	trampoline_header;
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	u32	sev_es_trampoline_start;
+	u32	sev_ap_park;
+	u32	sev_ap_park_seg;
+	u32	sev_ap_park_gdt;
 #endif
 #ifdef CONFIG_X86_64
 	u32	trampoline_start64;
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index aa114a4f3dfc..08bf897361b9 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -33,6 +33,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/processor.h>
 #include <asm/realmode.h>
+#include <asm/tlbflush.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
 #include <asm/svm.h>
@@ -1140,8 +1141,9 @@ void __init snp_set_wakeup_secondary_cpu(void)
 void __init sev_es_setup_ap_jump_table_data(void *base, u32 pa)
 {
 	struct sev_ap_jump_table_header *header;
+	u64 *ap_jumptable_gdt, *sev_ap_park_gdt;
 	struct desc_ptr *gdt_descr;
-	u64 *ap_jumptable_gdt;
+	int idx;

 	header = base;

@@ -1151,9 +1153,16 @@ void __init sev_es_setup_ap_jump_table_data(void *base, u32 pa)
 	 * real-mode.
 	 */
 	ap_jumptable_gdt = (u64 *)(base + header->ap_jumptable_gdt);
-	ap_jumptable_gdt[SEV_APJT_CS16 / 8] = GDT_ENTRY(0x9b, pa, 0xffff);
-	ap_jumptable_gdt[SEV_APJT_DS16 / 8] = GDT_ENTRY(0x93, pa, 0xffff);
-	ap_jumptable_gdt[SEV_RM_DS / 8] = GDT_ENTRY(0x93, 0, 0xffff);
+	sev_ap_park_gdt  = __va(real_mode_header->sev_ap_park_gdt);
+
+	idx = SEV_APJT_CS16 / 8;
+	ap_jumptable_gdt[idx] = sev_ap_park_gdt[idx] = GDT_ENTRY(0x9b, pa, 0xffff);
+
+	idx = SEV_APJT_DS16 / 8;
+	ap_jumptable_gdt[idx] = sev_ap_park_gdt[idx] = GDT_ENTRY(0x93, pa, 0xffff);
+
+	idx = SEV_RM_DS / 8;
+	ap_jumptable_gdt[idx] = GDT_ENTRY(0x93, 0x0, 0xffff);

 	/* Write correct GDT base address into GDT descriptor */
 	gdt_descr = (struct desc_ptr *)(base + header->ap_jumptable_gdt);
@@ -1342,6 +1351,38 @@ void setup_ghcb(void)
 }

 #ifdef CONFIG_HOTPLUG_CPU
+void __noreturn sev_jumptable_ap_park(void)
+{
+	local_irq_disable();
+
+	write_cr3(real_mode_header->trampoline_pgd);
+
+	/* Exiting long mode will fail if CR4.PCIDE is set. */
+	if (cpu_feature_enabled(X86_FEATURE_PCID))
+		cr4_clear_bits(X86_CR4_PCIDE);
+
+	/*
+	 * Set all GPRs except EAX, EBX, ECX, and EDX to reset state to prepare
+	 * for software reset.
+	 */
+	asm volatile("xorl	%%r15d, %%r15d\n"
+		     "xorl	%%r14d, %%r14d\n"
+		     "xorl	%%r13d, %%r13d\n"
+		     "xorl	%%r12d, %%r12d\n"
+		     "xorl	%%r11d, %%r11d\n"
+		     "xorl	%%r10d, %%r10d\n"
+		     "xorl	%%r9d,  %%r9d\n"
+		     "xorl	%%r8d,  %%r8d\n"
+		     "xorl	%%esi, %%esi\n"
+		     "xorl	%%edi, %%edi\n"
+		     "xorl	%%esp, %%esp\n"
+		     "xorl	%%ebp, %%ebp\n"
+		     "ljmpl	*%0" : :
+		     "m" (real_mode_header->sev_ap_park));
+	unreachable();
+}
+STACK_FRAME_NON_STANDARD(sev_jumptable_ap_park);
+
 static void sev_es_ap_hlt_loop(void)
 {
 	struct ghcb_state state;
@@ -1378,8 +1419,10 @@ static void sev_es_play_dead(void)
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
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index f614009d3e4e..7fa22159f7d8 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -28,11 +28,12 @@ wakeup-objs	+= video-vga.o
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
+realmode-$(CONFIG_AMD_MEM_ENCRYPT)	+= sev.o

 targets	+= $(realmode-y)

diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index 2eb62be6d256..17eae256d443 100644
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
 	.long	pa_trampoline_start64
diff --git a/arch/x86/realmode/rm/sev.S b/arch/x86/realmode/rm/sev.S
new file mode 100644
index 000000000000..ae6eea2d53f7
--- /dev/null
+++ b/arch/x86/realmode/rm/sev.S
@@ -0,0 +1,85 @@
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
+ * execution environment for the AP jump table blob. Then it jumps to the AP
+ * jump table to park the AP.
+ *
+ * The code was copied from reboot.S and modified to fit the SEV-ES requirements
+ * for AP parking. When this code is entered, all registers except %EAX-%EDX are
+ * in reset state.
+ *
+ * %EAX, %EBX, %ECX, %EDX and EFLAGS are undefined. Only use registers %EAX-%EDX and
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
+	xorl	%eax, %eax
+	xorl	%edx, %edx
+	movl	$MSR_EFER, %ecx
+	wrmsr
+
+	/* Clear CR3 */
+	xorl	%ecx, %ecx
+	movl	%ecx, %cr3
+
+	/* Set up the IDT for real mode. */
+	lidtl	pa_machine_real_restart_idt
+
+	/* Load the GDT with the 16-bit segments for the AP jump table */
+	lgdtl	pa_sev_ap_park_gdt
+
+	/* Setup code and data segments for AP jump table */
+	movw	$SEV_APJT_DS16, %ax
+	movw	%ax, %ds
+	movw	%ax, %ss
+
+	/* Jump to the AP jump table into 16 bit protected mode */
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
+	 * 32 bit code segment descriptor pointing to AP jump table base
+	 * Setup at runtime in sev_es_setup_ap_jump_table_data().
+	 */
+	.quad	0
+
+	/*
+	 * Offset 0x10
+	 * 32 bit data segment descriptor pointing to AP jump table base
+	 * Setup at runtime in sev_es_setup_ap_jump_table_data().
+	 */
+	.quad	0
+SYM_DATA_END_LABEL(sev_ap_park_gdt, SYM_L_GLOBAL, sev_ap_park_gdt_end)
--
2.34.1


