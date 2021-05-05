Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D125C37364D
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhEEIeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:34:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231736AbhEEIeM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:34:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620203595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9TvQ7n2flXAuwt0So1SwFAVULle508pKHTAOC6BbdB0=;
        b=AerflA3uuPba9mrxv+rjLbAWqyi+15QtOjOchVpi0x/a5LL5EsryX2OJXBOEfVglsLbVsH
        VJrwyl6bXxv6dwb0YD85ycPrDXuh1DWFeYeE7wIU948Q7mul46NDrRDVEHkcz3VvUE37Z7
        pffSb9D9hOP8+Yym3vOWIwkROek6YJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-Zp9fk-sLOJ6ploL0zu6Q6Q-1; Wed, 05 May 2021 04:33:14 -0400
X-MC-Unique: Zp9fk-sLOJ6ploL0zu6Q6Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0A3A84A5E5;
        Wed,  5 May 2021 08:33:12 +0000 (UTC)
Received: from starship (unknown [10.40.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBA161A865;
        Wed,  5 May 2021 08:33:10 +0000 (UTC)
Message-ID: <fa744382453d7a196812e88fe9ae9e842c903e13.camel@redhat.com>
Subject: Re: [PATCH 4/4] KVM: nVMX: Map enlightened VMCS upon restore when
 possible
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Wed, 05 May 2021 11:33:09 +0300
In-Reply-To: <20210503150854.1144255-5-vkuznets@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
         <20210503150854.1144255-5-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-03 at 17:08 +0200, Vitaly Kuznetsov wrote:
> It now looks like a bad idea to not restore eVMCS mapping directly from
> vmx_set_nested_state(). The restoration path now depends on whether KVM
> will continue executing L2 (vmx_get_nested_state_pages()) or will have to
> exit to L1 (nested_vmx_vmexit()), this complicates error propagation and
> diverges too much from the 'native' path when 'nested.current_vmptr' is
> set directly from vmx_get_nested_state_pages().
> 
> The existing solution postponing eVMCS mapping also seems to be fragile.
> In multiple places the code checks whether 'vmx->nested.hv_evmcs' is not
> NULL to distinguish between eVMCS and non-eVMCS cases. All these checks
> are 'incomplete' as we have a weird 'eVMCS is in use but not yet mapped'
> state.
> 
> Also, in case vmx_get_nested_state() is called right after
> vmx_set_nested_state() without executing the guest first, the resulting
> state is going to be incorrect as 'KVM_STATE_NESTED_EVMCS' flag will be
> missing.
> 
> Fix all these issues by making eVMCS restoration path closer to its
> 'native' sibling by putting eVMCS GPA to 'struct kvm_vmx_nested_state_hdr'.
> To avoid ABI incompatibility, do not introduce a new flag and keep the
> original eVMCS mapping path through KVM_REQ_GET_NESTED_STATE_PAGES in
> place. To distinguish between 'new' and 'old' formats consider eVMCS
> GPA == 0 as an unset GPA (thus forcing KVM_REQ_GET_NESTED_STATE_PAGES
> path). While technically possible, it seems to be an extremely unlikely
> case.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  2 ++
>  arch/x86/kvm/vmx/nested.c       | 27 +++++++++++++++++++++------
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0662f644aad9..3845977b739e 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -441,6 +441,8 @@ struct kvm_vmx_nested_state_hdr {
>  
>  	__u32 flags;
>  	__u64 preemption_timer_deadline;
> +
> +	__u64 evmcs_pa;
>  };
>  
>  struct kvm_svm_nested_state_data {
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 37fdc34f7afc..4261cf4755c8 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6019,6 +6019,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  		.hdr.vmx.vmxon_pa = -1ull,
>  		.hdr.vmx.vmcs12_pa = -1ull,
>  		.hdr.vmx.preemption_timer_deadline = 0,
> +		.hdr.vmx.evmcs_pa = -1ull,
>  	};
>  	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
>  		&user_kvm_nested_state->data.vmx[0];
> @@ -6037,8 +6038,10 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  		if (vmx_has_valid_vmcs12(vcpu)) {
>  			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
>  
> -			if (vmx->nested.hv_evmcs)
> +			if (vmx->nested.hv_evmcs) {
>  				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
> +				kvm_state.hdr.vmx.evmcs_pa = vmx->nested.hv_evmcs_vmptr;
> +			}
>  
>  			if (is_guest_mode(vcpu) &&
>  			    nested_cpu_has_shadow_vmcs(vmcs12) &&
> @@ -6230,13 +6233,25 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  		set_current_vmptr(vmx, kvm_state->hdr.vmx.vmcs12_pa);
>  	} else if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
> +		u64 evmcs_gpa = kvm_state->hdr.vmx.evmcs_pa;
> +
>  		/*
> -		 * nested_vmx_handle_enlightened_vmptrld() cannot be called
> -		 * directly from here as HV_X64_MSR_VP_ASSIST_PAGE may not be
> -		 * restored yet. EVMCS will be mapped from
> -		 * nested_get_vmcs12_pages().
> +		 * EVMCS GPA == 0 most likely indicates that the migration data is
> +		 * coming from an older KVM which doesn't support 'evmcs_pa' in
> +		 * 'struct kvm_vmx_nested_state_hdr'.
>  		 */
> -		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +		if (evmcs_gpa && (evmcs_gpa != -1ull) &&
> +		    (__nested_vmx_handle_enlightened_vmptrld(vcpu, evmcs_gpa, false) !=
> +		     EVMPTRLD_SUCCEEDED)) {
> +			return -EINVAL;
> +		} else if (!evmcs_gpa) {
> +			/*
> +			 * EVMCS GPA can't be acquired from VP assist page here because
> +			 * HV_X64_MSR_VP_ASSIST_PAGE may not be restored yet.
> +			 * EVMCS will be mapped from nested_get_evmcs_page().
> +			 */
> +			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +		}
>  	} else {
>  		return -EINVAL;
>  	}

Hi everyone!

Let me expalin my concern about this patch and also ask if I understand this correctly.

In a nutshell if I understand this correctly, we are not allowed to access any guest
memory while setting the nested state. 

Now, if I understand correctly as well, the reason for the above,
is that the userspace is allowed to set the nested state first, then fiddle with
the KVM memslots, maybe even update the guest memory and only later do the KVM_RUN ioctl,

And so this is the major reason why the KVM_REQ_GET_NESTED_STATE_PAGES
request exists in the first place.

If that is correct I assume that we either have to keep loading the EVMCS page on
KVM_REQ_GET_NESTED_STATE_PAGES request, or we want to include the EVMCS itself
in the migration state in addition to its physical address, similar to how we treat
the VMCS12 and the VMCB12.

I personally tinkered with qemu to try and reproduce this situation
and in my tests I wasn't able to make it update the memory
map after the load of the nested state but prior to KVM_RUN
but neither I wasn't able to prove that this can't happen.

In addition to that I don't know how qemu behaves when it does 
guest ram post-copy because so far I haven't tried to tinker with it.

Finally other userspace hypervisors exist, and they might rely on assumption
as well.

Looking forward for any comments,
Best regards,
	Maxim Levitsky



