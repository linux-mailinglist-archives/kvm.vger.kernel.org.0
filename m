Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9589B5828A9
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 16:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiG0O3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 10:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiG0O3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 10:29:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BC22CCA0
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76169B8218B
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 14:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F3AC433B5;
        Wed, 27 Jul 2022 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658932166;
        bh=9QA2eJFZn7Z14hUM93N7E339uHJnB8TKHbt4CPdZhqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2FwILbQQ/3GRYs+WLHVWr2/UJ7KI22BKRbtYW17RMIvpPoMTKErvC9Ngh69xFwYE
         9L7xBFl7vWw6oALjsTdZ4ubXTfWnCFeIs0CDa7IWv9Ao5944d2OGLMMMiuEDl/GQHr
         fY8qJzQk/JkdaZx/D8kPN+yfyPc33nQH1iXYxpCoV3ZSBS5PK7wkO3AYPjhRbCFT1g
         nh4q7MQhLYqLD2ZaxLINwljoTJNjlaGBIfFXdpE38rDhmWwNuFtDUF+6LXd0zSeAQj
         Ewk8iMMCixQ2+djQfssWRVx6xUescCY0SfULzqIVBwQg8DRYA4xqSjo7TvHD1qS6UF
         3P2soekPWp/xw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oGi2N-00APjL-PY;
        Wed, 27 Jul 2022 15:29:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, broonie@kernel.org,
        madvenka@linux.microsoft.com, tabba@google.com,
        oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
        elver@google.com, keirf@google.com, yuzenghui@huawei.com,
        ardb@kernel.org, oupton@google.com, kernel-team@android.com
Subject: [PATCH 3/6] KVM: arm64: Make unwind()/on_accessible_stack() per-unwinder functions
Date:   Wed, 27 Jul 2022 15:29:03 +0100
Message-Id: <20220727142906.1856759-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220727142906.1856759-1-maz@kernel.org>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
 <20220727142906.1856759-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com, broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com, mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com, elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Having multiple versions of on_accessible_stack() (one per unwinder)
makes it very hard to reason about what is used where due to the
complexity of the various includes, the forward declarations, and
the reliance on everything being 'inline'.

Instead, move the code back where it should be. Each unwinder
implements:

- on_accessible_stack() as well as the helpers it depends on,

- unwind()/unwind_next(), as they pass on_accessible_stack as
  a parameter to unwind_next_common() (which is the only common
  code here)

This hardly results in any duplication, and makes it much
easier to reason about the code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/stacktrace.h        | 74 ------------------
 arch/arm64/include/asm/stacktrace/common.h | 55 ++++---------
 arch/arm64/include/asm/stacktrace/nvhe.h   | 84 +-------------------
 arch/arm64/kernel/stacktrace.c             | 90 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/stacktrace.c       | 52 +++++++++++++
 arch/arm64/kvm/stacktrace.c                | 55 +++++++++++++
 6 files changed, 213 insertions(+), 197 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index ea828579a98b..6ebdcdff77f5 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -57,78 +57,4 @@ static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
 			struct stack_info *info) { return false; }
 #endif
 
-
-/*
- * We can only safely access per-cpu stacks from current in a non-preemptible
- * context.
- */
-static inline bool on_accessible_stack(const struct task_struct *tsk,
-				       unsigned long sp, unsigned long size,
-				       struct stack_info *info)
-{
-	if (on_accessible_stack_common(tsk, sp, size, info))
-		return true;
-
-	if (on_task_stack(tsk, sp, size, info))
-		return true;
-	if (tsk != current || preemptible())
-		return false;
-	if (on_irq_stack(sp, size, info))
-		return true;
-	if (on_sdei_stack(sp, size, info))
-		return true;
-
-	return false;
-}
-
-/*
- * Unwind from one frame record (A) to the next frame record (B).
- *
- * We terminate early if the location of B indicates a malformed chain of frame
- * records (e.g. a cycle), determined based on the location and fp value of A
- * and the location (but not the fp value) of B.
- */
-static inline int notrace unwind_next(struct unwind_state *state)
-{
-	struct task_struct *tsk = state->task;
-	unsigned long fp = state->fp;
-	struct stack_info info;
-	int err;
-
-	/* Final frame; nothing to unwind */
-	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
-		return -ENOENT;
-
-	err = unwind_next_common(state, &info, NULL);
-	if (err)
-		return err;
-
-	state->pc = ptrauth_strip_insn_pac(state->pc);
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	if (tsk->ret_stack &&
-		(state->pc == (unsigned long)return_to_handler)) {
-		unsigned long orig_pc;
-		/*
-		 * This is a case where function graph tracer has
-		 * modified a return address (LR) in a stack frame
-		 * to hook a function return.
-		 * So replace it to an original value.
-		 */
-		orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
-						(void *)state->fp);
-		if (WARN_ON_ONCE(state->pc == orig_pc))
-			return -EINVAL;
-		state->pc = orig_pc;
-	}
-#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-#ifdef CONFIG_KRETPROBES
-	if (is_kretprobe_trampoline(state->pc))
-		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
-#endif
-
-	return 0;
-}
-NOKPROBE_SYMBOL(unwind_next);
-
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 3ebb69ea374a..18046a7248a2 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -79,15 +79,6 @@ struct unwind_state {
 	struct task_struct *task;
 };
 
-static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
-				     struct stack_info *info);
-
-static inline bool on_accessible_stack(const struct task_struct *tsk,
-				       unsigned long sp, unsigned long size,
-				       struct stack_info *info);
-
-static inline int unwind_next(struct unwind_state *state);
-
 static inline bool on_stack(unsigned long sp, unsigned long size,
 			    unsigned long low, unsigned long high,
 			    enum stack_type type, struct stack_info *info)
@@ -106,21 +97,6 @@ static inline bool on_stack(unsigned long sp, unsigned long size,
 	return true;
 }
 
-static inline bool on_accessible_stack_common(const struct task_struct *tsk,
-					      unsigned long sp,
-					      unsigned long size,
-					      struct stack_info *info)
-{
-	if (info)
-		info->type = STACK_TYPE_UNKNOWN;
-
-	/*
-	 * Both the kernel and nvhe hypervisor make use of
-	 * an overflow_stack
-	 */
-	return on_overflow_stack(sp, size, info);
-}
-
 static inline void unwind_init_common(struct unwind_state *state,
 				      struct task_struct *task)
 {
@@ -156,8 +132,22 @@ static inline void unwind_init_common(struct unwind_state *state,
 typedef bool (*stack_trace_translate_fp_fn)(unsigned long *fp,
 					    enum stack_type type);
 
+/*
+ * on_accessible_stack_fn() - Check whether a stack range is on any
+ * of the possible stacks.
+ *
+ * @tsk:  task whose stack is being unwound
+ * @sp:   stack address being checked
+ * @size: size of the stack range being checked
+ * @info: stack unwinding context
+ */
+typedef bool (*on_accessible_stack_fn)(const struct task_struct *tsk,
+				       unsigned long sp, unsigned long size,
+				       struct stack_info *info);
+
 static inline int unwind_next_common(struct unwind_state *state,
 				     struct stack_info *info,
+				     on_accessible_stack_fn accessible,
 				     stack_trace_translate_fp_fn translate_fp)
 {
 	unsigned long fp = state->fp, kern_fp = fp;
@@ -166,7 +156,7 @@ static inline int unwind_next_common(struct unwind_state *state,
 	if (fp & 0x7)
 		return -EINVAL;
 
-	if (!on_accessible_stack(tsk, fp, 16, info))
+	if (!accessible(tsk, fp, 16, info))
 		return -EINVAL;
 
 	if (test_bit(info->type, state->stacks_done))
@@ -212,19 +202,4 @@ static inline int unwind_next_common(struct unwind_state *state,
 	return 0;
 }
 
-static inline void notrace unwind(struct unwind_state *state,
-				  stack_trace_consume_fn consume_entry,
-				  void *cookie)
-{
-	while (1) {
-		int ret;
-
-		if (!consume_entry(cookie, state->pc))
-			break;
-		ret = unwind_next(state);
-		if (ret < 0)
-			break;
-	}
-}
-NOKPROBE_SYMBOL(unwind);
 #endif	/* __ASM_STACKTRACE_COMMON_H */
diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 8a5cb96d7143..a096216d8970 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -37,59 +37,7 @@ static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
 	state->pc = pc;
 }
 
-static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
-				struct stack_info *info);
-
-static inline bool on_accessible_stack(const struct task_struct *tsk,
-				       unsigned long sp, unsigned long size,
-				       struct stack_info *info)
-{
-	if (on_accessible_stack_common(tsk, sp, size, info))
-		return true;
-
-	if (on_hyp_stack(sp, size, info))
-		return true;
-
-	return false;
-}
-
-#ifdef __KVM_NVHE_HYPERVISOR__
-/*
- * Protected nVHE HYP stack unwinder
- *
- * In protected mode, the unwinding is done by the hypervisor in EL2.
- */
-
-#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
-static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
-				     struct stack_info *info)
-{
-	unsigned long low = (unsigned long)this_cpu_ptr(overflow_stack);
-	unsigned long high = low + OVERFLOW_STACK_SIZE;
-
-	return on_stack(sp, size, low, high, STACK_TYPE_OVERFLOW, info);
-}
-
-static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
-				struct stack_info *info)
-{
-	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
-	unsigned long high = params->stack_hyp_va;
-	unsigned long low = high - PAGE_SIZE;
-
-	return on_stack(sp, size, low, high, STACK_TYPE_HYP, info);
-}
-
-static inline int notrace unwind_next(struct unwind_state *state)
-{
-	struct stack_info info;
-
-	return unwind_next_common(state, &info, NULL);
-}
-NOKPROBE_SYMBOL(unwind_next);
-#endif	/* CONFIG_PROTECTED_NVHE_STACKTRACE */
-
-#else	/* !__KVM_NVHE_HYPERVISOR__ */
+#ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * Conventional (non-protected) nVHE HYP stack unwinder
  *
@@ -142,36 +90,6 @@ static inline bool kvm_nvhe_stack_kern_va(unsigned long *addr,
 	return true;
 }
 
-static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
-				     struct stack_info *info)
-{
-	struct kvm_nvhe_stacktrace_info *stacktrace_info
-				= this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
-	unsigned long low = (unsigned long)stacktrace_info->overflow_stack_base;
-	unsigned long high = low + OVERFLOW_STACK_SIZE;
-
-	return on_stack(sp, size, low, high, STACK_TYPE_OVERFLOW, info);
-}
-
-static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
-				struct stack_info *info)
-{
-	struct kvm_nvhe_stacktrace_info *stacktrace_info
-				= this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
-	unsigned long low = (unsigned long)stacktrace_info->stack_base;
-	unsigned long high = low + PAGE_SIZE;
-
-	return on_stack(sp, size, low, high, STACK_TYPE_HYP, info);
-}
-
-static inline int notrace unwind_next(struct unwind_state *state)
-{
-	struct stack_info info;
-
-	return unwind_next_common(state, &info, kvm_nvhe_stack_kern_va);
-}
-NOKPROBE_SYMBOL(unwind_next);
-
 void kvm_nvhe_dump_backtrace(unsigned long hyp_offset);
 
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 9fa60ee48499..ce190ee18a20 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -67,6 +67,96 @@ static inline void unwind_init_from_task(struct unwind_state *state,
 	state->pc = thread_saved_pc(task);
 }
 
+/*
+ * We can only safely access per-cpu stacks from current in a non-preemptible
+ * context.
+ */
+static bool on_accessible_stack(const struct task_struct *tsk,
+				unsigned long sp, unsigned long size,
+				struct stack_info *info)
+{
+	if (info)
+		info->type = STACK_TYPE_UNKNOWN;
+
+	if (on_task_stack(tsk, sp, size, info))
+		return true;
+	if (tsk != current || preemptible())
+		return false;
+	if (on_irq_stack(sp, size, info))
+		return true;
+	if (on_overflow_stack(sp, size, info))
+		return true;
+	if (on_sdei_stack(sp, size, info))
+		return true;
+
+	return false;
+}
+
+/*
+ * Unwind from one frame record (A) to the next frame record (B).
+ *
+ * We terminate early if the location of B indicates a malformed chain of frame
+ * records (e.g. a cycle), determined based on the location and fp value of A
+ * and the location (but not the fp value) of B.
+ */
+static int notrace unwind_next(struct unwind_state *state)
+{
+	struct task_struct *tsk = state->task;
+	unsigned long fp = state->fp;
+	struct stack_info info;
+	int err;
+
+	/* Final frame; nothing to unwind */
+	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
+		return -ENOENT;
+
+	err = unwind_next_common(state, &info, on_accessible_stack, NULL);
+	if (err)
+		return err;
+
+	state->pc = ptrauth_strip_insn_pac(state->pc);
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (tsk->ret_stack &&
+		(state->pc == (unsigned long)return_to_handler)) {
+		unsigned long orig_pc;
+		/*
+		 * This is a case where function graph tracer has
+		 * modified a return address (LR) in a stack frame
+		 * to hook a function return.
+		 * So replace it to an original value.
+		 */
+		orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
+						(void *)state->fp);
+		if (WARN_ON_ONCE(state->pc == orig_pc))
+			return -EINVAL;
+		state->pc = orig_pc;
+	}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+#ifdef CONFIG_KRETPROBES
+	if (is_kretprobe_trampoline(state->pc))
+		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
+#endif
+
+	return 0;
+}
+NOKPROBE_SYMBOL(unwind_next);
+
+static void notrace unwind(struct unwind_state *state,
+			   stack_trace_consume_fn consume_entry, void *cookie)
+{
+	while (1) {
+		int ret;
+
+		if (!consume_entry(cookie, state->pc))
+			break;
+		ret = unwind_next(state);
+		if (ret < 0)
+			break;
+	}
+}
+NOKPROBE_SYMBOL(unwind);
+
 static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
 	char *loglvl = arg;
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 900324b7a08f..acbe272ecb32 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -39,6 +39,58 @@ static void hyp_prepare_backtrace(unsigned long fp, unsigned long pc)
 
 DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
 
+static bool on_overflow_stack(unsigned long sp, unsigned long size,
+			      struct stack_info *info)
+{
+	unsigned long low = (unsigned long)this_cpu_ptr(overflow_stack);
+	unsigned long high = low + OVERFLOW_STACK_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_OVERFLOW, info);
+}
+
+static bool on_hyp_stack(unsigned long sp, unsigned long size,
+			      struct stack_info *info)
+{
+	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
+	unsigned long high = params->stack_hyp_va;
+	unsigned long low = high - PAGE_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_HYP, info);
+}
+
+static bool on_accessible_stack(const struct task_struct *tsk,
+				unsigned long sp, unsigned long size,
+				struct stack_info *info)
+{
+	if (info)
+		info->type = STACK_TYPE_UNKNOWN;
+
+	return (on_overflow_stack(sp, size, info) ||
+		on_hyp_stack(sp, size, info));
+}
+
+static int unwind_next(struct unwind_state *state)
+{
+	struct stack_info info;
+
+	return unwind_next_common(state, &info, on_accessible_stack, NULL);
+}
+
+static void notrace unwind(struct unwind_state *state,
+			   stack_trace_consume_fn consume_entry,
+			   void *cookie)
+{
+	while (1) {
+		int ret;
+
+		if (!consume_entry(cookie, state->pc))
+			break;
+		ret = unwind_next(state);
+		if (ret < 0)
+			break;
+	}
+}
+
 /*
  * pkvm_save_backtrace_entry - Saves a protected nVHE HYP stacktrace entry
  *
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 9812aefdcfb4..4d5fec3175ff 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -21,6 +21,61 @@
 
 #include <asm/stacktrace/nvhe.h>
 
+static bool on_overflow_stack(unsigned long sp, unsigned long size,
+			      struct stack_info *info)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info
+				= this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+	unsigned long low = (unsigned long)stacktrace_info->overflow_stack_base;
+	unsigned long high = low + OVERFLOW_STACK_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_OVERFLOW, info);
+}
+
+static bool on_hyp_stack(unsigned long sp, unsigned long size,
+			 struct stack_info *info)
+{
+	struct kvm_nvhe_stacktrace_info *stacktrace_info
+				= this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
+	unsigned long low = (unsigned long)stacktrace_info->stack_base;
+	unsigned long high = low + PAGE_SIZE;
+
+	return on_stack(sp, size, low, high, STACK_TYPE_HYP, info);
+}
+
+static bool on_accessible_stack(const struct task_struct *tsk,
+				unsigned long sp, unsigned long size,
+				struct stack_info *info)
+{
+	if (info)
+		info->type = STACK_TYPE_UNKNOWN;
+
+	return (on_overflow_stack(sp, size, info) ||
+		on_hyp_stack(sp, size, info));
+}
+
+static int unwind_next(struct unwind_state *state)
+{
+	struct stack_info info;
+
+	return unwind_next_common(state, &info, on_accessible_stack,
+				  kvm_nvhe_stack_kern_va);
+}
+
+static void unwind(struct unwind_state *state,
+		   stack_trace_consume_fn consume_entry, void *cookie)
+{
+	while (1) {
+		int ret;
+
+		if (!consume_entry(cookie, state->pc))
+			break;
+		ret = unwind_next(state);
+		if (ret < 0)
+			break;
+	}
+}
+
 /*
  * kvm_nvhe_dump_backtrace_entry - Symbolize and print an nVHE backtrace entry
  *
-- 
2.34.1

