Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26CC6101E69
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 09:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfKSIsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 03:48:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:26340 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfKSIsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 03:48:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 00:48:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,322,1569308400"; 
   d="scan'208";a="196427030"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 19 Nov 2019 00:48:00 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 4/9] mmu: spp: Add functions to create/destroy SPP bitmap block
Date:   Tue, 19 Nov 2019 16:49:44 +0800
Message-Id: <20191119084949.15471-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191119084949.15471-1-weijiang.yang@intel.com>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create access bitmap for SPP subpages, the bitmap can
be accessed with a gfn. The initial access bitmap for each
physical page is 0xFFFFFFFF, meaning SPP is not enabled for the
subpages.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/vmx/spp.c          | 311 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/spp.h          |   7 +
 include/uapi/linux/kvm.h        |   9 +
 4 files changed, 325 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eb18f4dd993d..cc38670a0c45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -799,6 +799,7 @@ struct kvm_lpage_info {
 
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
+	u32 *subpage_wp_info;
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
 };
@@ -939,6 +940,8 @@ struct kvm_arch {
 	bool exception_payload_enabled;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
+	bool spp_active;
+
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/vmx/spp.c b/arch/x86/kvm/vmx/spp.c
index 27fef18fcc4e..964d31fe9426 100644
--- a/arch/x86/kvm/vmx/spp.c
+++ b/arch/x86/kvm/vmx/spp.c
@@ -22,6 +22,15 @@ static int is_spp_shadow_present(u64 pte)
 	return pte & PT_PRESENT_MASK;
 }
 
+u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long idx;
+
+	idx = gfn_to_index(gfn, slot->base_gfn, PT_PAGE_TABLE_LEVEL);
+	return &slot->arch.subpage_wp_info[idx];
+}
+EXPORT_SYMBOL_GPL(gfn_to_subpage_wp_info);
+
 static bool __rmap_open_subpage_bit(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head)
 {
@@ -179,6 +188,24 @@ bool is_spp_spte(struct kvm_mmu_page *sp)
 	return sp->role.spp;
 }
 
+/*
+ * all vcpus share the same SPPT, vcpu->arch.mmu->sppt_root points to same
+ * SPPT root page, so any vcpu will do.
+ */
+static struct kvm_vcpu *kvm_spp_get_vcpu(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu = NULL;
+	int idx;
+
+	for (idx = 0; idx < atomic_read(&kvm->online_vcpus); idx++) {
+		vcpu = kvm_get_vcpu(kvm, idx);
+		if (vcpu)
+			break;
+	}
+
+	return vcpu;
+}
+
 #define SPPT_ENTRY_PHA_MASK (0xFFFFFFFFFF << 12)
 
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
@@ -198,11 +225,8 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 		if (iter.level == PT_PAGE_TABLE_LEVEL) {
 			spp_spte = format_spp_spte(access_map);
 			old_spte = mmu_spte_get_lockless(iter.sptep);
-			if (old_spte != spp_spte) {
+			if (old_spte != spp_spte)
 				spp_spte_set(iter.sptep, spp_spte);
-				//kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-				kvm_flush_remote_tlbs(vcpu->kvm);
-			}
 			ret = 0;
 			break;
 		}
@@ -226,11 +250,288 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 			link_spp_shadow_page(vcpu, iter.sptep, sp);
 		}
 	}
-
+	kvm_flush_remote_tlbs(vcpu->kvm);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_spp_setup_structure);
 
+int vmx_spp_flush_sppt(struct kvm *kvm, struct kvm_subpage *spp_info)
+{
+	struct kvm_shadow_walk_iterator iter;
+	struct kvm_vcpu *vcpu;
+	gfn_t gfn = spp_info->base_gfn;
+	int npages = spp_info->npages;
+	u64 spde;
+	int i;
+
+	vcpu = kvm_spp_get_vcpu(kvm);
+	/* direct_map spp start */
+	if (!VALID_PAGE(vcpu->arch.mmu->sppt_root))
+		return -EFAULT;
+
+	for (i = 0; i < npages; ++i) {
+		for_each_shadow_spp_entry(vcpu, (u64)gfn << PAGE_SHIFT, iter) {
+			if (!is_spp_shadow_present(*iter.sptep))
+				break;
+
+			if (iter.level == PT_DIRECTORY_LEVEL) {
+				spde = *iter.sptep;
+				spde &= ~PT_PRESENT_MASK;
+				spp_spte_set(iter.sptep, spde);
+				break;
+			}
+		}
+		gfn++;
+	}
+	kvm_flush_remote_tlbs(kvm);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vmx_spp_flush_sppt);
+
+static int kvm_spp_create_bitmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int i, j, ret;
+	u32 *buff;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			buff = kvzalloc(memslot->npages *
+				sizeof(*memslot->arch.subpage_wp_info),
+				GFP_KERNEL);
+
+			if (!buff) {
+				ret = -ENOMEM;
+				goto out_free;
+			}
+			memslot->arch.subpage_wp_info = buff;
+
+			for (j = 0; j < memslot->npages; j++)
+				buff[j] = FULL_SPP_ACCESS;
+		}
+	}
+
+	return 0;
+out_free:
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			if (memslot->arch.subpage_wp_info) {
+				kvfree(memslot->arch.subpage_wp_info);
+				memslot->arch.subpage_wp_info = NULL;
+			}
+		}
+	}
+
+	return ret;
+}
+
+int vmx_spp_init(struct kvm *kvm)
+{
+	int i, ret;
+	struct kvm_vcpu *vcpu;
+	int root_level;
+	struct kvm_mmu_page *ssp_sp;
+	bool first_root = true;
+
+	/* SPP feature is exclusive with nested VM.*/
+	if (kvm_x86_ops->get_nested_state)
+		return -EPERM;
+
+	if (kvm->arch.spp_active)
+		return 0;
+
+	ret = kvm_spp_create_bitmaps(kvm);
+
+	if (ret)
+		return ret;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (first_root) {
+			/* prepare caches for SPP setup.*/
+			mmu_topup_memory_caches(vcpu);
+			root_level = vcpu->arch.mmu->shadow_root_level;
+			ssp_sp = kvm_spp_get_page(vcpu, 0, root_level);
+			first_root = false;
+		}
+		++ssp_sp->root_count;
+		vcpu->arch.mmu->sppt_root = __pa(ssp_sp->spt);
+		kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
+	}
+
+	kvm->arch.spp_active = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vmx_spp_init);
+
+int kvm_spp_get_permission(struct kvm *kvm, struct kvm_subpage *spp_info)
+{
+	u32 *access = spp_info->access_map;
+	gfn_t gfn = spp_info->base_gfn;
+	int npages = spp_info->npages;
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
+		access[i] = *gfn_to_subpage_wp_info(slot, gfn);
+	}
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(kvm_spp_get_permission);
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
+int kvm_spp_zap_entry(struct kvm *kvm, gfn_t gfn_lower, gfn_t gfn_upper,
+		      u64 *sptep, int level)
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
+	kvm_spp_zap_pte(kvm, sptep, level);
+	kvm_flush_remote_tlbs(kvm);
+
+	return ret;
+}
+
+int kvm_spp_set_permission(struct kvm *kvm, struct kvm_subpage *spp_info)
+{
+	u32 *access = spp_info->access_map;
+	gfn_t gfn = spp_info->base_gfn;
+	int npages = spp_info->npages;
+	struct kvm_memory_slot *slot;
+	struct kvm_subpage sbp = {0};
+	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_vcpu *vcpu;
+	gfn_t max_gfn;
+	gfn_t old_gfn = gfn;
+	u32 *wp_map;
+	int i, count;
+
+	if (!kvm->arch.spp_active)
+		return -ENODEV;
+
+	if (npages > SUBPAGE_MAX_BITMAP)
+		return -EFAULT;
+
+	for (i = 0; i < npages; i++, gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (!slot)
+			return -EFAULT;
+
+		wp_map = gfn_to_subpage_wp_info(slot, gfn);
+		*wp_map = access[i];
+	}
+
+	gfn = old_gfn;
+	max_gfn = gfn + npages - 1;
+	vcpu = kvm_spp_get_vcpu(kvm);
+
+	if (!vcpu || (vcpu && !VALID_PAGE(vcpu->arch.mmu->root_hpa)))
+		goto out;
+
+	for (i = 0; gfn <= max_gfn; i++, gfn++) {
+		for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
+			if (!is_shadow_present_pte(*iterator.sptep))
+				break;
+
+			if (iterator.level == PT_PAGE_TABLE_LEVEL) {
+				sbp.base_gfn = gfn;
+				sbp.access_map[0] = access[i];
+				sbp.npages = 1;
+				if (kvm_spp_mark_protection(kvm, &sbp) < 0)
+					return -EFAULT;
+				break;
+			} else if (is_large_pte(*iterator.sptep)) {
+				count = kvm_spp_zap_entry(kvm, gfn, max_gfn,
+							  iterator.sptep,
+							  iterator.level);
+				if (count >= npages)
+					goto out;
+				gfn += count - 1;
+			}
+		}
+	}
+out:
+	return npages;
+}
+
+int kvm_spp_mark_protection(struct kvm *kvm, struct kvm_subpage *spp_info)
+{
+	u32 *access = spp_info->access_map;
+	gfn_t gfn = spp_info->base_gfn;
+	struct kvm_memory_slot *slot;
+	struct kvm_rmap_head *rmap_head;
+	int ret;
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
+		/*
+		 * if all subpages are not writable, open SPP bit in
+		 * EPT leaf entry to enable SPP protection for
+		 * corresponding page.
+		 */
+		if (access[0] != FULL_SPP_ACCESS) {
+			ret = kvm_spp_open_write_protect(kvm, slot, gfn);
+			if (ret)
+				return ret;
+		} else {
+			ret = kvm_spp_clear_write_protect(kvm, slot, gfn);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+void kvm_spp_free_memslot(struct kvm_memory_slot *free,
+			  struct kvm_memory_slot *dont)
+{
+	if (!dont || free->arch.subpage_wp_info !=
+	    dont->arch.subpage_wp_info) {
+		kvfree(free->arch.subpage_wp_info);
+		free->arch.subpage_wp_info = NULL;
+	}
+}
+
 inline u64 construct_spptp(unsigned long root_hpa)
 {
 	return root_hpa & PAGE_MASK;
diff --git a/arch/x86/kvm/vmx/spp.h b/arch/x86/kvm/vmx/spp.h
index 25a23a4277eb..56b287ec15fd 100644
--- a/arch/x86/kvm/vmx/spp.h
+++ b/arch/x86/kvm/vmx/spp.h
@@ -2,9 +2,16 @@
 #ifndef __KVM_X86_VMX_SPP_H
 #define __KVM_X86_VMX_SPP_H
 
+#define FULL_SPP_ACCESS		((u32)((1ULL << 32) - 1))
+
 bool is_spp_spte(struct kvm_mmu_page *sp);
 inline u64 construct_spptp(unsigned long root_hpa);
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 			    u32 access_map, gfn_t gfn);
+int vmx_spp_flush_sppt(struct kvm *kvm, struct kvm_subpage *spp_info);
+void kvm_spp_free_memslot(struct kvm_memory_slot *free,
+			  struct kvm_memory_slot *dont);
+int vmx_spp_init(struct kvm *kvm);
+u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn);
 
 #endif /* __KVM_X86_VMX_SPP_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d5359e..9460830de536 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -102,6 +102,15 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };
 
+/* for KVM_SUBPAGES_GET_ACCESS and KVM_SUBPAGES_SET_ACCESS */
+#define SUBPAGE_MAX_BITMAP   64
+struct kvm_subpage {
+	__u64 base_gfn;
+	__u64 npages;
+	/* sub-page write-access bitmap array */
+	__u32 access_map[SUBPAGE_MAX_BITMAP];
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
  * other bits are reserved for kvm internal use which are defined in
-- 
2.17.2

