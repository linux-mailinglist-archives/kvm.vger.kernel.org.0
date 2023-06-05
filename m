Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7BA722741
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbjFENWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjFENWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:22:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF0DA6;
        Mon,  5 Jun 2023 06:22:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685971319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7i9GT2S5V5kPFQ9ynmoaH2oh68oVG88GxgQhO0L2r0=;
        b=FC2fz5Hw2DawTfhyAgMP7CIHQylN+gXXrfD4fYeAD8Vs6bcXX5W8G/FDLDF9Y9CwXjQoBl
        toMeLyHwHgz+ob+RHTUotbhJCq/g2OSbIUVWepD+Uqq+IW9YbPyXlwgdoGeWgCjfdlXFa8
        02bHeq9BqWlYrzeZ3P9+ErwmPbQFpLrTQWzcWxEQvl0+wBSwbS5WW/auR2NKwnrd3HazBy
        7mH4o5scHMUtm4BK6nw0RYhu4IU45Izkxet57Xz1FaptV3BlJUkk8gdMHF/t4O+sJTXP1y
        8SQdZvjjU9Vyk/lVsKetze2YggMKolV1c532dT5tHcciQjiqxivRVv24guue9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685971319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W7i9GT2S5V5kPFQ9ynmoaH2oh68oVG88GxgQhO0L2r0=;
        b=/fITta9sPx5iuy0knJVvC8GsJHywX+CKmnOx8iJk8BgKAJ+upOYhm9WyyCGPPOSJT1MKYP
        Jd5CklRgFPZ/YHAw==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 20/33] x86/fred: FRED entry/exit and dispatch code
In-Reply-To: <20230410081438.1750-21-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-21-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 15:21:58 +0200
Message-ID: <87fs766o3t.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * arch/x86/entry/entry_fred.c

Please do not add these completely pointless file names. They are
useless _and_ never get updated when a file is moved.

> + *
> + * This contains the dispatch functions called from the entry point
> + * assembly.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/kdebug.h>		/* oops_begin/end, ... */

Please remove this useless tail comment. We really do not have to list
which particular things are pulled in from which header file.

> +#include <linux/nospec.h>

New line between linux and asm includes please.

> +#include <asm/event-type.h>
> +#include <asm/fred.h>
> +#include <asm/idtentry.h>
> +#include <asm/syscall.h>
> +#include <asm/trapnr.h>
> +#include <asm/traps.h>
> +#include <asm/kdebug.h>
> +
> +/*
> + * Badness...

Really useful comment. Not.

> +
> +noinstr void fred_exc_double_fault(struct pt_regs *regs)

Has to be global because the only user is the table below, right?

> +{
> +	exc_double_fault(regs, regs->orig_ax);
> +}

Also why is this here and not next to the double fault implementation?

> +/*
> + * Exception entry
> + */
> +static DEFINE_FRED_HANDLER(fred_exception)

Lacks noinstr as most of the functions here.

> +{
> +	/*
> +	 * Exceptions that cannot happen on FRED h/w are set to fred_bad_event().
> +	 */
> +	static const fred_handler exception_handlers[NUM_EXCEPTION_VECTORS] = {
> +		[X86_TRAP_DE] = exc_divide_error,
> +		[X86_TRAP_DB] = fred_exc_debug,
> +		[X86_TRAP_NMI] = fred_bad_event, /* A separate event type, not handled here */

Please make this tabular aligned and get rid of these horrible tail
comments.

> +		[X86_TRAP_BP] = exc_int3,
> +		[X86_TRAP_OF] = exc_overflow,
> +		[X86_TRAP_BR] = exc_bounds,
> +		[X86_TRAP_UD] = exc_invalid_op,
> +		[X86_TRAP_NM] = exc_device_not_available,
> +		[X86_TRAP_DF] = fred_exc_double_fault,
> +		[X86_TRAP_OLD_MF] = fred_bad_event, /* 387 only! */
> +		[X86_TRAP_TS] = fred_exc_invalid_tss,
> +		[X86_TRAP_NP] = fred_exc_segment_not_present,
> +		[X86_TRAP_SS] = fred_exc_stack_segment,
> +		[X86_TRAP_GP] = fred_exc_general_protection,
> +		[X86_TRAP_PF] = fred_exc_page_fault,
> +		[X86_TRAP_SPURIOUS] = fred_bad_event, /* Interrupts are their own event type */
> +		[X86_TRAP_MF] = exc_coprocessor_error,
> +		[X86_TRAP_AC] = fred_exc_alignment_check,
> +		[X86_TRAP_MC] = fred_exc_machine_check,
> +		[X86_TRAP_XF] = exc_simd_coprocessor_error,

> +		[X86_TRAP_VE...NUM_EXCEPTION_VECTORS-1] = fred_bad_event

Can we please have something which makes it entirely clear that anything
from #VE on are exceptions which are installed during boot?

> +	};
> +	u8 vector = array_index_nospec((u8)regs->vector, NUM_EXCEPTION_VECTORS);

This only "works" when NUM_EXCEPTION_VECTORS is power of two. Also what
catches an out of bounds vector? I.e. vector 0x20 will end up as vector
0x0 due to array_index_nospec(). I know, FRED hardware is going to be
perfect...

> +	exception_handlers[vector](regs);
> +}
> +
> +static __always_inline void fred_emulate_trap(struct pt_regs *regs)
> +{
> +	regs->type = EVENT_TYPE_SWFAULT;

This type information is used where?

> +	regs->orig_ax = 0;
> +	fred_exception(regs);
> +}
> +
> +static __always_inline void fred_emulate_fault(struct pt_regs *regs)
> +{
> +	regs->ip -= regs->instr_len;
> +	fred_emulate_trap(regs);
> +}
> +
> +/*
> + * Emulate SYSENTER if applicable. This is not the preferred system
> + * call in 32-bit mode under FRED, rather int $0x80 is preferred and
> + * exported in the vdso. SYSCALL proper has a hard-coded early out in
> + * fred_entry_from_user().

So we have it nicely distributed all over the code....

> + */
> +static DEFINE_FRED_HANDLER(fred_syscall_slow)
> +{
> +	if (IS_ENABLED(CONFIG_IA32_EMULATION) &&
> +	    likely(regs->vector == FRED_SYSENTER)) {
> +		/* Convert frame to a syscall frame */
> +		regs->orig_ax = regs->ax;
> +		regs->ax = -ENOSYS;
> +		do_fast_syscall_32(regs);
> +	} else {
> +		regs->vector = X86_TRAP_UD;
> +		fred_emulate_fault(regs);
> +	}
> +}
> +
> +/*
> + * Some software exceptions can also be triggered as int instructions,
> + * for historical reasons. Implement those here. The performance-critical
> + * int $0x80 (32-bit system call) has a hard-coded early out.

This comment starts to annoy me. Can you put comments next to the code
where they actually make sense?

> + */
> +static DEFINE_FRED_HANDLER(fred_sw_interrupt_user)
> +{

i.e.

        /*
         * In compat mode INT $0x80 (32bit system call) is
         * performance-critical. Handle it first.
         */

> +	if (IS_ENABLED(CONFIG_IA32_EMULATION) &&
> +	    likely(regs->vector == IA32_SYSCALL_VECTOR)) {
> +		/* Convert frame to a syscall frame */
> +		regs->orig_ax = regs->ax;
> +		regs->ax = -ENOSYS;
> +		return do_int80_syscall_32(regs);

> +	}
> +
> +	switch (regs->vector) {
> +	case X86_TRAP_BP:
> +	case X86_TRAP_OF:
> +		fred_emulate_trap(regs);
> +		break;
> +	default:
> +		regs->vector = X86_TRAP_GP;
> +		fred_emulate_fault(regs);
> +		break;
> +	}
> +}
> +
> +static DEFINE_FRED_HANDLER(fred_hw_interrupt)
> +{
> +	irqentry_state_t state = irqentry_enter(regs);
> +
> +	instrumentation_begin();
> +	external_interrupt(regs);
> +	instrumentation_end();
> +	irqentry_exit(regs, state);
> +}
> +
> +__visible noinstr void fred_entry_from_user(struct pt_regs *regs)
> +{
> +	static const fred_handler user_handlers[FRED_EVENT_TYPE_COUNT] =
> +	{
> +		[EVENT_TYPE_HWINT]	= fred_hw_interrupt,
> +		[EVENT_TYPE_RESERVED]	= fred_bad_event,
> +		[EVENT_TYPE_NMI]	= fred_exc_nmi,
> +		[EVENT_TYPE_SWINT]	= fred_sw_interrupt_user,
> +		[EVENT_TYPE_HWFAULT]	= fred_exception,
> +		[EVENT_TYPE_SWFAULT]	= fred_exception,
> +		[EVENT_TYPE_PRIVSW]	= fred_exception,
> +		[EVENT_TYPE_OTHER]	= fred_syscall_slow
> +	};
> +
> +	/*
> +	 * FRED employs a two-level event dispatch mechanism, with
> +	 * the first-level on the type of an event and the second-level
> +	 * on its vector. Thus a dispatch typically induces 2 calls.
> +	 * We optimize it by using early outs for the most frequent
> +	 * events, and syscalls are the first. We may also need early
> +	 * outs for page faults.

I'm not really convinced that adding more special cases and conditionals
is a win. This should be a true two-level dispatch first for _all_ event
types and then in a separate step optimizations with proper performance
numbers and justifications. Premature optimization is the enemy of
correctness. Don't do it.

> +	 */
> +	if (likely(regs->type == EVENT_TYPE_OTHER &&
> +		   regs->vector == FRED_SYSCALL)) {
> +		/* Convert frame to a syscall frame */
> +		regs->orig_ax = regs->ax;
> +		regs->ax = -ENOSYS;
> +		do_syscall_64(regs, regs->orig_ax);
> +	} else {
> +		/* Not a system call */
> +		u8 type = array_index_nospec((u8)regs->type, FRED_EVENT_TYPE_COUNT);

What's the u8 buying here and in all the other places? This has the same
table issue as all other table handling in this file.

> +		user_handlers[type](regs);
> +	}
> +}

> diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
> index 2876ddae02bc..bd43866f9c3e 100644
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -82,6 +82,7 @@ static __always_inline void __##func(struct pt_regs *regs)
>  #define DECLARE_IDTENTRY_ERRORCODE(vector, func)			\
>  	asmlinkage void asm_##func(void);				\
>  	asmlinkage void xen_asm_##func(void);				\
> +	__visible void fred_##func(struct pt_regs *regs);		\

Wants to be a separate change.

>  	__visible void func(struct pt_regs *regs, unsigned long error_code)
>  
>  /**
> @@ -106,6 +107,11 @@ __visible noinstr void func(struct pt_regs *regs,			\
>  	irqentry_exit(regs, state);					\
>  }									\
>  									\
> +__visible noinstr void fred_##func(struct pt_regs *regs)		\
> +{									\
> +	func (regs, regs->orig_ax);					\

  func() ....

Thanks,

        tglx
