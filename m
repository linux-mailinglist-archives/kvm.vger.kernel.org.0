Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C3F260274
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgIGNUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 09:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbgIGNS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:18:26 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3B2C061799;
        Mon,  7 Sep 2020 06:18:04 -0700 (PDT)
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 05E3BFF4;
        Mon,  7 Sep 2020 15:16:59 +0200 (CEST)
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
Subject: [PATCH v7 33/72] x86/head/64: Install a CPU bringup IDT
Date:   Mon,  7 Sep 2020 15:15:34 +0200
Message-Id: <20200907131613.12703-34-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907131613.12703-1-joro@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add a separate bringup IDT used by CPU bringup code that will be used
until the kernel switches to the idt_table. There are two reasons for
a separate IDT:

	1) When the idt_table is set up and the secondary CPUs are
	   booted, it contains entries (e.g. IST entries) which
	   require certain CPU state to be set up. This includes a
	   working TSS (for IST), MSR_GS_BASE (for stack protector) or
	   CR4.FSGSBASE (for paranoid_entry) path. By using a
	   dedicated IDT for early boot this state need not to be set
	   up early.

	2) The idt_table is static to idt.c, so any function
	   using/modifying must be in idt.c too. That means that all
	   compiler driven instrumentation like tracing or KASAN is
	   also active in this code. But during early CPU bringup the
	   environment is not set up for this instrumentation to work
	   correctly.

To avoid all of these hassles and make early exception handling
robust, use a dedicated bringup IDT.

The IDT is loaded two times, first on the boot CPU while the kernel is
still running on direct mapped addresses, and again later when the
switch to kernel addresses happened. The second IDT load happens on
the boot and secondary CPUs.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/setup.h |  1 +
 arch/x86/kernel/head64.c     | 39 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/head_64.S    |  5 +++++
 3 files changed, 45 insertions(+)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 5c2fd05bd52c..4b3ca5ade2fd 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -50,6 +50,7 @@ extern unsigned long __startup_64(unsigned long physaddr, struct boot_params *bp
 extern unsigned long __startup_secondary_64(void);
 extern void startup_64_setup_env(unsigned long physbase);
 extern int early_make_pgtable(unsigned long address);
+extern void early_setup_idt(void);
 
 #ifdef CONFIG_X86_INTEL_MID
 extern void x86_intel_mid_early_setup(void);
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 8c82be44be94..7bfd5c27c773 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -36,6 +36,8 @@
 #include <asm/microcode.h>
 #include <asm/kasan.h>
 #include <asm/fixmap.h>
+#include <asm/realmode.h>
+#include <asm/desc.h>
 
 /*
  * Manage page tables very early on.
@@ -508,6 +510,41 @@ void __init x86_64_start_reservations(char *real_mode_data)
 	start_kernel();
 }
 
+/*
+ * Data structures and code used for IDT setup in head_64.S. The bringup-IDT is
+ * used until the idt_table takes over. On the boot CPU this happens in
+ * x86_64_start_kernel(), on secondary CPUs in start_secondary(). In both cases
+ * this happens in the functions called from head_64.S.
+ *
+ * The idt_table can't be used that early because all the code modifying it is
+ * in idt.c and can be instrumented by tracing or KASAN, which both don't work
+ * during early CPU bringup. Also the idt_table has the runtime vectors
+ * configured which require certain CPU state to be setup already (like TSS),
+ * which also hasn't happened yet in early CPU bringup.
+ */
+static gate_desc bringup_idt_table[NUM_EXCEPTION_VECTORS] __page_aligned_data;
+
+static struct desc_ptr bringup_idt_descr = {
+	.size		= (NUM_EXCEPTION_VECTORS * sizeof(gate_desc)) - 1,
+	.address	= 0, /* Set at runtime */
+};
+
+/* This runs while still in the direct mapping */
+static void startup_64_load_idt(unsigned long physbase)
+{
+	struct desc_ptr *desc = fixup_pointer(&bringup_idt_descr, physbase);
+
+	desc->address = (unsigned long)fixup_pointer(bringup_idt_table, physbase);
+	native_load_idt(desc);
+}
+
+/* This is used when running on kernel addresses */
+void early_setup_idt(void)
+{
+	bringup_idt_descr.address = (unsigned long)bringup_idt_table;
+	native_load_idt(&bringup_idt_descr);
+}
+
 /*
  * Setup boot CPU state needed before kernel switches to virtual addresses.
  */
@@ -521,4 +558,6 @@ void __head startup_64_setup_env(unsigned long physbase)
 	asm volatile("movl %%eax, %%ds\n"
 		     "movl %%eax, %%ss\n"
 		     "movl %%eax, %%es\n" : : "a"(__KERNEL_DS) : "memory");
+
+	startup_64_load_idt(physbase);
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 83050c9e54d9..1de09b58e578 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -198,6 +198,11 @@ SYM_CODE_START(secondary_startup_64)
 	 */
 	movq initial_stack(%rip), %rsp
 
+	/* Setup and Load IDT */
+	pushq	%rsi
+	call	early_setup_idt
+	popq	%rsi
+
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
-- 
2.28.0

