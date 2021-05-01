Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A974D37074E
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 15:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhEANGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 May 2021 09:06:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232127AbhEANGi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 May 2021 09:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619874347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QaLGggxWsR4nhRyo4uKvEE71cIOf16ehgKiX+853OaA=;
        b=Ehs/5Ck1OGcTtfpT9S0HSWI0COUB4C6nOrkhnG8ZbEgYFdir6UfWFT7WUG7hdC+KnELa/B
        3BYVryfkPyZlumXnV9xBe+Db0AXyCEiktBYg3TBN/UxTXsR980mAgz1v/PMaWw6YjaaQ1d
        LLA+2JQJPGXhkNBYkFLpKUMpHmFCDVQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-bHwVbHjbOXSUcVBoiMtsPg-1; Sat, 01 May 2021 09:05:46 -0400
X-MC-Unique: bHwVbHjbOXSUcVBoiMtsPg-1
Received: by mail-ej1-f70.google.com with SMTP id d16-20020a1709066410b0290373cd3ce7e6so100564ejm.14
        for <kvm@vger.kernel.org>; Sat, 01 May 2021 06:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QaLGggxWsR4nhRyo4uKvEE71cIOf16ehgKiX+853OaA=;
        b=AQPXD8DPz3vX2Y8NQUqigWkBRFYwNCaqhCt/iySMMkT7vGQWq6WczmZ5NQpQdAm6+l
         ztcr+KWLOLG76o4Hn0+6ES3GXipe+/clAMOUp3aKDEwjOZP1jfV5fTD54JNdcW3l3kbI
         1PhegJ/6Ql45+BGb4EpI5w5VaCMW6IEt6TNj+IKeApmbcIlMkapW+aQ9fAwkF4Dh9Tf+
         xMPYMRTJv6K7mC4MUKJ3eTIbEsGsOJUyhnAnGuwFgtq16vab3kSTi+7F716om9oRf9Eq
         0Z/iE/x6d5BT8eUOp1xnuBD7ExveT40yguiqY8sOP1NJVGPMmnFgOjaJqR1ZZFQ4CS82
         qgfg==
X-Gm-Message-State: AOAM531iBmS6Ga6IqbNLYGwDeccgLCv4LEli64qx9XOYQc0tEU7pe9K2
        iHHmnL3bPkXMWhh5J9z+wAfE1tlJBxsWFYSikYrBLST6iAW4Nc+MWM/BMiCBJYIiQQ/2/mvSlOm
        Ucz5YCX+G+Beg
X-Received: by 2002:aa7:c4d0:: with SMTP id p16mr11660634edr.102.1619874345017;
        Sat, 01 May 2021 06:05:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfPBoD0Tz5aS6Kb7+tMFf+gd+mveeXHCH2rRPVw30Y5rlCQwGj5gNS6DyfYYpOXxlizqCTAQ==
X-Received: by 2002:aa7:c4d0:: with SMTP id p16mr11660597edr.102.1619874344783;
        Sat, 01 May 2021 06:05:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id s20sm5617392edu.93.2021.05.01.06.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 May 2021 06:05:44 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: move srcu lock out of kvm_vcpu_check_block
To:     Sean Christopherson <seanjc@google.com>,
        Jon Kohler <jon@nutanix.com>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210428173820.13051-1-jon@nutanix.com>
 <YIxsV6VgSDEdngKA@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9040b3d8-f83f-beb5-a703-42202d78fabb@redhat.com>
Date:   Sat, 1 May 2021 15:05:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YIxsV6VgSDEdngKA@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/21 22:45, Sean Christopherson wrote:
> On Wed, Apr 28, 2021, Jon Kohler wrote:
>> To improve performance, this moves kvm->srcu lock logic from
>> kvm_vcpu_check_block to kvm_vcpu_running and wraps directly around
>> check_events. Also adds a hint for callers to tell
>> kvm_vcpu_running whether or not to acquire srcu, which is useful in
>> situations where the lock may already be held. With this in place, we
>> see roughly 5% improvement in an internal benchmark [3] and no more
>> impact from this lock on non-nested workloads.
> 
> ...
> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index efc7a82ab140..354f690cc982 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9273,10 +9273,24 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>>   	return 1;
>>   }
>>
>> -static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>> +static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu, bool acquire_srcu)
>>   {
>> -	if (is_guest_mode(vcpu))
>> -		kvm_x86_ops.nested_ops->check_events(vcpu);
>> +	if (is_guest_mode(vcpu)) {
>> +		if (acquire_srcu) {
>> +			/*
>> +			 * We need to lock because check_events could call
>> +			 * nested_vmx_vmexit() which might need to resolve a
>> +			 * valid memslot. We will have this lock only when
>> +			 * called from vcpu_run but not when called from
>> +			 * kvm_vcpu_check_block > kvm_arch_vcpu_runnable.
>> +			 */
>> +			int idx = srcu_read_lock(&vcpu->kvm->srcu);
>> +			kvm_x86_ops.nested_ops->check_events(vcpu);
>> +			srcu_read_unlock(&vcpu->kvm->srcu, idx);
>> +		} else {
>> +			kvm_x86_ops.nested_ops->check_events(vcpu);
>> +		}
>> +	}
> 
> Obviously not your fault, but I absolutely detest calling check_events() from
> kvm_vcpu_running.  I would much prefer to make baby steps toward cleaning up the
> existing mess instead of piling more weirdness on top.
> 
> Ideally, APICv support would be fixed to not require a deep probe into nested
> events just to see if a vCPU can run.  But, that's probably more than we want to
> bite off at this time.
> 
> What if we add another nested_ops API to check if the vCPU has an event, but not
> actually process the event?  I think that would allow eliminating the SRCU lock,
> and would get rid of the most egregious behavior of triggering a nested VM-Exit
> in a seemingly innocuous helper.
> 
> If this works, we could even explore moving the call to nested_ops->has_events()
> out of kvm_vcpu_running() and into kvm_vcpu_has_events(); I can't tell if the
> side effects in vcpu_block() would get messed up with that change :-/
> 
> Incomplete patch...

I think it doesn't even have to be *nested* events.  Most events are the 
same inside or outside guest mode, as they already special case guest 
mode inside the kvm_x86_ops callbacks (e.g. kvm_arch_interrupt_allowed 
is already called by kvm_vcpu_has_events).

I think we only need to extend kvm_x86_ops.nested_ops->hv_timer_pending 
to cover MTF, plus double check that INIT and SIPI are handled 
correctly, and then the call to check_nested_events can go away.

Paolo

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 00339d624c92..15f514891326 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3771,15 +3771,17 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
>                 to_vmx(vcpu)->nested.preemption_timer_expired;
>   }
> 
> -static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> +static int __vmx_check_nested_events(struct kvm_vcpu *vcpu, bool only_check)
>   {
>          struct vcpu_vmx *vmx = to_vmx(vcpu);
>          unsigned long exit_qual;
> -       bool block_nested_events =
> -           vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
>          bool mtf_pending = vmx->nested.mtf_pending;
>          struct kvm_lapic *apic = vcpu->arch.apic;
> 
> +       bool block_nested_events = only_check ||
> +                                  vmx->nested.nested_run_pending ||
> +                                  kvm_event_needs_reinjection(vcpu);
> +
>          /*
>           * Clear the MTF state. If a higher priority VM-exit is delivered first,
>           * this state is discarded.
> @@ -3837,7 +3839,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>          }
> 
>          if (vcpu->arch.exception.pending) {
> -               if (vmx->nested.nested_run_pending)
> +               if (vmx->nested.nested_run_pending || only_check)
>                          return -EBUSY;
>                  if (!nested_vmx_check_exception(vcpu, &exit_qual))
>                          goto no_vmexit;
> @@ -3886,10 +3888,23 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>          }
> 
>   no_vmexit:
> -       vmx_complete_nested_posted_interrupt(vcpu);
> +       if (!check_only)
> +               vmx_complete_nested_posted_interrupt(vcpu);
> +       else if (vmx->nested.pi_desc && vmx->nested.pi_pending)
> +               return -EBUSY;
>          return 0;
>   }
> 
> +static bool vmx_has_nested_event(struct kvm_vcpu *vcpu)
> +{
> +       return !!__vmx_check_nested_events(vcpu, true);
> +}
> +
> +static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> +{
> +       return __vmx_check_nested_events(vcpu, false);
> +}
> +
>   static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
>   {
>          ktime_t remaining =
> @@ -6627,6 +6642,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
>   }
> 
>   struct kvm_x86_nested_ops vmx_nested_ops = {
> +       .has_event = vmx_has_nested_event,
>          .check_events = vmx_check_nested_events,
>          .hv_timer_pending = nested_vmx_preemption_timer_pending,
>          .triple_fault = nested_vmx_triple_fault,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a829f1ab60c3..5df01012cb1f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9310,6 +9310,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                          update_cr8_intercept(vcpu);
>                          kvm_lapic_sync_to_vapic(vcpu);
>                  }
> +       } else if (is_guest_mode(vcpu)) {
> +               r = kvm_check_nested_events(vcpu);
> +               if (r < 0)
> +                       req_immediate_exit = true;
>          }
> 
>          r = kvm_mmu_reload(vcpu);
> @@ -9516,8 +9520,10 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
> 
>   static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>   {
> -       if (is_guest_mode(vcpu))
> -               kvm_check_nested_events(vcpu);
> +       if (is_guest_mode(vcpu) &&
> +           (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu) ||
> +            kvm_x86_ops.nested_ops->has_event(vcpu)))
> +               return true;
> 
>          return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>                  !vcpu->arch.apf.halted);
> 

