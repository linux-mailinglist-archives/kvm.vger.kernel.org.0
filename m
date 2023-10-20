Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A3C7D185C
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345425AbjJTVlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbjJTVlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:41:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7BC10C8
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9cad450d5fso1580828276.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838061; x=1698442861; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HzKv0aKoQ6Y11TCAac4g+R+SnDAhAHq7pzRLq3b0xvY=;
        b=or91Br27VACFT2sfWhGIdImFVz8KhnNJBKHX4miCmgVBPx7uQOIBd81sXbPE2+tuOR
         hPTSDa8t2lFbva06NYA53GZsU3m1xykLDcI6odOEuVbV5r+JetTbjBD9DpkxJt6zK0Bt
         fFwI8LYro7U7GKZFCE7GnqZfiww10ze3pft8TOq819X1aAbvX0QBzzHW+0jnV+9uhc/K
         kmHQ3x519NzyfoSXKgWX6CACGOc5HfSmdx5j2jTrxrPv5amjxYgW0/kwfZO9hf9bhc8I
         c6jGgqNUyPX4M/8kFx2GqNQg78QbDVaEPhPUa9ZJNLUVB2jkthrLoe+VavwA0KBW70kf
         kZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838061; x=1698442861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HzKv0aKoQ6Y11TCAac4g+R+SnDAhAHq7pzRLq3b0xvY=;
        b=mcjP6NW+4nv3uHO/rOoduO0gCZbvm+4rCtR/MXGuFfCGJDnCHGlMq9Ov1ElqPHxD9w
         r4f13uzl6YtfxS3pvX+m8bnnMlpmBRxMli9cmLDmE5j5k0+/MboJ3V/a3CyVVXvwZ4uP
         ig/OaMXMJb5afkQPlKWY3XTvAQsBhpruvmtLorVg/wDiid5kZMZO0YaxmVH9ZCWQ5MnL
         MADlMKkwYnTdsVaT+wa3F+F1QaRf7b5XvNige1dRKByO3oGNxycWHz8LjPW4TLl7b5Hx
         e2ohf1FrMOjbNFVtTqdlU7uUYCAFxywXHuDBKZUSaNGySxwTse2YucJd4kB8BlBPg9TD
         zIhQ==
X-Gm-Message-State: AOJu0YzGkfVvSiFcxRWHlJfk77/jDimvhYEFMigCWfX+kD2zmVsPM+7S
        MpL6XBJbN5yee14spksgriMzhud12JxD
X-Google-Smtp-Source: AGHT+IEz81OMCPv2Iaq1w7pusbiHb7caWK+8uwpUHI9LXEqiprDd6246fiQePusr7USK+DANhtCWIqwUusMH
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1083:b0:d9a:47ea:69a5 with SMTP
 id v3-20020a056902108300b00d9a47ea69a5mr87728ybu.1.1697838061072; Fri, 20 Oct
 2023 14:41:01 -0700 (PDT)
Date:   Fri, 20 Oct 2023 21:40:44 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-5-rananta@google.com>
Subject: [PATCH v8 04/13] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on
 the associated PMU
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, the value is set to the same
value as the current PE on every vCPU reset.  Unless the vCPU is
pinned to PEs that has the PMU associated to the guest from the
initial vCPU reset, the value might be different from the PMU's
PMCR_EL0.N on heterogeneous PMU systems.

Fix this by setting the vCPU's PMCR_EL0.N to the PMU's PMCR_EL0.N
value. Track the PMCR_EL0.N per guest, as only one PMU can be set
for the guest (PMCR_EL0.N must be the same for all vCPUs of the
guest), and it is convenient for updating the value.

To achieve this, the patch introduces a helper,
kvm_arm_pmu_get_max_counters(), that reads the maximum number of
counters from the arm_pmu associated to the VM. Make the function
global as upcoming patches will be interested to know the value
while setting the PMCR.N of the guest from userspace.

KVM does not yet support userspace modifying PMCR_EL0.N.
The following patch will add support for that.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/pmu-emul.c         | 26 +++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 28 ++++++++++++++--------------
 include/kvm/arm_pmu.h             |  6 ++++++
 4 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 846a7706e925c..5653d3553e3ee 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -290,6 +290,9 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
+	/* PMCR_EL0.N value for the guest */
+	u8 pmcr_n;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 097bf7122130d..9e24581206c24 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -690,6 +690,9 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	if (!entry)
 		goto out_unlock;
 
+	WARN_ON((pmu->num_events <= 0) ||
+		(pmu->num_events > ARMV8_PMU_MAX_COUNTERS));
+
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
@@ -873,11 +876,29 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+/**
+ * kvm_arm_pmu_get_max_counters - Return the max number of PMU counters.
+ * @kvm: The kvm pointer
+ */
+int kvm_arm_pmu_get_max_counters(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/*
+	 * The arm_pmu->num_events considers the cycle counter as well.
+	 * Ignore that and return only the general-purpose counters.
+	 */
+	return arm_pmu->num_events - 1;
+}
+
 static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	kvm->arch.arm_pmu = arm_pmu;
+	kvm->arch.pmcr_n = kvm_arm_pmu_get_max_counters(kvm);
 }
 
 /**
@@ -1091,5 +1112,8 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
  */
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
-	return __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0) &
+			~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+
+	return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a31cecb3d29fb..faf97878dfbbb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -721,12 +721,7 @@ static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
 
-	/* No PMU available, any PMU reg may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return 0;
-
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
+	n = vcpu->kvm->arch.pmcr_n;
 	if (n)
 		mask |= GENMASK(n - 1, 0);
 
@@ -762,17 +757,15 @@ static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 pmcr;
+	u64 pmcr = 0;
 
-	/* No PMU available, PMCR_EL0 may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return 0;
-
-	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
+	/*
+	 * The value of PMCR.N field is included when the
+	 * vCPU register is read via kvm_vcpu_read_pmcr().
+	 */
 	__vcpu_sys_reg(vcpu, r->reg) = pmcr;
 
 	return __vcpu_sys_reg(vcpu, r->reg);
@@ -1103,6 +1096,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 *val)
+{
+	*val = kvm_vcpu_read_pmcr(vcpu);
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -2235,7 +2235,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0 },
+	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index cd980d78b86b5..2e90f38090e6d 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -102,6 +102,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
+int kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 #else
@@ -181,6 +182,11 @@ static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
 	return -ENODEV;
 }
 
+static inline int kvm_arm_pmu_get_max_counters(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.42.0.655.g421f12c284-goog

