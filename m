Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1737767462
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbjG1SUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235910AbjG1SUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:20:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F724487
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:20:19 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5840614b107so25167017b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568418; x=1691173218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2xpjPS24yC6WEaeqRzU4H7WlQVocjOmJ6iEHs3rd81g=;
        b=sb2e2ZicSoE/37geVNg2mh/h4mq9S8CUzH9QMg9+39Ayh8kR7c1EYB4Rv3pgMM7fq2
         QAWPYWqDZ0lg+u3wNr50hD1JBmCXsagcMNol3qqVr9A0Vaea+UjBHyulaWRkhlkhQkjN
         GEfMqAftZfvBNVxT2Q25jJkD+pTC9PKkFy+XMJXNRl6qj2ev1nN4xMLBqXAy0Sx7PbTO
         1AcTIVQeGb4HHnP8u+0VTSD22iyXQFDSnjl1bKavsRMD562NrSOYP8OX+vPoK5rm51wU
         2JJFJzQFz4VzSFyooEzfTWRn/QQh0WwgNySDamrd97nPZoLr1WbDBpDtf1SlqKVsVSoT
         TmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568418; x=1691173218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xpjPS24yC6WEaeqRzU4H7WlQVocjOmJ6iEHs3rd81g=;
        b=d+siEfuWek5cjKk8YIAwD0y9lV1See9I4nX/H4QZVYFiutk1Gb1V5ZfXC1GsW6pLW2
         FPDQfwa/EFf2TtXenijYzCdDxHRHDXD0qFGKJyukpfStk3+MT+bf3BdZZpsFwx4HlGrj
         ySo5bDuxYBP4YVYfHE6HGAcax5lUBmR6VqaZA0GQ6ne1JuntWLiouYpqo8gZroVnzwJs
         SvhvqHcyv9a+zvNKnHLMQ3GJB0dsHsO1o6Z8I3UHtJ4EmTR+Lw6tvdD/qJ5zrkg+cccv
         p1Vx2LVKuY0cofH87sxme5Fe3HNPabopg9V6ZpQajegUpDZqAPaS8ZvRk1gu1HW4a68c
         g71A==
X-Gm-Message-State: ABy/qLYYvEADnf1bJzl1fk+wvh0jb4UKxq5vX+UyenJ/XX0DscPfqwXS
        76DpTDpTwpLl4o7cHFWc747I6SNSLZU=
X-Google-Smtp-Source: APBJJlGGMEKDyFVWW5wq3CmTjmWkAG6EK1Hulf1y3IEUhbUXkjIOZDJYusNOd29d4Wx+PcVgk7IhawHjcJc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:690c:708:b0:583:96da:32dd with SMTP id
 bs8-20020a05690c070800b0058396da32ddmr20691ywb.0.1690568418572; Fri, 28 Jul
 2023 11:20:18 -0700 (PDT)
Date:   Fri, 28 Jul 2023 11:19:07 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-6-reijiw@google.com>
Subject: [PATCH v2 5/5] KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}
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
index 68f44f893b44..47a27941163c 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -751,10 +751,12 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
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
2.41.0.585.gd2178a4bd4-goog

