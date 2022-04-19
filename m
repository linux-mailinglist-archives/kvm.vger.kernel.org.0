Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AFF506512
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349105AbiDSHAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349096AbiDSHAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FAA3123A
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:36 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so9261895plh.11
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k1aHxZoAaiwp9IBNDG6Sd3gJpxfpCorD51sV50ZX1Is=;
        b=Jli11xd8mqtWlIpeSa3R9uzukrE3588Wd4QhntxW82Bu/d8zHdDqy5Vnvhjai2huOG
         ctO1oRjeEaWQimFertWBqamfLaap9CKRToZztNwFW6AE5f77/xW9p6paFim7Eh7qvzSO
         ebE76Z2+yGh8wGatmYbFF/t13Q+dURYNiYoKJpRw2q7/OEK020kfrOfRxaTFtD8m1pBL
         ktAWStxHUd0QTBBINHesSzJ4IiTrb13R5/APAq0j6EGDHxYbYy5APaRw13Y0xyseo7hY
         rD7XzK+d9NrLLA43JNxU1nQ1vNk3faa9dqHy9TI1prJnH+RtsxwhlLg2kiKVaTaiNKH/
         mlng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k1aHxZoAaiwp9IBNDG6Sd3gJpxfpCorD51sV50ZX1Is=;
        b=dQQ3xuY6xS2x3+svlSYQ+LhyNMZYyejji0KmdWIiBA/EvSVOhWQjr59wOpOV4HlqEH
         9le+jlFT+N6eViZeKOCSjggZyIEO94WeT+PwjNggTGQsDo90tO7ZUmSvcshliCi0fpna
         7zjUb9ym4494QcKvF8Xpb7AJe3WRuooO2yx1BGj3SHsGTqWSoOp/z51DJewQo5K5WzD+
         iumzvM2ZkHAtsxB8mTS44rDzl6ZRqizG/nAlEzNQw/0Fun6bZohYkHdJWiJgZ0Pohq6Y
         GredUI1EPxUUfsjvyo5FnFKXsUa0wNW3e6r9Pju4Sx1y4qmtO4td/OWJA0ot/FXuv/xI
         QOrw==
X-Gm-Message-State: AOAM530iZbgt74fS4Jel9OXAMT0XjKhyCk5V2PQ8D5oE1Ycw56ByVf42
        xTK/l/7W6vnKUIMVuvFyPQB8hjemv6I=
X-Google-Smtp-Source: ABdhPJw4BjqWGKNFLnPZMZUC1+9yLnqihHWKtPmY8zD8R5Ja1UK3sVAaay5AnyQvY9iXieVJivmijHyA5sg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:2349:b0:4fa:934f:f6db with SMTP id
 j9-20020a056a00234900b004fa934ff6dbmr16170589pfj.44.1650351455448; Mon, 18
 Apr 2022 23:57:35 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:24 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-19-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 18/38] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_desc for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dfcf95eee139..9e090441057a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -723,6 +723,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_desc *id_reg, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -4157,6 +4187,11 @@ static struct id_reg_desc id_mmfr0_el1_desc = {
 	},
 };
 
+static struct id_reg_desc mvfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(MVFR1_EL1),
+	.validate = validate_mvfr1_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -4167,6 +4202,7 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	ID_DESC(ID_MMFR0_EL1, &id_mmfr0_el1_desc),
 
 	/* CRm=3 */
+	ID_DESC(MVFR1_EL1, &mvfr1_el1_desc),
 	ID_DESC(ID_DFR1_EL1, &id_dfr1_el1_desc),
 
 	/* CRm=4 */
-- 
2.36.0.rc0.470.gd361397f0d-goog

