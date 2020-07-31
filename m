Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE23234CE3
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgGaVXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:23:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:50224 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgGaVX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:29 -0400
IronPort-SDR: t9we91MTc4fYZIVkp+B0V0VSVMJQxIvjXH1WOizERGiEnKnoOOue9IPQBe00JTmm4ENEXkFJ3q
 CI0TMCZU1lig==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075130"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075130"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:27 -0700
IronPort-SDR: 2YkxLunpQZauh/yQCbzPCFkS86bbTRCTTyschYDC27EpCAGA9l89xiiKJtIXrTZP5KiiRqwwqk
 ET8nkNbeMUdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191305"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 14:23:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 4/8] KVM: x86/mmu: Add infrastructure for pinning PFNs on demand
Date:   Fri, 31 Jul 2020 14:23:19 -0700
Message-Id: <20200731212323.21746-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   7 ++
 arch/x86/kvm/mmu/mmu.c          | 111 ++++++++++++++++++++++++++------
 2 files changed, 99 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1bab87a444d78..b14864f3e8e74 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1138,6 +1138,13 @@ struct kvm_x86_ops {
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
+	bool (*pin_spte)(struct kvm_vcpu *vcpu, gfn_t gfn, int level,
+			 kvm_pfn_t pfn);
+	void (*drop_pinned_spte)(struct kvm *kvm, gfn_t gfn, int level,
+				 kvm_pfn_t pfn);
+	void (*zap_pinned_spte)(struct kvm *kvm, gfn_t gfn, int level);
+	void (*unzap_pinned_spte)(struct kvm *kvm, gfn_t gfn, int level);
+
 	bool (*has_wbinvd_exit)(void);
 
 	/* Returns actual tsc_offset set in active VMCS */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 182f398036248..cab3b2f2f49c3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -133,6 +133,9 @@ module_param(dbg, bool, 0644);
 #define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
 #define SPTE_MMIO_MASK (3ULL << 52)
 
+/* Special SPTEs flags that can only be used for non-MMIO SPTEs. */
+#define SPTE_PINNED_MASK	BIT_ULL(62)
+
 #define PT64_LEVEL_BITS 9
 
 #define PT64_LEVEL_SHIFT(level) \
@@ -211,6 +214,7 @@ enum {
 	RET_PF_EMULATE = 1,
 	RET_PF_INVALID = 2,
 	RET_PF_FIXED = 3,
+	RET_PF_UNZAPPED = 4,
 };
 
 struct pte_list_desc {
@@ -635,6 +639,11 @@ static bool is_shadow_present_pte(u64 pte)
 	return __is_shadow_present_pte(pte) && !is_mmio_spte(pte);
 }
 
+static bool is_pinned_pte(u64 pte)
+{
+	return !!(pte & SPTE_PINNED_MASK);
+}
+
 static int is_large_pte(u64 pte)
 {
 	return pte & PT_PAGE_SIZE_MASK;
@@ -937,15 +946,15 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * state bits, it is used to clear the last level sptep.
  * Returns the old PTE.
  */
-static u64 mmu_spte_clear_track_bits(u64 *sptep)
+static u64 __mmu_spte_clear_track_bits(u64 *sptep, u64 clear_value)
 {
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
 
 	if (!spte_has_volatile_bits(old_spte))
-		__update_clear_spte_fast(sptep, 0ull);
+		__update_clear_spte_fast(sptep, clear_value);
 	else
-		old_spte = __update_clear_spte_slow(sptep, 0ull);
+		old_spte = __update_clear_spte_slow(sptep, clear_value);
 
 	if (!is_shadow_present_pte(old_spte))
 		return old_spte;
@@ -968,6 +977,11 @@ static u64 mmu_spte_clear_track_bits(u64 *sptep)
 	return old_spte;
 }
 
+static inline u64 mmu_spte_clear_track_bits(u64 *sptep)
+{
+	return __mmu_spte_clear_track_bits(sptep, 0ull);
+}
+
 /*
  * Rules for using mmu_spte_clear_no_track:
  * Directly clear spte without caring the state bits of sptep,
@@ -1399,7 +1413,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	return pte_list_add(vcpu, spte, rmap_head);
 }
 
-static void rmap_remove(struct kvm *kvm, u64 *spte)
+static void rmap_remove(struct kvm *kvm, u64 *spte, u64 old_spte)
 {
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
@@ -1409,6 +1423,10 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 	rmap_head = gfn_to_rmap(kvm, gfn, sp);
 	__pte_list_remove(spte, rmap_head);
+
+	if (is_pinned_pte(old_spte))
+		kvm_x86_ops.drop_pinned_spte(kvm, gfn, sp->role.level - 1,
+					     spte_to_pfn(old_spte));
 }
 
 /*
@@ -1446,7 +1464,7 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 	iter->pos = 0;
 	sptep = iter->desc->sptes[iter->pos];
 out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
+	BUG_ON(!is_shadow_present_pte(*sptep) && !is_pinned_pte(*sptep));
 	return sptep;
 }
 
@@ -1491,8 +1509,8 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	u64 old_spte = mmu_spte_clear_track_bits(sptep);
 
-	if (is_shadow_present_pte(old_spte))
-		rmap_remove(kvm, sptep);
+	if (is_shadow_present_pte(old_spte) || is_pinned_pte(old_spte))
+		rmap_remove(kvm, sptep, old_spte);
 }
 
 
@@ -1730,17 +1748,49 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn);
 }
 
+static bool kvm_mmu_zap_pinned_spte(struct kvm *kvm, u64 *sptep)
+{
+	struct kvm_mmu_page *sp;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	if (!(*sptep & SPTE_PINNED_MASK))
+		return false;
+
+	sp = sptep_to_sp(sptep);
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+	pfn = spte_to_pfn(*sptep);
+
+	if (kvm_x86_ops.zap_pinned_spte)
+		kvm_x86_ops.zap_pinned_spte(kvm, gfn, sp->role.level - 1);
+
+	__mmu_spte_clear_track_bits(sptep, SPTE_PINNED_MASK | pfn << PAGE_SHIFT);
+	return true;
+}
+
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
 	bool flush = false;
 
-	while ((sptep = rmap_get_first(rmap_head, &iter))) {
+restart:
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		rmap_printk("%s: spte %p %llx.\n", __func__, sptep, *sptep);
 
+		if (!is_shadow_present_pte(*sptep)) {
+			WARN_ON_ONCE(!is_pinned_pte(*sptep));
+			continue;
+		}
+
+		flush = true;
+
+		/* Keep the rmap if the SPTE is pinned. */
+		if (kvm_mmu_zap_pinned_spte(kvm, sptep))
+			continue;
+
 		pte_list_remove(rmap_head, sptep);
-		flush = true;
+		goto restart;
 	}
 
 	return flush;
@@ -1774,6 +1824,10 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 		need_flush = 1;
 
+		/* Pinned pages should not be relocated (obviously). */
+		if (WARN_ON_ONCE(is_pinned_pte(*sptep)))
+			continue;
+
 		if (pte_write(*ptep)) {
 			pte_list_remove(rmap_head, sptep);
 			goto restart;
@@ -2630,7 +2684,7 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	struct kvm_mmu_page *child;
 
 	pte = *spte;
-	if (is_shadow_present_pte(pte)) {
+	if (is_shadow_present_pte(pte) || is_pinned_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 			if (is_large_pte(pte))
@@ -2639,7 +2693,7 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 		}
-		return true;
+		return is_shadow_present_pte(pte);
 	}
 
 	if (is_mmio_spte(pte))
@@ -2987,10 +3041,13 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	u64 spte = 0;
 	int ret = 0;
 	struct kvm_mmu_page *sp;
+	bool is_mmio_pfn;
 
 	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
 		return 0;
 
+	is_mmio_pfn = kvm_is_mmio_pfn(pfn);
+
 	sp = sptep_to_sp(sptep);
 	if (sp_ad_disabled(sp))
 		spte |= SPTE_AD_DISABLED_MASK;
@@ -3023,15 +3080,14 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
-		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
-			kvm_is_mmio_pfn(pfn));
+		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn, is_mmio_pfn);
 
 	if (host_writable)
 		spte |= SPTE_HOST_WRITEABLE;
 	else
 		pte_access &= ~ACC_WRITE_MASK;
 
-	if (!kvm_is_mmio_pfn(pfn))
+	if (!is_mmio_pfn)
 		spte |= shadow_me_mask;
 
 	spte |= (u64)pfn << PAGE_SHIFT;
@@ -3065,6 +3121,12 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (speculative)
 		spte = mark_spte_for_access_track(spte);
 
+	if (is_pinned_pte(*sptep) ||
+	    (vcpu->arch.mmu->direct_map && !is_mmio_pfn &&
+	     kvm_x86_ops.pin_spte &&
+	     kvm_x86_ops.pin_spte(vcpu, gfn, level, pfn)))
+		spte |= SPTE_PINNED_MASK;
+
 set_pte:
 	if (mmu_spte_update(sptep, spte))
 		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
@@ -3081,29 +3143,33 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	int set_spte_ret;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
+	u64 pte = *sptep;
 
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
 
-	if (is_shadow_present_pte(*sptep)) {
+	if (is_shadow_present_pte(pte)) {
 		/*
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (level > PG_LEVEL_4K && !is_large_pte(*sptep)) {
+		if (level > PG_LEVEL_4K && !is_large_pte(pte)) {
 			struct kvm_mmu_page *child;
-			u64 pte = *sptep;
 
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, sptep);
 			flush = true;
-		} else if (pfn != spte_to_pfn(*sptep)) {
+		} else if (pfn != spte_to_pfn(pte)) {
 			pgprintk("hfn old %llx new %llx\n",
-				 spte_to_pfn(*sptep), pfn);
+				 spte_to_pfn(pte), pfn);
 			drop_spte(vcpu->kvm, sptep);
 			flush = true;
 		} else
 			was_rmapped = 1;
+	} else if (is_pinned_pte(pte)) {
+		WARN_ON_ONCE(pfn != spte_to_pfn(pte));
+		ret = RET_PF_UNZAPPED;
+		was_rmapped = 1;
 	}
 
 	set_spte_ret = set_spte(vcpu, sptep, pte_access, level, gfn, pfn,
@@ -3136,6 +3202,9 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			rmap_recycle(vcpu, sptep, gfn);
 	}
 
+	if (ret == RET_PF_UNZAPPED && kvm_x86_ops.unzap_pinned_spte)
+		kvm_x86_ops.unzap_pinned_spte(vcpu->kvm, gfn, level - 1);
+
 	return ret;
 }
 
@@ -5921,6 +5990,10 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		sp = sptep_to_sp(sptep);
 		pfn = spte_to_pfn(*sptep);
 
+		/* Pinned page dirty logging is not supported. */
+		if (WARN_ON_ONCE(is_pinned_pte(*sptep)))
+			continue;
+
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,
 		 * which are found on the last rmap (level = 1) when not using
-- 
2.28.0

