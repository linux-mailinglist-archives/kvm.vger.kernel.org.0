Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269056B690E
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 18:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjCLR6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 13:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjCLR5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:57:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDF73B23D;
        Sun, 12 Mar 2023 10:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643872; x=1710179872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=32s2P8H+gnoxbsUumRwADFSJrD2gilacQVr+hHcznH4=;
  b=XfZAQ/c+kF3oSPQ58l4VqO0EVQr0RqWO+aKBhERjsMlyjRF/PgTy2NZT
   rwX+vnhdW+Q3eQX3mbn7A5A/S2s2nK3SGfnmqsMUW2aucG6OCrGEg1Gz+
   huG1z5W4p/xmZfzgPoH2ave4BKavRymFSXhyGjgXKop+dPXSs4orn46KO
   UhlpcCVHY6hHMImyBFconU4UvgGz0uP8sFoNFKvSARM+3XU80FABN/RZk
   VYf4PEjw9NBzxWXNhDbTPveTDoWN8hWNG971Wc9+iz0HlbpqTouR39HWF
   gsxWBedya7vLSK0yOOajfRI+IxTRWbR/9tERGroJ7MHTyRkTKqCaAsx4G
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320863561"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320863561"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628396917"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628396917"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v13 006/113] KVM: x86: Introduce vm_type to differentiate default VMs from confidential VMs
Date:   Sun, 12 Mar 2023 10:55:30 -0700
Message-Id: <78dac4d2133a7c48b2da21a8f9e0922ad38c3f7b.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
that have VM types already.  Other arch KVMs use different names to query
supported vm types and there is no common name for it, so new name was
chosen.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst        | 4 +++-
 arch/x86/include/asm/kvm-x86-ops.h    | 1 +
 arch/x86/include/asm/kvm_host.h       | 1 +
 arch/x86/kvm/svm/svm.c                | 7 +++++++
 arch/x86/kvm/vmx/main.c               | 1 +
 arch/x86/kvm/vmx/vmx.c                | 5 +++++
 arch/x86/kvm/vmx/x86_ops.h            | 1 +
 arch/x86/kvm/x86.c                    | 8 +++++++-
 arch/x86/kvm/x86.h                    | 2 ++
 tools/arch/x86/include/uapi/asm/kvm.h | 3 +++
 10 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 15754ef8470f..7a34efd31dcc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -150,7 +150,9 @@ You probably want to use 0 as machine type.
 X86:
 ^^^^
 
-Supported X86 VM types can be queried via KVM_CAP_VM_TYPES.
+Supported X86 VM types can be queried via KVM_CAP_VM_TYPES, which returns the
+bitmap of supported vm types. The 1-setting of bit @n means vm type with value
+@n is supported.
 
 S390:
 ^^^^^
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8dc345cc6318..eac4b65d1b01 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
+KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_OPTIONAL(vm_destroy)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d9fc5a1c7442..00c25f6ab871 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1561,6 +1561,7 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
+	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 252e7f37e4e2..687df130fbad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4682,6 +4682,12 @@ static void svm_vm_destroy(struct kvm *kvm)
 	sev_vm_destroy(kvm);
 }
 
+static bool svm_is_vm_type_supported(unsigned long type)
+{
+	/* FIXME: Check if CPU is capable of SEV. */
+	return __kvm_is_vm_type_supported(type);
+}
+
 static int svm_vm_init(struct kvm *kvm)
 {
 	if (!pause_filter_count || !pause_filter_thresh)
@@ -4710,6 +4716,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
 
+	.is_vm_type_supported = svm_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5bc31c41bea9..e36d392c2d40 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -58,6 +58,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 	.vm_destroy = vmx_vm_destroy,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d23830d92f61..8134c77860d4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7486,6 +7486,11 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
index 010d02c86ba4..30961fdbce10 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -32,6 +32,7 @@ void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
+bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2125fcaa3973..27ab684f8374 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4356,12 +4356,18 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static bool kvm_is_vm_type_supported(unsigned long type)
+bool __kvm_is_vm_type_supported(unsigned long type)
 {
 	return type == KVM_X86_DEFAULT_VM ||
 	       (type == KVM_X86_PROTECTED_VM &&
 	        IS_ENABLED(CONFIG_KVM_PROTECTED_VM) && tdp_enabled);
 }
+EXPORT_SYMBOL_GPL(__kvm_is_vm_type_supported);
+
+static bool kvm_is_vm_type_supported(unsigned long type)
+{
+	return static_call(kvm_x86_is_vm_type_supported)(type);
+}
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8167b47b8c8..ef1282c7de8d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,8 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+bool __kvm_is_vm_type_supported(unsigned long type);
+
 struct kvm_caps {
 	/* control of guest tsc rate supported? */
 	bool has_tsc_control;
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 7f467fe05d42..6afbfbb32d56 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -559,4 +559,7 @@ struct kvm_pmu_event_filter {
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+#define KVM_X86_DEFAULT_VM	0
+#define KVM_X86_PROTECTED_VM	1
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.25.1

