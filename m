Return-Path: <kvm+bounces-6705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31279837BB0
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 563C11C27B2B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27DE151CE7;
	Tue, 23 Jan 2024 00:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b1J+FmIf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B231B14D45E;
	Tue, 23 Jan 2024 00:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969366; cv=none; b=jsQ6VR+33VUIYAT8VadkZGQ8O/L4CxOfZ+p6C53axG9UPIC9oSpk+Lui4W1XvV/ThXxfej9v5sTY5SG92gFC3Rujbsh77gJSk0B3SE7VseK95zs0YzCsFrg5uWkGYTfwoVSOtawxRSOEZsOgQPX1aja0fPa++dj/K5bIogVqLAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969366; c=relaxed/simple;
	bh=Pk23GfO1+xv+r2v/tTA08MRpYztkXVfkC6AZBWmQV60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OIjAG52lCnfta9w/66eFLeuZwRFeBRdYuKP+tfhlfHy52QPRYhCUPo8Wvjh9HZ6RK7TIkQd7oPk7qY1XpgDrSeC3JaF6eJj0ROepmj7EPXX7BvtJg5tZXniJE2/GCGTgnRixtfj521qleM4aTOk+XsF5yWAv9RaEOPVR/GUt020=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b1J+FmIf; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969364; x=1737505364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pk23GfO1+xv+r2v/tTA08MRpYztkXVfkC6AZBWmQV60=;
  b=b1J+FmIfoC5PoGbocjqqIkTmas5LJv6BbfiI+SIdDkonjDIKEZmM7Sl6
   TgRWy6bEiffeeClOenY0WSAS5truRhbykPHzE/6ToNBv8xPzXiJk63SOL
   8tsIRHk8cYFqv+LrJ9G54g3RpYcVh8mURU23AoF4tAGyb1AdVh5czeSvU
   EZOxV9uGoCUkFc3BZF4qCZOcYmKA2fqcAyi2Lw1f5B5u5WfEMAORoRSxv
   V5ooaAP+dMlVtTVfNL2xbX1jIm23Dw8SwG5pprE66nWeXq7akhpbAi0pR
   dyhQb0FQ6/Txvg2syA50yVwS5gscWvX8ncY7BPit/hhWI61YHoRH0pcpq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125696"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125696"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825659"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:40 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v7 10/13] KVM: x86/tdp_mmu: Try to merge pages into a large page
Date: Mon, 22 Jan 2024 16:22:25 -0800
Message-Id: <5dec631851838d86314b86b6ebe95a1c7d77f386.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

When a large page is passed to the KVM page fault handler and some of sub
pages are already populated, try to merge sub pages into a large page.
This situation can happen when the guest converts small pages into shared
and convert it back into private.

When a large page is passed to KVM mmu page fault handler and the spte
corresponding to the page is non-leaf (one or more of sub pages are already
populated at lower page level), the current kvm mmu zaps non-leaf spte at a
large page level, and populate a leaf spte at that level.  Thus small pages
are converted into a large page.  However, it doesn't work for TDX because
zapping and re-populating results in zeroing page content.  Instead,
populate all small pages and merge them into a large page.

Merging pages into a large page can fail when some sub pages are accepted
and some are not.  In such case, with the assumption that guest tries to
accept at large page size for performance when possible, don't try to be
smart to identify which page is still pending, map all pages at lower page
level, and let vcpu re-execute.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v7:
- typo freezed => frozen
- return 0 when page is merged into 2M large page instead of -EAGAIN

v5:
- Fix memory leak
---
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |   4 +
 arch/x86/kvm/mmu/tdp_iter.c        |  37 ++++--
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 176 ++++++++++++++++++++++++++++-
 5 files changed, 211 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 08c55c3d6e5b..f4d3a9d1b613 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -106,9 +106,11 @@ KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(link_private_spt)
 KVM_X86_OP_OPTIONAL(free_private_spt)
 KVM_X86_OP_OPTIONAL(split_private_spt)
+KVM_X86_OP_OPTIONAL(merge_private_spt)
 KVM_X86_OP_OPTIONAL(set_private_spte)
 KVM_X86_OP_OPTIONAL(remove_private_spte)
 KVM_X86_OP_OPTIONAL(zap_private_spte)
+KVM_X86_OP_OPTIONAL(unzap_private_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8123fad88750..43614c6b84f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -147,6 +147,7 @@
 #define KVM_MAX_HUGEPAGE_LEVEL	PG_LEVEL_1G
 #define KVM_NR_PAGE_SIZES	(KVM_MAX_HUGEPAGE_LEVEL - PG_LEVEL_4K + 1)
 #define KVM_HPAGE_GFN_SHIFT(x)	(((x) - 1) * 9)
+#define KVM_HPAGE_GFN_MASK(x)	(~((1UL << KVM_HPAGE_GFN_SHIFT(x)) - 1))
 #define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + KVM_HPAGE_GFN_SHIFT(x))
 #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
@@ -1785,11 +1786,14 @@ struct kvm_x86_ops {
 				void *private_spt);
 	int (*split_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				  void *private_spt);
+	int (*merge_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 void *private_spt);
 	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn);
 	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				    kvm_pfn_t pfn);
 	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
+	int (*unzap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 04c247bfe318..c4a18703f88a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -71,6 +71,14 @@ tdp_ptep_t spte_to_child_pt(u64 spte, int level)
 	return (tdp_ptep_t)__va(spte_to_pfn(spte) << PAGE_SHIFT);
 }
 
+static void step_down(struct tdp_iter *iter, tdp_ptep_t child_pt)
+{
+	iter->level--;
+	iter->pt_path[iter->level - 1] = child_pt;
+	iter->gfn = gfn_round_for_level(iter->next_last_level_gfn, iter->level);
+	tdp_iter_refresh_sptep(iter);
+}
+
 /*
  * Steps down one level in the paging structure towards the goal GFN. Returns
  * true if the iterator was able to step down a level, false otherwise.
@@ -92,14 +100,28 @@ static bool try_step_down(struct tdp_iter *iter)
 	if (!child_pt)
 		return false;
 
-	iter->level--;
-	iter->pt_path[iter->level - 1] = child_pt;
-	iter->gfn = gfn_round_for_level(iter->next_last_level_gfn, iter->level);
-	tdp_iter_refresh_sptep(iter);
-
+	step_down(iter, child_pt);
 	return true;
 }
 
+/* Steps down for frozen spte.  Don't re-read sptep because it was frozen. */
+void tdp_iter_step_down(struct tdp_iter *iter, tdp_ptep_t child_pt)
+{
+	WARN_ON_ONCE(!child_pt);
+	WARN_ON_ONCE(iter->yielded);
+	WARN_ON_ONCE(iter->level == iter->min_level);
+
+	step_down(iter, child_pt);
+}
+
+void tdp_iter_step_side(struct tdp_iter *iter)
+{
+	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
+	iter->next_last_level_gfn = iter->gfn;
+	iter->sptep++;
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
+}
+
 /*
  * Steps to the next entry in the current page table, at the current page table
  * level. The next entry could point to a page backing guest memory or another
@@ -117,10 +139,7 @@ static bool try_step_side(struct tdp_iter *iter)
 	    (SPTE_ENT_PER_PAGE - 1))
 		return false;
 
-	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
-	iter->next_last_level_gfn = iter->gfn;
-	iter->sptep++;
-	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
+	tdp_iter_step_side(iter);
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index a9c9cd0db20a..ca00db799a50 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -134,6 +134,8 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
+void tdp_iter_step_side(struct tdp_iter *iter);
+void tdp_iter_step_down(struct tdp_iter *iter, tdp_ptep_t child_pt);
 
 static inline union kvm_mmu_page_role tdp_iter_child_role(struct tdp_iter *iter)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3f7307938982..bd9ec77e7933 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1205,6 +1205,180 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private)
 	}
 }
 
+static int tdp_mmu_iter_step_side(int i, struct tdp_iter *iter)
+{
+	i++;
+
+	/*
+	 * if i = SPTE_ENT_PER_PAGE, tdp_iter_step_side() results
+	 * in reading the entry beyond the last entry.
+	 */
+	if (i < SPTE_ENT_PER_PAGE)
+		tdp_iter_step_side(iter);
+
+	return i;
+}
+
+static int tdp_mmu_merge_private_spt(struct kvm_vcpu *vcpu,
+				     struct kvm_page_fault *fault,
+				     struct tdp_iter *iter, u64 new_spte)
+{
+	u64 *sptep = rcu_dereference(iter->sptep);
+	u64 old_spte = iter->old_spte;
+	struct kvm_mmu_page *child_sp;
+	struct kvm *kvm = vcpu->kvm;
+	struct tdp_iter child_iter;
+	int level = iter->level;
+	gfn_t gfn = iter->gfn;
+	tdp_ptep_t child_pt;
+	u64 child_spte;
+	int ret = 0;
+	int i;
+
+	/*
+	 * TDX KVM supports only 2MB large page.  It's not supported to merge
+	 * 2MB pages into 1GB page at the moment.
+	 */
+	WARN_ON_ONCE(fault->goal_level != PG_LEVEL_2M);
+	WARN_ON_ONCE(iter->level != PG_LEVEL_2M);
+	WARN_ON_ONCE(!is_large_pte(new_spte));
+
+	/* Freeze the spte to prevent other threads from working spte. */
+	if (!try_cmpxchg64(sptep, &iter->old_spte, REMOVED_SPTE))
+		return -EBUSY;
+
+	/*
+	 * Step down to the child spte.  Because tdp_iter_next() assumes the
+	 * parent spte isn't frozen, do it manually.
+	 */
+	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
+	child_sp = sptep_to_sp(child_pt);
+	WARN_ON_ONCE(child_sp->role.level != PG_LEVEL_4K);
+	WARN_ON_ONCE(!kvm_mmu_page_role_is_private(child_sp->role));
+
+	/* Don't modify iter as the caller will use iter after this function. */
+	child_iter = *iter;
+	/* Adjust the target gfn to the head gfn of the large page. */
+	child_iter.next_last_level_gfn &= -KVM_PAGES_PER_HPAGE(level);
+	tdp_iter_step_down(&child_iter, child_pt);
+
+	/*
+	 * All child pages are required to be populated for merging them into a
+	 * large page.  Populate all child spte.
+	 */
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i = tdp_mmu_iter_step_side(i, &child_iter)) {
+		int tmp;
+
+		WARN_ON_ONCE(child_iter.level != PG_LEVEL_4K);
+
+		if (is_shadow_present_pte(child_iter.old_spte)) {
+			/* TODO: relocate page for huge page. */
+			if (WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) !=
+					 spte_to_pfn(new_spte) + i)) {
+				if (!ret)
+					ret = -EAGAIN;
+				continue;
+			}
+			/*
+			 * When SEPT_VE_DISABLE=true and the page state is
+			 * pending, this case can happen.  Just resume the vcpu
+			 * again with the expectation for other vcpu to accept
+			 * this page.
+			 */
+			if (child_iter.gfn == fault->gfn) {
+				if (!ret)
+					ret = -EAGAIN;
+			}
+			continue;
+		}
+
+		child_spte = make_huge_page_split_spte(kvm, new_spte, child_sp->role, i);
+		/*
+		 * Because other thread may have started to operate on this spte
+		 * before freezing the parent spte,  Use atomic version to
+		 * prevent race.
+		 */
+		tmp = tdp_mmu_set_spte_atomic(vcpu->kvm, &child_iter, child_spte);
+		if (tmp == -EBUSY || tmp == -EAGAIN) {
+			/*
+			 * There was a race condition.  Populate remaining 4K
+			 * spte to resolve fault->gfn to guarantee the forward
+			 * progress.
+			 */
+			if (!ret)
+				ret = tmp;
+		} else if (tmp) {
+			ret = tmp;
+			goto out;
+		}
+	}
+	if (ret)
+		goto out;
+
+	/* Prevent the Secure-EPT entry from being used. */
+	ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+	if (ret)
+		goto out;
+	kvm_flush_remote_tlbs_range(kvm, gfn & KVM_HPAGE_GFN_MASK(level),
+				    KVM_PAGES_PER_HPAGE(level));
+
+	/* Merge pages into a large page. */
+	ret = static_call(kvm_x86_merge_private_spt)(kvm, gfn, level,
+						     kvm_mmu_private_spt(child_sp));
+	/*
+	 * Failed to merge pages because some pages are accepted and some are
+	 * pending.  Since the child page was mapped above, let vcpu run.
+	 */
+	if (ret) {
+		if (static_call(kvm_x86_unzap_private_spte)(kvm, gfn, level))
+			old_spte = SHADOW_NONPRESENT_VALUE |
+				(spte_to_pfn(old_spte) << PAGE_SHIFT) |
+				PT_PAGE_SIZE_MASK;
+		goto out;
+	}
+
+	/* Update stats manually as we don't use tdp_mmu_set_spte{, _atomic}(). */
+	kvm_update_page_stats(kvm, level - 1, -SPTE_ENT_PER_PAGE);
+	kvm_update_page_stats(kvm, level, 1);
+
+	/* Unfreeze spte. */
+	iter->old_spte = new_spte;
+	__kvm_tdp_mmu_write_spte(sptep, new_spte);
+
+	/*
+	 * Free unused child sp.  Secure-EPT page was already freed at TDX level
+	 * by kvm_x86_merge_private_spt().
+	 */
+	tdp_unaccount_mmu_page(kvm, child_sp);
+	tdp_mmu_free_sp(child_sp);
+	return 0;
+
+out:
+	iter->old_spte = old_spte;
+	__kvm_tdp_mmu_write_spte(sptep, old_spte);
+	return ret;
+}
+
+static int __tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
+					     struct kvm_page_fault *fault,
+					     struct tdp_iter *iter, u64 new_spte)
+{
+	/*
+	 * The private page has smaller-size pages.  For example, the child
+	 * pages was converted from shared to page, and now it can be mapped as
+	 * a large page.  Try to merge small pages into a large page.
+	 */
+	if (fault->slot &&
+	    kvm_gfn_shared_mask(vcpu->kvm) &&
+	    iter->level > PG_LEVEL_4K &&
+	    kvm_is_private_gpa(vcpu->kvm, fault->addr) &&
+	    is_shadow_present_pte(iter->old_spte) &&
+	    !is_large_pte(iter->old_spte))
+		return tdp_mmu_merge_private_spt(vcpu, fault, iter, new_spte);
+
+	return tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte);
+}
+
 /*
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
@@ -1246,7 +1420,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+	else if (__tdp_mmu_map_handle_target_level(vcpu, fault, iter, new_spte))
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
-- 
2.25.1


