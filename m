Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A841566933
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 10:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfGLIcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 04:32:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:9319 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfGLIcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 04:32:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 01:32:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="317928831"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga004.jf.intel.com with ESMTP; 12 Jul 2019 01:32:01 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com, tao3.xu@intel.com
Subject: [PATCH v7 3/3] KVM: vmx: handle vm-exit for UMWAIT and TPAUSE
Date:   Fri, 12 Jul 2019 16:29:07 +0800
Message-Id: <20190712082907.29137-4-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190712082907.29137-1-tao3.xu@intel.com>
References: <20190712082907.29137-1-tao3.xu@intel.com>
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

This patch is to handle the vm-exit for UMWAIT and TPAUSE as this
should never happen.

Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---

Changes in v7:
    - Add nested exit reason for UMWAIT and TPAUSE (Paolo)
---
 arch/x86/include/uapi/asm/vmx.h |  6 +++++-
 arch/x86/kvm/vmx/nested.c       |  3 +++
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

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
index a4d5da34b306..9f91f834ec43 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5213,6 +5213,9 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_ENCLS:
 		/* SGX is never exposed to L1 */
 		return false;
+	case EXIT_REASON_UMWAIT: case EXIT_REASON_TPAUSE:
+		return nested_cpu_has2(vmcs12,
+			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0787f140d155..e026b1313dc3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5349,6 +5349,20 @@ static int handle_monitor(struct kvm_vcpu *vcpu)
 	return handle_nop(vcpu);
 }
 
+static int handle_umwait(struct kvm_vcpu *vcpu)
+{
+	kvm_skip_emulated_instruction(vcpu);
+	WARN(1, "this should never happen\n");
+	return 1;
+}
+
+static int handle_tpause(struct kvm_vcpu *vcpu)
+{
+	kvm_skip_emulated_instruction(vcpu);
+	WARN(1, "this should never happen\n");
+	return 1;
+}
+
 static int handle_invpcid(struct kvm_vcpu *vcpu)
 {
 	u32 vmx_instruction_info;
@@ -5559,6 +5573,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
+	[EXIT_REASON_UMWAIT]                  = handle_umwait,
+	[EXIT_REASON_TPAUSE]                  = handle_tpause,
 };
 
 static const int kvm_vmx_max_exit_handlers =
-- 
2.20.1

