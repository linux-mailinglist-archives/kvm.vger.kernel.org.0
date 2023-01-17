Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C8D66D3D3
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 02:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbjAQBhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 20:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjAQBhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 20:37:04 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB49A23665
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:37:03 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id a11-20020a170902eccb00b0019476ac8ccfso6395318plh.10
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eC9TU+b1AulwCNQH9iDH+DAro1tSq5M9VVS0yBGcwEk=;
        b=pTfHbn8ECPuNLNJ2Du97YQ7SgX3rG2N1cPqBY0/gBrCiyAo0wNNJso7a5TAIuh4ML0
         LEshQKaWSd5UTKoQApFyvOZpi4Ti00acwDmnhhA9HsjoWA3rTg5ZykzvrrNt7vFxO/C/
         p1vg6AGjXPg7vvdJMCBh5OStNOaDF2Ux3yg0qrNskUBDrxzp7+L/bxe4gSSXI6mG+1YI
         ccaX9/iuVnPqZ6yr7WChriNCwdTqVROaP9Hy8UPl2mIIXQd9StFVSaKgsxhxDObNVfXx
         l7QzMU9Yid6Q53qTYfHNKhYL2ROX6Uy4yxDrzQ9+5Qx7tJRI+v5P1rcTL00+4WcM3Lrn
         Xg7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eC9TU+b1AulwCNQH9iDH+DAro1tSq5M9VVS0yBGcwEk=;
        b=hLJwN5IhlfBzpMeamo10G1x+Mc+CJJWFfbfXgquZMg5KuxKqBIlrrN7ggopHnwHUEh
         lp+fNyCWsnSpYZjvyrt4hx2Bfzk7TJJcS0GdWUzQ7UPXgViDfuIjH37oNdDt5Y2wXv6s
         VkR7AT7SQkhSWVBbEoTG1hdP1ThpUuWnZbbavhfA/3Oy+v5TGNeB/gWoNXBuaPQcYo8Y
         MTE1BNAFRTkf0p+jnUmZBbpAe0DZyOhPr+pCciQJUwmYzpNtvu/CEFD7cnPpwcB5XsAn
         7ZZT0IBUFJ0xYrf8F4pIQ/BztUIz7iYZbKlIj38GXnIOCqrok0wR2KX3ZYiDyoASzgOA
         21hA==
X-Gm-Message-State: AFqh2krYVQ2oKT4FQRujWja7a66WTaqShFgzuSirV438fTCx29EIN/xj
        be/ryBkt1tzRIBuCpb7s/QnoGl8pOkU=
X-Google-Smtp-Source: AMrXdXvUPDxrn4y21UKMvAWORpGeWfa/Ug/LOec+T5MpYmnHhsOtI7V0f55wuovNZa71BqVMEl3XpaOGjK0=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1401:b0:58d:9483:734e with SMTP id
 l1-20020a056a00140100b0058d9483734emr121553pfu.55.1673919423000; Mon, 16 Jan
 2023 17:37:03 -0800 (PST)
Date:   Mon, 16 Jan 2023 17:35:36 -0800
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-3-reijiw@google.com>
Subject: [PATCH v2 2/8] KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0
 and PMCCFILTR_EL0
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

