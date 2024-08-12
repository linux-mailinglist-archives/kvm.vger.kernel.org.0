Return-Path: <kvm+bounces-23903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A7B94F9E4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:51:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 827B61F2316B
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED7D19DF8D;
	Mon, 12 Aug 2024 22:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ANzz2u77"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B4F19D06E;
	Mon, 12 Aug 2024 22:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502918; cv=none; b=cIoRiTV0Ipm3JYdPMCFPXHm+P8Tl43fUmHIaKiMv9WLyygqC+kZuJN8IvdqPyCEKT4cPXRNX1Dv8Gp5Sc5Y/nfshO6gxGygQSgydKdQQ2IsYDCHYn9IDPvWih2fWk780x4m0XollzCVXqQ7bZo0V1+KVEH9h1q2w2tQcIUVK9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502918; c=relaxed/simple;
	bh=Ip2xcWFpC3D5OZKePr1UW34/GHSzjwOxZgWLMHIv1ZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ondjujQFE+KyrpNSueVEaq+92kYwKehkHmC3HxsGq0gPJHMakgkPKpIPXC/DzFhjQ2/TEJ7Jiqg8dVxJ4LKzDm+/jd2bb5NNCWOK5KrVBbtO0KY6gMK4fAo0XMDpXeEWLJaKvPAe8evxowaPgb0pGb9fJTcKJ5j5kJn4RfoU5X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ANzz2u77; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502916; x=1755038916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ip2xcWFpC3D5OZKePr1UW34/GHSzjwOxZgWLMHIv1ZY=;
  b=ANzz2u77S9vZVIvh81qtr4EdCwvpG4yboul+E2zGwnFl+5WTld5VrvCI
   7Kr5d8CIWH/7iD295tnu0mAiFoyOTGk3phkwn9YKlCrusq4hDgCsLM9YQ
   AxK9DsGwzlFKFQV8UULks/AmT++QqCeo75dNJGCJUsQ/1VZ4C16ha0EGZ
   SvBtNNFDETHvs9KQQ1kbb3Xd2h46T8QFmxJ8PTElUoFNgWUICc06GpWpm
   FPnPD6jnEJz2wPExsXcN8jhN27pBnGnMpRUKjxvSjYRaX361Zx9JwNY1E
   mMr3lqukYST+FyQIynW8aprNwM5GJ2NEA3D6Ivb424pOnVlrDteltf6pD
   Q==;
X-CSE-ConnectionGUID: sKSj8v3xSWafKkC2LrIclA==
X-CSE-MsgGUID: JXZv1tU2R7yZwglnaB5FPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041379"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041379"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:30 -0700
X-CSE-ConnectionGUID: /zEa/GbWSKqZgVKsrusMSg==
X-CSE-MsgGUID: r87SrUY4TVuwoapcXFtd8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008385"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:30 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 08/25] KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
Date: Mon, 12 Aug 2024 15:48:03 -0700
Message-Id: <20240812224820.34826-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
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

Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
TDX specific sub-commands will be added to retrieve/pass TDX specific
parameters.  Make mem_enc_ioctl non-optional as it's always filled.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - rename error->hw_error (Kai)
 - Include "x86_ops.h" to tdx.c as the patch to initialize TDX module
   doesn't include it anymore.
 - Introduce tdx_vm_ioctl() as the first tdx func in x86_ops.h
 - Drop middle paragraph in the commit log (Tony)

v15:
  - change struct kvm_tdx_cmd to drop unused member.
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/uapi/asm/kvm.h    | 26 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/main.c            | 10 ++++++++++
 arch/x86/kvm/vmx/tdx.c             | 32 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  6 ++++++
 arch/x86/kvm/x86.c                 |  4 ----
 6 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index af58cabcf82f..538f50eee86d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -123,7 +123,7 @@ KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP_OPTIONAL(dev_get_attr)
-KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index cba4351b3091..d91f1bad800e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -926,4 +926,30 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SNP_VM		4
 #define KVM_X86_TDX_VM		5
 
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
+	__u64 hw_error;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 21fae631c775..59f4d2d42620 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -41,6 +41,14 @@ static __init int vt_hardware_setup(void)
 	return 0;
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
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -189,6 +197,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
+
+	.mem_enc_ioctl = vt_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b1c885ce8c9c..de14e80d8f3a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2,6 +2,7 @@
 #include <linux/cpu.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
+#include "x86_ops.h"
 #include "tdx.h"
 
 #undef pr_fmt
@@ -29,6 +30,37 @@ static void __used tdx_guest_keyid_free(int keyid)
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
 
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_tdx_cmd tdx_cmd;
+	int r;
+
+	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
+		return -EFAULT;
+
+	/*
+	 * Userspace should never set @error. It is used to fill
+	 * hardware-defined error by the kernel.
+	 */
+	if (tdx_cmd.hw_error)
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
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 133afc4d196e..c69ca640abe6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -118,4 +118,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+#else
+static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a8944266a54d..7914ea50fd04 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7313,10 +7313,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		goto out;
 	}
 	case KVM_MEMORY_ENCRYPT_OP: {
-		r = -ENOTTY;
-		if (!kvm_x86_ops.mem_enc_ioctl)
-			goto out;
-
 		r = kvm_x86_call(mem_enc_ioctl)(kvm, argp);
 		break;
 	}
-- 
2.34.1


