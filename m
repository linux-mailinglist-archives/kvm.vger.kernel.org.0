Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4A018AF07
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgCSJOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:14:21 -0400
Received: from 8bytes.org ([81.169.241.247]:51930 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbgCSJOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:20 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 6C7E31E6; Thu, 19 Mar 2020 10:14:16 +0100 (CET)
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
Subject: [PATCH 04/70] x86/traps: Move some definitions to <asm/trap_defs.h>
Date:   Thu, 19 Mar 2020 10:13:01 +0100
Message-Id: <20200319091407.1481-5-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Move the definition of x86 trap vector numbers and the page-fault
error code bits to the new header file asm/trap_defs.h. This makes it
easier to include them into pre-decompression boot code. No functional
changes.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/trap_defs.h | 49 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/traps.h     | 44 +---------------------------
 2 files changed, 50 insertions(+), 43 deletions(-)
 create mode 100644 arch/x86/include/asm/trap_defs.h

diff --git a/arch/x86/include/asm/trap_defs.h b/arch/x86/include/asm/trap_defs.h
new file mode 100644
index 000000000000..488f82ac36da
--- /dev/null
+++ b/arch/x86/include/asm/trap_defs.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_TRAP_DEFS_H
+#define _ASM_X86_TRAP_DEFS_H
+
+/* Interrupts/Exceptions */
+enum {
+	X86_TRAP_DE = 0,	/*  0, Divide-by-zero */
+	X86_TRAP_DB,		/*  1, Debug */
+	X86_TRAP_NMI,		/*  2, Non-maskable Interrupt */
+	X86_TRAP_BP,		/*  3, Breakpoint */
+	X86_TRAP_OF,		/*  4, Overflow */
+	X86_TRAP_BR,		/*  5, Bound Range Exceeded */
+	X86_TRAP_UD,		/*  6, Invalid Opcode */
+	X86_TRAP_NM,		/*  7, Device Not Available */
+	X86_TRAP_DF,		/*  8, Double Fault */
+	X86_TRAP_OLD_MF,	/*  9, Coprocessor Segment Overrun */
+	X86_TRAP_TS,		/* 10, Invalid TSS */
+	X86_TRAP_NP,		/* 11, Segment Not Present */
+	X86_TRAP_SS,		/* 12, Stack Segment Fault */
+	X86_TRAP_GP,		/* 13, General Protection Fault */
+	X86_TRAP_PF,		/* 14, Page Fault */
+	X86_TRAP_SPURIOUS,	/* 15, Spurious Interrupt */
+	X86_TRAP_MF,		/* 16, x87 Floating-Point Exception */
+	X86_TRAP_AC,		/* 17, Alignment Check */
+	X86_TRAP_MC,		/* 18, Machine Check */
+	X86_TRAP_XF,		/* 19, SIMD Floating-Point Exception */
+	X86_TRAP_IRET = 32,	/* 32, IRET Exception */
+};
+
+/*
+ * Page fault error code bits:
+ *
+ *   bit 0 ==	 0: no page found	1: protection fault
+ *   bit 1 ==	 0: read access		1: write access
+ *   bit 2 ==	 0: kernel-mode access	1: user-mode access
+ *   bit 3 ==				1: use of reserved bit detected
+ *   bit 4 ==				1: fault was an instruction fetch
+ *   bit 5 ==				1: protection keys block access
+ */
+enum x86_pf_error_code {
+	X86_PF_PROT	=		1 << 0,
+	X86_PF_WRITE	=		1 << 1,
+	X86_PF_USER	=		1 << 2,
+	X86_PF_RSVD	=		1 << 3,
+	X86_PF_INSTR	=		1 << 4,
+	X86_PF_PK	=		1 << 5,
+};
+
+#endif /* _ASM_X86_TRAP_DEFS_H */
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index ffa0dc8a535e..2aa786484bb1 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -5,6 +5,7 @@
 #include <linux/context_tracking_state.h>
 #include <linux/kprobes.h>
 
+#include <asm/trap_defs.h>
 #include <asm/debugreg.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
@@ -132,47 +133,4 @@ void __noreturn handle_stack_overflow(const char *message,
 				      unsigned long fault_address);
 #endif
 
-/* Interrupts/Exceptions */
-enum {
-	X86_TRAP_DE = 0,	/*  0, Divide-by-zero */
-	X86_TRAP_DB,		/*  1, Debug */
-	X86_TRAP_NMI,		/*  2, Non-maskable Interrupt */
-	X86_TRAP_BP,		/*  3, Breakpoint */
-	X86_TRAP_OF,		/*  4, Overflow */
-	X86_TRAP_BR,		/*  5, Bound Range Exceeded */
-	X86_TRAP_UD,		/*  6, Invalid Opcode */
-	X86_TRAP_NM,		/*  7, Device Not Available */
-	X86_TRAP_DF,		/*  8, Double Fault */
-	X86_TRAP_OLD_MF,	/*  9, Coprocessor Segment Overrun */
-	X86_TRAP_TS,		/* 10, Invalid TSS */
-	X86_TRAP_NP,		/* 11, Segment Not Present */
-	X86_TRAP_SS,		/* 12, Stack Segment Fault */
-	X86_TRAP_GP,		/* 13, General Protection Fault */
-	X86_TRAP_PF,		/* 14, Page Fault */
-	X86_TRAP_SPURIOUS,	/* 15, Spurious Interrupt */
-	X86_TRAP_MF,		/* 16, x87 Floating-Point Exception */
-	X86_TRAP_AC,		/* 17, Alignment Check */
-	X86_TRAP_MC,		/* 18, Machine Check */
-	X86_TRAP_XF,		/* 19, SIMD Floating-Point Exception */
-	X86_TRAP_IRET = 32,	/* 32, IRET Exception */
-};
-
-/*
- * Page fault error code bits:
- *
- *   bit 0 ==	 0: no page found	1: protection fault
- *   bit 1 ==	 0: read access		1: write access
- *   bit 2 ==	 0: kernel-mode access	1: user-mode access
- *   bit 3 ==				1: use of reserved bit detected
- *   bit 4 ==				1: fault was an instruction fetch
- *   bit 5 ==				1: protection keys block access
- */
-enum x86_pf_error_code {
-	X86_PF_PROT	=		1 << 0,
-	X86_PF_WRITE	=		1 << 1,
-	X86_PF_USER	=		1 << 2,
-	X86_PF_RSVD	=		1 << 3,
-	X86_PF_INSTR	=		1 << 4,
-	X86_PF_PK	=		1 << 5,
-};
 #endif /* _ASM_X86_TRAPS_H */
-- 
2.17.1

