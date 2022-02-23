Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CBB4C0BAE
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbiBWFY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiBWFYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:22 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CEF694AF
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:55 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d07ae11464so162250937b3.14
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kBbjpsiAT8t80DB/Hae/sSQvzOy4duVi7ttnmtZT7iU=;
        b=cvWzSg8yZgLUgWZKUIjW5TSN+BW3VTrtVOKpGEnHmCq9LFApxaz2ug4Y6Y4TweNu1W
         f9E1LiZV7paz48nIFQ58vfAnH1K6o0bvbWTXyZRNy2eoNt9EF9GseVfZcFrpOMpaAZsv
         YfeUwK9fKdGDUIC+bPsLXVrJ/dI3zlbx7hzpBmIG2MmUKT7no3dFhQFnuWlscR6nzDpw
         D94zRcBAw6obzNOLADy5DNW08Hz9FTyO1IWbrJxXtBCcNGZOBsCLR5Y7BX69Ut6ugHh9
         /ICUNuePn6v0tNGb7si9lPoIGDB/04KZ4aNfI9KEiCrUUlX4abSfJJXZ09+2AJGxuoWO
         1yZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kBbjpsiAT8t80DB/Hae/sSQvzOy4duVi7ttnmtZT7iU=;
        b=Ppv9iljdcW233TAKL76X4g0GNueKDUK7SkZ6rVXjlk5IylC+0q+TO8VGAE7xiX1pDE
         LmU409/KzLoXDw911Sv8OC5Y7VpybsDoWpxkyOyPMSYTnm9caBMSiCGVxWSF2Qbxf1KQ
         tXcGydVjjNkDDRAohZ9ex35VsQV87bCaibnSfH0tdmiHna1KaVQtqylfAceUKdIVMVq5
         HhN1d2ursHfD0Ss32z92/+yCW4aHckFrRlDKnQ3FBV8WT+2Sa/C6RBplyKIcLFIAOFPB
         tj6gYrShoWM0foy0HJai/aCUl8Ho6ov3dc/s5ovbebbOv7UMUy4Z+KuB5mokTHEHkos9
         GtWQ==
X-Gm-Message-State: AOAM530LJQGtTahwLuCsJ2vUmogLHiNO9qLhD7l94UN2oZ/EGdMeDV7b
        ztRGSHKp7fnt+Ba2tPhh5Hpz9La3Iw1s
X-Google-Smtp-Source: ABdhPJyBLtJwVHx/eQ2H1TXtGc5CWguV1DYKie3D2boh+nhOh7RhoskWr4B/mahF4dAK4TfkpcUJJeAOMAIF
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a05:6902:1ca:b0:624:e2a1:2856 with SMTP id
 u10-20020a05690201ca00b00624e2a12856mr4238491ybh.389.1645593834551; Tue, 22
 Feb 2022 21:23:54 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:40 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-5-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 04/47] mm: asi: ASI support in interrupts/exceptions
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for potentially switching address spaces from within
interrupts/exceptions/NMIs etc. An interrupt does not automatically
switch to the unrestricted address space. It can switch if needed to
access some memory not available in the restricted address space, using
the normal asi_exit call.

On return from the outermost interrupt, if the target address space was
the restricted address space (e.g. we were in the critical code path
between ASI Enter and VM Enter), the restricted address space will be
automatically restored. Otherwise, execution will continue in the
unrestricted address space until the next explicit ASI Enter.

In order to keep track of when to restore the restricted address space,
an interrupt/exception nesting depth counter is maintained per-task.
An alternative implementation without needing this counter is also
possible, but the counter unlocks an additional nice-to-have benefit by
allowing detection of whether or not we are currently executing inside
an exception context, which would be useful in a later patch.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h       | 35 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/idtentry.h  | 25 +++++++++++++++++++++--
 arch/x86/include/asm/processor.h |  5 +++++
 arch/x86/kernel/process.c        |  2 ++
 arch/x86/kernel/traps.c          |  2 ++
 arch/x86/mm/asi.c                |  3 ++-
 kernel/entry/common.c            |  6 ++++++
 7 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 0a4af23ed0eb..7702332c62e8 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -4,6 +4,8 @@
 
 #include <asm-generic/asi.h>
 
+#include <linux/sched.h>
+
 #include <asm/pgtable_types.h>
 #include <asm/percpu.h>
 #include <asm/cpufeature.h>
@@ -51,6 +53,11 @@ void asi_destroy(struct asi *asi);
 void asi_enter(struct asi *asi);
 void asi_exit(void);
 
+static inline void asi_init_thread_state(struct thread_struct *thread)
+{
+	thread->intr_nest_depth = 0;
+}
+
 static inline void asi_set_target_unrestricted(void)
 {
 	if (static_cpu_has(X86_FEATURE_ASI)) {
@@ -85,6 +92,34 @@ static inline bool asi_is_target_unrestricted(void)
 
 #define static_asi_enabled() cpu_feature_enabled(X86_FEATURE_ASI)
 
+static inline void asi_intr_enter(void)
+{
+	if (static_cpu_has(X86_FEATURE_ASI)) {
+		current->thread.intr_nest_depth++;
+		barrier();
+	}
+}
+
+static inline void asi_intr_exit(void)
+{
+	void __asi_enter(void);
+
+	if (static_cpu_has(X86_FEATURE_ASI)) {
+		barrier();
+
+		if (--current->thread.intr_nest_depth == 0)
+			__asi_enter();
+	}
+}
+
+#else	/* CONFIG_ADDRESS_SPACE_ISOLATION */
+
+static inline void asi_intr_enter(void) { }
+
+static inline void asi_intr_exit(void) { }
+
+static inline void asi_init_thread_state(struct thread_struct *thread) { }
+
 #endif	/* CONFIG_ADDRESS_SPACE_ISOLATION */
 
 #endif
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 1345088e9902..ea5cdc90403d 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -10,6 +10,7 @@
 #include <linux/hardirq.h>
 
 #include <asm/irq_stack.h>
+#include <asm/asi.h>
 
 /**
  * DECLARE_IDTENTRY - Declare functions for simple IDT entry points
@@ -133,7 +134,16 @@ static __always_inline void __##func(struct pt_regs *regs,		\
  * is required before the enter/exit() helpers are invoked.
  */
 #define DEFINE_IDTENTRY_RAW(func)					\
-__visible noinstr void func(struct pt_regs *regs)
+static __always_inline void __##func(struct pt_regs *regs);		\
+									\
+__visible noinstr void func(struct pt_regs *regs)			\
+{									\
+	asi_intr_enter();						\
+	__##func (regs);						\
+	asi_intr_exit();						\
+}									\
+									\
+static __always_inline void __##func(struct pt_regs *regs)
 
 /**
  * DECLARE_IDTENTRY_RAW_ERRORCODE - Declare functions for raw IDT entry points
@@ -161,7 +171,18 @@ __visible noinstr void func(struct pt_regs *regs)
  * is required before the enter/exit() helpers are invoked.
  */
 #define DEFINE_IDTENTRY_RAW_ERRORCODE(func)				\
-__visible noinstr void func(struct pt_regs *regs, unsigned long error_code)
+static __always_inline void __##func(struct pt_regs *regs,		\
+				     unsigned long error_code);		\
+									\
+__visible noinstr void func(struct pt_regs *regs, unsigned long error_code)\
+{									\
+	asi_intr_enter();						\
+	__##func (regs, error_code);					\
+	asi_intr_exit();						\
+}									\
+									\
+static __always_inline void __##func(struct pt_regs *regs,		\
+				     unsigned long error_code)
 
 /**
  * DECLARE_IDTENTRY_IRQ - Declare functions for device interrupt IDT entry
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 355d38c0cf60..20116efd2756 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -519,6 +519,11 @@ struct thread_struct {
 	unsigned int		iopl_warn:1;
 	unsigned int		sig_on_uaccess_err:1;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/* The nesting depth of exceptions/interrupts */
+	int			intr_nest_depth;
+#endif
+
 	/*
 	 * Protection Keys Register for Userspace.  Loaded immediately on
 	 * context switch. Store it in thread_struct to avoid a lookup in
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 04143a653a8a..c8d4a00a4de7 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -90,6 +90,8 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 #ifdef CONFIG_VM86
 	dst->thread.vm86 = NULL;
 #endif
+	asi_init_thread_state(&dst->thread);
+
 	/* Drop the copied pointer to current's fpstate */
 	dst->thread.fpu.fpstate = NULL;
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c9d566dcf89a..acf675ddda96 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
 #include <asm/vdso.h>
+#include <asm/asi.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -413,6 +414,7 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 	}
 #endif
 
+	asi_exit();
 	irqentry_nmi_enter(regs);
 	instrumentation_begin();
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index d274c86f89b7..2453124f221d 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -107,12 +107,13 @@ void asi_destroy(struct asi *asi)
 }
 EXPORT_SYMBOL_GPL(asi_destroy);
 
-static void __asi_enter(void)
+void __asi_enter(void)
 {
 	u64 asi_cr3;
 	struct asi *target = this_cpu_read(asi_cpu_state.target_asi);
 
 	VM_BUG_ON(preemptible());
+	VM_BUG_ON(current->thread.intr_nest_depth != 0);
 
 	if (!target || target == this_cpu_read(asi_cpu_state.curr_asi))
 		return;
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index d5a61d565ad5..9064253085c7 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -9,6 +9,8 @@
 
 #include "common.h"
 
+#include <asm/asi.h>
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
 
@@ -321,6 +323,8 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
 		.exit_rcu = false,
 	};
 
+	asi_intr_enter();
+
 	if (user_mode(regs)) {
 		irqentry_enter_from_user_mode(regs);
 		return ret;
@@ -416,6 +420,7 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
 			instrumentation_end();
 			rcu_irq_exit();
 			lockdep_hardirqs_on(CALLER_ADDR0);
+			asi_intr_exit();
 			return;
 		}
 
@@ -438,6 +443,7 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
 		if (state.exit_rcu)
 			rcu_irq_exit();
 	}
+	asi_intr_exit();
 }
 
 irqentry_state_t noinstr irqentry_nmi_enter(struct pt_regs *regs)
-- 
2.35.1.473.g83b2b277ed-goog

