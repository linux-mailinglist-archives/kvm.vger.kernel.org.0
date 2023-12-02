Return-Path: <kvm+bounces-3253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED09D801C15
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 11:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DEAA1F2116C
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2D3156E6;
	Sat,  2 Dec 2023 10:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EicHjEmX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9C410C2;
	Sat,  2 Dec 2023 02:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511373; x=1733047373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Ny7K/1p6mPwz6jo6BVXvIZBJop8cXIZXURz+qH/CFNo=;
  b=EicHjEmXeYd0aRT3O1uvzEQaTHkCrIbJs0qB+ccIc9RM7okvcDHLA9pu
   /w8T6XJalLwDywlu0IFjgyIl79fWZiSsZPYYqebqXLZ6Vqs0YZQxRFrbE
   YkgxD6GydOchIi+J43ARuKcH96ceQBtlShqa9LmmCNk7HzhIIc7s5Sz0e
   0pRVz9l2Ne9qI7mkMX2GofghZWEeNd9ZzwShCTi6ufqZnOGWbFRWofuVZ
   DyxV8yUkcaqOrSTckSo6jHHe5JmisaO1Wxo0mbdpjaGtNHlCRwrBGXKiU
   rOxLNjX+kZpc1Yi1CECnWbuserHTwtjA6EDNXZkPH+0QhjWdPOmU4KM+h
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="424756538"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="424756538"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:02:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="836023023"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="836023023"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:02:49 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 37/42] KVM: x86: Implement KVM exported TDP fault handler on x86
Date: Sat,  2 Dec 2023 17:33:55 +0800
Message-Id: <20231202093355.15745-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Implement fault handler of KVM exported TDP on x86.
The fault handler will fail if the GFN to be faulted is in emulated MMIO
range or in write-tracked range.

kvm_tdp_mmu_map_exported_root() is actually a duplicate of
kvm_tdp_mmu_map() except that its shadow pages are allocated from exported
TDP specific header/page caches in kvm arch rather than from each vCPU's
header/page caches.

The exported TDP specific header/page caches are used is because fault
handler of KVM exported TDP is not called in vCPU thread.
Will seek to remove the duplication in future.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu.h         |  1 +
 arch/x86/kvm/mmu/mmu.c     | 57 +++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 81 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +
 arch/x86/kvm/x86.c         | 22 +++++++++++
 5 files changed, 163 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 3d11f2068572d..a6e6802fb4d56 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -254,6 +254,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 #ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
 int kvm_mmu_get_exported_tdp(struct kvm *kvm, struct kvm_exported_tdp *tdp);
 void kvm_mmu_put_exported_tdp(struct kvm_exported_tdp *tdp);
+int kvm_mmu_fault_exported_tdp(struct kvm_exported_tdp *tdp, unsigned long gfn, u32 err);
 #endif
 
 static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 37a903fff582a..b4b1ede30642d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7324,4 +7324,61 @@ void kvm_mmu_put_exported_tdp(struct kvm_exported_tdp *tdp)
 	mmu->root_page = NULL;
 	write_unlock(&kvm->mmu_lock);
 }
+
+int kvm_mmu_fault_exported_tdp(struct kvm_exported_tdp *tdp, unsigned long gfn, u32 err)
+{
+	struct kvm *kvm = tdp->kvm;
+	struct kvm_page_fault fault = {
+		.addr = gfn << PAGE_SHIFT,
+		.error_code = err,
+		.prefetch = false,
+		.exec = err & PFERR_FETCH_MASK,
+		.write = err & PFERR_WRITE_MASK,
+		.present = err & PFERR_PRESENT_MASK,
+		.rsvd = err & PFERR_RSVD_MASK,
+		.user = err & PFERR_USER_MASK,
+		.is_tdp = true,
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(kvm),
+		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.req_level = PG_LEVEL_4K,
+		.goal_level = PG_LEVEL_4K,
+		.gfn = gfn,
+		.slot = gfn_to_memslot(kvm, gfn),
+	};
+	struct kvm_exported_tdp_mmu *mmu = &tdp->arch.mmu;
+	int r;
+
+	if (page_fault_handle_page_track(kvm, &fault))
+		return -EINVAL;
+retry:
+	r = kvm_faultin_pfn(kvm, NULL, &fault, ACC_ALL);
+	if (r != RET_PF_CONTINUE)
+		goto out;
+
+	mutex_lock(&kvm->arch.exported_tdp_cache_lock);
+	r = mmu_topup_exported_tdp_caches(kvm);
+	if (r)
+		goto out_cache;
+
+	r = RET_PF_RETRY;
+	read_lock(&kvm->mmu_lock);
+	if (fault.slot && mmu_invalidate_retry_hva(kvm, fault.mmu_seq, fault.hva))
+		goto out_mmu;
+
+	if (mmu->root_page && is_obsolete_sp(kvm, mmu->root_page))
+		goto out_mmu;
+
+	r = kvm_tdp_mmu_map_exported_root(kvm, mmu, &fault);
+
+out_mmu:
+	read_unlock(&kvm->mmu_lock);
+out_cache:
+	mutex_unlock(&kvm->arch.exported_tdp_cache_lock);
+	kvm_release_pfn_clean(fault.pfn);
+out:
+	if (r == RET_PF_RETRY)
+		goto retry;
+
+	return r == RET_PF_FIXED ? 0 : -EFAULT;
+}
 #endif
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 36a309ad27d47..e7587aefc3304 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1900,4 +1900,85 @@ void kvm_tdp_mmu_put_exported_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	kvm_tdp_mmu_put_root(kvm, root, false);
 }
 
+int kvm_tdp_mmu_map_exported_root(struct kvm *kvm, struct kvm_exported_tdp_mmu *mmu,
+				  struct kvm_page_fault *fault)
+{
+	struct tdp_iter iter;
+	struct kvm_mmu_page *sp;
+	int ret = RET_PF_RETRY;
+
+	kvm_mmu_hugepage_adjust(kvm, fault);
+
+	trace_kvm_mmu_spte_requested(fault);
+
+	rcu_read_lock();
+
+	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+		int r;
+
+		if (fault->nx_huge_page_workaround_enabled)
+			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
+
+		/*
+		 * If SPTE has been frozen by another thread, just give up and
+		 * retry, avoiding unnecessary page table allocation and free.
+		 */
+		if (is_removed_spte(iter.old_spte))
+			goto retry;
+
+		if (iter.level == fault->goal_level)
+			goto map_target_level;
+
+		/* Step down into the lower level page table if it exists. */
+		if (is_shadow_present_pte(iter.old_spte) &&
+		    !is_large_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * The SPTE is either non-present or points to a huge page that
+		 * needs to be split.
+		 */
+		sp = tdp_mmu_alloc_sp_exported_cache(kvm);
+		tdp_mmu_init_child_sp(sp, &iter);
+
+		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
+
+		if (is_shadow_present_pte(iter.old_spte))
+			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
+		else
+			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
+
+		/*
+		 * Force the guest to retry if installing an upper level SPTE
+		 * failed, e.g. because a different task modified the SPTE.
+		 */
+		if (r) {
+			tdp_mmu_free_sp(sp);
+			goto retry;
+		}
+
+		if (fault->huge_page_disallowed &&
+		    fault->req_level >= iter.level) {
+			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+			if (sp->nx_huge_page_disallowed)
+				track_possible_nx_huge_page(kvm, sp);
+			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+		}
+	}
+
+	/*
+	 * The walk aborted before reaching the target level, e.g. because the
+	 * iterator detected an upper level SPTE was frozen during traversal.
+	 */
+	WARN_ON_ONCE(iter.level == fault->goal_level);
+	goto retry;
+
+map_target_level:
+	ret = tdp_mmu_map_handle_target_level(kvm, NULL, &mmu->common, fault, &iter);
+
+retry:
+	rcu_read_unlock();
+	return ret;
+}
+
 #endif
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index df42350022a3f..a3ea418aaffed 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -80,6 +80,8 @@ static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 struct kvm_mmu_page *kvm_tdp_mmu_get_exported_root(struct kvm *kvm,
 						   struct kvm_exported_tdp_mmu *mmu);
 void kvm_tdp_mmu_put_exported_root(struct kvm *kvm, struct kvm_mmu_page *root);
+int kvm_tdp_mmu_map_exported_root(struct kvm *kvm, struct kvm_exported_tdp_mmu *mmu,
+				  struct kvm_page_fault *fault);
 #endif
 
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index afc0e5372ddce..2886eac0590d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13445,6 +13445,28 @@ void kvm_arch_exported_tdp_destroy(struct kvm_exported_tdp *tdp)
 {
 	kvm_mmu_put_exported_tdp(tdp);
 }
+
+int kvm_arch_fault_exported_tdp(struct kvm_exported_tdp *tdp, unsigned long gfn,
+				struct kvm_tdp_fault_type type)
+{
+	u32 err = 0;
+	int ret;
+
+	if (type.read)
+		err |= PFERR_PRESENT_MASK | PFERR_USER_MASK;
+
+	if (type.write)
+		err |= PFERR_WRITE_MASK;
+
+	if (type.exec)
+		err |= PFERR_FETCH_MASK;
+
+	mutex_lock(&tdp->kvm->slots_lock);
+	ret = kvm_mmu_fault_exported_tdp(tdp, gfn, err);
+	mutex_unlock(&tdp->kvm->slots_lock);
+	return ret;
+}
+
 #endif
 
 int kvm_spec_ctrl_test_value(u64 value)
-- 
2.17.1


