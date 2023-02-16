Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE60699C54
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjBPSbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBPSa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:30:59 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF125358C
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:30:57 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id dl17so1086173qvb.1
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676572257;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+FMJyUGgEIyAoK5hxvTlwgFqGNZDXVOD888mf8ZgXdk=;
        b=KZFOgv9lRSgQbqjlSCP/qSkiu0fvciDK1fy1m7x9R11+F8ODYwIScpLvGqD9YOK8gC
         EYvC+pzXEV3/EiC52Vs9+KQdyoCLSLd1H9Q4VStG4qxgP++CkLUvk9lxyzXdNBALabXn
         aiaUZ/2f9L/7D+bzOZiRSA4Q67utacGX9y3+3pwJKEmV7G0NJrBg14SNUlPRSK7cZO0y
         d4oCUb44Rd5ycBaIDAzwfe7nEH9gyNTkRhNX/vaGkaja2tb1KsrH15uPeFvDrO7Akodr
         mntAw9+zitIrVv230PDiKFLNs/25mZL2wLks6JeWgo2iJ2k1o33cp0jh6aaE07PEsZEn
         aKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676572257;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+FMJyUGgEIyAoK5hxvTlwgFqGNZDXVOD888mf8ZgXdk=;
        b=zaYQeN8qkd6Ns4Bf/uy6mypQK/YdqMXIFjtYwHSrhJr9q0JVh8++gcpp9JmyT6TcXL
         V1QxbmOAWRt6Ze/va74c7J8wCnaXYNzls6SzmJ4KujGnhCMH+86EoBYip0SKKNE3vHx7
         lYV/YJsLpYB+7ZTjnuwpwOwDJixkMMPFOoFhFWBUcdjCAcQI5h6xgH0LjKAMq6uSqExf
         prSY8XZcXRlhzFbWvzQugRyDm0Ccew+iSEKe8WL68+aSTOJmShZW0tkAnL4d3FCvfLzz
         X4n8slAJ4bJJMaUxsnK/R/9VBbFnr1X8FCbJU8gqSzBo81coAoSftkKLjqnMgfGybTcG
         i8pw==
X-Gm-Message-State: AO0yUKWPaq3317YmUTQ2TDf2GA6eX0SpDMu2MI3TgWzpglm9isO1NWcW
        FWR9JqSkWa1dk3W9HqpWFs5dJj903AQrqH8Buhbrhg==
X-Google-Smtp-Source: AK7set+r7LgbVVtNTlxytwyEFKnGPR6iHM5NlHlrPYw8Gi9tdku+xZVMbp0SC1N+OUkulCXEdnoAHzlQCr9qpupLPrU=
X-Received: by 2002:a0c:e086:0:b0:56e:a207:142d with SMTP id
 l6-20020a0ce086000000b0056ea207142dmr574739qvk.6.1676572256683; Thu, 16 Feb
 2023 10:30:56 -0800 (PST)
MIME-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com> <20230215174046.2201432-5-ricarkol@google.com>
 <93595bc0-02fb-7e4f-f87e-2d03f604c0e8@redhat.com>
In-Reply-To: <93595bc0-02fb-7e4f-f87e-2d03f604c0e8@redhat.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 16 Feb 2023 10:30:45 -0800
Message-ID: <CAOHnOrxMa7qdRPyTc1NkUGoDiMh37H0+134VaHeX5RMPAFc=6w@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
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

On Thu, Feb 16, 2023 at 4:22 AM Shaoqin Huang <shahuang@redhat.com> wrote:
>
> Hi Ricardo,
>
> On 2/16/23 01:40, Ricardo Koller wrote:
> > Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> > range of huge pages. This will be used for eager-splitting huge pages
> > into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> > on write-protection faults, and instead use this function to do it
> > ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> > a time).
> >
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h |  30 ++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 105 +++++++++++++++++++++++++++
> >   2 files changed, 135 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 2ea397ad3e63..b28489aa0994 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -658,6 +658,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> >    */
> >   int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >
> > +/**
> > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > + *                           to PAGE_SIZE guest pages.
> > + * @pgt:      Page-table structure initialised by kvm_pgtable_stage2_init().
> > + * @addr:     Intermediate physical address from which to split.
> > + * @size:     Size of the range.
> > + * @mc:               Cache of pre-allocated and zeroed memory from which to allocate
> > + *            page-table pages.
> > + * @mc_capacity: Number of pages in @mc.
> > + *
> > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > + * the top level huge-page block size. This is an example using 1GB
> > + * huge-pages and 4KB granules.
> > + *
> > + *                          [---input range---]
> > + *                          :                 :
> > + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> > + *                          :                 :
> > + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> > + *                          :                 :
> > + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> > + *                          :                 :
> > + *
> > + * Return: 0 on success, negative error code on failure. Note that
> > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > + * blocks in the input range as allowed by @mc_capacity.
> > + */
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +                          void *mc, u64 mc_capacity);
> > +
> >   /**
> >    * kvm_pgtable_walk() - Walk a page-table.
> >    * @pgt:    Page-table structure initialised by kvm_pgtable_*_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index fed314f2b320..e2fb78398b3d 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1229,6 +1229,111 @@ int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> >       return 0;
> >   }
> >
> > +struct stage2_split_data {
> > +     struct kvm_s2_mmu               *mmu;
> > +     void                            *memcache;
> > +     u64                             mc_capacity;
> > +};
> > +
> > +/*
> > + * Get the number of page-tables needed to replace a bock with a fully
>
> /s/bock/block

ACK. Will fix this on v4.

>
> Thanks,
>
> > + * populated tree, up to the PTE level, at particular level.
> > + */
> > +static inline u32 stage2_block_get_nr_page_tables(u32 level)
> > +{
> > +     switch (level) {
> > +     /* There are no blocks at level 0 */
> > +     case 1: return 1 + PTRS_PER_PTE;
> > +     case 2: return 1;
> > +     case 3: return 0;
> > +     default:
> > +             WARN_ON_ONCE(1);
> > +             return ~0;
> > +     }
> > +}
> > +
> > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +                            enum kvm_pgtable_walk_flags visit)
> > +{
> > +     struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +     struct stage2_split_data *data = ctx->arg;
> > +     kvm_pte_t pte = ctx->old, new, *childp;
> > +     enum kvm_pgtable_prot prot;
> > +     void *mc = data->memcache;
> > +     u32 level = ctx->level;
> > +     u64 phys, nr_pages;
> > +     bool force_pte;
> > +     int ret;
> > +
> > +     /* No huge-pages exist at the last level */
> > +     if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > +             return 0;
> > +
> > +     /* We only split valid block mappings */
> > +     if (!kvm_pte_valid(pte))
> > +             return 0;
> > +
> > +     nr_pages = stage2_block_get_nr_page_tables(level);
> > +     if (data->mc_capacity >= nr_pages) {
> > +             /* Build a tree mapped down to the PTE granularity. */
> > +             force_pte = true;
> > +     } else {
> > +             /*
> > +              * Don't force PTEs. This requires a single page of PMDs at the
> > +              * PUD level, or a single page of PTEs at the PMD level. If we
> > +              * are at the PUD level, the PTEs will be created recursively.
> > +              */
> > +             force_pte = false;
> > +             nr_pages = 1;
> > +     }
> > +
> > +     if (data->mc_capacity < nr_pages)
> > +             return -ENOMEM;
> > +
> > +     phys = kvm_pte_to_phys(pte);
> > +     prot = kvm_pgtable_stage2_pte_prot(pte);
> > +
> > +     ret = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, &new, phys,
> > +                                              level, prot, mc, force_pte);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (!stage2_try_break_pte(ctx, data->mmu)) {
> > +             childp = kvm_pte_follow(new, mm_ops);
> > +             kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> > +             mm_ops->put_page(childp);
> > +             return -EAGAIN;
> > +     }
> > +
> > +     /*
> > +      * Note, the contents of the page table are guaranteed to be made
> > +      * visible before the new PTE is assigned because stage2_make_pte()
> > +      * writes the PTE using smp_store_release().
> > +      */
> > +     stage2_make_pte(ctx, new);
> > +     dsb(ishst);
> > +     data->mc_capacity -= nr_pages;
> > +     return 0;
> > +}
> > +
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +                          void *mc, u64 mc_capacity)
> > +{
> > +     struct stage2_split_data split_data = {
> > +             .mmu            = pgt->mmu,
> > +             .memcache       = mc,
> > +             .mc_capacity    = mc_capacity,
> > +     };
> > +
> > +     struct kvm_pgtable_walker walker = {
> > +             .cb     = stage2_split_walker,
> > +             .flags  = KVM_PGTABLE_WALK_LEAF,
> > +             .arg    = &split_data,
> > +     };
> > +
> > +     return kvm_pgtable_walk(pgt, addr, size, &walker);
> > +}
> > +
> >   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >                             struct kvm_pgtable_mm_ops *mm_ops,
> >                             enum kvm_pgtable_stage2_flags flags,
>
> --
> Regards,
> Shaoqin
>
