Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E19861287E
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiJ3GdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiJ3Gb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:31:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB79EBA1;
        Sat, 29 Oct 2022 23:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111102; x=1698647102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lZQmYrPEne6WmQc9Y8A1VT3t9Z2cJUiBqGjv5f3sfJ0=;
  b=HFGATXAz++sfFqUDRk/CDZX/u2jcQujqqaKg0otLdiS2yGknvlpTnBfM
   GLDD8sSnD2FnIZNwe70i9D0zOu7taD7ITp+GjQnb1/zva2XuGDOV2ZKJK
   TqEhk6WH7WDNxBRMXtsVJRHxhx7hjj0Wx83ULsWwnBpjD/VKjX+u8JFv8
   Bfb7Yskl5DvTd1wNt2eHBitrtVvJk9uSUCnyr4Y61IztAYGM2civ6YX8r
   Awxh1a5MUWoQXPRKkwE2Fqek85vRIqDJHjdv70MAP6iO4lv0wjsWAttrX
   rQwwTqiM7re9AfcE9El7GxxqPtlBUaK2xra4kIy500Kcl+nFX8278MjSz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037213"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037213"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:13 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393146"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393146"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 095/108] KVM: TDX: Handle TDX PV HLT hypercall
Date:   Sat, 29 Oct 2022 23:23:36 -0700
Message-Id: <9125a3e35d0bfe933bcec5b41a19943d88cdaefd.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 4b83d7a81433..03b08b3f1ff6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -528,7 +528,32 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
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
@@ -830,6 +855,17 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
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
@@ -838,6 +874,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 	switch (tdvmcall_leaf(vcpu)) {
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return tdx_emulate_hlt(vcpu);
 	default:
 		break;
 	}
@@ -1166,6 +1204,8 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	struct kvm_vcpu *vcpu = apic->vcpu;
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
+	/* See comment in tdx_protected_apic_has_interrupt(). */
+	tdx->buggy_hlt_workaround = 1;
 	/* TDX supports only posted interrupt.  No lapic emulation. */
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index eac341e08c9a..685184aa10e9 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -99,6 +99,9 @@ struct vcpu_tdx {
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

