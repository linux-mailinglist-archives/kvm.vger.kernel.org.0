Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E3D3B0082
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 11:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhFVJpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 05:45:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:20208 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhFVJpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 05:45:41 -0400
IronPort-SDR: jc1rrm9Avvs9uH3fgf6rKx0YpUnzQYQAOuSrvW9WZL25hfq6a7go0ZrTaNwpR6tRrP17wy5LAl
 Mcf+ApvP2ghQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="194330921"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="194330921"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:43:23 -0700
IronPort-SDR: YT0UXablTbHFjVGOUphLdQZI3IoiFPL8yBc2UqJr8G7mpfASBqseVxlrWsQj5BcIMDyWLT+dx2
 b78pMKFrVOjA==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="641600114"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:43:17 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        weijiang.yang@intel.com, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        Like Xu <like.xu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V7 01/18] perf/core: Use static_call to optimize perf_guest_info_callbacks
Date:   Tue, 22 Jun 2021 17:42:49 +0800
Message-Id: <20210622094306.8336-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210622094306.8336-1-lingshan.zhu@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

For "struct perf_guest_info_callbacks", the two fields "is_in_guest"
and "is_user_mode" are replaced with a new multiplexed member named
"state", and the "get_guest_ip" field will be renamed to "get_ip".

For arm64, xen and kvm/x86, the application of DEFINE_STATIC_CALL_RET0
could make all that perf_guest_cbs stuff suck less. For arm, csky, nds32,
and riscv, just applied some renamed refactoring.

Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-csky@vger.kernel.org
Cc: linux-riscv@lists.infradead.org
Cc: xen-devel@lists.xenproject.org
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Original-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 arch/arm/kernel/perf_callchain.c   | 16 ++++++++-----
 arch/arm64/kernel/perf_callchain.c | 29 ++++++++++++++++++-----
 arch/arm64/kvm/perf.c              | 22 ++++++++---------
 arch/csky/kernel/perf_callchain.c  |  4 ++--
 arch/nds32/kernel/perf_event_cpu.c | 16 ++++++++-----
 arch/riscv/kernel/perf_callchain.c |  4 ++--
 arch/x86/events/core.c             | 38 ++++++++++++++++++++++++------
 arch/x86/events/intel/core.c       |  7 +++---
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/pmu.c                 |  2 +-
 arch/x86/kvm/x86.c                 | 37 ++++++++++++++++-------------
 arch/x86/xen/pmu.c                 | 33 +++++++++++---------------
 include/linux/perf_event.h         | 12 ++++++----
 kernel/events/core.c               |  9 +++++++
 14 files changed, 144 insertions(+), 87 deletions(-)

diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
index 3b69a76d341e..1ce30f86d6c7 100644
--- a/arch/arm/kernel/perf_callchain.c
+++ b/arch/arm/kernel/perf_callchain.c
@@ -64,7 +64,7 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
 {
 	struct frame_tail __user *tail;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (perf_guest_cbs && perf_guest_cbs->state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -100,7 +100,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 {
 	struct stackframe fr;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (perf_guest_cbs && perf_guest_cbs->state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -111,8 +111,8 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		return perf_guest_cbs->get_guest_ip();
+	if (perf_guest_cbs && perf_guest_cbs->state())
+		return perf_guest_cbs->get_ip();
 
 	return instruction_pointer(regs);
 }
@@ -120,9 +120,13 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
 	int misc = 0;
+	unsigned int state = 0;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
-		if (perf_guest_cbs->is_user_mode())
+	if (perf_guest_cbs)
+		state = perf_guest_cbs->state();
+
+	if (perf_guest_cbs && state) {
+		if (state & PERF_GUEST_USER)
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 88ff471b0bce..5df2bd5d12ba 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2015 ARM Limited
  */
 #include <linux/perf_event.h>
+#include <linux/static_call.h>
 #include <linux/uaccess.h>
 
 #include <asm/pointer_auth.h>
@@ -99,10 +100,25 @@ compat_user_backtrace(struct compat_frame_tail __user *tail,
 }
 #endif /* CONFIG_COMPAT */
 
+DEFINE_STATIC_CALL_RET0(arm64_guest_state, *(perf_guest_cbs->state));
+DEFINE_STATIC_CALL_RET0(arm64_guest_get_ip, *(perf_guest_cbs->get_ip));
+
+void arch_perf_update_guest_cbs(void)
+{
+	static_call_update(arm64_guest_state, (void *)&__static_call_return0);
+	static_call_update(arm64_guest_get_ip, (void *)&__static_call_return0);
+
+	if (perf_guest_cbs && perf_guest_cbs->state)
+		static_call_update(arm64_guest_state, perf_guest_cbs->state);
+
+	if (perf_guest_cbs && perf_guest_cbs->get_ip)
+		static_call_update(arm64_guest_get_ip, perf_guest_cbs->get_ip);
+}
+
 void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 			 struct pt_regs *regs)
 {
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (static_call(arm64_guest_state)()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -149,7 +165,7 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 {
 	struct stackframe frame;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (static_call(arm64_guest_state)()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -160,8 +176,8 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		return perf_guest_cbs->get_guest_ip();
+	if (static_call(arm64_guest_state)())
+		return static_call(arm64_guest_get_ip)();
 
 	return instruction_pointer(regs);
 }
@@ -169,9 +185,10 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
 	int misc = 0;
+	unsigned int guest = static_call(arm64_guest_state)();
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
-		if (perf_guest_cbs->is_user_mode())
+	if (guest) {
+		if (guest & PERF_GUEST_USER)
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
index 151c31fb9860..8a3387e58f42 100644
--- a/arch/arm64/kvm/perf.c
+++ b/arch/arm64/kvm/perf.c
@@ -13,21 +13,20 @@
 
 DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 
-static int kvm_is_in_guest(void)
-{
-        return kvm_get_running_vcpu() != NULL;
-}
-
-static int kvm_is_user_mode(void)
+static unsigned int kvm_guest_state(void)
 {
 	struct kvm_vcpu *vcpu;
+	unsigned int state = 0;
+
+	if (kvm_get_running_vcpu())
+		state |= PERF_GUEST_ACTIVE;
 
 	vcpu = kvm_get_running_vcpu();
 
-	if (vcpu)
-		return !vcpu_mode_priv(vcpu);
+	if (vcpu && !vcpu_mode_priv(vcpu))
+		state |= PERF_GUEST_USER;
 
-	return 0;
+	return state;
 }
 
 static unsigned long kvm_get_guest_ip(void)
@@ -43,9 +42,8 @@ static unsigned long kvm_get_guest_ip(void)
 }
 
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest	= kvm_is_in_guest,
-	.is_user_mode	= kvm_is_user_mode,
-	.get_guest_ip	= kvm_get_guest_ip,
+	.state		= kvm_guest_state,
+	.get_ip		= kvm_get_guest_ip,
 };
 
 int kvm_perf_init(void)
diff --git a/arch/csky/kernel/perf_callchain.c b/arch/csky/kernel/perf_callchain.c
index ab55e98ee8f6..3e42239dd1b2 100644
--- a/arch/csky/kernel/perf_callchain.c
+++ b/arch/csky/kernel/perf_callchain.c
@@ -89,7 +89,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 	unsigned long fp = 0;
 
 	/* C-SKY does not support virtualization. */
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
+	if (perf_guest_cbs && perf_guest_cbs->state())
 		return;
 
 	fp = regs->regs[4];
@@ -113,7 +113,7 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 	struct stackframe fr;
 
 	/* C-SKY does not support virtualization. */
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (perf_guest_cbs && perf_guest_cbs->state()) {
 		pr_warn("C-SKY does not support perf in guest mode!");
 		return;
 	}
diff --git a/arch/nds32/kernel/perf_event_cpu.c b/arch/nds32/kernel/perf_event_cpu.c
index 0ce6f9f307e6..1dc32ba842ce 100644
--- a/arch/nds32/kernel/perf_event_cpu.c
+++ b/arch/nds32/kernel/perf_event_cpu.c
@@ -1371,7 +1371,7 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 
 	leaf_fp = 0;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (perf_guest_cbs && perf_guest_cbs->state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -1481,7 +1481,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 {
 	struct stackframe fr;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (perf_guest_cbs && perf_guest_cbs->state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -1494,8 +1494,8 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	/* However, NDS32 does not support virtualization */
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		return perf_guest_cbs->get_guest_ip();
+	if (perf_guest_cbs && perf_guest_cbs->state())
+		return perf_guest_cbs->get_ip();
 
 	return instruction_pointer(regs);
 }
@@ -1503,10 +1503,14 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
 	int misc = 0;
+	unsigned int state = 0;
+
+	if (perf_guest_cbs)
+		state = perf_guest_cbs->state();
 
 	/* However, NDS32 does not support virtualization */
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
-		if (perf_guest_cbs->is_user_mode())
+	if (perf_guest_cbs && state) {
+		if (state & PERF_GUEST_USER)
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
index 0bb1854dce83..ea63f70cae5d 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -59,7 +59,7 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 	unsigned long fp = 0;
 
 	/* RISC-V does not support perf in guest mode. */
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
+	if (perf_guest_cbs && perf_guest_cbs->state())
 		return;
 
 	fp = regs->s0;
@@ -79,7 +79,7 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
 	/* RISC-V does not support perf in guest mode. */
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (perf_guest_cbs && perf_guest_cbs->state()) {
 		pr_warn("RISC-V does not support perf in guest mode!");
 		return;
 	}
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 8f71dd72ef95..c71af4cfba9b 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -90,6 +90,27 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
  */
 DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
 
+DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
+DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
+DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
+
+void arch_perf_update_guest_cbs(void)
+{
+	static_call_update(x86_guest_state, (void *)&__static_call_return0);
+	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0);
+	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
+
+	if (perf_guest_cbs && perf_guest_cbs->state)
+		static_call_update(x86_guest_state, perf_guest_cbs->state);
+
+	if (perf_guest_cbs && perf_guest_cbs->get_ip)
+		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
+
+	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
+		static_call_update(x86_guest_handle_intel_pt_intr,
+				   perf_guest_cbs->handle_intel_pt_intr);
+}
+
 u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -2738,7 +2759,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 	struct unwind_state state;
 	unsigned long addr;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (static_call(x86_guest_state)()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2841,7 +2862,7 @@ perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs
 	struct stack_frame frame;
 	const struct stack_frame __user *fp;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+	if (static_call(x86_guest_state)()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2918,18 +2939,21 @@ static unsigned long code_segment_base(struct pt_regs *regs)
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
-		return perf_guest_cbs->get_guest_ip();
+	unsigned long ip = static_call(x86_guest_get_ip)();
+
+	if (likely(!ip))
+		ip = regs->ip + code_segment_base(regs);
 
-	return regs->ip + code_segment_base(regs);
+	return ip;
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
+	unsigned int guest = static_call(x86_guest_state)();
 	int misc = 0;
 
-	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
-		if (perf_guest_cbs->is_user_mode())
+	if (guest) {
+		if (guest & PERF_GUEST_USER)
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
 			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index e28892270c58..430f5743f3ca 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2780,6 +2780,8 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
 }
 
+DECLARE_STATIC_CALL(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
+
 static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
 	struct perf_sample_data data;
@@ -2850,10 +2852,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 */
 	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
 		handled++;
-		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
-			perf_guest_cbs->handle_intel_pt_intr))
-			perf_guest_cbs->handle_intel_pt_intr();
-		else
+		if (!static_call(x86_guest_handle_intel_pt_intr)())
 			intel_pt_interrupt();
 	}
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c7ced0e3171..f752fcf56d76 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1813,7 +1813,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
-int kvm_is_in_guest(void);
+unsigned int kvm_guest_state(void);
 
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 827886c12c16..2dcbd1b30004 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -87,7 +87,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 		 * woken up. So we should wake it, but this is impossible from
 		 * NMI context. Do it from irq work instead.
 		 */
-		if (!kvm_is_in_guest())
+		if (!kvm_guest_state())
 			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 		else
 			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b594275d49b5..9cb1c02d348c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8035,44 +8035,47 @@ static void kvm_timer_init(void)
 DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
 
-int kvm_is_in_guest(void)
+unsigned int kvm_guest_state(void)
 {
-	return __this_cpu_read(current_vcpu) != NULL;
-}
-
-static int kvm_is_user_mode(void)
-{
-	int user_mode = 3;
+	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	unsigned int state = 0;
 
-	if (__this_cpu_read(current_vcpu))
-		user_mode = static_call(kvm_x86_get_cpl)(__this_cpu_read(current_vcpu));
+	if (vcpu) {
+		state |= PERF_GUEST_ACTIVE;
+		if (static_call(kvm_x86_get_cpl)(vcpu))
+			state |= PERF_GUEST_USER;
+	}
 
-	return user_mode != 0;
+	return state;
 }
 
-static unsigned long kvm_get_guest_ip(void)
+static unsigned long kvm_guest_get_ip(void)
 {
+	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 	unsigned long ip = 0;
 
-	if (__this_cpu_read(current_vcpu))
-		ip = kvm_rip_read(__this_cpu_read(current_vcpu));
+	if (vcpu)
+		ip = kvm_rip_read(vcpu);
 
 	return ip;
 }
 
-static void kvm_handle_intel_pt_intr(void)
+static unsigned int kvm_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 
+	if (!vcpu)
+		return 0;
+
 	kvm_make_request(KVM_REQ_PMI, vcpu);
 	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
 			(unsigned long *)&vcpu->arch.pmu.global_status);
+	return 1;
 }
 
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest		= kvm_is_in_guest,
-	.is_user_mode		= kvm_is_user_mode,
-	.get_guest_ip		= kvm_get_guest_ip,
+	.state			= kvm_guest_state,
+	.get_ip			= kvm_guest_get_ip,
 	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
 };
 
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index e13b0b49fcdf..7352cf002b87 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -413,34 +413,30 @@ int pmu_apic_update(uint32_t val)
 }
 
 /* perf callbacks */
-static int xen_is_in_guest(void)
+static unsigned int xen_guest_state(void)
 {
 	const struct xen_pmu_data *xenpmu_data = get_xenpmu_data();
+	unsigned int state = 0;
 
 	if (!xenpmu_data) {
 		pr_warn_once("%s: pmudata not initialized\n", __func__);
-		return 0;
+		return state;
 	}
 
 	if (!xen_initial_domain() || (xenpmu_data->domain_id >= DOMID_SELF))
-		return 0;
-
-	return 1;
-}
+		return state;
 
-static int xen_is_user_mode(void)
-{
-	const struct xen_pmu_data *xenpmu_data = get_xenpmu_data();
+	state |= PERF_GUEST_ACTIVE;
 
-	if (!xenpmu_data) {
-		pr_warn_once("%s: pmudata not initialized\n", __func__);
-		return 0;
+	if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_PV) {
+		if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_USER)
+			state |= PERF_GUEST_USER;
+	} else {
+		if (!!(xenpmu_data->pmu.r.regs.cpl & 3))
+			state |= PERF_GUEST_USER;
 	}
 
-	if (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_PV)
-		return (xenpmu_data->pmu.pmu_flags & PMU_SAMPLE_USER);
-	else
-		return !!(xenpmu_data->pmu.r.regs.cpl & 3);
+	return state;
 }
 
 static unsigned long xen_get_guest_ip(void)
@@ -456,9 +452,8 @@ static unsigned long xen_get_guest_ip(void)
 }
 
 static struct perf_guest_info_callbacks xen_guest_cbs = {
-	.is_in_guest            = xen_is_in_guest,
-	.is_user_mode           = xen_is_user_mode,
-	.get_guest_ip           = xen_get_guest_ip,
+	.state                  = xen_guest_state,
+	.get_ip			= xen_get_guest_ip,
 };
 
 /* Convert registers from Xen's format to Linux' */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f5a6a2f069ed..8065e5f093f4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -26,11 +26,13 @@
 # include <asm/local64.h>
 #endif
 
+#define PERF_GUEST_ACTIVE	0x01
+#define PERF_GUEST_USER	0x02
+
 struct perf_guest_info_callbacks {
-	int				(*is_in_guest)(void);
-	int				(*is_user_mode)(void);
-	unsigned long			(*get_guest_ip)(void);
-	void				(*handle_intel_pt_intr)(void);
+	unsigned int			(*state)(void);
+	unsigned long			(*get_ip)(void);
+	unsigned int			(*handle_intel_pt_intr)(void);
 };
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
@@ -1237,6 +1239,8 @@ extern void perf_event_bpf_event(struct bpf_prog *prog,
 				 u16 flags);
 
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
+extern void __weak arch_perf_update_guest_cbs(void);
+
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6fee4a7e88d7..101fa7d0bfda 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6479,9 +6479,18 @@ static void perf_pending_event(struct irq_work *entry)
  */
 struct perf_guest_info_callbacks *perf_guest_cbs;
 
+/* explicitly use __weak to fix duplicate symbol error */
+void __weak arch_perf_update_guest_cbs(void)
+{
+}
+
 int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 {
+	if (WARN_ON_ONCE(perf_guest_cbs))
+		return -EBUSY;
+
 	perf_guest_cbs = cbs;
+	arch_perf_update_guest_cbs();
 	return 0;
 }
 EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
-- 
2.27.0

