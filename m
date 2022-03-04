Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525574CDD81
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiCDT75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiCDT7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F002335D6;
        Fri,  4 Mar 2022 11:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423448; x=1677959448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gQ2HFrAUzwOFK+v0RpVHUFa5/SQdoyNcxId2bU4O338=;
  b=R1oR62MiwN6VQCWJ51GyRmDYbHJ90e0Pfbh5u8zN4iwFCZg3wHFpLOEh
   /hxNsX0gwMJayO1vpAByp2yMyV+jRLitoLNAMTJPgrTcE6yrdJDQCAmcy
   n2rvGZxpqSMdMepLlOR3LXog+/t2mjGxLktZ1T0q4lGX9RIgK6yCjmTMg
   2h0XYrx0hcCv7otVZkyOgqQR+sdOnicDRh8u9XsresqGjagR6XJrENXKE
   ZTeudHy2UuTSj8BqygYr50U9yNJgv1+D6pQ5jK5QMsyQyJP3Tj9k3ZY6n
   L5v8QHsXALxcN8fhx2lIfoB0FMDAk6VGlCmDQLwXW+SRcaiOMmrDKEwkn
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779666"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779666"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:47 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344614"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:47 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 100/104] KVM: TDX: Silently discard SMI request
Date:   Fri,  4 Mar 2022 11:49:56 -0800
Message-Id: <b3976a6ed7b7e38f05a9e95eac5b0d735e52bb4d.1646422845.git.isaku.yamahata@intel.com>
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

TDX doesn't support system-management mode (SMM) and system-management
interrupt (SMI) in guest TDs.  Because guest state (vcpu state, memory
state) is protected, it must go through the TDX module APIs to change guest
state, injecting SMI and changing vcpu mode into SMM.  The TDX module
doesn't provide a way for VMM to inject SMI into guest TD and a way for VMM
to switch guest vcpu mode into SMM.

We have two options in KVM when handling SMM or SMI in the guest TD or the
device model (e.g. QEMU): 1) silently ignore the request or 2) return a
meaningful error.

For simplicity, we implemented the option 1).

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 43 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     | 25 ++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  8 +++++++
 3 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a528cfdbce54..478aa63acefa 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -193,6 +193,41 @@ static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return vmx_get_msr(vcpu, msr_info);
 }
 
+static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_smi_allowed(vcpu, for_injection);
+
+	return vmx_smi_allowed(vcpu, for_injection);
+}
+
+static int vt_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_enter_smm(vcpu, smstate);
+
+	return vmx_enter_smm(vcpu, smstate);
+}
+
+static int vt_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_leave_smm(vcpu, smstate);
+
+	return vmx_leave_smm(vcpu, smstate);
+}
+
+static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_enable_smi_window(vcpu);
+		return;
+	}
+
+	/* RSM will cause a vmexit anyway.  */
+	vmx_enable_smi_window(vcpu);
+}
+
 static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -539,10 +574,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.setup_mce = vmx_setup_mce,
 
-	.smi_allowed = vmx_smi_allowed,
-	.enter_smm = vmx_enter_smm,
-	.leave_smm = vmx_leave_smm,
-	.enable_smi_window = vmx_enable_smi_window,
+	.smi_allowed = vt_smi_allowed,
+	.enter_smm = vt_enter_smm,
+	.leave_smm = vt_leave_smm,
+	.enable_smi_window = vt_enable_smi_window,
 
 	.can_emulate_instruction = vmx_can_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e5eccec0e24d..7bbf6271967b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1692,6 +1692,31 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	return 1;
 }
 
+int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	/* SMI isn't supported for TDX. */
+	return false;
+}
+
+int tdx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+{
+	/* smi_allowed() is always false for TDX as above. */
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+int tdx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+{
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+void tdx_enable_smi_window(struct kvm_vcpu *vcpu)
+{
+	/* SMI isn't supported for TDX.  Silently discard SMI request. */
+	vcpu->arch.smi_pending = false;
+}
+
 static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index dcaa5806802e..19d793609cc4 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -159,6 +159,10 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 bool tdx_is_emulated_msr(u32 index, bool write);
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+int tdx_enter_smm(struct kvm_vcpu *vcpu, char *smstate);
+int tdx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate);
+void tdx_enable_smi_window(struct kvm_vcpu *vcpu);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -199,6 +203,10 @@ static inline void tdx_get_exit_info(
 static inline bool tdx_is_emulated_msr(u32 index, bool write) { return false; }
 static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static inline int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection) { return false; }
+static inline int tdx_enter_smm(struct kvm_vcpu *vcpu, char *smstate) { return 0; }
+static inline int tdx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate) { return 0; }
+static inline void tdx_enable_smi_window(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

