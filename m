Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBDB76BD2E
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 21:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjHATB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 15:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjHATBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 15:01:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B55D1B6
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 12:01:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56cf9a86277so74214437b3.3
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 12:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690916477; x=1691521277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6dm7mDs/QRbe10huX8K6gEhxhyCrqJzyAo9u27HeE6w=;
        b=J5GQt97bUuhSZbWtCfXdnF37hw3zRFmggpgXFePbfydkgIO7T1qEq3TC7f2qz7LLlB
         4S49rV6qgmg3/1l7yVS022ikDEXmKlfxNhAqIDWvOchRNowXWLLBy8iIxpAA/cT2wvOj
         0Jut4JR9bEMoTT1P2cTZf83PChcuoKX14DaGcu7FEuFVDg3mxNwmKtE3VgJDMNgE7MkD
         qC/oqkmws4pn49hZ8CNZrDufM0eGNvp8S3xY09c5Nn1FRHXe1bqAvy/+d7JqHlPxTLKn
         yaIphA2Z9J7Icu9PWR1Vc38L8VhqePDOXgAC9cI1GdFOazdrFTAWSjBwE0/ppSeYpBGV
         xMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690916477; x=1691521277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6dm7mDs/QRbe10huX8K6gEhxhyCrqJzyAo9u27HeE6w=;
        b=MjWNVuQ7wEa+BGN6VI4ZP/+AjPPjhEf8AR3LmqyPMihBOTM1/yLHmQS0qyTtYKIABH
         ra5uJjm5jzzzp1ZwmdtbNIFpJQiOrGp5kXeFoeDhwpiCeXXp4OOvaORsyf7BlsTpiyrk
         JefSGUVwq8Ln2NRm3ah7/zpQXYBALCtXj/vICf01aomKygOa0jTJR8dVw4Bagjnjbwvz
         OwUIuP/GoplVeausAMTjPLlNNRUW3QJnjzJMnJbEXakE4xhN+eCf4tuiQxqLxbpOhDuz
         h5R4wro/vevUdBMVaoiZEceegsfDzaiu5Gvbkpto45syjN/f6Wqm+UHC/YA7nRMxqhe0
         0PvA==
X-Gm-Message-State: ABy/qLaB3QokyB7jwWENccCpI4MUuT//xVvC301ckBOeWuYws0lGD2uH
        TEWkNbz5Tl2UjJd5CrIZ2ZQ22GNbYak=
X-Google-Smtp-Source: APBJJlGmS9vDxvKMs0vj75dQg8WdrWLo21/ggGbLQ/stLSWTeYc5YOHqkncZwnm3qxat2TVzW25JPR0Oz6k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad15:0:b0:d12:d6e4:a08f with SMTP id
 y21-20020a25ad15000000b00d12d6e4a08fmr86035ybi.6.1690916477204; Tue, 01 Aug
 2023 12:01:17 -0700 (PDT)
Date:   Tue, 1 Aug 2023 19:01:15 +0000
In-Reply-To: <20230801083553.8468-7-xin3.li@intel.com>
Mime-Version: 1.0
References: <20230801083553.8468-1-xin3.li@intel.com> <20230801083553.8468-7-xin3.li@intel.com>
Message-ID: <ZMlWe5TgS6HM98Mg@google.com>
Subject: Re: [PATCH RESEND v9 33/36] KVM: VMX: Add VMX_DO_FRED_EVENT_IRQOFF
 for IRQ/NMI handling
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Breno Leitao <leitao@debian.org>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Brian Gerst <brgerst@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ze Gao <zegao2021@gmail.com>, Fei Li <fei1.li@intel.com>,
        Conghui <conghui.chen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sathvika Vasireddy <sv@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, Xin Li wrote:
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 07e927d4d099..5ee6a57b59a5 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -2,12 +2,14 @@
>  #include <linux/linkage.h>
>  #include <asm/asm.h>
>  #include <asm/bitsperlong.h>
> +#include <asm/fred.h>
>  #include <asm/kvm_vcpu_regs.h>
>  #include <asm/nospec-branch.h>
>  #include <asm/percpu.h>
>  #include <asm/segment.h>
>  #include "kvm-asm-offsets.h"
>  #include "run_flags.h"
> +#include "../../entry/calling.h"

Rather than do the low level PUSH_REGS and POP_REGS, I vote to have core code
expose a FRED-specific wrapper for invoking external_interrupt().  More below.

>  
>  #define WORD_SIZE (BITS_PER_LONG / 8)
>  
> @@ -31,6 +33,80 @@
>  #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
>  #endif
>  
> +#ifdef CONFIG_X86_FRED
> +.macro VMX_DO_FRED_EVENT_IRQOFF branch_insn branch_target nmi=0

objtool isn't happy.

arch/x86/kvm/vmx/vmenter.o: warning: objtool: vmx_do_fred_interrupt_irqoff+0x6c: return with modified stack frame
arch/x86/kvm/vmx/vmenter.o: warning: objtool: vmx_do_fred_nmi_irqoff+0x37: sibling call from callable instruction with modified stack frame

The "return with modified stack frame" goes away with my suggested changes, but
the sibling call remains for the NMI case due to the JMP instead of a call.

> +	/*
> +	 * Unconditionally create a stack frame, getting the correct RSP on the
> +	 * stack (for x86-64) would take two instructions anyways, and RBP can
> +	 * be used to restore RSP to make objtool happy (see below).
> +	 */
> +	push %_ASM_BP
> +	mov %_ASM_SP, %_ASM_BP

The frame stuff is worth throwing in a macro, if only to avoid a copy+pasted
comment, which by the by, is wrong.  (a) it's ERETS, not IRET.  (b) the IRQ does
a vanilla RET, not ERETS.  E.g. like so:

.macro VMX_DO_EVENT_FRAME_BEGIN
	/*
	 * Unconditionally create a stack frame, getting the correct RSP on the
	 * stack (for x86-64) would take two instructions anyways, and RBP can
	 * be used to restore RSP to make objtool happy (see below).
	 */
	push %_ASM_BP
	mov %_ASM_SP, %_ASM_BP
.endm

.macro VMX_DO_EVENT_FRAME_END
	/*
	 * "Restore" RSP from RBP, even though {E,I}RET has already unwound RSP
	 * to the correct value *in most cases*.  KVM's IRQ handling with FRED
	 * doesn't do ERETS, and objtool doesn't know the callee will IRET/ERET
	 * and, without the explicit restore, thinks the stack is getting walloped.
	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
	 */
	mov %_ASM_BP, %_ASM_SP
	pop %_ASM_BP
.endm

> +
> +	/*
> +	 * Don't check the FRED stack level, the call stack leading to this
> +	 * helper is effectively constant and shallow (relatively speaking).
> +	 *
> +	 * Emulate the FRED-defined redzone and stack alignment.
> +	 */
> +	sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
> +	and $FRED_STACK_FRAME_RSP_MASK, %rsp
> +
> +	/*
> +	 * A FRED stack frame has extra 16 bytes of information pushed at the
> +	 * regular stack top compared to an IDT stack frame.

There is pretty much no chance that anyone remembers the layout of an IDT stack
frame off the top of their head.  I.e. saying "FRED has 16 bytes more" isn't all
that useful.  It also fails to capture the fact that FRED stuff a hell of a lot
more information in those "common" 48 bytes.

It'll be hard/impossible to capture all of the overload info in a comment, but
showing the actual layout of the frame would be super helpful, e.g. something like
this

	/*
	 * FRED stack frames are always 64 bytes:
	 *
	 * ------------------------------
	 * | Bytes  | Usage             |
	 * -----------------------------|
	 * | 63:56  | Reserved          |
	 * | 55:48  | Event Data        | 
         * | 47:40  | SS + Event Info   |
         * | 39:32  | RSP               |
	 * | 31:24  | RFLAGS            |
         * | 23:16  | CS + Aux Info     |
         * |  15:8  | RIP               |
         * |   7:0  | Error Code        |    
         * ------------------------------           
	 */

> +	 */
> +	push $0		/* Reserved by FRED, must be 0 */
> +	push $0		/* FRED event data, 0 for NMI and external interrupts */
> +
> +	shl $32, %rdi				/* FRED event type and vector */
> +	.if \nmi
> +	bts $FRED_SSX_NMI_BIT, %rdi		/* Set the NMI bit */

The spec I have from May 2022 says the NMI bit colocated with CS, not SS.  And
the cover letter's suggestion to use a search engine to find the spec ain't
exactly helpful, that just gives me the same "May 2022 Revision 3.0" spec.  So
either y'all have a spec that I can't find, or this is wrong.

> +	.endif
> +	bts $FRED_SSX_64_BIT_MODE_BIT, %rdi	/* Set the 64-bit mode */
> +	or $__KERNEL_DS, %rdi
> +	push %rdi
> +	push %rbp
> +	pushf
> +	mov $__KERNEL_CS, %rax
> +	push %rax
> +
> +	/*
> +	 * Unlike the IDT event delivery, FRED _always_ pushes an error code
> +	 * after pushing the return RIP, thus the CALL instruction CANNOT be
> +	 * used here to push the return RIP, otherwise there is no chance to
> +	 * push an error code before invoking the IRQ/NMI handler.
> +	 *
> +	 * Use LEA to get the return RIP and push it, then push an error code.
> +	 */
> +	lea 1f(%rip), %rax

This is quite misleading for IRQs.  It took me a while to figure out that the only
reason it's functionally ok is that external_interrupt() will do RET, not ERETS,
i.e. the RIP that's pushed here isn't used for IRQs!  Expanding the above comment
would be quite helpful, e.g.

	 *
	 * Use LEA to get the return RIP and push it, then push an error code.
	 * Note, only NMI handling does an ERETS to the target!  IRQ handling
	 * doesn't need to unmask NMIs and so simply uses CALL+RET, i.e. the
	 * RIP pushed here is only truly consumed for NMIs!

> +	push %rax
> +	push $0		/* FRED error code, 0 for NMI and external interrupts */
> +
> +	.if \nmi == 0
> +	PUSH_REGS
> +	mov %rsp, %rdi

Nit, *if* this stays in KVM, please use %_ASM_ARG1 instead of %rdi.  I normally
dislike unnecessary abstraction, but in this case using _ASM_ARG1 makes it clear
(without a comment) that this code is loading a param for a funciton call, *not*
for some FRED magic.

> +	.endif

Jumping way back to providing a wrapper for FRED, if we do that, then there's no
need to include calling.h, and the weird wrinkle about the ERET target kinda goes
away too.  E.g. provide this in arch/x86/entry/entry_64_fred.S

	.section .text, "ax"

/* Note, this is instrumentation safe, and returns via RET, not ERETS! */
#if IS_ENABLED(CONFIG_KVM_INTEL)
SYM_CODE_START(fred_irq_entry_from_kvm)
	FRED_ENTER
	call external_interrupt
	FRED_EXIT
	RET
SYM_CODE_END(fred_irq_entry_from_kvm)
EXPORT_SYMBOL_GPL(fred_irq_entry_from_kvm);
#endif

and then the KVM side for this particular chunk is more simply:

	lea 1f(%rip), %rax
	push %rax
	push $0		/* FRED error code, 0 for NMI and external interrupts */

	\branch_insn \branch_target
1:
	VMX_DO_EVENT_FRAME_END
	RET


Alternatively, the whole thing could be shoved into arch/x86/entry/entry_64_fred.S,
but at a glance I don't think that would be a net positive due to the need to handle
IRQs vs. NMIs.

> +	\branch_insn \branch_target
> +
> +	.if \nmi == 0
> +	POP_REGS
> +	.endif
> +
> +1:
> +	/*
> +	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to

As mentioned above, this is incorrect on two fronts.

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0ecf4be2c6af..4e90c69a92bf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6890,6 +6890,14 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>  	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
>  }
>  
> +#ifdef CONFIG_X86_FRED
> +void vmx_do_fred_interrupt_irqoff(unsigned int vector);
> +void vmx_do_fred_nmi_irqoff(unsigned int vector);
> +#else
> +#define vmx_do_fred_interrupt_irqoff(x) BUG()
> +#define vmx_do_fred_nmi_irqoff(x) BUG()
> +#endif

My slight preference is to open code the BUG() as a ud2 in assembly, purely to
avoid more #ifdefs.

> +
>  void vmx_do_interrupt_irqoff(unsigned long entry);
>  void vmx_do_nmi_irqoff(void);
>  
> @@ -6932,14 +6940,16 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  {
>  	u32 intr_info = vmx_get_intr_info(vcpu);
>  	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
> -	gate_desc *desc = (gate_desc *)host_idt_base + vector;
>  
>  	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
>  	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
>  		return;
>  
>  	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
> -	vmx_do_interrupt_irqoff(gate_offset(desc));
> +	if (cpu_feature_enabled(X86_FEATURE_FRED))
> +		vmx_do_fred_interrupt_irqoff(vector);	/* Event type is 0 */

I strongly prefer to use code to document what's going on.  E.g. the tail comment
just left me wondering, what event type is 0?  Whereas this makes it quite clear
that KVM is signaling a hardware interrupt.  The fact that it's a nop as far as
code generation goes is irrelevant.

	vmx_do_fred_interrupt_irqoff((EVENT_TYPE_HWINT << 16) | vector);

> +	else
> +		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base + vector));
>  	kvm_after_interrupt(vcpu);
>  
>  	vcpu->arch.at_instruction_boundary = true;

Here's a diff for (hopefully) everything I've suggested above.

---
 arch/x86/entry/entry_64_fred.S | 17 ++++++-
 arch/x86/kernel/traps.c        |  5 --
 arch/x86/kvm/vmx/vmenter.S     | 84 +++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.c         |  7 +--
 4 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 12063267d2ac..a973c0bd29f6 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -10,7 +10,6 @@
 #include "calling.h"
 
 	.code64
-	.section ".noinstr.text", "ax"
 
 .macro FRED_ENTER
 	UNWIND_HINT_END_OF_STACK
@@ -24,6 +23,22 @@
 	POP_REGS
 .endm
 
+	.section .text, "ax"
+
+/* Note, this is instrumentation safe, and returns via RET, not ERETS! */
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+SYM_CODE_START(fred_irq_entry_from_kvm)
+	FRED_ENTER
+	call external_interrupt
+	FRED_EXIT
+	RET
+SYM_CODE_END(fred_irq_entry_from_kvm)
+EXPORT_SYMBOL_GPL(fred_irq_entry_from_kvm);
+#endif
+
+	.section ".noinstr.text", "ax"
+
+
 /*
  * The new RIP value that FRED event delivery establishes is
  * IA32_FRED_CONFIG & ~FFFH for events that occur in ring 3.
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 21eeba7b188f..cbcb83c71dab 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1566,11 +1566,6 @@ int external_interrupt(struct pt_regs *regs)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_KVM_INTEL)
-/* For KVM VMX to handle IRQs in IRQ induced VM exits. */
-EXPORT_SYMBOL_GPL(external_interrupt);
-#endif
-
 #endif /* CONFIG_X86_64 */
 
 void __init trap_init(void)
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 79a4c91d9434..e25df565c3f8 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -9,7 +9,6 @@
 #include <asm/segment.h>
 #include "kvm-asm-offsets.h"
 #include "run_flags.h"
-#include "../../entry/calling.h"
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
@@ -33,15 +32,31 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
+.macro VMX_DO_EVENT_FRAME_BEGIN
+	/*
+	 * Unconditionally create a stack frame, getting the correct RSP on the
+	 * stack (for x86-64) would take two instructions anyways, and RBP can
+	 * be used to restore RSP to make objtool happy (see below).
+	 */
+	push %_ASM_BP
+	mov %_ASM_SP, %_ASM_BP
+.endm
+
+.macro VMX_DO_EVENT_FRAME_END
+	/*
+	 * "Restore" RSP from RBP, even though {E,I}RET has already unwound RSP
+	 * to the correct value *in most cases*.  KVM's IRQ handling with FRED
+	 * doesn't do ERETS, and objtool doesn't know the callee will IRET/ERET
+	 * and, without the explicit restore, thinks the stack is getting walloped.
+	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
+	 */
+	mov %_ASM_BP, %_ASM_SP
+	pop %_ASM_BP
+.endm
+
 #ifdef CONFIG_X86_FRED
 .macro VMX_DO_FRED_EVENT_IRQOFF branch_insn branch_target nmi=0
-	/*
-	 * Unconditionally create a stack frame, getting the correct RSP on the
-	 * stack (for x86-64) would take two instructions anyways, and RBP can
-	 * be used to restore RSP to make objtool happy (see below).
-	 */
-	push %_ASM_BP
-	mov %_ASM_SP, %_ASM_BP
+	VMX_DO_EVENT_FRAME_BEGIN
 
 	/*
 	 * Don't check the FRED stack level, the call stack leading to this
@@ -78,43 +93,23 @@
 	 * push an error code before invoking the IRQ/NMI handler.
 	 *
 	 * Use LEA to get the return RIP and push it, then push an error code.
+	 * Note, only NMI handling does an ERETS to the target!  IRQ handling
+	 * doesn't need to unmask NMIs and so simply uses CALL+RET, i.e. the
+	 * RIP pushed here is only truly consumed for NMIs!
 	 */
 	lea 1f(%rip), %rax
 	push %rax
 	push $0		/* FRED error code, 0 for NMI and external interrupts */
 
-	.if \nmi == 0
-	PUSH_REGS
-	mov %rsp, %rdi
-	.endif
-
 	\branch_insn \branch_target
-
-	.if \nmi == 0
-	POP_REGS
-	.endif
-
 1:
-	/*
-	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
-	 * the correct value.  objtool doesn't know the callee will IRET and,
-	 * without the explicit restore, thinks the stack is getting walloped.
-	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
-	 */
-	mov %_ASM_BP, %_ASM_SP
-	pop %_ASM_BP
+	VMX_DO_EVENT_FRAME_END
 	RET
 .endm
 #endif
 
 .macro VMX_DO_EVENT_IRQOFF call_insn call_target
-	/*
-	 * Unconditionally create a stack frame, getting the correct RSP on the
-	 * stack (for x86-64) would take two instructions anyways, and RBP can
-	 * be used to restore RSP to make objtool happy (see below).
-	 */
-	push %_ASM_BP
-	mov %_ASM_SP, %_ASM_BP
+	VMX_DO_EVENT_FRAME_BEGIN
 
 #ifdef CONFIG_X86_64
 	/*
@@ -129,14 +124,7 @@
 	push $__KERNEL_CS
 	\call_insn \call_target
 
-	/*
-	 * "Restore" RSP from RBP, even though IRET has already unwound RSP to
-	 * the correct value.  objtool doesn't know the callee will IRET and,
-	 * without the explicit restore, thinks the stack is getting walloped.
-	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
-	 */
-	mov %_ASM_BP, %_ASM_SP
-	pop %_ASM_BP
+	VMX_DO_EVENT_FRAME_END
 	RET
 .endm
 
@@ -375,11 +363,13 @@ SYM_INNER_LABEL_ALIGN(vmx_vmexit, SYM_L_GLOBAL)
 
 SYM_FUNC_END(__vmx_vcpu_run)
 
-#ifdef CONFIG_X86_FRED
 SYM_FUNC_START(vmx_do_fred_nmi_irqoff)
+#ifdef CONFIG_X86_FRED
 	VMX_DO_FRED_EVENT_IRQOFF jmp fred_entrypoint_kernel nmi=1
+#else
+	ud2
+#endif
 SYM_FUNC_END(vmx_do_fred_nmi_irqoff)
-#endif
 
 SYM_FUNC_START(vmx_do_nmi_irqoff)
 	VMX_DO_EVENT_IRQOFF call asm_exc_nmi_kvm_vmx
@@ -438,11 +428,13 @@ SYM_FUNC_END(vmread_error_trampoline)
 #endif
 
 .section .text, "ax"
-#ifdef CONFIG_X86_FRED
 SYM_FUNC_START(vmx_do_fred_interrupt_irqoff)
-	VMX_DO_FRED_EVENT_IRQOFF call external_interrupt
+#ifdef CONFIG_X86_FRED
+	VMX_DO_FRED_EVENT_IRQOFF call fred_irq_entry_from_kvm
+#else
+	ud2
+#endif
 SYM_FUNC_END(vmx_do_fred_interrupt_irqoff)
-#endif
 
 SYM_FUNC_START(vmx_do_interrupt_irqoff)
 	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bf757f5071e4..cb4675dd87df 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6919,13 +6919,8 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-#ifdef CONFIG_X86_FRED
 void vmx_do_fred_interrupt_irqoff(unsigned int vector);
 void vmx_do_fred_nmi_irqoff(unsigned int vector);
-#else
-#define vmx_do_fred_interrupt_irqoff(x) BUG()
-#define vmx_do_fred_nmi_irqoff(x) BUG()
-#endif
 
 void vmx_do_interrupt_irqoff(unsigned long entry);
 void vmx_do_nmi_irqoff(void);
@@ -6976,7 +6971,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
 	if (cpu_feature_enabled(X86_FEATURE_FRED))
-		vmx_do_fred_interrupt_irqoff(vector);	/* Event type is 0 */
+		vmx_do_fred_interrupt_irqoff((EVENT_TYPE_HWINT << 16) | vector);
 	else
 		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base + vector));
 	kvm_after_interrupt(vcpu);

base-commit: 8961078ffe509a97ec7803b17912e57c47b93fa2
-- 

