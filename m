Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A83454150
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 07:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbhKQG4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 01:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbhKQG4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 01:56:12 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B56C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:14 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id d3-20020a17090a6a4300b001a70e45f34cso885468pjm.0
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 22:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SC5T9znPBLTNrmN/sDQzNw6Ub+Qjzd3qc7h2EDRdpsw=;
        b=g/3NbKzHcUiXa+m/7cvTZ1xTKPYSz37HHs47wNPYPhkDUo2NjRSjilyLwR4i+nLrVY
         k0CyX97TWk0Ody6mji2CZ9wWp/OcbHpfT4FtJsU1gbn77p2NN7zZtfirQFP8PPlYzo20
         YUfM7RQLCGQ6yDYJEdVosYHXiP07cGB1dOF/k4W92QCz4TZq+K5R1vc8xRxXvio+osdY
         EQUK9mid9FV0hbYPr+2j51+1uvBX/aVW4JJCmwY5C/TFtfjmSwhvueqc2g4XdxRV1RNc
         9ei+QRh2fRv8siqh7/suv9Icey8MMkuKJH9+w84TprS+t0kZ0ym6L1+IAhlfY/I0lCPJ
         ASUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SC5T9znPBLTNrmN/sDQzNw6Ub+Qjzd3qc7h2EDRdpsw=;
        b=xuD/wuF1owrCFccOg+5bEIm656eCmo58lXNx2T7Gt5T6id82vFoE9HS4b3FqyfY35F
         L9klwjnuerFaAYV6ziR315V64adCNK+uLRtrPKq2ULMczy7d+f4VQnK9I+0StEIXieqv
         1RchhgEfZf1bP0FnagB7d51/64Ts2Ws9pPM5XIPntMrdq9Q07QW4ra3HiKH4LjZX1COS
         Hf20+Mga4ryVwSh/C6sJeTHLbM4Dpc2aj5+lpf7nTSxnqcEUY2pLnkwJp9kt8FgDHwKo
         DI8fPu17e9PXfevERJyQs7N3SHtJ2U/OpDd1HL+5vjPRZ8591gQXT2hEa9wGA9M/5Ik7
         pXuA==
X-Gm-Message-State: AOAM532cb0dGhxogzDCNxb7PV1ROa25fssN+A8p3JqHBqnsRFTEZuAd0
        sXA73HofJa7dsPcUxqQt1WXnwX3Xqg4=
X-Google-Smtp-Source: ABdhPJzxco6E3AqetETiY0RA3xGyLBBSVtg3Qx53KDDwdkXujTql0gFgly7E7xEMCFlAmqMkTH074Ke6ZUQ=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:c58e:: with SMTP id
 l14mr6765135pjt.214.1637131993894; Tue, 16 Nov 2021 22:53:13 -0800 (PST)
Date:   Tue, 16 Nov 2021 22:43:41 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-12-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 11/29] KVM: arm64: Make ID_DFR0_EL1 writable
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

This patch adds id_reg_info for ID_DFR0_EL1 to make it writable
by userspace.

Return an error if userspace tries to set PerfMon field of the
register to a value that conflicts with the PMU configuration.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 52 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0faf458b0efb..fbd335ac5e6b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -665,6 +665,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				const struct id_reg_info *id_reg, u64 val)
+{
+	bool vcpu_pmu, dfr0_pmu;
+	unsigned int perfmon;
+
+	perfmon = cpuid_feature_extract_unsigned_field(val, ID_DFR0_PERFMON_SHIFT);
+	if (perfmon == 1 || perfmon == 2)
+		/* PMUv1 or PMUv2 is not allowed on ARMv8. */
+		return -EINVAL;
+
+	vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	dfr0_pmu = id_reg_has_pmu(val, ID_DFR0_PERFMON_SHIFT, ID_DFR0_PERFMON_8_0);
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_pmu ^ dfr0_pmu)
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -725,6 +746,15 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_dfr0_el1_info(struct id_reg_info *id_reg)
+{
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	id_reg->vcpu_limit_val =
+		cpuid_feature_cap_perfmon_field(id_reg->vcpu_limit_val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_4);
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     const struct id_reg_info *idr)
 {
@@ -762,6 +792,14 @@ static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
 }
 
+static u64 get_reset_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				 const struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_DFR0_PERFMON)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
@@ -814,6 +852,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.get_reset_val = get_reset_id_aa64dfr0_el1,
 };
 
+static struct id_reg_info id_dfr0_el1_info = {
+	.sys_reg = SYS_ID_DFR0_EL1,
+	.init = init_id_dfr0_el1_info,
+	.validate = validate_id_dfr0_el1,
+	.get_reset_val = get_reset_id_dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -823,6 +868,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
@@ -1677,12 +1723,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
 		}
 		break;
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
 	}
 
 	return val;
-- 
2.34.0.rc1.387.gb447b232ab-goog

