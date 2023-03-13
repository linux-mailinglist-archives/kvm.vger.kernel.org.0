Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2343B6B6E00
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 04:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjCMDcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 23:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjCMDcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 23:32:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759CE31E31
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 20:32:37 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l10-20020a17090270ca00b0019caa6e6bd1so6401321plt.2
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 20:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678357;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cy0M1iGheyvntKi3y+GjSM1iOxY11G04EpNocjkoq+U=;
        b=cTlJ+7udPzmM6zDFIF8ee2sFIvZBsuiRIzV3hNdqlXEPHqtV/3ijyFigaPGG7iWIbO
         1guLZBZQIfl0luMifYX5GK0gqJ3c0xz/QgTJgsbv1j6AMWobq0tNK8nGok9LbuyK+0el
         rvRQs5ZG/duTgxuDLv0bQtipFopuFsxP8G+HiucL2KRVM8o6xEf8/+vriszjqqrNtsZ7
         XGfP9seoWjth9Ksb9BeuGopHHfUcP5zGR+xoYhy5m2yI5Z2vllNEqNzt9XTFb7I3pGTK
         woOmBWlowBmXlGZWhKub2Au27Z0uepqBaSnUTTCfkeNGOi3xq8FbhneFxCaqOUneCp+R
         DB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678357;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cy0M1iGheyvntKi3y+GjSM1iOxY11G04EpNocjkoq+U=;
        b=oVLTcVB77p4gV0ny14aHwScokQ+gzrMdbsg9qidrPynrmTJT2ChmDrcN9USmCD9/7D
         D4LMYtIz57TUV+HbrCzdEasko1l8X0+U5I2ja9WNE+lgLrj4fRen3L5zLoNEXTWBip6j
         bGjFibaeHZppdE1rWqMiKrKIWlB22Nm4oC+re4BIifyJXRl9asL2vNHQeu1WlUaG16j0
         4wEB3h4h6HF9Fxz5Tv2FsbQggEJnCacthC6VCxC7CaG2M+cbDWf7NYYGJnaCYA1gButs
         iC8k4/OTxqmYsTbc1UJsaZQ24YuqEl/ySnE4xBlVyJkvgKPGvn4zufAWLIDNYoz/q7kP
         Iwwg==
X-Gm-Message-State: AO0yUKUH67L3rRRrKaEpDPePXDFmao/ZaoLKdTgeDx5wZMkHVCh1+ORi
        wo0bxNMPK4yQcSsL3EgoV6Ffix80J1c=
X-Google-Smtp-Source: AK7set/Qj4lGvY7S0/dBT1dO/b9crIdCITPApjcUxw1m+F6Uzkdmxx1UuVnqUaK/Yt3t/zLkSaQwoK0FjNU=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a63:b55e:0:b0:502:e1c4:d37b with SMTP id
 u30-20020a63b55e000000b00502e1c4d37bmr11190335pgo.12.1678678357011; Sun, 12
 Mar 2023 20:32:37 -0700 (PDT)
Date:   Sun, 12 Mar 2023 20:32:34 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313033234.1475987-1-reijiw@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
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
        Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presently, when a guest writes 1 to PMCR_EL0.{C,P}, which is WO/RAZ,
KVM saves the register value, including these bits.
When userspace reads the register using KVM_GET_ONE_REG, KVM returns
the saved register value as it is (the saved value might have these
bits set).  This could result in userspace setting these bits on the
destination during migration.  Consequently, KVM may end up resetting
the vPMU counter registers (PMCCNTR_EL0 and/or PMEVCNTR<n>_EL0) to
zero on the first KVM_RUN after migration.

Fix this by not saving those bits when a guest writes 1 to those bits.

Fixes: ab9468340d2b ("arm64: KVM: Add access handler for PMCR register")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..c243b10f3e15 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -538,7 +538,8 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_pmu_is_3p5(vcpu))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	/* The reset bits don't indicate any state, and shouldn't be saved. */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) = val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
-- 
2.40.0.rc1.284.g88254d51c5-goog

