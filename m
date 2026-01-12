Return-Path: <kvm+bounces-67854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 287BED15F33
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E58A230090F2
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5830F2264D3;
	Tue, 13 Jan 2026 00:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIfwnDNF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B3B42AB7;
	Tue, 13 Jan 2026 00:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263488; cv=none; b=jDpvSzf/DeDyoQZrZWDCkLMxa3XxWi8c6W9KRBelr6k9Dfv3rbxpi3PeegX5x3DlRO6exVy1sAatpxPUtkZ5qDjBnEfwD9k0YqzE8TuY7oyAN33d3pWvOLgzSZ8d3MQzTc0kvacgATLGVqgB5bNZ4wBX2ngWc+omcksbr/EFmuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263488; c=relaxed/simple;
	bh=TzaBrq441dwgCPKohygquSJC95lAZPeg8uqbVOZSB2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVheKv1jvC6yVUg5lRNHLJVSB5mkvDjQYw72ipaPfYOa6aL3S7XjYEhPF3Ll2TSjdVBSDlpZjcflF8GiDLTBYFMjFVubCVEISZJ/MQRS4OJVF7SfHwRMay0coe5G9mKudgu1P68WXK04hJ4qJkRW0Hg+mqz/y2PbrA3aOTLXi34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIfwnDNF; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263480; x=1799799480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TzaBrq441dwgCPKohygquSJC95lAZPeg8uqbVOZSB2Q=;
  b=YIfwnDNFqpfrezORsh9cIQx7A3QtADw5pzNQBwQDj74ZZ6fUiO7VzzTa
   6MFHvKwH78sbToJoG/h0W/kW91uHHDSkG2PdOL2kyYlf0Z+xLuWIcsqYd
   whx5EcCaoL+qVHLYePHQCdT8WAI6Apy1+lwSIBTQQ0O/AJ57gNbXGbyMk
   Vjen8aPiN9WOoQhMTas3IwQex5YDeVms268nZumT+Ayd9q3Ysi6bL96Od
   /LowRMoZSmpmUEptDLPbdhAZd7l8doOcXzH3UgV4Dfun8IagyHfuIrZpr
   4m7AgDc2L0ml1K5pF/ufsOIdrbSdqp+Nei5iEuXxGsoiRHVew5PNIXM84
   Q==;
X-CSE-ConnectionGUID: BxsrgYnoR7eNgo1nvc/z+Q==
X-CSE-MsgGUID: c5GBz381SV6ND9ziXoqAQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264176"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264176"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:00 -0800
X-CSE-ConnectionGUID: raGHT03PT1mKbIluRpOwoA==
X-CSE-MsgGUID: Qu0pPiUVRaqg67oqMjsM+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042156"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:00 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 01/16] KVM: x86: Rename register accessors to be GPR-specific
Date: Mon, 12 Jan 2026 23:53:53 +0000
Message-ID: <20260112235408.168200-2-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
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
 arch/x86/kvm/svm/svm.c    |  8 ++++----
 arch/x86/kvm/vmx/nested.c | 20 ++++++++++----------
 arch/x86/kvm/vmx/vmx.c    | 12 ++++++------
 arch/x86/kvm/x86.c        | 10 +++++-----
 arch/x86/kvm/x86.h        |  5 ++---
 arch/x86/kvm/xen.c        |  2 +-
 6 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d..209faa742e98 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2474,7 +2474,7 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(vcpu, reg);
+		val = kvm_gpr_read(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -2520,7 +2520,7 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 			kvm_queue_exception(vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(vcpu, reg, val);
+		kvm_gpr_write(vcpu, reg, val);
 		trace_kvm_cr_read(cr, val);
 	}
 	return kvm_complete_insn_gp(vcpu, err);
@@ -2592,9 +2592,9 @@ static int dr_interception(struct kvm_vcpu *vcpu)
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
index 6137e5307d0f..b7d5feb4f5bd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5275,9 +5275,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
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
@@ -5669,7 +5669,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return 1;
 
 	/* Decode instruction info and find the field to read */
-	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, (((instr_info) >> 28) & 0xf));
 
 	if (!nested_vmx_is_evmptr12_valid(vmx)) {
 		/*
@@ -5718,7 +5718,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	 * on the guest's mode (32 or 64 bit), not on the given field's length.
 	 */
 	if (instr_info & BIT(10)) {
-		kvm_register_write(vcpu, (((instr_info) >> 3) & 0xf), value);
+		kvm_gpr_write(vcpu, (((instr_info) >> 3) & 0xf), value);
 	} else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
@@ -5792,7 +5792,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return nested_vmx_failInvalid(vcpu);
 
 	if (instr_info & BIT(10))
-		value = kvm_register_read(vcpu, (((instr_info) >> 3) & 0xf));
+		value = kvm_gpr_read(vcpu, (((instr_info) >> 3) & 0xf));
 	else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
@@ -5803,7 +5803,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			return kvm_handle_memory_failure(vcpu, r, &e);
 	}
 
-	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, (((instr_info) >> 28) & 0xf));
 
 	offset = get_vmcs12_field_offset(field);
 	if (offset < 0)
@@ -6001,7 +6001,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_register_read(vcpu, gpr_index);
+	type = kvm_gpr_read(vcpu, gpr_index);
 
 	types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
@@ -6082,7 +6082,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_register_read(vcpu, gpr_index);
+	type = kvm_gpr_read(vcpu, gpr_index);
 
 	types = (vmx->nested.msrs.vpid_caps &
 			VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
@@ -6356,7 +6356,7 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
 		reg = (exit_qualification >> 8) & 15;
-		val = kvm_register_read(vcpu, reg);
+		val = kvm_gpr_read(vcpu, reg);
 		switch (cr) {
 		case 0:
 			if (vmcs12->cr0_guest_host_mask &
@@ -6442,7 +6442,7 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 
 	/* Decode instruction info and find the field to access */
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	field = kvm_register_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
 	/* Out-of-range fields always cause a VM exit from L2 to L1 */
 	if (field >> 15)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b96f7aea20b..4320f61aabc2 100644
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
index ff8812f3a129..3256ad507265 100644
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


