Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796B44B425F
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbiBNHAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:00:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241044AbiBNHAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:00:38 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AEA58386
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:00:30 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id bj11-20020a17090b088b00b001b8ba3e7ce7so13501308pjb.2
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bOvKI1kPCaNNGWhIjOWMoR69tGeqR4WLISP2Q7llMqI=;
        b=csOB7hi1VBA/oFDOyjQMZYQFqlg8l/OnmxylmJhek12832NT8JhFn5Phv7C6mUHwbp
         AKruxmYtN8nVv4ced2ng2XspMYt/cavaRDSE9kd8AsUuTGyjGmcIqUzihAgLo9HcDuB6
         BKZZ4iza/sROO2ChnPsyCtEyqhIstwciWY1Bs1iz9w93e+WCzWDG9+wgT9g3NrJi2m5o
         2mXJwZC6t+JxapfS4ExaBSlUMRQEj9sBcrQlQl75AxtlYa/XH9WUCCSZVc9vt/uzSogG
         YSlwNIZ0jXx8QSNce60sNbxG5PzHlTEWVEqjb7+D4psXrlSiEDExSYtKX1EolSUDlfmc
         EYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bOvKI1kPCaNNGWhIjOWMoR69tGeqR4WLISP2Q7llMqI=;
        b=gJ0DfWcyosagYV3wekFbAnV9sAUUUrwL8DRl6IPOcRUUtBQdXKQu3gZabpg3M/XDBb
         3vfuTUyv7zkCGyXfrU4KBucrlFNys0v+wGYdJlCDxyrxW7eD/Dr00PE4/tLKMH84CZ/+
         2J0UADAQK5XIoNvArHu7XfYSuT5r8wY19mjQJSMsDXp3KEppf28/CExOM0l+xAQ/D2W6
         z4k+7GxioqgGTTYVoPSw2YEbCdR+hblRKMUafl9OoIc9ugBkDqo6Q/u57g2GIbwstPZU
         a4BU01OtxJg1ZZzQbu71XOOgHPmAdvf7E12eawBPOdK3M8cheJnGvrdAKK76vckn67vj
         lkfg==
X-Gm-Message-State: AOAM531nlkr3RAwnbnDpccTk7Hx8uKPGRwAEg0LkAmhZIXWN7RAYYpa0
        msZ+Lzg/6RlvlpxoRrpRnv41xlw0ark=
X-Google-Smtp-Source: ABdhPJx0j283c3uteG5vU/Wm7GzzzV9S4GvLk6zEMwainkGx3b9r3oXjbaFonEE5MPqvOlYgJbXjZ0p1T3E=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:aa7:9ad0:: with SMTP id x16mr12998774pfp.55.1644822030158;
 Sun, 13 Feb 2022 23:00:30 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:32 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-14-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 13/27] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_info for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 90e6a85d4e31..fea7b49018b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -654,6 +654,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_info *id_reg, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -816,6 +846,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.vcpu_mask = vcpu_mask_id_dfr0_el1,
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -826,6 +861,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.35.1.265.g69c8d7142f-goog

