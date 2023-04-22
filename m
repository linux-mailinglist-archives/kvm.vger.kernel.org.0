Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368946EBB2B
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 22:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjDVUcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 16:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDVUca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 16:32:30 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41753F4
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 13:32:29 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a9290a6f96so377955ad.1
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 13:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682195549; x=1684787549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s/t6FiR3MRSo2GYBUI2sfW6u9V9cA0LaRdzN2VMKmm4=;
        b=OvmIPVRRIvkvFmgMzN6kH6pS8akcaFWAYvhsJM/LjyesebBLb70Y81d46zcySyvuLW
         N6EQ5MNr0CtLwSGVEnLIzCgJlAyXFuh8Vqo//zUz1pKF2rO1Zb1VetUUgwflgtl/xiRX
         ovJVrBDAiu8rxfiawj5vRX6Y0VCYrEbRjkd1CPD0/YJJNGIYHohamaSox+yTZejVN9bC
         ADpyftteAOBKxpGirfoGH025Sl4bwnrFjJljdSwOLtY+Y1FbMEMRDPyIE5EKFaYUpQrt
         98WiqCC0jADRpaeJiO/IK8RNTqRlaCYHUsjBpkWnf2PvImspxJx1VSQhOMCVmZZGaHIB
         azpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682195549; x=1684787549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/t6FiR3MRSo2GYBUI2sfW6u9V9cA0LaRdzN2VMKmm4=;
        b=PiHeSTfP663hBq9kFGtbvojassejYYasqZq8LORwlI/hFINy+Z72ieub2pBeVTF42h
         rEcUkMgHVdoxhkDm7LBtp0EGwJcTrorIfXfsHeoA6TBkaj07rzsd8n4QHvLKOKZZ+uGh
         SmjmEbItEaTyqrUqy4dIISNM/yaV6KIQdv2rEhB8U2BEFlSmhJ/pWuClMOWDzW0xteFx
         KNyG5bXfwtxygEEQ2pkifS/iFwEXV5q8m6Yffl5BoaonA6+ukwgrgDj7HUJlqoQU91SM
         EXUOHJ7JdmVR+O17cPv+9CDbg31x5/IgiA5ShqLsaIbsHMKiM+prlwHwQ2ABKth6jdHc
         oB6A==
X-Gm-Message-State: AAQBX9d4Gf+SpBjsArTb3CGSQWXCBuBemzQGUreOWmKQwLML++3ULV1C
        c3bhIpgWTOTKO09IoT8x10zLHQ==
X-Google-Smtp-Source: AKy350aeOrrJuJjf821aVj4gCURycD0DOQajNkKIODEvgmL1DU9wGnBxEgTYOYUu5vesfAxT2uAUqw==
X-Received: by 2002:a17:903:2348:b0:1a6:db0a:7fee with SMTP id c8-20020a170903234800b001a6db0a7feemr236327plh.8.1682195548614;
        Sat, 22 Apr 2023 13:32:28 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709027d8b00b0019aaab3f9d7sm4344510plm.113.2023.04.22.13.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 13:32:28 -0700 (PDT)
Date:   Sat, 22 Apr 2023 13:32:25 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v7 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <ZEREWWIMEduE4jBF@google.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-6-ricarkol@google.com>
 <ef8ec8d0-51d9-0971-395e-04d035e948fe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef8ec8d0-51d9-0971-395e-04d035e948fe@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 02:38:06PM +0800, Gavin Shan wrote:
> On 4/9/23 2:29 PM, Ricardo Koller wrote:
> > Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> > range of huge pages. This will be used for eager-splitting huge pages
> > into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> > on write-protection faults, and instead use this function to do it
> > ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> > a time).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h |  19 +++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 103 +++++++++++++++++++++++++++
> >   2 files changed, 122 insertions(+)
> > 
> 
> With the following nits addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index c8e0e7d9303b2..32e5d42bf020f 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -653,6 +653,25 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> >    */
> >   int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> > +/**
> > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > + *				to PAGE_SIZE guest pages.
> > + * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
> > + * @addr:	 Intermediate physical address from which to split.
> > + * @size:	 Size of the range.
> > + * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
>                  ^^^^^^^^
> Alignment.
>

Same as in the previous commit. This is due to the added "+ " in the
diff. The line looks aligned without it.

> > + *		 page-table pages.
> > + *
> > + * The function tries to split any level 1 or 2 entry that overlaps
> > + * with the input range (given by @addr and @size).
> > + *
> > + * Return: 0 on success, negative error code on failure. Note that
> > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > + * blocks in the input range as allowed by @mc_capacity.
> > + */
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +			     struct kvm_mmu_memory_cache *mc);
> > +
> >   /**
> >    * kvm_pgtable_walk() - Walk a page-table.
> >    * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 477d2be67d401..48c5a95c6e8cd 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1272,6 +1272,109 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> >   	return pgtable;
> >   }
> > +/*
> > + * Get the number of page-tables needed to replace a block with a
> > + * fully populated tree up to the PTE entries. Note that @level is
> > + * interpreted as in "level @level entry".
> > + */
> > +static int stage2_block_get_nr_page_tables(u32 level)
> > +{
> > +	switch (level) {
> > +	case 1:
> > +		return PTRS_PER_PTE + 1;
> > +	case 2:
> > +		return 1;
> > +	case 3:
> > +		return 0;
> > +	default:
> > +		WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
> > +			     level >= KVM_PGTABLE_MAX_LEVELS);
> > +		return -EINVAL;
> > +	};
> > +}
> > +
> 
> When the starting level is 3, it's not a block mapping if I'm correct. Besides,
> the caller (stage2_split_walker()) bails when the starting level is 3. In this
> case, the changes may be integrated to stage2_split_walker(), which is the only
> caller. Otherwise, 'inline' is worthy to have.
> 
> 	nr_pages = kvm_granule_shift(level) == PUD_SHIFT && kvm_granule_shift(level) != PMD_SHIFT) ?
>                    (PTRS_PER_PTE + 1) : 1;
> 

Mind if I keep the function? It helps explaining what's going on: we
need to calculate the number of pages needed to replace a block (and how
it's done). Regarding the "inline", Marc suggested removing it as the
compiler will figure it out.

> > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +			       enum kvm_pgtable_walk_flags visit)
> > +{
> > +	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +	struct kvm_mmu_memory_cache *mc = ctx->arg;
> > +	struct kvm_s2_mmu *mmu;
> > +	kvm_pte_t pte = ctx->old, new, *childp;
> > +	enum kvm_pgtable_prot prot;
> > +	u32 level = ctx->level;
> > +	bool force_pte;
> > +	int nr_pages;
> > +	u64 phys;
> > +
> > +	/* No huge-pages exist at the last level */
> > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > +		return 0;
> > +
> > +	/* We only split valid block mappings */
> > +	if (!kvm_pte_valid(pte))
> > +		return 0;
> > +
> > +	nr_pages = stage2_block_get_nr_page_tables(level);
> > +	if (nr_pages < 0)
> > +		return nr_pages;
> > +
> > +	if (mc->nobjs >= nr_pages) {
> > +		/* Build a tree mapped down to the PTE granularity. */
> > +		force_pte = true;
> > +	} else {
> > +		/*
> > +		 * Don't force PTEs, so create_unlinked() below does
> > +		 * not populate the tree up to the PTE level. The
> > +		 * consequence is that the call will require a single
> > +		 * page of level 2 entries at level 1, or a single
> > +		 * page of PTEs at level 2. If we are at level 1, the
> > +		 * PTEs will be created recursively.
> > +		 */
> > +		force_pte = false;
> > +		nr_pages = 1;
> > +	}
> > +
> > +	if (mc->nobjs < nr_pages)
> > +		return -ENOMEM;
> > +
> > +	mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
> > +	phys = kvm_pte_to_phys(pte);
> > +	prot = kvm_pgtable_stage2_pte_prot(pte);
> > +
> > +	childp = kvm_pgtable_stage2_create_unlinked(mmu->pgt, phys,
> > +						    level, prot, mc, force_pte);
> > +	if (IS_ERR(childp))
> > +		return PTR_ERR(childp);
> > +
> > +	if (!stage2_try_break_pte(ctx, mmu)) {
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
> > +	return 0;
> > +}
> > +
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +			     struct kvm_mmu_memory_cache *mc)
> > +{
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb	= stage2_split_walker,
> > +		.flags	= KVM_PGTABLE_WALK_LEAF,
> > +		.arg	= mc,
> > +	};
> > +
> > +	return kvm_pgtable_walk(pgt, addr, size, &walker);
> > +}
> > +
> >   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >   			      struct kvm_pgtable_mm_ops *mm_ops,
> >   			      enum kvm_pgtable_stage2_flags flags,
> > 
> 
> Thanks,
> Gavin
> 
