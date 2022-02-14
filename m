Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AEC4B425D
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240998AbiBNG76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 01:59:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbiBNG75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 01:59:57 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52878575F7
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:59:50 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id g21-20020a056a0023d500b004cc3a6556c5so11092537pfc.22
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Brz6Y3j0MZViYAVMVNSgTmSSQnU2BlZWdtLqRqNaGsU=;
        b=Zu/UInFm39+Vm/bojUEccM94nZ9lA0DMX2QsEIaUyNi8fhkgvXbwYgWeczj5b+togF
         OMZJQ6q0qT+ld4tcgGrXQqv4ToFMTZ2Y9L/bIMZGz6WCDzumtbAA6qh+dQhCaKD8U1Fc
         cUTF8pUdBeTFJgl/6rtcjojOSrcXYXYnlWZF9OiwZE8qdd9uihGFSmBUwXW+YpTykR0w
         do5vJatra5x1BNWBA02xXjlt/ghW9hNKqzsVg8YLdRuoEMKUWLmDdsNZUnR7NvAdwQlt
         +kQLPlttHiIFiijR9O85L0qGSS2/OsSZMNIuhy5no5X7OsBRsee+pRBI0k8KPonH4m0z
         QRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Brz6Y3j0MZViYAVMVNSgTmSSQnU2BlZWdtLqRqNaGsU=;
        b=avTP0NyUkgf0xRwR3JnRwlWXjXgEepSiio36jq9BQ7a2vy1uZ/WHvrBhhIAWK6J2H5
         oQhR3T+ZBHAfzPtnrHqKJpKSNEB1AG1PA6i6rqMrW7BzzRa9bCfkd9EuTay0y52xsVGy
         obh+HcnybpVD6epTrd8+/wUVK6Oo/aNau1/0Bp7RYdzVWBmX13+crmxq5S4pNHKWEnoY
         ID7yF/PVZzD93nkabsMKXkvyEwo28Au0ulcD3HTijersHAgd7Qb4rZo01OTtDbgvA+FG
         icnwG6WQ6k1nLPbKuqHaelCxiz4/L3oatAp4ECEE5ixPUWqf0L6WCanOPQJ6yKHuxJjC
         Eb0w==
X-Gm-Message-State: AOAM531OuQjQZGOekhoeoGUVy1BEBQllBwVVi7lvsm+o0qi4zyzj4vtH
        CR6p38YA+8wkdVaNoCz9ALfXfOQQiug=
X-Google-Smtp-Source: ABdhPJwWwbe9hH9AKFYWngQ18eSzKL4vUbmfnE2yQiNzgqPynQfz0rkiJhzI+TM01pY5PO5th91tCagghrU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:894:: with SMTP id
 q20mr12856682pfj.79.1644821989848; Sun, 13 Feb 2022 22:59:49 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:28 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-10-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 09/27] KVM: arm64: Make ID_AA64MMFR1_EL1 writable
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

This patch adds id_reg_info for ID_AA64MMFR1_EL1 to make it
writable by userspace.

Hardware update of Access flag and/or Dirty state in translation
table needs to be disabled for the guest to let userspace set
ID_AA64MMFR1_EL1.HAFDBS field to a lower value. It requires trapping
the guest's accessing TCR_EL1, which KVM doesn't always do (in order
to trap it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which
also traps many other virtual memory control registers).
So, userspace won't be allowed to modify the value of the HAFDBS field.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4ed15ae7f160..1c137f8c236f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -570,6 +570,30 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64mmfr1_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+	unsigned int hafdbs, lim_hafdbs;
+
+	hafdbs = cpuid_feature_extract_unsigned_field(val, ID_AA64MMFR1_HADBS_SHIFT);
+	lim_hafdbs = cpuid_feature_extract_unsigned_field(limit, ID_AA64MMFR1_HADBS_SHIFT);
+
+	/*
+	 * Don't allow userspace to modify the value of HAFDBS.
+	 * Hardware update of Access flag and/or Dirty state in translation
+	 * table needs to be disabled for the guest to let userspace set
+	 * HAFDBS field to a lower value. It requires trapping the guest's
+	 * accessing TCR_EL1, which KVM doesn't always do (in order to trap
+	 * it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which also
+	 * traps many other virtual memory control registers).
+	 */
+	if (hafdbs != lim_hafdbs)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -675,6 +699,11 @@ static struct id_reg_info id_aa64mmfr0_el1_info = {
 	.validate = validate_id_aa64mmfr0_el1,
 };
 
+static struct id_reg_info id_aa64mmfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64MMFR1_EL1,
+	.validate = validate_id_aa64mmfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -689,6 +718,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
-- 
2.35.1.265.g69c8d7142f-goog

