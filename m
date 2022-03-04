Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995AF4CDD8A
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiCDT7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAA8240DCF;
        Fri,  4 Mar 2022 11:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423445; x=1677959445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+nGQVrBe96XTUjrDdPql+9GcVxyKPhvOW6aWfhm10vM=;
  b=JIOYX9fBvqLcVEI9SkR95tYsDp0MPMUlICNvS/WyPgWv/AypE2v8sEa3
   tLUH9ezx4Hr2hQ8Vyz7pHzgEgyCXej7nV2y7o8Ozy7Mql1phbXBKoAAMl
   EF4dIShw7m/8nE6tggKToX7cWegmTlSDI53Xx78sruNIaGYej9eRFu/8v
   OuhkUHGNT0vFaB/ZUF4XGbdaWJLp+AjZSpxu3+oW51Eq6yajsxKQVGfka
   NdLpEE/cxY05glAcytZLDJxHHFEK4NVl/3lfj55dtGvgMWLHzrDkOXgyE
   lyL+eCAysbwt7Hmt/O2+8V71U2fcasCG62cbshHVUUaLorlScHD9h85BK
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779655"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779655"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:44 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344562"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:44 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Date:   Fri,  4 Mar 2022 11:49:48 -0800
Message-Id: <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV HLT hypercall to the KVM backend function.

When the guest issues HLT, the hypercall instruction can be the right after
CLI instruction.  Atomically unmask virtual interrupt and issue HLT
hypercall. The virtual interrupts can arrive right after CLI instruction
before switching back to VMM.  In such a case, the VMM should return to the
guest without losing the interrupt.  Check if interrupts arrived before the
TDX module switching to VMM.  And return to the guest in such cases.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 45 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f7c9170d596a..b0dcc2421649 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -917,6 +917,48 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
+{
+	bool interrupt_disabled = tdvmcall_p1_read(vcpu);
+	union tdx_vcpu_state_details details;
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+
+	if (!interrupt_disabled) {
+		/*
+		 * Virtual interrupt can arrive after TDG.VM.VMCALL<HLT> during
+		 * the TDX module executing.  On the other hand, KVM doesn't
+		 * know if vcpu was executing in the guest TD or the TDX module.
+		 *
+		 * CPU mode transition:
+		 * TDG.VP.VMCALL<HLT> (SEAM VMX non-root mode) ->
+		 * the TDX module (SEAM VMX root mode) ->
+		 * KVM (Legacy VMX root mode)
+		 *
+		 * If virtual interrupt arrives to this vcpu
+		 * - In the guest TD executing:
+		 *   KVM can handle it in the same way to the VMX case.
+		 * - During the TDX module executing:
+		 *   The TDX modules switches to KVM with TDG.VM.VMCALL<HLT>
+		 *   exit reason.  KVM thinks the guest was running.  So KVM
+		 *   vcpu wake up logic doesn't kick in.  Check if virtual
+		 *   interrupt is pending and resume vcpu without blocking vcpu.
+		 * - KVM executing:
+		 *   The existing logic wakes up the target vcpu on injecting
+		 *   virtual interrupt in the same way to the VMX case.
+		 *
+		 * Check if the interrupt is already pending.  If yes, resume
+		 * vcpu from guest HLT without emulating hlt instruction.
+		 */
+		details.full = td_state_non_arch_read64(
+			to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);
+		if (details.vmxip)
+			return 1;
+	}
+
+	return kvm_emulate_halt_noskip(vcpu);
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -930,7 +972,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 	switch (tdvmcall_exit_reason(vcpu)) {
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
-
+	case EXIT_REASON_HLT:
+		return tdx_emulate_hlt(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

