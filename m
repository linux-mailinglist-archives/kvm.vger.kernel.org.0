Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9217628AE0
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 21:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbiKNUzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 15:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiKNUzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 15:55:00 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BFF63FC
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 12:54:59 -0800 (PST)
Date:   Mon, 14 Nov 2022 20:54:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668459297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A678RV37X2a5WAdwm/7rFErOS5ZproL4wmh+eRAOrpo=;
        b=B+rTg85BNob60Y8KzATpVLW3TAzfrCuopXNCGmZ/lR0PoxYCXGLcjQls41txe211SpDK7T
        ck32Iiv8/6yqgWwbkunnWdVMUwao0/YgT7W/3yGETav5Gd240aA9yEebm60YWmftjtErZ+
        kU1REr35oS30HK8FaC8oEq0uIst1ANI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        ricarkol@gmail.com
Subject: Re: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y3KrHG4WMXMUquUy@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-5-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Sat, Nov 12, 2022 at 08:17:06AM +0000, Ricardo Koller wrote:

[...]

> +/**
> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> + *				to PAGE_SIZE guest pages.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @addr:	Intermediate physical address from which to split.
> + * @size:	Size of the range.
> + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> + *		page-table pages.
> + *
> + * @addr and the end (@addr + @size) are effectively aligned down and up to
> + * the top level huge-page block size. This is an exampe using 1GB
> + * huge-pages and 4KB granules.
> + *
> + *                          [---input range---]
> + *                          :                 :
> + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> + *                          :                 :
> + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> + *                          :                 :
> + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> + *                          :                 :
> + *
> + * Return: 0 on success, negative error code on failure. Note that
> + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> + * blocks in the input range as allowed by the size of the memcache. It
> + * will fail it wasn't able to break any block.
> + */
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d1f309128118..9c42eff6d42e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
>  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
>  }
>  
> +struct stage2_split_data {
> +	struct kvm_s2_mmu		*mmu;
> +	void				*memcache;
> +	struct kvm_pgtable_mm_ops	*mm_ops;

You can also get at mm_ops through kvm_pgtable_visit_ctx

> +};
> +
> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +			       enum kvm_pgtable_walk_flags visit)
> +{
> +	struct stage2_split_data *data = ctx->arg;
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	kvm_pte_t pte = ctx->old, attr, new;
> +	enum kvm_pgtable_prot prot;
> +	void *mc = data->memcache;
> +	u32 level = ctx->level;
> +	u64 phys;
> +
> +	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> +		return -EINVAL;
> +
> +	/* Nothing to split at the last level */
> +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> +		return 0;
> +
> +	/* We only split valid block mappings */
> +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> +		return 0;
> +
> +	phys = kvm_pte_to_phys(pte);
> +	prot = kvm_pgtable_stage2_pte_prot(pte);
> +	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
> +
> +	/*
> +	 * Eager page splitting is best-effort, so we can ignore the error.
> +	 * The returned PTE (new) will be valid even if this call returns
> +	 * error: new will be a single (big) block PTE.  The only issue is
> +	 * that it will affect dirty logging performance, as the huge-pages
> +	 * will have to be split on fault, and so we WARN.
> +	 */
> +	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));

I don't believe we should warn in this case, at least not
unconditionally. ENOMEM is an expected outcome, for example.

Additionally, I believe you'll want to bail out at this point to avoid
installing a potentially garbage PTE as well.

> +	stage2_put_pte(ctx, data->mmu, mm_ops);

Ah, I see why you've relaxed the WARN in patch 1 now.

I would recommend you follow the break-before-make pattern and use the
helpers here as well. stage2_try_break_pte() will demote the store to
WRITE_ONCE() if called from a non-shared context.

Then the WARN will behave as expected in stage2_make_pte().

> +	/*
> +	 * Note, the contents of the page table are guaranteed to be made
> +	 * visible before the new PTE is assigned because
> +	 * stage2_make__pte() writes the PTE using smp_store_release().

typo: stage2_make_pte()

--
Thanks,
Oliver
