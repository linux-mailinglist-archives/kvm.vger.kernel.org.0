Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D76D5231C8
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbiEKLdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiEKLdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:33:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89E2263BF4
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tcSSPfl7VNm7diA5M0A+FZU0bpKbq549H5tEvNoL3ko=;
        b=FHwdTUpe3NMSxWuqlUXv8o+oVnLfsi4PReGYb4voY+FMSya4UTs3L12Q36Cp3+Jv2WGbaz
        vDhubBCXYADCsnr3V7XK5R+1UtVciWAa82AstvatGRbMeDfBEh2Jq9AAgHRLkxqyrGlTVO
        jw7vSjjUhC4Hi0b6HMZXsspWfsOi77Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-JnL40nmCPZKCIMF0yrK4uQ-1; Wed, 11 May 2022 07:32:56 -0400
X-MC-Unique: JnL40nmCPZKCIMF0yrK4uQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C9B780B91A;
        Wed, 11 May 2022 11:32:55 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28AE640CF8E4;
        Wed, 11 May 2022 11:32:52 +0000 (UTC)
Message-ID: <deae695da02d7f22dcfa4635eec53ab61baf9026.camel@redhat.com>
Subject: Re: [PATCH v3 14/34] KVM: x86: Introduce .post_hv_l2_tlb_flush()
 nested hook
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:32:52 +0300
In-Reply-To: <20220414132013.1588929-15-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-15-vkuznets@redhat.com>
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
> Hyper-V supports injecting synthetic L2->L1 exit after performing
> L2 TLB flush operation but the procedure is vendor specific.
> Introduce .post_hv_l2_tlb_flush() nested hook for it.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/Makefile           |  3 ++-
>  arch/x86/kvm/svm/hyperv.c       | 11 +++++++++++
>  arch/x86/kvm/svm/hyperv.h       |  2 ++
>  arch/x86/kvm/svm/nested.c       |  1 +
>  arch/x86/kvm/vmx/evmcs.c        |  4 ++++
>  arch/x86/kvm/vmx/evmcs.h        |  1 +
>  arch/x86/kvm/vmx/nested.c       |  1 +
>  8 files changed, 23 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kvm/svm/hyperv.c
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8b2a52bf26c0..ce62fde5f4ff 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1558,6 +1558,7 @@ struct kvm_x86_nested_ops {
>  	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
>  			    uint16_t *vmcs_version);
>  	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
> +	void (*post_hv_l2_tlb_flush)(struct kvm_vcpu *vcpu);
>  };
>  
>  struct kvm_x86_init_ops {
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 30f244b64523..b6d53b045692 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -25,7 +25,8 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>  			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
>  
> -kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
> +kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
> +			   svm/sev.o svm/hyperv.o
>  
>  ifdef CONFIG_HYPERV
>  kvm-amd-y		+= svm/svm_onhyperv.o
> diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
> new file mode 100644
> index 000000000000..c0749fc282fe
> --- /dev/null
> +++ b/arch/x86/kvm/svm/hyperv.c
> @@ -0,0 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * AMD SVM specific code for Hyper-V on KVM.
> + *
> + * Copyright 2022 Red Hat, Inc. and/or its affiliates.
> + */
> +#include "hyperv.h"
> +
> +void svm_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu)
> +{
> +}
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index 8cf702fed7e5..a2b0d7580b0d 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -48,4 +48,6 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>  	hv_vcpu->nested.vp_id = hve->hv_vp_id;
>  }
>  
> +void svm_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 2d1a76343404..de3f27301b5c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1665,4 +1665,5 @@ struct kvm_x86_nested_ops svm_nested_ops = {
>  	.get_nested_state_pages = svm_get_nested_state_pages,
>  	.get_state = svm_get_nested_state,
>  	.set_state = svm_set_nested_state,
> +	.post_hv_l2_tlb_flush = svm_post_hv_l2_tlb_flush,
>  };
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 87e3dc10edf4..e390e67496df 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -437,3 +437,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  
>  	return 0;
>  }
> +
> +void vmx_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu)
> +{
> +}
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 8d70f9aea94b..b120b0ead4f3 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -244,5 +244,6 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  			uint16_t *vmcs_version);
>  void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
>  int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
> +void vmx_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu);
>  
>  #endif /* __KVM_X86_VMX_EVMCS_H */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ee88921c6156..cc6c944b5815 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6850,4 +6850,5 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
>  	.write_log_dirty = nested_vmx_write_pml_buffer,
>  	.enable_evmcs = nested_enable_evmcs,
>  	.get_evmcs_version = nested_get_evmcs_version,
> +	.post_hv_l2_tlb_flush = vmx_post_hv_l2_tlb_flush,
>  };


I think that the name of the function is misleading, since it is not called
after each L2 HV tlb flush, but only after a flush which needs to inject
that synthetic VM exit.

I think something like 'inject_synthetic_l2_hv_tlb_flush_vmexit' 
(not a good name IMHO, but you get the idea) would be better.

Best regards,
	Maxim Levitsky



