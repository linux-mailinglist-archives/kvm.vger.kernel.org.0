Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C51A45D1AC
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353185AbhKYAYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:6415 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352887AbhKYAYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:23 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649703"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649703"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:12 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042195"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:11 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 26/59] KVM: x86: Introduce vm_teardown() hook in kvm_arch_vm_destroy()
Date:   Wed, 24 Nov 2021 16:20:09 -0800
Message-Id: <1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a second kvm_x86_ops hook in kvm_arch_vm_destroy() to support TDX's
destruction path, which needs to first put the VM into a teardown state,
then free per-vCPU resource, and finally free per-VM resources.

Note, this knowingly creates a discrepancy in nomenclature for SVM as
svm_vm_teardown() invokes avic_vm_destroy() and sev_vm_destroy().
Moving the now-misnamed functions or renaming them is left to a future
patch so as not to introduce a functional change for SVM.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/svm/svm.c             | 5 +++--
 arch/x86/kvm/vmx/vmx.c             | 7 +++++++
 arch/x86/kvm/x86.c                 | 3 ++-
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 30754f2b8a99..1009541fd6c2 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,7 @@ KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP(vm_init)
+KVM_X86_OP_NULL(vm_teardown)
 KVM_X86_OP_NULL(vm_destroy)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74c3c1629563..3bc5417f94ec 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1321,6 +1321,7 @@ struct kvm_x86_ops {
 	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
+	void (*vm_teardown)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2ef77d4566a9..1bf410add13b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4556,7 +4556,7 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
-static void svm_vm_destroy(struct kvm *kvm)
+static void svm_vm_teardown(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
@@ -4597,7 +4597,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.is_vm_type_supported = svm_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
-	.vm_destroy = svm_vm_destroy,
+	.vm_teardown = svm_vm_teardown,
+	.vm_destroy = NULL,
 
 	.prepare_guest_switch = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f2905e00b063..5e4c6ac9fe69 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6890,6 +6890,11 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static void vmx_vm_destroy(struct kvm *kvm)
+{
+
+}
+
 static int __init vmx_check_processor_compat(void)
 {
 	struct vmcs_config vmcs_conf;
@@ -7513,6 +7518,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
+	.vm_teardown = NULL,
+	.vm_destroy = vmx_vm_destroy,
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f2091c4b928a..88b55ddb22a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11613,7 +11613,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
-	static_call_cond(kvm_x86_vm_destroy)(kvm);
+	static_call_cond(kvm_x86_vm_teardown)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
@@ -11624,6 +11624,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	static_call_cond(kvm_x86_vm_destroy)(kvm);
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)
-- 
2.25.1

