Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076976C5B86
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 01:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjCWAtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 20:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjCWAtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 20:49:50 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617AD3C32
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 17:49:49 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 140-20020a630792000000b0050be9465db8so5139680pgh.2
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 17:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679532589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zwyTZ6PPDlnRZ+ynhQz9mBlyubWr9J0/Y5MHbDWpLSo=;
        b=dh7zaaeyc7G6ZT7JBzoyD0LhZsP8pQF7EtF1VKDgQTLfVeofXv5NFsXlGvhm/5Y+uQ
         A2l0AHmazfJSOind1Dc0U8haTrD2hsRYL2w66BLtYrwIA/p2u4aHBBaHLjyOiiccI3/H
         rrVCsUPf5oovclYimaRs7Dm90jHzO7SqrsIe3ZEJZdqC1uPXs0iRlvWt4ZouhzJ65QJS
         umtT+BjVR0JiiGd1PI9fh8AIcCG85x3vfGaIL8owz1bIdHRH7oyvUVmIu2VTCss5LWN7
         Z2dL0VOT4Ym+ijISqZ4swB/8QLjsWEEPywlYc4Qe9jxSVXGDDWW8+7m/uD0dEp53foBp
         Efpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679532589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwyTZ6PPDlnRZ+ynhQz9mBlyubWr9J0/Y5MHbDWpLSo=;
        b=YD5oQUwF4hXbv01MPT/EkIFWL+kN/K92teGqzT7WeqdAYe07nHBOAo4NOm1aSzzBDp
         iOOL4O7CzCcBvqkB+tS36qfmCdsvOXdZCKr8GqGBIojmDWInsJsJ6JzYSGzKwXtu9Ra8
         ma/TC2ucvRdLfd+/hkmDcGpvXcszFDzOlY87+WkUJpcOX0zKv0NXxUJveB1ou5vqTXGY
         0QLS/xqA0rDDdYmUsAmurTHlowGF7xsh7Jern0aXTeAoF8YZe3ssZ6bsOrS8ch2TgRVk
         5JYxlyK4smG7emSlb70lIjysDLCe2jvzJtKQ8yWt5tE7rE11ElJLuII98GsOUpsT7cQe
         95lQ==
X-Gm-Message-State: AO0yUKWQEQaTlCS1/i7BC23jCLf/fFgirJg63nBXcCIAgGyu0jQrvDMK
        cbV7QtEtzzBMtawKjZ7zYpxc03zZQos=
X-Google-Smtp-Source: AK7set/ggVY7eghL5+4OPHbzZnQdu8vaJmFCyxwI0dYxc5vdM79JxaftdCW3cxcpUdqPtzaxAJkWX+vAIyo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9a9:b0:625:563e:7d17 with SMTP id
 u41-20020a056a0009a900b00625563e7d17mr3134470pfg.0.1679532588962; Wed, 22 Mar
 2023 17:49:48 -0700 (PDT)
Date:   Wed, 22 Mar 2023 17:49:47 -0700
In-Reply-To: <20230227084016.3368-11-santosh.shukla@amd.com>
Mime-Version: 1.0
References: <20230227084016.3368-1-santosh.shukla@amd.com> <20230227084016.3368-11-santosh.shukla@amd.com>
Message-ID: <ZBuiK3bJyxsZ0k5A@google.com>
Subject: Re: [PATCHv4 10/11] KVM: x86: add support for delayed virtual NMI
 injection interface
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, mlevitsk@redhat.com,
        thomas.lendacky@amd.com, vkuznets@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please take the time to update shortlogs, changelogs, and comments when spinning
a new version.  This patch does waaaaay more than just "add support for delayed
virtual NMI injection interface", and the changelog isn't any better.   As you
can probably deduce from the nearly one month delay in me reviewing this version,
churning out a new version as quickly as possible is slower overall than taking
the time to make each version as solid as possible.

I'll fix things up this time.  I don't mind that much in this case because the
vNMI stuff is rather subtle and it reworking changelogs+comments was a good way
to review the code.  But in the future please take the time to fine tune the
entire patch, not just the code.

On Mon, Feb 27, 2023, Santosh Shukla wrote:
> Introducing two new vendor callbacks so to support virtual NMI
> injection example vNMI feature for SVM.
> 
> - kvm_x86_is_vnmi_pending()
> - kvm_x86_set_vnmi_pending()
> 
> Using those callbacks the KVM can take advantage of the
> hardware's accelerated delayed NMI delivery (currently vNMI on SVM).
> 
> Once NMI is set to pending via this interface, it is assumed that

State what the hardware does, not what it is assumed to do.  Hardware behavior
must be an immutable truth as far as KVM is concerned.

> the hardware will deliver the NMI on its own to the guest once
> all the x86 conditions for the NMI delivery are met.
> 
> Note that the 'kvm_x86_set_vnmi_pending()' callback is allowed
> to fail, in which case a normal NMI injection will be attempted
> when NMI can be delivered (possibly by using a NMI window).

Leading with "possibly by using an NMI window" and then contradicting that a few
sentences later is really confusing.

> With vNMI that can happen either if vNMI is already pending or
> if a nested guest is running.
> 
> When the vNMI injection fails due to the 'vNMI is already pending'
> condition, the new NMI will be dropped unless the new NMI can be
> injected immediately, so no NMI window will be requested.
> 
> Use '.kvm_x86_set_hw_nmi_pending' method to inject the

Stale reference.  Just delete this sentence, the role of the changelog is not to
give a play-by-play of the code.

> pending NMIs for AMD's VNMI feature.
> 
> Note that vNMI doesn't need nmi_window_existing feature to
> pend the new virtual NMI and that KVM will now be able to
> detect with flag (KVM_VCPUEVENT_VALID_NMI_PENDING) and pend
> the new NMI by raising KVM_REQ_NMI event.
> 
> Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
> Co-developed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
> v3:
>  - Fixed SOB
>  - Merged V_NMI implementation with x86_ops delayed NMI
>    API proposal for better readablity.
>  - Added early WARN_ON for VNMI case in svm_enable_nmi_window.
>  - Indentation and style fixes per v2 comment.
>  - Removed `svm->nmi_masked` check from svm_enable_nmi_window
>    and replaced with svm_get_nmi_mask().
>  - Note that I am keeping kvm_get_total_nmi_pending() logic
>    like v2.. since `events->nmi.pending` is u8 not a boolean.
> https://lore.kernel.org/all/Y9mwz%2FG6+G8NSX3+@google.com/
> 
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |  11 ++-
>  arch/x86/kvm/svm/svm.c             | 113 +++++++++++++++++++++++------
>  arch/x86/kvm/svm/svm.h             |  22 ++++++
>  arch/x86/kvm/x86.c                 |  26 ++++++-
>  5 files changed, 147 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 8dc345cc6318..092ef2398857 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -68,6 +68,8 @@ KVM_X86_OP(get_interrupt_shadow)
>  KVM_X86_OP(patch_hypercall)
>  KVM_X86_OP(inject_irq)
>  KVM_X86_OP(inject_nmi)
> +KVM_X86_OP_OPTIONAL_RET0(is_vnmi_pending)
> +KVM_X86_OP_OPTIONAL_RET0(set_vnmi_pending)
>  KVM_X86_OP(inject_exception)
>  KVM_X86_OP(cancel_injection)
>  KVM_X86_OP(interrupt_allowed)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 792a6037047a..f8a44c6c8633 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -878,7 +878,11 @@ struct kvm_vcpu_arch {
>  	u64 tsc_scaling_ratio; /* current scaling ratio */
>  
>  	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
> -	unsigned nmi_pending; /* NMI queued after currently running handler */
> +	/*
> +	 * NMI queued after currently running handler
> +	 * (not including a hardware pending NMI (e.g vNMI))
> +	 */
> +	unsigned int nmi_pending;
>  	bool nmi_injected;    /* Trying to inject an NMI this entry */
>  	bool smi_pending;    /* SMI queued after currently running handler */
>  	u8 handling_intr_from_guest;
> @@ -1640,6 +1644,10 @@ struct kvm_x86_ops {
>  	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
>  	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
>  	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
> +	/* returns true, if a NMI is pending injection on hardware level (e.g vNMI) */
> +	bool (*is_vnmi_pending)(struct kvm_vcpu *vcpu);
> +	/* attempts make a NMI pending via hardware interface (e.g vNMI) */

Expand this comment to justify/explain the use of a boolean return (static_call
RET0).

> +	bool (*set_vnmi_pending)(struct kvm_vcpu *vcpu);
>  	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
>  	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
>  	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);

...

> @@ -3745,8 +3802,8 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	 * problem (IRET or exception injection or interrupt shadow)
>  	 */
>  	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
> -	svm->nmi_singlestep = true;
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> +	svm->nmi_singlestep = true;

Spurious change.

>  }
>  
>  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> @@ -4780,6 +4837,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.patch_hypercall = svm_patch_hypercall,
>  	.inject_irq = svm_inject_irq,
>  	.inject_nmi = svm_inject_nmi,
> +	.is_vnmi_pending = svm_is_vnmi_pending,
> +	.set_vnmi_pending = svm_set_vnmi_pending,
>  	.inject_exception = svm_inject_exception,
>  	.cancel_injection = svm_cancel_injection,
>  	.interrupt_allowed = svm_interrupt_allowed,
> @@ -5070,6 +5129,16 @@ static __init int svm_hardware_setup(void)
>  			pr_info("Virtual GIF supported\n");
>  	}
>  
> +	vnmi = vgif && vnmi && boot_cpu_has(X86_FEATURE_AMD_VNMI);
> +	if (vnmi)
> +		pr_info("Virtual NMI enabled\n");
> +
> +	if (!vnmi) {
> +		svm_x86_ops.is_vnmi_pending = NULL;
> +		svm_x86_ops.set_vnmi_pending = NULL;
> +	}
> +
> +
>  	if (lbrv) {
>  		if (!boot_cpu_has(X86_FEATURE_LBRV))
>  			lbrv = false;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 839809972da1..fb48c347bbe0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -36,6 +36,7 @@ extern bool npt_enabled;
>  extern int vgif;
>  extern bool intercept_smi;
>  extern bool x2avic_enabled;
> +extern bool vnmi;
>  
>  /*
>   * Clean bits in VMCB.
> @@ -548,6 +549,27 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
>  	       (msr < (APIC_BASE_MSR + 0x100));
>  }
>  
> +static inline struct vmcb *get_vnmi_vmcb_l1(struct vcpu_svm *svm)
> +{
> +	if (!vnmi)
> +		return NULL;
> +
> +	if (is_guest_mode(&svm->vcpu))
> +		return NULL;
> +	else
> +		return svm->vmcb01.ptr;
> +}
> +
> +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = get_vnmi_vmcb_l1(svm);
> +
> +	if (vmcb)
> +		return !!(vmcb->control.int_ctl & V_NMI_ENABLE_MASK);
> +	else
> +		return false;
> +}
> +
>  /* svm.c */
>  #define MSR_INVALID				0xffffffffU
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b22074f467e0..b5354249fe00 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5113,7 +5113,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>  	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>  
>  	events->nmi.injected = vcpu->arch.nmi_injected;
> -	events->nmi.pending = vcpu->arch.nmi_pending;
> +	events->nmi.pending = kvm_get_total_nmi_pending(vcpu);
>  	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
>  
>  	/* events->sipi_vector is never valid when reporting to user space */
> @@ -5201,9 +5201,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  
>  	vcpu->arch.nmi_injected = events->nmi.injected;
>  	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING) {
> -		vcpu->arch.nmi_pending = events->nmi.pending;
> -		if (vcpu->arch.nmi_pending)
> -			kvm_make_request(KVM_REQ_NMI, vcpu);
> +		vcpu->arch.nmi_pending = 0;
> +		atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
> +		kvm_make_request(KVM_REQ_NMI, vcpu);

I'm going to split this out to a separate patch.  I want to isolate this change
from vNMI support, and unlike the addition of the kvm_x86_ops hooks, it makes
sense as a standalone thing (at least, IMO it does :-) ).

>  	}
>  	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
>  

...

> +/* Return total number of NMIs pending injection to the VM */
> +int kvm_get_total_nmi_pending(struct kvm_vcpu *vcpu)

I much prefer kvm_get_nr_pending_nmis() to make it obvious that this returns a
number and that that number can be greater than 1.

> +{
> +	return vcpu->arch.nmi_pending + static_call(kvm_x86_is_vnmi_pending)(vcpu);
> +}
> +
> +
>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>  				       unsigned long *vcpu_bitmap)
>  {
> -- 
> 2.25.1
> 
