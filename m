Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5559268CAB1
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjBFXlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjBFXlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:41:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8898F2E804
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 15:41:46 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id pj3so13223284pjb.1
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 15:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uhnlX2CSS0B3cBEKlSq7BD8ZLSZg6DP00qH5VYSGclU=;
        b=DtzX/n609+OHwI5XsNswm/boUQNzSdqH6NyRgJLShbb3lBrGS9RK5Mu+k1eiK3+Rlc
         oAr9YfdofMZ2haMJTYuIgWK7GQgkRB6XDPKcE6Uzc+es73ZA/Q5vMkP8nc3/ASQv2FZZ
         VRvpC6y7Ie6mcSBBhI/5EgFo53pqBUMRA7QmnhLVzN+e0VABYGI1CcBeAQ3HvHSmRqeO
         Ey1M5ObxJthARgbIj4GD7W8zWekpnJ5eW8/lBNqvq6P6yZnWeGizTe0x/fnPyXDLenJD
         jggmXV1dIZYB5isIMDbmGlPyochdwUJT81QgIeVmONMt+fV39fKMMVOpvkIgVDmuaOSy
         i9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uhnlX2CSS0B3cBEKlSq7BD8ZLSZg6DP00qH5VYSGclU=;
        b=TxWgIsuHSWbxTwirh6qt+NXs9prYBzt+wiejQdSY9YvZo02lquDQNWqpLeA15aUkA4
         6PVZ9EY9uRunhnucZirCXK3QZyz+BNZFg71ASgKKCNRPKX5GOaIRqYg4i8HX/YJfASpi
         MGdVD3CTpF6bPsGoQhH5RVxX8oZgWJSN3TfcqX08hM7qOkvI0w4Yjjyicua+/NPA9cfu
         I4Ts24TB2aGZ2s608MvzdEw1txiAxyslpBqCSaTgMNaxjfhvgR32SuDZi5mTD6PUVqqw
         6ilgQpJCqtbxwoo0sGKnQ1UtY7y+Pt5gP0bsK0wZW73bf9zucI2+x0j6MeTIcPB3IIpN
         /CIw==
X-Gm-Message-State: AO0yUKVwivVQxrUu90+tdZTasihrLJQejNFp2FYNJFG/H1VDHjYS3+x9
        QvGIfpfTn343e2WB7Awkd2eIKg==
X-Google-Smtp-Source: AK7set+pyZ0OHv9IVLoBokExj6pJIOurmOkVOr85a1VTPdkTEOhoD45BjlojQuHCfHWha19mqiYIQQ==
X-Received: by 2002:a17:902:c111:b0:199:1a4f:adc3 with SMTP id 17-20020a170902c11100b001991a4fadc3mr652111pli.68.1675726905828;
        Mon, 06 Feb 2023 15:41:45 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902710700b00196048cc113sm7430804pll.126.2023.02.06.15.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:41:45 -0800 (PST)
Date:   Mon, 6 Feb 2023 15:41:41 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 2/5] KVM: x86/mmu: Optimize SPTE change flow for
 clear-dirty-log
Message-ID: <Y+GQNXDlNbJNvDd2@google.com>
References: <20230203192822.106773-1-vipinsh@google.com>
 <20230203192822.106773-3-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203192822.106773-3-vipinsh@google.com>
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

On Fri, Feb 03, 2023 at 11:28:19AM -0800, Vipin Sharma wrote:
> No need to check all of the conditions in __handle_changed_spte() as
> clearing dirty log only involves resetting dirty or writable bit.

Channelling Sean: State what the patch does first.

> 
> Make atomic change to dirty or writable bit and mark pfn dirty.

This is way too vague. And the old code already did both of these
things. What's changed is that the bits are being cleared with an atomic
AND and taking advantage of the fact that that avoids needing to deal
with changes to volatile bits.

Please also explain what effect this has on @record_dirty_log and why it
can be opportunistically cleaned up in this commit.

> 
> Tested on 160 VCPU-160 GB VM and found that performance of clear dirty
> log stage improved by ~38% in dirty_log_perf_test
> 
> Before optimization:
> --------------------
> 
> Test iterations: 3
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory: [0x3fd7c0000000, 0x3fffc0000000)
> Populate memory time: 6.298459671s
> Setting dirty log mode took : 0.000000052s
> 
> Enabling dirty logging time: 0.003815691s
> 
> Iteration 1 dirty memory time: 0.185538848s
> Iteration 1 get dirty log time: 0.002562641s
> Iteration 1 clear dirty log time: 3.638543593s
> Iteration 2 dirty memory time: 0.192226071s
> Iteration 2 get dirty log time: 0.001558446s
> Iteration 2 clear dirty log time: 3.145032742s
> Iteration 3 dirty memory time: 0.193606295s
> Iteration 3 get dirty log time: 0.001559425s
> Iteration 3 clear dirty log time: 3.142340358s
> Disabling dirty logging time: 3.002873664s
> Get dirty log over 3 iterations took 0.005680512s.
> (Avg 0.001893504s/iteration)
> Clear dirty log over 3 iterations took 9.925916693s. (Avg 3.308638897s/iteration)
> 
> After optimization:
> -------------------
> 
> Test iterations: 3
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory: [0x3fd7c0000000, 0x3fffc0000000)
> Populate memory time: 6.581448437s
> Setting dirty log mode took : 0.000000058s
> 
> Enabling dirty logging time: 0.003981283s
> 
> Iteration 1 dirty memory time: 0.285693420s
> Iteration 1 get dirty log time: 0.002743004s
> Iteration 1 clear dirty log time: 2.384343157s
> Iteration 2 dirty memory time: 0.290414476s
> Iteration 2 get dirty log time: 0.001720445s
> Iteration 2 clear dirty log time: 1.882770288s
> Iteration 3 dirty memory time: 0.289965965s
> Iteration 3 get dirty log time: 0.001728232s
> Iteration 3 clear dirty log time: 1.881043086s
> Disabling dirty logging time: 2.930387523s
> Get dirty log over 3 iterations took 0.006191681s.
> (Avg 0.002063893s/iteration)
> Clear dirty log over 3 iterations took 6.148156531s. (Avg 2.049385510s/iteration)

Can you trim these results to just show the clear times? (assuming none
of the rest are relevant)

> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.h | 13 ++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c  | 51 +++++++++++++++----------------------
>  2 files changed, 34 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 30a52e5e68de..21046b34f94e 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -121,4 +121,17 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  void tdp_iter_next(struct tdp_iter *iter);
>  void tdp_iter_restart(struct tdp_iter *iter);
>  
> +static inline u64 kvm_tdp_mmu_clear_spte_bit(struct tdp_iter *iter, u64 mask)
> +{

Make "bit" plural as long as the parameter is a raw mask.

Also drop "kvm_" since this is not intended to be called outside the TDP
MMU. (It'd be nice to make the same cleanup to the read/write
functions if you feel like it.)


> +	atomic64_t *sptep;
> +
> +	if (kvm_tdp_mmu_spte_has_volatile_bits(iter->old_spte, iter->level)) {
> +		sptep = (atomic64_t *)rcu_dereference(iter->sptep);
> +		return (u64)atomic64_fetch_and(~mask, sptep);
> +	}
> +
> +	__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte & ~mask);
> +	return iter->old_spte;
> +}
> +
>  #endif /* __KVM_X86_MMU_TDP_ITER_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bba33aea0fb0..83f15052aa6c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -710,18 +710,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   *		      notifier for access tracking. Leaving record_acc_track
>   *		      unset in that case prevents page accesses from being
>   *		      double counted.
> - * @record_dirty_log: Record the page as dirty in the dirty bitmap if
> - *		      appropriate for the change being made. Should be set
> - *		      unless performing certain dirty logging operations.
> - *		      Leaving record_dirty_log unset in that case prevents page
> - *		      writes from being double counted.
>   *
>   * Returns the old SPTE value, which _may_ be different than @old_spte if the
>   * SPTE had voldatile bits.
>   */
>  static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
> -			      bool record_acc_track, bool record_dirty_log)
> +			      bool record_acc_track)
>  {
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  
> @@ -740,42 +735,34 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  
>  	if (record_acc_track)
>  		handle_changed_spte_acc_track(old_spte, new_spte, level);
> -	if (record_dirty_log)
> -		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> -					      new_spte, level);
> +
> +	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte, new_spte,
> +				      level);
>  	return old_spte;
>  }
>  
>  static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
> -				     u64 new_spte, bool record_acc_track,
> -				     bool record_dirty_log)
> +				     u64 new_spte, bool record_acc_track)
>  {
>  	WARN_ON_ONCE(iter->yielded);
>  
>  	iter->old_spte = __tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
>  					    iter->old_spte, new_spte,
>  					    iter->gfn, iter->level,
> -					    record_acc_track, record_dirty_log);
> +					    record_acc_track);
>  }
>  
>  static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  				    u64 new_spte)
>  {
> -	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
> +	_tdp_mmu_set_spte(kvm, iter, new_spte, true);
>  }
>  
>  static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
>  						 struct tdp_iter *iter,
>  						 u64 new_spte)
>  {
> -	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
> -}
> -
> -static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
> -						 struct tdp_iter *iter,
> -						 u64 new_spte)
> -{
> -	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
> +	_tdp_mmu_set_spte(kvm, iter, new_spte, false);
>  }
>  
>  #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
> @@ -925,7 +912,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  		return false;
>  
>  	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> -			   sp->gfn, sp->role.level + 1, true, true);
> +			   sp->gfn, sp->role.level + 1, true);
>  
>  	return true;
>  }
> @@ -1678,7 +1665,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>  				  gfn_t gfn, unsigned long mask, bool wrprot)
>  {
>  	struct tdp_iter iter;
> -	u64 new_spte;
> +	u64 clear_bits;

nit: clear_bit since it's always a single bit?

>  
>  	rcu_read_lock();
>  
> @@ -1694,18 +1681,22 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>  		mask &= ~(1UL << (iter.gfn - gfn));
>  
>  		if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
> -			if (is_writable_pte(iter.old_spte))
> -				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> -			else
> +			if (!is_writable_pte(iter.old_spte))
>  				continue;
> +
> +			clear_bits = PT_WRITABLE_MASK;
>  		} else {
> -			if (iter.old_spte & shadow_dirty_mask)
> -				new_spte = iter.old_spte & ~shadow_dirty_mask;
> -			else
> +			if (!(iter.old_spte & shadow_dirty_mask))
>  				continue;

You can factor out the continue check now that you have clear_bits. e.g.

	if (wrprot || spte_ad_need_write_protect(iter.old_spte))
		clear_bits = PT_WRITABLE_MASK;
	else
		clear_bits = shadow_dirty_mask;

	if (!(iter->old_spte & clear_bits))
		continue;

	iter.old_spte = kvm_tdp_mmu_clear_spte_bit(&iter, clear_bits);

> +
> +			clear_bits = shadow_dirty_mask;
>  		}
>  
> -		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
> +		iter.old_spte = kvm_tdp_mmu_clear_spte_bit(&iter, clear_bits);
> +		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
> +					       iter.old_spte,
> +					       iter.old_spte & ~clear_bits);
> +		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
>  	}
>  
>  	rcu_read_unlock();
> -- 
> 2.39.1.519.gcb327c4b5f-goog
> 
