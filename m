Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F02C5A7A52
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 11:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiHaJga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 05:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiHaJg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 05:36:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE28C58EE
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 02:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661938585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QljZ7z6HeWb0S3Z39VK4YcMBFACsSSFELwH1GoELfgU=;
        b=CN9yZIwogqbCtvpOBHyln8+ivuepFkasYjFOQnIETxNJjsPLOTJK95h2+r/09KB7KGQF6m
        LYd67Xmro/DY2vs4jS3QhrxsGSqiFIRt9Blnwq2Mi3PDc46ZscD5GmEKXvRHhMoefPumEj
        b118kQdyY0B1dXU97tjp2cWeC047g2M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-z1OTp_fvN8WKli-jvgzgGQ-1; Wed, 31 Aug 2022 05:36:21 -0400
X-MC-Unique: z1OTp_fvN8WKli-jvgzgGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42653101A588;
        Wed, 31 Aug 2022 09:36:21 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FE392166B26;
        Wed, 31 Aug 2022 09:36:19 +0000 (UTC)
Message-ID: <145980687a0fd85b783f8fd1412ee843e7c124e2.camel@redhat.com>
Subject: Re: [PATCH 04/19] KVM: SVM: Replace "avic_mode" enum with
 "x2avic_enabled" boolean
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 12:36:18 +0300
In-Reply-To: <20220831003506.4117148-5-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Replace the "avic_mode" enum with a single bool to track whether or not
> x2AVIC is enabled.  KVM already has "apicv_enabled" that tracks if any
> flavor of AVIC is enabled, i.e. AVIC_MODE_NONE and AVIC_MODE_X1 are
> redundant and unnecessary noise.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 45 +++++++++++++++++++----------------------
>  arch/x86/kvm/svm/svm.c  |  2 +-
>  arch/x86/kvm/svm/svm.h  |  9 +--------
>  3 files changed, 23 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 1d516d658f9a..b59f8ee2671f 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -53,7 +53,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>  static u32 next_vm_id = 0;
>  static bool next_vm_id_wrapped = 0;
>  static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
> -enum avic_modes avic_mode;
> +bool x2avic_enabled;
>  
>  /*
>   * This is a wrapper of struct amd_iommu_ir_data.
> @@ -231,8 +231,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>  	u64 *avic_physical_id_table;
>  	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>  
> -	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
> -	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
> +	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
> +	    (index > X2AVIC_MAX_PHYSICAL_ID))
>  		return NULL;
>  
>  	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
> @@ -279,8 +279,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	int id = vcpu->vcpu_id;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
> -	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
> +	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
> +	    (id > X2AVIC_MAX_PHYSICAL_ID))
>  		return -EINVAL;
>  
>  	if (!vcpu->arch.apic->regs)
> @@ -532,7 +532,7 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
>  	 * AVIC must be disabled if x2AVIC isn't supported and the guest has
>  	 * x2APIC enabled.
>  	 */
> -	if (avic_mode != AVIC_MODE_X2 && apic_x2apic_mode(vcpu->arch.apic))
> +	if (!x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))
>  		return APICV_INHIBIT_REASON_X2APIC;
>  
>  	return 0;
> @@ -1086,10 +1086,7 @@ void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
>  
> -	if (!lapic_in_kernel(vcpu) || avic_mode == AVIC_MODE_NONE)
> -		return;
> -
> -	if (!enable_apicv)
> +	if (!lapic_in_kernel(vcpu) || !enable_apicv)
>  		return;
>  
>  	if (kvm_vcpu_apicv_active(vcpu)) {
> @@ -1165,32 +1162,32 @@ bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
>  	if (!npt_enabled)
>  		return false;
>  
> +	/* AVIC is a prerequisite for x2AVIC. */
> +	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
> +		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> +			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
> +			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
> +		}
> +		return false;
> +	}
> +
>  	if (boot_cpu_has(X86_FEATURE_AVIC)) {
> -		avic_mode = AVIC_MODE_X1;
>  		pr_info("AVIC enabled\n");
>  	} else if (force_avic) {
>  		/*
>  		 * Some older systems does not advertise AVIC support.
>  		 * See Revision Guide for specific AMD processor for more detail.
>  		 */
> -		avic_mode = AVIC_MODE_X1;
>  		pr_warn("AVIC is not supported in CPUID but force enabled");
>  		pr_warn("Your system might crash and burn");
>  	}
>  
>  	/* AVIC is a prerequisite for x2AVIC. */
> -	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> -		if (avic_mode == AVIC_MODE_X1) {
> -			avic_mode = AVIC_MODE_X2;
> -			pr_info("x2AVIC enabled\n");
> -		} else {
> -			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
> -			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
> -		}
> -	}
> +	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
> +	if (x2avic_enabled)
> +		pr_info("x2AVIC enabled\n");
>  
> -	if (avic_mode != AVIC_MODE_NONE)
> -		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> +	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>  
> -	return !!avic_mode;
> +	return true;
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f3813dbacb9f..b25c89069128 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -821,7 +821,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
>  	if (intercept == svm->x2avic_msrs_intercepted)
>  		return;
>  
> -	if (avic_mode != AVIC_MODE_X2 ||
> +	if (!x2avic_enabled ||
>  	    !apic_x2apic_mode(svm->vcpu.arch.apic))
>  		return;
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6a7686bf6900..cee79ade400a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -35,14 +35,7 @@ extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
>  extern int vgif;
>  extern bool intercept_smi;
> -
> -enum avic_modes {
> -	AVIC_MODE_NONE = 0,
> -	AVIC_MODE_X1,
> -	AVIC_MODE_X2,
> -};
> -
> -extern enum avic_modes avic_mode;
> +extern bool x2avic_enabled;
>  
>  /*
>   * Clean bits in VMCB.

Overall looks like an improvement, I would probably do it this way if I were to
implement this code, but the original code is alright as well.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

