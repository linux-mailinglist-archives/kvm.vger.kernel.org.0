Return-Path: <kvm+bounces-963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D69247E42A5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CBB0B21A59
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785AC34CFD;
	Tue,  7 Nov 2023 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JHiSWah8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C09C347A4
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:04:46 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D3F6182;
	Tue,  7 Nov 2023 07:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369321; x=1730905321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lvFXZW11aNWprIE1CI7SHVvnjtFNvLn8G8igkdJaIJk=;
  b=JHiSWah8sIho63GCKhnW/tXQ7pSmW12v7w/8+69d2pD2f1glwfXogSf2
   V1ozXulDPbf96Sjf8NL2pLP7MGilMYHB30cD+dgXWNjdZyafM8fNZhzfy
   /GnxouaVh6u+/t+2HUfqE5isQTMSvuG7dFqQeZzjhmaeBR+cxLu6KWren
   9KVzVl4ipUUB5LasvY8rTowR2ztNanhsQ+JOO+lIsY8megwxM0cs9U2Hw
   O0kO7tcAiesQqNKQXEIieqwFOJ5YR6LViXDP041yFsfkiw1L7Y3VD3yT4
   LFMbKo8zwMOwZbxsIEvVeohhBskzDUbyUVuYUgkKrhmmNPkq0EDYOhVj+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462670"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462670"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851652"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:29 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 109/116] KVM: TDX: Add methods to ignore virtual apic related operation
Date: Tue,  7 Nov 2023 06:57:15 -0800
Message-Id: <124b36386a4c94ebeedb72ec6f9af72ccecd3b90.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
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
index 95aebd4162fc..08d8cbd12540 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -363,6 +363,14 @@ static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
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
@@ -371,6 +379,31 @@ static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
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
@@ -824,6 +857,22 @@ static void vt_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
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
@@ -1033,15 +1082,15 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index e21a46ac0434..38ce503611f0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2063,6 +2063,12 @@ void tdx_enable_smi_window(struct kvm_vcpu *vcpu)
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
index 4c859913fb0b..b063424c916d 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -168,6 +168,7 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 bool tdx_has_emulated_msr(u32 index, bool write);
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 int tdx_get_cpl(struct kvm_vcpu *vcpu);
 void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
@@ -220,6 +221,8 @@ static inline bool tdx_has_emulated_msr(u32 index, bool write) { return false; }
 static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 
+static inline void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu) {}
+
 static inline int tdx_get_cpl(struct kvm_vcpu *vcpu) { return 0; }
 static inline void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg) {}
 static inline unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu) { return 0; }
-- 
2.25.1


