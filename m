Return-Path: <kvm+bounces-3252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 182B1801C0C
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 11:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 467171C20A43
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91306156DD;
	Sat,  2 Dec 2023 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SyLHtsbV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806CC19F;
	Sat,  2 Dec 2023 02:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511349; x=1733047349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=hmQiFx37c9kQD8NB0bOovdRfd/CdlZnR5EzplmD7wsQ=;
  b=SyLHtsbVOIzjpge9tnxB/Y0SmYF18pY2YhHcm9fEGKMDXw+RfG2v/s6y
   AE9+Gd0nAAT6yaPfv0Lzklsqi9f3N3vqPFmWhMcUjXk5lWAXH/bybxAaX
   pvceSYnkQeYM5RbqwrCgczkq/FfV9QcJBRL73KL+NwnpWgxWEQ+0s+Be1
   qrVLRl0d2xunzwilHMuSKdy8lXR4LfIPWFtd4PU3+u830mynjlYz042tW
   nI8irqPC/VTbxY/+VbYeUJGroU27D7Bm2UFCEnGypFJId8E2WiwlYQb2R
   LlOGOXzBv5WVgi1OtjD1UkUujczpzSxrkJ7AY+02S8gRGQ8kS4aiysI4j
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="12304628"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="12304628"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:02:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="1101537971"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="1101537971"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:02:24 -0800
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
Subject: [RFC PATCH 36/42] KVM: x86/mmu: Keep exported TDP root valid
Date: Sat,  2 Dec 2023 17:33:25 +0800
Message-Id: <20231202093325.15676-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Keep exported TDP root always valid and zap all leaf entries to replace
the "root role invalid" operation.

Unlike TDP roots accessed by vCPUs only, update of TDP root exported to
external components must be in an atomic way, like
1. allocating new root,
2. updating and notifying new root to external components,
3. making old root invalid,

So, it's more efficient to just zap all leaf entries of the exported TDP.

Though zapping all leaf entries will make "fast zap" not fast enough, as
with commit 0df9dab891ff ("KVM: x86/mmu: Stop zapping invalidated TDP MMU
roots asynchronously"), zap of root is anyway required to be done
synchronously in kvm_mmu_zap_all_fast() before completing memslot removal.

Besides, it's also safe to skip invalidating "exported" root in
kvm_tdp_mmu_invalidate_all_roots() for path kvm_mmu_uninit_tdp_mmu(),
because when the VM is shutting down, as TDP FD will hold reference count
of kvm, kvm_mmu_uninit_tdp_mmu() --> kvm_tdp_mmu_invalidate_all_roots()
will not come until the TDP root is unmarked as "exported" and put. All
children entries are also zapped before the root is put.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c | 40 +++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h |  1 +
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e2475c678c27..37a903fff582a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6187,6 +6187,9 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	kvm_zap_obsolete_pages(kvm);
 
+	if (tdp_mmu_enabled)
+		kvm_tdp_mmu_zap_exported_roots(kvm);
+
 	write_unlock(&kvm->mmu_lock);
 
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 47edf54961e89..36a309ad27d47 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -897,12 +897,38 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 	read_unlock(&kvm->mmu_lock);
 }
 
+void kvm_tdp_mmu_zap_exported_roots(struct kvm *kvm)
+{
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+	struct kvm_mmu_page *root;
+	bool flush;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!root->exported)
+			continue;
+
+		flush = tdp_mmu_zap_leafs(kvm, root, 0, -1ULL, false, false);
+		if (flush)
+			kvm_flush_remote_tlbs(kvm);
+	}
+
+	rcu_read_unlock();
+#endif
+}
+
 /*
- * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
- * is about to be zapped, e.g. in response to a memslots update.  The actual
- * zapping is done separately so that it happens with mmu_lock with read,
- * whereas invalidating roots must be done with mmu_lock held for write (unless
- * the VM is being destroyed).
+ * Mark each TDP MMU root (except exported root) as invalid to prevent vCPUs from
+ * reusing a root that is about to be zapped, e.g. in response to a memslots
+ * update.
+ * The actual zapping is done separately so that it happens with mmu_lock
+ * with read, whereas invalidating roots must be done with mmu_lock held for write
+ * (unless the VM is being destroyed).
+ * For exported root, zap is done in kvm_tdp_mmu_zap_exported_roots() before
+ * the memslot update completes with mmu_lock held for write.
  *
  * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_get_vcpu_root_hpa().
@@ -932,6 +958,10 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	 * or get/put references to roots.
 	 */
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+		if (root->exported)
+			continue;
+#endif
 		/*
 		 * Note, invalid roots can outlive a memslot update!  Invalid
 		 * roots must be *zapped* before the memslot update completes,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1d36ed378848b..df42350022a3f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -25,6 +25,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
+void kvm_tdp_mmu_zap_exported_roots(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
-- 
2.17.1


