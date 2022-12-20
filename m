Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952F2651B24
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 08:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiLTHCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 02:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiLTHBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 02:01:43 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D6615FF0;
        Mon, 19 Dec 2022 23:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671519698; x=1703055698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hb71FjnS4IGfRJOJBzO+RW509BXu1SCIOAS8RAhI6Mo=;
  b=hK/pFesHsVnEbL2DNbR9Tc9yzKDuFyfR335gpxcyy7EFSxwiOLHfA+yv
   bcFogcs12MCajbG/CeSF/20dIwSV/UPgkRyu82QNTG+sfoDyfk1ogb86o
   XG1/YE2zfmIFbuBp7UpUh7fEJMrmHcouTwg2F9RISCt5WT5ywN7UmMDtT
   5YBVu3pFJfx6y8m0M0H6TBeR/Sv2kT6XI767Zb3ab7V377sV7HtomMivZ
   26N2yGri8nEGDnBgZ3R5v3RsJ0yCvSDEc9Tm1F5a/lstE1JhtcfjyNBfS
   iwFv+vBzvvVNzboYjiaELH/sAo27XAAu2t10G4NFVckoJbKcD7OgdptFQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="302972090"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="302972090"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:01:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="644326513"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="644326513"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga007.jf.intel.com with ESMTP; 19 Dec 2022 23:01:16 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH 21/32] x86/fred: FRED entry/exit and dispatch code
Date:   Mon, 19 Dec 2022 22:36:47 -0800
Message-Id: <20221220063658.19271-22-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220063658.19271-1-xin3.li@intel.com>
References: <20221220063658.19271-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
- entry_fred.c contains the event multi-level dispatch code for FRED.
  The two-level dispatch is on the event type, and the second-level
  is on the event vector.

Some event handlers, #DB/#BP/#DF/#PF/#MC/#UD, start instrumentation
in their own ways. Dave Hansen suggested to use an exception bitmap
for the checking whether to start instrumentation in the exception
dispatch framework.

Originally-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/Makefile         |   5 +-
 arch/x86/entry/entry_64_fred.S  |  55 +++++++
 arch/x86/entry/entry_fred.c     | 270 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/idtentry.h |   2 +
 arch/x86/include/asm/traps.h    |   2 +
 5 files changed, 333 insertions(+), 1 deletion(-)
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
index 000000000000..56814ab0b825
--- /dev/null
+++ b/arch/x86/entry/entry_fred.c
@@ -0,0 +1,270 @@
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
+#define DEFINE_FRED_EXCEPTION_HANDLER(func)			\
+static void fred_##func(struct pt_regs *regs)			\
+{								\
+	func (regs);						\
+}
+
+DEFINE_FRED_EXCEPTION_HANDLER(exc_divide_error);
+DEFINE_FRED_EXCEPTION_HANDLER(exc_overflow);
+DEFINE_FRED_EXCEPTION_HANDLER(exc_bounds);
+DEFINE_FRED_EXCEPTION_HANDLER(exc_device_not_available);
+DEFINE_FRED_EXCEPTION_HANDLER(exc_coprocessor_error);
+DEFINE_FRED_EXCEPTION_HANDLER(exc_simd_coprocessor_error);
+
+#define DEFINE_FRED_EXCEPTION_HANDLER_ERRORCODE(func)		\
+static void fred_##func(struct pt_regs *regs)			\
+{								\
+	func (regs, regs->orig_ax);				\
+}
+
+DEFINE_FRED_EXCEPTION_HANDLER_ERRORCODE(exc_invalid_tss);
+DEFINE_FRED_EXCEPTION_HANDLER_ERRORCODE(exc_segment_not_present);
+noinstr DEFINE_FRED_EXCEPTION_HANDLER_ERRORCODE(exc_double_fault);
+DEFINE_FRED_EXCEPTION_HANDLER_ERRORCODE(exc_stack_segment);
+DEFINE_FRED_EXCEPTION_HANDLER_ERRORCODE(exc_general_protection);
+DEFINE_FRED_EXCEPTION_HANDLER_ERRORCODE(exc_alignment_check);
+
+/*
+ * Exception entry
+ */
+static DEFINE_FRED_HANDLER(fred_exception)
+{
+	/*
+	 * This intentially omits exceptions that cannot happen on FRED h/w:
+	 * vectors _NOT_ listed are set to NULL.
+	 */
+	static const fred_handler exception_handlers[NUM_EXCEPTION_VECTORS] = {
+		[X86_TRAP_DE] = fred_exc_divide_error,
+		[X86_TRAP_DB] = fred_exc_debug,
+		[X86_TRAP_NMI] = NULL, /* A separate event type, not handled here */
+		[X86_TRAP_BP] = exc_int3,
+		[X86_TRAP_OF] = fred_exc_overflow,
+		[X86_TRAP_BR] = fred_exc_bounds,
+		[X86_TRAP_UD] = exc_invalid_op,
+		[X86_TRAP_NM] = fred_exc_device_not_available,
+		[X86_TRAP_DF] = fred_exc_double_fault,
+		[X86_TRAP_OLD_MF] = NULL, /* 387 only! */
+		[X86_TRAP_TS] = fred_exc_invalid_tss,
+		[X86_TRAP_NP] = fred_exc_segment_not_present,
+		[X86_TRAP_SS] = fred_exc_stack_segment,
+		[X86_TRAP_GP] = fred_exc_general_protection,
+		[X86_TRAP_PF] = fred_exc_page_fault,
+		[X86_TRAP_SPURIOUS] = NULL, /* Interrupts are their own event type */
+		[X86_TRAP_MF] = fred_exc_coprocessor_error,
+		[X86_TRAP_AC] = fred_exc_alignment_check,
+		[X86_TRAP_MC] = fred_exc_machine_check,
+		[X86_TRAP_XF] = fred_exc_simd_coprocessor_error
+	};
+	static const u32 noinstr_mask = BIT(X86_TRAP_DB) | BIT(X86_TRAP_BP) |
+					BIT(X86_TRAP_DF) | BIT(X86_TRAP_PF) |
+					BIT(X86_TRAP_MC) | BIT(X86_TRAP_UD);
+	u8 vector = array_index_nospec((u8)regs->vector, NUM_EXCEPTION_VECTORS);
+	irqentry_state_t state;
+
+	if (likely(exception_handlers[vector])) {
+		if (!(BIT(vector) & noinstr_mask)) {
+			state = irqentry_enter(regs);
+			instrumentation_begin();
+		}
+
+		exception_handlers[vector](regs);
+
+		if (!(BIT(vector) & noinstr_mask)) {
+			instrumentation_end();
+			irqentry_exit(regs, state);
+		}
+	} else {
+		return fred_bad_event(regs);
+	}
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
index 966d720046f1..5b3b8402e0c5 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -616,6 +616,8 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	exc_machine_check);
 #ifdef CONFIG_XEN_PV
 DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	xenpv_exc_machine_check);
 #endif
+#else
+#define fred_exc_machine_check		(NULL)
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

