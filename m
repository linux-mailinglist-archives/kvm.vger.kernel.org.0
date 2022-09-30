Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C42B5F08F3
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbiI3KZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiI3KXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:23:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35485B853;
        Fri, 30 Sep 2022 03:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533180; x=1696069180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yjeOmKxSHXyQaROUSIDgVbHM093jimLkUc7a+n1Knms=;
  b=ijXM0/WJKnoFOvt7i874MEPpXdYkM5MUBdV6lsOSaXnEHbOOURtUb7zS
   GThEdVG9TBmUDQyVHgnyH/rCgiYZgnfezyswue8znCVQSRYOJbe/6W63O
   OCUgMUb9eGrywZZ8Kv3jwHjTre0x+jfeBnpW1kdF/oMAbiYXf/RGCTBbL
   asTfoi5Z3l3y6ow8le+Pbw2J4WydARJu7mtDK3v5sVVH8F5ShCzbAe/za
   yex8rD4H7yJELchsk2gVMoXOy67iD946/LfVGDWui1uqJHzO2hoNMNAmS
   vqh2hHyxsH2CA4uvlwGb5nGy02N+RbbMhdL8sDSJhddU09LoffrBQgaV2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328540170"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328540170"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807804"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807804"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 092/105] KVM: TDX: Handle TDX PV HLT hypercall
Date:   Fri, 30 Sep 2022 03:18:26 -0700
Message-Id: <1a481884ea0b0bf832c7d01977706692052245b4.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 16bee3b38bf4..73dba86f9341 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -520,7 +520,32 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
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
@@ -822,6 +847,17 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
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
@@ -830,6 +866,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 	switch (tdvmcall_leaf(vcpu)) {
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return tdx_emulate_hlt(vcpu);
 	default:
 		break;
 	}
@@ -1135,6 +1173,8 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	struct kvm_vcpu *vcpu = apic->vcpu;
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
+	/* See comment in tdx_protected_apic_has_interrupt(). */
+	tdx->buggy_hlt_workaround = 1;
 	/* TDX supports only posted interrupt.  No lapic emulation. */
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ce2f49e15243..e79bdf01ad3e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -113,6 +113,9 @@ struct vcpu_tdx {
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

