Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FA04D5A03
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242853AbiCKEuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346480AbiCKEts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:49:48 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65EF1AC28D
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:41 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id e1-20020a17090a280100b001bf44b6d74bso7211474pjd.0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i1Q8oMVcIDawwcpspY0YFzmCHnlNLuWjVrH+1Iwojj8=;
        b=jVLOPO1C6Ge6K9MG6QbzCVTmnGDbg8jZOD1sL0KvfQwDeSvvbXuCxHIh9stqZKw7o7
         m0BVY3IxNn55nzY/Tq9XLu/IiOng74LRlvqo6E6T1rr/98gS9IDg8BpcnCjATjov5so9
         PtUgvUnGTNwMTLRZG1vo1oh9KTI7T9CSS/aHcKZjuFkCJ9JZVO64cqoNqredM66vA/hu
         LDihsicff+dxFB7+dRK10RK6CIvs3oKpyaKUMhvuJF+tGg1wBRtAiAjJsXrcLaiqZLXy
         E+wRlPN8J8Sn7I3xE/U1ZPoYGH5asekcZGHH0u4dk9Xg3hj2WMXVj+HaHl48qqjp7Abo
         0pWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i1Q8oMVcIDawwcpspY0YFzmCHnlNLuWjVrH+1Iwojj8=;
        b=x2hsgD3v5coYdNTsdYxAmztlQY+AdP/WnBInUppwxzA5KJMpATltdZBAMNoESoWKML
         gFOJIDdiWIjSOxp5BncZnUTBkdefxL+854aykIeQCWM9eNtaSLBCvsdh6DBgFJ2GPAQ+
         gwxBp1BdayQ/qB2QAITr42E9upkLh3Fy/tDCUAeqHcEPUD+9B/mWTSX5BUv5ooTNbDvU
         akhMJJe6pVzSiuKoadd293xhQ65IeDKZCQiHry/5wSJ5q9kue1tS/mKjwv1PoifItVTi
         dgIi7cmoXURsmHctBYBWLzCiHpisIRNEbeo9gZIOLnNWJAXdwWcAbt8gIzxlgXg5ODcw
         qErg==
X-Gm-Message-State: AOAM530+9L4agEg9CS+hLYSpvVzXwR5lAYp7ojWGtkRaEGDJKhALQgEQ
        o9oFC582XMJZWLasN1byDW4P2bRxr+Q=
X-Google-Smtp-Source: ABdhPJyqzZBFBrLfDZqJ/MEY5oQH2n+E2ImHCp7e6LaNBlZdtcnXcxrMItVl9Ayaa8AX1b+4PjFrf3CrT4s=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:11c7:b0:151:7290:ccc with SMTP id
 q7-20020a17090311c700b0015172900cccmr8717277plh.95.1646974121195; Thu, 10 Mar
 2022 20:48:41 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:52 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 06/25] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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
index 4294dbfd8fd4..378777238c68 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -389,6 +389,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
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
@@ -3167,6 +3190,11 @@ static struct id_reg_desc id_aa64pfr1_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
 };
 
+static struct id_reg_desc id_aa64isar0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64ISAR0_EL1),
+	.validate = validate_id_aa64isar0_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3175,6 +3203,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
+
+	/* CRm=6 */
+	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.35.1.723.g4982287a31-goog

