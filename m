Return-Path: <kvm+bounces-38951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D23C2A404F6
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D3A7176188
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2624B2066E5;
	Sat, 22 Feb 2025 01:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JXWA6pmy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B272063FE;
	Sat, 22 Feb 2025 01:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188828; cv=none; b=i72eSN3XN+RWI2nHhkuIPRyVvSLBlCeq+W+vAdn/ovewMlNea+c4EQp7UX1MMO30UgIwVCtRRLzW5Gs9f3CHGdnPmI5zGfAi9/mxzrZj9BqqasnRLsfnfY5qh6YZjTUg3c8/gxlij/xRK6KgCRQtcOTUucxyDt5bIylf/CLO8w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188828; c=relaxed/simple;
	bh=2vhq098NlKpMq5zP71G8KwHzo/Jj2ldd3kiRSJmFW88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E922SL/pHL0qo7ogmZpEiDgKgaIvT8pRixstPEQhNAh2ItxAvRJABmzq1oNez9GY1SdqEPxg8xrrxXdOn/xzBAZblqtHhn/S0zjKHguCCD+j6bkW1ibyvGy8tjDimH+skHezVjTXnaQ0FWBgUfouU+rVLVaVx4fN2zjVgtoXK0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JXWA6pmy; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188827; x=1771724827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2vhq098NlKpMq5zP71G8KwHzo/Jj2ldd3kiRSJmFW88=;
  b=JXWA6pmywCSqeIwyq8IfZ2B/NNy03y0pJuXVOcR3e0K9WDjPyBfe7M34
   R4fk//ye1unmcWH6wmMv1s0Yx38rJGzZeo0o/IWoZAAObTTJenzEOWGpw
   vyJQX+6nmbPs4Qrf7k+Ezqyxxa06vvWJrKBHCk4lVydIca8eE199A4scn
   e3QdEsFInpf8GLCOqgDriXoBA36d3yI/9BXsT1RGaaP+Ga2cgqWOhSIvE
   iAPewpTfzMGOBlHkhB7ugrwTOiM4wN3KhFh+lcZ+ZNajjdILkMUnRF/Ic
   8WZFu3DtdcN89AaI/Q84iaPOeDtFkkPHEnO9lqTnNOtxUpT2g+tb7MVPU
   Q==;
X-CSE-ConnectionGUID: BeY1XWLLR527QgAzHgtCCQ==
X-CSE-MsgGUID: vqfm+4aFSGSpizqO/istRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449066"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449066"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:06 -0800
X-CSE-ConnectionGUID: AEasiTOcT4aw23DUAmSfDw==
X-CSE-MsgGUID: LcV4dEZuR++jPG0ZeMC4mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621726"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:03 -0800
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
Subject: [PATCH v3 13/16] KVM: VMX: Move emulation_required to struct vcpu_vt
Date: Sat, 22 Feb 2025 09:47:54 +0800
Message-ID: <20250222014757.897978-14-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move emulation_required from struct vcpu_vmx to struct vcpu_vt so that
vmx_handle_exit_irqoff() can be reused by TDX code.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v3:
- No change.

TDX interrupts v2:
- New added.
---
 arch/x86/kvm/vmx/common.h |  1 +
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 20 ++++++++++----------
 arch/x86/kvm/vmx/vmx.h    |  1 -
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 8b12d8214b6c..493d191f348c 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -48,6 +48,7 @@ struct vcpu_vt {
 	 * hardware.
 	 */
 	bool		guest_state_loaded;
+	bool		emulation_required;
 
 #ifdef CONFIG_X86_64
 	u64		msr_host_kernel_gs_base;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3add9f1073ff..8ae608a1e66c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4794,7 +4794,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				vmcs12->vm_exit_msr_load_count))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
 
-	to_vmx(vcpu)->emulation_required = vmx_emulation_required(vcpu);
+	to_vt(vcpu)->emulation_required = vmx_emulation_required(vcpu);
 }
 
 static inline u64 nested_vmx_get_vmcs01_guest_efer(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4868e3bd9a2..84f26af888e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1584,7 +1584,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	vmcs_writel(GUEST_RFLAGS, rflags);
 
 	if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
-		vmx->emulation_required = vmx_emulation_required(vcpu);
+		vmx->vt.emulation_required = vmx_emulation_required(vcpu);
 }
 
 bool vmx_get_if_flag(struct kvm_vcpu *vcpu)
@@ -1866,7 +1866,7 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	WARN_ON_ONCE(vmx->emulation_required);
+	WARN_ON_ONCE(vmx->vt.emulation_required);
 
 	if (kvm_exception_is_soft(ex->vector)) {
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
@@ -3395,7 +3395,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 
 	/* depends on vcpu->arch.cr0 to be set to a new value */
-	vmx->emulation_required = vmx_emulation_required(vcpu);
+	vmx->vt.emulation_required = vmx_emulation_required(vcpu);
 }
 
 static int vmx_get_max_ept_level(void)
@@ -3658,7 +3658,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	__vmx_set_segment(vcpu, var, seg);
 
-	to_vmx(vcpu)->emulation_required = vmx_emulation_required(vcpu);
+	to_vmx(vcpu)->vt.emulation_required = vmx_emulation_required(vcpu);
 }
 
 void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
@@ -5804,7 +5804,7 @@ static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	return vmx->emulation_required && !vmx->rmode.vm86_active &&
+	return vmx->vt.emulation_required && !vmx->rmode.vm86_active &&
 	       (kvm_is_exception_pending(vcpu) || vcpu->arch.exception.injected);
 }
 
@@ -5817,7 +5817,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	intr_window_requested = exec_controls_get(vmx) &
 				CPU_BASED_INTR_WINDOW_EXITING;
 
-	while (vmx->emulation_required && count-- != 0) {
+	while (vmx->vt.emulation_required && count-- != 0) {
 		if (intr_window_requested && !vmx_interrupt_blocked(vcpu))
 			return handle_interrupt_window(&vmx->vcpu);
 
@@ -6464,7 +6464,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		 * the least awful solution for the userspace case without
 		 * risking false positives.
 		 */
-		if (vmx->emulation_required) {
+		if (vmx->vt.emulation_required) {
 			nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
 			return 1;
 		}
@@ -6474,7 +6474,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	/* If guest state is invalid, start emulating.  L2 is handled above. */
-	if (vmx->emulation_required)
+	if (vmx->vt.emulation_required)
 		return handle_invalid_guest_state(vcpu);
 
 	if (exit_reason.failed_vmentry) {
@@ -6967,7 +6967,7 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->emulation_required)
+	if (vmx->vt.emulation_required)
 		return;
 
 	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
@@ -7290,7 +7290,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	 * start emulation until we arrive back to a valid state.  Synthesize a
 	 * consistency check VM-Exit due to invalid guest state and bail.
 	 */
-	if (unlikely(vmx->emulation_required)) {
+	if (unlikely(vmx->vt.emulation_required)) {
 		vmx->fail = 0;
 
 		vmx->vt.exit_reason.full = EXIT_REASON_INVALID_STATE;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e635199901e2..6d1e40ecc024 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -263,7 +263,6 @@ struct vcpu_vmx {
 		} seg[8];
 	} segment_cache;
 	int vpid;
-	bool emulation_required;
 
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
-- 
2.46.0


