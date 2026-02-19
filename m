Return-Path: <kvm+bounces-71307-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJ8XN9dYlmmKeAIAu9opvQ
	(envelope-from <kvm+bounces-71307-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:27:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E1B815B244
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 262D63041BD0
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA658202F71;
	Thu, 19 Feb 2026 00:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UmCLgb5b"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD56C1A9F8D
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 00:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771460797; cv=none; b=gMcmzLy1ZGidfMJhpRx4EA5E8lTyJZZwniHUQ/GZNjMemkLXawAaHUKSESG3xXfNCRxnKyt/Ecc165hk9cZMIE5KO2C1JfO9FuA1Osjb7ooG4xGDX+6/iD0XZiggIv4uhMNJSqG4wpxqLZLRMwNty6FLSuJu66Vgqu+B6oyhe8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771460797; c=relaxed/simple;
	bh=bUMqcMuV4FFwt7twaqJRy3yJSdGH4AQSWhrv74zSNME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXXxbazwAJHRbJeu2L49fKpniey+7sp4vaHRoMsD8STY2n7XiLU6D6TpTNQm1PT/R++y8NNgt9ZdpciSZ/zopMlNkJsfdxGZCI1ZUruhj5NfgsM1n21HPlhfdsVxa4+GagkEwqILPPnj/3c7bfwD711NFcKhWuEjQyoHvgBg5vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UmCLgb5b; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 19 Feb 2026 00:26:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771460783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d8Q1JBs3IWao6IxKh5o3BW5Nrr3jIp3VDv0XASfYtbk=;
	b=UmCLgb5bpijcdRNxgX+p7Rt9O2xb0zXRWd7X0xqNQb/dE8lhGdanQwXYkIe3/1vVHUL1O8
	1AM7MPvN4AAYQXrqZnPzAdz4UsDsnxCzB3Ty+4jrbMpmf83v2THmgmsU/7nWXVNLCAELFy
	IJHk8uHV6t0fj4KtHVCj76O/hBWVQjU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] KVM: SVM: Recalculate nested RIPs after
 restoring REGS/SREGS
Message-ID: <wwa2h5gcb7gfxgmsh3jdwa4d4xurkmgd26dnkwupgzcln3khfu@v3w2w6nf4tq7>
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
 <20260212230751.1871720-5-yosry.ahmed@linux.dev>
 <aZZVqQrQ1iCNJhJJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZZVqQrQ1iCNJhJJ@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71307-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: 4E1B815B244
X-Rspamd-Action: no action

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index db3f393192d9..35fe1d337273 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12112,6 +12112,8 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> >  	kvm_rip_write(vcpu, regs->rip);
> >  	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
> >  
> > +	kvm_x86_call(post_user_set_regs)(vcpu);
> 
> I especially don't love this callback.  Aside from adding a new kvm_x86_ops hook,
> I don't like that _any_ CS change triggers a fixup, whereas only userspace writes
> to RIP trigger a fixup.  That _should_ be a moot point, because neither CS nor RIP
> should change while nested_run_pending is true, but I dislike the asymmetry.
> 
> I was going to suggest we instead react to RIP being dirty, but what if we take
> it a step further?  Somewhat of a crazy idea, but what happens if we simply wait
> until just before VMRUN to set soft_int_csbase, soft_int_old_rip, and
> soft_int_next_rip (when the guest doesn't have NRIPS)?

I generally like this idea. I thought about it for a moment but was
worried about how much of a behavioral change this introduces, but that
was probably before I convinced myself the problem only exists with
nested_run_pending.

That being said..

> 
> E.g. after patch 2, completely untested...
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index aec17c80ed73..6fc1b2e212d2 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -863,12 +863,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,

Above the context lines we have:

        /*
         * next_rip is consumed on VMRUN as the return address pushed on the
         * stack for injected soft exceptions/interrupts.  If nrips is exposed
         * to L1, take it verbatim from vmcb12.  If nrips is supported in
         * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
         * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
         * prior to injecting the event).
         */
        if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
                vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
        else if (boot_cpu_has(X86_FEATURE_NRIPS))
                vmcb02->control.next_rip    = vmcb12_rip;

The same bug affects vmcb02->control.next_rip when the guest doesn't
have NRIPS. I think we don't want to move part of the vmcb02
initialization before VMRUN too. We can keep the initialization here and
overwrite it before VMRUN if needed, but that's just also ugh..

>         svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
>         if (is_evtinj_soft(vmcb02->control.event_inj)) {
>                 svm->soft_int_injected = true;
> -               svm->soft_int_csbase = vmcb12_csbase;
> -               svm->soft_int_old_rip = vmcb12_rip;
> +
>                 if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>                         svm->soft_int_next_rip = svm->nested.ctl.next_rip;

Why not move this too?

> -               else
> -                       svm->soft_int_next_rip = vmcb12_rip;
>         }
>  
>         /* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8f8bc863e214..358ec940ffc9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4322,6 +4322,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>                 return EXIT_FASTPATH_EXIT_USERSPACE;
>         }
>  
> +       if (is_guest_mode(vcpu) && svm->nested.nested_run_pending &&
> +           svm->soft_int_injected) {
> +               svm->soft_int_csbase = svm->vmcb->save.cs.base;
> +               svm->soft_int_old_rip = kvm_rip_read(vcpu);
> +               if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> +                       svm->soft_int_next_rip = kvm_rip_read(vcpu);
> +       }
> +

I generally dislike adding more is_guest_mode() stuff in svm_vcpu_run(),
maybe we can refactor them later to pre-run and post-run nested
callbacks? Anyway, not a big deal, definitely an improvement over the
current patch assuming we can figure out how to fix next_rip.

>         sync_lapic_to_cr8(vcpu);
>  
>         if (unlikely(svm->asid != svm->vmcb->control.asid)) {

