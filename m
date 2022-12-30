Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96C65947E
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 05:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiL3EAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 23:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiL3EAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 23:00:30 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E744313DC9
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 20:00:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n190-20020a25dac7000000b007447d7a25e4so21056994ybf.9
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 20:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQL8LpFQbWC/4XZqubGHc3h5rf9RkGEx3SeQGahZOzI=;
        b=n+I2UUck4OlTqPy8zYXZ+xx/sIHj/NUhsraDP+JLn0MWryS27ueidGVOObK6RFGIwk
         BL6kbLfQLA6KOWwK/h1q2OpjhInRT7uNChsTZ5/PeTLsJCvsdDOxa+A2jCHpTinNJ36o
         4AMQUVLsLbIMbEvDGIzAH1yA79wByfLwDHDsMUrSYeb8+6im1q5TQgy5cw8HdrV+c7Zp
         GSl4E62BZMYznQzrGz11QM5NRL0h7M9r5fdcQMXfDnMsWIAhhGAPJcg2S3Hqn/uIIpyt
         yO820vWLVAzXwwQGgmhGRNoyqLCDoN8Cz8dERHFNmTgEw+U1IRdEHsHBMDezxOFoydPC
         8bHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQL8LpFQbWC/4XZqubGHc3h5rf9RkGEx3SeQGahZOzI=;
        b=vRL6Wjdb70m514jBha288I7iuSIL9Ry91bmLtcVJtndYvAvfG25jKJIG1ya99tddgO
         njvgFXuh5sHhzbIouVzFIqIp3tO2e0w38sf4UzDNDzhlMwQRLyVyOsn6E7hp8A8CHUFx
         WELSLAlOr34iS/TZVyLnUOpUzBjb6npX+LTQ5RcoePNz43dheaxVqeWQc6mzGdmFypEh
         F4d81cWOQVd0iJViLtI7egPB/Kbg4015FdOvy/mWH9NHT59sFUvsJya8qs/uOsO1IoBy
         uqoPq2dgcEs+SFRka1lTY9DnWQ554BUJf4dAf1DMHmIxhr2yo5hF20xkezFid4/DkUh5
         QplQ==
X-Gm-Message-State: AFqh2kpHI3FAmYVfyNKgzI3eAoikg7GbDPQIcDfztnwwWCOOATcUgSIH
        V8hRUjtm8iSkegRDdyHx9VA0hHeaPJQ=
X-Google-Smtp-Source: AMrXdXvHWmdW4POEvsJkJXQsrQc//66oPLiXUgTOK4KT6ispQGJVgdJ41r+5ZfWiIhEAIgPbKE8yYf9Oybs=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:852:0:b0:711:6d3a:2b9d with SMTP id
 v18-20020a5b0852000000b007116d3a2b9dmr4131790ybq.133.1672372828203; Thu, 29
 Dec 2022 20:00:28 -0800 (PST)
Date:   Thu, 29 Dec 2022 19:59:23 -0800
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-3-reijiw@google.com>
Subject: [PATCH 2/7] KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0
 and PMCCFILTR_EL0
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
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

The default reset function for PMU registers (reset_pmu_reg())
now simply clears a specified register. Use that function for
PMUSERENR_EL0 and PMCCFILTR_EL0, since those registers should
simply be cleared on vCPU reset.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ec4bdaf71a15..4959658b502c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1747,7 +1747,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0 },
 	{ PMU_SYS_REG(SYS_PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -1903,7 +1903,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0 },
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
-- 
2.39.0.314.g84b9a713c41-goog

