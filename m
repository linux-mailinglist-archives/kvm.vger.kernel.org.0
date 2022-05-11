Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952875231CF
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbiEKLeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiEKLeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:34:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BA5A41322
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAMoYFHBoif19/LCt+zZ4I/wxVwYh0umbjCqfUO0Uys=;
        b=CAZHvJi4dwCkq29Etf/tzeCn32PrvQhlqENqaw86DHq+m/vDZmKrrjL811wIExDukHpvJq
        aPL0TXFfsTY31fJkoiz64mn2F0prw9rDAXaUpAH4ePXqiqs/9zCFG6OCsHieMcrKj+mO7R
        BKsoaS6EMkgh3ycYDygYXLOQDC56aeE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-c06PDqn9MVKVrE0-IjmS-g-1; Wed, 11 May 2022 07:33:57 -0400
X-MC-Unique: c06PDqn9MVKVrE0-IjmS-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 736531C01B27;
        Wed, 11 May 2022 11:33:56 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F55240CF8E4;
        Wed, 11 May 2022 11:33:54 +0000 (UTC)
Message-ID: <0cbef2ca32145857b209a81ad82a99479ade5f6c.camel@redhat.com>
Subject: Re: [PATCH v3 21/34] KVM: nSVM: hyper-v: Enable L2 TLB flush
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:33:53 +0300
In-Reply-To: <20220414132013.1588929-22-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-22-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> Implement Hyper-V L2 TLB flush for nSVM. The feature needs to be enabled
> both in extended 'nested controls' in VMCB and partition assist page.
> According to Hyper-V TLFS, synthetic vmexit to L1 is performed with
> - HV_SVM_EXITCODE_ENL exit_code.
> - HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH exit_info_1.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/hyperv.c |  7 +++++++
>  arch/x86/kvm/svm/hyperv.h | 19 +++++++++++++++++++
>  arch/x86/kvm/svm/nested.c | 22 +++++++++++++++++++++-
>  3 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
> index c0749fc282fe..3842548bb88c 100644
> --- a/arch/x86/kvm/svm/hyperv.c
> +++ b/arch/x86/kvm/svm/hyperv.c
> @@ -8,4 +8,11 @@
>  
>  void svm_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	svm->vmcb->control.exit_code = HV_SVM_EXITCODE_ENL;
> +	svm->vmcb->control.exit_code_hi = 0;
> +	svm->vmcb->control.exit_info_1 = HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH;
> +	svm->vmcb->control.exit_info_2 = 0;
> +	nested_svm_vmexit(svm);
>  }
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index a2b0d7580b0d..cd33e89f9f61 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -33,6 +33,9 @@ struct hv_enlightenments {
>   */
>  #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
>  
> +#define HV_SVM_EXITCODE_ENL 0xF0000000
> +#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH   (1)
> +
>  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -48,6 +51,22 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>  	hv_vcpu->nested.vp_id = hve->hv_vp_id;
>  }
>  
> +static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct hv_enlightenments *hve =
> +		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
> +	struct hv_vp_assist_page assist_page;
> +
> +	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
> +		return false;
> +
> +	if (!hve->hv_enlightenments_control.nested_flush_hypercall)
> +		return false;
> +
> +	return assist_page.nested_control.features.directhypercall;
> +}
> +
>  void svm_post_hv_l2_tlb_flush(struct kvm_vcpu *vcpu);
>  
>  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de3f27301b5c..a6d9807c09b1 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -172,7 +172,8 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  	}
>  
>  	/* We don't want to see VMMCALLs from a nested guest */

Minor nitpick: Maybe update the comment?


> -	vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
> +	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
> +		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
>  
>  	for (i = 0; i < MAX_INTERCEPT; i++)
>  		c->intercepts[i] |= g->intercepts[i];
> @@ -488,6 +489,17 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
>  
>  static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>  {
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
>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>  	 * things to fix before this can be conditional:
> @@ -1357,6 +1369,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>  int nested_svm_exit_special(struct vcpu_svm *svm)
>  {
>  	u32 exit_code = svm->vmcb->control.exit_code;
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>  
>  	switch (exit_code) {
>  	case SVM_EXIT_INTR:
> @@ -1375,6 +1388,13 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
>  			return NESTED_EXIT_HOST;
>  		break;
>  	}
> +	case SVM_EXIT_VMMCALL:
> +		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
> +		if (kvm_hv_l2_tlb_flush_exposed(vcpu) &&
> +		    nested_svm_l2_tlb_flush_enabled(vcpu) &&
> +		    kvm_hv_is_tlb_flush_hcall(vcpu))
> +			return NESTED_EXIT_HOST;
> +		break;
>  	default:
>  		break;
>  	}


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


