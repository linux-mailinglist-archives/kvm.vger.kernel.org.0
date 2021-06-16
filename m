Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8333AA12A
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 18:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhFPQZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 12:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbhFPQY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 12:24:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C050C061760;
        Wed, 16 Jun 2021 09:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1d0Tl5rfohMOCIU/0DFB9J6Hwo/O5OgV8ZAPADtlBA0=; b=FTmH95Q23BqY4TkY4TDDOpOMxH
        9BtCg09BOIov7oalJ/k0iE3EaYw61VOCnIK0T+0XEkuV2C7lUm+GsDRXUJutWmZCHiimixdyrtPLt
        ozU7afsS3dXlOwMxyhAcCVKRGTT7ybEV/mOs4dxAto9Ems80hcGpOQgqaG+5YjiDWRTDbzGMhoLEU
        7gWPiz5fJnrL5KDKrpMzgSJdXpEmUsFGv3dDoFsal53jiwMKjDDKUBv1hoEbG0adkF0kXyPeoe2lO
        NdDudTUPcjbwLq4NgG5GBik6RFAB+pfIA+ZGmmR5uw4m9d7lBhU+1Uu7bwEZwwgLZcv3uBSVvlje9
        6PpMGJDQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltYIX-008FOd-VY; Wed, 16 Jun 2021 16:21:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7874D300269;
        Wed, 16 Jun 2021 18:04:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5620A2BD35DD3; Wed, 16 Jun 2021 18:04:26 +0200 (CEST)
Date:   Wed, 16 Jun 2021 18:04:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v5 3/6] x86/sev-es: Split up runtime #VC handler for
 correct state tracking
Message-ID: <YMohCkW/mChNpkqi@hirez.programming.kicks-ass.net>
References: <20210614135327.9921-1-joro@8bytes.org>
 <20210614135327.9921-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614135327.9921-4-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 03:53:24PM +0200, Joerg Roedel wrote:

> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -506,7 +506,7 @@ SYM_CODE_START(\asmsym)
>  
>  	movq	%rsp, %rdi		/* pt_regs pointer */
>  
> -	call	\cfunc
> +	call	kernel_\cfunc
>  
>  	/*
>  	 * No need to switch back to the IST stack. The current stack is either
> @@ -517,7 +517,7 @@ SYM_CODE_START(\asmsym)
>  
>  	/* Switch to the regular task stack */
>  .Lfrom_usermode_switch_stack_\@:
> -	idtentry_body safe_stack_\cfunc, has_error_code=1
> +	idtentry_body user_\cfunc, has_error_code=1
>  
>  _ASM_NOKPROBE(\asmsym)
>  SYM_CODE_END(\asmsym)

Consistency with idtentry_mce_db would seem to suggest using \cfunc and
noist_\cfunc.

amluto, tglx: do we have strong feelings on consistency?


> +static bool noinstr vc_check_and_handle_db(struct pt_regs *regs, unsigned long error_code)
> +{
> +	if (likely(error_code != SVM_EXIT_EXCP_BASE + X86_TRAP_DB))
> +		return false;
>  
> +	vc_handle_trap_db(regs);

It's a bit sad this does user_mode(regs) again.

> +
> +	return true;
> +}

Maybe something like:

static __always_inline bool vc_is_db(unsigned long error_code)
{
	return error_code == SVM_EXIT_EXCP_BASE + X86_TRAP_DB;
}

> +
> +/*
> + * Runtime #VC exception handler when raised from kernel mode. Runs in NMI mode
> + * and will panic when an error happens.
> + */
> +DEFINE_IDTENTRY_VC_KERNEL(exc_vmm_communication)
> +{
> +	irqentry_state_t irq_state;
>  
> +	/*
> +	 * With the current implementation it is always possible to switch to a
> +	 * safe stack because #VC exceptions only happen at known places, like
> +	 * intercepted instructions or accesses to MMIO areas/IO ports. They can
> +	 * also happen with code instrumentation when the hypervisor intercepts
> +	 * #DB, but the critical paths are forbidden to be instrumented, so #DB
> +	 * exceptions currently also only happen in safe places.
> +	 *
> +	 * But keep this here in case the noinstr annotations are violated due
> +	 * to bug elsewhere.
> +	 */
> +	if (unlikely(on_vc_fallback_stack(regs))) {
> +		instrumentation_begin();
> +		panic("Can't handle #VC exception from unsupported context\n");
> +		instrumentation_end();
> +	}
> +
> +	/*
> +	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
> +	 */
> +	if (vc_check_and_handle_db(regs, error_code))
> +		return;

	if (vc_is_db(error_core)) {
		exc_debug(regs);
		return;
	}

> +
> +	irq_state = irqentry_nmi_enter(regs);
> +
> +	instrumentation_begin();
> +
> +	if (!vc_raw_handle_exception(regs, error_code)) {
>  		/* Show some debug info */
>  		show_regs(regs);
>  
> @@ -1443,23 +1448,38 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
>  		panic("Returned from Terminate-Request to Hypervisor\n");
>  	}
>  
> +	instrumentation_end();
> +	irqentry_nmi_exit(regs, irq_state);
>  }
>  
> +/*
> + * Runtime #VC exception handler when raised from user mode. Runs in IRQ mode
> + * and will kill the current task with SIGBUS when an error happens.
> + */
> +DEFINE_IDTENTRY_VC_USER(exc_vmm_communication)
>  {
> +	irqentry_state_t irq_state;
> +
> +	/*
> +	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
> +	 */
> +	if (vc_check_and_handle_db(regs, error_code))
> +		return;

	if (vs_is_db(error_code)) {
		noist_exc_debug(regs);
		return;
	}

> +
> +	irq_state = irqentry_enter(regs);
>  	instrumentation_begin();
>  
> +	if (!vc_raw_handle_exception(regs, error_code)) {
> +		/*
> +		 * Do not kill the machine if user-space triggered the
> +		 * exception. Send SIGBUS instead and let user-space deal with
> +		 * it.
> +		 */
> +		force_sig_fault(SIGBUS, BUS_OBJERR, (void __user *)0);
> +	}
> +
> +	instrumentation_end();
> +	irqentry_exit(regs, irq_state);
>  }

Other than that, this seems *much* nicer. Thanks!


