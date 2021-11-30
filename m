Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4368462945
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 01:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhK3Avs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 19:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhK3Avs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 19:51:48 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9290C061714
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 16:48:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso15699794pjb.2
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 16:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SKb0tyWyh5coPyGBhZ1CTtyPx1ZKuebzYgiNQtZtLDQ=;
        b=FXlb8DHnsHvayR6ZOPHsYMujupoG7HgpC2377wMXQusARXxPsyVI8pBJQYeV4GUP8x
         I7F5Yb2Dt8YtbqNlwg0MYOoZl6ietGWJHZ5qTfGRpx6DeGgXSS1s2BEDIZFxAh6g/nM+
         ETX9huOwK1rmIVGiXQjVDQNUyfd+DlEkYu0Yf+wenmKRtqhSAyvjw7OojhY1ylz+Dvrb
         yb499G3x1X36cHaqzSJ88CuEJu7VR6RqWhSojfYPbRhrD3maUAhHQjpBEthiytL2PPhW
         eYO+kMwUfNwdczDOuD0xQnazIPv1WpEubC31qVticdDi0X/lnnK/qAjubLaeXvZy8RV/
         C/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SKb0tyWyh5coPyGBhZ1CTtyPx1ZKuebzYgiNQtZtLDQ=;
        b=qaGXpZsu8QyvcrRllGsD2xZI+rVcj10pwT1RfnqTxrRmY7sXA+t0K34rxaQnjWn0QL
         3nC2E3HsHw0IkWAc+uKxN2eY/qIUqKrHZLl9u9B034LI/uQhpk3fDj+bEWMaL32NnTQB
         XTx6DzLDOpBys8s9U0ZoxHrM9PfWgir/KCy14VV+WME+sodnbZP88IBhThKIEpBvIh8y
         4MMjDaCXrIngM1AwMOCj3sGzaLXYH8paojn+jAqT1PXVEeftTsiAJyLlNeWKXC/E4Zdt
         LTqxWXbIa5GEnb2WuXUa+3U2Z6OyHUZ3WrAVN9kUq1fvpljXAdnz5XOqRzZCyQjgg6gj
         F9KQ==
X-Gm-Message-State: AOAM533HlS6/5imXA7PgXcQHXPqCtqnSH9k5ugUKOhqLsgUcslvxuFpW
        gdKZCLg7Nux/V/w1KzOivigkfg==
X-Google-Smtp-Source: ABdhPJy+FCDHetyo1p1dnxEvjT6M/DKbtD2rUpSQGv3rbeWeeevKJJrU6ZhXSKN5TmY7gbKvSPPmlg==
X-Received: by 2002:a17:90b:1a87:: with SMTP id ng7mr1911697pjb.86.1638233309125;
        Mon, 29 Nov 2021 16:48:29 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z71sm12947783pgz.52.2021.11.29.16.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 16:48:28 -0800 (PST)
Date:   Tue, 30 Nov 2021 00:48:24 +0000
From:   David Matlack <dmatlack@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 2/2] KVM: mmu/x86: optimize zapping by retaining non-leaf
 SPTEs and avoid rcu stall
Message-ID: <YaV02MdGYlfGs35T@google.com>
References: <20211124214421.458549-1-mizhang@google.com>
 <20211124214421.458549-3-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124214421.458549-3-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24, 2021 at 09:44:21PM +0000, Mingwei Zhang wrote:
> TDP MMU SPTE zapping process currently uses two levels of iterations. The
> first level iteration happens at the for loop within the zap_gfn_range()
> with the purpose of calibrating the accurate range for zapping. The second
> level itreration start at tdp_mmu_set_spte{,_atomic}() that tears down the

iteration

> whole paging structures (leaf and non-leaf SPTEs) within the range. The
> former iteration is yield safe, while the second one is not.

I know what you mean but I'd suggest being more specific than "yield
safe". For example:

  Unlike the outer loop, the recursive zapping done under
  tdp_mmu_set_spte{,_atomic} does not yield. Since zapping is done with
  a pre-order traversal, zapping sufficiently large ranges can lead to
  RCU stall warnings.

I'd also clarify here that the TDP MMU iterator uses a pre-order
traversal which causes us KVM to end up doing the maximum amount of
zapping under tdp_mmu_set_spte{,_atomic} and not the outer for loop.

> 
> In many cases, zapping SPTE process could be optimized since the non-leaf
> SPTEs could most likely be retained for the next allocation. On the other
> hand, for large scale SPTE zapping scenarios, we may end up zapping too
> many SPTEs and use excessive CPU time that causes the RCU stall warning.
> 
> The follow selftest reproduces the warning:
> 
> 	(env: kvm.tdp_mmu=Y)
> 	./dirty_log_perf_test -v 64 -b 8G
> 
> Optimize the zapping process by skipping all SPTEs above a certain level in
> the first iteration. This allows us to control the granularity of the
> actual zapping and invoke tdp_mmu_iter_cond_resched() on time. In addition,
> we would retain some of the non-leaf SPTEs to accelerate next allocation.
> 
> For the selection of the `certain level`, we choose the PG_LEVEL_1G because
> it is currently the largest page size supported and it natually fits the
> scenario of splitting large pages.
> 
> For `zap_all` case (usually) at VM teardown time, we use a two-phase
> mechanism: the 1st phase zaps all SPTEs at PG_LEVEL_1G level and 2nd phase
> zaps everything else. This is achieved by the helper function
> __zap_gfn_range().
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: David Matlack <dmatlack@google.com>
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 57 ++++++++++++++++++++++++++------------
>  1 file changed, 40 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 89d16bb104de..3fadc51c004a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -697,24 +697,16 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
>   * account for the possibility that other threads are modifying the paging
>   * structures concurrently. If shared is false, this thread should hold the
>   * MMU lock in write mode.
> + *
> + * If zap_all is true, eliminate all the paging structures that contains the
> + * SPTEs.
>   */
> -static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -			  gfn_t start, gfn_t end, bool can_yield, bool flush,
> -			  bool shared)
> +static bool __zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> +			    gfn_t start, gfn_t end, bool can_yield, bool flush,
> +			    bool shared, bool zap_all)
>  {
> -	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> -	bool zap_all = (start == 0 && end >= max_gfn_host);
>  	struct tdp_iter iter;
>  
> -	/*
> -	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> -	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> -	 * and so KVM will never install a SPTE for such addresses.
> -	 */
> -	end = min(end, max_gfn_host);
> -
> -	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> -
>  	rcu_read_lock();
>  
>  	tdp_root_for_each_pte(iter, root, start, end) {
> @@ -725,17 +717,24 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  			continue;
>  		}
>  
> -		if (!is_shadow_present_pte(iter.old_spte))
> +		/*
> +		 * In zap_all case, ignore the checking of present since we have
> +		 * to zap everything.
> +		 */
> +		if (!zap_all && !is_shadow_present_pte(iter.old_spte))
>  			continue;

I don't believe there's any reason to attempt to zap a non-present spte,
even in the zap_all case. In any case, this change deserves its own
patch and a commit message that describes why the old logic is incorrect
and how this fixes it.

>  
>  		/*
>  		 * If this is a non-last-level SPTE that covers a larger range
>  		 * than should be zapped, continue, and zap the mappings at a
> -		 * lower level, except when zapping all SPTEs.
> +		 * lower level. Actual zapping started at proper granularity
> +		 * that is not so large as to cause a soft lockup when handling
> +		 * the changed pte (which does not yield).
>  		 */
>  		if (!zap_all &&
>  		    (iter.gfn < start ||
> -		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
> +		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end ||
> +		     iter.level > PG_LEVEL_1G) &&
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;

This if statement is getting a bit long. I'd suggest breaking out the
level check and also using KVM_MAX_HUGEPAGE_LEVEL.

e.g.

        /*
         * If not doing zap_all, only zap up to the huge page level to
         * avoid doing too much work in the recursive tdp_mmu_set_spte*
         * call below, since it does not yield.
         *
         * This will potentially leave behind some childless page tables
         * but that's ok because ...
         */
         if (!zap_all && iter.level > KVM_MAX_HUGEPAGE_LEVEL)
                continue;

And on that note, what is the reasoning for why it's ok to leave behind
childless page tables? I assume it's because most of the time we'll use
that page table again in the future, and at worst we leave the page
table allocated until the VM is cleaned up?

>  
> @@ -756,6 +755,30 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  	return flush;
>  }
>  
> +static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> +			  gfn_t start, gfn_t end, bool can_yield, bool flush,
> +			  bool shared)
> +{
> +	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
> +	bool zap_all = (start == 0 && end >= max_gfn_host);
> +
> +	/*
> +	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> +	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> +	 * and so KVM will never install a SPTE for such addresses.
> +	 */
> +	end = min(end, max_gfn_host);
> +
> +	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
> +
> +	flush = __zap_gfn_range(kvm, root, start, end, can_yield, flush, shared,
> +				false);
> +	if (zap_all)
> +		flush = __zap_gfn_range(kvm, root, start, end, can_yield, flush,
> +					shared, true);
> +	return flush;
> +}
> +
>  /*
>   * Tears down the mappings for the range of gfns, [start, end), and frees the
>   * non-root pages mapping GFNs strictly within that range. Returns true if
> -- 
> 2.34.0.rc2.393.gf8c9666880-goog
> 
