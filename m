Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3B465FDAA
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjAFJVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbjAFJUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:24 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3484D6B5EB;
        Fri,  6 Jan 2023 01:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996823; x=1704532823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vCu7hDBYF5PYXV3xZCXCG4axP12coNsvjra8oTgoxGQ=;
  b=E8U4la9FMGfemeAJrejbB1fUfBJK6wxzhsJ//j6sadLXJIBxTbzctcbr
   L/J0nOaQMIjflKuXlJJOhwVe+Pwc/rkLx0jf1IV1vi7n4ZcOKbqHri4WV
   7KPshrW6rwV9gubHJEEeIO+0GnhlJSX1qJ2zYq8YikUq5OueCCjXLPLyN
   YFTghIgymR96f9HSCA4aJo43XjvWJC7RdYEulWR/kN4dd1wv4lndg/7OC
   ePwpGWw1a0l9xf8vfunLpFtNlJRp8nyYKNyUhAKdLRRpHL6GjBCrLmGH2
   t9MMeeWTP/RorPTzeeCh7odypt4ZHkmmNnnBdt0bRTId2B+wr3abd7+Nj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511561"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511561"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139421"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139421"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:16 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 21/32] x86/fred: FRED entry/exit and dispatch code
Date:   Fri,  6 Jan 2023 00:56:06 -0800
Message-Id: <20230106085617.17248-22-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

The code to actually handle kernel and event entry/exit using
FRED. It is split up into two files thus:

- entry_64_fred.S contains the actual entrypoints and exit code, and
  saves and restores registers.
- entry_fred.c contains the two-level event dispatch code for FRED.
  The first-level dispatch is on the event type, and the second-level
  is on the event vector.

Originally-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v1:
* Initialize a FRED exception handler to fred_bad_event() instead of NULL
  if no FRED handler defined for an exception vector (Peter Zijlstra).
* Push calling irqentry_{enter,exit}() and instrumentation_{begin,end}()
  down into individual FRED exception handlers, instead of in the dispatch
  framework (Peter Zijlstra).
---
 arch/x86/entry/Makefile         |   5 +-
 arch/x86/entry/entry_64_fred.S  |  55 ++++++++
 arch/x86/entry/entry_fred.c     | 231 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/idtentry.h |   8 ++
 arch/x86/include/asm/traps.h    |   2 +
 5 files changed, 300 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/entry/entry_64_fred.S
 create mode 100644 arch/x86/entry/entry_fred.c

diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
index ca2fe186994b..c93e7f5c2a06 100644
--- a/arch/x86/entry/Makefile
+++ b/arch/x86/entry/Makefile
@@ -18,6 +18,9 @@ obj-y				+= vdso/
 obj-y				+= vsyscall/
 
 obj-$(CONFIG_PREEMPTION)	+= thunk_$(BITS).o
+CFLAGS_entry_fred.o		+= -fno-stack-protector
+CFLAGS_REMOVE_entry_fred.o	+= -pg $(CC_FLAGS_FTRACE)
+obj-$(CONFIG_X86_FRED)		+= entry_64_fred.o entry_fred.o
+
 obj-$(CONFIG_IA32_EMULATION)	+= entry_64_compat.o syscall_32.o
 obj-$(CONFIG_X86_X32_ABI)	+= syscall_x32.o
-
diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
new file mode 100644
index 000000000000..1fb765fd3871
--- /dev/null
+++ b/arch/x86/entry/entry_64_fred.S
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  arch/x86/entry/entry_64_fred.S
+ *
+ * The actual FRED entry points.
+ */
+#include <linux/linkage.h>
+#include <asm/errno.h>
+#include <asm/asm-offsets.h>
+#include <asm/fred.h>
+
+#include "calling.h"
+
+	.code64
+	.section ".noinstr.text", "ax"
+
+.macro FRED_ENTER
+	UNWIND_HINT_EMPTY
+	PUSH_AND_CLEAR_REGS
+	movq	%rsp, %rdi	/* %rdi -> pt_regs */
+.endm
+
+.macro FRED_EXIT
+	UNWIND_HINT_REGS
+	POP_REGS
+	addq $8,%rsp		/* Drop error code */
+.endm
+
+/*
+ * The new RIP value that FRED event delivery establishes is
+ * IA32_FRED_CONFIG & ~FFFH for events that occur in ring 3.
+ * Thus the FRED ring 3 entry point must be 4K page aligned.
+ */
+	.align 4096
+
+SYM_CODE_START_NOALIGN(fred_entrypoint_user)
+	FRED_ENTER
+	call	fred_entry_from_user
+SYM_INNER_LABEL(fred_exit_user, SYM_L_GLOBAL)
+	FRED_EXIT
+	ERETU
+SYM_CODE_END(fred_entrypoint_user)
+
+/*
+ * The new RIP value that FRED event delivery establishes is
+ * (IA32_FRED_CONFIG & ~FFFH) + 256 for events that occur in
+ * ring 0, i.e., fred_entrypoint_user + 256.
+ */
+	.org fred_entrypoint_user+256
+SYM_CODE_START_NOALIGN(fred_entrypoint_kernel)
+	FRED_ENTER
+	call	fred_entry_from_kernel
+	FRED_EXIT
+	ERETS
+SYM_CODE_END(fred_entrypoint_kernel)
diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
new file mode 100644
index 000000000000..61d12c152a37
--- /dev/null
+++ b/arch/x86/entry/entry_fred.c
@@ -0,0 +1,231 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * arch/x86/entry/entry_fred.c
+ *
+ * This contains the dispatch functions called from the entry point
+ * assembly.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kdebug.h>		/* oops_begin/end, ...		*/
+#include <linux/nospec.h>
+#include <asm/event-type.h>
+#include <asm/fred.h>
+#include <asm/idtentry.h>
+#include <asm/syscall.h>
+#include <asm/trapnr.h>
+#include <asm/traps.h>
+#include <asm/kdebug.h>
+
+/*
+ * Badness...
+ */
+static DEFINE_FRED_HANDLER(fred_bad_event)
+{
+	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
+
+	instrumentation_begin();
+
+	/* Panic on events from a high stack level */
+	if (regs->current_stack_level > 0) {
+		pr_emerg("PANIC: invalid or fatal FRED event; event type %u "
+			 "vector %u error 0x%lx aux 0x%lx at %04x:%016lx\n",
+			 regs->type, regs->vector, regs->orig_ax,
+			 fred_event_data(regs), regs->cs, regs->ip);
+		die("invalid or fatal FRED event", regs, regs->orig_ax);
+		panic("invalid or fatal FRED event");
+	} else {
+		unsigned long flags = oops_begin();
+		int sig = SIGKILL;
+
+		pr_alert("BUG: invalid or fatal FRED event; event type %u "
+			 "vector %u error 0x%lx aux 0x%lx at %04x:%016lx\n",
+			 regs->type, regs->vector, regs->orig_ax,
+			 fred_event_data(regs), regs->cs, regs->ip);
+
+		if (__die("Invalid or fatal FRED event", regs, regs->orig_ax))
+			sig = 0;
+
+		oops_end(flags, regs, sig);
+	}
+
+	instrumentation_end();
+	irqentry_nmi_exit(regs, irq_state);
+}
+
+noinstr void fred_exc_double_fault(struct pt_regs *regs)
+{
+	exc_double_fault(regs, regs->orig_ax);
+}
+
+/*
+ * Exception entry
+ */
+static DEFINE_FRED_HANDLER(fred_exception)
+{
+	/*
+	 * Exceptions that cannot happen on FRED h/w are set to fred_bad_event().
+	 */
+	static const fred_handler exception_handlers[NUM_EXCEPTION_VECTORS] = {
+		[X86_TRAP_DE] = exc_divide_error,
+		[X86_TRAP_DB] = fred_exc_debug,
+		[X86_TRAP_NMI] = fred_bad_event, /* A separate event type, not handled here */
+		[X86_TRAP_BP] = exc_int3,
+		[X86_TRAP_OF] = exc_overflow,
+		[X86_TRAP_BR] = exc_bounds,
+		[X86_TRAP_UD] = exc_invalid_op,
+		[X86_TRAP_NM] = exc_device_not_available,
+		[X86_TRAP_DF] = fred_exc_double_fault,
+		[X86_TRAP_OLD_MF] = fred_bad_event, /* 387 only! */
+		[X86_TRAP_TS] = fred_exc_invalid_tss,
+		[X86_TRAP_NP] = fred_exc_segment_not_present,
+		[X86_TRAP_SS] = fred_exc_stack_segment,
+		[X86_TRAP_GP] = fred_exc_general_protection,
+		[X86_TRAP_PF] = fred_exc_page_fault,
+		[X86_TRAP_SPURIOUS] = fred_bad_event, /* Interrupts are their own event type */
+		[X86_TRAP_MF] = exc_coprocessor_error,
+		[X86_TRAP_AC] = fred_exc_alignment_check,
+		[X86_TRAP_MC] = fred_exc_machine_check,
+		[X86_TRAP_XF] = exc_simd_coprocessor_error,
+		[X86_TRAP_VE...NUM_EXCEPTION_VECTORS-1] = fred_bad_event
+	};
+	u8 vector = array_index_nospec((u8)regs->vector, NUM_EXCEPTION_VECTORS);
+
+	exception_handlers[vector](regs);
+}
+
+static __always_inline void fred_emulate_trap(struct pt_regs *regs)
+{
+	regs->type = EVENT_TYPE_SWFAULT;
+	regs->orig_ax = 0;
+	fred_exception(regs);
+}
+
+static __always_inline void fred_emulate_fault(struct pt_regs *regs)
+{
+	regs->ip -= regs->instr_len;
+	fred_emulate_trap(regs);
+}
+
+/*
+ * Emulate SYSENTER if applicable. This is not the preferred system
+ * call in 32-bit mode under FRED, rather int $0x80 is preferred and
+ * exported in the vdso. SYSCALL proper has a hard-coded early out in
+ * fred_entry_from_user().
+ */
+static DEFINE_FRED_HANDLER(fred_syscall_slow)
+{
+	if (IS_ENABLED(CONFIG_IA32_EMULATION) &&
+	    likely(regs->vector == FRED_SYSENTER)) {
+		/* Convert frame to a syscall frame */
+		regs->orig_ax = regs->ax;
+		regs->ax = -ENOSYS;
+		do_fast_syscall_32(regs);
+	} else {
+		regs->vector = X86_TRAP_UD;
+		fred_emulate_fault(regs);
+	}
+}
+
+/*
+ * Some software exceptions can also be triggered as int instructions,
+ * for historical reasons. Implement those here. The performance-critical
+ * int $0x80 (32-bit system call) has a hard-coded early out.
+ */
+static DEFINE_FRED_HANDLER(fred_sw_interrupt_user)
+{
+	if (likely(regs->vector == IA32_SYSCALL_VECTOR)) {
+		/* Convert frame to a syscall frame */
+		regs->orig_ax = regs->ax;
+		regs->ax = -ENOSYS;
+		return do_int80_syscall_32(regs);
+	}
+
+	switch (regs->vector) {
+	case X86_TRAP_BP:
+	case X86_TRAP_OF:
+		fred_emulate_trap(regs);
+		break;
+	default:
+		regs->vector = X86_TRAP_GP;
+		fred_emulate_fault(regs);
+		break;
+	}
+}
+
+static DEFINE_FRED_HANDLER(fred_hw_interrupt)
+{
+	irqentry_state_t state = irqentry_enter(regs);
+
+	instrumentation_begin();
+	external_interrupt(regs, regs->vector);
+	instrumentation_end();
+	irqentry_exit(regs, state);
+}
+
+__visible noinstr void fred_entry_from_user(struct pt_regs *regs)
+{
+	static const fred_handler user_handlers[FRED_EVENT_TYPE_COUNT] =
+	{
+		[EVENT_TYPE_HWINT]	= fred_hw_interrupt,
+		[EVENT_TYPE_RESERVED]	= fred_bad_event,
+		[EVENT_TYPE_NMI]	= fred_exc_nmi,
+		[EVENT_TYPE_SWINT]	= fred_sw_interrupt_user,
+		[EVENT_TYPE_HWFAULT]	= fred_exception,
+		[EVENT_TYPE_SWFAULT]	= fred_exception,
+		[EVENT_TYPE_PRIVSW]	= fred_exception,
+		[EVENT_TYPE_OTHER]	= fred_syscall_slow
+	};
+
+	/*
+	 * FRED employs a two-level event dispatch mechanism, with
+	 * the first-level on the type of an event and the second-level
+	 * on its vector. Thus a dispatch typically induces 2 calls.
+	 * We optimize it by using early outs for the most frequent
+	 * events, and syscalls are the first. We may also need early
+	 * outs for page faults.
+	 */
+	if (likely(regs->type == EVENT_TYPE_OTHER &&
+		   regs->vector == FRED_SYSCALL)) {
+		/* Convert frame to a syscall frame */
+		regs->orig_ax = regs->ax;
+		regs->ax = -ENOSYS;
+		do_syscall_64(regs, regs->orig_ax);
+	} else {
+		/* Not a system call */
+		u8 type = array_index_nospec((u8)regs->type, FRED_EVENT_TYPE_COUNT);
+
+		user_handlers[type](regs);
+	}
+}
+
+static DEFINE_FRED_HANDLER(fred_sw_interrupt_kernel)
+{
+	switch (regs->vector) {
+	case X86_TRAP_NMI:
+		fred_exc_nmi(regs);
+		break;
+	default:
+		fred_bad_event(regs);
+		break;
+	}
+}
+
+__visible noinstr void fred_entry_from_kernel(struct pt_regs *regs)
+{
+	static const fred_handler kernel_handlers[FRED_EVENT_TYPE_COUNT] =
+	{
+		[EVENT_TYPE_HWINT]	= fred_hw_interrupt,
+		[EVENT_TYPE_RESERVED]	= fred_bad_event,
+		[EVENT_TYPE_NMI]	= fred_exc_nmi,
+		[EVENT_TYPE_SWINT]	= fred_sw_interrupt_kernel,
+		[EVENT_TYPE_HWFAULT]	= fred_exception,
+		[EVENT_TYPE_SWFAULT]	= fred_exception,
+		[EVENT_TYPE_PRIVSW]	= fred_exception,
+		[EVENT_TYPE_OTHER]	= fred_bad_event
+	};
+	u8 type = array_index_nospec((u8)regs->type, FRED_EVENT_TYPE_COUNT);
+
+	/* The pt_regs frame on entry here is an exception frame */
+	kernel_handlers[type](regs);
+}
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 966d720046f1..aec45611d79d 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -82,6 +82,7 @@ static __always_inline void __##func(struct pt_regs *regs)
 #define DECLARE_IDTENTRY_ERRORCODE(vector, func)			\
 	asmlinkage void asm_##func(void);				\
 	asmlinkage void xen_asm_##func(void);				\
+	__visible void fred_##func(struct pt_regs *regs);		\
 	__visible void func(struct pt_regs *regs, unsigned long error_code)
 
 /**
@@ -106,6 +107,11 @@ __visible noinstr void func(struct pt_regs *regs,			\
 	irqentry_exit(regs, state);					\
 }									\
 									\
+__visible noinstr void fred_##func(struct pt_regs *regs)		\
+{									\
+	func (regs, regs->orig_ax);					\
+}									\
+									\
 static __always_inline void __##func(struct pt_regs *regs,		\
 				     unsigned long error_code)
 
@@ -616,6 +622,8 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	exc_machine_check);
 #ifdef CONFIG_XEN_PV
 DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	xenpv_exc_machine_check);
 #endif
+#else
+#define fred_exc_machine_check		fred_bad_event
 #endif
 
 /* NMI */
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 366b1675c033..77ffc580e821 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -58,4 +58,6 @@ typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
 
 int exc_raise_irq(struct pt_regs *regs, u32 vector);
 
+int external_interrupt(struct pt_regs *regs, unsigned int vector);
+
 #endif /* _ASM_X86_TRAPS_H */
-- 
2.34.1

