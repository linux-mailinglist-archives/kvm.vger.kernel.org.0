Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218C8F107B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 08:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbfKFHms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 02:42:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:15128 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbfKFHmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 02:42:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 23:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="232770706"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 05 Nov 2019 23:42:45 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 3/9] mmu: spp: Add SPP Table setup functions
Date:   Wed,  6 Nov 2019 15:44:58 +0800
Message-Id: <20191106074504.14858-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191106074504.14858-1-weijiang.yang@intel.com>
References: <20191106074504.14858-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPPT is a 4-level paging structure similar to EPT, when SPP is
armed for target physical page, bit 61 of the corresponding
EPT entry is flaged, then SPPT is traversed with the gfn,
the leaf entry of SPPT contains the access bitmap of subpages
inside the target 4KB physical page, one bit per 128-byte subpage.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/vmx/spp.c          | 236 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/spp.h          |  10 ++
 3 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/spp.c
 create mode 100644 arch/x86/kvm/vmx/spp.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bdc16b0aa7c6..eb18f4dd993d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -270,7 +270,8 @@ union kvm_mmu_page_role {
 		unsigned smap_andnot_wp:1;
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
-		unsigned :6;
+		unsigned spp:1;
+		unsigned reserved:5;
 
 		/*
 		 * This is left at the top of the word so that
@@ -399,6 +400,7 @@ struct kvm_mmu {
 			   u64 *spte, const void *pte);
 	hpa_t root_hpa;
 	gpa_t root_cr3;
+	hpa_t sppt_root;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
diff --git a/arch/x86/kvm/vmx/spp.c b/arch/x86/kvm/vmx/spp.c
new file mode 100644
index 000000000000..a1cbfc5293f5
--- /dev/null
+++ b/arch/x86/kvm/vmx/spp.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "spp.h"
+
+#define for_each_shadow_spp_entry(_vcpu, _addr, _walker)    \
+	for (shadow_spp_walk_init(&(_walker), _vcpu, _addr);	\
+	     shadow_walk_okay(&(_walker));			\
+	     shadow_walk_next(&(_walker)))
+
+static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
+				 struct kvm_vcpu *vcpu, u64 addr)
+{
+	iterator->addr = addr;
+	iterator->shadow_addr = vcpu->arch.mmu->sppt_root;
+
+	/* SPP Table is a 4-level paging structure */
+	iterator->level = PT64_ROOT_4LEVEL;
+}
+
+static int is_spp_shadow_present(u64 pte)
+{
+	return pte & PT_PRESENT_MASK;
+}
+
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
+static int kvm_spp_open_write_protect(struct kvm *kvm,
+				      struct kvm_memory_slot *slot,
+				      gfn_t gfn)
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
+		spte = (*sptep & ~PT_SPP_MASK);
+		flush |= mmu_spte_update(sptep, spte);
+	}
+
+	return flush;
+}
+
+static int kvm_spp_clear_write_protect(struct kvm *kvm,
+				       struct kvm_memory_slot *slot,
+				       gfn_t gfn)
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
+struct kvm_mmu_page *kvm_spp_get_page(struct kvm_vcpu *vcpu,
+				      gfn_t gfn,
+				      unsigned int level)
+{
+	struct kvm_mmu_page *sp;
+	union kvm_mmu_page_role role;
+
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = level;
+	role.direct = true;
+	role.spp = true;
+
+	for_each_valid_sp(vcpu->kvm, sp, gfn) {
+		if (sp->gfn != gfn)
+			continue;
+		if (sp->role.word != role.word)
+			continue;
+		if (sp->role.spp && role.level == level)
+			goto out;
+	}
+
+	sp = kvm_mmu_alloc_page(vcpu, true);
+	sp->gfn = gfn;
+	sp->role = role;
+	hlist_add_head(&sp->hash_link,
+		       &vcpu->kvm->arch.mmu_page_hash
+		       [kvm_page_table_hashfn(gfn)]);
+	clear_page(sp->spt);
+out:
+	return sp;
+}
+EXPORT_SYMBOL_GPL(kvm_spp_get_page);
+
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
+static void spp_spte_set(u64 *sptep, u64 new_spte)
+{
+	__set_spte(sptep, new_spte);
+}
+
+bool is_spp_spte(struct kvm_mmu_page *sp)
+{
+	return sp->role.spp;
+}
+
+#define SPPT_ENTRY_PHA_MASK (0xFFFFFFFFFF << 12)
+
+int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
+			    u32 access_map, gfn_t gfn)
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
+				spp_spte_set(iter.sptep, spp_spte);
+				kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+			}
+			ret = 0;
+			break;
+		}
+
+		if (!is_spp_shadow_present(*iter.sptep)) {
+			u64 base_addr = iter.addr;
+
+			base_addr &= PT64_LVL_ADDR_MASK(iter.level);
+			pseudo_gfn = base_addr >> PAGE_SHIFT;
+
+			spp_spte = *iter.sptep;
+			if (iter.level == PT_DIRECTORY_LEVEL  &&
+			    (spp_spte & SPPT_ENTRY_PHA_MASK)) {
+				spp_spte |= PT_PRESENT_MASK;
+				spp_spte_set(iter.sptep, spp_spte);
+				continue;
+			}
+			sp = kvm_spp_get_page(vcpu, pseudo_gfn,
+					      iter.level - 1);
+			link_spp_shadow_page(vcpu, iter.sptep, sp);
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_spp_setup_structure);
+
+inline u64 construct_spptp(unsigned long root_hpa)
+{
+	return root_hpa & PAGE_MASK;
+}
+EXPORT_SYMBOL_GPL(construct_spptp);
+
diff --git a/arch/x86/kvm/vmx/spp.h b/arch/x86/kvm/vmx/spp.h
new file mode 100644
index 000000000000..25a23a4277eb
--- /dev/null
+++ b/arch/x86/kvm/vmx/spp.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_SPP_H
+#define __KVM_X86_VMX_SPP_H
+
+bool is_spp_spte(struct kvm_mmu_page *sp);
+inline u64 construct_spptp(unsigned long root_hpa);
+int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
+			    u32 access_map, gfn_t gfn);
+
+#endif /* __KVM_X86_VMX_SPP_H */
-- 
2.17.2

