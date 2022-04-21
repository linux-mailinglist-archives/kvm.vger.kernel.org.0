Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5986650A5D4
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiDUQdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiDUQdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:33:40 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6B2488B6
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:28:49 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g14so6359141ybj.12
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q8KjLP1ge6CAoQAgMyteAhGdc8R9b0Iwu1CbYU0QQX4=;
        b=CqNIj/zOCypJLipQuaEFIj7/HD2atvqJ0uUBCe49uKo0kO0SHINqVVrjlaDqeYDAZR
         bAKx3M9A9Q0gA3BiaqR5QGSxrnIpvK5r2BWpMk7PDvLvrl4ipiS2NYoUj4vqOk0KWWrM
         OrRdpyxWnHlZRnBeKonn4dOGH+FadwcvHiDztfe6fxP6wymeQ+THyqa6aFQrGbLVnw74
         BuzES2xxXbHQKYPW4j/2qy4TuJSynnKlRxo4wd2kBnKFSLtmHC6gkKPtW7vn5NWpc6sS
         qMBuXInD+TPKuDbCkD9fs5xkh+3UQHjBOFgrzdbBelaam+es7LEOjV6NLAykJR8cBM5v
         dvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q8KjLP1ge6CAoQAgMyteAhGdc8R9b0Iwu1CbYU0QQX4=;
        b=xR9ny/HgF/Cgivd2E8nl/l3uVGGTkUYku6RPJFt1ESbtNW4SrkLTlbprObYkYnO59I
         1rSrKZGz/qyg2EdKZHo4JqrSqguP36K/LrBT/Gt7Bj35vJ4Ng+GvnDQ6mTRae+/qGb0t
         ljCNVSwWQ2+LUIoAF7eX7lIRh2TXt+QFSbVxAHz/RmQbulTXO2HS7pYmzuO7aFaGhmC9
         nzM29T/JywossEsLfQkKxdrj4cOzJgC+G50mUM1XAlJssPEvgyE+7Y21EG5JY2ia/syo
         Oo4f+bEElt3aeZGYYH++U7YzOG0MiaEenBgjiYR4Ir6tGS7zaM57kw291JE8J7pagvE4
         mofQ==
X-Gm-Message-State: AOAM531Tnzug9Sulb5kxAXZkCQbHYpLblZAHXyUFgbNjehgWliAZZf0V
        jAkxsJL0mUKmFBiT2/FWwG2j8s86J57T3e4A9JBezQ==
X-Google-Smtp-Source: ABdhPJyFf1PQK+nJfwVXpStSPYFXSi6lgr/C7HjJzsJXnb9Mp1L3UDEiWHJBDsupjDNpUxAX7Xzm8RxfgnwHZEmZUZw=
X-Received: by 2002:a25:2408:0:b0:641:d07e:6ca with SMTP id
 k8-20020a252408000000b00641d07e06camr454993ybk.341.1650558528698; Thu, 21 Apr
 2022 09:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <20220415215901.1737897-15-oupton@google.com>
In-Reply-To: <20220415215901.1737897-15-oupton@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 21 Apr 2022 09:28:37 -0700
Message-ID: <CANgfPd-pK6jT4Sw_WCzyyHY9v3dj6O6SDPEt5Br1ws76H1Xx6w@mail.gmail.com>
Subject: Re: [RFC PATCH 14/17] KVM: arm64: Punt last page reference to rcu
 callback for parallel walk
To:     Oliver Upton <oupton@google.com>
Cc:     "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> It is possible that a table page remains visible to another thread until
> the next rcu synchronization event. To that end, we cannot drop the last
> page reference synchronous with post-order traversal for a parallel
> table walk.
>
> Schedule an rcu callback to clean up the child table page for parallel
> walks.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  3 ++
>  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++--
>  arch/arm64/kvm/mmu.c                 | 44 +++++++++++++++++++++++++++-
>  3 files changed, 67 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 74955aba5918..52e55e00f0ca 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -81,6 +81,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>   * @put_page:                  Decrement the refcount on a page. When the
>   *                             refcount reaches 0 the page is automatically
>   *                             freed.
> + * @free_table:                        Drop the last page reference, possibly in the
> + *                             next RCU sync if doing a shared walk.
>   * @page_count:                        Return the refcount of a page.
>   * @phys_to_virt:              Convert a physical address into a virtual
>   *                             address mapped in the current context.
> @@ -98,6 +100,7 @@ struct kvm_pgtable_mm_ops {
>         void            (*get_page)(void *addr);
>         void            (*put_page)(void *addr);
>         int             (*page_count)(void *addr);
> +       void            (*free_table)(void *addr, bool shared);
>         void*           (*phys_to_virt)(phys_addr_t phys);
>         phys_addr_t     (*virt_to_phys)(void *addr);
>         void            (*dcache_clean_inval_poc)(void *addr, size_t size);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 121818d4c33e..a9a48edba63b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -147,12 +147,19 @@ static inline void kvm_pgtable_walk_end(void)
>  {}
>
>  #define kvm_dereference_ptep   rcu_dereference_raw
> +
> +static inline void kvm_pgtable_destroy_barrier(void)
> +{}
> +
>  #else
>  #define kvm_pgtable_walk_begin rcu_read_lock
>
>  #define kvm_pgtable_walk_end   rcu_read_unlock
>
>  #define kvm_dereference_ptep   rcu_dereference
> +
> +#define kvm_pgtable_destroy_barrier    rcu_barrier
> +
>  #endif
>
>  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
> @@ -1063,7 +1070,12 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>                 childp = kvm_pte_follow(*old, mm_ops);
>         }
>
> -       mm_ops->put_page(childp);
> +       /*
> +        * If we do not have exclusive access to the page tables it is possible
> +        * the unlinked table remains visible to another thread until the next
> +        * rcu synchronization.
> +        */
> +       mm_ops->free_table(childp, shared);
>         mm_ops->put_page(ptep);
>
>         return ret;
> @@ -1203,7 +1215,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>                                                kvm_granule_size(level));
>
>         if (childp)
> -               mm_ops->put_page(childp);
> +               mm_ops->free_table(childp, shared);
>
>         return 0;
>  }
> @@ -1433,7 +1445,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>         mm_ops->put_page(ptep);
>
>         if (kvm_pte_table(*old, level))
> -               mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
> +               mm_ops->free_table(kvm_pte_follow(*old, mm_ops), shared);
>
>         return 0;
>  }
> @@ -1452,4 +1464,10 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>         pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
>         pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
>         pgt->pgd = NULL;
> +
> +       /*
> +        * Guarantee that all unlinked subtrees associated with the stage2 page
> +        * table have also been freed before returning.
> +        */
> +       kvm_pgtable_destroy_barrier();

Why do we need to wait for in-flight RCU callbacks to finish here?
Is this function only used on VM teardown and we just want to make
sure all the memory is freed or is something actually depending on
this behavior?

>  }
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index cc6ed6b06ec2..6ecf37009c21 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -98,9 +98,50 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>  static void *stage2_memcache_zalloc_page(void *arg)
>  {
>         struct kvm_mmu_caches *mmu_caches = arg;
> +       struct stage2_page_header *hdr;
> +       void *addr;
>
>         /* Allocated with __GFP_ZERO, so no need to zero */
> -       return kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> +       addr = kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> +       if (!addr)
> +               return NULL;
> +
> +       hdr = kvm_mmu_memory_cache_alloc(&mmu_caches->header_cache);
> +       if (!hdr) {
> +               free_page((unsigned long)addr);
> +               return NULL;
> +       }
> +
> +       hdr->page = virt_to_page(addr);
> +       set_page_private(hdr->page, (unsigned long)hdr);
> +       return addr;
> +}
> +
> +static void stage2_free_page_now(struct stage2_page_header *hdr)
> +{
> +       WARN_ON(page_ref_count(hdr->page) != 1);
> +
> +       __free_page(hdr->page);
> +       kmem_cache_free(stage2_page_header_cache, hdr);
> +}
> +
> +static void stage2_free_page_rcu_cb(struct rcu_head *head)
> +{
> +       struct stage2_page_header *hdr = container_of(head, struct stage2_page_header,
> +                                                     rcu_head);
> +
> +       stage2_free_page_now(hdr);
> +}
> +
> +static void stage2_free_table(void *addr, bool shared)
> +{
> +       struct page *page = virt_to_page(addr);
> +       struct stage2_page_header *hdr = (struct stage2_page_header *)page_private(page);
> +
> +       if (shared)
> +               call_rcu(&hdr->rcu_head, stage2_free_page_rcu_cb);
> +       else
> +               stage2_free_page_now(hdr);
>  }
>
>  static void *kvm_host_zalloc_pages_exact(size_t size)
> @@ -613,6 +654,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>         .free_pages_exact       = free_pages_exact,
>         .get_page               = kvm_host_get_page,
>         .put_page               = kvm_host_put_page,
> +       .free_table             = stage2_free_table,
>         .page_count             = kvm_host_page_count,
>         .phys_to_virt           = kvm_host_va,
>         .virt_to_phys           = kvm_host_pa,
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
