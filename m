Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5BD24F768
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgHXJOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:14:15 -0400
Received: from 8bytes.org ([81.169.241.247]:37398 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730454AbgHXI4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:05 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 6EE8CF1F;
        Mon, 24 Aug 2020 10:56:03 +0200 (CEST)
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v6 30/76] x86/head/64: Install startup GDT
Date:   Mon, 24 Aug 2020 10:54:25 +0200
Message-Id: <20200824085511.7553-31-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824085511.7553-1-joro@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Handling exceptions during boot requires a working GDT. The kernel GDT
can't be used on the direct mapping, so load a startup GDT and setup
segments.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20200724160336.5435-30-joro@8bytes.org
---
 arch/x86/include/asm/setup.h |  1 +
 arch/x86/kernel/head64.c     | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/head_64.S    | 14 ++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 84b645cc8bc9..5c2fd05bd52c 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -48,6 +48,7 @@ extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
 extern unsigned long __startup_64(unsigned long physaddr, struct boot_params *bp);
 extern unsigned long __startup_secondary_64(void);
+extern void startup_64_setup_env(unsigned long physbase);
 extern int early_make_pgtable(unsigned long address);
 
 #ifdef CONFIG_X86_INTEL_MID
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index cbb71c1b574f..8c82be44be94 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -61,6 +61,24 @@ unsigned long vmemmap_base __ro_after_init = __VMEMMAP_BASE_L4;
 EXPORT_SYMBOL(vmemmap_base);
 #endif
 
+/*
+ * GDT used on the boot CPU before switching to virtual addresses.
+ */
+static struct desc_struct startup_gdt[GDT_ENTRIES] = {
+	[GDT_ENTRY_KERNEL32_CS]         = GDT_ENTRY_INIT(0xc09b, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_CS]           = GDT_ENTRY_INIT(0xa09b, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_DS]           = GDT_ENTRY_INIT(0xc093, 0, 0xfffff),
+};
+
+/*
+ * Address needs to be set at runtime because it references the startup_gdt
+ * while the kernel still uses a direct mapping.
+ */
+static struct desc_ptr startup_gdt_descr = {
+	.size = sizeof(startup_gdt),
+	.address = 0,
+};
+
 #define __head	__section(.head.text)
 
 static void __head *fixup_pointer(void *ptr, unsigned long physaddr)
@@ -489,3 +507,18 @@ void __init x86_64_start_reservations(char *real_mode_data)
 
 	start_kernel();
 }
+
+/*
+ * Setup boot CPU state needed before kernel switches to virtual addresses.
+ */
+void __head startup_64_setup_env(unsigned long physbase)
+{
+	/* Load GDT */
+	startup_gdt_descr.address = (unsigned long)fixup_pointer(startup_gdt, physbase);
+	native_load_gdt(&startup_gdt_descr);
+
+	/* New GDT is live - reload data segment registers */
+	asm volatile("movl %%eax, %%ds\n"
+		     "movl %%eax, %%ss\n"
+		     "movl %%eax, %%es\n" : : "a"(__KERNEL_DS) : "memory");
+}
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 16da4ac01597..2b2e91627221 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -73,6 +73,20 @@ SYM_CODE_START_NOALIGN(startup_64)
 	/* Set up the stack for verify_cpu(), similar to initial_stack below */
 	leaq	(__end_init_task - SIZEOF_PTREGS)(%rip), %rsp
 
+	leaq	_text(%rip), %rdi
+	pushq	%rsi
+	call	startup_64_setup_env
+	popq	%rsi
+
+	/* Now switch to __KERNEL_CS so IRET works reliably */
+	pushq	$__KERNEL_CS
+	leaq	.Lon_kernel_cs(%rip), %rax
+	pushq	%rax
+	lretq
+
+.Lon_kernel_cs:
+	UNWIND_HINT_EMPTY
+
 	/* Sanitize CPU configuration */
 	call verify_cpu
 
-- 
2.28.0

