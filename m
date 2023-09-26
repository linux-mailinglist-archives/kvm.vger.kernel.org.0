Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08F17AF853
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 04:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjI0Cwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 22:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbjI0Cuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 22:50:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122DC1D2AC
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d866d13c637so11697680276.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771617; x=1696376417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SOO0Owg6z13+zclWBI3i6GF1p4XONQg1yPDHHPPUyLA=;
        b=DHepmkfgWlel3knvQquHJzCQ8ZKck9Yz2hkmrdfNLTCRienjO8TbVRa5yjwBde5K+Z
         /ofyEpxYBJ17obopzTwZAuBeUt6yFtXj42Mjzmg/qOmYhmjCwBMY99cIBaHcXd581SdO
         NXh1fL6tLeWBPcNTUNU5ClvcDiEBOGJ5pb1QpGYJRgzMozwiXaOBKLpWzFKULKlSy0iW
         HBIU0Wz83mpwIxEQCjHeSNgsTTNQVUBf+KROs9p+n2tvwxve3P1edBQwxG1+jdreCiff
         5wcM2SMS10brlJHVnv8l8WKDoNLjl9LGP6rXUpl5wbnSka3C0BlmePdwedJA8U/SSnjo
         yEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771617; x=1696376417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SOO0Owg6z13+zclWBI3i6GF1p4XONQg1yPDHHPPUyLA=;
        b=hOEB9dyfpd3OZidE403GhBJApLeFs3ohqAVIyr3NSP0hsbCSdcsF0FXS25bDg4J+ZC
         4VvIpstR6RSjuexiIFzILHWEVT3N3ShP7s5T+FbIKq6E+TH8kUFcO/6b8NqJUAT94rVP
         NfbAgIlNxBIyQ/F2yqCzt4ITGZGMfGG3MphHgeCOC67pmdMRQFicjeZFnUAHQqjf1Ld3
         hqccg1EXMB9NZw5SHdycTgD903zed3LhlLUO6ajwDhpleEirr4l0dWb8RNX2hxZ7pClL
         F0hXz434QToctyr07RNvwgzJboF7KMI9ufdi9yWqREOKjAQtojUooAF0QrPqXBrHYkfa
         mCZA==
X-Gm-Message-State: AOJu0YxhIC50qh5unrYwUSvJwh5f+gh7M75t1FFCBZheJyv8LRwT3l14
        vNuKnRV++Wjng82WDLQPeMgfljBYcr9/
X-Google-Smtp-Source: AGHT+IGUgid3XJfM7WrI6SnBJ34jSBPnUHYgXF7YKekwIi79TmqyisbuzEStEJAn2EbwUP4ouzwhqXm/LTHk
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:ae01:0:b0:d89:4776:5d6b with SMTP id
 a1-20020a25ae01000000b00d8947765d6bmr4133ybj.5.1695771616728; Tue, 26 Sep
 2023 16:40:16 -0700 (PDT)
Date:   Tue, 26 Sep 2023 23:40:02 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-6-rananta@google.com>
Subject: [PATCH v6 05/11] KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

Add a helper to read a vCPU's PMCR_EL0, and use it when KVM
reads a vCPU's PMCR_EL0.

The PMCR_EL0 value is tracked by a sysreg file per each vCPU.
The following patches will make (only) PMCR_EL0.N track per guest.
Having the new helper will be useful to combine the PMCR_EL0.N
field (tracked per guest) and the other fields (tracked per vCPU)
to provide the value of PMCR_EL0.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c      |  3 +--
 arch/arm64/kvm/pmu-emul.c | 21 +++++++++++++++------
 arch/arm64/kvm/sys_regs.c |  6 +++---
 include/kvm/arm_pmu.h     |  6 ++++++
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea3..86cafe5a6010b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -801,8 +801,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
-			kvm_pmu_handle_pmcr(vcpu,
-					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+			kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 
 		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
 			kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 998e1bbd5310d..d89438956f7d3 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -72,7 +72,7 @@ static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
 
 static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
 {
-	u64 val = __vcpu_sys_reg(kvm_pmc_to_vcpu(pmc), PMCR_EL0);
+	u64 val = kvm_vcpu_read_pmcr(kvm_pmc_to_vcpu(pmc));
 
 	return (pmc->idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
 	       (pmc->idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
@@ -250,7 +250,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	u64 val = kvm_vcpu_read_pmcr(vcpu) >> ARMV8_PMU_PMCR_N_SHIFT;
 
 	val &= ARMV8_PMU_PMCR_N_MASK;
 	if (val == 0)
@@ -272,7 +272,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
+	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -324,7 +324,7 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = 0;
 
-	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E)) {
+	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
@@ -426,7 +426,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 {
 	int i;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
+	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E))
 		return;
 
 	/* Weed out disabled counters */
@@ -569,7 +569,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
+	return (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) &&
 	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx));
 }
 
@@ -1084,3 +1084,12 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 					      ID_AA64DFR0_EL1_PMUVer_V3P5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
 }
+
+/**
+ * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
+ * @vcpu: The vcpu pointer
+ */
+u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_sys_reg(vcpu, PMCR_EL0);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 66b9e1de54230..5ae7399f2b822 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -803,7 +803,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		 * Only update writeable bits of PMCR (continuing into
 		 * kvm_pmu_handle_pmcr() as well)
 		 */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+		val = kvm_vcpu_read_pmcr(vcpu);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
@@ -811,7 +811,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		kvm_pmu_handle_pmcr(vcpu, val);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
+		val = kvm_vcpu_read_pmcr(vcpu)
 		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 		p->regval = val;
 	}
@@ -860,7 +860,7 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
 	u64 pmcr, val;
 
-	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	pmcr = kvm_vcpu_read_pmcr(vcpu);
 	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index b80c75d80886b..c6a5e49b850ab 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -103,6 +103,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
 
+u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
@@ -180,6 +181,11 @@ static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
 	return -ENODEV;
 }
 
+static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.42.0.582.g8ccd20d70d-goog

