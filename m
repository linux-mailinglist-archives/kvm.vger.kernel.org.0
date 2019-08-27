Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8E29F53A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbfH0Vkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:40:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:61893 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730773AbfH0Vks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919764"
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
Subject: [PATCH v2 09/14] KVM: x86: Handle emulation failure directly in kvm_task_switch()
Date:   Tue, 27 Aug 2019 14:40:35 -0700
Message-Id: <20190827214040.18710-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate the reporting of emulation failure into kvm_task_switch()
so that it can return EMULATE_USER_EXIT.  This helps pave the way for
removing EMULATE_FAIL altogether.

This also fixes a theoretical bug where task switch interception could
suppress an EMULATE_USER_EXIT return.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c     | 11 ++---------
 arch/x86/kvm/vmx/vmx.c | 14 +++-----------
 arch/x86/kvm/x86.c     |  9 ++++++---
 3 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9c46031e96cc..eab01c5d59f7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3892,17 +3892,10 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	if (int_type != SVM_EXITINTINFO_TYPE_SOFT)
 		int_vec = -1;
 
-	if (kvm_task_switch(&svm->vcpu, tss_selector, int_vec, reason,
-				has_error_code, error_code) == EMULATE_FAIL)
-		goto fail;
 
-	return 1;
 
-fail:
-	svm->vcpu.run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	svm->vcpu.run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	svm->vcpu.run->internal.ndata = 0;
-	return 0;
+	return kvm_task_switch(&svm->vcpu, tss_selector, int_vec, reason,
+			       has_error_code, error_code) != EMULATE_USER_EXIT;
 }
 
 static int cpuid_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c6ba452296e3..a80613a5921f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5073,21 +5073,13 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 		       type != INTR_TYPE_NMI_INTR))
 		skip_emulated_instruction(vcpu);
 
-	if (kvm_task_switch(vcpu, tss_selector,
-			    type == INTR_TYPE_SOFT_INTR ? idt_index : -1, reason,
-			    has_error_code, error_code) == EMULATE_FAIL) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
-		return 0;
-	}
-
 	/*
 	 * TODO: What about debug traps on tss switch?
 	 *       Are we supposed to inject them and update dr6?
 	 */
-
-	return 1;
+	return kvm_task_switch(vcpu, tss_selector,
+			       type == INTR_TYPE_SOFT_INTR ? idt_index : -1,
+			       reason, has_error_code, error_code) != EMULATE_USER_EXIT;
 }
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a886ec6957d..83b3c7e9fce7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8587,9 +8587,12 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 
 	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
 				   has_error_code, error_code);
-
-	if (ret)
-		return EMULATE_FAIL;
+	if (ret) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+		return EMULATE_USER_EXIT;
+	}
 
 	kvm_rip_write(vcpu, ctxt->eip);
 	kvm_set_rflags(vcpu, ctxt->eflags);
-- 
2.22.0

