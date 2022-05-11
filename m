Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DCC523193
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiEKL2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241245AbiEKLZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:25:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D146723EB67
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/sEqT73bKzt/oecFlVhkuotSkLjbj1qvxmmVWvG1EE=;
        b=V9eWN0oLik3M6lT/2pevOsL7bVwfNNAMl2bFTlc2ppgXz9Z2XTigp/S5aIvrpXC9TRY3HM
        BE2hi6ElgMsZ7S7ibxVv+Qfs8NKbiWNc9AlYFfKwH+WzKkijYNtFLAjLFeWBoBmym+6yuv
        IV5b83bskYNIwmtQTbwgKrUmOptdh/0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-bEUIe7wFNqeFCq2JS1bx9g-1; Wed, 11 May 2022 07:25:21 -0400
X-MC-Unique: bEUIe7wFNqeFCq2JS1bx9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5262985A5BC;
        Wed, 11 May 2022 11:25:21 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F26640CF8EB;
        Wed, 11 May 2022 11:25:18 +0000 (UTC)
Message-ID: <22c4fa84b033ecd7a984067a3cb53a20b6c0b269.camel@redhat.com>
Subject: Re: [PATCH v3 12/34] KVM: nVMX: Keep track of hv_vm_id/hv_vp_id
 when eVMCS is in use
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:25:17 +0300
In-Reply-To: <20220414132013.1588929-13-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-13-vkuznets@redhat.com>
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
> To handle L2 TLB flush requests, KVM needs to keep track of L2's VM_ID/
> VP_IDs which are set by L1 hypervisor. 'Partition assist page' address is
> also needed to handle post-flush exit to L1 upon request.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/vmx/nested.c       | 15 +++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 837c07e213de..8b2a52bf26c0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -622,6 +622,12 @@ struct kvm_vcpu_hv {
>  
>  	/* Preallocated buffer for handling hypercalls passing sparse vCPU set */
>  	u64 sparse_banks[64];
> +
> +	struct {
> +		u64 pa_page_gpa;
> +		u64 vm_id;
> +		u32 vp_id;
> +	} nested;
>  };
>  
>  /* Xen HVM per vcpu emulation context */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a6688663da4d..ee88921c6156 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -225,6 +225,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>  
>  static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
>  	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
> @@ -233,6 +234,12 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>  	}
>  
>  	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
> +
> +	if (hv_vcpu) {
> +		hv_vcpu->nested.pa_page_gpa = INVALID_GPA;
> +		hv_vcpu->nested.vm_id = 0;
> +		hv_vcpu->nested.vp_id = 0;
> +	}
>  }
>  
>  static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
> @@ -1591,11 +1598,19 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
>  {
>  	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
>  	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
>  
>  	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
>  	vmcs12->tpr_threshold = evmcs->tpr_threshold;
>  	vmcs12->guest_rip = evmcs->guest_rip;
>  
> +	if (unlikely(!(hv_clean_fields &
> +		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL))) {
> +		hv_vcpu->nested.pa_page_gpa = evmcs->partition_assist_page;
> +		hv_vcpu->nested.vm_id = evmcs->hv_vm_id;
> +		hv_vcpu->nested.vp_id = evmcs->hv_vp_id;
> +	}
> +
>  	if (unlikely(!(hv_clean_fields &
>  		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC))) {
>  		vmcs12->guest_rsp = evmcs->guest_rsp;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

