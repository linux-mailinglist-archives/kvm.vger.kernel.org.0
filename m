Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32128714294
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjE2EVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjE2EUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:20:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E3CB1;
        Sun, 28 May 2023 21:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334048; x=1716870048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GuNOrupytTWVtg3vLUyBeqrjZ+dJXBxIM2lAIA1J8Cg=;
  b=YyDvEd0x8oLu5IDBuUGRIit4pwDPsqYYrMsIDmrgP96rUaHXq2OcPyEx
   2GjQPjcakKV/bwVqU6dkUGvO218s6YKARAhVXTvtPHpH9y+SKJelDH2Rq
   bOUUwjcelSUUsrz+jLxg1GtoCAOGpUmJpUC+w77ngdPJxYGUsMHeO14c4
   OMQ+o3pbkPvq88ehTzrV5GjPY+hKTvF5Km7MyZPGzhNjj3Ur42VimcoCt
   hNv4N74C15iDGyOs7JDDoMU6+KeQMeNtOkZ99JMhIour32THnc9k2pg5M
   gt4A17AAS1BPKOm/bBkrOLWqWzHBOtiDzG67CR97DTrN9c31vCHMvVCUK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="418094258"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="418094258"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="683419301"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="683419301"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:45 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v14 006/113] KVM: x86: Introduce vm_type to differentiate default VMs from confidential VMs
Date:   Sun, 28 May 2023 21:18:48 -0700
Message-Id: <388177ea5e260c7df38a6b1c64f7af27416bfb41.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 9e2408941659..14a599aadb58 100644
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
index 13bc212cd4bc..c0143906fe6d 100644
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
index 8ed20ff1e697..c00bec29e787 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1543,6 +1543,7 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
+	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca32389f3c36..590fbb7c1fc6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4791,6 +4791,12 @@ static void svm_vm_destroy(struct kvm *kvm)
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
@@ -4819,6 +4825,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
 
+	.is_vm_type_supported = svm_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 72c6a78eaed4..19bba6d05f45 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -59,6 +59,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 	.vm_destroy = vmx_vm_destroy,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9e4def64495b..b423b2e58b53 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7459,6 +7459,11 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
index f59e5197836a..b96048828745 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -30,6 +30,7 @@ void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
+bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8d4459a53934..95ceddaf514c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4420,12 +4420,18 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
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
index c544602d07a3..7d5aa8f0571a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -9,6 +9,8 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+bool __kvm_is_vm_type_supported(unsigned long type);
+
 struct kvm_caps {
 	/* control of guest tsc rate supported? */
 	bool has_tsc_control;
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 1a6a1f987949..3e92f1057b51 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -562,4 +562,7 @@ struct kvm_pmu_event_filter {
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
 #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
 
+#define KVM_X86_DEFAULT_VM	0
+#define KVM_X86_PROTECTED_VM	1
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.25.1

