Return-Path: <kvm+bounces-971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1887E42AC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDE161C20FD5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CAD37149;
	Tue,  7 Nov 2023 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aRtfcDJK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F7E34CE2
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:04:51 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143E1619F;
	Tue,  7 Nov 2023 07:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369322; x=1730905322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mUGTrGbIIGBltmJxOA24uTc5A/R5LVIH6K6kMj7lVUc=;
  b=aRtfcDJKqOPWXq0CFjb5KS9OcKJEPnPf/SUApdYeGYe+fCBocgzlWV07
   Y8iFfPhOyYs3jYAME2ea1rnDuGAvSS2Sb7OL44P5V8XoVVbTkYAoLnxOQ
   zjaQkEgavqy36VWaCh/pKSDFncg+MyEvv+RUNJtUHF23eYBhuEE+5MYp8
   ZX5I+cBBRK46edInrEhY8LXULUjxOkVZWkIBw2JAN0LsNh61NrZErX4C7
   hkruPQPcaFNrd3MazVSxvXlFQRKGAxvuLB+8wwbyPX30T1G+cWsqO/2Zh
   x5ga61bqxwgciulH2IxDHIaG31KyUneN6Q7B94yFh2Tpo90IebXQ5N0pc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397614"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397614"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:01:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446853"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:01:01 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 11/16] KVM: x86/tdp_mmu: Split the large page when zap leaf
Date: Tue,  7 Nov 2023 07:00:38 -0800
Message-Id: <8b43a9203c34b5330c4ea5901da5dac3458ac98d.1699368363.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368363.git.isaku.yamahata@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

When TDX enabled, a large page cannot be zapped if it contains mixed
pages. In this case, it has to split the large page.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          |  6 +--
 arch/x86/kvm/mmu/mmu_internal.h |  9 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 68 +++++++++++++++++++++++++++++++--
 4 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b0f103641547..557479737962 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -93,6 +93,7 @@ config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
 	select KVM_SW_PROTECTED_VM if INTEL_TDX_HOST
+	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	select KVM_PRIVATE_MEM if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 265177cedf37..0bf043812644 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7463,8 +7463,8 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
-static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-				int level)
+bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+			     int level)
 {
 	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
 }
@@ -7491,7 +7491,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return kvm_range_has_memory_attributes(kvm, start, end, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
-		if (hugepage_test_mixed(slot, gfn, level - 1) ||
+		if (kvm_hugepage_test_mixed(slot, gfn, level - 1) ||
 		    attrs != kvm_get_memory_attributes(kvm, gfn))
 			return false;
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1da98be74ad2..653e96769956 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -460,4 +460,13 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+#else
+static inline bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	return false;
+}
+#endif
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7873e9ee82ad..a209a67decae 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -964,6 +964,14 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return true;
 }
 
+
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       bool shared);
+
+static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
+				   struct kvm_mmu_page *sp, bool shared);
+
 /*
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -975,13 +983,15 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 			      gfn_t start, gfn_t end, bool can_yield, bool flush,
 			      bool zap_private)
 {
+	bool is_private = is_private_sp(root);
+	struct kvm_mmu_page *split_sp = NULL;
 	struct tdp_iter iter;
 
 	end = min(end, tdp_mmu_max_gfn_exclusive());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	WARN_ON_ONCE(zap_private && !is_private_sp(root));
+	WARN_ON_ONCE(zap_private && !is_private);
 	if (!zap_private && is_private_sp(root))
 		return false;
 
@@ -1006,12 +1016,66 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		if (is_private && kvm_gfn_shared_mask(kvm) &&
+		    is_large_pte(iter.old_spte)) {
+			gfn_t gfn = iter.gfn & ~kvm_gfn_shared_mask(kvm);
+			gfn_t mask = KVM_PAGES_PER_HPAGE(iter.level) - 1;
+			struct kvm_memory_slot *slot;
+			struct kvm_mmu_page *sp;
+
+			slot = gfn_to_memslot(kvm, gfn);
+			if (kvm_hugepage_test_mixed(slot, gfn, iter.level) ||
+			    (gfn & mask) < start ||
+			    end < (gfn & mask) + KVM_PAGES_PER_HPAGE(iter.level)) {
+				WARN_ON_ONCE(!can_yield);
+				if (split_sp) {
+					sp = split_sp;
+					split_sp = NULL;
+					sp->role = tdp_iter_child_role(&iter);
+				} else {
+					WARN_ON(iter.yielded);
+					if (flush && can_yield) {
+						kvm_flush_remote_tlbs(kvm);
+						flush = false;
+					}
+					sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, false);
+					if (iter.yielded) {
+						split_sp = sp;
+						continue;
+					}
+				}
+				KVM_BUG_ON(!sp, kvm);
+
+				tdp_mmu_init_sp(sp, iter.sptep, iter.gfn);
+				if (tdp_mmu_split_huge_page(kvm, &iter, sp, false)) {
+					kvm_flush_remote_tlbs(kvm);
+					flush = false;
+					/* force retry on this gfn. */
+					iter.yielded = true;
+				} else
+					flush = true;
+				continue;
+			}
+		}
+
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 		flush = true;
 	}
 
 	rcu_read_unlock();
 
+	if (split_sp) {
+		WARN_ON(!can_yield);
+		if (flush) {
+			kvm_flush_remote_tlbs(kvm);
+			flush = false;
+		}
+
+		write_unlock(&kvm->mmu_lock);
+		tdp_mmu_free_sp(split_sp);
+		write_lock(&kvm->mmu_lock);
+	}
+
 	/*
 	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
 	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
@@ -1606,8 +1670,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 
 	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
 		   is_private_sptep(iter->sptep), kvm);
-	/* TODO: Large page isn't supported for private SPTE yet. */
-	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
-- 
2.25.1


