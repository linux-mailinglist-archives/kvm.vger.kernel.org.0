Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F6177704
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfG0Fxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:53:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728250AbfG0FwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568601"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 08/21] KVM: x86: Add kvm_x86_ops hook to short circuit emulation
Date:   Fri, 26 Jul 2019 22:52:01 -0700
Message-Id: <20190727055214.9282-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to the existing AMD #NPF case where emulation of the current
instruction is not possible due to lack of information, virtualization
of Intel SGX will introduce a scenario where emulation is not possible
due to the VMExit occurring in an SGX enclave.  And again similar to
the AMD case, emulation can be initiated by kvm_mmu_page_fault(), i.e.
outside of the control of the vendor-specific code.

While the cause and architecturally visible behavior of the two cases
is different,  e.g. Intel SGX will inject a #UD whereas AMD #NPF is a
clean resume or complete shutdown, the impact on the common emulation
code is identical: KVM must stop emulation immediately and resume the
guest.

Replace the exisiting need_emulation_on_page_fault() with a more generic
is_emulatable() kvm_x86_ops callback, which is called unconditionally
by x86_emulate_instruction().

Query is_emulatable() in handle_ud() as well so that the
force_emulation_prefix code doesn't incorrectly modify RIP before
calling emulate_instruction() in the absurdly unlikely scenario that
we encounter forced emulation in conjunction with "do not emulate".
Do this for both Intel and AMD so that any future changes to AMD's
emulation logic take effect as expected for handle_ud().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu.c              | 12 ------------
 arch/x86/kvm/svm.c              | 19 +++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c          | 11 +++++------
 arch/x86/kvm/x86.c              |  9 ++++++++-
 5 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26d1eb83f72a..1341d8390ebe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1198,7 +1198,7 @@ struct kvm_x86_ops {
 				   uint16_t *vmcs_version);
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
-	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+	bool (*is_emulatable)(struct kvm_vcpu *vcpu, void *insn, int insn_len);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 98f6e4f88b04..bf6952f8f330 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5412,18 +5412,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	if (!mmio_info_in_cache(vcpu, cr2, direct) && !is_guest_mode(vcpu))
 		emulation_type = EMULTYPE_ALLOW_RETRY;
 emulate:
-	/*
-	 * On AMD platforms, under certain conditions insn_len may be zero on #NPF.
-	 * This can happen if a guest gets a page-fault on data access but the HW
-	 * table walker is not able to read the instruction page (e.g instruction
-	 * page is not present in memory). In those cases we simply restart the
-	 * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
-	 */
-	if (unlikely(insn && !insn_len)) {
-		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
-			return 1;
-	}
-
 	er = x86_emulate_instruction(vcpu, cr2, emulation_type, insn, insn_len);
 
 	switch (er) {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 48c865a4e5dd..0fb8b60eb136 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7115,10 +7115,25 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	return -ENODEV;
 }
 
-static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
+static bool svm_is_emulatable(struct kvm_vcpu *vcpu, void *insn, int insn_len)
 {
 	bool is_user, smap;
 
+	if (likely(!insn || insn_len))
+		return true;
+
+	/*
+	 * Under certain conditions insn_len may be zero on #NPF.  This can
+	 * happen if a guest gets a page-fault on data access but the HW table
+	 * walker is not able to read the instruction page (e.g instruction
+	 * page is not present in memory). In those cases we simply restart the
+	 * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
+	 */
+	if (unlikely(insn && !insn_len)) {
+		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
+			return 1;
+	}
+
 	is_user = svm_get_cpl(vcpu) == 3;
 	smap = !kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 
@@ -7279,7 +7294,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.nested_enable_evmcs = nested_enable_evmcs,
 	.nested_get_evmcs_version = nested_get_evmcs_version,
 
-	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
+	.is_emulatable = svm_is_emulatable,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d98eac371c0a..f48fc990ca6d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1458,6 +1458,10 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
+static bool vmx_is_emulatable(struct kvm_vcpu *vcpu, void *insn, int insn_len)
+{
+	return true;
+}
 
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
@@ -7416,11 +7420,6 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
@@ -7723,7 +7722,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_nested_state = NULL,
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
-	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+	.is_emulatable = vmx_is_emulatable,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63bb1ee8258e..afcc01a59421 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5274,6 +5274,9 @@ int handle_ud(struct kvm_vcpu *vcpu)
 	char sig[5]; /* ud2; .ascii "kvm" */
 	struct x86_exception e;
 
+	if (unlikely(!kvm_x86_ops->is_emulatable(vcpu, NULL, 0)))
+		return 1;
+
 	if (force_emulation_prefix &&
 	    kvm_read_guest_virt(vcpu, kvm_get_linear_rip(vcpu),
 				sig, sizeof(sig), &e) == 0 &&
@@ -6430,7 +6433,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	int r;
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	bool writeback = true;
-	bool write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
+	bool write_fault_to_spt;
+
+	if (unlikely(!kvm_x86_ops->is_emulatable(vcpu, insn, insn_len)))
+		return EMULATE_DONE;
 
 	vcpu->arch.l1tf_flush_l1d = true;
 
@@ -6438,6 +6444,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	 * Clear write_fault_to_shadow_pgtable here to ensure it is
 	 * never reused.
 	 */
+	write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
 	vcpu->arch.write_fault_to_shadow_pgtable = false;
 	kvm_clear_exception_queue(vcpu);
 
-- 
2.22.0

