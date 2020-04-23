Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3651B5F52
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgDWPeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:34:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:46415 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgDWPeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:34:00 -0400
IronPort-SDR: dKh7CQqMNjMGcfO63Bo8XcLoHT+OW33oBmOsnRIjQANrEoW6aBWT/vax5V0M1C7rqbPmMxZsao
 S0Jlej4Xi2VQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 08:34:00 -0700
IronPort-SDR: QPa9RMw44FKNdJCF7lLC8+GCW7/D3GO5FLlqP3Etq5GvdM3PTDKoFija4mu6vAi7eJNxHj0bi6
 vSBXMipjM+Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="430364213"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Apr 2020 08:33:59 -0700
Date:   Thu, 23 Apr 2020 08:33:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Subject: Re: [kvm PATCH] KVM: nVMX - enable VMX preemption timer migration
Message-ID: <20200423153359.GB17824@linux.intel.com>
References: <20200422205030.84476-1-makarandsonare@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422205030.84476-1-makarandsonare@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few comments on the shortlog:

  - Use [PATCH] instead of [kvm PATCH], the "kvm" part is redundant with
    the subsystem scope.  I almost skipped over this patch because my eyes
    have been trained to treat [kvm... PATCH] as patches for kvm-unit-tests.

  - Use a colon instead of a dash after nVMX.

  - The patch should be tagged v2.  Again, I almost glossed over this
    because I thought it was a resend of v1.

  - I wouldn't phrase this as enabling, e.g. nothing prevented migrating
    the preemption timer before this patch, it just wasn't migrated
    correctly.

E.g.

  [PATCH v2] KVM: nVMX: Fix VMX preemption timer migration


On Wed, Apr 22, 2020 at 01:50:30PM -0700, Makarand Sonare wrote:
> From: Peter Shier <pshier@google.com>
> 
> Add new field to hold preemption timer remaining until expiration
> appended to struct kvm_vmx_nested_state_data. This is to prevent
> the second (and later) VM-Enter after migration from restarting the timer

This isn't correct.  The bug being fixed is that the _first_ VM-Enter after
migration would use the incorrect value, i.e. full value instead of
partially decayed timer.  My comment in v1 was that the changelog should
document why it adds a new field to fix the bug as opposed to simply
snapshotting the decayed timer.

> with wrong value. KVM_SET_NESTED_STATE restarts timer using migrated
> state regardless of whether L1 sets VM_EXIT_SAVE_VMX_PREEMPTION_TIMER.

Any plans to enhance the vmx_set_nested_state_test.c to verify this works
as intended?

> struct kvm_vmx_nested_state_hdr {
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cbc9ea2de28f9..a5207df73f015 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2014,15 +2014,16 @@ static enum hrtimer_restart vmx_preemption_timer_fn(struct hrtimer *timer)
>  		container_of(timer, struct vcpu_vmx, nested.preemption_timer);
>  
>  	vmx->nested.preemption_timer_expired = true;
> +	vmx->nested.preemption_timer_remaining = 0;

Won't this get overwritten by sync_vmcs02_to_vmcs12()?  Unless there is a
corner cases I'm missing, I think it'd be better to omit this so that it's
clear that sync_vmcs02_to_vmcs12() is responsible for snapshotting the
remaining time.

>  	kvm_make_request(KVM_REQ_EVENT, &vmx->vcpu);
>  	kvm_vcpu_kick(&vmx->vcpu);
>  
>  	return HRTIMER_NORESTART;
>  }

...

> @@ -5790,6 +5809,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) < VMCS12_SIZE);
> +	BUILD_BUG_ON(sizeof(user_vmx_nested_state->preemption_timer_remaining)
> +		    != sizeof(vmx->nested.preemption_timer_remaining));
> +
>  
>  	/*
>  	 * Copy over the full allocated size of vmcs12 rather than just the size
> @@ -5805,6 +5827,13 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  			return -EFAULT;
>  	}
>  
> +	if (kvm_state.flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +		if (copy_to_user(&user_vmx_nested_state->preemption_timer_remaining,
> +				 &vmx->nested.preemption_timer_remaining,
> +				 sizeof(vmx->nested.preemption_timer_remaining)))a

Build tested only, but {get,put}_user() compiles just fine, as requested.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a2cd413f2901..b2ec62a24f0c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5970,9 +5970,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,

        BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
        BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) < VMCS12_SIZE);
-       BUILD_BUG_ON(sizeof(user_vmx_nested_state->preemption_timer_remaining)
-                   != sizeof(vmx->nested.preemption_timer_remaining));
-

        /*
         * Copy over the full allocated size of vmcs12 rather than just the size
@@ -5989,9 +5986,8 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
        }

        if (kvm_state.flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
-               if (copy_to_user(&user_vmx_nested_state->preemption_timer_remaining,
-                                &vmx->nested.preemption_timer_remaining,
-                                sizeof(vmx->nested.preemption_timer_remaining)))
+               if (put_user(vmx->nested.preemption_timer_remaining,
+                            &user_vmx_nested_state->preemption_timer_remaining))
                        return -EFAULT;
        }

@@ -6164,9 +6160,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
                    offsetofend(struct  kvm_vmx_nested_state_data, preemption_timer_remaining))
                        goto error_guest_mode;

-               if (copy_from_user(&vmx->nested.preemption_timer_remaining,
-                                  &user_vmx_nested_state->preemption_timer_remaining,
-                                  sizeof(user_vmx_nested_state->preemption_timer_remaining))) {
+               if (get_user(vmx->nested.preemption_timer_remaining,
+                            &user_vmx_nested_state->preemption_timer_remaining)) {
                        ret = -EFAULT;
                        goto error_guest_mode;
                }

> +			return -EFAULT;
> +	}
> +
>  out:
>  	return kvm_state.size;
>  }
> @@ -5876,7 +5905,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	 */
>  	if (is_smm(vcpu) ?
>  		(kvm_state->flags &
> -		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
> +		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING |
> +		  KVM_STATE_NESTED_PREEMPTION_TIMER))
>  		: kvm_state->hdr.vmx.smm.flags)
>  		return -EINVAL;
>  
> @@ -5966,6 +5996,21 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  			goto error_guest_mode;
>  	}
>  
> +	if (kvm_state->flags & KVM_STATE_NESTED_PREEMPTION_TIMER) {
> +
> +		if (kvm_state->size <
> +		    offsetof(struct  kvm_nested_state, hdr.vmx) +
> +		    offsetofend(struct  kvm_vmx_nested_state_data, preemption_timer_remaining))

Too many spaces after 'struct'.

> +			goto error_guest_mode;
> +
> +		if (copy_from_user(&vmx->nested.preemption_timer_remaining,
> +				   &user_vmx_nested_state->preemption_timer_remaining,
> +				   sizeof(user_vmx_nested_state->preemption_timer_remaining))) {
> +			ret = -EFAULT;
> +			goto error_guest_mode;
> +		}
> +	}
> +
