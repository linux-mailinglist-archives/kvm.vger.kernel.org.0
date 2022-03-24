Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06094E6632
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 16:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbiCXPmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 11:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242256AbiCXPmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 11:42:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14504A1444
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 08:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648136433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QByLZV/xQidMU0lNxdw0ftNq4EpASOAjZu6w5lmb7uM=;
        b=UqElxzT/QahLYHNRck3L2cRi7cBn4AmtYkmrGzJmHMRF7Qa4NDMafF0K1XrNgHQDcePexN
        p2owNFZA0ZQgJFDRAYiZMapXZomJGz+tgcZ7/cEaOgKDNvYsC6ZGT6hs1JmqXPLaJ7bp5w
        5wHEmF6OVKk75wm7hgl0AwFspOaNlT8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-w3chLnp6PVCqOzMcvnjA0A-1; Thu, 24 Mar 2022 11:40:28 -0400
X-MC-Unique: w3chLnp6PVCqOzMcvnjA0A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64B7638008A1;
        Thu, 24 Mar 2022 15:40:27 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29BE640D296C;
        Thu, 24 Mar 2022 15:40:24 +0000 (UTC)
Message-ID: <d7a536300644697a2fae8278c5f37dedeba9e02d.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 10/12] KVM: SVM: Introduce helper functions to
 (de)activate AVIC and x2AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com,
        kernel test robot <lkp@intel.com>
Date:   Thu, 24 Mar 2022 17:40:24 +0200
In-Reply-To: <20220308163926.563994-11-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-11-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
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
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  1 +
>  arch/x86/kvm/svm/avic.c    | 48 ++++++++++++++++++++++++++++++++++----
>  2 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 681a348a9365..f5337022104d 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -248,6 +248,7 @@ enum avic_ipi_failure_cause {
>  	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
>  };
>  
> +#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
>  
>  /*
>   * For AVIC, the max index allowed for physical APIC ID
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 53559b8dfa52..b8d6bf6b6ed5 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -66,6 +66,45 @@ struct amd_svm_iommu_ir {
>  	void *data;		/* Storing pointer to struct amd_ir_data */
>  };
>  
> +static inline void avic_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable)
> +{
> +	int i;
> +
> +	for (i = 0x800; i <= 0x8ff; i++)
> +		set_msr_interception(&svm->vcpu, svm->msrpm, i,
> +				     !disable, !disable);
> +}
> +
> +static void avic_activate_vmcb(struct vcpu_svm *svm)
> +{
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
> +
> +	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
> +	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;

This looks a bit better, I don't 100% like this but let it be.

Honestly I will eventualy add code to calculate and update this maximum
dynamically to avoid wasting microcode going over the whole table,
or worse having nested avic code doing so.


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
Makes sense.


>  
>  /* Note:
>   * This function is called from IOMMU driver to notify
> @@ -183,13 +222,12 @@ void avic_init_vmcb(struct vcpu_svm *svm)
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
> @@ -703,9 +741,9 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  		 * accordingly before re-activating.
>  		 */
>  		avic_post_state_restore(vcpu);
> -		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
> +		avic_activate_vmcb(svm);
>  	} else {
> -		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
> +		avic_deactivate_vmcb(svm);
>  	}
>  	vmcb_mark_dirty(vmcb, VMCB_AVIC);
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

