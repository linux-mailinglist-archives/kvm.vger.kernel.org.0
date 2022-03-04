Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0E4CDDAA
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiCDUAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiCDT7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:10 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4517B269A7A;
        Fri,  4 Mar 2022 11:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423442; x=1677959442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S3ZaWwG9mI/BP5v7AFpzS7zNPq+WbUDAeYMpo8QxfoA=;
  b=VbMjlUU8yDXnoC8oUD1talMPLvGCjXkAGchwW+T9kOxMRk3fZZ8hwMtc
   x/9QhQPxgkyo2Cqo6Yl6/sdxf6mqj6xSW/BwCskpKg6jS2z2vc7ISMNNV
   WgZPfFYwUzrj7DAWtQ0OxYqNElEFdDG4iEwzuhPXLOFE7b6b/eJfJfvnK
   lZ+WBmnD3wcLnkCPlQB1frdF72BL957eCAAR8reXZNs3w8ajFlJap2BTi
   der4OaiFs0nf1v0X3egfgtPcWGhUswnpWqt7PNbh43Nma2sNaMx2XCc/W
   eBXCCAVd3v8E/7OU1ySJ2yEKa/UJit8bYknaIyKNAwbieWDc+huIXdlXq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779639"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779639"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:40 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344524"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:40 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 084/104] KVM: TDX: Add a place holder to handle TDX VM exit
Date:   Fri,  4 Mar 2022 11:49:40 -0800
Message-Id: <4028626d69d461a70838f060d6a1566089d630c3.1646422845.git.isaku.yamahata@intel.com>
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

Wire up handle_exit and handle_exit_irqoff methods and add a place holder
to handle VM exit.  Add helper functions to get exit info, exit
qualification, etc.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 35 +++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 79 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h | 11 ++++++
 3 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index aa84c13f8ee1..1e65406e3882 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -148,6 +148,23 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	return vmx_vcpu_load(vcpu, cpu);
 }
 
+static int vt_handle_exit(struct kvm_vcpu *vcpu,
+			     enum exit_fastpath_completion fastpath)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_handle_exit(vcpu, fastpath);
+
+	return vmx_handle_exit(vcpu, fastpath);
+}
+
+static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_handle_exit_irqoff(vcpu);
+
+	vmx_handle_exit_irqoff(vcpu);
+}
+
 static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -340,6 +357,18 @@ static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
 	vmx_request_immediate_exit(vcpu);
 }
 
+static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_get_exit_info(vcpu, reason, info1, info2, intr_info,
+				error_code);
+		return;
+	}
+
+	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
+}
+
 static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -411,7 +440,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.vcpu_pre_run = vmx_vcpu_pre_run,
 	.run = vt_vcpu_run,
-	.handle_exit = vmx_handle_exit,
+	.handle_exit = vt_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vt_set_interrupt_shadow,
@@ -446,7 +475,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
 
-	.get_exit_info = vmx_get_exit_info,
+	.get_exit_info = vt_get_exit_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
@@ -460,7 +489,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
+	.handle_exit_irqoff = vt_handle_exit_irqoff,
 
 	.request_immediate_exit = vt_request_immediate_exit,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 273898de9f7a..155208a8d768 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -68,6 +68,26 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa;
 }
 
+static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rcx_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rdx_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
+{
+	return kvm_r8_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
+{
+	return kvm_r9_read(vcpu);
+}
+
 static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
 {
 	return tdx->tdvpr.added;
@@ -768,6 +788,25 @@ void tdx_inject_nmi(struct kvm_vcpu *vcpu)
 	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
 }
 
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u16 exit_reason = tdx->exit_reason.basic;
+
+	if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
+		vmx_handle_exception_nmi_irqoff(vcpu, tdexit_intr_info(vcpu));
+	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		vmx_handle_external_interrupt_irqoff(vcpu,
+						     tdexit_intr_info(vcpu));
+}
+
+static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+	vcpu->mmio_needed = 0;
+	return 0;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
@@ -1042,6 +1081,46 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
 
+int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+{
+	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
+
+	if (unlikely(exit_reason.non_recoverable || exit_reason.error)) {
+		if (exit_reason.basic == EXIT_REASON_TRIPLE_FAULT)
+			return tdx_handle_triple_fault(vcpu);
+
+		kvm_pr_unimpl("TD exit 0x%llx, %d\n",
+			exit_reason.full, exit_reason.basic);
+		goto unhandled_exit;
+	}
+
+	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
+
+	switch (exit_reason.basic) {
+	default:
+		break;
+	}
+
+unhandled_exit:
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+	vcpu->run->hw.hardware_exit_reason = exit_reason.full;
+	return 0;
+}
+
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	*reason = tdx->exit_reason.full;
+
+	*info1 = tdexit_exit_qual(vcpu);
+	*info2 = tdexit_ext_exit_qual(vcpu);
+
+	*intr_info = tdexit_intr_info(vcpu);
+	*error_code = 0;
+}
+
 static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 31be5e8a1d5c..c0a34186bc37 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -146,11 +146,16 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu);
+int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath);
 
 void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -177,11 +182,17 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTP
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu) {}
+static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath) { return 0; }
 
 static inline void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu) {}
 static inline void tdx_deliver_interrupt(
 	struct kvm_lapic *apic, int delivery_mode, int trig_mode, int vector) {}
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
+static inline void tdx_get_exit_info(
+	struct kvm_vcpu *vcpu, u32 *reason, u64 *info1, u64 *info2,
+	u32 *intr_info, u32 *error_code) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

