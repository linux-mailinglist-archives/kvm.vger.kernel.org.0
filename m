Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2497C7756
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 21:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442643AbjJLTwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 15:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442559AbjJLTwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 15:52:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A54CE7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697140257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lU1u+ADdUzaJdK9EjBVkwIFqFLIsBY7NwNLCXpy5RI0=;
        b=Vm/+mC6ciOPTKRtZ2p6KV16fCGd5aphgabr9u1jPEupmboRD64RuXmcb/gS3tScwGBj3E4
        ZXnFU+ervUMOUzlkpWueSab6s4pjT3a5hwaGZc2KsLR72LEdPG8RhH0zyE/EzCN8RTWLgu
        mFpsRTFH940mz3SoEcbdumHAjHiCrxI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-iRVtaBJmPsir9C5HRHGHUQ-1; Thu, 12 Oct 2023 15:50:55 -0400
X-MC-Unique: iRVtaBJmPsir9C5HRHGHUQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f5df65fa35so9439565e9.3
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697140254; x=1697745054;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lU1u+ADdUzaJdK9EjBVkwIFqFLIsBY7NwNLCXpy5RI0=;
        b=SboPeSucSxSGiuDy8MqNjEZUC53rnNQSTJCDhdwLIj36agc/fDxTL3QnDXfSi3xvRB
         qVKd3M0leShw4Yh4xI5+q0o5dOAdvKJmWqCeYCUFTbDmYcQxky2DrDQq6MGNIzMs4yST
         o9OJ2LZCKI8UwNP2Vzfnw1i8oaOnqE4Aujwx/6qgObtBf2JrdiFh1U+mEP+qBuLCxQFa
         kbJrShCCNfiiooGHYEbwOz/zN50DVB27Vkoar/pnznVMusOjNsZ18VE5i4/7eoSdrESU
         t1oFtEyjDhAZlc/f06ckLIRREC1WOc4NWHytKXJjKOmABNxCE93TZGz2XD0pMrLWUBlf
         slBw==
X-Gm-Message-State: AOJu0Yy+WLDnU8K+t1X8+u35CUg/KY6Rmp3G2iR06Y8QfLikhLrKE1qn
        nrDFVuMwn694YpSvtdaeCn/pm8tjQIl4fb2HB0eGsrXbZBA7TKu2XjnjpgDlvGZaXLBNzu/J4et
        qFhQQlm/FKw6I
X-Received: by 2002:a5d:504e:0:b0:321:71ae:736c with SMTP id h14-20020a5d504e000000b0032171ae736cmr21916560wrt.7.1697140254299;
        Thu, 12 Oct 2023 12:50:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHl4IXgx+K/EVNeicwIyD0C7sfU5vOnnUM7IZSz5Rh31M6Zxpy5sOVG8f3ACAM5xWcrZiGhIQ==
X-Received: by 2002:a5d:504e:0:b0:321:71ae:736c with SMTP id h14-20020a5d504e000000b0032171ae736cmr21916550wrt.7.1697140253885;
        Thu, 12 Oct 2023 12:50:53 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id bv2-20020a0560001f0200b0032d09f7a713sm8418741wrb.18.2023.10.12.12.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 12:50:53 -0700 (PDT)
Message-ID: <406f20dc55db24dffda2e01a1ccf7a7135c61604.camel@redhat.com>
Subject: Re: [PATCH RFC 08/11] KVM: nVMX: hyper-v: Introduce
 nested_vmx_evmptr() accessor
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 12 Oct 2023 22:50:52 +0300
In-Reply-To: <20231010160300.1136799-9-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
         <20231010160300.1136799-9-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-10-10 у 18:02 +0200, Vitaly Kuznetsov пише:
> 'vmx->nested.hv_evmcs_vmptr' accesses are all over the place so hiding
> 'hv_evmcs_vmptr' under 'ifdef CONFIG_KVM_HYPERV' would take a lot of
> ifdefs. Introduce 'nested_vmx_evmptr()' accessor instead.


It might also make sense to have 'nested_evmptr_valid(vmx)'
so that we could use it instead of 'evmptr_is_valid(nested_vmx_evmptr(vmx))'?


> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/hyperv.h |  5 +++++
>  arch/x86/kvm/vmx/nested.c | 44 +++++++++++++++++++--------------------
>  arch/x86/kvm/vmx/nested.h |  3 ++-
>  3 files changed, 29 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index 933ef6cad5e6..6ca5c8c5be9c 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include "vmcs12.h"
> +#include "vmx.h"
>  
>  #define EVMPTR_INVALID (-1ULL)
>  #define EVMPTR_MAP_PENDING (-2ULL)
> @@ -20,7 +21,10 @@ enum nested_evmptrld_status {
>  	EVMPTRLD_ERROR,
>  };
>  
> +struct vcpu_vmx;
> +
>  #ifdef CONFIG_KVM_HYPERV
> +static inline gpa_t nested_vmx_evmptr(struct vcpu_vmx *vmx) { return vmx->nested.hv_evmcs_vmptr; }
>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> @@ -30,6 +34,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
>  bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  #else
> +static inline gpa_t nested_vmx_evmptr(struct vcpu_vmx *vmx) { return EVMPTR_INVALID; };
>  static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVMPTR_INVALID; }
>  static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata) {}
>  static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ca7e06759aa3..e6476f8e2ccd 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -179,7 +179,7 @@ static int nested_vmx_failValid(struct kvm_vcpu *vcpu,
>  	 * VM_INSTRUCTION_ERROR is not shadowed. Enlightened VMCS 'shadows' all
>  	 * fields and thus must be synced.
>  	 */
> -	if (to_vmx(vcpu)->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
> +	if (nested_vmx_evmptr(to_vmx(vcpu)) != EVMPTR_INVALID)
>  		to_vmx(vcpu)->nested.need_vmcs12_to_shadow_sync = true;
>  
>  	return kvm_skip_emulated_instruction(vcpu);
> @@ -194,7 +194,7 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
>  	 * can't be done if there isn't a current VMCS.
>  	 */
>  	if (vmx->nested.current_vmptr == INVALID_GPA &&
> -	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	    !evmptr_is_valid(nested_vmx_evmptr(vmx)))
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	return nested_vmx_failValid(vcpu, vm_instruction_error);
> @@ -230,7 +230,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx))) {
>  		kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
>  		vmx->nested.hv_evmcs = NULL;
>  	}
> @@ -2019,7 +2019,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  		return EVMPTRLD_DISABLED;
>  	}
>  
> -	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
> +	if (unlikely(evmcs_gpa != nested_vmx_evmptr(vmx))) {
>  		vmx->nested.current_vmptr = INVALID_GPA;
>  
>  		nested_release_evmcs(vcpu);
> @@ -2097,7 +2097,7 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>  		copy_vmcs12_to_enlightened(vmx);
>  	else
>  		copy_vmcs12_to_shadow(vmx);
> @@ -2251,7 +2251,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  	u32 exec_control;
>  	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
>  
> -	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(nested_vmx_evmptr(vmx)))
>  		prepare_vmcs02_early_rare(vmx, vmcs12);

There are some similarities between evmcs and shadow vmcs. I used to know this, but it will probably
take me time to recall all of the gory details.

It might make sense to unify some of the logic, which can make it easier to #ifdef the hyperv support
in less places.


>  
>  	/*
> @@ -2546,11 +2546,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	bool load_guest_pdptrs_vmcs12 = false;
>  
> -	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> +	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(nested_vmx_evmptr(vmx))) {
>  		prepare_vmcs02_rare(vmx, vmcs12);
>  		vmx->nested.dirty_vmcs12 = false;
>  
> -		load_guest_pdptrs_vmcs12 = !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) ||
> +		load_guest_pdptrs_vmcs12 = !evmptr_is_valid(nested_vmx_evmptr(vmx)) ||
>  			!(vmx->nested.hv_evmcs->hv_clean_fields &
>  			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
>  	}
> @@ -2673,7 +2673,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	 * bits when it changes a field in eVMCS. Mark all fields as clean
>  	 * here.
>  	 */
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>  		vmx->nested.hv_evmcs->hv_clean_fields |=
>  			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>  
> @@ -3181,7 +3181,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  	 * properly reflected.
>  	 */
>  	if (guest_cpuid_has_evmcs(vcpu) &&
> -	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
> +	    nested_vmx_evmptr(vmx) == EVMPTR_MAP_PENDING) {
>  		enum nested_evmptrld_status evmptrld_status =
>  			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
>  
> @@ -3551,7 +3551,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  
>  	load_vmcs12_host_state(vcpu, vmcs12);
>  	vmcs12->vm_exit_reason = exit_reason.full;
> -	if (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (enable_shadow_vmcs || evmptr_is_valid(nested_vmx_evmptr(vmx)))
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
>  	return NVMX_VMENTRY_VMEXIT;
>  }
> @@ -3584,7 +3584,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
>  		return nested_vmx_failInvalid(vcpu);
>  
> -	if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
> +	if (CC(!evmptr_is_valid(nested_vmx_evmptr(vmx)) &&
>  	       vmx->nested.current_vmptr == INVALID_GPA))
>  		return nested_vmx_failInvalid(vcpu);
>  
> @@ -3599,7 +3599,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	if (CC(vmcs12->hdr.shadow_vmcs))
>  		return nested_vmx_failInvalid(vcpu);
>  
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx))) {
>  		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields);
>  		/* Enlightened VMCS doesn't have launch state */
>  		vmcs12->launch_state = !launch;
> @@ -4344,11 +4344,11 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>  		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>  
>  	vmx->nested.need_sync_vmcs02_to_vmcs12_rare =
> -		!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
> +		!evmptr_is_valid(nested_vmx_evmptr(vmx));
>  
>  	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
>  	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
> @@ -4869,7 +4869,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	}
>  
>  	if ((vm_exit_reason != -1) &&
> -	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
> +	    (enable_shadow_vmcs || evmptr_is_valid(nested_vmx_evmptr(vmx))))
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
>  
>  	/* in case we halted in L2 */
> @@ -5335,7 +5335,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>  					   vmptr + offsetof(struct vmcs12,
>  							    launch_state),
>  					   &zero, sizeof(zero));
> -	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
> +	} else if (vmx->nested.hv_evmcs && vmptr == nested_vmx_evmptr(vmx)) {
>  		nested_release_evmcs(vcpu);
>  	}
>  
> @@ -5375,7 +5375,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  	/* Decode instruction info and find the field to read */
>  	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
>  
> -	if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> +	if (!evmptr_is_valid(nested_vmx_evmptr(vmx))) {
>  		/*
>  		 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
>  		 * any VMREAD sets the ALU flags for VMfailInvalid.
> @@ -5601,7 +5601,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
>  		return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_VMXON_POINTER);
>  
>  	/* Forbid normal VMPTRLD if Enlightened version was used */
> -	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>  		return 1;
>  
>  	if (vmx->nested.current_vmptr != vmptr) {
> @@ -5664,7 +5664,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
>  
> -	if (unlikely(evmptr_is_valid(to_vmx(vcpu)->nested.hv_evmcs_vmptr)))
> +	if (unlikely(evmptr_is_valid(nested_vmx_evmptr(to_vmx(vcpu)))))
>  		return 1;
>  
>  	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
> @@ -6450,7 +6450,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
>  
>  			/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
> -			if (vmx->nested.hv_evmcs_vmptr != EVMPTR_INVALID)
> +			if (nested_vmx_evmptr(vmx) != EVMPTR_INVALID)
>  				kvm_state.flags |= KVM_STATE_NESTED_EVMCS;
>  
>  			if (is_guest_mode(vcpu) &&
> @@ -6506,7 +6506,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  	} else  {
>  		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
>  		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
> -			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
> +			if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
>  				/*
>  				 * L1 hypervisor is not obliged to keep eVMCS
>  				 * clean fields data always up-to-date while
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index b4b9d51438c6..b389312636e2 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -3,6 +3,7 @@
>  #define __KVM_X86_VMX_NESTED_H
>  
>  #include "kvm_cache_regs.h"
> +#include "hyperv.h"

^ This fixes the build error introduced by patch 6.

>  #include "vmcs12.h"
>  #include "vmx.h"
>  
> @@ -57,7 +58,7 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
>  
>  	/* 'hv_evmcs_vmptr' can also be EVMPTR_MAP_PENDING here */
>  	return vmx->nested.current_vmptr != -1ull ||
> -		vmx->nested.hv_evmcs_vmptr != EVMPTR_INVALID;
> +		nested_vmx_evmptr(vmx) != EVMPTR_INVALID;

However with my suggestion of nested_evmptr_valid(vmx) we 
can hide that check and avoid the include as well.

>  }
>  
>  static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)


Best regards,
	Maxim Levitsky





