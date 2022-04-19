Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77CF5064FC
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349058AbiDSHAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349066AbiDSHAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:01 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9193927B14
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2ec44c52e7fso139280217b3.3
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F9GVjgg0f4Eemfa1MtjY71p4mXhfcLBZ4BAQg8wg5XY=;
        b=X+pobMbVaGwgu5LTnSwRAhxIsSPT3tTWzl4eEAhJdrVtMOSpFKA4Ke42asU/3dvssI
         381enhjh7yPijf8pAlX+aqtsdIj0duWitAwAoy42KcoMXeMZTmkNw4w9t3jtqUELlT7n
         vtJIM8CFxZuqkSv+/d7hpVxYopPx34tb94wNS19mvpV0aVTYCUiO3Ji7bfQgxyj1Zq+M
         Xxzajz4UsXketmCrnsvZkfgkOdXdgsp1xQ5NNW2ko6f9U22L3NeQx7cwF22PipUE8l1u
         bR7YuhvhEH5FAdYOx3Z4CTFCXbfRgfY96WHeJlj5IHlUeGIzTLqXst1wNQH5GsLfwIQL
         exfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F9GVjgg0f4Eemfa1MtjY71p4mXhfcLBZ4BAQg8wg5XY=;
        b=W3T/0vWu2ssZAprGDqSL51FhNOyp1Z8SbSiNW0xHkB5e8p+lFHgh8W7jbGOWzSj20t
         /jhgDqexGfHYX3gq8/pZxyGaEG/F7XuW6E/E8WknOoytYbXxVpOysWg9kZomrPcdKloJ
         ElH4u8SkJlh7KxI/mXLq77d7MKmhs8pR43moPlDRRI8b87mMuaN7CyeO0IfP7qdQcbGS
         Zi3eYhfg5qQ/CAOyvi0Zx4//ZvUmiWAv1naMHYjn7VFuKNOxHX62HmsqSWjo9r+ilOyP
         Zq9ROgVf7pgVvBziM3sOM5xbJcTybiDd3mjZScrZ1fd8a0aweoU6uE1VlCv1XnAM2aw+
         v+sQ==
X-Gm-Message-State: AOAM5314Sx9hHy1DDEQrPd3fXRE+G5FBHDeo9EoWXYNeS5+lSJeCUJ40
        aqxXf6CFm0mr3TKk1ypHhMP7RvYf9VA=
X-Google-Smtp-Source: ABdhPJyKCFDKA+Kv2LJacZJZ+S367HCU69wGD+6+X9uBwvbwrCQWpjBQK8XUhugss+g+U3Xwz9Iz0thLwQE=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:e050:0:b0:645:3723:f52d with SMTP id
 x77-20020a25e050000000b006453723f52dmr2116304ybg.144.1650351438821; Mon, 18
 Apr 2022 23:57:18 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:14 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-9-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 08/38] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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

This patch adds id_reg_desc for ID_AA64ISAR0_EL1 to make it writable
by userspace.

Updating sm3, sm4, sha1, sha2 and sha3 fields are allowed only
if values of those fields follow Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c3537cd4fe58..c01038cbdb31 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -425,6 +425,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_desc *id_reg, u64 val)
+{
+	unsigned int sm3, sm4, sha1, sha2, sha3;
+
+	/* Run consistency checkings according to Arm ARM */
+	sm3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM3_SHIFT);
+	sm4 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM4_SHIFT);
+	if (sm3 != sm4)
+		return -EINVAL;
+
+	sha1 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA1_SHIFT);
+	sha2 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA2_SHIFT);
+	if ((sha1 == 0) ^ (sha2 == 0))
+		return -EINVAL;
+
+	sha3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SHA3_SHIFT);
+	if (((sha2 == 2) ^ (sha3 == 1)) || (!sha1 && sha3))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -3256,6 +3279,11 @@ static struct id_reg_desc id_aa64pfr1_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
 };
 
+static struct id_reg_desc id_aa64isar0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64ISAR0_EL1),
+	.validate = validate_id_aa64isar0_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3264,6 +3292,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
+
+	/* CRm=6 */
+	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog

