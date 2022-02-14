Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48A94B4260
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbiBNHCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:02:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241146AbiBNHB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:01:56 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0FC5A594
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:40 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id c192-20020a621cc9000000b004e0ff94313dso2898139pfc.17
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ju7y0INwCkVlTLrGGMqN8WpA4pAC77LT4GJuAIzw0k4=;
        b=dW97xLS3Zq7BUp9OFgrYXx9OPZjlDniVb0QY3oGt2NWSrc9zm8dQdio2ZyVuL11KfO
         bGbdHEjXjbOQMA0MrV222jVAlYgL5ubTMCDAG0JdwDvryI4nu/xDi3CWKDX3tt4SQGnF
         XmQJtHEpXONICXTk3SQTNp8U4j+5LYhIEF4FnKvgzDTFpxhBfznHpdtoqfCpIIAGY9MS
         t8gjBeJiNsXwFR/MvrHpS+tZYzu5h+v6rPDGCfaLPpTv9PzzdVe5U0+/Jf8HltyKX3qB
         4oasagz52cbDQ9j9OgN4wRDWy3hvXkO/EXEzCPiy2RlF13N/gvr4te2XnQ765XXfteXV
         6waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ju7y0INwCkVlTLrGGMqN8WpA4pAC77LT4GJuAIzw0k4=;
        b=XFm89K1UzLCHAQettLoxW/Y+8F3ygYnyWfCaZcyQAiZ5GeRKi8FZopeB7a8CuroLyC
         SAymWtaMRnorD/PHFdfR1RJYn65WLUv5gvIt/wPbQ21MplT7rxVKbpM2taGx7KXJxGS1
         jH+C0yOU2KZHM5nw535JsY4KlhY9OGp0EM7vTwUeyvwtCX53PUMCf1sCx7n0fZUIONP1
         QZM2Er4WusNEfsREYPXDHFnAVXLKGK6snuGVlaJYIosAwC481Rl2Kx2uu3TKuDfmudZ8
         5tndoe6eFt57FVK9MD9QqCHDuktAOpPUSLyQCp36H1OmAq6pnpjNirw7YbKoOZJeKbBr
         cCLA==
X-Gm-Message-State: AOAM533G5heFrxOto8QXLEKwZrYfYW9xmvlNhFuAQqhazYCIqp26Sixn
        bIO4k3/DKl/RplRYQS785OAH3rXNFig=
X-Google-Smtp-Source: ABdhPJw38wrkf0DY+q9xEUe+4IZIcMsK0dHMLQQ5rU+27P+/eKD5VvrZIoA2rsFN/Y4lan8hmVuWz0OYkuM=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:dcca:: with SMTP id
 t10mr12648551pll.133.1644822100107; Sun, 13 Feb 2022 23:01:40 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:43 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-25-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 24/27] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
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

Add feature_config_ctrl for LORegions, which is indicated in
ID_AA64MMFR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Change trap_loregion() to use vcpu_feature_is_available()
to simplify checking of the feature's availability.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d91be297559d..205670a7d7c5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -373,6 +373,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
 	feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
 }
 
+static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
+{
+	feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
+}
+
 /* For ID_AA64PFR0_EL1 */
 static struct feature_config_ctrl ftr_ctrl_ras = {
 	.ftr_reg = SYS_ID_AA64PFR0_EL1,
@@ -432,6 +437,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
 	.trap_activate = feature_tracefilt_trap_activate,
 };
 
+/* For ID_AA64MMFR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_lor = {
+	.ftr_reg = SYS_ID_AA64MMFR1_EL1,
+	.ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
+	.ftr_min = 1,
+	.ftr_signed = FTR_UNSIGNED,
+	.trap_activate = feature_lor_trap_activate,
+};
+
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -991,6 +1005,10 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 static struct id_reg_info id_aa64mmfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64MMFR1_EL1,
 	.validate = validate_id_aa64mmfr1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64dfr0_el1_info = {
@@ -1111,10 +1129,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
-- 
2.35.1.265.g69c8d7142f-goog

