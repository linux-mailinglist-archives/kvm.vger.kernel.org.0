Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7E9506515
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349106AbiDSHA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349103AbiDSHAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6156B31500
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:37 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u10-20020a17090adb4a00b001cb7b5a79e8so1176195pjx.5
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XAe9o8/7QtvwA7T4kzsz7p8aDgk6j+Di6GgUS4L29XQ=;
        b=bjp6ZxrGAh7052Gw6Xdmrg+7KZKA2uAnPjBgjXkIw2dFvt7G7LE/TTe8/W3Oj57ExI
         cZYBHWsYxkJIQ7lHFYgAKKcsok3iLVBUXssHXQQQ655fJ2DAs1rIPQ936ssjYaDW5leP
         74OrsDeIahHKz5IKhc/qqk97SKOd4YF0gSsM2oRzjAKfleXT3nu/pB8ojlS0R+IA2MFb
         oN9GtMZPUdiMTKCBf2adntBJFKoPdzlR+R0bKWByFsr3b4kJw9P/zVfmY19IQAQJ+qut
         DV2weGfw90L/YB66aNJH8bfLF+/l6o4j7hpIPYdJMMBKUSgC5sOMHQ0BYi1Zjo5kIT7c
         BZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XAe9o8/7QtvwA7T4kzsz7p8aDgk6j+Di6GgUS4L29XQ=;
        b=DZflqRrt4i3vErLE3PJIH/f/Gc3qXFTuLyzNP1BrqJGnvVPrr7Tiukr/JEILQ14QAy
         S8L8O0JBy8nS8F9CtVp6zY0HFfxy0S6Vs0A1HkRVa2xkqdMaVJvNFyNlKxNoEcrOJsct
         N2QK11EJDGwxCBH5En30TRujWqYW9gfB0gOGN1AmHRghORZGax2WS+iuBiM5v/wXt9CE
         gV92M9nQjw2uJ1IoYIFaPnWoAH0oeNWNVloPiR5PeLKy08J6Lv+KC59vJIhnDr6UBT1G
         spmJzcbstxRuBattOWXJjQ4pqELdtccTOajNtjHjeFvaqCBrDv9izn+UmHOb35IRR2fx
         /9cA==
X-Gm-Message-State: AOAM530d8woXLMw++x6sGmKd8us1zGsioUse/Q4Ql/i1dSVVpLxBD1xR
        /zgXnxJzzYcfZwvkyNaL0ijofzzBRNY=
X-Google-Smtp-Source: ABdhPJxlcowD6T6yPgHuseBL0ofs+MsqwJykl/a/FrUlFopUkhnFg/TqdMwK8KVyg1eylJC4AC624op+zHg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:b89:b0:505:dead:db1d with SMTP id
 g9-20020a056a000b8900b00505deaddb1dmr16566920pfj.74.1650351456883; Mon, 18
 Apr 2022 23:57:36 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:25 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-20-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 19/38] KVM: arm64: Add remaining ID registers to id_reg_desc_table
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

Add hidden or reserved ID registers, and remaining ID registers,
which don't require special handling, to id_reg_desc_table.
Add 'flags' field to id_reg_desc, which is used to indicates hiddden
or reserved registers. Since now id_reg_desc_init() is called even
for hidden/reserved registers, change it to not do anything for them.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 84 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9e090441057a..479208dedd79 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -331,6 +331,11 @@ struct id_reg_desc {
 	/* Fields that are not validated by arm64_check_features. */
 	u64	ignore_mask;
 
+	/* Miscellaneous flags */
+#define ID_DESC_REG_UNALLOC	(1UL << 0)
+#define ID_DESC_REG_HIDDEN	(1UL << 1)
+	u64	flags;
+
 	/* An optional initialization function of the id_reg_desc */
 	void (*init)(struct id_reg_desc *id_reg);
 
@@ -376,8 +381,13 @@ struct id_reg_desc {
 static void id_reg_desc_init(struct id_reg_desc *id_reg)
 {
 	u32 id = reg_to_encoding(&id_reg->reg_desc);
-	u64 val = read_sanitised_ftr_reg(id);
+	u64 val;
+
+	if (id_reg->flags & (ID_DESC_REG_HIDDEN | ID_DESC_REG_UNALLOC))
+		/* Nothing to do for a hidden/unalloc ID register */
+		return;
 
+	val = read_sanitised_ftr_reg(id);
 	id_reg->vcpu_limit_val = val;
 
 	id_reg_desc_init_ftr(id_reg);
@@ -4192,33 +4202,103 @@ static struct id_reg_desc mvfr1_el1_desc = {
 	.validate = validate_mvfr1_el1,
 };
 
+#define ID_DESC_DEFAULT(name)					\
+	[IDREG_IDX(SYS_##name)] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_SANITISED(name),			\
+	}
+
+#define ID_DESC_HIDDEN(name)					\
+	[IDREG_IDX(SYS_##name)] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_HIDDEN(name),			\
+		.flags = ID_DESC_REG_HIDDEN,			\
+	}
+
+#define ID_DESC_UNALLOC(crm, op2)				\
+	[(crm - 1) << 3 | op2] = &(struct id_reg_desc) {	\
+		.reg_desc = ID_UNALLOCATED(crm, op2),		\
+		.flags = ID_DESC_REG_UNALLOC,			\
+	}
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
-/* A table for ID registers's information. */
+/*
+ * A table for ID registers's information.
+ * All entries in the table except ID_DESC_HIDDEN and ID_DESC_UNALLOC
+ * must have corresponding entries in arm64_ftr_regs[] in
+ * arch/arm64/kernel/cpufeature.c because read_sanitised_ftr_reg() is
+ * called for each of the ID registers.
+ */
 static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
+	ID_DESC_DEFAULT(ID_PFR0_EL1),
+	ID_DESC_DEFAULT(ID_PFR1_EL1),
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
+	ID_DESC_HIDDEN(ID_AFR0_EL1),
 	ID_DESC(ID_MMFR0_EL1, &id_mmfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_MMFR1_EL1),
+	ID_DESC_DEFAULT(ID_MMFR2_EL1),
+	ID_DESC_DEFAULT(ID_MMFR3_EL1),
+
+	/* CRm=2 */
+	ID_DESC_DEFAULT(ID_ISAR0_EL1),
+	ID_DESC_DEFAULT(ID_ISAR1_EL1),
+	ID_DESC_DEFAULT(ID_ISAR2_EL1),
+	ID_DESC_DEFAULT(ID_ISAR3_EL1),
+	ID_DESC_DEFAULT(ID_ISAR4_EL1),
+	ID_DESC_DEFAULT(ID_ISAR5_EL1),
+	ID_DESC_DEFAULT(ID_MMFR4_EL1),
+	ID_DESC_DEFAULT(ID_ISAR6_EL1),
 
 	/* CRm=3 */
+	ID_DESC_DEFAULT(MVFR0_EL1),
 	ID_DESC(MVFR1_EL1, &mvfr1_el1_desc),
+	ID_DESC_DEFAULT(MVFR2_EL1),
+	ID_DESC_UNALLOC(3, 3),
+	ID_DESC_DEFAULT(ID_PFR2_EL1),
 	ID_DESC(ID_DFR1_EL1, &id_dfr1_el1_desc),
+	ID_DESC_DEFAULT(ID_MMFR5_EL1),
+	ID_DESC_UNALLOC(3, 7),
 
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
+	ID_DESC_UNALLOC(4, 2),
+	ID_DESC_UNALLOC(4, 3),
+	ID_DESC_DEFAULT(ID_AA64ZFR0_EL1),
+	ID_DESC_UNALLOC(4, 5),
+	ID_DESC_UNALLOC(4, 6),
+	ID_DESC_UNALLOC(4, 7),
 
 	/* CRm=5 */
 	ID_DESC(ID_AA64DFR0_EL1, &id_aa64dfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64DFR1_EL1),
+	ID_DESC_UNALLOC(5, 2),
+	ID_DESC_UNALLOC(5, 3),
+	ID_DESC_HIDDEN(ID_AA64AFR0_EL1),
+	ID_DESC_HIDDEN(ID_AA64AFR1_EL1),
+	ID_DESC_UNALLOC(5, 6),
+	ID_DESC_UNALLOC(5, 7),
 
 	/* CRm=6 */
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
 	ID_DESC(ID_AA64ISAR2_EL1, &id_aa64isar2_el1_desc),
+	ID_DESC_UNALLOC(6, 3),
+	ID_DESC_UNALLOC(6, 4),
+	ID_DESC_UNALLOC(6, 5),
+	ID_DESC_UNALLOC(6, 6),
+	ID_DESC_UNALLOC(6, 7),
 
 	/* CRm=7 */
 	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
+	ID_DESC_DEFAULT(ID_AA64MMFR1_EL1),
+	ID_DESC_DEFAULT(ID_AA64MMFR2_EL1),
+	ID_DESC_UNALLOC(7, 3),
+	ID_DESC_UNALLOC(7, 4),
+	ID_DESC_UNALLOC(7, 5),
+	ID_DESC_UNALLOC(7, 6),
+	ID_DESC_UNALLOC(7, 7),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog

