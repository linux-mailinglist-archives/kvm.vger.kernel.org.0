Return-Path: <kvm+bounces-62556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 46BB2C488CB
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE9EA341A43
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E2C331A4F;
	Mon, 10 Nov 2025 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hss9biar"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A673314B6;
	Mon, 10 Nov 2025 18:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799085; cv=none; b=g0hGaIoLe8vVWGn4KPPKb+GNf4igYvpvlPjKWkNqnKVB9pycHnZJ2HZdyuqGfrh8QaIRG9G5xgEYT3TkMiMJJ+hh6UnaIvFUecbxBThFndOV802ql2ILm+SCbMiH16uKR05/4ObiFZPzZ9ggvaPbN00xbnr+emtpxH7zmGYXsh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799085; c=relaxed/simple;
	bh=rOAz+ywDBJAMB3ygOZJMiUcKS5Zy1jnq3CoNZHxvWyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjB0ZCT9SPTPTiVapnItl3ZxG4wmrg8hVJkxLTsx/Fxbrx+SC/fQJcr6ehbQIx1JuCqwWOcujL+9+LT7UN18TPkk7QcWPtvieLh6jibqogVvKah2tkDl6yHSvov0XeO3xvx4u6qmP7Hbdd1vPyRA24QcUzirBesFzlYr1JgAU1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hss9biar; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799084; x=1794335084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rOAz+ywDBJAMB3ygOZJMiUcKS5Zy1jnq3CoNZHxvWyw=;
  b=hss9biarrV/BLHmPHmSpYbi5uuiKS3CTd+e26I1xzOCJ6gGmOlzH5rM4
   HanwfS+9y3BPxgKnuVMjl43oYz0uYfmSIphz7drRt3zy9M2+EGSutOuYb
   cgZswH0hc1j0wtQp1KmNArM+YfcS3kQNTg4B3NfwGgJB0XX18bh8HW3mk
   F4AWIkme4hTes6ppVK9D7xbNYSvvkXR9o1sF7dJx+LYkSvLmXSFR73Kf2
   rVak+ybxY1I1vF4SY1tkvyMVCvmp34Zdo2/RRNh9BCz7+kMBlnQimIZkz
   kQUPG6hDzsZvD39mLSrdtjAbLEenck0jXdl3amT52RhDXalmlH1od9e54
   w==;
X-CSE-ConnectionGUID: K8F+pzBEQOKJX99Jr2U65w==
X-CSE-MsgGUID: G7wSg65FTvuWe1g8wjWF5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305492"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305492"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:44 -0800
X-CSE-ConnectionGUID: UvELXc6mTyC2S4DYueoUkQ==
X-CSE-MsgGUID: pd1+b6rwSLG09jIWdRTcPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396114"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:44 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 05/20] KVM: VMX: Refactor instruction information retrieval
Date: Mon, 10 Nov 2025 18:01:16 +0000
Message-ID: <20251110180131.28264-6-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce helpers to convert and extract exited instruction attributes,
preparing for EGPR support and deprecating some existing helpers.

Previously, VMX exit handlers directly decoded the raw VMCS field,
resulting in duplicated logic and assumption tied to the legacy layout.

With the unified structure, handlers can convert raw data into a
structure form and access each instruction attribute by field name.

The helper will later determine the format based on the VCPU
configuration. For now, there is no functional change since only the
legacy layout is used.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
RFC note:
Macro and variable naming may still evolve depending on
maintainer/reviewer preferences.
---
 arch/x86/kvm/vmx/nested.c | 73 +++++++++++++++++++--------------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 14 ++++----
 arch/x86/kvm/vmx/vmx.h    | 23 ++++++------
 4 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 47a941989787..4b883ded6c4b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5289,7 +5289,7 @@ static void nested_vmx_triple_fault(struct kvm_vcpu *vcpu)
  * #UD, #GP, or #SS.
  */
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, int len, gva_t *ret)
+			struct vmx_insn_info info, bool wr, int len, gva_t *ret)
 {
 	gva_t off;
 	bool exn;
@@ -5303,14 +5303,14 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	 * For how an actual address is calculated from all these components,
 	 * refer to Vol. 1, "Operand Addressing".
 	 */
-	int  scaling = vmx_instruction_info & 3;
-	int  addr_size = (vmx_instruction_info >> 7) & 7;
-	bool is_reg = vmx_instruction_info & (1u << 10);
-	int  seg_reg = (vmx_instruction_info >> 15) & 7;
-	int  index_reg = (vmx_instruction_info >> 18) & 0xf;
-	bool index_is_valid = !(vmx_instruction_info & (1u << 22));
-	int  base_reg       = (vmx_instruction_info >> 23) & 0xf;
-	bool base_is_valid  = !(vmx_instruction_info & (1u << 27));
+	int  scaling = insn_attr(info, scale);
+	int  addr_size = insn_attr(info, asize);
+	bool is_reg = insn_attr(info, is_reg);
+	int  seg_reg = insn_attr(info, seg);
+	int  index_reg = insn_attr(info, index);
+	bool index_is_valid = !insn_attr(info, index_invalid);
+	int  base_reg       = insn_attr(info, base);
+	bool base_is_valid  = !insn_attr(info, base_invalid);
 
 	if (is_reg) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -5421,7 +5421,7 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
 	int r;
 
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
-				vmcs_read32(VMX_INSTRUCTION_INFO), false,
+				vmx_get_insn_info(vcpu), false,
 				sizeof(*vmpointer), &gva)) {
 		*ret = 1;
 		return -EINVAL;
@@ -5706,7 +5706,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
 						    : get_vmcs12(vcpu);
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
-	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vmx_insn_info info = vmx_get_insn_info(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
 	unsigned long field;
@@ -5719,7 +5719,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return 1;
 
 	/* Decode instruction info and find the field to read */
-	field = kvm_gpr_read(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	if (!nested_vmx_is_evmptr12_valid(vmx)) {
 		/*
@@ -5767,12 +5767,12 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	 * Note that the number of bits actually copied is 32 or 64 depending
 	 * on the guest's mode (32 or 64 bit), not on the given field's length.
 	 */
-	if (instr_info & BIT(10)) {
-		kvm_gpr_write(vcpu, (((instr_info) >> 3) & 0xf), value);
+	if (insn_attr(info, is_reg)) {
+		kvm_gpr_write(vcpu, insn_attr(info, reg1), value);
 	} else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
-					instr_info, true, len, &gva))
+					info, true, len, &gva))
 			return 1;
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
 		r = kvm_write_guest_virt_system(vcpu, gva, &value, len, &e);
@@ -5812,7 +5812,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
 						    : get_vmcs12(vcpu);
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
-	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vmx_insn_info info = vmx_get_insn_info(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
 	unsigned long field;
@@ -5841,19 +5841,19 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (instr_info & BIT(10))
-		value = kvm_gpr_read(vcpu, (((instr_info) >> 3) & 0xf));
+	if (insn_attr(info, is_reg))
+		value = kvm_gpr_read(vcpu, insn_attr(info, reg1));
 	else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
-					instr_info, false, len, &gva))
+					info, false, len, &gva))
 			return 1;
 		r = kvm_read_guest_virt(vcpu, gva, &value, len, &e);
 		if (r != X86EMUL_CONTINUE)
 			return kvm_handle_memory_failure(vcpu, r, &e);
 	}
 
-	field = kvm_gpr_read(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	offset = get_vmcs12_field_offset(field);
 	if (offset < 0)
@@ -6001,7 +6001,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 static int handle_vmptrst(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
-	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vmx_insn_info info = vmx_get_insn_info(vcpu);
 	gpa_t current_vmptr = to_vmx(vcpu)->nested.current_vmptr;
 	struct x86_exception e;
 	gva_t gva;
@@ -6013,7 +6013,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	if (unlikely(nested_vmx_is_evmptr12_valid(to_vmx(vcpu))))
 		return 1;
 
-	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
+	if (get_vmx_mem_address(vcpu, exit_qual, info,
 				true, sizeof(gpa_t), &gva))
 		return 1;
 	/* *_system ok, nested_vmx_check_permission has verified cpl=0 */
@@ -6029,15 +6029,16 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 static int handle_invept(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 vmx_instruction_info, types;
 	unsigned long type, roots_to_free;
+	struct vmx_insn_info info;
 	struct kvm_mmu *mmu;
 	gva_t gva;
 	struct x86_exception e;
 	struct {
 		u64 eptp, gpa;
 	} operand;
-	int i, r, gpr_index;
+	u32 types;
+	int i, r;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_EPT) ||
@@ -6049,9 +6050,8 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_gpr_read(vcpu, gpr_index);
+	info = vmx_get_insn_info(vcpu);
+	type = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
@@ -6062,7 +6062,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
-			vmx_instruction_info, false, sizeof(operand), &gva))
+			info, false, sizeof(operand), &gva))
 		return 1;
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
@@ -6109,7 +6109,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 static int handle_invvpid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 vmx_instruction_info;
+	struct vmx_insn_info info;
 	unsigned long type, types;
 	gva_t gva;
 	struct x86_exception e;
@@ -6118,7 +6118,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		u64 gla;
 	} operand;
 	u16 vpid02;
-	int r, gpr_index;
+	int r;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
@@ -6130,9 +6130,8 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_gpr_read(vcpu, gpr_index);
+	info = vmx_get_insn_info(vcpu);
+	type = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	types = (vmx->nested.msrs.vpid_caps &
 			VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
@@ -6145,7 +6144,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
-			vmx_instruction_info, false, sizeof(operand), &gva))
+			info, false, sizeof(operand), &gva))
 		return 1;
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
@@ -6483,7 +6482,7 @@ static bool nested_vmx_exit_handled_encls(struct kvm_vcpu *vcpu,
 static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12, gpa_t bitmap)
 {
-	u32 vmx_instruction_info;
+	struct vmx_insn_info info;
 	unsigned long field;
 	u8 b;
 
@@ -6491,8 +6490,8 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 		return true;
 
 	/* Decode instruction info and find the field to access */
-	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	field = kvm_gpr_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	info = vmx_get_insn_info(vcpu);
+	field = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	/* Out-of-range fields always cause a VM exit from L2 to L1 */
 	if (field >> 15)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 983484d42ebf..e54f4e7b3664 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -50,7 +50,7 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
 int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
+			struct vmx_insn_info info, bool wr, int len, gva_t *ret);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c7d38f7692cf..dd8c9517c38c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5925,29 +5925,27 @@ static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 
 static int handle_invpcid(struct kvm_vcpu *vcpu)
 {
-	u32 vmx_instruction_info;
+	struct vmx_insn_info info;
 	unsigned long type;
 	gva_t gva;
 	struct {
 		u64 pcid;
 		u64 gla;
 	} operand;
-	int gpr_index;
 
 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
-	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_gpr_read(vcpu, gpr_index);
+	info = vmx_get_insn_info(vcpu);
+	type = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	/* According to the Intel instruction reference, the memory operand
 	 * is read even if it isn't needed (e.g., for type==all)
 	 */
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
-				vmx_instruction_info, false,
+				info, false,
 				sizeof(operand), &gva))
 		return 1;
 
@@ -6084,7 +6082,9 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 
 static int vmx_get_msr_imm_reg(struct kvm_vcpu *vcpu)
 {
-	return vmx_get_instr_info_reg(vmcs_read32(VMX_INSTRUCTION_INFO));
+	struct vmx_insn_info info = vmx_get_insn_info(vcpu);
+
+	return insn_attr(info, reg1);
 }
 
 static int handle_rdmsr_imm(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c358aca7253c..a58d9187ed1d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -372,6 +372,19 @@ struct vmx_insn_info {
 	union insn_info info;
 };
 
+static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu __maybe_unused)
+{
+	struct vmx_insn_info insn;
+
+	insn.extended  = false;
+	insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
+
+	return insn;
+}
+
+#define insn_attr(insn, attr) \
+	((insn).extended ? (insn).info.ext.attr : (insn).info.base.attr)
+
 static __always_inline struct vcpu_vt *to_vt(struct kvm_vcpu *vcpu)
 {
 	return &(container_of(vcpu, struct vcpu_vmx, vcpu)->vt);
@@ -780,16 +793,6 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 
 void dump_vmcs(struct kvm_vcpu *vcpu);
 
-static inline int vmx_get_instr_info_reg(u32 vmx_instr_info)
-{
-	return (vmx_instr_info >> 3) & 0xf;
-}
-
-static inline int vmx_get_instr_info_reg2(u32 vmx_instr_info)
-{
-	return (vmx_instr_info >> 28) & 0xf;
-}
-
 static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
 {
 	return  lapic_in_kernel(vcpu) && enable_ipiv;
-- 
2.51.0


