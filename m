Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2185064F0
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349027AbiDSG7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 02:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349028AbiDSG7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 02:59:54 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A2927B12
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:12 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i8-20020a17090a2a0800b001cb5c76ea21so10140940pjd.2
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VJImZSIZ+gG1OFTvYyrxAjCUBTqUqO7tRcl+ZvmmrQU=;
        b=fY034672N11uX9UN7COg34VjlKUqAo7dFya/wOHPBEs1jzO5xKlaqEmIenpptQfc3Z
         UO7slba7gfWUWNvpAFkm02q8WMmVD74ZeN9mCnYt2u2qXBaNDY4yoKJ/OuV+Z3lqdmmz
         W278iSjt45hIPJ+VKUtTyZeNHoo6fojiDaHX4KiwL8XTeN7iX5Gc8A/VbEX/dtjLYPWh
         ToYtzkMaDBmaPztTc/CagS+36DIDmgQw3Pry0pzFNvmBUmLwIjP/b6OljEat0qNHn/Qe
         uQMzg7jaZcRaQlvLVne9u6lapGzQYrEkbFM1BUCEeNf2SItPlzY0vnkCiPTUt9nqpRf2
         xpig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VJImZSIZ+gG1OFTvYyrxAjCUBTqUqO7tRcl+ZvmmrQU=;
        b=fUV3A5o7J/358u/DsNEBidH7bcUjxcxBP4X1pdL5FC0tBNlcdjHnEeyvBS/jcvbwtx
         zu5lEL9+Yd6mt3MVWqrlRKqMQotWqXhFEzhz+ByPvpwtAwPIYenGNmnijl1UzMSxe/ce
         yBi3ZHFgfWD/l9Uum8st9u5Ctuv1dRWzFRByx2o1nnpm5NkouwvOINOdpFLaS+IEOY+0
         mx+WE5+gdWTYziCs+xJ97wpsyNSCyIJ4vJ0kwiAFeS90xYhB1e7OP/VFjtC7VHmSaD/x
         GY4tbWSjge3GYDjUO0X3dOjNx9PhbHbnEKu+RlTRxtbU+XWKI86i6PYYFZDACNt71a7I
         qk/g==
X-Gm-Message-State: AOAM5329Tj2eOk0FTA79/pZjpGBBxB/oZv/V2RGVXZy1vS7F7J9c8sw/
        YmI1ORy6Ds7nKNXw0GeBbBpxJTeQwEs=
X-Google-Smtp-Source: ABdhPJwcF9IGP+oXjWqN513CFHPTbOhEPIcFqBvtuNUAEogsKCaN3cLS4dsvrgirt3TnfNpD+Muf6CEieGo=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:10d0:b0:4f7:5af4:47b6 with SMTP id
 d16-20020a056a0010d000b004f75af447b6mr16187254pfu.6.1650351431964; Mon, 18
 Apr 2022 23:57:11 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:10 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-5-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 04/38] KVM: arm64: Generate id_reg_desc's ftr_bits at KVM
 init when needed
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

Most of entries in ftr_bits[] of id_reg_desc will be UNSIGNED+LOWER_SAFE.
Use that as the default arm64_ftr_bits for any entries that are not
statically defined in ftr_bits[] so that we don't have to statically
define every single UNSIGNED+LOWER_SAFE entry.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30adc19e4619..b19e14a1206a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -35,6 +35,7 @@
 
 static u64 read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id);
 static inline struct id_reg_desc *get_id_reg_desc(u32 id);
+static void id_reg_desc_init_ftr(struct id_reg_desc *idr);
 
 /*
  * All of this file is extremely similar to the ARM coproc.c, but the
@@ -325,6 +326,8 @@ struct id_reg_desc {
 	 * Used to validate the ID register values with arm64_check_features().
 	 * The last item in the array must be terminated by an item whose
 	 * width field is zero as that is expected by arm64_check_features().
+	 * Entries that are not statically defined will be generated as
+	 * UNSIGNED+LOWER_SAFE entries during KVM's initialization.
 	 */
 	struct arm64_ftr_bits	ftr_bits[FTR_FIELDS_NUM];
 };
@@ -335,6 +338,9 @@ static void id_reg_desc_init(struct id_reg_desc *id_reg)
 	u64 val = read_sanitised_ftr_reg(id);
 
 	id_reg->vcpu_limit_val = val;
+
+	id_reg_desc_init_ftr(id_reg);
+
 	if (id_reg->init)
 		id_reg->init(id_reg);
 
@@ -3173,6 +3179,54 @@ static inline struct id_reg_desc *get_id_reg_desc(u32 id)
 	return id_reg_desc_table[IDREG_IDX(id)];
 }
 
+void kvm_ftr_bits_set_default(u8 shift, struct arm64_ftr_bits *ftrp)
+{
+	ftrp->sign = FTR_UNSIGNED;
+	ftrp->type = FTR_LOWER_SAFE;
+	ftrp->shift = shift;
+	ftrp->width = ARM64_FEATURE_FIELD_BITS;
+	ftrp->safe_val = 0;
+}
+
+/*
+ * Check to see if the id_reg's ftr_bits have statically defined entries
+ * for all fields of the ID register, and generate the default ones
+ * (FTR_UNSIGNED+FTR_LOWER_SAFE) for any missing fields.
+ */
+static void id_reg_desc_init_ftr(struct id_reg_desc *idr)
+{
+	struct arm64_ftr_bits *ftrp = idr->ftr_bits;
+	int index = 0;
+	int shift;
+	u64 ftr_mask;
+	u64 mask = 0;
+
+	/* Create a mask for fields that are statically defined */
+	for (index = 0; ftrp->width != 0; index++, ftrp++) {
+		ftr_mask = arm64_ftr_mask(ftrp);
+		WARN_ON_ONCE(mask & ftr_mask);
+		mask |= ftr_mask;
+	}
+
+	if (mask == -1UL)
+		/* All fields are statically defined */
+		return;
+
+	/* The 'index' indicates the first unused index of ftr_bits */
+	for (shift = 0; shift < 64; shift += ARM64_FEATURE_FIELD_BITS) {
+		/* Check if there is an existing ftrp for the field */
+		ftr_mask = ARM64_FEATURE_FIELD_MASK << shift;
+		if (mask & ftr_mask)
+			continue;
+
+		/* Generate the default arm64_ftr_bits for the field */
+		kvm_ftr_bits_set_default(shift, &idr->ftr_bits[index++]);
+		mask |= ftr_mask;
+	}
+
+	WARN_ON((mask != -1UL) || (index != (FTR_FIELDS_NUM - 1)));
+}
+
 static void id_reg_desc_init_all(void)
 {
 	int i;
-- 
2.36.0.rc0.470.gd361397f0d-goog

