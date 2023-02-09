Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939C769090E
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 13:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBIMkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 07:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBIMkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 07:40:35 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8240E5AB06
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 04:40:34 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id ow4so767516qkn.1
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 04:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wEBb6jh4OBASjgOuJ8EUtEbNgLorZ8qJTVNMTVmx2h0=;
        b=WmdmletUgMkd+nEQSbzWjYF4CyiT9oHq6r22roJauTteFtp8lCNSchHoXImLl+zXvk
         lALnTn6MZE/PReNC3gHR+uAsERDkX3XSOr0xZ+ChrXKEhlaj+6aHnQ2R+bE3SEjOGo+m
         ug+uJGrq7TtkBlSwhppBySII+9ejxpGa9oI47d02QwVySGpjNx0t+Rf9ccRJhLoaw6U5
         BeeGcI2eztxPGaAnFy8gLEV9YZ3CmvGttEguElg425dktc0nZK1EUP/Py4jaB188PCkf
         F01An+q6IZqJ2dXUCtlezNnV7wAzY4VV+0yAPrB46iDlYaVCSQTz2ffXpwphoT4sURX3
         yO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wEBb6jh4OBASjgOuJ8EUtEbNgLorZ8qJTVNMTVmx2h0=;
        b=Ni1plkEV1931irjICuH/YThDL/RfnNa631BzBxjMyeUgam8UTvceGaozskFSjGdy3K
         Ha+pDoElKHaPkvf5mOkA1WHpfCOQcmuNPOHLGKZt9WjPcnnlTohzuWh85lV8+xr0eaJB
         p+74xCw/rluali91pGCbpEfxC5Fl26otYEr5+KnuQ0majSyb4DvmZ7TEr085gFnZLavH
         /qHtmiYutvdAT2rsmGvJD23u6rgYOQ9FTXBHA0EkJlycLhAA4gNzXF/H2CbXbhasRoMt
         HZmKQK1cpJnXtTq/HSyQ/YGlKAZrqsgEiEoNUVFaC24wKkXBhmmj4EBBZJeWXCjqHhgw
         COBg==
X-Gm-Message-State: AO0yUKUINqBpaWY3RtHCB7LC/06hMN+Q+U7mDt5wFC+wA0XpLqzil1e9
        8usXDduBk3k+tEwdAiTjHYPVXN28GG0ulklwuHzRZg==
X-Google-Smtp-Source: AK7set+YEZkK5ls1iAQV9ETFtVKweQvqHdlKQDsjBS0Z1TzlkLU6wP3f5geuHyAQHtMBOI0DLsc1Y0OoZzD9z2SMxRY=
X-Received: by 2002:a37:6390:0:b0:72b:ada6:1295 with SMTP id
 x138-20020a376390000000b0072bada61295mr927544qkb.211.1675946433391; Thu, 09
 Feb 2023 04:40:33 -0800 (PST)
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-5-ricarkol@google.com>
 <cae4a1d9-b5c2-2929-6d88-5a3fbe719651@redhat.com>
In-Reply-To: <cae4a1d9-b5c2-2929-6d88-5a3fbe719651@redhat.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Thu, 9 Feb 2023 04:40:23 -0800
Message-ID: <CAOHnOrxqEsbRD302Wwn9N06d6xj5NWy4p+C9DBjEm6Z4z2FvXg@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
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

On Wed, Feb 8, 2023 at 9:58 PM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Ricardo,
>
> On 2/7/23 3:58 AM, Ricardo Koller wrote:
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
> > index e94c92988745..871c4eeb0184 100644
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
> > index fed314f2b320..ae80845c8db7 100644
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
> > +     if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> > +             return 0;
> > +
>
> Since stage2_split_walker() has been specified as a leaf walker by KVM_PGTABLE_WALK_LEAF,
> I don't understand how kvm_pte_table() can return true.

Good point. Will remove it. This check made sense for a previous
version (the RFC),
but not anymore.

>
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
>
> I think it's possible 'data->mc_capability' to be replaced by 'mc->nobjs'
> because they're same thing. With this, we needn't to maintain a duplicate
> 'data->mc_capability' since 'data->mc' has been existing.

Ah, nice, yes. That would be simpler.

Thanks!
Ricardo

>
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
> >
>
> Thanks,
> Gavin
>
