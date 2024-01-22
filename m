Return-Path: <kvm+bounces-6596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A1383791E
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:29:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AD261C280FB
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED425A792;
	Mon, 22 Jan 2024 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ggX2WGHh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6F259168;
	Mon, 22 Jan 2024 23:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967712; cv=none; b=c1Xx9byd5QeW4PvU3CjePqXA1z5WtUqrAo6C2JgzqE0M+zOf2jUfv+ZNwc79SWihkH04qC/PIjh71o/JeBeowjQf55afF717QO4qpBeANylAHQOFOURm7LUQEVb2BWRO4AiQhmHN/PCauodg2mbnveFK7ZXJGTXgtUSBo8Aakns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967712; c=relaxed/simple;
	bh=u8CBzHeXNtJ5wZuIzxt5cMq0Z6ffGX8b1vUuEX2TZTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iwDbXIJONA2S08zwR4uoct+aP1DfgOGg+Nv+XEoY8B1BBl689j0tqHLpA3KBJrKBRAh9Fz2fl0nB4wTSNwyg9LbCGZAoFV/hqX4n9Vl8fp0vLVy7xanCh6fzoei8B/oYrLqfRJz7agRYpG2I+lIIwRDnBrg2gLHfcM3n/fpV/XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ggX2WGHh; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967710; x=1737503710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u8CBzHeXNtJ5wZuIzxt5cMq0Z6ffGX8b1vUuEX2TZTs=;
  b=ggX2WGHhRuP8OWh9pitDK+zmgKfZBhUZ1aM3X5kM66IUaz1VLZX1HhD2
   GdaqZSDjIaLdWeRifgthpqs2oWBH+gFA/68nLxaASpcpsCAoQIDoKfyCn
   yS8AymLhimr4mtqvyd1ntdesjLRDSZxzdLuclb4FIHDpkSbc5Mm1UkkS2
   eprI4oII/b5Z3FCj8aXP8tMpQkA8anhe0E1mdMpMsovZUCFl5ru3EZ57i
   5pOTfHH9D5d/6tfr7+zZkDSvgPqxKO5rbkjOPJfLKxCgh7OE7Nrshlysk
   ueX2/+MeRyTTjH9jcq3Mlir8JKawZYUNsPbT0c80iUjKmrYxyiJbrPrzi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243797"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243797"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888503"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888503"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:08 -0800
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
Subject: [PATCH v18 023/121] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend specific
Date: Mon, 22 Jan 2024 15:52:59 -0800
Message-Id: <ed33ebe29b231e8e657cd610a983fa603b10f530.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index 943b21b8b106..2f976c0f3116 100644
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
index 26f4668b0273..db44a92e5659 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1602,7 +1602,9 @@ struct kvm_x86_ops {
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
+	int (*max_vcpus)(struct kvm *kvm);
 	unsigned int vm_size;
+	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 50da807d7aea..4611f305a450 100644
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
 static int vt_hardware_enable(void)
 {
 	int ret;
@@ -54,6 +66,14 @@ static void vt_hardware_unsetup(void)
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
@@ -91,7 +111,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
+	.max_vcpus = vt_max_vcpus,
 	.vm_size = sizeof(struct kvm_vmx),
+	.vm_enable_cap = vt_vm_enable_cap,
 	.vm_init = vt_vm_init,
 	.vm_destroy = vmx_vm_destroy,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8c463407f8a8..876ad7895b88 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -100,6 +100,35 @@ struct tdx_info {
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
index 6e238142b1e8..3a3be66888da 100644
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
index dd3a23d56621..a1389ddb1b33 100644
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
@@ -6683,6 +6685,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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


