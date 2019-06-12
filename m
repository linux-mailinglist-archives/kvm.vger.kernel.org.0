Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4377142D26
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404479AbfFLRMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:12:19 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:15654 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfFLRMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:12:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359536; x=1591895536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nu+2j4+opOk0AuGdSc7kENHXvBAWinXIo7DvC8lL1C0=;
  b=GgjrjYR2Fhg4rIViXM04lQ8U+jtAtJ4zfL1frHd5h6uDaq+WJOROx/75
   2JjKdfPbb7UahvzcnCa9jjElTvNR7RzWT6c+s9Q/GC3YIlB06C3DZ3DnH
   dkVn95bv6dxgDsv2kOFETo/0vLwb3mMte3meAQ+BAQhyKdlaSP08ZVzGw
   k=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="810039218"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Jun 2019 17:12:15 +0000
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (pdx2-ws-svc-lb17-vlan2.amazon.com [10.247.140.66])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 9D794A1892;
        Wed, 12 Jun 2019 17:12:14 +0000 (UTC)
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (ua08cfdeba6fe59dc80a8.ant.amazon.com [127.0.0.1])
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x5CHCCn6018873;
        Wed, 12 Jun 2019 19:12:12 +0200
Received: (from mhillenb@localhost)
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Submit) id x5CHCCfn018865;
        Wed, 12 Jun 2019 19:12:12 +0200
From:   Marius Hillenbrand <mhillenb@amazon.de>
To:     kvm@vger.kernel.org
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Julian Stecklina <js@alien8.de>
Subject: [RFC 09/10] kvm, vmx: move gprs to process local memory
Date:   Wed, 12 Jun 2019 19:08:42 +0200
Message-Id: <20190612170834.14855-10-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

General-purpose registers (GPRs) contain guest data and must be
protected from information leak vulnerabilities in the kernel.

Move GPRs into process local memory and change the VMX and SVM world
switch and related code accordingly.

The VMX and SVM world switch are giant inline assembly code blocks. To
keep the changes minimal, we pass all required state as a pointer to a
single struct in process-local memory, which is hidden from other
processes.

Note that this feature is strictly opt-in. When disabled, the world
switch code remains unchanged.

Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Inspired-by: Julian Stecklina <js@alien8.de> (while jsteckli@amazon.de)
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  27 +++++++-
 arch/x86/kvm/kvm_cache_regs.h   |   4 +-
 arch/x86/kvm/svm.c              |  67 +++++++++++--------
 arch/x86/kvm/vmx.c              | 114 +++++++++++++++++++++-----------
 arch/x86/kvm/x86.c              |   2 +-
 5 files changed, 143 insertions(+), 71 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 41c7b06588f9..4896ecde1c11 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -534,21 +534,30 @@ struct kvm_vcpu_hv {
 	cpumask_t tlb_flush;
 };
 
+typedef unsigned long kvm_arch_regs_t[NR_VCPU_REGS];
 #ifdef CONFIG_KVM_PROCLOCAL
+/*
+ * access to vcpu guest state must go through kvm_vcpu_arch_state(vcpu).
+ */
 struct kvm_vcpu_arch_hidden {
-	u64 placeholder;
+	/*
+	 * rip and regs accesses must go through
+	 * kvm_{register,rip}_{read,write} functions.
+	 */
+	kvm_arch_regs_t regs;
 };
 #endif
 
 struct kvm_vcpu_arch {
 #ifdef CONFIG_KVM_PROCLOCAL
 	struct kvm_vcpu_arch_hidden *hidden;
-#endif
+#else
 	/*
 	 * rip and regs accesses must go through
 	 * kvm_{register,rip}_{read,write} functions.
 	 */
-	unsigned long regs[NR_VCPU_REGS];
+	kvm_arch_regs_t regs;
+#endif
 	u32 regs_avail;
 	u32 regs_dirty;
 
@@ -791,6 +800,18 @@ struct kvm_vcpu_arch {
 	bool l1tf_flush_l1d;
 };
 
+#ifdef CONFIG_KVM_PROCLOCAL
+static inline struct kvm_vcpu_arch_hidden *kvm_vcpu_arch_state(struct kvm_vcpu_arch *arch)
+{
+	return arch->hidden;
+}
+#else
+static inline struct kvm_vcpu_arch *kvm_vcpu_arch_state(struct kvm_vcpu_arch *vcpu_arch)
+{
+	return vcpu_arch;
+}
+#endif
+
 struct kvm_lpage_info {
 	int disallow_lpage;
 };
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 9619dcc2b325..b62c42d637e0 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -13,14 +13,14 @@ static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
 	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
 		kvm_x86_ops->cache_reg(vcpu, reg);
 
-	return vcpu->arch.regs[reg];
+	return kvm_vcpu_arch_state(&vcpu->arch)->regs[reg];
 }
 
 static inline void kvm_register_write(struct kvm_vcpu *vcpu,
 				      enum kvm_reg reg,
 				      unsigned long val)
 {
-	vcpu->arch.regs[reg] = val;
+	kvm_vcpu_arch_state(&vcpu->arch)->regs[reg] = val;
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index af66b93902e5..486ad451a67d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -196,6 +196,7 @@ struct vcpu_svm_hidden {
 	struct { /* mimic topology in vcpu_svm: */
 		struct kvm_vcpu_arch_hidden arch;
 	} vcpu;
+	unsigned long vmcb_pa;
 };
 #endif
 
@@ -1585,7 +1586,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(&svm->vcpu, 2);
 	save->rip = 0x0000fff0;
-	svm->vcpu.arch.regs[VCPU_REGS_RIP] = save->rip;
+	kvm_vcpu_arch_state(&svm->vcpu.arch)->regs[VCPU_REGS_RIP] = save->rip;
 
 	/*
 	 * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
@@ -3150,7 +3151,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
-	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	msr    = kvm_vcpu_arch_state(&svm->vcpu.arch)->regs[VCPU_REGS_RCX];
 	offset = svm_msrpm_offset(msr);
 	write  = svm->vmcb->control.exit_info_1 & 1;
 	mask   = 1 << ((2 * (msr & 0xf)) + write);
@@ -5656,10 +5657,11 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long *regs = kvm_vcpu_arch_state(&vcpu->arch)->regs;
 
-	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+	svm->vmcb->save.rax = regs[VCPU_REGS_RAX];
+	svm->vmcb->save.rsp = regs[VCPU_REGS_RSP];
+	svm->vmcb->save.rip = regs[VCPU_REGS_RIP];
 
 	/*
 	 * A vmexit emulation is required before the vcpu can be executed
@@ -5690,6 +5692,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
+#ifdef CONFIG_KVM_PROCLOCAL
+	svm->hidden->vmcb_pa = svm->vmcb_pa;
+#endif
+
 	clgi();
 
 	/*
@@ -5765,24 +5771,31 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 		"xor %%edi, %%edi \n\t"
 		"pop %%" _ASM_BP
 		:
+#ifdef CONFIG_KVM_PROCLOCAL
+		: [svm]"a"(svm->hidden),
+#define SVM_STATE_STRUCT vcpu_svm_hidden
+#else
 		: [svm]"a"(svm),
-		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
-		  [rbx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RBX])),
-		  [rcx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RCX])),
-		  [rdx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RDX])),
-		  [rsi]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RSI])),
-		  [rdi]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RDI])),
-		  [rbp]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RBP]))
+#define SVM_STATE_STRUCT vcpu_svm
+#endif
+		  [vmcb]"i"(offsetof(struct SVM_STATE_STRUCT, vmcb_pa)),
+		  [rbx]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RBX])),
+		  [rcx]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RCX])),
+		  [rdx]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RDX])),
+		  [rsi]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RSI])),
+		  [rdi]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RDI])),
+		  [rbp]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RBP]))
 #ifdef CONFIG_X86_64
-		  , [r8]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R8])),
-		  [r9]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R9])),
-		  [r10]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R10])),
-		  [r11]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R11])),
-		  [r12]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R12])),
-		  [r13]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R13])),
-		  [r14]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R14])),
-		  [r15]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_R15]))
+		  , [r8]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R8])),
+		  [r9]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R9])),
+		  [r10]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R10])),
+		  [r11]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R11])),
+		  [r12]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R12])),
+		  [r13]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R13])),
+		  [r14]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R14])),
+		  [r15]"i"(offsetof(struct SVM_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R15]))
 #endif
+#undef SVM_STATE_STRUCT
 		: "cc", "memory"
 #ifdef CONFIG_X86_64
 		, "rbx", "rcx", "rdx", "rsi", "rdi"
@@ -5829,9 +5842,9 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
-	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
-	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
-	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
+	regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
+	regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
+	regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
@@ -6265,14 +6278,16 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	int ret;
 
 	if (is_guest_mode(vcpu)) {
+		unsigned long *regs = kvm_vcpu_arch_state(&vcpu->arch)->regs;
+
 		/* FED8h - SVM Guest */
 		put_smstate(u64, smstate, 0x7ed8, 1);
 		/* FEE0h - SVM Guest VMCB Physical Address */
 		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb);
 
-		svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-		svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-		svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+		svm->vmcb->save.rax = regs[VCPU_REGS_RAX];
+		svm->vmcb->save.rsp = regs[VCPU_REGS_RSP];
+		svm->vmcb->save.rip = regs[VCPU_REGS_RIP];
 
 		ret = nested_svm_vmexit(svm);
 		if (ret)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0fe9a4ab8268..0d2d6b7b0d50 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -982,6 +982,10 @@ struct vcpu_vmx_hidden {
 	struct { /* mimic topology in vcpu_svm: */
 		struct kvm_vcpu_arch_hidden arch;
 	} vcpu;
+	bool          __launched; /* temporary, used in vmx_vcpu_run */
+	/* shadow fields, used in vmx_vcpu_run */
+	u8            fail;
+	unsigned long host_rsp;
 };
 #endif
 
@@ -1024,7 +1028,9 @@ struct vcpu_vmx {
 	struct loaded_vmcs    vmcs01;
 	struct loaded_vmcs   *loaded_vmcs;
 	struct loaded_vmcs   *loaded_cpu_state;
+#ifndef CONFIG_KVM_PROCLOCAL
 	bool                  __launched; /* temporary, used in vmx_vcpu_run */
+#endif
 	struct msr_autoload {
 		struct vmx_msrs guest;
 		struct vmx_msrs host;
@@ -4612,10 +4618,10 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 	switch (reg) {
 	case VCPU_REGS_RSP:
-		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
+		kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
 		break;
 	case VCPU_REGS_RIP:
-		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
+		kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
 		break;
 	case VCPU_EXREG_PDPTR:
 		if (enable_ept)
@@ -6965,7 +6971,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
 
-	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
+	kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	kvm_set_cr8(vcpu, 0);
 
 	if (!init_event) {
@@ -7712,7 +7718,7 @@ static int handle_cpuid(struct kvm_vcpu *vcpu)
 
 static int handle_rdmsr(struct kvm_vcpu *vcpu)
 {
-	u32 ecx = vcpu->arch.regs[VCPU_REGS_RCX];
+	u32 ecx = kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RCX];
 	struct msr_data msr_info;
 
 	msr_info.index = ecx;
@@ -7726,17 +7732,17 @@ static int handle_rdmsr(struct kvm_vcpu *vcpu)
 	trace_kvm_msr_read(ecx, msr_info.data);
 
 	/* FIXME: handling of bits 32:63 of rax, rdx */
-	vcpu->arch.regs[VCPU_REGS_RAX] = msr_info.data & -1u;
-	vcpu->arch.regs[VCPU_REGS_RDX] = (msr_info.data >> 32) & -1u;
+	kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RAX] = msr_info.data & -1u;
+	kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RDX] = (msr_info.data >> 32) & -1u;
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
 static int handle_wrmsr(struct kvm_vcpu *vcpu)
 {
 	struct msr_data msr;
-	u32 ecx = vcpu->arch.regs[VCPU_REGS_RCX];
-	u64 data = (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
-		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
+	u32 ecx = kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RCX];
+	u64 data = (kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RAX] & -1u)
+		| ((u64)(kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RDX] & -1u) << 32);
 
 	msr.data = data;
 	msr.index = ecx;
@@ -10036,7 +10042,7 @@ static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
 static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 				     struct vmcs12 *vmcs12)
 {
-	u32 index = vcpu->arch.regs[VCPU_REGS_RCX];
+	u32 index = kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RCX];
 	u64 address;
 	bool accessed_dirty;
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
@@ -10082,7 +10088,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12;
-	u32 function = vcpu->arch.regs[VCPU_REGS_RAX];
+	u32 function = kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RAX];
 
 	/*
 	 * VMFUNC is only supported for nested guests, but we always enable the
@@ -10241,7 +10247,7 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
 static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12, u32 exit_reason)
 {
-	u32 msr_index = vcpu->arch.regs[VCPU_REGS_RCX];
+	u32 msr_index = kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RCX];
 	gpa_t bitmap;
 
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
@@ -11467,9 +11473,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
-		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
+		vmcs_writel(GUEST_RSP, kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RSP]);
 	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
-		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
+		vmcs_writel(GUEST_RIP, kvm_vcpu_arch_state(&vcpu->arch)->regs[VCPU_REGS_RIP]);
 
 	cr3 = __get_current_cr3_fast();
 	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
@@ -11508,7 +11514,12 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
+#ifdef CONFIG_KVM_PROCLOCAL
+	vmx->hidden->__launched = vmx->loaded_vmcs->launched;
+	vmx->hidden->host_rsp = vmx->host_rsp;
+#else
 	vmx->__launched = vmx->loaded_vmcs->launched;
+#endif
 
 	evmcs_rsp = static_branch_unlikely(&enable_evmcs) ?
 		(unsigned long)&current_evmcs->host_rsp : 0;
@@ -11588,27 +11599,35 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		".global vmx_return \n\t"
 		"vmx_return: " _ASM_PTR " 2b \n\t"
 		".popsection"
-	      : : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
-		[launched]"i"(offsetof(struct vcpu_vmx, __launched)),
-		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
-		[host_rsp]"i"(offsetof(struct vcpu_vmx, host_rsp)),
-		[rax]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RAX])),
-		[rbx]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RBX])),
-		[rcx]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RCX])),
-		[rdx]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RDX])),
-		[rsi]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RSI])),
-		[rdi]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RDI])),
-		[rbp]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RBP])),
+#ifdef CONFIG_KVM_PROCLOCAL
+		: : "c"(vmx->hidden),
+#define VMX_STATE_STRUCT vcpu_vmx_hidden
+#else
+		: : "c"(vmx),
+#define VMX_STATE_STRUCT vcpu_vmx
+#endif
+		"d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
+		[launched]"i"(offsetof(struct VMX_STATE_STRUCT, __launched)),
+		[fail]"i"(offsetof(struct VMX_STATE_STRUCT, fail)),
+		[host_rsp]"i"(offsetof(struct VMX_STATE_STRUCT, host_rsp)),
+		[rax]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RAX])),
+		[rbx]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RBX])),
+		[rcx]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RCX])),
+		[rdx]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RDX])),
+		[rsi]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RSI])),
+		[rdi]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RDI])),
+		[rbp]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_RBP])),
 #ifdef CONFIG_X86_64
-		[r8]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R8])),
-		[r9]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R9])),
-		[r10]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R10])),
-		[r11]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R11])),
-		[r12]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R12])),
-		[r13]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R13])),
-		[r14]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R14])),
-		[r15]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R15])),
+		[r8]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R8])),
+		[r9]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R9])),
+		[r10]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R10])),
+		[r11]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R11])),
+		[r12]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R12])),
+		[r13]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R13])),
+		[r14]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R14])),
+		[r15]"i"(offsetof(struct VMX_STATE_STRUCT, vcpu.arch.regs[VCPU_REGS_R15])),
 #endif
+#undef VMX_STATE_STRUCT
 		[wordsize]"i"(sizeof(ulong))
 	      : "cc", "memory"
 #ifdef CONFIG_X86_64
@@ -11671,6 +11690,11 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	/* Eliminate branch target predictions from guest mode */
 	vmexit_fill_RSB();
 
+#ifdef CONFIG_KVM_PROCLOCAL
+	vmx->fail = vmx->hidden->fail;
+	vmx->host_rsp = vmx->hidden->host_rsp;
+#endif
+
 	vcpu->arch.cr2 = read_cr2();
 
 	/* All fields are clean at this point */
@@ -11794,7 +11818,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vmx);
+		kmem_cache_free(kvm_vcpu_cache, vmx);
 }
 
 static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
@@ -13570,7 +13594,12 @@ static int __noclone nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->host_state.cr4 = cr4;
 	}
 
+#ifdef CONFIG_KVM_PROCLOCAL
+	vmx->hidden->__launched = vmx->loaded_vmcs->launched;
+	vmx->hidden->host_rsp = vmx->host_rsp;
+#else
 	vmx->__launched = vmx->loaded_vmcs->launched;
+#endif
 
 	asm(
 		/* Set HOST_RSP */
@@ -13593,12 +13622,19 @@ static int __noclone nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 		".global vmx_early_consistency_check_return\n\t"
 		"vmx_early_consistency_check_return: " _ASM_PTR " 2b\n\t"
 		".popsection"
-	      :
-	      : "c"(vmx), "d"((unsigned long)HOST_RSP),
-		[launched]"i"(offsetof(struct vcpu_vmx, __launched)),
-		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
-		[host_rsp]"i"(offsetof(struct vcpu_vmx, host_rsp))
+#ifdef CONFIG_KVM_PROCLOCAL
+	      : : "c"(vmx->hidden),
+#define VMX_STATE_STRUCT vcpu_vmx_hidden
+#else
+	      : : "c"(vmx),
+#define VMX_STATE_STRUCT vcpu_vmx
+#endif
+	      "d"((unsigned long)HOST_RSP),
+		[launched]"i"(offsetof(struct VMX_STATE_STRUCT, __launched)),
+		[fail]"i"(offsetof(struct VMX_STATE_STRUCT, fail)),
+		[host_rsp]"i"(offsetof(struct VMX_STATE_STRUCT, host_rsp))
 	      : "rax", "cc", "memory"
+#undef VMX_STATE_STRUCT
 	);
 
 	vmcs_writel(HOST_RIP, vmx_return);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2cfb96ca8cc8..35e41a772807 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9048,7 +9048,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
 	}
 
-	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
+	memset(kvm_vcpu_arch_state(&vcpu->arch)->regs, 0, sizeof(kvm_arch_regs_t));
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
-- 
2.21.0

