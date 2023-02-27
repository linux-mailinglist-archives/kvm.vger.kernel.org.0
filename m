Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4A66A3D20
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjB0Iba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjB0I3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:29:45 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4AC1CAD6;
        Mon, 27 Feb 2023 00:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486375; x=1709022375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MwS5q3Mu/hl9ne31Qt+848iYLVrjE88ultEAyvMyIB0=;
  b=jGILGuXujSFHwxcdeA1pP8Isc4XMgkRJmL9xsjR+/2bVw4/ukVxGmmXp
   +j7yfEiC4hkTyEsqerspkYgkw8msQFm9W297dO1MjJZpLzuc11m8o2lRd
   der7QmUs/LhuZ/DW4sN/ZZcPphAaYu916EPUYlP7HVSzIWMGFLko729bN
   oHJNsiMU5xn1qVYelUpZ4VP1Ml/f9vjZ9bVjsUFxM4sCaUFBp1vgG/i/8
   gp1zKVDAcSI9pdh+jCDCzdTHKDKqOyV4t6fg2qMifvz/YRKhSigFbWMCG
   HMkz/RikB9nurKLpPx70DQQ+vF1aHdSoOJNrBqWmktfdtOhA83/CTAuHc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609045"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609045"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242387"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242387"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:18 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 085/106] KVM: TDX: Handle TDX PV HLT hypercall
Date:   Mon, 27 Feb 2023 00:23:24 -0800
Message-Id: <fdcd211cd380ae1a7cb3b3bd600a674e2d7db628.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV HLT hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h |  3 +++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5add38cfd9f9..a5bfb82c620f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -628,7 +628,32 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_has_pending_interrupt(vcpu);
+	bool ret = pi_has_pending_interrupt(vcpu);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
+		return true;
+
+	if (tdx->interrupt_disabled_hlt)
+		return false;
+
+	/*
+	 * This is for the case where the virtual interrupt is recognized,
+	 * i.e. set in vmcs.RVI, between the STI and "HLT".  KVM doesn't have
+	 * access to RVI and the interrupt is no longer in the PID (because it
+	 * was "recognized".  It doesn't get delivered in the guest because the
+	 * TDCALL completes before interrupts are enabled.
+	 *
+	 * TDX modules sets RVI while in an STI interrupt shadow.
+	 * - TDExit(typically TDG.VP.VMCALL<HLT>) from the guest to TDX module.
+	 *   The interrupt shadow at this point is gone.
+	 * - It knows that there is an interrupt that can be delivered
+	 *   (RVI > PPR && EFLAGS.IF=1, the other conditions of 29.2.2 don't
+	 *    matter)
+	 * - It forwards the TDExit nevertheless, to a clueless hypervisor that
+	 *   has no way to glean either RVI or PPR.
+	 */
+	return !!xchg(&tdx->buggy_hlt_workaround, 0);
 }
 
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -987,6 +1012,17 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	/* See tdx_protected_apic_has_interrupt() to avoid heavy seamcall */
+	tdx->interrupt_disabled_hlt = tdvmcall_a0_read(vcpu);
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+	return kvm_emulate_halt_noskip(vcpu);
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -995,6 +1031,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 	switch (tdvmcall_leaf(vcpu)) {
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return tdx_emulate_hlt(vcpu);
 	default:
 		break;
 	}
@@ -1328,6 +1366,8 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	struct kvm_vcpu *vcpu = apic->vcpu;
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
+	/* See comment in tdx_protected_apic_has_interrupt(). */
+	tdx->buggy_hlt_workaround = 1;
 	/* TDX supports only posted interrupt.  No lapic emulation. */
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index fa44a1a9295f..71818c500186 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -93,6 +93,9 @@ struct vcpu_tdx {
 	bool host_state_need_restore;
 	u64 msr_host_kernel_gs_base;
 
+	bool interrupt_disabled_hlt;
+	unsigned int buggy_hlt_workaround;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
-- 
2.25.1

