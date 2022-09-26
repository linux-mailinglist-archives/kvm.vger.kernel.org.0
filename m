Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED46B5EADB3
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiIZRLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiIZRK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:10:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8668B3D5A5
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 09:19:57 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l65so7185600pfl.8
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 09:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=riSPHNsF0xOhaGspUldr32iYpAlbd9kHHXWwrlmwZ2k=;
        b=FIWI3/7v4gfpJFuMpLSMQfyTg3db+PwzbaWqx8f7E6SrbPbICQfwX4zFCWo9/9hxi9
         w1bitAo9ZZgAdLVtAaqf/wH+eNIkSeZWzDZewh9RHvH81wnISjzxtCXWfY9el3PfwL4P
         2IuJYBsunIRZ4FO2zjy4vnjAkEb89VjoIcyHgdPys49H1zzLVBZJkNJA8kZZaTS0tEtn
         OMDN5jW5afmMonqZgKYZy2+DHUizQBWUgZC+G+3mtUOgXXeFx7hNpdw/z0wmC4eOhdTd
         vHZT4t/gwi3hQ+98VjYDohxKTNHUMtWksbnx37KWYYgPEMupYeVZDUeEDXUJES3qNlTu
         T1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=riSPHNsF0xOhaGspUldr32iYpAlbd9kHHXWwrlmwZ2k=;
        b=GBzgtocUvrf37Cxza+A8orzCkZx6Uw5Ra3+9PwNkOjokIGUdKG2nj68Q0w8iuqiebk
         Q1H/O22CECn8M7/gSHlA54TfRIMDa70U6Ew60xf/K5EGCRTJCcnhv7pOdSIfRfJHMd8o
         Gdwwl9oMBbVXdx6g4BJmULsDoaBumc6SavEMngsjpXQV2DdbG6HTitF6pI8/HEHe4hha
         PS76rGaPrdAeL0p5khfb0xhtxyiHIJ7gVXvJ3zEU+SwwF2lbPt0/sTyreOEIJst8G7Io
         GbTaorEnbtBxoLmvPz+lpEKGYdIF/JMJUHK6YTWx3KrBxwXDzGE+13J+RwjqH5oVa7fl
         NV0Q==
X-Gm-Message-State: ACrzQf03R4m9YePHpMhumbONR4ZG9+z0OAhXvLZsrAzfEWkeI0gZRi7m
        vjm3/wiZC8AMC51cdsqh/JC1sA==
X-Google-Smtp-Source: AMsMyM7peqaL0FeyMjAray29j78rgv40wbugk9BjKI2iAb7xx7yzdEdFI7np8fAM372vbK2vOI8DrQ==
X-Received: by 2002:a05:6a00:2350:b0:541:b5bf:2774 with SMTP id j16-20020a056a00235000b00541b5bf2774mr24274454pfj.28.1664209196845;
        Mon, 26 Sep 2022 09:19:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b15-20020a65578f000000b004348bd693a8sm11011159pgr.31.2022.09.26.09.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 09:19:56 -0700 (PDT)
Date:   Mon, 26 Sep 2022 16:19:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jon@nutanix.com,
        kevin.tian@intel.com, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v2] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Message-ID: <YzHRKO1v5N/BIQl6@google.com>
References: <20220923085806.384344-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923085806.384344-1-chao.gao@intel.com>
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

On Fri, Sep 23, 2022, Chao Gao wrote:
> Set PID.SN right after VM exits and clear it before VM entry to minimize
> the chance of hardware issuing PINs to a CPU when it's in host.

Toggling PID.SN as close to the world switch as possible is undesirable.  If KVM
re-enters the guest without enabling IRQs, i.e. handles the VM-Exit in the fastpath,
then the notification IRQ will be delivered in the guest.

The natural location to do the toggling is when KVM "toggles" software, i.e. when
KVM sets IN_GUEST_MODE (clear SN) and OUTSIDE_GUEST_MODE (set SN).

I believe that would also obviate the need to manually send a PI Notification IRQ,
as the existing ->sync_pir_to_irr() call that exists to handle exactly this case
(notification not sent or handled in host) would ensure any outstanding posted IRQ
gets moved to the IRR and processed accordingly.

> Opportunistically clean up vmx_vcpu_pi_put(); when a vCPU is preempted,

Uh uh, this patch is already way, way too subtle and complex to tack on clean up.
"Opportunistic" clean up is for cases where the clean up is a pure refactoring
and/or has zero impact on functionality.

> it is pointless to update PID.NV to wakeup vector since notification is
> anyway suppressed. And since PID.SN should be already set for running
> vCPUs, so, don't set it again for preempted vCPUs.

I'm pretty sure this is wrong.  If the vCPU is preempted between prepare_to_rcuwait()
and schedule(), then skipping pi_enable_wakeup_handler() will hang the guest if
the wakeup event is a posted IRQ and the event arrives while the vCPU is preempted.

> When IPI virtualization is enabled, this patch increases "perf bench" [*]
> by 6.56%, and PIN count in 1 second drops from tens of thousands to
> hundreds. But cpuid loop test shows this patch causes 1.58% overhead in
> VM-exit round-trip latency.

The overhead is more than likely due to pi_is_pir_empty() in the VM-Entry path,
i.e. should in theory go away if PID.SN is clear/set at IN_GUEST_MODE and
OUTSIDE_GUEST_MODE

> Also honour PID.SN bit in vmx_deliver_posted_interrupt().

Why?

> When IPI virtualization is enabled, this patch increases "perf bench" [*]
> by 6.56%, and PIN count in 1 second drops from tens of thousands to
> hundreds. But cpuid loop test shows this patch causes 1.58% overhead in
> VM-exit round-trip latency.
> 
> [*] test cmd: perf bench sched pipe -T. Note that we change the source
> code to pin two threads to two different vCPUs so that it can reproduce
> stable results.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
> RFC: I am not sure whether the benefits outweighs the extra VM-exit cost.
> 
> Changes in v2 (addressed comments from Kevin):
> - measure/estimate the impact to non-IPC-intensive cases
> - don't tie PID.SN to vcpu->mode. Instead, clear PID.SN
>   right before VM-entry and set it after VM-exit.

Ah, sorry, missed v1.  Rather than key off of IN_GUEST_MODE in the sync path, add
an explicit kvm_x86_ops hook to perform the transition.  I.e. make it explict.

> - use !pi_is_pir_empty() in pi_enable_wakeup_handler() to
>   check if any interrupt was posted after clearing SN.
> - clean up vmx_vcpu_pi_put(). See comments above.
> 
>  arch/x86/kvm/lapic.c           |  2 ++
>  arch/x86/kvm/vmx/posted_intr.c | 55 +++++++++++-----------------------
>  arch/x86/kvm/vmx/vmx.c         | 34 ++++++++++++++++++++-
>  3 files changed, 53 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9dda989a1cf0..a9f27c6ce937 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -128,7 +128,9 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
>  }
>  
>  __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
> +EXPORT_SYMBOL_GPL(apic_hw_disabled);
>  __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
> +EXPORT_SYMBOL_GPL(apic_sw_disabled);

These exports will hopefully go away.

>  static inline int apic_enabled(struct kvm_lapic *apic)
>  {
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 1b56c5e5c9fb..9cec3dd88f75 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -70,12 +70,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  	 * needs to be changed.
>  	 */
>  	if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu == cpu) {
> -		/*
> -		 * Clear SN if it was set due to being preempted.  Again, do
> -		 * this even if there is no assigned device for simplicity.
> -		 */
> -		if (pi_test_and_clear_sn(pi_desc))
> -			goto after_clear_sn;
>  		return;
>  	}
>  
> @@ -101,11 +95,16 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		new.control = old.control;
>  
>  		/*
> -		 * Clear SN (as above) and refresh the destination APIC ID to
> -		 * handle task migration (@cpu != vcpu->cpu).
> +		 * Set SN and refresh the destination APIC ID to handle
> +		 * task migration (@cpu != vcpu->cpu).
> +		 *
> +		 * SN is cleared when a vCPU goes to blocked state so that
> +		 * the blocked vCPU can be waken up on receiving a
> +		 * notification. For a running/runnable vCPU, such
> +		 * notifications are useless. Set SN bit to suppress them.
>  		 */
>  		new.ndst = dest;
> -		new.sn = 0;
> +		new.sn = 1;

To handle the preempted case, I believe the correct behavior is to leave SN
as-is, although that would require setting SN=1 during vCPU creation.  Arguably
KVM should do that anyways when APICv is enabled.

Hmm, or alternatively this should do the same?

		new.sn = !kvm_vcpu_is_blocking();

> @@ -172,8 +160,10 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	 * enabled until it is safe to call try_to_wake_up() on the task being
>  	 * scheduled out).
>  	 */
> -	if (pi_test_on(&new))
> +	if (!pi_is_pir_empty(pi_desc)) {
> +		pi_set_on(pi_desc);

As much as I wish we could get rid of kvm_arch_vcpu_blocking(), I actually think
this would be a good application of that hook.  If PID.SN is cleared during
kvm_arch_vcpu_blocking() and set during kvm_arch_vcpu_unblocking(), then I believe
there's no need to manually check the PIR here, as any IRQ that isn't detected by
kvm_vcpu_check_block() is guaranteed to set PID.ON=1.

>  		apic->send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
> +	}
>  
>  	local_irq_restore(flags);
>  }
> @@ -193,21 +183,12 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
>  
>  void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>  {
> -	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> -
>  	if (!vmx_needs_pi_wakeup(vcpu))
>  		return;
>  
> -	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
> +	if (!vcpu->preempted && kvm_vcpu_is_blocking(vcpu) &&

As above, I don't think skipping this for preempted is correct.

> +	    !vmx_interrupt_blocked(vcpu))
>  		pi_enable_wakeup_handler(vcpu);
> -
> -	/*
> -	 * Set SN when the vCPU is preempted.  Note, the vCPU can both be seen
> -	 * as blocking and preempted, e.g. if it's preempted between setting
> -	 * its wait state and manually scheduling out.
> -	 */

Assuming I'm correct, hoist the "note" above to document that KVM needs to enable
the wakeup handler even when the vCPU is preempted.

> -	if (vcpu->preempted)
> -		pi_set_sn(pi_desc);
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c9b49a09e6b5..949fb80eca3d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4186,6 +4186,9 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>  	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
>  		return 0;
>  
> +	if (pi_test_sn(&vmx->pi_desc))
> +		return 0;

Should be unnecessary.
