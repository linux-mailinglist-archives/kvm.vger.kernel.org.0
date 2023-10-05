Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A65C7BA67B
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbjJEQfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbjJEQdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2262830D0
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 06:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696513870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/v0adbAqkr0AOlDohQDmkNPQwTJI1a9Z/VKG7A0hBWA=;
        b=cernl7QoJSFk6+fDGRGwiDsiLOUpqQ+1VwTMp1Y6sG5013Cyth+e1lFrXXtU+bmJznQru4
        LXIuQp/ZPQcCjbI8EY9prwI+T/i3VUed5vduZeZDfU/V2JsV2veribiNVUjXzIiuE3vuR0
        JJ+Bh6fZFOptvJx4iRahqFGiim7LkFo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-M8yInDFyPp6_svWo5uYBvw-1; Thu, 05 Oct 2023 08:50:19 -0400
X-MC-Unique: M8yInDFyPp6_svWo5uYBvw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9ae0bf9c0a9so72085966b.3
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 05:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696510218; x=1697115018;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/v0adbAqkr0AOlDohQDmkNPQwTJI1a9Z/VKG7A0hBWA=;
        b=QYzHUfHjt5qAIQwQxUUrL/Wfgl/rZWa6qQ3/t5j3xdsqgYsALVsiPYMxxU5ucvrKQN
         BNEoXpQmiSgjkTs/G0d8TMDqt/CJV0jDPAjRPaeNkAXHugajKBZOWWUJ5GvHFotFXeg0
         +rZWa5IBNwEXQXQh29h4qHN/tv2/zCNhlyL3/lHimU5wE4KzuglxQOS8HZfSD4eL9yMM
         DYfPSxaDEiFLHBrhaS6/RmV/mCNSuYAdrMBnbcGNtxGKh7KcH1rtS7xIz3BZv2k6VM7j
         RZm4hkGO04z0NiE4FAYiNVGgNZ+yGZXDooQY/26jMpLICkpM8azB1v3oi6ucqDaAFJEF
         91zg==
X-Gm-Message-State: AOJu0Yw25sbiq6Fc8tWRiNL6welGU/HUU3sAVDZU30csTIbrJqPyREsq
        1AybT6/n1mwTHNuUN7dGtf7629TPZRhh6MK9pbcsRuMB8NJ7ugA+Hw0nMONYf0RY32gG+QOBr02
        4RBdUMqJ8czdf
X-Received: by 2002:a17:906:7695:b0:9a9:f042:dec0 with SMTP id o21-20020a170906769500b009a9f042dec0mr5192580ejm.38.1696510218097;
        Thu, 05 Oct 2023 05:50:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2efrRPPi83JP91rlrZljdGCEsxo2DgTBNLkMExdPWWdkcKxpdXsDYMgxNAP+P4MsbasM+Fg==
X-Received: by 2002:a17:906:7695:b0:9a9:f042:dec0 with SMTP id o21-20020a170906769500b009a9f042dec0mr5192565ejm.38.1696510217875;
        Thu, 05 Oct 2023 05:50:17 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id i2-20020a05600c290200b004063d8b43e7sm3701061wmd.48.2023.10.05.05.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:50:17 -0700 (PDT)
Message-ID: <e1fa222fb8b48d5268a8be85dbb66e91af45e89a.camel@redhat.com>
Subject: Re: [PATCH 04/10] KVM: SVM: Add helper to deduplicate code for
 getting AVIC backing page
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Oct 2023 15:50:15 +0300
In-Reply-To: <20230815213533.548732-5-seanjc@google.com>
References: <20230815213533.548732-1-seanjc@google.com>
         <20230815213533.548732-5-seanjc@google.com>
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

У вт, 2023-08-15 у 14:35 -0700, Sean Christopherson пише:
> Add a helper to get the physical address of the AVIC backing page, both
> to deduplicate code and to prepare for getting the address directly from
> apic->regs, at which point it won't be all that obvious that the address
> in question is what SVM calls the AVIC backing page.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index b8313f2d88fa..954bdb45033b 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -241,14 +241,18 @@ int avic_vm_init(struct kvm *kvm)
>  	return err;
>  }
>  
> +static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
> +{
> +	return __sme_set(page_to_phys(svm->avic_backing_page));
> +}
> +
>  void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>  {
>  	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
> -	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
>  	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
>  	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
>  
> -	vmcb->control.avic_backing_page = bpa;
> +	vmcb->control.avic_backing_page = avic_get_backing_page_address(svm);
>  	vmcb->control.avic_logical_id = lpa;
>  	vmcb->control.avic_physical_id = ppa;
>  	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
> @@ -308,7 +312,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	if (!entry)
>  		return -EINVAL;
>  
> -	new_entry = __sme_set(page_to_phys(svm->avic_backing_page)) |
> +	new_entry = avic_get_backing_page_address(svm) |
>  		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
>  	WRITE_ONCE(*entry, new_entry);
>  
> @@ -859,7 +863,7 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
>  	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
>  		 irq.vector);
>  	*svm = to_svm(vcpu);
> -	vcpu_info->pi_desc_addr = __sme_set(page_to_phys((*svm)->avic_backing_page));
> +	vcpu_info->pi_desc_addr = avic_get_backing_page_address(*svm);
>  	vcpu_info->vector = irq.vector;
>  
>  	return 0;
> @@ -917,7 +921,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
>  			struct amd_iommu_pi_data pi;
>  
>  			/* Try to enable guest_mode in IRTE */
> -			pi.base = __sme_set(page_to_phys(svm->avic_backing_page));
> +			pi.base = avic_get_backing_page_address(svm);
>  			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
>  						     svm->vcpu.vcpu_id);
>  			pi.is_guest_mode = true;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

