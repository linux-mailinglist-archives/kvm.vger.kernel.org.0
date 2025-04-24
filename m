Return-Path: <kvm+bounces-44047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FED7A99F62
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B02F3B06E9
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482171AAE2E;
	Thu, 24 Apr 2025 03:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z4OycyqF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB591A7AF7;
	Thu, 24 Apr 2025 03:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464224; cv=none; b=pTCjFQqofw1mMByT67ybiFzxnUjROxhSrVq2+XkgBG95g55IsJO/f2u61xPubnxSOp5Te/unQVs77ZHcQ8mERBki2GaBXXxKoq9u6iszCea6BJmc+dYnoOPULXLj4e+ukyxFVAIYfKXKuJJ9ppIHZNYNP7sTrhUw3TjZuPwmDcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464224; c=relaxed/simple;
	bh=qk/fSOpi4sXPyeZrVbdyvuUmugkNkiPMIYQeoVSNvEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smSHiSqHWaibNHK7zqRcAbXI78wkjKsdKIvNVYmnLPc0Qd5DzgcMgYl7zWOhSy38Wvv+SgL8dQJIb5wJLBm/0hmPIrKL2AQOKu+T5He4oZ7MRD5Lsw3/QWiufvLkY5TwniT6MeNjXprqRCi6tCTf7ARKlgpudzkyzv2iNK7XGt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z4OycyqF; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464222; x=1777000222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qk/fSOpi4sXPyeZrVbdyvuUmugkNkiPMIYQeoVSNvEA=;
  b=Z4OycyqF4fFh81z7WJava12qFusHDQ8RWVHmmIxa1Ag3DA/N8MvhWUBs
   hjtZWzYVwuFtFCLJ6GInnPUifQZ/QDDz5ky1XOYfHT29S+nWCYnY1FUea
   /MsCE1BGJHvXul4QDCcwghk0CubNLf63KT3g3rrQeAqsbAAkox8NX6DcL
   yD3wUwIk8Kz5aGC5JazT/N8YBFR9OXM0zZJp75NBn28oCZxSuqLIy/LN4
   GY7gsAo3pEZCqQIFR9a0VoKPsusSpZ4ENFtCE0H0kvgoGscPFr71k8NIk
   7yF8/Nrj9CpGVByZJDnPw5i+3TuxdECQMGVVx80s1kR56jC+f9MXQOetw
   Q==;
X-CSE-ConnectionGUID: xNu1PJPHR0OgnUdGZ3mTOQ==
X-CSE-MsgGUID: 4JBe1ssmTWqINqTe/4+oFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47094595"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47094595"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:22 -0700
X-CSE-ConnectionGUID: ItOqydL4QkmjprsHQDQUIw==
X-CSE-MsgGUID: KcNI2OtbSvm7nkKajY5ROw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132332131"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:16 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 17/21] KVM: Change the return type of gfn_handler_t() from bool to int
Date: Thu, 24 Apr 2025 11:08:29 +0800
Message-ID: <20250424030829.486-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify the return type of gfn_handler_t() from bool to int. A negative
return value indicates failure, while a return value of 1 signifies success
with a flush required, and 0 denotes success without a flush required.

This adjustment prepares for a future change that will enable
kvm_pre_set_memory_attributes() to fail.

No functional changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/arm64/kvm/mmu.c             |  4 ++--
 arch/loongarch/kvm/mmu.c         |  4 ++--
 arch/mips/kvm/mmu.c              |  4 ++--
 arch/powerpc/kvm/book3s.c        |  4 ++--
 arch/powerpc/kvm/e500_mmu_host.c |  4 ++--
 arch/riscv/kvm/mmu.c             |  4 ++--
 arch/x86/kvm/mmu/mmu.c           | 12 ++++++------
 include/linux/kvm_host.h         | 12 ++++++------
 virt/kvm/kvm_main.c              | 25 ++++++++++++++++---------
 9 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 754f2fe0cc67..4bd8f61e9319 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1973,7 +1973,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
@@ -1989,7 +1989,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 */
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 4d203294767c..5e97fee941b9 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -511,7 +511,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 			range->end << PAGE_SHIFT, &ctx);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_ptw_ctx ctx;
 
@@ -523,7 +523,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 				range->end << PAGE_SHIFT, &ctx);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	gpa_t gpa = range->start << PAGE_SHIFT;
 	kvm_pte_t *ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index d2c3b6b41f18..2df3a53e23e9 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -444,12 +444,12 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return true;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	return kvm_mips_mkold_gpa_pt(kvm, range->start, range->end);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	gpa_t gpa = range->start << PAGE_SHIFT;
 	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d79c5d1098c0..9bf6e1cf64f1 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -886,12 +886,12 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm->arch.kvm_ops->unmap_gfn_range(kvm, range);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	return kvm->arch.kvm_ops->age_gfn(kvm, range);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	return kvm->arch.kvm_ops->test_age_gfn(kvm, range);
 }
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 06caf8bbbe2b..debe1ecb4bfd 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -697,13 +697,13 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_e500_mmu_unmap_gfn(kvm, range);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
 	return false;
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
 	return false;
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1087ea74567b..581bd1bc6675 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -550,7 +550,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	pte_t *ptep;
 	u32 ptep_level = 0;
@@ -568,7 +568,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return ptep_test_and_clear_young(NULL, 0, ptep);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	pte_t *ptep;
 	u32 ptep_level = 0;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0d49c69b6b55..ba993445a00e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1778,7 +1778,7 @@ static bool kvm_may_have_shadow_mmu_sptes(struct kvm *kvm)
 	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
@@ -1791,7 +1791,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return young;
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
@@ -7691,8 +7691,8 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range)
+int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+				       struct kvm_gfn_range *range)
 {
 	/*
 	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
@@ -7752,8 +7752,8 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return true;
 }
 
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range)
+int kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range)
 {
 	unsigned long attrs = range->arg.attributes;
 	struct kvm_memory_slot *slot = range->slot;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 19d7a577e7ed..ec47f2374fdf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -270,8 +270,8 @@ struct kvm_gfn_range {
 	bool lockless;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 int kvm_split_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range);
 #endif
 
@@ -1526,7 +1526,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_invalidate_begin(struct kvm *kvm);
 void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_mmu_invalidate_end(struct kvm *kvm);
-bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
@@ -2504,10 +2504,10 @@ static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn
 
 bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+				       struct kvm_gfn_range *range);
+int kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range);
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5ea1c442e339..72bd98c100cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -511,7 +511,7 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
-typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
+typedef int (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm);
 
@@ -595,6 +595,7 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 		kvm_for_each_memslot_in_hva_range(node, slots,
 						  range->start, range->end - 1) {
 			unsigned long hva_start, hva_end;
+			int ret;
 
 			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
 			hva_start = max_t(unsigned long, range->start, slot->userspace_addr);
@@ -635,7 +636,9 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 						goto mmu_unlock;
 				}
 			}
-			r.ret |= range->handler(kvm, &gfn_range);
+			ret = range->handler(kvm, &gfn_range);
+			WARN_ON_ONCE(ret < 0);
+			r.ret |= ret;
 		}
 	}
 
@@ -721,7 +724,7 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
 	}
 }
 
-bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
 	return kvm_unmap_gfn_range(kvm, range);
@@ -2413,7 +2416,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	struct kvm_memslot_iter iter;
 	bool found_memslot = false;
-	bool ret = false;
+	bool flush = false;
+	int ret = 0;
 	int i;
 
 	gfn_range.arg = range->arg;
@@ -2446,19 +2450,22 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 					range->on_lock(kvm);
 			}
 
-			ret |= range->handler(kvm, &gfn_range);
+			ret = range->handler(kvm, &gfn_range);
+			if (ret < 0)
+				goto err;
+			flush |= ret;
 		}
 	}
-
-	if (range->flush_on_ret && ret)
+err:
+	if (range->flush_on_ret && flush)
 		kvm_flush_remote_tlbs(kvm);
 
 	if (found_memslot)
 		KVM_MMU_UNLOCK(kvm);
 }
 
-static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
-					  struct kvm_gfn_range *range)
+static int kvm_pre_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range)
 {
 	/*
 	 * Unconditionally add the range to the invalidation set, regardless of
-- 
2.43.2


