Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6C2443D41
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhKCGbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbhKCGbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA63C061224
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a127-20020a627f85000000b0047feae4a8d9so814064pfd.19
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W1vWCSi6sD57/ju+MVWHrUzS8zlg3LpW8mzLjXGDeDs=;
        b=rEWlkDyGEepBbZ57FgoY7ltu6LDMAMHAOOx0P/jG/yyYU9fE274fG1o7BMK5p8Jp2e
         fKv91hIezGvLwOizMBpz+AGj+d7MNMWHzgrQEysT3B7rt4Cp7Hu+m7xk6d2ehFoxHzVf
         8ZsFFC+z/yC6oU3DBJCC5pHkNs3qfHXH5hX1KYvrxNfMTfQb5XAKyb1fQNOyJnOzxS0E
         Ow9wk2a0+f4tCA215T3nAoEa4t5ki9eX3BzTu4su6xHI1ULMqLRc6leSTSVCTDmAW13x
         zJ7Aej7Nw9Y5mBEo2nNT/L3287ObrbtpP7EDuyzAm/WpYJnwmG2D4adVYA9LvZJp8Dne
         fUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W1vWCSi6sD57/ju+MVWHrUzS8zlg3LpW8mzLjXGDeDs=;
        b=UU5UJJfYhc5LcFsWXMlRuA5bw2w5YsU1g583OIJLPqPi62eAj/WY3MsNzSOe+OOdZh
         T3rJqCYnrhRJCaklobaq/aG0oG266YvK5nwVTxk7+ErMfdJT9oksSv28RidIb21HbNIR
         jm8dtaNvUOIC4P+tXl9fzxRMRwrOUq/RCBOTWmgHSP7trDzuh7lZWraOQkfI+oO7uvvP
         hXzo2hBGFlhzV/cVnVlMek8eUtxZWLWbuqXU8Mi8Q8IcqXQoFH01lW/t4qtzzwLUB94N
         heqYz8b4rzs/NhevMavJhDhWFY7icv+issYF1/VECIXPvaD/Fimz4uKZRiMz95gVvNrR
         wXbw==
X-Gm-Message-State: AOAM530Q4ENkYeE4pRx4b1Yk1EY8lprKLkHt0JOrCtAXGsspO1zW76eB
        YNmipIaZ49XnuP8GcjH2/GY3X7VgrQc=
X-Google-Smtp-Source: ABdhPJxpQrRh12VLHNp/Qx/9xMnEFQ2hpQUSo9QzZqIcUPAIyKeeunNcRbGPMB0s9Ps8/EYxlzsFOQYqYNw=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:6bc8:b0:13f:8a54:1188 with SMTP id
 m8-20020a1709026bc800b0013f8a541188mr35966678plt.49.1635920912830; Tue, 02
 Nov 2021 23:28:32 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:15 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-24-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 23/28] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add feature_config_ctrl for MTE, which is indicated in
ID_AA64PFR1_EL1, to program configuration register to trap the
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 99cbfa865864..da6bc87d2d38 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -424,6 +424,17 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
 	.cfg_val = CPTR_EL2_TAM,
 };
 
+/* For ID_AA64PFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_mte = {
+	.ftr_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_shift = ID_AA64PFR1_MTE_SHIFT,
+	.ftr_min = ID_AA64PFR1_MTE_EL0,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_TID5 | HCR_DCT | HCR_ATA),
+	.cfg_val = HCR_TID5,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -880,6 +891,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64isar0_el1_info = {
-- 
2.33.1.1089.g2158813163f-goog

