Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AD672AE72
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 21:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjFJTpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 15:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjFJTpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 15:45:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A4A2D55
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 12:45:19 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56cd82e48bfso23832537b3.1
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 12:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686426318; x=1689018318;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DhmS+5Rbxn1VEYNEf/6MMSLp+0EGyRm+QoblFWUsSik=;
        b=NQHfPTF48NEz0KFbVuwd78qv8DOKvNH5I7z8FB5J0eJFMNwbBhiyD2v1x+I81tmFFC
         n+XgMlCrEXyYSgoaVbBFMJlCxn2qAqWXWoEj+BJCOFROgxBhXwT/25s1+lfyyyM3WGhM
         khd6GuD+zGW2V3ZSbh/vyYdudIz8SyH3Ce0iuzawnyasvtv/Z2yE9EiKmo1gfTWBm5EZ
         msIBgSC+hG/mNTJe+0mP8P51MQNfjhIE24Nnj2K6rmUHOdYRFFA7/uCoOkBozsDfwm2U
         CvhXh3YUnHeWkJXJdZKflGBBMQ4JVzl30IGvurmsKmJAhVgCvkfZYj//lyo0Cu6D4KY+
         V+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686426318; x=1689018318;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DhmS+5Rbxn1VEYNEf/6MMSLp+0EGyRm+QoblFWUsSik=;
        b=Y1gOLrnEM4IhBHtDWBtzXelZYrEJo2oty2vDMup+cW23R567ix9HeGS9ae1Q2+xjwx
         akLrTdqsapj9qwIP20sihztS4LiWar+BkNI8KjrRHpKv1BPYKy34W4ELpOseBLUPn1X7
         ceVLCtAymAwwr+jGNvF9OqBrr8hLvcaTDOW+FdeMdq1i74dDPs7y+gBJcbZh4otfkiPg
         TKLkoR5uVvXjZVZbDkJDxgYco2Cl55vgmqZ+udZqw2raS52lIt6WeIxamg1zdgnG4sS5
         b/rX1xSy3CXvT3kVuk06fcPaTnR/RC6ze/KlJUCxafLHTfbxrHbF7lkBQfN1NSAEw2kC
         1CKg==
X-Gm-Message-State: AC+VfDwm4h/HLK0qG3BtmR+XDZI2Xnc4REcEMs6Nd9/JFXCnUSnXT3tI
        QzWtIY+QjDUH5BCikv/233W/OjKEeXc=
X-Google-Smtp-Source: ACHHUZ6GNWiW+9MfWShyd11SyiEsw54ELBW+E0xkIuzWcSOJYkhY6fKB79FSpMLSbxUOjReFDpoKZ7i9IXo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:bc2:0:b0:ba6:e7ee:bb99 with SMTP id
 185-20020a250bc2000000b00ba6e7eebb99mr2545129ybl.12.1686426318417; Sat, 10
 Jun 2023 12:45:18 -0700 (PDT)
Date:   Sat, 10 Jun 2023 12:45:10 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230610194510.4146549-1-reijiw@google.com>
Subject: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid using the PMUVer of the host's PMU hardware (including
the sanitized value of the PMUVer) for vPMU control purposes,
except in a few cases, as the value of host's PMUVer may differ
from the value of ID_AA64DFR0_EL1.PMUVer for the guest.

The first case is when using the PMUVer as the limit value of
the ID_AA64DFR0_EL1.PMUVer for the guest. The second case is
when using the PMUVer to determine the valid range of events for
KVM_ARM_VCPU_PMU_V3_FILTER, as it has been allowing userspace to
specify events that are valid for the PMU hardware, regardless of
the value of the guest's ID_AA64DFR0_EL1.PMUVer. KVM will change
the valid range of the event that the guest can use based on the
value of the guest's ID_AA64DFR0_EL1.PMUVer though.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 491ca7eb2a4c..2d52f44de4a1 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -35,12 +35,8 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
 	return &vcpu->arch.pmu.pmc[cnt_idx];
 }
 
-static u32 kvm_pmu_event_mask(struct kvm *kvm)
+static u32 __kvm_pmu_event_mask(unsigned int pmuver)
 {
-	unsigned int pmuver;
-
-	pmuver = kvm->arch.arm_pmu->pmuver;
-
 	switch (pmuver) {
 	case ID_AA64DFR0_EL1_PMUVer_IMP:
 		return GENMASK(9, 0);
@@ -55,6 +51,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	}
 }
 
+static u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	return __kvm_pmu_event_mask(kvm->arch.dfr0_pmuver.imp);
+}
+
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -735,7 +736,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
+		if (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P4)
 			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
@@ -932,11 +933,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		return 0;
 	}
 	case KVM_ARM_VCPU_PMU_V3_FILTER: {
+		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
 		struct kvm_pmu_event_filter __user *uaddr;
 		struct kvm_pmu_event_filter filter;
 		int nr_events;
 
-		nr_events = kvm_pmu_event_mask(kvm) + 1;
+		/*
+		 * Allow userspace to specify an event filter for the entire
+		 * event range supported by PMUVer of the hardware, rather
+		 * than the guest's PMUVer for KVM backward compatibility.
+		 */
+		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
 
 		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
 
-- 
2.41.0.162.gfafddb0af9-goog

