Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4124F5507
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbiDFFYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835489AbiDFAbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 20:31:53 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8354F3A66
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 15:46:48 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id p8so790611pfh.8
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 15:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PBFAM1H2rlnaIIdKrJyDL2Ds5ftRVoz3Ng6L/c5lFgc=;
        b=TIPip8PSVDMp7s/pgmaOP9awbmRc4dtkTzmeh2cpwuqp24pUFaMX6gShrdlIKPmtGr
         Bjgxt7jOckoL+I0xC9hsFXxerCp/4DKg1foYiruEpI98Vw/q4RZ/i7n2bNKxkdbOd0QK
         zOIPiSSeHxsZqO5K5Qbki7d1B3s0H8AYJ8CpFyVaUp2+Z4gh0g8aSbtmUqlHg5ji5Szt
         XSR8HoopsxIc+AfJ9MiI+3T/WFqfs5LGDf5TQ7A+T3duXzD2u5ppPEQRxREPC5zKU+BW
         1IcuP6U3EFhfJVWnE1PP/JxypAuQPaY6oH4JKKFcjle+lizH3hJnb9GapaK/xqIuLMvU
         jJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PBFAM1H2rlnaIIdKrJyDL2Ds5ftRVoz3Ng6L/c5lFgc=;
        b=SFeCInskKXmvj0l7O0nBom0BGkvpsA2xQa2P1FzDJpjN2+iZn9fmkLzR2W/W1Mvq9P
         iNFTqAcat4mK1/TJPUdRfvllFJoLuhkh2VwzRKqneoRPNS5RWhRjw6+9lHnrTge7b4Zj
         Ec6n/BNNRHLHDhF178IGJdIGrcOswJSo59xP8Lk/uTNMs7YauKYMkzujaw6PJX3Q4a8V
         eVuLGTor0wH4tHshIqC20NjFpExyyXVYlVRY4N13lJQkhq4AzAxIEgeBq3af9zUkYYYC
         4pGAMWFCyakFeRBJGeGsgfiVhDDQwr9YdP559ngoQw+5QMMs4+EX4wxVtjb4l7HlItPa
         2CYA==
X-Gm-Message-State: AOAM531R5N5XPIrC9NN2KSUAlesNBPSHfn8kN9IZuD2KtySMwfKovHOF
        OhYuhcyAFU7WLCdwA84/TvdZ2F5i6L105g==
X-Google-Smtp-Source: ABdhPJyqeDqfJsMhy64cIDy86djX31xX7i7AEfndWeaZac3H3bP1KlVuwkojjPTeonnc1EJCsWGF1A==
X-Received: by 2002:a05:6a00:843:b0:4fe:3a5e:b347 with SMTP id q3-20020a056a00084300b004fe3a5eb347mr5780395pfk.64.1649198808042;
        Tue, 05 Apr 2022 15:46:48 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id o1-20020a637e41000000b003804d0e2c9esm14104960pgn.35.2022.04.05.15.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:46:47 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:46:43 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 08/11] KVM: x86/MMU: Allow NX huge pages to be
 disabled on a per-vm basis
Message-ID: <YkzG04NVKU/Pcy5v@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-9-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-9-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 10:46:18AM -0700, Ben Gardon wrote:
> In some cases, the NX hugepage mitigation for iTLB multihit is not
> needed for all guests on a host. Allow disabling the mitigation on a
> per-VM basis to avoid the performance hit of NX hugepages on trusted
> workloads.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  Documentation/virt/kvm/api.rst  | 11 +++++++++++
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              | 10 ++++++----
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/mmu/spte.c         |  7 ++++---
>  arch/x86/kvm/mmu/spte.h         |  3 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++-
>  arch/x86/kvm/x86.c              |  6 ++++++
>  include/uapi/linux/kvm.h        |  1 +
>  9 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index b102ba7cf903..b40c3113b14b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7844,6 +7844,17 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
>  this capability will disable PMU virtualization for that VM.  Usermode
>  should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>  
> +8.36 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
> +---------------------------
> +
> +:Capability KVM_CAP_PMU_CAPABILITY
> +:Architectures: x86
> +:Type: vm
> +
> +This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
> +
> +The capability has no effect if the nx_huge_pages module parameter is not set.
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 676705ad1e23..dcff7709444d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1246,6 +1246,8 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +
> +	bool disable_nx_huge_pages;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index e6cae6f22683..69cffc86b888 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -173,10 +173,12 @@ struct kvm_page_fault {
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
>  extern int nx_huge_pages;
> -static inline bool is_nx_huge_page_enabled(void)
> +static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
>  {
> -	return READ_ONCE(nx_huge_pages);
> +	return READ_ONCE(nx_huge_pages) &&
> +	       !kvm->arch.disable_nx_huge_pages;
>  }
> +void kvm_update_nx_huge_pages(struct kvm *kvm);
>  
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  					u32 err, bool prefetch)
> @@ -191,8 +193,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.user = err & PFERR_USER_MASK,
>  		.prefetch = prefetch,
>  		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
> -		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
> -
> +		.nx_huge_page_workaround_enabled =
> +			is_nx_huge_page_enabled(vcpu->kvm),
>  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
>  		.req_level = PG_LEVEL_4K,
>  		.goal_level = PG_LEVEL_4K,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index af428cb65b3f..eb7b935d3caa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6202,7 +6202,7 @@ static void __set_nx_huge_pages(bool val)
>  	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
>  }
>  
> -static void kvm_update_nx_huge_pages(struct kvm *kvm)
> +void kvm_update_nx_huge_pages(struct kvm *kvm)
>  {
>  	mutex_lock(&kvm->slots_lock);
>  	kvm_mmu_zap_all_fast(kvm);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4739b53c9734..877ad30bc7ad 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -116,7 +116,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		spte |= spte_shadow_accessed_mask(spte);
>  
>  	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
> -	    is_nx_huge_page_enabled()) {
> +	    is_nx_huge_page_enabled(vcpu->kvm)) {
>  		pte_access &= ~ACC_EXEC_MASK;
>  	}
>  
> @@ -215,7 +215,8 @@ static u64 make_spte_executable(u64 spte)
>   * This is used during huge page splitting to build the SPTEs that make up the
>   * new page table.
>   */
> -u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
> +u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
> +			      int index)
>  {
>  	u64 child_spte;
>  	int child_level;
> @@ -243,7 +244,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
>  		 * When splitting to a 4K page, mark the page executable as the
>  		 * NX hugepage mitigation no longer applies.
>  		 */
> -		if (is_nx_huge_page_enabled())
> +		if (is_nx_huge_page_enabled(kvm))
>  			child_spte = make_spte_executable(child_spte);
>  	}
>  
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 73f12615416f..e4142caff4b1 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>  	       u64 old_spte, bool prefetch, bool can_unsync,
>  	       bool host_writable, u64 *new_spte);
> -u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
> +u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
> +			      int index);
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
>  u64 mark_spte_for_access_track(u64 spte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a2f9a34a0168..5d82a54924e6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1469,7 +1469,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * not been linked in yet and thus is not reachable from any other CPU.
>  	 */
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> -		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
> +		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte,
> +						       level, i);
>  
>  	/*
>  	 * Replace the huge spte with a pointer to the populated lower level
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7a066cf92692..ea1d620b35df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4268,6 +4268,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_SYS_ATTRIBUTES:
>  	case KVM_CAP_VAPIC:
>  	case KVM_CAP_ENABLE_CAP:
> +	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -6061,6 +6062,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> +	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +		kvm->arch.disable_nx_huge_pages = true;
> +		kvm_update_nx_huge_pages(kvm);
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8616af85dc5d..12399c969b42 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1145,6 +1145,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PMU_CAPABILITY 212
>  #define KVM_CAP_DISABLE_QUIRKS2 213
>  #define KVM_CAP_VM_TSC_CONTROL 214
> +#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 215
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.35.1.1021.g381101b075-goog
> 
