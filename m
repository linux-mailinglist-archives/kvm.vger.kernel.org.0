Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B302377E9
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfFFPaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:30:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:53940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbfFFPaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:30:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:30:00 -0700
X-ExtLoop1: 1
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2019 08:29:59 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 5/9] KVM: VMX: Add init/set/get functions for SPP
Date:   Thu,  6 Jun 2019 23:28:08 +0800
Message-Id: <20190606152812.13141-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190606152812.13141-1-weijiang.yang@intel.com>
References: <20190606152812.13141-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

init_spp() must be called before {get, set}_subpage
functions, it creates subpage access bitmaps for memory pages
and issues a KVM request to setup SPPT root pages.

kvm_mmu_set_subpages() is to enable SPP bit in EPT leaf page
and setup corresponding SPPT entries. The mmu_lock
is held before above operation. If it's called in EPT fault and
SPPT mis-config induced handler, mmu_lock is acquired outside
the function, otherwise, it's acquired inside it.

kvm_mmu_get_subpages() is used to query access bitmap for
protected page, it's also used in EPT fault handler to check
whether the fault EPT page is SPP protected as well.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  18 ++++
 arch/x86/include/asm/vmx.h      |   2 +
 arch/x86/kvm/mmu.c              | 149 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  57 ++++++++++++
 arch/x86/kvm/x86.c              |  40 +++++++++
 include/linux/kvm_host.h        |   4 +-
 include/uapi/linux/kvm.h        |   9 ++
 7 files changed, 278 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44f6e1757861..5c4882015acc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -398,8 +398,13 @@ struct kvm_mmu {
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			   u64 *spte, const void *pte);
+	int (*get_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
+	int (*set_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
+	int (*init_spp)(struct kvm *kvm);
+
 	hpa_t root_hpa;
 	gpa_t root_cr3;
+	hpa_t sppt_root;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
@@ -927,6 +932,8 @@ struct kvm_arch {
 
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+
+	bool spp_active;
 };
 
 struct kvm_vm_stat {
@@ -1199,6 +1206,11 @@ struct kvm_x86_ops {
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+
+	bool (*get_spp_status)(void);
+	int (*get_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
+	int (*set_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
+	int (*init_spp)(struct kvm *kvm);
 };
 
 struct kvm_arch_async_pf {
@@ -1417,6 +1429,12 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush);
 
+int kvm_mmu_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info,
+			 bool mmu_locked);
+int kvm_mmu_set_subpages(struct kvm *kvm, struct kvm_subpage *spp_info,
+			 bool mmu_locked);
+int kvm_mmu_init_spp(struct kvm *kvm);
+
 void kvm_enable_tdp(void);
 void kvm_disable_tdp(void);
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a2c9e18e0ad7..6cb05ac07453 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -224,6 +224,8 @@ enum vmcs_field {
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
+	SPPT_POINTER			= 0x00002030,
+	SPPT_POINTER_HIGH		= 0x00002031,
 	TSC_MULTIPLIER                  = 0x00002032,
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 16e390fd6e58..57d50794474a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3756,6 +3756,9 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
 					   &invalid_list);
+			if (vcpu->kvm->arch.spp_active)
+				mmu_free_root_page(vcpu->kvm, &mmu->sppt_root,
+						   &invalid_list);
 		} else {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
@@ -4414,6 +4417,148 @@ int kvm_mmu_setup_spp_structure(struct kvm_vcpu *vcpu,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_setup_spp_structure);
+
+int kvm_mmu_init_spp(struct kvm *kvm)
+{
+	int i, ret;
+	struct kvm_vcpu *vcpu;
+
+	if (!kvm_x86_ops->get_spp_status())
+	      return -ENODEV;
+
+	if (kvm->arch.spp_active)
+	      return 0;
+
+	ret = kvm_subpage_create_bitmaps(kvm);
+
+	if (ret)
+	      return ret;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
+
+	kvm->arch.spp_active = true;
+	return 0;
+}
+
+int kvm_mmu_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info,
+			 bool mmu_locked)
+{
+	u32 *access = spp_info->access_map;
+	gfn_t gfn = spp_info->base_gfn;
+	int npages = spp_info->npages;
+	struct kvm_memory_slot *slot;
+	int i;
+	int ret;
+
+	if (!kvm->arch.spp_active)
+	      return -ENODEV;
+
+	if (!mmu_locked)
+	      spin_lock(&kvm->mmu_lock);
+
+	for (i = 0; i < npages; i++, gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (!slot) {
+			ret = -EFAULT;
+			goto out_unlock;
+		}
+		access[i] = *gfn_to_subpage_wp_info(slot, gfn);
+	}
+
+	ret = i;
+
+out_unlock:
+	if (!mmu_locked)
+	      spin_unlock(&kvm->mmu_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_get_subpages);
+
+int kvm_mmu_set_subpages(struct kvm *kvm, struct kvm_subpage *spp_info,
+			 bool mmu_locked)
+{
+	u32 *access = spp_info->access_map;
+	gfn_t gfn = spp_info->base_gfn;
+	int npages = spp_info->npages;
+	struct kvm_memory_slot *slot;
+	struct kvm_vcpu *vcpu;
+	struct kvm_rmap_head *rmap_head;
+	int i, k;
+	u32 *wp_map;
+	int ret = -EFAULT;
+
+	if (!kvm->arch.spp_active)
+		return -ENODEV;
+
+	if (!mmu_locked)
+	      spin_lock(&kvm->mmu_lock);
+
+	for (i = 0; i < npages; i++, gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (!slot)
+			goto out_unlock;
+
+		/*
+		 * check whether the target 4KB page exists in EPT leaf
+		 * entries.If it's there, we can setup SPP protection now,
+		 * otherwise, need to defer it to EPT page fault handler.
+		 */
+		rmap_head = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);
+
+		if (rmap_head->val) {
+			/*
+			 * if all subpages are not writable, open SPP bit in
+			 * EPT leaf entry to enable SPP protection for
+			 * corresponding page.
+			 */
+			if (access[i] != FULL_SPP_ACCESS) {
+				ret = kvm_mmu_open_subpage_write_protect(kvm,
+						slot, gfn);
+
+				if (ret)
+					goto out_err;
+
+				kvm_for_each_vcpu(k, vcpu, kvm)
+					kvm_mmu_setup_spp_structure(vcpu,
+						access[i], gfn);
+			} else {
+				ret = kvm_mmu_clear_subpage_write_protect(kvm,
+						slot, gfn);
+				if (ret)
+					goto out_err;
+			}
+
+		} else
+			pr_info("%s - No ETP entry, gfn = 0x%llx, access = 0x%x.\n", __func__, gfn, access[i]);
+
+		/* if this function is called in tdp_page_fault() or
+		 * spp_handler(), mmu_locked = true, SPP access bitmap
+		 * is being used, otherwise, it's being stored.
+		 */
+		if (!mmu_locked) {
+			wp_map = gfn_to_subpage_wp_info(slot, gfn);
+			*wp_map = access[i];
+		}
+	}
+
+	ret = i;
+out_err:
+	if (ret < 0)
+	      pr_info("SPP-Error, didn't get the gfn:" \
+		      "%llx from EPT leaf.\n"
+		      "Current we don't support SPP on" \
+		      "huge page.\n"
+		      "Please disable huge page and have" \
+		      "another try.\n", gfn);
+out_unlock:
+	if (!mmu_locked)
+	      spin_unlock(&kvm->mmu_lock);
+
+	return ret;
+}
+
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu *context)
 {
@@ -5104,6 +5249,9 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_cr3 = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
+	context->get_subpages = kvm_x86_ops->get_subpages;
+	context->set_subpages = kvm_x86_ops->set_subpages;
+	context->init_spp = kvm_x86_ops->init_spp;
 
 	if (!is_paging(vcpu)) {
 		context->nx = false;
@@ -5309,6 +5457,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		uint i;
 
 		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
+		vcpu->arch.mmu->sppt_root = INVALID_PAGE;
 
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a0753a36155d..91f1ebddb317 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2847,11 +2847,17 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
 	return eptp;
 }
 
+static inline u64 construct_spptp(unsigned long root_hpa)
+{
+	return root_hpa & PAGE_MASK;
+}
+
 void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	struct kvm *kvm = vcpu->kvm;
 	unsigned long guest_cr3;
 	u64 eptp;
+	u64 spptp;
 
 	guest_cr3 = cr3;
 	if (enable_ept) {
@@ -2874,6 +2880,21 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		ept_load_pdptrs(vcpu);
 	}
 
+	if (kvm->arch.spp_active) {
+		if (vcpu->arch.mmu->sppt_root == INVALID_PAGE) {
+			 int root_level;
+			 struct kvm_mmu_page *ssp_sp;
+
+			 root_level = vcpu->arch.mmu->shadow_root_level;
+			 ssp_sp = kvm_mmu_get_spp_page(vcpu, 0, root_level);
+			 ++ssp_sp->root_count;
+			 vcpu->arch.mmu->sppt_root = __pa(ssp_sp->spt);
+		}
+		spptp = construct_spptp(vcpu->arch.mmu->sppt_root);
+		vmcs_write64(SPPT_POINTER, spptp);
+		vmx_flush_tlb(vcpu, true);
+	}
+
 	vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
@@ -5735,6 +5756,9 @@ void dump_vmcs(void)
 		pr_err("PostedIntrVec = 0x%02x\n", vmcs_read16(POSTED_INTR_NV));
 	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT))
 		pr_err("EPT pointer = 0x%016llx\n", vmcs_read64(EPT_POINTER));
+	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_SPP))
+		pr_err("SPPT pointer = 0x%016llx\n", vmcs_read64(SPPT_POINTER));
+
 	n = vmcs_read32(CR3_TARGET_COUNT);
 	for (i = 0; i + 1 < n; i += 4)
 		pr_err("CR3 target%u=%016lx target%u=%016lx\n",
@@ -7546,6 +7570,12 @@ static __init int hardware_setup(void)
 		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
 	}
 
+	if (!spp_supported) {
+		kvm_x86_ops->get_subpages = NULL;
+		kvm_x86_ops->set_subpages = NULL;
+		kvm_x86_ops->init_spp = NULL;
+	}
+
 	if (!cpu_has_vmx_preemption_timer())
 		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
 
@@ -7592,6 +7622,28 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
+static bool vmx_get_spp_status(void)
+{
+	return spp_supported;
+}
+
+static int vmx_get_subpages(struct kvm *kvm,
+			    struct kvm_subpage *spp_info)
+{
+	return kvm_get_subpages(kvm, spp_info);
+}
+
+static int vmx_set_subpages(struct kvm *kvm,
+			    struct kvm_subpage *spp_info)
+{
+	return kvm_set_subpages(kvm, spp_info);
+}
+
+static int vmx_init_spp(struct kvm *kvm)
+{
+	return kvm_init_spp(kvm);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7740,6 +7792,11 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+
+	.get_spp_status = vmx_get_spp_status,
+	.get_subpages = vmx_get_subpages,
+	.set_subpages = vmx_set_subpages,
+	.init_spp = vmx_init_spp,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26e4c574731c..c7cb17941344 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4589,6 +4589,44 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
+int kvm_get_subpages(struct kvm *kvm,
+		     struct kvm_subpage *spp_info)
+{
+	int ret;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_mmu_get_subpages(kvm, spp_info, false);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_get_subpages);
+
+int kvm_set_subpages(struct kvm *kvm,
+		     struct kvm_subpage *spp_info)
+{
+	int ret;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_mmu_set_subpages(kvm, spp_info, false);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_set_subpages);
+
+int kvm_init_spp(struct kvm *kvm)
+{
+	int ret;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_mmu_init_spp(kvm);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_init_spp);
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -9349,6 +9387,8 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	}
 
 	kvm_page_track_free_memslot(free, dont);
+	if (kvm->arch.spp_active)
+	      kvm_subpage_free_memslot(free, dont);
 }
 
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7f904d4d788c..da30fcbb2727 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -849,7 +849,9 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 
 struct kvm_mmu_page *kvm_mmu_get_spp_page(struct kvm_vcpu *vcpu,
 			gfn_t gfn, unsigned int level);
-
+int kvm_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_set_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_init_spp(struct kvm *kvm);
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
  * All architectures that want to use vzalloc currently also
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d4ea4b6c922..2c75a87ab3b5 100644
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
+	 /* sub-page write-access bitmap array */
+	__u32 access_map[SUBPAGE_MAX_BITMAP];
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
  * other bits are reserved for kvm internal use which are defined in
-- 
2.17.2

