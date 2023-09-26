Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B057AF764
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 02:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjI0AWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 20:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjI0AUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 20:20:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBA21E3CE
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d865f1447a2so12386082276.2
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771618; x=1696376418; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iClvWFMAUhr23DSEXTqh9q2xJJj0sRpIP3b88ASy6ss=;
        b=d8Ni91g36jwJIeaR3HDmN47EiIgkC8CeSFLud8HIUoic4nXGJNK3USm+siCAvN9b27
         CCZ8xGGSd+a+6eem8BxeZDJoWenWhC9UgvReOGHcltxWlJtQctZpW39oLqWoJMeP7qk2
         1RTkSQIJd1hb/dCBQr5JB+MQ1ULZAY2SYgZCHKtXmFVS2rXsrmlNTTRHL/pwKNeehC2I
         NJD0xhsdp73dIWG0zc0Yl57ipLDi9krM5kiudTaLcWFGn/PKgbbU+DU7azz8awWx6y/n
         0A2x/Tn3CMCwBKonS0zCPtAQ8/2T8KEg3xkCGgDcmrdqok4Ji6DC5QAJEXDbnPt+KhlM
         cq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771618; x=1696376418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iClvWFMAUhr23DSEXTqh9q2xJJj0sRpIP3b88ASy6ss=;
        b=obxHJ8zCVUKRz25cQsqyvXkRa4J/R9OOj1fWuaRESVh7lyBF0tHmup+X4L/ytbvxSY
         onuvOYjvgZ85dA/lgDPdPp3d3Zux93tZKFYFeBm2csYTYU6z0YnkxZuyoZloCw+9W9GL
         uB5iFc1DrcIPnW2MwgMxZs3LSrTyJ73xiUnWXxR9QmX5C2Hgjlj5Z0crTFGc3czoJ46x
         8Iu7gOut8+TolCzeot8QWaXE7RHxuyqL1TvZpBL+3tsQuPEKzCxUthcFpDP/WfCiiFo+
         LQRTNIETEu7QSZS7Y4lzI7d27EeefuZf2+F3oP+IX1307EXGJbqjmFWoKzG2fE3nC4xr
         8pHQ==
X-Gm-Message-State: AOJu0YyD582S8vj97sO5mWZqhG4dgp0YXTirXYXVq/QXlgqe60uQyKKR
        dS5inUReuntot8LHN13MBuNHr5ISbKoh
X-Google-Smtp-Source: AGHT+IGdhsgrwxOExAadcdVTRP0/JsWFhavF0JjE0J43GmACivLbYOziS/Nuzn9aFoXjDGtvKedlw7WT0g/E
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:d7:0:b0:d89:b072:d06f with SMTP id
 206-20020a2500d7000000b00d89b072d06fmr4171yba.7.1695771617694; Tue, 26 Sep
 2023 16:40:17 -0700 (PDT)
Date:   Tue, 26 Sep 2023 23:40:03 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-7-rananta@google.com>
Subject: [PATCH v6 06/11] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on
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

From: Reiji Watanabe <reijiw@google.com>

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

KVM does not yet support userspace modifying PMCR_EL0.N.
The following patch will add support for that.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/pmu-emul.c         | 20 +++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 15 +++++++++------
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af06ccb7ee343..0fe9cc9dc8368 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -257,6 +257,9 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
+	/* PMCR_EL0.N value for the guest */
+	u8 pmcr_n;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index d89438956f7d3..121cfd161959a 100644
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
 
@@ -878,6 +881,13 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	kvm->arch.arm_pmu = arm_pmu;
+
+	/*
+	 * Both the num_events and PMCR_EL0.N indicates the number of
+	 * PMU event counters, but the former includes the cycle counter
+	 * while the latter does not.
+	 */
+	kvm->arch.pmcr_n = arm_pmu->num_events - 1;
 }
 
 /**
@@ -1088,8 +1098,16 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 /**
  * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
  * @vcpu: The vcpu pointer
+ *
+ * The function returns the value of PMCR.N based on the per-VM tracked
+ * value (kvm->arch.pmcr_n). This is to ensure that the register field
+ * remains consistent for the VM, even on heterogeneous systems where
+ * the value may vary when read from different CPUs (during vCPU reset).
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
index 5ae7399f2b822..d1db1f292645e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr;
 
-	/* No PMU available, PMCR_EL0 may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return 0;
-
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr = kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
@@ -1084,6 +1080,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
@@ -2148,7 +2151,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0 },
+	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
-- 
2.42.0.582.g8ccd20d70d-goog

