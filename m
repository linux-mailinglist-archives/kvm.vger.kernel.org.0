Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C74659480
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 05:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbiL3EAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 23:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiL3EAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 23:00:41 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4424B13D25
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 20:00:41 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id z4-20020a17090ab10400b002195a146546so14886926pjq.9
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 20:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R/yQ6qOJ9nE5sbZwT5+Hdlb+OS4oscumD9F8iuYsEP0=;
        b=TOfBgUI4HFcbvh0KtsNM/9/o1ljcx4Cqad/F/ADZ81uGH6f8ziU+OldSZqnTjldSar
         WiTR2PvRUcHB3sXXEtotTUdzx4cHCeMEK4s9CaNx3M6rjrf8UpWKtK0lVBRkXGG7R0Ow
         wSC57/bdkzgNWhmjfxLHoHJ35ZeTliLCztAxl5oolvneqPKe1VPfDBAzaAQNl2kAdTJC
         RoZX7y2q/atgIXWgzJIuX9jklibMxhBblRPCYOM1xZRGMbe4837LKDw+Ldlk99ynPvAH
         jfY654Fy62qyUHhAbxsK6w4Htvnzuc6dL+oKNVpX2FOq8bE6D+hKT8xAfCWfVozN+KXH
         4icw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/yQ6qOJ9nE5sbZwT5+Hdlb+OS4oscumD9F8iuYsEP0=;
        b=sBhgO5D06xcOdOCm1FkAqlCdrYN4vX4nQX3yrx5VktKDiw1ZIQ8G/XDKks7Ndqe6Re
         ZHDXN9OBHFPE3qhUpymuEn1Nt0bvkpWG1wN4asRQMG29QaTIjOP3Zv8ja6UZczfCBAAR
         LU0qlIF21BTHPt4N8b2Rm0DdjYHCIPSx9/c70JtkwOuWH2i8Xe3MYKC+Bud2uw1S5z9y
         9zrygkVk10pWn0D0o0KPEB6gLRObRzTvzyPvGzcDts+ewn5YP92YlFvS1Fln9dP4rAu8
         rFD8++08qZYy3/ATgPZJRAvZ79+kUPPgJzt653EscqvAUWzeRaAvQt3xDQHVRHNOOSFn
         QQow==
X-Gm-Message-State: AFqh2krPWvh+d2oRfOsN1qTcX3TYC5nAWP4cUlew9Kj6tlOh4MesETp+
        A22ZeYm4P0JwvpJOuiuKjLzgVVWQlm4=
X-Google-Smtp-Source: AMrXdXsA4iCBx3qhY8WnvROWXZ/axMqc2KCGoEEEIPQYkLStYSSjcl0e/rJxaFRrNWsrhr+FV7fmOU0gHls=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:902:70cb:b0:18c:1bc5:ab84 with SMTP id
 l11-20020a17090270cb00b0018c1bc5ab84mr1583115plt.105.1672372840749; Thu, 29
 Dec 2022 20:00:40 -0800 (PST)
Date:   Thu, 29 Dec 2022 19:59:24 -0800
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-4-reijiw@google.com>
Subject: [PATCH 3/7] KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on vCPU reset
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
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

