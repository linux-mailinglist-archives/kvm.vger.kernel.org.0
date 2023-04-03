Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441A06D4677
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjDCOGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjDCOFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:05:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C998B24AF4;
        Mon,  3 Apr 2023 07:05:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so32629426pjb.4;
        Mon, 03 Apr 2023 07:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680530726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uW7m7/qrXam5zwn+ChF6Qpt85GH+CQW9JyNbrYZqUtk=;
        b=QN64awyKH2bnzXFUM0DQTGfpVpq/h63QBaT+4tckfdagXqJDEmBMWLu2Vkl7oEJKic
         fycFWDRzX3T7b8VVtnlAZcPhvxz1OzgldgL8O3FItUC/w73Hf7HYY/urvNTbXb0KXW3j
         Ihk6w/7gVeGFBMR3zgPFLnVpDPtP/rL31KGdJhm9vvMfOCd3fH/H7IfLofRVdFqMgint
         9FASraQTodJWJLEzvWW7bI28zLRlT9L/J+thd2t110TlJ4cr6JcZFZpf5YuQb1UAxFgC
         S2FCaXBVsFD2k4RPksbuSugf9SIYjFmqM7kYB9D+wPXXEw4xgWoopTGc46cT9PqZAC2Q
         zMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680530726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uW7m7/qrXam5zwn+ChF6Qpt85GH+CQW9JyNbrYZqUtk=;
        b=jG6zvbSOgT3hT1Mu37EetBgApV5CenjEpSDD4Wr6xXjALjGd0d6j1SV6oM8YkR1uDj
         AvPchw4PyMAXgmve3dzfdynU+rGPAx1cA96qfkGskngQtrAJjUM/U6wD35/ZvKACxV6A
         TcuIWxcCRDtCx+pZT9G84jF3iQecA6hiCkqmjjB2sGScKlcJHRs5EeCE8MbVFq8OuFHn
         32F8SnQ/6wbKi0qceiyhuM1R11d8IlkgcDsa8PGrqDYe9pePWiqy4zt1nP8JV4l4OyhS
         LG2qNk0TcfI3p2jYRMcCQJ1BJQUINq+pupN7N1/8G5eclKxBQC+vZ7c6hLGyrdBdPs5U
         WWag==
X-Gm-Message-State: AAQBX9e9evMYsLZs7JQI4tlQz44/6OECl1C26dS5SNa6+QGzJjeTNxAD
        W1yiaZFVYre+OPdWgs980xTJuQxBbyE=
X-Google-Smtp-Source: AKy350Yiz3pkX2+ZDR0fWkZykmS9yXCpx/nMMdG3lv9PdOfELPEwKXfhTSZRhGUtA1MZusU5VNg0zw==
X-Received: by 2002:a17:90b:314d:b0:23e:f8e2:9ec8 with SMTP id ip13-20020a17090b314d00b0023ef8e29ec8mr39219405pjb.16.1680530726066;
        Mon, 03 Apr 2023 07:05:26 -0700 (PDT)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a800900b00233db0db3dfsm9902721pjn.7.2023.04.03.07.05.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Apr 2023 07:05:25 -0700 (PDT)
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
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [RFC PATCH 4/7] x86/entry: Use atomic-IST-entry for NMI
Date:   Mon,  3 Apr 2023 22:06:02 +0800
Message-Id: <20230403140605.540512-5-jiangshanlai@gmail.com>
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

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/entry/entry_64.S       | 373 --------------------------------
 arch/x86/entry/ist_entry.c      |   2 +-
 arch/x86/include/asm/idtentry.h |   9 +-
 3 files changed, 7 insertions(+), 377 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 50a24cc83581..2bb7ab8512dc 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1341,379 +1341,6 @@ SYM_CODE_START_LOCAL(error_return)
 	jmp	swapgs_restore_regs_and_return_to_usermode
 SYM_CODE_END(error_return)
 
-/*
- * Runs on exception stack.  Xen PV does not go through this path at all,
- * so we can use real assembly here.
- *
- * Registers:
- *	%r14: Used to save/restore the CR3 of the interrupted context
- *	      when PAGE_TABLE_ISOLATION is in use.  Do not clobber.
- */
-SYM_CODE_START(asm_exc_nmi)
-	UNWIND_HINT_IRET_REGS
-	ENDBR
-
-	/*
-	 * We allow breakpoints in NMIs. If a breakpoint occurs, then
-	 * the iretq it performs will take us out of NMI context.
-	 * This means that we can have nested NMIs where the next
-	 * NMI is using the top of the stack of the previous NMI. We
-	 * can't let it execute because the nested NMI will corrupt the
-	 * stack of the previous NMI. NMI handlers are not re-entrant
-	 * anyway.
-	 *
-	 * To handle this case we do the following:
-	 *  Check the a special location on the stack that contains
-	 *  a variable that is set when NMIs are executing.
-	 *  The interrupted task's stack is also checked to see if it
-	 *  is an NMI stack.
-	 *  If the variable is not set and the stack is not the NMI
-	 *  stack then:
-	 *    o Set the special variable on the stack
-	 *    o Copy the interrupt frame into an "outermost" location on the
-	 *      stack
-	 *    o Copy the interrupt frame into an "iret" location on the stack
-	 *    o Continue processing the NMI
-	 *  If the variable is set or the previous stack is the NMI stack:
-	 *    o Modify the "iret" location to jump to the repeat_nmi
-	 *    o return back to the first NMI
-	 *
-	 * Now on exit of the first NMI, we first clear the stack variable
-	 * The NMI stack will tell any nested NMIs at that point that it is
-	 * nested. Then we pop the stack normally with iret, and if there was
-	 * a nested NMI that updated the copy interrupt stack frame, a
-	 * jump will be made to the repeat_nmi code that will handle the second
-	 * NMI.
-	 *
-	 * However, espfix prevents us from directly returning to userspace
-	 * with a single IRET instruction.  Similarly, IRET to user mode
-	 * can fault.  We therefore handle NMIs from user space like
-	 * other IST entries.
-	 */
-
-	ASM_CLAC
-	cld
-
-	/* Use %rdx as our temp variable throughout */
-	pushq	%rdx
-
-	testb	$3, CS-RIP+8(%rsp)
-	jz	.Lnmi_from_kernel
-
-	/*
-	 * NMI from user mode.  We need to run on the thread stack, but we
-	 * can't go through the normal entry paths: NMIs are masked, and
-	 * we don't want to enable interrupts, because then we'll end
-	 * up in an awkward situation in which IRQs are on but NMIs
-	 * are off.
-	 *
-	 * We also must not push anything to the stack before switching
-	 * stacks lest we corrupt the "NMI executing" variable.
-	 */
-
-	swapgs
-	FENCE_SWAPGS_USER_ENTRY
-	SWITCH_TO_KERNEL_CR3 scratch_reg=%rdx
-	movq	%rsp, %rdx
-	movq	PER_CPU_VAR(pcpu_hot + X86_top_of_stack), %rsp
-	UNWIND_HINT_IRET_REGS base=%rdx offset=8
-	pushq	5*8(%rdx)	/* pt_regs->ss */
-	pushq	4*8(%rdx)	/* pt_regs->rsp */
-	pushq	3*8(%rdx)	/* pt_regs->flags */
-	pushq	2*8(%rdx)	/* pt_regs->cs */
-	pushq	1*8(%rdx)	/* pt_regs->rip */
-	UNWIND_HINT_IRET_REGS
-	pushq   $-1		/* pt_regs->orig_ax */
-	PUSH_AND_CLEAR_REGS rdx=(%rdx)
-	ENCODE_FRAME_POINTER
-
-	IBRS_ENTER
-	UNTRAIN_RET
-
-	/*
-	 * At this point we no longer need to worry about stack damage
-	 * due to nesting -- we're on the normal thread stack and we're
-	 * done with the NMI stack.
-	 */
-
-	movq	%rsp, %rdi
-	movq	$-1, %rsi
-	call	exc_nmi
-
-	/*
-	 * Return back to user mode.  We must *not* do the normal exit
-	 * work, because we don't want to enable interrupts.
-	 */
-	jmp	swapgs_restore_regs_and_return_to_usermode
-
-.Lnmi_from_kernel:
-	/*
-	 * Here's what our stack frame will look like:
-	 * +---------------------------------------------------------+
-	 * | original SS                                             |
-	 * | original Return RSP                                     |
-	 * | original RFLAGS                                         |
-	 * | original CS                                             |
-	 * | original RIP                                            |
-	 * +---------------------------------------------------------+
-	 * | temp storage for rdx                                    |
-	 * +---------------------------------------------------------+
-	 * | "NMI executing" variable                                |
-	 * +---------------------------------------------------------+
-	 * | iret SS          } Copied from "outermost" frame        |
-	 * | iret Return RSP  } on each loop iteration; overwritten  |
-	 * | iret RFLAGS      } by a nested NMI to force another     |
-	 * | iret CS          } iteration if needed.                 |
-	 * | iret RIP         }                                      |
-	 * +---------------------------------------------------------+
-	 * | outermost SS          } initialized in first_nmi;       |
-	 * | outermost Return RSP  } will not be changed before      |
-	 * | outermost RFLAGS      } NMI processing is done.         |
-	 * | outermost CS          } Copied to "iret" frame on each  |
-	 * | outermost RIP         } iteration.                      |
-	 * +---------------------------------------------------------+
-	 * | pt_regs                                                 |
-	 * +---------------------------------------------------------+
-	 *
-	 * The "original" frame is used by hardware.  Before re-enabling
-	 * NMIs, we need to be done with it, and we need to leave enough
-	 * space for the asm code here.
-	 *
-	 * We return by executing IRET while RSP points to the "iret" frame.
-	 * That will either return for real or it will loop back into NMI
-	 * processing.
-	 *
-	 * The "outermost" frame is copied to the "iret" frame on each
-	 * iteration of the loop, so each iteration starts with the "iret"
-	 * frame pointing to the final return target.
-	 */
-
-	/*
-	 * Determine whether we're a nested NMI.
-	 *
-	 * If we interrupted kernel code between repeat_nmi and
-	 * end_repeat_nmi, then we are a nested NMI.  We must not
-	 * modify the "iret" frame because it's being written by
-	 * the outer NMI.  That's okay; the outer NMI handler is
-	 * about to about to call exc_nmi() anyway, so we can just
-	 * resume the outer NMI.
-	 */
-
-	movq	$repeat_nmi, %rdx
-	cmpq	8(%rsp), %rdx
-	ja	1f
-	movq	$end_repeat_nmi, %rdx
-	cmpq	8(%rsp), %rdx
-	ja	nested_nmi_out
-1:
-
-	/*
-	 * Now check "NMI executing".  If it's set, then we're nested.
-	 * This will not detect if we interrupted an outer NMI just
-	 * before IRET.
-	 */
-	cmpl	$1, -8(%rsp)
-	je	nested_nmi
-
-	/*
-	 * Now test if the previous stack was an NMI stack.  This covers
-	 * the case where we interrupt an outer NMI after it clears
-	 * "NMI executing" but before IRET.  We need to be careful, though:
-	 * there is one case in which RSP could point to the NMI stack
-	 * despite there being no NMI active: naughty userspace controls
-	 * RSP at the very beginning of the SYSCALL targets.  We can
-	 * pull a fast one on naughty userspace, though: we program
-	 * SYSCALL to mask DF, so userspace cannot cause DF to be set
-	 * if it controls the kernel's RSP.  We set DF before we clear
-	 * "NMI executing".
-	 */
-	lea	6*8(%rsp), %rdx
-	/* Compare the NMI stack (rdx) with the stack we came from (4*8(%rsp)) */
-	cmpq	%rdx, 4*8(%rsp)
-	/* If the stack pointer is above the NMI stack, this is a normal NMI */
-	ja	first_nmi
-
-	subq	$EXCEPTION_STKSZ, %rdx
-	cmpq	%rdx, 4*8(%rsp)
-	/* If it is below the NMI stack, it is a normal NMI */
-	jb	first_nmi
-
-	/* Ah, it is within the NMI stack. */
-
-	testb	$(X86_EFLAGS_DF >> 8), (3*8 + 1)(%rsp)
-	jz	first_nmi	/* RSP was user controlled. */
-
-	/* This is a nested NMI. */
-
-nested_nmi:
-	/*
-	 * Modify the "iret" frame to point to repeat_nmi, forcing another
-	 * iteration of NMI handling.
-	 */
-	subq	$8, %rsp
-	leaq	-10*8(%rsp), %rdx
-	pushq	$__KERNEL_DS
-	pushq	%rdx
-	pushfq
-	pushq	$__KERNEL_CS
-	pushq	$repeat_nmi
-
-	/* Put stack back */
-	addq	$(6*8), %rsp
-
-nested_nmi_out:
-	popq	%rdx
-
-	/* We are returning to kernel mode, so this cannot result in a fault. */
-	iretq
-
-first_nmi:
-	/* Restore rdx. */
-	movq	(%rsp), %rdx
-
-	/* Make room for "NMI executing". */
-	pushq	$0
-
-	/* Leave room for the "iret" frame */
-	subq	$(5*8), %rsp
-
-	/* Copy the "original" frame to the "outermost" frame */
-	.rept 5
-	pushq	11*8(%rsp)
-	.endr
-	UNWIND_HINT_IRET_REGS
-
-	/* Everything up to here is safe from nested NMIs */
-
-#ifdef CONFIG_DEBUG_ENTRY
-	/*
-	 * For ease of testing, unmask NMIs right away.  Disabled by
-	 * default because IRET is very expensive.
-	 */
-	pushq	$0		/* SS */
-	pushq	%rsp		/* RSP (minus 8 because of the previous push) */
-	addq	$8, (%rsp)	/* Fix up RSP */
-	pushfq			/* RFLAGS */
-	pushq	$__KERNEL_CS	/* CS */
-	pushq	$1f		/* RIP */
-	iretq			/* continues at repeat_nmi below */
-	UNWIND_HINT_IRET_REGS
-1:
-#endif
-
-repeat_nmi:
-	ANNOTATE_NOENDBR // this code
-	/*
-	 * If there was a nested NMI, the first NMI's iret will return
-	 * here. But NMIs are still enabled and we can take another
-	 * nested NMI. The nested NMI checks the interrupted RIP to see
-	 * if it is between repeat_nmi and end_repeat_nmi, and if so
-	 * it will just return, as we are about to repeat an NMI anyway.
-	 * This makes it safe to copy to the stack frame that a nested
-	 * NMI will update.
-	 *
-	 * RSP is pointing to "outermost RIP".  gsbase is unknown, but, if
-	 * we're repeating an NMI, gsbase has the same value that it had on
-	 * the first iteration.  paranoid_entry will load the kernel
-	 * gsbase if needed before we call exc_nmi().  "NMI executing"
-	 * is zero.
-	 */
-	movq	$1, 10*8(%rsp)		/* Set "NMI executing". */
-
-	/*
-	 * Copy the "outermost" frame to the "iret" frame.  NMIs that nest
-	 * here must not modify the "iret" frame while we're writing to
-	 * it or it will end up containing garbage.
-	 */
-	addq	$(10*8), %rsp
-	.rept 5
-	pushq	-6*8(%rsp)
-	.endr
-	subq	$(5*8), %rsp
-end_repeat_nmi:
-	ANNOTATE_NOENDBR // this code
-
-	/*
-	 * Everything below this point can be preempted by a nested NMI.
-	 * If this happens, then the inner NMI will change the "iret"
-	 * frame to point back to repeat_nmi.
-	 */
-	pushq	$-1				/* ORIG_RAX: no syscall to restart */
-
-	PUSH_AND_CLEAR_REGS
-	UNWIND_HINT_REGS
-	ENCODE_FRAME_POINTER
-
-	/*
-	 * Use paranoid_entry to handle SWAPGS, but no need to use paranoid_exit
-	 * as we should not be calling schedule in NMI context.
-	 * Even with normal interrupts enabled. An NMI should not be
-	 * setting NEED_RESCHED or anything that normal interrupts and
-	 * exceptions might do.
-	 */
-	call	paranoid_entry
-
-	movq	%rsp, %rdi
-	movq	$-1, %rsi
-	call	exc_nmi
-
-	/* Always restore stashed SPEC_CTRL value (see paranoid_entry) */
-	IBRS_EXIT save_reg=%r15
-
-	/* Always restore stashed CR3 value (see paranoid_entry) */
-	RESTORE_CR3 scratch_reg=%r15 save_reg=%r14
-
-	/*
-	 * The above invocation of paranoid_entry stored the GSBASE
-	 * related information in R/EBX depending on the availability
-	 * of FSGSBASE.
-	 *
-	 * If FSGSBASE is enabled, restore the saved GSBASE value
-	 * unconditionally, otherwise take the conditional SWAPGS path.
-	 */
-	ALTERNATIVE "jmp nmi_no_fsgsbase", "", X86_FEATURE_FSGSBASE
-
-	wrgsbase	%rbx
-	jmp	nmi_restore
-
-nmi_no_fsgsbase:
-	/* EBX == 0 -> invoke SWAPGS */
-	testl	%ebx, %ebx
-	jnz	nmi_restore
-
-nmi_swapgs:
-	swapgs
-
-nmi_restore:
-	POP_REGS
-
-	/*
-	 * Skip orig_ax and the "outermost" frame to point RSP at the "iret"
-	 * at the "iret" frame.
-	 */
-	addq	$6*8, %rsp
-
-	/*
-	 * Clear "NMI executing".  Set DF first so that we can easily
-	 * distinguish the remaining code between here and IRET from
-	 * the SYSCALL entry and exit paths.
-	 *
-	 * We arguably should just inspect RIP instead, but I (Andy) wrote
-	 * this code when I had the misapprehension that Xen PV supported
-	 * NMIs, and Xen PV would break that approach.
-	 */
-	std
-	movq	$0, 5*8(%rsp)		/* clear "NMI executing" */
-
-	/*
-	 * iretq reads the "iret" frame and exits the NMI stack in a
-	 * single instruction.  We are returning to kernel mode, so this
-	 * cannot result in a fault.  Similarly, we don't need to worry
-	 * about espfix64 on the way back to kernel mode.
-	 */
-	iretq
-SYM_CODE_END(asm_exc_nmi)
-
 #ifndef CONFIG_IA32_EMULATION
 /*
  * This handles SYSCALL from 32-bit code.  There is no way to program
diff --git a/arch/x86/entry/ist_entry.c b/arch/x86/entry/ist_entry.c
index e1b06306ac51..407571cc4a8c 100644
--- a/arch/x86/entry/ist_entry.c
+++ b/arch/x86/entry/ist_entry.c
@@ -41,7 +41,7 @@ static __always_inline bool identify_ist_##sym_name(				\
 	return true;								\
 }
 
-DEFINE_IDENTIFY_IST(NMI, nmi, false)
+DEFINE_IDENTIFY_IST(NMI, nmi, true)
 DEFINE_IDENTIFY_IST(DB, debug, false)
 DEFINE_IDENTIFY_IST(MCE, machine_check, false)
 DEFINE_IDENTIFY_IST(VC, vmm_communication, false)
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index b241af4ce9b4..b568f1de6da6 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -450,6 +450,9 @@ __visible noinstr void func(struct pt_regs *regs,			\
 	idtentry_sysvec vector func
 
 #ifdef CONFIG_X86_64
+# define DECLARE_IDTENTRY_NMI(vector, func)				\
+	idtentry_ist vector asm_##func func func has_error_code=0 stack_offset=CEA_stacks_NMI
+
 # define DECLARE_IDTENTRY_MCE(vector, func)				\
 	idtentry_mce_db vector asm_##func func
 
@@ -475,11 +478,11 @@ __visible noinstr void func(struct pt_regs *regs,			\
 /* No ASM emitted for XEN hypervisor callback */
 # define DECLARE_IDTENTRY_XENCB(vector, func)
 
-#endif
-
-/* No ASM code emitted for NMI */
+/* No ASM code emitted for NMI for X86_32 */
 #define DECLARE_IDTENTRY_NMI(vector, func)
 
+#endif
+
 /*
  * ASM code to emit the common vector entry stubs where each stub is
  * packed into IDT_ALIGN bytes.
-- 
2.19.1.6.gb485710b

