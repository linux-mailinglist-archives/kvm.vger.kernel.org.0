Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042344D5A07
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242130AbiCKEuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346465AbiCKEuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:50:00 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799341AAFD9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:48 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id k130-20020a628488000000b004f362b45f28so4532094pfd.9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uoX+Y+G6xoHPXp4kqnfSVmpfMNJMZgMHDhyE0auL83Q=;
        b=YNltLUs0JQ2gFkvqzjAXUoHgAi9ZfaLM/L+GHykWnnLtUkQPfLjXODJYzEL9TwOD6t
         KT525jlPQqr6DC8/EAKJleLT4RIABEucKJ5u44URo1HHUaVsuoJY+jybtXEexOHuofJ6
         wCj0ICOlApK+2jJbRNw4N3p1WM8pFyr4Ubpf6Pt8qMqU0jlcXMYsJZjx35tteE0y5NUY
         qnS6lOa6QbzS4qN2M5utqKhbabagUFrSOdlffYrSdoPd8AZqgRpu5tPA0ERglZjeaJ5R
         1E63LdOlRt9IhJ41HAwVfOJRFHL9oVsIcfQZg6j8+/BIPZmoEh1N4r0YC/zkS2bMai5t
         aVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uoX+Y+G6xoHPXp4kqnfSVmpfMNJMZgMHDhyE0auL83Q=;
        b=bQ+5MilHQM2tp5VLexAFtuGyW03yNTBLg34Ua97PR2/4DRrWRBHAl/CvZezrgs+ODJ
         TPJWHDpW8ymKdAXclKY2VpHymFzJk+5gRrcTh0Ad7akU22ZhAIOVH2mQUd9XmHjJEgJN
         9n0Fva/MwhzAfe09lXOF/5g00ls0SIzT451tCYKTMEBo1qPkLIOZe12k7C+xDIarrSU3
         rFBUY1Rjg1i4bE+ybKkUgox/I7h9aWHGqtUnRYAW11XH0+st1EmsskcgxZssW73KpqYx
         8laWjOPsuLDWMrNUt3ouL0MDCjTTYg1j0NFr25jgsAHj6zLquMWRzJhgQCq7dFWB+jd8
         nB9g==
X-Gm-Message-State: AOAM531i4EtcD7AjJ5Ku0mDW1aRggTnEuJ/spCkGx90DFPrxDJitMSPx
        OrqhImsTqSFJoPJf57FCl/qsMDdkRAc=
X-Google-Smtp-Source: ABdhPJzlEs8FIbA8U2Dis881SY2f6s+kkp+46U11VGjc7k6FSU9t7G0DvVjrYGujHVyxJSa56LXMGJhejwU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1a47:b0:4e1:5bc7:840d with SMTP id
 h7-20020a056a001a4700b004e15bc7840dmr8455437pfv.10.1646974127983; Thu, 10 Mar
 2022 20:48:47 -0800 (PST)
Date:   Thu, 10 Mar 2022 20:47:56 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-11-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 10/25] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_desc for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 46d95626f4d5..45d22b9e0d40 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -632,6 +632,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_desc *id_reg, u64 val)
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
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -3474,6 +3504,11 @@ static struct id_reg_desc id_dfr0_el1_desc = {
 	.vcpu_mask = vcpu_mask_id_dfr0_el1,
 };
 
+static struct id_reg_desc mvfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(MVFR1_EL1),
+	.validate = validate_mvfr1_el1,
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3482,6 +3517,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	/* CRm=1 */
 	ID_DESC(ID_DFR0_EL1, &id_dfr0_el1_desc),
 
+	/* CRm=3 */
+	ID_DESC(MVFR1_EL1, &mvfr1_el1_desc),
+
 	/* CRm=4 */
 	ID_DESC(ID_AA64PFR0_EL1, &id_aa64pfr0_el1_desc),
 	ID_DESC(ID_AA64PFR1_EL1, &id_aa64pfr1_el1_desc),
-- 
2.35.1.723.g4982287a31-goog

