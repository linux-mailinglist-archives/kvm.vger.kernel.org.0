Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13021DC554
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 04:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgEUCoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 22:44:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:9554 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgEUCoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 22:44:03 -0400
IronPort-SDR: 77tqvV7Tyk+cjJ1w3QY2PjftDZY+r7BktqBclD5MPeBgGl0zY9pt6ZUvVIWJBhQ9sFTx7Vc0bJ
 E8P2aeD9eeQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 19:44:02 -0700
IronPort-SDR: bxbp/Ap5ZDLl2yEMLzXUslyWQr/FsIcC+c5Usj05UAr8VKq8/AWL68TWIahN4C9sNRiwu7K3G/
 QQye2gJ9KqUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,416,1583222400"; 
   d="scan'208";a="440275229"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 20 May 2020 19:44:01 -0700
Date:   Wed, 20 May 2020 19:44:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Subject: Re: [PATCH  1/2 v3] KVM: nVMX: Fix VMX preemption timer migration
Message-ID: <20200521024401.GK18102@linux.intel.com>
References: <20200520232228.55084-1-makarandsonare@google.com>
 <20200520232228.55084-2-makarandsonare@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520232228.55084-2-makarandsonare@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 04:22:27PM -0700, Makarand Sonare wrote:
> From: Peter Shier <pshier@google.com>
> 
> Add new field to hold preemption timer expiration deadline
> appended to struct kvm_vmx_nested_state_hdr. This is to prevent
> the first VM-Enter after migration from incorrectly restarting the timer
> with the full timer value instead of partially decayed timer value.
> KVM_SET_NESTED_STATE restarts timer using migrated state regardless
> of whether L1 sets VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.
> 
> Fixes: cf8b84f48a593 ("kvm: nVMX: Prepare for checkpointing L2 state")
> 
> Signed-off-by: Peter Shier <pshier@google.com>
> Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> Change-Id: I6446aba5a547afa667f0ef4620b1b76115bf3753
> ---

...

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 51ebb60e1533a..46dc2ef731b37 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2092,9 +2092,9 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
>  	return HRTIMER_NORESTART;
>  }
> 
> -static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
> +static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
> +					u64 preemption_timeout)
>  {
> -	u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> 
>  	/*
> @@ -3353,8 +3353,21 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	 * the timer.
>  	 */
>  	vmx->nested.preemption_timer_expired = false;
> -	if (nested_cpu_has_preemption_timer(vmcs12))
> -		vmx_start_preemption_timer(vcpu);
> +	if (nested_cpu_has_preemption_timer(vmcs12)) {
> +		u64 timer_value = 0;

Personal preference would be to zero this in an else case.  More to make it
obvious there isn't an uninitialized access than to shave cycles.  Or get
rid of timer_value altogether (see below).

> +		u64 l1_scaled_tsc_value = (kvm_read_l1_tsc(vcpu, rdtsc())

Dropping the "_value" can help avoid some wraps, i.e. use l1_scaled_tsc.

> +					   >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE);

Parantheses around the entire expression are unnecessary.  And I strongly
prefer the operator on the previous line, not sure how others feel.

> +
> +		if (!vmx->nested.has_preemption_timer_deadline) {
> +			timer_value = vmcs12->vmx_preemption_timer_value;
> +			vmx->nested.preemption_timer_deadline = timer_value +
> +								l1_scaled_tsc_value;
> +			vmx->nested.has_preemption_timer_deadline = true;
> +		} else if (l1_scaled_tsc_value <= vmx->nested.preemption_timer_deadline)

Not that it matters, but this can be '<'.

> +			timer_value = vmx->nested.preemption_timer_deadline -
> +				      l1_scaled_tsc_value;
> +		vmx_start_preemption_timer(vcpu, timer_value);

Any objection to moving this to a separate helper?  It'd reduce the indentation
enough that, if combined with shorter names, would eliminate the line wraps and
yield a nice diff to boot.  E.g. something like:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6a4f06c2e741..d204aa0910c2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2093,9 +2093,9 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
        return HRTIMER_NORESTART;
 }

-static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
+static void __vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
+                                        u64 preemption_timeout)
 {
-       u64 preemption_timeout = get_vmcs12(vcpu)->vmx_preemption_timer_value;
        struct vcpu_vmx *vmx = to_vmx(vcpu);

        /*
@@ -2117,6 +2117,27 @@ static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
                      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL);
 }

+static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
+                                      struct vmcs12 *vmcs12)
+{
+       struct vcpu_vmx *vmx = to_vmx(vcpu);
+       u64 l1_scaled_tsc = kvm_read_l1_tsc(vcpu, rdtsc()) >>
+                               VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE;
+       u64 val;
+
+       if (!vmx->nested.has_preemption_timer_deadline) {
+               val = vmcs12->vmx_preemption_timer_value;
+               vmx->nested.has_preemption_timer_deadline = true;
+               vmx->nested.preemption_timer_deadline = val + l1_scaled_tsc;
+       } else if (vmx->nested.preemption_timer_deadline > l1_scaled_tsc) {
+               val = vmx->nested.preemption_timer_deadline - l1_scaled_tsc;
+       } else {
+               val = 0;
+       }
+       __vmx_start_preemption_timer(vcpu, val);
+}
+
+
 static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
        if (vmx->nested.nested_run_pending &&
@@ -3358,7 +3379,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
         */
        vmx->nested.preemption_timer_expired = false;
        if (nested_cpu_has_preemption_timer(vmcs12))
-               vmx_start_preemption_timer(vcpu);
+               vmx_start_preemption_timer(vcpu, vmcs12);

        /*
         * Note no nested_vmx_succeed or nested_vmx_fail here. At this point

> +	}
> 
>  	/*
>  	 * Note no nested_vmx_succeed or nested_vmx_fail here. At this point
> @@ -3462,6 +3475,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	 * the nested entry.
>  	 */
>  	vmx->nested.nested_run_pending = 1;
> +	vmx->nested.has_preemption_timer_deadline = false;
>  	status = nested_vmx_enter_non_root_mode(vcpu, true);
>  	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
>  		goto vmentry_failed;
> @@ -3962,9 +3976,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
> 
>  	if (nested_cpu_has_preemption_timer(vmcs12) &&
> -	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> +	    !vmx->nested.nested_run_pending) {
> +		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)

The extra if statement is unnecessary, which in turn makes the curly braces
unnecessary.

>  			vmcs12->vmx_preemption_timer_value =
>  				vmx_get_preemption_timer_value(vcpu);
> +	}
> 
>  	/*
>  	 * In some cases (usually, nested EPT), L2 is allowed to change its
> @@ -5898,6 +5914,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  		.size = sizeof(kvm_state),
>  		.hdr.vmx.vmxon_pa = -1ull,
>  		.hdr.vmx.vmcs12_pa = -1ull,
> +		.hdr.vmx.preemption_timer_deadline = 0,
>  	};
>  	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
>  		&user_kvm_nested_state->data.vmx[0];
