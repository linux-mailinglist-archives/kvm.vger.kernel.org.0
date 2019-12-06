Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2F3114D8C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 09:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfLFIZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 03:25:16 -0500
Received: from mga06.intel.com ([134.134.136.31]:25876 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfLFIZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 03:25:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 00:25:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,283,1571727600"; 
   d="scan'208";a="294797944"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 06 Dec 2019 00:25:13 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 04/10] mmu: spp: Add functions to operate SPP access bitmap
Date:   Fri,  6 Dec 2019 16:26:28 +0800
Message-Id: <20191206082634.21042-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191206082634.21042-1-weijiang.yang@intel.com>
References: <20191206082634.21042-1-weijiang.yang@intel.com>
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
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/mmu/spp.c          | 328 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h          |  12 ++
 include/uapi/linux/kvm.h        |   8 +
 4 files changed, 350 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f49b807ce3d3..a30cff333033 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -798,6 +798,7 @@ struct kvm_lpage_info {
 
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
+	u32 *subpage_wp_info;
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
 };
@@ -940,6 +941,7 @@ struct kvm_arch {
 	struct kvm_pmu_event_filter *pmu_event_filter;
 
 	hpa_t sppt_root;
+	bool spp_active;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 655d3254a241..332fca0156cd 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -17,6 +17,17 @@ static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
 	iterator->level = PT64_ROOT_4LEVEL;
 }
 
+u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long idx;
+
+	idx = gfn_to_index(gfn, slot->base_gfn, PT_PAGE_TABLE_LEVEL);
+	if (idx > slot->npages - 1)
+		return NULL;
+	return &slot->arch.subpage_wp_info[idx];
+}
+EXPORT_SYMBOL_GPL(gfn_to_subpage_wp_info);
+
 static bool __rmap_open_subpage_bit(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head)
 {
@@ -173,6 +184,20 @@ bool is_spp_spte(struct kvm_mmu_page *sp)
 	return sp->role.spp;
 }
 
+int kvm_spp_level_pages(gfn_t gfn_lower, gfn_t gfn_upper, int level)
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
 #define SPPT_ENTRY_PHA_MASK (0xFFFFFFFFFF << 12)
 
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
@@ -221,6 +246,309 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(kvm_spp_setup_structure);
 
+int vmx_spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages)
+{
+	struct kvm_shadow_walk_iterator iter;
+	struct kvm_vcpu *vcpu;
+	gfn_t gfn = gfn_base;
+	gfn_t gfn_max = gfn_base + npages - 1;
+	u64 spde;
+	int count;
+	bool flush = false;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	if (!VALID_PAGE(vcpu->kvm->arch.sppt_root))
+		return -EFAULT;
+
+	for (; gfn <= gfn_max; gfn++) {
+		for_each_shadow_spp_entry(vcpu, (u64)gfn << PAGE_SHIFT, iter) {
+			if (!is_shadow_present_pte(*iter.sptep))
+				break;
+
+			if (iter.level == PT_DIRECTORY_LEVEL) {
+				spde = *iter.sptep;
+				spde &= ~PT_PRESENT_MASK;
+				spp_spte_set(iter.sptep, spde);
+				count = kvm_spp_level_pages(gfn,
+							    gfn_max,
+							    PT_DIRECTORY_LEVEL);
+				flush = true;
+				if (count >= npages)
+					goto out;
+				gfn += count;
+				break;
+			}
+		}
+	}
+out:
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
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
+			vcpu->kvm->arch.sppt_root = __pa(ssp_sp->spt);
+		}
+		++ssp_sp->root_count;
+		kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
+	}
+
+	kvm->arch.spp_active = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vmx_spp_init);
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
+bool kvm_spp_flush_rmap(struct kvm *kvm, u64 gfn_min, u64 gfn_max)
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
+	gfn_t gfn_max;
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
+	gfn_max = gfn + npages - 1;
+	vcpu = kvm_get_vcpu(kvm, 0);
+
+	if (!vcpu || (vcpu && !VALID_PAGE(vcpu->arch.mmu->root_hpa)))
+		goto out;
+
+	flush = kvm_spp_flush_rmap(kvm, gfn, gfn_max);
+
+	for (i = 0; gfn <= gfn_max; i++, gfn++) {
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
+							    gfn_max,
+							    level);
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
+		if (access != FULL_SPP_ACCESS) {
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
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index 25a23a4277eb..a636d09f6db0 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -2,9 +2,21 @@
 #ifndef __KVM_X86_VMX_SPP_H
 #define __KVM_X86_VMX_SPP_H
 
+#define FULL_SPP_ACCESS		((u32)((1ULL << 32) - 1))
+
+int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map);
+int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map);
+int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
 bool is_spp_spte(struct kvm_mmu_page *sp);
 inline u64 construct_spptp(unsigned long root_hpa);
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 			    u32 access_map, gfn_t gfn);
+int vmx_spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages);
+void kvm_spp_free_memslot(struct kvm_memory_slot *free,
+			  struct kvm_memory_slot *dont);
+int vmx_spp_init(struct kvm *kvm);
+u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn);
 
 #endif /* __KVM_X86_VMX_SPP_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d5359e..592624e46669 100644
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

