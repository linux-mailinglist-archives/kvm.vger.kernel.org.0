Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1719E692D96
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBKDQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBKDQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:16:49 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1FA64651
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n20-20020a25da14000000b008fa1d22bd55so2247009ybf.21
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt9DyyP+jmxt2SRd9Qfh6SlGcBq+sGg3jGSKwiZnJL0=;
        b=C1bEkr31Oghws9EXM2+M78anmo1fN6vdiqVKbpzl4X7MsRntpD5o+I8PqT5MvEFooZ
         kQr7e8aA/+8WIn8xqsm3jq9Tm8xgZrHyMSJB1LdNMgX7JcRvxW0ec+JBL3MoVg8/d1sJ
         Z8tBsoDqXa556tZjMiWiSsqXliJDZVVvzQq4gmoLuLo7bi0OxJkM/A2ZqBuFyzf5VL1W
         EYQFEqS3Lrl26h+oAUO0PyL4iLKeMNQyYXTc1Rs6Xy7cJJvBNmpVypwHtvbpYDxpuNzt
         re45vhtC/opL+3MfEYkx1em6R9CUm90bIIztwg/woBPSmUrcDmmOlH0E09fXY9zPS63p
         yRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt9DyyP+jmxt2SRd9Qfh6SlGcBq+sGg3jGSKwiZnJL0=;
        b=Gu+ZLLUAgbn3Fk6w7v+vmTnEfBjWiCIE/UBGHZfJtECReGnIJnWex0t/ai/Nep16ja
         wE8/4iIxbkw10rrMBhFrNHJrM7diidDKbY+pGl85u4dYMVXPuPtFWD4I9+O5uFHdsGbM
         F6YCF4fC8mIkNMIsdoBFy6RpynEY7sLvBOSMzFgNU9iH1vrf+Nd8/WNPH0h62jqVoXbM
         vV1fVgTi025XVthokuzF90KQ0ZmmwFd6toNRnfgoOSU+lN6GapCvwHXc9aS6jhbbHqo+
         /VlOP8W21xYaRRE9BBUlKPl2FeUvywCtweIiNLCELHFnfhrm8oeI/xM8ZEwfcAHY3gdo
         POPQ==
X-Gm-Message-State: AO0yUKVpHiv5zzrxveTY8bnOcQ+5Rn9RXqiLO9IwxlbAEN83X150GSpv
        VNDW5hrC1AQGcOpNgLBEud2Pcv725+w=
X-Google-Smtp-Source: AK7set+ncL9YC5JFHYhtNyMYhJcbgzv4xqHEyW0dk7wxu2vqklwEMnCfyPDaS30N5G1PI7QfeeBSP5J2yF0=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:9304:0:b0:52e:e6ed:30a7 with SMTP id
 k4-20020a819304000000b0052ee6ed30a7mr158690ywg.551.1676085402308; Fri, 10 Feb
 2023 19:16:42 -0800 (PST)
Date:   Fri, 10 Feb 2023 19:14:57 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-6-reijiw@google.com>
Subject: [PATCH v4 05/14] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
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

On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
This function clears RAZ bits of those registers corresponding
to unimplemented event counters on the vCPU, and sets bits
corresponding to implemented event counters to a predefined
pseudo UNKNOWN value (some bits are set to 1).

The function identifies (un)implemented event counters on the
vCPU based on the PMCR_EL0.N value on the host. Using the host
value for this would be problematic when KVM supports letting
userspace set PMCR_EL0.N to a value different from the host value
(some of the RAZ bits of those registers could end up being set to 1).

Fix this by clearing the registers so that it can ensure
that all the RAZ bits are cleared even when the PMCR_EL0.N value
for the vCPU is different from the host value. Use reset_val() to
do this instead of fixing reset_pmu_reg(), and remove
reset_pmu_reg(), as it is no longer used.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1ec4a68b914..e6e419157856 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -602,23 +602,6 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-{
-	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
-
-	/* No PMU available, any PMU reg may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return;
-
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
-	if (n)
-		mask |= GENMASK(n - 1, 0);
-
-	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
-}
-
 static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
@@ -976,7 +959,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 #define PMU_SYS_REG(r)						\
-	SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
+	SYS_DESC(r), .reset = reset_val, .visibility = pmu_visibility
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
-- 
2.39.1.581.gbfd45094c4-goog

