Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA337443D27
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhKCGaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhKCGau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:50 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1E8C06120B
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:15 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id s22-20020a056a0008d600b00480fea2e96cso841300pfu.7
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hpPFwAGTwEZ1i/HOmllQFr9pElbCJZ8JCm8mzrl1EGY=;
        b=mq0S+7gAP0Npdg8RBHPC2lWxXXDKc+VHlWuF1/QYsXFOVsYtMWwvZyS0M+wBMY6/63
         w8/MhbJVnBgtNOQI//ywgCot6Z1cn/Utt5TWC+2JwoRBFyLfJBXFAWESwXlC7qUpEMoY
         HVClvfxgmmCUIfp6jufnEV8NKDk+ysqoSS1J1JGe3IV/S6GNb7yN++OgBk5PLEVpudom
         2QXxG10EP0KPYk10RJ5UDb3p0bYd1R0K4CPM2/jxQGN8uT4GTtkzQxeyfn/mlhyh9+1h
         bRaRSJ0xyifxrKcB/YNLByWcAu12PuOU+rzhT3pHXoSFpDiqo+6Yf7WLtLJzuPepoJCr
         DtRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hpPFwAGTwEZ1i/HOmllQFr9pElbCJZ8JCm8mzrl1EGY=;
        b=WBm3EmqUNKNcoIqf8rZB7xkwyJi1lBzr/nsF/EPxJ6w7iMg0zibeOK/AGL2OZYEKrF
         DMSoePkePpsgxfoQOefj+ZaZJVdCsbXDzWsYaXInJw1ZalitlNjD+fAyFvV5kQOtPYOM
         g9wKROMvjwztNULa3padHA8kpUTdZXdRVXVCzwqJrdPPYvWGOXi74a7Onz92/JOTZXNg
         Z5vEugwNoKQQUqiCCfIcx6G+b3ER1ICgiFq5iwq4JbdK8k9uSfbodkaW/RaCUI+N0Opz
         uFlxELvM5nOzL6eZNHx8AugJK2AzCLywGF9iaKyd9tZaW75pd5TLT9NKIEaxOIYCaLsQ
         thVw==
X-Gm-Message-State: AOAM532mzUatLhUfzIzssvNX51qxN+1kQD473sK7CpRNZX47s6ylP1Ft
        OsSLf8zI8QkWnzcxpbc37E4Z48843Wc=
X-Google-Smtp-Source: ABdhPJydVvRuo+vjDmU3tMNH4IppD6LBdgzne8qEmR7ZMkyzecx82BglXuP8sTb11J8mDk4MAmH3CRyb248=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr397676pjd.0.1635920894183; Tue, 02 Nov 2021 23:28:14 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:04 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-13-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 12/28] KVM: arm64: Make ID_DFR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 58 +++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 54bc3641d582..8abd3f6fd667 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -654,6 +654,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -707,6 +728,15 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
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
@@ -738,6 +768,14 @@ static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -790,6 +828,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
@@ -799,6 +844,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
@@ -1636,18 +1682,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = reg_to_encoding(r);
-	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
-
-	switch (id) {
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
-	}
 
-	return val;
+	return raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 }
 
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
-- 
2.33.1.1089.g2158813163f-goog

