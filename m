Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F09565FDBA
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbjAFJWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjAFJU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:28 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4EA6B59C;
        Fri,  6 Jan 2023 01:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996827; x=1704532827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4WhS6qbl4v4SUQZIQxhNnh0VxQyeKO3B401EDCjjATg=;
  b=M8SPOYqu+aQEqpf4vDu0In9o1NxsY+Yo9OMSF/PPSgQ89OH3S7hNrmoN
   c7OKaNcJhS5RaJF6KFpAy2dsfys99RbLHQZLG5O0spB+vH3FZjz+de+UJ
   r3RLmU5be8lZPHN3ZsJjsuaoDwAukgnwH4RIif76+MtoNEbTy4nGtQJPx
   6b6bFZ73NEuwKBoxrDy/x6yFeb7YZcTRoCeAHL78U9J5tAXACF1ok00lc
   jeJwdtNdv3wToHjOucSKRRSavOVViLODZ/c8wyKFZ8QdBdDa1FE9Sks22
   aeiqK9nnhkQfMMCbJWghIcpVunBgdIjJJ0p4nq2pE8yX0ERRrHtSCkbaq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511658"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511658"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139469"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139469"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:18 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 31/32] x86/fred: allow dynamic stack frame size
Date:   Fri,  6 Jan 2023 00:56:16 -0800
Message-Id: <20230106085617.17248-32-xin3.li@intel.com>
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

A FRED stack frame could contain different amount of information for
different event types, or perhaps even for different instances of the
same event type. Thus we need to eliminate the need of any advance
information of the stack frame size to allow dynamic stack frame size.

Implement it through:
  1) add a new field user_pt_regs to thread_info, and initialize it
     with a pointer to a virtual pt_regs structure at the top of a
     thread stack.
  2) save a pointer to the user-space pt_regs structure created by
     fred_entrypoint_user() to user_pt_regs in fred_entry_from_user().
  3) initialize the init_thread_info's user_pt_regs with a pointer to
     a virtual pt_regs structure at the top of init stack.

This approach also works for IDT, thus we unify the code.

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/entry_32.S           |  2 +-
 arch/x86/entry/entry_fred.c         |  2 ++
 arch/x86/include/asm/entry-common.h |  3 +++
 arch/x86/include/asm/processor.h    | 12 +++------
 arch/x86/include/asm/switch_to.h    |  3 +--
 arch/x86/include/asm/thread_info.h  | 41 ++++-------------------------
 arch/x86/kernel/head_32.S           |  3 +--
 arch/x86/kernel/process.c           |  5 ++++
 kernel/fork.c                       |  6 +++++
 9 files changed, 27 insertions(+), 50 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index e309e7156038..d98cc64ca82b 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1244,7 +1244,7 @@ SYM_CODE_START(rewind_stack_and_make_dead)
 	xorl	%ebp, %ebp
 
 	movl	PER_CPU_VAR(cpu_current_top_of_stack), %esi
-	leal	-TOP_OF_KERNEL_STACK_PADDING-PTREGS_SIZE(%esi), %esp
+	leal	-PTREGS_SIZE(%esi), %esp
 
 	call	make_task_dead
 1:	jmp 1b
diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index 61d12c152a37..980954e9091e 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -177,6 +177,8 @@ __visible noinstr void fred_entry_from_user(struct pt_regs *regs)
 		[EVENT_TYPE_OTHER]	= fred_syscall_slow
 	};
 
+	current->thread_info.user_pt_regs = regs;
+
 	/*
 	 * FRED employs a two-level event dispatch mechanism, with
 	 * the first-level on the type of an event and the second-level
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index 674ed46d3ced..21e1e3ef9e33 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -12,6 +12,9 @@
 /* Check that the stack and regs on entry from user mode are sane. */
 static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs)
 {
+	if (!cpu_feature_enabled(X86_FEATURE_FRED))
+		current->thread_info.user_pt_regs = regs;
+
 	if (IS_ENABLED(CONFIG_DEBUG_ENTRY)) {
 		/*
 		 * Make sure that the entry code gave us a sensible EFLAGS
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 67c9d73b31fa..6d573eeea074 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -747,17 +747,11 @@ static inline void spin_lock_prefetch(const void *x)
 	prefetchw(x);
 }
 
-#define TOP_OF_INIT_STACK ((unsigned long)&init_stack + sizeof(init_stack) - \
-			   TOP_OF_KERNEL_STACK_PADDING)
+#define TOP_OF_INIT_STACK ((unsigned long)&init_stack + sizeof(init_stack))
 
-#define task_top_of_stack(task) ((unsigned long)(task_pt_regs(task) + 1))
+#define task_top_of_stack(task) ((unsigned long)task_stack_page(task) + THREAD_SIZE)
 
-#define task_pt_regs(task) \
-({									\
-	unsigned long __ptr = (unsigned long)task_stack_page(task);	\
-	__ptr += THREAD_SIZE - TOP_OF_KERNEL_STACK_PADDING;		\
-	((struct pt_regs *)__ptr) - 1;					\
-})
+#define task_pt_regs(task) ((task)->thread_info.user_pt_regs)
 
 #ifdef CONFIG_X86_32
 #define INIT_THREAD  {							  \
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 499c6a701558..484899a3fbb8 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -75,8 +75,7 @@ static inline void update_task_stack(struct task_struct *task)
 		/*
 		 * Will use WRMSRNS/WRMSRLIST for performance once it's upstreamed.
 		 */
-		wrmsrl(MSR_IA32_FRED_RSP0,
-		       task_top_of_stack(task) + TOP_OF_KERNEL_STACK_PADDING);
+		wrmsrl(MSR_IA32_FRED_RSP0, task_top_of_stack(task));
 	} else if (static_cpu_has(X86_FEATURE_XENPV)) {
 		/* Xen PV enters the kernel on the thread stack. */
 		load_sp0(task_top_of_stack(task));
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fea0e69fc3d4..9b88b7a04fda 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -13,42 +13,6 @@
 #include <asm/percpu.h>
 #include <asm/types.h>
 
-/*
- * TOP_OF_KERNEL_STACK_PADDING is a number of unused bytes that we
- * reserve at the top of the kernel stack.  We do it because of a nasty
- * 32-bit corner case.  On x86_32, the hardware stack frame is
- * variable-length.  Except for vm86 mode, struct pt_regs assumes a
- * maximum-length frame.  If we enter from CPL 0, the top 8 bytes of
- * pt_regs don't actually exist.  Ordinarily this doesn't matter, but it
- * does in at least one case:
- *
- * If we take an NMI early enough in SYSENTER, then we can end up with
- * pt_regs that extends above sp0.  On the way out, in the espfix code,
- * we can read the saved SS value, but that value will be above sp0.
- * Without this offset, that can result in a page fault.  (We are
- * careful that, in this case, the value we read doesn't matter.)
- *
- * In vm86 mode, the hardware frame is much longer still, so add 16
- * bytes to make room for the real-mode segments.
- *
- * x86-64 has a fixed-length stack frame, but it depends on whether
- * or not FRED is enabled. Future versions of FRED might make this
- * dynamic, but for now it is always 2 words longer.
- */
-#ifdef CONFIG_X86_32
-# ifdef CONFIG_VM86
-#  define TOP_OF_KERNEL_STACK_PADDING 16
-# else
-#  define TOP_OF_KERNEL_STACK_PADDING 8
-# endif
-#else /* x86-64 */
-# ifdef CONFIG_X86_FRED
-#  define TOP_OF_KERNEL_STACK_PADDING (2*8)
-# else
-#  define TOP_OF_KERNEL_STACK_PADDING 0
-# endif
-#endif
-
 /*
  * low level task data that entry.S needs immediate access to
  * - this struct should fit entirely inside of one cache line
@@ -56,6 +20,7 @@
  */
 #ifndef __ASSEMBLY__
 struct task_struct;
+struct pt_regs;
 #include <asm/cpufeature.h>
 #include <linux/atomic.h>
 
@@ -66,11 +31,14 @@ struct thread_info {
 #ifdef CONFIG_SMP
 	u32			cpu;		/* current CPU */
 #endif
+	struct pt_regs		*user_pt_regs;
 };
 
+#define INIT_TASK_PT_REGS ((struct pt_regs *)TOP_OF_INIT_STACK - 1)
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.flags		= 0,			\
+	.user_pt_regs   = INIT_TASK_PT_REGS,	\
 }
 
 #else /* !__ASSEMBLY__ */
@@ -235,6 +203,7 @@ static inline int arch_within_stack_frames(const void * const stack,
 
 extern void arch_task_cache_init(void);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
+extern void arch_init_user_pt_regs(struct task_struct *tsk);
 extern void arch_release_task_struct(struct task_struct *tsk);
 extern void arch_setup_new_exec(void);
 #define arch_setup_new_exec arch_setup_new_exec
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 9b7acc9c7874..8961946f1418 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -539,8 +539,7 @@ SYM_DATA_END(initial_page_table)
  * reliably detect the end of the stack.
  */
 SYM_DATA(initial_stack,
-		.long init_thread_union + THREAD_SIZE -
-		SIZEOF_PTREGS - TOP_OF_KERNEL_STACK_PADDING)
+		.long init_thread_union + THREAD_SIZE - SIZEOF_PTREGS)
 
 __INITRODATA
 int_msg:
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e436c9c1ef3b..6294d41f7691 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -97,6 +97,11 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	return 0;
 }
 
+void arch_init_user_pt_regs(struct task_struct *tsk)
+{
+	tsk->thread_info.user_pt_regs = (struct pt_regs *)task_top_of_stack(tsk)- 1;
+}
+
 #ifdef CONFIG_X86_64
 void arch_release_task_struct(struct task_struct *tsk)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 08969f5aa38d..00bd585a4e07 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -948,6 +948,10 @@ int __weak arch_dup_task_struct(struct task_struct *dst,
 	return 0;
 }
 
+void __weak arch_init_user_pt_regs(struct task_struct *tsk)
+{
+}
+
 void set_task_stack_end_magic(struct task_struct *tsk)
 {
 	unsigned long *stackend;
@@ -975,6 +979,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	if (err)
 		goto free_tsk;
 
+	arch_init_user_pt_regs(tsk);
+
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	refcount_set(&tsk->stack_refcount, 1);
 #endif
-- 
2.34.1

