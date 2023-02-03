Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B24D688E89
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjBCEXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjBCEXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:23:34 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A307437F00
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:23:33 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso3743106ybx.19
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 20:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rjHuOROaPh04hBIryzlS3UOwUzWVXjEKlopD+fhxM6Q=;
        b=ZwkdcLbW28CGT5q2oMQ7rph4wKqhu4THcTXKCGfhgxf1olfxceL475/g9ILy30bq7X
         Yt2shk2Z3/55BWhYiUqR8iJl6EysMSZEwq4WZzCZMZWy2orA2HMxpsbZIg/o3bh8ZqfW
         5DROz9ICqHUHCb/bfiExo5XUkTHjkqCq9SqHMLxMoNGjfi8jC3Rdd6HNTdVswsRkJeHG
         ZotPLrCH4uX0eKstAc2GRJyeQjE/igLlQbBpVBqklScwk6e9vuBHBwyUj7k9PMo4SFua
         q30MOaQFuh+kKToOgv38mrEZ4Uo0uxfyNEKnY2lUcaTjXqY0kWWnPySfOEdCafW22npv
         iEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjHuOROaPh04hBIryzlS3UOwUzWVXjEKlopD+fhxM6Q=;
        b=GgRLrCRlEf0PeEkIsMJvy7ehDC2SvijUeGRoEDcgLr3x4/xU2/5bT/jHDVpyetjH1i
         Gp4txGqsqyMIDXqNsODIgCrNcw7aTEA8oFtLIvglFrMAW8nfoKWYlnJ2AVd71q+wwa5d
         tgRrvgWKAhwept1khys/3XYyIK7b6DM/o9dRLs1FyWeBfHAZyyeQzymplQD2oWU4ma2t
         xfuPYntpBz9aBJjUPlAbzxAf0ihQANBQGSWTR7vs5hees5s2jUwREToUyUJD5wnKdaTn
         0YN8R7N+3IPWVy+85+Bn+U9AC5Z3vSZ8UAsWra5ddeAvlMCcCiLDlI72mcuqBHCjIckH
         e8LA==
X-Gm-Message-State: AO0yUKUwb+7MXTjQRkw3X063PGDl/1rZ56xPG21MlSqIn+c4y2Vn8qoK
        dwXwPsKEboweokgwqY6zhf10GVgqyDI=
X-Google-Smtp-Source: AK7set/rNgLZtJ+6USHfQmvNtMEkp1YLxm5xnM8Ib/JZT7xCM+iM+JYo+d/C8Pil6f6TG+WD4DTI5r/fK3E=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:d10c:0:b0:507:b797:f1b with SMTP id
 w12-20020a81d10c000000b00507b7970f1bmr905069ywi.468.1675398212958; Thu, 02
 Feb 2023 20:23:32 -0800 (PST)
Date:   Thu,  2 Feb 2023 20:20:52 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-9-reijiw@google.com>
Subject: [PATCH v3 10/14] KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N
 for the guest
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

KVM does not yet support userspace modifying PMCR_EL0.N (With
the previous patch, KVM ignores what is written by upserspace).
Add support userspace limiting PMCR_EL0.N.

Disallow userspace to set PMCR_EL0.N to a value that is greater
than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
support more event counters than the host HW implements.
Although this is an ABI change, this change only affects
userspace setting PMCR_EL0.N to a larger value than the host.
As accesses to unadvertised event counters indices is CONSTRAINED
UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
on every vCPU reset before this series, I can't think of any
use case where a user space would do that.

Also, ignore writes to read-only bits that are cleared on vCPU reset,
and RES{0,1} bits (including writable bits that KVM doesn't support
yet), as those bits shouldn't be modified (at least with
the current KVM).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/pmu-emul.c         |  1 +
 arch/arm64/kvm/sys_regs.c         | 48 ++++++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 734f1b6f7468..cd0014d1ec16 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -236,6 +236,9 @@ struct kvm_arch {
 	/* PMCR_EL0.N value for the guest */
 	u8 pmcr_n;
 
+	/* Limit value of PMCR_EL0.N for the guest */
+	u8 pmcr_n_limit;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3053c06db7a9..ff4ec678afbd 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -890,6 +890,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 	 * while the latter does not.
 	 */
 	kvm->arch.pmcr_n = arm_pmu->num_events - 1;
+	kvm->arch.pmcr_n_limit = arm_pmu->num_events - 1;
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index aba93db29697..959bd142b797 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -949,6 +949,52 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 new_n, mutable_mask;
+	int ret = 0;
+
+	new_n = FIELD_GET(ARMV8_PMU_PMCR_N, val);
+
+	if (unlikely(new_n != kvm->arch.pmcr_n)) {
+		mutex_lock(&kvm->lock);
+		/*
+		 * The vCPU can't have more counters than the PMU
+		 * hardware implements.
+		 */
+		if (new_n <= kvm->arch.pmcr_n_limit)
+			kvm->arch.pmcr_n = new_n;
+		else
+			ret = -EINVAL;
+
+		mutex_unlock(&kvm->lock);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Ignore writes to RES0 bits, read only bits that are cleared on
+	 * vCPU reset, and writable bits that KVM doesn't support yet.
+	 * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
+	 * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the vCPU.
+	 * But, we leave the bit as it is here, as the vCPU's PMUver might
+	 * be changed later (NOTE: the bit will be cleared on first vCPU run
+	 * if necessary).
+	 */
+	mutable_mask = (ARMV8_PMU_PMCR_MASK | ARMV8_PMU_PMCR_N);
+	val &= mutable_mask;
+	val |= (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
+
+	/* The LC bit is RES1 when AArch32 is not supported */
+	if (!kvm_supports_32bit_el0())
+		val |= ARMV8_PMU_PMCR_LC;
+
+	__vcpu_sys_reg(vcpu, r->reg) = val;
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -1723,7 +1769,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
-	  .reg = PMCR_EL0, .get_user = get_pmcr },
+	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(SYS_PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(SYS_PMCNTENCLR_EL0),
-- 
2.39.1.519.gcb327c4b5f-goog

