Return-Path: <kvm+bounces-977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 754C27E42B1
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 974DD1C20F85
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823A4374C4;
	Tue,  7 Nov 2023 15:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rj3Clj01"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E322A3589E
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:04:53 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C91658A;
	Tue,  7 Nov 2023 07:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369324; x=1730905324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JDnzHoeAz9cXEruHJnpAEIxBR3VtDux3aJfiykJUT1I=;
  b=Rj3Clj01fY5v0bOMz5l43fgzfJU4XJuwPTnyeh52z7NSWf7T7FpCxnBd
   uy13WgICRBEOvh3y8JJwXR7WCIbu6wJ4gj6hEocnvAiKktiND0fMG2LVq
   /CDWBYHjbI7JzFz6DwKqksyUlriFFL+E6CjJ4IcRaaCRsre5BFGf7B+VN
   T7Wfuc3TuVsEuQYZKDAx6xFgw3kWaGgHdulHmAgoOnswSzwAUNEmt4STV
   ZaFQsuh2TMNEhdIgrIjnhE3jhWOT6M0yHWL9Zmk2SHGrrDmAgC/GUy2Le
   IXbIyWqxwQXwAcw13b8bcVpYhoyQEFHYf+3iOYTnhdBgE67IbAY1eI3yF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397634"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397634"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:01:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446882"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:01:04 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v6 15/16] KVM: x86/mmu: Make kvm fault handler aware of large page of private memslot
Date: Tue,  7 Nov 2023 07:00:42 -0800
Message-Id: <075de567893a2b09bdfb203ae7ecd1867e5c3d8e.1699368363.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

struct kvm_page_fault.req_level is the page level which takes care of the
faulted-in page size.  For now its calculation is only for the conventional
kvm memslot by host_pfn_mapping_level() that traverses page table.

However, host_pfn_mapping_level() cannot be used for private kvm memslot
because pages of private kvm memlost aren't mapped into user virtual
address space.  Instead page order is given when getting pfn.  Remember it
in struct kvm_page_fault and use it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 34 +++++++++++++++++----------------
 arch/x86/kvm/mmu/mmu_internal.h | 12 +++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0bf043812644..0aec7c11f4e2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3158,10 +3158,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 
 static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+				       gfn_t gfn, int max_level, int host_level,
+				       bool is_private)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3170,24 +3170,23 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
-	if (is_private)
-		return max_level;
-
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
+	if (!is_private) {
+		WARN_ON_ONCE(host_level != PG_LEVEL_NONE);
+		host_level = host_pfn_mapping_level(kvm, gfn, slot);
+	}
+	WARN_ON_ONCE(host_level == PG_LEVEL_NONE);
 	return min(host_level, max_level);
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      int max_level)
+			      int max_level, bool faultin_private)
 {
-	bool is_private = kvm_slot_can_be_private(slot) &&
-			  kvm_mem_is_private(kvm, gfn);
-
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level, is_private);
+	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level,
+					   PG_LEVEL_NONE, faultin_private);
 }
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -3212,7 +3211,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
 						       fault->gfn, fault->max_level,
-						       fault->is_private);
+						       fault->host_level,
+						       kvm_is_faultin_private(fault));
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4336,6 +4336,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
 	int max_order, r;
+	u8 max_level;
 
 	if (!kvm_slot_can_be_private(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
@@ -4349,8 +4350,9 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 		return r;
 	}
 
-	fault->max_level = min(kvm_max_level_for_order(max_order),
-			       fault->max_level);
+	max_level = kvm_max_level_for_order(max_order);
+	fault->host_level = max_level;
+	fault->max_level = min(max_level, fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 
 	return RET_PF_CONTINUE;
@@ -4400,7 +4402,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return -EFAULT;
 	}
 
-	if (fault->is_private)
+	if (kvm_is_faultin_private(fault))
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
@@ -6809,7 +6811,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 */
 		if (sp->role.direct &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
-							       PG_LEVEL_NUM)) {
+							       PG_LEVEL_NUM, false)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_remote_tlbs_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 653e96769956..6b540a10fd67 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -357,6 +357,9 @@ struct kvm_page_fault {
 	 * is changing its own translation in the guest page tables.
 	 */
 	bool write_fault_to_shadow_pgtable;
+
+	/* valid only for private memslot && private gfn */
+	enum pg_level host_level;
 };
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
@@ -451,7 +454,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      int max_level);
+			      int max_level, bool faultin_private);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
@@ -469,4 +472,11 @@ static inline bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t g
 }
 #endif
 
+static inline bool kvm_is_faultin_private(const struct kvm_page_fault *fault)
+{
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM))
+		return fault->is_private && kvm_slot_can_be_private(fault->slot);
+	return false;
+}
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c8a4bd052c71..173e4e9053fc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2179,7 +2179,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
-							      iter.gfn, PG_LEVEL_NUM);
+							      iter.gfn, PG_LEVEL_NUM, false);
 		if (max_mapping_level < iter.level)
 			continue;
 
-- 
2.25.1


