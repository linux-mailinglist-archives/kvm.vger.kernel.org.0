Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0E258BD3A
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbiHGWGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiHGWET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:04:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBDB6593;
        Sun,  7 Aug 2022 15:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909772; x=1691445772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/nw6S/LZcRkxsaPmZ6JlPeaz/WuWls7dj04WCs4mwi4=;
  b=dsifFwidl/eT3itijuwZ/Nu5QOuRlNXhW1OfBQYRYYMY7DFtaJzvWbOc
   wxS+TznUJAxJSoeTQcjEJTziQDmhVHnDu4kr8l9Wlc8SvaqncE6whTAId
   q7pWYAapSz79lNUhbQgBmXT8IoX8ftQG3Gi84KY8XwBqi0rfvLFsoBPYC
   HwtSJ9vJRBjDKad43mnXOgAapkYueQuKGGNFPobczMsCuFs/imOVWfBXg
   k/Jr3DAoNHoqEpb/40pCtcaZzdRkEPf3VDUlUFJO4y8NAD9GcJFSaZycm
   IjR5GxrfUiEIKWOEzEiw3C7pggmn2od2H3kE5w809u55agy14vQAW90W5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240378"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240378"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:41 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682705"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:41 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 079/103] KVM: TDX: Implement methods to inject NMI
Date:   Sun,  7 Aug 2022 15:02:04 -0700
Message-Id: <985b94f3dce57d946f63f3c9081982c481c0cf99.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
 arch/x86/kvm/vmx/main.c    | 62 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     |  5 +++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 52d3fac737fd..fea4652c2190 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -264,6 +264,58 @@ static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vmx_flush_tlb_guest(vcpu);
 }
 
+static void vt_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_inject_nmi(vcpu);
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
@@ -418,14 +470,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.inject_irq = vt_inject_irq,
-	.inject_nmi = vmx_inject_nmi,
+	.inject_nmi = vt_inject_nmi,
 	.queue_exception = vmx_queue_exception,
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
index 79d2e2a609e1..151fa41fec0e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -802,6 +802,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
+void tdx_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 7c40833edc8e..679f283da95a 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -153,6 +153,7 @@ bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
+void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -184,6 +185,7 @@ static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { ret
 
 static inline void tdx_deliver_interrupt(
 	struct kvm_lapic *apic, int delivery_mode, int trig_mode, int vector) {}
+static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

