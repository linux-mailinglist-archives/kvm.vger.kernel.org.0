Return-Path: <kvm+bounces-37326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4E3A288ED
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 12:11:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15A2B3AF230
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA25322B8BE;
	Wed,  5 Feb 2025 11:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4nk9zyd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40DF22B5B2;
	Wed,  5 Feb 2025 11:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738753404; cv=none; b=CPM+QV4AZiA9aINJIC+djXGODOgeLBUvKVyMsOMeqHBFU0d1QQCBTkkJo3ejSJNxFmVadTEXx7uI5cfPhy4WN5t84y/eqy1Yxg6z8Rr6267jJ4sgUIGYI7mTdguqj968HiP3RPTjFBkOpGhuxswEqaMmxV/YjqXM7fslCxOLMNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738753404; c=relaxed/simple;
	bh=InSNhNZ+Ugs5LeocTNKTd8Kp7o1k5BRoOcDugxabbZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6AYu5U66uRO8tF2H7ySYLZdK4PSnVXxmQ7mgLCnaG958uMI0PufVRDqlWOp4kApJkFWgbftNAIGcEYWJMvI33bGFppa9xc6SIRNeRdhjgxM8PM7jogG/v8hmF0RF3YxZXvLrxe7TYRpFGZYHiHuAlMcu60UwfOnzgMso2xEnbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4nk9zyd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B510BC4CED1;
	Wed,  5 Feb 2025 11:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738753404;
	bh=InSNhNZ+Ugs5LeocTNKTd8Kp7o1k5BRoOcDugxabbZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b4nk9zydgFgHNcVY/drIF3FqZYsAV3OzJFu/Gs6fhrqKIGj+wwrTJ/uVvAVWP9Y7V
	 rBlORqEovHWInJWEKQtdTufTQzXSrbroS3RGWN/Hexh0WmuTfVL0hbHpmvLLnU6tl8
	 TgRcezrlf/Di7lnsSZWqCiC0ag/sVVKGFGiLJVbITC7J6Rx+gJv+WY9eivnhtXNAgv
	 GNAZetzC6jaKtCw8sd35Oa8+ko72sgpfY6zSSa4vvv2eR3VjeqgurQtxaOrowPsjEg
	 r9URWYsPoToetVIJZFmDS6BbG9IcDnF2qbSpCS6fvIZJVPYqgCeEonYExaDz79T7BR
	 iMOliqKOP06qA==
Date: Wed, 5 Feb 2025 16:24:05 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
Message-ID: <y7fpqqk5klh3e56fzsnqdubnnztenzjf6uw2xnepa7z4q4t3qj@mofgkdt3txrt>
References: <cover.1738595289.git.naveen@kernel.org>
 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com>
 <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com>
 <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
 <Z6JoInXNntIoHLQ8@google.com>
 <2c9ffa51b82b4ae75e803d5b30bf74eda9350686.camel@redhat.com>
 <Z6LBz69oVI5qUGFW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6LBz69oVI5qUGFW@google.com>

On Tue, Feb 04, 2025 at 05:41:35PM -0800, Sean Christopherson wrote:
> On Tue, Feb 04, 2025, Maxim Levitsky wrote:
> > On Tue, 2025-02-04 at 11:18 -0800, Sean Christopherson wrote:
> > > On Mon, Feb 03, 2025, Maxim Levitsky wrote:
> > > @@ -3219,20 +3228,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
> > >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> > >  	svm_clear_vintr(to_svm(vcpu));
> > >  
> > > -	/*
> > > -	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
> > > -	 * In this case AVIC was temporarily disabled for
> > > -	 * requesting the IRQ window and we have to re-enable it.
> > > -	 *
> > > -	 * If running nested, still remove the VM wide AVIC inhibit to
> > > -	 * support case in which the interrupt window was requested when the
> > > -	 * vCPU was not running nested.
> > > -
> > > -	 * All vCPUs which run still run nested, will remain to have their
> > > -	 * AVIC still inhibited due to per-cpu AVIC inhibition.
> > > -	 */
> > 
> > Please keep these comment that explain why inhibit has to be cleared here,
> 
> Ya, I'll make sure there are good comments that capture everything before posting
> anything.
> 
> > and the code as well.
> > 
> > The reason is that IRQ window can be requested before nested entry, which
> > will lead to VM wide inhibit, and the interrupt window can happen while
> > nested because nested hypervisor can opt to not intercept interrupts. If that
> > happens, the AVIC will remain inhibited forever.

<snip>

> It's still not perfect, but the obvious-in-hindsight answer is to 
> clear the
> IRQ window inhibit when KVM actually injects an interrupt and there's no longer
> a injectable interrupt.
> 
> That optimizes all the paths: if L1 isn't intercept IRQs, KVM will drop the
> inhibit as soon as an interrupt is injected into L2.  If L1 is intercepting IRQs,
> KVM will keep the inhibit until the IRQ is injected into L2.  Unless I'm missing
> something, the inhibit itself should prevent an injectable IRQ from disappearing,
> i.e. AVIC won't be left inhibited.
> 
> So this for the SVM changes?

I tested this in my setup (below changes to svm.c, along with the rest 
of the changes from your earlier posting), and it ensures proper update 
of the APICv inhibit. That is, with the below changes, AVIC is properly 
enabled in the virtual machine in pit=discard mode (which wasn't the 
case with the earlier changes to svm_[set|clear]_vintr()).

This improves performance in my test by ~10%:
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:           lo      0.12      0.12      0.01      0.01      0.00      0.00      0.00      0.00
Average:       enp0s2 1197141.51 1197158.89 226801.33 114572.12      0.00      0.00      0.00      0.00

This is still ~10% below what I see with avic=0 though.


Thanks,
Naveen

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7640a84e554a..2a5cf7029b26 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3219,20 +3219,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	svm_clear_vintr(to_svm(vcpu));
>  
> -	/*
> -	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
> -	 * In this case AVIC was temporarily disabled for
> -	 * requesting the IRQ window and we have to re-enable it.
> -	 *
> -	 * If running nested, still remove the VM wide AVIC inhibit to
> -	 * support case in which the interrupt window was requested when the
> -	 * vCPU was not running nested.
> -
> -	 * All vCPUs which run still run nested, will remain to have their
> -	 * AVIC still inhibited due to per-cpu AVIC inhibition.
> -	 */
> -	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
> -
>  	++vcpu->stat.irq_window_exits;
>  	return 1;
>  }
> @@ -3670,6 +3656,23 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	u32 type;
>  
> +	/*
> +	 * If AVIC was inhibited in order to detect an IRQ window, and there's
> +	 * no other injectable interrupts pending or L2 is active (see below),
> +	 * then drop the inhibit as the window has served its purpose.
> +	 *
> +	 * If L2 is active, this path is reachable if L1 is not intercepting
> +	 * IRQs, i.e. if KVM is injecting L1 IRQs into L2.  AVIC is locally
> +	 * inhibited while L2 is active; drop the VM-wide inhibit to optimize
> +	 * the case in which the interrupt window was requested while L1 was
> +	 * active (the vCPU was not running nested).
> +	 */
> +	if (svm->avic_irq_window &&
> +	    (!kvm_cpu_has_injectable_intr(vcpu) || is_guest_mode(vcpu))) {
> +		svm->avic_irq_window = false;
> +		kvm_dec_apicv_irq_window(svm->vcpu.kvm);
> +	}
> +
>  	if (vcpu->arch.interrupt.soft) {
>  		if (svm_update_soft_interrupt_rip(vcpu))
>  			return;
> @@ -3881,17 +3884,28 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
>  	 */
>  	if (vgif || gif_set(svm)) {
>  		/*
> -		 * IRQ window is not needed when AVIC is enabled,
> -		 * unless we have pending ExtINT since it cannot be injected
> -		 * via AVIC. In such case, KVM needs to temporarily disable AVIC,
> -		 * and fallback to injecting IRQ via V_IRQ.
> +		 * KVM only enables IRQ windows when AVIC is enabled if there's
> +		 * pending ExtINT since it cannot be injected via AVIC (ExtINT
> +		 * bypasses the local APIC).  V_IRQ is ignored by hardware when
> +		 * AVIC is enabled, and so KVM needs to temporarily disable
> +		 * AVIC in order to detect when it's ok to inject the ExtINT.
>  		 *
> -		 * If running nested, AVIC is already locally inhibited
> -		 * on this vCPU, therefore there is no need to request
> -		 * the VM wide AVIC inhibition.
> +		 * If running nested, AVIC is already locally inhibited on this
> +		 * vCPU (L2 vCPUs use a different MMU that never maps the AVIC
> +		 * backing page), therefore there is no need to increment the
> +		 * VM-wide AVIC inhibit.  KVM will re-evaluate events when the
> +		 * vCPU exits to L1 and enable an IRQ window if the ExtINT is
> +		 * still pending.
> +		 *
> +		 * Note, the IRQ window inhibit needs to be updated even if
> +		 * AVIC is inhibited for a different reason, as KVM needs to
> +		 * keep AVIC inhibited if the other reason is cleared and there
> +		 * is still an injectable interrupt pending.
>  		 */
> -		if (!is_guest_mode(vcpu))
> -			kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
> +		if (enable_apicv && !svm->avic_irq_window && !is_guest_mode(vcpu)) {
> +			svm->avic_irq_window = true;
> +			kvm_inc_apicv_irq_window(vcpu->kvm);
> +		}
>  
>  		svm_set_vintr(svm);
>  	}

