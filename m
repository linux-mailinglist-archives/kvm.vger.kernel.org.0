Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E334625A9
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhK2WmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbhK2WlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:41:14 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0722BC0FE6CD
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:14:34 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g19so18398300pfb.8
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vJr1WdAhjm9K0bo/NyTysmBXUmrGdwZ7UXHYeZqs6A8=;
        b=jdenIRW0OyIXe10cw0js/ZnNTpE8qTUaHcTLqnB+y0RwKsdGlV1H6tro2In8FIoSfG
         iZL2fXqcuolco57Hre7w5GH3eUP85HClcmJQ5zGyoCygJLtxNsK3qosIljIs7AdyWZc+
         M0BZ3MW2LHKi3OGNITu1k8b+P6eRcpWlVcNKpeWNDAQjJJkFeGYyiThy1oRSOI/FIklr
         T2dN8qmpWPyE2Im5mOWCvjKi9OAlFw6Sc9ImvwnjtquXM1LOFMjXqW4R6sNAazwYXfee
         94hRnZxRXYMxQEIzOr9D6p3tZfFoHpEA9pmlYwUzYVpPd3fDuw0hhSRAchvW2acvY7Dk
         tiTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vJr1WdAhjm9K0bo/NyTysmBXUmrGdwZ7UXHYeZqs6A8=;
        b=SDLmaBFJnEPKISRGF3cbiS2Lsmo+juiMoQ4nAl2R/5ciPyd1kLo1aPTnbzEIQemtfF
         ikRb8XdVu6nKen4fjZmDmGmezZvSGsZQimAc1sg8zjX/Yuw/HNHp20egHcxBi11DnjCt
         xWFM/ggHqyBDmJ32WzD8qRBWH+G/IuC4ZjRIGpO4vPOm/PJ7siQyd8CCUxyaoG8/YCAm
         Xtt4kToIVGXAO6vtuzfQr9z8bJtv8jxd8/g6iWKJp6DUR5LdWmrnFro5UWU6Ta/umpXp
         z1A9yqn4IF/gZYJXwfr+TkTirPMPpgWJcVeaW4uvXdFZ6EpENCc/Q8mdg2QRO1F9+zyS
         Qklg==
X-Gm-Message-State: AOAM5320cWXAjEfA8NwwqfjFT1rwd/RnkulYDj3w7GnTT1FmkDv11mdV
        Hh9feL2YCtTy6USZQWiaGwJ1ng==
X-Google-Smtp-Source: ABdhPJw2WkFD6GadsTgMaNDrZxN0dOHmssbuABOd/93651c3GRU+L1jbEthI31TKKWKXRWgKbF7jbg==
X-Received: by 2002:a05:6a00:1821:b0:4a4:ab04:39a with SMTP id y33-20020a056a00182100b004a4ab04039amr42940454pfa.76.1638224073328;
        Mon, 29 Nov 2021 14:14:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l21sm299058pjt.24.2021.11.29.14.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 14:14:32 -0800 (PST)
Date:   Mon, 29 Nov 2021 22:14:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: VMX: prepare sync_pir_to_irr for running with
 APICv disabled
Message-ID: <YaVQxZ42Ve6JNIzt@google.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
 <20211123004311.2954158-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123004311.2954158-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Paolo Bonzini wrote:
> If APICv is disabled for this vCPU, assigned devices may
> still attempt to post interrupts.  In that case, we need
> to cancel the vmentry and deliver the interrupt with
> KVM_REQ_EVENT.  Extend the existing code that handles
> injection of L1 interrupts into L2 to cover this case
> as well.
> 
> vmx_hwapic_irr_update is only called when APICv is active
> so it would be confusing to add a check for
> vcpu->arch.apicv_active in there.  Instead, just use
> vmx_set_rvi directly in vmx_sync_pir_to_irr.

Overzealous newlines.

If APICv is disabled for this vCPU, assigned devices may still attempt to
post interrupts.  In that case, we need to cancel the vmentry and deliver
the interrupt with KVM_REQ_EVENT.  Extend the existing code that handles
injection of L1 interrupts into L2 to cover this case as well.

vmx_hwapic_irr_update is only called when APICv is active so it would be
confusing to add a check for vcpu->arch.apicv_active in there.  Instead,
just use vmx_set_rvi directly in vmx_sync_pir_to_irr.


> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++------------
>  1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ba66c171d951..cccf1eab58ac 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6264,7 +6264,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>  	int max_irr;
>  	bool max_irr_updated;
>  
> -	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
> +	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
>  		return -EIO;
>  
>  	if (pi_test_on(&vmx->pi_desc)) {
> @@ -6276,20 +6276,31 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>  		smp_mb__after_atomic();
>  		max_irr_updated =
>  			kvm_apic_update_irr(vcpu, vmx->pi_desc.pir, &max_irr);
> -
> -		/*
> -		 * If we are running L2 and L1 has a new pending interrupt
> -		 * which can be injected, this may cause a vmexit or it may
> -		 * be injected into L2.  Either way, this interrupt will be
> -		 * processed via KVM_REQ_EVENT, not RVI, because we do not use
> -		 * virtual interrupt delivery to inject L1 interrupts into L2.
> -		 */
> -		if (is_guest_mode(vcpu) && max_irr_updated)
> -			kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	} else {
>  		max_irr = kvm_lapic_find_highest_irr(vcpu);
> +		max_irr_updated = false;

Heh, maybe s/max_irr_updated/new_pir_found or so?  This is a bit weird:

  1. Update max_irr
  2. max_irr_updated = false

>  	}
> -	vmx_hwapic_irr_update(vcpu, max_irr);
> +
> +	/*
> +	 * If virtual interrupt delivery is not in use, the interrupt
> +	 * will be processed via KVM_REQ_EVENT, not RVI.  This can happen

I'd strongly prefer to phrase this as a command, e.g. "process the interrupt via
KVM_REQ_EVENT".  "will be processed" makes it sound like some other flow is
handling the event, which confused me.

> +	 * in two cases:
> +	 *
> +	 * 1) If we are running L2 and L1 has a new pending interrupt

Hmm, calling it L1's interrupt isn't technically wrong, but it's a bit confusing
because it's handled in L2.  Maybe just say "vCPU"?

> +	 * which can be injected, this may cause a vmexit or it may

Overzealous newlines again.

> +	 * be injected into L2.  We do not use virtual interrupt
> +	 * delivery to inject L1 interrupts into L2.

I found the part of "may cause a vmexit or may be injected into L2" hard to
follow, I think because this doesn't explicit state that the KVM_REQ_EVENT is
needed to synthesize a VM-Exit.

How about this for the comment?

	/*
	 * If virtual interrupt delivery is not in use, process the interrupt
	 * via KVM_REQ_EVENT, not RVI.  This is necessary in two cases:
	 *
	 * 1) If L2 is running and the vCPU has a new pending interrupt.  If L1
	 * wants to exit on interrupts, KVM_REQ_EVENT is needed to synthesize a
	 * VM-Exit to L1.  If L1 doesn't want to exit, the interrupt is injected
	 * into L2, but KVM doesn't use virtual interrupt delivery to inject
	 * interrupts into L2, and so KVM_REQ_EVENT is again needed.
	 *
	 * 2) If APICv is disabled for this vCPU, assigned devices may still
	 * attempt to post interrupts.  The posted interrupt vector will cause
	 * a VM-Exit and the subsequent entry will call sync_pir_to_irr.
	 */

> +	 *
> +	 * 2) If APICv is disabled for this vCPU, assigned devices may
> +	 * still attempt to post interrupts.  The posted interrupt
> +	 * vector will cause a vmexit and the subsequent entry will
> +	 * call sync_pir_to_irr.
> +	 */
> +	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active)

If the second check uses kvm_vcpu_apicv_active(), this will avoid a silent conflict
when kvm/master and kvm/queue are merged.

Nits aside, the logic is good:

Reviewed-by: Sean Christopherson <seanjc@google.com>

> +		vmx_set_rvi(max_irr);
> +	else if (max_irr_updated)
> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
> +
>  	return max_irr;
>  }
>  
> -- 
> 2.27.0
> 
> 
