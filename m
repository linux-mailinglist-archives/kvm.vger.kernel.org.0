Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5B396F81
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhFAIvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:51:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:45201 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhFAIue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:50:34 -0400
IronPort-SDR: NYtbMDpcOyvDufvxG7c8oMU9aQzJG2GctxYKaVnzJAjJjeQzmNwj/VtDY56bUX1mzT8R5W0w8z
 TsLmjVbzFQWQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381454"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381454"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:30 -0700
IronPort-SDR: W+lflgdUTzZQ1CrjmgkWekOe5ht+j3gWgQhJLKHZsdhcdgXJkzZwg6LwI2wNzLfCED2smKBz5D
 d6AyXJ+mURdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967829"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:27 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 11/15] kvm/vmx: Implement vmx_compute_tertiary_exec_control()
Date:   Tue,  1 Jun 2021 16:47:50 +0800
Message-Id: <1622537274-146420-12-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like vmx_compute_secondary_exec_control(), before L1 set VMCS, compute its
tertiary control capability MSR's value according to guest CPUID setting.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44c9f16..5b46d7b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4523,6 +4523,22 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
 #define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
 	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
 
+static void vmx_compute_tertiary_exec_control(struct vcpu_vmx *vmx)
+{
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
+}
+
 static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 {
 	struct kvm_vcpu *vcpu = &vmx->vcpu;
@@ -4622,8 +4638,10 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		secondary_exec_controls_set(vmx, vmx->secondary_exec_control);
 	}
 
-	if (cpu_has_tertiary_exec_ctrls())
-		tertiary_exec_controls_set(vmx, vmcs_config.cpu_based_3rd_exec_ctrl);
+	if (cpu_has_tertiary_exec_ctrls()) {
+		vmx_compute_tertiary_exec_control(vmx);
+		tertiary_exec_controls_set(vmx, vmx->tertiary_exec_control);
+	}
 
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
 		vmcs_write64(EOI_EXIT_BITMAP0, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e0ade10..d2eecb8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -258,6 +258,7 @@ struct vcpu_vmx {
 	u32		      msr_ia32_umwait_control;
 
 	u32 secondary_exec_control;
+	u64 tertiary_exec_control;
 
 	/*
 	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
-- 
1.8.3.1

