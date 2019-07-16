Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CFF6A286
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 08:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbfGPG6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 02:58:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:51761 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730400AbfGPG6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 02:58:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 23:58:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="366116070"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jul 2019 23:58:45 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com, tao3.xu@intel.com
Subject: [PATCH v8 3/3] KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit
Date:   Tue, 16 Jul 2019 14:55:51 +0800
Message-Id: <20190716065551.27264-4-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190716065551.27264-1-tao3.xu@intel.com>
References: <20190716065551.27264-1-tao3.xu@intel.com>
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

Because KVM never enable RDTSC exiting, the vm-exit for UMWAIT and TPAUSE
should never happen. Considering EXIT_REASON_XSAVES and
EXIT_REASON_XRSTORS is also unexpected VM-exit for KVM. Introduce a common
exit helper handle_unexpected_vmexit() to handle these unexpected VM-exit.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---

Changes in v8:
    - Introduce a common exit helper handle_unexpected_vmexit (Sean)
---
 arch/x86/include/uapi/asm/vmx.h |  6 +++++-
 arch/x86/kvm/vmx/nested.c       |  4 ++++
 arch/x86/kvm/vmx/vmx.c          | 28 ++++++++++++----------------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index d213ec5c3766..d88d7a68849b 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -85,6 +85,8 @@
 #define EXIT_REASON_PML_FULL            62
 #define EXIT_REASON_XSAVES              63
 #define EXIT_REASON_XRSTORS             64
+#define EXIT_REASON_UMWAIT              67
+#define EXIT_REASON_TPAUSE              68
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -142,7 +144,9 @@
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
index a4d5da34b306..12a162a2d798 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5213,6 +5213,10 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
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
index 0224b087aad3..db5bdc468f70 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4967,20 +4967,6 @@ static int handle_xsetbv(struct kvm_vcpu *vcpu)
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
@@ -5499,6 +5485,14 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
+{
+	kvm_skip_emulated_instruction(vcpu);
+	WARN_ONCE(1, "Unexpected VM-Exit Reason = 0x%x",
+		vmcs_read32(VM_EXIT_REASON));
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5550,13 +5544,15 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
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
-- 
2.20.1

