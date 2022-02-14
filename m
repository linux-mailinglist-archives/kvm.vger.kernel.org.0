Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676594B4262
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240984AbiBNG7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 01:59:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbiBNG7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 01:59:37 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DF1575F7
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:59:30 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id x6-20020a1709029a4600b0014efe26b04fso1101152plv.21
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M/a/Vc/shmJJLkjZEVBmniQlBoL+OJyInbuc84cKOVo=;
        b=oHiVtTsoFuP7yxvyHQnSpouOUcn7G4EYC+Ud3GVI/+GZOlUg97m7sK+ac0e7acp21k
         br/kA9rY0/54R62sM2+J6XotY6GpkxYuJsq96VMGi2rokSONE9v65Nk0WLHRhgqQ+kkz
         j6XS69iblworG4svJ04iUpjYT8hYS4RSKesB+K2856MWjkpvigJyP0bOMW1mo2gcJBrl
         5Qj4dZUhifjRold70IjyqXd944ao9fLKeVarR4PxB6/a47gB3xqndq4YcD3bYKqjmNBf
         ktzk+MGTgVt6OZbt1a0wY1KSoLsOl64r7hw+BPjxAIQ1OfkQjvNbPcsoT3XoxHuKUeDq
         31Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M/a/Vc/shmJJLkjZEVBmniQlBoL+OJyInbuc84cKOVo=;
        b=7FSRANOisTUG9oqJ/5PWJt4KEUIuuv74Vk7Izdk7N6eoHIAoTmUVeqPdUdhrzqfE33
         d5Bz4pftm0fxazJRuNeDiDec28N59jdkpnqt+NYy7hilEhJoYBh+2dAgE8MghriwqDZA
         ifgncu2lZFXL+agWaKi4YtpHLQQtg87KNK/Hdgc6qT/I3ntXNj8rtOltta0kJSURscDw
         BKEC4UBPB8pjLbetaVwTqkEauuu/S3lB6E/QesQnvcFYThOsBkwacGOfqdr7aDGK6nJK
         OjzHOLH0q4xqnUHQiAxRjlxmsA4ubbk2W1lvH1lIp5fDEwv0ggf9ez1PlhkNMaCg+YZI
         0G9w==
X-Gm-Message-State: AOAM531cuKbkTUb4n1hgce0q8kUZBy53FAg5uNWswcDfsZtvtlCfeoVY
        qutl0sIqyYPVLVthpiJAvp3FMwNuWdw=
X-Google-Smtp-Source: ABdhPJwsfhL7pM3Pz0k0600RZWcFVmJjjZYx2f1pfIZDVbRupYBHsW6Obk+gUclfejqilFnthPKptjfIvSo=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr1640298pjb.0.1644821969667; Sun, 13 Feb 2022 22:59:29 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:25 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 06/27] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64ISAR0_EL1 to make it writable
by userspace.

Updating sm3, sm4, sha1, sha2 and sha3 fields are allowed only
if values of those fields follow Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b41e9662736d..eb2ae03cbf54 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -387,6 +387,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
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
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -454,6 +477,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
 };
 
+static struct id_reg_info id_aa64isar0_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR0_EL1,
+	.validate = validate_id_aa64isar0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -465,6 +493,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
-- 
2.35.1.265.g69c8d7142f-goog

