Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAE1692D9A
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBKDRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBKDRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:17:01 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586F793CC
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:48 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-517f8be4b00so67967317b3.3
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ccQ/Ep4gPvxWBDmSHprpIitRzQFtxgmXhrKz1ZUM8F0=;
        b=saFiY3eQDW9h1ujzAmebXz7d0tN5Me0CI3vySrQb5DdV8WJiSKAIWd1/a6JeMk2NDI
         aXG/BRX2P5JvGH21rgdC9LHTwPHLZnJVYRt210tmPz9hIyQVVJ6n+x68GaNaY2rkEEpe
         AeLbUxd1NWB70/ziaCQJwCCxQ+E+hiKn2+TAURRVG0OLNsWLaRoE/neA/ai9aBLPngrn
         FzJamKdsg5U2HadGr2KWLrnX7Ch9yAYcvNB8lbsTWN8mFk81TtBqLHyMY3KY30uZN2zb
         uHhJ/CiyziIZ8V3zaby9x+PRyeXZOvj33mMfhHN3GzEf6IF93nNlLais0HSkNyKmNobs
         2hxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ccQ/Ep4gPvxWBDmSHprpIitRzQFtxgmXhrKz1ZUM8F0=;
        b=52wwzjKsOFawHOJf3E9Rpmzu5B9fdLR6oqpg0/+u/aP7Uo6/kimgEYfGgtmlee7fAo
         9gxA6k4+uB453Inpo48GZyXOATeoLISzE9+Ff2vUsOiBta5jV64UqKeNdXcjFGXk/3bz
         ld7zC63Z9LZxr3t+918wqV76i+1W3JDm07x/1fA6e/IHWlumx4aGgVaioKYZQ2oovCgk
         6t4iG9JWIvbLoVxI5RQE4chx30wQlyCA64p4v57AcbRe449aBKaDb+sKhuA5RcjHm6FQ
         ITfDXaqRLrv/6oqQh4o6f1YddW2+tjWtSk8zhd8Ros7y72neEAN8TWB17hbdHz1WJYSf
         Yvbw==
X-Gm-Message-State: AO0yUKVFAR1KG2Vv36NWE0r4kyAXCluFUTcA8WmjA7eZRAyXpItxpEcy
        Ow+2I//zSSepYuYasZeJnqQyEzyvkOc=
X-Google-Smtp-Source: AK7set8Q2cZNeiYkK1Z5DUJcwC9OR6/Ty3Qwh1Pk3dSsKY/QDZR0QR6wjDIfVRFF/5zaxynxKBFZmNBsGdc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a0d:eb8a:0:b0:52e:e972:ca5d with SMTP id
 u132-20020a0deb8a000000b0052ee972ca5dmr83887ywe.7.1676085407993; Fri, 10 Feb
 2023 19:16:47 -0800 (PST)
Date:   Fri, 10 Feb 2023 19:15:00 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-9-reijiw@google.com>
Subject: [PATCH v4 08/14] KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
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

Add a helper to read a vCPU's PMCR_EL0, and use it when KVM
reads a vCPU's PMCR_EL0.

The PMCR_EL0 value is tracked by a sysreg file per each vCPU.
The following patches will make (only) PMCR_EL0.N track per guest.
Having the new helper will be useful to combine the PMCR_EL0.N
field (tracked per guest) and the other fields (tracked per vCPU)
to provide the value of PMCR_EL0.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/arm.c      |  3 +--
 arch/arm64/kvm/pmu-emul.c | 17 +++++++++++------
 arch/arm64/kvm/sys_regs.c |  6 +++---
 include/kvm/arm_pmu.h     |  6 ++++++
 4 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 41f478344a4d..ee3df098a75e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -753,8 +753,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
-			kvm_pmu_handle_pmcr(vcpu,
-					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+			kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 9dbf532e264e..5ff44224148f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -68,7 +68,7 @@ static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
 
 static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
 {
-	u64 val = __vcpu_sys_reg(kvm_pmc_to_vcpu(pmc), PMCR_EL0);
+	u64 val = kvm_vcpu_read_pmcr(kvm_pmc_to_vcpu(pmc));
 
 	return (pmc->idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
 	       (pmc->idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
@@ -246,7 +246,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
+	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
 
 	if (val == 0)
 		return BIT(ARMV8_PMU_CYCLE_IDX);
@@ -267,7 +267,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
+	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -319,7 +319,7 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = 0;
 
-	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E)) {
+	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
@@ -421,7 +421,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 {
 	int i;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
+	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E))
 		return;
 
 	/* Weed out disabled counters */
@@ -562,7 +562,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
+	return (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) &&
 	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx));
 }
 
@@ -1071,3 +1071,8 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 					      ID_AA64DFR0_EL1_PMUVer_V3P5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
 }
+
+u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_sys_reg(vcpu, PMCR_EL0);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9b410a2ea20c..9f8c25e49a5a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -680,7 +680,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		 * Only update writeable bits of PMCR (continuing into
 		 * kvm_pmu_handle_pmcr() as well)
 		 */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+		val = kvm_vcpu_read_pmcr(vcpu);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
@@ -689,7 +689,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
+		val = kvm_vcpu_read_pmcr(vcpu)
 		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 		p->regval = val;
 	}
@@ -738,7 +738,7 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
 	u64 val;
 
-	val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
+	val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
 		return false;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index c7da46c7377e..8f55c9055058 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -97,6 +97,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 
 int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu);
 
+u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
@@ -173,6 +174,11 @@ static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 	return 0;
 }
 
+static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.39.1.581.gbfd45094c4-goog

