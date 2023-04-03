Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA3F6D4675
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjDCOF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjDCOFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:05:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4762CACB;
        Mon,  3 Apr 2023 07:05:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so30681321pjb.0;
        Mon, 03 Apr 2023 07:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680530720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxbMrHgICX+PzuOws0YA449+rnLgC+W+xeXNuZzARcg=;
        b=AR6Lx/9XbhMlTOKj0uW359PfePlcMPcLdb6lc6JN8f/haKItlJfyxvt9vLZ3WoAneV
         mmOFta9BIwUKS1ElbROBvfRXScc+D6GjEMnLFaLREJy80H9sDD+TECyU43x6me4Lbil2
         sXcvAmzpgeRXKEbvY5tNUeU9J6KLOp9dW/v+NOuZP65fi6Cd9/EAcBc4dO2FsCJgfCQv
         IVq+3sY7E++imRfQPH2kZgCmLfpZ8kkGof5yKx9+a6dP3O4BOaHveoUmnnuBAhBxNTET
         5Eyef5XHlX617RaeEfqGLIx+DrdpVrrUWgGm4lTXj8oVRKPdh56evZYz4O3G1NppsOAW
         /BsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680530720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NxbMrHgICX+PzuOws0YA449+rnLgC+W+xeXNuZzARcg=;
        b=118Kx2pNxBCE8o9kG/YCGBguSBGkkVFVQ7187nIGf/5TfMCGeDQKd0Mccv/JdD8cDR
         t0y3NhUurJPGuCAQpXxQilEzJ63CoLnw5ycxhHEDU6UmdJ/rh1PsBYM5XcSC5eTjyhEt
         Ok8bHwghXz5nu/yVDMOSuPkeefsth3bCVD1mKr1UTgj++Kc2o+4qnrUMacy9Si/YrFLD
         gAKmAEXRTkqkdY8rTdSD4PFO2vgfXGDtdqiKyK8mNqqqdArA3zFuf5W4mP/ckuwM18N/
         1xGE5WxDtnn7q78Mq75vFkcenmlYN+fTGAYsW/d6pj8b5pm7sEgtCn4hfGgb7hEzjZ7C
         H1rA==
X-Gm-Message-State: AAQBX9cga6CrkI/PURl02BOno2CWeLWGJiHUTyjMtfO2EnkQAOTn7p+K
        X5o31diSGpezxA4AA8uDDlshHaJt4+A=
X-Google-Smtp-Source: AKy350a3RjUaiH4XHbLWoO9BC1c+N8qfMXhehIi/eun4+wHvqOk+gwENOtPBIk1BisFY8WmvRq6eAQ==
X-Received: by 2002:a17:902:ce83:b0:1a1:ad5e:bdb2 with SMTP id f3-20020a170902ce8300b001a1ad5ebdb2mr45730746plg.57.1680530720217;
        Mon, 03 Apr 2023 07:05:20 -0700 (PDT)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id w11-20020a170902d70b00b00186a2274382sm6639410ply.76.2023.04.03.07.05.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Apr 2023 07:05:19 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH 3/7] x86/entry: Implement atomic-IST-entry
Date:   Mon,  3 Apr 2023 22:06:01 +0800
Message-Id: <20230403140605.540512-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230403140605.540512-1-jiangshanlai@gmail.com>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

See the comments in the cover-letter.  They will be moved into the code
and changelog here when improved.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/entry/Makefile          |   3 +
 arch/x86/entry/entry_64.S        | 193 ++++++++++++++++++++
 arch/x86/entry/ist_entry.c       | 299 +++++++++++++++++++++++++++++++
 arch/x86/kernel/asm-offsets_64.c |   7 +
 arch/x86/kernel/callthunks.c     |   2 +
 tools/objtool/check.c            |   7 +-
 6 files changed, 510 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/entry/ist_entry.c

diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
index ca2fe186994b..7cc1254ca519 100644
--- a/arch/x86/entry/Makefile
+++ b/arch/x86/entry/Makefile
@@ -8,11 +8,14 @@ UBSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 
 CFLAGS_REMOVE_common.o		= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_ist_entry.o	= $(CC_FLAGS_FTRACE) $(RETHUNK_CFLAGS)
 
 CFLAGS_common.o			+= -fno-stack-protector
+CFLAGS_ist_entry.o		+= -fno-stack-protector
 
 obj-y				:= entry.o entry_$(BITS).o syscall_$(BITS).o
 obj-y				+= common.o
+obj-$(CONFIG_X86_64)		+= ist_entry.o
 
 obj-y				+= vdso/
 obj-y				+= vsyscall/
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 49ddc4dd3117..50a24cc83581 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -443,6 +443,184 @@ SYM_CODE_END(\asmsym)
 	idtentry \vector asm_\cfunc \cfunc has_error_code=0
 .endm
 
+/**
+ * idtentry_ist - Macro to generate entry stubs for IST exceptions except #DF
+ * @vector:		Vector number
+ * @asmsym:		ASM symbol for the entry point
+ * @cfunc:		C function to be called when it occurs in kernel
+ * @user_cfunc:		C function to be called when it occurs in userspace
+ * @has_error_code:	Hardware pushed error code on stack
+ * @stack_offset:	Offset of the IST stack top in struct cea_exception_stacks
+ *
+ * The macro emits code to set up the kernel context for IST exceptions.
+ *
+ * From the hardware entry of the event to the SYM_INNER_LABEL(commit_\asmsym)
+ * is atomic-IST-entry (note: atomic-IST-entry is from the hardware entry,
+ * not merely from the first instruction of this macro).
+ *
+ * The atomic-IST-entry pushes pt_regs and copies the pt_regs to the IST
+ * main stack, and switches to it.  If the atomic-IST-entry is interrupted
+ * by another IST event (except #DF), the new atomic-IST-entry will
+ * replicate the interrupted one as if every atomic-IST-entry is atomic.
+ *
+ * See the comments in entry64.c.
+ *
+ * When the cpu is on any IST stack or the IST main stack, %rsp can not be
+ * switched off except being interrupted by any IST exception or totally
+ * switching off (no usable data left).
+ *
+ * If the entry comes from user space, it turns to use the normal entry
+ * path finally on its kernel stack including the return to user space
+ * work and preemption checks on exit.  The macro idtentry_body ensures
+ * the IST main stack is totally switched off (no usable data left) at
+ * the same time it switches to the kernel stack..
+ *
+ * If hits in kernel mode then it needs to go through the paranoid
+ * entry as the exception can hit any random state. No preemption
+ * check on exit to keep the paranoid path simple.
+ */
+.macro idtentry_ist vector asmsym cfunc user_cfunc has_error_code:req, stack_offset:req
+SYM_CODE_START(\asmsym)
+	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
+	ENDBR
+
+	/*
+	 * Clear X86_EFLAGS_AC, X86_EFLAGS_DF and set a default ORIG_RAX.
+	 *
+	 * The code setting ORIG_RAX will not be replicated if interrupted.
+	 */
+	ASM_CLAC
+	cld
+
+	.if \has_error_code == 0
+		pushq	$-1		/* ORIG_RAX: no syscall to restart */
+	.endif
+
+	/*
+	 * No register can be touched except %rsp,%rflags,%rip before
+	 * pushing all the registers.  It is indispensable for nested
+	 * atomic-IST-entry to replicate pushing the registers.
+	 */
+	PUSH_REGS
+
+	/*
+	 * Finished pushing register, all registers can be touched by now.
+	 *
+	 * Clear registers for the C function ist_copy_regs_to_main_stack()
+	 * and the handler to avoid any possible exploitation of any
+	 * speculation attack.
+	 */
+	CLEAR_REGS
+
+	/*
+	 * Copy the pt_regs to the IST main stack including the pt_regs of
+	 * the interrupted atomic-IST-entris, if any, by replicating.
+	 */
+	movq	%rsp, %rdi				/* pt_regs pointer on its own IST stack */
+	leaq	PTREGS_SIZE-\stack_offset(%rsp), %rsi	/* struct cea_exception_stacks pointer */
+	call	ist_copy_regs_to_main_stack
+
+	/*
+	 * Commit stage.
+	 */
+SYM_INNER_LABEL(start_commit_\asmsym, SYM_L_GLOBAL)
+	/*
+	 * Switches to the IST main stack.  Before the switching is done,
+	 * %rax is the copied pt_regs pointer in IST main stack.
+	 */
+	movq	%rax, %rsp
+
+	/*
+	 * The label should be immediate after the instruction that switches
+	 * the stack since there is code assuming there is only one single
+	 * instruction in the commit stage and the code assumes "%rsp in the
+	 * IST main stack is also the sign of ending a atomic-IST-entry".
+	 * (The code will be removed in future when %rip-based identifying
+	 * is added.)
+	 */
+SYM_INNER_LABEL(commit_\asmsym, SYM_L_GLOBAL)
+
+	/*
+	 * Now, it is on the IST main stack.  For the whole kernel, the entries
+	 * of the IST exceptions can be seen from here because the inside
+	 * of the atomic-IST-entry can not be seen from the whole kernel
+	 * except in the atomic-IST-entry or #DF.
+	 */
+	UNWIND_HINT_REGS
+	ENCODE_FRAME_POINTER
+
+	/*
+	 * The code setting ORIG_RAX will not be replicated if interrupted.
+	 * So redo it here.
+	 */
+	.if \has_error_code == 0
+		movq	$-1, ORIG_RAX(%rsp)	/* ORIG_RAX: no syscall to restart */
+	.endif
+
+	/*
+	 * If the entry is from userspace, switch stacks and treat it as
+	 * a normal entry.
+	 */
+	testb	$3, CS(%rsp)
+	jnz	.Lfrom_usermode_switch_stack_\@
+
+	/*
+	 * paranoid_entry returns GS/CR3/SPEC_CTL information for
+	 * paranoid_exit in RBX/R14/R15.
+	 */
+	call	paranoid_entry
+
+	movq	%rsp, %rdi		/* pt_regs pointer */
+	.if \has_error_code == 1
+		movq	ORIG_RAX(%rsp), %rsi	/* get error code into 2nd argument*/
+		movq	$-1, ORIG_RAX(%rsp)	/* no syscall to restart */
+	.endif
+	call	\cfunc
+
+	jmp	paranoid_exit
+
+.Lfrom_usermode_switch_stack_\@:
+	/* Switch context: GS_BASE, CR3, SPEC_CTL. */
+	swapgs
+	FENCE_SWAPGS_USER_ENTRY
+	/* We have user CR3.  Change to kernel CR3. */
+	SWITCH_TO_KERNEL_CR3 scratch_reg=%rax
+	IBRS_ENTER
+	UNTRAIN_RET
+
+	/* Put the pt_regs onto the kernel task stack. */
+	movq	%rsp, %rdi			/* arg0 = pt_regs pointer */
+	call	sync_regs
+
+	/*
+	 * Switch to the kernel task stack and use the user entry point.
+	 *
+	 * When from the user mode, the procedure has to atomically switches
+	 * off the TSS-configured IST stacks too, so it switches to the IST
+	 * main stack first, and then switches off the IST main stack in atomic
+	 * fashion: when %rsp leaves the IST main stack, the IST main stack is
+	 * totally free.
+	 */
+	movq	%rax, %rsp
+	UNWIND_HINT_REGS
+	ENCODE_FRAME_POINTER
+
+	movq	%rsp, %rdi			/* pt_regs pointer into 1st argument*/
+	.if \has_error_code == 1
+		movq	ORIG_RAX(%rsp), %rsi	/* get error code into 2nd argument*/
+		movq	$-1, ORIG_RAX(%rsp)	/* no syscall to restart */
+	.endif
+	call	\user_cfunc
+
+	/* For some configurations \user_cfunc ends up being a noreturn. */
+	REACHABLE
+
+	jmp	error_return
+
+_ASM_NOKPROBE(\asmsym)
+SYM_CODE_END(\asmsym)
+.endm
+
 /**
  * idtentry_mce_db - Macro to generate entry stubs for #MC and #DB
  * @vector:		Vector number
@@ -586,8 +764,23 @@ SYM_CODE_END(\asmsym)
  */
 .macro idtentry_df vector asmsym cfunc
 SYM_CODE_START(\asmsym)
+
+	/*
+	 * This unwind-hint is incorect if it is the soft double fault rasied
+	 * from ist_double_fault().  It doesn't matter since it is unrecoverable
+	 * double fault.
+	 */
 	UNWIND_HINT_IRET_REGS offset=8
 	ENDBR
+
+	/*
+	 * Set %rsp = %rsp - 8 if it is the soft double fault raisied from
+	 * ist_double_fault().  The CPU doesn't push an error code in the case
+	 * since it is injected by an INT instruction.
+	 */
+	btr	$3, %rsp
+	UNWIND_HINT_IRET_REGS offset=8
+
 	ASM_CLAC
 	cld
 
diff --git a/arch/x86/entry/ist_entry.c b/arch/x86/entry/ist_entry.c
new file mode 100644
index 000000000000..e1b06306ac51
--- /dev/null
+++ b/arch/x86/entry/ist_entry.c
@@ -0,0 +1,299 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Copyright (C) 2022-2023 Lai Jiangshan, Ant Group
+ *
+ * Handle entries and exits for hardware traps and faults.
+ *
+ * It is as low level as entry_64.S and its code can be running in the
+ * environments that the GS base is a user controlled value, or the CR3
+ * is the PTI user CR3 or both.
+ */
+#include <asm/traps.h>
+
+#define IST_DOUBLE_FAULT_VECTOR 8
+
+static __always_inline void ist_double_fault(void)
+{
+	asm volatile ("int $" __stringify(IST_DOUBLE_FAULT_VECTOR));
+}
+
+#define IN_CEA_ESTACK(ceastp, name, sp)			\
+	((CEA_ESTACK_BOT(ceastp, name) <= (sp)) &&	\
+	 ((sp) < CEA_ESTACK_TOP(ceastp, name)))
+
+struct ist_ctx {
+	const struct pt_regs *regs;
+	unsigned long commit_ip;
+};
+
+#define DEFINE_IDENTIFY_IST(stack_name, sym_name, is_enabled)			\
+extern char commit_asm_exc_##sym_name[];					\
+static __always_inline bool identify_ist_##sym_name(				\
+		const struct pt_regs *regs, struct cea_exception_stacks *stacks,\
+		struct ist_ctx *ctx)						\
+{										\
+	if (!(is_enabled))							\
+		return false;							\
+	if (!IN_CEA_ESTACK(stacks, stack_name, regs->sp))			\
+		return false;							\
+	ctx->regs = (struct pt_regs *)CEA_ESTACK_TOP(stacks, stack_name) - 1;	\
+	ctx->commit_ip = (unsigned long)commit_asm_exc_##sym_name;		\
+	return true;								\
+}
+
+DEFINE_IDENTIFY_IST(NMI, nmi, false)
+DEFINE_IDENTIFY_IST(DB, debug, false)
+DEFINE_IDENTIFY_IST(MCE, machine_check, false)
+DEFINE_IDENTIFY_IST(VC, vmm_communication, false)
+
+static __always_inline bool identify_ist(
+		const struct pt_regs *regs, struct cea_exception_stacks *stacks,
+		struct ist_ctx *ctx)
+{
+	return	identify_ist_nmi(regs, stacks, ctx) ||
+		identify_ist_debug(regs, stacks, ctx) ||
+		identify_ist_machine_check(regs, stacks, ctx) ||
+		identify_ist_vmm_communication(regs, stacks, ctx);
+}
+
+/*
+ * identify if an interrupted atomic-IST-entry had successfully saved
+ * the general registers onto its IST stack.
+ *
+ * Generally, the outmost atomic-IST-entry had likely successfully saved
+ * the general registers.  If not, there must be one of the nested
+ * atomic-IST-entry had saved the general registers of the context that
+ * the outmost atomic-IST-entry had interrupted.
+ *
+ * Arguments:
+ *   @nested: the nested atomic-IST-entry who had interrupted @interrupted
+ *   @interrupted: the interrupted atomic-IST-entry.
+ *
+ * Returns:
+ *   true:  the interrupted atomic-IST-entry had saved the general registers.
+ *   false: the interrupted atomic-IST-entry had not yet saved the general registers.
+ */
+static __always_inline
+bool identify_if_gp_registers_saved(const struct pt_regs *nested, const struct pt_regs *interrupted)
+{
+	return nested->sp <= (unsigned long)(void *)interrupted;
+}
+
+static __always_inline
+void copy_regs_exception_head(struct pt_regs *target, const struct pt_regs *from)
+{
+	target->ss	= from->ss;
+	target->sp	= from->sp;
+	target->flags 	= from->flags;
+	target->cs	= from->cs;
+	target->ip	= from->ip;
+	target->orig_ax	= from->orig_ax;
+}
+
+static __always_inline
+void copy_regs_general_registers(struct pt_regs *target, const struct pt_regs *from)
+{
+	target->di  = from->di;
+	target->si  = from->si;
+	target->dx  = from->dx;
+	target->cx  = from->cx;
+	target->ax  = from->ax;
+	target->r8  = from->r8;
+	target->r9  = from->r9;
+	target->r10 = from->r10;
+	target->r11 = from->r11;
+	target->bx  = from->bx;
+	target->bp  = from->bp;
+	target->r12 = from->r12;
+	target->r13 = from->r13;
+	target->r14 = from->r14;
+	target->r15 = from->r15;
+}
+
+/*
+ * Do the work as the outmost atomic-IST-entry to copy the supposed pt_regs
+ * of the interrupted context to the IST main stack.  (If the ongoing
+ * atomic-IST-entry is the outmost one, the work is literally doing copy as
+ * the outmost, if not, the work is replicating the outmost.)
+ *
+ * The hardware-entry of the outmost atomic-IST-entry has already saved the
+ * exception head of the  pt_regs. If the outmost atomic-IST-entry was
+ * unfortunately interrupted before fully saving all the general registers,
+ * the general registers are untouched and must be saved by one of the
+ * consequent nested atomic-IST-entries. The identifying code can just
+ * examine all the nested atomic-IST-entries to find which one has saved
+ * the general registers.
+ */
+static __always_inline
+void copy_outmost(struct pt_regs *target, const struct pt_regs *outmost, const struct pt_regs *gp)
+{
+	copy_regs_exception_head(target, outmost);
+	copy_regs_general_registers(target, gp);
+}
+
+/*
+ * Replicate the interrupted atomic-IST-entry's CLAC and CLD in the ASM
+ * code.  Even SMAP is not enabled, CLAC is replicated unconditionally
+ * since doing so has no harm.
+ */
+static __always_inline void replicate_clac_cld(struct pt_regs *target)
+{
+	target->flags &= ~(unsigned long)(X86_EFLAGS_AC | X86_EFLAGS_DF);
+}
+
+/* Replicate the interrupted atomic-IST-entry's CLEAR_REGS macro. */
+static __always_inline void replicate_clear_regs(struct pt_regs *target)
+{
+	target->di  = 0;
+	target->si  = 0;
+	target->dx  = 0;
+	target->cx  = 0;
+	target->ax  = 0;
+	target->r8  = 0;
+	target->r9  = 0;
+	target->r10 = 0;
+	target->r11 = 0;
+	target->bx  = 0;
+	target->bp  = 0;
+	target->r12 = 0;
+	target->r13 = 0;
+	target->r14 = 0;
+	target->r15 = 0;
+}
+
+/*
+ * Replicate the action that the interrupted atomic-IST-entry's
+ * ist_copy_regs_to_main_stack() clobbers caller-saved registers
+ */
+static __always_inline void replicate_func_clobber(struct pt_regs *target)
+{
+	/* nothing needs to be done. */
+}
+
+/*
+ * Replicate the copy operation in the interrupted atomic-IST-entry's
+ * ist_copy_regs_to_main_stack()
+ */
+static __always_inline void replicate_func_copy(struct pt_regs *target)
+{
+	/*
+	 * To avoid recursive functions calls with __always_inline, the
+	 * copy operation for the interrupted atomic-IST-entry has been
+	 * done in the caller of copy_nested(). Nothing need to be done.
+	 */
+}
+
+#define IST_FRAME_SIZE	ALIGN(sizeof(struct pt_regs), 16)
+
+/*
+ * Replicate the return result of the interrupted atomic-IST-entry's
+ * ist_copy_regs_to_main_stack() in %rax and the commit operation.
+ */
+static __always_inline void replicate_func_result_and_commit(struct pt_regs *target, unsigned long commit_ip)
+{
+	void *target_of_interrupted = (void *)target + IST_FRAME_SIZE;
+
+	/* return result in %rax */
+	target->ax = (unsigned long)target_of_interrupted;
+	/* move %rax, %rsp */
+	target->sp = (unsigned long)target_of_interrupted;
+	/* the %rip advances to commit point */
+	target->ip = commit_ip;
+}
+
+/*
+ * Do the work as a nested atomic-IST-entry to copy the supposed pt_regs
+ * of the interrupted context to the IST main stack.
+ *
+ * The hardware-entry of the nested atomic-IST-entry has already saved
+ * the exception head of the pt_regs of the interrupted context (inside
+ * the interrupted atomic-IST-entry).  To maintain the atomic attribute
+ * of the atomic-IST-entry, the copy_nested() (of the ongoing nested
+ * atomic-IST-entry) has to replicate all that the interrupted
+ * atomic-IST-entries should have been done till the commit point and
+ * copy the supposed saved context (pt_regs).
+ *
+ * To avoid touching any saved pt_regs, the replicating is actually
+ * directly applied on the target pt_regs.
+ */
+static __always_inline
+void copy_nested(struct pt_regs *target, const struct pt_regs *nested, unsigned long commit_ip)
+{
+	copy_regs_exception_head(target, nested);
+	replicate_clac_cld(target);
+	replicate_clear_regs(target);
+	replicate_func_clobber(target);
+	replicate_func_copy(target);
+	replicate_func_result_and_commit(target, commit_ip);
+}
+
+asmlinkage __visible __noinstr_section(".entry.text")
+struct pt_regs *ist_copy_regs_to_main_stack(
+		const struct pt_regs *regs, struct cea_exception_stacks *stacks)
+{
+	unsigned long ist_main_sp = CEA_ESTACK_TOP(stacks, IST);
+	struct ist_ctx ist_ctx[8];
+	const struct pt_regs *gp_saved;
+	struct pt_regs *target;
+	int nr_entries, i;
+
+	/*
+	 * Identify all of the atomic-IST-entris.
+	 *
+	 * The current ongoing atomic-IST-entry doesn't need to be identified,
+	 * but is also put in the @ist_ctx[0] for later convenience.
+	 *
+	 * The for-loop identifies what the context @regs has interrupted is.
+	 * It travels back to the outmost atomic-IST-entry.
+	 *
+	 * Result:
+	 *   Identified result is put in ist_ctx[i].
+	 *   ist_ctx[0] is the current ongoing atomic-IST-entry.
+	 *   ist_ctx[nr_entries-1] is the outmost atomic-IST-entry.
+	 *   gp_saved is the atomic-IST-entry that has saved the general registers.
+	 */
+	ist_ctx[0].regs = regs;
+	ist_ctx[0].commit_ip = -1; /* unused */
+	nr_entries = 1;
+	gp_saved = regs;
+	for (;;) {
+		if (user_mode((struct pt_regs *)regs))
+			break;
+		if (ip_within_syscall_gap((struct pt_regs *)regs))
+			break;
+		if (!identify_ist(regs, stacks, &ist_ctx[nr_entries])) {
+			/* locate the top of copying target pt_regs */
+			if (IN_CEA_ESTACK(stacks, IST, regs->sp))
+				ist_main_sp = ALIGN_DOWN(regs->sp, 16);
+			break;
+		}
+		if (identify_if_gp_registers_saved(regs, ist_ctx[nr_entries].regs))
+			gp_saved = ist_ctx[nr_entries].regs;
+		regs = ist_ctx[nr_entries].regs;
+		nr_entries++;
+		if (nr_entries >= ARRAY_SIZE(ist_ctx))
+			ist_double_fault();
+	}
+
+	if (!IN_CEA_ESTACK(stacks, IST, ist_main_sp - IST_FRAME_SIZE * nr_entries))
+		ist_double_fault();
+
+	/*
+	 * Copy the saved pt_regs to the IST main stack.
+	 *
+	 * For each atomic-IST-entry including the interrupted ones and
+	 * the current ongoing one, calls either copy_outmost() or copy_nested()
+	 * to copy the pt_regs of what should have been saved, by replicating
+	 * if needed, to the IST main stack.
+	 */
+	ist_main_sp -= IST_FRAME_SIZE;
+	target = (void *)ist_main_sp;
+	copy_outmost(target, ist_ctx[nr_entries - 1].regs, gp_saved);
+	for (i = nr_entries - 2; unlikely(i >= 0); i--) {
+		ist_main_sp -= IST_FRAME_SIZE;
+		target = (void *)ist_main_sp;
+		copy_nested(target, ist_ctx[i].regs, ist_ctx[i+1].commit_ip);
+	}
+
+	return target;
+}
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index bb65371ea9df..f861a56c0002 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -60,5 +60,12 @@ int main(void)
 	OFFSET(FIXED_stack_canary, fixed_percpu_data, stack_canary);
 	BLANK();
 #endif
+
+	DEFINE(CEA_stacks_NMI, offsetofend(struct cea_exception_stacks, NMI_stack));
+	DEFINE(CEA_stacks_DB,  offsetofend(struct cea_exception_stacks, DB_stack));
+	DEFINE(CEA_stacks_MCE, offsetofend(struct cea_exception_stacks, MCE_stack));
+	DEFINE(CEA_stacks_VC,  offsetofend(struct cea_exception_stacks, VC_stack));
+	BLANK();
+
 	return 0;
 }
diff --git a/arch/x86/kernel/callthunks.c b/arch/x86/kernel/callthunks.c
index ffea98f9064b..e756c89996d8 100644
--- a/arch/x86/kernel/callthunks.c
+++ b/arch/x86/kernel/callthunks.c
@@ -123,6 +123,8 @@ static bool skip_addr(void *dest)
 {
 	if (dest == error_entry)
 		return true;
+	if (dest == ist_copy_regs_to_main_stack)
+		return true;
 	if (dest == paranoid_entry)
 		return true;
 	if (dest == xen_error_entry)
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f937be1afe65..8dfa627d4b41 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3998,6 +3998,11 @@ static int validate_unret(struct objtool_file *file)
 	return warnings;
 }
 
+static bool in_ist_entry(struct instruction *insn)
+{
+	return !strcmp(insn->sym->name, "ist_copy_regs_to_main_stack");
+}
+
 static int validate_retpoline(struct objtool_file *file)
 {
 	struct instruction *insn;
@@ -4016,7 +4021,7 @@ static int validate_retpoline(struct objtool_file *file)
 			continue;
 
 		if (insn->type == INSN_RETURN) {
-			if (opts.rethunk) {
+			if (opts.rethunk && !in_ist_entry(insn)) {
 				WARN_FUNC("'naked' return found in RETHUNK build",
 					  insn->sec, insn->offset);
 			} else
-- 
2.19.1.6.gb485710b

