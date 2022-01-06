Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3527485FB0
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiAFE2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiAFE2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:28:40 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE7FC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:28:40 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id k1-20020a63d841000000b003417384b156so866108pgj.13
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iggCERYPvKZzkmiH5L0dJnOh5/4oawtODr5G6JGC3EA=;
        b=mVLqwj6g6bvq57fUaSXBKokDOk+Vl5QV/c2R0889pzyzfCBoA/raBr27Y7kswkDDvt
         wCDfvRtxY/zyAeZZpDDG6FaHhPoAsHlTPkalAKLnRzJSHDPdJBhM+95Oc37OOpPNILcg
         XJQblN1T7v+0cS6yn+I85idg1qCUXVRBP/sKXhl0gKeZysvAhhVQqLZ/AA4DHQwrbePb
         s8vCdjD+phywxu/FGU3qwT6KZ4N/E7IAJW/Q9jWJr5q0fFXjEVz4nMKM/ULNrtzDFP59
         Gs7JiJpDxpAcEoQqEGZBABmMH3cUOOzEu/PL9UWJC/RjpX69PO75BPiBBuXuTIbRRwRD
         DHKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iggCERYPvKZzkmiH5L0dJnOh5/4oawtODr5G6JGC3EA=;
        b=6XQUJBC0Gx3fKBF7fpOX2EMIShD28Q+DdN7SNSAgrlpvRss6p1Z3KFOC3MwKWO2nP2
         f4BMG0fp28P0Z4VbyRCM6CRnuAZVkv1syxU6aed6HxWECZEsUZI6ufHOFCG4N2NwQ6XB
         Is7QReN8I55CmiK9HYPRjtt2pMFUFFzIgDWrlDuaOLidJikIzPflUzdminXcs+NbH91m
         kR1yE4/bWsOkzvlAsl4RYPX9meZvvrpS8hQp/O8ulzyEa+0tBy23U0GkRshYEQHn3IST
         2rMOD+zG/yrqWM3fag/OhugZONkHWFtGzBxWVKz6zw4rk92r5brBPK0XexiQM3GK8ipB
         4BeA==
X-Gm-Message-State: AOAM532OqYiJ/y5S30/sb5rqHTa5AuF/k03zNRxQ9qLV47yiTBgLxq3X
        pha6B/O/+z8fUXbSlmqh4o4vXNu/tNE=
X-Google-Smtp-Source: ABdhPJxDhvY2RCuxPGDkqE5OOdzgA9LIz2uvcajr4q2pHOtqqx/TF2sfgcMcvVhIt9btg/jJEMB+aQVz7pA=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:2a4e:: with SMTP id
 d14mr528686pjg.0.1641443319139; Wed, 05 Jan 2022 20:28:39 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:26:48 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-7-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 06/26] KVM: arm64: Make ID_AA64ISAR0_EL1 writable
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
index ae9ca341a2e4..3f1313875be5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,29 @@ static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
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
@@ -441,6 +464,11 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
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
@@ -452,6 +480,7 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
-- 
2.34.1.448.ga2b2bfdf31-goog

