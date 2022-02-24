Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64B84C33C0
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiBXRa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiBXRa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:30:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A44B2186BAE
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645723766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOV5EV1UzXliH9U/EzhEDJEFZZoLbZzEL9tR71RF+1A=;
        b=ghaSrUSfFRdcIwofNKVmMdXEQ6pS8N7rBFNlGVjzL0OgIOvf3Wo/hHfA4NJ0jLBnwtSetH
        GJCtyh8Be2u+bKqgde/lJGrIxCEDfTCRKVBH7vfOW8ntLezL9MWvwXQKBXfIdQ9t2vO0Ke
        CNIcEdtYxgp+YPaVtcZLvEHmbDxorO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-Cq01rZ-aOKORCANWokIZVQ-1; Thu, 24 Feb 2022 12:29:21 -0500
X-MC-Unique: Cq01rZ-aOKORCANWokIZVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74E2018766D0;
        Thu, 24 Feb 2022 17:29:19 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E91AF866DD;
        Thu, 24 Feb 2022 17:29:16 +0000 (UTC)
Message-ID: <334aadda53c7837d71e7c9d11b772a4a66b58df3.camel@redhat.com>
Subject: Re: [RFC PATCH 06/13] KVM: SVM: Add logic to determine x2APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 19:29:15 +0200
In-Reply-To: <20220221021922.733373-7-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-7-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> Introduce avic_update_vapic_bar(), which checks the x2APIC enable bit
> of the APIC Base register and update the new struct vcpu_svm.x2apic_enabled
> to keep track of current APIC mode of each vCPU,
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 13 +++++++++++++
>  arch/x86/kvm/svm/svm.c  |  4 ++++
>  arch/x86/kvm/svm/svm.h  |  2 ++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 1999076966fd..60f30e48d816 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -609,6 +609,19 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
>  	avic_handle_ldr_update(vcpu);
>  }
>  
> +void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
> +{
> +	svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
> +
> +	/* Set x2APIC mode bit if guest enable x2apic mode. */
> +	svm->x2apic_enabled = (avic_mode == AVIC_MODE_X2 &&
> +			       kvm_apic_mode(data) == LAPIC_MODE_X2APIC);
> +	pr_debug("vcpu_id:%d switch to %s\n", svm->vcpu.vcpu_id,
> +		 svm->x2apic_enabled ? "x2APIC" : "xAPIC");
> +	vmcb_mark_dirty(svm->vmcb, VMCB_AVIC);
> +	kvm_vcpu_update_apicv(&svm->vcpu);
> +}
> +
>  void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  {
>  	return;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3687026f2859..4e6dc1feeac7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2867,6 +2867,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		svm->msr_decfg = data;
>  		break;
>  	}
> +	case MSR_IA32_APICBASE:
> +		if (kvm_vcpu_apicv_active(vcpu))
> +			avic_update_vapic_bar(to_svm(vcpu), data);
> +		fallthrough;
>  	default:
>  		return kvm_set_msr_common(vcpu, msr);
>  	}
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 1a0bf6b853df..bfbebb933da2 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -225,6 +225,7 @@ struct vcpu_svm {
>  	u32 dfr_reg;
>  	struct page *avic_backing_page;
>  	u64 *avic_physical_id_cache;
> +	bool x2apic_enabled;
>  
>  	/*
>  	 * Per-vcpu list of struct amd_svm_iommu_ir:
> @@ -566,6 +567,7 @@ void avic_init_vmcb(struct vcpu_svm *svm);
>  int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
>  int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
>  int avic_init_vcpu(struct vcpu_svm *svm);
> +void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data);
>  void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  void avic_vcpu_put(struct kvm_vcpu *vcpu);
>  void avic_post_state_restore(struct kvm_vcpu *vcpu);


Have you looked at how this is done on Intel's APICv side?
You need to implement .set_virtual_apic_mode instead.
(look at vmx_set_virtual_apic_mode)

I also don't think you need x2apic_enabled boolean.
You can already know if a vCPU uses apic or x2apic via

kvm_get_apic_mode(vcpu);

in fact I don't think avic code should have any bookeeping in regard to x2apic/x2avic mode,
but rather kvm's apic mode  (which is read directly from apic base msr (vcpu->arch.apic_base),
should enable avic, or x2avic if possible, or inhibit avic if not possible.

e.g it should drive the bits in vmcb and such.

Best regards,
	Maxim Levitsky

