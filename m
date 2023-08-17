Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B800277EE47
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 02:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347394AbjHQAbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 20:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347345AbjHQAam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 20:30:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF15273B
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589ee10d363so40684247b3.1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232240; x=1692837040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dy3jz0Upm5vJJIEQd/6fuDwPpF3yAciYfyTeKkOfktw=;
        b=TFkjpdFK0U43ci9JaC0b/cB/XH6betgPdARDR2SxRkzVZXc72zWUOoTdcvk2K2CTyU
         4dJwnkVRj/2I6MNUtMwvGyR9yCygbWHI9lhSEqL/nrVD5O+hH2hZIb2yaMgkK6TglK06
         1i8lmzHSRWRIzEYggGOOcXxV/qf2TzUdcZGVzxcQ2taGdDoFjDsdKnrzr8OiN65YCz4B
         jgkNFLbBLSaHPaxxNV1ddtMKOpIqQK48zlfNLY8M8Qijc7dCZ3JBmobhIdDOsEgj/Uza
         H/m9OzW0E2OzO+NoFb1DBeG0iJihqMp0vPtYFRkHUsHmwWubuXF0eX1P5ff8b/cT5RmS
         gb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232240; x=1692837040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dy3jz0Upm5vJJIEQd/6fuDwPpF3yAciYfyTeKkOfktw=;
        b=f5FP2qEBE06sJn7vcI+zdK++2iSiTUn6/n2I9P7dBf1py6EEn3C89T5NpGol2RvTol
         kmb8BsJFw3Qu/VHVmf5CB23OS8RFipsuGDLwmQWiOGIWaTCYfMenYaLeS7Mkme/AZlfO
         3b0Ol46MW8FSCPcvdyzp/Iidzx1V3jpDobo5Q0VAqHATrfzR1REeiN386wfI0iBDD+/D
         aA4XXDUnqJaKYU9/zu27O9eQlGEKOaPMnNLz2SBWveeSsihiAS9MUz3xCIoIQ+Ir+lG3
         5knQ1Oh9AvtG/EJwgZP0Dx4C7TnyScnS03P43hVTex7gya+9QogPc9vNrOfQ1l2gCqfZ
         pE3g==
X-Gm-Message-State: AOJu0Yy7GwESSZtfuflVD26D6zIH6i7+Rz/340kRt1FIEbSKhdhaOx+U
        0RDhWzoil5RurxekRKxEozwgT+J1HvTZ
X-Google-Smtp-Source: AGHT+IEPXZGPdN3mdjmFtzRONvtRYtEgwzrrjDWsYxKyH65SNIn4If96nwlibegCkgzywaHufOlROrERuSM/
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ac54:0:b0:586:a58d:2e24 with SMTP id
 z20-20020a81ac54000000b00586a58d2e24mr48228ywj.5.1692232240685; Wed, 16 Aug
 2023 17:30:40 -0700 (PDT)
Date:   Thu, 17 Aug 2023 00:30:25 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-9-rananta@google.com>
Subject: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N
 for the guest
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
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/pmu-emul.c         |  1 +
 arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++++--
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0f2dbbe8f6a7e..c15ec365283d1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -259,6 +259,9 @@ struct kvm_arch {
 	/* PMCR_EL0.N value for the guest */
 	u8 pmcr_n;
 
+	/* Limit value of PMCR_EL0.N for the guest */
+	u8 pmcr_n_limit;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ce7de6bbdc967..39ad56a71ad20 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 	 * while the latter does not.
 	 */
 	kvm->arch.pmcr_n = arm_pmu->num_events - 1;
+	kvm->arch.pmcr_n_limit = arm_pmu->num_events - 1;
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2075901356c5b..c01d62afa7db4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
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
+	mutex_lock(&kvm->arch.config_lock);
+	if (unlikely(new_n != kvm->arch.pmcr_n)) {
+		/*
+		 * The vCPU can't have more counters than the PMU
+		 * hardware implements.
+		 */
+		if (new_n <= kvm->arch.pmcr_n_limit)
+			kvm->arch.pmcr_n = new_n;
+		else
+			ret = -EINVAL;
+	}
+	mutex_unlock(&kvm->arch.config_lock);
+	if (ret)
+		return ret;
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
@@ -2147,8 +2192,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
-	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
+	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
+	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
-- 
2.41.0.694.ge786442a9b-goog

