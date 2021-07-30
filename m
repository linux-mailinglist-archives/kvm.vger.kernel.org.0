Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2CF3DBFEC
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 22:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhG3Ulw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 16:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhG3Ulw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 16:41:52 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3581AC06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 13:41:46 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso16100598pjo.1
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 13:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iGe3a44MKzp7hLQkGT4D/Xx3gHqLq0hzI8UAi85GNqw=;
        b=TmGetRmin6MgmAKL/h0wdXzjCugBlEBEIK09snStOeePSa8kW64PlGuJzkqZLhfDRU
         AJbPtfF7i0vAdJFBkxe9Q0lpZD9QA1DivovKWsMFS0xUwDDOETY8UY6YkGBPYhF9gMiv
         83F0kpmNfD023b455IX6oUyLR0wtNUf6ca047rpfBN7qU+rJIWxKTWqWWvs9GFQ0pnnT
         US95RW7W2ZbQMe/MjYgHSrnoSBvGOLarFpcHu5bRDedoJ7zoy/5g2dIUcSNKI7d7erVh
         VS87upuUEMYVTKdM63afnqMHLlG2lWcVMEgxPj1DYk6wWtMB6n7pj45jbAHAJ4YoGga8
         VXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iGe3a44MKzp7hLQkGT4D/Xx3gHqLq0hzI8UAi85GNqw=;
        b=ckPNd8jPbOSaJrYTlfe4veuX9lUEAsWbukdZfLZFq5XHnfs8aYLiXSAYthuL09FKV2
         tP3RDUkLdH7gEnCJxSUAdkWdtZRqWIW3j8JynB26s2iehD6PRf1buwCE04Yoey/Z6hlV
         5x+343dPpuznkh+IDVf+FjCH8tfjauVwCw4unZj3EVkShQqoxd+d3V/Fa4Havh6YPzc8
         lT6Ww5QjG7vRyWMmJKweQ9W+qgMZVIakwrYWaYI7d30lHyYuEHma6N8N6sRMBmfD56uo
         4JHyf75DiHj9HH2VMNdv1P3pgVL015b1Uqs0fB7a+0tz3wmGC5yAz5hxii/EFSD+AV/k
         vhRw==
X-Gm-Message-State: AOAM530vnA/vlW2LRuvf+TQJ/TqxDBekqsGFP27vxJIiggG4YIgcN36l
        MQAiaegyD/5U+FARpfmynUJN7g==
X-Google-Smtp-Source: ABdhPJzuxOTTAum430R3h8k8t8GJddigk/qji8DXsIAUwzaogcmfCbHxt1c1IReEAD974D4EYFJMCA==
X-Received: by 2002:a65:4286:: with SMTP id j6mr32138pgp.10.1627677705242;
        Fri, 30 Jul 2021 13:41:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x24sm3245180pjk.43.2021.07.30.13.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 13:41:44 -0700 (PDT)
Date:   Fri, 30 Jul 2021 20:41:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
Message-ID: <YQRkBI9RFf6lbifZ@google.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525051204.1480610-1-tao3.xu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021, Tao Xu wrote:
>  #endif /* __KVM_X86_VMX_CAPS_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bceb5ca3a89..c0ad01c88dac 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -205,6 +205,10 @@ module_param(ple_window_max, uint, 0444);
>  int __read_mostly pt_mode = PT_MODE_SYSTEM;
>  module_param(pt_mode, int, S_IRUGO);
>  
> +/* Default is 0, less than 0 (for example, -1) disables notify window. */
> +static int __read_mostly notify_window;

I'm not sure I like the idea of trusting ucode to select an appropriate internal
threshold.  Unless the internal threshold is architecturally defined to be at
least N nanoseconds or whatever, I think KVM should provide its own sane default.
E.g. it's not hard to imagine a scenario where a ucode patch gets rolled out that
adjusts the threshold and starts silently degrading guest performance.

Even if the internal threshold isn't architecturally constrained, it would be very,
very helpful if Intel could publish the per-uarch/stepping thresholds, e.g. to give
us a ballpark idea of how agressive KVM can be before it risks false positives.

> +module_param(notify_window, int, 0644);

I really like the idea of making the module param writable, but doing so will
require far more effort.  At an absolute minimum, the module param would need to
be snapshotted at VM creation time, a la lapic_timer_advance_ns, otherwise the
behavior is non-deterministic.

But I don't think snapshotting is a worthwhile approach because the main reason
for adjusting the window while guests are running is probably going to be to relax
the window because guest's are observing degraded performance.  Hopefully that
never happens, but the "CPU adds a magic internal buffer" behavior makes me more
than a bit nervous.

And on the other hand, adding a ton of logic to forcefully update every VMCS is
likely overkill.

So, that takes us back to providing a sane, somewhat conservative default.  I've
said in the past that ideally the notify_window would be as small as possible,
but pushing it down to single digit cycles swings the pendulum too far in the
other direction.

> +
>  static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
>  static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
>  static DEFINE_MUTEX(vmx_l1d_flush_mutex);
> @@ -2539,7 +2543,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  			SECONDARY_EXEC_PT_USE_GPA |
>  			SECONDARY_EXEC_PT_CONCEAL_VMX |
>  			SECONDARY_EXEC_ENABLE_VMFUNC |
> -			SECONDARY_EXEC_BUS_LOCK_DETECTION;
> +			SECONDARY_EXEC_BUS_LOCK_DETECTION |
> +			SECONDARY_EXEC_NOTIFY_VM_EXITING;
>  		if (cpu_has_sgx())
>  			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
>  		if (adjust_vmx_controls(min2, opt2,
> @@ -4376,6 +4381,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
>  		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
>  
> +	if (cpu_has_notify_vm_exiting() && notify_window < 0)
> +		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
> +
>  	vmx->secondary_exec_control = exec_control;
>  }
>  
> @@ -4423,6 +4431,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		vmx->ple_window_dirty = true;
>  	}
>  
> +	if (cpu_has_notify_vm_exiting() && notify_window >= 0)
> +		vmcs_write32(NOTIFY_WINDOW, notify_window);

I'm all for punting full nested support to a future patch, but _this_ patch
absolutely needs to apply KVM's notify_window to vmcs02, otherwise L1 can simply
run in L2 to avoid the restriction.  init_vmcs() is used only for vmcs01, i.e.
prepare_vmcs02_constant_state() needs to set the correct vmcs.NOTIFY_WINDOW,
and prepare_vmcs02_early() needs to set/clear SECONDARY_EXEC_NOTIFY_VM_EXITING
appropriately.

> +
>  	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
>  	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
>  	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
> @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int handle_notify(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
> +
> +	if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {

What does CONTEXT_INVALID mean?  The ISE doesn't provide any information whatsoever.

> +		/*
> +		 * Notify VM exit happened while executing iret from NMI,
> +		 * "blocked by NMI" bit has to be set before next VM entry.
> +		 */
> +		if (enable_vnmi &&
> +		    (exit_qual & INTR_INFO_UNBLOCK_NMI))
> +			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
> +				      GUEST_INTR_STATE_NMI);

Hmm, logging of some kind is probably a good idea if this exit occurs, e.g. so
that the host can (a) get an indication that a guest is potentially malicious and
(b) rule out (or confirm) notify_window exits as the source of degraded guest
performance.

Maybe add a per-vCPU stat, "u64 notify_window_exits"?

Another thought would be to also do pr_info/warn_ratelimited if a vCPU gets
multiple notify_window exits and doesn't appear to be making forward progress,
e.g. same RIP observed two notify_window exits in a row.  Even if the guest is
making forward progress, displaying the guest RIP and instruction (if possible)
could be useful in triaging why the guest appears to be getting false positives.

> +		return 1;
> +	}
> +
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_NO_EVENT_WINDOW;
> +	vcpu->run->internal.ndata = 1;
> +	vcpu->run->internal.data[0] = exit_qual;

Unless an invalid context can _never_ happen, or is already fatal to the guest,
I don't think effectively killing the guest is a good idea.  KVM doesn't know
for certain that the guest was being malicious, all it knows is that the CPU
didn't open an event window for some arbitrary amount of time (arbitrary because
the internal threshold is likely to be uarch specific).  KVM is getting exits,
which means it's getting a chance to check for signals, etc..., so resuming the
guest is ok.

> +
> +	return 0;
> +}
> +
>  /*
>   * The exit handlers return 1 if the exit was handled fully and guest execution
>   * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> @@ -5699,6 +5735,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>  	[EXIT_REASON_ENCLS]		      = handle_encls,
>  	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
> +	[EXIT_REASON_NOTIFY]		      = handle_notify,
>  };
>  
