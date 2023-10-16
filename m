Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DBB7CAFBC
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbjJPQht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbjJPQhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4E044B2;
        Mon, 16 Oct 2023 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473201; x=1729009201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0jJSfAH/rm1pFANGErJJWvHSeXt4lnyzK3yPKF7K1j8=;
  b=FbZnmT3b+80ANV+8+7bVXV2bL7rsy3bKFQDend4ds7jOB6X8RXuUqyJU
   7k1gWXrMUiUs6M8pfW3fPV1ead6Y4pIew6oMtZFmSXMF38/GmwRJAGJtw
   BgVOmFUgkR6HLZMGRDXYdD1khbrLavxdOMBvtr02XDZQk7YLZCSdVpUZa
   Y2MvYMhxuzsy7WIGewwMtgd0CxZPd7Y8/VjXMcjDt5LFTT05lSpg6/jf4
   17ppfDRTbxRDxu13arZjyJsAN31RcKfowXE9DOMxxnjPPKxLPYZuVyvcc
   cAd/7DRAtVlze5MC45gxgjpIyqn0u/BYLST8u25LFtrKDyqv4o/7AWA1t
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921961"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921961"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448242"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448242"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:57 -0700
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
Subject: [PATCH v16 078/116] KVM: TDX: Implement methods to inject NMI
Date:   Mon, 16 Oct 2023 09:14:30 -0700
Message-Id: <f1cc116c09b285915914b0bc5db56a78c22e0293.1697471314.git.isaku.yamahata@intel.com>
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

TDX vcpu control structure defines one bit for pending NMI for VMM to
inject NMI by setting the bit without knowing TDX vcpu NMI states.  Because
the vcpu state is protected, VMM can't know about NMI states of TDX vcpu.
The TDX module handles actual injection and NMI states transition.

Add methods for NMI and treat NMI can be injected always.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c    | 64 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     |  6 ++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0ce9578a1453..91e2ad643a47 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -315,6 +315,60 @@ static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vmx_flush_tlb_guest(vcpu);
 }
 
+static void vt_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_inject_nmi(vcpu);
+		return;
+	}
+
+	vmx_inject_nmi(vcpu);
+}
+
+static int vt_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	/*
+	 * The TDX module manages NMI windows and NMI reinjection, and hides NMI
+	 * blocking, all KVM can do is throw an NMI over the wall.
+	 */
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_nmi_allowed(vcpu, for_injection);
+}
+
+static bool vt_get_nmi_mask(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Assume NMIs are always unmasked.  KVM could query PEND_NMI and treat
+	 * NMIs as masked if a previous NMI is still pending, but SEAMCALLs are
+	 * expensive and the end result is unchanged as the only relevant usage
+	 * of get_nmi_mask() is to limit the number of pending NMIs, i.e. it
+	 * only changes whether KVM or the TDX module drops an NMI.
+	 */
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return vmx_get_nmi_mask(vcpu);
+}
+
+static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_nmi_mask(vcpu, masked);
+}
+
+static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
+{
+	/* Refer the comment in vt_get_nmi_mask(). */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_enable_nmi_window(vcpu);
+}
+
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			int pgd_level)
 {
@@ -493,14 +547,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.inject_irq = vt_inject_irq,
-	.inject_nmi = vmx_inject_nmi,
+	.inject_nmi = vt_inject_nmi,
 	.inject_exception = vmx_inject_exception,
 	.cancel_injection = vt_cancel_injection,
 	.interrupt_allowed = vt_interrupt_allowed,
-	.nmi_allowed = vmx_nmi_allowed,
-	.get_nmi_mask = vmx_get_nmi_mask,
-	.set_nmi_mask = vmx_set_nmi_mask,
-	.enable_nmi_window = vmx_enable_nmi_window,
+	.nmi_allowed = vt_nmi_allowed,
+	.get_nmi_mask = vt_get_nmi_mask,
+	.set_nmi_mask = vt_set_nmi_mask,
+	.enable_nmi_window = vt_enable_nmi_window,
 	.enable_irq_window = vt_enable_irq_window,
 	.update_cr8_intercept = vmx_update_cr8_intercept,
 	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index beb3fa2d3e41..f5e29f8f1b6a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -848,6 +848,12 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
+void tdx_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.nmi_injections;
+	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 454f28099868..9a949273bf47 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -159,6 +159,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
+void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -195,6 +196,7 @@ static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
+static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1

