Return-Path: <kvm+bounces-53741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F8AB165C5
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 19:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 274AA4E6F0A
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 17:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FBC2E1C5C;
	Wed, 30 Jul 2025 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="o2LoQHDL"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A2B2DA75B;
	Wed, 30 Jul 2025 17:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753897627; cv=none; b=eM00idzpiYgGJA/7TbgP9u2kNifOJ66hGUMT6Q5HFcUxHWSvEiEgpnwboIYx92JoeiwxWPsuhUoHjobvK9OEiG/t8zGNJg3sf2FAtIHr4ra/KYPl9VgvYyB/Hup0u8gUVpWtJ7t9u4O0RceaS9xm2OZFpmli/A5zmidKwVgPCDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753897627; c=relaxed/simple;
	bh=YBJus5C8l5AMo62+7/2sG3d8ceo/0qQLJ1V6dkpFBaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7FOKeDii781uHKJbtoEHZrEtWbxTuaBTRionVNvup576E+9DZu5j1R85L4BtSIIO3RHRAOxzq2qiGyv6VxKCganbQhoXsT0DQH1S8+Cmm4INmKE1nWozSStHlzAStUyimJHNyBni/MbqF52QVI9od+V2hVFmUeppz4oh+4cQDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=o2LoQHDL; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56UHk6nB1614815
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 30 Jul 2025 10:46:32 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56UHk6nB1614815
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753897592;
	bh=SZMIKmky2zV5qXb0yssonRrDBOK8LL684EUF4Rj+HaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2LoQHDLwJzb5swEyLMdRQtcHydVM44dg9fAe37C8+Ab9ll/DUAaevydDbA3v8wTs
	 ZlMKCoPHlBtMTFkhm3A1uelx+5spnpIMvr8LdFDy0SVXJy9fd6GZAyFj3LNGpgzqAp
	 +hdho1x1BU1oCuEwhZrBJQGvnTEWqh6XdQkOQNrCZkR7KhLyMA+QefMrxOTGwILv4X
	 358GM4M3dv+c3vZnf9p9u+wuAVoO8gHCYIwLW1RUWKS98EvTipZQUre1g8xY34pBUE
	 9T7eQC1HjEqMdPlaD6xuPjduwEbuLDBDoh6GfM4XoVy8f4NzupZDyzkJVtXXo6xzFQ
	 Y8ORGDhpPLTtg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v1 3/4] KVM: VMX: Handle the immediate form of MSR instructions
Date: Wed, 30 Jul 2025 10:46:04 -0700
Message-ID: <20250730174605.1614792-4-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730174605.1614792-1-xin@zytor.com>
References: <20250730174605.1614792-1-xin@zytor.com>
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

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/include/uapi/asm/vmx.h |  6 +++++-
 arch/x86/kvm/vmx/vmx.c          | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h          |  5 +++++
 arch/x86/kvm/x86.c              | 29 ++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h              |  1 +
 6 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a854d9a166fe..f8d85efd47b6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -979,6 +979,7 @@ struct kvm_vcpu_arch {
 	unsigned long guest_debug_dr7;
 	u64 msr_platform_info;
 	u64 msr_misc_features_enables;
+	int rdmsr_reg;
 
 	u64 mcg_cap;
 	u64 mcg_status;
@@ -2156,7 +2157,9 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiat
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b3..7129e7b1ef03 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6003,6 +6003,22 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_rdmsr_imm(struct kvm_vcpu *vcpu)
+{
+	u32 msr = vmx_get_exit_qual(vcpu);
+	int reg = vmx_get_instr_info_reg(vmcs_read32(VMX_INSTRUCTION_INFO));
+
+	return kvm_emulate_rdmsr_imm(vcpu, msr, reg);
+}
+
+static int handle_wrmsr_imm(struct kvm_vcpu *vcpu)
+{
+	u32 msr = vmx_get_exit_qual(vcpu);
+	int reg = vmx_get_instr_info_reg(vmcs_read32(VMX_INSTRUCTION_INFO));
+
+	return kvm_emulate_wrmsr_imm(vcpu, msr, reg);
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -6061,6 +6077,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
 	[EXIT_REASON_NOTIFY]		      = handle_notify,
+	[EXIT_REASON_MSR_READ_IMM]            = handle_rdmsr_imm,
+	[EXIT_REASON_MSR_WRITE_IMM]           = handle_wrmsr_imm,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -6495,6 +6513,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 #ifdef CONFIG_MITIGATION_RETPOLINE
 	if (exit_reason.basic == EXIT_REASON_MSR_WRITE)
 		return kvm_emulate_wrmsr(vcpu);
+	else if (exit_reason.basic == EXIT_REASON_MSR_WRITE_IMM)
+		return handle_wrmsr_imm(vcpu);
 	else if (exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER)
 		return handle_preemption_timer(vcpu);
 	else if (exit_reason.basic == EXIT_REASON_INTERRUPT_WINDOW)
@@ -7171,6 +7191,12 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
 	switch (vmx_get_exit_reason(vcpu).basic) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
+	case EXIT_REASON_MSR_WRITE_IMM: {
+		u32 msr = vmx_get_exit_qual(vcpu);
+		int reg = vmx_get_instr_info_reg(vmcs_read32(VMX_INSTRUCTION_INFO));
+
+		return handle_fastpath_set_msr_imm_irqoff(vcpu, msr, reg);
+	}
 	case EXIT_REASON_PREEMPTION_TIMER:
 		return handle_fastpath_preemption_timer(vcpu, force_immediate_exit);
 	case EXIT_REASON_HLT:
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
index 5086c3b30345..ed41d583aaae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1962,9 +1962,14 @@ EXPORT_SYMBOL_GPL(kvm_set_msr);
 
 static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->run->msr.error) {
+	if (vcpu->run->msr.error)
+		return;
+
+	if (vcpu->arch.rdmsr_reg == VCPU_EXREG_EDX_EAX) {
 		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
 		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
+	} else {
+		kvm_register_write(vcpu, vcpu->arch.rdmsr_reg, vcpu->run->msr.data);
 	}
 }
 
@@ -2041,6 +2046,8 @@ static int kvm_emulate_get_msr(struct kvm_vcpu *vcpu, u32 msr, int reg)
 			kvm_register_write(vcpu, reg, data);
 		}
 	} else {
+		vcpu->arch.rdmsr_reg = reg;
+
 		/* MSR read failed? See if we should ask user space */
 		if (kvm_msr_user_space(vcpu, msr, KVM_EXIT_X86_RDMSR, 0,
 				       complete_fast_rdmsr, r))
@@ -2057,6 +2064,12 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
 
+int kvm_emulate_rdmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
+{
+	return kvm_emulate_get_msr(vcpu, msr, reg);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr_imm);
+
 static int kvm_emulate_set_msr(struct kvm_vcpu *vcpu, u32 msr, int reg)
 {
 	u64 data;
@@ -2091,6 +2104,12 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
+int kvm_emulate_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
+{
+	return kvm_emulate_set_msr(vcpu, msr, reg);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr_imm);
+
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu)
 {
 	return kvm_skip_emulated_instruction(vcpu);
@@ -2231,6 +2250,12 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
+fastpath_t handle_fastpath_set_msr_imm_irqoff(struct kvm_vcpu *vcpu, u32 msr, int reg)
+{
+	return handle_set_msr_irqoff(vcpu, msr, reg);
+}
+EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_imm_irqoff);
+
 /*
  * Adapt set_msr() to msr_io()'s calling convention
  */
@@ -8387,6 +8412,8 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 		return X86EMUL_UNHANDLEABLE;
 
 	if (r) {
+		vcpu->arch.rdmsr_reg = VCPU_EXREG_EDX_EAX;
+
 		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
 				       complete_emulated_rdmsr, r))
 			return X86EMUL_IO_NEEDED;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bcfd9b719ada..f8d117a17c46 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -438,6 +438,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
+fastpath_t handle_fastpath_set_msr_imm_irqoff(struct kvm_vcpu *vcpu, u32 msr, int reg);
 fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
 
 extern struct kvm_caps kvm_caps;
-- 
2.50.1


