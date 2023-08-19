Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53A781761
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 06:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242875AbjHSEkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Aug 2023 00:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242866AbjHSEkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Aug 2023 00:40:04 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C8BA7
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 21:40:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583312344e7so22476997b3.1
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 21:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692420002; x=1693024802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D2rf4521dR3zfDVxwsUnaZ4b3GIZAWIZe5mix3E7tmw=;
        b=qJS+3BP7OJziky4Ud3VEiJCDjUq1/v8p2/3so871pbftG1o6VhLmHaKAvxvc/L0/lL
         RvCeLG/sgdDmxuip/JLrWp8B5ZiIpGuDZEPzkKvGL7Wg3vYk6L9uI6IuPq4l5LgLmXfh
         kHGTifVOEVrb/wXei6Jui/bmc3s7YTqeQ3iYB4FfHQuFRL/6SeEAyyfKS00ArXonMIYv
         yjG0yYi24sKXP7HhYV217lmUt+h4sE9EqNuLUVdP89KEd4X8eS+fP0KCnAV0RyzQwsPf
         Q1uTjgegb1D7RycOUdaMzSEY8qtgpI3IBfGaExfyHzH6dTzWNciN2emzhZJovG6Ia+Da
         syjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692420002; x=1693024802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2rf4521dR3zfDVxwsUnaZ4b3GIZAWIZe5mix3E7tmw=;
        b=g+sHd3u/Y2lii4nQF/cCD5toR/zXUq+MjDTDN/DK1xrsaxqkrijEqIcD1JAReGTQGp
         OkgbCgNhvhtVLe85bSlgCIxQ2sgXYISDPJiKnwCFrzcPwAXvz2s9CamJv0aUEw1aiYh+
         kUMCu3hWgWd5f6GYN3qTWo7Dyo28j6NBJFs3dzJGIwr7YXTU9CTYuKs/mE/uvNP2X61i
         miIgPVeaiHpJFSlQvyUuNfjft/Y867ptfkLWtbt87LtweoTy9EIrml/OrO0zTwEnyiw2
         cXatk3KejWGSc7ocVcFkOQMGl7re5wKp2d62I2VeKzbZQZflyxgXgTX/lyqqrweJN2mE
         wijA==
X-Gm-Message-State: AOJu0Yz7TDntDe/Ru9qdal800saM8n/MNwLfus2lb7MSyZMYxed7m5o9
        Jsl1v+JnYo0m4dBULsurZaYq+V0GJlQ=
X-Google-Smtp-Source: AGHT+IELA4iR22cgCTDziZj26+U0sQqaJauKgJgwS++FJVq1RlXhGN+EUKXwl62A9kMl5bSyEq87t/VnBkY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:b71a:0:b0:56c:f8b7:d4fa with SMTP id
 v26-20020a81b71a000000b0056cf8b7d4famr9410ywh.7.1692420002422; Fri, 18 Aug
 2023 21:40:02 -0700 (PDT)
Date:   Fri, 18 Aug 2023 21:39:46 -0700
In-Reply-To: <20230819043947.4100985-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230819043947.4100985-1-reijiw@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819043947.4100985-4-reijiw@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: PMU: Don't advertise the STALL_SLOT event
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, KVM hides the STALL_SLOT event for guests if the
host PMU version is PMUv3p4 or newer, as PMMIR_EL1 is handled
as RAZ for the guests. But, this should be based on the guests'
PMU version (instead of the host PMU version), as an older PMU
that doesn't support PMMIR_EL1 could support the STALL_SLOT
event, according to the Arm ARM. Exposing the STALL_SLOT event
without PMMIR_EL1 won't be very useful anyway though.

Stop advertising the STALL_SLOT event for guests unconditionally,
rather than fixing or keeping the inaccurate checking to
advertise the event for the case, where it is not very useful.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index eaeb8fea7971..b9633deff32a 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -761,8 +761,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
-			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
+		val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
 
-- 
2.42.0.rc1.204.g551eb34607-goog

