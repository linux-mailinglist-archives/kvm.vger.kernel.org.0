Return-Path: <kvm+bounces-9749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4138866DB4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E70AF1C2384C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680A2130AE0;
	Mon, 26 Feb 2024 08:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y0T53hPe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BBD12F39B;
	Mon, 26 Feb 2024 08:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936161; cv=none; b=iKJigOhSelNwh3Gagm+ZnWhI89Zs0hId5K8HIG+7lxWdHwxqSMvjypWWRYDcWa6aCzxS0Tk57Q4iP64nFVf+VOQxns0gsnHvmCqMFE1bCa3mU2MWxNH9Wd9JLjNnpGlsNyD8jWve8YbNMAV80hscWSg6SlUst3lY9rLsEnFJe7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936161; c=relaxed/simple;
	bh=3EtzmmZ/aleau45nztUNKdmXOOZf4kna/f5LnDlJiNs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R4IPXgpF8RoWXxmiPSpp/EyZYsJl/6qqw2qzb802ZU6LXkVZMA0+DlSrlOfSwy0bvDT2Q473yWq6ShrupaWU/4QKBWUg60fV2QDtU8xnk4ER3w3lBBv8IoA4uAt36YbeiymIgeVI5X64pPkt11WuBoI3evI9WNBCGAkIh4ogG5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y0T53hPe; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936159; x=1740472159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3EtzmmZ/aleau45nztUNKdmXOOZf4kna/f5LnDlJiNs=;
  b=Y0T53hPebT+0Mde18P+DJZ0ZZ7MdJtyx+EZfDZoeZwQcoMaeBDppVXh8
   LtT3wWFzm4+9rE/bd6NKUzl8gx+WRfqpH1mHFeAnzX4uondlk+zHVGUtz
   uUPkkAqBTrY2mgNqnEt6nBAU8UUlOJNCzs5AMf35OrTk1EZYobtNtr1mC
   uEsR9wbUkqCDUDSQoMcz3Gwi8CI4S0Hbb+U617Q6vy/s1z4T6twKRYlVA
   flzWr0IeTzFDpJHg4XXLDWOyNUiQnYPae3Pe0Co0Mrg9pEKqxjAx6zezr
   bbCHHol6WTupk7XT2dHdWVIVkuP23EGQypa/DykGY2+K+yN3Vju4/3T6F
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751408"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751408"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735140"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:11 -0800
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
Subject: [PATCH v19 125/130] KVM: TDX: Add methods to ignore virtual apic related operation
Date: Mon, 26 Feb 2024 00:27:07 -0800
Message-Id: <52300c655b1e7d6cc0a13727d977f1f02729a4bb.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX protects TDX guest APIC state from VMM.  Implement access methods of
TDX guest vAPIC state to ignore them or return zero.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 61 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     |  6 ++++
 arch/x86/kvm/vmx/x86_ops.h |  3 ++
 3 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index fae5a3668361..c46c860be0f2 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -352,6 +352,14 @@ static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return vmx_apic_init_signal_blocked(vcpu);
 }
 
+static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_set_virtual_apic_mode(vcpu);
+
+	return vmx_set_virtual_apic_mode(vcpu);
+}
+
 static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -360,6 +368,31 @@ static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 	memset(pi->pir, 0, sizeof(pi->pir));
 }
 
+static void vt_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	return vmx_hwapic_irr_update(vcpu, max_irr);
+}
+
+static void vt_hwapic_isr_update(int max_isr)
+{
+	if (is_td_vcpu(kvm_get_running_vcpu()))
+		return;
+
+	return vmx_hwapic_isr_update(max_isr);
+}
+
+static bool vt_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 at the moment. */
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return false;
+
+	return vmx_guest_apic_has_interrupt(vcpu);
+}
+
 static int vt_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -815,6 +848,22 @@ static void vt_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 	vmx_update_cr8_intercept(vcpu, tpr, irr);
 }
 
+static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_apic_access_page_addr(vcpu);
+}
+
+static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return;
+
+	vmx_refresh_apicv_exec_ctrl(vcpu);
+}
+
 static void vt_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 {
 	if (is_td_vcpu(vcpu))
@@ -1055,15 +1104,15 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.enable_nmi_window = vt_enable_nmi_window,
 	.enable_irq_window = vt_enable_irq_window,
 	.update_cr8_intercept = vt_update_cr8_intercept,
-	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
-	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
+	.set_virtual_apic_mode = vt_set_virtual_apic_mode,
+	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
+	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vt_load_eoi_exitmap,
 	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
-	.hwapic_irr_update = vmx_hwapic_irr_update,
-	.hwapic_isr_update = vmx_hwapic_isr_update,
-	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
+	.hwapic_irr_update = vt_hwapic_irr_update,
+	.hwapic_isr_update = vt_hwapic_isr_update,
+	.guest_apic_has_interrupt = vt_guest_apic_has_interrupt,
 	.sync_pir_to_irr = vt_sync_pir_to_irr,
 	.deliver_interrupt = vt_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fc78e9ca61c1..f706c346eea4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2080,6 +2080,12 @@ void tdx_enable_smi_window(struct kvm_vcpu *vcpu)
 }
 #endif
 
+void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	/* Only x2APIC mode is supported for TD. */
+	WARN_ON_ONCE(kvm_get_apic_mode(vcpu) != LAPIC_MODE_X2APIC);
+}
+
 int tdx_get_cpl(struct kvm_vcpu *vcpu)
 {
 	return 0;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 727c4d418601..c507f1513dac 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -168,6 +168,7 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 bool tdx_has_emulated_msr(u32 index, bool write);
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 int tdx_get_cpl(struct kvm_vcpu *vcpu);
 void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
@@ -227,6 +228,8 @@ static inline bool tdx_has_emulated_msr(u32 index, bool write) { return false; }
 static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 
+static inline void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu) {}
+
 static inline int tdx_get_cpl(struct kvm_vcpu *vcpu) { return 0; }
 static inline void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg) {}
 static inline unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu) { return 0; }
-- 
2.25.1


