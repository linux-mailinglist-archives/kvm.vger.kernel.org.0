Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7B44C3247
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 17:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiBXQzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 11:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiBXQzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 11:55:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E628025D6
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645721713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fjhQNIhph84bfsMFxiUxBEgb36uPYbCGqR8imgof9OE=;
        b=HqU1Wu8h8V7bb1bVGXzJugMFeNP+1GsiKUFlb/6v2YwdNHpw/RfH0wo7cGgr1sKfC957t2
        xGRbx1grjksnLLj3Dw5s8OUeTKP0SEG+8IP06cx3NkAsriiX6mMiYwAoEZcsayLZqwyS7m
        QsSo+BlTPOCxaRnr6s6CxtIfpdXMidQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-53Mptq0NM5iNaH6eGbcKEg-1; Thu, 24 Feb 2022 11:55:09 -0500
X-MC-Unique: 53Mptq0NM5iNaH6eGbcKEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41C77100C609;
        Thu, 24 Feb 2022 16:55:08 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36D0A804DC;
        Thu, 24 Feb 2022 16:54:58 +0000 (UTC)
Message-ID: <dc820a37ef302ed7c11315c01c6f434d5506c543.camel@redhat.com>
Subject: Re: [RFC PATCH 04/13] KVM: SVM: Only call vcpu_(un)blocking when
 AVIC is enabled.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 18:54:58 +0200
In-Reply-To: <20220221021922.733373-5-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-5-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> The kvm_x86_ops.vcpu_(un)blocking are needed by AVIC only.
> Therefore, set the ops only when AVIC is enabled.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 12 ++++++++++--
>  arch/x86/kvm/svm/svm.c  |  7 -------
>  arch/x86/kvm/svm/svm.h  |  2 --
>  3 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index abde08ca23ab..0040824e4376 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -996,7 +996,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>  }
>  
> -void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
> +static void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_vcpu_apicv_active(vcpu))
>  		return;
> @@ -1021,7 +1021,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
>  	preempt_enable();
>  }
>  
> -void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> +static void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  {
>  	int cpu;
>  
> @@ -1057,6 +1057,14 @@ bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
>  		pr_info("x2AVIC enabled\n");
>  	}
>  
> +	if (avic_mode) {
> +		x86_ops->vcpu_blocking = avic_vcpu_blocking;
> +		x86_ops->vcpu_unblocking = avic_vcpu_unblocking;
> +	} else {
> +		x86_ops->vcpu_blocking = NULL;
> +		x86_ops->vcpu_unblocking = NULL;
> +	}
> +
>  	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>  	return !!avic_mode;
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3048f4b758d6..3687026f2859 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4531,8 +4531,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.prepare_guest_switch = svm_prepare_guest_switch,
>  	.vcpu_load = svm_vcpu_load,
>  	.vcpu_put = svm_vcpu_put,
> -	.vcpu_blocking = avic_vcpu_blocking,
> -	.vcpu_unblocking = avic_vcpu_unblocking,
>  
>  	.update_exception_bitmap = svm_update_exception_bitmap,
>  	.get_msr_feature = svm_get_msr_feature,
> @@ -4819,11 +4817,6 @@ static __init int svm_hardware_setup(void)
>  
>  	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
>  
> -	if (!enable_apicv) {
> -		svm_x86_ops.vcpu_blocking = NULL;
> -		svm_x86_ops.vcpu_unblocking = NULL;
> -	}

Isn't this code already zeros these callbacks when avic is not enabled?

I am not sure why this patch is needed to be honest.

Best regards,
	Maxim Levitsky

> -
>  	if (vls) {
>  		if (!npt_enabled ||
>  		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index b53c83a44ec2..1a0bf6b853df 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -578,8 +578,6 @@ void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
>  bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>  		       uint32_t guest_irq, bool set);
> -void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
> -void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  void avic_ring_doorbell(struct kvm_vcpu *vcpu);
>  
>  /* sev.c */


