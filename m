Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511836B6499
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCLKAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCLJ72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBDD366A4
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615108; x=1710151108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=trQNqUH2Gsm2ctWbPbJJYwLaezy8afpY6uEsUv8/m7I=;
  b=kFk80t2RqQdJ/tRFyhGp2zC2C/hZMzDXiSBPO6WBgwPAf8egS1jRFSrB
   cL/9vVYtttHxkn8m2H9EzOSCMy4qYsXbtzooTJoA2wsABmuilaDnxqWwL
   9Hp7Tw3d0HjvaVTcPTrUwItL/v0HT8P+TQDet4q61p3HrbTD747JHA+RI
   I3gnMAlPDQ1fKrDIF8WDAQaqH1Oz73petJMNUzAkoVIl1Il0T0QuirFZp
   /ff+dlVyPxkOPp4OEYbn2A+Dfp28c9Cw5QKa9S1RX74NI1Dke+8Z+3lw+
   MRn/kGW23kiOvh8Da26RR+nn+TkJcHS2RoLsk0fzptPAEhWeBUJtiokNV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998136"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998136"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677809"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677809"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:34 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-5 22/22] pkvm: x86: Add vmx msr emulation
Date:   Mon, 13 Mar 2023 02:03:03 +0800
Message-Id: <20230312180303.1778492-23-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host VM see VMX capability, but with reduced features. pKVM need to
provide such vmx msrs emulation to tell supported VMX capabilities to
the host VM.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/nested.c            | 65 +++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h            |  8 +++
 .../vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h    |  2 +-
 arch/x86/kvm/vmx/pkvm/hyp/vmsr.c              | 25 +++++--
 4 files changed, 94 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 73fa66ba95bd..429bfe7bb309 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -6,9 +6,71 @@
 #include <pkvm.h>
 
 #include "pkvm_hyp.h"
+#include "nested.h"
+#include "cpu.h"
 #include "vmx.h"
 #include "debug.h"
 
+/*
+ * Not support shadow vmcs & vmfunc;
+ * Not support descriptor-table exiting
+ * as it requires guest memory access
+ * to decode and emulate instructions
+ * which is not supported for protected VM.
+ */
+#define NESTED_UNSUPPORTED_2NDEXEC 		\
+	(SECONDARY_EXEC_SHADOW_VMCS | 		\
+	 SECONDARY_EXEC_ENABLE_VMFUNC | 	\
+	 SECONDARY_EXEC_DESC)
+
+static const unsigned int vmx_msrs[] = {
+	LIST_OF_VMX_MSRS
+};
+
+bool is_vmx_msr(unsigned long msr)
+{
+	bool found = false;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vmx_msrs); i++) {
+		if (msr == vmx_msrs[i]) {
+			found = true;
+			break;
+		}
+	}
+
+	return found;
+}
+
+int read_vmx_msr(struct kvm_vcpu *vcpu, unsigned long msr, u64 *val)
+{
+	u32 low, high;
+	int err = 0;
+
+	pkvm_rdmsr(msr, low, high);
+
+	switch (msr) {
+	case MSR_IA32_VMX_PROCBASED_CTLS2:
+		high &= ~NESTED_UNSUPPORTED_2NDEXEC;
+		break;
+	case MSR_IA32_VMX_MISC:
+		/* not support PT, SMM */
+		low &= ~(MSR_IA32_VMX_MISC_INTEL_PT | BIT(28));
+		break;
+	case MSR_IA32_VMX_VMFUNC:
+		/* not support vmfunc */
+		low = high = 0;
+		break;
+	default:
+		err = -EACCES;
+		break;
+	}
+
+	*val = (u64)high << 32 | (u64)low;
+
+	return err;
+}
+
 /**
  * According to SDM Appendix B Field Encoding in VMCS, some fields only
  * exist on processor that support the 1-setting of the corresponding
@@ -492,6 +554,9 @@ static u64 emulate_field_for_vmcs02(struct vcpu_vmx *vmx, u16 field, u64 virt_va
 		/* host always in 64bit mode */
 		val |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
 		break;
+	case SECONDARY_VM_EXEC_CONTROL:
+		val &= ~NESTED_UNSUPPORTED_2NDEXEC;
+		break;
 	}
 	return val;
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.h b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
index 3f785be165c2..24cf731e96dd 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
@@ -16,4 +16,12 @@ int handle_vmlaunch(struct kvm_vcpu *vcpu);
 int nested_vmexit(struct kvm_vcpu *vcpu);
 void pkvm_init_nest(void);
 
+#define LIST_OF_VMX_MSRS        		\
+	MSR_IA32_VMX_MISC,                      \
+	MSR_IA32_VMX_PROCBASED_CTLS2,           \
+	MSR_IA32_VMX_VMFUNC
+
+bool is_vmx_msr(unsigned long msr);
+int read_vmx_msr(struct kvm_vcpu *vcpu, unsigned long msr, u64 *val);
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
index 8666cda4ee6d..7b0f1d73d76c 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
@@ -28,6 +28,7 @@ EMULATED_FIELD_RW(VIRTUAL_PROCESSOR_ID, virtual_processor_id)
 /* 32-bits */
 EMULATED_FIELD_RW(VM_EXIT_CONTROLS, vm_exit_controls)
 EMULATED_FIELD_RW(VM_ENTRY_CONTROLS, vm_entry_controls)
+EMULATED_FIELD_RW(SECONDARY_VM_EXEC_CONTROL, secondary_vm_exec_control)
 
 /* 64-bits, what about their HIGH 32 fields?  */
 EMULATED_FIELD_RW(IO_BITMAP_A, io_bitmap_a)
@@ -77,7 +78,6 @@ SHADOW_FIELD_RW(GUEST_PML_INDEX, guest_pml_index)
 /* 32-bits */
 SHADOW_FIELD_RW(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control)
 SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control)
-SHADOW_FIELD_RW(SECONDARY_VM_EXEC_CONTROL, secondary_vm_exec_control)
 SHADOW_FIELD_RW(EXCEPTION_BITMAP, exception_bitmap)
 SHADOW_FIELD_RW(PAGE_FAULT_ERROR_CODE_MASK, page_fault_error_code_mask)
 SHADOW_FIELD_RW(PAGE_FAULT_ERROR_CODE_MATCH, page_fault_error_code_match)
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmsr.c b/arch/x86/kvm/vmx/pkvm/hyp/vmsr.c
index 360b0333b84f..ec7476debf25 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmsr.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmsr.c
@@ -5,6 +5,7 @@
 
 #include <pkvm.h>
 #include "cpu.h"
+#include "nested.h"
 #include "debug.h"
 
 #define INTERCEPT_DISABLE		(0U)
@@ -13,7 +14,7 @@
 #define INTERCEPT_READ_WRITE		(INTERCEPT_READ | INTERCEPT_WRITE)
 
 static unsigned int emulated_ro_guest_msrs[] = {
-	/* DUMMY */
+	LIST_OF_VMX_MSRS,
 };
 
 static void enable_msr_interception(u8 *bitmap, unsigned int msr_arg, unsigned int mode)
@@ -50,11 +51,25 @@ static void enable_msr_interception(u8 *bitmap, unsigned int msr_arg, unsigned i
 
 int handle_read_msr(struct kvm_vcpu *vcpu)
 {
-	/* simply return 0 for non-supported MSRs */
-	vcpu->arch.regs[VCPU_REGS_RAX] = 0;
-	vcpu->arch.regs[VCPU_REGS_RDX] = 0;
+	unsigned long msr = vcpu->arch.regs[VCPU_REGS_RCX];
+	int ret = 0;
+	u32 low = 0, high = 0;
+	u64 val;
 
-	return 0;
+	/* For non-supported MSRs, return low=high=0 by default */
+	if (is_vmx_msr(msr)) {
+		ret = read_vmx_msr(vcpu, msr, &val);
+		if (!ret) {
+			low = (u32)val;
+			high = (u32)(val >> 32);
+		}
+	}
+	pkvm_dbg("%s: CPU%d Value of msr 0x%lx: low=0x%x, high=0x%x\n", __func__, vcpu->cpu, msr, low, high);
+
+	vcpu->arch.regs[VCPU_REGS_RAX] = low;
+	vcpu->arch.regs[VCPU_REGS_RDX] = high;
+
+	return ret;
 }
 
 int handle_write_msr(struct kvm_vcpu *vcpu)
-- 
2.25.1

