Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F429107AAD
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKVWkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:61220 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbfKVWkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029637"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] KVM: x86: Explicitly pass an exception struct to check_intercept
Date:   Fri, 22 Nov 2019 14:39:48 -0800
Message-Id: <20191122223959.13545-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly pass an exception struct when checking for intercept from
the emulator, which elimates the last reference to arch.emulate_ctxt
in vendor specific code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/svm.c              | 3 ++-
 arch/x86/kvm/vmx/vmx.c          | 8 ++++----
 arch/x86/kvm/x86.c              | 3 ++-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6aa4075..dec643f4ac78 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1139,7 +1139,8 @@ struct kvm_x86_ops {
 
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
-			       enum x86_intercept_stage stage);
+			       enum x86_intercept_stage stage,
+			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 	bool (*mpx_supported)(void);
 	bool (*xsaves_supported)(void);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 362e874297e4..bc57bd01c7b3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6074,7 +6074,8 @@ static const struct __x86_intercept {
 
 static int svm_check_intercept(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
-			       enum x86_intercept_stage stage)
+			       enum x86_intercept_stage stage,
+			       struct x86_exception *exception)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int vmexit, ret = X86EMUL_CONTINUE;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d39475e2d44e..a192a3da5fc2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7152,10 +7152,10 @@ static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
 
 static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
-			       enum x86_intercept_stage stage)
+			       enum x86_intercept_stage stage,
+			       struct x86_exception *exception)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 
 	/*
 	 * RDPID causes #UD if disabled through secondary execution controls.
@@ -7163,8 +7163,8 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	 */
 	if (info->intercept == x86_intercept_rdtscp &&
 	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
-		ctxt->exception.vector = UD_VECTOR;
-		ctxt->exception.error_code_valid = false;
+		exception->vector = UD_VECTOR;
+		exception->error_code_valid = false;
 		return X86EMUL_PROPAGATE_FAULT;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b4af6be255c..c3992ed1568a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6195,7 +6195,8 @@ static int emulator_intercept(struct x86_emulate_ctxt *ctxt,
 			      struct x86_instruction_info *info,
 			      enum x86_intercept_stage stage)
 {
-	return kvm_x86_ops->check_intercept(emul_to_vcpu(ctxt), info, stage);
+	return kvm_x86_ops->check_intercept(emul_to_vcpu(ctxt), info, stage,
+					    &ctxt->exception);
 }
 
 static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
-- 
2.24.0

