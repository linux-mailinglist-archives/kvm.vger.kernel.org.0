Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DE3163726
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgBRX34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:29:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:38638 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbgBRX3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:29:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936645"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/13] KVM: x86: Explicitly pass an exception struct to check_intercept
Date:   Tue, 18 Feb 2020 15:29:42 -0800
Message-Id: <20200218232953.5724-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly pass an exception struct when checking for intercept from
the emulator, which eliminates the last reference to arch.emulate_ctxt
in vendor specific code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/svm.c              | 3 ++-
 arch/x86/kvm/vmx/vmx.c          | 8 ++++----
 arch/x86/kvm/x86.c              | 3 ++-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4dffbc10d3f8..c750cd957558 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1160,7 +1160,8 @@ struct kvm_x86_ops {
 
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
-			       enum x86_intercept_stage stage);
+			       enum x86_intercept_stage stage,
+			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion *exit_fastpath);
 	bool (*mpx_supported)(void);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a3e32d61d60c..ae62ea454158 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6180,7 +6180,8 @@ static const struct __x86_intercept {
 
 static int svm_check_intercept(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
-			       enum x86_intercept_stage stage)
+			       enum x86_intercept_stage stage,
+			       struct x86_exception *exception)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int vmexit, ret = X86EMUL_CONTINUE;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a6664886f2e..09bb0d98afeb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7100,10 +7100,10 @@ static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
 
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
@@ -7111,8 +7111,8 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
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
index 6554abef631f..409bf35f26fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6267,7 +6267,8 @@ static int emulator_intercept(struct x86_emulate_ctxt *ctxt,
 			      struct x86_instruction_info *info,
 			      enum x86_intercept_stage stage)
 {
-	return kvm_x86_ops->check_intercept(emul_to_vcpu(ctxt), info, stage);
+	return kvm_x86_ops->check_intercept(emul_to_vcpu(ctxt), info, stage,
+					    &ctxt->exception);
 }
 
 static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
-- 
2.24.1

