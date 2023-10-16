Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590177CAFEF
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbjJPQkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343535AbjJPQjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:39:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62836E9A;
        Mon, 16 Oct 2023 09:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473326; x=1729009326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qV+EOFqYuH/9/7/aBdY7X3g8KyLOgbz8iWb6NJMoKNs=;
  b=IxPhVtQdW1q88P6PDEa/9RjnMMYbdYCe//XpuY24yXwc7nHqEKc+t6Vr
   vsogK7kjzBspgWxHRKd0Zd18xrVnnjGckLkC2scIZb6wjQc7GMfG4ucYa
   vqJfEP9qpmN+OfEVF1qLK3invuCivBC1756kiah8Yv9aeF01yGoiyppJE
   wsFQvTSc0WHD1+zlb7ssnhoHxhr3pcRWsVNFbTh+szSUBngS6Tk0Jg5TR
   ZgC9JF7J82D4tC/Wuc0mScYSXZTLxdJeK8k22dgxG3bEaXyf/4gZhHgVx
   6vP9oUJztWxOzH7xfixOJMsX2/E0DDsVkWl7THG7DQCUdDNkC9/Um6UxX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922099"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922099"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448342"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448342"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 100/116] KVM: TDX: Silently discard SMI request
Date:   Mon, 16 Oct 2023 09:14:52 -0700
Message-Id: <c088d5a1f3c1789634f099ec0636f27e4d502cc9.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 982022993700..ad91efcc2413 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -294,6 +294,43 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
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
@@ -678,10 +715,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index b4a0fa51ee62..f368f9c950ad 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2042,6 +2042,35 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	}
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
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index fd52c7df0cd8..092676b50dc2 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -222,4 +222,16 @@ static inline int tdx_sept_flush_remote_tlbs(struct kvm *kvm) { return 0; }
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

