Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6648363F800
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 20:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiLATRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 14:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLATRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 14:17:20 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5911C6E65
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 11:17:19 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so3064661pjm.2
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 11:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFmVJk+q8aJmE5nuImVUhZwYdOyGkWsb7VjfOHULw+0=;
        b=RdtWL0N+k812OddccpiML3pYWHQT639WK7ZgL1dveDLWv/EmoNqlzuxQkDSkHLrMIF
         RVMjN+JUbRF+vQR/1ETq4nlzCv0mqodaKtjTFyMseTl/xEM3iLnzYzC1Ac7YlzZkOKz2
         OUswf3d3HHbI7Dew/J8zrexFQcx549K3VQX6+iR+9orT5y8y5qKUZdflU7Eka4+5HLoZ
         iOPg5UMiLdN3jZQUN+RIAee3hoEq2ufLJ0BoU88XvuvBU8BdbhveTl9Z0jmuOzgu70uC
         1B0L0e726RIPS5tDLfy87s0ux06eCPPZVVaxCXVWaowzzFZt/SuN1lmxk0rUI+iLHq+x
         rwug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFmVJk+q8aJmE5nuImVUhZwYdOyGkWsb7VjfOHULw+0=;
        b=aKRueJweT6ffHg8soDu1b7w8WH48em8glGfrhA68bhhzexFDT+eh4mrkiVEOeQeHpb
         jrwA3YgriGBTZa49EO6fKSS75cpEOvMJQ5zQXcmc6wx7ruPqaKHeuQaOFrAHp5OzHcj9
         PJ08RRT0cvs143l/9DM7zd/7Wh+9jelYiPyQxCZ8LBUp9OIEEsAQOdBYx14lmXO0DCoq
         ikArGCK18cbuRV+J2DeaqS/UaZJd9agbJX+JgzmmMMXjVjwNJIn0ZFnMqLD5jDGvuuFy
         5lmnSnapqUENXmeNCu1EiTkDR1FvHN6Baavr7vXkbxknZUrw+byfpScNqW+sRDl/gmYE
         8Nlw==
X-Gm-Message-State: ANoB5pnLq6d3ZDfilS4ZHW6nIUOkFBR7GToA6MuEZl6ekZVVUvrLX2tc
        7UHbnNwKWpigKyHBkfBRR63Tgw==
X-Google-Smtp-Source: AA0mqf44NRHwlhQTSIt11dyKHvnL21RfooazfD2xLCsqI68yorcFQT0pgaA34WWqcVl+ouf6vSPtzg==
X-Received: by 2002:a17:903:31d5:b0:187:1461:9b27 with SMTP id v21-20020a17090331d500b0018714619b27mr51491975ple.165.1669922239259;
        Thu, 01 Dec 2022 11:17:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c133-20020a621c8b000000b00575cdd7c0adsm3570372pfc.80.2022.12.01.11.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 11:17:18 -0800 (PST)
Date:   Thu, 1 Dec 2022 19:17:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Message-ID: <Y4j9u6YEpJ/px6kj@google.com>
References: <20221129182226.82087-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129182226.82087-1-jon@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022, Jon Kohler wrote:
> Set vcpu->mode to EXITING_GUEST_MODE as soon vCPU exits to reflect
> that we are indeed exiting guest mode, but not quite out of guest
> mode yet. Note: This is done lazily without an explicit memory
> barrier so that we do not regress the cost in the critical path
> of going from the exit to the exit handler.

This is not remotely sufficient justification.  Memory "barriers" are just compiler
barriers on x86, so the odds of regressing the VM-Enter/VM-Exit cost without
introducing a bug are miniscule.

> Flip back to IN_GUEST_MODE for exits that use
> EXIT_FASTPATH_REENTER_GUEST, such that we are IN_GUEST_MODE upon
> reentry.
> 
> Changing vcpu->mode away from IN_GUEST_MODE as early as possible

Except this isn't as early as possible.  If we're going to bother doing something
like this, my vote is to move it into assembly.

> gives IPI senders as much runway as possible to avoid ringing
> doorbell or sending posted interrupt IPI in AMD and Intel,
> respectively. Since this is done without an explicit memory
> barrier, the worst case is that the IPI sender sees IN_GUEST_MODE
> still and sends a spurious event, which is the behavior prior
> to this patch.

No, worst case scenario is that kvm_vcpu_exiting_guest_mode() sees EXITING_GUEST_MODE
and doesn't kick the vCPU.  For "kicks" that set a request, kvm_vcpu_exit_request()
will punt the vCPU out of the tight run loop, though there might be ordering issues.

But whether or not there are ordering issues is a moot point since there are uses
of kvm_vcpu_kick() that aren't accompanied by a request, e.g. to purge the PML
buffers.  In other words, kvm_vcpu_kick() absolutely cannot have false negatives.
We could modify KVM to require a request when using kvm_vcpu_kick(), but that's
a bit of a hack, and all of the possible ordering problems is still a pile of
complexity I'd rather avoid.

No small part of me thinks we'd be better off adding a dedicated flag to very
precisely track whether or not the vCPU is truly "in the guest" for the purposes
of sending IPIs.  Things like kicks have different requirements around IN_GUEST_MODE
than sending interrupts, e.g. KVM manually processes the IRR on every VM-Enter and
so lack of an IPI is a non-issue, whereas missing an IPI for a kick is problematic.
In other words, EXITING_GUEST_MODE really needs to mean "existing the run loop".

E.g. toggle the dedicated flag within a few instructions of VM-Enter and
VM-Exit for maximum efficiency for interrupts, and avoid having to make vcpu->mode
more complex than it already is.

To add clarity, we could even rename IN_GUEST_MODE and EXITING_GUEST_MODE to
something like IN_RUN_LOOP and EXITING_RUN_LOOP.

> Signed-off-by: Jon Kohler <jon@nutanix.com>
> ---
>  arch/x86/kvm/svm/svm.c |  7 +++++++
>  arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++++
>  arch/x86/kvm/x86.c     |  8 ++++++++
>  3 files changed, 38 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ce362e88a567..5f0c118a3ffd 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3907,6 +3907,13 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>  	else
>  		__svm_vcpu_run(svm, spec_ctrl_intercepted);
>  
> +	/* Optimize IPI reduction by setting mode immediately after vmexit

	/*
 	 * Because KVM isn't the crazy land of net/ block comments should like
	 * this. 
	 */

> +	 * without a memmory barrier as this as not paired anywhere.
> +	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memory
> +	 * barrier, after the host is done fully restoring various host states.
> +	 */
> +	vcpu->mode = EXITING_GUEST_MODE;
> +
>  	guest_state_exit_irqoff();
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 63247c57c72c..243dcb87c727 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5878,6 +5878,17 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
>  
>  	if (!vmx->req_immediate_exit &&
>  	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
> +		/* Reset IN_GUEST_MODE since we're going to reenter
> +		 * guest as part of this fast path. This is done as
> +		 * an optimization without a memory barrier since
> +		 * EXITING_GUEST_MODE is also set without a memory

Heh, justifying the lack of a memory barrier by saying pointing out the other
code you added doesn't use a memory barrier is interesting, to put it politely.

> +		 * barrier. This also needs to be reset prior to
> +		 * calling apic_timer_expired() so that
> +		 * kvm_use_posted_timer_interrupt() returns the proper
> +		 * value.
> +		 */
> +		if (vcpu->mode == EXITING_GUEST_MODE)
> +			vcpu->mode = IN_GUEST_MODE;

It's far easier, likely more performant, documents why this has a chance of working,
and significantly less error prone to do this unconditionally in either assembly
or after the EXIT_FASTPATH_REENTER_GUEST check in vcpu_enter_guest().
