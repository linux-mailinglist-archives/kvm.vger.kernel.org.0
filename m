Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8679667B99
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240932AbjALQns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240316AbjALQir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBCF1CFDD;
        Thu, 12 Jan 2023 08:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541248; x=1705077248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R0Hplyw7yEPnWIXTN/BB3x9pMmj9BhBxuKEGsvOCFK0=;
  b=lqxEuNp2kaU7tlUdwHhDofAoxeDy1SojKP0UsCs3+Xk9HxEc5M0zr2/q
   o2m6E/sFXslsQO+y9JKrH6MKLG6cC6J679e5j7I6lgSMpWgu9ZwT4SuML
   w3ZHhfv/MKD/qZ7rpP31aGQGUPj+u/C8Y9zENeydZOfdEuOz5ukykAswq
   VbxbvMBrLs6aTvMJwdttHRrM7mT8A2f3CO3Nq8bQabRr27c1AfPNetzab
   rAJK2tqrPeniOXD6QGMJ3LqqeshLATxvMURS9wHFdEpkg5lcVC5lLrdLB
   m8EAeZgFeWTRGZYg8LH4NHaQGY4SqQrTD0Ay6CW6d78xuGjE+xgr/pUkO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811979"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811979"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151866"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151866"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 066/113] KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
Date:   Thu, 12 Jan 2023 08:32:14 -0800
Message-Id: <4f9dc026cfeffcf53a07d2959d101b5231a10325.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/vmx/main.c    | 28 ++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 40 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |  4 ++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ac2dc05961b5..f4b20974199f 100644
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
@@ -223,9 +247,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index 53a8c6fcc263..854aa4af4937 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/cpu.h>
+#include <linux/mmu_context.h>
 
 #include <asm/tdx.h>
 
@@ -333,6 +334,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	struct kvm_cpuid_entry2 *e;
 
 	/*
@@ -372,9 +374,45 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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
@@ -445,6 +483,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx->host_state_need_restore = true;
+
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 4912fbeed1c4..63916388fdcf 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -66,6 +66,10 @@ struct vcpu_tdx {
 
 	bool vcpu_initialized;
 
+	bool host_state_need_save;
+	bool host_state_need_restore;
+	u64 msr_host_kernel_gs_base;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b9b2d4fd99e5..f5ee5efd7cf6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -155,6 +155,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
@@ -179,6 +181,8 @@ static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
+static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

