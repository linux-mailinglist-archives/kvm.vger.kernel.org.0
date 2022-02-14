Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964664B4269
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241117AbiBNHCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:02:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241112AbiBNHCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:02:00 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9598358E73
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:47 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id r19-20020a170902be1300b0014edf03f82eso2775863pls.20
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l5XORbNWq/eRBF/KP+e0aDCNzGukLV10hjBR4KXniUs=;
        b=MJufiVJHKSyIus/sFhnoRwe2+keKwVB9kk5MzqrsJ7id6EZNMC30IKykXiNLgdTTsU
         VEMC26J4nsTGlzC1/XFzD+0AENUijjmcQSoMhoylRxg1CvenHLuPuZlRr7OLrHqWJzRa
         fvVE6sPk2yZWUhkJNd4jo5SZdek+ZjFGE8Lezs/exgfghLy7DZ1lKrblwCawnKK1oyoI
         RW3JtZZ9/0HQy9zbN4q1n5dcbiV0g1q9cKMrVesvzox6k0BUfqXyK/8U+zMu2pCEr/Bl
         pEQtrdCftz8Tl1R2z1vD79cXtgZk6KA2BcyV4qkFNaaOwqu97A8KasmUHI1X4QULMsbd
         7Jog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l5XORbNWq/eRBF/KP+e0aDCNzGukLV10hjBR4KXniUs=;
        b=AN3Tfn/d62FUpCE1m9gyyHYuRqogsv+oE2UwBRg4zc4yEa480euXrMzvV9ZtkvghSO
         mw+ObhPc8upwIzIOaxWkofr3tcFXEYD/5NnHiKRxOpBV0eW7jI+phSOgR+LgWjdByIMz
         DnNpZXcoiHPCCjsX2iFsW+70Yn374h/l7CK0+QaCP5bFuBp8cVk2hEGaxHgTapPIMFpM
         w50+Vnkj14ahjisAOrRr5rs7pT64XhTU91p19rJtkDeaCIpY0OX5T0jS8r12sKdBlnbB
         NnIxxmulaPjm5+y1UNOtbByj1OXpbhnn4oD0LefqqS/C+4PNTPZ5TNXLFw8/rT6570z0
         YhEg==
X-Gm-Message-State: AOAM5328ORlwEqxKyiV6ILn3vUFjfoDO/0LIIuuK0lV03xNOrXNrehN7
        AvSnxZfDdP3C6Xj16s5Z7TKiHFx+qDc=
X-Google-Smtp-Source: ABdhPJwJkw68YJr5to3yBrgNhXZsf8uxRX0mR+fW+ct2ISB7LByn8kkySbfysY2JTpFORc7JKGvY52yitHY=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr1640945pjb.0.1644822106646; Sun, 13 Feb 2022 23:01:46 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:44 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-26-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 25/27] KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
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

Add feature_config_ctrl for PTRAUTH, which is indicated in
ID_AA64ISAR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 205670a7d7c5..562f9b28767a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -283,6 +283,30 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/*
+ * Return true if ptrauth needs to be trapped.
+ * (i.e. if ptrauth is supported on the host but not exposed to the guest)
+ */
+static bool vcpu_need_trap_ptrauth(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+	bool generic, address;
+
+	if (!system_has_full_ptr_auth())
+		/* The feature is not supported. */
+		return false;
+
+	val = __read_id_reg(vcpu, SYS_ID_AA64ISAR1_EL1);
+	generic = aa64isar1_has_gpi(val) || aa64isar1_has_gpa(val);
+	address = aa64isar1_has_api(val) || aa64isar1_has_apa(val);
+	if (generic && address)
+		/* The feature is available. */
+		return false;
+
+	/* The feature is supported but hidden. */
+	return true;
+}
+
 /*
  * Feature information to program configuration register to trap or disable
  * guest's using a feature when the feature is not exposed to the guest.
@@ -378,6 +402,11 @@ static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
 }
 
+static void feature_ptrauth_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, 0, HCR_API | HCR_APK);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -446,6 +475,12 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.trap_activate = feature_lor_trap_activate,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.trap_activate = feature_ptrauth_trap_activate,
+};
+
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -986,6 +1021,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.init = init_id_aa64isar1_el1_info,
 	.validate = validate_id_aa64isar1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64mmfr0_el1_info = {
-- 
2.35.1.265.g69c8d7142f-goog

