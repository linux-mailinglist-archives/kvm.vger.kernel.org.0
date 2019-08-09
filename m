Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F76687F35
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437186AbfHIQPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:13 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52920 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437130AbfHIQPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 111BF3031EBE;
        Fri,  9 Aug 2019 19:01:31 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 553B1305B7AB;
        Fri,  9 Aug 2019 19:01:29 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 67/92] kvm: introspection: use single stepping on unimplemented instructions
Date:   Fri,  9 Aug 2019 19:00:22 +0300
Message-Id: <20190809160047.8319-68-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

On emulation failures, we notify the introspection tool for read/write
operations if needed. Unless it responds with RETRY (to re-enter guest),
we continue single stepping the vCPU.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++
 arch/x86/include/asm/vmx.h      |  2 ++
 arch/x86/kvm/kvmi.c             | 21 ++++++++++++
 arch/x86/kvm/mmu.c              |  5 +++
 arch/x86/kvm/svm.c              |  8 +++++
 arch/x86/kvm/vmx/vmx.c          | 13 ++++++--
 arch/x86/kvm/x86.c              | 57 ++++++++++++++++++++++++++++++++-
 include/linux/kvmi.h            |  4 +++
 virt/kvm/kvmi.c                 | 56 ++++++++++++++++++++++++++++++++
 virt/kvm/kvmi_int.h             |  1 +
 10 files changed, 169 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 60e2c298d469..2392678dde46 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -770,6 +770,9 @@ struct kvm_vcpu_arch {
 	/* set at EPT violation at this point */
 	unsigned long exit_qualification;
 
+	/* #PF translated error code from EPT/NPT exit reason */
+	u64 error_code;
+
 	/* pv related host specific info */
 	struct {
 		bool pv_unhalted;
@@ -1016,6 +1019,7 @@ struct kvm_x86_ops {
 	void (*msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
 				bool enable);
 	bool (*desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
+	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
 	void (*set_mtf)(struct kvm_vcpu *vcpu, bool enable);
 	void (*cr3_write_exiting)(struct kvm_vcpu *vcpu, bool enable);
 	bool (*nested_pagefault)(struct kvm_vcpu *vcpu);
@@ -1627,6 +1631,7 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 void kvm_arch_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 				bool enable);
+u64 kvm_mmu_fault_gla(struct kvm_vcpu *vcpu);
 bool kvm_mmu_nested_pagefault(struct kvm_vcpu *vcpu);
 bool kvm_spt_fault(struct kvm_vcpu *vcpu);
 void kvm_set_mtf(struct kvm_vcpu *vcpu, bool enable);
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 11ca64ced578..bc0f5bbd692c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -538,6 +538,7 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_READABLE_BIT	3
 #define EPT_VIOLATION_WRITABLE_BIT	4
 #define EPT_VIOLATION_EXECUTABLE_BIT	5
+#define EPT_VIOLATION_GLA_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
@@ -545,6 +546,7 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
 #define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
+#define EPT_VIOLATION_GLA_VALID		(1 << EPT_VIOLATION_GLA_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
 /*
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index f0ab4bd9eb37..9d66c7d6c953 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -759,6 +759,27 @@ int kvmi_arch_cmd_control_cr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+bool is_ud2_instruction(struct kvm_vcpu *vcpu, int *emulation_type)
+{
+	u8 ud2[] = {0x0F, 0x0B};
+	u8 insn_len = vcpu->arch.emulate_ctxt.fetch.ptr -
+		      vcpu->arch.emulate_ctxt.fetch.data;
+
+	if (insn_len != sizeof(ud2))
+		return false;
+
+	if (memcmp(vcpu->arch.emulate_ctxt.fetch.data, ud2, insn_len))
+		return false;
+
+	/* Do not reexecute the UD2 instruction, else we might enter to an
+	 * endless emulation loop. Let the emulator fall down through the
+	 * handle_emulation_failure() which shall inject the #UD exception.
+	 */
+	*emulation_type &= ~EMULTYPE_ALLOW_RETRY;
+
+	return true;
+}
+
 void kvmi_arch_start_single_step(struct kvm_vcpu *vcpu)
 {
 	kvm_set_mtf(vcpu, true);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0b859b1797f6..c2f863797495 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -6667,6 +6667,11 @@ void kvm_mmu_module_exit(void)
 	mmu_audit_disable();
 }
 
+u64 kvm_mmu_fault_gla(struct kvm_vcpu *vcpu)
+{
+	return kvm_x86_ops->fault_gla(vcpu);
+}
+
 bool kvm_mmu_nested_pagefault(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops->nested_pagefault(vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3481c0247680..cb536a2611f6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2675,6 +2675,8 @@ static int pf_interception(struct vcpu_svm *svm)
 	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	svm->vcpu.arch.error_code = error_code;
+
 	return kvm_handle_page_fault(&svm->vcpu, error_code, fault_address,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
@@ -7171,6 +7173,11 @@ static void svm_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 	set_msr_interception(svm, msrpm, msr, enable, enable);
 }
 
+static u64 svm_fault_gla(struct kvm_vcpu *vcpu)
+{
+	return ~0ull;
+}
+
 static bool svm_nested_pagefault(struct kvm_vcpu *vcpu)
 {
 	return false;
@@ -7233,6 +7240,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cr3_write_exiting = svm_cr3_write_exiting,
 	.msr_intercept = svm_msr_intercept,
 	.desc_intercept = svm_desc_intercept,
+	.fault_gla = svm_fault_gla,
 	.nested_pagefault = svm_nested_pagefault,
 	.spt_fault = svm_spt_fault,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f0369d0574dc..dc648ba47df3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5171,10 +5171,11 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 			EPT_VIOLATION_EXECUTABLE))
 		      ? PFERR_PRESENT_MASK : 0;
 
-	error_code |= (exit_qualification & 0x100) != 0 ?
-	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
+	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED)
+		      ? PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
 	vcpu->arch.exit_qualification = exit_qualification;
+	vcpu->arch.error_code = error_code;
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
@@ -7880,6 +7881,13 @@ static void vmx_cr3_write_exiting(struct kvm_vcpu *vcpu,
 	/* TODO: nested ? vmcs12->cpu_based_vm_exec_control */
 }
 
+static u64 vmx_fault_gla(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exit_qualification & EPT_VIOLATION_GLA_VALID)
+		return vmcs_readl(GUEST_LINEAR_ADDRESS);
+	return ~0ull;
+}
+
 static bool vmx_nested_pagefault(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.exit_qualification & EPT_VIOLATION_GVA_TRANSLATED)
@@ -7947,6 +7955,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.msr_intercept = vmx_msr_intercept,
 	.cr3_write_exiting = vmx_cr3_write_exiting,
 	.desc_intercept = vmx_desc_intercept,
+	.fault_gla = vmx_fault_gla,
 	.nested_pagefault = vmx_nested_pagefault,
 	.spt_fault = vmx_spt_fault,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 65855340249a..dd10f9e0c054 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6526,6 +6526,53 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
+/*
+ * With introspection enabled, emulation failures translate in events being
+ * missed because the read/write callbacks are not invoked. All we have is
+ * the fetch event (kvm_page_track_preexec). Below we use the EPT/NPT VMEXIT
+ * information to generate the events, but without providing accurate
+ * data and size (the emulator would have computed those). If an instruction
+ * would happen to read and write in the same page, the second event will
+ * initially be missed and we rely on the page tracking mechanism to bring
+ * us back here to send it.
+ */
+static bool kvm_page_track_emulation_failure(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	u64 error_code = vcpu->arch.error_code;
+	bool data_ready = false;
+	u8 data = 0;
+	gva_t gva;
+	bool ret;
+
+	/* MMIO emulation failures should be treated the normal way */
+	if (unlikely(error_code & PFERR_RSVD_MASK))
+		return true;
+
+	/* EPT/NTP must be enabled */
+	if (unlikely(!vcpu->arch.mmu->direct_map))
+		return true;
+
+	/*
+	 * The A/D bit emulation should make this test unneeded, but just
+	 * in case
+	 */
+	if (unlikely((error_code & PFERR_NESTED_GUEST_PAGE) ==
+		     PFERR_NESTED_GUEST_PAGE))
+		return true;
+
+	gva = kvm_mmu_fault_gla(vcpu);
+
+	if (error_code & PFERR_WRITE_MASK)
+		ret = kvm_page_track_prewrite(vcpu, gpa, gva, &data, 0);
+	else if (error_code & PFERR_USER_MASK)
+		ret = kvm_page_track_preread(vcpu, gpa, gva, &data, 0,
+					     &data_ready);
+	else
+		ret = true;
+
+	return ret;
+}
+
 int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			    unsigned long cr2,
 			    int emulation_type,
@@ -6574,9 +6621,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		++vcpu->stat.insn_emulation;
 		if (r == EMULATION_RETRY_INSTR)
 			return EMULATE_DONE;
-		if (r != EMULATION_OK)  {
+		if (r != EMULATION_OK) {
 			if (emulation_type & EMULTYPE_TRAP_UD)
 				return EMULATE_FAIL;
+			if (!kvm_page_track_emulation_failure(vcpu, cr2))
+				return EMULATE_DONE;
+			if (kvmi_single_step(vcpu, cr2, &emulation_type))
+				return EMULATE_DONE;
 			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 						emulation_type))
 				return EMULATE_DONE;
@@ -6621,6 +6672,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		return EMULATE_DONE;
 
 	if (r == EMULATION_FAILED) {
+		if (!kvm_page_track_emulation_failure(vcpu, cr2))
+			return EMULATE_DONE;
+		if (kvmi_single_step(vcpu, cr2, &emulation_type))
+			return EMULATE_DONE;
 		if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 					emulation_type))
 			return EMULATE_DONE;
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index 1dc90284dc3a..69db02795fc0 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -21,6 +21,7 @@ bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_queue_exception(struct kvm_vcpu *vcpu);
 void kvmi_trap_event(struct kvm_vcpu *vcpu);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
+bool kvmi_single_step(struct kvm_vcpu *vcpu, gpa_t gpa, int *emulation_type);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 void kvmi_stop_ss(struct kvm_vcpu *vcpu);
 bool kvmi_vcpu_enabled_ss(struct kvm_vcpu *vcpu);
@@ -41,6 +42,9 @@ static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 u8 write)
 			{ return true; }
+static inline bool kvmi_single_step(struct kvm_vcpu *vcpu, gpa_t gpa,
+				    int *emulation_type)
+			{ return false; }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 06dc23f40ded..14eadc3b9ca9 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -1018,6 +1018,62 @@ void kvmi_destroy_vm(struct kvm *kvm)
 	wait_for_completion_killable(&kvm->kvmi_completed);
 }
 
+static u8 kvmi_translate_pf_error_code(u64 error_code)
+{
+	u8 access = 0;
+
+	if (error_code & PFERR_USER_MASK)
+		access |= KVMI_PAGE_ACCESS_R;
+	if (error_code & PFERR_WRITE_MASK)
+		access |= KVMI_PAGE_ACCESS_W;
+	if (error_code & PFERR_FETCH_MASK)
+		access |= KVMI_PAGE_ACCESS_X;
+
+	return access;
+}
+
+static bool __kvmi_single_step(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       int *emulation_type)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvmi *ikvm = IKVM(kvm);
+	u8 allowed_access, pf_access;
+	u32 ignored_write_bitmap;
+	gfn_t gfn = gpa_to_gfn(gpa);
+	int err;
+
+	if (is_ud2_instruction(vcpu, emulation_type))
+		return false;
+
+	err = kvmi_get_gfn_access(ikvm, gfn, &allowed_access,
+				  &ignored_write_bitmap);
+	if (err) {
+		kvmi_warn(ikvm, "%s: gfn 0x%llx not found in the radix tree\n",
+			  __func__, gpa_to_gfn(gpa));
+		return false;
+	}
+
+	pf_access = kvmi_translate_pf_error_code(vcpu->arch.error_code);
+
+	return kvmi_start_ss(vcpu, gpa, pf_access);
+}
+
+bool kvmi_single_step(struct kvm_vcpu *vcpu, gpa_t gpa, int *emulation_type)
+{
+	struct kvmi *ikvm;
+	bool ret = false;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return false;
+
+	ret = __kvmi_single_step(vcpu, gpa, emulation_type);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
 static int kvmi_vcpu_kill(int sig, struct kvm_vcpu *vcpu)
 {
 	int err = -ESRCH;
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 5485529db06b..c96fa2b1e9b7 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -290,6 +290,7 @@ int kvmi_arch_cmd_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
 				   u64 address);
 int kvmi_arch_cmd_control_cr(struct kvm_vcpu *vcpu,
 			     const struct kvmi_control_cr *req);
+bool is_ud2_instruction(struct kvm_vcpu *vcpu, int *emulation_type);
 void kvmi_arch_start_single_step(struct kvm_vcpu *vcpu);
 void kvmi_arch_stop_single_step(struct kvm_vcpu *vcpu);
 u8 kvmi_arch_relax_page_access(u8 old, u8 new);
