Return-Path: <kvm+bounces-66447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 87232CD3BB5
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72E3E3042809
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD7222DF9E;
	Sun, 21 Dec 2025 04:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Naqlg7YE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CC021CC7B;
	Sun, 21 Dec 2025 04:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291495; cv=none; b=Tlq/GojUJzZIqWC14mL4Gd2lpZf+s4Mp/yQ9vosqgbKajjPX7xqV43H265+3i2vnZdavXeD+7/ztMFnl/yvjYudXze7KYTlYsPKCZC/aRDmLPAcIV+oTdudMSVTUyH8cLff+OdGm8QFuvbMRpV/TIrBwONiZz3EAlEzbRUG4/NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291495; c=relaxed/simple;
	bh=Zey7/cPb/bvZvwRADisMH0xtOMrTQ65Vf8gIwMGuSdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEG1LUk/uP23+FCWZRD6C/4nOk2bqo7ZYc5uc7ktnMu6IFRZRmbZrafapJuFtMo4Osarv/78G+iLqGAkXp8rPQjhGEIwncp916xSlFyFOjWAzc/1MAe7lii+fTF8unlA4y6IBq24A6RTdsH/XjNsNMxLf5liwQfHJHJJDCXIocI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Naqlg7YE; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291493; x=1797827493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zey7/cPb/bvZvwRADisMH0xtOMrTQ65Vf8gIwMGuSdo=;
  b=Naqlg7YEN90Y78HatXP7zb6I0wpYG4Hij7siL804hWBTDjY7pBb6qfWN
   bRp0bAIt+4CPDTGKfnc5vJkG7c3tVwMHMMh0x2ZypIy4nsgzaNeFfMbQT
   ZNYHYKpP9Hvocd08+h+9JpR37r4okADLrmVIUj2uL7dIxk7IX9nOf+yOU
   q+cqgIH8ErMFy8bg1TqqAo/QijtDz0Ma7JpZjeKdhPq+4EhuNeBAOM98Q
   gZKnrcfOcldSLIRdLqOGTfs/HU3DawrY3ATNv8M1zP6MqdW9WtOuLjtbG
   biru5HRsek+mzzuw3TFFYK2MwOzPM6/u+UjgbMlrlOIau0bciuoBgf/76
   g==;
X-CSE-ConnectionGUID: z065+HWaRFaLetI+6w2xBg==
X-CSE-MsgGUID: YMFiQ63TSNasTGVTYosvdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132393"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132393"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:32 -0800
X-CSE-ConnectionGUID: ly5JB0FtQ1+ezDEb/3sEiw==
X-CSE-MsgGUID: +xlGdVw1Q06dDkg+dNOmsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229884977"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:32 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 05/16] KVM: VMX: Refactor instruction information retrieval
Date: Sun, 21 Dec 2025 04:07:31 +0000
Message-ID: <20251221040742.29749-6-chang.seok.bae@intel.com>
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
No change since last version
---
 arch/x86/kvm/vmx/nested.c | 73 +++++++++++++++++++--------------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 14 ++++----
 arch/x86/kvm/vmx/vmx.h    | 23 ++++++------
 4 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 84e2a4a613b7..558f889db621 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5238,7 +5238,7 @@ static void nested_vmx_triple_fault(struct kvm_vcpu *vcpu)
  * #UD, #GP, or #SS.
  */
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
-			u32 vmx_instruction_info, bool wr, int len, gva_t *ret)
+			struct vmx_insn_info info, bool wr, int len, gva_t *ret)
 {
 	gva_t off;
 	bool exn;
@@ -5252,14 +5252,14 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
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
+	int  scaling        = insn_attr(info, scale);
+	int  addr_size      = insn_attr(info, asize);
+	bool is_reg         = insn_attr(info, is_reg);
+	int  seg_reg        = insn_attr(info, seg);
+	int  index_reg      = insn_attr(info, index);
+	bool index_is_valid = !insn_attr(info, index_invalid);
+	int  base_reg       = insn_attr(info, base);
+	bool base_is_valid  = !insn_attr(info, base_invalid);
 
 	if (is_reg) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -5370,7 +5370,7 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
 	int r;
 
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
-				vmcs_read32(VMX_INSTRUCTION_INFO), false,
+				vmx_get_insn_info(vcpu), false,
 				sizeof(*vmpointer), &gva)) {
 		*ret = 1;
 		return -EINVAL;
@@ -5655,7 +5655,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
 						    : get_vmcs12(vcpu);
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
-	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vmx_insn_info info = vmx_get_insn_info(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
 	unsigned long field;
@@ -5668,7 +5668,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return 1;
 
 	/* Decode instruction info and find the field to read */
-	field = kvm_gpr_read(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	if (!nested_vmx_is_evmptr12_valid(vmx)) {
 		/*
@@ -5716,12 +5716,12 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
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
@@ -5761,7 +5761,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
 						    : get_vmcs12(vcpu);
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
-	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vmx_insn_info info = vmx_get_insn_info(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
 	unsigned long field;
@@ -5790,19 +5790,19 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
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
@@ -5950,7 +5950,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 static int handle_vmptrst(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
-	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct vmx_insn_info info = vmx_get_insn_info(vcpu);
 	gpa_t current_vmptr = to_vmx(vcpu)->nested.current_vmptr;
 	struct x86_exception e;
 	gva_t gva;
@@ -5962,7 +5962,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	if (unlikely(nested_vmx_is_evmptr12_valid(to_vmx(vcpu))))
 		return 1;
 
-	if (get_vmx_mem_address(vcpu, exit_qual, instr_info,
+	if (get_vmx_mem_address(vcpu, exit_qual, info,
 				true, sizeof(gpa_t), &gva))
 		return 1;
 	/* *_system ok, nested_vmx_check_permission has verified cpl=0 */
@@ -5978,15 +5978,16 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
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
@@ -5998,9 +5999,8 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_gpr_read(vcpu, gpr_index);
+	info = vmx_get_insn_info(vcpu);
+	type = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
@@ -6011,7 +6011,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
-			vmx_instruction_info, false, sizeof(operand), &gva))
+			info, false, sizeof(operand), &gva))
 		return 1;
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
@@ -6058,7 +6058,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 static int handle_invvpid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 vmx_instruction_info;
+	struct vmx_insn_info info;
 	unsigned long type, types;
 	gva_t gva;
 	struct x86_exception e;
@@ -6067,7 +6067,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		u64 gla;
 	} operand;
 	u16 vpid02;
-	int r, gpr_index;
+	int r;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
@@ -6079,9 +6079,8 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
-	type = kvm_gpr_read(vcpu, gpr_index);
+	info = vmx_get_insn_info(vcpu);
+	type = kvm_gpr_read(vcpu, insn_attr(info, reg2));
 
 	types = (vmx->nested.msrs.vpid_caps &
 			VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
@@ -6094,7 +6093,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
 	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
-			vmx_instruction_info, false, sizeof(operand), &gva))
+			info, false, sizeof(operand), &gva))
 		return 1;
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
@@ -6432,7 +6431,7 @@ static bool nested_vmx_exit_handled_encls(struct kvm_vcpu *vcpu,
 static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12, gpa_t bitmap)
 {
-	u32 vmx_instruction_info;
+	struct vmx_insn_info info;
 	unsigned long field;
 	u8 b;
 
@@ -6440,8 +6439,8 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
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
index c944b75c10a7..ae28b06b11f5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6054,29 +6054,27 @@ static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 
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
 
@@ -6219,7 +6217,9 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 
 static int vmx_get_msr_imm_reg(struct kvm_vcpu *vcpu)
 {
-	return vmx_get_instr_info_reg(vmcs_read32(VMX_INSTRUCTION_INFO));
+	struct vmx_insn_info info = vmx_get_insn_info(vcpu);
+
+	return insn_attr(info, reg1);
 }
 
 static int handle_rdmsr_imm(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 567320115a5a..ed02a8bcc15e 100644
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
@@ -778,16 +791,6 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 
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


