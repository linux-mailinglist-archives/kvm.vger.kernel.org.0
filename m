Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E69551F994
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 12:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiEIKUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 06:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiEIKTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 06:19:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7ADE41595AF
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 03:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652091328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cIlYceoGUlRkCnVhaNdl+IfkGyfDgIQrc1UyaqSaPTA=;
        b=gysKelpowknPKrnm/EUwRYgXvaLnY/5pOW2FUC3K5yXxNNZCE6xBHlvsKFsPl17EXyJIzV
        26e3duqZt625ExrUepOMfx8EmKcVaICnXyVvifWkR4NipZaujOwz92vMoLnOd6bgwMJ5fS
        n58K4ZmGBzf06tbtMrwcYDefbxf6u4Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-LdWr4RNgObO1BxEpDfuDYw-1; Mon, 09 May 2022 06:15:24 -0400
X-MC-Unique: LdWr4RNgObO1BxEpDfuDYw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2E5F811E75;
        Mon,  9 May 2022 10:15:23 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E1E12166B2F;
        Mon,  9 May 2022 10:15:21 +0000 (UTC)
Message-ID: <777656422ff13a74f97e12f55959bf4bed6c4f19.camel@redhat.com>
Subject: Re: [PATCH v4 03/15] KVM: SVM: Detect X2APIC virtualization
 (x2AVIC) support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 09 May 2022 13:15:20 +0300
In-Reply-To: <20220508023930.12881-4-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
         <20220508023930.12881-4-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-05-07 at 21:39 -0500, Suravee Suthikulpanit wrote:
> Add CPUID check for the x2APIC virtualization (x2AVIC) feature.
> If available, the SVM driver can support both AVIC and x2AVIC modes
> when load the kvm_amd driver with avic=1. The operating mode will be
> determined at runtime depending on the guest APIC mode.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  3 +++
>  arch/x86/kvm/svm/avic.c    | 51 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c     | 15 ++---------
>  arch/x86/kvm/svm/svm.h     |  1 +
>  4 files changed, 57 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index f70a5108d464..2c2a104b777e 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -195,6 +195,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define AVIC_ENABLE_SHIFT 31
>  #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
>  
> +#define X2APIC_MODE_SHIFT 30
> +#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
> +
>  #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
>  #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
>  
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a8f514212b87..95006bbdf970 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -40,6 +40,15 @@
>  #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
>  #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
>  
> +enum avic_modes {
> +	AVIC_MODE_NONE = 0,
> +	AVIC_MODE_X1,
> +	AVIC_MODE_X2,
> +};
> +
> +static bool force_avic;
> +module_param_unsafe(force_avic, bool, 0444);
> +
>  /* Note:
>   * This hash table is used to map VM_ID to a struct kvm_svm,
>   * when handling AMD IOMMU GALOG notification to schedule in
> @@ -50,6 +59,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>  static u32 next_vm_id = 0;
>  static bool next_vm_id_wrapped = 0;
>  static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
> +static enum avic_modes avic_mode;
>  
>  /*
>   * This is a wrapper of struct amd_iommu_ir_data.
> @@ -1077,3 +1087,44 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  
>  	avic_vcpu_load(vcpu);
>  }
> +
> +/*
> + * Note:
> + * - The module param avic enable both xAPIC and x2APIC mode.
> + * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
> + * - The mode can be switched at run-time.
> + */
> +bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	if (!npt_enabled)
> +		return false;
> +
> +	if (boot_cpu_has(X86_FEATURE_AVIC)) {
> +		avic_mode = AVIC_MODE_X1;
> +		pr_info("AVIC enabled\n");
> +	} else if (force_avic) {
> +		/*
> +		 * Some older systems does not advertise AVIC support.
> +		 * See Revision Guide for specific AMD processor for more detail.
> +		 */
> +		avic_mode = AVIC_MODE_X1;
> +		pr_warn("AVIC is not supported in CPUID but force enabled");
> +		pr_warn("Your system might crash and burn");
> +	}
> +
> +	/* AVIC is a prerequisite for x2AVIC. */
> +	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> +		if (avic_mode == AVIC_MODE_X1) {
> +			avic_mode = AVIC_MODE_X2;
> +			pr_info("x2AVIC enabled\n");
> +		} else {
> +			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
> +			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
> +		}
> +	}
> +
> +	if (avic_mode != AVIC_MODE_NONE)
> +		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> +
> +	return !!avic_mode;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3b49337998ec..74e6f86f5dc3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -188,9 +188,6 @@ module_param(tsc_scaling, int, 0444);
>  static bool avic;
>  module_param(avic, bool, 0444);
>  
> -static bool force_avic;
> -module_param_unsafe(force_avic, bool, 0444);
> -
>  bool __read_mostly dump_invalid_vmcb;
>  module_param(dump_invalid_vmcb, bool, 0644);
>  
> @@ -4913,17 +4910,9 @@ static __init int svm_hardware_setup(void)
>  			nrips = false;
>  	}
>  
> -	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
> +	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
>  
> -	if (enable_apicv) {
> -		if (!boot_cpu_has(X86_FEATURE_AVIC)) {
> -			pr_warn("AVIC is not supported in CPUID but force enabled");
> -			pr_warn("Your system might crash and burn");
> -		} else
> -			pr_info("AVIC enabled\n");
> -
> -		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> -	} else {
> +	if (!enable_apicv) {
>  		svm_x86_ops.vcpu_blocking = NULL;
>  		svm_x86_ops.vcpu_unblocking = NULL;
>  		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 32220a1b0ea2..678fc7757fe4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -603,6 +603,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>  
>  /* avic.c */
>  
> +bool avic_hardware_setup(struct kvm_x86_ops *ops);
>  int avic_ga_log_notifier(u32 ga_tag);
>  void avic_vm_destroy(struct kvm *kvm);
>  int avic_vm_init(struct kvm *kvm);

Looks great!

Best regars,
	Maxim Levitsky

