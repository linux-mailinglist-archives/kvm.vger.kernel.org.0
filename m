Return-Path: <kvm+bounces-32791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 081FD9DF491
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 04:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60E69162C92
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 03:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E4069D2B;
	Sun,  1 Dec 2024 03:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="diMdgVRU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B84F4207A;
	Sun,  1 Dec 2024 03:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733025123; cv=none; b=YQbSoNimKjA9ncZuyK59t2lXduUXqVeVrjBsxpjVrG6YuE7r22DlQBikwI5okq/9f/B+Wljw3LWs6jem1Ix90Fnmh/3qoSnSdbHDA7xshhpqXBPSP2945G38h0MDhexvgP2N8C8im+CzcF0/v1DsP1unyB1kFZyLCGnsvopTHuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733025123; c=relaxed/simple;
	bh=hkw9rG4cKA1zT1DbXIMaMT1/XactRoQ3dJeEtIMgxu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilZ29Tm79akCAxWb2f7rB1ohyqOIH+GTUUCOpfNNopXO5aoIV+ni9wCnLNaBVKnZjgO5GGjSKbDbxiGQABXdI9OnuzVyUqJOgfjSq+V/i+n3+w7BQWSCQI41dnpTx+E3EzMsMbLl+k+pbc3tEcRB8B1W2GHuc7izKlmF30TMxPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=diMdgVRU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733025121; x=1764561121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hkw9rG4cKA1zT1DbXIMaMT1/XactRoQ3dJeEtIMgxu4=;
  b=diMdgVRUEpKtsQa8mk4m5Jt/nm8Hg7Wce8B2fe7gIDc7Q6SdfU+8x7sG
   4MB0zYAPyhBICiuUS+CvaDoQB+T/Nss8WfGVGqbnzE1VHp3+uOg2DJQJo
   vdajsTO1BIQKyfZwJwt+wwOQu0aHJrhqLQXdxk309mN0MTVQ2aaqGY+H0
   SnZBoc0vp3lxHBm/oIJBPXZJVrldnmNK9M5qlsAh8e1ehTIFQj7XruX8E
   oxgUVUYRB8iofKIWAUH8Fr0hUQp28WCh/JSYCePmWxSc81NYouvZvZxC+
   lTqR+S3IBwNstQJIy1Xkj3xY/RG5pSVfqZOzReRMXchdPAhFqn5U+ydV7
   g==;
X-CSE-ConnectionGUID: 7dH7l/ytQLS+sML98QTYGw==
X-CSE-MsgGUID: 6oRVV6dnSyeG2jN+hAX61w==
X-IronPort-AV: E=McAfee;i="6700,10204,11272"; a="50725096"
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="50725096"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:00 -0800
X-CSE-ConnectionGUID: OBbNCpiVSoqAoz5k45kAUg==
X-CSE-MsgGUID: X/VkhGZXQOiNHwDaQODcmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="93257481"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:51:57 -0800
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
	michael.roth@amd.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 1/7] KVM: TDX: Add a place holder to handle TDX VM exit
Date: Sun,  1 Dec 2024 11:53:50 +0800
Message-ID: <20241201035358.2193078-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce the wiring for handling TDX VM exits by implementing the
callbacks .get_exit_info(), and .handle_exit().  Additionally, add
error handling during the TDX VM exit flow, and add a place holder
to handle various exit reasons.  Add helper functions to retrieve
exit information, exit qualifications, and more.

Contention Handling: The TDH.VP.ENTER operation may contend with TDH.MEM.*
operations for secure EPT or TD EPOCH.  If contention occurs, the return
value will have TDX_OPERAND_BUSY set with operand type, prompting the vCPU
to attempt re-entry into the guest via the fast path.

Error Handling: The following scenarios will return to userspace with
KVM_EXIT_INTERNAL_ERROR.
- TDX_SW_ERROR: This includes #UD caused by SEAMCALL instruction if the
  CPU isn't in VMX operation, #GP caused by SEAMCALL instruction when TDX
  isn't enabled by the BIOS, and TDX_SEAMCALL_VMFAILINVALID when SEAM
  firmware is not loaded or disabled.
- TDX_ERROR: This indicates some check failed in the TDX module, preventing
  the vCPU from running.
- TDX_NON_RECOVERABLE: Set by the TDX module when the error is
  non-recoverable, indicating that the TDX guest is dead or the vCPU is
  disabled.  This also covers failed_vmentry case, which must have
  TDX_NON_RECOVERABLE set since off-TD debug feature has not been enabled.
  An exception is the triple fault, which also sets TDX_NON_RECOVERABLE
  but exits to userspace with KVM_EXIT_SHUTDOWN, aligning with the VMX
  case.
- Any unhandled VM exit reason will also return to userspace with
  KVM_EXIT_INTERNAL_ERROR.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace breakout:
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
 arch/x86/kvm/vmx/main.c      |  25 +++++-
 arch/x86/kvm/vmx/tdx.c       | 164 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx_errno.h |   3 +
 arch/x86/kvm/vmx/x86_ops.h   |   8 ++
 5 files changed, 198 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 77477b905dca..01409a59224d 100644
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
index f8acb1dc7c10..4f6faeb6e8e5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -165,6 +165,15 @@ static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
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
@@ -212,6 +221,18 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
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
@@ -305,7 +326,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.vcpu_pre_run = vt_vcpu_pre_run,
 	.vcpu_run = vt_vcpu_run,
-	.handle_exit = vmx_handle_exit,
+	.handle_exit = vt_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
@@ -340,7 +361,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
 
-	.get_exit_info = vmx_get_exit_info,
+	.get_exit_info = vt_get_exit_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f975bb323f60..3dcbdb5a7bf8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -186,6 +186,54 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
 }
 
+static __always_inline union vmx_exit_reason tdexit_exit_reason(struct kvm_vcpu *vcpu)
+{
+	return (union vmx_exit_reason)(u32)(to_tdx(vcpu)->vp_enter_ret);
+}
+
+/*
+ * There is no simple way to check some bit(s) to decide whether the return
+ * value of TDH.VP.ENTER has a VMX exit reason or not.  E.g.,
+ * TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE has exit reason but with error bit
+ * (bit 63) set, TDX_NON_RECOVERABLE_TD_CORRUPTED_MD has no exit reason but with
+ * error bit cleared.
+ */
+static __always_inline bool tdx_has_exit_reason(struct kvm_vcpu *vcpu)
+{
+	u64 status = to_tdx(vcpu)->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK;
+
+	return status == TDX_SUCCESS || status == TDX_NON_RECOVERABLE_VCPU ||
+	       status == TDX_NON_RECOVERABLE_TD ||
+	       status == TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE ||
+	       status == TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE;
+}
+
+static __always_inline bool tdx_check_exit_reason(struct kvm_vcpu *vcpu, u16 reason)
+{
+	return tdx_has_exit_reason(vcpu) &&
+	       (u16)tdexit_exit_reason(vcpu).basic == reason;
+}
+
+static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rcx_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rdx_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
+{
+	return kvm_r8_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
+{
+	return kvm_r9_read(vcpu);
+}
+
 static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
@@ -824,6 +872,21 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	guest_state_exit_irqoff();
 }
 
+static fastpath_t tdx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	u64 vp_enter_ret = to_tdx(vcpu)->vp_enter_ret;
+
+	/* See the comment of tdx_seamcall_sept(). */
+	if (unlikely(vp_enter_ret == TDX_ERROR_SEPT_BUSY))
+		return EXIT_FASTPATH_REENTER_GUEST;
+
+	/* TDH.VP.ENTER checks TD EPOCH which can contend with TDH.MEM.TRACK. */
+	if (unlikely(vp_enter_ret == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_TD_EPOCH)))
+		return EXIT_FASTPATH_REENTER_GUEST;
+
+	return EXIT_FASTPATH_NONE;
+}
+
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -837,9 +900,26 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	tdx->prep_switch_state = TDX_PREP_SW_STATE_UNRESTORED;
 
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
+
+	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
+		return EXIT_FASTPATH_NONE;
+
+	if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_MCE_DURING_VMENTRY)))
+		kvm_machine_check();
+
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
-	return EXIT_FASTPATH_NONE;
+	if (unlikely(tdx_has_exit_reason(vcpu) && tdexit_exit_reason(vcpu).failed_vmentry))
+		return EXIT_FASTPATH_NONE;
+
+	return tdx_exit_handlers_fastpath(vcpu);
+}
+
+static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+	vcpu->mmio_needed = 0;
+	return 0;
 }
 
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
@@ -1135,6 +1215,88 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
 }
 
+int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u64 vp_enter_ret = tdx->vp_enter_ret;
+	union vmx_exit_reason exit_reason;
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
+	/*
+	 * Without off-TD debug enabled, failed_vmentry case must have
+	 * TDX_NON_RECOVERABLE set.
+	 */
+	if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE))) {
+		/* Triple fault is non-recoverable. */
+		if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_TRIPLE_FAULT)))
+			return tdx_handle_triple_fault(vcpu);
+
+		kvm_pr_unimpl("TD vp_enter_ret 0x%llx, hkid 0x%x hkid pa 0x%llx\n",
+			      vp_enter_ret, to_kvm_tdx(vcpu->kvm)->hkid,
+			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
+		goto unhandled_exit;
+	}
+
+	/* From now, the seamcall status should be TDX_SUCCESS. */
+	WARN_ON_ONCE((vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
+	exit_reason = tdexit_exit_reason(vcpu);
+
+	switch (exit_reason.basic) {
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
+	if (tdx_has_exit_reason(vcpu)) {
+		/*
+		 * Encode some useful info from the the 64 bit return code
+		 * into the 32 bit exit 'reason'. If the VMX exit reason is
+		 * valid, just set it to those bits.
+		 */
+		*reason = (u32)tdx->vp_enter_ret;
+		*info1 = tdexit_exit_qual(vcpu);
+		*info2 = tdexit_ext_exit_qual(vcpu);
+	} else {
+		/*
+		 * When the VMX exit reason in vp_enter_ret is not valid,
+		 * overload the VMX_EXIT_REASONS_FAILED_VMENTRY bit (31) to
+		 * mean the vmexit code is not valid. Set the other bits to
+		 * try to avoid picking a value that may someday be a valid
+		 * VMX exit code.
+		 */
+		*reason = 0xFFFFFFFF;
+		*info1 = 0;
+		*info2 = 0;
+	}
+
+	*intr_info = tdexit_intr_info(vcpu);
+	*error_code = 0;
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
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
index 02b33390e1bf..1c18943e0e1d 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -133,6 +133,10 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
+int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath);
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -167,6 +171,10 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
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


