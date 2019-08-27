Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CFA9F53B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbfH0Vkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:40:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:61898 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730835AbfH0Vks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919750"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 14:40:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 05/14] KVM: x86: Move #GP injection for VMware into x86_emulate_instruction()
Date:   Tue, 27 Aug 2019 14:40:31 -0700
Message-Id: <20190827214040.18710-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Immediately inject a #GP when VMware emulation fails and return
EMULATE_DONE instead of propagating EMULATE_FAIL up the stack.  This
helps pave the way for removing EMULATE_FAIL altogether.

Rename EMULTYPE_VMWARE to EMULTYPE_VMWARE_GP to document that the x86
emulator is called to handle VMware #GP interception, e.g. why a #GP
is injected on emulation failure for EMULTYPE_VMWARE_GP.

Drop EMULTYPE_NO_UD_ON_FAIL as a standalone type.  The "no #UD on fail"
is used only in the VMWare case and is obsoleted by having the emulator
itself reinject #GP.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/svm.c              | 10 ++--------
 arch/x86/kvm/vmx/vmx.c          | 10 ++--------
 arch/x86/kvm/x86.c              | 14 +++++++++-----
 4 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44a5ce57a905..d1d5b5ca1195 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1318,8 +1318,7 @@ enum emulation_result {
 #define EMULTYPE_TRAP_UD	    (1 << 1)
 #define EMULTYPE_SKIP		    (1 << 2)
 #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
-#define EMULTYPE_NO_UD_ON_FAIL	    (1 << 4)
-#define EMULTYPE_VMWARE		    (1 << 5)
+#define EMULTYPE_VMWARE_GP	    (1 << 5)
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7242142573d6..c4b72db48bc5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2768,7 +2768,6 @@ static int gp_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u32 error_code = svm->vmcb->control.exit_info_1;
-	int er;
 
 	WARN_ON_ONCE(!enable_vmware_backdoor);
 
@@ -2780,13 +2779,8 @@ static int gp_interception(struct vcpu_svm *svm)
 		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 		return 1;
 	}
-	er = kvm_emulate_instruction(vcpu,
-		EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
-	if (er == EMULATE_USER_EXIT)
-		return 0;
-	else if (er != EMULATE_DONE)
-		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
-	return 1;
+	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP) !=
+						EMULATE_USER_EXIT;
 }
 
 static bool is_erratum_383(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8a65e1122376..c6ba452296e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4492,7 +4492,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	u32 intr_info, ex_no, error_code;
 	unsigned long cr2, rip, dr6;
 	u32 vect_info;
-	enum emulation_result er;
 
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmx->exit_intr_info;
@@ -4519,13 +4518,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 			return 1;
 		}
-		er = kvm_emulate_instruction(vcpu,
-			EMULTYPE_VMWARE | EMULTYPE_NO_UD_ON_FAIL);
-		if (er == EMULATE_USER_EXIT)
-			return 0;
-		else if (er != EMULATE_DONE)
-			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
-		return 1;
+		return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP) !=
+							EMULATE_USER_EXIT;
 	}
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe847f8eb947..228ca71d5b01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6210,8 +6210,10 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
-	if (emulation_type & EMULTYPE_NO_UD_ON_FAIL)
-		return EMULATE_FAIL;
+	if (emulation_type & EMULTYPE_VMWARE_GP) {
+		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+		return EMULATE_DONE;
+	}
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
@@ -6543,9 +6545,11 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if ((emulation_type & EMULTYPE_VMWARE) &&
-	    !is_vmware_backdoor_opcode(ctxt))
-		return EMULATE_FAIL;
+	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
+	    !is_vmware_backdoor_opcode(ctxt)) {
+		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
+		return EMULATE_DONE;
+	}
 
 	if (emulation_type & EMULTYPE_SKIP) {
 		kvm_rip_write(vcpu, ctxt->_eip);
-- 
2.22.0

