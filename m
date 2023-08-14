Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D639277C18E
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 22:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjHNUfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 16:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjHNUfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 16:35:40 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599A11703;
        Mon, 14 Aug 2023 13:35:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bdeb022738so6655595ad.0;
        Mon, 14 Aug 2023 13:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692045339; x=1692650139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Dpn0LXIHN37LlwYOQkWgoOoiUYJkZj+9sfdGrW9oSE=;
        b=CxSBv9sizW4p72ywQxQr4bL7KPusbMfLNXDcgwXsEBbZrDAa3Oyh8JTCqEkZb2H3Tc
         ovpATqnEgZSBs9QqQNNDWyWh1H2GFYnEPE7plBQ2P4C/RNbelcjQydZkenhFREn/7tu1
         UadB6AH11vlqhDfzIOSxULRVlTWsF1Wz6Z2zQPQDkAKP18OyRN3wqUzlAo+el3HOcGnl
         vlSAFZuuAmXZ6aTVDo8/RHzxrBNViz4trszkdeQWoVCHDbXPouUIcqAx7GxwX3/l8db3
         i2TEsbzrDyI+nZmVK8Ye0ETckp+O9AHJBJ1CxNpDy3jaB+rNnhjX2280O1zJ2D1zmPrh
         H55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692045339; x=1692650139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Dpn0LXIHN37LlwYOQkWgoOoiUYJkZj+9sfdGrW9oSE=;
        b=Md6A5JpYfrSjvJ7gXL/d77yxw8SdFdKtj0uh8OZH+hlk/5jtNibmglGcO7JJgrxCRy
         xvUr0EDpTB8OOQBbdQtU6YQ1q+iDSpmxRgdsCoco7s4I4t6LPjzuA4v7ubzUthwgKIvM
         r410iHoWTnGRjfNXx99g1w0EeCSZUzbRP6hUg1wjcmy+Wi5TGN//cKU4Rso0jGsBO/fa
         S+glDycbeS3xxK0ik6KENB5OXDWBhVId3iySoTnfzctikVt1hYVdZfmBgYWCwIi8ZPPb
         H1a4LBbTOu9p8IQpp8xxQZ3D251C09HCWxMpBSf0j2afgTxRYnRnvgebtnEP7Um+r8ry
         nM5g==
X-Gm-Message-State: AOJu0Yy+OerBXNSRCOoei7/VyUDMtpSFoiHILbES9S8q7cLbrPDNaiYV
        Pu7+n2mnwuNS3JIdkuGX5kI=
X-Google-Smtp-Source: AGHT+IHIA+m4NLfJbD0pwljJ4yob89pyeJn1LijeuHhvbV3eu3maw12j/bZrI5voybejoIPe7GOu0A==
X-Received: by 2002:a17:90a:7486:b0:26b:374f:97c2 with SMTP id p6-20020a17090a748600b0026b374f97c2mr75282pjk.6.1692045338647;
        Mon, 14 Aug 2023 13:35:38 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id jg22-20020a17090326d600b001bdea189261sm2003751plb.229.2023.08.14.13.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 13:35:38 -0700 (PDT)
Date:   Mon, 14 Aug 2023 13:35:36 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [RFC PATCH v4 13/16] KVM: x86/tdp_mmu: Try to merge pages into a
 large page
Message-ID: <20230814203536.GB2257301@ls.amr.corp.intel.com>
References: <cover.1690323516.git.isaku.yamahata@intel.com>
 <d649f4294d95803a46aaaf3ddd87c7e2f8ff501d.1690323516.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d649f4294d95803a46aaaf3ddd87c7e2f8ff501d.1690323516.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 03:23:59PM -0700,
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> When a large page is passed to the KVM page fault handler and some of sub
> pages are already populated, try to merge sub pages into a large page.
> This situation can happen when the guest converts small pages into shared
> and convert it back into private.
> 
> When a large page is passed to KVM mmu page fault handler and the spte
> corresponding to the page is non-leaf (one or more of sub pages are already
> populated at lower page level), the current kvm mmu zaps non-leaf spte at a
> large page level, and populate a leaf spte at that level.  Thus small pages
> are converted into a large page.  However, it doesn't work for TDX because
> zapping and re-populating results in zeroing page content.  Instead,
> populate all small pages and merge them into a large page.
> 
> Merging pages into a large page can fail when some sub pages are accepted
> and some are not.  In such case, with the assumption that guest tries to
> accept at large page size for performance when possible, don't try to be
> smart to identify which page is still pending, map all pages at lower page
> level, and let vcpu re-execute.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |   4 +
>  arch/x86/kvm/mmu/tdp_iter.c        |  37 +++++--
>  arch/x86/kvm/mmu/tdp_iter.h        |   2 +
>  arch/x86/kvm/mmu/tdp_mmu.c         | 163 ++++++++++++++++++++++++++++-
>  5 files changed, 198 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c3963002722c..612fcaac600d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1242,6 +1242,167 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private)
>  	rcu_read_unlock();
>  }
>  
> +static void tdp_mmu_iter_step_side(int i, struct tdp_iter *iter)
> +{
> +	/*
> +	 * if i = SPTE_ENT_PER_PAGE - 1, tdp_iter_step_side() results
> +	 * in reading the entry beyond the last entry.
> +	 */
> +	if (i < SPTE_ENT_PER_PAGE)
> +		tdp_iter_step_side(iter);
> +}
> +
> +static int tdp_mmu_merge_private_spt(struct kvm_vcpu *vcpu,
> +				     struct kvm_page_fault *fault,
> +				     struct tdp_iter *iter, u64 new_spte)
> +{
> +	u64 *sptep = rcu_dereference(iter->sptep);
> +	struct kvm_mmu_page *child_sp;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct tdp_iter child_iter;
> +	bool ret_pf_retry = false;
> +	int level = iter->level;
> +	gfn_t gfn = iter->gfn;
> +	u64 old_spte = *sptep;
> +	tdp_ptep_t child_pt;
> +	u64 child_spte;
> +	int ret = 0;
> +	int i;
> +
> +	/*
> +	 * TDX KVM supports only 2MB large page.  It's not supported to merge
> +	 * 2MB pages into 1GB page at the moment.
> +	 */
> +	WARN_ON_ONCE(fault->goal_level != PG_LEVEL_2M);
> +	WARN_ON_ONCE(iter->level != PG_LEVEL_2M);
> +	WARN_ON_ONCE(!is_large_pte(new_spte));
> +
> +	/* Freeze the spte to prevent other threads from working spte. */
> +	if (!try_cmpxchg64(sptep, &iter->old_spte, REMOVED_SPTE))
> +		return -EBUSY;
> +
> +	/*
> +	 * Step down to the child spte.  Because tdp_iter_next() assumes the
> +	 * parent spte isn't freezed, do it manually.
> +	 */
> +	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
> +	child_sp = sptep_to_sp(child_pt);
> +	WARN_ON_ONCE(child_sp->role.level != PG_LEVEL_4K);
> +	WARN_ON_ONCE(!kvm_mmu_page_role_is_private(child_sp->role));
> +
> +	/* Don't modify iter as the caller will use iter after this function. */
> +	child_iter = *iter;
> +	/* Adjust the target gfn to the head gfn of the large page. */
> +	child_iter.next_last_level_gfn &= -KVM_PAGES_PER_HPAGE(level);
> +	tdp_iter_step_down(&child_iter, child_pt);
> +
> +	/*
> +	 * All child pages are required to be populated for merging them into a
> +	 * large page.  Populate all child spte.
> +	 */
> +	for (i = 0; i < SPTE_ENT_PER_PAGE; i++, tdp_mmu_iter_step_side(i, &child_iter)) {
> +		WARN_ON_ONCE(child_iter.level != PG_LEVEL_4K);
> +		if (is_shadow_present_pte(child_iter.old_spte)) {
> +			/* TODO: relocate page for huge page. */
> +			if (WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) !=
> +					 spte_to_pfn(new_spte) + i)) {
> +				ret = -EAGAIN;
> +				ret_pf_retry = true;
> +			}
> +			/*
> +			 * When SEPT_VE_DISABLE=true and the page state is
> +			 * pending, this case can happen.  Just resume the vcpu
> +			 * again with the expectation for other vcpu to accept
> +			 * this page.
> +			 */
> +			if (child_iter.gfn == fault->gfn) {
> +				ret = -EAGAIN;
> +				ret_pf_retry = true;
> +				break;
> +			}
> +			continue;
> +		}
> +
> +		WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) != spte_to_pfn(new_spte) + i);
> +		child_spte = make_huge_page_split_spte(kvm, new_spte, child_sp->role, i);
> +		/*
> +		 * Because other thread may have started to operate on this spte
> +		 * before freezing the parent spte,  Use atomic version to
> +		 * prevent race.
> +		 */
> +		ret = tdp_mmu_set_spte_atomic(vcpu->kvm, &child_iter, child_spte);
> +		if (ret == -EBUSY || ret == -EAGAIN)
> +			/*
> +			 * There was a race condition.  Populate remaining 4K
> +			 * spte to resolve fault->gfn to guarantee the forward
> +			 * progress.
> +			 */
> +			ret_pf_retry = true;
> +		else if (ret)
> +			goto out;
> +
> +	}
> +	if (ret_pf_retry)
> +		goto out;
> +
> +	/* Prevent the Secure-EPT entry from being used. */
> +	ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
> +	if (ret)
> +		goto out;
> +	kvm_flush_remote_tlbs_range(kvm, gfn & KVM_HPAGE_GFN_MASK(level),
> +				    KVM_PAGES_PER_HPAGE(level));
> +
> +	/* Merge pages into a large page. */
> +	ret = static_call(kvm_x86_merge_private_spt)(kvm, gfn, level,
> +						     kvm_mmu_private_spt(child_sp));
> +	/*
> +	 * Failed to merge pages because some pages are accepted and some are
> +	 * pending.  Since the child page was mapped above, let vcpu run.
> +	 */
> +	if (ret) {
> +		if (static_call(kvm_x86_unzap_private_spte)(kvm, gfn, level))
> +			old_spte = SHADOW_NONPRESENT_VALUE |
> +				(spte_to_pfn(old_spte) << PAGE_SHIFT) |
> +				PT_PAGE_SIZE_MASK;
> +		goto out;
> +	}
> +
> +	/* Unfreeze spte. */
> +	__kvm_tdp_mmu_write_spte(sptep, new_spte);
> +
> +	/*
> +	 * Free unused child sp.  Secure-EPT page was already freed at TDX level
> +	 * by kvm_x86_merge_private_spt().
> +	 */
> +	tdp_unaccount_mmu_page(kvm, child_sp);
> +	tdp_mmu_free_sp(child_sp);
> +	return -EAGAIN;
> +
> +out:
> +	__kvm_tdp_mmu_write_spte(sptep, old_spte);
> +	return ret;
> +}
> +
> +static int __tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> +					     struct kvm_page_fault *fault,
> +					     struct tdp_iter *iter, u64 new_spte)
> +{
> +	/*
> +	 * The private page has smaller-size pages.  For example, the child
> +	 * pages was converted from shared to page, and now it can be mapped as
> +	 * a large page.  Try to merge small pages into a large page.
> +	 */
> +	if (fault->slot &&
> +	    kvm_gfn_shared_mask(vcpu->kvm) &&
> +	    iter->level > PG_LEVEL_4K &&
> +	    kvm_is_private_gpa(vcpu->kvm, fault->addr) &&
> +	    is_shadow_present_pte(iter->old_spte) &&
> +	    !is_large_pte(iter->old_spte))
> +		return tdp_mmu_merge_private_spt(vcpu, fault, iter, new_spte);
> +
> +	return tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte);
> +}
> +
>  /*
>   * Installs a last-level SPTE to handle a TDP page fault.
>   * (NPT/EPT violation/misconfiguration)
> @@ -1276,7 +1437,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  
>  	if (new_spte == iter->old_spte)
>  		ret = RET_PF_SPURIOUS;
> -	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> +	else if (__tdp_mmu_map_handle_target_level(vcpu, fault, iter, new_spte))
>  		return RET_PF_RETRY;
>  	else if (is_shadow_present_pte(iter->old_spte) &&
>  		 !is_last_spte(iter->old_spte, iter->level))
> -- 
> 2.25.1
> 


I missed the race condition and had a wrong WARN_ON_ONCE().  I think it's hard
to hit it because
- In most cases, we hit if (is_shadow_present_pte()) because map it with large
  page, split the page on mapgpa(to-shared), merge the page on
  mapgpa(to-private-again).
  We need independent mapgpa sequence on a different GPA, but within same 2M
  range.

- To hit removed case, we need a race with 2 vcpus in addition to the above.

Anyway this will be included in the next respin.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 70051dd863a8..4ccfbd04fb27 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1306,6 +1306,13 @@ static int tdp_mmu_merge_private_spt(struct kvm_vcpu *vcpu,
 	 */
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i = tdp_mmu_iter_step_side(i, &child_iter)) {
 		WARN_ON_ONCE(child_iter.level != PG_LEVEL_4K);
+
+		if (is_removed_spte(child_iter.old_spte)) {
+			ret = -EAGAIN;
+			ret_pf_retry = true;
+			continue;
+		}
+
 		if (is_shadow_present_pte(child_iter.old_spte)) {
 			/* TODO: relocate page for huge page. */
 			if (WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) !=
@@ -1327,7 +1334,6 @@ static int tdp_mmu_merge_private_spt(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) != spte_to_pfn(new_spte) + i);
 		child_spte = make_huge_page_split_spte(kvm, new_spte, child_sp->role, i);
 		/*
 		 * Because other thread may have started to operate on this spte
-- 
2.25.1

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
