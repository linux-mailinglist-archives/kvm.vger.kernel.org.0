Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40729A49F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 03:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbfHWBHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 21:07:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:37991 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732752AbfHWBHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 21:07:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 18:07:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="186733514"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Aug 2019 18:07:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 10/13] KVM: x86: Handle emulation failure directly in kvm_task_switch()
Date:   Thu, 22 Aug 2019 18:07:06 -0700
Message-Id: <20190823010709.24879-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823010709.24879-1-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
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
index c8e3bef2d586..d9d88cecaba6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3888,17 +3888,10 @@ static int task_switch_interception(struct vcpu_svm *svm)
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
index 25410c58c758..52d5705ff7dc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5068,21 +5068,13 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
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

