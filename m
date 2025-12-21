Return-Path: <kvm+bounces-66443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DA9D9CD3B8E
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:31:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 34E9C300A37D
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D1F22259F;
	Sun, 21 Dec 2025 04:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QkrlAa8R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31F521D3F2;
	Sun, 21 Dec 2025 04:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291481; cv=none; b=P8WEvD2mLrvD4uv5EY+c3Tq//aEDhLc/4orsbhsjH4yYO311taVQqLDejveALO9czHoImj2JnOc3l2HFZThQmPXY1+0HLumCDSZ7dLslXpSQFBUuAU3Lh3ppB+pqo8AqoBZGT/Pn0YEDAks31mkiimPcKdJw+yjdrY3vefZuuEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291481; c=relaxed/simple;
	bh=qI1pjgInsVR2QMifm/sOkZ+ghcZwWYvzVBIQL/G0WwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjLImeZ9pXNDW9zBgPGegy0w6KSlPqxN55k4lZaNquGC0R9ghM4z9TozXriJ2VxxtI9Dim2YujyBwp0y5m0Xqvw+ogGKDa1rdCVOII+M72O13UuoNhDgIkLdo60EVM0wUcD9HAg3cgnzphzrs1yBtDuXPbfFgtGhUEWO1hxrWto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QkrlAa8R; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291480; x=1797827480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qI1pjgInsVR2QMifm/sOkZ+ghcZwWYvzVBIQL/G0WwM=;
  b=QkrlAa8RBCcKqIjaDNn6ZZ/KjP20aFRH/7gsFMOS8T8dhRDsTs3quijX
   Vt+qrUD12ftXrxGXOtl3XjaycKC2eqK3/wRB2Rdyxlg0/09bfUjtPz0n+
   BmWOQLx0iNAgdoyaDusjBrOif6IwJOPeMQBhzwyKH+pBlPizi5+QV0IfH
   Dm6jNRfX7lWblI7sGTLv7zv8h7wFVl/sW15WvCIgrno0DqUkxa4Srlzlx
   VKRIo7MWGRTDlcb+nawMQcTdlf3Xmp/N10jfeWVrQtT1hIdhtfnOUccdR
   QkG4U/4JP+DJvNBepGXuKljreES871jjTGuVSoO5cshIM3m1sKZLht0Sh
   A==;
X-CSE-ConnectionGUID: s+tp2myiSPKo6FSN6Vvn7Q==
X-CSE-MsgGUID: 6+OxzqM+RpSm0UEBDH/CWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132373"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132373"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:19 -0800
X-CSE-ConnectionGUID: di/OlJ57RgCoIrurN+1JUA==
X-CSE-MsgGUID: nC9L4JxCSYqvaZhrSZK77A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229884919"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:19 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 01/16] KVM: x86: Rename register accessors to be GPR-specific
Date: Sun, 21 Dec 2025 04:07:27 +0000
Message-ID: <20251221040742.29749-2-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the VCPU register state accessors to make them explicitly
GPR-only.

The existing register accessors operate on the cached VCPU register
state. That cache holds GPRs and RIP. RIP has its own interface already.
This renaming clarifies GPR access only.

No functional changes intended.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
No change since last version
---
 arch/x86/kvm/svm/svm.c    |  8 ++++----
 arch/x86/kvm/vmx/nested.c | 20 ++++++++++----------
 arch/x86/kvm/vmx/vmx.c    | 12 ++++++------
 arch/x86/kvm/x86.c        | 10 +++++-----
 arch/x86/kvm/x86.h        |  5 ++---
 arch/x86/kvm/xen.c        |  2 +-
 6 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f56c2d895011..ca1dc2342134 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2473,7 +2473,7 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(vcpu, reg);
+		val = kvm_gpr_read(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -2519,7 +2519,7 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 			kvm_queue_exception(vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(vcpu, reg, val);
+		kvm_gpr_write(vcpu, reg, val);
 		trace_kvm_cr_read(cr, val);
 	}
 	return kvm_complete_insn_gp(vcpu, err);
@@ -2591,9 +2591,9 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 	if (dr >= 16) { /* mov to DRn  */
 		dr -= 16;
-		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
+		err = kvm_set_dr(vcpu, dr, kvm_gpr_read(vcpu, reg));
 	} else {
-		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
+		kvm_gpr_write(vcpu, reg, kvm_get_dr(vcpu, dr));
 	}
 
 	return kvm_complete_insn_gp(vcpu, err);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 40777278eabb..84e2a4a613b7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5274,9 +5274,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	else if (addr_size == 0)
 		off = (gva_t)sign_extend64(off, 15);
 	if (base_is_valid)
-		off += kvm_register_read(vcpu, base_reg);
+		off += kvm_gpr_read(vcpu, base_reg);
 	if (index_is_valid)
-		off += kvm_register_read(vcpu, index_reg) << scaling;
+		off += kvm_gpr_read(vcpu, index_reg) << scaling;
 	vmx_get_segment(vcpu, &s, seg_reg);
 
 	/*
@@ -5668,7 +5668,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return 1;
 
 	/* Decode instruction info and find the field to read */
-	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, (((instr_info) >> 28) & 0xf));
 
 	if (!nested_vmx_is_evmptr12_valid(vmx)) {
 		/*
@@ -5717,7 +5717,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	 * on the guest's mode (32 or 64 bit), not on the given field's length.
 	 */
 	if (instr_info & BIT(10)) {
-		kvm_register_write(vcpu, (((instr_info) >> 3) & 0xf), value);
+		kvm_gpr_write(vcpu, (((instr_info) >> 3) & 0xf), value);
 	} else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
@@ -5791,7 +5791,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return nested_vmx_failInvalid(vcpu);
 
 	if (instr_info & BIT(10))
-		value = kvm_register_read(vcpu, (((instr_info) >> 3) & 0xf));
+		value = kvm_gpr_read(vcpu, (((instr_info) >> 3) & 0xf));
 	else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
@@ -5802,7 +5802,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			return kvm_handle_memory_failure(vcpu, r, &e);
 	}
 
-	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, (((instr_info) >> 28) & 0xf));
 
 	offset = get_vmcs12_field_offset(field);
 	if (offset < 0)
@@ -6000,7 +6000,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_register_read(vcpu, gpr_index);
+	type = kvm_gpr_read(vcpu, gpr_index);
 
 	types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
@@ -6081,7 +6081,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_register_read(vcpu, gpr_index);
+	type = kvm_gpr_read(vcpu, gpr_index);
 
 	types = (vmx->nested.msrs.vpid_caps &
 			VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
@@ -6355,7 +6355,7 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
 		reg = (exit_qualification >> 8) & 15;
-		val = kvm_register_read(vcpu, reg);
+		val = kvm_gpr_read(vcpu, reg);
 		switch (cr) {
 		case 0:
 			if (vmcs12->cr0_guest_host_mask &
@@ -6441,7 +6441,7 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 
 	/* Decode instruction info and find the field to access */
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	field = kvm_register_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
 	/* Out-of-range fields always cause a VM exit from L2 to L1 */
 	if (field >> 15)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cbe8c84b636..c944b75c10a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5591,7 +5591,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		val = kvm_register_read(vcpu, reg);
+		val = kvm_gpr_read(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -5633,12 +5633,12 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 			WARN_ON_ONCE(enable_unrestricted_guest);
 
 			val = kvm_read_cr3(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_gpr_write(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		case 8:
 			val = kvm_get_cr8(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_gpr_write(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		}
@@ -5708,10 +5708,10 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 
 	reg = DEBUG_REG_ACCESS_REG(exit_qualification);
 	if (exit_qualification & TYPE_MOV_FROM_DR) {
-		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
+		kvm_gpr_write(vcpu, reg, kvm_get_dr(vcpu, dr));
 		err = 0;
 	} else {
-		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
+		err = kvm_set_dr(vcpu, dr, kvm_gpr_read(vcpu, reg));
 	}
 
 out:
@@ -6070,7 +6070,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_register_read(vcpu, gpr_index);
+	type = kvm_gpr_read(vcpu, gpr_index);
 
 	/* According to the Intel instruction reference, the memory operand
 	 * is read even if it isn't needed (e.g., for type==all)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..23e57170898a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2080,8 +2080,8 @@ static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
 static int complete_fast_rdmsr_imm(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->run->msr.error)
-		kvm_register_write(vcpu, vcpu->arch.cui_rdmsr_imm_reg,
-				   vcpu->run->msr.data);
+		kvm_gpr_write(vcpu, vcpu->arch.cui_rdmsr_imm_reg,
+			      vcpu->run->msr.data);
 
 	return complete_fast_msr_access(vcpu);
 }
@@ -2135,7 +2135,7 @@ static int __kvm_emulate_rdmsr(struct kvm_vcpu *vcpu, u32 msr, int reg,
 			kvm_rax_write(vcpu, data & -1u);
 			kvm_rdx_write(vcpu, (data >> 32) & -1u);
 		} else {
-			kvm_register_write(vcpu, reg, data);
+			kvm_gpr_write(vcpu, reg, data);
 		}
 	} else {
 		/* MSR read failed? See if we should ask user space */
@@ -2193,7 +2193,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_emulate_wrmsr);
 
 int kvm_emulate_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
 {
-	return __kvm_emulate_wrmsr(vcpu, msr, kvm_register_read(vcpu, reg));
+	return __kvm_emulate_wrmsr(vcpu, msr, kvm_gpr_read(vcpu, reg));
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_emulate_wrmsr_imm);
 
@@ -2297,7 +2297,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(handle_fastpath_wrmsr);
 
 fastpath_t handle_fastpath_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
 {
-	return __handle_fastpath_wrmsr(vcpu, msr, kvm_register_read(vcpu, reg));
+	return __handle_fastpath_wrmsr(vcpu, msr, kvm_gpr_read(vcpu, reg));
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(handle_fastpath_wrmsr_imm);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..7d6c1c31539f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -400,15 +400,14 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return false;
 }
 
-static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
+static inline unsigned long kvm_gpr_read(struct kvm_vcpu *vcpu, int reg)
 {
 	unsigned long val = kvm_register_read_raw(vcpu, reg);
 
 	return is_64_bit_mode(vcpu) ? val : (u32)val;
 }
 
-static inline void kvm_register_write(struct kvm_vcpu *vcpu,
-				       int reg, unsigned long val)
+static inline void kvm_gpr_write(struct kvm_vcpu *vcpu, int reg, unsigned long val)
 {
 	if (!is_64_bit_mode(vcpu))
 		val = (u32)val;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d6b2a665b499..c9700dc88bb1 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1679,7 +1679,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	bool handled = false;
 	u8 cpl;
 
-	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
+	input = (u64)kvm_gpr_read(vcpu, VCPU_REGS_RAX);
 
 	/* Hyper-V hypercalls get bit 31 set in EAX */
 	if ((input & 0x80000000) &&
-- 
2.51.0


