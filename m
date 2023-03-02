Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEF16A7B22
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 06:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCBFxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 00:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjCBFxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 00:53:09 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E370457D32
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 21:51:50 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id e195-20020a25e7cc000000b00a1e59ba7ed9so2970493ybh.11
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 21:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIeZqQDsplqWeP29HSexHYJ737JRXcOhQ7J6+HeNN2w=;
        b=G7n5xRm8RuF8DWUa4l/dLwnWK40+IWpfuZf0ysJNlcCfBoklRxlEITp3YycBMOORKJ
         B1TCLExmdY4QQO8YBfGSb1K8/NdSEuqGiPOpnbvcVa0XUuYZOTsXKHWJkZiy5ydEippp
         d5dLg66/P6IfBlW1CMH5eFq8MQhHQhFkD1S27UABk5qRXTdCPMWuoeiqxwgOdbW3agzZ
         xcDn9pMYTT/2TcSno3TOuLAZL3SIzukVCHBGqoQ6PFhGe8HOVYcfwSUe82Jlsorf50zg
         eRRIKDMiN94VfqUUSM2An1jKG22Q8worBPPp0YTpyxoXdwi8jl5E9oD+BQPNFMpSsJrt
         L+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JIeZqQDsplqWeP29HSexHYJ737JRXcOhQ7J6+HeNN2w=;
        b=eGCKuE0WAkgJ3w8aOeECkKR2LOxhcNgvHC8cU96+gZq52BWMefsJiWsoPK5uYxG1+T
         T/1fPKTM1Ulb5WgoVhlf6k0hPhmvEshe3hn9x3mWjXJTOLBpbLy3SN5FeE0yJqIAqSvm
         lYDE9uMjN1h0a296iqiB55x2sCvikFuKZ7+uZQ5yp7yoghQYXK4aXfWGlVvpf4czbhXn
         JFbaEYnuAOWeft4w66cE2BkmtuAR4WZ1xILGqtusCowmcNNOxXHV5yRgZpaNhaWSj8Ho
         Fi5KcHCOr2wdMUu20J2G5O7TQi5Skvgm4SsAawgOuzsVYArBexNYmln01ga+BtQ++5Am
         MGSg==
X-Gm-Message-State: AO0yUKU3AwKsPkbf3z5UIIl/jhcDRebNijBVyExWAbUlcgraxUz/s0iT
        5SQFCoi3quXBQvH5huWHobpLdd/FyGA=
X-Google-Smtp-Source: AK7set8kXeijwpd5IrzgWApLjro6tbe3Ft4KHgEVuEL6iPTP37OQY2fZkgCjZ3ALNfhQIYq/8IZYFpXUm4U=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:ac4e:0:b0:535:5e8c:65ef with SMTP id
 z14-20020a81ac4e000000b005355e8c65efmr5482065ywj.6.1677736273146; Wed, 01 Mar
 2023 21:51:13 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:50:32 -0800
In-Reply-To: <20230302055033.3081456-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230302055033.3081456-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230302055033.3081456-2-reijiw@google.com>
Subject: [PATCH 1/2] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return
 the current value
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
        Will Deacon <will@kernel.org>,
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

Have KVM_GET_ONE_REG for vPMU counter (vPMC) registers (PMCCNTR_EL0
and PMEVCNTR<n>_EL0) return the sum of the register value in the sysreg
file and the current perf event counter value.

Values of vPMC registers are saved in sysreg files on certain occasions.
These saved values don't represent the current values of the vPMC
registers if the perf events for the vPMCs count events after the save.
The current values of those registers are the sum of the sysreg file
value and the current perf event counter value.  But, when userspace
reads those registers (using KVM_GET_ONE_REG), KVM returns the sysreg
file value to userspace (not the sum value).

Fix this to return the sum value for KVM_GET_ONE_REG.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c6cbfe6b854b..c48c053d6146 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -765,6 +765,22 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 	return true;
 }
 
+static int get_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			  u64 *val)
+{
+	u64 idx;
+
+	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 0)
+		/* PMCCNTR_EL0 */
+		idx = ARMV8_PMU_CYCLE_IDX;
+	else
+		/* PMEVCNTRn_EL0 */
+		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
+
+	*val = kvm_pmu_get_counter_value(vcpu, idx);
+	return 0;
+}
+
 static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
@@ -981,7 +997,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
-	  .reset = reset_pmevcntr,					\
+	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
@@ -1745,7 +1761,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
-	  .access = access_pmu_evcntr, .reset = reset_unknown, .reg = PMCCNTR_EL0 },
+	  .access = access_pmu_evcntr, .reset = reset_unknown,
+	  .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
 	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
 	  .access = access_pmu_evtyper, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
-- 
2.39.2.722.g9855ee24e9-goog

