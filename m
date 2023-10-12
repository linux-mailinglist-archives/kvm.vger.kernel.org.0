Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791207C775D
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 21:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347408AbjJLTwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 15:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442541AbjJLTwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 15:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A681710D
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697140305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RPA/v4uWaduRFB1qGuKaM/NsjJDQS9vCUwih/qNwXiA=;
        b=hLWJv4gWEEDyHH2vs7hrzUrr/EdNu7GffFcopheVugDuRGJ/QAWz7HlIWLzjinytEzx3ed
        qRnlLIvAF15gN5puESZbT7H532g5i2rFrV2F+JFysAIgLLXsGbiWVuExnBa01J7EIrI6H+
        Vao889tgnDWMUvUiX5ezC8VFLJ3Fwew=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-8QGGS_pqNtmYztYZh2QQJQ-1; Thu, 12 Oct 2023 15:51:39 -0400
X-MC-Unique: 8QGGS_pqNtmYztYZh2QQJQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4065478afd3so13094085e9.0
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697140298; x=1697745098;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RPA/v4uWaduRFB1qGuKaM/NsjJDQS9vCUwih/qNwXiA=;
        b=JGD2FRkzGq1W+VkMnOeNlr+5s5EVgR7btYkG0h9IUfUJInUOBuIgAE6LALJFdXkVX7
         M21z2Yq/hfAwAog8/MPHvX+iITE6hjx/CXdUvzoqDXCpr+WwZJOuTKbi0XAQtkVmKZeG
         zaI5jdX5mAoO0cHgMhMsxCtTlqr143xLQ1szd8aPWFl8EX+1/qMZiR+Rxa1XEvWyvYec
         kZE63B8ShAsa4zCoJwvGyaqBz2L+au/oGF/rocNtULjDlWkgYSl/uQK1qL9rj4kVzpfv
         Vbyag8kjo2kyrH9kYzkCnUMgQUHR+zMiugrxr/aJHW62f+4yfJa1pNn8HWVZOgPTRsKE
         EzHQ==
X-Gm-Message-State: AOJu0YwbKidNih6oLRpm2FNsco+XN6FOR2Ho1bVsvf07eSwEiO9OwHL1
        YU0ojn2aLZB1686X5tzPN4FEa+3vXoiq8UxHR/BSO8JWkCNGrWE7nqj2lhRSc2Hyi2irQufIA3G
        5IVElL7Tjupks
X-Received: by 2002:a05:600c:2a4e:b0:406:3f62:e591 with SMTP id x14-20020a05600c2a4e00b004063f62e591mr22759319wme.41.1697140298501;
        Thu, 12 Oct 2023 12:51:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGm5Fjv3pBthpLdfTMuIl1E6In1YGa236ONL6R3j7EhdTdRgwPGNT5O0h+Uhqe4HygW52xBwA==
X-Received: by 2002:a05:600c:2a4e:b0:406:3f62:e591 with SMTP id x14-20020a05600c2a4e00b004063f62e591mr22759308wme.41.1697140298164;
        Thu, 12 Oct 2023 12:51:38 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c248800b004055858e7d8sm659368wms.7.2023.10.12.12.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 12:51:37 -0700 (PDT)
Message-ID: <239535781889c5f541e166dc6c36621c550d82e1.camel@redhat.com>
Subject: Re: [PATCH RFC 11/11] KVM: nSVM: hyper-v: Hide more stuff under
 CONFIG_KVM_HYPERV/CONFIG_HYPERV
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 12 Oct 2023 22:51:36 +0300
In-Reply-To: <20231010160300.1136799-12-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
         <20231010160300.1136799-12-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-10-10 у 18:03 +0200, Vitaly Kuznetsov пише:
> 'struct hv_vmcb_enlightenments' in VMCB only make sense when either
> CONFIG_KVM_HYPERV or CONFIG_HYPERV is enabled.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 20 ++++++++++++++------
>  arch/x86/kvm/svm/svm.h    |  2 ++
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 4d8cd378a30b..5ae41a708005 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -187,7 +187,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
>   */
>  static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  {
> -	struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
>  	int i;
>  
>  	/*
> @@ -198,11 +197,16 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  	 * - Nested hypervisor (L1) is using Hyper-V emulation interface and
>  	 * tells KVM (L0) there were no changes in MSR bitmap for L2.
>  	 */
> -	if (!svm->nested.force_msr_bitmap_recalc &&
> -	    kvm_hv_hypercall_enabled(&svm->vcpu) &&
> -	    hve->hv_enlightenments_control.msr_bitmap &&
> -	    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
> -		goto set_msrpm_base_pa;
> +#ifdef CONFIG_KVM_HYPERV
> +	if (!svm->nested.force_msr_bitmap_recalc) {
> +		struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
> +
> +		if (kvm_hv_hypercall_enabled(&svm->vcpu) &&
> +		    hve->hv_enlightenments_control.msr_bitmap &&
> +		    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
> +			goto set_msrpm_base_pa;
> +	}
> +#endif
>  
>  	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
>  		return true;
> @@ -230,7 +234,9 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  
>  	svm->nested.force_msr_bitmap_recalc = false;
>  
> +#ifdef CONFIG_KVM_HYPERV
>  set_msrpm_base_pa:
> +#endif
>  	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
>  
>  	return true;
> @@ -378,12 +384,14 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	to->msrpm_base_pa &= ~0x0fffULL;
>  	to->iopm_base_pa  &= ~0x0fffULL;
>  
> +#ifdef CONFIG_KVM_HYPERV
>  	/* Hyper-V extensions (Enlightened VMCB) */
>  	if (kvm_hv_hypercall_enabled(vcpu)) {
>  		to->clean = from->clean;
>  		memcpy(&to->hv_enlightenments, &from->hv_enlightenments,
>  		       sizeof(to->hv_enlightenments));
>  	}
> +#endif
>  }
>  
>  void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index be67ab7fdd10..59adff7bbf55 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -148,7 +148,9 @@ struct vmcb_ctrl_area_cached {
>  	u64 virt_ext;
>  	u32 clean;
>  	union {
> +#if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_KVM_HYPERV)
>  		struct hv_vmcb_enlightenments hv_enlightenments;
> +#endif
>  		u8 reserved_sw[32];
>  	};
>  };

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

