Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABF8454145
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhKQGxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbhKQGxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:53:23 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BF3C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:50:24 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id a4-20020a170902ecc400b00142562309c7so570337plh.6
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LMhbb8z+xm9w4/dja4Fw2MViuPAGvmmbQ+PVrYP0i5Q=;
        b=SHNcn7oF3x+HutlCWfvIjEAcuL9nEimGUkVvMDgZQWTx6O+yl+XGGHBSaV4C4FE9Hd
         r00c15U+WA/c/IC5ocEZq7Xo1J9td6jlOfz7tLGtc0DzkplgSJaZai2mGzwHpHOJJcJ3
         mntmYW8ApfOYm/CMasymg9RgoGV3hB6XEG8roGM5q7qI8dhIiTyXIpTSNJEPSEY11kZr
         TA7jjU63CGF/1Ds1KIhKHcysXlmGwvLJGJW5xXRqJTQCnLk1K2HXho0wMctqMKCNvp/r
         gqBI19+OFVf7Z0+X/Ltrx8hqOclgC3e3HmVDOL7XtGmdlv07TZqPfbNemzRwNjRoQdZc
         kWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LMhbb8z+xm9w4/dja4Fw2MViuPAGvmmbQ+PVrYP0i5Q=;
        b=UnZVgH66ceKnZ37q/RVxKEfH26AiPV+KA8agxfwIQ4dSek1W068fmkw690nTMqVOs1
         /z8IZhNnKkEyJZqbOPAcYqsm3j3yLR5Pu4ZulihXTQA9nb6O8ClhXeKQCpBQ+E6Xy/KG
         9Kem6isxbmaKRG9UcHlNw+5bTWDRdR+Ne/wyLG5ji7QVXqHt8z/YRyJa5tg2qvKeTNT5
         mQiZ3+I8MY4MF6W2N9gxA/QAoxN9PPm7004w+NqdeUjhRukDn+imh6x5E7fHdRLfNxCG
         jFbtoWS0RdE1PZ7iyKIzp2quHHWIWks9TnpJAaJ+qavXp9gAoV94Si9ccPR7A8W0/nZj
         w1GA==
X-Gm-Message-State: AOAM5329kQ/ruagBgolvi7SJRnxAHsW7xUWJ2vYrEJmDAfGss0/OpJUB
        5SyV71PWt8Lh23rH14yFVJ9TRWaFx70=
X-Google-Smtp-Source: ABdhPJyqvIkcOzg9kv5HN+bRx6bfyb/Kt8VaG6o4P5ZXqPuVs07Jl4gjrYMSnip9n9ksQ1DhnYmfpYKYXKE=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr312752pjf.1.1637131824128; Tue, 16 Nov 2021 22:50:24 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:36 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-7-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 06/29] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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
index 7dc2b0d41b75..fdd707462fa8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -448,6 +448,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
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
@@ -526,6 +549,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
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
@@ -537,6 +565,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
-- 
2.34.0.rc1.387.gb447b232ab-goog

