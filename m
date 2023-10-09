Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754D67BEEE0
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 01:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379099AbjJIXKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 19:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379095AbjJIXKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 19:10:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC4F211F
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 16:09:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d815354ea7fso6635710276.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 16:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892952; x=1697497752; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVPLom817QijAmu2ToM6KNwT4YXyplIKJbzjUf63Skc=;
        b=OxoSC0kIC2tM7yj6oB7INmcei2Zyace6vqK7POSLLwVgZuOTkxHjy97WppcuGY3JjH
         +A0lMgF1kPr602w41/FUuBLgQgBAQCEbjPJnrYIRYgBJMYTJYuZSNmXjc6ymu/lhXfMc
         Vv8pxUGUMX9E59T2D9/bP3zARX+wgK/cq1wDbhGpb2zvpPUB3bhn+zJcvwh5sIK0FixL
         6MXwMCgIjBx7iJVHlwXDrQRRBesJODOSlXHs4+XTQjMkUWzTS3k7vwpyt9fta9T0Iqa2
         VSXwUzhExSMoYPEI2Ey6B6SRPJ7xGQ0BoDkHmORkvU8Zr+quGxBJr9jD9MshWhmg0QSb
         kTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892952; x=1697497752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WVPLom817QijAmu2ToM6KNwT4YXyplIKJbzjUf63Skc=;
        b=L+Geoe7/L//aoHYGNLi/B8lL0U8TxeNIAckt3A/HvAA0u6CNg9UOQzrx6TIDv5dCkz
         BEg3yEkk/rzZ+8s7RVnUOqEHdp1Cn5fb6K5ZW0RyRkREBaEPJSOajuhJsZtCOrSh7nQy
         7feBn8hlPi1RX3/fP0BvBQoH4XO1f0zoKLzPY4TtXVqK6fy39NKXBOqGzueBpCdn7zgy
         5zhrckA5S+RUnpBRCkMbJA6DMD23oyWPg47MIEeEfK/KiYou8ypkewRdpCa1eB7zmF3R
         10G/HQ1a7AOz16LZbV5Ht1JbW/gAfEHyUQ8yKpAr0c5zy/exNAvfZzKprMmCv8ad4Y3i
         LPuA==
X-Gm-Message-State: AOJu0Yy5CVMFE5koazovPz2Y7YYf2Wl9MpR2E8Lb0HowAc/cdo7piWog
        2KQi8o9xEfVuHSQWRX5NLWtvjG+9Pa95
X-Google-Smtp-Source: AGHT+IFyNG907oCnWxlCAmcf3y3TzafJxvxtebFLo6APkYcTiodd1Eri22KDLIo7rsKWPkhluSmUKsZppbb+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:5057:0:b0:d9a:5e8f:1562 with SMTP id
 e84-20020a255057000000b00d9a5e8f1562mr1171ybb.6.1696892951907; Mon, 09 Oct
 2023 16:09:11 -0700 (PDT)
Date:   Mon,  9 Oct 2023 23:08:54 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-9-rananta@google.com>
Subject: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N
 for the guest
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

KVM does not yet support userspace modifying PMCR_EL0.N (With
the previous patch, KVM ignores what is written by userspace).
Add support userspace limiting PMCR_EL0.N.

Disallow userspace to set PMCR_EL0.N to a value that is greater
than the host value as KVM doesn't support more event counters
than what the host HW implements. Also, make this register
immutable after the VM has started running. To maintain the
existing expectations, instead of returning an error, KVM
returns a success for these two cases.

Finally, ignore writes to read-only bits that are cleared on
vCPU reset, and RES{0,1} bits (including writable bits that
KVM doesn't support yet), as those bits shouldn't be modified
(at least with the current KVM).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 57 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c750722fbe4a..0c8d337b0370 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1087,6 +1087,59 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 new_n, mutable_mask;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	/*
+	 * Make PMCR immutable once the VM has started running, but do
+	 * not return an error (-EBUSY) to meet the existing expectations.
+	 */
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		mutex_unlock(&kvm->arch.config_lock);
+		return 0;
+	}
+
+	new_n = (val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+	if (new_n != kvm->arch.pmcr_n) {
+		u8 pmcr_n_limit = kvm_arm_get_num_counters(kvm);
+
+		/*
+		 * The vCPU can't have more counters than the PMU hardware
+		 * implements. Ignore this error to maintain compatibility
+		 * with the existing KVM behavior.
+		 */
+		if (new_n <= pmcr_n_limit)
+			kvm->arch.pmcr_n = new_n;
+	}
+	mutex_unlock(&kvm->arch.config_lock);
+
+	/*
+	 * Ignore writes to RES0 bits, read only bits that are cleared on
+	 * vCPU reset, and writable bits that KVM doesn't support yet.
+	 * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
+	 * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the vCPU.
+	 * But, we leave the bit as it is here, as the vCPU's PMUver might
+	 * be changed later (NOTE: the bit will be cleared on first vCPU run
+	 * if necessary).
+	 */
+	mutable_mask = (ARMV8_PMU_PMCR_MASK |
+			(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT));
+	val &= mutable_mask;
+	val |= (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
+
+	/* The LC bit is RES1 when AArch32 is not supported */
+	if (!kvm_supports_32bit_el0())
+		val |= ARMV8_PMU_PMCR_LC;
+
+	__vcpu_sys_reg(vcpu, r->reg) = val;
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -2150,8 +2203,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
-	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
+	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
+	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
-- 
2.42.0.609.gbb76f46606-goog

