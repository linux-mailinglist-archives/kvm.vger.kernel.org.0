Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCF538E68A
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhEXM2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:28:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232476AbhEXM2d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XSzr21vwqst9EpOmT8fSgxup5KtjbpG83J7rKiSxd2M=;
        b=AyHJQIr+/g57DFrv17de6KwWalxR0uXMBbuykpdEGcOr5ZpQfJrQx++3IYrs4whyW2+YVD
        UMlVqt2P9aWsVMHF08ZhzlcMWMqeqPVAjKSJ2m34NyHD6fahDFv8ZSJIJf4/GfkhdVP6f1
        OY/L52ivzlbdSUJNY95MT7+lQpe6iAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-uVzqynCLPzOOT0DtSpDH-Q-1; Mon, 24 May 2021 08:27:02 -0400
X-MC-Unique: uVzqynCLPzOOT0DtSpDH-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D0ED100945F;
        Mon, 24 May 2021 12:27:01 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 329E71037E80;
        Mon, 24 May 2021 12:26:58 +0000 (UTC)
Message-ID: <48f7950dd6504a9ecc7a5209db264587958cafdf.camel@redhat.com>
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Ignore 'hv_clean_fields' data when
 eVMCS data is copied in vmx_get_nested_state()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Mon, 24 May 2021 15:26:57 +0300
In-Reply-To: <20210517135054.1914802-4-vkuznets@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
         <20210517135054.1914802-4-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-17 at 15:50 +0200, Vitaly Kuznetsov wrote:
> 'Clean fields' data from enlightened VMCS is only valid upon vmentry: L1
> hypervisor is not obliged to keep it up-to-date while it is mangling L2's
> state, KVM_GET_NESTED_STATE request may come at a wrong moment when actual
> eVMCS changes are unsynchronized with 'hv_clean_fields'. As upon migration
> VMCS12 is used as a source of ultimate truth, we must make sure we pick all
> the changes to eVMCS and thus 'clean fields' data must be ignored.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 49 +++++++++++++++++++++++----------------
>  1 file changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ea2869d8b823..ec476f64df73 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1607,7 +1607,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
>  	vmcs_load(vmx->loaded_vmcs->vmcs);
>  }
>  
> -static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
> +static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
>  {
>  	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
>  	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
> @@ -1616,7 +1616,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  	vmcs12->tpr_threshold = evmcs->tpr_threshold;
>  	vmcs12->guest_rip = evmcs->guest_rip;
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC))) {
>  		vmcs12->guest_rsp = evmcs->guest_rsp;
>  		vmcs12->guest_rflags = evmcs->guest_rflags;
> @@ -1624,23 +1624,23 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  			evmcs->guest_interruptibility_info;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC))) {
>  		vmcs12->cpu_based_vm_exec_control =
>  			evmcs->cpu_based_vm_exec_control;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN))) {
>  		vmcs12->exception_bitmap = evmcs->exception_bitmap;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_ENTRY))) {
>  		vmcs12->vm_entry_controls = evmcs->vm_entry_controls;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT))) {
>  		vmcs12->vm_entry_intr_info_field =
>  			evmcs->vm_entry_intr_info_field;
> @@ -1650,7 +1650,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  			evmcs->vm_entry_instruction_len;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1))) {
>  		vmcs12->host_ia32_pat = evmcs->host_ia32_pat;
>  		vmcs12->host_ia32_efer = evmcs->host_ia32_efer;
> @@ -1670,7 +1670,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  		vmcs12->host_tr_selector = evmcs->host_tr_selector;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1))) {
>  		vmcs12->pin_based_vm_exec_control =
>  			evmcs->pin_based_vm_exec_control;
> @@ -1679,18 +1679,18 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  			evmcs->secondary_vm_exec_control;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP))) {
>  		vmcs12->io_bitmap_a = evmcs->io_bitmap_a;
>  		vmcs12->io_bitmap_b = evmcs->io_bitmap_b;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP))) {
>  		vmcs12->msr_bitmap = evmcs->msr_bitmap;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2))) {
>  		vmcs12->guest_es_base = evmcs->guest_es_base;
>  		vmcs12->guest_cs_base = evmcs->guest_cs_base;
> @@ -1730,14 +1730,14 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  		vmcs12->guest_tr_selector = evmcs->guest_tr_selector;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2))) {
>  		vmcs12->tsc_offset = evmcs->tsc_offset;
>  		vmcs12->virtual_apic_page_addr = evmcs->virtual_apic_page_addr;
>  		vmcs12->xss_exit_bitmap = evmcs->xss_exit_bitmap;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR))) {
>  		vmcs12->cr0_guest_host_mask = evmcs->cr0_guest_host_mask;
>  		vmcs12->cr4_guest_host_mask = evmcs->cr4_guest_host_mask;
> @@ -1749,7 +1749,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  		vmcs12->guest_dr7 = evmcs->guest_dr7;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER))) {
>  		vmcs12->host_fs_base = evmcs->host_fs_base;
>  		vmcs12->host_gs_base = evmcs->host_gs_base;
> @@ -1759,13 +1759,13 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
>  		vmcs12->host_rsp = evmcs->host_rsp;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT))) {
>  		vmcs12->ept_pointer = evmcs->ept_pointer;
>  		vmcs12->virtual_processor_id = evmcs->virtual_processor_id;
>  	}
>  
> -	if (unlikely(!(evmcs->hv_clean_fields &
> +	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1))) {
>  		vmcs12->vmcs_link_pointer = evmcs->vmcs_link_pointer;
>  		vmcs12->guest_ia32_debugctl = evmcs->guest_ia32_debugctl;
> @@ -3473,6 +3473,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	enum nvmx_vmentry_status status;
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
> +	struct hv_enlightened_vmcs *evmcs;
>  	enum nested_evmptrld_status evmptrld_status;
>  
>  	++vcpu->stat.nested_run;
> @@ -3488,7 +3489,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  		return nested_vmx_failInvalid(vcpu);
>  	}
>  
> -	if (CC(!vmx->nested.hv_evmcs && vmx->nested.current_vmptr == -1ull))
> +	evmcs = vmx->nested.hv_evmcs;
> +	if (CC(!evmcs && vmx->nested.current_vmptr == -1ull))
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	vmcs12 = get_vmcs12(vcpu);
> @@ -3502,8 +3504,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (CC(vmcs12->hdr.shadow_vmcs))
>  		return nested_vmx_failInvalid(vcpu);
>  
> -	if (vmx->nested.hv_evmcs) {
> -		copy_enlightened_to_vmcs12(vmx);
> +	if (evmcs) {
> +		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
>  		/* Enlightened VMCS doesn't have launch state */
>  		vmcs12->launch_state = !launch;
>  	} else if (enable_shadow_vmcs) {
> @@ -6136,7 +6138,14 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
>  		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
>  			if (vmx->nested.hv_evmcs)
> -				copy_enlightened_to_vmcs12(vmx);
> +				/*
> +				 * L1 hypervisor is not obliged to keep eVMCS
> +				 * clean fields data always up-to-date while
> +				 * not in guest mode, 'hv_clean_fields' is only
> +				 * supposed to be actual upon vmentry so we need
> +				 * to ignore it here and do full copy.
> +				 */
> +				copy_enlightened_to_vmcs12(vmx, 0);

Hi Vitaly!

This patch had lead me to a deep rabbit hole,
so I would like to share my thoughts about it:

Initially I thought that we should just drop the copy of the evmcs to vmcs12
instead, based on the following argument:
 
When L2 is running we don't copy it since then guest must not
modify it just like normal vmcs, and L2 state is in our vmcs02.
 
And when L1 is running, then essentially evmcs is just a guest memory.

Even when loaded by previous vm entry,
we barely touch that evmcs
(we only touch it to update the vmx instruction error),
and even for that we need to update the evmcs (vmcs12->evmcs) and not vice versa.

Reading whole evmcs while the L1 is running indeed 
feels wrong since at this point the L1 owns it.

However we have another bug that you fixed in patch 6, which I sadly rediscovered
while reviewing this patch, which makes the above approach impossible.
After a migration we won't be able to know if evmcs is more up to date,
or if vmcs12 is more up to date.

I was thinking that for later case (vmcs12 more up to date) it would be cleaner
to sync evmcs here and then drop the copy_enlightened_to_vmcs12 call.

However we can't do this since in KVM_GET_NESTED_STATE handler we are not allowed
to dirtify the guest memory since at the point, this ioctl is called, the userspace
assumes that it has already copied all of the guest memory, 
and that this ioctl won't dirtify the guest memory again.
(see commit fa58a9fa74979f845fc6c94a58501e67f3abb6de)

It is still possible to go with my suggestion though if we avoid using
need_vmcs12_to_shadow_sync for evmcs, and sync evmcs right away
in the two places where it needed:
On nested vmexit and when updating the VM_INSTRUCTION_ERROR.
This shouldn't cause any performance regressions.

Then we can just drop the copy_enlightened_to_vmcs12, drop this patch, patch 5 and patch 6,
and now have the assumption that when we migrate L1 then
whatever evmcs was previously used we
fully updated it on last nested vmexit, and then maybe L1 modified it,
while vmcs12 continues to hold state of the vm that we wrote
during last nested vm exit.

In regard to backward compatibility the evmcs nested migration 
was very broken prior to these fixes anyway thus the change
that I propose shoudn't make things worse.

What do you think?

Best regards,
	Maxim Levitsky



>  			else if (enable_shadow_vmcs)
>  				copy_shadow_to_vmcs12(vmx);
>  		}






