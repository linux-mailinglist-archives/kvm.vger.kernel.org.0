Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C718F4EA166
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 22:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbiC1UXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 16:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343736AbiC1UXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 16:23:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B91366AC9
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:21:40 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so552780pjo.2
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OTSl5wqoRBvDXv4InM69VBlkS/7JMtGiy6dDLpaq+Xo=;
        b=fxHHTVM2HHXwrO55+d2FKc1nNIOb7+DeSg8iVDFyu+qppWU6mrTfrKGgxTRmawYHD2
         J9ZpsgyFWth/eBZ/qwdb8N5bC1k8XihsgzCKXfSdh3jt9hD3iA0GqG/6TUKWLYng7xDr
         rGdEK1V3udN11jAm1p+d2ZI6Un4BX+yb22h/Gr3d12pn6jheqdhA0W7CHikrczfkw5m/
         BNxTPisGsXWXHm69v3oCvyeOAl92yXbdvbSHBdW0hLs7pXd02Se+NQqEYPrkMPYfPD0W
         XdX+zgFxTCLbZIiP/rP27RgtV7DB4j/sx5c4MFZgQ1SQmBFnbZBQh1TqB5DMCxL/CXWA
         sV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OTSl5wqoRBvDXv4InM69VBlkS/7JMtGiy6dDLpaq+Xo=;
        b=LO/nMHZ5JYpVUHZfF6i9qB6k3ybqtNWao4gxe8qmAUHMHb3hN4Sm3FvyllRMoKaXEi
         QQTsC+Wf25da4XSZwFA5Me8WHC8KoB0XrSuo7hdud9IMwS2LGLUvVIYjq0g0HFzXorYD
         9fVbkYFgyxe9HJZIL/wBuuwUyJimzJ7BdSquJ1mazJcVtZf3jVGaajVc3LCpwHIQIrVx
         5xVj4kNDoIpueuh2XpWsIZCywum5WVZqpafrHGSOKaZ5QaGx1m1w2UccVpqdgdthEvm9
         bXUwkEd2uZQPeWQkw2XuDeleEZcSCiWNuTwMMdSo1d53Dw4wwUahM4BXOX66Kj3+wVKy
         j8zA==
X-Gm-Message-State: AOAM533XlifqkxzvcB4L5U5z7V3E4v2nhAaffFjUwBF6T/qu6QdHcUUX
        D9ueB55DtFZc4/MUj+HIlQoh0w==
X-Google-Smtp-Source: ABdhPJy9B8/XsWnPtS5us8Bk8vwH1/QkzXGjCZyOtJXyuuzIlWLAtspgHDrim18obXS6uUAt6a6cDQ==
X-Received: by 2002:a17:902:bd46:b0:154:b936:d1df with SMTP id b6-20020a170902bd4600b00154b936d1dfmr27489992plx.73.1648498899756;
        Mon, 28 Mar 2022 13:21:39 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id o15-20020a17090a168f00b001bf66741097sm327416pja.16.2022.03.28.13.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 13:21:38 -0700 (PDT)
Date:   Mon, 28 Mar 2022 20:21:35 +0000
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
Subject: Re: [PATCH v2 08/11] KVM: x86/MMU: Track NX hugepages on a per-VM
 basis
Message-ID: <YkIYz4H1NLPvqVcG@google.com>
References: <20220321234844.1543161-1-bgardon@google.com>
 <20220321234844.1543161-9-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321234844.1543161-9-bgardon@google.com>
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

On Mon, Mar 21, 2022 at 04:48:41PM -0700, Ben Gardon wrote:
> Track whether NX hugepages are enabled on a per-VM basis instead of as a
> host-wide setting. With this commit, the per-VM state will always be the
> same as the host-wide setting, but in future commits, it will be allowed
> to differ.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/mmu.h              | 8 ++++----
>  arch/x86/kvm/mmu/mmu.c          | 7 +++++--
>  arch/x86/kvm/mmu/spte.c         | 7 ++++---
>  arch/x86/kvm/mmu/spte.h         | 3 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 3 ++-
>  6 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f72e80178ffc..0a0c54639dd8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1240,6 +1240,8 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +
> +	bool nx_huge_pages;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index bf8dbc4bb12a..dd28fe8d13ae 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -173,9 +173,9 @@ struct kvm_page_fault {
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
>  extern int nx_huge_pages;
> -static inline bool is_nx_huge_page_enabled(void)
> +static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
>  {
> -	return READ_ONCE(nx_huge_pages);
> +	return READ_ONCE(kvm->arch.nx_huge_pages);
>  }
>  
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> @@ -191,8 +191,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
> index 1b59b56642f1..dc9672f70468 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6195,8 +6195,10 @@ static void __set_nx_huge_pages(bool val)
>  	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
>  }
>  
> -static int kvm_update_nx_huge_pages(struct kvm *kvm)
> +static void kvm_update_nx_huge_pages(struct kvm *kvm)
>  {
> +	kvm->arch.nx_huge_pages = nx_huge_pages;
> +
>  	mutex_lock(&kvm->slots_lock);
>  	kvm_mmu_zap_all_fast(kvm);
>  	mutex_unlock(&kvm->slots_lock);
> @@ -6227,7 +6229,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  		mutex_lock(&kvm_lock);
>  
>  		list_for_each_entry(kvm, &vm_list, vm_list)
> -			kvm_set_nx_huge_pages(kvm);
> +			kvm_update_nx_huge_pages(kvm);
>  		mutex_unlock(&kvm_lock);
>  	}
>  
> @@ -6448,6 +6450,7 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>  {
>  	int err;
>  
> +	kvm->arch.nx_huge_pages = READ_ONCE(nx_huge_pages);
>  	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
>  					  "kvm-nx-lpage-recovery",
>  					  &kvm->arch.nx_lpage_recovery_thread);
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
> index af60922906ef..98a45a87f0b2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1466,7 +1466,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * not been linked in yet and thus is not reachable from any other CPU.
>  	 */
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> -		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
> +		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte,
> +						       level, i);
>  
>  	/*
>  	 * Replace the huge spte with a pointer to the populated lower level
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
