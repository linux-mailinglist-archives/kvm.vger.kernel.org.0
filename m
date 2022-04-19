Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6950650B
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349090AbiDSHAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349088AbiDSHAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:16 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85963056C
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e18-20020a17090301d200b00158faee4449so3115206plh.21
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+RIFV+GBe2M89AsHlXZMsb8M9PH2fcdCA31lX27Exl0=;
        b=jHfDWDQBRdFMX1KUZ7M8h7PpM144EBI9vT9022UC7DTugoUZgKVXh5XxcMJR3sxN70
         aoQkPuceSyyGP29G1menl9lnaI1m0kUA+fvRB7mzGNAWeYz5l/fUgvMoob1N9gab1My7
         UWCic2ZNLYXUgeFFIn4H97XVTt+viw27rpDxXWVHJgA1B6p2CmVNcKJ6TLveWXxE/xQk
         ydfiv5X53K1FVVmXor1T/C4gL3g0lIyJ9MLApM8nzmMIH6pNamH5H0+iUvJ4kqd03eXW
         b47bh5b8cCNcl9sSjgo+NkhW9d2Yibv3AQ7C9gI5XGp8J4zhObzXeuECjtA3WNtmsgOr
         Pefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+RIFV+GBe2M89AsHlXZMsb8M9PH2fcdCA31lX27Exl0=;
        b=CZlxTWglNmeRcBLkCarkxTJus8aJbFI6RCV6KL77TXPCCGvrAUAAFYo3aR5lWQB8uM
         l4MJBd2bLm9Z7BmWdix5BGosUW94QfOIHKkRX0RzOoao2dLQscMiChmvYA7S2yi5N+6i
         3mC/NtcNFe9ic3OSfjorx1iTlh01YBu46lf11bswVZWH/e8beXuLdNt2lsfdAVhPayxW
         7NjvBBmmkpJywu2f/CarUoP5B9OtEc7v3vSebCXwuIdJGJO+JK/M8ibbQJGaOq3Ai5NS
         SAvGIrsV6QqAvB4V655WZqvvdjaomPceDN3ihwpTYjNJzFOqBsPyPaxDEsNmh2rcGJ1J
         C/Lw==
X-Gm-Message-State: AOAM530JC+VVxrB5/wiBFqxIainnSlASI/onElDqBsnAVY9hFWT3VUBS
        i2DdwXkWTxX/mY5v6VvTt8QF/USvG6s=
X-Google-Smtp-Source: ABdhPJxyzd0FpvVmJHlsUoLjVst/BJV+186a7Jt7JsU7eedDcva2Fw/AIAC6p8ib5uPpHPfQ2iIiPlO8PG0=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:234f:b0:4f6:f0c0:ec68 with SMTP id
 j15-20020a056a00234f00b004f6f0c0ec68mr16406433pfj.14.1650351451950; Mon, 18
 Apr 2022 23:57:31 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:22 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-17-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 16/38] KVM: arm64: KVM: arm64: Make ID_DFR1_EL1 writable
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
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

This patch adds id_reg_desc for ID_DFR1_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9eca085886f5..3892278deb09 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4142,6 +4142,13 @@ static struct id_reg_desc id_dfr0_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_dfr0_el1,
 };
 
+static struct id_reg_desc id_dfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_DFR1_EL1),
+	.ftr_bits = {
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_DFR1_MTPMU_SHIFT, 0xf),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -4150,6 +4157,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
 
+	/* CRm=3 */
+	ID_DESC(ID_DFR1_EL1, &id_dfr1_el1_desc),
+
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
-- 
2.36.0.rc0.470.gd361397f0d-goog

