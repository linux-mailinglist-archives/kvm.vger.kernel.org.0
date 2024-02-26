Return-Path: <kvm+bounces-9661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC78866C8A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 647C41F21232
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CC45D49F;
	Mon, 26 Feb 2024 08:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vi/SzKHI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF775A7B6;
	Mon, 26 Feb 2024 08:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936085; cv=none; b=c1DD+m7uSZV9CP4mcnpn1SXsnGRrqwplUR+lVmseajTyGq8ARySqU/gxkYDEjObzZqGOfKFbNQTQ6FRMwRFAUAk6YkAIMUUCBCY5M/PzVLzD/ayaknEu3hzyMhqW1S3dbTFKLKSZr57nv7a9q2xPWRdM2Oybd1dIM8H+aBH/e1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936085; c=relaxed/simple;
	bh=L+VqlxX10T0o55WrNVdRU8lzKiSJUabdBC/i3CdqN64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jl6YvDi9W2VjWwzor+FuQJmLD7T143x8wVFI0gMP8kKILoYpvtxLMvY0Cq3jetUSpCc4cwSOsuopCWgwBE7iIaxBiy0OlXIG4ihxwpA95IT4SVGzNyTzuMehEkgNFvWW+ckMhKH68Utn0lztAAhCP6Usgj+gQzOIE3zeHE2NqQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vi/SzKHI; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936083; x=1740472083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L+VqlxX10T0o55WrNVdRU8lzKiSJUabdBC/i3CdqN64=;
  b=Vi/SzKHIOtY09RfVFqJMxHgtvTp0fpARUV6TvHOWtFNH/j9Jmpv7IOcR
   DVuAc3ni/uRJSTVhy936TuoaB0KzI0uexDfMUBF3NdEtNZJ3Il3T8oJgo
   ntjLOzcfePndo4Dam/KGKNweus4z39HWvoTYn+0V1INJchEYkNRUwilmV
   WttPd5CvAA950kdxoowlhG2W3MU6KBDurS6doa93Q/uHFPbVlIQKMdJtW
   R5N8g4GLvTVigkGrjD83FthREv9zvwg/UIvtgEKJMJr7TUXyMrMJmRZeO
   v1AXVmaHv2UNYcQPAZot0plp4kcmK+6rEaFMesi+wGnktlTcpGepMJFwm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155312"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155312"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615645"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:01 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend specific
Date: Mon, 26 Feb 2024 00:25:39 -0800
Message-Id: <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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

When creating TD (TDH.MNG.INIT), the maximum number of vcpu needs to be
specified as struct td_params_struct.  and the value is a part of
measurement.  The user space has to specify the value somehow.  There are
two options for it.
option 1. API (Set KVM_CAP_MAX_VCPU) to specify the value (this patch)
option 2. Add max_vcpu as a parameter to initialize the guest.
          (TDG.MNG.INIT)

The flow will be create VM (KVM_CREATE_VM), create VCPUs (KVM_CREATE_VCPU),
initialize TDX part of VM and, initialize TDX part of vcpu.
Because the creation of vcpu is independent from TDX VM initialization,
Choose the option 1.
The work flow will be, KVM_CREATE_VM, set KVM_CAP_MAX_VCPU and,
KVM_CREATE_VCPU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- use TDX instead of "x86, tdx" in subject
- use min(max_vcpu, TDX_MAX_VCPU) instead of
  min3(max_vcpu, KVM_MAX_VCPU, TDX_MAX_VCPU)
- make "if (KVM_MAX_VCPU) and if (TDX_MAX_VCPU)" into one if statement
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/vmx/main.c            | 22 ++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c             | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  5 +++++
 arch/x86/kvm/x86.c                 |  4 ++++
 6 files changed, 64 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 00b371d9a1ca..1b0dacc6b6c0 100644
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
index 37cda8aa07b6..cf8eb46b3a20 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1604,7 +1604,9 @@ struct kvm_x86_ops {
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
+	int (*max_vcpus)(struct kvm *kvm);
 	unsigned int vm_size;
+	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 082e82ce6580..e8a1a7533eea 100644
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
+		return min(kvm->max_vcpus, TDX_MAX_VCPUS);
+
+	return kvm->max_vcpus;
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -39,6 +51,14 @@ static void vt_hardware_unsetup(void)
 	vmx_hardware_unsetup();
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
@@ -77,7 +97,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
+	.max_vcpus = vt_max_vcpus,
 	.vm_size = sizeof(struct kvm_vmx),
+	.vm_enable_cap = vt_vm_enable_cap,
 	.vm_init = vt_vm_init,
 	.vm_destroy = vmx_vm_destroy,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 816ccdb4bc41..ee015f3ce2c9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -56,6 +56,35 @@ struct tdx_info {
 /* Info about the TDX module. */
 static struct tdx_info *tdx_info;
 
+int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	int r;
+
+	switch (cap->cap) {
+	case KVM_CAP_MAX_VCPUS: {
+		if (cap->flags || cap->args[0] == 0)
+			return -EINVAL;
+		if (cap->args[0] > KVM_MAX_VCPUS ||
+		    cap->args[0] > TDX_MAX_VCPUS)
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
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f6c57ad44f80..0031a8d61589 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -139,12 +139,17 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 void tdx_hardware_unsetup(void);
 bool tdx_is_vm_type_supported(unsigned long type);
 
+int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 
+static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+	return -EINVAL;
+};
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c459a5e9e520..3f16e9450d2f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4726,6 +4726,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
+		if (kvm_x86_ops.max_vcpus)
+			r = static_call(kvm_x86_max_vcpus)(kvm);
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_MAX_VCPU_IDS;
@@ -6709,6 +6711,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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


