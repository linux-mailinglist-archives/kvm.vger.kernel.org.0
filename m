Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652F0506507
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349088AbiDSHAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349094AbiDSHAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:18 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5445327B23
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u5-20020a17090282c500b00158e301f407so4999705plz.15
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kOtruObnAwr73tGi5MZAsEqpA/uKhtQAPuGoRa00WMc=;
        b=mTJ21013PiSwkw5o3Gbtoin1gGUFTC2f11xhWGdUiETUkhecccbVgbMOAwtXaKBtqw
         34ltnUdfLnvlsCBfBtytLBYdcq3Iprqi6xqpEewEB0sE+o7KVrPiafcRnuf2v6WzOaVz
         PEWZt6iQR+LcBRGuArYRWNqjokJGWZTYDaUxQIXIY/pYCFOQmIuyIaTXxmw/sbJbbr1C
         yyBD3zGKzxr9xv8DPDiQ998Qbyf/SibU/rYcpFowvPKU2y/xz0ceqb+fEZe2ToqdztS9
         zbY7kgN2a91vAerHogjHLztkGGHsfqbki1OYpRjBk4DLs/AKRYh2bDlAC/YTvmeNZDxM
         WRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kOtruObnAwr73tGi5MZAsEqpA/uKhtQAPuGoRa00WMc=;
        b=B/3QrCAnAUFrH9dlVyIUjNrEhTUWIzCqL6NqJKlc130i62PknQmFmDAGnkzlXD4uZ3
         /hG8CuDkRcNcjSVJOW4Z+Zrmon7gQtOzy2b2zDFRn7pZevwARVzPunVP0s7D16TJgzew
         kCbdiVgTVvuS5dTp0MBqEq9MVJCbp+tKpiKjlUmy6nWvy2RqjSRyROeRrUAoU2lnMARR
         frRZfKB/rF44a0/FDYJdp8Aa1MZWP6buE3Z8XFid9Uio4N4xfqbY04WUG5pLwohrLSC2
         R2FFQdT2rCeqsrWNCHZKpMQPfkbkI+TGx15pvuzF0QtFpkdkO1ZffXoutSnRZyJF8snu
         K36A==
X-Gm-Message-State: AOAM530zDFaXAo9NdohtO1roQLmU0KseC2WjQcpeJ7gsCRiMdOkoR7/U
        RsHxx4Dd9lJf97xfzoatngTpfhwrWS8=
X-Google-Smtp-Source: ABdhPJx6qDbSnrgYvhJroWf4jBAE01A6EcpohDsqf8ebCgDlStR+vqVIies+oFNL6BLxOeYZEqyR+y7SKVI=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr276854pjb.1.1650351453576; Mon, 18 Apr
 2022 23:57:33 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:23 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-18-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 17/38] KVM: arm64: KVM: arm64: Make ID_MMFR0_EL1 writable
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

This patch adds id_reg_desc for ID_MMFR0_EL1 to make it writable
by userspace.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3892278deb09..dfcf95eee139 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4149,6 +4149,14 @@ static struct id_reg_desc id_dfr1_el1_desc = {
 	},
 };
 
+static struct id_reg_desc id_mmfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_MMFR0_EL1),
+	.ftr_bits = {
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_MMFR0_OUTERSHR_SHIFT, 0xf),
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_MMFR0_INNERSHR_SHIFT, 0xf),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -4156,6 +4164,7 @@ static struct id_reg_desc id_dfr1_el1_desc = {
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
+	ID_DESC(ID_MMFR0_EL1, &id_mmfr0_el1_desc),
 
 	/* CRm=3 */
 	ID_DESC(ID_DFR1_EL1, &id_dfr1_el1_desc),
-- 
2.36.0.rc0.470.gd361397f0d-goog

