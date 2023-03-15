Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F516BBCB4
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 19:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjCOSvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 14:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjCOSvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 14:51:49 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA354FA93
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 11:51:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j13so4178667pjd.1
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 11:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678906307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=42QJ/DBAenrkxWAeMRihXI7VBg+g91dINOBJSBMNT6g=;
        b=RAiAVGnrNSMFFwIsO8ZS/ykc00hqK9Nn2xFiUsL8LMQwpu9+o+JmRJ1qUKgsTJtRPX
         axqFBOSGdI/BT/PcSnpuVuBQzXL4SkNMA6Fci0SRoLA9KchB8uvkxDwqJWv9jDT/V4yl
         9u7CLTia1Pj3FdEjYqmfn6jWN81D+7Chz/tTFIoVwAgjYJfdLr7TpM6+Yau4WK9p55oF
         tBsL8bFpEyoF7N0L7R6zn0AXzeDL6fJP9YFoIJKYY1NBVMox3EfiDQZk7Fd+YJoJTFLe
         07lYtMDrE6HVZ3KiavxSqkunlZ9FgbtXui+YlAc8ncXI+6fBmLcCUuHr20lDb1t+ndeW
         u/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678906307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=42QJ/DBAenrkxWAeMRihXI7VBg+g91dINOBJSBMNT6g=;
        b=Z0ruu9Bb8O+D2hRWtgEGDAMhcZHBpyDQUf2/sEi3rAtirxIxiNKs5JbBo6fKVByj97
         HalgS8mPyDA6KqzEKmgfHI5uuoRCtnJxwWg4Xc9nR3qRPoJKXRDw5R6xdwRHwS2+n3IN
         +uV2ORBy7EClpX5xG80lZ806Qy+RjLf4FV14edH59gEm8fPYP6hu9MciCL05ML4ErCxh
         RLpMZs9Y8k7j7ooPDainxL/IAo2KpspUsytEX+TtI222QENUn3u/zPCkl+IynL+4iKO2
         TcqM9RJgXn7blW071oYKZbJqLlHmrTjdFQ8OXX+GQEagIlb5VNHRoi29EvjvWxacfyYX
         DwbA==
X-Gm-Message-State: AO0yUKUFA7UylJHBu9WP1hQdc+MzbGK5QHHvCKXTAkNf6lVOKjxpB/1S
        OKD/RG3SRAdMfn5qeCSC/BTolA==
X-Google-Smtp-Source: AK7set/LbDY9dq5BoETie4emgO/oAQrqFkge0qdWxrYH3TVgSeJ/bw8tn0xlnRTBJIEN08EFTezdjg==
X-Received: by 2002:a17:903:41d2:b0:19a:5a9d:3c with SMTP id u18-20020a17090341d200b0019a5a9d003cmr254548ple.16.1678906306512;
        Wed, 15 Mar 2023 11:51:46 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id d10-20020a63fd0a000000b004fba32949c3sm3630006pgh.16.2023.03.15.11.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 11:51:46 -0700 (PDT)
Date:   Wed, 15 Mar 2023 11:51:42 -0700
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
Message-ID: <ZBITvmlzkJS+P4Rm@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-5-ricarkol@google.com>
 <87a60i5hju.wl-maz@kernel.org>
 <ZA+4pv6UIDpAp5aY@google.com>
 <86cz59yjhz.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cz59yjhz.wl-maz@kernel.org>
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

On Wed, Mar 15, 2023 at 06:09:12PM +0000, Marc Zyngier wrote:
> On Mon, 13 Mar 2023 23:58:30 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Sun, Mar 12, 2023 at 11:35:01AM +0000, Marc Zyngier wrote:
> > > On Tue, 07 Mar 2023 03:45:47 +0000,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > 
> > > > Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> > > > range of huge pages. This will be used for eager-splitting huge pages
> > > > into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> > > > on write-protection faults, and instead use this function to do it
> > > > ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> > > > a time).
> > > > 
> > > > No functional change intended. This new function will be used in a
> > > > subsequent commit.
> > > 
> > > Same comment as before about the usefulness of this last sentence.
> > > 
> > > > 
> > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_pgtable.h |  30 +++++++
> > > >  arch/arm64/kvm/hyp/pgtable.c         | 113 +++++++++++++++++++++++++++
> > > >  2 files changed, 143 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > > index b7b3fc0fa7a5..40e323a718fc 100644
> > > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > > @@ -665,6 +665,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> > > >   */
> > > >  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> > > >  
> > > > +/**
> > > > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > > > + *				to PAGE_SIZE guest pages.
> > > > + * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
> > > > + * @addr:	 Intermediate physical address from which to split.
> > > > + * @size:	 Size of the range.
> > > > + * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
> > > > + *		 page-table pages.
> > > > + * @mc_capacity: Number of pages in @mc.
> > > > + *
> > > > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > > > + * the top level huge-page block size. This is an example using 1GB
> > > > + * huge-pages and 4KB granules.
> > > > + *
> > > > + *                          [---input range---]
> > > > + *                          :                 :
> > > > + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> > > > + *                          :                 :
> > > > + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> > > > + *                          :                 :
> > > > + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> > > > + *                          :                 :
> > > 
> > > So here, what alignment do we effectively get?
> > >
> > 
> > The function tries to split any block that overlaps with the input
> > range. Here's another example that might be more helpful:
> > 
> >  *                                [---input range---]
> >  *                                :                 :
> >  * [--1G block pte--][--2MB--][--2MB--][--1G block pte--][--1G block pte--]
> > 
> > is split like this:
> > 
> >  * [--1G block pte--][--2MB--][ ][ ][ ][ ][ ][ ][ ][ ][ ][--1G block pte--]
> >                               <-------split range------->
> > 
> > I think I will just use this new description instead.
> > 
> > > > + * Return: 0 on success, negative error code on failure. Note that
> > > > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > > > + * blocks in the input range as allowed by @mc_capacity.
> > > > + */
> > > > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > > > +			     void *mc, u64 mc_capacity);
> > > > +
> > > >  /**
> > > >   * kvm_pgtable_walk() - Walk a page-table.
> > > >   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > > index 6bdfcb671b32..3149b98d1701 100644
> > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > @@ -1259,6 +1259,119 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > > >  	return pgtable;
> > > >  }
> > > >  
> > > > +struct stage2_split_data {
> > > > +	struct kvm_s2_mmu		*mmu;
> > > > +	void				*memcache;
> > > > +	u64				mc_capacity;
> > > 
> > > Why isn't this a pointer to a *real* memcache structure?
> > > 
> > 
> > Mainly because I wanted this function to be like the other pgtable.c
> > funtions that use opaque pointers to handle the vhe and nvhe cases. vhe
> > uses "struct kvm_mmu_memory_cache" while nvhe uses "struct hyp_pool".
> > This series only implements the vhe case but I didn't want to restrict
> > kvm_pgtable_stage2_split() to vhe just because of this. Just in case, I
> > have not tried it in nvhe.
> 
> Do you really mean nVHE here? or do you actually mean pKVM? The former
> shouldn't be any different from VHE (the PT code runs in the same
> context, give or take), and it is only the latter that is using
> something else altogether.
> 
> And since pKVM cannot really do page splitting in the normal KVM
> sense, this code shouldn't even be there!
> 

I see, then this should definitely be using "struct
kvm_mmu_memory_cache".  Thanks for the info.

> > 
> > > > +};
> > > > +
> > > > +/*
> > > > + * Get the number of page-tables needed to replace a block with a
> > > > + * fully populated tree, up to the PTE level, at particular level.
> > > > + */
> > > > +static inline int stage2_block_get_nr_page_tables(u32 level)
> > > 
> > > Please drop the inline. The compiler will figure it out.
> > > 
> > > > +{
> > > > +	if (WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
> > > > +			 level >= KVM_PGTABLE_MAX_LEVELS))
> > > > +		return -EINVAL;
> > > 
> > > Move this check to the 'default' case below.
> > > 
> > > > +
> > > > +	switch (level) {
> > > > +	case 1:
> > > > +		return PTRS_PER_PTE + 1;
> > > > +	case 2:
> > > > +		return 1;
> > > 
> > > This is odd. Replacing a block by a table always requires
> > > 'PTRS_PER_PTE + 1' pages. Why 1? If this is some special treatment for
> > > level-2 mappings, please spell it out.
> > 
> > I'm not sure I understand. I'm interpreting "level=X" as in "level X
> > entry".  More specifically, using PAGE_SIZE=4096 as an example:
> > 
> > a level 3 entry (a PTE): a 4096 block needs 0 page-table pages
> > a level 2 entry: a 2M block needs 1 page-table pages
> > a level 1 entry: a 1G block needs 512+1 page-table pages
> 
> Ah, gotcha. I was reasoning at the block level, not at the entry
> level. Maybe some extra idiot-proof explanation would help here for
> the next time I look at this after having paged it out.
> 
> > 
> > > 
> > > > +	case 3:
> > > > +		return 0;
> > > > +	default:
> > > > +		return -EINVAL;
> > > > +	};
> > > > +}
> > > > +
> > > > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > > +			       enum kvm_pgtable_walk_flags visit)
> > > > +{
> > > > +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > > > +	struct stage2_split_data *data = ctx->arg;
> > > > +	kvm_pte_t pte = ctx->old, new, *childp;
> > > > +	enum kvm_pgtable_prot prot;
> > > > +	void *mc = data->memcache;
> > > > +	u32 level = ctx->level;
> > > > +	bool force_pte;
> > > > +	int nr_pages;
> > > > +	u64 phys;
> > > > +
> > > > +	/* No huge-pages exist at the last level */
> > > > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > > > +		return 0;
> > > 
> > > Why the check for level 3 in the previous function if never get there?
> > > 
> > 
> > Was trying to make stage2_block_get_nr_page_tables() useful for other
> > cases. It's still correct for other cases to ask how many page-table
> > pages are needed for a PTE (stage2_block_get_nr_page_tables(3) -> 0).
> 
> Right. I don't mind either way, but the double check somehow tickled
> me.
> 
> > > > +
> > > > +	/* We only split valid block mappings */
> > > > +	if (!kvm_pte_valid(pte))
> > > > +		return 0;
> > > > +
> > > > +	nr_pages = stage2_block_get_nr_page_tables(level);
> > > > +	if (nr_pages < 0)
> > > > +		return nr_pages;
> > > > +
> > > > +	if (data->mc_capacity >= nr_pages) {
> > > > +		/* Build a tree mapped down to the PTE granularity. */
> > > > +		force_pte = true;
> > > > +	} else {
> > > > +		/*
> > > > +		 * Don't force PTEs. This requires a single page of PMDs at the
> > > > +		 * PUD level, or a single page of PTEs at the PMD level. If we
> > > > +		 * are at the PUD level, the PTEs will be created recursively.
> > > > +		 */
> > > 
> > > I don't understand how you reach this 'single page' conclusion. You
> > > need to explain why you get there.
> > 
> > Ack, will expand it.
> 
> Thanks. The above explanation you gave helped, so something long these
> lines would be good.
> 
> Cheers,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
