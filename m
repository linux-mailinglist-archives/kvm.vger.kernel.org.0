Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D0E76745D
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 20:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbjG1STh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 14:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjG1STg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 14:19:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940983C1D
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:19:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-cf4cb742715so2161053276.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 11:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568375; x=1691173175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T7cMhi6W1QA72qy6OnVjmEOCding/R2p1klzAYF0ZSc=;
        b=rF2yKEaY1+qGW4yqr/ZDga1hoWZYiI2p2zc8yQ9kHdT44KsPEvoMVekCxp8AfghkrW
         rMjKjRvkxs+wiCzBI5lgToksGFROkVlXlN+SkQIjZniH8ytnyaxvtlQRlJn9Cj8kcvI3
         KoFNL9T8OSKOnjnssPigziHXCqK1L3kE2iRASoTLF1OnyYkPMah8AsJk05j8hATC3ZZ2
         C8bnTiwVpe5/KEZBZIzcExtKteckZN91xceRRLul0/fRz8xcWAGQJvr8FcCUVvOx9LpH
         CBFXgWSA928eM+Yo7h1fWLEYXg24t9YcsTPZYlS7JEpAAXmcD3X0XI3V5Wi6vT6uSlm2
         uZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568375; x=1691173175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T7cMhi6W1QA72qy6OnVjmEOCding/R2p1klzAYF0ZSc=;
        b=VDoM1y4HdITTpB/VJV+ltn88rSvdRqY1ilC5rEq6ng55oBeKXbygA1jp785n2qPkCv
         TUAY2Rnof60p55YBQYs0LGrkY5EuBpEkwwLs9OS9N8VdUtWBshXLDoaKKDdWfK/SNMt3
         1slmQ/UmM6YK+X1Zp2EpLqD63txI+aYsP7u0zucoCE8RSAOsjXkgrWNATbtT2Y5vu+rE
         qhyu6mpd9Kld97ebkBhHqdcPgVryXmTpycklrxWYxci/w9SsyfJDeW21IdX2FsfM8Tuf
         R34JOJjeVrSmyqzOl1fVmqDgN+uxMO8cHQh5CJKIZDDb/WenCnDg5XbZNIrIdjwxYGU+
         85ow==
X-Gm-Message-State: ABy/qLZ8oWzH5ANAZzhJ6240lGpjdAqHCB7qljAix6XZPJnjuu3LvSZi
        9znvfO3VFuINyalxBqR+qekljF4y2/A=
X-Google-Smtp-Source: APBJJlHHrkbaWwlROgHKR6eB+lXZtSRXwpmBiCRMU364RcnA5ppYwL/doSe0Q2ZdQqFbWDIBBE84vPbLp04=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:100f:b0:cf9:3564:33cc with SMTP id
 w15-20020a056902100f00b00cf9356433ccmr18274ybt.13.1690568374733; Fri, 28 Jul
 2023 11:19:34 -0700 (PDT)
Date:   Fri, 28 Jul 2023 11:19:03 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-2-reijiw@google.com>
Subject: [PATCH v2 1/5] KVM: arm64: PMU: Use of pmuv3_implemented() instead of
 open-coded version
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

Replace the open-coded PMU version check with pmuv3_implemented()
to simplify the code.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 560650972478..dee83119e112 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -14,6 +14,7 @@
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
+#include <asm/arm_pmuv3.h>
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
@@ -672,8 +673,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
-	    pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+	if (!pmuv3_implemented(pmu->pmuver))
 		return;
 
 	mutex_lock(&arm_pmus_lock);
-- 
2.41.0.585.gd2178a4bd4-goog

