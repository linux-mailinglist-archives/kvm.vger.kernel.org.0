Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D0E5231B8
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiEKLcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237277AbiEKLcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:32:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 247133ED2A
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+BJJMERzVy0p73QO0H4njt1EJ0ruBqyO5Hp/+L0nhYE=;
        b=g5vdD1ZO7AQisVOvhsuSqrYp2eW+LynFf2PJfrttFR2IG4Ao7ovi0JcSYim+fBIH697MlS
        zjYqvExNka3JIJLrLuaGsGSGSn58zr5l+g/NulpOmFdvMKEOxAwGSfXrw1xrc6k4DsAzTA
        EOLtiLYlapJbxktAj7PGmtjDBkGJpPg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-0LZSZk8SP1inhSyRCm4c9Q-1; Wed, 11 May 2022 07:32:00 -0400
X-MC-Unique: 0LZSZk8SP1inhSyRCm4c9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F73C397968A;
        Wed, 11 May 2022 11:31:59 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C09E40CF8E4;
        Wed, 11 May 2022 11:31:57 +0000 (UTC)
Message-ID: <3d25a230ec31161823c6320ceef77ab0c331e3d1.camel@redhat.com>
Subject: Re: [PATCH v3 19/34] KVM: nVMX: hyper-v: Enable L2 TLB flush
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:31:56 +0300
In-Reply-To: <20220414132013.1588929-20-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-20-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> Enable L2 TLB flush feature on nVMX when:
> - Enlightened VMCS is in use.
> - The feature flag is enabled in eVMCS.
> - The feature flag is enabled in partition assist page.
> 
> Perform synthetic vmexit to L1 after processing TLB flush call upon
> request (HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH).
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/evmcs.c  | 20 ++++++++++++++++++++
>  arch/x86/kvm/vmx/evmcs.h  | 10 ++++++++++
>  arch/x86/kvm/vmx/nested.c | 16 ++++++++++++++++
>  3 files changed, 46 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index e390e67496df..e0cb2e223daa 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -6,6 +6,7 @@
>  #include "../hyperv.h"
>  #include "../cpuid.h"
>  #include "evmcs.h"
> +#include "nested.h"
>  #include "vmcs.h"
>  #include "vmx.h"
>  #include "trace.h"
> @@ -438,6 +439,25 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
> +	struct hv_vp_assist_page assist_page;
> +
> +	if (!evmcs)
> +		return false;
> +
> +	if (!evmcs->hv_enlightenments_control.nested_flush_hypercall)
> +		return false;
> +
> +	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
> +		return false;
> +
> +	return assist_page.nested_control.features.directhypercall;
> +}
> +
>  void vmx_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +	nested_vmx_vmexit(vcpu, HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH, 0, 0);
>  }
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index b120b0ead4f3..ddbdb557cc53 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -65,6 +65,15 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>  #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>  #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
>  
> +/*
> + * Note, Hyper-V isn't actually stealing bit 28 from Intel, just abusing it by
> + * pairing it with architecturally impossible exit reasons.  Bit 28 is set only
> + * on SMI exits to a SMI transfer monitor (STM) and if and only if a MTF VM-Exit
> + * is pending.  I.e. it will never be set by hardware for non-SMI exits (there
> + * are only three), nor will it ever be set unless the VMM is an STM.

I am sure that this will backfire this way or another. Their fault though...


I also wonder why they need that synthetic VM exit, it's in the spec,
but why I don't fully understand. Their fault as well though.

The flag that controls it is 'TlbLockCount', I wonder what it means...

> + */
> +#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
> +
>  struct evmcs_field {
>  	u16 offset;
>  	u16 clean_field;
> @@ -244,6 +253,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  			uint16_t *vmcs_version);
>  void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
>  int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
> +bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>  void vmx_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu);
>  
>  #endif /* __KVM_X86_VMX_EVMCS_H */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cc6c944b5815..3e2ef5edad4a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1170,6 +1170,17 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +	/*
> +	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
> +	 * L2's VP_ID upon request from the guest. Make sure we check for
> +	 * pending entries for the case when the request got misplaced (e.g.
> +	 * a transition from L2->L1 happened while processing L2 TLB flush
> +	 * request or vice versa). kvm_hv_vcpu_flush_tlb() will not flush
> +	 * anything if there are no requests in the corresponding buffer.
> +	 */
> +	if (to_hv_vcpu(vcpu))
> +		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +
>  	/*
>  	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
>  	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
> @@ -5997,6 +6008,11 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>  		 * Handle L2's bus locks in L0 directly.
>  		 */
>  		return true;
> +	case EXIT_REASON_VMCALL:
> +		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
> +		return kvm_hv_l2_tlb_flush_exposed(vcpu) &&
> +			nested_evmcs_l2_tlb_flush_enabled(vcpu) &&
> +			kvm_hv_is_tlb_flush_hcall(vcpu);
>  	default:
>  		break;
>  	}



Looks good,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

