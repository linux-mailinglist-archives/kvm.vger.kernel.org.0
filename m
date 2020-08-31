Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAAD25787E
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 13:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgHaLax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 07:30:53 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45730 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgHaLaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 07:30:19 -0400
Received: from zn.tnic (p200300ec2f085000329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5000:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4F12D1EC02C1;
        Mon, 31 Aug 2020 13:30:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598873406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Xc+Pd4QRnfNfg4+7CpZrHisRsqB1SyQ+tI27GhvzMCQ=;
        b=SenbmO87jXBqpXwojhBpSHQnEP4BtnTmjZyLxOz7tyqmb6JwiuipB0Ll5jgUTJzOB5CVQI
        gqH0XdsTxrHF2XN6Q8OMqK5PJ0qdVeME1fBmi9+KIvMkE1t9bJ3vKpQFj/q/RLBwVVakrk
        U7cWe9EJ9E3Y7cK1nNtroJ067GRc6f8=
Date:   Mon, 31 Aug 2020 13:30:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 48/76] x86/entry/64: Add entry code for #VC handler
Message-ID: <20200831113002.GH27517@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-49-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-49-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:43AM +0200, Joerg Roedel wrote:
> @@ -446,6 +448,82 @@ _ASM_NOKPROBE(\asmsym)
>  SYM_CODE_END(\asmsym)
>  .endm
>  

ifdeffery pls...

> +/**
> + * idtentry_vc - Macro to generate entry stub for #VC
> + * @vector:		Vector number
> + * @asmsym:		ASM symbol for the entry point
> + * @cfunc:		C function to be called
> + *
> + * The macro emits code to set up the kernel context for #VC. The #VC handler
> + * runs on an IST stack and needs to be able to cause nested #VC exceptions.
> + *
> + * To make this work the #VC entry code tries its best to pretend it doesn't use
> + * an IST stack by switching to the task stack if coming from user-space (which
> + * includes early SYSCALL entry path) or back to the stack in the IRET frame if
> + * entered from kernel-mode.
> + *
> + * If entered from kernel-mode the return stack is validated first, and if it is
> + * not safe to use (e.g. because it points to the entry stack) the #VC handler
> + * will switch to a fall-back stack (VC2) and call a special handler function.
> + *
> + * The macro is only used for one vector, but it is planned to extend it in the
								^^^^^^^^^^^

"... to be extended..."

...

> @@ -674,6 +675,56 @@ asmlinkage __visible noinstr struct pt_regs *sync_regs(struct pt_regs *eregs)
>  	return regs;
>  }
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *eregs)
> +{
> +	unsigned long sp, *stack;
> +	struct stack_info info;
> +	struct pt_regs *regs;

Let's call those "regs_ret" or so, so that the argument can be "regs" by
convention and for better differentiation.

> +	/*
> +	 * In the SYSCALL entry path the RSP value comes from user-space - don't
> +	 * trust it and switch to the current kernel stack
> +	 */
> +	if (eregs->ip >= (unsigned long)entry_SYSCALL_64 &&
> +	    eregs->ip <  (unsigned long)entry_SYSCALL_64_safe_stack) {
> +		sp = this_cpu_read(cpu_current_top_of_stack);
> +		goto sync;
> +	}
> +
> +	/*
> +	 * From here on the the RSP value is trusted - more RSP sanity checks
> +	 * need to happen above.
> +	 *
> +	 * Check whether entry happened from a safe stack.
> +	 */
> +	sp    = eregs->sp;
> +	stack = (unsigned long *)sp;
> +	get_stack_info_noinstr(stack, current, &info);
> +
> +	/*
> +	 * Don't sync to entry stack or other unknown stacks - use the fall-back
> +	 * stack instead.
> +	 */
> +	if (info.type == STACK_TYPE_UNKNOWN || info.type == STACK_TYPE_ENTRY ||

AFAICT, that STACK_TYPE_UNKNOWN gets set only by the plain
get_stack_info() function - not by the _noinstr() variant so you'd need
to check the return value of latter...

> +	    info.type >= STACK_TYPE_EXCEPTION_LAST)
> +		sp = __this_cpu_ist_top_va(VC2);
> +
> +sync:
> +	/*
> +	 * Found a safe stack - switch to it as if the entry didn't happen via
> +	 * IST stack. The code below only copies pt_regs, the real switch happens
> +	 * in assembly code.
> +	 */
> +	sp = ALIGN_DOWN(sp, 8) - sizeof(*regs);
> +
> +	regs = (struct pt_regs *)sp;
> +	*regs = *eregs;
> +
> +	return regs;
> +}
> +#endif
> +
>  struct bad_iret_stack {
>  	void *error_entry_ret;
>  	struct pt_regs regs;
> -- 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
