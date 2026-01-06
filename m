Return-Path: <kvm+bounces-67128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 57BECCF7CCC
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:32:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 49DA23032CD1
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243553358B1;
	Tue,  6 Jan 2026 10:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+3pmAEB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51830335097;
	Tue,  6 Jan 2026 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695138; cv=none; b=tB40wTP8ZmWWaDf3aU9of4wuaTRn3laX2A3AiMN0bni3En/rkP+7Gtavf4hqE3/eyYpSFeGZ+fyFVGT6WJvfYXVgTLzSW86lHkAKnrKSkwp+p6c2RVpI2ds4e+u0JxJ+Ah3J5le3ZESCQZjaAZ/9a6CIkHDn37wgRauNxXfDZUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695138; c=relaxed/simple;
	bh=VJy5UQSBk0MUjLZqt0wrUpLU7GZHYX/hSwGX2hN+5eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoNbK8NAFu3iUkmLVfWP0ohycX3M5179MFY50Fo9qSebthdj7kjGPnOuTeaE8xlNL44QFpbc7MG8yE7HqRexFLRySNeNeF8AR7a6QJ5Zt2C5t9ISLVK3qhwd+W+nsC8oSRyWxbJnlMSw3ZaUpyQOa+Dsa5lDmKRvOfipZx9MFuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+3pmAEB; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695136; x=1799231136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VJy5UQSBk0MUjLZqt0wrUpLU7GZHYX/hSwGX2hN+5eg=;
  b=D+3pmAEBOGCp9XV2vfg0SHUrr3/dp6mPjgm1VzpL+WtpZxAG+hteSiNb
   w5ww0Vz/qpfu3DnbAex0ZcUPM2AditmlG26L9R/YdYurWS9chO+B9af5c
   9DRhJA2390jPD1v7QRw9wxgRR9/SKuTdujF3Q2XgDI0u1N/y2zqHRKlzH
   HuhtXnzCGX5ARsowSZtIJF+t1qxF74Rws89JUQ94DDQT2TH0XlSEHHFcH
   a7QNW3rm/CPClU4I7Hs88PMjJUphL41R5lR3uENXRsk4zscwjKZq7MMzw
   Ll4slcNu3rgRBFcJhnQfuNOEUqMZ+FbQ5ABojRojash/QYIe9CeAV/WNS
   w==;
X-CSE-ConnectionGUID: 9NiaDqZoSlOtQ6MSCezPKg==
X-CSE-MsgGUID: Ep/w2U9kTB2XHeR0sGasCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72689736"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72689736"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:34 -0800
X-CSE-ConnectionGUID: 98YaJTufTiKZm/pvRdVkzQ==
X-CSE-MsgGUID: Hqu89t5FTZa55nCdoVfZ7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202645182"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:29 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	michael.roth@amd.com,
	david@kernel.org,
	vannapurve@google.com,
	sagis@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	nik.borisov@suse.com,
	pgonda@google.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	francescolavra.fl@gmail.com,
	jgross@suse.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	chao.gao@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for splitting
Date: Tue,  6 Jan 2026 18:23:31 +0800
Message-ID: <20260106102331.25244-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce per-VM external cache for splitting the external page table by
adding KVM x86 ops for cache "topup", "free", "need topup" operations.

Invoke the KVM x86 ops for "topup", "need topup" for the per-VM external
split cache when splitting the mirror root in
tdp_mmu_split_huge_pages_root() where there's no per-vCPU context.

Invoke the KVM x86 op for "free" to destroy the per-VM external split cache
when KVM frees memory caches.

This per-VM external split cache is only used when per-vCPU context is not
available. Use the per-vCPU external fault cache in the fault path
when per-vCPU context is available.

The per-VM external split cache is protected under both kvm->mmu_lock and a
cache lock inside vendor implementations to ensure that there're enough
pages in cache for one split:

- Dequeuing of the per-VM external split cache is in
  kvm_x86_ops.split_external_spte() under mmu_lock.

- Yield the traversal in tdp_mmu_split_huge_pages_root() after topup of
  the per-VM cache, so that need_topup() is checked again after
  re-acquiring the mmu_lock.

- Vendor implementations of the per-VM external split cache provide a
  cache lock to protect the enqueue/dequeue of pages into/from the cache.

Here's the sequence to show how enough pages in cache is guaranteed.

a. with write mmu_lock:

   1. write_lock(&kvm->mmu_lock)
      kvm_x86_ops.need_topup()

   2. write_unlock(&kvm->mmu_lock)
      kvm_x86_ops.topup() --> in vendor:
      {
        allocate pages
        get cache lock
        enqueue pages in cache
        put cache lock
      }

   3. write_lock(&kvm->mmu_lock)
      kvm_x86_ops.need_topup() (goto 2 if topup is necessary)  (*)

      kvm_x86_ops.split_external_spte() --> in vendor:
      {
         get cache lock
         dequeue pages in cache
         put cache lock
      }
      write_unlock(&kvm->mmu_lock)

b. with read mmu_lock,

   1. read_lock(&kvm->mmu_lock)
      kvm_x86_ops.need_topup()

   2. read_unlock(&kvm->mmu_lock)
      kvm_x86_ops.topup() --> in vendor:
      {
        allocate pages
        get cache lock
        enqueue pages in cache
        put cache lock
      }

   3. read_lock(&kvm->mmu_lock)
      kvm_x86_ops.need_topup() (goto 2 if topup is necessary)

      kvm_x86_ops.split_external_spte() --> in vendor:
      {
         get cache lock
         kvm_x86_ops.need_topup() (return retry if topup is necessary) (**)
         dequeue pages in cache
         put cache lock
      }

      read_unlock(&kvm->mmu_lock)

Due to (*) and (**) in step 3, enough pages for split is guaranteed.

Co-developed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Introduce x86 ops to manages the cache.
---
 arch/x86/include/asm/kvm-x86-ops.h |  3 ++
 arch/x86/include/asm/kvm_host.h    | 17 +++++++
 arch/x86/kvm/mmu/mmu.c             |  2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 71 +++++++++++++++++++++++++++++-
 4 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 84fa8689b45c..307edc51ad8d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -102,6 +102,9 @@ KVM_X86_OP_OPTIONAL(split_external_spte)
 KVM_X86_OP_OPTIONAL(alloc_external_fault_cache)
 KVM_X86_OP_OPTIONAL(topup_external_fault_cache)
 KVM_X86_OP_OPTIONAL(free_external_fault_cache)
+KVM_X86_OP_OPTIONAL(topup_external_per_vm_split_cache)
+KVM_X86_OP_OPTIONAL(free_external_per_vm_split_cache)
+KVM_X86_OP_OPTIONAL(need_topup_external_per_vm_split_cache)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 315ffb23e9d8..6122801f334b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1862,6 +1862,23 @@ struct kvm_x86_ops {
 	/* Free in external page fault cache. */
 	void (*free_external_fault_cache)(struct kvm_vcpu *vcpu);
 
+	/*
+	 * Top up extra pages needed in the per-VM cache for splitting external
+	 * page table.
+	 */
+	int (*topup_external_per_vm_split_cache)(struct kvm *kvm,
+						 enum pg_level level);
+
+	/* Free the per-VM cache for splitting external page table. */
+	void (*free_external_per_vm_split_cache)(struct kvm *kvm);
+
+	/*
+	 * Check if it's necessary to top up the per-VM cache for splitting
+	 * external page table.
+	 */
+	bool (*need_topup_external_per_vm_split_cache)(struct kvm *kvm,
+						       enum pg_level level);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 35a6e37bfc68..3d568512201d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6924,6 +6924,8 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
 	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
+	if (kvm_has_mirrored_tdp(kvm))
+		kvm_x86_call(free_external_per_vm_split_cache)(kvm);
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b984027343b7..b45d3da683f2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1606,6 +1606,55 @@ static bool iter_cross_boundary(struct tdp_iter *iter, gfn_t start, gfn_t end)
 		 (iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) <= end);
 }
 
+/*
+ * Check the per-VM external split cache under write mmu_lock or read mmu_lock
+ * in tdp_mmu_split_huge_pages_root().
+ *
+ * When need_topup_external_split_cache() returns false, the mmu_lock is held
+ * throughout the exectution from
+ * (a) need_topup_external_split_cache(), and
+ * (b) the cache dequeuing (in tdx_sept_split_private_spte() called by
+ *     tdp_mmu_split_huge_page()).
+ *
+ * - When mmu_lock is held for write, the per-VM external split cache is
+ *   exclusively accessed by a single user. Therefore, the result returned from
+ *   need_topup_external_split_cache() is accurate.
+ *
+ * - When mmu_lock is held for read, the per-VM external split cache can be
+ *   shared among multiple users. Cache dequeuing in
+ *   tdx_sept_split_private_spte() thus needs to check again of the cache page
+ *   count after acquiring its internal split cache lock and return an error for
+ *   retry if the cache page count is not sufficient.
+ */
+static bool need_topup_external_split_cache(struct kvm *kvm, int level)
+{
+	return kvm_x86_call(need_topup_external_per_vm_split_cache)(kvm, level);
+}
+
+static int topup_external_split_cache(struct kvm *kvm, int level, bool shared)
+{
+	int r;
+
+	rcu_read_unlock();
+
+	if (shared)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
+
+	r = kvm_x86_call(topup_external_per_vm_split_cache)(kvm, level);
+
+	if (shared)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
+
+	if (!r)
+		rcu_read_lock();
+
+	return r;
+}
+
 static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 					 struct kvm_mmu_page *root,
 					 gfn_t start, gfn_t end,
@@ -1614,6 +1663,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct tdp_iter iter;
+	int r = 0;
 
 	rcu_read_lock();
 
@@ -1672,6 +1722,21 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			continue;
 		}
 
+		if (is_mirror_sp(root) &&
+		    need_topup_external_split_cache(kvm, iter.level)) {
+			r = topup_external_split_cache(kvm, iter.level, shared);
+
+			if (r) {
+				trace_kvm_mmu_split_huge_page(iter.gfn,
+							      iter.old_spte,
+							      iter.level, r);
+				goto out;
+			}
+
+			iter.yielded = true;
+			continue;
+		}
+
 		tdp_mmu_init_child_sp(sp, &iter);
 
 		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
@@ -1682,15 +1747,17 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 
 	rcu_read_unlock();
 
+out:
 	/*
 	 * It's possible to exit the loop having never used the last sp if, for
 	 * example, a vCPU doing HugePage NX splitting wins the race and
-	 * installs its own sp in place of the last sp we tried to split.
+	 * installs its own sp in place of the last sp we tried to split or
+	 * topup_external_split_cache() failure.
 	 */
 	if (sp)
 		tdp_mmu_free_sp(sp);
 
-	return 0;
+	return r;
 }
 
 
-- 
2.43.2


