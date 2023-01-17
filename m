Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1BE66D3D1
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 02:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbjAQBgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 20:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbjAQBgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 20:36:05 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CBF23D8A
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:36:04 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id t12-20020a17090a3e4c00b00225cb4e761cso13647934pjm.3
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=300KIYOplSSI+ZMp3X/TUeSfcU5weuXC03K02O9sYcM=;
        b=e3uPjfL92VI+YaZk15R9Pjh1o0bTmFUgCgCOFhlKvx6QcljtI9lz6v/zbfJSXvCd1D
         iePHCuAoPzbThx8eQiufOY3N1km12jfbD/cou2HuyyJ+Lcks6hZjcTxr9AmbX0n0WwgU
         8dLluqitN3rdpOREVQp48ieClgybL+BAS2FXNmseBT+L87FIguRrtRc+f+51aE0ze0V9
         IJBPNu7PtOmIU1HobDWB2MihtfXtnwrcIFxlHwwteauzVb06LlFO+GgsJodWobJEzKEB
         UKghbjf4h72RgnjI8XjD9aZwQWz5JvXhq+FGDviZVrXadf4JROqAO9hMm0OJ5bKwv4d1
         QZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=300KIYOplSSI+ZMp3X/TUeSfcU5weuXC03K02O9sYcM=;
        b=WwH0XiGIPqt4SzwAWy8xODbdb8pjhqdrQ1hfyD4JlHWnoHGeSAErjKPyQElPllTyTt
         qRTg3H6YZGwSemwbqKKLkSwvRlveitLHXBDT8MemXHOyy0lAcj6kWHOpTv19Ns0s6Ck+
         oRfKt8oY7Zhx+EzRaDT2/NDldLa4OCmNsFo+aH93MbcNtmBu63HUnARiLdpGhh0LbCB5
         4REG8wCO4KPVYsT9I6dzMZE6oTjm0Ltw9zw+qL8FIrK2umoWT5keTfXFO0VEgk2S8rQq
         98aEAYcOOta2gvPnPtBVTugoreoFMhdHs+ScAT6IJgHNeZh/Ik+HIWBUuG/NjRT0zWwX
         QPQg==
X-Gm-Message-State: AFqh2kpvememq0VLI6X3B4Ola5rFbRAERFaoOtucz1G435nj/mYGPrNa
        qrx5u+spw85fPZpLWZS05HoL74sQJGU=
X-Google-Smtp-Source: AMrXdXs3rKjFgNbseEaHIbohSFHUxCQJdUXPGHsNJTk1fHY3uVZgpmMJpJfCn/DzEXDXOFyJQLcX1QD8O9w=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a62:e801:0:b0:58d:aeb6:2d66 with SMTP id
 c1-20020a62e801000000b0058daeb62d66mr130395pfi.66.1673919363765; Mon, 16 Jan
 2023 17:36:03 -0800 (PST)
Date:   Mon, 16 Jan 2023 17:35:35 -0800
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-2-reijiw@google.com>
Subject: [PATCH v2 1/8] KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
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

On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
This function clears RAZ bits of those registers corresponding
to unimplemented event counters on the vCPU, and sets bits
corresponding to implemented event counters to a predefined
pseudo UNKNOWN value (some bits are set to 1).

The function identifies (un)implemented event counters on the
vCPU based on the PMCR_EL1.N value on the host. Using the host
value for this would be problematic when KVM supports letting
userspace set PMCR_EL1.N to a value different from the host value
(some of the RAZ bits of those registers could end up being set to 1).

Fix reset_pmu_reg() to clear the registers so that it can ensure
that all the RAZ bits are cleared even when the PMCR_EL1.N value
for the vCPU is different from the host value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c6cbfe6b854b..ec4bdaf71a15 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -604,19 +604,11 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 
 static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
-
 	/* No PMU available, any PMU reg may UNDEF... */
 	if (!kvm_arm_support_pmu_v3())
 		return;
 
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
-	if (n)
-		mask |= GENMASK(n - 1, 0);
-
-	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
+	__vcpu_sys_reg(vcpu, r->reg) = 0;
 }
 
 static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-- 
2.39.0.314.g84b9a713c41-goog

