Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BB63928F3
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 09:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbhE0Hz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 03:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhE0Hzy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 03:55:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622102061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NIJDEDPTUUh+MvYYUhV4MRTGp0zHgItTIJ248uznSmE=;
        b=cSyfZRPpI3IRDQiXb9+BYKLm4Z/ol0fvJJb0pIqJBuKtLupMLrgsYo0+5MSwkNkilFUSRT
        7wqWFUe2T6Hr6ZhVQwehfz/x9pimJmEjq6fZ+Pj7PR+CNCYbdbw9sB7RFRt4HAiMvLBygs
        YoRI6HDzPfnd15H4KA0Y3eF92AhaLdE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-QcwbIFiuODSu2ba6yShlZw-1; Thu, 27 May 2021 03:54:19 -0400
X-MC-Unique: QcwbIFiuODSu2ba6yShlZw-1
Received: by mail-wm1-f70.google.com with SMTP id z62-20020a1c65410000b0290179bd585ef9so1632253wmb.7
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 00:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NIJDEDPTUUh+MvYYUhV4MRTGp0zHgItTIJ248uznSmE=;
        b=fIth3nlO2ziXpYD1USC3k39nwc9ssL7uRi0COsya/0TtT6aqMZDgqJL2/jYkcGaHnK
         vP7SEBV3pChcycVvqjhJjO5FGyKsYXWCo6bFiqd0rqPACzvHmYtKPj3bIg3n/8FkX++w
         S8y3nadwraktAgtiCO99L2fo2/PdfhNzEJAzyN1UkpxAv+KuNoGTlUohAViWDpwNG2WG
         E7Bca6TVtcGAerRX/rOeg0+cOjEk+2IgAP2Jnt+n+aFZ3erylSx2AldQRWJ87JAAtNlr
         FHycfh60odwNeRLlhFqnm5Ohp6lpkB4FG1HH2mgTGJXC/xyFZBqFWl9uvhKWM1UnYpRI
         M1Bg==
X-Gm-Message-State: AOAM530YywaVvBNysVDkBuplIcxMr0UTkMYVdXXO7OHef0gEm4itGvP+
        1HmLr53h4fUsY0ZPAC6I/bPv3+POn++6fUyyKb5kx/I3jtZZ+2Zg6aBSaOltDRcdj+uC4+AGctc
        KVSiQ0hgSm7Xt
X-Received: by 2002:a05:6000:44:: with SMTP id k4mr1980982wrx.76.1622102058387;
        Thu, 27 May 2021 00:54:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2HZr63KmUO8MVRPoQh32l69obiJzdpK+D/iQHJrIjQ80sRsQOrW9Z4nR1sE1g/DC3rYiBaQ==
X-Received: by 2002:a05:6000:44:: with SMTP id k4mr1980954wrx.76.1622102058083;
        Thu, 27 May 2021 00:54:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v3sm2064256wrr.19.2021.05.27.00.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 00:54:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Introduce nested_evmcs_is_used()
In-Reply-To: <2a3eae6089958956f707dbc55d1d2a410edb6983.camel@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <20210517135054.1914802-2-vkuznets@redhat.com>
 <80892ca2e3d7122b5b92f696ecf4c1943b0245b9.camel@redhat.com>
 <875yz871j1.fsf@vitty.brq.redhat.com>
 <2a3eae6089958956f707dbc55d1d2a410edb6983.camel@redhat.com>
Date:   Thu, 27 May 2021 09:54:16 +0200
Message-ID: <87cztc7gt3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Mon, 2021-05-24 at 14:35 +0200, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> 
>> > On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
>> > > Unlike regular set_current_vmptr(), nested_vmx_handle_enlightened_vmptrld()
>> > > can not be called directly from vmx_set_nested_state() as KVM may not have
>> > > all the information yet (e.g. HV_X64_MSR_VP_ASSIST_PAGE MSR may not be
>> > > restored yet). Enlightened VMCS is mapped later while getting nested state
>> > > pages. In the meantime, vmx->nested.hv_evmcs remains NULL and using it
>> > > for various checks is incorrect. In particular, if KVM_GET_NESTED_STATE is
>> > > called right after KVM_SET_NESTED_STATE, KVM_STATE_NESTED_EVMCS flag in the
>> > > resulting state will be unset (and such state will later fail to load).
>> > > 
>> > > Introduce nested_evmcs_is_used() and use 'is_guest_mode(vcpu) &&
>> > > vmx->nested.current_vmptr == -1ull' check to detect not-yet-mapped eVMCS
>> > > after restore.
>> > > 
>> > > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> > > ---
>> > >  arch/x86/kvm/vmx/nested.c | 31 ++++++++++++++++++++++++++-----
>> > >  1 file changed, 26 insertions(+), 5 deletions(-)
>> > > 
>> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> > > index 6058a65a6ede..3080e00c8f90 100644
>> > > --- a/arch/x86/kvm/vmx/nested.c
>> > > +++ b/arch/x86/kvm/vmx/nested.c
>> > > @@ -141,6 +141,27 @@ static void init_vmcs_shadow_fields(void)
>> > >  	max_shadow_read_write_fields = j;
>> > >  }
>> > >  
>> > > +static inline bool nested_evmcs_is_used(struct vcpu_vmx *vmx)
>> > > +{
>> > > +	struct kvm_vcpu *vcpu = &vmx->vcpu;
>> > > +
>> > > +	if (vmx->nested.hv_evmcs)
>> > > +		return true;
>> > > +
>> > > +	/*
>> > > +	 * After KVM_SET_NESTED_STATE, enlightened VMCS is mapped during
>> > > +	 * KVM_REQ_GET_NESTED_STATE_PAGES handling and until the request is
>> > > +	 * processed vmx->nested.hv_evmcs is NULL. It is, however, possible to
>> > > +	 * detect such state by checking 'nested.current_vmptr == -1ull' when
>> > > +	 * vCPU is in guest mode, it is only possible with eVMCS.
>> > > +	 */
>> > > +	if (unlikely(vmx->nested.enlightened_vmcs_enabled && is_guest_mode(vcpu) &&
>> > > +		     (vmx->nested.current_vmptr == -1ull)))
>> > > +		return true;
>> > > +
>> > > +	return false;
>> > > +}
>> > 
>> > I think that this is a valid way to solve the issue,
>> > but it feels like there might be a better way.
>> > I don't mind though to accept this patch as is.
>> > 
>> > So here are my 2 cents about this:
>> > 
>> > First of all after studying how evmcs works I take my words back
>> > about needing to migrate its contents. 
>> > 
>> > It is indeed enough to migrate its physical address, 
>> > or maybe even just a flag that evmcs is loaded
>> > (and to my surprise we already do this - KVM_STATE_NESTED_EVMCS)
>> > 
>> > So how about just having a boolean flag that indicates that evmcs is in use, 
>> > but doesn't imply that we know its address or that it is mapped 
>> > to host address space, something like 'vmx->nested.enlightened_vmcs_loaded'
>> > 
>> > On migration that flag saved and restored as the KVM_STATE_NESTED_EVMCS,
>> > otherwise it set when we load an evmcs and cleared when it is released.
>> > 
>> > Then as far as I can see we can use this flag in nested_evmcs_is_used
>> > since all its callers don't touch evmcs, thus don't need it to be
>> > mapped.
>> > 
>> > What do you think?
>
>
>
>> > 
>> 
>> First, we need to be compatible with older KVMs which don't have the
>> flag and this is problematic: currently, we always expect vmcs12 to
>> carry valid contents. This is challenging.
>
> All right, I understand this can be an issue!
>
> If the userspace doesn't set the KVM_STATE_NESTED_EVMCS
> but has a valid EVMCS as later indicated enabling it in the HV
> assist page, we can just use the logic that this patch uses but use it 
> to set vmx->nested.enlightened_vmcs_loaded flag or whatever
> we decide to name it.
> Later we can even deprecate and disable this with a new KVM cap.
>
>
> BTW, I like Paolo's idea of putting this flag into the evmcs_gpa,
> like that
>
> -1 no evmcs
> 0 - evmcs enabled but its gpa not known
> anything else - valid gpa.
>
>
> Also as I said, I am not against this patch either, 
> I am just thinking maybe we can make it a bit better.
>

v3 implements a similar idea (I kept Paolo's 'Suggested-by' though :-)
we set hv_evmcs_vmptr to EVMPTR_MAP_PENDING after migration. I haven't
tried it yet but I thin we can eventually drop
KVM_REQ_GET_NESTED_STATE_PAGES usage.

For now, this series is a bugfix (multiple bugfixes, actually) so I'd
like to get in and not try to make everything perfect regarding eVMCS
:-) I'll certainly take a look at other possible improvements later.

>
>> 
>> Second, vCPU can be migrated in three different states:
>> 1) While L2 was running ('true' nested state is in VMCS02)
>> 2) While L1 was running ('true' nested state is in eVMCS)
>> 3) Right after an exit from L2 to L1 was forced
>> ('need_vmcs12_to_shadow_sync = true') ('true' nested state is in
>> VMCS12).
>
> Yes and this was quite difficult thing to understand
> when I was trying to figure out how this code works.
>
> Also you can add another intersting state:
>
> 4) Right after emulating vmlauch/vmresume but before
> the actual entry to the nested guest (aka nested_run_pending=true)
>

Honestly, I haven't took a closer look at this state. Do you envision
specific issues? Can we actually try to serve KVM_GET_NESTED_STATE in
between setting 'nested_run_pending=true' and an actual attempt to enter
L2?

>
>
>> 
>> The current solution is to always use VMCS12 as a container to transfer
>> the state and conceptually, it is at least easier to understand.
>> 
>> We can, indeed, transfer eVMCS (or VMCS12) in case 2) through guest
>> memory and I even tried that but that was making the code more complex
>> so eventually I gave up and decided to preserve the 'always use VMCS12
>> as a container' status quo.
>
>
> My only point of concern is that it feels like it is wrong to update eVMCS
> when not doing a nested vmexit, because then the eVMCS is owned by the
> L1 hypervisor.

I see your concern and ideally we wouldn't have to touch it.

> At least not the fields which aren't supposed to be updated by us.
>
>
> This is a rough code draft of what I had in mind (not tested).
> To me this seems reasonable but I do agree that there is
> some complexety tradeoffs involved.
>
> About the compatibitly it can be said that:
>
>
> Case 1:
> Both old and new kernels will send/recive up to date vmcs12,
> while evcms is not up to date, and its contents aren't even defined
> (since L2 runs).
>
> Case 2:
> Old kernel will send vmcb12, with partial changes that L1 already
> made to evmcs, and latest state of evmcs with all changes
> in the guest memory.
>
> But these changes will be discarded on the receiving side, 
> since once L1 asks us to enter L2, we will reload all the state from eVMCS,
> (at least the state that is marked as dirty, which means differ
> from vmcs12 as it was on the last nested vmexit)
>
> New kernel will always send the vmcb12 as it was on the last vmexit,
> a bit older version but even a more consistent one.
>
> But this doesn't matter either as just like in case of the old kernel, 
> the vmcs12 will be updated from evmcs as soon as we do another L2 entry.
>
> So while in this case we send 'more stale' vmcb12, it doesn't
> really matter as it is stale anyway and will be reloaded from
> evmcs.
>
> Case 3:
> Old kernel will send up to date vmcb12 (since L1 didn't had a chance
> to run anyway after nested vmexit). The evmcs will not be up to date
> in the guest memory, but newer kernel can fix this by updating it
> as you did in patch 6.
>
> New kernel will send up to date vmcb12 (same reason) and up to date
> evmcs, so in fact an unchanged target kernel will be able to migrate
> from this state.
>
> So in fact my suggestion would allow to actually migrate to a kernel
> without the fix applied.
> This is even better than I thought.
>
>
> This is a rough draft of the idea:
>
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6058a65a6ede..98eb7526cae6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -167,15 +167,22 @@ static int nested_vmx_failInvalid(struct kvm_vcpu *vcpu)
>  static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
>  				u32 vm_instruction_error)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	vmx_set_rflags(vcpu, (vmx_get_rflags(vcpu)
>  			& ~(X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF |
>  			    X86_EFLAGS_SF | X86_EFLAGS_OF))
>  			| X86_EFLAGS_ZF);
>  	get_vmcs12(vcpu)->vm_instruction_error = vm_instruction_error;
> +
>  	/*
>  	 * We don't need to force a shadow sync because
>  	 * VM_INSTRUCTION_ERROR is not shadowed
> +	 * We do need to update the evmcs
>  	 */
> +
> +	if (vmx->nested.hv_evmcs)
> +		vmx->nested.hv_evmcs->vm_instruction_error = vm_instruction_error;
> +
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
>  
> @@ -1962,6 +1969,10 @@ static int copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
>  
>  	evmcs->guest_bndcfgs = vmcs12->guest_bndcfgs;
>  
> +	/* All fields are clean */
> +	vmx->nested.hv_evmcs->hv_clean_fields |=
> +		HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
> +
>  	return 0;
>  }
>  
> @@ -2055,16 +2066,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -
> -	if (vmx->nested.hv_evmcs) {
> -		copy_vmcs12_to_enlightened(vmx);
> -		/* All fields are clean */
> -		vmx->nested.hv_evmcs->hv_clean_fields |=
> -			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
> -	} else {
> -		copy_vmcs12_to_shadow(vmx);
> -	}
> -
> +	copy_vmcs12_to_shadow(vmx);
>  	vmx->nested.need_vmcs12_to_shadow_sync = false;
>  }
>  
> @@ -3437,8 +3439,13 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  
>  	load_vmcs12_host_state(vcpu, vmcs12);
>  	vmcs12->vm_exit_reason = exit_reason.full;
> -	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
> +
> +	if (enable_shadow_vmcs)
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
> +
> +	if (vmx->nested.hv_evmcs)
> +		copy_vmcs12_to_enlightened(vmx);
> +
>  	return NVMX_VMENTRY_VMEXIT;
>  }
>  
> @@ -4531,10 +4538,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>  	}
>  
> -	if ((vm_exit_reason != -1) &&
> -	    (enable_shadow_vmcs || vmx->nested.hv_evmcs))
> +	if ((vm_exit_reason != -1) && enable_shadow_vmcs)
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
>  
> +	if (vmx->nested.hv_evmcs)
> +		copy_vmcs12_to_enlightened(vmx);
> +
>  	/* in case we halted in L2 */
>  	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  
> @@ -6111,12 +6120,8 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>  	} else  {
>  		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
> -		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
> -			if (vmx->nested.hv_evmcs)
> -				copy_enlightened_to_vmcs12(vmx);
> -			else if (enable_shadow_vmcs)
> -				copy_shadow_to_vmcs12(vmx);
> -		}
> +		if (enable_shadow_vmcs && !vmx->nested.need_vmcs12_to_shadow_sync)
> +			copy_shadow_to_vmcs12(vmx);
>  	}
>  
>  	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
>
>

I don't see why this can't work, the only concern here is that
conceptually, we'll be making eVMCS something different from shadow
vmcs. In any case, let's give this a try when this series fixing real
bugs lands.

-- 
Vitaly

