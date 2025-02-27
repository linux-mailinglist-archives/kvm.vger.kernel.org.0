Return-Path: <kvm+bounces-39447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 959CBA470DE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01749188DE4E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89D719C552;
	Thu, 27 Feb 2025 01:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nsgDY+01"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E5B1917FB;
	Thu, 27 Feb 2025 01:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619160; cv=none; b=rvnAFTalUS75SmfY4VUlgrSXkMzka7qCAVmwc2xIYT3m2luhPQJXcEJy0b0o01tvU8cUyltXGUutwBe0iXovS4nu8FbPRfmSxMyrXtoiqrm/tUkT9rXEBlZq4nCg6bCeU00P6pamylftPQHXjl5WGpldriDUbWdFldsusj6hrt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619160; c=relaxed/simple;
	bh=ri6AyiRTtAQTnjyYiC0FobX78tZ80oBXhVhCjzKkk9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puTnHtNxW8jCARZjEmR5LiHLYo2TH/gglIC4nEXC0XuGr8HHFmFAElzYTKBU+3vYX4EYH5r4dZh2g3kwM/I92nLpWdpx8Pt4cduUHqYUUuGvSZsOdJNt4bQHcCM5iUHX8wLhDQxpGWzNL36TRGf4ZeohC9KoyYpChVu/yp2V7Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nsgDY+01; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619159; x=1772155159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ri6AyiRTtAQTnjyYiC0FobX78tZ80oBXhVhCjzKkk9I=;
  b=nsgDY+01bk4nyLptcTnvweZ7dV9SXqs0L6KatVTwnDlSdbpYWuZ63iDM
   jt1Mli2Npbt9MLdGI2cGJrn1E43za2P6FI+1DLMepyLmRHTJ4dg33PJQS
   0gWRO7WNau66VgjonU/u3XWnJnMeCkWfBKxe+oq4xUXgR3iW5QOMxJOCD
   5ZVtPUVkdmrc8RyHY2oCP7b06N+8BbSapJVQxF3+MzmnmotT48yxH4cqB
   GJLwaOuaWClHPQIdqyJYH5yDM9jBXEIp3Wh4FnQhW9Rj9+33R3Ej6OE4i
   gjpcxpsh3Z/snAJ5TFdxT7/yMETbYshnWZ2nq4zK7DKce4F9Fy+QMx81g
   Q==;
X-CSE-ConnectionGUID: y6eDhVYXRneWQ1vcVZ+u2Q==
X-CSE-MsgGUID: d/6uD2QASiab12tkYbH2mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959626"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959626"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:19 -0800
X-CSE-ConnectionGUID: tLI6RLXxRxqkpvfZtvvDqg==
X-CSE-MsgGUID: msoI5mqTQQyrheb4v1ne9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674900"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:15 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 09/20] KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
Date: Thu, 27 Feb 2025 09:20:10 +0800
Message-ID: <20250227012021.1778144-10-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Morph PV RDMSR/WRMSR hypercall to EXIT_REASON_MSR_{READ,WRITE} and
wire up KVM backend functions.

For complete_emulated_msr() callback, instead of injecting #GP on error,
implement tdx_complete_emulated_msr() to set return code on error.  Also
set return value on MSR read according to the values from kvm x86
registers.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX "the rest" v2:
- Morph PV RDMSR/WRMSR hypercall to EXIT_REASON_MSR_{READ,WRITE}. (Sean)
- Rebased to use tdcall_to_vmx_exit_reason().
- Marshall values to the appropriate x86 registers to leverage the existing
  kvm_emulate_{rdmsr,wrmsr}(). (Sean)
- Implement complete_emulated_msr() callback for TDX to set return value
  and return code to vp_enter_args.
- Update changelog.

TDX "the rest" v1:
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 arch/x86/kvm/vmx/tdx.c  | 24 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h  |  2 ++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 463de3add3bd..7f3be1b65ce1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -235,6 +235,14 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
 	vmx_msr_filter_changed(vcpu);
 }
 
+static int vt_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_complete_emulated_msr(vcpu, err);
+
+	return kvm_complete_insn_gp(vcpu, err);
+}
+
 #ifdef CONFIG_KVM_SMM
 static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
@@ -686,7 +694,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.migrate_timers = vmx_migrate_timers,
 
 	.msr_filter_changed = vt_msr_filter_changed,
-	.complete_emulated_msr = kvm_complete_insn_gp,
+	.complete_emulated_msr = vt_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5b556af0f139..85ff6e040cf3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -878,6 +878,8 @@ static __always_inline u32 tdcall_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 	case EXIT_REASON_CPUID:
 	case EXIT_REASON_HLT:
 	case EXIT_REASON_IO_INSTRUCTION:
+	case EXIT_REASON_MSR_READ:
+	case EXIT_REASON_MSR_WRITE:
 		return tdvmcall_leaf(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
 		return EXIT_REASON_EPT_MISCONFIG;
@@ -1880,6 +1882,20 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
+{
+	if (err) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MSR_READ)
+		tdvmcall_set_return_val(vcpu, kvm_read_edx_eax(vcpu));
+
+	return 1;
+}
+
+
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1945,6 +1961,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_emulate_vmcall(vcpu);
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdx_emulate_io(vcpu);
+	case EXIT_REASON_MSR_READ:
+		kvm_rcx_write(vcpu, tdx->vp_enter_args.r12);
+		return kvm_emulate_rdmsr(vcpu);
+	case EXIT_REASON_MSR_WRITE:
+		kvm_rcx_write(vcpu, tdx->vp_enter_args.r12);
+		kvm_rax_write(vcpu, tdx->vp_enter_args.r13 & -1u);
+		kvm_rdx_write(vcpu, tdx->vp_enter_args.r13 >> 32);
+		return kvm_emulate_wrmsr(vcpu);
 	case EXIT_REASON_EPT_MISCONFIG:
 		return tdx_emulate_mmio(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index cb9014b7a4f1..8f8070d0f55e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -171,6 +171,7 @@ static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
 
 
 bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu);
+int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu, int err);
 
 TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
@@ -194,6 +195,7 @@ struct vcpu_tdx {
 };
 
 static inline bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu) { return false; }
+static inline int tdx_complete_emulated_msr(struct kvm_vcpu *vcpu, int err) { return 0; }
 
 #endif
 
-- 
2.46.0


