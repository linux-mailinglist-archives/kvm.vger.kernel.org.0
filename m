Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F4F61EE86
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 10:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiKGJQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 04:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiKGJQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 04:16:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D8E1707B;
        Mon,  7 Nov 2022 01:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667812570; x=1699348570;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4g54fovxN/9L+XvgL/metcK6kKTJLbBqfrqSz8Mliew=;
  b=FlWsOlBebcuvjxAzkg8XdVHx4ZMRQad/2duY7tkFIIwwi0Iitv8j7if0
   b/0mTkoVJXsqgx9zdfuWby+jcd73KRg8P2SMNRilOvnuY81FONlFtkIWG
   +d8XFU4eVMr2tXwmO6eiV4+thOL/cCt60h5iv0BmRt1o8pAl/Mldh82fm
   mnQzJztK092JSNpxTB+c0KYdfHt8HfNqedTzCeXPrCCvi9j0UW0VtNC9T
   VcvCp9qYfmnYIJvBt8Tm4FFfQQFxeQcgjd5FrO0AVBkMd7gGb5bm9YrnS
   IskMdad+Cg4F5VddCqjToIKyS0UWr1Xv1q8inT6G7cn96rgIDTyP0/dZy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="337083259"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="337083259"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 01:16:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="741416530"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="741416530"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by fmsmga002.fm.intel.com with ESMTP; 07 Nov 2022 01:16:09 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
Date:   Mon,  7 Nov 2022 16:27:27 +0800
Message-Id: <20221107082727.1355797-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMFUNC is not supported for L1 guests, and executing VMFUNC in
L1 shall generate a #UD directly. Just disable it in secondary
proc-based execution control for L1, instead of intercepting it
and inject the #UD again.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 17 +++++------------
 arch/x86/kvm/vmx/vmx.c    |  4 +++-
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c62352dda6a..8858c6c0979f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5793,11 +5793,11 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	u32 function = kvm_rax_read(vcpu);
 
 	/*
-	 * VMFUNC is only supported for nested guests, but we always enable the
-	 * secondary control for simplicity; for non-nested mode, fake that we
-	 * didn't by injecting #UD.
+	 * VMFUNC is only supported for nested guests, instead of triggering
+	 * a VM Exit, non-nested guests shall receive #UD directly.
 	 */
 	if (!is_guest_mode(vcpu)) {
+		vcpu_unimpl(vcpu, "vmx: unexpected vm exit EXIT_REASON_VMFUNC.\n");
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
@@ -6808,6 +6808,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 		SECONDARY_EXEC_RDRAND_EXITING |
 		SECONDARY_EXEC_ENABLE_INVPCID |
+		SECONDARY_EXEC_ENABLE_VMFUNC |
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES |
 		SECONDARY_EXEC_TSC_SCALING;
@@ -6839,16 +6840,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 				SECONDARY_EXEC_ENABLE_PML;
 			msrs->ept_caps |= VMX_EPT_AD_BIT;
 		}
-	}
 
-	if (cpu_has_vmx_vmfunc()) {
-		msrs->secondary_ctls_high |=
-			SECONDARY_EXEC_ENABLE_VMFUNC;
-		/*
-		 * Advertise EPTP switching unconditionally
-		 * since we emulate it
-		 */
-		if (enable_ept)
+		if (cpu_has_vmx_vmfunc())
 			msrs->vmfunc_controls =
 				VMX_VMFUNC_EPTP_SWITCHING;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 65f092e4a81b..9e17de62eb37 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4483,6 +4483,9 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 	exec_control &= ~SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
 
+	/* VMFUNC is not supported for L1 guest, just disable it. */
+	exec_control &= ~SECONDARY_EXEC_ENABLE_VMFUNC;
+
 	/* SECONDARY_EXEC_DESC is enabled/disabled on writes to CR4.UMIP,
 	 * in vmx_set_cr4.  */
 	exec_control &= ~SECONDARY_EXEC_DESC;
@@ -6000,7 +6003,6 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_RDSEED]                  = kvm_handle_invalid_op,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
-	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
-- 
2.17.1

