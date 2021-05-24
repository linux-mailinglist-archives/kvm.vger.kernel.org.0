Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C7A38F299
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhEXRze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232789AbhEXRzd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621878844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eU3fA2KEKT/WOFixl2f9WK5sIlL2IQKSCLc2pU9iNpE=;
        b=XuuJe54RPENDmPHgIPGc3E36KYcmhZaWmXp/LWWnz5r9BaHe5+FTJnkM27COMBSCNbPbOv
        3aLRXOpgJpsK7ds2nCq05WUkpLOXkFXNtqfl7gCfUtF+6HINixYLWii5cQv+S+yD12tIU1
        B4nbp9uvoDmdsE49Gc97DfomdZD37pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-Wx1ubxTWNMeDwYTZLroKSg-1; Mon, 24 May 2021 13:54:01 -0400
X-MC-Unique: Wx1ubxTWNMeDwYTZLroKSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C2E21007B01;
        Mon, 24 May 2021 17:53:59 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 977AB5C230;
        Mon, 24 May 2021 17:53:55 +0000 (UTC)
Message-ID: <2b3bc8aff14a09c4ea4a1b648f750b5ffb1a15a0.camel@redhat.com>
Subject: Re: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 24 May 2021 20:53:54 +0300
In-Reply-To: <20210521102449.21505-10-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-10-ilstam@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-05-21 at 11:24 +0100, Ilias Stamatis wrote:
> The vmx->current_tsc_ratio field is redundant as
> vcpu->arch.tsc_scaling_ratio already tracks the current TSC scaling
> ratio. Removing this field makes decache_tsc_multiplier() an one-liner
> so remove that too and do a vmcs_write64() directly in order to be more
> consistent with surrounding code.
Not to mention that 'decache_tsc_multiplier' isn't a good name IMHO
for this....


> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 9 ++++-----
>  arch/x86/kvm/vmx/vmx.c    | 5 ++---
>  arch/x86/kvm/vmx/vmx.h    | 8 --------
>  3 files changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6058a65a6ede..239154d3e4e7 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2533,9 +2533,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	}
>  
>  	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
> -
>  	if (kvm_has_tsc_control)
> -		decache_tsc_multiplier(vmx);
> +		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
>  
>  	nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
>  
> @@ -4501,12 +4500,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>  	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
> +	if (kvm_has_tsc_control)
> +		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
> +
>  	if (vmx->nested.l1_tpr_threshold != -1)
>  		vmcs_write32(TPR_THRESHOLD, vmx->nested.l1_tpr_threshold);
>  
> -	if (kvm_has_tsc_control)
> -		decache_tsc_multiplier(vmx);
> -
>  	if (vmx->nested.change_vmcs01_virtual_apic_mode) {
>  		vmx->nested.change_vmcs01_virtual_apic_mode = false;
>  		vmx_set_virtual_apic_mode(vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4b70431c2edd..7c52c697cfe3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1392,9 +1392,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>  	}
>  
>  	/* Setup TSC multiplier */
> -	if (kvm_has_tsc_control &&
> -	    vmx->current_tsc_ratio != vcpu->arch.tsc_scaling_ratio)
> -		decache_tsc_multiplier(vmx);
> +	if (kvm_has_tsc_control)
> +		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);

This might have an overhead of writing the TSC scaling ratio even if
it is unchanged. I haven't measured how expensive vmread/vmwrites are but
at least when nested, the vmreads/vmwrites can be very expensive (if they
cause a vmexit).

This is why I think the 'vmx->current_tsc_ratio' exists - to have
a cached value of TSC scale ratio to avoid either 'vmread'ing
or 'vmwrite'ing it without a need.


Best regards,
	Maxim Levitsky

>  }
>  
>  /*
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index aa97c82e3451..3eaa86a0ba3e 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -322,8 +322,6 @@ struct vcpu_vmx {
>  	/* apic deadline value in host tsc */
>  	u64 hv_deadline_tsc;
>  
> -	u64 current_tsc_ratio;
> -
>  	unsigned long host_debugctlmsr;
>  
>  	/*
> @@ -532,12 +530,6 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
>  			      GFP_KERNEL_ACCOUNT);
>  }
>  
> -static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
> -{
> -	vmx->current_tsc_ratio = vmx->vcpu.arch.tsc_scaling_ratio;
> -	vmcs_write64(TSC_MULTIPLIER, vmx->current_tsc_ratio);
> -}
> -
>  static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
>  {
>  	return vmx->secondary_exec_control &


