Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5223D3D1671
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 20:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhGURy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 13:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGURyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 13:54:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13691C061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 11:35:01 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id my10so2229229pjb.1
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 11:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tohiAbuGWIEuKKnflan8OJz8nWOrrCsg3KVTwWO0TPA=;
        b=E/e8czsvrju7cn0Pw0Rmc4k1XcQqP90RPZGBrD5ri2YWGgy/s3GgwEGbfCJlKzcsjm
         ccNRMhmzrmdfcQCxRm7oRkODMPne2vQYe9LcLOWgBG0SiptZYDHyen+V5eTALTajVdtP
         2aro2ynhiZR0niq4cxIaSK0+zsfXQMyIb5k5ipMMRYozeqGLMfKELIMrb3yFWDjDaJxK
         QaEpnBfzfe8USXu5fwuGYFwz73iJsz49B/2XOiIXTVbXKO6VWDlWZBABBlmqRuvZwmsM
         2MG7/rFu2GY2K1cULWQOJarFPl6c97esEVCHfBo/moNRwuURz6RFdFMVwk2TLjkLhezr
         v49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tohiAbuGWIEuKKnflan8OJz8nWOrrCsg3KVTwWO0TPA=;
        b=f9gF+qQfu4KOiKGM3S+gQtN6HAWTp5Un1pEpdNOHyMeiXgyB7IUGeQNm7rkaG1SLXS
         vPsjytZDH94WE+0325HVqqnOa0dzvFgpJHnOWSAb/AFxf8zTO+lUtphuQkrclYyE07/r
         VI7MxYoLP2ztPOOsv+ChmnbNjQC8i2PtAMJRnme2xTov7ZJP/oX+D+xsZQ1BBfW+Sczi
         HaE/0Gydw3SZffvXkhiuPZGNq684Hut06ppepWCNdVD5K6k9WAzilVaz7X3jaH8tWB+w
         M7kH3JSUE2slKTdSMcnzk5+eWkuIaiqhs9rXBi8tExFxb44KDgBQy1mtd1CsKNiqFjqZ
         7oYg==
X-Gm-Message-State: AOAM532tzkDEHBvShw4FEznav8DKZRA71bF+LkdccFzJxmEs4klNNY3+
        suidS5spHgTqjkyrOE7aOnxAfbK5LHMy/Q==
X-Google-Smtp-Source: ABdhPJylpeWoIHMeyAAVwdUYMnK7rcY5liuhfcwHbd5L0OzMHaMlcTGEPA9tGMsEUTUjDWeiPc2UZA==
X-Received: by 2002:a17:90a:fa86:: with SMTP id cu6mr5205794pjb.68.1626892500310;
        Wed, 21 Jul 2021 11:35:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d6sm28922475pgq.88.2021.07.21.11.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 11:34:59 -0700 (PDT)
Date:   Wed, 21 Jul 2021 18:34:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 2/2] kvm: mmu/x86: Add detailed page size stats
Message-ID: <YPho0ME5pSjqRSoc@google.com>
References: <20210721051247.355435-1-mizhang@google.com>
 <20210721051247.355435-3-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721051247.355435-3-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021, Mingwei Zhang wrote:
> Existing KVM code tracks the number of large pages regardless of their
> sizes. Therefore, when large page of 1GB (or larger) is adopted, the
> information becomes less useful because lpages counts a mix of 1G and 2M
> pages.
> 
> So bridge the gap and provide a comprehensive page stats of all sizes from
> 4K to 512G.
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> Suggested-by: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 11 ++++++++-
>  arch/x86/kvm/mmu.h              |  2 ++
>  arch/x86/kvm/mmu/mmu.c          | 43 +++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 10 +++-----
>  arch/x86/kvm/x86.c              |  6 ++++-
>  5 files changed, 51 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..1b7b024f9573 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1206,9 +1206,18 @@ struct kvm_vm_stat {
>  	u64 mmu_recycled;
>  	u64 mmu_cache_miss;
>  	u64 mmu_unsync;
> -	u64 lpages;
> +	atomic64_t lpages;

What's the point of keeping lpages if the individual page sizes are tracked?  It
should be trivial for userspace to aggregate the data.  The two counts are also
not updated atomically (as a pair), e.g. userspace could see a discrepancy between
lpages and the sum of 1g+2m pages.

>  	u64 nx_lpage_splits;
>  	u64 max_mmu_page_hash_collisions;
> +	union {
> +		struct {
> +			atomic64_t pages_4k;
> +			atomic64_t pages_2m;
> +			atomic64_t pages_1g;
> +			atomic64_t pages_512g;
> +		};
> +		atomic64_t pages[4];
> +	} page_stats;
>  };
>  
>  struct kvm_vcpu_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 83e6c6965f1e..56d9c947a0cd 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -240,4 +240,6 @@ static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>  	return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
>  }
>  
> +void kvm_update_page_stats(struct kvm *kvm, u64 spte, int level, int delta);
> +
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c45ddd2c964f..9ba25f00ca2b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -588,16 +588,33 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>  	return flush;
>  }
>  
> +void kvm_update_page_stats(struct kvm *kvm, u64 spte, int level, int count)
> +{
> +	if (!is_last_spte(spte, level))
> +		return;
> +	/*
> +	 * If the backing page is a large page, update the lpages stat first,
> +	 * then log the specific type of backing page. Only log pages at highter

s/highter/higher

> +	 * levels if they are marked as large pages. (As opposed to simply
> +	 * pointing to another level of page tables.).
> +	 */

IMO, this whole comment is unnecessary.  It never explains the "why", just the
"what", and the "what" is obvious from the code.

> +	if (is_large_pte(spte))
> +		atomic64_add(count, (atomic64_t *)&kvm->stat.lpages);
> +	atomic64_add(count,
> +		(atomic64_t *)&kvm->stat.page_stats.pages[level-1]);

The cast is unnecessary, pages[] is already an atomit64_t array.

Spaces in "[level - 1]".

Align indentation, e.g.:

	atomic64_add(count,
		     (atomic64_t *)&kvm->stat.page_stats.pages[level-1]);

But that's a moot point, because the 80 char wrap is not a hard rule.  Readability
is paramount, and in this case I think most people would find this easier to read.

	atomic64_add(count, (atomic64_t *)&kvm->stat.page_stats.pages[level - 1]);

And _that's_ a moot point because dropping the unnecessary cast makes this fit
nicely under 80 chars.

> +}
> +

...

> @@ -2690,10 +2707,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  
>  	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
>  	trace_kvm_mmu_set_spte(level, gfn, sptep);
> -	if (!was_rmapped && is_large_pte(*sptep))
> -		++vcpu->kvm->stat.lpages;
>  
>  	if (!was_rmapped) {
> +		kvm_update_page_stats(vcpu->kvm, *sptep,
> +			sptep_to_sp(sptep)->role.level, 1);

mmu_set_spte() takes @level, no need to retrieve it from the shadow page.

>  		rmap_count = rmap_add(vcpu, sptep, gfn);
>  		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
>  			rmap_recycle(vcpu, sptep, gfn);
> @@ -5669,7 +5686,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
>  		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
>  							       pfn, PG_LEVEL_NUM)) {
> -			pte_list_remove(rmap_head, sptep);
> +			pte_list_remove(kvm, rmap_head, sptep);
>  
>  			if (kvm_available_flush_tlb_with_range())
>  				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index caac4ddb46df..24bd7f03248c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -446,12 +446,10 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  
>  	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
>  
> -	if (is_large_pte(old_spte) != is_large_pte(new_spte)) {
> -		if (is_large_pte(old_spte))
> -			atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
> -		else
> -			atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
> -	}

Hmm, the existing code is flawed.  is_large_pte() doesn't check that the PTE is
shadow-present, it only checks the page size bit.  That means we could get a
false positive on an MMIO SPTE if the MMIO generation happens to set bit 7, or
on a REMOVED_SPTE, which sets bit 7 in its magic value.

Patch at the bottom is compile tested only.

> +	if (is_large_pte(old_spte) && !is_large_pte(new_spte))
> +		kvm_update_page_stats(kvm, old_spte, level, -1);
> +	else if (!is_large_pte(old_spte) && is_large_pte(new_spte))
> +		kvm_update_page_stats(kvm, new_spte, level, 1);

And back to this code, it fails to account 4kb pages.  The other thing of note
is that passing the SPTE value to kvm_update_page_stats() is confusing and error
prone, e.g. in some cases it's the old SPTE, in others it's the new SPTE.
Happily, we don't actually need the SPTE value since the caller can and should
check that the SPTE being modified is a leaf SPTE.  This case is easy to handle
via "was_leaf != is_leaf", the legacy MMU "was_rmapped" handles adding a page,
and the legacy MMU zap case can explicitly check is_last_spte().

The partial diff (on top of the bug fix below) would be something like:

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 83e6c6965f1e..ced396685be7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -240,4 +240,9 @@ static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
        return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
 }

+static inline void kvm_update_page_stats(struct kvm *kvm, int level, int count)
+{
+       atomic64_add(count, &kvm->stat.page_stats.pages[level - 1]);
+}
+
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c45ddd2c964f..13cb2f4c4df4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -594,10 +594,11 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * state bits, it is used to clear the last level sptep.
  * Returns non-zero if the PTE was previously valid.
  */
-static int mmu_spte_clear_track_bits(u64 *sptep)
+static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 {
        kvm_pfn_t pfn;
        u64 old_spte = *sptep;
+       int level = sptep_to_sp(sptep)->role.level;
 
        if (!spte_has_volatile_bits(old_spte))
                __update_clear_spte_fast(sptep, 0ull);
@@ -607,6 +608,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
        if (!is_shadow_present_pte(old_spte))
                return 0;
 
+       if (is_last_spte(old_spte, level))
+               kvm_update_page_stats(kvm, level, -1);
+
        pfn = spte_to_pfn(old_spte);
 
        /*
@@ -2692,8 +2694,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
        trace_kvm_mmu_set_spte(level, gfn, sptep);
 
        if (!was_rmapped) {
-               if (is_large_pte(*sptep))
-                       ++vcpu->kvm->stat.lpages;
+               kvm_update_page_stats(vcpu->kvm, level, 1);
 
                rmap_count = rmap_add(vcpu, sptep, gfn);
                if (rmap_count > RMAP_RECYCLE_THRESHOLD)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 65715156625b..b6447947af98 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -413,7 +413,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
        bool was_leaf = was_present && is_last_spte(old_spte, level);
        bool is_leaf = is_present && is_last_spte(new_spte, level);
        bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
-       bool was_large, is_large;
 
        WARN_ON(level > PT64_ROOT_MAX_LEVEL);
        WARN_ON(level < PG_LEVEL_4K);
@@ -476,14 +475,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
         * Update large page stats if a large page is being zapped, created, or
         * is replacing an existing shadow page.
         */
-       was_large = was_leaf && is_large_pte(old_spte);
-       is_large = is_leaf && is_large_pte(new_spte);
-       if (was_large != is_large) {
-               if (was_large)
-                       atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
-               else
-                       atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
-       }
+       if (is_leaf != was_leaf)
+               kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
 
        if (was_leaf && is_dirty_spte(old_spte) &&
            (!is_present || !is_dirty_spte(new_spte) || pfn_changed))



From 081bb53be76271d7e1117bc406c75aad77202e82 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Jul 2021 10:57:18 -0700
Subject: [PATCH] KVM: x86/mmu: Avoid collision with !PRESENT SPTEs in TDP MMU
 lpage stats

Factor in whether or not the old/new SPTEs are shadow-present when
adjusting the large page stats in the TDP MMU.  A modified MMIO SPTE can
toggle the page size bit, as bit 7 is used to store the MMIO generation,
i.e. is_large_pte() can get a false positive when called on a MMIO SPTE.
Ditto for nuking SPTEs with REMOVED_SPTE, which sets bit 7 in its magic
value.

Opportunistically move the logic below the check to verify at least one
of the old/new SPTEs is shadow present.

Use is/was_leaf even though is/was_present would suffice.  The code
generation is roughly equivalent since all flags need to be computed
prior to the code in question, and using the *_leaf flags will minimize
the diff in a future enhancement to account all pages, i.e. will change
the check to "is_leaf != was_leaf".

Fixes: 1699f65c8b65 ("kvm/x86: Fix 'lpages' kvm stat for TDM MMU")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index caac4ddb46df..65715156625b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -413,6 +413,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool was_large, is_large;

 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -446,13 +447,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,

 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);

-	if (is_large_pte(old_spte) != is_large_pte(new_spte)) {
-		if (is_large_pte(old_spte))
-			atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
-		else
-			atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
-	}
-
 	/*
 	 * The only times a SPTE should be changed from a non-present to
 	 * non-present state is when an MMIO entry is installed/modified/
@@ -478,6 +472,18 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		return;
 	}

+	/*
+	 * Update large page stats if a large page is being zapped, created, or
+	 * is replacing an existing shadow page.
+	 */
+	was_large = was_leaf && is_large_pte(old_spte);
+	is_large = is_leaf && is_large_pte(new_spte);
+	if (was_large != is_large) {
+		if (was_large)
+			atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
+		else
+			atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
+	}

 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
--
2.32.0.402.g57bb445576-goog


>  	/*
>  	 * The only times a SPTE should be changed from a non-present to
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8166ad113fb2..23444257fcbd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -237,7 +237,11 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>  	STATS_DESC_ICOUNTER(VM, mmu_unsync),
>  	STATS_DESC_ICOUNTER(VM, lpages),
>  	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
> -	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
> +	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
> +	STATS_DESC_ICOUNTER(VM, page_stats.pages_4k),
> +	STATS_DESC_ICOUNTER(VM, page_stats.pages_2m),
> +	STATS_DESC_ICOUNTER(VM, page_stats.pages_1g),
> +	STATS_DESC_ICOUNTER(VM, page_stats.pages_512g)
>  };
>  static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
>  		sizeof(struct kvm_vm_stat) / sizeof(u64));
> -- 
> 2.32.0.402.g57bb445576-goog
> 
