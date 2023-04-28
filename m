Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A196F149D
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345783AbjD1Jy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 05:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345437AbjD1JyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 05:54:18 -0400
Received: from out0-198.mail.aliyun.com (out0-198.mail.aliyun.com [140.205.0.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8BA268E;
        Fri, 28 Apr 2023 02:53:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047192;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=32;SR=0;TI=SMTPD_---.STCEPaY_1682675567;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.STCEPaY_1682675567)
          by smtp.aliyun-inc.com;
          Fri, 28 Apr 2023 17:52:48 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Thomas Garnier" <thgarnie@chromium.org>,
        "Lai Jiangshan" <jiangshan.ljs@antgroup.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Josh Poimboeuf" <jpoimboe@kernel.org>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>,
        "Dennis Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>,
        "Christoph Lameter" <cl@linux.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Juergen Gross" <jgross@suse.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Nathan Chancellor" <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        "Tom Rix" <trix@redhat.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
        "Brian Gerst" <brgerst@gmail.com>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <llvm@lists.linux.dev>
Subject: [PATCH RFC 18/43] x86/percpu: Use PC-relative addressing for percpu variable references
Date:   Fri, 28 Apr 2023 17:50:58 +0800
Message-Id: <175116f75c38c15d8d73a03301eab805fea13a0a.1682673543.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1682673542.git.houwenlong.hwl@antgroup.com>
References: <cover.1682673542.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For PIE binary, all symbol references are PC-relative addressing, even
for percpu variable. So to keep compatible with PIE, add %rip suffix in
percpu assembly macros if PIE is enabled. However, relocation of percpu
variable references is broken now for PIE. It would be fixed later.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Thomas Garnier <thgarnie@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
---
 arch/x86/entry/calling.h             | 17 ++++++++++++----
 arch/x86/include/asm/nospec-branch.h | 10 +++++-----
 arch/x86/include/asm/percpu.h        | 29 +++++++++++++++++++++++++---
 arch/x86/kernel/head_64.S            |  2 +-
 arch/x86/kernel/kvm.c                | 21 ++++++++++++++++----
 arch/x86/lib/cmpxchg16b_emu.S        |  8 ++++----
 arch/x86/xen/xen-asm.S               | 10 +++++-----
 7 files changed, 71 insertions(+), 26 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index f6907627172b..11328578741d 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -173,7 +173,7 @@ For 32-bit we have the following conventions - kernel is built with
 .endm
 
 #define THIS_CPU_user_pcid_flush_mask   \
-	PER_CPU_VAR(cpu_tlbstate) + TLB_STATE_user_pcid_flush_mask
+	PER_CPU_VAR(cpu_tlbstate + TLB_STATE_user_pcid_flush_mask)
 
 .macro SWITCH_TO_USER_CR3_NOSTACK scratch_reg:req scratch_reg2:req
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
@@ -370,8 +370,8 @@ For 32-bit we have the following conventions - kernel is built with
 .endm
 
 .macro SAVE_AND_SET_GSBASE scratch_reg:req save_reg:req
+	GET_PERCPU_BASE \scratch_reg \save_reg
 	rdgsbase \save_reg
-	GET_PERCPU_BASE \scratch_reg
 	wrgsbase \scratch_reg
 .endm
 
@@ -407,15 +407,24 @@ For 32-bit we have the following conventions - kernel is built with
  * Thus the kernel would consume a guest's TSC_AUX if an NMI arrives
  * while running KVM's run loop.
  */
-.macro GET_PERCPU_BASE reg:req
+#ifdef CONFIG_X86_PIE
+.macro GET_PERCPU_BASE reg:req scratch_reg:req
+	LOAD_CPU_AND_NODE_SEG_LIMIT \reg
+	andq	$VDSO_CPUNODE_MASK, \reg
+	leaq	__per_cpu_offset(%rip), \scratch_reg
+	movq	(\scratch_reg, \reg, 8), \reg
+.endm
+#else
+.macro GET_PERCPU_BASE reg:req scratch_reg:req
 	LOAD_CPU_AND_NODE_SEG_LIMIT \reg
 	andq	$VDSO_CPUNODE_MASK, \reg
 	movq	__per_cpu_offset(, \reg, 8), \reg
 .endm
+#endif /* CONFIG_X86_PIE */
 
 #else
 
-.macro GET_PERCPU_BASE reg:req
+.macro GET_PERCPU_BASE reg:req scratch_reg:req
 	movq	pcpu_unit_offsets(%rip), \reg
 .endm
 
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index edb2b0cb8efe..d8fd935e0697 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -59,13 +59,13 @@
 
 #ifdef CONFIG_CALL_THUNKS_DEBUG
 # define CALL_THUNKS_DEBUG_INC_CALLS				\
-	incq	%gs:__x86_call_count;
+	incq	%gs:(__x86_call_count)__percpu_rel;
 # define CALL_THUNKS_DEBUG_INC_RETS				\
-	incq	%gs:__x86_ret_count;
+	incq	%gs:(__x86_ret_count)__percpu_rel;
 # define CALL_THUNKS_DEBUG_INC_STUFFS				\
-	incq	%gs:__x86_stuffs_count;
+	incq	%gs:(__x86_stuffs_count)__percpu_rel;
 # define CALL_THUNKS_DEBUG_INC_CTXSW				\
-	incq	%gs:__x86_ctxsw_count;
+	incq	%gs:(__x86_ctxsw_count)__percpu_rel;
 #else
 # define CALL_THUNKS_DEBUG_INC_CALLS
 # define CALL_THUNKS_DEBUG_INC_RETS
@@ -95,7 +95,7 @@
 	CALL_THUNKS_DEBUG_INC_CALLS
 
 #define INCREMENT_CALL_DEPTH					\
-	sarq	$5, %gs:pcpu_hot + X86_call_depth;		\
+	sarq	$5, %gs:(pcpu_hot + X86_call_depth)__percpu_rel;\
 	CALL_THUNKS_DEBUG_INC_CALLS
 
 #define ASM_INCREMENT_CALL_DEPTH				\
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 13c0d63ed55e..a627a073c6ea 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -4,16 +4,26 @@
 
 #ifdef CONFIG_X86_64
 #define __percpu_seg		gs
+#ifdef CONFIG_X86_PIE
+#define __percpu_rel		(%rip)
+#else
+#define __percpu_rel
+#endif /* CONFIG_X86_PIE */
 #else
 #define __percpu_seg		fs
+#define __percpu_rel
 #endif
 
 #ifdef __ASSEMBLY__
 
 #ifdef CONFIG_SMP
-#define PER_CPU_VAR(var)	%__percpu_seg:var
+/* Compatible with Position Independent Code */
+#define PER_CPU_VAR(var)	%__percpu_seg:(var)##__percpu_rel
+/* Rare absolute reference */
+#define PER_CPU_VAR_ABS(var)	%__percpu_seg:var
 #else /* ! SMP */
-#define PER_CPU_VAR(var)	var
+#define PER_CPU_VAR(var)	(var)##__percpu_rel
+#define PER_CPU_VAR_ABS(var)	var
 #endif	/* SMP */
 
 #ifdef CONFIG_X86_64_SMP
@@ -148,10 +158,23 @@ do {									\
 	(typeof(_var))(unsigned long) pfo_val__;			\
 })
 
+/*
+ * Position Independent code uses relative addresses only.
+ * The 'P' modifier prevents RIP-relative addressing in GCC,
+ * so use 'a' modifier instead. Howerver, 'P' modifier allows
+ * RIP-relative addressing in Clang but Clang doesn't support
+ * 'a' modifier.
+ */
+#if defined(CONFIG_X86_PIE) && defined(CONFIG_CC_IS_GCC)
+#define __percpu_stable_arg	__percpu_arg(a[var])
+#else
+#define __percpu_stable_arg	__percpu_arg(P[var])
+#endif
+
 #define percpu_stable_op(size, op, _var)				\
 ({									\
 	__pcpu_type_##size pfo_val__;					\
-	asm(__pcpu_op2_##size(op, __percpu_arg(P[var]), "%[val]")	\
+	asm(__pcpu_op2_##size(op, __percpu_stable_arg, "%[val]")	\
 	    : [val] __pcpu_reg_##size("=", pfo_val__)			\
 	    : [var] "p" (&(_var)));					\
 	(typeof(_var))(unsigned long) pfo_val__;			\
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 61f1873d0ff7..1eed50b7d1ac 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -396,7 +396,7 @@ SYM_CODE_START(start_cpu0)
 	UNWIND_HINT_END_OF_STACK
 
 	/* Find the idle task stack */
-	movq	PER_CPU_VAR(pcpu_hot) + X86_current_task, %rcx
+	movq	PER_CPU_VAR(pcpu_hot + X86_current_task), %rcx
 	movq	TASK_threadsp(%rcx), %rsp
 
 	jmp	.Ljump_to_C_code
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cceac5984da..32d7b201f4f0 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -794,14 +794,27 @@ PV_CALLEE_SAVE_REGS_THUNK(__kvm_vcpu_is_preempted);
 
 extern bool __raw_callee_save___kvm_vcpu_is_preempted(long);
 
+#ifndef CONFIG_X86_PIE
+#define KVM_CHECK_VCPU_PREEMPTED			\
+	"movq	__per_cpu_offset(,%rdi,8), %rax;"	\
+	"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
+#else
+#define KVM_CHECK_VCPU_PREEMPTED			\
+	"pushq	%rdi;"					\
+	"leaq	__per_cpu_offset(%rip), %rax;"		\
+	"movq	(%rax,%rdi,8), %rax;"			\
+	"leaq	steal_time(%rip), %rdi;"		\
+	"cmpb	$0, (%rax, %rdi, 1);"			\
+	"popq	%rdi;"
+#endif
+
 /*
  * Hand-optimize version for x86-64 to avoid 8 64-bit register saving and
  * restoring to/from the stack.
  */
-#define PV_VCPU_PREEMPTED_ASM						     \
- "movq   __per_cpu_offset(,%rdi,8), %rax\n\t"				     \
- "cmpb   $0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax)\n\t" \
- "setne  %al\n\t"
+#define PV_VCPU_PREEMPTED_ASM		\
+	KVM_CHECK_VCPU_PREEMPTED	\
+	"setne  %al\n\t"
 
 DEFINE_PARAVIRT_ASM(__raw_callee_save___kvm_vcpu_is_preempted,
 		    PV_VCPU_PREEMPTED_ASM, .text);
diff --git a/arch/x86/lib/cmpxchg16b_emu.S b/arch/x86/lib/cmpxchg16b_emu.S
index 33c70c0160ea..891c5e9fd868 100644
--- a/arch/x86/lib/cmpxchg16b_emu.S
+++ b/arch/x86/lib/cmpxchg16b_emu.S
@@ -27,13 +27,13 @@ SYM_FUNC_START(this_cpu_cmpxchg16b_emu)
 	pushfq
 	cli
 
-	cmpq PER_CPU_VAR((%rsi)), %rax
+	cmpq PER_CPU_VAR_ABS((%rsi)), %rax
 	jne .Lnot_same
-	cmpq PER_CPU_VAR(8(%rsi)), %rdx
+	cmpq PER_CPU_VAR_ABS(8(%rsi)), %rdx
 	jne .Lnot_same
 
-	movq %rbx, PER_CPU_VAR((%rsi))
-	movq %rcx, PER_CPU_VAR(8(%rsi))
+	movq %rbx, PER_CPU_VAR_ABS((%rsi))
+	movq %rcx, PER_CPU_VAR_ABS(8(%rsi))
 
 	popfq
 	mov $1, %al
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 9e5e68008785..448958ddbaf8 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -28,7 +28,7 @@
  * non-zero.
  */
 SYM_FUNC_START(xen_irq_disable_direct)
-	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	movb $1, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 	RET
 SYM_FUNC_END(xen_irq_disable_direct)
 
@@ -69,7 +69,7 @@ SYM_FUNC_END(check_events)
 SYM_FUNC_START(xen_irq_enable_direct)
 	FRAME_BEGIN
 	/* Unmask events */
-	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	movb $0, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 
 	/*
 	 * Preempt here doesn't matter because that will deal with any
@@ -78,7 +78,7 @@ SYM_FUNC_START(xen_irq_enable_direct)
 	 */
 
 	/* Test for pending */
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_pending)
 	jz 1f
 
 	call check_events
@@ -97,7 +97,7 @@ SYM_FUNC_END(xen_irq_enable_direct)
  * x86 use opposite senses (mask vs enable).
  */
 SYM_FUNC_START(xen_save_fl_direct)
-	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_mask)
 	setz %ah
 	addb %ah, %ah
 	RET
@@ -113,7 +113,7 @@ SYM_FUNC_END(xen_read_cr2);
 
 SYM_FUNC_START(xen_read_cr2_direct)
 	FRAME_BEGIN
-	_ASM_MOV PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_arch_cr2, %_ASM_AX
+	_ASM_MOV PER_CPU_VAR(xen_vcpu_info + XEN_vcpu_info_arch_cr2), %_ASM_AX
 	FRAME_END
 	RET
 SYM_FUNC_END(xen_read_cr2_direct);
-- 
2.31.1

