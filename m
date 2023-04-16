Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011FB6E3515
	for <lists+kvm@lfdr.de>; Sun, 16 Apr 2023 06:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjDPEyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Apr 2023 00:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjDPEx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Apr 2023 00:53:56 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7672D79
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 21:53:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1a682ad2f8cso3502675ad.1
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 21:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681620834; x=1684212834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VMTDeZwh9/grD0gErG9YU5jhGrRVgshTp/o9TkkizoE=;
        b=6mjBhXEnOVj0mJPIE+HvGuFO0mlKW314KgvPQGrpUgHQRjQAeuRVyFEpoAeHsldQg5
         WOmp4/nLJcTMLVROM2QGULQY1FHtUU4/VP6xgTGicDK+WJA31QBPaTwrulRYnJws8OOu
         0MfnFtpsn7zTVcgc6CHI0aNdhiqVGPmRf2t380xktetwqAgGILbi6IG74cX0dd1aTklL
         aRh74dYgYCTqGZ5kaPTHLavCv8ctsoISgxGf61T6ihn48pEUHtMhUCrQGupRETRs3mRc
         FSeVS1dcUhySXaCDKC/ACq+gTDROu/zmasXiFoVdneA3JT4y4+fHN5tSy/AXLh3lhlrP
         +ecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681620834; x=1684212834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VMTDeZwh9/grD0gErG9YU5jhGrRVgshTp/o9TkkizoE=;
        b=U1zpqlnDfr0F9hncgZULWW6+AIZcc+w0rwzK2w1PWK24ceBbnw201NLqAlj4yVJsTG
         QP87gnkMCT23zqfZyhnI5QwHSJO+glPwe35d4iXA7Bz9cpZ5G9xEBiSKatkSI1+yDfoZ
         mZBA898yuYGvtU5QBHB6GwNUa1E2ySrMSnUgaMU52ACks4TcJzji7SFOBN2l8XtecnCM
         C0VMpDra4PUF2HGn6ORSQWGe3O1NVSJiA2+wmGoGS6hUABNrBccacgyulYIw++tmPQfv
         76xD2tjusr/uzAVnvZVSEzXCFbKV32X0X2/bVZ0Ov7/z9z7k8KT8PEXvgkKZv9+Kxx4f
         wioA==
X-Gm-Message-State: AAQBX9cGL5J3Xp4Ih9IVJXyiAHSpn0jkFH0ljDgzMbFCIHbs/XV1ghl/
        Fl55W9OwVRr6wc7Ep3Lf5vvp8S08Y8k=
X-Google-Smtp-Source: AKy350adYnpwquKs5u8XpxsLbgnVKuP8weSf0ElM94XiI/RcQMBOdqACbZtcVbYpYyKSLA2MSnJakpqPwiA=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:181f:b0:62d:afc6:c152 with SMTP id
 y31-20020a056a00181f00b0062dafc6c152mr5669836pfa.5.1681620834123; Sat, 15 Apr
 2023 21:53:54 -0700 (PDT)
Date:   Sat, 15 Apr 2023 21:53:16 -0700
In-Reply-To: <20230416045316.1367849-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230416045316.1367849-1-reijiw@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230416045316.1367849-3-reijiw@google.com>
Subject: [PATCH v4 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, with VHE, KVM sets ER, CR, SW and EN bits of
PMUSERENR_EL0 to 1 on vcpu_load(), and saves and restores
the register value for the host on vcpu_load() and vcpu_put().
If the value of those bits are cleared on a pCPU with a vCPU
loaded (armv8pmu_start() would do that when PMU counters are
programmed for the guest), PMU access from the guest EL0 might
be trapped to the guest EL1 directly regardless of the current
PMUSERENR_EL0 value of the vCPU.

Fix this by not letting armv8pmu_start() overwrite PMUSERENR_EL0
on the pCPU where PMUSERENR_EL0 for the guest is loaded, and
instead updating the saved shadow register value for the host,
so that the value can be restored on vcpu_put() later.
While vcpu_{put,load}() are manipulating PMUSERENR_EL0, disable
IRQs to prevent a race condition between these processes and IPIs
that attempt to update PMUSERENR_EL0 for the host EL0.
As this change (disabling IRQs) is applied to the nVHE hyp code,
unwanted code (e.g. trace_hardirqs_off, etc) will be included in the
hyp code when CONFIG_TRACE_IRQFLAGS and/or CONFIG_DEBUG_IRQFLAGS
are enabled.  Introduce NO_TRACE_IRQFLAGS and NO_DEBUG_IRQFLAGS
macros to locally disable CONFIG_TRACE_IRQFLAGS or
CONFIG_DEBUG_IRQFLAGS in the nVHE hyp code.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  7 +++++++
 arch/arm64/kernel/perf_event.c          | 21 ++++++++++++++++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
 arch/arm64/kvm/pmu.c                    | 25 +++++++++++++++++++++++++
 include/linux/irqflags.h                |  6 +++---
 6 files changed, 78 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..c49cfda2740a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -668,6 +668,8 @@ struct kvm_vcpu_arch {
 /* Software step state is Active-pending */
 #define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
 
+/* PMUSERENR for the guest EL0 is on physical CPU */
+#define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(6))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -1028,9 +1030,14 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u32 clr);
+bool kvm_set_pmuserenr(u64 val);
 #else
 static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u32 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
 #endif
 
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index dde06c0f97f3..33bb5f548f8a 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -741,9 +741,25 @@ static inline u32 armv8pmu_getreset_flags(void)
 	return value;
 }
 
+static void update_pmuserenr(u64 val)
+{
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * The current PMUSERENR_EL0 value might be the value for the guest.
+	 * If that's the case, have KVM keep tracking of the register value
+	 * for the host EL0 so that KVM can restore it before returning to
+	 * the host EL0. Otherwise, update the register now.
+	 */
+	if (kvm_set_pmuserenr(val))
+		return;
+
+	write_sysreg(val, pmuserenr_el0);
+}
+
 static void armv8pmu_disable_user_access(void)
 {
-	write_sysreg(0, pmuserenr_el0);
+	update_pmuserenr(0);
 }
 
 static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
@@ -759,8 +775,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 			armv8pmu_write_evcntr(i, 0);
 	}
 
-	write_sysreg(0, pmuserenr_el0);
-	write_sysreg(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR, pmuserenr_el0);
+	update_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
 }
 
 static void armv8pmu_enable_event(struct perf_event *event)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6718731729fd..7e73be12cfaf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -82,12 +82,24 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_arm_support_pmu_v3()) {
 		struct kvm_cpu_context *hctxt;
+		unsigned long flags;
 
 		write_sysreg(0, pmselr_el0);
 
 		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+
+		/*
+		 * Disable IRQs to prevent a race condition between the
+		 * following code and IPIs that attempts to update
+		 * PMUSERENR_EL0. See also kvm_set_pmuserenr().
+		 */
+		local_irq_save(flags);
+
 		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
+
+		local_irq_restore(flags);
 	}
 
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
@@ -112,9 +124,21 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3()) {
 		struct kvm_cpu_context *hctxt;
+		unsigned long flags;
 
 		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+
+		/*
+		 * Disable IRQs to prevent a race condition between the
+		 * following code and IPIs that attempts to update
+		 * PMUSERENR_EL0. See also kvm_set_pmuserenr().
+		 */
+		local_irq_save(flags);
+
 		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
+		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
+
+		local_irq_restore(flags);
 	}
 
 	if (cpus_have_final_cap(ARM64_SME)) {
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 530347cdebe3..2e31d37512c7 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -10,7 +10,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
 # will explode instantly (Words of Marc Zyngier). So introduce a generic flag
 # __DISABLE_TRACE_MMIO__ to disable MMIO tracing for nVHE KVM.
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
-ccflags-y += -fno-stack-protector	\
+ccflags-y += -fno-stack-protector -DNO_TRACE_IRQFLAGS -DNO_DEBUG_IRQFLAGS \
 	     -DDISABLE_BRANCH_PROFILING	\
 	     $(DISABLE_STACKLEAK_PLUGIN)
 
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 7887133d15f0..d6a863853bfe 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -209,3 +209,28 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_enable_el0(events_host);
 	kvm_vcpu_pmu_disable_el0(events_guest);
 }
+
+/*
+ * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on the pCPU
+ * where PMUSERENR_EL0 for the guest is loaded, since PMUSERENR_EL0 is switched
+ * to the value for the guest on vcpu_load().  The value for the host EL0
+ * will be restored on vcpu_put(), before returning to the EL0.
+ *
+ * Return true if KVM takes care of the register. Otherwise return false.
+ */
+bool kvm_set_pmuserenr(u64 val)
+{
+	struct kvm_cpu_context *hctxt;
+	struct kvm_vcpu *vcpu;
+
+	if (!kvm_arm_support_pmu_v3() || !has_vhe())
+		return false;
+
+	vcpu = kvm_get_running_vcpu();
+	if (!vcpu || !vcpu_get_flag(vcpu, PMUSERENR_ON_CPU))
+		return false;
+
+	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
+	return true;
+}
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 5ec0fa71399e..bcf3b969d459 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -156,7 +156,7 @@ do {						\
 # define start_critical_timings() do { } while (0)
 #endif
 
-#ifdef CONFIG_DEBUG_IRQFLAGS
+#if defined CONFIG_DEBUG_IRQFLAGS && !defined(NO_DEBUG_IRQFLAGS)
 extern void warn_bogus_irq_restore(void);
 #define raw_check_bogus_irq_restore()			\
 	do {						\
@@ -198,9 +198,9 @@ extern void warn_bogus_irq_restore(void);
 
 /*
  * The local_irq_*() APIs are equal to the raw_local_irq*()
- * if !TRACE_IRQFLAGS.
+ * if !TRACE_IRQFLAGS or if NO_TRACE_IRQFLAGS is locally set.
  */
-#ifdef CONFIG_TRACE_IRQFLAGS
+#if defined CONFIG_TRACE_IRQFLAGS && !defined(NO_TRACE_IRQFLAGS)
 
 #define local_irq_enable()				\
 	do {						\
-- 
2.40.0.634.g4ca3ef3211-goog

