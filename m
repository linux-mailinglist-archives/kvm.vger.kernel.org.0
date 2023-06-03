Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FD9720D7E
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 04:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbjFCCwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 22:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237085AbjFCCwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 22:52:18 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B5CE5F
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 19:52:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56536dd5f79so41815457b3.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 19:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685760722; x=1688352722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KDFXlg40JZK7tD1QcINc3yvgddagMFe1ISddFDG7yUk=;
        b=jjrCMUfevaPYgb2kZwsK1yDw7Qlp8585C9teElxM/xHufCFV3l63n5NHNbiPffqLeV
         KmpleA/Kdn1JqTCpeOrLlqzCz0KhToR5k7o3gU0zyJlErZFHsvIKm4nm0Tj4RW6krX45
         dx1KBykEOQpPDW5NccaI7csUq/WQkGCQps/wA1aq79jwWiyI9ThIgRSchtJuwSuVzKKa
         v3hGZ1WKVhKnMPrvuDnawLt+L2qyKD98LfwjhFUUEOqfFn4nFF09pYRWAq33+MtW/26j
         drcEZZuTyh16IOrbgy++GzYImwlu8KEsa8nvMvI3+LA1TFZow7KsYlTtArA61oWr4Yv9
         jKMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685760722; x=1688352722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDFXlg40JZK7tD1QcINc3yvgddagMFe1ISddFDG7yUk=;
        b=fEePe04iNfGMrjozGIjCGkyJnLwMxk7Hx1Idak/czQtMApqOsCdPUlqFT1vKzRfguE
         OEFq4EBNFLnGsrFeaCV5YhnxgucvfsXsRqPobZx5zRkLIH1etTSN4MGj4OFCviY6Z4/v
         D6ubbeakj/pELJ32JrNmkYSg4JrbNI2WyvRhbtJWFZphl+sdac5HB+qzs5jnZ91Uh36J
         c1FemdxcAayAx5ry32WYo81iMZJTPh/P2kqRVoSPjJ+73t2FLLwNswPmlQtKr/VCHeVh
         zi3sHFr69TP+ANBXA1rV6MZP+unAbcAyKIXVm8P1wNmfaP7TiQ2qoLgl6CM1g3WqgaGR
         2Zjw==
X-Gm-Message-State: AC+VfDzERJXr/ot58Cxpf+S5hxDneXHU1nx0uzuOLSxOX3ol6tPjrdk9
        nTHTmVfJLQP625aDJZCSzEXjk1m20cs=
X-Google-Smtp-Source: ACHHUZ4CDztfSVCjau0l24GyQAsrUl9AQhGkOIfEYDSBDcjmK8RGLjB3vZ/MQohARF1O0R5waBVGa8RCccg=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:ad06:0:b0:565:bf4b:de20 with SMTP id
 l6-20020a81ad06000000b00565bf4bde20mr926860ywh.2.1685760722413; Fri, 02 Jun
 2023 19:52:02 -0700 (PDT)
Date:   Fri,  2 Jun 2023 19:50:35 -0700
In-Reply-To: <20230603025035.3781797-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230603025035.3781797-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230603025035.3781797-3-reijiw@google.com>
Subject: [PATCH v5 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
instead updating the saved shadow register value for the host
so that the value can be restored on vcpu_put() later.
While vcpu_{put,load}() are manipulating PMUSERENR_EL0, disable
IRQs to prevent a race condition between these processes and IPIs
that attempt to update PMUSERENR_EL0 for the host EL0.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h        |  5 +++++
 arch/arm64/include/asm/kvm_host.h       |  7 +++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 ++
 arch/arm64/kvm/hyp/vhe/switch.c         | 14 +++++++++++++
 arch/arm64/kvm/pmu.c                    | 27 +++++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c                | 21 ++++++++++++++++---
 6 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index f4db3e75d75f..f3cd04ff022d 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -222,6 +222,11 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 	return false;
 }
 
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
+
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
 #define ARMV8_PMU_DFR_VER_V3P4      0x5
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7e7e19ef6993..9787503ff43f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -699,6 +699,8 @@ struct kvm_vcpu_arch {
 #define SYSREGS_ON_CPU		__vcpu_single_flag(sflags, BIT(4))
 /* Software step state is Active-pending */
 #define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
+/* PMUSERENR for the guest EL0 is on physical CPU */
+#define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(6))
 
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -1065,9 +1067,14 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
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
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 51229d847103..c530cf6b4bef 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -89,6 +89,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
 	}
 
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
@@ -116,6 +117,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 
 		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
+		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
 	}
 
 	if (cpus_have_final_cap(ARM64_SME)) {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3d868e84c7a0..3f0b5756c956 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -92,14 +92,28 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 }
 NOKPROBE_SYMBOL(__deactivate_traps);
 
+/*
+ * Disable IRQs in {activate,deactivate}_traps_vhe_{load,put}() to
+ * prevent a race condition between context switching of PMUSERENR_EL0
+ * in __{activate,deactivate}_traps_common() and IPIs that attempts to
+ * update PMUSERENR_EL0. See also kvm_set_pmuserenr().
+ */
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__activate_traps_common(vcpu);
+	local_irq_restore(flags);
 }
 
 void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__deactivate_traps_common(vcpu);
+	local_irq_restore(flags);
 }
 
 static const exit_handler_fn hyp_exit_handlers[] = {
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 7887133d15f0..121f1a14c829 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -209,3 +209,30 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_enable_el0(events_host);
 	kvm_vcpu_pmu_disable_el0(events_guest);
 }
+
+/*
+ * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on the pCPU
+ * where PMUSERENR_EL0 for the guest is loaded, since PMUSERENR_EL0 is switched
+ * to the value for the guest on vcpu_load().  The value for the host EL0
+ * will be restored on vcpu_put(), before returning to userspace.
+ * This isn't necessary for nVHE, as the register is context switched for
+ * every guest enter/exit.
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
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index c98e4039386d..93b7edb5f1e7 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -677,9 +677,25 @@ static inline u32 armv8pmu_getreset_flags(void)
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
+	write_pmuserenr(val);
+}
+
 static void armv8pmu_disable_user_access(void)
 {
-	write_pmuserenr(0);
+	update_pmuserenr(0);
 }
 
 static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
@@ -695,8 +711,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 			armv8pmu_write_evcntr(i, 0);
 	}
 
-	write_pmuserenr(0);
-	write_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
+	update_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
 }
 
 static void armv8pmu_enable_event(struct perf_event *event)
-- 
2.41.0.rc0.172.g3f132b7071-goog

