Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915427AF761
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 02:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjI0AWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 20:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjI0AT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 20:19:58 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AF11C259
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a1df5b7830so53232157b3.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771615; x=1696376415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKu1b4ypf/1yghTsriWdPSnBvGzU0xcIPJuBHtiUctI=;
        b=jxNnwNjId4zwWnoM5Lc5fxMEBqlBiEYJXygy1QwBRgaxLJXwDQXN7gKruoh43ieUyu
         U4uZHU3MgivvYRkJ+nD39LbSJueISZqT4fWOUAszhpIISjN+DZXZH2F3EeDQkwa/tRdf
         MATE4xKjIGHH21GifDI+imCzzH2V4uHsRXtImqUkKl3wtVmN/m3/4RC+jPK/JdRbDegt
         hH1PGe92qNRyOgZyEXOiYO4OesoljzhtuGUL89atb169dfQ3NEhD/XmUVH15z1G0+Khf
         mQoJye0bjbZdVwE/e3jikwNnny4hMVDgwRlVksjTlw8yYRoE/bbC8IcwHh+Awoyp4nrg
         Wm9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771615; x=1696376415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jKu1b4ypf/1yghTsriWdPSnBvGzU0xcIPJuBHtiUctI=;
        b=B8SWonNrzsKwhpvV3RAkFWbHrL/kluRfdyQjrpqAtsTTeGNMaGDEUQujK1eGDIS2fr
         J4Hq4EfjF77XFdlSwbSDlPiQJQ8oVvzsw2R0iUmlKsNF8Pp5JwRw3w7tbmOVrCxgDOHq
         ysRPo3FBxFja02RQtp4UWcN/2hYDpgChNAtakJpFVLwqs3sZ5R0enAPlmApnCJJiOyLz
         bae3z/NC4dyniurxAco53sw72NFUISiD+EI4+8wai5kSoT2Nz6hRhiGnaVbWzbAzPrAR
         3M4RJ/1SNMOMToCtUTZovHOy/sZuwUlxMMBKBtDNONpGAlvu24Q/9wi5kioVc82siMDT
         YWIQ==
X-Gm-Message-State: AOJu0Ywj2c/Q1bEIYpEvoLHKjnczzUDh77w2eaRsRoQWJJMPFmkI6hjq
        37Z0udivCO3NP6WqY138ePa1a6vMTx37
X-Google-Smtp-Source: AGHT+IGV5SFhSIRyByL8fTSP12VqgZmgARh5Ry8ZzINOdYh4tv/44IYbvZ41cAWOSTLUQkOt8P/xRpn4mw7O
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:ad13:0:b0:d77:984e:c770 with SMTP id
 y19-20020a25ad13000000b00d77984ec770mr4746ybi.5.1695771615699; Tue, 26 Sep
 2023 16:40:15 -0700 (PDT)
Date:   Tue, 26 Sep 2023 23:40:01 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-5-rananta@google.com>
Subject: [PATCH v6 04/11] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

The default reset function for PMU registers (defined by PMU_SYS_REG)
now simply clears a specified register. Use the default one for
PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
registers on vCPU reset (NOTE: All non-RES0 fields of those
registers have UNKNOWN reset values, and the same fields of
their AArch32 registers have 0 reset values).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ffd123fae30d6..66b9e1de54230 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2180,7 +2180,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0, },
 	{ PMU_SYS_REG(PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -2338,7 +2338,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0, },
 
 	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
 	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
-- 
2.42.0.582.g8ccd20d70d-goog

