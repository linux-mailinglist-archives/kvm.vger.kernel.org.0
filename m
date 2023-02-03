Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20004688E85
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjBCEXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjBCEXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:23:31 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B6D21298
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:23:26 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k204-20020a256fd5000000b007b8b040bc50so3759680ybc.1
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 20:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HBCz7z4MHncYI2KSfyYRfjQx9Mlcxqfcto8G8RgoI+M=;
        b=WofD4bhyrBhdRY20IdvABnvAxrZJGDg14FMZs4aRUuxFzcyyJNLD8BNBBOaCBqFvKm
         b+adIuQveo0NZ2IyySWJTMXaRtjsGVoB9q9vxBIimzF8cOvUB73PMiVm5IqyYRtpWWV7
         U1/MCwDf1QXL9F7T53pC+otZQ9ZT48w+Eh2gtY2UNGgo+v7tL3ENLIOci92h5nA1fwTO
         WmmAW0qdiBcWdAT9FsPT+2fUjjG5gputhLsp4bqaRCALKB2qk0fjiArKzUnIeEKPymXU
         +V9Vcf87R4tkBTJO0TS/VlrxUAGw+6IidvTOCHVsMgkNg4kwnDRKBO4/MwXxSoKUkA2n
         CcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HBCz7z4MHncYI2KSfyYRfjQx9Mlcxqfcto8G8RgoI+M=;
        b=zZTBd3okGgD5a3NQGeJkry/6MIJst/EkwIIOiHELnugjG1LlyFk7z5l0UgqHbHiU1P
         PiktEZvQyy4epWYl8J4LcfNvpC5DBS5HhOJdD3v1AxsEfpyLiG1gOWBkbUcz/AYuTsYX
         KBLJcqqrR3jtjBG3nnTZAui0EkaY6v21i1eNvwFkcBJhIdXzrPOx/PVvu+FQEHZTIPlj
         Z9xdlIobsgiELHdqmNWGFuqJe+NzutgG3HZACN50z2Ajqv0TB8IVQLJ3EOW2OFK4LpIc
         1E502s+h9mlLl0QhEG+U6+EMPHp/KlTLMHavsxNyxOi5/I4VTqriX3d5QMwRCI7Mk9b8
         uu+g==
X-Gm-Message-State: AO0yUKXjp2GVX+jqVPAAc/bKOpRJKiJK84mc4Pq7ZDsFItp1a6qhec3L
        DpeDn34GyoR9wA5Q1pf4SzsqRrqR8jg=
X-Google-Smtp-Source: AK7set/t8pe6lygSGCd7T7jks2ZMy/qqzT75Fgk2uLNRlJkG/RDtkFqloigxMAKyLeMC43xNsHeIvtJtJq8=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:cad4:0:b0:855:fd13:bc37 with SMTP id
 a203-20020a25cad4000000b00855fd13bc37mr4ybg.6.1675398205745; Thu, 02 Feb 2023
 20:23:25 -0800 (PST)
Date:   Thu,  2 Feb 2023 20:20:48 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-5-reijiw@google.com>
Subject: [PATCH v3 06/14] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
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
2.39.1.519.gcb327c4b5f-goog

