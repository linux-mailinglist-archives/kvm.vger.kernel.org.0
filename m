Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A60443D42
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhKCGbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbhKCGbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:12 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFF8C061227
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:36 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id n22-20020a6563d6000000b0029261ffde9bso981321pgv.22
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BX4KfiOrqcyrws1uL0O/L9kuIJ9ad1jF0+cPWSoKuUE=;
        b=Cq+Ej5Dj1LWD30hdNkPSEz0exbwNZnXqqPulw8Gmqzc7LR4lC1jHqktbHVxfhABplQ
         R9YrjUB/wF/5c0X663TPQAoEyOgm2s8MaUCPKA//pe+hdhCLIELWB9f+c9MePXEfkwwW
         S8xGsHcZfNSrlUrYoq6iTdvI/MQQWKbzxBHM6OKfL4DXiEjS+klxjDQ17u8YAMZ4cVP2
         eiuRKwsTRikzUj11zQXxroBCJhKZccdC9rinDOvLf0fMqGJuRQcPqsdJ4iIfKBUMsgbH
         N/tn/NDfYP5FFFbw+eq2fsqG/DGZb//M8atMntiHRDwqK81M/PBJJDc+T+kczg87BNrG
         wnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BX4KfiOrqcyrws1uL0O/L9kuIJ9ad1jF0+cPWSoKuUE=;
        b=NAubZKSDd/2KAtCYRk+5NPav7nP2siRQTllS3lK8k/xxI5lCAiB9G7/94gWI0bRmUc
         Cmued+BATEAE0RULs/AmgRr8yBu1Cs19GppAConPcVSZl5Wp5qgqljgljjtNIO4JspSO
         Ei7xQokuAVS40m/7KlDbB4ceQQkyDW54Yb078lRTwTrqI/ESDI01gSVmjdSpRY90B6XJ
         P+IT9xOKvCXjKUX3H/yRE1PJmnQuC/YpRNnixDu0p3HKd6cPQgR2BkY9TcslTCjCRg2X
         wCQmWkV5a7DC/Gt9Gpf7EtHa6C4BY6MSDwD2xg7Gu4khZCopyXUItu4/s2NV4BqqSVyg
         ElEQ==
X-Gm-Message-State: AOAM532ZjTrrggK5eWNb6qPN9iewfQ99FCo0KK9WQim/VMNEMMExfOS3
        o8EXWg/zCXAbbS5W450JCktU7/vwOn0=
X-Google-Smtp-Source: ABdhPJzuUEYjbQ+VthWhEtBAz70l7/XdAP5N4DRm0ePAhD1+zGjxBUKsgIracOcC41SAcK82UPr9qsMgAzE=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:a5c2:b0:140:14bb:8efd with SMTP id
 t2-20020a170902a5c200b0014014bb8efdmr36677073plq.31.1635920916024; Tue, 02
 Nov 2021 23:28:36 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:17 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-26-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 25/28] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
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

Add feature_config_ctrl for LORegions, which is indicated in
ID_AA64MMFR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Change trap_loregion() to use vcpu_feature_is_available()
to simplify checking of the feature's availability.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 67f56ff08e41..2d2263abac90 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -467,6 +467,17 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
 	.cfg_val = MDCR_EL2_TTRF,
 };
 
+/* For ID_AA64MMFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_lor = {
+	.ftr_reg = SYS_ID_AA64MMFR1_EL1,
+	.ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = HCR_TLOR,
+	.cfg_val = HCR_TLOR,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -968,6 +979,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	},
 };
 
+static struct id_reg_info id_aa64mmfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64MMFR1_EL1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
+};
+
 static struct id_reg_info id_dfr0_el1_info = {
 	.sys_reg = SYS_ID_DFR0_EL1,
 	.init = init_id_dfr0_el1_info,
@@ -1010,6 +1029,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1104,10 +1124,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
-- 
2.33.1.1089.g2158813163f-goog

