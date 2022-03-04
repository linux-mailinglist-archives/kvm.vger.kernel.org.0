Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9404CDEBE
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiCDUGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiCDUF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:05:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0DA291CC3;
        Fri,  4 Mar 2022 12:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424055; x=1677960055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EhG2TlETTqdg7t4BLg4FzDbSlRgG9OzbfNlqLZO3CTI=;
  b=AmgtfHmjDTG00yLdzGJlbKEExCM5qpdub7UOLhzEnbpyG/2R1JwHINVI
   ATFp7Gqqp8oJ4lYI0C9MogZHb0oDajIjrQiA10Jq2BJwmB+WPF9JJjFM6
   KHnYMyAUM7rrZLrM60eCfnjE1c1qP1sSNO41yMrAlJEa3TDUF2tJIzqGD
   1W7ToF1K7pvDrlnKvCLGU6Jun+7Nc5dvSueFWhsfhVwo4rc5P02qg4E2K
   BWsM4AxUCFj5DUeH0GPBLDNWzuAEc2HnBMMlsAFPGZFz0TKmHfg1HXXx5
   ImwThfaJQUPnkfIgobgq515ec2/X/i3SOkB1hKUugGAs1ieTzeYkPfZrU
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983313"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983313"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344111"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:05 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 009/104] KVM: x86: Introduce vm_type to differentiate default VMs from confidential VMs
Date:   Fri,  4 Mar 2022 11:48:25 -0800
Message-Id: <262b01c1cfe8c1dc6463773eabacfc1d01a3e651.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Unlike default VMs, confidential VMs (Intel TDX and AMD SEV-ES) don't allow
some operations (e.g., memory read/write, register state access, etc).

Introduce vm_type to track the type of the VM to x86 KVM.  Other arch KVMs
already use vm_type, KVM_INIT_VM accepts vm_type, and x86 KVM callback
vm_init accepts vm_type.  So follow them.  Further, a different policy can
be made based on vm_type.  Define KVM_X86_DEFAULT_VM for default VM as
default and define KVM_X86_TDX_VM for Intel TDX VM.  The wrapper function
will be defined as "bool is_td(kvm) { return vm_type == VM_TYPE_TDX; }"

Add a capability KVM_CAP_VM_TYPES to effectively allow device model,
e.g. qemu, to query what VM types are supported by KVM.  This (introduce a
new capability and add vm_type) is chosen to align with other arch KVMs
that have VM types already.  Other arch KVMs uses different name to query
supported vm types and there is no common name for it, so new name was
chosen.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/api.rst        | 15 +++++++++++++++
 arch/x86/include/asm/kvm-x86-ops.h    |  1 +
 arch/x86/include/asm/kvm_host.h       |  2 ++
 arch/x86/include/uapi/asm/kvm.h       |  3 +++
 arch/x86/kvm/svm/svm.c                |  6 ++++++
 arch/x86/kvm/vmx/main.c               |  1 +
 arch/x86/kvm/vmx/tdx.h                |  6 +-----
 arch/x86/kvm/vmx/vmx.c                |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h            |  1 +
 arch/x86/kvm/x86.c                    |  9 ++++++++-
 include/uapi/linux/kvm.h              |  1 +
 tools/arch/x86/include/uapi/asm/kvm.h |  3 +++
 tools/include/uapi/linux/kvm.h        |  1 +
 13 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f3172376ec3..b1e142719ec0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -147,15 +147,30 @@ described as 'basic' will be available.
 The new VM has no virtual cpus and no memory.
 You probably want to use 0 as machine type.
 
+X86:
+^^^^
+
+Supported vm type can be queried from KVM_CAP_VM_TYPES, which returns the
+bitmap of supported vm types. The 1-setting of bit @n means vm type with
+value @n is supported.
+
+S390:
+^^^^^
+
 In order to create user controlled virtual machines on S390, check
 KVM_CAP_S390_UCONTROL and use the flag KVM_VM_S390_UCONTROL as
 privileged user (CAP_SYS_ADMIN).
 
+MIPS:
+^^^^^
+
 To use hardware assisted virtualization on MIPS (VZ ASE) rather than
 the default trap & emulate implementation (which changes the virtual
 memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
 flag KVM_VM_MIPS_VZ.
 
+ARM64:
+^^^^^^
 
 On arm64, the physical address size for a VM (IPA Size limit) is limited
 to 40bits by default. The limit can be configured if the host supports the
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index d39e0de06be2..8125d43d3566 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -18,6 +18,7 @@ KVM_X86_OP_NULL(hardware_unsetup)
 KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
+KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_NULL(vm_destroy)
 KVM_X86_OP(vcpu_create)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b61e46743184..8de357a9ad30 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1048,6 +1048,7 @@ struct kvm_x86_msr_filter {
 #define APICV_INHIBIT_REASON_ABSENT	7
 
 struct kvm_arch {
+	unsigned long vm_type;
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
@@ -1322,6 +1323,7 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
+	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf6e96011dfe..71a5851475e7 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -525,4 +525,7 @@ struct kvm_pmu_event_filter {
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+#define KVM_X86_DEFAULT_VM	0
+#define KVM_X86_TDX_VM		1
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fd3a00c892c7..778075b71dc3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4512,6 +4512,11 @@ static void svm_vm_destroy(struct kvm *kvm)
 	sev_vm_destroy(kvm);
 }
 
+static bool svm_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_DEFAULT_VM;
+}
+
 static int svm_vm_init(struct kvm *kvm)
 {
 	if (!pause_filter_count || !pause_filter_thresh)
@@ -4539,6 +4544,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_free = svm_free_vcpu,
 	.vcpu_reset = svm_vcpu_reset,
 
+	.is_vm_type_supported = svm_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 28a7597d0782..77da926ee505 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -29,6 +29,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index d448e019602c..616fbf79b129 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -15,11 +15,7 @@ struct vcpu_tdx {
 
 static inline bool is_td(struct kvm *kvm)
 {
-	/*
-	 * TDX VM type isn't defined yet.
-	 * return kvm->arch.vm_type == KVM_X86_TDX_VM;
-	 */
-	return false;
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
 
 static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7838cd177f0e..3c7b3f245fee 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7079,6 +7079,11 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
+bool vmx_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_DEFAULT_VM;
+}
+
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 1bad27e592b5..f7327bc73be0 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -25,6 +25,7 @@ void vmx_hardware_unsetup(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
 bool report_flexpriority(void);
+bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 int vmx_vcpu_create(struct kvm_vcpu *vcpu);
 int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa2942060154..f6438750d190 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4344,6 +4344,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = sizeof(struct kvm_xsave);
 		break;
 	}
+	case KVM_CAP_VM_TYPES:
+		r = BIT(KVM_X86_DEFAULT_VM);
+		if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
+			r |= BIT(KVM_X86_TDX_VM);
+		break;
 	default:
 		break;
 	}
@@ -11583,9 +11588,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	int ret;
 	unsigned long flags;
 
-	if (type)
+	if (!static_call(kvm_x86_is_vm_type_supported)(type))
 		return -EINVAL;
 
+	kvm->arch.vm_type = type;
+
 	ret = kvm_page_track_init(kvm);
 	if (ret)
 		return ret;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 507ee1f2aa96..bb3e29770f76 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1135,6 +1135,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
 #define KVM_CAP_PPC_AIL_MODE_3 210
+#define KVM_CAP_VM_TYPES 21
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index bf6e96011dfe..71a5851475e7 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -525,4 +525,7 @@ struct kvm_pmu_event_filter {
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+#define KVM_X86_DEFAULT_VM	0
+#define KVM_X86_TDX_VM		1
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 507ee1f2aa96..1a99d0aae852 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1135,6 +1135,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
 #define KVM_CAP_PPC_AIL_MODE_3 210
+#define KVM_CAP_VM_TYPES 211
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.1

