Return-Path: <kvm+bounces-9659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C1E866C86
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E2AA1F2168F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25265C5F4;
	Mon, 26 Feb 2024 08:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YkJ6wtO/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8562659B62;
	Mon, 26 Feb 2024 08:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936084; cv=none; b=Y8+3Zm7lymClEg9HEBsyuSXYIIagcQME9VMmh20q5DNUMBDQFkI0muCK9m9RuVMOu3i7eyD58xLzPRdaGB/gTz6eAk2e63bsYufGBqMd420xRqgVYw+JptOn7qcfbu66E+sZ5rR/WM59gQBqlIwSuEo+9PXX5GZ1Gf75TYIPUW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936084; c=relaxed/simple;
	bh=IbPdSA5+Gq2omZqSV56w9i5tpK2g28tpRmPxwftvXo8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QhGpcSMe4jKUKaMLJ+pDEjr9nE96LfmyKYL/oqPWwsKBxO73kggU7Di3R+JGKVNOQZtdJJmwosjRqDUyve5/nxn5pgSH6Yvdw3rzZ4DrBpdzkhnOLRwI6Ic8BYER/sqXDtRTVtQNmKiuPpWMrnGIfBdMyedaW2n0UcOwUHQqr6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YkJ6wtO/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936082; x=1740472082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IbPdSA5+Gq2omZqSV56w9i5tpK2g28tpRmPxwftvXo8=;
  b=YkJ6wtO/jWaMnq14wD8f/goh5nbMt4WBInp6R3fy20Jxv2Y93In9PzGf
   w21CwfsrHV1rgZ8Ns/lP2ooTZEG5oGWmb56wD+LHOwERhUebr+VT1bgar
   +B9WZpGoIqyLLu1T1kkWgY2QgfsQV0j1gJ4NgtDF0rL/foNnzx6GMD3mL
   vsyuYv4RecwM7HWpSIA0MeyTHYKkBRNKZ0XONzEpvWOrLYDXYudFFC5hQ
   QWWWjgOuqoMb1rbOD/6H188IHaO+8zmH988D5M7rgBa2gr8i3E0HJqS/J
   nK7zRTu0Du5mnPPXi2eGGcL3DMgw0HwXOiZyJS5cYb2FTcsqcCFPN9q3m
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155300"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155300"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615606"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:00 -0800
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
Subject: [PATCH v19 035/130] KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
Date: Mon, 26 Feb 2024 00:25:37 -0800
Message-Id: <079540d563ab0f5d8991ad4d3b1546c05dc2fb01.1708933498.git.isaku.yamahata@intel.com>
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

KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
guest state-protected VM.  It defined subcommands for technology-specific
operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
are not limited to memory encryption, but various technology-specific
operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
for TDX specific operations and define subcommands.

TDX requires VM-scoped TDX-specific operations for device model, for
example, qemu.  Getting system-wide parameters, TDX-specific VM
initialization.

Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
TDX specific sub-commands will be added to retrieve/pass TDX specific
parameters.  Make mem_enc_ioctl non-optional as it's always filled.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v15:
- change struct kvm_tdx_cmd to drop unused member.
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/uapi/asm/kvm.h    | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/main.c            | 10 ++++++++++
 arch/x86/kvm/vmx/tdx.c             | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  4 ++++
 arch/x86/kvm/x86.c                 |  4 ----
 6 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8be71a5c5c87..00b371d9a1ca 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -123,7 +123,7 @@ KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
-KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 45b2c2304491..9ea46d143bef 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -567,6 +567,32 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_TDX_VM		2
 #define KVM_X86_SNP_VM		3
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	/* enum kvm_tdx_cmd_id */
+	__u32 id;
+	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
+	__u32 flags;
+	/*
+	 * data for each sub-command. An immediate or a pointer to the actual
+	 * data in process virtual address.  If sub-command doesn't use it,
+	 * set zero.
+	 */
+	__u64 data;
+	/*
+	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+	 * status code in addition to -Exxx.
+	 * Defined for consistency with struct kvm_sev_cmd.
+	 */
+	__u64 error;
+};
+
 #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
 
 struct kvm_tdx_cpuid_config {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a948a6959ac7..082e82ce6580 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -47,6 +47,14 @@ static int vt_vm_init(struct kvm *kvm)
 	return vmx_vm_init(kvm);
 }
 
+static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
+{
+	if (!is_td(kvm))
+		return -ENOTTY;
+
+	return tdx_vm_ioctl(kvm, argp);
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -200,6 +208,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
+
+	.mem_enc_ioctl = vt_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5edfb99abb89..07a3f0f75f87 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -55,6 +55,32 @@ struct tdx_info {
 /* Info about the TDX module. */
 static struct tdx_info *tdx_info;
 
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_tdx_cmd tdx_cmd;
+	int r;
+
+	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
+		return -EFAULT;
+	if (tdx_cmd.error)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	switch (tdx_cmd.id) {
+	default:
+		r = -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
+		r = -EFAULT;
+
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 #define TDX_MD_MAP(_fid, _ptr)			\
 	{ .fid = MD_FIELD_ID_##_fid,		\
 	  .ptr = (_ptr), }
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index e8cb4ae81cf1..f6c57ad44f80 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -138,10 +138,14 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 void tdx_hardware_unsetup(void);
 bool tdx_is_vm_type_supported(unsigned long type);
+
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
+
+static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 442b356e4939..c459a5e9e520 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7247,10 +7247,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		goto out;
 	}
 	case KVM_MEMORY_ENCRYPT_OP: {
-		r = -ENOTTY;
-		if (!kvm_x86_ops.mem_enc_ioctl)
-			goto out;
-
 		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, argp);
 		break;
 	}
-- 
2.25.1


