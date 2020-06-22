Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE16A20438C
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbgFVW0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:26:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20577 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730945AbgFVW0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:26:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592864794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/k5TGIh9JQqchOWZyVagILLlTiRp7JFfkWRq88BGebY=;
        b=BlSvliptlnbxywaXERyILmlRcxqHwVg8KtSdUvxogZBoMu3x00tIJ8xeQDrftFljDnpLhK
        K9ExKIBXrVe55ApUXVsZQ4q8X9l3PL4c47zELSi+C8vNk4W7BRFtPqVQ7kH66g3bLnwdVE
        lMgbpIT0Z63cHkBoTPtQJFbZRPYlPbA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-BHOj4AJ4MDGlXLY2JQwv_g-1; Mon, 22 Jun 2020 18:26:30 -0400
X-MC-Unique: BHOj4AJ4MDGlXLY2JQwv_g-1
Received: by mail-wr1-f69.google.com with SMTP id i10so8111841wrn.21
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/k5TGIh9JQqchOWZyVagILLlTiRp7JFfkWRq88BGebY=;
        b=JMBRLEwBSFNGrO/kVupHaBdNUCGQLVRF/gmV84bFaysjo5G1m1tVWrWfftYtcUDnXF
         2GkamBXsnO0dpAUxfckq583Bsdyep9TpCytVCQeSTTRPGi0i0fRrsnJJ1Kb7Q2j0i7yv
         U4oe4fGjbJqmLNksoUPiUrggxA1VQ6gIJlHJRxP0CgYAZGD307kbKe2U2rbRBZFLoziO
         y4J5acw1O0UnLrXUvMBgWDEZhJX4TjopHpEicS001DeP24d/1G0PdwhpIsoAg21TgZzl
         K1zq7TlhySqRmU+X6ao77vHCBx/Yagol/bS15UhvtxzG4S0c7Vkqv3r1Vw3f2t0EFISM
         CY7A==
X-Gm-Message-State: AOAM5320KtBj168DmOra7ZphNnX0hThAsxEXPYVkcP5AJgV+HeXuCOU0
        pI2xk6VGZcZsXIbpuCHlXLZAVWelE29deS7Jy0LhmHBdQeNRcPmii+e4ut6iztZF/Y9LDN460ki
        m6xvOv41AyOEU
X-Received: by 2002:adf:9d8f:: with SMTP id p15mr21738398wre.421.1592864789050;
        Mon, 22 Jun 2020 15:26:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+aIlfrTHfDsjLsV+FvJdbdiOIaLPxVXssw64dW66X2gkNKOm8/ldbzx+h+1hdLNNFZ0nS9w==
X-Received: by 2002:adf:9d8f:: with SMTP id p15mr21738379wre.421.1592864788786;
        Mon, 22 Jun 2020 15:26:28 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id u13sm1099287wmm.6.2020.06.22.15.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 15:26:28 -0700 (PDT)
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Make .write_log_dirty a nested
 operation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200622215832.22090-1-sean.j.christopherson@intel.com>
 <20200622215832.22090-5-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d19cadaf-286e-0f6e-2067-2ea77429fbfa@redhat.com>
Date:   Tue, 23 Jun 2020 00:26:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622215832.22090-5-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 23:58, Sean Christopherson wrote:
> Move .write_log_dirty() into kvm_x86_nested_ops to help differentiate it
> from the non-nested dirty log hooks.  And because it's a nested-only
> operation.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
>  arch/x86/kvm/vmx/nested.c       | 38 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c          | 38 ---------------------------------
>  4 files changed, 40 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 446ea70a554d..4e6219cb3933 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1220,7 +1220,6 @@ struct kvm_x86_ops {
>  	void (*enable_log_dirty_pt_masked)(struct kvm *kvm,
>  					   struct kvm_memory_slot *slot,
>  					   gfn_t offset, unsigned long mask);
> -	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
>  
>  	/* pmu operations of sub-arch */
>  	const struct kvm_pmu_ops *pmu_ops;
> @@ -1281,6 +1280,7 @@ struct kvm_x86_nested_ops {
>  			 struct kvm_nested_state __user *user_kvm_nested_state,
>  			 struct kvm_nested_state *kvm_state);
>  	bool (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
> +	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
>  
>  	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
>  			    uint16_t *vmcs_version);
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 60e7b2308876..c733196fd45b 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -260,7 +260,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
>  				!(pte & PT_GUEST_DIRTY_MASK)) {
>  			trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
>  #if PTTYPE == PTTYPE_EPT
> -			if (kvm_x86_ops.write_log_dirty(vcpu, addr))
> +			if (kvm_x86_ops.nested_ops->write_log_dirty(vcpu, addr))
>  				return -EINVAL;
>  #endif
>  			pte |= PT_GUEST_DIRTY_MASK;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index adb11b504d5c..db9abcbeefd1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3205,6 +3205,43 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static int nested_vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
> +{
> +	struct vmcs12 *vmcs12;
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	gpa_t dst;
> +
> +	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
> +		return 0;
> +
> +	if (WARN_ON_ONCE(vmx->nested.pml_full))
> +		return 1;
> +
> +	/*
> +	 * Check if PML is enabled for the nested guest. Whether eptp bit 6 is
> +	 * set is already checked as part of A/D emulation.
> +	 */
> +	vmcs12 = get_vmcs12(vcpu);
> +	if (!nested_cpu_has_pml(vmcs12))
> +		return 0;
> +
> +	if (vmcs12->guest_pml_index >= PML_ENTITY_NUM) {
> +		vmx->nested.pml_full = true;
> +		return 1;
> +	}
> +
> +	gpa &= ~0xFFFull;
> +	dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
> +
> +	if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
> +				 offset_in_page(dst), sizeof(gpa)))
> +		return 0;
> +
> +	vmcs12->guest_pml_index--;
> +
> +	return 0;
> +}
> +
>  /*
>   * Intel's VMX Instruction Reference specifies a common set of prerequisites
>   * for running VMX instructions (except VMXON, whose prerequisites are
> @@ -6503,6 +6540,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
>  	.get_state = vmx_get_nested_state,
>  	.set_state = vmx_set_nested_state,
>  	.get_vmcs12_pages = nested_get_vmcs12_pages,
> +	.write_log_dirty = nested_vmx_write_pml_buffer,
>  	.enable_evmcs = nested_enable_evmcs,
>  	.get_evmcs_version = nested_get_evmcs_version,
>  };
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index adf83047bb21..8bf06a59f356 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7501,43 +7501,6 @@ static void vmx_flush_log_dirty(struct kvm *kvm)
>  	kvm_flush_pml_buffers(kvm);
>  }
>  
> -static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
> -{
> -	struct vmcs12 *vmcs12;
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	gpa_t dst;
> -
> -	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
> -		return 0;
> -
> -	if (WARN_ON_ONCE(vmx->nested.pml_full))
> -		return 1;
> -
> -	/*
> -	 * Check if PML is enabled for the nested guest. Whether eptp bit 6 is
> -	 * set is already checked as part of A/D emulation.
> -	 */
> -	vmcs12 = get_vmcs12(vcpu);
> -	if (!nested_cpu_has_pml(vmcs12))
> -		return 0;
> -
> -	if (vmcs12->guest_pml_index >= PML_ENTITY_NUM) {
> -		vmx->nested.pml_full = true;
> -		return 1;
> -	}
> -
> -	gpa &= ~0xFFFull;
> -	dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
> -
> -	if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
> -				 offset_in_page(dst), sizeof(gpa)))
> -		return 0;
> -
> -	vmcs12->guest_pml_index--;
> -
> -	return 0;
> -}
> -
>  static void vmx_enable_log_dirty_pt_masked(struct kvm *kvm,
>  					   struct kvm_memory_slot *memslot,
>  					   gfn_t offset, unsigned long mask)
> @@ -7966,7 +7929,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.slot_disable_log_dirty = vmx_slot_disable_log_dirty,
>  	.flush_log_dirty = vmx_flush_log_dirty,
>  	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
> -	.write_log_dirty = vmx_write_pml_buffer,
>  
>  	.pre_block = vmx_pre_block,
>  	.post_block = vmx_post_block,
> 

Queued, thanks (patch 1 for 5.8).

Paolo

