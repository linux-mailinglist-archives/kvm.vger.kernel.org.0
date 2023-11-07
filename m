Return-Path: <kvm+bounces-913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F42167E4260
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A84032812A7
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877983589F;
	Tue,  7 Nov 2023 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jkitLa8V"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41881347AC
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:57:56 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB23122;
	Tue,  7 Nov 2023 06:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369074; x=1730905074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uWltnmYzfs7BObRXLFLXx3+4exGGkdrWvG4bNNpVL6U=;
  b=jkitLa8V0nYGL6Erw9GvtUg4snkfBdtU2Voig+Iz+pm1B69MfV7LeZXY
   P6j1xO8FgQ2780cOiLvO7S/R5WJtlbq5sCp3YWzVqe1Bt0KQ2kT3yxCNH
   cSwC7rO5gqXIJCLftqXxDg5PRvr8Gc6cA7wjV0PucBFlfvunH/wY72lvI
   pfAix+bEZ5I9bdDP2sIH4QwG3tSO+o9L5uMc/2n+nN48v4FapmxbuUFkw
   Z/r3QJXOJ5bYedCqkBngnIT4qN9Kip/3Wdx1zASBGvhLvdjmVGF+cT/Su
   yZlWpDFSwfvWnOmpeAzIjR1ch3Z7IGn5Nm4Gry6HeaJjn6wWzVEJlHfdJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555801"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555801"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10444072"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:53 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 019/116] KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS backend specific
Date: Tue,  7 Nov 2023 06:55:45 -0800
Message-Id: <376bdde3fac2fb13579b33b9db3d3d2bc2774ffa.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 arch/x86/kvm/vmx/x86_ops.h         |  5 +++++
 arch/x86/kvm/x86.c                 |  4 ++++
 7 files changed, 68 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 09abb53d92ea..b7b591f1ff72 100644
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
index 6509e967454a..f240c3d025b1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1574,7 +1574,9 @@ struct kvm_x86_ops {
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
+	int (*max_vcpus)(struct kvm *kvm);
 	unsigned int vm_size;
+	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a95bbd10c3d8..5a857c8defd9 100644
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
@@ -80,7 +100,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
+	.max_vcpus = vt_max_vcpus,
 	.vm_size = sizeof(struct kvm_vmx),
+	.vm_enable_cap = vt_vm_enable_cap,
 	.vm_init = vt_vm_init,
 	.vm_destroy = vmx_vm_destroy,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f9e80582865d..331fbaa10d46 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -17,6 +17,36 @@
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
index 473013265bd8..22c0b57f69ca 100644
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
index 6487884a8d8e..ee5d8a38e7f8 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -138,11 +138,16 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 bool tdx_is_vm_type_supported(unsigned long type);
 
+int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 
+static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	return -EINVAL;
+};
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ced75e9204b9..de6e6462e7f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4694,6 +4694,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
+		if (kvm_x86_ops.max_vcpus)
+			r = static_call(kvm_x86_max_vcpus)(kvm);
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_MAX_VCPU_IDS;
@@ -6641,6 +6643,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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


