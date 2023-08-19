Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54AB781762
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 06:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242883AbjHSEkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Aug 2023 00:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbjHSEkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Aug 2023 00:40:05 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8516A7
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 21:40:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-26b1371594dso1839353a91.2
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 21:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692420004; x=1693024804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AKUPjh6oK/AHt5DTbKeyntJhoH5vBBMqS9Q93jlsqh4=;
        b=BPxNSvzkcI0KKZBmZ9vQvp3Q195xCQ7XrW3Lauqrxtr/suDRr1vREqQ6vB0KZFVGix
         Bxkmn7EnM5GCcYKazSBbCKPV+sFDRs/+mMkUV2cVIR0H07p0pVTDSh346xHr3B1jj/qF
         8j6a0sb61kLuc3SOBP1x/1UMwSYQRmRPiyVh1zREs9bZlxecSC8WsR7qh9L+sC+N/K05
         kWCXI/PsQN2twFYHmk/cQKV0p0kWlPmLVsKhcDHr4hb2xWzVsDAMVK9Cjj3Zg4JKyWX+
         MHfewnRYEQUQAwbZ5umk4yK9/Xt7w+UZHhpnoHY4iCzxxE+48gCwKIzm4pTEwl43HG19
         av3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692420004; x=1693024804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKUPjh6oK/AHt5DTbKeyntJhoH5vBBMqS9Q93jlsqh4=;
        b=QoyNmowTUbdXVRpJSSatgytyV8f4xKHYcZHXzYbRht8b5V0YyHCiZhEbT1RcAe2Fbf
         1g7hpUBE8GXhMrMU8IRwTleSY7Qlop0BU3IHeDsFYggGsnnUhth96tKR9iL0OnMQe8R0
         yELzLGfZS+x7FtUae83SBTqzzcLWsT5eeFr0nxiHL+iV/p6d3A01o7CYKaw2nlhHSAXw
         NXAQsjr/AsUPDeut680z6shvAlyoYJSrY+VF36t2+jY8oe73cnrQogL+8CS3el0yzSs6
         UR0rNJEcprsuO+mvd61U0H+Hj8GMDt4untd7bzFWzUykAsjdQX3qdqVrNvXTHEO1qS7Q
         c6Nw==
X-Gm-Message-State: AOJu0YyAeOnBdDgQsS6mgm/9518QWC+ph7doxKW5pEy1K/3VVM47y8N/
        UHJ6Kttr0ZZxBuZav5JlRj8zRHMDBBM=
X-Google-Smtp-Source: AGHT+IGLxzRdP1MTKcNfYnDsSILLHW1aOrghtWBJGgIJIi7ddCSua7RomiZDF2YXdMVwaolTy42XkIptf6U=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:902:da87:b0:1bb:83ec:841 with SMTP id
 j7-20020a170902da8700b001bb83ec0841mr490814plx.6.1692420004335; Fri, 18 Aug
 2023 21:40:04 -0700 (PDT)
Date:   Fri, 18 Aug 2023 21:39:47 -0700
In-Reply-To: <20230819043947.4100985-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230819043947.4100985-1-reijiw@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819043947.4100985-5-reijiw@google.com>
Subject: [PATCH v3 4/4] KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}
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

Don't advertise STALL_SLOT_{FRONT,BACK}END events to the guest,
similar to STALL_SLOT event, as when any of these three events
are implemented, all three of them should be implemented,
according to the Arm ARM.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b9633deff32a..6b066e04dc5d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -758,10 +758,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	} else {
 		val = read_sysreg(pmceid1_el0);
 		/*
-		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
+		 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
+		val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
+			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
+			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
 		base = 32;
 	}
 
-- 
2.42.0.rc1.204.g551eb34607-goog

