Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68ED69A499
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 03:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732795AbfHWBHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 21:07:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:38011 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732720AbfHWBHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 21:07:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:07:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="186733501"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Aug 2019 18:07:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 06/13] KVM: x86: Move #GP injection for VMware into x86_emulate_instruction()
Date:   Thu, 22 Aug 2019 18:07:02 -0700
Message-Id: <20190823010709.24879-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823010709.24879-1-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Immediately inject a #GP when VMware emulation fails and return
EMULATE_DONE instead of propagating EMULATE_FAIL up the stack.  This
helps pave the way for removing EMULATE_FAIL altogether.

Rename EMULTYPE_VMWARE to EMULTYPE_VMWARE_GP to help document why a #GP
is injected on emulation failure.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              |  9 ++-------
 arch/x86/kvm/vmx/vmx.c          |  9 ++-------
 arch/x86/kvm/x86.c              | 14 +++++++++-----
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dd6bd9ed0839..d1d5b5ca1195 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1318,7 +1318,7 @@ enum emulation_result {
 #define EMULTYPE_TRAP_UD	    (1 << 1)
 #define EMULTYPE_SKIP		    (1 << 2)
 #define EMULTYPE_ALLOW_RETRY	    (1 << 3)
-#define EMULTYPE_VMWARE		    (1 << 5)
+#define EMULTYPE_VMWARE_GP	    (1 << 5)
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b96a119690f4..97562c2c8b7b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2768,7 +2768,6 @@ static int gp_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u32 error_code = svm->vmcb->control.exit_info_1;
-	int er;
 
 	WARN_ON_ONCE(!enable_vmware_backdoor);
 
@@ -2776,12 +2775,8 @@ static int gp_interception(struct vcpu_svm *svm)
 		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 		return 1;
 	}
-	er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
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
index 3ee0dd304bc7..25410c58c758 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4492,7 +4492,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	u32 intr_info, ex_no, error_code;
 	unsigned long cr2, rip, dr6;
 	u32 vect_info;
-	enum emulation_result er;
 
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmx->exit_intr_info;
@@ -4514,12 +4513,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 			return 1;
 		}
-		er = kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE);
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
index e0f0e14d8fac..228ca71d5b01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6210,8 +6210,10 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
-	if (emulation_type & EMULTYPE_VMWARE)
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

