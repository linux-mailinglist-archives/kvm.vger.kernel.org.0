Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5CF66D3D8
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 02:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbjAQBit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 20:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbjAQBi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 20:38:27 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C7229E02
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:38:26 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id n27-20020aa7985b000000b0058dae392ac5so1601027pfq.10
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDhGZMGcl/+rCpQW7EzsP5A7EK7uMx6I717AP5BdSVE=;
        b=g3A+F2lovTBusknN04Pspphh2sOZEygyJHo6g0SrJ2qVG/CZS9TOHepUiFMEbeu2P7
         +pbgUZcUYF9GlDu2Noju5TPTZatLo7dvV3wDHPHHLXd7YJ9d+17CzdZGeEHU0NL4BMYF
         rcTYh00PPwtNgsZ5yVDHHXSEHB5qB5IITaq2PmI67NCedEepfxXkNWDlmZrX+EBPgqAI
         pIGKaWKriMwjqFxECsiRor9wGaYSvU1+JKqrYzRyYHNVdGAb8aiO6l5y2aoYhYKiNmyz
         GLk9+y/dlVZ3Ae67oQRNlOcxe92GGHLfiG6kT5OlPZtVfxpx1K9Mty5YY4ISn/Piwj1A
         DtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDhGZMGcl/+rCpQW7EzsP5A7EK7uMx6I717AP5BdSVE=;
        b=v1jVU/Umt6NVh7zks9cwVs+UHD1KQI+pZhn2+Y358CCka3EZpqdacQfSLCr2z2DGTi
         9GZeT+TiSUQK3liUFYkrzS+xz7jErnDjJKGqG/sj7uKCagM9k8V8rmK2nCdzRSzskVDI
         LeEGnipniRMWzBcsbw14I1h2SPZYoIoWnQ6IapTuP0XPF/CZMMQ4hxiusIj84Vpc/y9q
         kUKakmj4GtTSbwFuD69JqbYAWhQll1drBxpDyL4wOwMQQg09PlD+ABMACecwl3gOgLvZ
         55pcDG1hkERFzw0nQGV9XGHT3LyEQicFjbsGj0NnO26k5HQjWBs0zwMzaim4Qw2SDrud
         XRPA==
X-Gm-Message-State: AFqh2kqf3Uj2h2R89woLDvEKGVN4PKTOFIqUgAAagYQcjAsmJC5h03SO
        8h3UoEIFgC/0/Y+HtZLGdneR4+WOhZU=
X-Google-Smtp-Source: AMrXdXuVU/+Elb5Rp0AHcmNgcHCXEJox4jaCx2mUWqCwLJEwmIXLFTyN3/3HemE7+V5HT6N4PiGUjHLD8m8=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:aa7:9f95:0:b0:578:1e16:f788 with SMTP id
 z21-20020aa79f95000000b005781e16f788mr134098pfr.12.1673919505841; Mon, 16 Jan
 2023 17:38:25 -0800 (PST)
Date:   Mon, 16 Jan 2023 17:35:38 -0800
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-5-reijiw@google.com>
Subject: [PATCH v2 4/8] KVM: arm64: PMU: Disallow userspace to set PMCR.N
 greater than the host value
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

Currently, KVM allows userspace to set PMCR_EL0 to any values
with KVM_SET_ONE_REG for a vCPU with PMUv3 configured.

Disallow userspace to set PMCR_EL0.N to a value that is greater
than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
support more event counters than the host HW implements.
Although this is an ABI change, this change only affects
userspace setting PMCR_EL0.N to a larger value than the host.
As accesses to unadvertised event counters indices is CONSTRAINED
UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
on every vCPU reset before this series, I can't think of any
use case where a user space would do that.

Also, ignore writes to read-only bits that are cleared on vCPU reset,
and RES{0,1} bits (including writable bits that KVM doesn't support
yet), as those bits shouldn't be modified (at least with
the current KVM).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 67c1bd39b478..e4bff9621473 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -958,6 +958,43 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 val)
+{
+	u64 host_pmcr, host_n, new_n, mutable_mask;
+
+	new_n = (val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+
+	host_pmcr = read_sysreg(pmcr_el0);
+	host_n = (host_pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+
+	/* The vCPU can't have more counters than the host have. */
+	if (new_n > host_n)
+		return -EINVAL;
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
+
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -1718,7 +1755,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0 },
+	  .reset = reset_pmcr, .reg = PMCR_EL0, .set_user = set_pmcr },
 	{ PMU_SYS_REG(SYS_PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(SYS_PMCNTENCLR_EL0),
-- 
2.39.0.314.g84b9a713c41-goog

