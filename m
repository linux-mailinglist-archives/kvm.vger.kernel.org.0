Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6026A3D24
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjB0Ibg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjB0IaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:30:05 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751E220D12;
        Mon, 27 Feb 2023 00:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486402; x=1709022402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x0ayolqox89Eiek3h19Ty17vWo1hFMBecMFI+9M9Tko=;
  b=FfbztvSMUbIkrfq9ybDoZveVhPBK3PUYv7ZoC9JBSsjFMH/SIqUGN7gL
   JjWk/J4KAteCsv0x34PAz1WWhvBYmpBbgts5HwEZffYpd+/6BjAhQMPpw
   XLexrq977pzGlV/YH7VXX8Vzcqp479VzCr+IjnN0CSQftwdDsQMgu/kSt
   hshX14ZeU9p2pFv3wh7Md3/v76ClmqMsiWbTmfxve9BrJOeu6vbgNel2+
   dXMfznDnjJCt7pIV7jYo7zkVNv9CIt7xM4bVRqaX/K5JX5ZXuQAgad91U
   I4OQ0cqlJtrOUfvSgvNeyfObSHPmYLXoprTAvo7mjhhFr/WCSTth6996g
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609074"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609074"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242422"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242422"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:19 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 093/106] KVM: TDX: Silently discard SMI request
Date:   Mon, 27 Feb 2023 00:23:32 -0800
Message-Id: <0f2736a8b7526c91d1e7438f9b0726f88c0aa825.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/smm.h         |  7 +++++-
 arch/x86/kvm/vmx/main.c    | 45 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     | 29 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h | 12 ++++++++++
 4 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index a1cf2ac5bd78..bc77902f5c18 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -142,7 +142,12 @@ union kvm_smram {
 
 static inline int kvm_inject_smi(struct kvm_vcpu *vcpu)
 {
-	kvm_make_request(KVM_REQ_SMI, vcpu);
+	/*
+	 * If SMM isn't supported (e.g. TDX), silently discard SMI request.
+	 * Assume that SMM supported = MSR_IA32_SMBASE supported.
+	 */
+	if (static_call(kvm_x86_has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE))
+		kvm_make_request(KVM_REQ_SMI, vcpu);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 67d565a32e96..872479b8edb8 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -273,6 +273,43 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
 	vmx_msr_filter_changed(vcpu);
 }
 
+#ifdef CONFIG_KVM_SMM
+static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_smi_allowed(vcpu, for_injection);
+
+	return vmx_smi_allowed(vcpu, for_injection);
+}
+
+static int vt_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_enter_smm(vcpu, smram);
+
+	return vmx_enter_smm(vcpu, smram);
+}
+
+static int vt_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_leave_smm(vcpu, smram);
+
+	return vmx_leave_smm(vcpu, smram);
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
+#endif
+
 static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -658,10 +695,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.setup_mce = vmx_setup_mce,
 
 #ifdef CONFIG_KVM_SMM
-	.smi_allowed = vmx_smi_allowed,
-	.enter_smm = vmx_enter_smm,
-	.leave_smm = vmx_leave_smm,
-	.enable_smi_window = vmx_enable_smi_window,
+	.smi_allowed = vt_smi_allowed,
+	.enter_smm = vt_enter_smm,
+	.leave_smm = vt_leave_smm,
+	.enable_smi_window = vt_enable_smi_window,
 #endif
 
 	.can_emulate_instruction = vmx_can_emulate_instruction,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 35c6875d3bef..01871f343ce2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1862,6 +1862,35 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	return 1;
 }
 
+#ifdef CONFIG_KVM_SMM
+int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	/* SMI isn't supported for TDX. */
+	WARN_ON_ONCE(1);
+	return false;
+}
+
+int tdx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
+{
+	/* smi_allowed() is always false for TDX as above. */
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+int tdx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
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
+#endif
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 26d07514f6a4..242fcd043d0a 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -226,4 +226,16 @@ static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { return 0; }
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
+#if defined(CONFIG_INTEL_TDX_HOST) && defined(CONFIG_KVM_SMM)
+int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection);
+int tdx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram);
+int tdx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram);
+void tdx_enable_smi_window(struct kvm_vcpu *vcpu);
+#else
+static inline int tdx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection) { return false; }
+static inline int tdx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram) { return 0; }
+static inline int tdx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram) { return 0; }
+static inline void tdx_enable_smi_window(struct kvm_vcpu *vcpu) {}
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

