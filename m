Return-Path: <kvm+bounces-9643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C741866C5C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:34:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FCD71C2033E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0658354F89;
	Mon, 26 Feb 2024 08:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eGJhJmfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43405336F;
	Mon, 26 Feb 2024 08:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936071; cv=none; b=lWpKHc41WVS1/5/G5AvF7Q0qivTBBv3ohdUYjP1Gx5csA7oZXflpuYJVa5tolBM1L70sDVgJ7dD63KWGQ+vHoo+prmmqtkHLrfUtOQqbHdl5jZHxVDvHtjEPVba2Bix6tt47ymttmmqMC3N/ESX5SXCUef43+dp/uc+jjmVxOdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936071; c=relaxed/simple;
	bh=qKBirrBY3+MoQoDpbImPbRXsqS9NNbeEormb4888U70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X1vwIRd+1+y+3h40XrcQhspSvTdUZjB+pNZU1VM1zZKoNz+ZCAwL1atJ7eQGZ2ldpJzla0nTYata7CI8i/uShxUJnvKMmrEWaKe0bguc3wbHOlBufJW3f0/ZVqilN3iViQcw/qf0S6vRRhUAUdZczYx+jr9Y66gd8/H01cVnBf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eGJhJmfZ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936070; x=1740472070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qKBirrBY3+MoQoDpbImPbRXsqS9NNbeEormb4888U70=;
  b=eGJhJmfZRHZRK592g1XLGwrkp7EqGydS49l0gxJ81LAb2nsnBqcAumUV
   1ihZ1k8xBuEdTFvhIUotzeMV3jjJhAe/+jcUNPQGszFLWRb8ou9nGNYCc
   yB1uBNWIYGPef7BmEzPDl+R3hJEb4w7jx9ZuUx+JFHQy229RxspPH02sy
   BskrFFbkaARPY++u7l9SlXnzBd6Alsb5nNJWEdRMG/QMeGaRWJds4Z572
   VphbKuxkZTaA/Q4ddzN/EWFnD+1vMSuUuYiLJ2CmJGT0G1ahL8ptB/zHk
   VxsEB4nsnIHjEY7flFqqmsZ83pluEkUgs10X+919mjy8OuqPPhzRSa7+S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631506"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631506"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474357"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:44 -0800
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
Subject: [PATCH v19 019/130] KVM: x86: Add is_vm_type_supported callback
Date: Mon, 26 Feb 2024 00:25:21 -0800
Message-Id: <6712a8a18abb033b1c32b9b6579ac297e3b00ab6.1708933498.git.isaku.yamahata@intel.com>
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

For SEV_SNP and TDX, allow the backend can override the supported vm type.
Add KVM_X86_SNP_VM and KVM_X86_TDX_VM to reserve the bit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v19:
- Mention KVM_X86_SNP_VM to the commit message

v18:
- include into TDX KVM patch series v18

Changes v3 -> v4:
- Added KVM_X86_SNP_VM

Changes v2 -> v3:
- no change
- didn't bother to rename KVM_X86_PROTECTED_VM to KVM_X86_SW_PROTECTED_VM

Changes v1 -> v2
- no change

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  2 ++
 arch/x86/kvm/svm/svm.c             |  7 +++++++
 arch/x86/kvm/vmx/vmx.c             |  7 +++++++
 arch/x86/kvm/x86.c                 | 12 +++++++++++-
 arch/x86/kvm/x86.h                 |  2 ++
 7 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 156832f01ebe..8be71a5c5c87 100644
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
index 28314e7d546c..37cda8aa07b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1603,6 +1603,7 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
+	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a448d0964fc0..aa7a56a47564 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -564,5 +564,7 @@ struct kvm_pmu_event_filter {
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
+#define KVM_X86_TDX_VM		2
+#define KVM_X86_SNP_VM		3
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..f76dd52d29ba 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4886,6 +4886,12 @@ static void svm_vm_destroy(struct kvm *kvm)
 	sev_vm_destroy(kvm);
 }
 
+static bool svm_is_vm_type_supported(unsigned long type)
+{
+	/* FIXME: Check if CPU is capable of SEV-SNP. */
+	return __kvm_is_vm_type_supported(type);
+}
+
 static int svm_vm_init(struct kvm *kvm)
 {
 	if (!pause_filter_count || !pause_filter_thresh)
@@ -4914,6 +4920,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
 
+	.is_vm_type_supported = svm_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1111d9d08903..fca3457dd050 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7541,6 +7541,12 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
+static bool vmx_is_vm_type_supported(unsigned long type)
+{
+	/* TODO: Check if TDX is supported. */
+	return __kvm_is_vm_type_supported(type);
+}
+
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
@@ -8263,6 +8269,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 	.vm_destroy = vmx_vm_destroy,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03dab4266172..442b356e4939 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4576,12 +4576,18 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 }
 #endif
 
-static bool kvm_is_vm_type_supported(unsigned long type)
+bool __kvm_is_vm_type_supported(unsigned long type)
 {
 	return type == KVM_X86_DEFAULT_VM ||
 	       (type == KVM_X86_SW_PROTECTED_VM &&
 		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled);
 }
+EXPORT_SYMBOL_GPL(__kvm_is_vm_type_supported);
+
+static bool kvm_is_vm_type_supported(unsigned long type)
+{
+	return static_call(kvm_x86_is_vm_type_supported)(type);
+}
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
@@ -4784,6 +4790,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = BIT(KVM_X86_DEFAULT_VM);
 		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
 			r |= BIT(KVM_X86_SW_PROTECTED_VM);
+		if (kvm_is_vm_type_supported(KVM_X86_TDX_VM))
+			r |= BIT(KVM_X86_TDX_VM);
+		if (kvm_is_vm_type_supported(KVM_X86_SNP_VM))
+			r |= BIT(KVM_X86_SNP_VM);
 		break;
 	default:
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2f7e19166658..4e40c23d66ed 100644
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
-- 
2.25.1


