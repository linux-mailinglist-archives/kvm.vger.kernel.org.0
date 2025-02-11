Return-Path: <kvm+bounces-37796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A22A301E1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97C4B169893
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B84F1E98F9;
	Tue, 11 Feb 2025 02:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ih1m6fKT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B071E7C16;
	Tue, 11 Feb 2025 02:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242643; cv=none; b=MPcW7dL3FCd1wvaSYW4A2XgyCkpgM7Q8E+fAZofbnNFGVycCJ7PxMeWBLm7wX7uLHxTDpKryotMpNd4moTzwJluCUiaPon3hDEHXaJaPxLcogd+cg+emqCnB9MM4vLIhpezF6K6B3JxgyLk/jo0wugIB4FTg5+u2R0V7BlNMsyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242643; c=relaxed/simple;
	bh=KeqMKy135qaKMyKYwiBX5D0AtAEXTegCVVgh4QvC4oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQnJC5iyxbXSX3m/JcM86L3wR1LpK70S/aSGrY73fmEQo+9Gv/gTin0DHeSRjARg08BFxQAv0GxMXGnhWRHE+j7SqZ6PJeoKVW0azFWlM7uy0QKl5bRCLOj0wAGK1e2ZaNnpI1PNBwWjDBN3DFQdzyYUsFUy5poJREjmnVgYdcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ih1m6fKT; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242643; x=1770778643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KeqMKy135qaKMyKYwiBX5D0AtAEXTegCVVgh4QvC4oU=;
  b=ih1m6fKT2Upz8MeBrk/NCkNb90ouDl7EH2Wt7VtrfdAMRIGN9ZPQIIQF
   XTiq6TPIqa1edWrR3RVqWO/DqbKzfiml74NUc7iGU6KZ1GQso9ZmksUUA
   1OQmRTtjnh4m0DKp0F5GsCg6CFvvA2cAfEbujT5bQHcKnx2aw+0yUrx4G
   +j06kj4bf+UdCy4H7ZqfLAnuGSZ744vXbcXd5vFVi6aK7SnmNlYT84a58
   ApIg1uBGt2gO9RGivDVhoSPFVwFuhs9qSVSR9k2zkuvPJvpaFxq72HQt7
   eSZfCAbHbf8PA52aX2yqY1ui4HqRPZCrkIEcRKZvneRLA6XStjOcLFGxO
   w==;
X-CSE-ConnectionGUID: tkp+7lBnTVK9nnqGcKhnoA==
X-CSE-MsgGUID: VDoQFLpQQ0qyuYvVVLpTgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612468"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612468"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:22 -0800
X-CSE-ConnectionGUID: CisfEC6rR7+EDbtEX/1uBg==
X-CSE-MsgGUID: vQOJXd1lQbmkEWCIlVaSsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355350"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:18 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 09/17] KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
Date: Tue, 11 Feb 2025 10:58:20 +0800
Message-ID: <20250211025828.3072076-10-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle SMI request as what KVM does for CONFIG_KVM_SMM=n, i.e. return
-ENOTTY, and add KVM_BUG_ON() to SMI related OPs for TD.

TDX doesn't support system-management mode (SMM) and system-management
interrupt (SMI) in guest TDs.  Because guest state (vCPU state, memory
state) is protected, it must go through the TDX module APIs to change
guest state.  However, the TDX module doesn't provide a way for VMM to
inject SMI into guest TD or a way for VMM to switch guest vCPU mode into
SMM.

MSR_IA32_SMBASE will not be emulated for TDX guest, -ENOTTY will be
returned when SMI is requested.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v2:
- No change.

TDX interrupts v1:
- Renamed from "KVM: TDX: Silently discard SMI request" to
  "KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM".
- Change the changelog.
- Handle SMI request as !CONFIG_KVM_SMM for TD, and remove the
  unnecessary comment. (Sean)
- Bug the VM if SMI OPs are called for a TD and remove related
  tdx_* functions, but still keep the vt_* wrappers. (Sean, Paolo)
- Use kvm_x86_call()
---
 arch/x86/kvm/smm.h      |  3 +++
 arch/x86/kvm/vmx/main.c | 43 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index a1cf2ac5bd78..551703fbe200 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -142,6 +142,9 @@ union kvm_smram {
 
 static inline int kvm_inject_smi(struct kvm_vcpu *vcpu)
 {
+	if (!kvm_x86_call(has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE))
+		return -ENOTTY;
+
 	kvm_make_request(KVM_REQ_SMI, vcpu);
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0d9b17d55bcc..8d91bd8eb991 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -180,6 +180,41 @@ static int vt_handle_exit(struct kvm_vcpu *vcpu,
 	return vmx_handle_exit(vcpu, fastpath);
 }
 
+#ifdef CONFIG_KVM_SMM
+static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return false;
+
+	return vmx_smi_allowed(vcpu, for_injection);
+}
+
+static int vt_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
+	return vmx_enter_smm(vcpu, smram);
+}
+
+static int vt_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
+	return vmx_leave_smm(vcpu, smram);
+}
+
+static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	/* RSM will cause a vmexit anyway.  */
+	vmx_enable_smi_window(vcpu);
+}
+#endif
+
 static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -539,10 +574,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
-- 
2.46.0


