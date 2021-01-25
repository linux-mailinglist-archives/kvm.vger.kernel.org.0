Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E57303405
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbhAZFMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:12:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:22891 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbhAYJPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:15:23 -0500
IronPort-SDR: UyNWly9re0az8Ul8RXe62eCmlYfhF547aehk9sSh7c384t/HHA9OvwHD3Txn08IqxGIoYB3XJb
 /s7NLZp1VDVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915785"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915785"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:09 -0800
IronPort-SDR: vYnEoaErLNtYQ4Yk5C0Ok6pLMsNBzs2vZ5iD/LkQiJaeO3AXDiiTnH5V5vrFsEkX3vedX54oxu
 ZQ6f0deVQFNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223856"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:07 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 04/12] kvm/vmx: enable LOADIWKEY vm-exit support in tertiary processor-based VM-execution controls
Date:   Mon, 25 Jan 2021 17:06:12 +0800
Message-Id: <1611565580-47718-5-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

But don't implement 'loadiwkey' vm-exit handler in this patch, it will be
done in next one.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/vmx.h         |  6 ++++++
 arch/x86/include/asm/vmxfeatures.h |  3 +++
 arch/x86/include/uapi/asm/vmx.h    |  5 ++++-
 arch/x86/kvm/vmx/vmx.c             | 27 +++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 1517692..2fe69e9 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -75,6 +75,12 @@
 #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
 
+/*
+ * Definitions of Tertiary Processor-Based VM-Execution Controls.
+ */
+#define TERTIARY_EXEC_LOADIWKEY_EXITING         VMCS_CONTROL_BIT(LOADIWKEY_EXITING)
+
+
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
 #define PIN_BASED_VIRTUAL_NMIS                  VMCS_CONTROL_BIT(VIRTUAL_NMIS)
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 75a15c2..1d11575 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -85,4 +85,7 @@
 #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
 #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
 
+/* Tertiary Processor-Based VM-Execution Controls, word 3 */
+#define VMX_FEATURE_LOADIWKEY_EXITING	(3*32 +  0) /* "" VM-Exit on LOADIWKey */
+
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index b8ff9e8..9c04550 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -88,6 +88,7 @@
 #define EXIT_REASON_XRSTORS             64
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
+#define EXIT_REASON_LOADIWKEY           69
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -148,7 +149,9 @@
 	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
-	{ EXIT_REASON_TPAUSE,                "TPAUSE" }
+	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
+	{ EXIT_REASON_LOADIWKEY,             "LOADIWKEY" }
+
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 12a926e..d01bbb4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2368,6 +2368,23 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	return 0;
 }
 
+static __init int adjust_vmx_controls_64(u64 ctl_min, u64 ctl_opt,
+					  u32 msr, u64 *result)
+{
+	u64 vmx_msr;
+	u64 ctl = ctl_min | ctl_opt;
+
+	rdmsrl(msr, vmx_msr);
+	ctl &= vmx_msr; /* bit == 1 means it can be set */
+
+	/* Ensure minimum (required) set of control bits are supported. */
+	if (ctl_min & ~ctl)
+		return -EIO;
+
+	*result = ctl;
+	return 0;
+}
+
 static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				    struct vmx_capability *vmx_cap)
 {
@@ -2472,6 +2489,16 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				"1-setting enable VPID VM-execution control\n");
 	}
 
+	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
+		u64 opt3 = TERTIARY_EXEC_LOADIWKEY_EXITING;
+		u64 min3 = 0;
+
+		if (adjust_vmx_controls_64(min3, opt3,
+					   MSR_IA32_VMX_PROCBASED_CTLS3,
+					   &_cpu_based_3rd_exec_control))
+			return -EIO;
+	}
+
 	min = VM_EXIT_SAVE_DEBUG_CONTROLS | VM_EXIT_ACK_INTR_ON_EXIT;
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
-- 
1.8.3.1

