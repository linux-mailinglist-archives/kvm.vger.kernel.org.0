Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D3C12552C
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfLRVzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:55:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:54829 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbfLRVzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:55:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108049"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: [PATCH v2 10/45] KVM: x86: Move kvm_vcpu_init() invocation to common code
Date:   Wed, 18 Dec 2019 13:54:55 -0800
Message-Id: <20191218215530.2280-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the kvm_cpu_{un}init() calls to common x86 code as an intermediate
step to removing kvm_cpu_{un}init() altogether.

Note, VMX'x alloc_apic_access_page() and init_rmode_identity_map() are
per-VM allocations and are intentionally kept if vCPU creation fails.
They are freed by kvm_arch_destroy_vm().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              | 13 +++----------
 arch/x86/kvm/vmx/vmx.c          | 19 ++++++-------------
 arch/x86/kvm/x86.c              | 20 +++++++++++++++-----
 4 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dbc2aa055942..deddd6fb198c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1045,7 +1045,7 @@ struct kvm_x86_ops {
 	void (*vm_destroy)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
-	int (*vcpu_create)(struct kvm *kvm, struct kvm_vcpu *vcpu, unsigned id);
+	int (*vcpu_create)(struct kvm_vcpu *vcpu);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 	void (*vcpu_reset)(struct kvm_vcpu *vcpu, bool init_event);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1a5ead23e84b..84d1a28e99d6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2144,8 +2144,7 @@ static int avic_init_vcpu(struct vcpu_svm *svm)
 	return ret;
 }
 
-static int svm_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
-			   unsigned int id)
+static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *page;
@@ -2157,14 +2156,10 @@ static int svm_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
 	svm = to_svm(vcpu);
 
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		return err;
-
 	err = -ENOMEM;
 	page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!page)
-		goto uninit;
+		goto out;
 
 	msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
 	if (!msrpm_pages)
@@ -2213,8 +2208,7 @@ static int svm_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	__free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
 free_page1:
 	__free_page(page);
-uninit:
-	kvm_vcpu_uninit(vcpu);
+out:
 	return err;
 }
 
@@ -2241,7 +2235,6 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 	__free_page(virt_to_page(svm->nested.hsave));
 	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
-	kvm_vcpu_uninit(vcpu);
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fd688b16e688..eea940330dd3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6672,11 +6672,9 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
-	kvm_vcpu_uninit(vcpu);
 }
 
-static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
-			   unsigned int id)
+static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx;
 	unsigned long *msr_bitmap;
@@ -6685,10 +6683,6 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
 
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		return err;
-
 	err = -ENOMEM;
 
 	vmx->vpid = allocate_vpid();
@@ -6702,7 +6696,7 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	if (enable_pml) {
 		vmx->pml_pg = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 		if (!vmx->pml_pg)
-			goto uninit_vcpu;
+			goto free_vpid;
 	}
 
 	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != NR_SHARED_MSRS);
@@ -6747,7 +6741,7 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-	if (kvm_cstate_in_guest(kvm)) {
+	if (kvm_cstate_in_guest(vcpu->kvm)) {
 		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
@@ -6763,13 +6757,13 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	vmx_vcpu_put(vcpu);
 	put_cpu();
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
-		err = alloc_apic_access_page(kvm);
+		err = alloc_apic_access_page(vcpu->kvm);
 		if (err)
 			goto free_vmcs;
 	}
 
 	if (enable_ept && !enable_unrestricted_guest) {
-		err = init_rmode_identity_map(kvm);
+		err = init_rmode_identity_map(vcpu->kvm);
 		if (err)
 			goto free_vmcs;
 	}
@@ -6801,8 +6795,7 @@ static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	free_loaded_vmcs(vmx->loaded_vmcs);
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
+free_vpid:
 	free_vpid(vmx->vpid);
 	return err;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b3e367963b08..8973037eb2fa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9095,6 +9095,8 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kvm_x86_ops->vcpu_free(vcpu);
 
+	kvm_vcpu_uninit(vcpu);
+
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
@@ -9116,12 +9118,20 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (!vcpu)
 		return ERR_PTR(-ENOMEM);
 
-	r = kvm_x86_ops->vcpu_create(kvm, vcpu, id);
-	if (r) {
-		kmem_cache_free(kvm_vcpu_cache, vcpu);
-		return ERR_PTR(r);
-	}
+	r = kvm_vcpu_init(vcpu, kvm, id);
+	if (r)
+		goto free_vcpu;
+
+	r = kvm_x86_ops->vcpu_create(vcpu);
+	if (r)
+		goto uninit_vcpu;
 	return vcpu;
+
+uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
+free_vcpu:
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
+	return ERR_PTR(r);
 }
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
-- 
2.24.1

