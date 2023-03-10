Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536B36B3FCB
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 13:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCJM5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 07:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCJM5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 07:57:35 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A7A7D57E
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 04:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678453054; x=1709989054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=33oblRFP71mt89S4XReeIGfRr7aH/WPUyLlvpq3sCvU=;
  b=XcBvXR5Hv3j74Mu/bxsBLkRR6uUYWw9EZ1HqSmN2HLN6vSuJCmU2ppEg
   MdUFt3JYPtBqT2VS0FfxheyktdJ83aunXEcpGfAJ8yyTxNRVujIOAf+sM
   NIxR50eVXYiUoEBUouwVF94Mw+uwSaLjXw3gDShIaJk4XyGKSxlP4zBFE
   iSdUx7Ma5P0CImbDkPs9naze5bQqXfA0HR06POAO/BzJvrR1dWD36/NrT
   IBS0/Qwyi9e3/7mqjurCX1Jx0/a+OtKB0KBZRIOMLcupawUjcl5184K9E
   EveL7J3TbLV8c1h5Qd6/tn1tJeftOwCJP6sKoWE95dm5NNPiAslt4aSkv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="336739892"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="336739892"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 04:57:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="801573457"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="801573457"
Received: from sqa-gate.sh.intel.com (HELO zhihaihu-desk.tsp.org) ([10.239.48.212])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 04:57:32 -0800
From:   Robert Hoo <robert.hu@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     robert.hoo.linux@gmail.com
Subject: [PATCH 1/3] KVM: VMX: Rename vmx_umip_emulated() to cpu_has_vmx_desc()
Date:   Fri, 10 Mar 2023 20:57:16 +0800
Message-Id: <20230310125718.1442088-2-robert.hu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230310125718.1442088-1-robert.hu@intel.com>
References: <20230310125718.1442088-1-robert.hu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just rename, no functional changes intended.

vmx_umip_emulated() comes from the ancient time when there was a
kvm_x86_ops::umip_emulated(), which originally simply returned false.
(66336cab3531d "KVM: x86: add support for emulating UMIP"). Afterwards, its
body changed and moved from vmx.c to the dedicated capabilities.h, but
kept its old name which looks weired among cpu_has_vmx_XXX() group.

Rename it to align with other analogous functions, the new name is more
accurate for what it does. And, vmcs_config.cpu_based_2nd_exec_ctrl &
SECONDARY_EXEC_DESC just means it has the capability of emulating UMIP,
not *umip-being-emulated*, e.g. if host has caps of UMIP, it's actually not
emulated. On the other hand, UMIP concerned instructions are just subset
of those SECONDARY_EXEC_DESC intercepts [1][2].

[1] SDM. Vol.3 Table 25-7. Definitions of Secondary Processor-Based VM-Execution Controls
SECONDARY_EXEC_DESC "determines whether executions of LGDT, LIDT, LLDT,
LTR, SGDT, SIDT, SLDT, and STR cause VM exits."

[2] SDM. Vol.3 2.5 Control Registers
CR4.UMIP is about SGDT, SIDT, SLDT, SMSW, and STR.

Signed-off-by: Robert Hoo <robert.hu@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  2 +-
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 45162c1bcd8f..afa116063acd 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -150,7 +150,7 @@ static inline bool cpu_has_vmx_ept(void)
 		SECONDARY_EXEC_ENABLE_EPT;
 }
 
-static inline bool vmx_umip_emulated(void)
+static inline bool cpu_has_vmx_desc(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
 		SECONDARY_EXEC_DESC;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7c4f5ca405c7..6804b4fcf2b9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2322,7 +2322,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		 * Preset *DT exiting when emulating UMIP, so that vmx_set_cr4()
 		 * will not have to rewrite the controls just for this bit.
 		 */
-		if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated() &&
+		if (!boot_cpu_has(X86_FEATURE_UMIP) && cpu_has_vmx_desc() &&
 		    (vmcs12->guest_cr4 & X86_CR4_UMIP))
 			exec_control |= SECONDARY_EXEC_DESC;
 
@@ -6984,7 +6984,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 	rdmsrl(MSR_IA32_VMX_CR0_FIXED1, msrs->cr0_fixed1);
 	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, msrs->cr4_fixed1);
 
-	if (vmx_umip_emulated())
+	if (cpu_has_vmx_desc())
 		msrs->cr4_fixed1 |= X86_CR4_UMIP;
 
 	msrs->vmcs_enum = nested_vmx_calc_vmcs_enum_msr();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcac3efcde41..96f7c9f37afd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3431,7 +3431,13 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	else
 		hw_cr4 |= KVM_PMODE_VM_CR4_ALWAYS_ON;
 
-	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
+	/*
+	 * Emulate UMIP via enable secondary_exec_control.DESC
+	 * It can get here means it has passed valid_cr4() check, i.e.
+	 * guest been exposed with UMIP feature, i.e. either host has cap
+	 * of UMIP or vmx_set_cpu_caps() set it because of cpu_has_vmx_desc()
+	 */
+	if (!boot_cpu_has(X86_FEATURE_UMIP) && cpu_has_vmx_desc()) {
 		if (cr4 & X86_CR4_UMIP) {
 			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 			hw_cr4 &= ~X86_CR4_UMIP;
@@ -7820,7 +7826,7 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_SGX2);
 	}
 
-	if (vmx_umip_emulated())
+	if (cpu_has_vmx_desc())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-- 
2.31.1

