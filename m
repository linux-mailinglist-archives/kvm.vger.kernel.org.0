Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335B2377EF
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfFFPag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:30:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:53940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbfFFP36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:29:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:29:57 -0700
X-ExtLoop1: 1
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2019 08:29:56 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 3/9] KVM: VMX: Implement functions for SPPT paging setup
Date:   Thu,  6 Jun 2019 23:28:06 +0800
Message-Id: <20190606152812.13141-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190606152812.13141-1-weijiang.yang@intel.com>
References: <20190606152812.13141-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPPT is a 4-level paging structure similar to EPT, when SPP is
kicked for target physical page, bit 61 of the corresponding
EPT enty will be flaged, then SPPT is traversed with the gfn to
build up entries, the leaf entry of SPPT contains the access
bitmap for subpages inside the target 4KB physical page, one bit
per 128-byte subpage.

SPPT entries are set up in below cases:
1. the EPT faulted page is SPP protected.
2. SPP mis-config induced vmexit is handled.
3. User configures SPP protected pages via SPP IOCTLs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   7 +-
 arch/x86/kvm/mmu.c              | 207 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu.h              |   1 +
 include/linux/kvm_host.h        |   3 +
 4 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c79abe7ca093..98e5158287d5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -271,7 +271,8 @@ union kvm_mmu_page_role {
 		unsigned smap_andnot_wp:1;
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
-		unsigned :6;
+		unsigned spp:1;
+		unsigned reserved:5;
 
 		/*
 		 * This is left at the top of the word so that
@@ -1407,6 +1408,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u64 error_code,
 		       void *insn, int insn_len);
+
+int kvm_mmu_setup_spp_structure(struct kvm_vcpu *vcpu,
+				u32 access_map, gfn_t gfn);
+
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d9c7b45d231f..494ad2038f36 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -208,6 +208,11 @@ static const union kvm_mmu_page_role mmu_base_role_mask = {
 		({ spte = mmu_spte_get_lockless(_walker.sptep); 1; });	\
 	     __shadow_walk_next(&(_walker), spte))
 
+#define for_each_shadow_spp_entry(_vcpu, _addr, _walker)    \
+	for (shadow_spp_walk_init(&(_walker), _vcpu, _addr);	\
+	     shadow_walk_okay(&(_walker));			\
+	     shadow_walk_next(&(_walker)))
+
 static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
@@ -516,6 +521,11 @@ static int is_shadow_present_pte(u64 pte)
 	return (pte != 0) && !is_mmio_spte(pte);
 }
 
+static int is_spp_shadow_present(u64 pte)
+{
+	return pte & PT_PRESENT_MASK;
+}
+
 static int is_large_pte(u64 pte)
 {
 	return pte & PT_PAGE_SIZE_MASK;
@@ -535,6 +545,11 @@ static bool is_executable_pte(u64 spte)
 	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
 }
 
+static bool is_spp_spte(struct kvm_mmu_page *sp)
+{
+	return sp->role.spp;
+}
+
 static kvm_pfn_t spte_to_pfn(u64 pte)
 {
 	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
@@ -1703,6 +1718,87 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static bool __rmap_open_subpage_bit(struct kvm *kvm,
+				    struct kvm_rmap_head *rmap_head)
+{
+	struct rmap_iterator iter;
+	bool flush = false;
+	u64 *sptep;
+	u64 spte;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		/*
+		 * SPP works only when the page is write-protected
+		 * and SPP bit is set in EPT leaf entry.
+		 */
+		flush |= spte_write_protect(sptep, false);
+		spte = *sptep | PT_SPP_MASK;
+		flush |= mmu_spte_update(sptep, spte);
+	}
+
+	return flush;
+}
+
+static int kvm_mmu_open_subpage_write_protect(struct kvm *kvm,
+					      struct kvm_memory_slot *slot,
+					      gfn_t gfn)
+{
+	struct kvm_rmap_head *rmap_head;
+	bool flush = false;
+
+	/*
+	 * SPP is only supported with 4KB level1 memory page, check
+	 * if the page is mapped in EPT leaf entry.
+	 */
+	rmap_head = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);
+
+	if (!rmap_head->val)
+		return -EFAULT;
+
+	flush |= __rmap_open_subpage_bit(kvm, rmap_head);
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	return 0;
+}
+
+static bool __rmap_clear_subpage_bit(struct kvm *kvm,
+				     struct kvm_rmap_head *rmap_head)
+{
+	struct rmap_iterator iter;
+	bool flush = false;
+	u64 *sptep;
+	u64 spte;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		spte = (*sptep & ~PT_SPP_MASK) | PT_WRITABLE_MASK;
+		flush |= mmu_spte_update(sptep, spte);
+	}
+
+	return flush;
+}
+
+static int kvm_mmu_clear_subpage_write_protect(struct kvm *kvm,
+					       struct kvm_memory_slot *slot,
+					       gfn_t gfn)
+{
+	struct kvm_rmap_head *rmap_head;
+	bool flush = false;
+
+	rmap_head = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);
+
+	if (!rmap_head->val)
+		return -EFAULT;
+
+	flush |= __rmap_clear_subpage_bit(kvm, rmap_head);
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	return 0;
+}
+
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn)
 {
@@ -2410,6 +2506,30 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sp);
 }
 
+struct kvm_mmu_page *kvm_mmu_get_spp_page(struct kvm_vcpu *vcpu,
+						 gfn_t gfn,
+						 unsigned int level)
+
+{
+	struct kvm_mmu_page *sp;
+	union kvm_mmu_page_role role;
+
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = level;
+	role.direct = true;
+	role.spp = true;
+
+	sp = kvm_mmu_alloc_page(vcpu, true);
+	sp->gfn = gfn;
+	sp->role = role;
+	hlist_add_head(&sp->hash_link,
+		       &vcpu->kvm->arch.mmu_page_hash
+		       [kvm_page_table_hashfn(gfn)]);
+	clear_page(sp->spt);
+	return sp;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_get_spp_page);
+
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
@@ -2536,6 +2656,16 @@ static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 				    addr);
 }
 
+static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
+				 struct kvm_vcpu *vcpu, u64 addr)
+{
+	iterator->addr = addr;
+	iterator->shadow_addr = vcpu->arch.mmu->sppt_root;
+
+	/* SPP Table is a 4-level paging structure */
+	iterator->level = 4;
+}
+
 static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 {
 	if (iterator->level < PT_PAGE_TABLE_LEVEL)
@@ -2586,6 +2716,18 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 		mark_unsync(sptep);
 }
 
+static void link_spp_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
+				 struct kvm_mmu_page *sp)
+{
+	u64 spte;
+
+	spte = __pa(sp->spt) | PT_PRESENT_MASK;
+
+	mmu_spte_set(sptep, spte);
+
+	mmu_page_add_parent_pte(vcpu, sp, sptep);
+}
+
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				   unsigned direct_access)
 {
@@ -4157,6 +4299,71 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	return RET_PF_RETRY;
 }
 
+static u64 format_spp_spte(u32 spp_wp_bitmap)
+{
+	u64 new_spte = 0;
+	int i = 0;
+
+	/*
+	 * One 4K page contains 32 sub-pages, in SPP table L4E, old bits
+	 * are reserved, so we need to transfer u32 subpage write
+	 * protect bitmap to u64 SPP L4E format.
+	 */
+	while (i < 32) {
+		if (spp_wp_bitmap & (1ULL << i))
+			new_spte |= 1ULL << (i * 2);
+
+		i++;
+	}
+
+	return new_spte;
+}
+
+static void mmu_spp_spte_set(u64 *sptep, u64 new_spte)
+{
+	__set_spte(sptep, new_spte);
+}
+
+int kvm_mmu_setup_spp_structure(struct kvm_vcpu *vcpu,
+				u32 access_map, gfn_t gfn)
+{
+	struct kvm_shadow_walk_iterator iter;
+	struct kvm_mmu_page *sp;
+	gfn_t pseudo_gfn;
+	u64 old_spte, spp_spte;
+	int ret = -EFAULT;
+
+	/* direct_map spp start */
+	if (!VALID_PAGE(vcpu->arch.mmu->sppt_root))
+		return -EFAULT;
+
+	for_each_shadow_spp_entry(vcpu, (u64)gfn << PAGE_SHIFT, iter) {
+		if (iter.level == PT_PAGE_TABLE_LEVEL) {
+			spp_spte = format_spp_spte(access_map);
+			old_spte = mmu_spte_get_lockless(iter.sptep);
+			if (old_spte != spp_spte) {
+				mmu_spp_spte_set(iter.sptep, spp_spte);
+				kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+			}
+
+			ret = 0;
+			break;
+		}
+
+		if (!is_spp_shadow_present(*iter.sptep)) {
+			u64 base_addr = iter.addr;
+
+			base_addr &= PT64_LVL_ADDR_MASK(iter.level);
+			pseudo_gfn = base_addr >> PAGE_SHIFT;
+			sp = kvm_mmu_get_spp_page(vcpu, pseudo_gfn,
+						  iter.level - 1);
+			link_spp_shadow_page(vcpu, iter.sptep, sp);
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_setup_spp_structure);
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu *context)
 {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 54c2a377795b..ba1e85326713 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -26,6 +26,7 @@
 #define PT_PAGE_SIZE_MASK (1ULL << PT_PAGE_SIZE_SHIFT)
 #define PT_PAT_MASK (1ULL << 7)
 #define PT_GLOBAL_MASK (1ULL << 8)
+#define PT_SPP_MASK (1ULL << 61)
 #define PT64_NX_SHIFT 63
 #define PT64_NX_MASK (1ULL << PT64_NX_SHIFT)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 640a03642766..7f904d4d788c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -847,6 +847,9 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 
+struct kvm_mmu_page *kvm_mmu_get_spp_page(struct kvm_vcpu *vcpu,
+			gfn_t gfn, unsigned int level);
+
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
  * All architectures that want to use vzalloc currently also
-- 
2.17.2

