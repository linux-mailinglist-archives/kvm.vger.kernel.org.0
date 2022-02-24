Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2744C2A3E
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 12:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbiBXLDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 06:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiBXLDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 06:03:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A91828F472
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 03:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645700561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nSU2N5M6fePTRhm0z8tk+KKYY2u9fTYFmziTNm9sGS8=;
        b=dF1ycLQcf8UyfZir0W/yEw4aZIs/ymcSh7bxb+zSi+y1s7qaY8CpeBr1d712IejvXbcV0m
        4VJoBgBSIGsic70fziN5KQxFNAyhKc87/G+jMLKs2INDVpmtvq2GWpnScBLRvI/LQTA5VL
        k5m7FvoapY3V4iS8MQV0UAAUGNb+Ua8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-u4g3W4AJPqSIezi5TucqGw-1; Thu, 24 Feb 2022 06:02:40 -0500
X-MC-Unique: u4g3W4AJPqSIezi5TucqGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 321491006AA5;
        Thu, 24 Feb 2022 11:02:39 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD6067B608;
        Thu, 24 Feb 2022 11:02:37 +0000 (UTC)
Message-ID: <207674f05d63a8b1a0edd1a35f6453aa8532200e.camel@redhat.com>
Subject: Re: [PATCH v2 14/18] KVM: x86/mmu: avoid indirect call for get_cr3
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Thu, 24 Feb 2022 13:02:36 +0200
In-Reply-To: <20220217210340.312449-15-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-15-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
> Most of the time, calls to get_guest_pgd result in calling
> kvm_read_cr3 (the exception is only nested TDP).  Hardcode
> the default instead of using the get_cr3 function, avoiding
> a retpoline if they are enabled.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu.h             | 13 +++++++++++++
>  arch/x86/kvm/mmu/mmu.c         | 15 +++++----------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  arch/x86/kvm/x86.c             |  2 +-
>  4 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 1d0c1904d69a..1808d6814ddb 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -116,6 +116,19 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  					  vcpu->arch.mmu->shadow_root_level);
>  }
>  
> +static inline gpa_t __kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> +{
> +	if (!mmu->get_guest_pgd)
> +		return kvm_read_cr3(vcpu);
> +	else
> +		return mmu->get_guest_pgd(vcpu);
> +}
> +
> +static inline gpa_t kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu)
> +{
> +	return __kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
> +}
> +
>  struct kvm_page_fault {
>  	/* arguments to kvm_mmu_do_page_fault.  */
>  	const gpa_t addr;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4e8e3e9530ca..d422d0d2adf8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3451,7 +3451,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	unsigned i;
>  	int r;
>  
> -	root_pgd = mmu->get_guest_pgd(vcpu);
> +	root_pgd = kvm_mmu_get_guest_pgd(vcpu);
>  	root_gfn = root_pgd >> PAGE_SHIFT;
>  
>  	if (mmu_check_root(vcpu, root_gfn))
> @@ -3881,7 +3881,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>  	arch.gfn = gfn;
>  	arch.direct_map = vcpu->arch.mmu->direct_map;
> -	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
> +	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu);
>  
>  	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
>  				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
> @@ -4230,11 +4230,6 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>  
> -static unsigned long get_cr3(struct kvm_vcpu *vcpu)
> -{
> -	return kvm_read_cr3(vcpu);
> -}
> -
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>  			   unsigned int access)
>  {
> @@ -4789,7 +4784,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	context->invlpg = NULL;
>  	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
>  	context->direct_map = true;
> -	context->get_guest_pgd = get_cr3;
> +	context->get_guest_pgd = NULL; /* use kvm_read_cr3 */
>  	context->get_pdptr = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
>  	context->root_level = role_regs_to_root_level(&regs);
> @@ -4964,7 +4959,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
>  
>  	kvm_init_shadow_mmu(vcpu, &regs);
>  
> -	context->get_guest_pgd     = get_cr3;
> +	context->get_guest_pgd	   = NULL; /* use kvm_read_cr3 */
>  	context->get_pdptr         = kvm_pdptr_read;
>  	context->inject_page_fault = kvm_inject_page_fault;
>  }
> @@ -4996,7 +4991,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	g_context->mmu_role.as_u64 = new_role.as_u64;
> -	g_context->get_guest_pgd     = get_cr3;
> +	g_context->get_guest_pgd     = NULL; /* use kvm_read_cr3 */
>  	g_context->get_pdptr         = kvm_pdptr_read;
>  	g_context->inject_page_fault = kvm_inject_page_fault;
>  	g_context->root_level        = new_role.base.level;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 346f3bad3cb9..1a85aba837b2 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -362,7 +362,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	trace_kvm_mmu_pagetable_walk(addr, access);
>  retry_walk:
>  	walker->level = mmu->root_level;
> -	pte           = mmu->get_guest_pgd(vcpu);
> +	pte           = __kvm_mmu_get_guest_pgd(vcpu, mmu);
>  	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>  
>  #if PTTYPE == 64
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f10878aa5b20..adcee7c305ca 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12161,7 +12161,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  		return;
>  
>  	if (!vcpu->arch.mmu->direct_map &&
> -	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
> +	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu))
>  		return;
>  
>  	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Not sure though if that is worth it though. IMHO it would be better to convert mmu callbacks
(and nested ops callbacks, etc) to static calls.

Best regards,
	Maxim Levitsky



