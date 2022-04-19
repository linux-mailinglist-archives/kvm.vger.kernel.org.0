Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E0C50652F
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 08:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349147AbiDSHAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349126AbiDSHAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:00:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9844E326CA
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oo16-20020a17090b1c9000b001c6d21e8c04so1181702pjb.4
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 23:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YLQ/jtBXlP9biEBlw29VzMlxGtkHK85JhXdSg1Dey2k=;
        b=eAw4dTke4ES4lJseM7OQ6Z/1m7Omzg+78Rf0GXMt1GNKwDyp38SZ6TmEaeL41gIF3V
         O3W2n9UMmq+6M2Dlqx7kPsxjW9QwgcacCCvhksep5fJ2ps5tbZ4U6zJw0q2UO/Zml3ym
         9BCmmDCprmbgGdLCXrZdHzt/XmNLdUXEBH4TBQs6gcdzLkC7ybe3KRk952sC/b6zHZSA
         iAvYXo/EGdqGvbO71ux5zx0vlb30A3xe8dM0BJSX6BxG1QZD+7b6D7VD8d30WtVdba9j
         P00CX0knXDaWtBD1id8WQ6fLIy/E99z+vOOTA5nnERYy6RpDQtJR1OgHZ37/lfhfTb+s
         RrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YLQ/jtBXlP9biEBlw29VzMlxGtkHK85JhXdSg1Dey2k=;
        b=UtowjbNBCmQB0JxmbHTbg6EAEzx3loSs4qauGdygyRnRqmNYFu4YekH2GzkeThovX2
         yDcsE04BRdKIay5EdLUiPYZcHVZp4sLj3ubKbDHNdSl8o6/F7BnYwqZIshQnSeNbMBP4
         4AzB3c/wD7CBstOD5l1ovKNT2RokAt0aSksyHZooHcxq1Gzwfv7pXIfZWkOiDflgbWNV
         jJUwl1eYTE/zW3yNO5Iz+5oXYUCq5gVQDJzNNoXvk933xFRH3QYbqzDrjMAGNVUpvom0
         UfRAIsdp0ym6PEdwi0cRFSe5WL6j+Eyw72W7PKFDyVdQQ8IkPlljmnNLwQkyXbABLe53
         eTFQ==
X-Gm-Message-State: AOAM530vOsdXZY/MW2ET4INOsunmT5AyKOKXTHNOOtsBrUrmBeQ79YwB
        UYgjLmJzzWUK2HCUzD3G8v2ag0NFsAw=
X-Google-Smtp-Source: ABdhPJwTql5uKFd/srdQQoG38aaRxnbuF6PS3EHwIAVgiky4Itg3RMnrRk+AFOPWQpN2BRiBLUohcU6eXZw=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4b07:b0:1d1:8a08:5096 with SMTP id
 lx7-20020a17090b4b0700b001d18a085096mr16807088pjb.91.1650351475734; Mon, 18
 Apr 2022 23:57:55 -0700 (PDT)
Date:   Mon, 18 Apr 2022 23:55:37 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-32-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 31/38] KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
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
 arch/arm64/kvm/sys_regs.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6a8ed59d8d90..0e3cff91f41d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -299,6 +299,15 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR2_GPA3_SHIFT) >= \
 	 ID_AA64ISAR2_GPA3_ARCHITECTED)
 
+/*
+ * Return true if ptrauth needs to be trapped.
+ * (i.e. if ptrauth is supported on the host but not exposed to the guest)
+ */
+static bool vcpu_need_trap_ptrauth(struct kvm_vcpu *vcpu)
+{
+	return (system_has_full_ptr_auth() && !vcpu_has_ptrauth(vcpu));
+}
+
 /*
  * Feature information to program configuration register to trap or disable
  * guest's using a feature when the feature is not exposed to the guest.
@@ -394,6 +403,11 @@ static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
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
@@ -462,6 +476,12 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.trap_activate = feature_lor_trap_activate,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.trap_activate = feature_ptrauth_trap_activate,
+};
+
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -4416,6 +4436,10 @@ static struct id_reg_desc id_aa64isar1_el1_desc = {
 		U_FTR_BITS(FTR_EXACT, ID_AA64ISAR1_APA_SHIFT, 0),
 		U_FTR_BITS(FTR_EXACT, ID_AA64ISAR1_API_SHIFT, 0),
 	},
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_desc id_aa64isar2_el1_desc = {
-- 
2.36.0.rc0.470.gd361397f0d-goog

