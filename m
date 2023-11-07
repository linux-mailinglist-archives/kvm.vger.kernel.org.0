Return-Path: <kvm+bounces-948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E86217E4294
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D369281360
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDEF315A5;
	Tue,  7 Nov 2023 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gBPJuW0K"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B3136AF3
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:00:40 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627F04498;
	Tue,  7 Nov 2023 07:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369213; x=1730905213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=puhPCTNcDrlP7tM7JxEjGytPeDk9ee3vHbmdF80CzHg=;
  b=gBPJuW0K5JmjqTYOTlhJG4wKbCscYMNGsR9iLzojRDF9ssCi9xme3+6h
   JHRG+G5Owg/sdp8Ot3wj8W5GkozvrDafZBZ7FzOw0NZa6zAloLum/6ani
   dRtLD668OUYlp7Z+QqAhOuEZZc7/iP/a8U9FSS8H739QJgnu4eGY7pfRP
   OOTbpwkjmDq+Jm34GXmQW3zZB70ZH0Ing+X8ssl1bLhZcohZBxpDONG4a
   0/DGek1l986IcUStR97UxaAFJQYCj1a4XmZrIhv7WP1InZmFhveDmginG
   IPOdkg8bsCDO22XSCQ8J5dIDOzNu33EqmnlbTuM+VDW87Fl3kguENCj6+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462417"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462417"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851449"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:17 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 062/116] KVM: TDX: Implement TDX vcpu enter/exit path
Date: Tue,  7 Nov 2023 06:56:28 -0800
Message-Id: <752d42280428f2db02ed5d8a00f44c1546ce66b4.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
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
index bbc6aedf6e0c..f78365f52296 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -169,6 +169,23 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -321,8 +338,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index caf7eb331487..c1127a12a0e1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -10,6 +10,9 @@
 #include "vmx.h"
 #include "x86.h"
 
+#include <trace/events/kvm.h>
+#include "trace.h"
+
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -465,6 +468,87 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
index 4ae9cd66cefc..04942488e6d1 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -25,12 +25,45 @@ struct kvm_tdx {
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
 
 	unsigned long tdvpr_pa;
 	unsigned long *tdvpx_pa;
 
+	union tdx_exit_reason exit_reason;
+
 	bool initialized;
 
 	/*
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 810b8e7c41e2..9f3cc97fae41 100644
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
index cb695aa8fe20..d57633ab9b70 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -315,6 +315,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 };
 
 u64 __read_mostly host_xcr0;
+EXPORT_SYMBOL_GPL(host_xcr0);
 
 static struct kmem_cache *x86_emulator_cache;
 
-- 
2.25.1


