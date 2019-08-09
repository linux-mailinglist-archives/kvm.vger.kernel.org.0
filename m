Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E717A87F63
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437087AbfHIQPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52862 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407429AbfHIQO7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:14:59 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 06B94302475F;
        Fri,  9 Aug 2019 19:01:09 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CEB7C305B7A4;
        Fri,  9 Aug 2019 19:01:07 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        He Chen <he.chen@linux.intel.com>,
        Zhang Yi <yi.z.zhang@linux.intel.com>
Subject: [RFC PATCH v6 38/92] KVM: VMX: Add init/set/get functions for SPP
Date:   Fri,  9 Aug 2019 18:59:53 +0300
Message-Id: <20190809160047.8319-39-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yang Weijiang <weijiang.yang@intel.com>

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

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20190717133751.12910-6-weijiang.yang@intel.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  18 ++++
 arch/x86/include/asm/vmx.h      |   2 +
 arch/x86/kvm/mmu.c              | 160 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  48 ++++++++++
 arch/x86/kvm/x86.c              |  57 ++++++++++++
 include/linux/kvm_host.h        |   3 +
 include/uapi/linux/kvm.h        |   9 ++
 7 files changed, 297 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f0878631b12a..7ee6e1ff5ee9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -399,8 +399,13 @@ struct kvm_mmu {
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
@@ -929,6 +934,8 @@ struct kvm_arch {
 
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+
+	bool spp_active;
 };
 
 struct kvm_vm_stat {
@@ -1202,6 +1209,11 @@ struct kvm_x86_ops {
 	int (*nested_enable_evmcs)(struct kvm_vcpu *vcpu,
 				   uint16_t *vmcs_version);
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
+
+	bool (*get_spp_status)(void);
+	int (*get_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
+	int (*set_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
+	int (*init_spp)(struct kvm *kvm);
 };
 
 struct kvm_arch_async_pf {
@@ -1420,6 +1432,12 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
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
index f2774bbcfeed..38e79210d010 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3846,6 +3846,9 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
 					   &invalid_list);
+			if (vcpu->kvm->arch.spp_active)
+				mmu_free_root_page(vcpu->kvm, &mmu->sppt_root,
+						   &invalid_list);
 		} else {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
@@ -4510,6 +4513,158 @@ int kvm_mmu_setup_spp_structure(struct kvm_vcpu *vcpu,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_setup_spp_structure);
+
+int kvm_mmu_init_spp(struct kvm *kvm)
+{
+	int i, ret;
+	struct kvm_vcpu *vcpu;
+	int root_level;
+	struct kvm_mmu_page *ssp_sp;
+
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
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		/* prepare caches for SPP setup.*/
+		mmu_topup_memory_caches(vcpu);
+		root_level = vcpu->arch.mmu->shadow_root_level;
+		ssp_sp = kvm_mmu_get_spp_page(vcpu, 0, root_level);
+		++ssp_sp->root_count;
+		vcpu->arch.mmu->sppt_root = __pa(ssp_sp->spt);
+		kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
+	}
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
@@ -5207,6 +5362,9 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_cr3 = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
+	context->get_subpages = kvm_x86_ops->get_subpages;
+	context->set_subpages = kvm_x86_ops->set_subpages;
+	context->init_spp = kvm_x86_ops->init_spp;
 
 	if (!is_paging(vcpu)) {
 		context->nx = false;
@@ -5403,6 +5561,8 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		uint i;
 
 		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
+		if (!vcpu->kvm->arch.spp_active)
+			vcpu->arch.mmu->sppt_root = INVALID_PAGE;
 
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f94e3defd9cf..a50dd2b9d438 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2853,11 +2853,17 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
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
@@ -2880,6 +2886,12 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		ept_load_pdptrs(vcpu);
 	}
 
+	if (kvm->arch.spp_active && VALID_PAGE(vcpu->arch.mmu->sppt_root)) {
+		spptp = construct_spptp(vcpu->arch.mmu->sppt_root);
+		vmcs_write64(SPPT_POINTER, spptp);
+		vmx_flush_tlb(vcpu, true);
+	}
+
 	vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
@@ -5743,6 +5755,9 @@ static void dump_vmcs(void)
 		pr_err("PostedIntrVec = 0x%02x\n", vmcs_read16(POSTED_INTR_NV));
 	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT))
 		pr_err("EPT pointer = 0x%016llx\n", vmcs_read64(EPT_POINTER));
+	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_SPP))
+		pr_err("SPPT pointer = 0x%016llx\n", vmcs_read64(SPPT_POINTER));
+
 	n = vmcs_read32(CR3_TARGET_COUNT);
 	for (i = 0; i + 1 < n; i += 4)
 		pr_err("CR3 target%u=%016lx target%u=%016lx\n",
@@ -7646,6 +7661,12 @@ static __init int hardware_setup(void)
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
 
@@ -7706,6 +7727,28 @@ static bool vmx_spt_fault(struct kvm_vcpu *vcpu)
 	return (vmx->exit_reason == EXIT_REASON_EPT_VIOLATION);
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
@@ -7856,6 +7899,11 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_nested_state = NULL,
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
+
+	.get_spp_status = vmx_get_spp_status,
+	.get_subpages = vmx_get_subpages,
+	.set_subpages = vmx_set_subpages,
+	.init_spp = vmx_init_spp,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2ac1e0aba1fc..b8ae25cb227b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4576,6 +4576,61 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
+static int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
+				     struct kvm_subpage *spp_info)
+{
+	return kvm_arch_get_subpages(kvm, spp_info);
+}
+
+static int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
+				     struct kvm_subpage *spp_info)
+{
+	return kvm_arch_set_subpages(kvm, spp_info);
+}
+
+static int kvm_vm_ioctl_init_spp(struct kvm *kvm)
+{
+	return kvm_arch_init_spp(kvm);
+}
+
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
@@ -9352,6 +9407,8 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	}
 
 	kvm_page_track_free_memslot(free, dont);
+	if (kvm->arch.spp_active)
+	      kvm_subpage_free_memslot(free, dont);
 }
 
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ca7597e429df..0b9a0f546397 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -834,6 +834,9 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 
 struct kvm_mmu_page *kvm_mmu_get_spp_page(struct kvm_vcpu *vcpu,
 			gfn_t gfn, unsigned int level);
+int kvm_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_set_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_init_spp(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2ff05fd123e3..ad8f2a3ca72d 100644
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
