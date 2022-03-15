Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704B44DA5B5
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 23:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352405AbiCOWve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 18:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352377AbiCOWva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 18:51:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449A45D1B8;
        Tue, 15 Mar 2022 15:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647384617; x=1678920617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PgaT9mB9xoUvv8y7xzREbtfBG6Jfb2pjJN0zDMM4jLg=;
  b=gytEoER/S/10e5Upu1O5gBxTJMNBpOhtbyR17u//H7YpNLcD4IbGwET3
   5nr3NB4uXNfwMiv4oXPVJ00NF17E0hd//9psPiOPc7a9qjdix76GnWw2i
   /IH7MOPpvqOaDEKDvU45tkRGuMiMLMoZJBKafY/7/z20jnZ86OIynJfHC
   ZhGgVn8xiS4/BCyOT9hKhH+3gdIQB4XIuhsL5SqBqA+vYhUAFMC4u28oY
   53/0qzd4tAj5UGahgI//n8FxtCH7VkzFZ1wFPMFIuXFJwRwlxsYi1+4zh
   7W5WZ+SJImkNFJzlALOMTBzJUWL5+EXiZjSXq4gWvCBLgY8xlWzc5qIou
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256390619"
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="256390619"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:50:13 -0700
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="690368468"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:50:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5/6] KVM: x86: Introduce vm_type to differentiate default VMs from confidential VMs
Date:   Tue, 15 Mar 2022 15:50:09 -0700
Message-Id: <9780952e0c91eb6a7eb5a1ec1b8850ee38338785.1647384148.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1647384147.git.isaku.yamahata@intel.com>
References: <cover.1647384147.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
introduced.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
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
index ec9830d2aabf..f1d2f21a8c87 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1047,6 +1047,7 @@ struct kvm_x86_msr_filter {
 #define APICV_INHIBIT_REASON_ABSENT	7
 
 struct kvm_arch {
+	unsigned long vm_type;
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
@@ -1321,6 +1322,7 @@ struct kvm_x86_ops {
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
index 7acbb317caa8..459087fcf7b7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -17,6 +17,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 060bf48ec3d6..473013265bd8 100644
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
index 538b91380c06..191e653355dd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7085,6 +7085,11 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
index 74465c3d3c5f..e0a4c6438c88 100644
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
index eb4029660bd9..fcd250c4647c 100644
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
@@ -11584,9 +11589,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
index 507ee1f2aa96..1a99d0aae852 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1135,6 +1135,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
 #define KVM_CAP_PPC_AIL_MODE_3 210
+#define KVM_CAP_VM_TYPES 211
 
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

