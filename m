Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52DC2B4FA0
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388168AbgKPS2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:20638 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388103AbgKPS2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:07 -0500
IronPort-SDR: 2imAF1Tzfn1GrhVnu5GlKSrsIJ8KowrIddRCZUrhuCm+QFyWVXBzMt+Z+wXR4+MqlqQSGqxK7o
 SSNIrY8oikFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410038"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410038"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:05 -0800
IronPort-SDR: YSowsfb0gkqGsaTiZQuJSKr8TfV7PdtFN3V8zLg75miiBfviUT6hAjuTQ5tIz2I9W5QxqQknRM
 C9tDXcdqYNHg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528025"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:05 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 28/67] KVM: x86: Introduce vm_teardown() hook in kvm_arch_vm_destroy()
Date:   Mon, 16 Nov 2020 10:26:13 -0800
Message-Id: <54b79b2f3571737c0fa7ae516212eef6cc056ccc.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
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
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          |  8 +++++++-
 arch/x86/kvm/vmx/vmx.c          | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32e995327944..a6c89666ec49 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1100,6 +1100,7 @@ struct kvm_x86_ops {
 	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
+	void (*vm_teardown)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 241a26e1fa71..15836446a9b8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4155,12 +4155,17 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
 }
 
-static void svm_vm_destroy(struct kvm *kvm)
+static void svm_vm_teardown(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
 	sev_vm_destroy(kvm);
 }
 
+static void svm_vm_destroy(struct kvm *kvm)
+{
+
+}
+
 static bool svm_is_vm_type_supported(unsigned long type)
 {
 	return type == KVM_X86_LEGACY_VM;
@@ -4195,6 +4200,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.is_vm_type_supported = svm_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
+	.vm_teardown = svm_vm_teardown,
 	.vm_destroy = svm_vm_destroy,
 
 	.prepare_guest_switch = svm_prepare_guest_switch,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2ee7eb7dac26..3559b51f566d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7010,6 +7010,16 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static void vmx_vm_teardown(struct kvm *kvm)
+{
+
+}
+
+static void vmx_vm_destroy(struct kvm *kvm)
+{
+
+}
+
 static int __init vmx_check_processor_compat(void)
 {
 	struct vmcs_config vmcs_conf;
@@ -7611,6 +7621,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
+	.vm_teardown = vmx_vm_teardown,
+	.vm_destroy = vmx_vm_destroy,
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b8bbdc98492..42bd24ba7fdd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10533,10 +10533,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
-	if (kvm_x86_ops.vm_destroy)
-		kvm_x86_ops.vm_destroy(kvm);
 	for (i = 0; i < kvm->arch.msr_filter.count; i++)
 		kfree(kvm->arch.msr_filter.ranges[i].bitmap);
+	kvm_x86_ops.vm_teardown(kvm);
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_free_vcpus(kvm);
@@ -10545,6 +10544,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_mmu_uninit_vm(kvm);
 	kvm_page_track_cleanup(kvm);
 	kvm_hv_destroy_vm(kvm);
+	kvm_x86_ops.vm_destroy(kvm);
 }
 
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
-- 
2.17.1

