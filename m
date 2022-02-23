Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5BD4C165B
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbiBWPRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241424AbiBWPRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:17:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44AA820196
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 07:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645629427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tu33o2ArSJyVBxtb4bIrT1Cfsldx0wNE8Mbk2ocniBo=;
        b=E9b3nxsQKyBVpMZDEV5wTp1Jeu8C5jOhG9AVQ8BBeAclfHf/MioT+vHaMeiPfBpf/fDQzE
        qrn0GO7QeIbz9Jltu4cBglAeU8257Gt0b6SXXeY3zPZ++K7OgP1fVIYymrNdM9qr68w8WM
        vUSxxsWYKx62wxTIv2gMKODA+Y6Y3Qg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-cwXBXUKYM2S9sQXNBuhwfg-1; Wed, 23 Feb 2022 10:17:03 -0500
X-MC-Unique: cwXBXUKYM2S9sQXNBuhwfg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A453E1006AA5;
        Wed, 23 Feb 2022 15:17:02 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CBAD8359E;
        Wed, 23 Feb 2022 15:17:01 +0000 (UTC)
Message-ID: <cda148b77e3615a4f1ac81de8be233204fb8f981.camel@redhat.com>
Subject: Re: [PATCH v2 08/18] KVM: x86/mmu: do not pass vcpu to root freeing
 functions
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 17:16:59 +0200
In-Reply-To: <20220217210340.312449-9-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-9-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
> These functions only operate on a given MMU, of which there are two in a vCPU.
> They also need a struct kvm in order to lock the mmu_lock, but they do not
> needed anything else in the struct kvm_vcpu.  So, pass the vcpu->kvm directly
> to them.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++--
>  arch/x86/kvm/mmu/mmu.c          | 21 +++++++++++----------
>  arch/x86/kvm/vmx/nested.c       |  8 ++++----
>  arch/x86/kvm/x86.c              |  4 ++--
>  4 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6442facfd5c0..79f37ccc8726 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1780,9 +1780,9 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu);
>  void kvm_update_dr7(struct kvm_vcpu *vcpu);
>  
>  int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
> -void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  			ulong roots_to_free);
> -void kvm_mmu_free_guest_mode_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
> +void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu);
>  gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
>  			      struct x86_exception *exception);
>  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e1578f71feae..0f2de811e871 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3234,10 +3234,9 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  }
>  
>  /* roots_to_free must be some combination of the KVM_MMU_ROOT_* flags */
> -void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  			ulong roots_to_free)
>  {
> -	struct kvm *kvm = vcpu->kvm;
>  	int i;
>  	LIST_HEAD(invalid_list);
>  	bool free_active_root;
> @@ -3287,7 +3286,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
>  
> -void kvm_mmu_free_guest_mode_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> +void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  {
>  	unsigned long roots_to_free = 0;
>  	hpa_t root_hpa;
> @@ -3309,7 +3308,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>  	}
>  
> -	kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
> +	kvm_mmu_free_roots(kvm, mmu, roots_to_free);
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
>  
> @@ -3710,7 +3709,7 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu)
>  			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>  
>  	/* sync prev_roots by simply freeing them */
> -	kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
> +	kvm_mmu_free_roots(vcpu->kvm, vcpu->arch.mmu, roots_to_free);
>  }
>  
>  static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> @@ -4159,8 +4158,10 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  			      union kvm_mmu_page_role new_role)
>  {
> +	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +
>  	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
> -		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
> +		kvm_mmu_free_roots(vcpu->kvm, mmu, KVM_MMU_ROOT_CURRENT);
>  		return;
>  	}
>  
> @@ -5083,10 +5084,10 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	return r;
>  }
>  
> -static void __kvm_mmu_unload(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> +static void __kvm_mmu_unload(struct kvm *kvm, struct kvm_mmu *mmu)
>  {
>  	int i;
> -	kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOTS_ALL);
> +	kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOTS_ALL);
>  	WARN_ON(VALID_PAGE(mmu->root.hpa));
>  	if (mmu->pae_root) {
>  		for (i = 0; i < 4; ++i)
> @@ -5096,8 +5097,8 @@ static void __kvm_mmu_unload(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>  {
> -	__kvm_mmu_unload(vcpu, &vcpu->arch.root_mmu);
> -	__kvm_mmu_unload(vcpu, &vcpu->arch.guest_mmu);
> +	__kvm_mmu_unload(vcpu->kvm, &vcpu->arch.root_mmu);
> +	__kvm_mmu_unload(vcpu->kvm, &vcpu->arch.guest_mmu);
>  }
>  
>  static bool need_remote_flush(u64 old, u64 new)
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 29289ecca223..b7bc634d35e2 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -321,7 +321,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
>  	vmx->nested.pi_desc = NULL;
>  
> -	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
> +	kvm_mmu_free_roots(vcpu->kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
>  
>  	nested_release_evmcs(vcpu);
>  
> @@ -5007,7 +5007,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
>  				  vmx->nested.current_vmptr >> PAGE_SHIFT,
>  				  vmx->nested.cached_vmcs12, 0, VMCS12_SIZE);
>  
> -	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
> +	kvm_mmu_free_roots(vcpu->kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
>  
>  	vmx->nested.current_vmptr = INVALID_GPA;
>  }
> @@ -5486,7 +5486,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (roots_to_free)
> -		kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
> +		kvm_mmu_free_roots(vcpu->kvm, mmu, roots_to_free);
>  
>  	return nested_vmx_succeed(vcpu);
>  }
> @@ -5575,7 +5575,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>  	 * TODO: sync only the affected SPTEs for INVDIVIDUAL_ADDR.
>  	 */
>  	if (!enable_ept)
> -		kvm_mmu_free_guest_mode_roots(vcpu, &vcpu->arch.root_mmu);
> +		kvm_mmu_free_guest_mode_roots(vcpu->kvm, &vcpu->arch.root_mmu);
>  
>  	return nested_vmx_succeed(vcpu);
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c0d7256e3a78..6aefd7ac7039 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -855,7 +855,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	 * Shadow page roots need to be reconstructed instead.
>  	 */
>  	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
> -		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
> +		kvm_mmu_free_roots(vcpu->kvm, mmu, KVM_MMU_ROOT_CURRENT);
>  
>  	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
>  	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> @@ -1156,7 +1156,7 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
>  		if (kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd) == pcid)
>  			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>  
> -	kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
> +	kvm_mmu_free_roots(vcpu->kvm, mmu, roots_to_free);
>  }
>  
>  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)

IMHO anything that is related to guest memory should work on
VM level (that is struct kvm).

It is just ironically sad that writing to a guest page requires
these days a vCPU due to dirty ring tracking.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


