Return-Path: <kvm+bounces-6695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF7D837A82
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1EED28ECD0
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD71812DD9A;
	Tue, 23 Jan 2024 00:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gplhXR1r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0D212CDB0;
	Tue, 23 Jan 2024 00:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968979; cv=none; b=kZG7zFxY07laWdILlsbcimUHkWUzzBcKhzK3UPYxw0BdNwVQ7WMRGz7exWbwubEZM3GNJz+pQ9mkjo5IJoEYLRheJ0dkhdGW3Cm9fe1AymacoHhr8328+9g8sV59YT2nxtuOe3c3P/fFFZSlHh5S+pomc5LigjaqMf8LBtPQxWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968979; c=relaxed/simple;
	bh=KuKxDgMYvM/akVrIEinCr43jRwN18h/B3SBovOv7FCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mo8EAkv1T/3EoOv+WaNUnXeLnt+mT9O42W5FfxM3Ae722XQ78m2mEOiNDqwBhsNhVAn5n03flX4qtg51wK/zkBgwO5OkE5K5DfmrUXPqrMeGznvD41N4xVYdjiAl6pQInTYb16cqXmmmXhPc9GdCj6aVYGR08+mNZfzH7wOIw44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gplhXR1r; arc=none smtp.client-ip=134.134.136.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705968976; x=1737504976;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KuKxDgMYvM/akVrIEinCr43jRwN18h/B3SBovOv7FCk=;
  b=gplhXR1r8I4kLSppURBQl0BpK3TN+yElFofvIg5vBdmypodmPj0AxDGu
   GmfHxvsdspF+do9ySD+taDoA50MbffRrwJvuCugQUfd3VDa2+MK/lOB6+
   ju0qm9bl4T6uYSHR4EYxNH1j2moGutUr9A2YsMRZ3RNkYbHjUhttj0dA6
   /O5SDjI+oD0JsOPzV+TF5qd7j3L56gr8S80aJXsxqD3GH2CFSzObdWF9+
   MSuz3t5XYJvemngcBeqrmLYphOynhZJrRoQUg6KiwCDbCR6T1QUe8rS6v
   OwdWh9AxJxkfIrbEodDCOusa116DaypSLofKOwmmxJ80edg3n2uzeaWry
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="465626022"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="465626022"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:16:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="785848854"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="785848854"
Received: from powerlab.fi.intel.com ([10.237.71.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:16:11 -0800
From: Michal Wilczynski <michal.wilczynski@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	mlevitsk@redhat.com
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dedekind1@gmail.com,
	yuan.yao@intel.com,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH v2] KVM: x86: nSVM/nVMX: Fix handling triple fault on RSM instruction
Date: Tue, 23 Jan 2024 02:15:55 +0200
Message-ID: <20240123001555.4168188-1-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzkaller found a warning triggered in nested_vmx_vmexit().
vmx->nested.nested_run_pending is non-zero, even though we're in
nested_vmx_vmexit(). Generally, trying  to cancel a pending entry is
considered a bug. However in this particular scenario, the kernel
behavior seems correct.

Syzkaller scenario:
1) Set up VCPU's
2) Run some code with KVM_RUN in L2 as a nested guest
3) Return from KVM_RUN
4) Inject KVM_SMI into the VCPU
5) Change the EFER register with KVM_SET_SREGS to value 0x2501
6) Run some code on the VCPU using KVM_RUN
7) Observe following behavior:

kvm_smm_transition: vcpu 0: entering SMM, smbase 0x30000
kvm_entry: vcpu 0, rip 0x8000
kvm_entry: vcpu 0, rip 0x8000
kvm_entry: vcpu 0, rip 0x8002
kvm_smm_transition: vcpu 0: leaving SMM, smbase 0x30000
kvm_nested_vmenter: rip: 0x0000000000008002 vmcs: 0x0000000000007000
                    nested_rip: 0x0000000000000000 int_ctl: 0x00000000
		    event_inj: 0x00000000 nested_ept=n guest
		    cr3: 0x0000000000002000
kvm_nested_vmexit_inject: reason: TRIPLE_FAULT ext_inf1: 0x0000000000000000
                          ext_inf2: 0x0000000000000000 ext_int: 0x00000000
			  ext_int_err: 0x00000000

What happened here is an SMI was injected immediately and the handler was
called at address 0x8000; all is good. Later, an RSM instruction is
executed in an emulator to return to the nested VM. em_rsm() is called,
which leads to emulator_leave_smm(). A part of this function calls VMX/SVM
callback, in this case vmx_leave_smm(). It attempts to set up a pending
reentry to guest VM by calling nested_vmx_enter_non_root_mode() and sets
vmx->nested.nested_run_pending to one. Unfortunately, later in
emulator_leave_smm(), rsm_load_state_64() fails to write invalid EFER to
the MSR. This results in em_rsm() calling triple_fault callback. At this
point it's clear that the KVM should call the vmexit, but
vmx->nested.nested_run_pending is left set to 1.

Similar flow goes for SVM, as the bug also reproduces on AMD platforms.

To address this issue, reset the nested_run_pending flag in the
triple_fault handler. However, it's crucial to note that
nested_pending_run cannot be cleared in all cases. It should only be
cleared for the specific instruction requiring hardware VM-Enter to
complete the emulation, such as RSM. Previously, there were instances
where KVM prematurely synthesized a triple fault on nested VM-Enter. In
these cases, it is not appropriate to zero the nested_pending_run.

To resolve this, introduce a new emulator flag indicating the need for
HW VM-Enter to complete emulating RSM. Based on this flag, a decision can
be made in vendor-specific triple fault handlers about whether
nested_pending_run needs to be cleared.

Fixes: 759cbd59674a ("KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM")
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Closes: https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
v2:
 - added new emulator flags indicating whether an instruction needs a
   VM-Enter to complete emulation (Sean)
 - fix in SVM nested triple_fault handler (Sean)
 - only clear nested_run_pending on RSM instruction (Sean)

 arch/x86/kvm/emulate.c     |  4 +++-
 arch/x86/kvm/kvm_emulate.h |  2 ++
 arch/x86/kvm/svm/nested.c  |  9 +++++++++
 arch/x86/kvm/vmx/nested.c  | 12 ++++++++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e223043ef5b2..889460432eac 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -178,6 +178,7 @@
 #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
 #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
 #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
+#define NeedVMEnter ((u64)1 << 57)  /* Instruction needs HW VM-Enter to complete */
 
 #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
 
@@ -4462,7 +4463,7 @@ static const struct opcode twobyte_table[256] = {
 	F(DstMem | SrcReg | Src2CL | ModRM, em_shld), N, N,
 	/* 0xA8 - 0xAF */
 	I(Stack | Src2GS, em_push_sreg), I(Stack | Src2GS, em_pop_sreg),
-	II(EmulateOnUD | ImplicitOps, em_rsm, rsm),
+	II(EmulateOnUD | ImplicitOps | NeedVMEnter, em_rsm, rsm),
 	F(DstMem | SrcReg | ModRM | BitOp | Lock | PageTable, em_bts),
 	F(DstMem | SrcReg | Src2ImmByte | ModRM, em_shrd),
 	F(DstMem | SrcReg | Src2CL | ModRM, em_shrd),
@@ -4966,6 +4967,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	}
 
 	ctxt->is_branch = opcode.flags & IsBranch;
+	ctxt->need_vm_enter = opcode.flags & NeedVMEnter;
 
 	/* Unrecognised? */
 	if (ctxt->d == 0)
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index e6d149825169..1e1366afa51d 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -372,6 +372,8 @@ struct x86_emulate_ctxt {
 	struct read_cache io_read;
 	struct read_cache mem_read;
 	bool is_branch;
+	/* instruction need a HW VM-Enter to complete correctly */
+	bool need_vm_enter;
 };
 
 #define KVM_EMULATOR_BUG_ON(cond, ctxt)		\
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dee62362a360..8c19ad5e18d4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1165,11 +1165,20 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
 {
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (!vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SHUTDOWN))
 		return;
 
+	/*
+	 * In case of a triple fault, cancel the nested reentry. This may occur
+	 * when the RSM instruction fails while attempting to restore the state
+	 * from SMRAM.
+	 */
+	if (ctxt->need_vm_enter)
+		svm->nested.nested_run_pending = 0;
+
 	kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	nested_svm_simple_vmexit(to_svm(vcpu), SVM_EXIT_SHUTDOWN);
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6329a306856b..9228699b4c1e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4950,7 +4950,19 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 static void nested_vmx_triple_fault(struct kvm_vcpu *vcpu)
 {
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
 	kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
+	/*
+	 * In case of a triple fault, cancel the nested reentry. This may occur
+	 * when the RSM instruction fails while attempting to restore the state
+	 * from SMRAM.
+	 */
+	if (ctxt->need_vm_enter)
+		vmx->nested.nested_run_pending = 0;
+
 	nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
 }
 
-- 
2.41.0


