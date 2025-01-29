Return-Path: <kvm+bounces-36831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC149A21A9A
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09F181885AF4
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE06C1B4141;
	Wed, 29 Jan 2025 10:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIr8tV4j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881BA1BD03F;
	Wed, 29 Jan 2025 10:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144806; cv=none; b=tTAjwfabDivRsX05AWrgs4GRPU2Bs9Ze60JOZvWFOrAQHSs0YcoyHi2xNYZcAFv6SlCwlr5aEow2c2B0BOZNrtHk5bNPhTpM8NeFUecqntEdS4nzc7B7sfM8ZyNeH05SjuhY0WnWWWMDMf4JWBEXu29V7ymosEK+iK7nc4YqFT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144806; c=relaxed/simple;
	bh=qTeY++NE1GntEjApCuhtFHvsTJ/xj4PR1DRLDQ6kphM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0aI7OxYVISrEqgVIsG55JBNdKTFXVRiA3jXyC991mh9nAZw05+tMRLCMn0+pueThxSCUEuxVOqmmxnRmw4x7cSPb8weFM30cUaHD1pVUgScbYCVBzvl9ZxFkwZHsvHubAViOkLEghhZLzmX2iUUortry4U7M/pfrQWSYibpPcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIr8tV4j; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144805; x=1769680805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qTeY++NE1GntEjApCuhtFHvsTJ/xj4PR1DRLDQ6kphM=;
  b=bIr8tV4jzqeciKwKQvt3/iyOG3VJZFJV9hcnYpqLyn8mdLcYQ9okF8lI
   F0036huFe/eWX38HEBTBO69YMevzhMYenZwVDE8Z7F2ZxafG7SMX6SsSp
   JvNW6NoXkfQP3Yq50Ij0p8TIv0WTkhdgbf4FvSipHB7c1mRBAz7DPO3Wx
   YmjiXHt3R28sdXTOYYm1gUjrn7DzOqH98u+n+Jo8jbGJrKuCaF3X7cT6/
   vRETmuJZyuNFGbOt1Ies8e/T1bdot0iJCUM+PsnUNFzx9vukDS7CEPB+/
   xwJj2eOQh9HKc/ydxRFX9gRidjp+yTq19LsrZeK1ETNdkVTFB34xQi7Vf
   A==;
X-CSE-ConnectionGUID: P6nHZIVFRlqzmrzYKhlj/g==
X-CSE-MsgGUID: UrmCUfc2QDqjqUCzmEM9aA==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50036019"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50036019"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:44 -0800
X-CSE-ConnectionGUID: GB/2mLpTSrCJQMBuP2LN+Q==
X-CSE-MsgGUID: pNKRLv3ZTleGWuRBaEvUcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262676"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:39 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 05/12] KVM: TDX: Implement TDX vcpu enter/exit path
Date: Wed, 29 Jan 2025 11:58:54 +0200
Message-ID: <20250129095902.16391-6-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement callbacks to enter/exit a TDX VCPU by calling tdh_vp_enter().
Ensure the TDX VCPU is in a correct state to run.

Do not pass arguments from/to vcpu->arch.regs[] unconditionally. Instead,
marshall state to/from the appropriate x86 registers only when needed,
i.e., to handle some TDVMCALL sub-leaves following KVM's ABI to leverage
the existing code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v2:
- Move VCPU_TD_STATE_INITIALIZED check to tdx_vcpu_pre_run() (Xiaoyao)
- Check TD_STATE_RUNNABLE also in tdx_vcpu_pre_run() (Yan)
- Add back 'noinstr' for tdx_vcpu_enter_exit() (Sean)
- Add WARN_ON_ONCE if force_immediate_exit (Sean)
- Add vp_enter_args to vcpu_tdx to store the input/output arguments for
  tdh_vp_enter().
- Don't copy arguments to/from vcpu->arch.regs[] unconditionally. (Sean)

TD vcpu enter/exit v1:
- Make argument of tdx_vcpu_enter_exit() struct kvm_vcpu.
- Update for the wrapper functions for SEAMCALLs. (Sean)
- Remove noinstr (Sean)
- Add a missing comma, clarify sched_in part, and update changelog to
  match code by dropping the PMU related paragraph (Binbin)
  https://lore.kernel.org/lkml/c0029d4d-3dee-4f11-a929-d64d2651bfb3@linux.intel.com/
- Remove the union tdx_exit_reason. (Sean)
  https://lore.kernel.org/kvm/ZfSExlemFMKjBtZb@google.com/
- Remove the code of special handling of vcpu->kvm->vm_bugged (Rick)
  https://lore.kernel.org/kvm/20240318234010.GD1645738@ls.amr.corp.intel.com/
- For !tdx->initialized case, set tdx->vp_enter_ret to TDX_SW_ERROR to avoid
  collision with EXIT_REASON_EXCEPTION_NMI.

v19:
- Removed export_symbol_gpl(host_xcr0) to the patch that uses it

Changes v15 -> v16:
- use __seamcall_saved_ret()
- As struct tdx_module_args doesn't match with vcpu.arch.regs, copy regs
  before/after calling __seamcall_saved_ret().
---
 arch/x86/kvm/vmx/main.c    | 20 ++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 47 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |  3 +++
 arch/x86/kvm/vmx/x86_ops.h |  7 ++++++
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 1cc1c06461f2..301c1a26606f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -133,6 +133,22 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx_vcpu_load(vcpu, cpu);
 }
 
+static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_pre_run(vcpu);
+
+	return vmx_vcpu_pre_run(vcpu);
+}
+
+static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_run(vcpu, force_immediate_exit);
+
+	return vmx_vcpu_run(vcpu, force_immediate_exit);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -272,8 +288,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index a7ebdafdfd82..95420ffd0022 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -11,6 +11,8 @@
 #include "vmx.h"
 #include "mmu/spte.h"
 #include "common.h"
+#include <trace/events/kvm.h>
+#include "trace.h"
 
 #pragma GCC poison to_vmx
 
@@ -673,6 +675,51 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
 }
 
+int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(to_tdx(vcpu)->state != VCPU_TD_STATE_INITIALIZED ||
+		     to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE))
+		return -EINVAL;
+
+	return 1;
+}
+
+static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	guest_state_enter_irqoff();
+
+	tdx->vp_enter_ret = tdh_vp_enter(&tdx->vp, &tdx->vp_enter_args);
+
+	guest_state_exit_irqoff();
+}
+
+#define TDX_REGS_UNSUPPORTED_SET	(BIT(VCPU_EXREG_RFLAGS) |	\
+					 BIT(VCPU_EXREG_SEGMENTS))
+
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+{
+	/*
+	 * force_immediate_exit requires vCPU entering for events injection with
+	 * an immediately exit followed. But The TDX module doesn't guarantee
+	 * entry, it's already possible for KVM to _think_ it completely entry
+	 * to the guest without actually having done so.
+	 * Since KVM never needs to force an immediate exit for TDX, and can't
+	 * do direct injection, just warn on force_immediate_exit.
+	 */
+	WARN_ON_ONCE(force_immediate_exit);
+
+	trace_kvm_entry(vcpu, force_immediate_exit);
+
+	tdx_vcpu_enter_exit(vcpu);
+
+	vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
+
+	trace_kvm_exit(vcpu, KVM_ISA_VMX);
+
+	return EXIT_FASTPATH_NONE;
+}
 
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ba880dae547f..8339bbf0fdd4 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -46,11 +46,14 @@ enum vcpu_tdx_state {
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 	struct vcpu_vt vt;
+	struct tdx_module_args vp_enter_args;
 
 	struct tdx_vp vp;
 
 	struct list_head cpu_list;
 
+	u64 vp_enter_ret;
+
 	enum vcpu_tdx_state state;
 };
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ff6370787926..83aac44b779b 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -131,6 +131,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -158,6 +160,11 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
+static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+{
+	return EXIT_FASTPATH_NONE;
+}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.43.0


