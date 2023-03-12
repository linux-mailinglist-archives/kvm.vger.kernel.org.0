Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A96B6488
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCLJ7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCLJ6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2FB2A9A7
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615068; x=1710151068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mYSf9kIDblRRvhB2/ecZ9cFKmFT8e1o420/fFtNfVEc=;
  b=CNt6h11z9tis7b+9n4MoAXDC8EioKXx/g/ZhJeP2gS0F72rW8H3jWOsG
   EFah3W2Nok6/cyDeBNIoT8ILUbVNduLozBOeWa/ksOoLjIuSbeqoCZJN0
   b8mulPfEboA9uBVJ+LRi5b/AF8iX3OW8Yge4Gz7cUIFjm96LrIyVHF6bq
   cSb51/7fXA2MZLlNC4E4D0qgwWHG/OPSi+voK8t+SHlmNmuYbTYJwF9+c
   URTC+T36JGu7rccWAuxbRe+9MLyZsMMfHy7jc9zzYcumPLK0/jKVZ22sP
   wJtWbcZRcPbMs+8ePuaORbFUdivfY5qnU/SmTfOut3nvsufUnlPO37HhX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998114"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998114"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677706"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677706"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:20 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 10/22] pkvm: x86: Add has_vmcs_field() API for physical vmx capability check
Date:   Mon, 13 Mar 2023 02:02:51 +0800
Message-Id: <20230312180303.1778492-11-jason.cj.chen@intel.com>
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

From: Tina Zhang <tina.zhang@intel.com>

Some fields in vmcs exist only on processors that support the 1-setting
of those fields in the control registers [1]. VMREAD/VMWRITE from/to
unsupported VMCS component leads to VMfailValid [2].

Introduce a function called has_vmcs_field() which can be used to check
if a field exists in vmcs before using VMREAD/VMWRITE to access the field.

[1]: SDM: Appendix B Field Encoding in VMCS, NOTES.
[2]: SDM: VMX Instruction Reference chapter, VMWRITE/VMREAD.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/nested.c | 115 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c  |  29 ++++++++
 2 files changed, 144 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index f5e2eb8f51c8..31ad33f2cdbf 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -8,6 +8,121 @@
 #include "pkvm_hyp.h"
 #include "debug.h"
 
+/**
+ * According to SDM Appendix B Field Encoding in VMCS, some fields only
+ * exist on processor that support the 1-setting of the corresponding
+ * fields in the control regs.
+ */
+static bool has_vmcs_field(u16 encoding)
+{
+	struct nested_vmx_msrs *msrs = &pkvm_hyp->vmcs_config.nested;
+
+	switch (encoding) {
+	case MSR_BITMAP:
+		return msrs->procbased_ctls_high & CPU_BASED_USE_MSR_BITMAPS;
+	case VIRTUAL_APIC_PAGE_ADDR:
+	case VIRTUAL_APIC_PAGE_ADDR_HIGH:
+	case TPR_THRESHOLD:
+		return msrs->procbased_ctls_high & CPU_BASED_TPR_SHADOW;
+	case SECONDARY_VM_EXEC_CONTROL:
+		return msrs->procbased_ctls_high &
+			CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+
+	case VIRTUAL_PROCESSOR_ID:
+		return msrs->secondary_ctls_high & SECONDARY_EXEC_ENABLE_VPID;
+	case XSS_EXIT_BITMAP:
+		return msrs->secondary_ctls_high & SECONDARY_EXEC_XSAVES;
+	case PML_ADDRESS:
+		return msrs->secondary_ctls_high & SECONDARY_EXEC_ENABLE_PML;
+	case VM_FUNCTION_CONTROL:
+		return msrs->secondary_ctls_high & SECONDARY_EXEC_ENABLE_VMFUNC;
+	case EPT_POINTER:
+		return msrs->secondary_ctls_high & SECONDARY_EXEC_ENABLE_EPT;
+	case EOI_EXIT_BITMAP0:
+	case EOI_EXIT_BITMAP1:
+	case EOI_EXIT_BITMAP2:
+	case EOI_EXIT_BITMAP3:
+		return msrs->secondary_ctls_high &
+			SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
+	case VMREAD_BITMAP:
+	case VMWRITE_BITMAP:
+		return msrs->secondary_ctls_high & SECONDARY_EXEC_SHADOW_VMCS;
+	case ENCLS_EXITING_BITMAP:
+		return msrs->secondary_ctls_high &
+			SECONDARY_EXEC_ENCLS_EXITING;
+	case GUEST_INTR_STATUS:
+		return msrs->secondary_ctls_high &
+			SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
+	case GUEST_PML_INDEX:
+		return msrs->secondary_ctls_high & SECONDARY_EXEC_ENABLE_PML;
+	case APIC_ACCESS_ADDR:
+	case APIC_ACCESS_ADDR_HIGH:
+		return msrs->secondary_ctls_high &
+			SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+	case TSC_MULTIPLIER:
+	case TSC_MULTIPLIER_HIGH:
+		return msrs->secondary_ctls_high &
+			SECONDARY_EXEC_TSC_SCALING;
+	case GUEST_PHYSICAL_ADDRESS:
+	case GUEST_PHYSICAL_ADDRESS_HIGH:
+		return msrs->secondary_ctls_high &
+			SECONDARY_EXEC_ENABLE_EPT;
+	case GUEST_PDPTR0:
+	case GUEST_PDPTR0_HIGH:
+	case GUEST_PDPTR1:
+	case GUEST_PDPTR1_HIGH:
+	case GUEST_PDPTR2:
+	case GUEST_PDPTR2_HIGH:
+	case GUEST_PDPTR3:
+	case GUEST_PDPTR3_HIGH:
+		return msrs->secondary_ctls_high & SECONDARY_EXEC_ENABLE_EPT;
+	case PLE_GAP:
+	case PLE_WINDOW:
+		return msrs->secondary_ctls_high &
+			SECONDARY_EXEC_PAUSE_LOOP_EXITING;
+
+	case VMX_PREEMPTION_TIMER_VALUE:
+		return msrs->pinbased_ctls_high &
+			PIN_BASED_VMX_PREEMPTION_TIMER;
+	case POSTED_INTR_DESC_ADDR:
+		return msrs->pinbased_ctls_high & PIN_BASED_POSTED_INTR;
+	case POSTED_INTR_NV:
+		return msrs->pinbased_ctls_high & PIN_BASED_POSTED_INTR;
+	case GUEST_IA32_PAT:
+	case GUEST_IA32_PAT_HIGH:
+		return (msrs->entry_ctls_high & VM_ENTRY_LOAD_IA32_PAT) ||
+			(msrs->exit_ctls_high & VM_EXIT_SAVE_IA32_PAT);
+	case GUEST_IA32_EFER:
+	case GUEST_IA32_EFER_HIGH:
+		return (msrs->entry_ctls_high & VM_ENTRY_LOAD_IA32_EFER) ||
+			(msrs->exit_ctls_high & VM_EXIT_SAVE_IA32_EFER);
+	case GUEST_IA32_PERF_GLOBAL_CTRL:
+	case GUEST_IA32_PERF_GLOBAL_CTRL_HIGH:
+		return msrs->entry_ctls_high & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+	case GUEST_BNDCFGS:
+	case GUEST_BNDCFGS_HIGH:
+		return (msrs->entry_ctls_high & VM_ENTRY_LOAD_BNDCFGS) ||
+			(msrs->exit_ctls_high & VM_EXIT_CLEAR_BNDCFGS);
+	case GUEST_IA32_RTIT_CTL:
+	case GUEST_IA32_RTIT_CTL_HIGH:
+		return (msrs->entry_ctls_high & VM_ENTRY_LOAD_IA32_RTIT_CTL) ||
+			(msrs->exit_ctls_high & VM_EXIT_CLEAR_IA32_RTIT_CTL);
+	case HOST_IA32_PAT:
+	case HOST_IA32_PAT_HIGH:
+		return msrs->exit_ctls_high & VM_EXIT_LOAD_IA32_PAT;
+	case HOST_IA32_EFER:
+	case HOST_IA32_EFER_HIGH:
+		return msrs->exit_ctls_high & VM_EXIT_LOAD_IA32_EFER;
+	case HOST_IA32_PERF_GLOBAL_CTRL:
+	case HOST_IA32_PERF_GLOBAL_CTRL_HIGH:
+		return msrs->exit_ctls_high & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+	case EPTP_LIST_ADDRESS:
+		return msrs->vmfunc_controls & VMX_VMFUNC_EPTP_SWITCHING;
+	default:
+		return true;
+	}
+}
+
 enum VMXResult {
 	VMsucceed,
 	VMfailValid,
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 2dff1123b61f..4ea82a147af5 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -426,6 +426,33 @@ static __init void pkvm_host_deinit_vmx(struct pkvm_host_vcpu *vcpu)
 		vmx->vmcs01.msr_bitmap = NULL;
 }
 
+static __init void pkvm_host_setup_nested_vmx_cap(struct pkvm_hyp *pkvm)
+{
+	struct nested_vmx_msrs *msrs = &pkvm->vmcs_config.nested;
+
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
+		msrs->procbased_ctls_low,
+		msrs->procbased_ctls_high);
+
+	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2,
+			&msrs->secondary_ctls_low,
+			&msrs->secondary_ctls_high);
+
+	rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
+		msrs->pinbased_ctls_low,
+		msrs->pinbased_ctls_high);
+
+	rdmsrl_safe(MSR_IA32_VMX_VMFUNC, &msrs->vmfunc_controls);
+
+	rdmsr(MSR_IA32_VMX_EXIT_CTLS,
+		msrs->exit_ctls_low,
+		msrs->exit_ctls_high);
+
+	rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
+		msrs->entry_ctls_low,
+		msrs->entry_ctls_high);
+}
+
 static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
 {
 	struct vmcs_config *vmcs_config = &pkvm->vmcs_config;
@@ -476,6 +503,8 @@ static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
 		pr_info("vmentry_ctrl 0x%x\n", vmcs_config->vmentry_ctrl);
 	}
 
+	pkvm_host_setup_nested_vmx_cap(pkvm);
+
 	return ret;
 }
 
-- 
2.25.1

