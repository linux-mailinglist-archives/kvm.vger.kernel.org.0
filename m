Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BBA9F55A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731360AbfH0Vl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:41:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:61893 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbfH0Vkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919767"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 14:40:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 10/14] KVM: x86: Move triple fault request into RM int injection
Date:   Tue, 27 Aug 2019 14:40:36 -0700
Message-Id: <20190827214040.18710-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Request triple fault in kvm_inject_realmode_interrupt() instead of
returning EMULATE_FAIL and deferring to the caller.  All existing
callers request triple fault and it's highly unlikely Real Mode is
going to acquire new features.  While this consolidates a small amount
of code, the real goal is to remove the last reference to EMULATE_FAIL.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c |  9 +++------
 arch/x86/kvm/x86.c     | 17 ++++++++---------
 arch/x86/kvm/x86.h     |  2 +-
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a80613a5921f..85a378075725 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1527,8 +1527,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 		int inc_eip = 0;
 		if (kvm_exception_is_soft(nr))
 			inc_eip = vcpu->arch.event_exit_inst_len;
-		if (kvm_inject_realmode_interrupt(vcpu, nr, inc_eip) != EMULATE_DONE)
-			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		kvm_inject_realmode_interrupt(vcpu, nr, inc_eip);
 		return;
 	}
 
@@ -4276,8 +4275,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 		int inc_eip = 0;
 		if (vcpu->arch.interrupt.soft)
 			inc_eip = vcpu->arch.event_exit_inst_len;
-		if (kvm_inject_realmode_interrupt(vcpu, irq, inc_eip) != EMULATE_DONE)
-			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		kvm_inject_realmode_interrupt(vcpu, irq, inc_eip);
 		return;
 	}
 	intr = irq | INTR_INFO_VALID_MASK;
@@ -4313,8 +4311,7 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 	vmx->loaded_vmcs->nmi_known_unmasked = false;
 
 	if (vmx->rmode.vm86_active) {
-		if (kvm_inject_realmode_interrupt(vcpu, NMI_VECTOR, 0) != EMULATE_DONE)
-			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		kvm_inject_realmode_interrupt(vcpu, NMI_VECTOR, 0);
 		return;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83b3c7e9fce7..e457363622e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6176,7 +6176,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
 }
 
-int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
+void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	int ret;
@@ -6188,14 +6188,13 @@ int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 	ctxt->_eip = ctxt->eip + inc_eip;
 	ret = emulate_int_real(ctxt, irq);
 
-	if (ret != X86EMUL_CONTINUE)
-		return EMULATE_FAIL;
-
-	ctxt->eip = ctxt->_eip;
-	kvm_rip_write(vcpu, ctxt->eip);
-	kvm_set_rflags(vcpu, ctxt->eflags);
-
-	return EMULATE_DONE;
+	if (ret != X86EMUL_CONTINUE) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+	} else {
+		ctxt->eip = ctxt->_eip;
+		kvm_rip_write(vcpu, ctxt->eip);
+		kvm_set_rflags(vcpu, ctxt->eflags);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b5274e2a53cf..dbf7442a822b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -261,7 +261,7 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 }
 
 void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
-int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
+void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
 u64 get_kvmclock_ns(struct kvm *kvm);
-- 
2.22.0

