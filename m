Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914C062AF10
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 00:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238631AbiKOXEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 18:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiKOXDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 18:03:54 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3E22C67F
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 15:03:46 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gw22so14892818pjb.3
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 15:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TM8ZdzPY8VeCgsKf+mKszlJ7zUv1Tn1f4qoClWbV9mo=;
        b=BmG3IRmGqa6sSXc7X5ymjmBqJaVvVnv1G8UM2GvrkOLZPq7P/z0BGh+/mNT7YQ2eRc
         A46tBakC/1l6o+WNXGSpYoRzV+ssLP0VRrezbi1aOHPtqIQuDWC4RHdkYlTdBbjJlceX
         6FY1ofXCLSBBblzs0/fagqt4I1sHsOGRvi8wMzM4ElQigsfeoC23Xp5IvDM+Fj6t5pyT
         YFwG1CFKcEmbDjdgTP1VIr8Thso8mDtOruzE89XXPPTGjy4183N0nc1QKNG5iZF0ujqX
         7MS8CNh6pZrgC9qZe5WeDlcJMo7CGigRknomBv/aA4Yi7ckFWu/Q3lIx/uqKqJBF4hXf
         yEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TM8ZdzPY8VeCgsKf+mKszlJ7zUv1Tn1f4qoClWbV9mo=;
        b=AoTkgqtzHa4Elxq5SOUDSHCI5up+cwttyuV0w8mP0UlwPjsTitpikOSklyXnRHMbz/
         WLhNAwcmAg4Odbuh30q6kjjIAX+USak8lbohJ6cLMH7XMamex0uzNIlBvqW3r5GF9ZmN
         V83HWzLmLsgdSt75UAhPYdHwASGRFycIpW2xsFtNqS4amSr6myPKjdFjfWINns/7zIIF
         gV5i/SWc7KdqktMhB+w4KD2A6IjJEjaGHdHGQ/ceN6N7PBPpjVOgtLaqbZmW6M5oqWuh
         vuXW+jLseFO+Z0UCGeR6Sloh/tySHGlYJNLdcOoFH68zJmf4MzESgBlwprn5zIHRXv+J
         Vq2A==
X-Gm-Message-State: ANoB5plwsbwOhE/p2O04Y7lss30SaWuxhD12MigLpY1Tq/vh1qNKw4Mx
        Hm38aaSes2yh8546zARIzOWjEQ==
X-Google-Smtp-Source: AA0mqf7LfXsB/10HJv75H+dYIS42WcgKPLR/Zxv/4knjej8JRdnsPljaNjB0k7wvSobjL6dcK8km+g==
X-Received: by 2002:a17:902:8c95:b0:17c:1c61:4aec with SMTP id t21-20020a1709028c9500b0017c1c614aecmr6314073plo.112.1668553426142;
        Tue, 15 Nov 2022 15:03:46 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902868300b00168dadc7354sm10473426plo.78.2022.11.15.15.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:03:45 -0800 (PST)
Date:   Tue, 15 Nov 2022 15:03:42 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        ricarkol@gmail.com
Subject: Re: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y3QazjAUVE+T6rHh@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-5-ricarkol@google.com>
 <Y3KrHG4WMXMUquUy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3KrHG4WMXMUquUy@google.com>
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

On Mon, Nov 14, 2022 at 08:54:52PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Sat, Nov 12, 2022 at 08:17:06AM +0000, Ricardo Koller wrote:
> 
> [...]
> 
> > +/**
> > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > + *				to PAGE_SIZE guest pages.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @addr:	Intermediate physical address from which to split.
> > + * @size:	Size of the range.
> > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > + *		page-table pages.
> > + *
> > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > + * the top level huge-page block size. This is an exampe using 1GB
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
> > + * blocks in the input range as allowed by the size of the memcache. It
> > + * will fail it wasn't able to break any block.
> > + */
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> > +
> >  /**
> >   * kvm_pgtable_walk() - Walk a page-table.
> >   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index d1f309128118..9c42eff6d42e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
> >  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
> >  }
> >  
> > +struct stage2_split_data {
> > +	struct kvm_s2_mmu		*mmu;
> > +	void				*memcache;
> > +	struct kvm_pgtable_mm_ops	*mm_ops;
> 
> You can also get at mm_ops through kvm_pgtable_visit_ctx
> 
> > +};
> > +
> > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +			       enum kvm_pgtable_walk_flags visit)
> > +{
> > +	struct stage2_split_data *data = ctx->arg;
> > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > +	kvm_pte_t pte = ctx->old, attr, new;
> > +	enum kvm_pgtable_prot prot;
> > +	void *mc = data->memcache;
> > +	u32 level = ctx->level;
> > +	u64 phys;
> > +
> > +	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> > +		return -EINVAL;
> > +
> > +	/* Nothing to split at the last level */
> > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > +		return 0;
> > +
> > +	/* We only split valid block mappings */
> > +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> > +		return 0;
> > +
> > +	phys = kvm_pte_to_phys(pte);
> > +	prot = kvm_pgtable_stage2_pte_prot(pte);
> > +	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
> > +
> > +	/*
> > +	 * Eager page splitting is best-effort, so we can ignore the error.
> > +	 * The returned PTE (new) will be valid even if this call returns
> > +	 * error: new will be a single (big) block PTE.  The only issue is
> > +	 * that it will affect dirty logging performance, as the huge-pages
> > +	 * will have to be split on fault, and so we WARN.
> > +	 */
> > +	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
> 
> I don't believe we should warn in this case, at least not
> unconditionally. ENOMEM is an expected outcome, for example.

Given that "eager page splitting" is best-effort, the error must be
ignored somewhere: either here or by the caller (in mmu.c). It seems
that ignoring the error here is not a very good idea.

> 
> Additionally, I believe you'll want to bail out at this point to avoid
> installing a potentially garbage PTE as well.

It should be fine as stage2_create_removed() is also best-effort. The
returned PTE is valid even when it fails; it just returns a big block
PTE.

> 
> > +	stage2_put_pte(ctx, data->mmu, mm_ops);
> 
> Ah, I see why you've relaxed the WARN in patch 1 now.
> 
> I would recommend you follow the break-before-make pattern and use the
> helpers here as well. stage2_try_break_pte() will demote the store to
> WRITE_ONCE() if called from a non-shared context.
> 

ACK, I can do that. The only reason why I didnt' is because I would have
to handle the potential error from stage2_try_break_pte(). It would feel
wrong not to, even if it's !shared. On the other hand, I would like to
easily experiment with both the !shared and the shared approaches
easily.

> Then the WARN will behave as expected in stage2_make_pte().
> 
> > +	/*
> > +	 * Note, the contents of the page table are guaranteed to be made
> > +	 * visible before the new PTE is assigned because
> > +	 * stage2_make__pte() writes the PTE using smp_store_release().
> 
> typo: stage2_make_pte()
> 
> --
> Thanks,
> Oliver
