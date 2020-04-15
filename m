Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355E31AB2BF
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 22:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371329AbgDOUfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 16:35:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:20840 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371302AbgDOUfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 16:35:01 -0400
IronPort-SDR: o+2GpII5lN0+pON7Sp0C2QR+XsCJf4YAfZEvsYGVIkuiOwP8XEjwY7Z9ur4bQdMnrb7xqRA4Pd
 TWsJ4K8yFmrw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 13:34:58 -0700
IronPort-SDR: O02n3iteVrECxMvqLKIOLHe8rcvOFKfHoFc9U2xegqKUg5qnnoD3Bted5INT3m5yOT2J4L9tab
 noWSTm2JMBZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="288657650"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 15 Apr 2020 13:34:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: VMX: Cache vmcs.EXIT_QUALIFICATION using arch avail_reg flags
Date:   Wed, 15 Apr 2020 13:34:53 -0700
Message-Id: <20200415203454.8296-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415203454.8296-1-sean.j.christopherson@intel.com>
References: <20200415203454.8296-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new "extended register" type, EXIT_INFO_1 (to pair with the
nomenclature in .get_exit_info()), and use it to cache VMX's
vmcs.EXIT_QUALIFICATION.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/nested.c       | 21 ++++++++++-----------
 arch/x86/kvm/vmx/nested.h       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 28 ++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h          | 15 ++++++++++++++-
 5 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c7da23aed79a..faec08d49e98 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -170,6 +170,7 @@ enum kvm_reg {
 	VCPU_EXREG_CR3,
 	VCPU_EXREG_RFLAGS,
 	VCPU_EXREG_SEGMENTS,
+	VCPU_EXREG_EXIT_INFO_1,
 };
 
 enum {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 979d66fe0c0e..8e2d86c6140e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4603,7 +4603,7 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 	gva_t gva;
 	struct x86_exception e;
 
-	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
+	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
 				vmcs_read32(VMX_INSTRUCTION_INFO), false,
 				sizeof(*vmpointer), &gva))
 		return 1;
@@ -4868,7 +4868,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
 						    : get_vmcs12(vcpu);
-	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
@@ -4954,7 +4954,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
 						    : get_vmcs12(vcpu);
-	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
@@ -5139,7 +5139,7 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 /* Emulate the VMPTRST instruction */
 static int handle_vmptrst(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qual = vmcs_readl(EXIT_QUALIFICATION);
+	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
 	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	gpa_t current_vmptr = to_vmx(vcpu)->nested.current_vmptr;
 	struct x86_exception e;
@@ -5207,7 +5207,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	/* According to the Intel VMX instruction reference, the memory
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
-	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
+	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
 			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
@@ -5289,7 +5289,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	/* according to the intel vmx instruction reference, the memory
 	 * operand is read even if it isn't needed (e.g., for type==global)
 	 */
-	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
+	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
 			vmx_instruction_info, false, sizeof(operand), &gva))
 		return 1;
 	if (kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e)) {
@@ -5419,7 +5419,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 fail:
 	nested_vmx_vmexit(vcpu, vmx->exit_reason,
 			  vmcs_read32(VM_EXIT_INTR_INFO),
-			  vmcs_readl(EXIT_QUALIFICATION));
+			  vmx_get_exit_qual(vcpu));
 	return 1;
 }
 
@@ -5470,7 +5470,7 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
 		return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);
 
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	exit_qualification = vmx_get_exit_qual(vcpu);
 
 	port = exit_qualification >> 16;
 	size = (exit_qualification & 7) + 1;
@@ -5524,7 +5524,7 @@ static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
 static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12)
 {
-	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 	int cr = exit_qualification & 15;
 	int reg;
 	unsigned long val;
@@ -5662,7 +5662,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	}
 
 	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason,
-				vmcs_readl(EXIT_QUALIFICATION),
+				vmx_get_exit_qual(vcpu),
 				vmx->idt_vectoring_info,
 				intr_info,
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
@@ -5813,7 +5813,6 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	}
 }
 
-
 static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index e8f4a74f7251..d81a349e7d45 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -104,7 +104,7 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 	}
 
 	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
-			  vmcs_readl(EXIT_QUALIFICATION));
+			  vmx_get_exit_qual(vcpu));
 	return 1;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9709a6dbeebc..106761fde58c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4698,7 +4698,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	}
 
 	if (is_page_fault(intr_info)) {
-		cr2 = vmcs_readl(EXIT_QUALIFICATION);
+		cr2 = vmx_get_exit_qual(vcpu);
 		/* EPT won't cause page fault directly */
 		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_reason && enable_ept);
 		return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
@@ -4714,7 +4714,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
 		return 1;
 	case DB_VECTOR:
-		dr6 = vmcs_readl(EXIT_QUALIFICATION);
+		dr6 = vmx_get_exit_qual(vcpu);
 		if (!(vcpu->guest_debug &
 		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
 			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
@@ -4769,7 +4769,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	int size, in, string;
 	unsigned port;
 
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	exit_qualification = vmx_get_exit_qual(vcpu);
 	string = (exit_qualification & 16) != 0;
 
 	++vcpu->stat.io_exits;
@@ -4860,7 +4860,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	int err;
 	int ret;
 
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	exit_qualification = vmx_get_exit_qual(vcpu);
 	cr = exit_qualification & 15;
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
@@ -4937,7 +4937,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 	unsigned long exit_qualification;
 	int dr, dr7, reg;
 
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	exit_qualification = vmx_get_exit_qual(vcpu);
 	dr = exit_qualification & DEBUG_REG_ACCESS_NUM;
 
 	/* First, if DR does not exist, trigger UD */
@@ -5050,7 +5050,7 @@ static int handle_invd(struct kvm_vcpu *vcpu)
 
 static int handle_invlpg(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 
 	kvm_mmu_invlpg(vcpu, exit_qualification);
 	return kvm_skip_emulated_instruction(vcpu);
@@ -5082,7 +5082,7 @@ static int handle_xsetbv(struct kvm_vcpu *vcpu)
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
 	if (likely(fasteoi)) {
-		unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+		unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 		int access_type, offset;
 
 		access_type = exit_qualification & APIC_ACCESS_TYPE;
@@ -5103,7 +5103,7 @@ static int handle_apic_access(struct kvm_vcpu *vcpu)
 
 static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 	int vector = exit_qualification & 0xff;
 
 	/* EOI-induced VM exit is trap-like and thus no need to adjust IP */
@@ -5113,7 +5113,7 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
 
 static int handle_apic_write(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 	u32 offset = exit_qualification & 0xfff;
 
 	/* APIC-write VM exit is trap-like and thus no need to adjust IP */
@@ -5134,7 +5134,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 	idt_index = (vmx->idt_vectoring_info & VECTORING_INFO_VECTOR_MASK);
 	type = (vmx->idt_vectoring_info & VECTORING_INFO_TYPE_MASK);
 
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	exit_qualification = vmx_get_exit_qual(vcpu);
 
 	reason = (u32)exit_qualification >> 30;
 	if (reason == TASK_SWITCH_GATE && idt_v) {
@@ -5184,7 +5184,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	gpa_t gpa;
 	u64 error_code;
 
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	exit_qualification = vmx_get_exit_qual(vcpu);
 
 	/*
 	 * EPT violation happened while executing iret from NMI,
@@ -5444,7 +5444,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	/* According to the Intel instruction reference, the memory operand
 	 * is read even if it isn't needed (e.g., for type==all)
 	 */
-	if (get_vmx_mem_address(vcpu, vmcs_readl(EXIT_QUALIFICATION),
+	if (get_vmx_mem_address(vcpu, vmx_get_exit_qual(vcpu),
 				vmx_instruction_info, false,
 				sizeof(operand), &gva))
 		return 1;
@@ -5520,7 +5520,7 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 
 	trace_kvm_pml_full(vcpu->vcpu_id);
 
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	exit_qualification = vmx_get_exit_qual(vcpu);
 
 	/*
 	 * PML buffer FULL happened while executing iret from NMI,
@@ -5634,7 +5634,7 @@ static const int kvm_vmx_max_exit_handlers =
 
 static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
 {
-	*info1 = vmcs_readl(EXIT_QUALIFICATION);
+	*info1 = vmx_get_exit_qual(vcpu);
 	*info2 = vmcs_read32(VM_EXIT_INTR_INFO);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 78c99a60fa49..a13eafec67fc 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -210,6 +210,7 @@ struct vcpu_vmx {
 	 */
 	bool		      guest_state_loaded;
 
+	unsigned long         exit_qualification;
 	u32                   exit_intr_info;
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
@@ -449,7 +450,8 @@ static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 				  | (1 << VCPU_EXREG_RFLAGS)
 				  | (1 << VCPU_EXREG_PDPTR)
 				  | (1 << VCPU_EXREG_SEGMENTS)
-				  | (1 << VCPU_EXREG_CR3));
+				  | (1 << VCPU_EXREG_CR3)
+				  | (1 << VCPU_EXREG_EXIT_INFO_1));
 	vcpu->arch.regs_dirty = 0;
 }
 
@@ -493,6 +495,17 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
+static inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!kvm_register_is_available(vcpu, VCPU_EXREG_EXIT_INFO_1)) {
+		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
+		vmx->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+	}
+	return vmx->exit_qualification;
+}
+
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
-- 
2.26.0

