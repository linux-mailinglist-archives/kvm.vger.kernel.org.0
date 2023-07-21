Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F1675BE7B
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjGUGJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjGUGJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:09:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BB42D54;
        Thu, 20 Jul 2023 23:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919743; x=1721455743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NdP2SeUCzPEdFuzwKBKi+sK0rXQVe+hgWiznlOj3LLM=;
  b=Sqyb+VllIsouvOilnlD1Uu154n+oIaBrxePBC+mmZyBVDxzwIRjrMXIW
   YnIAOtQ2cml5sa2otVP8R0tk8a5mFSFAFa/GgAeMJfjsQlw31gdUUrSc9
   GAJlJnLzZh4/zsobAAM4rUqEXUmQyCbIvTAJhs+hzOhCf5azI5bQkv0xv
   5MKEM0UOWGp3ZzxAVH1uMmFWnLQhaP0rZEPAEhmzdxYwqJZRmQSJg4F7t
   WN7XTtLSDlBd8GC03iPMlNMaaCQYO9429D76MUGmeRhTleQ9ewfasf2D+
   dTOy0hMX9XxMl+zuDnuZY4cRsl6NCsog+gDx1SnLk3LLDIA0KTX+GycYC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547616"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547616"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721971"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721971"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 10/20] KVM:x86: Make guest supervisor states as non-XSAVE managed
Date:   Thu, 20 Jul 2023 23:03:42 -0400
Message-Id: <20230721030352.72414-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save and reload guest CET supervisor states, i.e.,PL{0,1,2}_SSP,
when vCPU context is being swapped before and after userspace
<->kernel entry, also do the same operation when vCPU is sched-in
or sched-out.

Enabling CET supervisor state management in KVM due to:
 -Introducing unnecessary XSAVE operation when switch to non-vCPU
userspace within current FPU framework.
 -Forcing allocating additional space for CET supervisor states in
each thread context regardless whether it's vCPU thread or not.

Add a new helper kvm_arch_sched_out() for that purpose. Adding
the support in kvm_arch_vcpu_put/load() without the new helper
looks possible, but the put/load functions are also called in
vcpu_put()/load(), the latter are heavily used in KVM, so adding
new helper makes the implementation clearer.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/arm64/include/asm/kvm_host.h   |  1 +
 arch/mips/include/asm/kvm_host.h    |  1 +
 arch/powerpc/include/asm/kvm_host.h |  1 +
 arch/riscv/include/asm/kvm_host.h   |  1 +
 arch/s390/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                  | 37 +++++++++++++++++++++++++++++
 include/linux/kvm_host.h            |  1 +
 virt/kvm/kvm_main.c                 |  1 +
 8 files changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7e7e19ef6993..98235cb3d258 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1023,6 +1023,7 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 957121a495f0..56c5e85ba5a3 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -893,6 +893,7 @@ static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 14ee0dece853..11587d953bf6 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -880,6 +880,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index ee0acccb1d3b..6ff4a04fe0f2 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -244,6 +244,7 @@ struct kvm_vcpu_arch {
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 2bbc3d54959d..d1750a6a86cf 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1033,6 +1033,7 @@ extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a3753c05c09..f7558f0f6fc0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11212,6 +11212,33 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	trace_kvm_fpu(0);
 }
 
+static void kvm_save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
+		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
+		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
+		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
+		/*
+		 * Omit reset to host PL{1,2}_SSP because Linux will never use
+		 * these MSRs.
+		 */
+		wrmsrl(MSR_IA32_PL0_SSP, 0);
+	}
+	preempt_enable();
+}
+
+static void kvm_reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
+		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
+		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
+		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
+	}
+	preempt_enable();
+}
+
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
@@ -11222,6 +11249,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	kvm_sigset_activate(vcpu);
 	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);
+	kvm_reload_cet_supervisor_ssp(vcpu);
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
@@ -11310,6 +11338,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	r = vcpu_run(vcpu);
 
 out:
+	kvm_save_cet_supervisor_ssp(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	if (kvm_run->kvm_valid_regs)
 		store_regs(vcpu);
@@ -12398,9 +12427,17 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		pmu->need_cleanup = true;
 		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
+
+	kvm_reload_cet_supervisor_ssp(vcpu);
+
 	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
+void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu)
+{
+	kvm_save_cet_supervisor_ssp(vcpu);
+}
+
 void kvm_arch_free_vm(struct kvm *kvm)
 {
 	kfree(to_kvm_hv(kvm)->hv_pa_pg);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d90331f16db1..b3032a5f0641 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1423,6 +1423,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
+void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu);
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 66c1447d3c7f..42f28e8905e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5885,6 +5885,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	kvm_arch_sched_out(vcpu, 0);
 	if (current->on_rq) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
-- 
2.27.0

