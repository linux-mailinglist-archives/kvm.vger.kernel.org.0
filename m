Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20D1229CB6
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgGVQCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:18 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37954 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728697AbgGVQBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1F3C2305D7EA;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 064B9307278A;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 06/34] KVM: x86: mmu: add support for EPT switching
Date:   Wed, 22 Jul 2020 19:00:53 +0300
Message-Id: <20200722160121.9601-7-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marian Rotariu <marian.c.rotariu@gmail.com>

The introspection tool uses this function to check the hardware support
for EPT switching, which can be used either to singlestep vCPUs
on a unprotected EPT view or to use #VE in order to avoid filter out
VM-exits caused by EPT violations.

Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 12 ++--
 arch/x86/kvm/vmx/vmx.c          | 98 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          |  1 +
 4 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bd45778e0904..1035308940fe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -421,6 +421,7 @@ struct kvm_mmu {
 	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			   u64 *spte, const void *pte);
 	hpa_t root_hpa;
+	hpa_t root_hpa_altviews[KVM_MAX_EPT_VIEWS];
 	gpa_t root_pgd;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0b6527a1ebe6..553425ab3518 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3760,8 +3760,11 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	if (free_active_root) {
 		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
-			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
-					   &invalid_list);
+			for (i = 0; i < KVM_MAX_EPT_VIEWS; i++)
+				mmu_free_root_page(vcpu->kvm,
+						   mmu->root_hpa_altviews + i,
+						   &invalid_list);
+			mmu->root_hpa = INVALID_PAGE;
 		} else {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
@@ -3821,9 +3824,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 					      shadow_root_level, true, i);
 			if (!VALID_PAGE(root))
 				return -ENOSPC;
-			if (i == 0)
-				vcpu->arch.mmu->root_hpa = root;
+			vcpu->arch.mmu->root_hpa_altviews[i] = root;
 		}
+		vcpu->arch.mmu->root_hpa =
+		  vcpu->arch.mmu->root_hpa_altviews[kvm_get_ept_view(vcpu)];
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
 			MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0256c3a93c87..2024ef4d9a74 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3124,6 +3124,32 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
 	return eptp;
 }
 
+static void vmx_construct_eptp_with_index(struct kvm_vcpu *vcpu,
+					  unsigned short view)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 *eptp_list = NULL;
+
+	if (!vmx->eptp_list_pg)
+		return;
+
+	eptp_list = phys_to_virt(page_to_phys(vmx->eptp_list_pg));
+
+	if (!eptp_list)
+		return;
+
+	eptp_list[view] = construct_eptp(vcpu,
+				vcpu->arch.mmu->root_hpa_altviews[view]);
+}
+
+static void vmx_construct_eptp_list(struct kvm_vcpu *vcpu)
+{
+	unsigned short view;
+
+	for (view = 0; view < KVM_MAX_EPT_VIEWS; view++)
+		vmx_construct_eptp_with_index(vcpu, view);
+}
+
 void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -3135,6 +3161,8 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
 		eptp = construct_eptp(vcpu, pgd);
 		vmcs_write64(EPT_POINTER, eptp);
 
+		vmx_construct_eptp_list(vcpu);
+
 		if (kvm_x86_ops.tlb_remote_flush) {
 			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 			to_vmx(vcpu)->ept_pointer = eptp;
@@ -4336,6 +4364,15 @@ static void ept_set_mmio_spte_mask(void)
 	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE, 0);
 }
 
+static int vmx_alloc_eptp_list_page(struct vcpu_vmx *vmx)
+{
+	vmx->eptp_list_pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!vmx->eptp_list_pg)
+		return -ENOMEM;
+
+	return 0;
+}
+
 #define VMX_XSS_EXIT_BITMAP 0
 
 /*
@@ -4426,6 +4463,10 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
 
+	if (vmx->eptp_list_pg)
+		vmcs_write64(EPTP_LIST_ADDRESS,
+				page_to_phys(vmx->eptp_list_pg));
+
 	if (vmx_pt_mode_is_host_guest()) {
 		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
 		/* Bit[6~0] are forced to 1, writes are ignored. */
@@ -5913,6 +5954,24 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 	       vmcs_readl(limit + GUEST_GDTR_BASE - GUEST_GDTR_LIMIT));
 }
 
+static void dump_eptp_list(void)
+{
+	phys_addr_t eptp_list_phys, *eptp_list = NULL;
+	int i;
+
+	eptp_list_phys = (phys_addr_t)vmcs_read64(EPTP_LIST_ADDRESS);
+	if (!eptp_list_phys)
+		return;
+
+	eptp_list = phys_to_virt(eptp_list_phys);
+
+	pr_err("*** EPTP Switching ***\n");
+	pr_err("EPTP List Address: %p (phys %p)\n",
+		eptp_list, (void *)eptp_list_phys);
+	for (i = 0; i < KVM_MAX_EPT_VIEWS; i++)
+		pr_err("%d: %016llx\n", i, *(eptp_list + i));
+}
+
 void dump_vmcs(void)
 {
 	u32 vmentry_ctl, vmexit_ctl;
@@ -6061,6 +6120,23 @@ void dump_vmcs(void)
 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
 		pr_err("Virtual processor ID = 0x%04x\n",
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
+
+	dump_eptp_list();
+}
+
+static unsigned int update_ept_view(struct vcpu_vmx *vmx)
+{
+	u64 *eptp_list = phys_to_virt(page_to_phys(vmx->eptp_list_pg));
+	u64 eptp = vmcs_read64(EPT_POINTER);
+	unsigned int view;
+
+	for (view = 0; view < KVM_MAX_EPT_VIEWS; view++)
+		if (eptp_list[view] == eptp) {
+			vmx->view = view;
+			break;
+		}
+
+	return vmx->view;
 }
 
 /*
@@ -6073,6 +6149,13 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	u32 exit_reason = vmx->exit_reason;
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
+	if (vmx->eptp_list_pg) {
+		unsigned int view = update_ept_view(vmx);
+		struct kvm_mmu *mmu = vcpu->arch.mmu;
+
+		mmu->root_hpa = mmu->root_hpa_altviews[view];
+	}
+
 	/*
 	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
 	 * updated. Another good is, in kvm_vm_ioctl_get_dirty_log, before
@@ -6951,12 +7034,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_fastpath;
 }
 
+static void vmx_destroy_eptp_list_page(struct vcpu_vmx *vmx)
+{
+	if (vmx->eptp_list_pg) {
+		__free_page(vmx->eptp_list_pg);
+		vmx->eptp_list_pg = NULL;
+	}
+}
+
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (enable_pml)
 		vmx_destroy_pml_buffer(vmx);
+	vmx_destroy_eptp_list_page(vmx);
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
@@ -7021,6 +7113,12 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	if (err < 0)
 		goto free_pml;
 
+	if (kvm_eptp_switching_supported) {
+		err = vmx_alloc_eptp_list_page(vmx);
+		if (err)
+			goto free_pml;
+	}
+
 	msr_bitmap = vmx->vmcs01.msr_bitmap;
 	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
 	vmx_disable_intercept_for_msr(NULL, msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 14f0b9102d58..4e2f86458ca2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -297,6 +297,7 @@ struct vcpu_vmx {
 
 	struct pt_desc pt_desc;
 
+	struct page *eptp_list_pg;
 	/* The view this vcpu operates on. */
 	u16 view;
 };
