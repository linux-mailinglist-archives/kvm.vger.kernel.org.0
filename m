Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C057BEEE4
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 01:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379149AbjJIXK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 19:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379101AbjJIXKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 19:10:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF5B211E
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 16:09:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8153284d6eso6763077276.3
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 16:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892951; x=1697497751; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fdARUUKusxUQMjGBXV+ANnlmYThkUVs6hxgDwUx3ZvE=;
        b=AIFOvX2fQrfztqdrxJ3uBaHwRmWznpE0SgU2h5D83UhhX78bqCMdgmdhg9g+Y7vvp2
         JWW+YJZ9+ArXlPkFOz4K9iuMTQuk1dZbtdnxSBh+6cIPlmPeaak64z2tB7gfx9WvUEHq
         AKwDF10KBuc+dZklvAM/9BpqTWfg0QU1qqK2zM6jMSAn7l8H6mODZZemO6feaqdp0rDV
         8xPWRq1sD+dIts0C5myjhXsG45ehkIn3lftshZfIIeC2gn5yjXkR91YX76zhAmvLori1
         VmaTN4tehm1moTPY10eT6p/E+LX4SsEwpPpvPpbcVEn2l9ZAVXCmVsdjTr8ZLGfIVcrY
         I7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892951; x=1697497751;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fdARUUKusxUQMjGBXV+ANnlmYThkUVs6hxgDwUx3ZvE=;
        b=unNPsrfGVbBMhjoSdo7u/jEqpi7Ymm7w516KrR8GoD3C/nJ3r0NzOXoMqddtpTBGsj
         /f5ggEvvC9T/vX92LlGGB+c5mhN+umaoWUjgqUA173Q2EcwDKqPGBtGKtPprcmqy9yOM
         DoV+Ixv2wvehKeiGruFdzyNKM7YU0ILEZOTAoUFfEJ9rsaqDcg7RnNWkEFDUctIIuowp
         /oFZ0Oj8DuVjTXi7q8XtO4Z0jGwylPFfmHe2xhyalA7oHup989Y5Dw/3cwD7Rwr6hA6P
         YIQ7DNS/825pqrUswQl2c97a5ZWmmtShELOr4w3fg9tcKcaI768jmOiLmlm/Xcy1qcLU
         xPOA==
X-Gm-Message-State: AOJu0YwCyvX3Xpc5jinh6Kj+VXelV7TKrzz3W06Fd2xAMIubpPUj+ikx
        U36skh0w6pu2+ZHK1cGpD8jbCskj7ozQ
X-Google-Smtp-Source: AGHT+IFPG5m5pY2ciF7RtIv45EznHHERUOKqerEgN7jSlF+TN5zmlITE81O6tL7BoA7o1uHqO3aJ59+EsvnC
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:180e:b0:d77:984e:c770 with SMTP
 id cf14-20020a056902180e00b00d77984ec770mr291052ybb.5.1696892951029; Mon, 09
 Oct 2023 16:09:11 -0700 (PDT)
Date:   Mon,  9 Oct 2023 23:08:53 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-8-rananta@google.com>
Subject: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/arm64/kvm/pmu-emul.c         | 14 +++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 15 +++++++++------
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f7e5132c0a23..a7f326a85077 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -283,6 +283,9 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
+	/* PMCR_EL0.N value for the guest */
+	u8 pmcr_n;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 84aa8efd9163..4daa9f6b170a 100644
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
 
@@ -895,6 +898,7 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	kvm->arch.arm_pmu = arm_pmu;
+	kvm->arch.pmcr_n = kvm_arm_get_num_counters(kvm);
 }
 
 /**
@@ -1105,8 +1109,16 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
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
index ff0f7095eaca..c750722fbe4a 100644
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
2.42.0.609.gbb76f46606-goog

