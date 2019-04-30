Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6B8FEF5
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 19:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfD3Rg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 13:36:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:32357 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfD3RgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 13:36:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 10:36:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="166341322"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga002.fm.intel.com with ESMTP; 30 Apr 2019 10:36:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Omit caching logic for always-available GPRs
Date:   Tue, 30 Apr 2019 10:36:17 -0700
Message-Id: <20190430173619.15774-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430173619.15774-1-sean.j.christopherson@intel.com>
References: <20190430173619.15774-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Except for RSP and RIP, which are held in VMX's VMCS, GPRs are always
treated "available and dirtly" on both VMX and SVM, i.e. are
unconditionally loaded/saved immediately before/after VM-Enter/VM-Exit.

Eliminating the unnecessary caching code reduces the size of KVM by a
non-trivial amount, much of which comes from the most common code paths.
E.g. on x86_64, kvm_emulate_cpuid() is reduced from 342 to 182 bytes and
kvm_emulate_hypercall() from 1362 to 1143, with the total size of KVM
dropping by ~1000 bytes.  With CONFIG_RETPOLINE=y, the numbers are even
more pronounced, e.g.: 353->182, 1418->1172 and well over 2000 bytes.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

As an added bonus, this also gave me a legitimate way to get rid of the
funky wrapping of ": 0;" in complete_fast_pio_in(), which is probably my
favorite part of this patch.  ;-)

 arch/x86/kvm/cpuid.c          | 12 ++---
 arch/x86/kvm/hyperv.c         | 24 +++++-----
 arch/x86/kvm/kvm_cache_regs.h | 32 ++++++++++++-
 arch/x86/kvm/svm.c            | 26 +++++-----
 arch/x86/kvm/vmx/vmx.c        |  2 +-
 arch/x86/kvm/x86.c            | 89 +++++++++++++++++------------------
 6 files changed, 105 insertions(+), 80 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fd3951638ae4..fc8ccf596624 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -962,13 +962,13 @@ int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	if (cpuid_fault_enabled(vcpu) && !kvm_require_cpl(vcpu, 0))
 		return 1;
 
-	eax = kvm_register_read(vcpu, VCPU_REGS_RAX);
-	ecx = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	eax = kvm_rax_read(vcpu);
+	ecx = kvm_rcx_read(vcpu);
 	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
-	kvm_register_write(vcpu, VCPU_REGS_RAX, eax);
-	kvm_register_write(vcpu, VCPU_REGS_RBX, ebx);
-	kvm_register_write(vcpu, VCPU_REGS_RCX, ecx);
-	kvm_register_write(vcpu, VCPU_REGS_RDX, edx);
+	kvm_rax_write(vcpu, eax);
+	kvm_rbx_write(vcpu, ebx);
+	kvm_rcx_write(vcpu, ecx);
+	kvm_rdx_write(vcpu, edx);
 	return kvm_skip_emulated_instruction(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 421899f6ad7b..7868daceb25b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1526,10 +1526,10 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 
 	longmode = is_64_bit_mode(vcpu);
 	if (longmode)
-		kvm_register_write(vcpu, VCPU_REGS_RAX, result);
+		kvm_rax_write(vcpu, result);
 	else {
-		kvm_register_write(vcpu, VCPU_REGS_RDX, result >> 32);
-		kvm_register_write(vcpu, VCPU_REGS_RAX, result & 0xffffffff);
+		kvm_rdx_write(vcpu, result >> 32);
+		kvm_rax_write(vcpu, result & 0xffffffff);
 	}
 }
 
@@ -1602,18 +1602,18 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	longmode = is_64_bit_mode(vcpu);
 
 	if (!longmode) {
-		param = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
-			(kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffffff);
-		ingpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
-			(kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffffff);
-		outgpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
-			(kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffffff);
+		param = ((u64)kvm_rdx_read(vcpu) << 32) |
+			(kvm_rax_read(vcpu) & 0xffffffff);
+		ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
+			(kvm_rcx_read(vcpu) & 0xffffffff);
+		outgpa = ((u64)kvm_rdi_read(vcpu) << 32) |
+			(kvm_rsi_read(vcpu) & 0xffffffff);
 	}
 #ifdef CONFIG_X86_64
 	else {
-		param = kvm_register_read(vcpu, VCPU_REGS_RCX);
-		ingpa = kvm_register_read(vcpu, VCPU_REGS_RDX);
-		outgpa = kvm_register_read(vcpu, VCPU_REGS_R8);
+		param = kvm_rcx_read(vcpu);
+		ingpa = kvm_rdx_read(vcpu);
+		outgpa = kvm_r8_read(vcpu);
 	}
 #endif
 
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index f8f56a93358b..d179b7d7860d 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -9,6 +9,34 @@
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE)
 
+#define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
+static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
+{									      \
+	return vcpu->arch.regs[VCPU_REGS_##uname];			      \
+}									      \
+static __always_inline void kvm_##lname##_write(struct kvm_vcpu *vcpu,	      \
+						unsigned long val)	      \
+{									      \
+	vcpu->arch.regs[VCPU_REGS_##uname] = val;			      \
+}
+BUILD_KVM_GPR_ACCESSORS(rax, RAX)
+BUILD_KVM_GPR_ACCESSORS(rbx, RBX)
+BUILD_KVM_GPR_ACCESSORS(rcx, RCX)
+BUILD_KVM_GPR_ACCESSORS(rdx, RDX)
+BUILD_KVM_GPR_ACCESSORS(rbp, RBP)
+BUILD_KVM_GPR_ACCESSORS(rsi, RSI)
+BUILD_KVM_GPR_ACCESSORS(rdi, RDI)
+#ifdef CONFIG_X86_64
+BUILD_KVM_GPR_ACCESSORS(r8,  R8)
+BUILD_KVM_GPR_ACCESSORS(r9,  R9)
+BUILD_KVM_GPR_ACCESSORS(r10, R10)
+BUILD_KVM_GPR_ACCESSORS(r11, R11)
+BUILD_KVM_GPR_ACCESSORS(r12, R12)
+BUILD_KVM_GPR_ACCESSORS(r13, R13)
+BUILD_KVM_GPR_ACCESSORS(r14, R14)
+BUILD_KVM_GPR_ACCESSORS(r15, R15)
+#endif
+
 static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
 					      enum kvm_reg reg)
 {
@@ -83,8 +111,8 @@ static inline ulong kvm_read_cr4(struct kvm_vcpu *vcpu)
 
 static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 {
-	return (kvm_register_read(vcpu, VCPU_REGS_RAX) & -1u)
-		| ((u64)(kvm_register_read(vcpu, VCPU_REGS_RDX) & -1u) << 32);
+	return (kvm_rax_read(vcpu) & -1u)
+		| ((u64)(kvm_rdx_read(vcpu) & -1u) << 32);
 }
 
 static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 406b558abfef..a855e9ec93d4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2091,7 +2091,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	init_vmcb(svm);
 
 	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true);
-	kvm_register_write(vcpu, VCPU_REGS_RDX, eax);
+	kvm_rdx_write(vcpu, eax);
 
 	if (kvm_vcpu_apicv_active(vcpu) && !init_event)
 		avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
@@ -3408,7 +3408,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	} else {
 		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
 	}
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, hsave->save.rax);
+	kvm_rax_write(&svm->vcpu, hsave->save.rax);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, hsave->save.rsp);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, hsave->save.rip);
 	svm->vmcb->save.dr7 = 0;
@@ -3516,7 +3516,7 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	kvm_mmu_reset_context(&svm->vcpu);
 
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, nested_vmcb->save.rax);
+	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, nested_vmcb->save.rsp);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, nested_vmcb->save.rip);
 
@@ -3791,11 +3791,11 @@ static int invlpga_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	trace_kvm_invlpga(svm->vmcb->save.rip, kvm_register_read(&svm->vcpu, VCPU_REGS_RCX),
-			  kvm_register_read(&svm->vcpu, VCPU_REGS_RAX));
+	trace_kvm_invlpga(svm->vmcb->save.rip, kvm_rcx_read(&svm->vcpu),
+			  kvm_rax_read(&svm->vcpu));
 
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
-	kvm_mmu_invlpg(vcpu, kvm_register_read(&svm->vcpu, VCPU_REGS_RAX));
+	kvm_mmu_invlpg(vcpu, kvm_rax_read(&svm->vcpu));
 
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	return kvm_skip_emulated_instruction(&svm->vcpu);
@@ -3803,7 +3803,7 @@ static int invlpga_interception(struct vcpu_svm *svm)
 
 static int skinit_interception(struct vcpu_svm *svm)
 {
-	trace_kvm_skinit(svm->vmcb->save.rip, kvm_register_read(&svm->vcpu, VCPU_REGS_RAX));
+	trace_kvm_skinit(svm->vmcb->save.rip, kvm_rax_read(&svm->vcpu));
 
 	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 	return 1;
@@ -3817,7 +3817,7 @@ static int wbinvd_interception(struct vcpu_svm *svm)
 static int xsetbv_interception(struct vcpu_svm *svm)
 {
 	u64 new_bv = kvm_read_edx_eax(&svm->vcpu);
-	u32 index = kvm_register_read(&svm->vcpu, VCPU_REGS_RCX);
+	u32 index = kvm_rcx_read(&svm->vcpu);
 
 	if (kvm_set_xcr(&svm->vcpu, index, new_bv) == 0) {
 		svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
@@ -4213,7 +4213,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static int rdmsr_interception(struct vcpu_svm *svm)
 {
-	u32 ecx = kvm_register_read(&svm->vcpu, VCPU_REGS_RCX);
+	u32 ecx = kvm_rcx_read(&svm->vcpu);
 	struct msr_data msr_info;
 
 	msr_info.index = ecx;
@@ -4225,10 +4225,8 @@ static int rdmsr_interception(struct vcpu_svm *svm)
 	} else {
 		trace_kvm_msr_read(ecx, msr_info.data);
 
-		kvm_register_write(&svm->vcpu, VCPU_REGS_RAX,
-				   msr_info.data & 0xffffffff);
-		kvm_register_write(&svm->vcpu, VCPU_REGS_RDX,
-				   msr_info.data >> 32);
+		kvm_rax_write(&svm->vcpu, msr_info.data & 0xffffffff);
+		kvm_rdx_write(&svm->vcpu, msr_info.data >> 32);
 		svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 		return kvm_skip_emulated_instruction(&svm->vcpu);
 	}
@@ -4422,7 +4420,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 static int wrmsr_interception(struct vcpu_svm *svm)
 {
 	struct msr_data msr;
-	u32 ecx = kvm_register_read(&svm->vcpu, VCPU_REGS_RCX);
+	u32 ecx = kvm_rcx_read(&svm->vcpu);
 	u64 data = kvm_read_edx_eax(&svm->vcpu);
 
 	msr.data = data;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d8f101b58ab8..5880c5c7388a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4927,7 +4927,7 @@ static int handle_wbinvd(struct kvm_vcpu *vcpu)
 static int handle_xsetbv(struct kvm_vcpu *vcpu)
 {
 	u64 new_bv = kvm_read_edx_eax(vcpu);
-	u32 index = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	u32 index = kvm_rcx_read(vcpu);
 
 	if (kvm_set_xcr(vcpu, index, new_bv) == 0)
 		return kvm_skip_emulated_instruction(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c09507057743..b6734c2d882f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1096,15 +1096,15 @@ EXPORT_SYMBOL_GPL(kvm_get_dr);
 
 bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 {
-	u32 ecx = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data;
 	int err;
 
 	err = kvm_pmu_rdpmc(vcpu, ecx, &data);
 	if (err)
 		return err;
-	kvm_register_write(vcpu, VCPU_REGS_RAX, (u32)data);
-	kvm_register_write(vcpu, VCPU_REGS_RDX, data >> 32);
+	kvm_rax_write(vcpu, (u32)data);
+	kvm_rdx_write(vcpu, data >> 32);
 	return err;
 }
 EXPORT_SYMBOL_GPL(kvm_rdpmc);
@@ -6564,7 +6564,7 @@ static int complete_fast_pio_out(struct kvm_vcpu *vcpu)
 static int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size,
 			    unsigned short port)
 {
-	unsigned long val = kvm_register_read(vcpu, VCPU_REGS_RAX);
+	unsigned long val = kvm_rax_read(vcpu);
 	int ret = emulator_pio_out_emulated(&vcpu->arch.emulate_ctxt,
 					    size, port, &val, 1);
 
@@ -6588,8 +6588,7 @@ static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
 	}
 
 	/* For size less than 4 we merge, else we zero extend */
-	val = (vcpu->arch.pio.size < 4) ? kvm_register_read(vcpu, VCPU_REGS_RAX)
-					: 0;
+	val = (vcpu->arch.pio.size < 4) ? kvm_rax_read(vcpu) : 0;
 
 	/*
 	 * Since vcpu->arch.pio.count == 1 let emulator_pio_in_emulated perform
@@ -6597,7 +6596,7 @@ static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
 	 */
 	emulator_pio_in_emulated(&vcpu->arch.emulate_ctxt, vcpu->arch.pio.size,
 				 vcpu->arch.pio.port, &val, 1);
-	kvm_register_write(vcpu, VCPU_REGS_RAX, val);
+	kvm_rax_write(vcpu, val);
 
 	return kvm_skip_emulated_instruction(vcpu);
 }
@@ -6609,12 +6608,12 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	int ret;
 
 	/* For size less than 4 we merge, else we zero extend */
-	val = (size < 4) ? kvm_register_read(vcpu, VCPU_REGS_RAX) : 0;
+	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
 
 	ret = emulator_pio_in_emulated(&vcpu->arch.emulate_ctxt, size, port,
 				       &val, 1);
 	if (ret) {
-		kvm_register_write(vcpu, VCPU_REGS_RAX, val);
+		kvm_rax_write(vcpu, val);
 		return ret;
 	}
 
@@ -7129,11 +7128,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	if (kvm_hv_hypercall_enabled(vcpu->kvm))
 		return kvm_hv_hypercall(vcpu);
 
-	nr = kvm_register_read(vcpu, VCPU_REGS_RAX);
-	a0 = kvm_register_read(vcpu, VCPU_REGS_RBX);
-	a1 = kvm_register_read(vcpu, VCPU_REGS_RCX);
-	a2 = kvm_register_read(vcpu, VCPU_REGS_RDX);
-	a3 = kvm_register_read(vcpu, VCPU_REGS_RSI);
+	nr = kvm_rax_read(vcpu);
+	a0 = kvm_rbx_read(vcpu);
+	a1 = kvm_rcx_read(vcpu);
+	a2 = kvm_rdx_read(vcpu);
+	a3 = kvm_rsi_read(vcpu);
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
@@ -7174,7 +7173,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 out:
 	if (!op_64_bit)
 		ret = (u32)ret;
-	kvm_register_write(vcpu, VCPU_REGS_RAX, ret);
+	kvm_rax_write(vcpu, ret);
 
 	++vcpu->stat.hypercalls;
 	return kvm_skip_emulated_instruction(vcpu);
@@ -8263,23 +8262,23 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 		emulator_writeback_register_cache(&vcpu->arch.emulate_ctxt);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 	}
-	regs->rax = kvm_register_read(vcpu, VCPU_REGS_RAX);
-	regs->rbx = kvm_register_read(vcpu, VCPU_REGS_RBX);
-	regs->rcx = kvm_register_read(vcpu, VCPU_REGS_RCX);
-	regs->rdx = kvm_register_read(vcpu, VCPU_REGS_RDX);
-	regs->rsi = kvm_register_read(vcpu, VCPU_REGS_RSI);
-	regs->rdi = kvm_register_read(vcpu, VCPU_REGS_RDI);
+	regs->rax = kvm_rax_read(vcpu);
+	regs->rbx = kvm_rbx_read(vcpu);
+	regs->rcx = kvm_rcx_read(vcpu);
+	regs->rdx = kvm_rdx_read(vcpu);
+	regs->rsi = kvm_rsi_read(vcpu);
+	regs->rdi = kvm_rdi_read(vcpu);
 	regs->rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
-	regs->rbp = kvm_register_read(vcpu, VCPU_REGS_RBP);
+	regs->rbp = kvm_rbp_read(vcpu);
 #ifdef CONFIG_X86_64
-	regs->r8 = kvm_register_read(vcpu, VCPU_REGS_R8);
-	regs->r9 = kvm_register_read(vcpu, VCPU_REGS_R9);
-	regs->r10 = kvm_register_read(vcpu, VCPU_REGS_R10);
-	regs->r11 = kvm_register_read(vcpu, VCPU_REGS_R11);
-	regs->r12 = kvm_register_read(vcpu, VCPU_REGS_R12);
-	regs->r13 = kvm_register_read(vcpu, VCPU_REGS_R13);
-	regs->r14 = kvm_register_read(vcpu, VCPU_REGS_R14);
-	regs->r15 = kvm_register_read(vcpu, VCPU_REGS_R15);
+	regs->r8 = kvm_r8_read(vcpu);
+	regs->r9 = kvm_r9_read(vcpu);
+	regs->r10 = kvm_r10_read(vcpu);
+	regs->r11 = kvm_r11_read(vcpu);
+	regs->r12 = kvm_r12_read(vcpu);
+	regs->r13 = kvm_r13_read(vcpu);
+	regs->r14 = kvm_r14_read(vcpu);
+	regs->r15 = kvm_r15_read(vcpu);
 #endif
 
 	regs->rip = kvm_rip_read(vcpu);
@@ -8299,23 +8298,23 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	vcpu->arch.emulate_regs_need_sync_from_vcpu = true;
 	vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 
-	kvm_register_write(vcpu, VCPU_REGS_RAX, regs->rax);
-	kvm_register_write(vcpu, VCPU_REGS_RBX, regs->rbx);
-	kvm_register_write(vcpu, VCPU_REGS_RCX, regs->rcx);
-	kvm_register_write(vcpu, VCPU_REGS_RDX, regs->rdx);
-	kvm_register_write(vcpu, VCPU_REGS_RSI, regs->rsi);
-	kvm_register_write(vcpu, VCPU_REGS_RDI, regs->rdi);
+	kvm_rax_write(vcpu, regs->rax);
+	kvm_rbx_write(vcpu, regs->rbx);
+	kvm_rcx_write(vcpu, regs->rcx);
+	kvm_rdx_write(vcpu, regs->rdx);
+	kvm_rsi_write(vcpu, regs->rsi);
+	kvm_rdi_write(vcpu, regs->rdi);
 	kvm_register_write(vcpu, VCPU_REGS_RSP, regs->rsp);
-	kvm_register_write(vcpu, VCPU_REGS_RBP, regs->rbp);
+	kvm_rbp_write(vcpu, regs->rbp);
 #ifdef CONFIG_X86_64
-	kvm_register_write(vcpu, VCPU_REGS_R8, regs->r8);
-	kvm_register_write(vcpu, VCPU_REGS_R9, regs->r9);
-	kvm_register_write(vcpu, VCPU_REGS_R10, regs->r10);
-	kvm_register_write(vcpu, VCPU_REGS_R11, regs->r11);
-	kvm_register_write(vcpu, VCPU_REGS_R12, regs->r12);
-	kvm_register_write(vcpu, VCPU_REGS_R13, regs->r13);
-	kvm_register_write(vcpu, VCPU_REGS_R14, regs->r14);
-	kvm_register_write(vcpu, VCPU_REGS_R15, regs->r15);
+	kvm_r8_write(vcpu, regs->r8);
+	kvm_r9_write(vcpu, regs->r9);
+	kvm_r10_write(vcpu, regs->r10);
+	kvm_r11_write(vcpu, regs->r11);
+	kvm_r12_write(vcpu, regs->r12);
+	kvm_r13_write(vcpu, regs->r13);
+	kvm_r14_write(vcpu, regs->r14);
+	kvm_r15_write(vcpu, regs->r15);
 #endif
 
 	kvm_rip_write(vcpu, regs->rip);
-- 
2.21.0

