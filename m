Return-Path: <kvm+bounces-54240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B905B1D51C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C63091637CE
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD9A21FF26;
	Thu,  7 Aug 2025 09:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lIlaRkBl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC2426B2DA;
	Thu,  7 Aug 2025 09:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559915; cv=none; b=fVwDk+yg7CoREYBP3bnBiUxrTsY3ZyD19YmYpvRsjyA5lQHJA1M8veU/1VwcM6VD5qipyhjUO4o/EuL+NrOEDLqIXIZTeSC0PuDQZ2kHDa3wBRp2xMf2VoEfrU2l7n8+U/tQGucV/6bVirev/jaiNotWh1OYv7UCyE6KmnDH4EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559915; c=relaxed/simple;
	bh=6c78WcExugBwVS/0wPZFtewC2MOsLhATUWEp6SqfWHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pz3JhOrWNPZ9MNTzrlZUYFtlfRI7DJEsnQyEcBQeUtCgSwOm1X3MEQMYj3YcoDgEu0jQsBQdhFTJu38VeCS9tV/9cWZbowc2XQR7zK35XptgEDuwcLtS7tHXa5+KWv80tHNYP9f7+emLUucM1weAf55/YMJ7yC2/MaIpSs1aphs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lIlaRkBl; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559914; x=1786095914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6c78WcExugBwVS/0wPZFtewC2MOsLhATUWEp6SqfWHU=;
  b=lIlaRkBlU7q3avvh5qLUa1+BBr99u3BIHUbiL+3B6PfAVBD2i2J+bxpa
   TH+L1AA9MBaKy0EMmJwVSp+OmkI1MvEEdnjmpZsFZQBu4j3BolYPsfMn6
   fQtHvXakSlbN2YhF4mD7fTH/nDXGfA6FQ4h3X07Gjse9MF5oiqKyC4j/0
   ALG9YXgmMFvEA2W0E7cnLWOtRxDISufYaHdSMRANulde3awUFB/LxIben
   b1tC5JgzZnAH4Vj81qmq8o6/Uxm++ad76gnAvyMFcG/yQCY7qFeLFKQz4
   zCXqVL52RX1M5fgu8raX/J402wcKTB4f/jN04VV+BoI4n+sVJh8y9dg5a
   A==;
X-CSE-ConnectionGUID: vJ4+dIOJRFORzeMqlEDwYg==
X-CSE-MsgGUID: UYbOQrvXQimTlrcCrT2EPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56760266"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56760266"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:45:13 -0700
X-CSE-ConnectionGUID: o5b8FlbpQ/20wP840HARzg==
X-CSE-MsgGUID: es9bcseBQwyg6+kSwhNq5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165382174"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:45:07 -0700
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
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
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
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 15/23] KVM: Change the return type of gfn_handler_t() from bool to int
Date: Thu,  7 Aug 2025 17:44:36 +0800
Message-ID: <20250807094436.4659-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
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

This adjustment prepares for a later change that will enable
kvm_pre_set_memory_attributes() to fail.

No functional changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- No change

RFC v1:
- New patch.
---
 arch/arm64/kvm/mmu.c             |  8 ++++----
 arch/loongarch/kvm/mmu.c         |  8 ++++----
 arch/mips/kvm/mmu.c              |  6 +++---
 arch/powerpc/kvm/book3s.c        |  4 ++--
 arch/powerpc/kvm/e500_mmu_host.c |  8 ++++----
 arch/riscv/kvm/mmu.c             | 12 ++++++------
 arch/x86/kvm/mmu/mmu.c           | 20 ++++++++++----------
 include/linux/kvm_host.h         | 12 ++++++------
 virt/kvm/kvm_main.c              | 24 ++++++++++++++++--------
 9 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8b225450a4eb..991a6df0ca21 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1999,12 +1999,12 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
 	if (!kvm->arch.mmu.pgt)
-		return false;
+		return 0;
 
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
@@ -2015,12 +2015,12 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 */
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
 	if (!kvm->arch.mmu.pgt)
-		return false;
+		return 0;
 
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index ed956c5cf2cc..0542516c98eb 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -511,7 +511,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 			range->end << PAGE_SHIFT, &ctx);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_ptw_ctx ctx;
 
@@ -523,15 +523,15 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 				range->end << PAGE_SHIFT, &ctx);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	gpa_t gpa = range->start << PAGE_SHIFT;
 	kvm_pte_t *ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
 
 	if (ptep && kvm_pte_present(NULL, ptep) && kvm_pte_young(*ptep))
-		return true;
+		return 1;
 
-	return false;
+	return 0;
 }
 
 /*
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index d2c3b6b41f18..c26cc89c8e98 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -444,18 +444,18 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
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
 
 	if (!gpa_pte)
-		return false;
+		return 0;
 	return pte_young(*gpa_pte);
 }
 
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
index 06caf8bbbe2b..dd5411ee242e 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -697,16 +697,16 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_e500_mmu_unmap_gfn(kvm, range);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
-	return false;
+	return 0;
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
-	return false;
+	return 0;
 }
 
 /*****************************************/
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1087ea74567b..98c2fcd9229f 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -550,38 +550,38 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	pte_t *ptep;
 	u32 ptep_level = 0;
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
 	if (!kvm->arch.pgd)
-		return false;
+		return 0;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
 	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
-		return false;
+		return 0;
 
 	return ptep_test_and_clear_young(NULL, 0, ptep);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	pte_t *ptep;
 	u32 ptep_level = 0;
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
 	if (!kvm->arch.pgd)
-		return false;
+		return 0;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
 	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
-		return false;
+		return 0;
 
 	return pte_young(ptep_get(ptep));
 }
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1c639286aac2..c71f8bb0b903 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1806,7 +1806,7 @@ static bool kvm_may_have_shadow_mmu_sptes(struct kvm *kvm)
 	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
@@ -1819,7 +1819,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return young;
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
@@ -7841,8 +7841,8 @@ static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
 }
 
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range)
+int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+				       struct kvm_gfn_range *range)
 {
 	struct kvm_memory_slot *slot = range->slot;
 	int level;
@@ -7859,10 +7859,10 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	 * a hugepage can be used for affected ranges.
 	 */
 	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
-		return false;
+		return 0;
 
 	if (WARN_ON_ONCE(range->end <= range->start))
-		return false;
+		return 0;
 
 	/*
 	 * If the head and tail pages of the range currently allow a hugepage,
@@ -7921,8 +7921,8 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return true;
 }
 
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range)
+int kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range)
 {
 	unsigned long attrs = range->arg.attributes;
 	struct kvm_memory_slot *slot = range->slot;
@@ -7938,7 +7938,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	 * SHARED may now allow hugepages.
 	 */
 	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
-		return false;
+		return 0;
 
 	/*
 	 * The sequence matters here: upper levels consume the result of lower
@@ -7985,7 +7985,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 				hugepage_set_mixed(slot, gfn, level);
 		}
 	}
-	return false;
+	return 0;
 }
 
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6137b76341e1..d03e4a70a6db 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -271,8 +271,8 @@ struct kvm_gfn_range {
 	bool lockless;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
 				   bool shared);
 #endif
@@ -1537,7 +1537,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_invalidate_begin(struct kvm *kvm);
 void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_mmu_invalidate_end(struct kvm *kvm);
-bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
@@ -2524,10 +2524,10 @@ static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn
 
 bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+				       struct kvm_gfn_range *range);
+int kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range);
 
 /*
  * Returns true if the given gfn's private/shared status (in the CoCo sense) is
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fe86f3f627ba..8f87d6c6be3f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -508,7 +508,7 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
-typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
+typedef int (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm);
 
@@ -592,6 +592,7 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 		kvm_for_each_memslot_in_hva_range(node, slots,
 						  range->start, range->end - 1) {
 			unsigned long hva_start, hva_end;
+			int ret;
 
 			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
 			hva_start = max_t(unsigned long, range->start, slot->userspace_addr);
@@ -632,7 +633,9 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 						goto mmu_unlock;
 				}
 			}
-			r.ret |= range->handler(kvm, &gfn_range);
+			ret = range->handler(kvm, &gfn_range);
+			WARN_ON_ONCE(ret < 0);
+			r.ret |= ret;
 		}
 	}
 
@@ -718,7 +721,7 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
 	}
 }
 
-bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
 	return kvm_unmap_gfn_range(kvm, range);
@@ -2469,7 +2472,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	struct kvm_memslot_iter iter;
 	bool found_memslot = false;
-	bool ret = false;
+	bool flush = false;
+	int ret = 0;
 	int i;
 
 	gfn_range.arg = range->arg;
@@ -2502,19 +2506,23 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 					range->on_lock(kvm);
 			}
 
-			ret |= range->handler(kvm, &gfn_range);
+			ret = range->handler(kvm, &gfn_range);
+			if (ret < 0)
+				goto err;
+			flush |= ret;
 		}
 	}
 
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


