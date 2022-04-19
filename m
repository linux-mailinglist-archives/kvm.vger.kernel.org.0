Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB150652B
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349118AbiDSHAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349128AbiDSHAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8A03207C
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:54 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so9262670plh.11
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FGn+d1/fzCMoysQ55Sv7panNzkYFCREIVH43wm5V/xU=;
        b=nbP6H9eLPB2KRUszqjTjx8oXBwErZ7lIfZHOLtdkJWYF4Y8A1N/NpiaKp37xuFx1Ud
         XFYUj8R3HIK/2yg2tTUzGPz29aiDAuuxLbJAZvX5j0DVwEfJ9DmZqNZuYwG854scSWEU
         KCgssLZ9jYfOjk0MY1SCFqfXsElf5DH70nSmWeFUNB3+TPODZGz0TwDe1XiI63R4XGqW
         dqIprL+Vy62aXPKqODFGp8794SpD9CXf3AgMD2as9uU2afjv9U086jbrTKkU7e+iSTca
         ZNe8BSjcDOQEwLGE2Riw8tDL09c0xKw6YVhUNpoL+BtOcOk72Wj/EgA9R6I8puV0x1Po
         kLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FGn+d1/fzCMoysQ55Sv7panNzkYFCREIVH43wm5V/xU=;
        b=R0RX29WEmihg0pBOdAOq85pUQOGNx+lM/nPHfdus1NHea5cUCb9SI20yGcK5hRumQJ
         v8KDFMbRvq03LhcwjbbG+U0n7ZoajcF6t/gGGAx2QvNcTTZ1bGA8iscv0WG6Qulw5JI4
         dxslJDHADMKf2vS2lsmItCIfrAKW48McZreWIrav5RicQOGhuzHCI5yyG2TH9EwJV3ss
         /pDCxfr+4Ezlcs5fLZLA6hahAJC6OZ9Cyssai224Ea+HgU1hCgmfC3D+OFrEn0vTVlAH
         4Wik9X541VbCgHZvybOfGs1VhDcRB/LKBYUh+SJpwNjNsLz2yAnFd7HtfKs0REb7L/c6
         FkzQ==
X-Gm-Message-State: AOAM533DquurcXpLELLCB3MaxAuokYbrzGtkiHizXLujVdxLF5NL9gJS
        fq9s1cPuJdwD/ZHURL5P4LYLL5FylLQ=
X-Google-Smtp-Source: ABdhPJxpYOikvgNJvHHbbpFpSUMKs8Qh1bxceFJTHg4QBYMxz42FIi3eaMxP3/8CTDdPHB7uL9Sp54w8dR0=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:3b86:b0:1d2:66cf:569b with SMTP id
 pc6-20020a17090b3b8600b001d266cf569bmr14889978pjb.206.1650351474413; Mon, 18
 Apr 2022 23:57:54 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:36 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-31-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 30/38] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
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
 arch/arm64/kvm/sys_regs.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a09c910198d6..6a8ed59d8d90 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -389,6 +389,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -448,6 +453,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
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
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -1104,10 +1118,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_id_reg_with_encoding(vcpu, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
+	if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
@@ -4433,6 +4446,14 @@ static struct id_reg_desc id_aa64mmfr0_el1_desc = {
 	},
 };
 
+static struct id_reg_desc id_aa64mmfr1_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64MMFR1_EL1),
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_lor,
+		NULL,
+	},
+};
+
 static struct id_reg_desc id_aa64dfr0_el1_desc = {
 	.reg_desc = ID_SANITISED(ID_AA64DFR0_EL1),
 	/*
@@ -4577,7 +4598,7 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 
 	/* CRm=7 */
 	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
-	ID_DESC_DEFAULT(ID_AA64MMFR1_EL1),
+	ID_DESC(ID_AA64MMFR1_EL1, &id_aa64mmfr1_el1_desc),
 	ID_DESC_DEFAULT(ID_AA64MMFR2_EL1),
 	ID_DESC_UNALLOC(7, 3),
 	ID_DESC_UNALLOC(7, 4),
-- 
2.36.0.rc0.470.gd361397f0d-goog

