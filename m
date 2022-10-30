Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4478612835
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiJ3G3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiJ3G12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:27:28 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B63126;
        Sat, 29 Oct 2022 23:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111068; x=1698647068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JYNUDx8GHocZLxIorehBxnsfBypc958rUI5pLMpWkV4=;
  b=QG0coiFrJsFeuyOYWrKfmE2uh0Nno/1Yw/VvHs2kHFO5P2qjLcBQmZFg
   zfgqEGP/g3cFgRVOE01ByI3lLMpK5tMP8VaQocf4V3s9afNnqYgrl+Gbh
   VuS5k8ZS/h+8LkNEHgET6Q/csfaXkOGps1g+Uh6fEm3XW9lqBlZ7/Rojl
   Cnr1bgjH0FGWGYU0dCJdH4ED4Htvw7QenKBp7giuZ432ArRFLLgHxYP98
   +g7c3Qzz8MLdy1NZ6Zb4TZZREbIyG1BKNYycFfdM3Xls45SHUyYmvrMYi
   Ey/RqJTKe7IBxdeaH0Opmdhzd266CDOXgiqJOXnQ9Q6GqjQaGBvWcBPgv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="288435999"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="288435999"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:14 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393171"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393171"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:14 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 103/108] KVM: TDX: Silently discard SMI request
Date:   Sat, 29 Oct 2022 23:23:44 -0700
Message-Id: <e8b5a458f0944d2945d53c4a42d927e1979129f7.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/lapic.c       |  7 +++++--
 arch/x86/kvm/vmx/main.c    | 43 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     | 27 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  8 +++++++
 arch/x86/kvm/x86.c         |  3 ++-
 5 files changed, 81 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8d894c3959c8..7a1d612bd138 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1171,8 +1171,11 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 	case APIC_DM_SMI:
 		result = 1;
-		kvm_make_request(KVM_REQ_SMI, vcpu);
-		kvm_vcpu_kick(vcpu);
+		if (static_call(kvm_x86_has_emulated_msr)(vcpu->kvm,
+							  MSR_IA32_SMBASE)) {
+			kvm_make_request(KVM_REQ_SMI, vcpu);
+			kvm_vcpu_kick(vcpu);
+		}
 		break;
 
 	case APIC_DM_NMI:
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 3a8a4fdf1ce7..4acba8d8cb27 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -223,6 +223,41 @@ static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -580,10 +615,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
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
index 8e8ac1081ce4..111027724e06 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1660,6 +1660,33 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	return 1;
 }
 
+int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	/* SMI isn't supported for TDX. */
+	WARN_ON_ONCE(1);
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
+	WARN_ON_ONCE(1);
+	vcpu->arch.smi_pending = false;
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 8b9399b154f3..d4ffbf580bc5 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -165,6 +165,10 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 bool tdx_is_emulated_msr(u32 index, bool write);
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+int tdx_enter_smm(struct kvm_vcpu *vcpu, char *smstate);
+int tdx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate);
+void tdx_enable_smi_window(struct kvm_vcpu *vcpu);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -206,6 +210,10 @@ static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *in
 static inline bool tdx_is_emulated_msr(u32 index, bool write) { return false; }
 static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static inline int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection) { return false; }
+static inline int tdx_enter_smm(struct kvm_vcpu *vcpu, char *smstate) { return 0; }
+static inline int tdx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate) { return 0; }
+static inline void tdx_enable_smi_window(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5304b27f2566..d07563d0e204 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4936,7 +4936,8 @@ static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
 
 static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
 {
-	kvm_make_request(KVM_REQ_SMI, vcpu);
+	if (static_call(kvm_x86_has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE))
+		kvm_make_request(KVM_REQ_SMI, vcpu);
 
 	return 0;
 }
-- 
2.25.1

