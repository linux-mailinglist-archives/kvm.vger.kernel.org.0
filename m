Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F74A141BC8
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 05:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgASEAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 23:00:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:62796 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgASEAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 23:00:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 20:00:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="214910478"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 18 Jan 2020 20:00:26 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 03/10] mmu: spp: Implement functions to {get|set}_subpage permission
Date:   Sun, 19 Jan 2020 12:05:00 +0800
Message-Id: <20200119040507.23113-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200119040507.23113-1-weijiang.yang@intel.com>
References: <20200119040507.23113-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace application can {set|get} subpage permission via
IOCTLs if SPP has been initialized.

Steps for set_permission:
1)Store the permission vectors to SPP bitmap buffer.
2)Flush existing hugepage mapping in rmap so as to avoid
  stale mapping.
3)Walk EPT to check if gfn->pfn 4KB mapping is there,
  mark the existing entry as WP and SPP protected.
4)Zap the entry if gfn->pfn is hugepage mapping so that
  following memory access can trigger EPT page_fault() to
  set up SPP protection.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/mmu.h              |   2 +
 arch/x86/kvm/mmu/spp.c          | 242 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h          |  12 ++
 include/uapi/linux/kvm.h        |   8 ++
 5 files changed, 267 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9506c9d40895..4fb8816a328a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -712,6 +712,7 @@ struct kvm_vcpu_arch {
 	unsigned nmi_pending; /* NMI queued after currently running handler */
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 	bool smi_pending;    /* SMI queued after currently running handler */
+	bool spp_pending;    /* SPP has been requested, need to update VMCS */
 
 	struct kvm_mtrr mtrr_state;
 	u64 pat;
@@ -812,6 +813,7 @@ struct kvm_lpage_info {
 
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
+	u32 *subpage_wp_info;
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
 };
@@ -959,6 +961,7 @@ struct kvm_arch {
 	struct task_struct *nx_lpage_recovery_thread;
 
 	hpa_t sppt_root;
+	bool spp_active;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index d55674f44a18..a09ea3896efc 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -28,6 +28,8 @@
 #define PT_GLOBAL_MASK (1ULL << 8)
 #define PT64_NX_SHIFT 63
 #define PT64_NX_MASK (1ULL << PT64_NX_SHIFT)
+#define PT_SPP_SHIFT 61
+#define PT_SPP_MASK (1ULL << PT_SPP_SHIFT)
 
 #define PT_PAT_SHIFT 7
 #define PT_DIR_PAT_SHIFT 12
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 4247d6b1c6f7..55899eee4398 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -17,6 +17,68 @@ static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
 	iterator->level = PT64_ROOT_4LEVEL;
 }
 
+u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long idx;
+
+	if (!slot->arch.subpage_wp_info)
+		return NULL;
+
+	idx = gfn_to_index(gfn, slot->base_gfn, PT_PAGE_TABLE_LEVEL);
+	if (idx > slot->npages - 1)
+		return NULL;
+
+	return &slot->arch.subpage_wp_info[idx];
+}
+
+static bool __rmap_update_subpage_bit(struct kvm *kvm,
+				      struct kvm_rmap_head *rmap_head,
+				      bool setbit)
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
+		spte = setbit ? (*sptep | PT_SPP_MASK) :
+				(*sptep & ~PT_SPP_MASK);
+		flush |= mmu_spte_update(sptep, spte);
+	}
+
+	return flush;
+}
+
+static int kvm_spp_update_write_protect(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					gfn_t gfn,
+					bool enable)
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
+	flush |= __rmap_update_subpage_bit(kvm, rmap_head, enable);
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	return 0;
+}
+
 struct kvm_mmu_page *kvm_spp_get_page(struct kvm_vcpu *vcpu,
 				      gfn_t gfn,
 				      unsigned int level)
@@ -82,6 +144,20 @@ static void spp_spte_set(u64 *sptep, u64 new_spte)
 	__set_spte(sptep, new_spte);
 }
 
+static int kvm_spp_level_pages(gfn_t gfn_lower, gfn_t gfn_upper, int level)
+{
+	int page_num = KVM_PAGES_PER_HPAGE(level);
+	gfn_t gfn_max = (gfn_lower & ~(page_num - 1)) + page_num - 1;
+	int ret;
+
+	if (gfn_upper <= gfn_max)
+		ret = gfn_upper - gfn_lower + 1;
+	else
+		ret = gfn_max - gfn_lower + 1;
+
+	return ret;
+}
+
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 			    u32 access_map, gfn_t gfn)
 {
@@ -124,3 +200,169 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 	kvm_flush_remote_tlbs(vcpu->kvm);
 	return ret;
 }
+
+int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map)
+{
+	u32 *access;
+	struct kvm_memory_slot *slot;
+	int i;
+
+	if (!kvm->arch.spp_active)
+		return -ENODEV;
+
+	for (i = 0; i < npages; i++, gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (!slot)
+			return -EFAULT;
+		access = gfn_to_subpage_wp_info(slot, gfn);
+		if (!access)
+			return -EFAULT;
+		access_map[i] = *access;
+	}
+
+	return i;
+}
+
+static void kvm_spp_zap_pte(struct kvm *kvm, u64 *spte, int level)
+{
+	u64 pte;
+
+	pte = *spte;
+	if (is_shadow_present_pte(pte) && is_last_spte(pte, level)) {
+		drop_spte(kvm, spte);
+		if (is_large_pte(pte))
+			--kvm->stat.lpages;
+	}
+}
+
+static bool kvm_spp_flush_rmap(struct kvm *kvm, u64 gfn_min, u64 gfn_max)
+{
+	u64 *sptep;
+	struct rmap_iterator iter;
+	struct kvm_rmap_head *rmap_head;
+	int level;
+	struct kvm_memory_slot *slot;
+	bool flush = false;
+
+	slot = gfn_to_memslot(kvm, gfn_min);
+	if (!slot)
+		return false;
+
+	for (; gfn_min <= gfn_max; gfn_min++) {
+		for (level = PT_PAGE_TABLE_LEVEL;
+		     level <= PT_DIRECTORY_LEVEL; level++) {
+			rmap_head = __gfn_to_rmap(gfn_min, level, slot);
+			for_each_rmap_spte(rmap_head, &iter, sptep) {
+				pte_list_remove(rmap_head, sptep);
+				flush = true;
+			}
+		}
+	}
+
+	return flush;
+}
+
+int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map)
+{
+	gfn_t old_gfn = gfn;
+	u32 *access;
+	struct kvm_memory_slot *slot;
+	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_vcpu *vcpu;
+	gfn_t gfn_end;
+	int i, count, level;
+	bool flush = false;
+
+	if (!kvm->arch.spp_active)
+		return -ENODEV;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	if (!VALID_PAGE(vcpu->kvm->arch.sppt_root))
+		return -EFAULT;
+
+	for (i = 0; i < npages; i++, gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (!slot)
+			return -EFAULT;
+
+		access = gfn_to_subpage_wp_info(slot, gfn);
+		if (!access)
+			return -EFAULT;
+		*access = access_map[i];
+	}
+
+	gfn = old_gfn;
+	gfn_end = gfn + npages - 1;
+	vcpu = kvm_get_vcpu(kvm, 0);
+
+	if (!vcpu || (vcpu && !VALID_PAGE(vcpu->arch.mmu->root_hpa)))
+		goto out;
+
+	/* Flush any existing stale mappings in EPT before set up SPP */
+	flush = kvm_spp_flush_rmap(kvm, gfn, gfn_end);
+
+	for (i = 0; gfn <= gfn_end; i++, gfn++) {
+		for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
+			if (!is_shadow_present_pte(*iterator.sptep))
+				break;
+
+			if (iterator.level == PT_PAGE_TABLE_LEVEL) {
+				if (kvm_spp_mark_protection(kvm,
+							    gfn,
+							    access_map[i]) < 0)
+					return -EFAULT;
+				break;
+			} else if (is_large_pte(*iterator.sptep)) {
+				level = iterator.level;
+				if (access_map[i] == FULL_SPP_ACCESS)
+					break;
+				count = kvm_spp_level_pages(gfn,
+							    gfn_end,
+							    level);
+				/*
+				 * Zap existing hugepage entry so that eligible
+				 * 4KB mappings can be rebuilt in page_fault.
+				 */
+				kvm_spp_zap_pte(kvm, iterator.sptep, level);
+				flush = true;
+				if (count >= npages)
+					goto out;
+				gfn += count - 1;
+			}
+		}
+	}
+out:
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+	return npages;
+}
+
+int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_rmap_head *rmap_head;
+	int ret = 0;
+	bool enable;
+
+	if (!kvm->arch.spp_active)
+		return -ENODEV;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot)
+		return -EFAULT;
+
+	/*
+	 * check whether the target 4KB page exists in EPT leaf
+	 * entry.If it's there, just flag SPP bit of the entry,
+	 * defer the setup to SPPT miss induced vm-exit  handler.
+	 */
+	rmap_head = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);
+
+	if (rmap_head->val) {
+		enable = access != FULL_SPP_ACCESS;
+		ret = kvm_spp_update_write_protect(kvm, slot, gfn, enable);
+	}
+	return ret;
+}
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index 03e4dfad595a..9171e682be1f 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -2,4 +2,16 @@
 #ifndef __KVM_X86_VMX_SPP_H
 #define __KVM_X86_VMX_SPP_H
 
+#define FULL_SPP_ACCESS		(u32)(BIT_ULL(32) - 1)
+
+int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map);
+int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map);
+int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
+
+int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
+			    u32 access_map, gfn_t gfn);
+u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn);
+
 #endif /* __KVM_X86_VMX_SPP_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0a16b4adbbd..eabd55ec5af7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -102,6 +102,14 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };
 
+/* for KVM_SUBPAGES_GET_ACCESS and KVM_SUBPAGES_SET_ACCESS */
+struct kvm_subpage {
+	__u64 gfn_base; /* the first page gfn of the contiguous pages */
+	__u32 npages;   /* number of 4K pages */
+	__u32 flags;    /* reserved to 0 now */
+	__u32 access_map[0]; /* start place of bitmap array */
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
  * other bits are reserved for kvm internal use which are defined in
-- 
2.17.2

