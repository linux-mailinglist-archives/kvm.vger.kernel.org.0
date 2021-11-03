Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB4C443D1F
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhKCGan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhKCGam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FE8C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:06 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e6-20020a637446000000b002993ba24bbaso1012076pgn.12
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Gm7mR1LOrJBKTHxCMeDmedILqwUP3OMytAls+H/S7bU=;
        b=jPsuNnbg/QU+2caiIez8a8TyHTUk/yd+DEx9LtczN9tZprd+9kHOPY+WTAVfiBJ6ai
         kzBH3B3/w81JPllA73p+RDDa3TzrwdZNZYBVr/PPQyq/vNmLLXGPSIL8P1NBu7lWCoa0
         dHDK9bbyO4r5QKxFc1pDDfOlPFaJhX0E0UqNp8fIB8i5SivMPXLJwe/lRK2WPY/qy32P
         BWUjNgmK+s8JOKv2bWAfhQZyTR1T0KE2eBP1NbGgRNZ/VWdEq7tGTvlA82xdbD8NTibE
         7BsUZ7muTN/zFD1beM9hgHFZSw6BLJbETIzDlZDPiNkgkYQzNccXc5H9Dq8FNK8l41XY
         bUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Gm7mR1LOrJBKTHxCMeDmedILqwUP3OMytAls+H/S7bU=;
        b=D8MYcmWIlACVftU1zOM/vjTu8ks+IMCu21oCreIAxXUSQM/OwC0Neb6CDj+jSF0raC
         nYDmJFKEIGR9ngv5TbaD3pxolqgbxjPB5aFFGe3pw+tZ7D97KNQd4sJUN6+SlLuzAQbz
         byNii0owsV6Txm/kTjdlCv4aAuKSHYh7K9wIfcx2do5xarOKrBc1cUhwEmiXRQ+OqWfe
         SsTGFO/5bVGwZssC+dToDyKmIGeWOhm00tFehinjTIsUGXfv0+UmxGiRfrZC9ttRRgu+
         o5eCU8wbes1dH6QTLbBRYHH4yNm7WPjnmoEBMbda5D60n0R0XY33T1S7N9gUct9jqfJI
         XuHA==
X-Gm-Message-State: AOAM532AZN9647cdlXvLcGgWYlFVwqXeTXyg6qZ29tydI1riftXOiJwq
        otLZVjKaD7GPiImsXsSKXqXtXCqcWvQ=
X-Google-Smtp-Source: ABdhPJx4iUpI5oPSkMfBiiSHZTrxt3jDZPbO9Y5vkrpaP5+G0KSWuasdv0FcSGbk6TmKos+QwAbRI+dV8AU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:ab8c:b0:13a:22d1:88d with SMTP id
 f12-20020a170902ab8c00b0013a22d1088dmr36282740plr.33.1635920886142; Tue, 02
 Nov 2021 23:28:06 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:24:59 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-8-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 07/28] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64ISAR0_EL1 to make it writable
by userspace.

Updating sm3, sm4, sha1, sha2 and sha3 fields are allowed only
if values of those fields follow Arm ARM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 00ebf4dfc4f8..7f505853b569 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -437,6 +437,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
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
@@ -502,6 +525,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
 };
 
+static struct id_reg_info id_aa64isar0_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR0_EL1,
+	.validate = validate_id_aa64isar0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -513,6 +541,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
-- 
2.33.1.1089.g2158813163f-goog

