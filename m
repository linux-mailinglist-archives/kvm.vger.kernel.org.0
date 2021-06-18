Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B91A3AC7A7
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 11:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhFRJeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 05:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbhFRJeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 05:34:02 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CE7C0611C1
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 02:31:18 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so9141862otl.0
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 02:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GPeRH4hmuREp1clHnwfw9qScnyR9MdpgxRYZe37BmEE=;
        b=pMSTcZFHJwl7kCAJEOdswnD5xOFqmsX98UB70ZEyYyVDghAwEyBerXqBibqrwow426
         yYBrOM2azwYmGF0JUPol1DBiNdkCs2o+AbOr5zS2BZvBP7Bo/lOrQBaAFeDJMADVMUOc
         HMtUq1tBiceMSgQ+1vmfrwbVbBLDV2zCSmu6SY1yMrS29xfsUn+pHtiIPJ5C+zOlrIwF
         Doqgjl6y7HYDtSLnuUtyvBkn8GJGMrJiKa+yLUDCC96txA8mXVHkVfrYm4NJoXwNygFT
         PlyYTn2U4T+GPsGlZfm3oRU4ndDDo54s50l9cbhFV04x3ACVmJvG2EGZ9A7IJ84clsbc
         Cydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GPeRH4hmuREp1clHnwfw9qScnyR9MdpgxRYZe37BmEE=;
        b=sB3LpooiEAz/wP55YHiKnVA6CuAFxKA2ljMe3lHUjyZTIheeyaGBwTQKUqYM5hyBwL
         yQmGxDbTYuZKk2Rd/lKZKAnsQHbpFD8PSgvwqTfyfh44k4XUL+3kI4njTBfxzAfq/ci+
         q6PdIWrWbUB7OwuljdxreRMhs/x6IWz8m6jBM8HbppLYKsJGkXmU0TqUWUPXt3rsLHkh
         KyYMewQOU+INHgTHYoakNiyUctiT7zqbmCwQLPIMpfakKS6GkiPoBmA0lf+FWXqLuv4g
         F23x+Q2vj9IqkrJnkx9tE4Otqe6Q4UOE2K6YQpYWCr9YY4zgZ8PPpz8bxe6Mk/iVbjrm
         2cUQ==
X-Gm-Message-State: AOAM532V9q2oZpoFpqae31SEEZ/2NMIU4vYqTx/7o8d755ywlxH0JeRQ
        ZNNjVU/hEsI4h1SvvejklyFUUmdJ7FNY8Z1zLEXjMQ==
X-Google-Smtp-Source: ABdhPJxVoa7NUzYSI/4DLiCN8uOQHMqLW6VjWnPqO/JD7BrK7yJsXK7EgA1NjRBHG201hJaR49+Az4O/feUcYx9iF30=
X-Received: by 2002:a05:6830:1598:: with SMTP id i24mr8609437otr.52.1624008677336;
 Fri, 18 Jun 2021 02:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210617105824.31752-1-wangyanan55@huawei.com> <20210617105824.31752-5-wangyanan55@huawei.com>
In-Reply-To: <20210617105824.31752-5-wangyanan55@huawei.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Fri, 18 Jun 2021 10:30:41 +0100
Message-ID: <CA+EHjTynd1bosv862Py6_pxEe62aH466Jzw30MKkFskKzN6ODg@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] KVM: arm64: Move guest CMOs to the fault handlers
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yanan,

On Thu, Jun 17, 2021 at 11:58 AM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> We currently uniformly permorm CMOs of D-cache and I-cache in function

Nit: permorm -> perform

> user_mem_abort before calling the fault handlers. If we get concurrent
> guest faults(e.g. translation faults, permission faults) or some really
> unnecessary guest faults caused by BBM, CMOs for the first vcpu are
> necessary while the others later are not.
>
> By moving CMOs to the fault handlers, we can easily identify conditions
> where they are really needed and avoid the unnecessary ones. As it's a
> time consuming process to perform CMOs especially when flushing a block
> range, so this solution reduces much load of kvm and improve efficiency
> of the stage-2 page table code.
>
> We can imagine two specific scenarios which will gain much benefit:
> 1) In a normal VM startup, this solution will improve the efficiency of
> handling guest page faults incurred by vCPUs, when initially populating
> stage-2 page tables.
> 2) After live migration, the heavy workload will be resumed on the
> destination VM, however all the stage-2 page tables need to be rebuilt
> at the moment. So this solution will ease the performance drop during
> resuming stage.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 38 +++++++++++++++++++++++++++++-------
>  arch/arm64/kvm/mmu.c         | 37 ++++++++++++++---------------------
>  2 files changed, 46 insertions(+), 29 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d99789432b05..760c551f61da 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -577,12 +577,24 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>         mm_ops->put_page(ptep);
>  }
>
> +static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
> +{
> +       u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> +       return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
> +}
> +
> +static bool stage2_pte_executable(kvm_pte_t pte)
> +{
> +       return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
> +}
> +
>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                                       kvm_pte_t *ptep,
>                                       struct stage2_map_data *data)
>  {
>         kvm_pte_t new, old = *ptep;
>         u64 granule = kvm_granule_size(level), phys = data->phys;
> +       struct kvm_pgtable *pgt = data->mmu->pgt;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
>         if (!kvm_block_mapping_supported(addr, end, phys, level))
> @@ -606,6 +618,14 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                 stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
>         }
>
> +       /* Perform CMOs before installation of the guest stage-2 PTE */
> +       if (mm_ops->clean_invalidate_dcache && stage2_pte_cacheable(pgt, new))
> +               mm_ops->clean_invalidate_dcache(kvm_pte_follow(new, mm_ops),
> +                                               granule);
> +
> +       if (mm_ops->invalidate_icache && stage2_pte_executable(new))
> +               mm_ops->invalidate_icache(kvm_pte_follow(new, mm_ops), granule);
> +
>         smp_store_release(ptep, new);
>         if (stage2_pte_is_counted(new))
>                 mm_ops->get_page(ptep);
> @@ -798,12 +818,6 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>         return ret;
>  }
>
> -static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
> -{
> -       u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> -       return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
> -}
> -
>  static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>                                enum kvm_pgtable_walk_flags flag,
>                                void * const arg)
> @@ -874,6 +888,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  {
>         kvm_pte_t pte = *ptep;
>         struct stage2_attr_data *data = arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
>         if (!kvm_pte_valid(pte))
>                 return 0;
> @@ -888,8 +903,17 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>          * but worst-case the access flag update gets lost and will be
>          * set on the next access instead.
>          */
> -       if (data->pte != pte)
> +       if (data->pte != pte) {
> +               /*
> +                * Invalidate instruction cache before updating the guest
> +                * stage-2 PTE if we are going to add executable permission.
> +                */
> +               if (mm_ops->invalidate_icache &&
> +                   stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
> +                       mm_ops->invalidate_icache(kvm_pte_follow(pte, mm_ops),
> +                                                 kvm_granule_size(level));
>                 WRITE_ONCE(*ptep, pte);
> +       }
>
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b980f8a47cbb..c9f002d74ab4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -434,14 +434,16 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  }
>
>  static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
> -       .zalloc_page            = stage2_memcache_zalloc_page,
> -       .zalloc_pages_exact     = kvm_host_zalloc_pages_exact,
> -       .free_pages_exact       = free_pages_exact,
> -       .get_page               = kvm_host_get_page,
> -       .put_page               = kvm_host_put_page,
> -       .page_count             = kvm_host_page_count,
> -       .phys_to_virt           = kvm_host_va,
> -       .virt_to_phys           = kvm_host_pa,
> +       .zalloc_page                    = stage2_memcache_zalloc_page,
> +       .zalloc_pages_exact             = kvm_host_zalloc_pages_exact,
> +       .free_pages_exact               = free_pages_exact,
> +       .get_page                       = kvm_host_get_page,
> +       .put_page                       = kvm_host_put_page,
> +       .page_count                     = kvm_host_page_count,
> +       .phys_to_virt                   = kvm_host_va,
> +       .virt_to_phys                   = kvm_host_pa,
> +       .clean_invalidate_dcache        = clean_dcache_guest_page,
> +       .invalidate_icache              = invalidate_icache_guest_page,
>  };
>
>  /**
> @@ -1012,15 +1014,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (writable)
>                 prot |= KVM_PGTABLE_PROT_W;
>
> -       if (fault_status != FSC_PERM && !device)
> -               clean_dcache_guest_page(page_address(pfn_to_page(pfn)),
> -                                       vma_pagesize);
> -
> -       if (exec_fault) {
> +       if (exec_fault)
>                 prot |= KVM_PGTABLE_PROT_X;
> -               invalidate_icache_guest_page(page_address(pfn_to_page(pfn)),
> -                                            vma_pagesize);
> -       }
>
>         if (device)
>                 prot |= KVM_PGTABLE_PROT_DEVICE;
> @@ -1218,12 +1213,10 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>         WARN_ON(range->end - range->start != 1);
>
>         /*
> -        * We've moved a page around, probably through CoW, so let's treat it
> -        * just like a translation fault and clean the cache to the PoC.
> -        */
> -       clean_dcache_guest_page(page_address(pfn_to_page(pfn), PAGE_SIZE);
> -
> -       /*
> +        * We've moved a page around, probably through CoW, so let's treat
> +        * it just like a translation fault and the map handler will clean
> +        * the cache to the PoC.
> +        *
>          * The MMU notifiers will have unmapped a huge PMD before calling
>          * ->change_pte() (which in turn calls kvm_set_spte_gfn()) and
>          * therefore we never need to clear out a huge PMD through this

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> --
> 2.23.0
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
