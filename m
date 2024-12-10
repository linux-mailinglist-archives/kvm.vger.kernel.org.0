Return-Path: <kvm+bounces-33354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E4D9EA3CC
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30C1F167343
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BA519E980;
	Tue, 10 Dec 2024 00:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gBTz32e4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3503119D897;
	Tue, 10 Dec 2024 00:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791689; cv=none; b=DWjdODusal1gBR6ZkJiMRAs+8YBDVr9HvoMsMvonRNo8/pDKuxIMxcTDRnNVROWR+7h/k5NE8m6or2crMG8W2GH9RIjyn/XKDIFhILvYDkiIhH4rVFK6oWoAVMEMqnsBqiHpKX1+QU1IhAoZKfqqDnHb6rOY2VvKhzZOw/Z+4VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791689; c=relaxed/simple;
	bh=PSSo+9eYAoqziDacJv2YmgxniM4s+DtQkJOYkubWaHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tx3eJa6LzEJIIuGw7AtCVNFtJD/MPeK2qVUBJAdg0udr0Wyo1Mpd2SJPQulN0V77JV1iHsesQneLBZi+WDtzW1azHVUiff/LDtsRl35U60j57P/kyVuGtd/v6dDJbzQbD7tdEYkM0VoJpUb+gr8qkWomn2fNpHoQjl4Ut2L+x8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gBTz32e4; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791687; x=1765327687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PSSo+9eYAoqziDacJv2YmgxniM4s+DtQkJOYkubWaHY=;
  b=gBTz32e4be436OFxfNbiU/u877gn2xf6/n5BiXaQCQnDCkby2qSI5X41
   LOjhWE3XbP6q+BjmtoUEIRHygTyUFsRSmPDGnB1B6HmoazmEgyC/22h/r
   5nXilNLIPdYYc5TaYESR4wAO7Ly4ew2dFppAtAjVxkyPfrqCLh7ZWk9V3
   qRCeTjFEfsInIf/eE3PuoCAn5rwaiRSFqd6MoXf9qIIRjXpXnmk/5s/Vc
   Gru6psoUgk8Gr9BPQ2QLYcBPBM4dBQsJ3XSRVxg2mYsmG9EMRyFK5oJeQ
   9OMbE4BDD9rbCu8tRLw6PFrBKQzkLkTC5aOdZvH7wFsKBp3CqyP6vuuVw
   g==;
X-CSE-ConnectionGUID: hK8d6tUdSqyI4bhI5og7nA==
X-CSE-MsgGUID: Ati0TWEqRpCVJ1X1LaVdxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793704"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793704"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:06 -0800
X-CSE-ConnectionGUID: WrPuodzPQa28/GpCTSmOmg==
X-CSE-MsgGUID: WTfxpc9mRKS6Fl65lCrX+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033023"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:03 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 05/18] KVM: TDX: Handle TDX PV HLT hypercall
Date: Tue, 10 Dec 2024 08:49:31 +0800
Message-ID: <20241210004946.3718496-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle TDX PV HLT hypercall and the interrupt status due to it.

TDX guest status is protected, KVM can't get the interrupt status
of TDX guest and it assumes interrupt is always allowed unless TDX
guest calls TDVMCALL with HLT, which passes the interrupt blocked flag.

Update vt_interrupt_allowed() for TDX based on interrupt blocked flag
passed by HLT TDVMCALL.  Do not wakeup TD vCPU if interrupt is blocked
for VT-d PI.

For NMIs, KVM cannot determine the NMI blocking status for TDX guests,
so KVM always assumes NMIs are not blocked.  In the unlikely scenario
where a guest invokes the PV HLT hypercall within an NMI handler, this
could result in a spurious wakeup.  The guest should implement the PV
HLT hypercall within a loop if it truly requires no interruptions, since
NMI could be unblocked by an IRET due to an exception occurring before
the PV HLT is executed in the NMI handler.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Update the changelog.
- Remove the interrupt_disabled_hlt field (Sean)
  https://lore.kernel.org/kvm/Zg1seIaTmM94IyR8@google.com/
- Move the logic of interrupt status to vt_interrupt_allowed() (Chao)
  https://lore.kernel.org/kvm/ZhIX7K0WK+gYtcan@chao-email/
- Add suggested-by tag.
- Use tdx_check_exit_reason()
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)

v19:
- move tdvps_state_non_arch_check() to this patch

v18:
- drop buggy_hlt_workaround and use TDH.VP.RD(TD_VCPU_STATE_DETAILS)
---
 arch/x86/kvm/vmx/main.c        |  2 +-
 arch/x86/kvm/vmx/posted_intr.c |  3 ++-
 arch/x86/kvm/vmx/tdx.c         | 32 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h         |  6 ++++++
 arch/x86/kvm/vmx/tdx_arch.h    | 11 +++++++++++
 5 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 305425b19cb5..bfe848083eb9 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -424,7 +424,7 @@ static void vt_cancel_injection(struct kvm_vcpu *vcpu)
 static int vt_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (is_td_vcpu(vcpu))
-		return true;
+		return tdx_interrupt_allowed(vcpu);
 
 	return vmx_interrupt_allowed(vcpu, for_injection);
 }
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 87a6964c662a..1ce9b9e93a26 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -223,7 +223,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 		return;
 
 	if (kvm_vcpu_is_blocking(vcpu) &&
-	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
+	    ((is_td_vcpu(vcpu) && tdx_interrupt_allowed(vcpu)) ||
+	     (!is_td_vcpu(vcpu) && !vmx_interrupt_blocked(vcpu))))
 		pi_enable_wakeup_handler(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 62dbb47ead21..2b64652a0d05 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -771,9 +771,31 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	local_irq_enable();
 }
 
+bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * KVM can't get the interrupt status of TDX guest and it assumes
+	 * interrupt is always allowed unless TDX guest calls TDVMCALL with HLT,
+	 * which passes the interrupt blocked flag.
+	 */
+	if (!tdx_check_exit_reason(vcpu, EXIT_REASON_TDCALL) ||
+	    tdvmcall_exit_type(vcpu) || tdvmcall_leaf(vcpu) != EXIT_REASON_HLT)
+	    return true;
+
+	return !tdvmcall_a0_read(vcpu);
+}
+
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_has_pending_interrupt(vcpu);
+	u64 vcpu_state_details;
+
+	if (pi_has_pending_interrupt(vcpu))
+		return true;
+
+	vcpu_state_details =
+		td_state_non_arch_read64(to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);
+
+	return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
 }
 
 /*
@@ -1294,6 +1316,12 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
+{
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+	return kvm_emulate_halt_noskip(vcpu);
+}
+
 static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pio.count = 0;
@@ -1477,6 +1505,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_report_fatal_error(vcpu);
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return tdx_emulate_hlt(vcpu);
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdx_emulate_io(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index b553dd9b0b06..008180c0c30f 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -152,6 +152,7 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
 }
 
 static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
 
 #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
 static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
@@ -199,11 +200,15 @@ static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
 		tdh_vp_wr_failed(tdx, #uclass, " &= ~", field, bit, err);\
 }
 
+
+bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu);
+
 TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 
 TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
+TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
 
 #else
 static inline void tdx_bringup(void) {}
@@ -223,6 +228,7 @@ static inline bool is_td(struct kvm *kvm) { return false; }
 static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
 static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return NULL; }
 static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) { return NULL; }
+static inline bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu) { return false; }
 
 #endif
 
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 2f9e88f497bc..861c0f649b69 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -71,6 +71,17 @@ enum tdx_tdcs_execution_control {
 	TD_TDCS_EXEC_TSC_OFFSET = 10,
 };
 
+enum tdx_vcpu_guest_other_state {
+	TD_VCPU_STATE_DETAILS_NON_ARCH = 0x100,
+};
+
+#define TDX_VCPU_STATE_DETAILS_INTR_PENDING	BIT_ULL(0)
+
+static inline bool tdx_vcpu_state_details_intr_pending(u64 vcpu_state_details)
+{
+	return !!(vcpu_state_details & TDX_VCPU_STATE_DETAILS_INTR_PENDING);
+}
+
 /* @field is any of enum tdx_tdcs_execution_control */
 #define TDCS_EXEC(field)		BUILD_TDX_FIELD(TD_CLASS_EXECUTION_CONTROLS, (field))
 
-- 
2.46.0


