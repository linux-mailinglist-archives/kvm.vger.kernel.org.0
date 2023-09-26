Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0597AF757
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 02:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjI0AV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 20:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjI0AT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 20:19:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D841A671
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d8997e79faeso5932384276.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771614; x=1696376414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qevun5/yY9+JK3ZHPWuRVz7IcDpyIACFdYtKkR+rLD4=;
        b=yRI2Di85SFVr7an7ncuLb8iD1LRwsoZWl94k6Tb/CHJurcyFpXpS1N4AR8+jUPNQlO
         9F9CknFfCNJTRYSw7y7ENFN6CKlKEf6MMuX2FDiSvqQmDtBT/kdm0nUpoohAXSSZhxdg
         fD2bhGh55YyBHNnpdfg/cXch8r+yp/5dsx0BAWK2HQQsDOh34oZU2IUa0jpIqSkKo3hW
         h7Xi3IPi8aKCk+46OeI/el9WmbvUPCIJl3XrGnnQvpoxlUIwg4pTsmEoNI9YTQ3ozzgG
         wBiI2R9E9Qirb31xcyt36wjIT6RRrxTW5oWkKsTVKlw3OBR7+XcPwrFRZLDUGChNI7Jj
         p40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771614; x=1696376414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qevun5/yY9+JK3ZHPWuRVz7IcDpyIACFdYtKkR+rLD4=;
        b=EVBCaIo5j+JnnKANAH4y8ae8qQWsWig/wVZNTDHmg4LEmLP4L28ZiDbJClfdnk9xvR
         pKPWE1LOTVRiq9fbRvy2DuPbVlyZ1BG1j7L7QYa7/Zx/Jq4ApNCB5bitUkc8dB+Jk9YB
         iDoW0eQMMYrY0O2+eXAIP5CbHVZ+9hH3QBm248LP4//lnfU5df9kyxV3/usq/XM8RfB6
         2IBrrDVxWSkrX/OF5i8KCaOuatbhgdvbTD3kF/EZ+k/LXaVIj0iCJLEUBhQD9qsxTBNx
         X8X7PvHFbRGLC1zuXZv9F+kUtqy3mu9hNslZXDttMDO+qfSKaQv/Rf1l2UpwvJK28X8a
         oL8g==
X-Gm-Message-State: AOJu0YyxO9WkwQ5xD2KbjWpV6wvWe5Sk4z7TCTkWjvHyUx2a7PJnZzuX
        jBL1zufKDMqavu9LFE/C4RzcGxFU+PDY
X-Google-Smtp-Source: AGHT+IEetmKobj2HvrfP5UmgYOr+yV8c5JH7C8utm5y5aVOqCwA2WWM3hZUA8gTkdds5ZVhPcUCGyps/w76l
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:4f2:b0:ca3:3341:6315 with SMTP id
 w18-20020a05690204f200b00ca333416315mr8256ybs.0.1695771614584; Tue, 26 Sep
 2023 16:40:14 -0700 (PDT)
Date:   Tue, 26 Sep 2023 23:40:00 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-4-rananta@google.com>
Subject: [PATCH v6 03/11] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

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
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d4494..ffd123fae30d6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-{
-	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
-
-	/* No PMU available, any PMU reg may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return 0;
-
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
-	if (n)
-		mask |= GENMASK(n - 1, 0);
-
-	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
-
-	return __vcpu_sys_reg(vcpu, r->reg);
-}
-
 static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
@@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 #define PMU_SYS_REG(name)						\
-	SYS_DESC(SYS_##name), .reset = reset_pmu_reg,			\
+	SYS_DESC(SYS_##name), .reset = reset_val,			\
 	.visibility = pmu_visibility
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
-- 
2.42.0.582.g8ccd20d70d-goog

