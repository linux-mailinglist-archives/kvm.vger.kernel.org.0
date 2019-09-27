Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD84C003E
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 09:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfI0HqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 03:46:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:59042 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfI0HqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 03:46:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 00:46:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,554,1559545200"; 
   d="scan'208";a="201935622"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.159.36])
  by orsmga002.jf.intel.com with ESMTP; 27 Sep 2019 00:46:19 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     kvm@vger.kernel.org, liran.alon@oracle.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     Tao Xu <tao3.xu@intel.com>, Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v9] KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit
Date:   Fri, 27 Sep 2019 15:46:16 +0800
Message-Id: <20190927074616.31092-1-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the latest Intel 64 and IA-32 Architectures Software Developer's
Manual, UMWAIT and TPAUSE instructions cause a VM exit if the
RDTSC exiting and enable user wait and pause VM-execution
controls are both 1.

Because KVM never enable RDTSC exiting, the vm-exit for UMWAIT and
TPAUSE should never happen. Considering EXIT_REASON_XSAVES and
EXIT_REASON_XRSTORS is also unexpected VM-exit for KVM. Reuse the code
of 'commit 7396d337cfad ("KVM: x86: Return to userspace with internal
error on unexpected exit reason"), and introduce a common exit helper
handle_unexpected_vmexit() to handle these unexpected VM-exit.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---
 arch/x86/include/uapi/asm/vmx.h |  6 +++-
 arch/x86/kvm/vmx/nested.c       |  4 +++
 arch/x86/kvm/vmx/vmx.c          | 51 ++++++++++++++++-----------------
 3 files changed, 33 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index f01950aa7fae..3eb8411ab60e 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -86,6 +86,8 @@
 #define EXIT_REASON_PML_FULL            62
 #define EXIT_REASON_XSAVES              63
 #define EXIT_REASON_XRSTORS             64
+#define EXIT_REASON_UMWAIT              67
+#define EXIT_REASON_TPAUSE              68
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -144,7 +146,9 @@
 	{ EXIT_REASON_RDSEED,                "RDSEED" }, \
 	{ EXIT_REASON_PML_FULL,              "PML_FULL" }, \
 	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
-	{ EXIT_REASON_XRSTORS,               "XRSTORS" }
+	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
+	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
+	{ EXIT_REASON_TPAUSE,                "TPAUSE" }
 
 #define VMX_ABORT_SAVE_GUEST_MSR_FAIL        1
 #define VMX_ABORT_LOAD_HOST_PDPTE_FAIL       2
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4a57134a8aee..41abc62c9a8a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5479,6 +5479,10 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_ENCLS:
 		/* SGX is never exposed to L1 */
 		return false;
+	case EXIT_REASON_UMWAIT:
+	case EXIT_REASON_TPAUSE:
+		return nested_cpu_has2(vmcs12,
+			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3567478a0472..f1a5d32111af 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5045,20 +5045,6 @@ static int handle_xsetbv(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_xsaves(struct kvm_vcpu *vcpu)
-{
-	kvm_skip_emulated_instruction(vcpu);
-	WARN(1, "this should never happen\n");
-	return 1;
-}
-
-static int handle_xrstors(struct kvm_vcpu *vcpu)
-{
-	kvm_skip_emulated_instruction(vcpu);
-	WARN(1, "this should never happen\n");
-	return 1;
-}
-
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
 	if (likely(fasteoi)) {
@@ -5552,6 +5538,24 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
+			vmx->exit_reason);
+	dump_vmcs();
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror =
+		KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 1;
+	vcpu->run->internal.data[0] = vmx->exit_reason;
+	kvm_skip_emulated_instruction(vcpu);
+	WARN_ONCE(1, "Unexpected VM-Exit Reason = 0x%x",
+		vmcs_read32(VM_EXIT_REASON));
+	return 0;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5603,13 +5607,15 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
 	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
 	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
-	[EXIT_REASON_XSAVES]                  = handle_xsaves,
-	[EXIT_REASON_XRSTORS]                 = handle_xrstors,
+	[EXIT_REASON_XSAVES]                  = handle_unexpected_vmexit,
+	[EXIT_REASON_XRSTORS]                 = handle_unexpected_vmexit,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
+	[EXIT_REASON_UMWAIT]                  = handle_unexpected_vmexit,
+	[EXIT_REASON_TPAUSE]                  = handle_unexpected_vmexit,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -5946,17 +5952,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
-	else {
-		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
-				exit_reason);
-		dump_vmcs();
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 1;
-		vcpu->run->internal.data[0] = exit_reason;
-		return 0;
-	}
+	else
+		return handle_unexpected_vmexit(vcpu);
 }
 
 /*
-- 
2.20.1

