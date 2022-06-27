Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B091F55D0C7
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241776AbiF0V4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241442AbiF0VzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5836547;
        Mon, 27 Jun 2022 14:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366899; x=1687902899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SLbQCwT8znjYy8PXe/vjA77B7r9fMxcsTvKOMReM9KU=;
  b=MtzTvQUXsXvEGKPBVP9mewGhyjDwnAThAjkbFrfR1acgeTz4QF1dmojG
   Kk44TooS4WLBdHjRTr4cYG0SwLFQHTGS2GW94v3DyD7QMJP5UkEscR5ld
   sX7nZjSgpZWbj1jwp6WwPlUnGSd1OHeJkN8KfjtSTHJYgeN3x36nM19fX
   ylHPaTfzwi9kyrkH1BUqTvbK4WDo1iF2HbdCq2bQPcrX8DXp1Aakkchik
   y+tP6opuNofNSVJSszPZXh9nctB+5uWpzSFXuNIK+zB+gM8W+sc9tEAOa
   MXLjqnGp5jt77KvsQqEGtf+CPKTmkFATm8nBkocd4KshY3bqxrScqH+oV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116103"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116103"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863643"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 064/102] KVM: TDX: Implement TDX vcpu enter/exit path
Date:   Mon, 27 Jun 2022 14:53:56 -0700
Message-Id: <b3eae6d71e2450ee31ae04f7e9edbe656944871f.1656366338.git.isaku.yamahata@intel.com>
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

This patch implements running TDX vcpu.  Once vcpu runs on the logical
processor (LP), the TDX vcpu is associated with it.  When the TDX vcpu
moves to another LP, the TDX vcpu needs to flush its status on the LP.
When destroying TDX vcpu, it needs to complete flush and flush cpu memory
cache.  Track which LP the TDX vcpu run and flush it as necessary.

Do nothing on sched_in event as TDX doesn't support pause loop.

TDX vcpu execution requires restoring PMU debug store after returning back
to KVM because the TDX module unconditionally resets the value.  To reuse
the existing code, export perf_restore_debug_store.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 21 +++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 arch/x86/kvm/x86.c         |  1 +
 5 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 442d89e02459..099842a8a397 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -110,6 +110,23 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	return vmx_vcpu_reset(vcpu, init_event);
 }
 
+static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		/* Unconditionally continue to vcpu_run(). */
+		return 1;
+
+	return vmx_vcpu_pre_run(vcpu);
+}
+
+static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_run(vcpu);
+
+	return vmx_vcpu_run(vcpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -222,8 +239,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.flush_tlb_gva = vt_flush_tlb_gva,
 	.flush_tlb_guest = vt_flush_tlb_guest,
 
-	.vcpu_pre_run = vmx_vcpu_pre_run,
-	.vcpu_run = vmx_vcpu_run,
+	.vcpu_pre_run = vt_vcpu_pre_run,
+	.vcpu_run = vt_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d2688bb8e5fa..e13b1c8caa39 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -10,6 +10,9 @@
 #include "vmx.h"
 #include "x86.h"
 
+#include <trace/events/kvm.h>
+#include "trace.h"
+
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
 
@@ -552,6 +555,35 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->kvm->vm_bugged = true;
 }
 
+u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
+
+static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
+					struct vcpu_tdx *tdx)
+{
+	guest_enter_irqoff();
+	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs, 0);
+	guest_exit_irqoff();
+}
+
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (unlikely(vcpu->kvm->vm_bugged)) {
+		tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
+		return EXIT_FASTPATH_NONE;
+	}
+
+	trace_kvm_entry(vcpu);
+
+	tdx_vcpu_enter_exit(vcpu, tdx);
+
+	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
+	trace_kvm_exit(vcpu, KVM_ISA_VMX);
+
+	return EXIT_FASTPATH_NONE;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 29e7accee733..f90f83b22d25 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -48,12 +48,45 @@ struct kvm_tdx {
 	spinlock_t seamcall_lock;
 };
 
+union tdx_exit_reason {
+	struct {
+		/* 31:0 mirror the VMX Exit Reason format */
+		u64 basic		: 16;
+		u64 reserved16		: 1;
+		u64 reserved17		: 1;
+		u64 reserved18		: 1;
+		u64 reserved19		: 1;
+		u64 reserved20		: 1;
+		u64 reserved21		: 1;
+		u64 reserved22		: 1;
+		u64 reserved23		: 1;
+		u64 reserved24		: 1;
+		u64 reserved25		: 1;
+		u64 bus_lock_detected	: 1;
+		u64 enclave_mode	: 1;
+		u64 smi_pending_mtf	: 1;
+		u64 smi_from_vmx_root	: 1;
+		u64 reserved30		: 1;
+		u64 failed_vmentry	: 1;
+
+		/* 63:32 are TDX specific */
+		u64 details_l1		: 8;
+		u64 class		: 8;
+		u64 reserved61_48	: 14;
+		u64 non_recoverable	: 1;
+		u64 error		: 1;
+	};
+	u64 full;
+};
+
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page *tdvpx;
 
+	union tdx_exit_reason exit_reason;
+
 	bool initialized;
 
 	/*
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2c55aea8963f..ea34671cd23f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -141,6 +141,7 @@ void tdx_vm_free(struct kvm *kvm);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -161,6 +162,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c90ec611de2f..70312e195f36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -300,6 +300,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 };
 
 u64 __read_mostly host_xcr0;
+EXPORT_SYMBOL_GPL(host_xcr0);
 
 static struct kmem_cache *x86_emulator_cache;
 
-- 
2.25.1

