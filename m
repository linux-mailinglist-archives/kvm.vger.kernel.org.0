Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7CE692D97
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjBKDQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBKDQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:16:50 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F09C84F51
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y125-20020a25c883000000b0086349255277so6711031ybf.8
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=agf94AuTrHxCSXQaehK7Zl4P+40uGWhpn6X3L2a5GPA=;
        b=TFQ9QwV+p6zUCAWb8PQ0XUHpz7d7S20zrq4xFspgd62UPZ8ZwVLp4FZ7Ec0wXAGy5a
         mUxV/RSLDot3wPpar3LEfqAk4isVq7lujAAUEdQ+BVhpTKJfalBLcQFf73xu3sxW8ILJ
         OqJ6EygOpMRO/Ld2MC1q5qpUuvu2XVn00RDJtJBzH4okHXFIzloWw/Vs6rNNYaev3lry
         Gjxc5PFysYHP1T0QhyUXufhh2mmxWaRDlJFliqoDphGxMCC8l83XTNFqlwlGLxH7xHU0
         pMCa4lN0GmitdJIkqs0wtz9Cz/4owPsEdfJtJ2wHG3WV8DHTXA43OPrbrfXfRUEivPcA
         z9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=agf94AuTrHxCSXQaehK7Zl4P+40uGWhpn6X3L2a5GPA=;
        b=W5ywWDdXH3x58LSSBjwtA+5jz9DQG85K0c+8pj/+VAlmqdLx1RT0KyWkigZGSvKX+y
         TR+ucsX4p0KuzDuj0AviU8YNQXl2Tls21N/+UipDqvL1e0+rMdeSquK7H1iLrzEXH+CH
         BWFj2TNAz/gq/REpalzA48j1V3hjDpVudZztua9nQXGmmwlyGt4zWpFjN6aA4jspl0Ef
         s4BaQMlEDPjc77x9+hXPpFJTGaUR/FC491TFT7IbpRvM44Nk8WVD1/ieTibsF8tq1nRB
         loXGeqvqUjRzd8okfDWFjY1+4fghvPwhIcKn3VuUmCTWX/T6fNWGHnxSUPeZBI4jMgOi
         PqEw==
X-Gm-Message-State: AO0yUKXHhiiAyhmAVgLSdfsRCYK+S40D3ykoz/zli/MgTCoUgIdDn7aq
        3Xi+tNfWEsACDntRHANbc6tuHaTphGk=
X-Google-Smtp-Source: AK7set9b7sVz+BIQF/Y69bLjTeuuu6haCf6tB27Fceumt1tmwKTb6i26DmdDPHoNuYujCvhTV68xnHmJoKo=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:54a:b0:8bb:dfe8:a33b with SMTP id
 z10-20020a056902054a00b008bbdfe8a33bmr77ybs.9.1676085403814; Fri, 10 Feb 2023
 19:16:43 -0800 (PST)
Date:   Fri, 10 Feb 2023 19:14:58 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-7-reijiw@google.com>
Subject: [PATCH v4 06/14] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
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
        Shaoqin Huang <shahuang@redhat.com>,
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

The default reset function for PMU registers (defined by PMU_SYS_REG)
now simply clears a specified register. Use the default one for
PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
registers on vCPU reset (NOTE: All non-RES0 fields of those
registers have UNKNOWN reset values, and the same fields of
their AArch32 registers have 0 reset values).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e6e419157856..790f028a1686 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1752,7 +1752,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0 },
 	{ PMU_SYS_REG(SYS_PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -1908,7 +1908,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0 },
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
-- 
2.39.1.581.gbfd45094c4-goog

