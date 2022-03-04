Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40EC4CDDA6
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiCDUAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372FF240DC6;
        Fri,  4 Mar 2022 11:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423444; x=1677959444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5mlRGTr+vsYtDPxh4+8Jw49QEBaDh2DnfdsVQyhr+Ig=;
  b=hfXPXMmopQqdQWBEcLPj9zlwtTADp1mUgZoRd+GtnaW65f30MQlL2vB7
   6uXHKHAyTvWBA4/zgEBCdO5QC9BJYm1oPlp3ABBGkFYMzLTWHs9E3B/uk
   OEg9YMWzvefaQ4JwUeIkk8FwNVBjgPStQwZ47+dDW/h09TE8WbMm+nlND
   sj9GNEIloNW4LXhlekVL4TMQDEljMUCXOY5t+06sAYaYAVs85kvPmFJab
   j0WZDV72QxfvGhMJ0EhCcYyzFf1kGCMuUb6vKs1VcmYt3yzquvvopIbq/
   p9B7TO8IYKr3NLaoT5UjQBmi2WefvGyaGART+k0eEKucWpAVUGiwbJFzi
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779648"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779648"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:42 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344543"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:42 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 089/104] KVM: TDX: Add a placeholder for handler of TDX hypercalls (TDG.VP.VMCALL)
Date:   Fri,  4 Mar 2022 11:49:45 -0800
Message-Id: <b84fcd9927e49716de913b0fe910018788aaba46.1646422845.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL for short)
for the guest TD to call hypercall to VMM.  When the guest TD issues
TDG.VP.VMCALL, the guest TD exits to VMM with a new exit reason of
TDVMCALL.  The arguments from the guest TD and returned values from the VMM
are passed in the guest registers.  The guest RCX registers indicates which
registers are used.

Define the TDVMCALL exit reason, which is carved out from the VMX exit
reason namespace as the TDVMCALL exit from TDX guest to TDX-SEAM is really
just a VM-Exit.  Add a place holder to handle TDVMCALL exit.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/vmx.h |  4 +++-
 arch/x86/kvm/vmx/tdx.c          | 27 ++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h          | 13 +++++++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 3d9b4598e166..cb0a0565219a 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -92,6 +92,7 @@
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
 #define EXIT_REASON_BUS_LOCK            74
+#define EXIT_REASON_TDCALL              77
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -154,7 +155,8 @@
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
-	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }
+	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
+	{ EXIT_REASON_TDCALL,                "TDCALL" }
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8695836ce796..86daafd9eec0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -780,7 +780,8 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_tdx *tdx)
 {
 	guest_enter_irqoff();
-	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs, 0);
+	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs,
+					tdx->tdvmcall.regs_mask);
 	guest_exit_irqoff();
 }
 
@@ -815,6 +816,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (tdx->exit_reason.error || tdx->exit_reason.non_recoverable)
 		return EXIT_FASTPATH_NONE;
+
+	if (tdx->exit_reason.basic == EXIT_REASON_TDCALL)
+		tdx->tdvmcall.rcx = vcpu->arch.regs[VCPU_REGS_RCX];
+	else
+		tdx->tdvmcall.rcx = 0;
 	return EXIT_FASTPATH_NONE;
 }
 
@@ -859,6 +865,23 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_tdvmcall(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (unlikely(tdx->tdvmcall.xmm_mask))
+		goto unsupported;
+
+	switch (tdvmcall_exit_reason(vcpu)) {
+	default:
+		break;
+	}
+
+unsupported:
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	return 1;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
@@ -1187,6 +1210,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_handle_exception(vcpu);
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
 		return tdx_handle_external_interrupt(vcpu);
+	case EXIT_REASON_TDCALL:
+		return handle_tdvmcall(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
 		return tdx_handle_ept_violation(vcpu);
 	case EXIT_REASON_EPT_MISCONFIG:
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 7cd81780f3fa..9e8ed9b3119e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -86,6 +86,19 @@ struct vcpu_tdx {
 	/* Posted interrupt descriptor */
 	struct pi_desc pi_desc;
 
+	union {
+		struct {
+			union {
+				struct {
+					u16 gpr_mask;
+					u16 xmm_mask;
+				};
+				u32 regs_mask;
+			};
+			u32 reserved;
+		};
+		u64 rcx;
+	} tdvmcall;
 	union tdx_exit_reason exit_reason;
 
 	bool initialized;
-- 
2.25.1

