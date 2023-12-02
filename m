Return-Path: <kvm+bounces-3251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED694801C0A
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 11:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A23B8281D7B
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CA0156DD;
	Sat,  2 Dec 2023 10:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gcXXIdQP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D02C10C2;
	Sat,  2 Dec 2023 02:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511318; x=1733047318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=4u8cSeWDKWAI+5kWXYXLrN5RJVNgC+yTrQ8oaHPCpOs=;
  b=gcXXIdQPBqP8Dnkc9IzQ474n58moiLDYrBEARNKLbsztuM+wwvSuLL18
   XkRerZPmbUR85sLWrA00YU+hkybxy80X62YaAUJoYiBSAv0Vfg1yQpFYM
   IJexhn6p1PhRQMuMM/99QuD358r2elO9vzvFD0DZOZkR5Qx4O6dOSBGhR
   q0DnCjLKY9V5ziK6a6DoNL9IhNeYq2ryy16847wnFtD+t4ZJy9KS+thcA
   ZFcmmjSnhkm3yOYsVj933hQCKx+cJQeHVsUd4/NwAc6jr/DwP21AhNVOP
   OtBHoAtXm9u6+2RE5SkpdSZlU/AHUr+p++v9jf9ozQOpRVwSTE0v1OuoR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="424756492"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="424756492"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:01:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="836022857"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="836022857"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 02:01:54 -0800
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
Subject: [RFC PATCH 35/42] KVM: x86/mmu: Get/Put TDP root page to be exported
Date: Sat,  2 Dec 2023 17:32:59 +0800
Message-Id: <20231202093259.15609-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Get/Put the root page of a KVM exported TDP page table based on KVM TDP
MMU.

When KVM TDP FD requests a TDP to export, it provides an address space
to indicate page roles of the TDP to export. In this RFC, KVM address space
0 is supported only. So, TDP MMU will select a root page role with smm=0
and guest_mode=0. (Level of root page role is from kvm->arch.maxphyaddr,
based on the assumption that vCPUs are homogeneous.)

TDP MMU then searches list tdp_mmu_roots for a existing root, or create a
new root if no one is found.
A specific kvm->arch.exported_tdp_header_cache is used to allocate the root
page in non-vCPU context.
The found/created root page will be marked as "exported".

When KVM TDP fd puts the exported FD, the mark of "exported" on root page
role will be removed.

No matter the root page role is exported or not, vCPUs just load TDP root
according to its vCPU modes.

In this way, KVM is able to share the TDP page tables in KVM address space
0 to IOMMU side.

                                         tdp_mmu_roots
                                             |
 role | smm | guest_mode              +------+-----------+----------+
------|-----------------              |      |           |          |
  0   |  0  |  0 ==> address space 0  |      v           v          v
  1   |  1  |  0                      |  .--------.  .--------. .--------.
  2   |  0  |  1                      |  |  root  |  |  root  | |  root  |
  3   |  1  |  1                      |  |(role 1)|  |(role 2)| |(role 3)|
                                      |  '--------'  '--------' '--------'
                                      |      ^
                                      |      |    create or get   .------.
                                      |      +--------------------| vCPU |
                                      |              fault        '------'
                                      |                            smm=1
                                      |                       guest_mode=0
                                      |
          (set root as exported)      v
.--------.    create or get   .---------------.  create or get   .------.
| TDP FD |------------------->| root (role 0) |<-----------------| vCPU |
'--------'        fault       '---------------'     fault        '------'
                                      .                            smm=0
                                      .                       guest_mode=0
                                      .
                 non-vCPU context <---|---> vCPU context
                                      .
                                      .

This patch actually needs to be split into several smaller ones.
It's tempted to be kept in a single big patch to show a bigger picture.
Will split them into smaller ones in next version.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  18 +++++
 arch/x86/kvm/mmu.h              |   5 ++
 arch/x86/kvm/mmu/mmu.c          | 129 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |   4 +
 arch/x86/kvm/mmu/tdp_mmu.c      |  47 ++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   6 ++
 arch/x86/kvm/x86.c              |  17 +++++
 7 files changed, 226 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1f6ac04e0f952..860502720e3e7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1476,7 +1476,25 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+	struct kvm_mmu_memory_cache exported_tdp_header_cache;
+	struct kvm_mmu_memory_cache exported_tdp_page_cache;
+	struct mutex exported_tdp_cache_lock;
+	int maxphyaddr;
+#endif
+};
+
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+#define __KVM_HAVE_ARCH_EXPORTED_TDP
+struct kvm_exported_tdp_mmu {
+	struct kvm_mmu_common common;
+	struct kvm_mmu_page *root_page;
 };
+struct kvm_arch_exported_tdp {
+	struct kvm_exported_tdp_mmu mmu;
+};
+#endif
 
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e9631cc23a594..3d11f2068572d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -251,6 +251,11 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+int kvm_mmu_get_exported_tdp(struct kvm *kvm, struct kvm_exported_tdp *tdp);
+void kvm_mmu_put_exported_tdp(struct kvm_exported_tdp *tdp);
+#endif
+
 static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c9b587b30dae3..3e2475c678c27 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5468,6 +5468,13 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested_mmu.cpu_role.ext.valid = 0;
 	kvm_mmu_reset_context(vcpu);
 
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+	if (vcpu->kvm->arch.maxphyaddr)
+		vcpu->kvm->arch.maxphyaddr = min(vcpu->kvm->arch.maxphyaddr,
+						 vcpu->arch.maxphyaddr);
+	else
+		vcpu->kvm->arch.maxphyaddr = vcpu->arch.maxphyaddr;
+#endif
 	/*
 	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
 	 * kvm_arch_vcpu_ioctl().
@@ -6216,6 +6223,13 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
+
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+	mutex_init(&kvm->arch.exported_tdp_cache_lock);
+	kvm->arch.exported_tdp_header_cache.kmem_cache = mmu_page_header_cache;
+	kvm->arch.exported_tdp_header_cache.gfp_zero = __GFP_ZERO;
+	kvm->arch.exported_tdp_page_cache.gfp_zero = __GFP_ZERO;
+#endif
 }
 
 static void mmu_free_vm_memory_caches(struct kvm *kvm)
@@ -7193,3 +7207,118 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.nx_huge_page_recovery_thread)
 		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
+
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+static bool kvm_mmu_is_expoted_allowed(struct kvm *kvm, int as_id)
+{
+	if (as_id != 0) {
+		pr_err("unsupported address space to export TDP\n");
+		return false;
+	}
+
+	/*
+	 * Currently, exporting TDP is based on TDP MMU and is not enabled on
+	 * hyperv, one of the reasons is because of hyperv's tlb flush way
+	 */
+	if (!tdp_mmu_enabled || IS_ENABLED(CONFIG_HYPERV) ||
+	    !IS_ENABLED(CONFIG_HAVE_KVM_MMU_PRESENT_HIGH)) {
+		pr_err("Not allowed to create exported tdp, please check config\n");
+		return false;
+	}
+
+	/* we need max phys addr of vcpus, so oneline vcpus must > 0 */
+	if (!atomic_read(&kvm->online_vcpus)) {
+		pr_err("Exported tdp must be created after vCPUs created\n");
+		return false;
+	}
+
+	if (kvm->arch.maxphyaddr < 32) {
+		pr_err("Exported tdp must be created on 64-bit platform\n");
+		return false;
+	}
+	/*
+	 * Do not allow noncoherent DMA if TDP is exported, because mapping of
+	 * the exported TDP may not be at vCPU context, but noncoherent DMA
+	 * requires vCPU mode and guest vCPU MTRRs to get the right memory type.
+	 */
+	if (kvm_arch_has_noncoherent_dma(kvm)) {
+		pr_err("Not allowed to create exported tdp for noncoherent DMA\n");
+		return false;
+	}
+
+	return true;
+}
+
+static void init_kvm_exported_tdp_mmu(struct kvm *kvm, int as_id,
+				     struct kvm_exported_tdp_mmu *mmu)
+{
+	WARN_ON(!kvm->arch.maxphyaddr);
+
+	union kvm_cpu_role cpu_role = { 0 };
+
+	cpu_role.base.smm = !!as_id;
+	cpu_role.base.guest_mode = 0;
+
+	mmu->common.root_role = kvm_calc_tdp_mmu_root_page_role(kvm->arch.maxphyaddr,
+								cpu_role);
+	reset_tdp_shadow_zero_bits_mask(&mmu->common);
+}
+
+static int mmu_topup_exported_tdp_caches(struct kvm *kvm)
+{
+	int r;
+
+	lockdep_assert_held(&kvm->arch.exported_tdp_cache_lock);
+
+	r = kvm_mmu_topup_memory_cache(&kvm->arch.exported_tdp_header_cache,
+				       PT64_ROOT_MAX_LEVEL);
+	if (r)
+		return r;
+
+	return kvm_mmu_topup_memory_cache(&kvm->arch.exported_tdp_page_cache,
+				       PT64_ROOT_MAX_LEVEL);
+}
+
+int kvm_mmu_get_exported_tdp(struct kvm *kvm, struct kvm_exported_tdp *tdp)
+{
+	struct kvm_exported_tdp_mmu *mmu = &tdp->arch.mmu;
+	struct kvm_mmu_page *root;
+	int ret;
+
+	if (!kvm_mmu_is_expoted_allowed(kvm, tdp->as_id))
+		return -EINVAL;
+
+	init_kvm_exported_tdp_mmu(kvm, tdp->as_id, mmu);
+
+	mutex_lock(&kvm->arch.exported_tdp_cache_lock);
+	ret = mmu_topup_exported_tdp_caches(kvm);
+	if (ret) {
+		mutex_unlock(&kvm->arch.exported_tdp_cache_lock);
+		return ret;
+	}
+	write_lock(&kvm->mmu_lock);
+	root = kvm_tdp_mmu_get_exported_root(kvm, mmu);
+	WARN_ON(root->exported);
+	root->exported = true;
+	mmu->common.root.hpa = __pa(root->spt);
+	mmu->root_page = root;
+	write_unlock(&kvm->mmu_lock);
+
+	mutex_unlock(&kvm->arch.exported_tdp_cache_lock);
+
+	return 0;
+}
+
+void kvm_mmu_put_exported_tdp(struct kvm_exported_tdp *tdp)
+{
+	struct kvm_exported_tdp_mmu *mmu = &tdp->arch.mmu;
+	struct kvm *kvm = tdp->kvm;
+
+	write_lock(&kvm->mmu_lock);
+	mmu->root_page->exported = false;
+	kvm_tdp_mmu_put_exported_root(kvm, mmu->root_page);
+	mmu->common.root.hpa = INVALID_PAGE;
+	mmu->root_page = NULL;
+	write_unlock(&kvm->mmu_lock);
+}
+#endif
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1e9be0604e348..9294bb7e56c08 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -130,6 +130,10 @@ struct kvm_mmu_page {
 	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
 	struct rcu_head rcu_head;
 #endif
+
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+	bool exported;
+#endif
 };
 
 extern struct kmem_cache *mmu_page_header_cache;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5edff3b4698b7..47edf54961e89 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1824,3 +1824,50 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 	 */
 	return rcu_dereference(sptep);
 }
+
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_exported_cache(struct kvm *kvm)
+{
+	struct kvm_mmu_page *sp;
+
+	sp = kvm_mmu_memory_cache_alloc(&kvm->arch.exported_tdp_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&kvm->arch.exported_tdp_page_cache);
+
+	return sp;
+}
+
+struct kvm_mmu_page *kvm_tdp_mmu_get_exported_root(struct kvm *kvm,
+						   struct kvm_exported_tdp_mmu *mmu)
+{
+	union kvm_mmu_page_role role = mmu->common.root_role;
+	struct kvm_mmu_page *root;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
+		if (root->role.word == role.word &&
+		    kvm_tdp_mmu_get_root(root))
+			goto out;
+
+	}
+
+	root = tdp_mmu_alloc_sp_exported_cache(kvm);
+	tdp_mmu_init_sp(root, NULL, 0, role);
+
+	refcount_set(&root->tdp_mmu_root_count, 2);
+
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+
+out:
+	return root;
+}
+
+void kvm_tdp_mmu_put_exported_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	tdp_mmu_zap_root(kvm, root, false);
+	kvm_tdp_mmu_put_root(kvm, root, false);
+}
+
+#endif
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 733a3aef3a96e..1d36ed378848b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -75,4 +75,10 @@ static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 #endif
 
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+struct kvm_mmu_page *kvm_tdp_mmu_get_exported_root(struct kvm *kvm,
+						   struct kvm_exported_tdp_mmu *mmu);
+void kvm_tdp_mmu_put_exported_root(struct kvm *kvm, struct kvm_mmu_page *root);
+#endif
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9ac8682c70ae7..afc0e5372ddce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13429,6 +13429,23 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_HAVE_KVM_EXPORTED_TDP
+int kvm_arch_exported_tdp_init(struct kvm *kvm, struct kvm_exported_tdp *tdp)
+{
+	int ret;
+
+	ret = kvm_mmu_get_exported_tdp(kvm, tdp);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+void kvm_arch_exported_tdp_destroy(struct kvm_exported_tdp *tdp)
+{
+	kvm_mmu_put_exported_tdp(tdp);
+}
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
-- 
2.17.1


