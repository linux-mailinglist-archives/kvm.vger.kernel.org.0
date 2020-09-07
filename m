Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A17E2602D6
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 19:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgIGRgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 13:36:32 -0400
Received: from 8bytes.org ([81.169.241.247]:43656 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbgIGNSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:18:15 -0400
Received: from cap.home.8bytes.org (p549add56.dip0.t-ipconnect.de [84.154.221.86])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id D2659F51;
        Mon,  7 Sep 2020 15:16:51 +0200 (CEST)
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
Subject: [PATCH v7 19/72] x86/boot/compressed/64: Add stage1 #VC handler
Date:   Mon,  7 Sep 2020 15:15:20 +0200
Message-Id: <20200907131613.12703-20-joro@8bytes.org>
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

Add the first handler for #VC exceptions. At stage 1 there is no GHCB
yet becaue the kernel might still be running on the EFI page table.

The stage 1 handler is limited to the MSR based protocol to talk to
the hypervisor and can only support CPUID exit-codes, but that is
enough to get to stage 2.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/Makefile          |  1 +
 arch/x86/boot/compressed/idt_64.c          |  4 ++
 arch/x86/boot/compressed/idt_handlers_64.S |  4 ++
 arch/x86/boot/compressed/misc.h            |  1 +
 arch/x86/boot/compressed/sev-es.c          | 45 +++++++++++++++
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/include/asm/sev-es.h              | 37 ++++++++++++
 arch/x86/include/asm/trapnr.h              |  1 +
 arch/x86/kernel/sev-es-shared.c            | 66 ++++++++++++++++++++++
 9 files changed, 160 insertions(+)
 create mode 100644 arch/x86/boot/compressed/sev-es.c
 create mode 100644 arch/x86/include/asm/sev-es.h
 create mode 100644 arch/x86/kernel/sev-es-shared.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index c12c9223a1fb..7302f184bece 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -83,6 +83,7 @@ ifdef CONFIG_X86_64
 	vmlinux-objs-y += $(obj)/idt_64.o $(obj)/idt_handlers_64.o
 	vmlinux-objs-y += $(obj)/mem_encrypt.o
 	vmlinux-objs-y += $(obj)/pgtable_64.o
+	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-es.o
 endif
 
 vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
index 5f083092a86d..f3ca7324be44 100644
--- a/arch/x86/boot/compressed/idt_64.c
+++ b/arch/x86/boot/compressed/idt_64.c
@@ -32,6 +32,10 @@ void load_stage1_idt(void)
 {
 	boot_idt_desc.address = (unsigned long)boot_idt;
 
+
+	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
+		set_idt_entry(X86_TRAP_VC, boot_stage1_vc);
+
 	load_boot_idt(&boot_idt_desc);
 }
 
diff --git a/arch/x86/boot/compressed/idt_handlers_64.S b/arch/x86/boot/compressed/idt_handlers_64.S
index b20e57504a94..92eb4df478a1 100644
--- a/arch/x86/boot/compressed/idt_handlers_64.S
+++ b/arch/x86/boot/compressed/idt_handlers_64.S
@@ -70,3 +70,7 @@ SYM_FUNC_END(\name)
 	.code64
 
 EXCEPTION_HANDLER	boot_page_fault do_boot_page_fault error_code=1
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+EXCEPTION_HANDLER	boot_stage1_vc do_vc_no_ghcb error_code=1
+#endif
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 9840c82a39f1..eaa8b45ebccb 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -141,5 +141,6 @@ extern struct desc_ptr boot_idt_desc;
 
 /* IDT Entry Points */
 void boot_page_fault(void);
+void boot_stage1_vc(void);
 
 #endif /* BOOT_COMPRESSED_MISC_H */
diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
new file mode 100644
index 000000000000..bb91cbb5920e
--- /dev/null
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD Encrypted Register State Support
+ *
+ * Author: Joerg Roedel <jroedel@suse.de>
+ */
+
+/*
+ * misc.h needs to be first because it knows how to include the other kernel
+ * headers in the pre-decompression code in a way that does not break
+ * compilation.
+ */
+#include "misc.h"
+
+#include <asm/sev-es.h>
+#include <asm/msr-index.h>
+#include <asm/ptrace.h>
+#include <asm/svm.h>
+
+static inline u64 sev_es_rd_ghcb_msr(void)
+{
+	unsigned long low, high;
+
+	asm volatile("rdmsr\n" : "=a" (low), "=d" (high) :
+			"c" (MSR_AMD64_SEV_ES_GHCB));
+
+	return ((high << 32) | low);
+}
+
+static inline void sev_es_wr_ghcb_msr(u64 val)
+{
+	u32 low, high;
+
+	low  = val & 0xffffffffUL;
+	high = val >> 32;
+
+	asm volatile("wrmsr\n" : : "c" (MSR_AMD64_SEV_ES_GHCB),
+			"a"(low), "d" (high) : "memory");
+}
+
+#undef __init
+#define __init
+
+/* Include code for early handlers */
+#include "../../kernel/sev-es-shared.c"
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index dc131b84ac3a..cd6d651ff730 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -466,6 +466,7 @@
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 #define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
+#define MSR_AMD64_SEV_ES_GHCB		0xc0010130
 #define MSR_AMD64_SEV			0xc0010131
 #define MSR_AMD64_SEV_ENABLED_BIT	0
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
new file mode 100644
index 000000000000..48a44038b5d1
--- /dev/null
+++ b/arch/x86/include/asm/sev-es.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AMD Encrypted Register State Support
+ *
+ * Author: Joerg Roedel <jroedel@suse.de>
+ */
+
+#ifndef __ASM_ENCRYPTED_STATE_H
+#define __ASM_ENCRYPTED_STATE_H
+
+#include <linux/types.h>
+
+#define GHCB_SEV_CPUID_REQ	0x004UL
+#define		GHCB_CPUID_REQ_EAX	0
+#define		GHCB_CPUID_REQ_EBX	1
+#define		GHCB_CPUID_REQ_ECX	2
+#define		GHCB_CPUID_REQ_EDX	3
+#define		GHCB_CPUID_REQ(fn, reg) (GHCB_SEV_CPUID_REQ | \
+					(((unsigned long)reg & 3) << 30) | \
+					(((unsigned long)fn) << 32))
+
+#define GHCB_SEV_CPUID_RESP	0x005UL
+#define GHCB_SEV_TERMINATE	0x100UL
+
+#define	GHCB_SEV_GHCB_RESP_CODE(v)	((v) & 0xfff)
+#define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
+
+void do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code);
+
+static inline u64 lower_bits(u64 val, unsigned int bits)
+{
+	u64 mask = (1ULL << bits) - 1;
+
+	return (val & mask);
+}
+
+#endif
diff --git a/arch/x86/include/asm/trapnr.h b/arch/x86/include/asm/trapnr.h
index 082f45631fa9..f5d2325aa0b7 100644
--- a/arch/x86/include/asm/trapnr.h
+++ b/arch/x86/include/asm/trapnr.h
@@ -26,6 +26,7 @@
 #define X86_TRAP_XF		19	/* SIMD Floating-Point Exception */
 #define X86_TRAP_VE		20	/* Virtualization Exception */
 #define X86_TRAP_CP		21	/* Control Protection Exception */
+#define X86_TRAP_VC		29	/* VMM Communication Exception */
 #define X86_TRAP_IRET		32	/* IRET Exception */
 
 #endif
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
new file mode 100644
index 000000000000..0bea32341afa
--- /dev/null
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD Encrypted Register State Support
+ *
+ * Author: Joerg Roedel <jroedel@suse.de>
+ *
+ * This file is not compiled stand-alone. It contains code shared
+ * between the pre-decompression boot code and the running Linux kernel
+ * and is included directly into both code-bases.
+ */
+
+/*
+ * Boot VC Handler - This is the first VC handler during boot, there is no GHCB
+ * page yet, so it only supports the MSR based communication with the
+ * hypervisor and only the CPUID exit-code.
+ */
+void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
+{
+	unsigned int fn = lower_bits(regs->ax, 32);
+	unsigned long val;
+
+	/* Only CPUID is supported via MSR protocol */
+	if (exit_code != SVM_EXIT_CPUID)
+		goto fail;
+
+	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EAX));
+	VMGEXIT();
+	val = sev_es_rd_ghcb_msr();
+	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
+		goto fail;
+	regs->ax = val >> 32;
+
+	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EBX));
+	VMGEXIT();
+	val = sev_es_rd_ghcb_msr();
+	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
+		goto fail;
+	regs->bx = val >> 32;
+
+	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_ECX));
+	VMGEXIT();
+	val = sev_es_rd_ghcb_msr();
+	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
+		goto fail;
+	regs->cx = val >> 32;
+
+	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EDX));
+	VMGEXIT();
+	val = sev_es_rd_ghcb_msr();
+	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
+		goto fail;
+	regs->dx = val >> 32;
+
+	/* Skip over the CPUID two-byte opcode */
+	regs->ip += 2;
+
+	return;
+
+fail:
+	sev_es_wr_ghcb_msr(GHCB_SEV_TERMINATE);
+	VMGEXIT();
+
+	/* Shouldn't get here - if we do halt the machine */
+	while (true)
+		asm volatile("hlt\n");
+}
-- 
2.28.0

