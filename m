Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A8F485FBB
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbiAFE2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiAFE2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:28:47 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C851CC0611FD
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:28:47 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 62-20020a630641000000b0033ab7698954so865815pgg.10
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kduJ8W7D23BHwaQqjKYPNo6TWtKwdbe4Pc0zb3RITt8=;
        b=fKlXAux6G7PjhGP2oJRAOU0jZOCiN6+OnCweQVroA6ACLMYmdQ3VyAoWtutcib5ZKj
         30QA6RUJpRG8JzLhKgPmimoHkW4yLy+UKVHqwu90LnsGQus1oYaHJ7UhFlFcSPBSUuzX
         mUI+n7ioNGsSvMe7aR8nT5ag1xqNVpQ+B+/6e/wP4y9NuwHejlv5akE1DtvgVnntXB9R
         9rtnO0Q5HTSinZbv31ZjvBKELAXybcYQhRLY6V5jvJQG0dBOT7r1LjeB6VXxgBLyzPnf
         8sp/96HX8tzitwF+hgIgruNcOvCJwhT0AM2x9Pt4phAKqk3bgRnW1i6tImUBprVoRkA6
         4fEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kduJ8W7D23BHwaQqjKYPNo6TWtKwdbe4Pc0zb3RITt8=;
        b=zhvVCEoOZL1OEba8JaEkCsKFX9Mm2Yi09MgewfimZESfBeZORaPg7xuahvbStqd4Pg
         51rV7bbSnobtPFH6WqyOULaJMT/nxDE14pubg+7tfbtI8LTF9Qa3CRv1KRnrkPn3zGkK
         bBND87u/TmrMXwR0pbnDSlFcBDzg8m6/vzCv9UCWYFabi3yJ7ArTcoQ/zXad92d/ban0
         bRc20NdeIVrPNVg3d2gOX+wCteRaj8y0Pcrowd2Dd8O/xhCjSFw2YCqRSiodwgj3JAFJ
         9DQyqeU7FvXnxRoCyTytkPlQYpczuZ2qaaYqZJzZDJS2li0PI324Dly0JDh6mgNDXq3Z
         iUCA==
X-Gm-Message-State: AOAM530FV70V5fF5hdVSKoIxCr9dXmE9atCDLmD8BGSxZEN5XYYovKYh
        1aO41SbrYhlJdboTzf/Q+Do1gf5oEVc=
X-Google-Smtp-Source: ABdhPJzPTNL48G0HNzxfO0ns7AexR+6gb/acsiG8g9dhMwIoRkX3C10ON5Y8LUKx4GNdP776NLQAWlwRwGo=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:6d23:: with SMTP id
 z32mr7912129pjj.144.1641443327365; Wed, 05 Jan 2022 20:28:47 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:26:53 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-12-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 11/26] KVM: arm64: Make ID_DFR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 55 ++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9a9055d60223..1707c7832593 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -596,6 +596,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -656,8 +677,17 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
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
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
-					 const struct id_reg_info *idr)
+				     const struct id_reg_info *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
@@ -680,6 +710,12 @@ static u64 vcpu_mask_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
 	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
 }
 
+static u64 vcpu_mask_id_dfr0_el1(const struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
@@ -731,6 +767,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
 	.vcpu_mask = vcpu_mask_id_aa64dfr0_el1,
 };
 
+static struct id_reg_info id_dfr0_el1_info = {
+	.sys_reg = SYS_ID_DFR0_EL1,
+	.init = init_id_dfr0_el1_info,
+	.validate = validate_id_dfr0_el1,
+	.vcpu_mask = vcpu_mask_id_dfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -740,6 +783,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
@@ -1662,15 +1706,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		/* Clear fields for opt-in features that are not configured. */
 		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
 
-	switch (id) {
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
-	}
-
 	return val;
 }
 
-- 
2.34.1.448.ga2b2bfdf31-goog

