Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4957149E01
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 01:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgA0AlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 19:41:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:63120 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgA0AlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 19:41:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 16:41:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,367,1574150400"; 
   d="scan'208";a="223116783"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jan 2020 16:41:15 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86: Consolidate VM allocation and free for VMX and SVM
Date:   Sun, 26 Jan 2020 16:41:13 -0800
Message-Id: <20200127004113.25615-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127004113.25615-1-sean.j.christopherson@intel.com>
References: <20200127004113.25615-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the VM allocation and free code to common x86 as the logic is
more or less identical across SVM and VMX.

Note, although hyperv.hv_pa_pg is part of the common kvm->arch, it's
(currently) only allocated by VMX VMs.  But, since kfree() plays nice
when passed a NULL pointer, the superfluous call for SVM is harmless
and avoids future churn if SVM gains support for HyperV's direct TLB
flush.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 12 ++++--------
 arch/x86/kvm/svm.c              | 13 +++----------
 arch/x86/kvm/vmx/vmx.c          | 14 +++-----------
 arch/x86/kvm/x86.c              |  7 +++++++
 4 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 77d206a93658..06f48d3efa0a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1053,8 +1053,7 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(int index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
 
-	struct kvm *(*vm_alloc)(void);
-	void (*vm_free)(struct kvm *);
+	unsigned int (*vm_size)(void);
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
@@ -1271,13 +1270,10 @@ extern struct kmem_cache *x86_fpu_cache;
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return kvm_x86_ops->vm_alloc();
-}
-
-static inline void kvm_arch_free_vm(struct kvm *kvm)
-{
-	return kvm_x86_ops->vm_free(kvm);
+	return __vmalloc(kvm_x86_ops->vm_size(),
+			 GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL);
 }
+void kvm_arch_free_vm(struct kvm *kvm);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
 static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4fff99722487..e72e209e7254 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1946,17 +1946,11 @@ static void __unregister_enc_region_locked(struct kvm *kvm,
 	kfree(region);
 }
 
-static struct kvm *svm_vm_alloc(void)
+static unsigned int svm_vm_size(void)
 {
 	BUILD_BUG_ON(offsetof(struct kvm_svm, kvm) != 0);
 
-	return __vmalloc(sizeof(struct kvm_svm),
-			 GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL);
-}
-
-static void svm_vm_free(struct kvm *kvm)
-{
-	vfree(kvm);
+	return sizeof(struct kvm_svm);
 }
 
 static void sev_vm_destroy(struct kvm *kvm)
@@ -7385,8 +7379,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.vcpu_free = svm_free_vcpu,
 	.vcpu_reset = svm_vcpu_reset,
 
-	.vm_alloc = svm_vm_alloc,
-	.vm_free = svm_vm_free,
+	.vm_size = svm_vm_size,
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 17e449330c8a..17ae291122e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6657,18 +6657,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_complete_interrupts(vmx);
 }
 
-static struct kvm *vmx_vm_alloc(void)
+static unsigned int vmx_vm_size(void)
 {
 	BUILD_BUG_ON(offsetof(struct kvm_vmx, kvm) != 0);
 
-	return __vmalloc(sizeof(struct kvm_vmx),
-			 GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL);
-}
-
-static void vmx_vm_free(struct kvm *kvm)
-{
-	kfree(kvm->arch.hyperv.hv_pa_pg);
-	vfree(kvm);
+	return sizeof(struct kvm_vmx);
 }
 
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
@@ -7756,9 +7749,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.vm_size = vmx_vm_size,
 	.vm_init = vmx_vm_init,
-	.vm_alloc = vmx_vm_alloc,
-	.vm_free = vmx_vm_free,
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e3f1d937224..f57a0bcd0e45 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9653,6 +9653,13 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 	kvm_x86_ops->sched_in(vcpu, cpu);
 }
 
+void kvm_arch_free_vm(struct kvm *kvm)
+{
+	kfree(kvm->arch.hyperv.hv_pa_pg);
+	vfree(kvm);
+}
+
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	if (type)
-- 
2.24.1

