Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27514260F8B
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 12:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgIHKWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 06:22:43 -0400
Received: from 8bytes.org ([81.169.241.247]:43782 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgIHKWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 06:22:41 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A2E93344; Tue,  8 Sep 2020 12:22:39 +0200 (CEST)
Date:   Tue, 8 Sep 2020 12:22:37 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
Subject: [PATCH v7.1 39/72] x86/sev-es: Setup early #VC handler
Message-ID: <20200908102237.GA12638@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-40-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907131613.12703-40-joro@8bytes.org>
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
 arch/x86/include/asm/sev-es.h |  3 +++
 arch/x86/kernel/head64.c      | 21 +++++++++++++++++++++
 arch/x86/kernel/head_64.S     | 30 ++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
index 6dc52440c4b4..7175d432ebfe 100644
--- a/arch/x86/include/asm/sev-es.h
+++ b/arch/x86/include/asm/sev-es.h
@@ -73,4 +73,7 @@ static inline u64 lower_bits(u64 val, unsigned int bits)
 	return (val & mask);
 }
 
+/* Early IDT entry points for #VC handler */
+extern void vc_no_ghcb(void);
+
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 4282dac694c3..5683bbb555ef 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -40,6 +40,7 @@
 #include <asm/desc.h>
 #include <asm/extable.h>
 #include <asm/trapnr.h>
+#include <asm/sev-es.h>
 
 /*
  * Manage page tables very early on.
@@ -540,11 +541,31 @@ static struct desc_ptr bringup_idt_descr = {
 	.address	= 0, /* Set at runtime */
 };
 
+static void set_bringup_idt_handler(int n, void *handler)
+{
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	struct idt_data data;
+	gate_desc desc;
+
+	init_idt_data(&data, n, handler);
+	idt_init_desc(&desc, &data);
+	native_write_idt_entry(bringup_idt_table, n, &desc);
+#endif
+}
+
 /* This runs while still in the direct mapping */
 static void startup_64_load_idt(unsigned long physbase)
 {
 	struct desc_ptr *desc = fixup_pointer(&bringup_idt_descr, physbase);
 
+	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
+		void *handler;
+
+		/* VMM Communication Exception */
+		handler = fixup_pointer(vc_no_ghcb, physbase);
+		set_bringup_idt_handler(X86_TRAP_VC, handler);
+	}
+
 	desc->address = (unsigned long)fixup_pointer(bringup_idt_table, physbase);
 	native_load_idt(desc);
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 3b40ec44a67d..6e68bca64ae4 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -348,6 +348,36 @@ SYM_CODE_START_LOCAL(early_idt_handler_common)
 	jmp restore_regs_and_return_to_kernel
 SYM_CODE_END(early_idt_handler_common)
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+/*
+ * VC Exception handler used during very early boot. The
+ * early_idt_handler_array can't be used because it returns via the
+ * paravirtualized INTERRUPT_RETURN and pv-ops don't work that early.
+ *
+ * This handler will end up in the .init.text section and not be
+ * available to boot secondary CPUs.
+ */
+SYM_CODE_START_NOALIGN(vc_no_ghcb)
+	UNWIND_HINT_IRET_REGS offset=8
+
+	/* Build pt_regs */
+	PUSH_AND_CLEAR_REGS
+
+	/* Call C handler */
+	movq    %rsp, %rdi
+	movq	ORIG_RAX(%rsp), %rsi
+	call    do_vc_no_ghcb
+
+	/* Unwind pt_regs */
+	POP_REGS
+
+	/* Remove Error Code */
+	addq    $8, %rsp
+
+	/* Pure iret required here - don't use INTERRUPT_RETURN */
+	iretq
+SYM_CODE_END(vc_no_ghcb)
+#endif
 
 #define SYM_DATA_START_PAGE_ALIGNED(name)			\
 	SYM_START(name, SYM_L_GLOBAL, .balign PAGE_SIZE)
-- 
2.28.0

