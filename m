Return-Path: <kvm+bounces-6595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C608D83794C
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:35:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C40D28FF0D
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C965A100;
	Mon, 22 Jan 2024 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ijtQt/UP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC0B5813E;
	Mon, 22 Jan 2024 23:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967711; cv=none; b=M9L4qjkybQTwEDKgfW3dNxlkTVDZLAkhyJYmWJxtqshL0LxbthIAy4bor+iECoJoTx5zFefZ/TPXZqnI82umX20XiWGSDVqVGmsyMmTzXJ7jV1/tVkEnmh6aWsdWzCa9QPlRDGhUfRsUXdMrZ7+Usbheix343Jzin6M7GIDQ5ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967711; c=relaxed/simple;
	bh=NjPEE8U/8RpWvMrc0iTO+AV+ZRRvmhj9F2/fU6hvMXk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rVbrhTCRs/B/lp3fjVjYYmdeJYYSu6saGYvX0/vfxRdfWeP4jGLU3gv8cJa1UjIWf05ITdFnjozv943YM8Dk4BBkJP9Vo8/+mbIIUPyHF2haEI/pFg7PJHaHw0MmmBIDzzG3j8KY5oHqfhC3Nm121tt/rZQBox2Ke1KOU9MHvnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ijtQt/UP; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967709; x=1737503709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NjPEE8U/8RpWvMrc0iTO+AV+ZRRvmhj9F2/fU6hvMXk=;
  b=ijtQt/UPexoE6bqt3YsB6eRUXRMuQnUJqXkb5PXmiD5ta9OnW0rEVxRo
   x01JUtpmAMr38hR2aD5vwzVhVeZ/TcLniuphTYefAExe01Fh8Wdd0FXNd
   HRKREtgeRc0QiNPq8uwGRQOp6UWxRzv5GJ/8W5exbB8XtYrMMW9ruke1S
   sfjfH9UAadjk0bprrCVwlxz9na6QNn7QNhR2c69h0DL2CtvR4RNFZLJLu
   jpQbdODLPkigwLMelFPacY2NVmEoDdNlCBvwV50wldTRoXXcg/k7tI9V3
   eRWnYqSwrxm9BQrnJIFBHzM2WXqX7EsR6X7v42W0ycVMeR6Wnx5fiqRl0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243786"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243786"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888486"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888486"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:07 -0800
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
Subject: [PATCH v18 021/121] KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
Date: Mon, 22 Jan 2024 15:52:57 -0800
Message-Id: <1f6a56ef9d25170a8a62003b9b5fbf77785bc90c.1705965634.git.isaku.yamahata@intel.com>
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
index e6b1763b041d..943b21b8b106 100644
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
index f181620b2922..50da807d7aea 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -62,6 +62,14 @@ static int vt_vm_init(struct kvm *kvm)
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
@@ -214,6 +222,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
+
+	.mem_enc_ioctl = vt_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 55399136b680..56655e6bfd5e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -99,6 +99,32 @@ struct tdx_info {
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
 static int __init tdx_module_setup(void)
 {
 	u16 num_cpuid_config;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9523087ae355..6e238142b1e8 100644
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
index 1b1045dc8e7a..dd3a23d56621 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7218,10 +7218,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
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


