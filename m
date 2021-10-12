Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D86429C88
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhJLEid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhJLEic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:32 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE905C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:31 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d5-20020a63ed05000000b002688d3aff8aso8040914pgi.2
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YN5X7g7A0IcM/p+7vsiMHZtNXVKHJ9chV2Lsbk7C1zQ=;
        b=D9t2oSmy3ndrP6bG2CsMouv9WCLzBGAUEH9kU9GDfWruie5xcB4VWV5N3fdKM04NQT
         y7exLiVXuZ5lFdKYyePdLkoPo8cn1KqjXXh2Bzo6fXPw7dt8Teh9e+XAsRniQxTFH2mj
         myl0tm3EG6VL6ui4G3GvrZAcc0a+CQ2Lu67tFDcHuFdPNLPfR4C+BiNq81g4Lrip9dW3
         /BhRDqpetIQC6EqPlJuNc5GtsRceGBjoNScBNh8IPSRwQe1/D9hxC0nPlBkscc4lwz/O
         B48K0R37H4tPXUoiS6eIn0jXuDnOjMxP4kD4HyUDRMZT8H/DCqAyH7zyrmvQK/CheTFN
         IfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YN5X7g7A0IcM/p+7vsiMHZtNXVKHJ9chV2Lsbk7C1zQ=;
        b=TMPpsJ/WO6xvgIR5V90UfXhnz/uD2N/JVxKkMCqZlBlZDFTm8+Heu9psCCvjR+aYoU
         XzK3EDv9/fNfN4NDvTeCtm/tZYwmNYVUHvL+hldLkSeXfpyM/NPLuc2Uva9S5r+nmktS
         CCyLD0IQS+fch6KPIrnWbfJWmxDuJ+j3TwtPGjOQ9sOXiIjC6RA7vpNYHtf0dFzGVhy9
         mnApQAEJoBmNibbBXGVb7x79V2Yz3fctMzcGeLskeHeNpNfl/4+tI8NG1SofstMKJBwk
         DajsMRc3yS4VA48uk9nDfwL2ZZ6xGihq3MRDEIvHgAQu0j+Ev/NBUYRQFTBr/pTxzcTe
         +LAQ==
X-Gm-Message-State: AOAM5301fwsFlFmnaJp7ujASjddsLlz6GIZW5KvMT0QMz16XQQFtdzmI
        085QaAXmWW45KBwheRZ/UdsSYOS8mBY=
X-Google-Smtp-Source: ABdhPJx7SjSGAN6iiMVQeGbe49tKa2HXO9o45gNjMgaiwIrwZeu4H15V70apGcoFeW+OXBwcRgRJdrHYH/Q=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:3ee4:: with SMTP id
 k91mr295558pjc.1.1634013390825; Mon, 11 Oct 2021 21:36:30 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:18 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-9-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 08/25] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0e4423a81cb9..73b5dad0b2ee 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -328,6 +328,31 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	unsigned int sm3, sm4, sha1, sha2, sha3;
+
+	/* Run consistency checkings according to Arm ARM */
+	sm3 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM3_SHIFT);
+	sm4 = cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR0_SM4_SHIFT);
+	if (sm3 != sm4)
+		return -EINVAL;
+
+	sha1 = cpuid_feature_extract_unsigned_field(val,
+						    ID_AA64ISAR0_SHA1_SHIFT);
+	sha2 = cpuid_feature_extract_unsigned_field(val,
+						    ID_AA64ISAR0_SHA2_SHIFT);
+	if ((sha1 == 0) ^ (sha2 == 0))
+		return -EINVAL;
+
+	sha3 = cpuid_feature_extract_unsigned_field(val,
+						    ID_AA64ISAR0_SHA3_SHIFT);
+	if (((sha2 == 2) ^ (sha3 == 1)) || (!sha1 && sha3))
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit;
@@ -396,6 +421,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
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
@@ -407,6 +437,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
-- 
2.33.0.882.g93a45727a2-goog

