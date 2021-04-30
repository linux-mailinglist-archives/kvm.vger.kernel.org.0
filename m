Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A423370259
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 22:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhD3UqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 16:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbhD3UqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 16:46:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC6FC06138B
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 13:45:16 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p17so9169052pjz.3
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 13:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XV1S7QX7pqISwKM1jB1GYc13VlD7bLx7ViM4ltZNWvc=;
        b=kC7w1khTWN2G6MhIIRpBpH5C+waiMNYFwiSwBeCh3wxC25KAB+f8yT9YhWesbnJfs4
         zMWJhDMZIYbi2lK09czlbTIiFHH1bBA/Za0YMgIVwnYV/NRmKubuM7y9YZIYe+LoIPaN
         1fSifRORlDvCpL6MQQ9wNYvPLouiXkf7BDlAdnuCXR7/RHqB0D8KFHnppO3+Pvkt1Rav
         3h7H7ghykzjdaDgp5Bt4WbJX5T320llMrzlGRW0N6paUrM9UX80KsAWbAN3DI4qRv7KI
         mzh7sgPJGGy3qEtXi9GT2lZNuR3qN6ZhzrPtzGWJZm4pBpI6Axve4JYeZSzNSkogkbJM
         zbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XV1S7QX7pqISwKM1jB1GYc13VlD7bLx7ViM4ltZNWvc=;
        b=uZpvwfPMwnJ0sUHt0nZeU2+EiT52eNCffGMSrpIH3KuOsoKSvTEDGfxDETWxCkjrAP
         aQtBbhdLErf6rFeAkWplLct7IHvr5adQE+XpDMUt64zf+iV9+tA8kBw3dnrqRbtimUV6
         Np75/x4lJDSH89XJ+SLG+/J2IcKVxfuinEGKispEWlZBxfnn/Q2PZlO88JAWqhx7cjYG
         3rC2mJd88reQJU+qC6uw+tXO0f3VaINLCjV6pUF5nacDOaAep4QIKChJnwW7dCYbuvCf
         Sa253IcdfBWp4OudSw/y9rrsO03ukla2Zen9Ve0VfJEWnV3jQJtmDH5b9NL74FgCl0JM
         AVzw==
X-Gm-Message-State: AOAM5318MKwnPrEMJZTxGQ/u7n7wkglsAP3BRrDZ1afnD1pRZPJNDKCV
        NFroDmd84KptasjBt+avG29fLQ==
X-Google-Smtp-Source: ABdhPJwKn4YKXVr0RI440tpiiDhbuArtF+So3buArcfhCZhkihl8gczHEyvSsmApSw3Ba6k57GnaCw==
X-Received: by 2002:a17:90a:dd45:: with SMTP id u5mr17554026pjv.15.1619815515285;
        Fri, 30 Apr 2021 13:45:15 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w124sm2962195pfb.73.2021.04.30.13.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 13:45:14 -0700 (PDT)
Date:   Fri, 30 Apr 2021 20:45:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: move srcu lock out of kvm_vcpu_check_block
Message-ID: <YIxsV6VgSDEdngKA@google.com>
References: <20210428173820.13051-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428173820.13051-1-jon@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021, Jon Kohler wrote:
> To improve performance, this moves kvm->srcu lock logic from
> kvm_vcpu_check_block to kvm_vcpu_running and wraps directly around
> check_events. Also adds a hint for callers to tell
> kvm_vcpu_running whether or not to acquire srcu, which is useful in
> situations where the lock may already be held. With this in place, we
> see roughly 5% improvement in an internal benchmark [3] and no more
> impact from this lock on non-nested workloads.

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index efc7a82ab140..354f690cc982 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9273,10 +9273,24 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  	return 1;
>  }
> 
> -static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
> +static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu, bool acquire_srcu)
>  {
> -	if (is_guest_mode(vcpu))
> -		kvm_x86_ops.nested_ops->check_events(vcpu);
> +	if (is_guest_mode(vcpu)) {
> +		if (acquire_srcu) {
> +			/*
> +			 * We need to lock because check_events could call
> +			 * nested_vmx_vmexit() which might need to resolve a
> +			 * valid memslot. We will have this lock only when
> +			 * called from vcpu_run but not when called from
> +			 * kvm_vcpu_check_block > kvm_arch_vcpu_runnable.
> +			 */
> +			int idx = srcu_read_lock(&vcpu->kvm->srcu);
> +			kvm_x86_ops.nested_ops->check_events(vcpu);
> +			srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +		} else {
> +			kvm_x86_ops.nested_ops->check_events(vcpu);
> +		}
> +	}

Obviously not your fault, but I absolutely detest calling check_events() from
kvm_vcpu_running.  I would much prefer to make baby steps toward cleaning up the
existing mess instead of piling more weirdness on top.

Ideally, APICv support would be fixed to not require a deep probe into nested
events just to see if a vCPU can run.  But, that's probably more than we want to
bite off at this time.

What if we add another nested_ops API to check if the vCPU has an event, but not
actually process the event?  I think that would allow eliminating the SRCU lock,
and would get rid of the most egregious behavior of triggering a nested VM-Exit
in a seemingly innocuous helper.

If this works, we could even explore moving the call to nested_ops->has_events()
out of kvm_vcpu_running() and into kvm_vcpu_has_events(); I can't tell if the
side effects in vcpu_block() would get messed up with that change :-/

Incomplete patch...

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 00339d624c92..15f514891326 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3771,15 +3771,17 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
               to_vmx(vcpu)->nested.preemption_timer_expired;
 }

-static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
+static int __vmx_check_nested_events(struct kvm_vcpu *vcpu, bool only_check)
 {
        struct vcpu_vmx *vmx = to_vmx(vcpu);
        unsigned long exit_qual;
-       bool block_nested_events =
-           vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
        bool mtf_pending = vmx->nested.mtf_pending;
        struct kvm_lapic *apic = vcpu->arch.apic;

+       bool block_nested_events = only_check ||
+                                  vmx->nested.nested_run_pending ||
+                                  kvm_event_needs_reinjection(vcpu);
+
        /*
         * Clear the MTF state. If a higher priority VM-exit is delivered first,
         * this state is discarded.
@@ -3837,7 +3839,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
        }

        if (vcpu->arch.exception.pending) {
-               if (vmx->nested.nested_run_pending)
+               if (vmx->nested.nested_run_pending || only_check)
                        return -EBUSY;
                if (!nested_vmx_check_exception(vcpu, &exit_qual))
                        goto no_vmexit;
@@ -3886,10 +3888,23 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
        }

 no_vmexit:
-       vmx_complete_nested_posted_interrupt(vcpu);
+       if (!check_only)
+               vmx_complete_nested_posted_interrupt(vcpu);
+       else if (vmx->nested.pi_desc && vmx->nested.pi_pending)
+               return -EBUSY;
        return 0;
 }

+static bool vmx_has_nested_event(struct kvm_vcpu *vcpu)
+{
+       return !!__vmx_check_nested_events(vcpu, true);
+}
+
+static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
+{
+       return __vmx_check_nested_events(vcpu, false);
+}
+
 static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
 {
        ktime_t remaining =
@@ -6627,6 +6642,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 }

 struct kvm_x86_nested_ops vmx_nested_ops = {
+       .has_event = vmx_has_nested_event,
        .check_events = vmx_check_nested_events,
        .hv_timer_pending = nested_vmx_preemption_timer_pending,
        .triple_fault = nested_vmx_triple_fault,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a829f1ab60c3..5df01012cb1f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9310,6 +9310,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
                        update_cr8_intercept(vcpu);
                        kvm_lapic_sync_to_vapic(vcpu);
                }
+       } else if (is_guest_mode(vcpu)) {
+               r = kvm_check_nested_events(vcpu);
+               if (r < 0)
+                       req_immediate_exit = true;
        }

        r = kvm_mmu_reload(vcpu);
@@ -9516,8 +9520,10 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)

 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
-       if (is_guest_mode(vcpu))
-               kvm_check_nested_events(vcpu);
+       if (is_guest_mode(vcpu) &&
+           (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu) ||
+            kvm_x86_ops.nested_ops->has_event(vcpu)))
+               return true;

        return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
                !vcpu->arch.apf.halted);
