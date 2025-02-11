Return-Path: <kvm+bounces-37780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCF4A301B6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 030DF16846D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12781D6DA9;
	Tue, 11 Feb 2025 02:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LPUnu/33"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42BF1D54C2;
	Tue, 11 Feb 2025 02:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242394; cv=none; b=ciK2auPrgjFoITcLsI6yCbi46m1pJ14gUldDLrjq2o60YjoqjjHuIZCJ9yQwdN55SvdJLOygDtdZlKQvd2cOMxPf5vcUofAD2lKRRALi02ND2d21AWS5+m4sTRGQYv9pFwYguTvSs7SN3+l0bEfJ1FVbuvZ7B3VPoi9VSIwWx4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242394; c=relaxed/simple;
	bh=SBvYkIlOlMShcP+fpx+z9pM4LYvwobKjklVzZrcNP/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ+D3LnrRZ1kbniH+Vz/gVBVbPqDoUB81kWFRLKv7WmbE5cuTOAOUaeoT5M50ba7LFvD8BU9VFxj/gUupM0cfcT8xVA3Or2Ci66/1SARQIDAkRe3O2C1rmtBIoEIs2jasanoLu48BiEwIw3ULJmasQEqIA/L2mGISz+w4IDbroE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LPUnu/33; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242393; x=1770778393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SBvYkIlOlMShcP+fpx+z9pM4LYvwobKjklVzZrcNP/E=;
  b=LPUnu/33dUFalfHauHIqqNS1sLrzOS7YbMs8QAO6Zp1zF44iF4vXD7rA
   gl5vb4zAKQHZCqgyZdaFv1C4NnlQ+KTtcCGPwtj7b/5nQXwGQWCOLcLKl
   99hWZN7sVz4OwSRT5n7kuWqrzKsGIxHDTWWV9280rJg2HXRjVYaopR5Gq
   rIpKZswAifgHsOGrf0cwBdD5vCXujWsgOI+31ykuM5oh3IuNbBC0bsm4w
   fS+CxADPrpRL5AVIy4qSKFyw5/kTKFzpohh5ML07XIZ0NsV1ZJf0ZiIry
   4tYScv0icAzwiK81VkiO5TrPu6TLFYhNSMv6N6Mzql8wm4VvKyyOsDaXP
   w==;
X-CSE-ConnectionGUID: pOeqHYsuSVGcgKE0S18A0w==
X-CSE-MsgGUID: KVPYpSLGQamyVsUN9gpL9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43506596"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43506596"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:13 -0800
X-CSE-ConnectionGUID: LDeV5jkeSGKkXjxJqRRkWg==
X-CSE-MsgGUID: QUW0cuJdRjOlhUjJ8KbjLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112236419"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:09 -0800
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
Subject: [PATCH v2 2/8] KVM: TDX: Add a place holder to handle TDX VM exit
Date: Tue, 11 Feb 2025 10:54:36 +0800
Message-ID: <20250211025442.3071607-3-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce the wiring for handling TDX VM exits by implementing the
callbacks .get_exit_info(), .get_entry_info(), and .handle_exit().
Additionally, add error handling during the TDX VM exit flow, and add a
place holder to handle various exit reasons.

Store VMX exit reason and exit qualification in struct vcpu_vt for TDX,
so that TDX/VMX can use the same helpers to get exit reason and exit
qualification. Store extended exit qualification and exit GPA info in
struct vcpu_tdx because they are used by TDX code only.

Contention Handling: The TDH.VP.ENTER operation may contend with TDH.MEM.*
operations due to secure EPT or TD EPOCH. If the contention occurs,
the return value will have TDX_OPERAND_BUSY set, prompting the vCPU to
attempt re-entry into the guest with EXIT_FASTPATH_EXIT_HANDLED,
not EXIT_FASTPATH_REENTER_GUEST, so that the interrupts pending during
IN_GUEST_MODE can be delivered for sure. Otherwise, the requester of
KVM_REQ_OUTSIDE_GUEST_MODE may be blocked endlessly.

Error Handling:
- TDX_SW_ERROR: This includes #UD caused by SEAMCALL instruction if the
  CPU isn't in VMX operation, #GP caused by SEAMCALL instruction when TDX
  isn't enabled by the BIOS, and TDX_SEAMCALL_VMFAILINVALID when SEAM
  firmware is not loaded or disabled.
- TDX_ERROR: This indicates some check failed in the TDX module, preventing
  the vCPU from running.
- Failed VM Entry: Exit to userspace with KVM_EXIT_FAIL_ENTRY. Handle it
  separately before handling TDX_NON_RECOVERABLE because when off-TD debug
  is not enabled, TDX_NON_RECOVERABLE is set.
- TDX_NON_RECOVERABLE: Set by the TDX module when the error is
  non-recoverable, indicating that the TDX guest is dead or the vCPU is
  disabled.
  A special case is triple fault, which also sets TDX_NON_RECOVERABLE but
  exits to userspace with KVM_EXIT_SHUTDOWN, aligning with the VMX case.
- Any unhandled VM exit reason will also return to userspace with
  KVM_EXIT_INTERNAL_ERROR.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
Hypercalls exit to userspace v2:
- Record vmx exit reason and exit_qualification in struct vcpu_vt for TDX,
  so that TDX/VMX can use the same helpers to get exit reason and exit
  qualification. (Sean)
- Handle failed vmentry separately by KVM_EXIT_FAIL_ENTRY. (Xiaoyao)
- Remove the print of hkid & set_hkid_to_hpa() for TDX_ERROR or
  TDX_NON_RECOVERABLE case. (Xiaoyao)
- Handle EXIT_REASON_TRIPLE_FAULT in switch case, and drop the helper
  tdx_handle_triple_fault(), open code it. (Sean)
- intr_info should be 0 for the case VMX exit reason is invalid in
  tdx_get_exit_info(). (Chao)
- Combine TDX_OPERAND_BUSY for TDX_OPERAND_ID_TD_EPOCH and TDX_OPERAND_ID_SEPT,
  use EXIT_FASTPATH_EXIT_HANDLED instead of EXIT_FASTPATH_REENTER_GUEST. Updated
  comments.
- Use helper tdx_operand_busy().
- Add vt_get_entry_info() to implement .get_entry_info() for TDX.

Hypercalls exit to userspace v1:
- Dropped Paolo's Reviewed-by since the change is not subtle.
- Mention addition of .get_exit_info() handler in changelog. (Binbin)
- tdh_sept_seamcall() -> tdx_seamcall_sept() in comments. (Binbin)
- Do not open code TDX_ERROR_SEPT_BUSY. (Binbin)
- "TDH.VP.ENTRY" -> "TDH.VP.ENTER". (Binbin)
- Remove the use of union tdx_exit_reason. (Sean)
  https://lore.kernel.org/kvm/ZfSExlemFMKjBtZb@google.com/
- Add tdx_check_exit_reason() to check a VMX exit reason against the
  status code of TDH.VP.ENTER.
- Move the handling of TDX_ERROR_SEPT_BUSY and (TDX_OPERAND_BUSY |
  TDX_OPERAND_ID_TD_EPOCH) into fast path, and add a helper function
  tdx_exit_handlers_fastpath().
- Remove the warning on TDX_SW_ERROR in fastpath, but return without
  further handling.
- Call kvm_machine_check() for EXIT_REASON_MCE_DURING_VMENTRY, align
  with VMX case.
- On failed_vmentry in fast path, return without further handling.
- Exit to userspace for #UD and #GP.
- Fix whitespace in tdx_get_exit_info()
- Add a comment in tdx_handle_exit() to describe failed_vmentry case
  is handled by TDX_NON_RECOVERABLE handling.
- Move the code of handling NMI, exception and external interrupts out
  of the patch, i.e., the NMI handling in tdx_vcpu_enter_exit() and the
  wiring of .handle_exit_irqoff() are removed.
- Drop the check for VCPU_TD_STATE_INITIALIZED in tdx_handle_exit()
  because it has been checked in tdx_vcpu_pre_run().
- Update changelog.
---
 arch/x86/include/asm/tdx.h   |   1 +
 arch/x86/kvm/vmx/main.c      |  38 +++++++++-
 arch/x86/kvm/vmx/tdx.c       | 141 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h       |   2 +
 arch/x86/kvm/vmx/tdx_errno.h |   3 +
 arch/x86/kvm/vmx/x86_ops.h   |   8 ++
 6 files changed, 189 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 8a47a69c148e..897db9392d7d 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -18,6 +18,7 @@
  * TDX module.
  */
 #define TDX_ERROR			_BITUL(63)
+#define TDX_NON_RECOVERABLE		_BITUL(62)
 #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
 #define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 341aa537ca72..7f1318c44040 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -169,6 +169,15 @@ static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	return vmx_vcpu_run(vcpu, force_immediate_exit);
 }
 
+static int vt_handle_exit(struct kvm_vcpu *vcpu,
+			  enum exit_fastpath_completion fastpath)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_handle_exit(vcpu, fastpath);
+
+	return vmx_handle_exit(vcpu, fastpath);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -216,6 +225,29 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static void vt_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info, u32 *error_code)
+{
+	*intr_info = 0;
+	*error_code = 0;
+
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_get_entry_info(vcpu, intr_info, error_code);
+}
+
+static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_get_exit_info(vcpu, reason, info1, info2, intr_info,
+				  error_code);
+		return;
+	}
+
+	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -310,7 +342,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.vcpu_pre_run = vt_vcpu_pre_run,
 	.vcpu_run = vt_vcpu_run,
-	.handle_exit = vmx_handle_exit,
+	.handle_exit = vt_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
@@ -344,8 +376,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
 
-	.get_exit_info = vmx_get_exit_info,
-	.get_entry_info = vmx_get_entry_info,
+	.get_exit_info = vt_get_exit_info,
+	.get_entry_info = vt_get_entry_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0863bdaf761a..cb64675e6ad9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -807,17 +807,70 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
 		!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES));
 }
 
+static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
+	case TDX_SUCCESS:
+	case TDX_NON_RECOVERABLE_VCPU:
+	case TDX_NON_RECOVERABLE_TD:
+	case TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE:
+	case TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE:
+		break;
+	default:
+		return -1u;
+	}
+
+	return tdx->vp_enter_ret;
+}
+
 static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 
 	guest_state_enter_irqoff();
 
 	tdx->vp_enter_ret = tdh_vp_enter(&tdx->vp, &tdx->vp_enter_args);
 
+	vt->exit_reason.full = tdx_to_vmx_exit_reason(vcpu);
+
+	vt->exit_qualification = tdx->vp_enter_args.rcx;
+	tdx->ext_exit_qualification = tdx->vp_enter_args.rdx;
+	tdx->exit_gpa = tdx->vp_enter_args.r8;
+	vt->exit_intr_info = tdx->vp_enter_args.r9;
+
 	guest_state_exit_irqoff();
 }
 
+static bool tdx_failed_vmentry(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_exit_reason(vcpu).failed_vmentry &&
+	       vmx_get_exit_reason(vcpu).full != -1u;
+}
+
+static fastpath_t tdx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	u64 vp_enter_ret = to_tdx(vcpu)->vp_enter_ret;
+
+	/*
+	 * TDX_OPERAND_BUSY could be returned for SEPT due to 0-step mitigation
+	 * or for TD EPOCH due to contention with TDH.MEM.TRACK on TDH.VP.ENTER.
+	 *
+	 * When KVM requests KVM_REQ_OUTSIDE_GUEST_MODE, which has both
+	 * KVM_REQUEST_WAIT and KVM_REQUEST_NO_ACTION set, it requires target
+	 * vCPUs leaving fastpath so that interrupt can be enabled to ensure the
+	 * IPIs can be delivered. Return EXIT_FASTPATH_EXIT_HANDLED instead of
+	 * EXIT_FASTPATH_REENTER_GUEST to exit fastpath, otherwise, the
+	 * requester may be blocked endlessly.
+	 */
+	if (unlikely(tdx_operand_busy(vp_enter_ret)))
+		return EXIT_FASTPATH_EXIT_HANDLED;
+
+	return EXIT_FASTPATH_NONE;
+}
+
 #define TDX_REGS_UNSUPPORTED_SET	(BIT(VCPU_EXREG_RFLAGS) |	\
 					 BIT(VCPU_EXREG_SEGMENTS))
 
@@ -863,9 +916,18 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 	vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
 
+	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
+		return EXIT_FASTPATH_NONE;
+
+	if (unlikely(vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
+		kvm_machine_check();
+
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
-	return EXIT_FASTPATH_NONE;
+	if (unlikely(tdx_failed_vmentry(vcpu)))
+		return EXIT_FASTPATH_NONE;
+
+	return tdx_exit_handlers_fastpath(vcpu);
 }
 
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
@@ -1155,6 +1217,83 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn_to_page(pfn));
 }
 
+int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u64 vp_enter_ret = tdx->vp_enter_ret;
+	union vmx_exit_reason exit_reason = vmx_get_exit_reason(vcpu);
+
+	if (fastpath != EXIT_FASTPATH_NONE)
+		return 1;
+
+	/*
+	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
+	 * TDX_SEAMCALL_VMFAILINVALID.
+	 */
+	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
+		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
+		goto unhandled_exit;
+	}
+
+	if (unlikely(tdx_failed_vmentry(vcpu))) {
+		/*
+		 * If the guest state is protected, that means off-TD debug is
+		 * not enabled, TDX_NON_RECOVERABLE must be set.
+		 */
+		WARN_ON_ONCE(vcpu->arch.guest_state_protected &&
+				!(vp_enter_ret & TDX_NON_RECOVERABLE));
+		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		vcpu->run->fail_entry.hardware_entry_failure_reason = exit_reason.full;
+		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
+		return 0;
+	}
+
+	if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE)) &&
+		exit_reason.basic != EXIT_REASON_TRIPLE_FAULT) {
+		kvm_pr_unimpl("TD vp_enter_ret 0x%llx\n", vp_enter_ret);
+		goto unhandled_exit;
+	}
+
+	WARN_ON_ONCE(exit_reason.basic != EXIT_REASON_TRIPLE_FAULT &&
+		     (vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
+
+	switch (exit_reason.basic) {
+	case EXIT_REASON_TRIPLE_FAULT:
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		vcpu->mmio_needed = 0;
+		return 0;
+	default:
+		break;
+	}
+
+unhandled_exit:
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = vp_enter_ret;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	return 0;
+}
+
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	*reason = tdx->vt.exit_reason.full;
+	if (*reason != -1u) {
+		*info1 = vmx_get_exit_qual(vcpu);
+		*info2 = tdx->ext_exit_qualification;
+		*intr_info = vmx_get_intr_info(vcpu);
+	} else {
+		*info1 = 0;
+		*info2 = 0;
+		*intr_info = 0;
+	}
+
+	*error_code = 0;
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8339bbf0fdd4..0e3522e423cc 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -46,6 +46,8 @@ enum vcpu_tdx_state {
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 	struct vcpu_vt vt;
+	u64 ext_exit_qualification;
+	gpa_t exit_gpa;
 	struct tdx_module_args vp_enter_args;
 
 	struct tdx_vp vp;
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index f9dbb3a065cc..6ff4672c4181 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -10,6 +10,9 @@
  * TDX SEAMCALL Status Codes (returned in RAX)
  */
 #define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
+#define TDX_NON_RECOVERABLE_TD			0x4000000200000000ULL
+#define TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE	0x6000000500000000ULL
+#define TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE	0x6000000700000000ULL
 #define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
 #define TDX_OPERAND_INVALID			0xC000010000000000ULL
 #define TDX_OPERAND_BUSY			0x8000020000000000ULL
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f856eac8f1e8..92716f6486e9 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -135,6 +135,10 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
+int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath);
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -169,6 +173,10 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
 }
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
+static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath) { return 0; }
+static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
+				     u64 *info2, u32 *intr_info, u32 *error_code) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.46.0


