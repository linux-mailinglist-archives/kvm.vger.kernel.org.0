Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A490A673D2E
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 16:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjASPK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 10:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjASPKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 10:10:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C64A6DB3D;
        Thu, 19 Jan 2023 07:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674141050; x=1705677050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L7iHmUNW9JP/1fUrsU1qz6/t8KvG5NQvNDZLIvQ9EXo=;
  b=i1GK/uM8WFE0LtwiDbrcZ77HnQLXXMNjglKR4sM6jm7TdoVDx5H12WGt
   0G5vah2KVCpu08nVJMAHYF4eyTe3AcubKlqkALlCcH9PtQP0X8ZpSSobB
   taoaKZOAXqz8qgASR7bVqys1/pUSlsFU4ruNaW44XGb/Pmu7Li2gqdHgm
   fkeNnP5+qVmPdk+2dPFnRY/SLlPKEqFHi7U+hBfFENNXB66LSG3kcCGY9
   LZ6KqAxcKJc7Mhsp9JQLOEh8rIFRDX/0b3fgajjQWDquXufJScjD3Fi7J
   ci+kRLov5Zr00w46QG1LtImsDMvTgS5JnjiedfNiVIv2Y7hx8CJA/Bc/q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="325350486"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="325350486"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 07:10:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="610093354"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="610093354"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga003.jf.intel.com with ESMTP; 19 Jan 2023 07:10:47 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: nVMX: Add helpers to setup VMX control msr configs
Date:   Thu, 19 Jan 2023 22:19:46 +0800
Message-Id: <20230119141946.585610-2-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119141946.585610-1-yu.c.zhang@linux.intel.com>
References: <20230119141946.585610-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_vmx_setup_ctls_msrs() is used to set up the various VMX MSR
controls for nested VMX. But it is a bit lengthy, just add helpers
to setup the configuration of VMX MSRs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 129 +++++++++++++++++++++++++-------------
 1 file changed, 85 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 81dfbffae575..98ed7631e810 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6750,36 +6750,9 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
 	return (u64)max_idx << VMCS_FIELD_INDEX_SHIFT;
 }
 
-/*
- * nested_vmx_setup_ctls_msrs() sets up variables containing the values to be
- * returned for the various VMX controls MSRs when nested VMX is enabled.
- * The same values should also be used to verify that vmcs12 control fields are
- * valid during nested entry from L1 to L2.
- * Each of these control msrs has a low and high 32-bit half: A low bit is on
- * if the corresponding bit in the (32-bit) control field *must* be on, and a
- * bit in the high half is on if the corresponding bit in the control field
- * may be on. See also vmx_control_verify().
- */
-void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
+static inline void nested_vmx_setup_pinbased_ctls(struct vmcs_config *vmcs_conf,
+						  struct nested_vmx_msrs *msrs)
 {
-	struct nested_vmx_msrs *msrs = &vmcs_conf->nested;
-
-	/*
-	 * Note that as a general rule, the high half of the MSRs (bits in
-	 * the control fields which may be 1) should be initialized by the
-	 * intersection of the underlying hardware's MSR (i.e., features which
-	 * can be supported) and the list of features we want to expose -
-	 * because they are known to be properly supported in our code.
-	 * Also, usually, the low half of the MSRs (bits which must be 1) can
-	 * be set to 0, meaning that L1 may turn off any of these bits. The
-	 * reason is that if one of these bits is necessary, it will appear
-	 * in vmcs01 and prepare_vmcs02, when it bitwise-or's the control
-	 * fields of vmcs01 and vmcs02, will turn these bits off - and
-	 * nested_vmx_l1_wants_exit() will not pass related exits to L1.
-	 * These rules have exceptions below.
-	 */
-
-	/* pin-based controls */
 	msrs->pinbased_ctls_low =
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 
@@ -6792,8 +6765,11 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 	msrs->pinbased_ctls_high |=
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
 		PIN_BASED_VMX_PREEMPTION_TIMER;
+}
 
-	/* exit controls */
+static inline void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
+					      struct nested_vmx_msrs *msrs)
+{
 	msrs->exit_ctls_low =
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
 
@@ -6812,8 +6788,11 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 
 	/* We support free control of debug control saving. */
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
+}
 
-	/* entry controls */
+static inline void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
+					       struct nested_vmx_msrs *msrs)
+{
 	msrs->entry_ctls_low =
 		VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
 
@@ -6829,8 +6808,11 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 
 	/* We support free control of debug control loading. */
 	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
+}
 
-	/* cpu-based controls */
+static inline void nested_vmx_setup_cpubased_ctls(struct vmcs_config *vmcs_conf,
+						  struct nested_vmx_msrs *msrs)
+{
 	msrs->procbased_ctls_low =
 		CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
 
@@ -6862,7 +6844,12 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 	/* We support free control of CR3 access interception. */
 	msrs->procbased_ctls_low &=
 		~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);
+}
 
+static inline void nested_vmx_setup_secondary_ctls(u32 ept_caps,
+				struct vmcs_config *vmcs_conf,
+				struct nested_vmx_msrs *msrs)
+{
 	msrs->secondary_ctls_low = 0;
 
 	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
@@ -6944,8 +6931,11 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 
 	if (enable_sgx)
 		msrs->secondary_ctls_high |= SECONDARY_EXEC_ENCLS_EXITING;
+}
 
-	/* miscellaneous data */
+static inline void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
+					      struct nested_vmx_msrs *msrs)
+{
 	msrs->misc_low = (u32)vmcs_conf->misc & VMX_MISC_SAVE_EFER_LMA;
 	msrs->misc_low |=
 		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
@@ -6953,13 +6943,16 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		VMX_MISC_ACTIVITY_HLT |
 		VMX_MISC_ACTIVITY_WAIT_SIPI;
 	msrs->misc_high = 0;
+}
 
-	/*
-	 * This MSR reports some information about VMX support. We
-	 * should return information about the VMX we emulate for the
-	 * guest, and the VMCS structure we give it - not about the
-	 * VMX support of the underlying hardware.
-	 */
+/*
+ * VMX basic MSR reports some information about VMX support. We should
+ * return information about the VMX we emulate for the guest, and the
+ * VMCS structure we give it - not about the VMX support of the underlying
+ * hardware.
+ */
+static inline void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
+{
 	msrs->basic =
 		VMCS12_REVISION |
 		VMX_BASIC_TRUE_CTLS |
@@ -6968,12 +6961,15 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
+}
 
-	/*
-	 * These MSRs specify bits which the guest must keep fixed on
-	 * while L1 is in VMXON mode (in L1's root mode, or running an L2).
-	 * We picked the standard core2 setting.
-	 */
+/*
+ * cr0_fixed & cr4_fixed MSRs specify bits which the guest must keep fixed
+ * on while L1 is in VMXON mode (in L1's root mode, or running an L2).
+ * We picked the standard core2 setting.
+ */
+static inline void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
+{
 #define VMXON_CR0_ALWAYSON     (X86_CR0_PE | X86_CR0_PG | X86_CR0_NE)
 #define VMXON_CR4_ALWAYSON     X86_CR4_VMXE
 	msrs->cr0_fixed0 = VMXON_CR0_ALWAYSON;
@@ -6985,6 +6981,51 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 
 	if (vmx_umip_emulated())
 		msrs->cr4_fixed1 |= X86_CR4_UMIP;
+}
+
+/*
+ * nested_vmx_setup_ctls_msrs() sets up variables containing the values to be
+ * returned for the various VMX controls MSRs when nested VMX is enabled.
+ * The same values should also be used to verify that vmcs12 control fields are
+ * valid during nested entry from L1 to L2.
+ * Each of these control msrs has a low and high 32-bit half: A low bit is on
+ * if the corresponding bit in the (32-bit) control field *must* be on, and a
+ * bit in the high half is on if the corresponding bit in the control field
+ * may be on. See also vmx_control_verify().
+ */
+void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
+{
+	struct nested_vmx_msrs *msrs = &vmcs_conf->nested;
+
+	/*
+	 * Note that as a general rule, the high half of the MSRs (bits in
+	 * the control fields which may be 1) should be initialized by the
+	 * intersection of the underlying hardware's MSR (i.e., features which
+	 * can be supported) and the list of features we want to expose -
+	 * because they are known to be properly supported in our code.
+	 * Also, usually, the low half of the MSRs (bits which must be 1) can
+	 * be set to 0, meaning that L1 may turn off any of these bits. The
+	 * reason is that if one of these bits is necessary, it will appear
+	 * in vmcs01 and prepare_vmcs02, when it bitwise-or's the control
+	 * fields of vmcs01 and vmcs02, will turn these bits off - and
+	 * nested_vmx_l1_wants_exit() will not pass related exits to L1.
+	 * These rules have exceptions below.
+	 */
+	nested_vmx_setup_pinbased_ctls(vmcs_conf, msrs);
+
+	nested_vmx_setup_exit_ctls(vmcs_conf, msrs);
+
+	nested_vmx_setup_entry_ctls(vmcs_conf, msrs);
+
+	nested_vmx_setup_cpubased_ctls(vmcs_conf, msrs);
+
+	nested_vmx_setup_secondary_ctls(ept_caps, vmcs_conf, msrs);
+
+	nested_vmx_setup_misc_data(vmcs_conf, msrs);
+
+	nested_vmx_setup_basic(msrs);
+
+	nested_vmx_setup_cr_fixed(msrs);
 
 	msrs->vmcs_enum = nested_vmx_calc_vmcs_enum_msr();
 }
-- 
2.25.1

