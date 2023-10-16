Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDE07CAF6E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbjJPQdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbjJPQcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:32:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372A7326B;
        Mon, 16 Oct 2023 09:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473248; x=1729009248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o57K4oha6PrcinqAhUp1paLNgeUKARLWsMj4J+uMhQs=;
  b=OFou8M7yMMHlKG8hr+IQiaZTcvSCVlqCeGuxgKJHrJk1bfHxYRGK7mVt
   QSScllHU3EQU2ZPjD1HyXw8SBfknbOy1OVl9HV3NdPFYGO/ou/5Bcen3w
   WafK/TSgPxy5D40hxBoymSJBZmpq/deZH/PJioFASgaZAKVGHLsh/U+1V
   h9D4fffokUa2UF+rx1c6WFBA7l4xF5WJ5NLDeDCMpKtocI0BzTAJUDrhP
   8vkiRKiLzVRul+Jo865Uo5vgoSgULNV8c0P1z8FDzTJi2PCwwVfLvA4vf
   xo+AoPaTagwnvNcOCVtxeJU61280ZpNjsliNqSHp/0sRptK1c1tYgaZwo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922048"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922048"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448305"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448305"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:04 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 092/116] KVM: TDX: Handle TDX PV HLT hypercall
Date:   Mon, 16 Oct 2023 09:14:44 -0700
Message-Id: <2a7c1474785e4697832b9026f2365ed3119f640f.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 9430091fec80..2f8bb0e9394e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -662,7 +662,32 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
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
@@ -1104,6 +1129,17 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
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
@@ -1112,6 +1148,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 	switch (tdvmcall_leaf(vcpu)) {
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return tdx_emulate_hlt(vcpu);
 	default:
 		break;
 	}
@@ -1504,6 +1542,8 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	struct kvm_vcpu *vcpu = apic->vcpu;
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
+	/* See comment in tdx_protected_apic_has_interrupt(). */
+	tdx->buggy_hlt_workaround = 1;
 	/* TDX supports only posted interrupt.  No lapic emulation. */
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 870a0d15e073..4ddcf804c0a4 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -101,6 +101,9 @@ struct vcpu_tdx {
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

