Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2717366D3D4
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 02:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbjAQBhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 20:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbjAQBhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 20:37:18 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AC723665
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:37:17 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id t12-20020a170902b20c00b00192e3d10c5bso20867311plr.4
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R/yQ6qOJ9nE5sbZwT5+Hdlb+OS4oscumD9F8iuYsEP0=;
        b=BIanP+6o+DalVgd3npztrKDyle5vEuGPPH2y24H9sG6gr8WHAqWrGxjc4qJOF3b7Pe
         pZ0ocJObA8sR1zKG3b4dtjvur3wtGP/F+RP81Lu2vmg/KJG3A5cY61EclFYbzoZmAD9R
         2t4xMqS2xPUWqi2ecaKApshFrbENbCi/23GuUYaeL+AQrZrLlr8C9X+eg1PV68Zzp/rJ
         FrpWTAt69byVLoVLigmqkOdQfbZOb83t1hj2H4gRXV+CPU32Jwi2Sv7wPPlbpjfe7N/r
         ZshXJAWwiJybZsnx4UMyJrAPpFVwfdEa+QeblTavPTbowIcGOkJ0WFEYxuUoeS2bNEq2
         3cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/yQ6qOJ9nE5sbZwT5+Hdlb+OS4oscumD9F8iuYsEP0=;
        b=pF+conzEL4+kQxwVeYwua2hKtVjABOc16IZcSM5xlmsUjCERq3s6WIx7V+/JTGeL18
         4cpPiLEXRV+IBalWLreim7MdO+1+6dutcJDQfzf2x7FkAADxjA7p0MfSCHjOkCfKysxv
         Kfko2dw0uGGt2FJUIc5ITRz8GkGwuQLCWImVU0CluSnrtcRDi+Y+nMaYwepzlHBhtucs
         ayEJhI1bj0nTQSI4+yqhdc+Yjp0+ktvlbVpsRQxilimMladWpPO9F4cUcLRGJuCvZOA0
         ktDjlW4D/0YfeAHv5u55hSMQsMvjeoUeu4MA1fUQVuasDQddPTN+GxlQ6Fz+fRYsq+Rt
         Pggg==
X-Gm-Message-State: AFqh2kr2fjLp/WcEjdlC4XeBemqtNt5wjyPOzsdJouLaW0WBE5saCIFs
        3qxoe0hJP0uA5x9pY4xgKMHvd4A7AZM=
X-Google-Smtp-Source: AMrXdXu1BwvGS43nNucWc8njSPNaqgCGpTv5cPH0A8yykvGIC9UMKkE3HnsLwdKjNbWczW0pdOjTVkd832g=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1401:b0:58b:bf1f:e213 with SMTP id
 l1-20020a056a00140100b0058bbf1fe213mr110981pfu.50.1673919436912; Mon, 16 Jan
 2023 17:37:16 -0800 (PST)
Date:   Mon, 16 Jan 2023 17:35:37 -0800
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-4-reijiw@google.com>
Subject: [PATCH v2 3/8] KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on
 vCPU reset
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

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, its value will be the same as
the host value by default. Userspace can set PMCR_EL0.N for the
vCPU to a lower value than the host value using KVM_SET_ONE_REG.
However, it is practically unsupported, as reset_pmcr() resets
PMCR_EL0.N to the host value on vCPU reset.

Change reset_pmcr() to preserve the vCPU's PMCR_EL0.N value on
vCPU reset so that userspace can limit the number of the PMU
event counter on the vCPU.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 6 ++++++
 arch/arm64/kvm/sys_regs.c | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..937a272b00a5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -213,6 +213,12 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
 		pmu->pmc[i].idx = i;
+
+	/*
+	 * Initialize PMCR_EL0 for the vCPU with the host value so that
+	 * the value is available at the very first vCPU reset.
+	 */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) = read_sysreg(pmcr_el0);
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4959658b502c..67c1bd39b478 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -637,8 +637,10 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	if (!kvm_arm_support_pmu_v3())
 		return;
 
+	/* PMCR_EL0 for the vCPU is set to the host value at vCPU creation. */
+
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr = __vcpu_sys_reg(vcpu, r->reg) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
-- 
2.39.0.314.g84b9a713c41-goog

