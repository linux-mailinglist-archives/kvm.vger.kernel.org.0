Return-Path: <kvm+bounces-6669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB949837855
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:14:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C0AC28BF58
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA6B374E1F;
	Mon, 22 Jan 2024 23:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NYpKEAf1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D4D6A33D;
	Mon, 22 Jan 2024 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967763; cv=none; b=TdPr09FWzBT9mZ8kD0NVPifydEXfdjtNI/ujHPd6YaV0V73V9X/WikRrbu8mes75wVWdN+ajA6/R/ILR8ucL5HLiWD3kJh1vBF/yElULHgGfolh8dXpwbs4oVGjVkomo/PrNaVGdZiasqiRJQLtv1/oxiG7nDvwOWp6c/X0zlSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967763; c=relaxed/simple;
	bh=DixcZBLJerRFfFWkfzdVFq9may1qHuF9NoiKMUV+Ksg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E6XHa3xkVUBAejaydxw8rytFTL7qheOhSSh+y3vFAm3V9kXsjXnpMU4uqF7MaFL/ALRv2Hmpl2YuB/xuajv/6n6EuLeaXJWphCb/h7CDwJUvlp5IVwnRX80iSsZxxSMkk4r/ng50h4M85I9C+ZLGGyyPoF41pbA4825pBAfvXg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NYpKEAf1; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967760; x=1737503760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DixcZBLJerRFfFWkfzdVFq9may1qHuF9NoiKMUV+Ksg=;
  b=NYpKEAf1AMXLnejGUZfNyrP+0dpafdxkJTKrco5JutRGj0GRXwvpklC/
   C+urIRCfxyu2fpLhyDgyzQonoC8wxl4+PxuUTp5rbZlWPv8PJ3B8/Rn+0
   FrJHphcXZf9Pz55cH7q4w1uN41kwImfZz23Lpz6PgGEl2nlLp+WinC+xu
   RSkPnkl82lhf0WKG4Sl0eWOqC1KhrvmWYdRKPliDPXAV30Iib4JInMUYq
   KKIVyCQ1Bo2Gu1aOWzxECPyCPToRAujruU6C7Wyt/UrJN/oq49nfy4LnD
   FkmlJvNUG9mzcKmVFIgQWmJ1j8/TGaDPX9ayRda7qCZw9f9AjuOv48FhM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016512"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016512"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468239"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:39 -0800
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
Subject: [PATCH v18 067/121] KVM: TDX: Implement TDX vcpu enter/exit path
Date: Mon, 22 Jan 2024 15:53:43 -0800
Message-Id: <421905898dfe4966168bc0b7c29b7bcf682b440e.1705965635.git.isaku.yamahata@intel.com>
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

This patch implements running TDX vcpu.  Once vcpu runs on the logical
processor (LP), the TDX vcpu is associated with it.  When the TDX vcpu
moves to another LP, the TDX vcpu needs to flush its status on the LP.
When destroying TDX vcpu, it needs to complete flush and flush cpu memory
cache.  Track which LP the TDX vcpu run and flush it as necessary.

Do nothing on sched_in event as TDX doesn't support pause loop.

TDX vcpu execution requires restoring PMU debug store after returning back
to KVM because the TDX module unconditionally resets the value.  To reuse
the existing code, export perf_restore_debug_store.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v15 -> v16:
- use __seamcall_saved_ret()
- As struct tdx_module_args doesn't match with vcpu.arch.regs, copy regs
  before/after calling __seamcall_saved_ret().
---
 arch/x86/kvm/vmx/main.c    | 21 +++++++++-
 arch/x86/kvm/vmx/tdx.c     | 84 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     | 33 +++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 +
 arch/x86/kvm/x86.c         |  1 +
 5 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0784290d846f..89ab8411500d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -173,6 +173,23 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_vcpu_reset(vcpu, init_event);
 }
 
+static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		/* Unconditionally continue to vcpu_run(). */
+		return 1;
+
+	return vmx_vcpu_pre_run(vcpu);
+}
+
+static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_run(vcpu);
+
+	return vmx_vcpu_run(vcpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -325,8 +342,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.flush_tlb_gva = vt_flush_tlb_gva,
 	.flush_tlb_guest = vt_flush_tlb_guest,
 
-	.vcpu_pre_run = vmx_vcpu_pre_run,
-	.vcpu_run = vmx_vcpu_run,
+	.vcpu_pre_run = vt_vcpu_pre_run,
+	.vcpu_run = vt_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index faa04d8922b6..5a64ac4fd5fb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -11,6 +11,9 @@
 #include "vmx.h"
 #include "x86.h"
 
+#include <trace/events/kvm.h>
+#include "trace.h"
+
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -541,6 +544,87 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 }
 
+static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx *tdx)
+{
+	struct tdx_module_args args;
+
+	/*
+	 * Avoid section mismatch with to_tdx() with KVM_VM_BUG().  The caller
+	 * should call to_tdx().
+	 */
+	struct kvm_vcpu *vcpu = &tdx->vcpu;
+
+	guest_state_enter_irqoff();
+
+	/*
+	 * TODO: optimization:
+	 * - Eliminate copy between args and vcpu->arch.regs.
+	 * - copyin/copyout registers only if (tdx->tdvmvall.regs_mask != 0)
+	 *   which means TDG.VP.VMCALL.
+	 */
+	args = (struct tdx_module_args) {
+		.rcx = tdx->tdvpr_pa,
+#define REG(reg, REG)	.reg = vcpu->arch.regs[VCPU_REGS_ ## REG]
+		REG(rdx, RDX),
+		REG(r8,  R8),
+		REG(r9,  R9),
+		REG(r10, R10),
+		REG(r11, R11),
+		REG(r12, R12),
+		REG(r13, R13),
+		REG(r14, R14),
+		REG(r15, R15),
+		REG(rbx, RBX),
+		REG(rdi, RDI),
+		REG(rsi, RSI),
+#undef REG
+	};
+
+	tdx->exit_reason.full = __seamcall_saved_ret(TDH_VP_ENTER, &args);
+
+#define REG(reg, REG)	vcpu->arch.regs[VCPU_REGS_ ## REG] = args.reg
+		REG(rcx, RCX);
+		REG(rdx, RDX);
+		REG(r8,  R8);
+		REG(r9,  R9);
+		REG(r10, R10);
+		REG(r11, R11);
+		REG(r12, R12);
+		REG(r13, R13);
+		REG(r14, R14);
+		REG(r15, R15);
+		REG(rbx, RBX);
+		REG(rdi, RDI);
+		REG(rsi, RSI);
+#undef REG
+
+	WARN_ON_ONCE(!kvm_rebooting &&
+		     (tdx->exit_reason.full & TDX_SW_ERROR) == TDX_SW_ERROR);
+
+	guest_state_exit_irqoff();
+}
+
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (unlikely(!tdx->initialized))
+		return -EINVAL;
+	if (unlikely(vcpu->kvm->vm_bugged)) {
+		tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
+		return EXIT_FASTPATH_NONE;
+	}
+
+	trace_kvm_entry(vcpu);
+
+	tdx_vcpu_enter_exit(tdx);
+
+	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
+	trace_kvm_exit(vcpu, KVM_ISA_VMX);
+
+	return EXIT_FASTPATH_NONE;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index d589a2caedfb..45b0b88a9b28 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -25,6 +25,37 @@ struct kvm_tdx {
 	u64 tsc_offset;
 };
 
+union tdx_exit_reason {
+	struct {
+		/* 31:0 mirror the VMX Exit Reason format */
+		u64 basic		: 16;
+		u64 reserved16		: 1;
+		u64 reserved17		: 1;
+		u64 reserved18		: 1;
+		u64 reserved19		: 1;
+		u64 reserved20		: 1;
+		u64 reserved21		: 1;
+		u64 reserved22		: 1;
+		u64 reserved23		: 1;
+		u64 reserved24		: 1;
+		u64 reserved25		: 1;
+		u64 bus_lock_detected	: 1;
+		u64 enclave_mode	: 1;
+		u64 smi_pending_mtf	: 1;
+		u64 smi_from_vmx_root	: 1;
+		u64 reserved30		: 1;
+		u64 failed_vmentry	: 1;
+
+		/* 63:32 are TDX specific */
+		u64 details_l1		: 8;
+		u64 class		: 8;
+		u64 reserved61_48	: 14;
+		u64 non_recoverable	: 1;
+		u64 error		: 1;
+	};
+	u64 full;
+};
+
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
@@ -32,6 +63,8 @@ struct vcpu_tdx {
 	unsigned long *tdvpx_pa;
 	bool td_vcpu_created;
 
+	union tdx_exit_reason exit_reason;
+
 	bool initialized;
 
 	/*
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 5a9aabf39c02..9061284487e8 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -150,6 +150,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -177,6 +178,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eee63b08f14f..2371a8df9be3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -315,6 +315,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 };
 
 u64 __read_mostly host_xcr0;
+EXPORT_SYMBOL_GPL(host_xcr0);
 
 static struct kmem_cache *x86_emulator_cache;
 
-- 
2.25.1


