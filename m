Return-Path: <kvm+bounces-38946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2780A404EC
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6982861C84
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC5F204C1F;
	Sat, 22 Feb 2025 01:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fm+DEDv0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DFC204690;
	Sat, 22 Feb 2025 01:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188811; cv=none; b=Eor8rJKHvPKUVhC5RbW7JbMQRpYmyB9EyO0jA2ZjJ09FeL2k2RTRyeiuWLyqxlceKQ/1GDufQK525yPCT5cRqyg57qqTukVO/0RyenQ1nS180oqNqU24T5tvMoVr3BQ18rjk53EUa/o24faAN6kcf7BijS40As83QWAOf1/ehDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188811; c=relaxed/simple;
	bh=VNMnzk/GcIe81MNjAwlETyAaaMI3OzGUEfG/JR3++is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8wZqRfr5tBztcaC/9zMnG2g1G4LS/krF3Hu4sITpfyfzZpTUufW3DIbSIr9jBSS+AUI8GOF7b7NPT9XHG8eNDfe1wgzSy/cyvOYex1OAMX43lNKSwcbUiRfNwB75OCcJFFj3fuUu0aBvVkdJfkb0kml2xkzxl8D4W8iTlnntAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fm+DEDv0; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188810; x=1771724810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VNMnzk/GcIe81MNjAwlETyAaaMI3OzGUEfG/JR3++is=;
  b=fm+DEDv0zKUKwOCT/UhzVqn3Hxdeb3QELwPNi/ajGgkuZkNye9oelsmC
   7SOKJL+cRltTKY7h6GhApTwtHPvDmSW9KrhslMvrKojuGyG/evqNetRf4
   bcQY3ZmMfvHAJwHeLFWaQ/eIyJcNxh0pAEohDBTescI33G23WOKAEHLBi
   r0eSvIYVA8fsKoAxpDIdPGfWPfaDLaBqmEN/v6JRfpnfwpn6vWAlcM5vs
   9DenEfV3Mp4VwfU3mT1yBi1JRN+qWVLo8/GvYqwjuY2vkwDkO84HkBBZH
   /kA8UoJ3J5nM3Mm/cn0dDYrLUcOWHj5p9ws2oEIMhe84sYtDeFv6XzOlc
   w==;
X-CSE-ConnectionGUID: BTL2+HkeR0K8eRgoGoVT4w==
X-CSE-MsgGUID: zDd4UFO2Tt23tUZGnQPjjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449047"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449047"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:50 -0800
X-CSE-ConnectionGUID: 7pVC6xL1SPaH6W4NiazrZg==
X-CSE-MsgGUID: BX4zPXE+Ry6QmgO8lzupLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621684"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:46 -0800
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
Subject: [PATCH v3 08/16] KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
Date: Sat, 22 Feb 2025 09:47:49 +0800
Message-ID: <20250222014757.897978-9-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
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
TDX interrupts v3:
 - changing 'false' to '0' (Sean)

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
index cb5fcf5fd963..0af357a992af 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -191,6 +191,41 @@ static int vt_handle_exit(struct kvm_vcpu *vcpu,
 	return vmx_handle_exit(vcpu, fastpath);
 }
 
+#ifdef CONFIG_KVM_SMM
+static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
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
@@ -549,10 +584,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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


