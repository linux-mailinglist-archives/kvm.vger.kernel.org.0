Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D3155E319
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbiF0V4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241496AbiF0Vz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F5565B5;
        Mon, 27 Jun 2022 14:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366900; x=1687902900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fwA1sd1VXvVvw+tA83GmswLMuaAb0B6ZtOOy1PBRsGU=;
  b=gJhl7MlQ+FR6EyWUWvBimDEm2eb3FejuXsi4wln/LoGY+w5hycDVBbIQ
   KBnAMxf8VKROuTt1VHClte21nvDzoT3ussXXPjfZVRfjJ3sqkrkaxsocw
   iETlXKvd17eBZ4fGMtgx+i87QvCewRxshyk1tzS+HeHzp3a9cOndHiY/M
   YrYxxQLq4qy9B3ddlhXFWMLzIPFEdIHYRaFpKi2Hnnn3iffkFhbNk/JO6
   CE9bFJfUM4o+EWhptpt3AJqkUKRnSLv1qrnmQN/Pa++qCcGO3So/iPnCH
   3FhckMD6GoDHIlUP7nkhpzc6aHOsk1b8e/SYGUE+qzXVkJKvzo6xVaY5Z
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116104"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116104"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863646"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 065/102] KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
Date:   Mon, 27 Jun 2022 14:53:57 -0700
Message-Id: <2b8f650785f316ab0f5327ea95165bcd8ebb2612.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c    | 28 +++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 39 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |  4 ++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 099842a8a397..f101f358d90c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -110,6 +110,30 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -206,9 +230,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index e13b1c8caa39..d9e0dd30c150 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/cpu.h>
+#include <linux/mmu_context.h>
 
 #include <asm/tdx.h>
 
@@ -463,6 +464,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_state_protected =
 		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
 
+	tdx->host_state_need_save = true;
+	tdx->host_state_need_restore = false;
+
 	return 0;
 
 free_tdvpx:
@@ -476,6 +480,39 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	return ret;
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
@@ -578,6 +615,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx->host_state_need_restore = true;
+
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index f90f83b22d25..414c15235ed0 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -89,6 +89,10 @@ struct vcpu_tdx {
 
 	bool initialized;
 
+	bool host_state_need_save;
+	bool host_state_need_restore;
+	u64 msr_host_kernel_gs_base;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ea34671cd23f..2213739c2303 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -142,6 +142,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -163,6 +165,8 @@ static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
+static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

