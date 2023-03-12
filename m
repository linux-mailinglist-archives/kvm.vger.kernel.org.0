Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF76A6B69CD
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjCLSHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCLSFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:05:31 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B18551CBC;
        Sun, 12 Mar 2023 11:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644077; x=1710180077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UM044UJG+PPHay0ZNQHU262VYsx2E1CBwh+QM9tGVqk=;
  b=D7sS3pTjkqSwxxI2uRyld9WLWJjH4jHlGcttQH5Okp+U5nwBXpr5b2sr
   q8hH2eadzLKmpHwPZNirEeEPXjelwym+KXfdndMglI93DeTyDqmjiZT00
   S5pF2hX5Ad2LRmpm1ClWFzbQ5CWPrDn1N0y8FPi1nN7nT/3OhDW/emNhz
   FDxvP68GczLHX3QZ3or/lZ8lfjc/Sf/UT0LhEXyFRN5Svp19eHc0uGSD8
   LZ4f8hFPEbVoGeMvrp3dZrSl79RGRietiPdmYjkFzRN+U72+l7gJp4hzy
   h4L8rtPv99vMtTfSUa/bq1IZM4X9eyvHF6CWSnI42wwSM7ZnSXzd8lhtM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660140"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660140"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596865"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596865"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:18 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 109/113] KVM: TDX: Add methods to ignore virtual apic related operation
Date:   Sun, 12 Mar 2023 10:57:13 -0700
Message-Id: <bb549855d0e8707f5776cd7c2558ce62fd812fdd.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 21aebf38697a..c79f46ede97e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -364,6 +364,14 @@ static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
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
 static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -372,6 +380,31 @@ static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
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
@@ -809,6 +842,22 @@ static void vt_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
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
@@ -1019,15 +1068,15 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
 	.apicv_post_state_restore = vt_apicv_post_state_restore,
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
index 23a184d5ab47..8e392bc3330b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1866,6 +1866,12 @@ void tdx_enable_smi_window(struct kvm_vcpu *vcpu)
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
index 9be0ac32d2b4..d049e0c72ed0 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -174,6 +174,7 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 bool tdx_has_emulated_msr(u32 index, bool write);
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 int tdx_get_cpl(struct kvm_vcpu *vcpu);
 void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
@@ -226,6 +227,8 @@ static inline bool tdx_has_emulated_msr(u32 index, bool write) { return false; }
 static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 
+static inline void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu) {}
+
 static inline int tdx_get_cpl(struct kvm_vcpu *vcpu) { return 0; }
 static inline void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg) {}
 static inline unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu) { return 0; }
-- 
2.25.1

