Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCC1429C8E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhJLEii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbhJLEih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:38:37 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D088C06161C
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:36 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id m26-20020a62a21a000000b0041361973ba7so8587932pff.15
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cwGN9Xe3XWxW643nb96+bXhhQ/Ir7xJT1HwtMeHM7cQ=;
        b=DBUBOXq/KtFBlinyQ1LBw4GMEMeHuJzh2MUTnjINtr2KUrltQAUA/+vj8wI0Fk5ST3
         XiWsa2domVcF8x4i7LPxC0hj8GAwn/DPal9Zqj1qoljPzYPMatgwIia0NMQQqWKOxdYE
         LeLft6vpRTZbBcHr0bemhAlKRQCe5qJgGwKhn2+w35t4snNcehqQb2g0rsw1RIOdYFU9
         bAiPujoV+AaVBXHt8l6+A821yQN76n/5eHRiIh9+1xoDs8dHcReaRoDiKfQOBKkSwGZP
         HVYmsNdv0YnE0MVnp1hIZAk+puV5zvweS0KhO09Xkis/O6oEEaP7NKkHSlBTNJZEgphI
         qdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cwGN9Xe3XWxW643nb96+bXhhQ/Ir7xJT1HwtMeHM7cQ=;
        b=4SRq5QmYTQaCGn3w45jcVV9GtnT9tyDtvo0aSCp3vH/SF3R7qNWWyZr3BRIPSwgF1t
         CTQBvpqFxXqwB0nqxZ0li2xLD8hMqza5/lSVwGnJguqVLg/rAYa6bhI0X/PkIiHO1D4k
         ziqANgp+pe4CAxh3KSRrcrYjAG1jxtdXG3trZgEErg9fF+1htQ8aZhQOMSIEjQTlcIrN
         0CJF1yFxz+mHOrp9njyfqty6Ak/w9mU94oVDCRmcYFrd2HxddDs0ktaGRSL5saig9MQ9
         CjKONs0kYQkr8NFR4EWXw+0L8RXtFbKz9v29+8bd2DwemRzL+EpKCyUkaHf5M6I5TlIU
         9vgg==
X-Gm-Message-State: AOAM530loQMB3xmo6IGAAnTr/PTAM/jFKdNxjWtt+mO0m6oyGhHvG9U2
        Iz9BELofGlMPjaqNScMiDj4j8+JvvQg=
X-Google-Smtp-Source: ABdhPJy8CGkD4X+vedywWNr5lgYqfM+G5c5VEXo+GN+CPYbQ23SjsxTScLeFIEMAadLh5UzZSK8h53NYvAg=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:8b8d:: with SMTP id
 z13mr296126pjn.0.1634013395790; Mon, 11 Oct 2021 21:36:35 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:21 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-12-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 11/25] KVM: arm64: Make ID_DFR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 57 +++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 61e61f4bb81c..84c064dfc63a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -442,6 +442,25 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
 	return 0;
 }
 
+static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	bool vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
+	unsigned int perfmon = cpuid_feature_extract_unsigned_field(val,
+						ID_DFR0_PERFMON_SHIFT);
+	bool dfr0_pmu = id_reg_has_pmu(val, ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_0);
+
+	if (perfmon == 1 || perfmon == 2)
+		/* PMUv1 or PMUv2 is not allowed on ARMv8. */
+		return -EINVAL;
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
 	u64 limit;
@@ -526,6 +545,16 @@ static void init_id_aa64dfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_dfr0_el1_info(struct id_reg_info *id_reg)
+{
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+
+	/* Limit guests to PMUv3 for ARMv8.4 */
+	id_reg->vcpu_limit_val = id_reg_cap_pmu(id_reg->sys_val,
+						ID_DFR0_PERFMON_SHIFT,
+						ID_DFR0_PERFMON_8_4);
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     struct id_reg_info *idr)
 {
@@ -557,6 +586,14 @@ static u64 get_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER)));
 }
 
+static u64 get_reset_id_dfr0_el1(struct kvm_vcpu *vcpu,
+				 struct id_reg_info *idr)
+{
+	return kvm_vcpu_has_pmu(vcpu) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_DFR0_PERFMON)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.init = init_id_aa64pfr0_el1_info,
@@ -593,6 +630,13 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
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
@@ -602,6 +646,7 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
  */
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
+	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
@@ -1440,18 +1485,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = reg_to_encoding(r);
-	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
-	switch (id) {
-	case SYS_ID_DFR0_EL1:
-		/* Limit guests to PMUv3 for ARMv8.4 */
-		val = cpuid_feature_cap_perfmon_field(val,
-						      ID_DFR0_PERFMON_SHIFT,
-						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
-		break;
-	}
-
-	return val;
+	return raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 }
 
 static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
-- 
2.33.0.882.g93a45727a2-goog

