Return-Path: <kvm+bounces-39444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0B2A470D8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D3283B1311
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C520617A303;
	Thu, 27 Feb 2025 01:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OWr8Qa4R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B22B17A2F3;
	Thu, 27 Feb 2025 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619151; cv=none; b=cqkNC0KQH0JxyFWT6y+YKBR6ix/k/FagOb5LXiCDVJLxKDEvQ2J1n5roO6araic6pi7SR8mgUyOvltHudVThGjoYVYWVN+mVCgRvY/KQQpwUDdTB6Cd4bdvrdkkwedNCpa4qj0n+Qgzak9wECbYA/IjSuwneNe7lO4Ay2cuooyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619151; c=relaxed/simple;
	bh=I2BGa656dde3G5onU6rC3eO3gUchuMpeokI55iQR/iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnPfBjZGLaYrSZsjpF3lgiNNv66u0vXS8RESyXYwlVmq5iVEMTCR+ONfFJcsHalAHftU/v2c/G8zEBJRyf0q0tI4d4eczghG15pEwNDE5CSKbx90ZCNcw0c/MpktoQ3ngtQB0nEBXSUUrt9up/IYdfB2qnsGvMtH1w7XioZjNEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OWr8Qa4R; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619149; x=1772155149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I2BGa656dde3G5onU6rC3eO3gUchuMpeokI55iQR/iU=;
  b=OWr8Qa4RE94rRSrXbUFqDYy0mlEod2Wc2KdmMQ+aKiFqiIhgtOPLmrrM
   M2lPgiYO97M0lAA9+qCo7EJfTd78wEmyNhT33cfUQDTX07buClQQt0BgQ
   G33D6uathivEfmWrxm5aoRXARMv6n0BpICYxkqrtC6yBmQ4wVXF+ScXOe
   k6yFxUjOt1+BbamzT+41lQjMfpeoG6qHNhXEM2G7vDreG1hqK1ieCckj6
   cg7bppeud961ZzU+LV6qYEK8d7JUzdzp+y21WXAhxAaX400PaUAu+98SD
   ZmHdr8qeWnxXtfbgpAc5mPnVx5idQJq1Tw1FC18gB/lNxHdVMs5EvMGzh
   w==;
X-CSE-ConnectionGUID: 5/sJzgIRSASa1x2SRjPsUQ==
X-CSE-MsgGUID: XxQ5tHCyQDyuE6z+fcLS1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959613"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959613"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:09 -0800
X-CSE-ConnectionGUID: idOysd39QxWehSbzUmNG6A==
X-CSE-MsgGUID: EFvmq/ZnScyYLu5DUfcbIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674886"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:05 -0800
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
Subject: [PATCH v2 06/20] KVM: TDX: Handle TDX PV HLT hypercall
Date: Thu, 27 Feb 2025 09:20:07 +0800
Message-ID: <20250227012021.1778144-7-binbin.wu@linux.intel.com>
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

Handle TDX PV HLT hypercall and the interrupt status due to it.

TDX guest status is protected, KVM can't get the interrupt status
of TDX guest and it assumes interrupt is always allowed unless TDX
guest calls TDVMCALL with HLT, which passes the interrupt blocked flag.

If the guest halted with interrupt enabled, also query pending RVI by
checking bit 0 of TD_VCPU_STATE_DETAILS_NON_ARCH field via a seamcall.

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
TDX "the rest" v2:
- Morph PV HLT hypercall to EXIT_REASON_HLT. (Sean)
- Rebased to use tdcall_to_vmx_exit_reason().
- Use vp_enter_args directly instead of helpers.
- Check RVI pending for halted case and updated the changelog
  accordingly.

TDX "the rest" v1:
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
 arch/x86/kvm/vmx/tdx.c         | 39 ++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.h         |  7 ++++++
 arch/x86/kvm/vmx/tdx_arch.h    | 11 ++++++++++
 5 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 55c8507d60fe..d383f4510c15 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -418,7 +418,7 @@ static void vt_cancel_injection(struct kvm_vcpu *vcpu)
 static int vt_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (is_td_vcpu(vcpu))
-		return true;
+		return tdx_interrupt_allowed(vcpu);
 
 	return vmx_interrupt_allowed(vcpu, for_injection);
 }
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 895bbe85b818..f2ca37b3f606 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -203,7 +203,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 		return;
 
 	if (kvm_vcpu_is_blocking(vcpu) &&
-	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
+	    ((is_td_vcpu(vcpu) && tdx_interrupt_allowed(vcpu)) ||
+	     (!is_td_vcpu(vcpu) && !vmx_interrupt_blocked(vcpu))))
 		pi_enable_wakeup_handler(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8019bf553ca5..30f0ceeed7d2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -720,9 +720,39 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	local_irq_enable();
 }
 
+bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * KVM can't get the interrupt status of TDX guest and it assumes
+	 * interrupt is always allowed unless TDX guest calls TDVMCALL with HLT,
+	 * which passes the interrupt blocked flag.
+	 */
+	return vmx_get_exit_reason(vcpu).basic != EXIT_REASON_HLT ||
+	       !to_tdx(vcpu)->vp_enter_args.r12;
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
+	/*
+	 * Only check RVI pending for HALTED case with IRQ enabled.
+	 * For non-HLT cases, KVM doesn't care about STI/SS shadows.  And if the
+	 * interrupt was pending before TD exit, then it _must_ be blocked,
+	 * otherwise the interrupt would have been serviced at the instruction
+	 * boundary.
+	 */
+	if (vmx_get_exit_reason(vcpu).basic != EXIT_REASON_HLT ||
+	    to_tdx(vcpu)->vp_enter_args.r12)
+		return false;
+
+	vcpu_state_details =
+		td_state_non_arch_read64(to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);
+
+	return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
 }
 
 /*
@@ -846,6 +876,7 @@ static __always_inline u32 tdcall_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
 	case EXIT_REASON_CPUID:
+	case EXIT_REASON_HLT:
 	case EXIT_REASON_IO_INSTRUCTION:
 		return tdvmcall_leaf(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
@@ -1103,9 +1134,7 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 	/*
 	 * Stop processing the remaining part if there is a pending interrupt,
 	 * which could be qualified to deliver.  Skip checking pending RVI for
-	 * TDVMCALL_MAP_GPA.
-	 * TODO: Add a comment to link the reason when the target function is
-	 * implemented.
+	 * TDVMCALL_MAP_GPA, see comments in tdx_protected_apic_has_interrupt().
 	 */
 	if (kvm_vcpu_has_events(vcpu)) {
 		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
@@ -1908,6 +1937,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return 1;
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return kvm_emulate_halt_noskip(vcpu);
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
 	case EXIT_REASON_VMCALL:
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index c6bafac31d4d..cb9014b7a4f1 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -121,6 +121,7 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
 }
 
 static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
 
 #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
 static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
@@ -168,11 +169,15 @@ static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
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
 static inline int tdx_bringup(void) { return 0; }
@@ -188,6 +193,8 @@ struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 };
 
+static inline bool tdx_interrupt_allowed(struct kvm_vcpu *vcpu) { return false; }
+
 #endif
 
 #endif
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index fcbf0d4abc5f..e1f636ef5d0e 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -36,6 +36,17 @@ enum tdx_tdcs_execution_control {
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


