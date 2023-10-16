Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727617CAECD
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjJPQTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjJPQS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:18:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7761ED42;
        Mon, 16 Oct 2023 09:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473054; x=1729009054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=meWSAO3wRMzJGDcSjU0Yaya0L1JIfRVehLc/go6idwI=;
  b=Zh9ND3VaBMZtQ/6gnZxI0tETjCMHr41sWfdAUFky2//YqkBxmu98X1Qr
   KsKwZDZzmHf9UuRYP1h5eDEmcriiRww6hqSH+59wt5h76NTFpnUanftUW
   /L8aiFgdM3IxUwiXjGD3Mo+IvsmdYqtLVg3CTvTlHEA9d73rBjYhHoqb0
   rOIrirlfZJjZ7wVFO7wlJmpprYcWcG6RDbXQUpYRhkHIH6aRl/+Urqbws
   B9WAt3K4Jt7FvpTN8FSoapblaQI7FUvRe6AOACnu+7n4bpZzBIJK3d1UJ
   +ME+OGxSaSq3SD3e8WCbHsnYedKbwW5FmVCsSMt8LHcnWrtit2ZBoBzfk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921860"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921860"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448182"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448182"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 062/116] KVM: TDX: Implement TDX vcpu enter/exit path
Date:   Mon, 16 Oct 2023 09:14:14 -0700
Message-Id: <67e4e5acd151ad188aa258d79a94d554199eca8e.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 22b9d44ee29f..c45b8fc3e8d3 100644
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
index f4a8f57c2b35..7b5d0556ad95 100644
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
index e2a8b59adf2d..87cfa1c5afa3 100644
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
index 69d9d15ef70d..f524a7d3fda8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -315,6 +315,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 };
 
 u64 __read_mostly host_xcr0;
+EXPORT_SYMBOL_GPL(host_xcr0);
 
 static struct kmem_cache *x86_emulator_cache;
 
-- 
2.25.1

