Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F98D7C7A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388384AbfJOQzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:55:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:46855 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388349AbfJOQze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:55:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 09:55:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="201811363"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Oct 2019 09:55:32 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: X86: Refactor kvm_arch_vcpu_create
Date:   Wed, 16 Oct 2019 00:40:32 +0800
Message-Id: <20191015164033.87276-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20191015164033.87276-1-xiaoyao.li@intel.com>
References: <20191015164033.87276-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current x86 arch vcpu creation flow is a little bit messed.
Specifically, vcpu's data structure allocation and vcpu initialization
are mixed up, which is unfriendly to read.

Seperating the vcpu_create and vcpu_init just like what ARM does, that
it first calls vcpu_create related functions for vcpu's data structure
allocation and then calls vcpu_init related functions to initialize the
vcpu.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm.c              |  63 +++++++++---------
 arch/x86/kvm/vmx/vmx.c          | 109 ++++++++++++++++----------------
 arch/x86/kvm/x86.c              |  16 +++++
 4 files changed, 102 insertions(+), 87 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5d8056ff7390..d574c2391145 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1015,6 +1015,7 @@ struct kvm_x86_ops {
 
 	/* Create, but do not attach this VCPU */
 	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
+	int (*vcpu_init)(struct kvm_vcpu *vcpu);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 	void (*vcpu_reset)(struct kvm_vcpu *vcpu, bool init_event);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e479ea9bc9da..d35ef5456462 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2138,6 +2138,32 @@ static int avic_init_vcpu(struct vcpu_svm *svm)
 	return ret;
 }
 
+static int svm_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int err;
+
+	err = avic_init_vcpu(svm);
+	if (err)
+		return err;
+
+	/* We initialize this flag to true to make sure that the is_running
+	 * bit would be set the first time the vcpu is loaded.
+	 */
+	svm->avic_is_running = true;
+
+	svm_vcpu_init_msrpm(svm->msrpm);
+	svm_vcpu_init_msrpm(svm->nested.msrpm);
+
+	clear_page(svm->vmcb);
+	svm->asid_generation = 0;
+	init_vmcb(svm);
+
+	svm_init_osvw(vcpu);
+
+	return 0;
+}
+
 static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 {
 	struct vcpu_svm *svm;
@@ -2150,17 +2176,15 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	BUILD_BUG_ON_MSG(offsetof(struct vcpu_svm, vcpu) != 0,
 		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
 
+	err = -ENOMEM;
 	svm = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
-	if (!svm) {
-		err = -ENOMEM;
+	if (!svm)
 		goto out;
-	}
 
 	svm->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
 						     GFP_KERNEL_ACCOUNT);
 	if (!svm->vcpu.arch.user_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
-		err = -ENOMEM;
 		goto free_partial_svm;
 	}
 
@@ -2168,18 +2192,12 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 						     GFP_KERNEL_ACCOUNT);
 	if (!svm->vcpu.arch.guest_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
-		err = -ENOMEM;
 		goto free_user_fpu;
 	}
 
-	err = kvm_vcpu_init(&svm->vcpu, kvm, id);
-	if (err)
-		goto free_svm;
-
-	err = -ENOMEM;
 	page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!page)
-		goto uninit;
+		goto free_svm;
 
 	msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
 	if (!msrpm_pages)
@@ -2193,43 +2211,22 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!hsave_page)
 		goto free_page3;
 
-	err = avic_init_vcpu(svm);
-	if (err)
-		goto free_page4;
-
-	/* We initialize this flag to true to make sure that the is_running
-	 * bit would be set the first time the vcpu is loaded.
-	 */
-	svm->avic_is_running = true;
-
 	svm->nested.hsave = page_address(hsave_page);
 
 	svm->msrpm = page_address(msrpm_pages);
-	svm_vcpu_init_msrpm(svm->msrpm);
-
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
-	svm_vcpu_init_msrpm(svm->nested.msrpm);
 
 	svm->vmcb = page_address(page);
-	clear_page(svm->vmcb);
 	svm->vmcb_pa = __sme_set(page_to_pfn(page) << PAGE_SHIFT);
-	svm->asid_generation = 0;
-	init_vmcb(svm);
-
-	svm_init_osvw(&svm->vcpu);
 
 	return &svm->vcpu;
 
-free_page4:
-	__free_page(hsave_page);
 free_page3:
 	__free_pages(nested_msrpm_pages, MSRPM_ALLOC_ORDER);
 free_page2:
 	__free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
 free_page1:
 	__free_page(page);
-uninit:
-	kvm_vcpu_uninit(&svm->vcpu);
 free_svm:
 	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
 free_user_fpu:
@@ -2263,7 +2260,6 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 	__free_page(virt_to_page(svm->nested.hsave));
 	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
-	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, svm->vcpu.arch.guest_fpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
@@ -7242,6 +7238,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.vcpu_create = svm_create_vcpu,
 	.vcpu_free = svm_free_vcpu,
+	.vcpu_init = svm_vcpu_init,
 	.vcpu_reset = svm_vcpu_reset,
 
 	.vm_alloc = svm_vm_alloc,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7051511c27c2..2f54a3bcb6a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6705,30 +6705,78 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	kfree(vmx->guest_msrs);
-	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 }
 
+static int vmx_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	int cpu;
+	int err;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	cpu = get_cpu();
+	vmx_vcpu_load(vcpu, cpu);
+	vmx->vcpu.cpu = cpu;
+	vmx_vmcs_setup(vmx);
+	vmx_vcpu_put(vcpu);
+	put_cpu();
+
+	if (cpu_need_virtualize_apic_accesses(&vmx->vcpu)) {
+		err = alloc_apic_access_page(vcpu->kvm);
+		if (err)
+			return -ENOMEM;
+	}
+
+	if (enable_ept && !enable_unrestricted_guest) {
+		err = init_rmode_identity_map(vcpu->kvm);
+		if (err)
+			return -ENOMEM;
+	}
+
+	if (nested)
+		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
+					   vmx_capability.ept,
+					   kvm_vcpu_apicv_active(&vmx->vcpu));
+	else
+		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
+
+
+	vmx->nested.posted_intr_nv = -1;
+	vmx->nested.current_vmptr = -1ull;
+
+	vmx->msr_ia32_feature_control_valid_bits = FEATURE_CONTROL_LOCKED;
+
+	/*
+	 * Enforce invariant: pi_desc.nv is always either POSTED_INTR_VECTOR
+	 * or POSTED_INTR_WAKEUP_VECTOR.
+	 */
+	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
+	vmx->pi_desc.sn = 1;
+
+	vmx->ept_pointer = INVALID_PAGE;
+
+	return 0;
+}
+
 static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 {
 	int err;
 	struct vcpu_vmx *vmx;
-	int cpu;
 
 	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
 		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
 
+	err = -ENOMEM;
 	vmx = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
 	if (!vmx)
-		return ERR_PTR(-ENOMEM);
+		goto out;
 
 	vmx->vcpu.arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
 			GFP_KERNEL_ACCOUNT);
 	if (!vmx->vcpu.arch.user_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
-		err = -ENOMEM;
 		goto free_partial_vcpu;
 	}
 
@@ -6736,18 +6784,11 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 			GFP_KERNEL_ACCOUNT);
 	if (!vmx->vcpu.arch.guest_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate vcpu's fpu\n");
-		err = -ENOMEM;
 		goto free_user_fpu;
 	}
 
 	vmx->vpid = allocate_vpid();
 
-	err = kvm_vcpu_init(&vmx->vcpu, kvm, id);
-	if (err)
-		goto free_vcpu;
-
-	err = -ENOMEM;
-
 	/*
 	 * If PML is turned on, failure on enabling PML just results in failure
 	 * of creating the vcpu, therefore we can simplify PML logic (by
@@ -6757,7 +6798,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (enable_pml) {
 		vmx->pml_pg = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 		if (!vmx->pml_pg)
-			goto uninit_vcpu;
+			goto free_vcpu;
 	}
 
 	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
@@ -6772,55 +6813,13 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto free_msrs;
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
-	cpu = get_cpu();
-	vmx_vcpu_load(&vmx->vcpu, cpu);
-	vmx->vcpu.cpu = cpu;
-	vmx_vmcs_setup(vmx);
-	vmx_vcpu_put(&vmx->vcpu);
-	put_cpu();
-	if (cpu_need_virtualize_apic_accesses(&vmx->vcpu)) {
-		err = alloc_apic_access_page(kvm);
-		if (err)
-			goto free_vmcs;
-	}
-
-	if (enable_ept && !enable_unrestricted_guest) {
-		err = init_rmode_identity_map(kvm);
-		if (err)
-			goto free_vmcs;
-	}
-
-	if (nested)
-		nested_vmx_setup_ctls_msrs(&vmx->nested.msrs,
-					   vmx_capability.ept,
-					   kvm_vcpu_apicv_active(&vmx->vcpu));
-	else
-		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
-
-	vmx->nested.posted_intr_nv = -1;
-	vmx->nested.current_vmptr = -1ull;
-
-	vmx->msr_ia32_feature_control_valid_bits = FEATURE_CONTROL_LOCKED;
-
-	/*
-	 * Enforce invariant: pi_desc.nv is always either POSTED_INTR_VECTOR
-	 * or POSTED_INTR_WAKEUP_VECTOR.
-	 */
-	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
-	vmx->pi_desc.sn = 1;
-
-	vmx->ept_pointer = INVALID_PAGE;
 
 	return &vmx->vcpu;
 
-free_vmcs:
-	free_loaded_vmcs(vmx->loaded_vmcs);
 free_msrs:
 	kfree(vmx->guest_msrs);
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
-uninit_vcpu:
-	kvm_vcpu_uninit(&vmx->vcpu);
 free_vcpu:
 	free_vpid(vmx->vpid);
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.guest_fpu);
@@ -6828,6 +6827,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	kmem_cache_free(x86_fpu_cache, vmx->vcpu.arch.user_fpu);
 free_partial_vcpu:
 	kmem_cache_free(kvm_vcpu_cache, vmx);
+out:
 	return ERR_PTR(err);
 }
 
@@ -7764,6 +7764,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
+	.vcpu_init = vmx_vcpu_init,
 	.vcpu_reset = vmx_vcpu_reset,
 
 	.prepare_guest_switch = vmx_prepare_switch_to_guest,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f26f8be4e621..fd9f1a1f0f01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9016,6 +9016,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
+	kvm_vcpu_uninit(vcpu);
 	kvm_x86_ops->vcpu_free(vcpu);
 	free_cpumask_var(wbinvd_dirty_mask);
 }
@@ -9024,6 +9025,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
+	int err;
 
 	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
 		printk_once(KERN_WARNING
@@ -9031,6 +9033,14 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		"guest TSC will not be reliable\n");
 
 	vcpu = kvm_x86_ops->vcpu_create(kvm, id);
+	if (IS_ERR(vcpu))
+		return vcpu;
+
+	err = kvm_vcpu_init(vcpu, kvm, id);
+	if (err) {
+		kvm_x86_ops->vcpu_free(vcpu);
+		return ERR_PTR(err);
+	}
 
 	return vcpu;
 }
@@ -9083,6 +9093,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_unload(vcpu);
 	vcpu_put(vcpu);
 
+	kvm_vcpu_uninit(vcpu);
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 
@@ -9379,8 +9390,13 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_hv_vcpu_init(vcpu);
 
+	if (kvm_x86_ops->vcpu_init(vcpu))
+		goto fail_free_wbinvd_dirty_mask;
+
 	return 0;
 
+fail_free_wbinvd_dirty_mask:
+	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
 fail_free_lapic:
-- 
2.19.1

