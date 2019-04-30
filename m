Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DDEFEF6
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 19:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfD3Rg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 13:36:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:32357 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfD3Rg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 13:36:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Apr 2019 10:36:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,414,1549958400"; 
   d="scan'208";a="166341326"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga002.fm.intel.com with ESMTP; 30 Apr 2019 10:36:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: Prevent use of kvm_register_{read,write}() with known GPRs
Date:   Tue, 30 Apr 2019 10:36:18 -0700
Message-Id: <20190430173619.15774-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430173619.15774-1-sean.j.christopherson@intel.com>
References: <20190430173619.15774-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... to prevent future code from using the unoptimized generic accessors
when hardcoding access to always-available GPRs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 41 +++++++++++++++++++++++++++++------
 arch/x86/kvm/svm.c            |  8 +++----
 arch/x86/kvm/vmx/nested.c     | 12 +++++-----
 arch/x86/kvm/x86.c            |  4 ++--
 4 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index d179b7d7860d..7074e9f2be79 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -37,8 +37,8 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
 BUILD_KVM_GPR_ACCESSORS(r15, R15)
 #endif
 
-static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
-					      enum kvm_reg reg)
+static inline unsigned long __kvm_register_read(struct kvm_vcpu *vcpu,
+						enum kvm_reg reg)
 {
 	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
 		kvm_x86_ops->cache_reg(vcpu, reg);
@@ -46,23 +46,50 @@ static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
 	return vcpu->arch.regs[reg];
 }
 
-static inline void kvm_register_write(struct kvm_vcpu *vcpu,
-				      enum kvm_reg reg,
-				      unsigned long val)
+static inline void __kvm_register_write(struct kvm_vcpu *vcpu,
+					enum kvm_reg reg,
+					unsigned long val)
 {
 	vcpu->arch.regs[reg] = val;
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
+static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
+					      enum kvm_reg reg)
+{
+	BUILD_BUG_ON(__builtin_constant_p(reg));
+
+	return __kvm_register_read(vcpu, reg);
+}
+
+static inline void kvm_register_write(struct kvm_vcpu *vcpu,
+				      enum kvm_reg reg,
+				      unsigned long val)
+{
+	BUILD_BUG_ON(__builtin_constant_p(reg));
+
+	__kvm_register_write(vcpu, reg, val);
+}
+
 static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
 {
-	return kvm_register_read(vcpu, VCPU_REGS_RIP);
+	return __kvm_register_read(vcpu, VCPU_REGS_RIP);
 }
 
 static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
 {
-	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
+	__kvm_register_write(vcpu, VCPU_REGS_RIP, val);
+}
+
+static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
+{
+	return __kvm_register_read(vcpu, VCPU_REGS_RSP);
+}
+
+static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	__kvm_register_write(vcpu, VCPU_REGS_RSP, val);
 }
 
 static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a855e9ec93d4..bfb5c9ac0e24 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3409,8 +3409,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
 	}
 	kvm_rax_write(&svm->vcpu, hsave->save.rax);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, hsave->save.rsp);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, hsave->save.rip);
+	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
+	kvm_rip_write(&svm->vcpu, hsave->save.rip);
 	svm->vmcb->save.dr7 = 0;
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
@@ -3517,8 +3517,8 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, nested_vmcb->save.rsp);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, nested_vmcb->save.rip);
+	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
+	kvm_rip_write(&svm->vcpu, nested_vmcb->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
 	svm->vmcb->save.rax = nested_vmcb->save.rax;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b46136b099b8..35d92f5ab2de 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2384,8 +2384,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (!enable_ept)
 		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
 
-	kvm_register_write(vcpu, VCPU_REGS_RSP, vmcs12->guest_rsp);
-	kvm_register_write(vcpu, VCPU_REGS_RIP, vmcs12->guest_rip);
+	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
+	kvm_rip_write(vcpu, vmcs12->guest_rip);
 	return 0;
 }
 
@@ -3429,8 +3429,8 @@ static void sync_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
 	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
 
-	vmcs12->guest_rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
-	vmcs12->guest_rip = kvm_register_read(vcpu, VCPU_REGS_RIP);
+	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
+	vmcs12->guest_rip = kvm_rip_read(vcpu);
 	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
 
 	vmcs12->guest_es_selector = vmcs_read16(GUEST_ES_SELECTOR);
@@ -3613,8 +3613,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vcpu->arch.efer &= ~(EFER_LMA | EFER_LME);
 	vmx_set_efer(vcpu, vcpu->arch.efer);
 
-	kvm_register_write(vcpu, VCPU_REGS_RSP, vmcs12->host_rsp);
-	kvm_register_write(vcpu, VCPU_REGS_RIP, vmcs12->host_rip);
+	kvm_rsp_write(vcpu, vmcs12->host_rsp);
+	kvm_rip_write(vcpu, vmcs12->host_rip);
 	vmx_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	vmx_set_interrupt_shadow(vcpu, 0);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6734c2d882f..200e424afcc3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8268,7 +8268,7 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	regs->rdx = kvm_rdx_read(vcpu);
 	regs->rsi = kvm_rsi_read(vcpu);
 	regs->rdi = kvm_rdi_read(vcpu);
-	regs->rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
+	regs->rsp = kvm_rsp_read(vcpu);
 	regs->rbp = kvm_rbp_read(vcpu);
 #ifdef CONFIG_X86_64
 	regs->r8 = kvm_r8_read(vcpu);
@@ -8304,7 +8304,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	kvm_rdx_write(vcpu, regs->rdx);
 	kvm_rsi_write(vcpu, regs->rsi);
 	kvm_rdi_write(vcpu, regs->rdi);
-	kvm_register_write(vcpu, VCPU_REGS_RSP, regs->rsp);
+	kvm_rsp_write(vcpu, regs->rsp);
 	kvm_rbp_write(vcpu, regs->rbp);
 #ifdef CONFIG_X86_64
 	kvm_r8_write(vcpu, regs->r8);
-- 
2.21.0

