Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF57142A6
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjE2EVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjE2EVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:21:09 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEF2CD;
        Sun, 28 May 2023 21:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334055; x=1716870055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Ejnejo1xxFZJOOxnD/7dsWsnDZDzanD+wMLc4cjIDA=;
  b=E+AxYYsg6Sf7L8aNmcF7bqUm182K33vrFDwM1A60XK55Eeqcg9USSOIr
   8UvQwM02hqynOcLgGYHE5FA4efBqucOEXO8WiWXbWhW53GJQvoPBUQMut
   qCLSxvoTgY/c3APlxOO5aijoeiOD9sw/ewaPkmNyAlLe+JPtoMRFE02gQ
   EVDB9Vhf5vucvx6yAlFkxEEald2Ur+nzizBtLKaLRRsv5MZB52L2FjItx
   yi9LZrEMHQr0wpHvIv0cu2a8RbkChCu+U+x5rJLCIpBV6u+kXKAqDY/ju
   D6S0CvH8ClGW5Nt8R1oAN1MoKMWwZRpO0j6rK+bRORtbW+6/EL44Sr+FU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="418094327"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="418094327"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="683419345"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="683419345"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 018/113] KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS backend specific
Date:   Sun, 28 May 2023 21:19:00 -0700
Message-Id: <ffc76f3e9acbce3a9810249e52f590b2b1058a1a.1685333727.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX has its own limitation on the maximum number of vcpus that the guest
can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/vmx/main.c            | 22 ++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c             | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h             |  3 +++
 arch/x86/kvm/vmx/x86_ops.h         |  2 ++
 arch/x86/kvm/x86.c                 |  4 ++++
 7 files changed, 65 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cc97fb9920c7..22e2136f8ccd 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -21,6 +21,8 @@ KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
+KVM_X86_OP_OPTIONAL(max_vcpus);
+KVM_X86_OP_OPTIONAL(vm_enable_cap)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_OPTIONAL(vm_destroy)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c00bec29e787..9260667b3cc4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1544,7 +1544,9 @@ struct kvm_x86_ops {
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
+	int (*max_vcpus)(struct kvm *kvm);
 	unsigned int vm_size;
+	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 857e82315049..cea0d32972a7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "tdx.h"
+#include "tdx_arch.h"
 
 static bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
@@ -16,6 +17,17 @@ static bool vt_is_vm_type_supported(unsigned long type)
 		(enable_tdx && tdx_is_vm_type_supported(type));
 }
 
+static int vt_max_vcpus(struct kvm *kvm)
+{
+	if (!kvm)
+		return KVM_MAX_VCPUS;
+
+	if (is_td(kvm))
+		return min3(kvm->max_vcpus, KVM_MAX_VCPUS, TDX_MAX_VCPUS);
+
+	return kvm->max_vcpus;
+}
+
 static int vt_hardware_enable(void)
 {
 	int ret;
@@ -43,6 +55,14 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	if (is_td(kvm))
+		return tdx_vm_enable_cap(kvm, cap);
+
+	return -EINVAL;
+}
+
 static int vt_vm_init(struct kvm *kvm)
 {
 	if (is_td(kvm))
@@ -82,7 +102,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
+	.max_vcpus = vt_max_vcpus,
 	.vm_size = sizeof(struct kvm_vmx),
+	.vm_enable_cap = vt_vm_enable_cap,
 	.vm_init = vt_vm_init,
 	.vm_destroy = vmx_vm_destroy,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cf320459574f..4d58bb3333a7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -16,6 +16,36 @@
 		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
 		/ sizeof(struct tdx_cpuid_config))
 
+int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	int r;
+
+	switch (cap->cap) {
+	case KVM_CAP_MAX_VCPUS: {
+		if (cap->flags || cap->args[0] == 0)
+			return -EINVAL;
+		if (cap->args[0] > KVM_MAX_VCPUS)
+			return -E2BIG;
+		if (cap->args[0] > TDX_MAX_VCPUS)
+			return -E2BIG;
+
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			r = -EBUSY;
+		else {
+			kvm->max_vcpus = cap->args[0];
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		break;
+	}
+	default:
+		r = -EINVAL;
+		break;
+	}
+	return r;
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 2210c8c1e893..3860aa351bd9 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,6 +3,9 @@
 #define __KVM_X86_TDX_H
 
 #ifdef CONFIG_INTEL_TDX_HOST
+
+#include "tdx_ops.h"
+
 struct kvm_tdx {
 	struct kvm kvm;
 	/* TDX specific members follow. */
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 504a269d3e25..dc0a9d5c2cf6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -139,11 +139,13 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 bool tdx_is_vm_type_supported(unsigned long type);
 
+int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 
+static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap) { return -EINVAL; };
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f08b75da4419..38801728c047 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4565,6 +4565,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
+		if (kvm_x86_ops.max_vcpus)
+			r = static_call(kvm_x86_max_vcpus)(kvm);
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_MAX_VCPU_IDS;
@@ -6494,6 +6496,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	default:
 		r = -EINVAL;
+		if (kvm_x86_ops.vm_enable_cap)
+			r = static_call(kvm_x86_vm_enable_cap)(kvm, cap);
 		break;
 	}
 	return r;
-- 
2.25.1

