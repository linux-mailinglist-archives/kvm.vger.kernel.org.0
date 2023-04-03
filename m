Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6BD6D467B
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjDCOGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbjDCOGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:06:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C514D2BECB;
        Mon,  3 Apr 2023 07:05:52 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j13so27313926pjd.1;
        Mon, 03 Apr 2023 07:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680530747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tkuw81I/aX6b/59j6Co6HUBjcgFUTGOqJSCJO2DhDcg=;
        b=WuEa5G/4lBckHk7nq/DPvThZPQB4AtqBwCaNe03LCce8Z0MhcMozEMEJLbD+Bo0dYi
         C/jTla1EEkMqkgYTgh7HzYYFNAkE2z8CQTF35/TZWQd20OzBgLLGjXgNyotvzOAa/Iou
         bdJO/M+EoYeMKzv9QkqTrPskMX+bvj3VcDyMb9LlEvy0kuafQqENXnL8zPh5zy9WKByb
         cBwzZc8YL2YQOJeAGueAc4aIWgH+xYK7omuyQbKNiga7Ok0+WxW1qDFoHqvZR5Ybr2Vz
         eRURMUSlR9vXzXp/TEfFYh8ydoD17LIENSsj3X5HWVbPkfxLA7AC5DjyGNIIO+gJThlE
         Mclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680530747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tkuw81I/aX6b/59j6Co6HUBjcgFUTGOqJSCJO2DhDcg=;
        b=ZVVaPzh2q/xyvV7weFvHhMreBJv/WhbVAmp+Cwt9cRy/nn5s42S+s3rbRvFmUekQ33
         n2wl5X9AwOGqWg+XXPlG6QW5PcF94S4EZfG1ag6+sO+NZMZ4oE+3Hl0DUVZla3PyUyek
         zVEGJgwQjSMuc2XIWgoj7zZAck3OaKm6j48QvCUQiSPvRD0QXFqc25Mojk+RYjQDV/r4
         +fqdTgcBxsLgGLdVCr4jovdHWOfIyiKlA7C+/+1zWM1UG+6ONV6J55x7Xea40LpBavcL
         zXdonTguIuyWIxH96Uj8n/xXCeqHsD7NXFH8Kkcdd3mmJG6wsZjbY/mfbOWBad29Bofn
         hrWg==
X-Gm-Message-State: AAQBX9eLAxUeUMFN+S0664MJ7Gh9NSoopUPvbAdjIBrftLcoZV2lIRhL
        vUNUycQp+gmKwbIr5o8wsWb/NLZ5IM4=
X-Google-Smtp-Source: AKy350Z0p2YSQMmwfxiGhhWsJRHhupcmkaKVxEfihpzfkjQKsa/LZdMbwlGjQUyc15H7/2/cg07nYA==
X-Received: by 2002:a17:903:807:b0:1a2:a298:6f65 with SMTP id kr7-20020a170903080700b001a2a2986f65mr10187229plb.2.1680530746444;
        Mon, 03 Apr 2023 07:05:46 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id bf12-20020a170902b90c00b00198fb25d09bsm6609339plb.237.2023.04.03.07.05.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Apr 2023 07:05:46 -0700 (PDT)
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
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [RFC PATCH 6/7] x86/entry: Use atomic-IST-entry for VC
Date:   Mon,  3 Apr 2023 22:06:04 +0800
Message-Id: <20230403140605.540512-7-jiangshanlai@gmail.com>
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
 arch/x86/entry/entry_64.S             |  83 --------------------
 arch/x86/entry/ist_entry.c            |   2 +-
 arch/x86/include/asm/cpu_entry_area.h |   3 -
 arch/x86/include/asm/idtentry.h       |   2 +-
 arch/x86/include/asm/sev.h            |  14 ----
 arch/x86/include/asm/traps.h          |   1 -
 arch/x86/kernel/dumpstack_64.c        |   4 +-
 arch/x86/kernel/nmi.c                 |   8 --
 arch/x86/kernel/sev.c                 | 108 --------------------------
 arch/x86/kernel/traps.c               |  43 ----------
 arch/x86/mm/cpu_entry_area.c          |   1 -
 11 files changed, 3 insertions(+), 266 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index e4ddc793f841..187d42efd288 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -621,89 +621,6 @@ _ASM_NOKPROBE(\asmsym)
 SYM_CODE_END(\asmsym)
 .endm
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-/**
- * idtentry_vc - Macro to generate entry stub for #VC
- * @vector:		Vector number
- * @asmsym:		ASM symbol for the entry point
- * @cfunc:		C function to be called
- *
- * The macro emits code to set up the kernel context for #VC. The #VC handler
- * runs on an IST stack and needs to be able to cause nested #VC exceptions.
- *
- * To make this work the #VC entry code tries its best to pretend it doesn't use
- * an IST stack by switching to the task stack if coming from user-space (which
- * includes early SYSCALL entry path) or back to the stack in the IRET frame if
- * entered from kernel-mode.
- *
- * If entered from kernel-mode the return stack is validated first, and if it is
- * not safe to use (e.g. because it points to the entry stack) the #VC handler
- * will switch to a fall-back stack (VC2) and call a special handler function.
- *
- * The macro is only used for one vector, but it is planned to be extended in
- * the future for the #HV exception.
- */
-.macro idtentry_vc vector asmsym cfunc
-SYM_CODE_START(\asmsym)
-	UNWIND_HINT_IRET_REGS
-	ENDBR
-	ASM_CLAC
-	cld
-
-	/*
-	 * If the entry is from userspace, switch stacks and treat it as
-	 * a normal entry.
-	 */
-	testb	$3, CS-ORIG_RAX(%rsp)
-	jnz	.Lfrom_usermode_switch_stack_\@
-
-	PUSH_AND_CLEAR_REGS
-	UNWIND_HINT_REGS
-	ENCODE_FRAME_POINTER
-
-	/*
-	 * paranoid_entry returns SWAPGS flag for paranoid_exit in EBX.
-	 * EBX == 0 -> SWAPGS, EBX == 1 -> no SWAPGS
-	 */
-	call	paranoid_entry
-
-	/*
-	 * Switch off the IST stack to make it free for nested exceptions. The
-	 * vc_switch_off_ist() function will switch back to the interrupted
-	 * stack if it is safe to do so. If not it switches to the VC fall-back
-	 * stack.
-	 */
-	movq	%rsp, %rdi		/* pt_regs pointer */
-	call	vc_switch_off_ist
-	movq	%rax, %rsp		/* Switch to new stack */
-
-	ENCODE_FRAME_POINTER
-	UNWIND_HINT_REGS
-
-	/* Update pt_regs */
-	movq	ORIG_RAX(%rsp), %rsi	/* get error code into 2nd argument*/
-	movq	$-1, ORIG_RAX(%rsp)	/* no syscall to restart */
-
-	movq	%rsp, %rdi		/* pt_regs pointer */
-
-	call	kernel_\cfunc
-
-	/*
-	 * No need to switch back to the IST stack. The current stack is either
-	 * identical to the stack in the IRET frame or the VC fall-back stack,
-	 * so it is definitely mapped even with PTI enabled.
-	 */
-	jmp	paranoid_exit
-
-	/* Switch to the regular task stack */
-.Lfrom_usermode_switch_stack_\@:
-	idtentry_body user_\cfunc, has_error_code=1
-
-_ASM_NOKPROBE(\asmsym)
-SYM_CODE_END(\asmsym)
-.endm
-#endif
-
 /*
  * Double fault entry. Straight paranoid. No checks from which context
  * this comes because for the espfix induced #DF this would do the wrong
diff --git a/arch/x86/entry/ist_entry.c b/arch/x86/entry/ist_entry.c
index 946b3b537bd5..c0cbd4527033 100644
--- a/arch/x86/entry/ist_entry.c
+++ b/arch/x86/entry/ist_entry.c
@@ -44,7 +44,7 @@ static __always_inline bool identify_ist_##sym_name(				\
 DEFINE_IDENTIFY_IST(NMI, nmi, true)
 DEFINE_IDENTIFY_IST(DB, debug, true)
 DEFINE_IDENTIFY_IST(MCE, machine_check, IS_ENABLED(CONFIG_X86_MCE))
-DEFINE_IDENTIFY_IST(VC, vmm_communication, false)
+DEFINE_IDENTIFY_IST(VC, vmm_communication, IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
 
 static __always_inline bool identify_ist(
 		const struct pt_regs *regs, struct cea_exception_stacks *stacks,
diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index a373e8c37e25..618aa698eb82 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -30,8 +30,6 @@
 	char	MCE_stack[EXCEPTION_STKSZ];			\
 	char	VC_stack_guard[guardsize];			\
 	char	VC_stack[optional_stack_size];			\
-	char	VC2_stack_guard[guardsize];			\
-	char	VC2_stack[optional_stack_size];			\
 	char	IST_stack_guard[guardsize];			\
 	char	IST_stack[IST_MAIN_STKSZ];			\
 	char	IST_top_guard[guardsize];			\
@@ -55,7 +53,6 @@ enum exception_stack_ordering {
 	ESTACK_DB,
 	ESTACK_MCE,
 	ESTACK_VC,
-	ESTACK_VC2,
 	ESTACK_IST,
 	N_EXCEPTION_STACKS
 };
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 01f3152ffe82..5f3250e589ec 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -466,7 +466,7 @@ __visible noinstr void func(struct pt_regs *regs,			\
 	DECLARE_IDTENTRY(vector, func)
 
 # define DECLARE_IDTENTRY_VC(vector, func)				\
-	idtentry_vc vector asm_##func func
+	idtentry_ist vector asm_##func kernel_##func user_##func has_error_code=1 stack_offset=CEA_stacks_VC
 
 #else
 # define DECLARE_IDTENTRY_MCE(vector, func)				\
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ebc271bb6d8e..ce554b3a818d 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -135,18 +135,6 @@ struct snp_secrets_page_layout {
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern struct static_key_false sev_es_enable_key;
-extern void __sev_es_ist_enter(struct pt_regs *regs);
-extern void __sev_es_ist_exit(void);
-static __always_inline void sev_es_ist_enter(struct pt_regs *regs)
-{
-	if (static_branch_unlikely(&sev_es_enable_key))
-		__sev_es_ist_enter(regs);
-}
-static __always_inline void sev_es_ist_exit(void)
-{
-	if (static_branch_unlikely(&sev_es_enable_key))
-		__sev_es_ist_exit();
-}
 extern int sev_es_setup_ap_jump_table(struct real_mode_header *rmh);
 extern void __sev_es_nmi_complete(void);
 static __always_inline void sev_es_nmi_complete(void)
@@ -198,8 +186,6 @@ bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
 int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, unsigned long *fw_err);
 #else
-static inline void sev_es_ist_enter(struct pt_regs *regs) { }
-static inline void sev_es_ist_exit(void) { }
 static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
 static inline void sev_es_nmi_complete(void) { }
 static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 47ecfff2c83d..dc0da530f951 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -15,7 +15,6 @@ asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *eregs);
 asmlinkage __visible notrace
 struct pt_regs *fixup_bad_iret(struct pt_regs *bad_regs);
 void __init trap_init(void);
-asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *eregs);
 #endif
 
 extern bool ibt_selftest(void);
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 3413b23fa9f1..b7ef2685f63b 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -25,7 +25,6 @@ static const char * const exception_stack_names[] = {
 		[ ESTACK_DB	]	= "#DB",
 		[ ESTACK_MCE	]	= "#MC",
 		[ ESTACK_VC	]	= "#VC",
-		[ ESTACK_VC2	]	= "#VC2",
 		[ ESTACK_IST	]	= "#IST",
 };
 
@@ -89,7 +88,6 @@ struct estack_pages estack_pages[CEA_ESTACK_PAGES] ____cacheline_aligned = {
 	EPAGERANGE(DB),
 	EPAGERANGE(MCE),
 	EPAGERANGE(VC),
-	EPAGERANGE(VC2),
 	EPAGERANGE(IST),
 };
 
@@ -100,7 +98,7 @@ static __always_inline bool in_exception_stack(unsigned long *stack, struct stac
 	struct pt_regs *regs;
 	unsigned int k;
 
-	BUILD_BUG_ON(N_EXCEPTION_STACKS != 7);
+	BUILD_BUG_ON(N_EXCEPTION_STACKS != 6);
 
 	begin = (unsigned long)__this_cpu_read(cea_exception_stacks);
 	/*
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 776f4b1e395b..bafd0c7ca5b7 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -514,12 +514,6 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 	}
 nmi_restart:
 
-	/*
-	 * Needs to happen before DR7 is accessed, because the hypervisor can
-	 * intercept DR7 reads/writes, turning those into #VC exceptions.
-	 */
-	sev_es_ist_enter(regs);
-
 	this_cpu_write(nmi_dr7, local_db_save());
 
 	irq_state = irqentry_nmi_enter(regs);
@@ -544,8 +538,6 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 
 	local_db_restore(this_cpu_read(nmi_dr7));
 
-	sev_es_ist_exit();
-
 	if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))
 		write_cr2(this_cpu_read(nmi_cr2));
 	if (this_cpu_dec_return(nmi_state))
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 679026a640ef..74d55786c353 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -122,77 +122,6 @@ struct sev_config {
 
 static struct sev_config sev_cfg __read_mostly;
 
-static __always_inline bool on_vc_stack(struct pt_regs *regs)
-{
-	unsigned long sp = regs->sp;
-
-	/* User-mode RSP is not trusted */
-	if (user_mode(regs))
-		return false;
-
-	/* SYSCALL gap still has user-mode RSP */
-	if (ip_within_syscall_gap(regs))
-		return false;
-
-	return ((sp >= __this_cpu_ist_bottom_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
-}
-
-/*
- * This function handles the case when an NMI is raised in the #VC
- * exception handler entry code, before the #VC handler has switched off
- * its IST stack. In this case, the IST entry for #VC must be adjusted,
- * so that any nested #VC exception will not overwrite the stack
- * contents of the interrupted #VC handler.
- *
- * The IST entry is adjusted unconditionally so that it can be also be
- * unconditionally adjusted back in __sev_es_ist_exit(). Otherwise a
- * nested sev_es_ist_exit() call may adjust back the IST entry too
- * early.
- *
- * The __sev_es_ist_enter() and __sev_es_ist_exit() functions always run
- * on the NMI IST stack, as they are only called from NMI handling code
- * right now.
- */
-void noinstr __sev_es_ist_enter(struct pt_regs *regs)
-{
-	unsigned long old_ist, new_ist;
-
-	/* Read old IST entry */
-	new_ist = old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
-
-	/*
-	 * If NMI happened while on the #VC IST stack, set the new IST
-	 * value below regs->sp, so that the interrupted stack frame is
-	 * not overwritten by subsequent #VC exceptions.
-	 */
-	if (on_vc_stack(regs))
-		new_ist = regs->sp;
-
-	/*
-	 * Reserve additional 8 bytes and store old IST value so this
-	 * adjustment can be unrolled in __sev_es_ist_exit().
-	 */
-	new_ist -= sizeof(old_ist);
-	*(unsigned long *)new_ist = old_ist;
-
-	/* Set new IST entry */
-	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], new_ist);
-}
-
-void noinstr __sev_es_ist_exit(void)
-{
-	unsigned long ist;
-
-	/* Read IST entry */
-	ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
-
-	if (WARN_ON(ist == __this_cpu_ist_top_va(VC)))
-		return;
-
-	/* Read back old IST entry and write it to the TSS */
-	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], *(unsigned long *)ist);
-}
-
 /*
  * Nothing shall interrupt this code path while holding the per-CPU
  * GHCB. The backup GHCB is only for NMIs interrupting this path.
@@ -1841,26 +1770,6 @@ static __always_inline void vc_forward_exception(struct es_em_ctxt *ctxt)
 	}
 }
 
-static __always_inline bool is_vc2_stack(unsigned long sp)
-{
-	return (sp >= __this_cpu_ist_bottom_va(VC2) && sp < __this_cpu_ist_top_va(VC2));
-}
-
-static __always_inline bool vc_from_invalid_context(struct pt_regs *regs)
-{
-	unsigned long sp, prev_sp;
-
-	sp      = (unsigned long)regs;
-	prev_sp = regs->sp;
-
-	/*
-	 * If the code was already executing on the VC2 stack when the #VC
-	 * happened, let it proceed to the normal handling routine. This way the
-	 * code executing on the VC2 stack can cause #VC exceptions to get handled.
-	 */
-	return is_vc2_stack(sp) && !is_vc2_stack(prev_sp);
-}
-
 static bool vc_raw_handle_exception(struct pt_regs *regs, unsigned long error_code)
 {
 	struct ghcb_state state;
@@ -1930,23 +1839,6 @@ DEFINE_IDTENTRY_VC_KERNEL(exc_vmm_communication)
 {
 	irqentry_state_t irq_state;
 
-	/*
-	 * With the current implementation it is always possible to switch to a
-	 * safe stack because #VC exceptions only happen at known places, like
-	 * intercepted instructions or accesses to MMIO areas/IO ports. They can
-	 * also happen with code instrumentation when the hypervisor intercepts
-	 * #DB, but the critical paths are forbidden to be instrumented, so #DB
-	 * exceptions currently also only happen in safe places.
-	 *
-	 * But keep this here in case the noinstr annotations are violated due
-	 * to bug elsewhere.
-	 */
-	if (unlikely(vc_from_invalid_context(regs))) {
-		instrumentation_begin();
-		panic("Can't handle #VC exception from unsupported context\n");
-		instrumentation_end();
-	}
-
 	/*
 	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
 	 */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d317dc3d06a3..6c697c175f7a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -864,49 +864,6 @@ asmlinkage __visible noinstr struct pt_regs *sync_regs(struct pt_regs *eregs)
 	return regs;
 }
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *regs)
-{
-	unsigned long sp, *stack;
-	struct stack_info info;
-	struct pt_regs *regs_ret;
-
-	/*
-	 * In the SYSCALL entry path the RSP value comes from user-space - don't
-	 * trust it and switch to the current kernel stack
-	 */
-	if (ip_within_syscall_gap(regs)) {
-		sp = this_cpu_read(pcpu_hot.top_of_stack);
-		goto sync;
-	}
-
-	/*
-	 * From here on the RSP value is trusted. Now check whether entry
-	 * happened from a safe stack. Not safe are the entry or unknown stacks,
-	 * use the fall-back stack instead in this case.
-	 */
-	sp    = regs->sp;
-	stack = (unsigned long *)sp;
-
-	if (!get_stack_info_noinstr(stack, current, &info) || info.type == STACK_TYPE_ENTRY ||
-	    info.type > STACK_TYPE_EXCEPTION_LAST)
-		sp = __this_cpu_ist_top_va(VC2);
-
-sync:
-	/*
-	 * Found a safe stack - switch to it as if the entry didn't happen via
-	 * IST stack. The code below only copies pt_regs, the real switch happens
-	 * in assembly code.
-	 */
-	sp = ALIGN_DOWN(sp, 8) - sizeof(*regs_ret);
-
-	regs_ret = (struct pt_regs *)sp;
-	*regs_ret = *regs;
-
-	return regs_ret;
-}
-#endif
-
 asmlinkage __visible noinstr struct pt_regs *fixup_bad_iret(struct pt_regs *bad_regs)
 {
 	struct pt_regs tmp, *new_stack;
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 62341cb819ab..7df1301ec343 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -153,7 +153,6 @@ static void __init percpu_setup_exception_stacks(unsigned int cpu)
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
 		if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
 			cea_map_stack(VC);
-			cea_map_stack(VC2);
 		}
 	}
 }
-- 
2.19.1.6.gb485710b

