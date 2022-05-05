Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836DE51C78A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384292AbiEES0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383453AbiEESUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:20:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420C95DA6F;
        Thu,  5 May 2022 11:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774576; x=1683310576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dQW6WFHQdnwK7Za9a0thwXd0uTEe0ieRUqRCfR5Ix14=;
  b=Exm/xn/GCxa5GGGmsfetlEnD4GPpYJ7WpQxDFnU0BnsR+8/QkDhvD85D
   i4wdDBtbDW2TOHg3MPoNplkuV94cjx9juwI4YAfjAQooNyxPLqHcE/wc0
   HrMWrpaYhtW5QNNcoZS9ArERXReVNpp4x1gZj/rm2gHN99HL+DbWLJio7
   DGr72LO9OpWPE4PjJ1XFmqxx7/4ws61PsAke0/KYRpGT3mkGjXL8mxe39
   GVOkn2uNDjtRJhyeGo4fMaotVuLtlG/FTWwtpiUVZoFkVgqYoON8igzQf
   XtDTiqUsZPIUGHIDqeJLmIRdskXoDKnF7goO3wVRebhukLVm3BgL7rCCF
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268354869"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="268354869"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083459"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 088/104] KVM: TDX: Add a place holder for handler of TDX hypercalls (TDG.VP.VMCALL)
Date:   Thu,  5 May 2022 11:15:22 -0700
Message-Id: <b92b43b3d961716efab78f700d26648792ceda76.1651774251.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL for short)
for the guest TD to call hypercall to VMM.  When the guest TD issues
TDG.VP.VMCALL, the guest TD exits to VMM with a new exit reason of
TDVMCALL.  The arguments from the guest TD and returned values from the VMM
are passed in the guest registers.  The guest RCX registers indicates which
registers are used.  Define helper functions to access those registers as
ABI.

Define the TDVMCALL exit reason, which is carved out from the VMX exit
reason namespace as the TDVMCALL exit from TDX guest to TDX-SEAM is really
just a VM-Exit.  Add a place holder to handle TDVMCALL exit.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/vmx.h |  4 ++-
 arch/x86/kvm/vmx/tdx.c          | 56 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h          | 13 ++++++++
 3 files changed, 71 insertions(+), 2 deletions(-)

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
index 2f88871b5b86..3c6cf08a2e3c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -98,6 +98,41 @@ static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
 	return kvm_r9_read(vcpu);
 }
 
+#define BUILD_TDVMCALL_ACCESSORS(param, gpr)				\
+static __always_inline							\
+unsigned long tdvmcall_##param##_read(struct kvm_vcpu *vcpu)		\
+{									\
+	return kvm_##gpr##_read(vcpu);					\
+}									\
+static __always_inline void tdvmcall_##param##_write(struct kvm_vcpu *vcpu, \
+						     unsigned long val)	\
+{									\
+	kvm_##gpr##_write(vcpu, val);					\
+}
+BUILD_TDVMCALL_ACCESSORS(a0, r12);
+BUILD_TDVMCALL_ACCESSORS(a1, r13);
+BUILD_TDVMCALL_ACCESSORS(a2, r14);
+BUILD_TDVMCALL_ACCESSORS(a3, r15);
+
+static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
+{
+	return kvm_r10_read(vcpu);
+}
+static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
+{
+	return kvm_r11_read(vcpu);
+}
+static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
+						     long val)
+{
+	kvm_r10_write(vcpu, val);
+}
+static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
+						    unsigned long val)
+{
+	kvm_r11_write(vcpu, val);
+}
+
 static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
 {
 	return tdx->tdvpr.added;
@@ -798,7 +833,8 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_tdx *tdx)
 {
 	guest_enter_irqoff();
-	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs, 0);
+	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs,
+					tdx->tdvmcall.regs_mask);
 	guest_exit_irqoff();
 }
 
@@ -831,6 +867,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_complete_interrupts(vcpu);
 
+	if (tdx->exit_reason.basic == EXIT_REASON_TDCALL)
+		tdx->tdvmcall.rcx = vcpu->arch.regs[VCPU_REGS_RCX];
+	else
+		tdx->tdvmcall.rcx = 0;
+
 	return EXIT_FASTPATH_NONE;
 }
 
@@ -877,6 +918,17 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_tdvmcall(struct kvm_vcpu *vcpu)
+{
+	switch (tdvmcall_leaf(vcpu)) {
+	default:
+		break;
+	}
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	return 1;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
@@ -1274,6 +1326,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_handle_exception(vcpu);
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
 		return tdx_handle_external_interrupt(vcpu);
+	case EXIT_REASON_TDCALL:
+		return handle_tdvmcall(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
 		return tdx_handle_ept_violation(vcpu);
 	case EXIT_REASON_EPT_MISCONFIG:
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 1268a49fdf18..b0bb239b51bf 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -95,6 +95,19 @@ struct vcpu_tdx {
 
 	struct list_head cpu_list;
 
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

