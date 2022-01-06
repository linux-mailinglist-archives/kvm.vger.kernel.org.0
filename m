Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD7485FCE
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 05:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiAFE3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 23:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiAFE3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 23:29:03 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D6BC061201
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 20:29:03 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id 35-20020a17090a0fa600b001b160e1ecffso1000623pjz.9
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 20:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qPDa0VEsnhEJbcsFzMR0knGwcI8yYnbYngQzhurSzTI=;
        b=el0X9Zkgu29y78QxvRRd3e98uRJLbBfd8byXjqGxhRWbWZ5YLstsOUH3SFh+cW/6z/
         AVuB1b3VFvR84FyYVgCoeX3qyeSoxYIK9UU5iKlkt+sp13xtyJw7/vR4xGCQhIPlBtXs
         MlFRDk9JISkEweQpNA55vKistpn9TOflRmiQQHqXIG5WIJlgELrDF6YpN8bIcNyyqp9o
         F8Z4hvl/K/vZDGgrhVs9PXRe6QB09f/1aeu2jeZsgpsotEIpfkCZX+n9zCAVS0Onnnlq
         1vwCqEIl8gWTZ9xflG8USBgiBnrN/MhMk0hlU7CxCS6MR4Od2tIFu1cs91k+Y03JfjoF
         28kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qPDa0VEsnhEJbcsFzMR0knGwcI8yYnbYngQzhurSzTI=;
        b=O0GTk/daYRmz035AkEH8ErxiWoFr9msljYpsl+iLgAvsyz/bjeUCii4WOtC63Lf2eZ
         k5xwsJR0tVJrIcci9TUM0B3k1ds7kwcYVZgo3mlHV9kuCOYaDR1ht9F/UtISF/i/yPHM
         7eICNSq7REK0CU9RXwEFDoDaIO+WtLCpHchTzK530Cy4g8zv/acZl2Ef14fKDAp2oeWq
         eRmpTFwooqejRJQedVMUmD/qXRZOWbqC++bQGQyhqGN6kvJjk5ThYMas4tezDdbETbzT
         GjovVu0pimlbFYFR/zh2JcKsxiXTfeXDMcOFXYDxgkQ36tAVp2nNj4CUQAX1KqmrV4gn
         g+mg==
X-Gm-Message-State: AOAM5308Szp+geIr4Kuu+g4008aiS0BoLnik/32lBMaFCCq2AEuV1/Sl
        t3RQzCfdfhSKWVTioD1diQ9k1JM/KYg=
X-Google-Smtp-Source: ABdhPJw+xFogrAR3QZG8Cbh9A/rmDIhEkalnaXKaSZdJeTa/0vLqoOgvnJWOwy6unb5TL5lq547d52EGcuk=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:6a88:b0:149:848f:1e8b with SMTP id
 n8-20020a1709026a8800b00149848f1e8bmr44237005plk.124.1641443343115; Wed, 05
 Jan 2022 20:29:03 -0800 (PST)
Date:   Wed,  5 Jan 2022 20:27:03 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-22-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 21/26] KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
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

Add feature_config_ctrl for MTE, which is indicated in
ID_AA64PFR1_EL1, to program configuration register to trap the
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 015d67092d5e..72e745c5a9c2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -344,6 +344,11 @@ static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
 }
 
+static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -361,6 +366,15 @@ static struct feature_config_ctrl ftr_ctrl_amu = {
 	.trap_activate = feature_amu_trap_activate,
 };
 
+/* For ID_AA64PFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_mte = {
+	.ftr_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_shift = ID_AA64PFR1_MTE_SHIFT,
+	.ftr_min = ID_AA64PFR1_MTE_EL0,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_mte_trap_activate,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -847,6 +861,10 @@ static struct id_reg_info id_aa64pfr1_el1_info = {
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_mte,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64isar0_el1_info = {
-- 
2.34.1.448.ga2b2bfdf31-goog

