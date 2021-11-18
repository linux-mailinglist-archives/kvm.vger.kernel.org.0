Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975874560A6
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 17:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhKRQkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 11:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbhKRQke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 11:40:34 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DA1C06173E
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 08:37:34 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id b4so5825217pgh.10
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 08:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eSlGi5RuVgo7OXNua4tu84/flggr/LpyiJgQtSdy3yM=;
        b=q5ZeqDsUJK3gz8NyzGqQhy4Ng9nNfszISWbCU0xpoPQ28ZdhSY7CDtZ8B1DY7+i8X7
         kJ6ob4HDQT4KvVAsQg5OyQRpTTfvWeALcBBgro5Ex8Yq6rr1Y2scWKOHnmui6n0LfUC6
         WR8mrqca5n4HGfq3rqZNzGb9YiJic7LvfLidnUJiJajz7hv3s4hLRjhyZ6IW6RNQF325
         PQYylEjctPMlMOQioHSeBJpiTIw9njU2+Nqp44N9jhDb20QGUoG4UBtElt7R55D4rkEo
         3YHFPrcEUchj92JSb1EwGAC5eGwIeW5BTK9QZuNC2fyP06HGw/ZEvLLHLb1ab/ceo7gO
         +5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eSlGi5RuVgo7OXNua4tu84/flggr/LpyiJgQtSdy3yM=;
        b=lSapc3E3TGaJIgu4VzSWm3svImN23EHKT7wJhlEN1VDpVA4MFdnjc8U8NU+IxPshUR
         +KA2ihgQo344SeJ1xmkpRIHODYy5fgDH+oBVnL8D8SRNIqtd7/WvY3BH5PKHFIo7tnNw
         z73XRHnqpVqv2w+W6a2dXsM78LiQyvOHkdWdfcwYuoSJIirTk6Mc8dSkwv96mMcm99Si
         +HH9Xs8oivIvksnSb77fLnG16vuF2wdv9FCp9sPQEk33Oj16z92bTA928IIBKQqINRHS
         GF06wJizAQf+AFTJxv6qbbT57YE5ZyBT/X1O1F04xjp+yFr941KjqbPIrs1A4lYkAZJI
         ugKg==
X-Gm-Message-State: AOAM532UyH5YqEJEhJvnSDgMVIebA28g5A8203ERcnOS1+xhG/DdAGy6
        /sbisipXa1CmPj3vrbn7LJhWOORT7BfyKw==
X-Google-Smtp-Source: ABdhPJyniZd4HCHWU0Zk/S2bncAHEGtGw52ezIlUt31Yx49ou6//UqI+npzLNPw1lXGB6+ljLoOvTQ==
X-Received: by 2002:a05:6a00:848:b0:49f:b215:e002 with SMTP id q8-20020a056a00084800b0049fb215e002mr56777937pfk.47.1637253453821;
        Thu, 18 Nov 2021 08:37:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rj8sm9894583pjb.0.2021.11.18.08.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 08:37:33 -0800 (PST)
Date:   Thu, 18 Nov 2021 16:37:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Message-ID: <YZaBSf+bPc69WR1R@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com>
 <YZW02M0+YzAzBF/w@google.com>
 <YZXIqAHftH4d+B9Y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZXIqAHftH4d+B9Y@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Sean Christopherson wrote:
> Another idea.  The only difference between 5-level and 4-level is that 5-level
> fills in index [4], and I'm pretty sure 4-level doesn't touch that index.  For
> PAE NPT (32-bit SVM), the shadow root level will never change, so that's not an issue.
> 
> Nested NPT is the only case where anything for an EPT/NPT MMU can change, because
> that follows EFER.NX.
> 
> In other words, the non-nested TDP reserved bits don't need to be recalculated
> regardless of level, they can just fill in 5-level and leave it be.
> 
> E.g. something like the below.  The sp->role.direct check could be removed if we
> forced EFER.NX for nested NPT.
> 
> It's a bit ugly in that we'd pass both @kvm and @vcpu, so that needs some more
> thought, but at minimum it means there's no need to recalc the reserved bits.

Ok, I think my final vote is to have the reserved bits passed in, but with the
non-nested TDP reserved bits being computed at MMU init.

I would also prefer to keep the existing make_spte() name so that there's no churn
in those call sites, and to make the relationship between the wrapper, mask_spte(),
and the "real" helper, __make_spte(), more obvious and aligned with the usual
kernel style.

So with the kvm_vcpu_ad_need_write_protect() change and my proposed hack-a-fix for
kvm_x86_get_mt_mask(), the end result would look like:

bool __make_spte(struct kvm *kvm, struct kvm_mmu_page *sp,
		 struct kvm_memory_slot *slot, unsigned int pte_access,
		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
		 bool can_unsync, bool host_writable, u64 *new_spte,
		 struct rsvd_bits_validate *shadow_rsvd_bits)
{
	int level = sp->role.level;
	u64 spte = SPTE_MMU_PRESENT_MASK;
	bool wrprot = false;

	if (sp->role.ad_disabled)
		spte |= SPTE_TDP_AD_DISABLED_MASK;
	else if (kvm_mmu_page_ad_need_write_protect(sp))
		spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;

	/*
	 * For the EPT case, shadow_present_mask is 0 if hardware
	 * supports exec-only page table entries.  In that case,
	 * ACC_USER_MASK and shadow_user_mask are used to represent
	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
	 */
	spte |= shadow_present_mask;
	if (!prefetch)
		spte |= spte_shadow_accessed_mask(spte);

	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
	    is_nx_huge_page_enabled()) {
		pte_access &= ~ACC_EXEC_MASK;
	}

	if (pte_access & ACC_EXEC_MASK)
		spte |= shadow_x_mask;
	else
		spte |= shadow_nx_mask;

	if (pte_access & ACC_USER_MASK)
		spte |= shadow_user_mask;

	if (level > PG_LEVEL_4K)
		spte |= PT_PAGE_SIZE_MASK;
	if (tdp_enabled)
		spte |= static_call(kvm_x86_get_mt_mask)(kvm, gfn,
			kvm_is_mmio_pfn(pfn));

	if (host_writable)
		spte |= shadow_host_writable_mask;
	else
		pte_access &= ~ACC_WRITE_MASK;

	if (!kvm_is_mmio_pfn(pfn))
		spte |= shadow_me_mask;

	spte |= (u64)pfn << PAGE_SHIFT;

	if (pte_access & ACC_WRITE_MASK) {
		spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask;

		/*
		 * Optimization: for pte sync, if spte was writable the hash
		 * lookup is unnecessary (and expensive). Write protection
		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
		 * Same reasoning can be applied to dirty page accounting.
		 */
		if (is_writable_pte(old_spte))
			goto out;

		/*
		 * Unsync shadow pages that are reachable by the new, writable
		 * SPTE.  Write-protect the SPTE if the page can't be unsync'd,
		 * e.g. it's write-tracked (upper-level SPs) or has one or more
		 * shadow pages and unsync'ing pages is not allowed.
		 */
		if (mmu_try_to_unsync_pages(kvm, slot, gfn, can_unsync, prefetch)) {
			pgprintk("%s: found shadow page for %llx, marking ro\n",
				 __func__, gfn);
			wrprot = true;
			pte_access &= ~ACC_WRITE_MASK;
			spte &= ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
		}
	}

	if (pte_access & ACC_WRITE_MASK)
		spte |= spte_shadow_dirty_mask(spte);

out:
	if (prefetch)
		spte = mark_spte_for_access_track(spte);

	WARN_ONCE(is_rsvd_spte(shadow_rsvd_bits), spte, level),
		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
		  get_rsvd_bits(&shadow_rsvd_bits, spte, level));

	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
		/* Enforced by kvm_mmu_hugepage_adjust. */
		WARN_ON(level > PG_LEVEL_4K);
		mark_page_dirty_in_slot(kvm, slot, gfn);
	}

	*new_spte = spte;
	return wrprot;
}

bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
	       struct kvm_memory_slot *slot,
	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
	       u64 old_spte, bool prefetch, bool can_unsync,
	       bool host_writable, u64 *new_spte)
{
	return __make_spte(vcpu->kvm, sp, slot, pte_access, gfn, pfn, old_spte,
			   prefetch, can_unsync, host_writable, new_spte,
			   &vcpu->arch.mmu->shadow_zero_check);
}
