Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1730688E84
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBCEXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjBCEX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:23:29 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62A223C4B
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:23:24 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h14-20020a258a8e000000b00827819f87e5so3796688ybl.0
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 20:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+lTOMqZEuFEaNT61qUBO+2GaxyavVhauG1igBc20tgA=;
        b=PK76gQxhOVDeyvTP2E//JguBNyOHQYe6aDfiMNG68uFtZ9Mt4eIqGhceH3w4Tv7uK6
         Ps8Ut5EjxC3aMnq6OJYmBBigANjGhqm+gCn+KuQ9YBPVKD/qwjeSRqBGfODmGmRWLJdj
         2PMnBQ6d6M75FDeTIMhss8wGcYnF9vyYi3oUQh8fiNqXeFCpu/828VnUB2mEFMws9Ifx
         J8WiePKArOMpW4alrfqJEgQC5SUW/VpG/BKR7R+qp7s/eimIrxAHcCo6OLMkRxEZauZH
         399ohqTJulad0xDkIoLYjzzxMQ48OPDQvNH2s+ZZdkyt3BUeMAz8N/g+Hz37CEWdycwb
         OEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lTOMqZEuFEaNT61qUBO+2GaxyavVhauG1igBc20tgA=;
        b=nJ0Mvzk5Ur9c0mo43isI7fIHfs71MgUN8/1wpqk1s8+8euTaF4izIQntUlvEzZy38z
         eLwxIjTfxpj1L6QwKRgmKSdt4YvJAJzh1rq2bDQOCqRrrDZCjQkvO1Lz5+gOWDcQ2eae
         czk3SID3e543p5967Uey6XP6HrWnvG/me/oqN92kfuGDB56uhI8wKgdkU5xXy9nk36tV
         +WmrPru3xcF5+PtOHGufQA8HvgqPG66KxG6AwyfcexzxdDzlgGqw8vtGIB1SK2sFE5bu
         2fl3Tm/ORRH+V/ipQFiEgzfcspMDKHvVxij8BRmA+Zl+Jbt8chKUOv0wROiVjGkaa3Pa
         Ajcg==
X-Gm-Message-State: AO0yUKWryxGE1S9GIzq0vCy8DqcfXnfubQl4qKgN73kWZN2XgufLuQM0
        SXf0XnJ2WwH9ollLeM8Dzk8ffpwqxIk=
X-Google-Smtp-Source: AK7set9IanJjSULDLBxl3uXOGzf9AFE8QBFbNG5ZQ2mcI+jJcEc6I9RwVCGqxiME38zDnC7Jl4VQnbJ+yNI=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:b285:0:b0:855:fdcb:4460 with SMTP id
 k5-20020a25b285000000b00855fdcb4460mr2ybj.1.1675398203551; Thu, 02 Feb 2023
 20:23:23 -0800 (PST)
Date:   Thu,  2 Feb 2023 20:20:47 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-4-reijiw@google.com>
Subject: [PATCH v3 05/14] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
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
2.39.1.519.gcb327c4b5f-goog

