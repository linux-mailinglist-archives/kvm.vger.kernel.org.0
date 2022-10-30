Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D188612837
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiJ3G3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiJ3G12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:27:28 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7E7D8;
        Sat, 29 Oct 2022 23:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111067; x=1698647067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l77jQ4gJS+CcJ3+mZO3jl3ANs87zjcLaB5TTLAVX6b4=;
  b=Yd9XzP+oudAd8wISj+R4aCPyTQ1LIkA+uq2t5gcBYZxEi7IejKkZ2ddS
   IkSZICllJMYbbgOwkHV546PrfvXFl1PJ1qYs3TmXBh6ZKSmqVwj4dhxGR
   mwyTBUqXa+1IB618fWFdq7tffUIZ4xVUA2ygx6kYVZ8IlKFOIABH51IAN
   qCn4TRql7Yrn0TQX/8Xrhv/E2AplmDGodyGi9FxvY1Bf/wBzg5EZhHoic
   GUD3vYvr4UQNzMd7WD4DAaMmXF0CdluwaThf/MUXBW2USt9JrcRRFSNpK
   Y62oYWpeaCInAu2pbGQS+yKr9NKqbwmIIxQTetS1B3SfU99qq38tKW4nG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037182"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037182"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393067"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393067"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:08 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 069/108] KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
Date:   Sat, 29 Oct 2022 23:23:10 -0700
Message-Id: <4bd691b93fc90f5cad66688e12e671ad12d4c913.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 5f9634c130d0..b225cdfac4bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2080,6 +2080,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
+void kvm_user_return_msr_init_cpu(void);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 252c33820271..379b3343557b 100644
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
index 2f57f62eb103..021040fdd630 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/cpu.h>
+#include <linux/mmu_context.h>
 
 #include <asm/tdx.h>
 
@@ -329,6 +330,8 @@ int tdx_vm_init(struct kvm *kvm)
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
 	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
 	if (!vcpu->arch.apic)
 		return -EINVAL;
@@ -345,9 +348,46 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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
@@ -438,6 +478,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx->host_state_need_restore = true;
+
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 064e1f2f61d5..e5f973b2d752 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -72,6 +72,10 @@ struct vcpu_tdx {
 
 	bool vcpu_initialized;
 
+	bool host_state_need_save;
+	bool host_state_need_restore;
+	u64 msr_host_kernel_gs_base;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ccae338dcfdd..a4e50c5a4bf5 100644
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
index 3662f64f3b5e..65541bfebb37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -418,7 +418,7 @@ int kvm_find_user_return_msr(u32 msr)
 }
 EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
 
-static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
+static void __kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
 {
 	u64 value;
 	int i;
@@ -434,12 +434,18 @@ static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
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

