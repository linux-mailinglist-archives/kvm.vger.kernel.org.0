Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF315688E87
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjBCEXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbjBCEXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:23:31 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D0D29409
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:23:28 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id qb3-20020a17090b280300b002307b2547b5so165980pjb.1
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 20:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xpEXHfZvLbpfaKhqxhiDfUYZgyXkf2aFSNA+vKwneRY=;
        b=CU20XaZTa84GhtBhLVM8cHDsTfRVWu4SeFehyh9NtswcjAvNgffGKt3di3DbSi7VAe
         eKj9fkwDnkXLIPB+veEf4siptUwbGFLPfGqnALD6xThehUT8jFHOFFwYgXQ4z1hFsTFt
         zqsn8A4HBczz68w25URq3WBkWLi5DR9WuO/7AFJ2IKsKJDPQ1PrheVLqulPEZHUXLQmg
         otch6vhX54gs5STs2gr2WwWBGGMA7KuG8e86/2UjQtBJ9DPZuDrJP8vA9MqaqzlsrKRa
         zGCPrl8k5lZp9mZ0WG55FX/JmkIZShK4zbca2yxFxbWUbRy4210F5mz4pKpL5wdRk43n
         6P/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xpEXHfZvLbpfaKhqxhiDfUYZgyXkf2aFSNA+vKwneRY=;
        b=CZBL9OJUBcbWNgU5BxDzN+hyVKZRpm8VZSW5Mamt4NhZrUaPbqtulhM7nJ7es/66QL
         CZSTL2OswOnEFYfsKO2RM30h01EVzsGy0djFt/S0u6ANQLJNsj6GkDG6lHkOQYkCeiqf
         PjzsKJwqFcEkTf0AcGF4r/g8Mup3ZefhfNAlpcE22kH34PPIK7yD61CwCPnUvHvn+L2o
         ehQpSwoTZHMb+mhiuVGxYRbCKFrrRxxIeAWxXS2HyKd4ERb127FgMaJnp+JCZY52xvbX
         4nkedcbK4bo/W01F34jKhuqI/SZDfXNBAJe7vO7ibJBE2N1LSJ5uoeRbG3TEkPA30mpD
         BuKA==
X-Gm-Message-State: AO0yUKW7e0Xhx+zc9iAOLwJmgCqBJBbNxV7dj6XzntRzG5uzosXUNWSi
        CZ8jbD3SpR7cet8gAO90IOzshjTxSKI=
X-Google-Smtp-Source: AK7set/0mGNoOdEuR0rgdSC8ryLt9r67mzIzERGJmYbc/256SmGadiMn1crQB06HpA2fBqvDNM3pX7bJq7E=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a63:1c1e:0:b0:4df:c991:3a74 with SMTP id
 c30-20020a631c1e000000b004dfc9913a74mr1414141pgc.94.1675398207662; Thu, 02
 Feb 2023 20:23:27 -0800 (PST)
Date:   Thu,  2 Feb 2023 20:20:49 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-6-reijiw@google.com>
Subject: [PATCH v3 07/14] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
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

Some code extracts PMCR_EL0.N using ARMV8_PMU_PMCR_N_SHIFT and
ARMV8_PMU_PMCR_N_MASK. Define ARMV8_PMU_PMCR_N (0x1f << 11),
and simplify those codes using FIELD_GET() and/or ARMV8_PMU_PMCR_N.
The following patches will also use these macros to extract PMCR_EL0.N.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/perf_event.h | 2 +-
 arch/arm64/kernel/perf_event.c      | 3 +--
 arch/arm64/kvm/pmu-emul.c           | 3 +--
 arch/arm64/kvm/sys_regs.c           | 7 +++----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index 3eaf462f5752..eeef8d56d9c8 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -219,7 +219,7 @@
 #define ARMV8_PMU_PMCR_LC	(1 << 6) /* Overflow on 64 bit cycle counter */
 #define ARMV8_PMU_PMCR_LP	(1 << 7) /* Long event counter enable */
 #define	ARMV8_PMU_PMCR_N_SHIFT	11	 /* Number of counters supported */
-#define	ARMV8_PMU_PMCR_N_MASK	0x1f
+#define	ARMV8_PMU_PMCR_N	(0x1f << ARMV8_PMU_PMCR_N_SHIFT)
 #define	ARMV8_PMU_PMCR_MASK	0xff	 /* Mask for writable bits */
 
 /*
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index a5193f2146a6..1775d89a9144 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -1158,8 +1158,7 @@ static void __armv8pmu_probe_pmu(void *info)
 	probe->present = true;
 
 	/* Read the nb of CNTx counters supported from PMNC */
-	cpu_pmu->num_events = (armv8pmu_pmcr_read() >> ARMV8_PMU_PMCR_N_SHIFT)
-		& ARMV8_PMU_PMCR_N_MASK;
+	cpu_pmu->num_events = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
 
 	/* Add the CPU cycles counter */
 	cpu_pmu->num_events += 1;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 701728ad78d6..9dbf532e264e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -246,9 +246,8 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
 
-	val &= ARMV8_PMU_PMCR_N_MASK;
 	if (val == 0)
 		return BIT(ARMV8_PMU_CYCLE_IDX);
 	else
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 790f028a1686..9b410a2ea20c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -629,7 +629,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		return;
 
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N;
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
@@ -736,10 +736,9 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
-	u64 pmcr, val;
+	u64 val;
 
-	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+	val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
 		return false;
-- 
2.39.1.519.gcb327c4b5f-goog

