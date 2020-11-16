Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21872B4FCA
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388592AbgKPSdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:33:20 -0500
Received: from mga06.intel.com ([134.134.136.31]:20631 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732986AbgKPS2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:00 -0500
IronPort-SDR: l/3V7HYxsx1qJ6wJ0jVQXwNhW1mB085A2zFN3c+gTedQvo4hjWwDqb8x462jC68x1rnNZlUCCR
 g+aDcp4HpeWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410013"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410013"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:59 -0800
IronPort-SDR: no8lWM01D+Mlc0XWjfWSQpaZ3zAQ6POduMmX4kjePNnbjoo1RPwFtpQ8ZiMkbaV6VDbPXTojPV
 Z5RPIMGF+pEA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527880"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:59 -0800
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH 15/67] KVM: x86: Add vm_type to differentiate legacy VMs from protected VMs
Date:   Mon, 16 Nov 2020 10:26:00 -0800
Message-Id: <e4879f4528d8e282d8b10c3dbc5526fa88b93e62.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a capability to effectively allow userspace to query what VM types
are supported by KVM.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h       | 2 ++
 arch/x86/include/uapi/asm/kvm.h       | 4 ++++
 arch/x86/kvm/svm/svm.c                | 6 ++++++
 arch/x86/kvm/vmx/vmx.c                | 6 ++++++
 arch/x86/kvm/x86.c                    | 9 ++++++++-
 include/uapi/linux/kvm.h              | 2 ++
 tools/arch/x86/include/uapi/asm/kvm.h | 4 ++++
 tools/include/uapi/linux/kvm.h        | 2 ++
 8 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c2639744ea09..1ff33efd6394 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -897,6 +897,7 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_X2APIC	5
 
 struct kvm_arch {
+	unsigned long vm_type;
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
@@ -1090,6 +1091,7 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
+	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 89e5f3d1bba8..29cdf262e516 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -486,4 +486,8 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_X86_LEGACY_VM	0
+#define KVM_X86_SEV_ES_VM	1
+#define KVM_X86_TDX_VM		2
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e001e3c9e4bc..11ab330a9b55 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4161,6 +4161,11 @@ static void svm_vm_destroy(struct kvm *kvm)
 	sev_vm_destroy(kvm);
 }
 
+static bool svm_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_LEGACY_VM;
+}
+
 static int svm_vm_init(struct kvm *kvm)
 {
 	if (!pause_filter_count || !pause_filter_thresh)
@@ -4187,6 +4192,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_free = svm_free_vcpu,
 	.vcpu_reset = svm_vcpu_reset,
 
+	.is_vm_type_supported = svm_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0703d82e7bad..b3ecdb96789a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6966,6 +6966,11 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	return err;
 }
 
+static bool vmx_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_LEGACY_VM;
+}
+
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
@@ -7603,6 +7608,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19b53aedc6c8..346394d83672 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3771,6 +3771,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_STEAL_TIME:
 		r = sched_info_on();
 		break;
+	case KVM_CAP_VM_TYPES:
+		r = BIT(KVM_X86_LEGACY_VM);
+		if (kvm_x86_ops.is_vm_type_supported(KVM_X86_TDX_VM))
+			r |= BIT(KVM_X86_TDX_VM);
+		break;
 	default:
 		break;
 	}
@@ -10249,9 +10254,11 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
-	if (type)
+	if (!kvm_x86_ops.is_vm_type_supported(type))
 		return -EINVAL;
 
+	kvm->arch.vm_type = type;
+
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..c603e9a004f1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1054,6 +1054,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_MSR_FILTER 189
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 
+#define KVM_CAP_VM_TYPES 1000
+
 #ifdef KVM_CAP_IRQ_ROUTING
 
 struct kvm_irq_routing_irqchip {
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 0780f97c1850..44313ac967dd 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -466,4 +466,8 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_X86_LEGACY_VM	0
+#define KVM_X86_SEV_ES_VM	1
+#define KVM_X86_TDX_VM		2
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 7d8eced6f459..b043b01f0d87 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1038,6 +1038,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_STEAL_TIME 187
 
+#define KVM_CAP_VM_TYPES 1000
+
 #ifdef KVM_CAP_IRQ_ROUTING
 
 struct kvm_irq_routing_irqchip {
-- 
2.17.1

