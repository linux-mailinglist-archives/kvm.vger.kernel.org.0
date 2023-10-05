Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880267BA67C
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbjJEQfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbjJEQdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB28C4689
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 06:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696513921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xcvsqfs+0EpVaBq57CSBuRBfpi+Ba+5rBlUn7RyIyWg=;
        b=FrWf+w/VtLyk0paF3yzw6cBuwIDj9Tjg9IBcdUzj1+kE5z9MhaoDuX5OFMaEc3yGJmm+gh
        ah6PayJA6QoazsIaKwDvNyMCbf6CDhkxYrPdMJuvs/I4niX9FLiZuuN/Vu2CKSkjmzp+f1
        d6KXLLXZWp4k/cLBppLmPk4NcHkvNJM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-jhAlcfkkNYqkMGz8NwzSig-1; Thu, 05 Oct 2023 08:50:31 -0400
X-MC-Unique: jhAlcfkkNYqkMGz8NwzSig-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-406710d9a4aso6709985e9.2
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 05:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696510230; x=1697115030;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xcvsqfs+0EpVaBq57CSBuRBfpi+Ba+5rBlUn7RyIyWg=;
        b=kJ6GDa3SKbfW57tfp+UzCxaSNgdPb6oUjKTwn8jTIz+52ux+zy2ECcZuGgmcQLbizc
         ssDkE6RPruIpEDIfqyz0YDb+AK0w6MEuWuORs7U/i4FDjbtM3o62ofSjSeY7rK3l83v8
         CA0SnMM7ATFCxazo+D4ogLWe2KB9bhrHS7ZKsEm0zXyxzDB1y/tEJSArdl00Oikn7+GC
         rPeKMRNVaPbS0HS08dmVfG667r97EebtOAbvjvn8g7oaeDgQE2bzRWXVfNowm5f5qT5z
         +IesmqJUHfp5X2+jLZ53MRD10/gEZtwOV21yq3aAxYZF4BTmp5tiC/97RgV7sSSYJh7n
         wS4g==
X-Gm-Message-State: AOJu0Yw8H/uSDkBeHO6kUVo1YMveuCMRctKrriLlPBV4fA5NEKyb5fk3
        k+0uoYrGGqnmifnpeyvF1+BEgbB8ct/bBV0xYOHCkGb9XybLu8RFhyEvIPSTOX8lk8WjmlY+Jn8
        NGVWUnKlKB3zrMhyTL/al
X-Received: by 2002:a7b:ce8a:0:b0:405:4776:735a with SMTP id q10-20020a7bce8a000000b004054776735amr5323312wmj.2.1696510230555;
        Thu, 05 Oct 2023 05:50:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/nNVNIiyNjSawDybdIlilVc6D36h0kbYPNWFpdsCIWytAI5dR7THMDUcsxYxTxZ4KOTFEUA==
X-Received: by 2002:a7b:ce8a:0:b0:405:4776:735a with SMTP id q10-20020a7bce8a000000b004054776735amr5323302wmj.2.1696510230236;
        Thu, 05 Oct 2023 05:50:30 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b004054dcbf92asm1452694wmi.20.2023.10.05.05.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 05:50:29 -0700 (PDT)
Message-ID: <c09766568221adac7e532dc4ae283d7f367571a3.camel@redhat.com>
Subject: Re: [PATCH 05/10] KVM: SVM: Drop vcpu_svm's pointless
 avic_backing_page field
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Oct 2023 15:50:28 +0300
In-Reply-To: <20230815213533.548732-6-seanjc@google.com>
References: <20230815213533.548732-1-seanjc@google.com>
         <20230815213533.548732-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-08-15 у 14:35 -0700, Sean Christopherson пише:
> Drop vcpu_svm's avic_backing_page pointer and instead grab the physical
> address of KVM's vAPIC page directly from the source.  Getting a physical
> address from a kernel virtual address is not an expensive operation, and
> getting the physical address from a struct page is *more* expensive for
> CONFIG_SPARSEMEM=y kernels.  Regardless, none of the paths that consume
> the address are hot paths, i.e. shaving cycles is not a priority.
> 
> Eliminating the "cache" means KVM doesn't have to worry about the cache
> being invalid, which will simplify a future fix when dealing with vCPU IDs
> that are too big.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 4 +---
>  arch/x86/kvm/svm/svm.h  | 1 -
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 954bdb45033b..e49b682c8469 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -243,7 +243,7 @@ int avic_vm_init(struct kvm *kvm)
>  
>  static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
>  {
> -	return __sme_set(page_to_phys(svm->avic_backing_page));
> +	return __sme_set(__pa(svm->vcpu.arch.apic->regs));

I overall agree with this patch however the old code was safer:

svm->avic_backing_page is set to physical address of the apic registers
only in the avic_init_backing_page() and after checking the 
vcpu->arch.apic->regs != NULL and now in theory NULL vcpu->arch.apic->regs
are not checked.

I know that you later add a patch which adds a similar warning, but I prefer that
you fold it with this patch.
 
>  }
>  
>  void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
> @@ -305,8 +305,6 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>  
> -	svm->avic_backing_page = virt_to_page(vcpu->arch.apic->regs);
> -
>  	/* Setting AVIC backing page address in the phy APIC ID table */
>  	entry = avic_get_physical_id_entry(vcpu, id);
>  	if (!entry)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 2237230aad98..a9fde1bb85ee 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -261,7 +261,6 @@ struct vcpu_svm {
>  
>  	u32 ldr_reg;
>  	u32 dfr_reg;
> -	struct page *avic_backing_page;
>  	u64 *avic_physical_id_cache;
>  
>  	/*


Best regards,
	Maxim Levitsky



