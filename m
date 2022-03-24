Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400464E61FE
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 11:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344801AbiCXKzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 06:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243846AbiCXKzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 06:55:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4B5FFD06
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 03:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648119225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YL0ux8ZP7RRT+zZTE0y7IJkuSOvClsy9Ez3fBXBZARI=;
        b=PhqwZstNJnWh3lpzheicwZT48u7RXeTy58AC4wh0kj94dJIs3xNZQFKjyp51c50lBWBMT0
        uiT+OhgwfWmE4eV1+VVKVGftg3FgFCJH/iUaOzJIYPVLrw2hEVwKDetzM+3ME2f8TWO3HV
        ja0F5ZeE4oFmq+vKDOhKowytP98lpsU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-ON-5c832NjyDq7O6SBEAZQ-1; Thu, 24 Mar 2022 06:53:41 -0400
X-MC-Unique: ON-5c832NjyDq7O6SBEAZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61A55296A60B;
        Thu, 24 Mar 2022 10:53:41 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01F1F9E60;
        Thu, 24 Mar 2022 10:53:38 +0000 (UTC)
Message-ID: <331ce3b91d8ac2033f23a77b17c86e687c2646ce.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 03/12] KVM: SVM: Detect X2APIC virtualization
 (x2AVIC) support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Mar 2022 12:53:37 +0200
In-Reply-To: <20220308163926.563994-4-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-4-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
> Add CPUID check for the x2APIC virtualization (x2AVIC) feature.
> If available, the SVM driver can support both AVIC and x2AVIC modes
> when load the kvm_amd driver with avic=1. The operating mode will be
> determined at runtime depending on the guest APIC mode.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  3 +++
>  arch/x86/kvm/svm/avic.c    | 34 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c     |  8 ++------
>  arch/x86/kvm/svm/svm.h     |  1 +
>  4 files changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 7eb2df5417fb..7a7a2297165b 100644
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
> index 60cd346acd1c..49b185f0d42e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -40,6 +40,12 @@
>  #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
>  #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
>  
> +enum avic_modes {
> +	AVIC_MODE_NONE = 0,
> +	AVIC_MODE_X1,
> +	AVIC_MODE_X2,
> +};
> +
>  /* Note:
>   * This hash table is used to map VM_ID to a struct kvm_svm,
>   * when handling AMD IOMMU GALOG notification to schedule in
> @@ -50,6 +56,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>  static u32 next_vm_id = 0;
>  static bool next_vm_id_wrapped = 0;
>  static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
> +static enum avic_modes avic_mode;
>  
>  /*
>   * This is a wrapper of struct amd_iommu_ir_data.
> @@ -1014,3 +1021,30 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  
>  	put_cpu();
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
> +	}
> +
> +	if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> +		avic_mode = AVIC_MODE_X2;
> +		pr_info("x2AVIC enabled\n");
> +	}
> +
> +	if (avic_mode != AVIC_MODE_NONE)
> +		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> +
> +	return !!avic_mode;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 821edf664e7a..3048f4b758d6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4817,13 +4817,9 @@ static __init int svm_hardware_setup(void)
>  			nrips = false;
>  	}
>  
> -	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
> +	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
>  
> -	if (enable_apicv) {
> -		pr_info("AVIC enabled\n");
> -
> -		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> -	} else {
> +	if (!enable_apicv) {
>  		svm_x86_ops.vcpu_blocking = NULL;
>  		svm_x86_ops.vcpu_unblocking = NULL;
>  	}
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index fa98d6844728..b53c83a44ec2 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -558,6 +558,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>  
>  /* avic.c */
>  
> +bool avic_hardware_setup(struct kvm_x86_ops *ops);
>  int avic_ga_log_notifier(u32 ga_tag);
>  void avic_vm_destroy(struct kvm *kvm);
>  int avic_vm_init(struct kvm *kvm);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

