Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DEA667B91
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbjALQnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbjALQir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CEE1CB1F;
        Thu, 12 Jan 2023 08:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541248; x=1705077248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RdmlyanURZCyWYRamAQC2SeSkRr1PQ56a93uIOY89Yo=;
  b=ObGj6H4s3bnLqgJLs+put2Hwc4lnn1+9V5UkJhgEUuGnY3vai7t+Ycgh
   iPzzcuW8tf8V9zEroGM7Yfjkxkza0qIUj4wiVKNOB/o80s0JB3e9zXD/H
   xshwLVmJ4DviIUdPY9ba8UAjnTXXJQzitpXAJ4Ek3l+hWyYUawsK5/rT4
   pCvam8n7RnLBrRke4hxecM7fVfTsC6WlpClyoS2zsM1pGvDjRpMihiC2F
   PPGegCOXNylYZGbAN4Ts74Zvo7gJoFNg6h/zANPFMDoc43SAiNa914Pyf
   H95V23kPpE3/3ZBTBUUxexAINeVlxJhR8bHtdNj0aAKxaU4N1OtGvt7EH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811974"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811974"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151863"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151863"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 065/113] KVM: TDX: Implement TDX vcpu enter/exit path
Date:   Thu, 12 Jan 2023 08:32:13 -0800
Message-Id: <3d67321fe13c9b57454821f457ec148448e7275c.1673539699.git.isaku.yamahata@intel.com>
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
index 4319f6d7a4da..ac2dc05961b5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -100,6 +100,23 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -241,8 +258,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index d04e2729d2a3..53a8c6fcc263 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -10,6 +10,9 @@
 #include "x86.h"
 #include "mmu.h"
 
+#include <trace/events/kvm.h>
+#include "trace.h"
+
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -419,6 +422,35 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->kvm->vm_bugged = true;
 }
 
+u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
+
+static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
+					struct vcpu_tdx *tdx)
+{
+	guest_enter_irqoff();
+	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr_pa, vcpu->arch.regs, 0);
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
index d8b4102c67fc..4912fbeed1c4 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -25,12 +25,45 @@ struct kvm_tdx {
 	u64 tsc_offset;
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
 
 	unsigned long tdvpr_pa;
 	unsigned long *tdvpx_pa;
 
+	union tdx_exit_reason exit_reason;
+
 	bool vcpu_initialized;
 
 	/*
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d903e0f606d3..b9b2d4fd99e5 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -154,6 +154,7 @@ void tdx_vm_free(struct kvm *kvm);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
@@ -177,6 +178,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4579e696d39..7785225f03ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -305,6 +305,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 };
 
 u64 __read_mostly host_xcr0;
+EXPORT_SYMBOL_GPL(host_xcr0);
 
 static struct kmem_cache *x86_emulator_cache;
 
-- 
2.25.1

