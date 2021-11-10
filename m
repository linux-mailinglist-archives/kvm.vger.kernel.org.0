Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EF844CCDF
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhKJWeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhKJWeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:34:16 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D77C06122B
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:31:16 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x25-20020aa79199000000b0044caf0d1ba8so2763399pfa.1
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ldW91wlXn8Nh81WNcDS8T3qMJSnkBkv0dUkW0EdfFg8=;
        b=pv4JNA3zdg+m6PIYkxBmnczNxzjzSCX427piXb8HddSLJ99m7hBH54Jzu65IImWEMG
         2ucz1Y6pLDJ12Gtw+N1OqJQaUf5DwXv8ES9CuhRos30u6ql6Ioj+h6VtgZUTGzsm8P6J
         FMDQe3KY4GmutldldZSPZLqdMtH1x63txjc18pVA5T5m1pCaZ2ZKJIcd/xVdkY+WnXqp
         0rPXAEy6HgO5PdSF0ygXgtxioPkwAjtR7KwH71aYcfrizJA/SdH3AFoIEq1G8xtAIeGt
         5ZLhCV0bvU2q4zUDLwrXj6UgH1GXgLRzCa0zF309x6dnr0H2Ye7DfXaCxrNQ/nHM5z61
         o8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ldW91wlXn8Nh81WNcDS8T3qMJSnkBkv0dUkW0EdfFg8=;
        b=QHeuwNFYE952sslKvkHOs1+jeZGXYUJKfg9Ma2SLvtLYjv5DdCfympppcGWWSLPTx8
         2dkBudP2RWOlzR7xY6VD00qw4huVuSo0tNw5hB23f43Cr8xUI04ps9+d6NX7rAEr2Lla
         kLEjtiLzLMr/F/HmoZ9P6hPW597l/Gy5Jwtm/qT6xFl7lH09kVco5JLoMP5RkviEI/KD
         N+yazQ/L3LQdiDElb0ZFA0EUDoQOFjep7KGtnOewp/oOSAthFaMc03NvxiQjV/39BbVI
         gZBcWgHSAqYK0BohGqtGMToFHy8T4yWLV8aiQoiQ1Ny4gY1oRYi1G/8za8PM2xeDv9wb
         vCJw==
X-Gm-Message-State: AOAM530uEIzkORa89IxyHPztzk9XqNUfgZSq1L/d6WCdkLSAArtyjAZl
        kdFksbO80Pi92HVMeJ5wfhqSQ2e0oxRj
X-Google-Smtp-Source: ABdhPJyFKSswS7Pz+l1CcGPccn7T/6K9wxzQnw7pOs4wiwT54m3groMD/MDFiPgg3hfc6u7nCwLtDAk1bbym
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr49033pjd.0.1636583475503; Wed, 10 Nov 2021 14:31:15 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:30:10 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-20-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 19/19] KVM: x86/mmu: Promote pages in-place when disabling dirty logging
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When disabling dirty logging, the TDP MMU currently zaps each leaf entry
mapping memory in the relevant memslot. This is very slow. Doing the zaps
under the mmu read lock requires a TLB flush for every zap and the
zapping causes a storm of ETP/NPT violations.

Instead of zapping, replace the split large pages with large page
mappings directly. While this sort of operation has historically only
been done in the vCPU page fault handler context, refactorings earlier
in this series and the relative simplicity of the TDP MMU make it
possible here as well.

Running the dirty_log_perf_test on an Intel Skylake with 96 vCPUs and 1G
of memory per vCPU, this reduces the time required to disable dirty
logging from over 45 seconds to just over 1 second. It also avoids
provoking page faults, improving vCPU performance while disabling
dirty logging.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/mmu_internal.h |  4 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 69 ++++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef7a84422463..add724aa9e8c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4449,7 +4449,7 @@ static inline bool boot_cpu_is_amd(void)
  * the direct page table on host, use as much mmu features as
  * possible, however, kvm currently does not do execution-protection.
  */
-static void
+void
 build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
 				int shadow_root_level)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 6563cce9c438..84d439432acf 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -161,4 +161,8 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+void
+build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
+				int shadow_root_level);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 836eadd4e73a..77ff7f1d0d0a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1435,6 +1435,66 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
 
+static void try_promote_lpage(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot,
+			      struct tdp_iter *iter)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
+	struct rsvd_bits_validate shadow_zero_check;
+	/*
+	 * Since the TDP  MMU doesn't manage nested PTs, there's no need to
+	 * write protect for a nested VM when PML is in use.
+	 */
+	bool ad_need_write_protect = false;
+	bool map_writable;
+	kvm_pfn_t pfn;
+	u64 new_spte;
+	u64 mt_mask;
+
+	/*
+	 * If addresses are being invalidated, don't do in-place promotion to
+	 * avoid accidentally mapping an invalidated address.
+	 */
+	if (unlikely(kvm->mmu_notifier_count))
+		return;
+
+	pfn = __gfn_to_pfn_memslot(slot, iter->gfn, true, NULL, true,
+				   &map_writable, NULL);
+
+	/*
+	 * Can't reconstitute an lpage if the consituent pages can't be
+	 * mapped higher.
+	 */
+	if (iter->level > kvm_mmu_max_mapping_level(kvm, slot, iter->gfn,
+						    pfn, PG_LEVEL_NUM))
+		return;
+
+	build_tdp_shadow_zero_bits_mask(&shadow_zero_check, iter->root_level);
+
+	/*
+	 * In some cases, a vCPU pointer is required to get the MT mask,
+	 * however in most cases it can be generated without one. If a
+	 * vCPU pointer is needed kvm_x86_try_get_mt_mask will fail.
+	 * In that case, bail on in-place promotion.
+	 */
+	if (unlikely(!static_call(kvm_x86_try_get_mt_mask)(kvm, iter->gfn,
+							   kvm_is_mmio_pfn(pfn),
+							   &mt_mask)))
+		return;
+
+	make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
+		  map_writable, ad_need_write_protect, mt_mask,
+		  &shadow_zero_check, &new_spte);
+
+	tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
+
+	/*
+	 * Re-read the SPTE to avoid recursing into one of the removed child
+	 * page tables.
+	 */
+	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+}
+
 /*
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
@@ -1455,9 +1515,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte) ||
-		    !is_last_spte(iter.old_spte, iter.level))
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/* Try to promote the constitutent pages to an lpage. */
+		if (!is_last_spte(iter.old_spte, iter.level)) {
+			try_promote_lpage(kvm, slot, &iter);
 			continue;
+		}
 
 		pfn = spte_to_pfn(iter.old_spte);
 		if (kvm_is_reserved_pfn(pfn) ||
-- 
2.34.0.rc0.344.g81b53c2807-goog

