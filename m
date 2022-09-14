Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DDD5B7DF8
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 02:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiINAwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 20:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiINAwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 20:52:01 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3320A371AF
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 17:52:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r23so4292013pgr.6
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 17:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=CT92j6tCxFfRZCqWY+0RsmfIURyeela0R3FbUxkSEXA=;
        b=cgRpIsMu0sY8TKHmNRgR4MKetGHKJRZYfqHceV78oKOfizDpGrpq06Zv1NGuZ38zuf
         odVigm4u4qPDOor5HN5/WV1I6v9q8s4tp4asoO+7epdSmsdWWXnB2pdcDpIknT6vWeW3
         3sLrxnuxYzsvZ/3F90rE6r9i2v4cwDq9nxwQUzcS5iBBMjcN2gAUnWD0rBLfdH8x2K1B
         za6wyueWfWee0Lb/tiz6uh8Q3aKTaXyiqoO/owaxkeOv7o35mbY9lkTcrtadV8v5S9tm
         DNlp6ypDZ6+A6Oe9vpyrkjGkJSQmtULSvaAcl0VJ6V2oGbwxb4atbZ0CT9Y1h++BC7MI
         Gu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=CT92j6tCxFfRZCqWY+0RsmfIURyeela0R3FbUxkSEXA=;
        b=eLOi4n+K8Y3pN9P1juY9lVVrC+ZWj9QOwI+j4wSlQ2DU2iOAXUaY/EQD5xMCBCRHvX
         xgUBFsUgifGomH4CKc1MFfxSg6wjbm1AveMS18i/mg8H6S1sGQAvH/f+/Q1Z58fIKths
         EGplj+7DkBIoN0V16llGof7AVslERxXT2RWGpCvFx9u9YPAJKJHhVpDAVIb3csVt5jmX
         u1Plf1SQCNL4O0Zi8+Fstq0NXdDyFSnlaq2VHdn6tLaIfargi8Xqcpr1eJvzgp91kQB/
         p/1cxYi8VXi9Fd97mo8a1HVoJYZMH9YRNjcoC3Dxg+ZzrRuMajQ9XAwyReAfc3Hguj4C
         AcbA==
X-Gm-Message-State: ACgBeo0RMNkayj2nOUEW5RogdJyy5xiNSPqa74uQ3wH9MgeVhFi6MCe6
        kYW3jtHavWld/eqowXfDJDfOaw==
X-Google-Smtp-Source: AA6agR5GjBnaRX3fVEsuzgfSGNv0ro7BnN3Nfszv29mu5h+OuwOhxaI1d2CFE4UJ9YkeXhgPmagp5w==
X-Received: by 2002:a05:6a00:14c4:b0:542:cd3a:591e with SMTP id w4-20020a056a0014c400b00542cd3a591emr14315838pfu.27.1663116719529;
        Tue, 13 Sep 2022 17:51:59 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id p8-20020a1709027ec800b00174ea015ee2sm9297880plb.38.2022.09.13.17.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 17:51:58 -0700 (PDT)
Date:   Tue, 13 Sep 2022 17:51:55 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] KVM: arm64: Make changes block->table to leaf PTEs
 parallel-aware
Message-ID: <YyElq0c6WD1zh7Lu@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830195102.964724-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830195102.964724-1-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 07:51:01PM +0000, Oliver Upton wrote:
> In order to service stage-2 faults in parallel, stage-2 table walkers
> must take exclusive ownership of the PTE being worked on. An additional
> requirement of the architecture is that software must perform a
> 'break-before-make' operation when changing the block size used for
> mapping memory.
> 
> Roll these two concepts together into helpers for performing a
> 'break-before-make' sequence. Use a special PTE value to indicate a PTE
> has been locked by a software walker. Additionally, use an atomic
> compare-exchange to 'break' the PTE when the stage-2 page tables are
> possibly shared with another software walker. Elide the DSB + TLBI if
> the evicted PTE was invalid (and thus not subject to break-before-make).
> 
> All of the atomics do nothing for now, as the stage-2 walker isn't fully
> ready to perform parallel walks.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 87 +++++++++++++++++++++++++++++++++---
>  1 file changed, 82 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 61a4437c8c16..71ae96608752 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -49,6 +49,12 @@
>  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
>  #define KVM_MAX_OWNER_ID		1
>  
> +/*
> + * Used to indicate a pte for which a 'break-before-make' sequence is in
> + * progress.
> + */
> +#define KVM_INVALID_PTE_LOCKED		BIT(10)
> +
>  struct kvm_pgtable_walk_data {
>  	struct kvm_pgtable		*pgt;
>  	struct kvm_pgtable_walker	*walker;
> @@ -586,6 +592,8 @@ struct stage2_map_data {
>  
>  	/* Force mappings to page granularity */
>  	bool				force_pte;
> +
> +	bool				shared;
>  };
>  
>  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> @@ -691,6 +699,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>  	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
>  }
>  
> +static bool stage2_pte_is_locked(kvm_pte_t pte)
> +{
> +	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> +}
> +
>  static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bool shared)
>  {
>  	if (!shared) {
> @@ -701,6 +714,69 @@ static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bo
>  	return cmpxchg(ptep, old, new) == old;
>  }
>  
> +/**
> + * stage2_try_break_pte() - Invalidates a pte according to the
> + *			    'break-before-make' requirements of the
> + *			    architecture.
> + *
> + * @ptep: Pointer to the pte to break
> + * @old: The previously observed value of the pte
> + * @addr: IPA corresponding to the pte
> + * @level: Table level of the pte
> + * @shared: true if the stage-2 page tables could be shared by multiple software
> + *	    walkers
> + *
> + * Returns: true if the pte was successfully broken.
> + *
> + * If the removed pte was valid, performs the necessary serialization and TLB
> + * invalidation for the old value. For counted ptes, drops the reference count
> + * on the containing table page.
> + */
> +static bool stage2_try_break_pte(kvm_pte_t *ptep, kvm_pte_t old, u64 addr, u32 level,
> +				 struct stage2_map_data *data)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +
> +	if (stage2_pte_is_locked(old)) {
> +		/*
> +		 * Should never occur if this walker has exclusive access to the
> +		 * page tables.
> +		 */
> +		WARN_ON(!data->shared);
> +		return false;
> +	}

The above check is not needed as the cmpxchg() will return false if the
old pte is equal to "new" (KVM_INVALID_PTE_LOCKED).

> +
> +	if (!stage2_try_set_pte(ptep, old, KVM_INVALID_PTE_LOCKED, data->shared))
> +		return false;
> +
> +	/*
> +	 * Perform the appropriate TLB invalidation based on the evicted pte
> +	 * value (if any).
> +	 */
> +	if (kvm_pte_table(old, level))
> +		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> +	else if (kvm_pte_valid(old))
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> +
> +	if (stage2_pte_is_counted(old))
> +		mm_ops->put_page(ptep);
> +
> +	return true;
> +}
> +
> +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new,
> +			    struct stage2_map_data *data)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +
> +	WARN_ON(!stage2_pte_is_locked(*ptep));
> +
> +	if (stage2_pte_is_counted(new))
> +		mm_ops->get_page(ptep);
> +
> +	smp_store_release(ptep, new);
> +}
> +
>  static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>  			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
>  {
> @@ -836,17 +912,18 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	if (!childp)
>  		return -ENOMEM;
>  
> +	if (!stage2_try_break_pte(ptep, *old, addr, level, data)) {
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
> +
>  	/*
>  	 * If we've run into an existing block mapping then replace it with
>  	 * a table. Accesses beyond 'end' that fall within the new table
>  	 * will be mapped lazily.
>  	 */
> -	if (stage2_pte_is_counted(pte))
> -		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> -
>  	new = kvm_init_table_pte(childp, mm_ops);
> -	mm_ops->get_page(ptep);
> -	smp_store_release(ptep, new);
> +	stage2_make_pte(ptep, *old, new, data);
>  	*old = new;
>  
>  	return 0;
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
