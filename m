Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0013B7D185A
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345446AbjJTVl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbjJTVlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:41:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1166410C6
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9ab7badadeso1643804276.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838060; x=1698442860; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uuXBV0qQn1hgsBM5m030KdW6lqqqMyz/TK8I8fJPWXo=;
        b=wmAywqyjZJbLMou/H0AGjB3XwMUzGfAVRFdOKI0uknNP1bCbsnt92iTI7ONoV+KXR3
         IHoQrrhbHzz3QJvOTgxg5v78shTWvjfFxuyTeI/0atbGqqRGVqOLEdqLG58t7nLjMb7e
         NLc2tduNc5/HdXcKVsfxmarCBolmQCDUDelDmGR0PMlXgXhSzXj1H5LhwqC4RQuMbzSR
         0bgtWMigfh1rf7lrq0GXLUfwdFIGlJ2IOhvHarHjj4C/VDTO/aaueklAKugTcdU5j4mh
         Lb36Y/+T2VnaqSD6ZmEHFNcTTgFTHsi+r2A1oSGlKxL+qTW3+Uek1rBcB9v9i1NDBr51
         KqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838060; x=1698442860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uuXBV0qQn1hgsBM5m030KdW6lqqqMyz/TK8I8fJPWXo=;
        b=HzBRE05GiBwdEmREeIm1Wd3eB4LCthVBlzwYsd5cGNEeK9/+6q8D2YjSUDgtH75SLg
         UO80cBwr6UpNjiO/VJuw5flvDEHZBPxH1K12fv2AL4sgB2weoSP9eRcMpCTUcdja6N5U
         5jimSGJ/cr9LC5HzVW1g9vHsPl91FRQzv8va7mIpetkr1WQITRjC2hLvyBPzFVUV17Qf
         0cvqSYrxYmGB4hgvNFVn7fl5r9AZCkOrBD/+RiX5lkMPbw3xNXCgssTLhVaLbaFU9MYK
         ZzVvBHhemfgviddjBlZXEdvpINILC9muw6eGa7BhxWSbwwUAL+qSb0PpGWOvSuK2cUd8
         nVZQ==
X-Gm-Message-State: AOJu0YxlcJIqCoeTbkosFQmwZqDhuqW6XC1Qo06Db1gh3NDOaKT1q21q
        /biMk6zdKGAJy0jCaXHGRj+02K6rGtBT
X-Google-Smtp-Source: AGHT+IGcErzgyS3eJYI37KfNFaBbNiCvHxmDEjQdEqWuiXZzGUDEszx3cxJtsS8H29RPPsR181w1xzUddUY2
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1083:b0:d9a:4f4c:961b with SMTP
 id v3-20020a056902108300b00d9a4f4c961bmr88781ybu.1.1697838060201; Fri, 20 Oct
 2023 14:41:00 -0700 (PDT)
Date:   Fri, 20 Oct 2023 21:40:43 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-4-rananta@google.com>
Subject: [PATCH v8 03/13] KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>
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

Add a helper to read a vCPU's PMCR_EL0, and use it whenever KVM
reads a vCPU's PMCR_EL0.

Currently, the PMCR_EL0 value is tracked per vCPU. The following
patches will make (only) PMCR_EL0.N track per guest. Having the
new helper will be useful to combine the PMCR_EL0.N field
(tracked per guest) and the other fields (tracked per vCPU)
to provide the value of PMCR_EL0.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/arm.c      |  3 +--
 arch/arm64/kvm/pmu-emul.c | 21 +++++++++++++++------
 arch/arm64/kvm/sys_regs.c |  6 +++---
 include/kvm/arm_pmu.h     |  6 ++++++
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 08c2f76983b9d..e3074a9e23a8b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -857,8 +857,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
-			kvm_pmu_handle_pmcr(vcpu,
-					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+			kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 
 		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
 			kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 66c244021ff08..097bf7122130d 100644
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
index ce1bb97d35176..a31cecb3d29fb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -822,7 +822,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		 * Only update writeable bits of PMCR (continuing into
 		 * kvm_pmu_handle_pmcr() as well)
 		 */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+		val = kvm_vcpu_read_pmcr(vcpu);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
@@ -830,7 +830,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		kvm_pmu_handle_pmcr(vcpu, val);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
+		val = kvm_vcpu_read_pmcr(vcpu)
 		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 		p->regval = val;
 	}
@@ -879,7 +879,7 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
 	u64 pmcr, val;
 
-	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	pmcr = kvm_vcpu_read_pmcr(vcpu);
 	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 858ed9ce828a6..cd980d78b86b5 100644
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
2.42.0.655.g421f12c284-goog

