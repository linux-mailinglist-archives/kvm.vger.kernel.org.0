Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B50B3736E6
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 11:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhEEJTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 05:19:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231963AbhEEJS7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 05:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620206283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xF+fA5fxNVPdjny4gNEBrvfwyuZJATrYMPX8JPTS77I=;
        b=Z9HLk/Ht6d5m+mDxLqBJUGKPtocP5XfFluC2YrhbkNBUSsFEszmdvnjbL/oIRwx+VTLSJl
        LKO0ShKuzUbcrxtFduQkcR8VgfezPMmbJNq/bU6JOkmsg4/5Bq+SdtpYDehpteZFgB7ufO
        pmxOfRf+2fHIrvHuyP/ctNvmUdyDlMo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-SQwF9aoaOu-T3Mixo2KpGA-1; Wed, 05 May 2021 05:18:01 -0400
X-MC-Unique: SQwF9aoaOu-T3Mixo2KpGA-1
Received: by mail-ed1-f72.google.com with SMTP id d6-20020a0564020786b0290387927a37e2so542648edy.10
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 02:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xF+fA5fxNVPdjny4gNEBrvfwyuZJATrYMPX8JPTS77I=;
        b=fpgu+MfmJfsePuAlu/eUywlt3GuvIuES+3Iw8vlGZkwFwfcoLljVpMYZye9EMMXlP0
         1r3tp5bbBL9xx9P/gmZ3s8QWekibVOFZZtAsUSxyPUah7tRRzp6zzmrOKaEvn6yj3nBB
         yIQylDZSilAtdbMv1QqS6RL5ZQ8tMiuwlMNXO5mZLMCCCs6aOb2VgLF7QFWIhzXvSPOm
         Vz7rvNnxHL6X1Xi6McwR5wfNkglp+BzqDN+UaaUC+OMRxWyKcIV7SiYpztCtlijCENym
         PRsAGlsEcCU2s2foZTjXfMImlZ7FPetV7qa7PbbD3VEOGqUYXbDIvRaFHU4bkyAzl6qJ
         t+Sg==
X-Gm-Message-State: AOAM533erx4Pl88hk5PigAEjYGmkXwEdizXMMNF0tm5ci5kxfeoAvwv1
        pVZkXeLWoKwtu4e1xoy+hFkCrGZ2RTQZnEd3hY0IUQCbRMtZMdPJRvzSY77vtjxua9La7c9xiU5
        dGlEtliUnunjf
X-Received: by 2002:a17:906:9381:: with SMTP id l1mr25971270ejx.45.1620206280025;
        Wed, 05 May 2021 02:18:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIbSzLE1jwgCeK5h7xTLIO7kVWLVEGWtnOfkc5d859aMGuImanJP3vz9UGj4yqgLY6xYrnQw==
X-Received: by 2002:a17:906:9381:: with SMTP id l1mr25971247ejx.45.1620206279749;
        Wed, 05 May 2021 02:17:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x9sm15732424edv.22.2021.05.05.02.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 02:17:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4/4] KVM: nVMX: Map enlightened VMCS upon restore when
 possible
In-Reply-To: <fa744382453d7a196812e88fe9ae9e842c903e13.camel@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
 <20210503150854.1144255-5-vkuznets@redhat.com>
 <fa744382453d7a196812e88fe9ae9e842c903e13.camel@redhat.com>
Date:   Wed, 05 May 2021 11:17:58 +0200
Message-ID: <877dkdy1x5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Mon, 2021-05-03 at 17:08 +0200, Vitaly Kuznetsov wrote:
>> It now looks like a bad idea to not restore eVMCS mapping directly from
>> vmx_set_nested_state(). The restoration path now depends on whether KVM
>> will continue executing L2 (vmx_get_nested_state_pages()) or will have to
>> exit to L1 (nested_vmx_vmexit()), this complicates error propagation and
>> diverges too much from the 'native' path when 'nested.current_vmptr' is
>> set directly from vmx_get_nested_state_pages().
>> 
>> The existing solution postponing eVMCS mapping also seems to be fragile.
>> In multiple places the code checks whether 'vmx->nested.hv_evmcs' is not
>> NULL to distinguish between eVMCS and non-eVMCS cases. All these checks
>> are 'incomplete' as we have a weird 'eVMCS is in use but not yet mapped'
>> state.
>> 
>> Also, in case vmx_get_nested_state() is called right after
>> vmx_set_nested_state() without executing the guest first, the resulting
>> state is going to be incorrect as 'KVM_STATE_NESTED_EVMCS' flag will be
>> missing.
>> 
>> Fix all these issues by making eVMCS restoration path closer to its
>> 'native' sibling by putting eVMCS GPA to 'struct kvm_vmx_nested_state_hdr'.
>> To avoid ABI incompatibility, do not introduce a new flag and keep the
>> original eVMCS mapping path through KVM_REQ_GET_NESTED_STATE_PAGES in
>> place. To distinguish between 'new' and 'old' formats consider eVMCS
>> GPA == 0 as an unset GPA (thus forcing KVM_REQ_GET_NESTED_STATE_PAGES
>> path). While technically possible, it seems to be an extremely unlikely
>> case.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/uapi/asm/kvm.h |  2 ++
>>  arch/x86/kvm/vmx/nested.c       | 27 +++++++++++++++++++++------
>>  2 files changed, 23 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index 0662f644aad9..3845977b739e 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -441,6 +441,8 @@ struct kvm_vmx_nested_state_hdr {
>>  
>>  	__u32 flags;
>>  	__u64 preemption_timer_deadline;
>> +
>> +	__u64 evmcs_pa;
>>  };
>>  
>>  struct kvm_svm_nested_state_data {
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 37fdc34f7afc..4261cf4755c8 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -6019,6 +6019,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>>  		.hdr.vmx.vmxon_pa = -1ull,
>>  		.hdr.vmx.vmcs12_pa = -1ull,
>>  		.hdr.vmx.preemption_timer_deadline = 0,
>> +		.hdr.vmx.evmcs_pa = -1ull,
>>  	};
>>  	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
>>  		&user_kvm_nested_state->data.vmx[0];
>> @@ -6037,8 +6038,10 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>>  		if (vmx_has_valid_vmcs12(vcpu)) {
>>  			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
>>  
>> -			if (vmx->nested.hv_evmcs)
>> +			if (vmx->nested.hv_evmcs) {
>>  				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
>> +				kvm_state.hdr.vmx.evmcs_pa = vmx->nested.hv_evmcs_vmptr;
>> +			}
>>  
>>  			if (is_guest_mode(vcpu) &&
>>  			    nested_cpu_has_shadow_vmcs(vmcs12) &&
>> @@ -6230,13 +6233,25 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>>  
>>  		set_current_vmptr(vmx, kvm_state->hdr.vmx.vmcs12_pa);
>>  	} else if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
>> +		u64 evmcs_gpa = kvm_state->hdr.vmx.evmcs_pa;
>> +
>>  		/*
>> -		 * nested_vmx_handle_enlightened_vmptrld() cannot be called
>> -		 * directly from here as HV_X64_MSR_VP_ASSIST_PAGE may not be
>> -		 * restored yet. EVMCS will be mapped from
>> -		 * nested_get_vmcs12_pages().
>> +		 * EVMCS GPA == 0 most likely indicates that the migration data is
>> +		 * coming from an older KVM which doesn't support 'evmcs_pa' in
>> +		 * 'struct kvm_vmx_nested_state_hdr'.
>>  		 */
>> -		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
>> +		if (evmcs_gpa && (evmcs_gpa != -1ull) &&
>> +		    (__nested_vmx_handle_enlightened_vmptrld(vcpu, evmcs_gpa, false) !=
>> +		     EVMPTRLD_SUCCEEDED)) {
>> +			return -EINVAL;
>> +		} else if (!evmcs_gpa) {
>> +			/*
>> +			 * EVMCS GPA can't be acquired from VP assist page here because
>> +			 * HV_X64_MSR_VP_ASSIST_PAGE may not be restored yet.
>> +			 * EVMCS will be mapped from nested_get_evmcs_page().
>> +			 */
>> +			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
>> +		}
>>  	} else {
>>  		return -EINVAL;
>>  	}
>
> Hi everyone!
>
> Let me expalin my concern about this patch and also ask if I understand this correctly.
>
> In a nutshell if I understand this correctly, we are not allowed to access any guest
> memory while setting the nested state. 
>
> Now, if I understand correctly as well, the reason for the above,
> is that the userspace is allowed to set the nested state first, then fiddle with
> the KVM memslots, maybe even update the guest memory and only later do the KVM_RUN ioctl,

Currently, userspace is free to restore the guest in any order
indeed. I've probably missed post-copy but even the fact that guest MSRs
can be restored after restoring nested state doesn't make our life easier.

>
> And so this is the major reason why the KVM_REQ_GET_NESTED_STATE_PAGES
> request exists in the first place.
>
> If that is correct I assume that we either have to keep loading the EVMCS page on
> KVM_REQ_GET_NESTED_STATE_PAGES request, or we want to include the EVMCS itself
> in the migration state in addition to its physical address, similar to how we treat
> the VMCS12 and the VMCB12.

Keeping eVMCS load from KVM_REQ_GET_NESTED_STATE_PAGES is OK I believe
(or at least I still don't see a reason for us to carry a copy in the
migration data). What I still don't like is the transient state after
vmx_set_nested_state(): 
- vmx->nested.current_vmptr is -1ull because no 'real' vmptrld was done
(we skip set_current_vmptr() when KVM_STATE_NESTED_EVMCS)
- vmx->nested.hv_evmcs/vmx->nested.hv_evmcs_vmptr are also NULL because
we haven't performed nested_vmx_handle_enlightened_vmptrld() yet.

I know of at least one real problem with this state: in case
vmx_get_nested_state() happens before KVM_RUN the resulting state won't
have KVM_STATE_NESTED_EVMCS flag and this is incorrect. Take a look at
the check in nested_vmx_fail() for example:

        if (vmx->nested.current_vmptr == -1ull && !vmx->nested.hv_evmcs)
                return nested_vmx_failInvalid(vcpu);

this also seems off (I'm not sure it matters in any context but still).

>
> I personally tinkered with qemu to try and reproduce this situation
> and in my tests I wasn't able to make it update the memory
> map after the load of the nested state but prior to KVM_RUN
> but neither I wasn't able to prove that this can't happen.

Userspace has multiple ways to mess with the state of course, in KVM we
only need to make sure we don't crash :-) On migration, well behaving
userspace is supposed to restore exactly what it got though. The
restoration sequence may vary.

>
> In addition to that I don't know how qemu behaves when it does 
> guest ram post-copy because so far I haven't tried to tinker with it.
>
> Finally other userspace hypervisors exist, and they might rely on assumption
> as well.
>
> Looking forward for any comments,
> Best regards,
> 	Maxim Levitsky
>
>
>

-- 
Vitaly

