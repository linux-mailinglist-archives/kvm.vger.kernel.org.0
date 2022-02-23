Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5B94C186C
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbiBWQVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242728AbiBWQVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:21:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7B77C4E22
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 08:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645633248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TiO1yBPh8R5cpx6Ex6jDuaNR/N/orDWr7M4nBkkNmDQ=;
        b=Hu2ZnTwZrsnxPPmGeRHhyO0zNDYCksnZjypx2BO9hzjxsbIf2V/xGzPO9AtAjt/WxFwqXJ
        Rm9+LhzNFOBeCWv19zlp5W9rMV4aI6+A/fFEQJf0fPydQLWHE014xBgjZGQl+EsJv7fm4C
        qcMuuQ19sWs73cEijnsuvoLjEPRQRy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-KraB3RmFOe6YNaelxlfj1g-1; Wed, 23 Feb 2022 11:20:43 -0500
X-MC-Unique: KraB3RmFOe6YNaelxlfj1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65E9AFC82;
        Wed, 23 Feb 2022 16:20:42 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B2A29BEBD;
        Wed, 23 Feb 2022 16:20:40 +0000 (UTC)
Message-ID: <fd1cc09c83c1424cea7003eb9e8ec937276fe3f8.camel@redhat.com>
Subject: Re: [PATCH v2 10/18] KVM: x86/mmu: load new PGD after the shadow
 MMU is initialized
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 18:20:39 +0200
In-Reply-To: <20220217210340.312449-11-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-11-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> Now that __kvm_mmu_new_pgd does not look at the MMU's root_level and
> shadow_root_level anymore, pull the PGD load after the initialization of
> the shadow MMUs.

Again, thanks a million for this! I once spend at least a hour figuring
out why my kernel panics when I did a similiar change, only to figure out
that __kvm_mmu_new_pgd needs to happen before mmu re-initialization.

> 
> Besides being more intuitive, this enables future simplifications
> and optimizations because it's not necessary anymore to compute the
> role outside kvm_init_mmu.  In particular, kvm_mmu_reset_context was not
> attempting to use a cached PGD to avoid having to figure out the new role.
> It will soon be able to follow what nested_{vmx,svm}_load_cr3 are doing,
> and avoid unloading all the cached roots.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c    | 37 +++++++++++++++++--------------------
>  arch/x86/kvm/svm/nested.c |  6 +++---
>  arch/x86/kvm/vmx/nested.c |  6 +++---
>  3 files changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index da324a317000..906a9244ad28 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4903,9 +4903,8 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>  
>  	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
>  
> -	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
> -
>  	shadow_mmu_init_context(vcpu, context, &regs, new_role);
> +	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
>  
> @@ -4943,27 +4942,25 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
>  						   execonly, level);
>  
> -	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
> -
> -	if (new_role.as_u64 == context->mmu_role.as_u64)
> -		return;
> -
> -	context->mmu_role.as_u64 = new_role.as_u64;
> +	if (new_role.as_u64 != context->mmu_role.as_u64) {
> +		context->mmu_role.as_u64 = new_role.as_u64;
>  
> -	context->shadow_root_level = level;
> +		context->shadow_root_level = level;
>  
> -	context->ept_ad = accessed_dirty;
> -	context->page_fault = ept_page_fault;
> -	context->gva_to_gpa = ept_gva_to_gpa;
> -	context->sync_page = ept_sync_page;
> -	context->invlpg = ept_invlpg;
> -	context->root_level = level;
> -	context->direct_map = false;
> +		context->ept_ad = accessed_dirty;
> +		context->page_fault = ept_page_fault;
> +		context->gva_to_gpa = ept_gva_to_gpa;
> +		context->sync_page = ept_sync_page;
> +		context->invlpg = ept_invlpg;
> +		context->root_level = level;
> +		context->direct_map = false;
> +		update_permission_bitmask(context, true);
> +		context->pkru_mask = 0;
> +		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
> +		reset_ept_shadow_zero_bits_mask(context, execonly);
> +	}
>  
> -	update_permission_bitmask(context, true);
> -	context->pkru_mask = 0;
> -	reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
> -	reset_ept_shadow_zero_bits_mask(context, execonly);
> +	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
>  
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f284e61451c8..96bab464967f 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -492,14 +492,14 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>  	    CC(!load_pdptrs(vcpu, cr3)))
>  		return -EINVAL;
>  
> -	if (!nested_npt)
> -		kvm_mmu_new_pgd(vcpu, cr3);
> -
>  	vcpu->arch.cr3 = cr3;
>  
>  	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
>  	kvm_init_mmu(vcpu);
>  
> +	if (!nested_npt)
> +		kvm_mmu_new_pgd(vcpu, cr3);
> +
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b7bc634d35e2..1dfe23963a9e 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1126,15 +1126,15 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>  		return -EINVAL;
>  	}
>  
> -	if (!nested_ept)
> -		kvm_mmu_new_pgd(vcpu, cr3);
> -
>  	vcpu->arch.cr3 = cr3;
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>  
>  	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
>  	kvm_init_mmu(vcpu);
>  
> +	if (!nested_ept)
> +		kvm_mmu_new_pgd(vcpu, cr3);
> +
>  	return 0;
>  }
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

