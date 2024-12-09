Return-Path: <kvm+bounces-33269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CC59E88E1
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:08:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E28522835B9
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 01:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C706156257;
	Mon,  9 Dec 2024 01:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gbEdqpeK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA615532A;
	Mon,  9 Dec 2024 01:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733706372; cv=none; b=ub8uBjWiOunGG7LBkHSCXcGbzhykobYslv0/Ja7f7ZQHwV1Wcmt1w1HO8SJuCEzBbfadYKyr77Pe5+VduSc5aEj5SHJMN/XuKzt0eGllpIU1rWWR6OQ3pZzZRPRCeupcG8pPXoDpUt8iyljfyMRbunlTbQWMlduMqP097r0PwhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733706372; c=relaxed/simple;
	bh=KKprr1MLIOaWjaMEW+Z0yi/CHEUiks7GRwHYj3nfd34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guPPqapxgSx2xJSRrYhX3D6iTgyz2yfr8am8eSnHwvaim/fdr3ZRbl4NOfAYY/NtM5BjYlTxvVudPwbOPpsbKoqJYUE63FnuCz2fmhalbvs9kNobpuL+w7RllrGAPYCIbmkdV5YcA9IdP+M6/iJmWekX4STIKTpMVM1IppfyhFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gbEdqpeK; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733706371; x=1765242371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KKprr1MLIOaWjaMEW+Z0yi/CHEUiks7GRwHYj3nfd34=;
  b=gbEdqpeK3PA3Carqt180qlY5XiNZNuehAqhJwF6z1DBWXkmtGj5czzcc
   wmtqwQUUDgTc6d2F0hf82TZhvmXam9thjP3QeiZlulybMjxsSjTrdnllS
   wRBIBqsFhbrhkVvsfOmtdgj1J4IabPx3BIdr9bPLTUL5lce7QgYXx8O5W
   7DSAhQgI2DlvFF1I1pzVaSNNFxkAE7UoaT2pJPuY/ZWoK9ZT0nRVAbrSi
   cAQTavOm6MoubFAxV0P0ucNM4QExxIuilGXG5l8mGrPDMLtJ3hLoVm3oL
   bbVPiYibb7SfU8vhfLeTYxgIftqy/vWQUaSp21CtWCUZSWwr537yhTrHT
   w==;
X-CSE-ConnectionGUID: XlzHttu5TAW/rNTP5AODzQ==
X-CSE-MsgGUID: LDuv4+DMQ/aB0LG6JvXF+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="36833719"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="36833719"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:11 -0800
X-CSE-ConnectionGUID: 2GyM7aqjQZ6AH89YYGqNUg==
X-CSE-MsgGUID: bex6hh+iQOubLCMAg4WtzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="95402507"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 17:06:07 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 10/16] KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
Date: Mon,  9 Dec 2024 09:07:24 +0800
Message-ID: <20241209010734.3543481-11-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
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
TDX interrupts breakout:
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
index 4b42d14cc62e..8ec96646faec 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -176,6 +176,41 @@ static int vt_handle_exit(struct kvm_vcpu *vcpu,
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
+	if(KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
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
@@ -523,10 +558,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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


