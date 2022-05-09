Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9B51FE97
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 15:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbiEINrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 09:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbiEINrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 09:47:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22A852689D5
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 06:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652103788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFbwZW49pkw4yye95MvglQVhO0vrHkh9u5V8p01SIsk=;
        b=AKxH8cioyOk1Uo/jhqGfJK65KL0dopEPmfXEKMPj4B/BJ7ip1LJrenDGY0GGAsOFtoCkOj
        cOEJC857c8JezCcMybauMzgjwQnzhRzzcbl9jBqMHtyoaIIdbbbHm3dn4xklF4TrJ+neuP
        1ye1A7E7JSrrDf+Cjelv7EfMvbjdSxs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-gJZrXA4sNPqjqkKLdKWf8A-1; Mon, 09 May 2022 09:43:03 -0400
X-MC-Unique: gJZrXA4sNPqjqkKLdKWf8A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F37A01C161D6;
        Mon,  9 May 2022 13:42:44 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B72D463E15;
        Mon,  9 May 2022 13:42:41 +0000 (UTC)
Message-ID: <a60d885cf4b0b11aca730273ff317546362bff83.camel@redhat.com>
Subject: Re: [PATCH v4 10/15] KVM: SVM: Introduce helper functions to
 (de)activate AVIC and x2AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com,
        kernel test robot <lkp@intel.com>
Date:   Mon, 09 May 2022 16:42:41 +0300
In-Reply-To: <20220508023930.12881-11-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
         <20220508023930.12881-11-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
> Refactor the current logic for (de)activate AVIC into helper functions,
> and also add logic for (de)activate x2AVIC. The helper function are used
> when initializing AVIC and switching from AVIC to x2AVIC mode
> (handled by svm_refresh_spicv_exec_ctrl()).
> 
> When an AVIC-enabled guest switches from APIC to x2APIC mode during
> runtime, the SVM driver needs to perform the following steps:
> 
> 1. Set the x2APIC mode bit for AVIC in VMCB along with the maximum
> APIC ID support for each mode accodingly.
> 
> 2. Disable x2APIC MSRs interception in order to allow the hardware
> to virtualize x2APIC MSRs accesses.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  6 +++++
>  arch/x86/kvm/svm/avic.c    | 54 ++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/svm/svm.c     |  6 ++---
>  arch/x86/kvm/svm/svm.h     |  1 +
>  4 files changed, 58 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 4c26b0d47d76..f5525c0e03f7 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -256,6 +256,7 @@ enum avic_ipi_failure_cause {
>  	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
>  };
>  
> +#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
>  
>  /*
>   * For AVIC, the max index allowed for physical APIC ID
> @@ -500,4 +501,9 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
>  DEFINE_GHCB_ACCESSORS(sw_scratch)
>  DEFINE_GHCB_ACCESSORS(xcr0)
>  
> +struct svm_direct_access_msrs {
> +	u32 index;   /* Index of the MSR */
> +	bool always; /* True if intercept is initially cleared */
> +};
> +
>  #endif
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a82981722018..ad2ef6c00559 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -69,6 +69,51 @@ struct amd_svm_iommu_ir {
>  	void *data;		/* Storing pointer to struct amd_ir_data */
>  };
>  
> +static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
> +		int index = direct_access_msrs[i].index;
> +
> +		if ((index < APIC_BASE_MSR) ||
> +		    (index > APIC_BASE_MSR + 0xff))
> +			continue;
> +		set_msr_interception(&svm->vcpu, svm->msrpm, index,
> +				     !disable, !disable);
> +	}
> +}
> +
> +static void avic_activate_vmcb(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
> +
> +	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
> +	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
> +
> +	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> +	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
> +		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> +		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
> +		/* Disabling MSR intercept for x2APIC registers */
> +		avic_set_x2apic_msr_interception(svm, false);
> +	} else {
> +		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
> +		/* Enabling MSR intercept for x2APIC registers */
> +		avic_set_x2apic_msr_interception(svm, true);
> +	}
> +}
> +
> +static void avic_deactivate_vmcb(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
> +
> +	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
> +	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
> +
> +	/* Enabling MSR intercept for x2APIC registers */
> +	avic_set_x2apic_msr_interception(svm, true);
> +}
>  
>  /* Note:
>   * This function is called from IOMMU driver to notify
> @@ -185,13 +230,12 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>  	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
>  	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
>  	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
> -	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>  	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
>  
>  	if (kvm_apicv_activated(svm->vcpu.kvm))
> -		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> +		avic_activate_vmcb(svm);
>  	else
> -		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
> +		avic_deactivate_vmcb(svm);
>  }
>  
>  static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
> @@ -1082,9 +1126,9 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  		 * accordingly before re-activating.
>  		 */
>  		avic_apicv_post_state_restore(vcpu);
> -		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> +		avic_activate_vmcb(svm);
>  	} else {
> -		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
> +		avic_deactivate_vmcb(svm);
>  	}
>  	vmcb_mark_dirty(vmcb, VMCB_AVIC);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9066568fd19d..96a1fc1a1d1b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -74,10 +74,8 @@ static uint64_t osvw_len = 4, osvw_status;
>  
>  static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  
> -static const struct svm_direct_access_msrs {
> -	u32 index;   /* Index of the MSR */
> -	bool always; /* True if intercept is initially cleared */
> -} direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
> +const struct svm_direct_access_msrs
> +direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
>  	{ .index = MSR_STAR,				.always = true  },
>  	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
>  	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5ed958863b81..bb5bf70de3b2 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -600,6 +600,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
>  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
>  
>  extern struct kvm_x86_nested_ops svm_nested_ops;
> +extern const struct svm_direct_access_msrs direct_access_msrs[];
>  
>  /* avic.c */
>  


So I did some testing, and reviewed this code again with regard to nesting, 
and now I see that it has CVE worthy bug, so have to revoke my Reviewed-By.

This is what happens:

On nested VM entry, *request to inhibit AVIC is done*, and then nested msr bitmap
is calculated, still with all X2AVIC msrs open,

1. nested_svm_vmrun -> enter_svm_guest_mode -> kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
2. nested_svm_vmrun -> nested_svm_vmrun_msrpm


But the nested guest will be entered without AVIC active 
(since we don't yet support nested avic and it is optional anyway), thus if the nested guest
also doesn't intercept those msrs, it will gain access to the *host* x2apic msrs. Ooops.

I think the easist way to fix this for now, is to make nested_svm_vmrun_msrpm
never open access to x2apic msrs regardless of the host bitmap value, but in the long
term the whole thing needs to be refactored.


Another thing I noted is that avic_deactivate_vmcb should not touch avic msrs
when avic_mode == AVIC_MODE_X1, it is just a waste of time.

Also updating these msr intercepts is pointless if the guest doesn't use x2apic.

Same it true while entering the nested guest - AVIC is inhibited, but there is
no need to update the msr intercepts in L1 msr bitmap, since this bitmap isn't
used by the CPU and vise versa while returing back to L1 from the nested guest.

However optimizing all of this should also be done very carefully to 
avoid issue like the above.

I need to think on how to correctly fix/refactor all of this to be honest.

Best regards,
	Maxim levitsky



