Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF55485B2C
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 22:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244649AbiAEV4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 16:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244639AbiAEV4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 16:56:36 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BE5C061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 13:56:36 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 8so344181pgc.10
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 13:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xdjsovFc/nON5wnse3BZmRrklvHqQCIYLQiW2THlrxY=;
        b=O42b2Evp887BBH/weMa6uzm2GzWnJjAEotSFojeuIq35IcjmJvV2yhGTgkEdApvF1U
         NSMaQ9+CB6t1l88C0Eo4AJkfHRlncQrfF0a+7qEXoHxylhCo6LnHchr6tfBVZZ9QDu4R
         OCaPhsYtuC0Z/fhSpaErPyG+QphuL0qpe20hpre1hzOWl3Nkd7j4ke9mGl2JnGaIG9+q
         n7b1GzeF3nt3wzn8mmqPuBHGh5F3IvrX/obtqsHNUwli7V7cwkq6Gc6rAIrGwfK29HFe
         UDUPwb+zybcBlNQr2y1q6ZA8wAdJl2E5eMUgxDTGc9DosM2HX6CoyX+x6PGcHi4ZzZFn
         yCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xdjsovFc/nON5wnse3BZmRrklvHqQCIYLQiW2THlrxY=;
        b=kE00BmcJZXBWYWYBQBJ9UyZ2R8mst3L5kxUNjJvvtVJXy4ayVsnR4cIszaPK7QBBCQ
         JHsSu4OHL6jw7XBVwnzaVMuSoYY4wQSo2CkinInK3pf0MEWQwNihOGxZUvTXbHUfK/v7
         KkEhsx4CVO+QXHo4RLSs7NzfumAq0x4DYpCVOQvYsJdNPm60lcQCo/pn2kPnwU10QJCw
         FNt8CpcJx+JH2vVf+0HPVHwCfT2KZfkywfTbC31uZvCMmQi9zeLDVIsbe4/Cd1rjaVr3
         fTCCY++8vyVvo/BJtC9BG8c80c9eVjT5hTTuVIlYZ9OAB8gr4Rn5jR3F8R6vc02dZp4f
         kALQ==
X-Gm-Message-State: AOAM5336FNbiqHnyLjajbMvIEgqvWXV5RFGcmaZI6Wjl4E0uA/eYmy08
        tAZ9yAEz075PIuy/fayeiTUIUQ==
X-Google-Smtp-Source: ABdhPJz5RLD0EsXCSaV6qR9HhnUxioq0GE8qo9I3/CQHwFLJ7pJDpx480F84CSaZ4BU1nQLg9ce7Zw==
X-Received: by 2002:a65:55c7:: with SMTP id k7mr50241731pgs.511.1641419795683;
        Wed, 05 Jan 2022 13:56:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mi5sm3860300pjb.21.2022.01.05.13.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 13:56:35 -0800 (PST)
Date:   Wed, 5 Jan 2022 21:56:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 5/5] KVM: SVM: allow AVIC to co-exist with a nested
 guest running
Message-ID: <YdYUD22otUIF3fqR@google.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-6-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213104634.199141-6-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, Maxim Levitsky wrote:
> @@ -1486,6 +1485,12 @@ struct kvm_x86_ops {
>  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>  
>  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> +
> +	/*
> +	 * Returns false if for some reason APICv (e.g guest mode)
> +	 * must be inhibited on this vCPU

Comment is wrong, code returns 'true' if AVIC is inhibited due to is_guest_mode().
Even better, rename the hook to something that's more self-documenting.

vcpu_is_apicv_inhibited() jumps to mind, but that's a bad name since it's not
called by kvm_vcpu_apicv_active().  Maybe vcpu_has_apicv_inhibit_condition()?

> +	 */
> +	bool (*apicv_check_inhibit)(struct kvm_vcpu *vcpu);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 34f62da2fbadd..5a8304938f51e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -734,6 +734,11 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
>  	return 0;
>  }
>  
> +bool avic_is_vcpu_inhibited(struct kvm_vcpu *vcpu)

This should follow whatever wording we decide on for the kvm_x86_ops hook.  In
isolation, this name is too close to kvm_vcpu_apicv_active() and could be wrongly
assumed to mean that APICv is not inhibited for _any_ reason on this vCPU if it
returns false.

> +{
> +	return is_guest_mode(vcpu);
> +}
> +
>  bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	return false;

...

> @@ -4486,6 +4493,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.complete_emulated_msr = svm_complete_emulated_msr,
>  
>  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> +	.apicv_check_inhibit = avic_is_vcpu_inhibited,

This can technically be NULL if nested=0.

>  };
>  
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index daa8ca84afccd..545684ea37353 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -590,6 +590,7 @@ void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
>  void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
>  void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
>  int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
> +bool avic_is_vcpu_inhibited(struct kvm_vcpu *vcpu);
>  bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>  		       uint32_t guest_irq, bool set);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 81a74d86ee5eb..125599855af47 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9161,6 +9161,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
>  		r = kvm_check_nested_events(vcpu);
>  		if (r < 0)
>  			goto out;
> +
> +		/* Nested VM exit might need to update APICv status */
> +		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
> +			kvm_vcpu_update_apicv(vcpu);
>  	}
>  
>  	/* try to inject new event if pending */
> @@ -9538,6 +9542,10 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  	down_read(&vcpu->kvm->arch.apicv_update_lock);
>  
>  	activate = kvm_apicv_activated(vcpu->kvm);
> +
> +	if (kvm_x86_ops.apicv_check_inhibit)
> +		activate = activate && !kvm_x86_ops.apicv_check_inhibit(vcpu);

Might as well use Use static_call().  This would also be a candidate for
DEFINE_STATIC_CALL_RET0, though that's overkill if this is the only call site.

> +
>  	if (vcpu->arch.apicv_active == activate)
>  		goto out;
>  
> @@ -9935,7 +9943,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		 * per-VM state, and responsing vCPUs must wait for the update
>  		 * to complete before servicing KVM_REQ_APICV_UPDATE.
>  		 */
> -		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> +		if (!is_guest_mode(vcpu))
> +			WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> +		else
> +			WARN_ON(kvm_vcpu_apicv_active(vcpu));

Won't this fire on VMX?

>  
>  		exit_fastpath = static_call(kvm_x86_run)(vcpu);
>  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
> -- 
> 2.26.3
> 
