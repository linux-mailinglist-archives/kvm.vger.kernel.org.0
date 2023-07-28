Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4BB76745F
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbjG1SUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbjG1ST7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:19:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C703A4483
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:19:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5847479b559so18221047b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568395; x=1691173195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aAekjaTFXjEweeDH/Mb/ZF43LZdu52WOafvdUDqv0bc=;
        b=x2Oe9AirNgS7MogCIu5oJEqq/52wGFhjSA2r8zXGXeSPnwQQ56qElMbIeSrctyuSqn
         VhgLSHooyJxBubxB/sekpoO36br0Rw+VItm+aildhM69+/WctF+kNs6r9HGT6OYO23Te
         Mlr0ZD5d538njjfjNMnVNE352zXLPAAv44OXzX8WamqjuGJWQMfwUU1qjYZB+l6gksTk
         4E/FO7lA60doM+lD8gYzmS+QNLXiHt69J6ffxgwXmnzn3M9sjEvlGbAlMlGLAKF0ki+O
         zw7xZ8/SQiHGQjZhP0EXB1qy6o25gtwhaZb/BL0DU46WRCDv1/ATWDApKWQAKxTYnXiB
         A54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568395; x=1691173195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aAekjaTFXjEweeDH/Mb/ZF43LZdu52WOafvdUDqv0bc=;
        b=DExjvqvkW+IFFdmOr3JvRl3rWn41svteVq9Hn4RY/oXKPouW+VsshopGXjGYF0haX3
         Pnx/5AmJMnhKqqoFDtWIDe9Rosx8j070WjX+KLOaQGw7txjXGR+dVhYHw4854REtJ2qw
         PwZnshmuVsU5Ejk6Vy7MKn4XFHV6yp2nJHrklXkjQ1LNd8dDrNck13sjZ2o2QdTyySgw
         1krTFsz4s0n7utmf0QlaJnM1GuYEa+EzKGLJIt/qjYYg1fszXeGIYKcg1bb++XUwM/G0
         GuUQdx/y3z9c2fWp71kPJWpn2bQNsYPwQsyxdIAVhhS0n0ffzNcbHWtMhuou2b0d76yS
         YxGQ==
X-Gm-Message-State: ABy/qLak9RSNGgyilbQJ3lELVewqJ0AEKlRwDA0q2mvyD/uWzvnMbi+7
        bOQUGDpVdkXn4yAdTPgMPFXm60qpdPo=
X-Google-Smtp-Source: APBJJlEiuMt+iQwxWAR3z0dbeeYVal00IsgPQQYapNBLmQrDJITZt7qPg6Q37+JqAmmMLNr4R/yVTSp7USo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:b28b:0:b0:d0c:e37:b749 with SMTP id
 k11-20020a25b28b000000b00d0c0e37b749mr13192ybj.10.1690568395653; Fri, 28 Jul
 2023 11:19:55 -0700 (PDT)
Date:   Fri, 28 Jul 2023 11:19:05 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-4-reijiw@google.com>
Subject: [PATCH v2 3/5] KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
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

Avoid using the PMUVer of the host's PMU hardware to determine
the PMU event mask, except in one case, as the value of host's
PMUVer may differ from the value of ID_AA64DFR0_EL1.PMUVer for
the guest.

The exception case is when using the PMUVer to determine the
valid range of events for KVM_ARM_VCPU_PMU_V3_FILTER, as it has
been allowing userspace to specify events that are valid for
the PMU hardware, regardless of the value of the guest's
ID_AA64DFR0_EL1.PMUVer.  KVM will use a valid range of events
based on the value of the guest's ID_AA64DFR0_EL1.PMUVer,
in order to effectively filter events that the guest attempts
to program though.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6fb5c59948a8..f0cbc9024bb7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -36,12 +36,8 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
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
@@ -56,6 +52,14 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	}
 }
 
+static u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	u64 dfr0 = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
+	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0);
+
+	return __kvm_pmu_event_mask(pmuver);
+}
+
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -947,11 +951,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
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
2.41.0.585.gd2178a4bd4-goog

