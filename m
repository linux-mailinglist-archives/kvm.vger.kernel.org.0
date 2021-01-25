Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA530340A
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbhAZFM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:12:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:22894 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbhAYJRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:17:21 -0500
IronPort-SDR: YTCaMAUxY4k+oL3ZbIr4by0PIN4KBz9eoXJpCv/SOL6t3pCaMaJT8x+N7WeUjdR1T0NGJ1U/Mq
 Xifw6UG5UdRA==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915811"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915811"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:18 -0800
IronPort-SDR: Ch7Z9tUe5CjN5UUCUdZ44gYHUa+DzmsLXDUPGZAVk7EH7soqotHzydoggakX5HWAU7Iin/V9dd
 8pQzompdyGgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223907"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:16 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 08/12] kvm/vmx: Refactor vmx_compute_tertiary_exec_control()
Date:   Mon, 25 Jan 2021 17:06:16 +0800
Message-Id: <1611565580-47718-9-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like vmx_compute_tertiary_exec_control(), before L1 set VMCS, compute its
nested VMX feature control MSR's value according to guest CPUID setting.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f29a91c..cf8ab95 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4377,10 +4377,20 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
 #define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
 	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
 
-static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
+static void vmx_compute_tertiary_exec_control(struct vcpu_vmx *vmx)
 {
-	/* Though currently, no special adjustment. There might be in the future*/
-	return vmcs_config.cpu_based_3rd_exec_ctrl;
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	u32 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
+
+	if (nested) {
+		if (guest_cpuid_has(vcpu, X86_FEATURE_KEYLOCKER))
+			vmx->nested.msrs.tertiary_ctls |=
+				TERTIARY_EXEC_LOADIWKEY_EXITING;
+		else
+			vmx->nested.msrs.tertiary_ctls &=
+				~TERTIARY_EXEC_LOADIWKEY_EXITING;
+	}
+	vmx->tertiary_exec_control = exec_control;
 }
 
 static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
@@ -4493,8 +4503,10 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
 	}
 
-	if (cpu_has_tertiary_exec_ctrls())
-		tertiary_exec_controls_set(vmx, vmx_tertiary_exec_control(vmx));
+	if (cpu_has_tertiary_exec_ctrls()) {
+		vmx_compute_tertiary_exec_control(vmx);
+		tertiary_exec_controls_set(vmx, vmx->tertiary_exec_control);
+	}
 
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
 		vmcs_write64(EOI_EXIT_BITMAP0, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 94f1c27..0915fad 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -209,6 +209,7 @@ struct vcpu_vmx {
 	u32		      msr_ia32_umwait_control;
 
 	u32 secondary_exec_control;
+	u64 tertiary_exec_control;
 
 	/*
 	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
-- 
1.8.3.1

