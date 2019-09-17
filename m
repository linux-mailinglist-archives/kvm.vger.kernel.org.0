Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2480CB49E9
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 10:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfIQIw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 04:52:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:37165 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfIQIwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 04:52:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 01:52:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,515,1559545200"; 
   d="scan'208";a="193695520"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Sep 2019 01:52:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 5/9] mmu: spp: Introduce SPP {init,set,get} functions
Date:   Tue, 17 Sep 2019 16:53:00 +0800
Message-Id: <20190917085304.16987-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190917085304.16987-1-weijiang.yang@intel.com>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

spp_init() must be called before any {get, set}_subpage
functions, it creates subpage access bitmaps for VM memory
space then sets up SPPT root pages.

kvm_spp_set_permission() is to enable SPP bit in EPT leaf page.
If the gfn range covers hugepage, then it zapps the hugepage entries
in EPT, this induces following memory access to cause EPT page fault.
The mmu_lock must be held before above operation.

kvm_spp_get_permission() is used to query access bitmap for
protected page, it's also used in EPT fault handler to check
whether the fault EPT page is SPP protected as well.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/vmx/spp.c          | 242 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/spp.h          |   5 +
 include/uapi/linux/kvm.h        |   9 ++
 4 files changed, 258 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fe6417756983..cc38670a0c45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -940,6 +940,8 @@ struct kvm_arch {
 	bool exception_payload_enabled;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
+	bool spp_active;
+
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/vmx/spp.c b/arch/x86/kvm/vmx/spp.c
index 7e66d87186a2..ffc4ebcb64a6 100644
--- a/arch/x86/kvm/vmx/spp.c
+++ b/arch/x86/kvm/vmx/spp.c
@@ -186,6 +186,24 @@ bool is_spp_spte(struct kvm_mmu_page *sp)
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
+		      break;
+	}
+
+	return vcpu;
+}
+
 #define SPPT_ENTRY_PHA_MASK (0xFFFFFFFFFF << 12)
 
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
@@ -236,6 +254,40 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
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
+	      return -EFAULT;
+
+	for (i = 0; i< npages; ++i) {
+		for_each_shadow_spp_entry(vcpu,(u64)gfn << PAGE_SHIFT, iter) {
+			if (!is_spp_shadow_present(*iter.sptep))
+			      break;
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
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vmx_spp_flush_sppt);
+
 static int kvm_spp_create_bitmaps(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
@@ -276,6 +328,196 @@ static int kvm_spp_create_bitmaps(struct kvm *kvm)
 	return ret;
 }
 
+int vmx_spp_init(struct kvm *kvm)
+{
+	int i, ret;
+	struct kvm_vcpu *vcpu;
+	int root_level;
+	struct kvm_mmu_page *ssp_sp;
+
+	/* SPP feature is exclusive with nested VM.*/
+	if (kvm_x86_ops->get_nested_state)
+	      return -EPERM;
+
+	if (kvm->arch.spp_active)
+	      return 0;
+
+	ret = kvm_spp_create_bitmaps(kvm);
+
+	if (ret)
+	      return ret;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		/* prepare caches for SPP setup.*/
+		mmu_topup_memory_caches(vcpu);
+		root_level = vcpu->arch.mmu->shadow_root_level;
+		ssp_sp = kvm_spp_get_page(vcpu, 0, root_level);
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
+	      return -ENODEV;
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
+		      --kvm->stat.lpages;
+	}
+}
+
+int kvm_spp_zap_entry(struct kvm *kvm, gfn_t gfn_lower, gfn_t gfn_upper,
+		      u64 *sptep, int level)
+{
+	int page_num = KVM_PAGES_PER_HPAGE(level);
+	gfn_t gfn_max = (gfn_lower & ~(page_num - 1)) + page_num -1;
+	int ret;
+
+	if (gfn_upper <= gfn_max)
+	      ret = gfn_upper - gfn_lower + 1;
+	else
+	      ret = gfn_max - gfn_lower + 1;
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
+	      return -EFAULT;
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
+	for (i = 0; gfn <= max_gfn; i++, gfn++) {
+		for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
+			if (!is_shadow_present_pte(*iterator.sptep))
+			      break;
+
+			if (iterator.level == PT_PAGE_TABLE_LEVEL) {
+				sbp.base_gfn = gfn;
+				sbp.access_map[0] = access[i];
+				sbp.npages = 1;
+				if (kvm_spp_mark_protection(kvm, &sbp) < 0)
+				      return -EFAULT;
+				break;
+			}
+
+			if (is_large_pte(*iterator.sptep)) {
+				count = kvm_spp_zap_entry(kvm, gfn, max_gfn,
+							  iterator.sptep,
+							  iterator.level);
+				if (count >= npages)
+				      goto out;
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
+	      return -EFAULT;
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
+			ret = kvm_spp_open_write_protect(kvm,
+						slot, gfn);
+			if (ret)
+				return ret;
+		} else {
+			ret = kvm_spp_clear_write_protect(kvm,
+						slot, gfn);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
 
 void kvm_spp_free_memslot(struct kvm_memory_slot *free,
 			      struct kvm_memory_slot *dont)
diff --git a/arch/x86/kvm/vmx/spp.h b/arch/x86/kvm/vmx/spp.h
index 94f6e39b30ed..9c3a51feddda 100644
--- a/arch/x86/kvm/vmx/spp.h
+++ b/arch/x86/kvm/vmx/spp.h
@@ -3,9 +3,14 @@
 #define __KVM_X86_VMX_SPP_H
 
 #define FULL_SPP_ACCESS		((u32)((1ULL << 32) - 1))
+
 bool is_spp_spte(struct kvm_mmu_page *sp);
 inline u64 construct_spptp(unsigned long root_hpa);
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 				u32 access_map, gfn_t gfn);
+int vmx_spp_flush_sppt(struct kvm *kvm, struct kvm_subpage *spp_info);
+void kvm_spp_free_memslot(struct kvm_memory_slot *free,
+			  struct kvm_memory_slot *dont);
+int vmx_spp_init(struct kvm *kvm);
 
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

