Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA65478FD8
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbhLQPa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:10842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238210AbhLQPaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755008; x=1671291008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UAli8J8lgVIdRC1P6KuS5fK9r8AqDifhErcOIH4VyWU=;
  b=PQRpxPJ5b2IKl791mTuEcNKPsJpKVrfM3D3aD+v6bEP1g46TRZJqOUMS
   3/VDxE2csLBLb3khL/lwF88bZe9srs+Cl1BuRMyK9f1e2+et8dS/Ok5ss
   Uoxx/Vq+KcVW68c/zSA6diz5tSat5HpkeJbOXDnzuCDRgL0pthpVRXQfd
   Eszdhp0edDpV2lWmhPZkM7h+zvJ4fLJzYmHo6v1XDgr29pF4TINXSSla6
   bQKdpFTZfBH0NAHlgZH4fR/D7clUrhYT9ay6BeLMOhVLPvG0OANAKTcQ2
   CLsgljs/XCB5R0uSle7W3nB0l0B1Ur/zTfGg/6OutJ8PsjVYFvo4eF02g
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723455"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723455"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588438"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:05 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 13/23] kvm: x86: Intercept #NM for saving IA32_XFD_ERR
Date:   Fri, 17 Dec 2021 07:29:53 -0800
Message-Id: <20211217153003.1719189-14-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest IA32_XFD_ERR is generally modified in two places:

  - Set by CPU when #NM is triggered;
  - Cleared by guest in its #NM handler;

Intercept #NM for the first case, if guest CPUID includes any dynamic
xfeature. #NM is rare if the guest doesn't use dynamic features.
Otherwise, there is at most one exception per guest task given a
dynamic feature.

Save the current XFD_ERR value to the guest_fpu container in the #NM
VM-exit handler. This must be done with interrupt/preemption disabled,
otherwise the unsaved MSR value may be clobbered by host operations.

Inject a virtual #NM to the guest after saving the MSR value.

Restore the host value (always ZERO outside of the host #NM
handler) before enabling preemption.

Restore the guest value from the guest_fpu container right before
entering the guest (with preemption disabled).

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
TODO: Investigate delaying #NM interception until guest sets a dynamic
feature in XCR0.

 arch/x86/kvm/vmx/vmcs.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c  | 15 ++++++++++++++-
 arch/x86/kvm/x86.c      |  6 ++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 6e5de2e2b0da..c57798b56f95 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -129,6 +129,11 @@ static inline bool is_machine_check(u32 intr_info)
 	return is_exception_n(intr_info, MC_VECTOR);
 }
 
+static inline bool is_nm(u32 intr_info)
+{
+	return is_exception_n(intr_info, NM_VECTOR);
+}
+
 /* Undocumented: icebp/int1 */
 static inline bool is_icebp(u32 intr_info)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9453743ce0c4..483075045253 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -36,6 +36,7 @@
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
+#include <asm/fpu/xstate.h>
 #include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
@@ -763,6 +764,9 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, match);
 	}
 
+	if (vcpu->arch.guest_supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC)
+		eb |= (1u << NM_VECTOR);
+
 	vmcs_write32(EXCEPTION_BITMAP, eb);
 }
 
@@ -4750,7 +4754,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmx_get_intr_info(vcpu);
 
-	if (is_machine_check(intr_info) || is_nmi(intr_info))
+	if (is_machine_check(intr_info) || is_nmi(intr_info) || is_nm(intr_info))
 		return 1; /* handled by handle_exception_nmi_irqoff() */
 
 	if (is_invalid_opcode(intr_info))
@@ -6338,6 +6342,12 @@ static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
 	kvm_after_interrupt(vcpu);
 }
 
+static void handle_exception_nm(struct kvm_vcpu *vcpu)
+{
+	rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
+	kvm_queue_exception(vcpu, NM_VECTOR);
+}
+
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
 	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
@@ -6346,6 +6356,9 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(intr_info))
 		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+	/* if exit due to NM, handle before preemptions are enabled */
+	else if (is_nm(intr_info))
+		handle_exception_nm(&vmx->vcpu);
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a274146ef439..e528085030b3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9894,6 +9894,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
 
+	if (vcpu->arch.guest_fpu.xfd_err)
+		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
+
 	if (unlikely(vcpu->arch.switch_db_regs)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
@@ -9957,6 +9960,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
 
+	if (vcpu->arch.guest_fpu.xfd_err)
+		wrmsrl(MSR_IA32_XFD_ERR, 0);
+
 	/*
 	 * Consume any pending interrupts, including the possible source of
 	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
-- 
2.27.0

