Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5256B8129
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 19:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjCMSu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 14:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjCMSuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 14:50:22 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824CC22136
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 11:49:56 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k2so6157525pll.8
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 11:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678733393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=25DsBlbnYzgLfbUv0//jnNAcvsBteJ6bqVcMgyivMgw=;
        b=gzs4hNBq584fUnlxy9MSb9w3ruNF/KkvHH9BbakVZRl8hx23UCyMw+xiTmIZOW+AWl
         Lp1vOYHORGHjZnAW6DdsNFLVStK8zGBWOoenEal9tPkKzwJDQ7R/r96w12QMsilBYrKB
         4ozu/gUECfZrue3DSxOmuF8ENBRJ9OxEqvzDNaqBCrDR1Zlp3IEt4gerkyVsCUvugM4p
         sZIpa5sPICo65qk3kr8blH/sy2hGgn4RqZLJ2YtaAcukGQdW/uv+SmsTzXzpp3/MUB+B
         PKOQkmJGw589iXJ/V4FqHAcwaQyIqPKG+/Egurbki7dHgeAMmoa8jhxJ2b/ZSJUUXtWx
         QPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678733393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25DsBlbnYzgLfbUv0//jnNAcvsBteJ6bqVcMgyivMgw=;
        b=XOKas8MLJM/4nKaw1Zas/k+S3JCeDq8jTpNZL3Ma+mqRVlzgaqAHf4Ed8DRQgb7zFr
         +oAurvIFfK5T4IG1BWM6cEdn5NcFE9gE6SD/lR+oKkAFtGY8WM5HYaPukZtwF6M9vNeY
         wM/mAjJq8Ad9nxJmSHp1+KXUryVcTNS3hokXER0WILmuvIa31RYbKqEF7PSTL+M+aDZW
         NFDzj1t9yGreUoTtPZ51lyhKzotPvYR/6QAqjXXB5H+6u89rr1pNyNh7nyOxBGPTOKyD
         LjdEWUEppLIgk3AYK9QFY6pamflrnGXSr3zAdYzfnYmMrYoEWstTS5i/ujCzi9yorKzD
         x73A==
X-Gm-Message-State: AO0yUKVjxjxnR8u0WUPzVopOL8IT2RuL0oVo1TUmuzVmENHre9LAE5ue
        yYO+MABfMc4MuiLsMDYdiJxq8Q==
X-Google-Smtp-Source: AK7set9OpkTliVZ8owp3VBzDUXbV41ZMbMYgRkxriMP4prz9jiiNGkLY7l5wUxQIrsQcvxeifqikJA==
X-Received: by 2002:a17:903:430d:b0:1a0:563e:b0d1 with SMTP id jz13-20020a170903430d00b001a0563eb0d1mr198125plb.18.1678733392548;
        Mon, 13 Mar 2023 11:49:52 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id u19-20020a17090abb1300b00233acae2ce6sm210119pjr.23.2023.03.13.11.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 11:49:52 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:49:48 -0700
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
Subject: Re: [PATCH v6 02/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
Message-ID: <ZA9wTG6fIx2n4YHi@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-3-ricarkol@google.com>
 <87cz5e5jnr.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cz5e5jnr.wl-maz@kernel.org>
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

On Sun, Mar 12, 2023 at 10:49:28AM +0000, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:45 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
> > KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
> > perform break-before-make (BBM) nor cache maintenance operations
> > (CMO). This will by a future commit to create unlinked tables not
> 
> This will *be used*?
> 
> > accessible to the HW page-table walker.  This is safe as these
> > unlinked tables are not visible to the HW page-table walker.
> 
> I don't think this last sentence makes much sense. The PTW is always
> coherent with the CPU caches and doesn't require cache maintenance
> (CMOs are solely for the pages the PTs point to).
> 
> But this makes me question this patch further.
> 
> The key observation here is that if you are creating new PTs that
> shadow an existing structure and still points to the same data pages,
> the cache state is independent of the intermediate PT walk, and thus
> CMOs are pointless anyway. So skipping CMOs makes sense.
> 
> I agree with the assertion that there is little point in doing BBM
> when *creating* page tables, as all PTs start in an invalid state. But
> then, why do you need to skip it? The invalidation calls are already
> gated on the previous pointer being valid, which I presume won't be
> the case for what you describe here.
> 

I need to change the SKIP_BBM name; it's confusing, sorry for that. As
you noticed below, SKIP_BBM just skips the TLB invalidation step in the
BBM, so the invalidation still occurs with SKIP_BBM=true.

Thanks for the reviews Marc.

> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
> >  2 files changed, 34 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 26a4293726c1..c7a269cad053 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -195,6 +195,12 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
> >   *					with other software walkers.
> >   * @KVM_PGTABLE_WALK_HANDLE_FAULT:	Indicates the page-table walk was
> >   *					invoked from a fault handler.
> > + * @KVM_PGTABLE_WALK_SKIP_BBM:		Visit and update table entries
> > + *					without Break-before-make
> > + *					requirements.
> > + * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
> > + *					without Cache maintenance
> > + *					operations required.
> 
> We have both I and D side CMOs. Is it reasonable to always treat them
> identically?
> 
> >   */
> >  enum kvm_pgtable_walk_flags {
> >  	KVM_PGTABLE_WALK_LEAF			= BIT(0),
> > @@ -202,6 +208,8 @@ enum kvm_pgtable_walk_flags {
> >  	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
> >  	KVM_PGTABLE_WALK_SHARED			= BIT(3),
> >  	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
> > +	KVM_PGTABLE_WALK_SKIP_BBM		= BIT(5),
> > +	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
> >  };
> >  
> >  struct kvm_pgtable_visit_ctx {
> > @@ -223,6 +231,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
> >  	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
> >  }
> >  
> > +static inline bool kvm_pgtable_walk_skip_bbm(const struct kvm_pgtable_visit_ctx *ctx)
> > +{
> > +	return ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM;
> 
> Probably worth wrapping this with an 'unlikely'.
> 
> > +}
> > +
> > +static inline bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
> > +{
> > +	return ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO;
> 
> Same here.
> 
> Also, why are these in kvm_pgtable.h? Can't they be moved inside
> pgtable.c and thus have the "inline" attribute dropped?
> 
> > +}
> > +
> >  /**
> >   * struct kvm_pgtable_walker - Hook into a page-table walk.
> >   * @cb:		Callback function to invoke during the walk.
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index a3246d6cddec..4f703cc4cb03 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -741,14 +741,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> >  	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
> >  		return false;
> >  
> > -	/*
> > -	 * Perform the appropriate TLB invalidation based on the evicted pte
> > -	 * value (if any).
> > -	 */
> > -	if (kvm_pte_table(ctx->old, ctx->level))
> > -		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > -	else if (kvm_pte_valid(ctx->old))
> > -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> > +	if (!kvm_pgtable_walk_skip_bbm(ctx)) {
> > +		/*
> > +		 * Perform the appropriate TLB invalidation based on the
> > +		 * evicted pte value (if any).
> > +		 */
> > +		if (kvm_pte_table(ctx->old, ctx->level))
> 
> You're not skipping BBM here. You're skipping the TLB invalidation.
> Not quite the same thing.
> 
> > +			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +		else if (kvm_pte_valid(ctx->old))
> > +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> > +				     ctx->addr, ctx->level);
> > +	}
> >  
> >  	if (stage2_pte_is_counted(ctx->old))
> >  		mm_ops->put_page(ctx->ptep);
> > @@ -832,11 +835,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >  		return -EAGAIN;
> >  
> >  	/* Perform CMOs before installation of the guest stage-2 PTE */
> > -	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> > +	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->dcache_clean_inval_poc &&
> > +	    stage2_pte_cacheable(pgt, new))
> >  		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> > -						granule);
> > +					       granule);
> >  
> > -	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> > +	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->icache_inval_pou &&
> > +	    stage2_pte_executable(new))
> >  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> >  
> >  	stage2_make_pte(ctx, new);
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
