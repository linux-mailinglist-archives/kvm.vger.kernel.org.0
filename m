Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CB13A2944
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 12:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFJKXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 06:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhFJKXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 06:23:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC18C061574;
        Thu, 10 Jun 2021 03:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h/muEhpxVB/fiLZzxDtNWLmprGe33vvGrnl4EIsyiME=; b=C9711rfL7VWAOpk6sJJ9J7J/I1
        zaCKOfBhOnlG98lP2S47uOkx7vj7XIY74Syna8t0J7A1iYuJdd5jZhyvArBg8tCPqpHoWNsbbwVGt
        6mpY4+CRaLfOMN2C51RUHQPX7MV8AdfqjOf65GQVVg5gXj1lgemfVVOS86BOXJvFafieSbfH8S/bu
        uU96SaHMvaBDL5GEwfMIpu6IuPe2p6GPGLwwriTEo/pobY5OPGk0ZcuPxTcePBSm1p+CeuSgqS2k9
        lGVGbKGFQ34etlCs0UaYdXjTcacWG1COJwp9YBMrI9vNveIAm78LmGJGideBbJIcU/37qrHKKYLp6
        GoVRv4AQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lrHmr-001UFJ-SK; Thu, 10 Jun 2021 10:19:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BC91B300258;
        Thu, 10 Jun 2021 12:19:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AB1BB20811810; Thu, 10 Jun 2021 12:19:43 +0200 (CEST)
Date:   Thu, 10 Jun 2021 12:19:43 +0200
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
Subject: Re: [PATCH v4 3/6] x86/sev-es: Split up runtime #VC handler for
 correct state tracking
Message-ID: <YMHnP1qgvznyYazv@hirez.programming.kicks-ass.net>
References: <20210610091141.30322-1-joro@8bytes.org>
 <20210610091141.30322-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610091141.30322-4-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Bah, I suppose the trouble is that this SEV crap requires PARAVIRT?

I should really get around to fixing noinstr validation with PARAVIRT on
:-(

On Thu, Jun 10, 2021 at 11:11:38AM +0200, Joerg Roedel wrote:

> +static void vc_handle_from_kernel(struct pt_regs *regs, unsigned long error_code)

static noinstr ...

> +{
> +	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
>  
> +	instrumentation_begin();
>  
> +	if (!vc_raw_handle_exception(regs, error_code)) {
>  		/* Show some debug info */
>  		show_regs(regs);
>  
> @@ -1434,7 +1400,59 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
>  		panic("Returned from Terminate-Request to Hypervisor\n");
>  	}
>  
> +	instrumentation_end();
> +	irqentry_nmi_exit(regs, irq_state);
> +}
> +
> +static void vc_handle_from_user(struct pt_regs *regs, unsigned long error_code)

static noinstr ...

> +{
> +	irqentry_state_t irq_state = irqentry_enter(regs);
> +
> +	instrumentation_begin();
> +
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
> +}

+ linebreak

> +/*
> + * Main #VC exception handler. It is called when the entry code was able to
> + * switch off the IST to a safe kernel stack.
> + *
> + * With the current implementation it is always possible to switch to a safe
> + * stack because #VC exceptions only happen at known places, like intercepted
> + * instructions or accesses to MMIO areas/IO ports. They can also happen with
> + * code instrumentation when the hypervisor intercepts #DB, but the critical
> + * paths are forbidden to be instrumented, so #DB exceptions currently also
> + * only happen in safe places.
> + */
> +DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
> +{
> +	/*
> +	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
> +	 */
> +	if (error_code == SVM_EXIT_EXCP_BASE + X86_TRAP_DB) {
> +		vc_handle_trap_db(regs);
> +		return;
> +	}
> +
> +	/*
> +	 * This is invoked through an interrupt gate, so IRQs are disabled. The
> +	 * code below might walk page-tables for user or kernel addresses, so
> +	 * keep the IRQs disabled to protect us against concurrent TLB flushes.
> +	 */
> +
> +	if (user_mode(regs))
> +		vc_handle_from_user(regs, error_code);
> +	else
> +		vc_handle_from_kernel(regs, error_code);
>  }

#DB and MCE use idtentry_mce_db and split out in asm. When I look at
idtentry_vc, it appears to me that VC_SAFE_STACK already implies
from-user, or am I reading that wrong?

Ah, it appears you're muddling things up again by then also calling
safe_stack_ from exc_.

How about you don't do that and have exc_ call your new from_kernel
function, then we know that safe_stack_ is always from-user. Then also
maybe do:

	s/VS_SAFE_STACK/VC_USER/
	s/safe_stack_/noist_/

to match all the others (#DB/MCE).

Also, AFAICT, you don't actually need DEFINE_IDTENTRY_VC_IST, it doesn't
have an ASM counterpart.

So then you end up with something like:

DEFINE_IDTENTRY_VC(exc_vc)
{
	if (unlikely(on_vc_fallback_stack(regs))) {
		instrumentation_begin();
		panic("boohooo\n");
		instrumentation_end();
	}

	vc_from_kernel();
}

DEFINE_IDTENTRY_VC_USER(exc_vc)
{
	vc_from_user();
}

Which is, I'm thinking, much simpler, no?
