Return-Path: <kvm+bounces-53864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 596DBB189D0
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 02:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 137446270E3
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 00:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92AC65A79B;
	Sat,  2 Aug 2025 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jJHmtdFo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49112E3709;
	Sat,  2 Aug 2025 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754093766; cv=none; b=uajpfy6ibhbpHljNrwBikjVpvA1llt4qPnSL5As3rY5UDo4hwJwi9QWCs1c1buUyEHSxK26lanqzwlCdvg/iSQm7KeF/zMszh+Q2QfBLxx/3tqUm1BXTrVW1qZHyalTSYLya9bVbvu2Lm1zSmn6U2Rw0VzsJJho5PSdKGhvq+As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754093766; c=relaxed/simple;
	bh=MzIR2cLKl+HewSrrVNNYWp6ZXaV4THQEI6WWciSA0Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGneZjAzTkro9QyxmdlO2+KsH2JQsaRGCQr122V7XJp+hK5sagOQBo9FztK9UIBNSg9mT75WjdroAP1E0Ahg5DOir8br33UJ2JVXqkx7wYCpPum7ucJ9V2BvNfCKHiBPQIZx7xVwaEYOofqDSzxBXZvlHs9GalQWKJCj/c2z6EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=jJHmtdFo; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5720FKpH3142596
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 1 Aug 2025 17:15:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5720FKpH3142596
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754093729;
	bh=ZOnNopfXBW3kal1VgoAIIJvAF0qNYDB5XZWEeAFc7wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJHmtdFotCafqqW7p4xxlaTv/iRTsrpjYv11WayotVMelMKK8U4rkRKC5rT+UE9J4
	 R0mmjJ2ha4++Mtyyoc1t5daH90Vg8IIJu+pmn0Xoyw0V9pTTdn85WtRJfy8qVK9JMA
	 g1yS7iCVfpdegPJA7Q1c1VNJThmHjoyhW7jA0BymoiavTDRm+qvatXyXFBFqV0RHOi
	 pXWnhRN3QZLFCie313459GwZQPqL9wY5xN1+9P5pzboiMD98KcmScnpzBEZMoSCmR7
	 Dk8AqbBuXpHE1bU7TTN0M927oB7Q3pRsF5lIpci6CDInMGwidOwdUBTHIk4yRCVszh
	 1s1Xy2tWZqqsg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v2 2/4] KVM: VMX: Handle the immediate form of MSR instructions
Date: Fri,  1 Aug 2025 17:15:18 -0700
Message-ID: <20250802001520.3142577-3-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250802001520.3142577-1-xin@zytor.com>
References: <20250802001520.3142577-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle two newly introduced VM exit reasons associated with the
immediate form of MSR instructions.

For proper virtualization of the immediate form of MSR instructions,
Intel VMX architecture adds the following changes:

  1) The immediate form of RDMSR uses VM exit reason 84.

  2) The immediate form of WRMSRNS uses VM exit reason 85.

  3) For both VM exit reasons 84 and 85, the exit qualification is set
     to the MSR address causing the VM exit.

  4) Bits 3 ~ 6 of the VM exit instruction information field represent
     the operand register used in the immediate form of MSR instruction.

  5) The VM-exit instruction length field records the size of the
     immediate form of the MSR instruction.

Add code to properly virtualize the immediate form of MSR instructions.

While at it, add helper functions to centralize guest MSR read/write
emulation, which consolidates the MSR emulation logic and makes it
easier to extend support for new MSR-related VM exit reasons introduced
with the immediate form of MSR instructions.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Changes in v2:
*) Added nested MSR bitmap check for the two new MSR-related VM exit
   reasons (Chao).
*) Shortened function names that still convey enough information
   (Chao & Sean).
*) Removed VCPU_EXREG_EDX_EAX as it unnecessarily exposes details of a
   specific flow across KVM (Sean).
*) Implemented a separate userspace completion callback for the
   immediate form RDMSR (Sean).
*) Passed MSR data directly to __kvm_emulate_wrmsr() instead of the
   encoded general-purpose register containing it (Sean).
*) Merged modifications to x86.c and vmx.c within the same patch to
   facilitate easier code review (Sean).
*) Moved fastpath support in a separate following patch (Sean).
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/include/uapi/asm/vmx.h |  6 ++-
 arch/x86/kvm/vmx/nested.c       | 13 +++++-
 arch/x86/kvm/vmx/vmx.c          | 21 ++++++++++
 arch/x86/kvm/vmx/vmx.h          |  5 +++
 arch/x86/kvm/x86.c              | 73 +++++++++++++++++++++++++--------
 6 files changed, 101 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..c5d0082cf0a5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -978,6 +978,7 @@ struct kvm_vcpu_arch {
 	unsigned long guest_debug_dr7;
 	u64 msr_platform_info;
 	u64 msr_misc_features_enables;
+	u32 cui_rdmsr_imm_reg;
 
 	u64 mcg_cap;
 	u64 mcg_status;
@@ -2155,7 +2156,9 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiat
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
+int kvm_emulate_rdmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg);
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
+int kvm_emulate_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg);
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu);
 int kvm_emulate_invd(struct kvm_vcpu *vcpu);
 int kvm_emulate_mwait(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index f0f4a4cf84a7..9792e329343e 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -94,6 +94,8 @@
 #define EXIT_REASON_BUS_LOCK            74
 #define EXIT_REASON_NOTIFY              75
 #define EXIT_REASON_TDCALL              77
+#define EXIT_REASON_MSR_READ_IMM        84
+#define EXIT_REASON_MSR_WRITE_IMM       85
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -158,7 +160,9 @@
 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
 	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
 	{ EXIT_REASON_NOTIFY,                "NOTIFY" }, \
-	{ EXIT_REASON_TDCALL,                "TDCALL" }
+	{ EXIT_REASON_TDCALL,                "TDCALL" }, \
+	{ EXIT_REASON_MSR_READ_IMM,          "MSR_READ_IMM" }, \
+	{ EXIT_REASON_MSR_WRITE_IMM,         "MSR_WRITE_IMM" }
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b8ea1969113d..4e6352ef9520 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6216,19 +6216,26 @@ static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
 					struct vmcs12 *vmcs12,
 					union vmx_exit_reason exit_reason)
 {
-	u32 msr_index = kvm_rcx_read(vcpu);
+	u32 msr_index;
 	gpa_t bitmap;
 
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
 		return true;
 
+	if (exit_reason.basic == EXIT_REASON_MSR_READ_IMM ||
+	    exit_reason.basic == EXIT_REASON_MSR_WRITE_IMM)
+		msr_index = vmx_get_exit_qual(vcpu);
+	else
+		msr_index = kvm_rcx_read(vcpu);
+
 	/*
 	 * The MSR_BITMAP page is divided into four 1024-byte bitmaps,
 	 * for the four combinations of read/write and low/high MSR numbers.
 	 * First we need to figure out which of the four to use:
 	 */
 	bitmap = vmcs12->msr_bitmap;
-	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
+	if (exit_reason.basic == EXIT_REASON_MSR_WRITE ||
+	    exit_reason.basic == EXIT_REASON_MSR_WRITE_IMM)
 		bitmap += 2048;
 	if (msr_index >= 0xc0000000) {
 		msr_index -= 0xc0000000;
@@ -6527,6 +6534,8 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC);
 	case EXIT_REASON_MSR_READ:
 	case EXIT_REASON_MSR_WRITE:
+	case EXIT_REASON_MSR_READ_IMM:
+	case EXIT_REASON_MSR_WRITE_IMM:
 		return nested_vmx_exit_handled_msr(vcpu, vmcs12, exit_reason);
 	case EXIT_REASON_INVALID_STATE:
 		return true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b3..c112595dfff9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6003,6 +6003,23 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int vmx_get_msr_imm_reg(void)
+{
+	return vmx_get_instr_info_reg(vmcs_read32(VMX_INSTRUCTION_INFO));
+}
+
+static int handle_rdmsr_imm(struct kvm_vcpu *vcpu)
+{
+	return kvm_emulate_rdmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
+				     vmx_get_msr_imm_reg());
+}
+
+static int handle_wrmsr_imm(struct kvm_vcpu *vcpu)
+{
+	return kvm_emulate_wrmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
+				     vmx_get_msr_imm_reg());
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -6061,6 +6078,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
 	[EXIT_REASON_NOTIFY]		      = handle_notify,
+	[EXIT_REASON_MSR_READ_IMM]            = handle_rdmsr_imm,
+	[EXIT_REASON_MSR_WRITE_IMM]           = handle_wrmsr_imm,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -6495,6 +6514,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 #ifdef CONFIG_MITIGATION_RETPOLINE
 	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		return kvm_emulate_wrmsr(vcpu);
+	else if (exit_reason.basic == EXIT_REASON_MSR_WRITE_IMM)
+		return handle_wrmsr_imm(vcpu);
 	else if (exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER)
 		return handle_preemption_timer(vcpu);
 	else if (exit_reason.basic == EXIT_REASON_INTERRUPT_WINDOW)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d3389baf3ab3..24d65dac5e89 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -706,6 +706,11 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 
 void dump_vmcs(struct kvm_vcpu *vcpu);
 
+static inline int vmx_get_instr_info_reg(u32 vmx_instr_info)
+{
+	return (vmx_instr_info >> 3) & 0xf;
+}
+
 static inline int vmx_get_instr_info_reg2(u32 vmx_instr_info)
 {
 	return (vmx_instr_info >> 28) & 0xf;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..fe12aae7089c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1968,6 +1968,13 @@ static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void complete_userspace_rdmsr_imm(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->run->msr.error)
+		kvm_register_write(vcpu, vcpu->arch.cui_rdmsr_imm_reg,
+				   vcpu->run->msr.data);
+}
+
 static int complete_emulated_msr_access(struct kvm_vcpu *vcpu)
 {
 	return complete_emulated_insn_gp(vcpu, vcpu->run->msr.error);
@@ -1990,6 +1997,12 @@ static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
 	return complete_fast_msr_access(vcpu);
 }
 
+static int complete_fast_rdmsr_imm(struct kvm_vcpu *vcpu)
+{
+	complete_userspace_rdmsr_imm(vcpu);
+	return complete_fast_msr_access(vcpu);
+}
+
 static u64 kvm_msr_reason(int r)
 {
 	switch (r) {
@@ -2024,56 +2037,82 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
 	return 1;
 }
 
-int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
+static int __kvm_emulate_rdmsr(struct kvm_vcpu *vcpu, u32 msr, int reg,
+			       int (*complete_rdmsr)(struct kvm_vcpu *))
 {
-	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data;
 	int r;
 
-	r = kvm_get_msr_with_filter(vcpu, ecx, &data);
-
+	r = kvm_get_msr_with_filter(vcpu, msr, &data);
 	if (!r) {
-		trace_kvm_msr_read(ecx, data);
+		trace_kvm_msr_read(msr, data);
 
-		kvm_rax_write(vcpu, data & -1u);
-		kvm_rdx_write(vcpu, (data >> 32) & -1u);
+		if (reg < 0) {
+			kvm_rax_write(vcpu, data & -1u);
+			kvm_rdx_write(vcpu, (data >> 32) & -1u);
+		} else {
+			kvm_register_write(vcpu, reg, data);
+		}
 	} else {
 		/* MSR read failed? See if we should ask user space */
-		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_RDMSR, 0,
-				       complete_fast_rdmsr, r))
+		if (kvm_msr_user_space(vcpu, msr, KVM_EXIT_X86_RDMSR, 0,
+				       complete_rdmsr, r))
 			return 0;
-		trace_kvm_msr_read_ex(ecx);
+		trace_kvm_msr_read_ex(msr);
 	}
 
 	return kvm_x86_call(complete_emulated_msr)(vcpu, r);
 }
+
+int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
+{
+	return __kvm_emulate_rdmsr(vcpu, kvm_rcx_read(vcpu), -1,
+				   complete_fast_rdmsr);
+}
 EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
 
-int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
+int kvm_emulate_rdmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
+{
+	vcpu->arch.cui_rdmsr_imm_reg = reg;
+
+	return __kvm_emulate_rdmsr(vcpu, msr, reg, complete_fast_rdmsr_imm);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr_imm);
+
+static int __kvm_emulate_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
-	u32 ecx = kvm_rcx_read(vcpu);
-	u64 data = kvm_read_edx_eax(vcpu);
 	int r;
 
-	r = kvm_set_msr_with_filter(vcpu, ecx, data);
+	r = kvm_set_msr_with_filter(vcpu, msr, data);
 
 	if (!r) {
-		trace_kvm_msr_write(ecx, data);
+		trace_kvm_msr_write(msr, data);
 	} else {
 		/* MSR write failed? See if we should ask user space */
-		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_WRMSR, data,
+		if (kvm_msr_user_space(vcpu, msr, KVM_EXIT_X86_WRMSR, data,
 				       complete_fast_msr_access, r))
 			return 0;
 		/* Signal all other negative errors to userspace */
 		if (r < 0)
 			return r;
-		trace_kvm_msr_write_ex(ecx, data);
+		trace_kvm_msr_write_ex(msr, data);
 	}
 
 	return kvm_x86_call(complete_emulated_msr)(vcpu, r);
 }
+
+int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
+{
+	return __kvm_emulate_wrmsr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu));
+}
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
+int kvm_emulate_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
+{
+	return __kvm_emulate_wrmsr(vcpu, msr, kvm_register_read(vcpu, reg));
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr_imm);
+
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu)
 {
 	return kvm_skip_emulated_instruction(vcpu);
-- 
2.50.1


