Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E345F08A2
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiI3KVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiI3KTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700DA1664AC;
        Fri, 30 Sep 2022 03:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533146; x=1696069146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xEq02T/uQIuvtk20d4tWbp/OW6HixVvgi/WsrUctB2M=;
  b=I2Bcxp5eF0sZqmey0HLpaSqocni/OZr6wIklOxFh9RAqhsefzVoVhJ5Z
   RORPMklGZEaFUrLJKHQzhZCWrAaOSnOd7PUUoIO7nuR/LFDHxC1TO4xxP
   hUsJVsacKYRF9kvALHRC2dE0otnwz4cFTpaicAjvX1K4zlRL6nUlek5Wf
   h3ZUoy60OMnPtqWD/dkcPkuIDFbQ6GMsCQZIQ15R75u6iZvgf5eb5+r1j
   0XglukZrGifKNm0+Zs/GIWdeUiXLyRR+7deYGJRj3TE6Lq9dSwsxrSfTx
   gxcrWgoXNZl4s+CHyI9GeG36J4erf40gNxep1HE6fPR1i1R+AWZkyq4Aj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="285294798"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="285294798"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807718"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807718"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 066/105] KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
Date:   Fri, 30 Sep 2022 03:18:00 -0700
Message-Id: <1b16f328c88654df8fda2a5e40f26e7bf14d08a0.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

On entering/exiting TDX vcpu, Preserved or clobbered CPU state is different
from VMX case.  Add TDX hooks to save/restore host/guest CPU state.
Save/restore kernel GS base MSR.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/main.c         | 28 ++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c          | 42 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h          |  4 ++++
 arch/x86/kvm/vmx/x86_ops.h      |  4 ++++
 arch/x86/kvm/x86.c              | 10 ++++++--
 6 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b9ebe82a4c37..18224a3b59a5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2074,6 +2074,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
+void kvm_user_return_msr_init_cpu(void);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index de01b3c79eca..44f9fc9e987b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -100,6 +100,30 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	return vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * All host state is saved/restored across SEAMCALL/SEAMRET, and the
+	 * guest state of a TD is obviously off limits.  Deferring MSRs and DRs
+	 * is pointless because the TDX module needs to load *something* so as
+	 * not to expose guest state.
+	 */
+	if (is_td_vcpu(vcpu)) {
+		tdx_prepare_switch_to_guest(vcpu);
+		return;
+	}
+
+	vmx_prepare_switch_to_guest(vcpu);
+}
+
+static void vt_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_put(vcpu);
+
+	return vmx_vcpu_put(vcpu);
+}
+
 static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -214,9 +238,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_free = vt_vcpu_free,
 	.vcpu_reset = vt_vcpu_reset,
 
-	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
+	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
 	.vcpu_load = vmx_vcpu_load,
-	.vcpu_put = vmx_vcpu_put,
+	.vcpu_put = vt_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e5545608aea5..869cb9952773 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/cpu.h>
+#include <linux/mmu_context.h>
 
 #include <asm/tdx.h>
 
@@ -321,6 +322,8 @@ int tdx_vm_init(struct kvm *kvm)
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
 	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
 	if (!vcpu->arch.apic)
 		return -EINVAL;
@@ -337,9 +340,46 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_state_protected =
 		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
 
+	tdx->host_state_need_save = true;
+	tdx->host_state_need_restore = false;
+
 	return 0;
 }
 
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	kvm_user_return_msr_init_cpu();
+	if (!tdx->host_state_need_save)
+		return;
+
+	if (likely(is_64bit_mm(current->mm)))
+		tdx->msr_host_kernel_gs_base = current->thread.gsbase;
+	else
+		tdx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+
+	tdx->host_state_need_save = false;
+}
+
+static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	tdx->host_state_need_save = true;
+	if (!tdx->host_state_need_restore)
+		return;
+
+	wrmsrl(MSR_KERNEL_GS_BASE, tdx->msr_host_kernel_gs_base);
+	tdx->host_state_need_restore = false;
+}
+
+void tdx_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	vmx_vcpu_pi_put(vcpu);
+	tdx_prepare_switch_to_host(vcpu);
+}
+
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -430,6 +470,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx->host_state_need_restore = true;
+
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 2c850297e8b2..caf837d7f64d 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -86,6 +86,10 @@ struct vcpu_tdx {
 
 	bool vcpu_initialized;
 
+	bool host_state_need_save;
+	bool host_state_need_restore;
+	u64 msr_host_kernel_gs_base;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f28812b7bf98..de94aa189268 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -148,6 +148,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -171,6 +173,8 @@ static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
+static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7046bb601225..9254d2e72c56 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -413,7 +413,7 @@ int kvm_find_user_return_msr(u32 msr)
 }
 EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
 
-static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
+static void __kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
 {
 	u64 value;
 	int i;
@@ -429,12 +429,18 @@ static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
 	msrs->initialized = true;
 }
 
+void kvm_user_return_msr_init_cpu(void)
+{
+	__kvm_user_return_msr_init_cpu(this_cpu_ptr(user_return_msrs));
+}
+EXPORT_SYMBOL_GPL(kvm_user_return_msr_init_cpu);
+
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
 	int err;
 
-	kvm_user_return_msr_init_cpu(msrs);
+	__kvm_user_return_msr_init_cpu(msrs);
 
 	value = (value & mask) | (msrs->values[slot].host & ~mask);
 	if (value == msrs->values[slot].curr)
-- 
2.25.1

