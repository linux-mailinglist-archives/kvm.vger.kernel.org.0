Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BEC396F6F
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhFAIuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:50:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:45164 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233182AbhFAIt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:49:58 -0400
IronPort-SDR: wBaon7NPHhrrvu6F3UZ8GvxttPkWt1sCRlYvpu/yCfvBBeZZkfWJU5T5ZWfXKfSxDsMX5WXJRO
 qBlhCf2WFZrA==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381353"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381353"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:15 -0700
IronPort-SDR: CP44KpMcMxtiTFQ+YGit0IDawMBPvayVTbQ78XltNVn8mmIPhxZTUvxUi5I2dsTgAmheGyTfS6
 g2xGdt8aRxng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967791"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:12 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 06/15] kvm/vmx: Set Tertiary VM-Execution control field When init vCPU's VMCS
Date:   Tue,  1 Jun 2021 16:47:45 +0800
Message-Id: <1622537274-146420-7-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define the new 64bit VMCS field, as well as its auxiliary set function.
In init_vmcs(), set this field to the value previously configured.
But in vmx_exec_control(), at this moment, returning
vmcs_config.primary_exec_control with tertiary-exec artifially disabled,
as till now no real feature on it is enabled. This will be removed later in
Key Locker enablement patch.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/vmx.h | 2 ++
 arch/x86/kvm/vmx/vmcs.h    | 1 +
 arch/x86/kvm/vmx/vmx.c     | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c035649..dc549e3 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -222,6 +222,8 @@ enum vmcs_field {
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
 	TSC_MULTIPLIER                  = 0x00002032,
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
+	TERTIARY_VM_EXEC_CONTROL        = 0x00002034,
+	TERTIARY_VM_EXEC_CONTROL_HIGH   = 0x00002035,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 1472c6c..343c329 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -48,6 +48,7 @@ struct vmcs_controls_shadow {
 	u32 pin;
 	u32 exec;
 	u32 secondary_exec;
+	u64 tertiary_exec;
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 554e572..56a56f5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4255,6 +4255,9 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
 				CPU_BASED_MONITOR_EXITING);
 	if (kvm_hlt_in_guest(vmx->vcpu.kvm))
 		exec_control &= ~CPU_BASED_HLT_EXITING;
+
+	/* Disable Tertiary-Exec Control at this moment, as no feature used yet */
+	exec_control &= ~CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	return exec_control;
 }
 
@@ -4413,6 +4416,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
 	}
 
+	if (cpu_has_tertiary_exec_ctrls())
+		tertiary_exec_controls_set(vmx, vmcs_config.cpu_based_3rd_exec_ctrl);
+
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
 		vmcs_write64(EOI_EXIT_BITMAP0, 0);
 		vmcs_write64(EOI_EXIT_BITMAP1, 0);
-- 
1.8.3.1

