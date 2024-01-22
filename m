Return-Path: <kvm+bounces-6678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C771837868
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D8781F24CD7
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449607E590;
	Mon, 22 Jan 2024 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwNxjuX8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C2677F04;
	Mon, 22 Jan 2024 23:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967769; cv=none; b=PxlmyDGanrK631bf61vLqEJ4fFpcgp9O0IWQPOIPU6wZ3wTey1axcP1yyCaYhcfPU4rWLAa+vp0jwLPMF2Ys2bKfPlVGoeTwgnZKOPWg59dTVkPXSChhW7wJIZpdpxH17urlIqPtskqkIQLEMNP5B2m6ralxQw3WcVWNh+r9/10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967769; c=relaxed/simple;
	bh=ShnWPqwXd6oImZEStNfbRn9eZWdCYnbKir4yP6TYo7w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i9uIrGPT8+ogugULgFxedziJVMu1UWhxT/aSAeS/vcye4X4zBiQZndGD03DyNPsFyjUUIbRw2vMTbHigCFj8LfkeH2TK0YK0bLjgrkOTlJYxL4sNtB3Xq0B9knrVudmyQDVpO5MJMUAMFK+OCD/Iv4q8z9md5bFAuykSneoN1Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwNxjuX8; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967767; x=1737503767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ShnWPqwXd6oImZEStNfbRn9eZWdCYnbKir4yP6TYo7w=;
  b=OwNxjuX85RVQVsMwboaiHMg/JQxfx6/Fm6z+SmjM4iwKbZztdvs2bLZT
   kxsQoOzJf0t5zQZU9mqdHMr8GJd57hiVqiC76gjU1fZNd03eBNXdIU9NA
   9YwjIXkwI9oyWWfV6RNYrcljLlCH+zQTfnzIqQQLKv26qrxCLxrEfC91W
   1ziJUhWOqhf7BwGijoqDVLxZVF1WQuktCzpw03AV7ni1YmNvHIFjC2b87
   iGEvzD+1TssTsOS1FSihjUtW/Cdm2pBLBMhb9tmxhb0zaRjo9UYUOR4Eb
   JdNhpiBGWuKeNd8NDKQXVev40pm831P+XrfrkOtMnfNJoJe0adjPB2IIz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217896"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217896"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818002"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:53 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 105/121] KVM: TDX: Silently discard SMI request
Date: Mon, 22 Jan 2024 15:54:21 -0800
Message-Id: <8a361ed130a0672c3dc5c09f12ca42b05635b9d1.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 0373744ecf00..cf0d8ed4d18e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -298,6 +298,43 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
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
 static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -682,10 +719,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
 
 	.check_emulate_instruction = vmx_check_emulate_instruction,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9283d45ea4b8..2dd5fe926a0e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2090,6 +2090,35 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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
index 608db691b1b8..b220c8d1da33 100644
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


