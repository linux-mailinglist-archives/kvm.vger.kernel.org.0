Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998936B8672
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 00:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCMX6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 19:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjCMX6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 19:58:39 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE420E04C
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 16:58:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id rj10so3099100pjb.4
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 16:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678751914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PDGcCbApk5SWwy8kMHL+dkdFkrI2nhTDi1PUuQqqAaQ=;
        b=DryNVkrkPQR7Y8Frs7sEVAlw83RREkA6IF0+9mmWSUQyTMzlEkUFDpbr4pJGIp/QMY
         rGpI3UYjyL0TbLhkw3wbcC1UXJELK8y+jymeZZDfrTwh4q3VCs1yDk4R0L5FIxoIZ0dZ
         d8emcyC0X112nr53vG/poiTBbeVJA7H07fI1oNMDakalatUD0omup49Y2VZqf3SxJp6J
         lbDAIQ+y7olJqs4BKdlNF1ic7r5SlC5+kjwu3yDQPCH1XGzZQAfV0RbsYiAfVoYZ7yAs
         b9aj/oLomDwuIi/Q5KZ6mDgSsEPA2s2k+IABYOxjgiwWuO6eUAy1BRPLheQQH2xq6Fzs
         wiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678751914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDGcCbApk5SWwy8kMHL+dkdFkrI2nhTDi1PUuQqqAaQ=;
        b=3HCSqqLwabPwYTjNX9IKjDqJy3EfohsiKHyOY0MNvRKzD1yYr7SJhSEq+qWJJ0nkxw
         oBReW5W0PYSb7Qz8T9dyw6OKYRsaFG9NxMhx4I1dj1StrmMjVwg1ZUk+8MqMkzjELS7M
         M/qLoPacX8gKZ/Ni2OrIdRojfSqZdlh+wQMWRjk97bOLIzEZzOoT25c7+B5ApV7/dMIf
         XrBONJJUyGHuc8WDpZP8dPKZerKkgJj27fyuybw5qmJDVEIZ+obYbkD1YRmTOLx4e1Ko
         6xddAFVfufOa87RdDds06/r9cmPMjnyGiDTMDLu7KNngFb+10voOQ+m5uCbptlt7Cecx
         XGEQ==
X-Gm-Message-State: AO0yUKWSNaGE3WEAfLn/Fa3CJWE22nwQR5HkK1JQOT+IPBBseJLi0Bsc
        FyRTmJ5QHd6wURtSJ+X9Jrg2IQ==
X-Google-Smtp-Source: AK7set/Hu7vqd1wnczHiPPHnEjFdjll2EklIz6df1Wi2Pzcr8jT04QXk+2sps3I4+iud/g2olGWDWg==
X-Received: by 2002:a17:903:430e:b0:19c:c5d4:afd2 with SMTP id jz14-20020a170903430e00b0019cc5d4afd2mr7340plb.11.1678751914078;
        Mon, 13 Mar 2023 16:58:34 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id bu11-20020a17090aee4b00b002342ccc8280sm414596pjb.6.2023.03.13.16.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 16:58:33 -0700 (PDT)
Date:   Mon, 13 Mar 2023 16:58:30 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v6 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <ZA+4pv6UIDpAp5aY@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-5-ricarkol@google.com>
 <87a60i5hju.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a60i5hju.wl-maz@kernel.org>
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

On Sun, Mar 12, 2023 at 11:35:01AM +0000, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:47 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> > range of huge pages. This will be used for eager-splitting huge pages
> > into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> > on write-protection faults, and instead use this function to do it
> > ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> > a time).
> > 
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> 
> Same comment as before about the usefulness of this last sentence.
> 
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  30 +++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 113 +++++++++++++++++++++++++++
> >  2 files changed, 143 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index b7b3fc0fa7a5..40e323a718fc 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -665,6 +665,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> >   */
> >  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >  
> > +/**
> > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > + *				to PAGE_SIZE guest pages.
> > + * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
> > + * @addr:	 Intermediate physical address from which to split.
> > + * @size:	 Size of the range.
> > + * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
> > + *		 page-table pages.
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
> 
> So here, what alignment do we effectively get?
>

The function tries to split any block that overlaps with the input
range. Here's another example that might be more helpful:

 *                                [---input range---]
 *                                :                 :
 * [--1G block pte--][--2MB--][--2MB--][--1G block pte--][--1G block pte--]

is split like this:

 * [--1G block pte--][--2MB--][ ][ ][ ][ ][ ][ ][ ][ ][ ][--1G block pte--]
                              <-------split range------->

I think I will just use this new description instead.

> > + * Return: 0 on success, negative error code on failure. Note that
> > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > + * blocks in the input range as allowed by @mc_capacity.
> > + */
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +			     void *mc, u64 mc_capacity);
> > +
> >  /**
> >   * kvm_pgtable_walk() - Walk a page-table.
> >   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 6bdfcb671b32..3149b98d1701 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1259,6 +1259,119 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> >  	return pgtable;
> >  }
> >  
> > +struct stage2_split_data {
> > +	struct kvm_s2_mmu		*mmu;
> > +	void				*memcache;
> > +	u64				mc_capacity;
> 
> Why isn't this a pointer to a *real* memcache structure?
> 

Mainly because I wanted this function to be like the other pgtable.c
funtions that use opaque pointers to handle the vhe and nvhe cases. vhe
uses "struct kvm_mmu_memory_cache" while nvhe uses "struct hyp_pool".
This series only implements the vhe case but I didn't want to restrict
kvm_pgtable_stage2_split() to vhe just because of this. Just in case, I
have not tried it in nvhe.

> > +};
> > +
> > +/*
> > + * Get the number of page-tables needed to replace a block with a
> > + * fully populated tree, up to the PTE level, at particular level.
> > + */
> > +static inline int stage2_block_get_nr_page_tables(u32 level)
> 
> Please drop the inline. The compiler will figure it out.
> 
> > +{
> > +	if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
> > +			 level >= KVM_PGTABLE_MAX_LEVELS))
> > +		return -EINVAL;
> 
> Move this check to the 'default' case below.
> 
> > +
> > +	switch (level) {
> > +	case 1:
> > +		return PTRS_PER_PTE + 1;
> > +	case 2:
> > +		return 1;
> 
> This is odd. Replacing a block by a table always requires
> 'PTRS_PER_PTE + 1' pages. Why 1? If this is some special treatment for
> level-2 mappings, please spell it out.

I'm not sure I understand. I'm interpreting "level=X" as in "level X
entry".  More specifically, using PAGE_SIZE=4096 as an example:

a level 3 entry (a PTE): a 4096 block needs 0 page-table pages
a level 2 entry: a 2M block needs 1 page-table pages
a level 1 entry: a 1G block needs 512+1 page-table pages

> 
> > +	case 3:
> > +		return 0;
> > +	default:
> > +		return -EINVAL;
> > +	};
> > +}
> > +
> > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +			       enum kvm_pgtable_walk_flags visit)
> > +{
> > +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +	struct stage2_split_data *data = ctx->arg;
> > +	kvm_pte_t pte = ctx->old, new, *childp;
> > +	enum kvm_pgtable_prot prot;
> > +	void *mc = data->memcache;
> > +	u32 level = ctx->level;
> > +	bool force_pte;
> > +	int nr_pages;
> > +	u64 phys;
> > +
> > +	/* No huge-pages exist at the last level */
> > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > +		return 0;
> 
> Why the check for level 3 in the previous function if never get there?
> 

Was trying to make stage2_block_get_nr_page_tables() useful for other
cases. It's still correct for other cases to ask how many page-table
pages are needed for a PTE (stage2_block_get_nr_page_tables(3) -> 0).

> > +
> > +	/* We only split valid block mappings */
> > +	if (!kvm_pte_valid(pte))
> > +		return 0;
> > +
> > +	nr_pages = stage2_block_get_nr_page_tables(level);
> > +	if (nr_pages < 0)
> > +		return nr_pages;
> > +
> > +	if (data->mc_capacity >= nr_pages) {
> > +		/* Build a tree mapped down to the PTE granularity. */
> > +		force_pte = true;
> > +	} else {
> > +		/*
> > +		 * Don't force PTEs. This requires a single page of PMDs at the
> > +		 * PUD level, or a single page of PTEs at the PMD level. If we
> > +		 * are at the PUD level, the PTEs will be created recursively.
> > +		 */
> 
> I don't understand how you reach this 'single page' conclusion. You
> need to explain why you get there.

Ack, will expand it.

> 
> > +		force_pte = false;
> > +		nr_pages = 1;
> > +	}
> > +
> > +	if (data->mc_capacity < nr_pages)
> > +		return -ENOMEM;
> > +
> > +	phys = kvm_pte_to_phys(pte);
> > +	prot = kvm_pgtable_stage2_pte_prot(pte);
> > +
> > +	childp = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, phys,
> > +						    level, prot, mc, force_pte);
> > +	if (IS_ERR(childp))
> > +		return PTR_ERR(childp);
> > +
> > +	if (!stage2_try_break_pte(ctx, data->mmu)) {
> > +		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> > +		mm_ops->put_page(childp);
> > +		return -EAGAIN;
> > +	}
> > +
> > +	/*
> > +	 * Note, the contents of the page table are guaranteed to be made
> > +	 * visible before the new PTE is assigned because stage2_make_pte()
> > +	 * writes the PTE using smp_store_release().
> > +	 */
> > +	new = kvm_init_table_pte(childp, mm_ops);
> > +	stage2_make_pte(ctx, new);
> > +	dsb(ishst);
> > +	data->mc_capacity -= nr_pages;
> > +	return 0;
> > +}
> > +
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +			     void *mc, u64 mc_capacity)
> > +{
> > +	struct stage2_split_data split_data = {
> > +		.mmu		= pgt->mmu,
> > +		.memcache	= mc,
> > +		.mc_capacity	= mc_capacity,
> > +	};
> > +
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb	= stage2_split_walker,
> > +		.flags	= KVM_PGTABLE_WALK_LEAF,
> > +		.arg	= &split_data,
> > +	};
> > +
> > +	return kvm_pgtable_walk(pgt, addr, size, &walker);
> > +}
> > +
> >  int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >  			      struct kvm_pgtable_mm_ops *mm_ops,
> >  			      enum kvm_pgtable_stage2_flags flags,
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
