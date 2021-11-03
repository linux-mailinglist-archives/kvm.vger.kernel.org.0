Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FD3443D48
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhKCGbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhKCGbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:31:13 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3F1C061203
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:28:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id p20-20020a63fe14000000b002cc2a31eaf6so1037241pgh.6
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ep2NTeFQHRtb1x7tniQeG2pd+DzpIaqpLIGDyxGNaak=;
        b=fFT02gdqViWYrbCdTEQFZh2dd8gF3sRFDKawTgXYqjLI7nmc2vVWIHc5fQYX9NKzEd
         OrN0S2OhP0OEbUusgLIOJ24ho/2alYvcos4x7SolFhapIn6YxL0Q/VDzjpdSyamRXq5s
         RrMyR8gjtsL8vUcd0lgvbJ6rN2iAQkzAgkFYvLsnRwgoEAjFhXUV3qEsGRMH+1yMZEsW
         29uITSD/EwfM2NeAOOpPDlb7zlKc6xEPzSf2xyfOc7+pQtJPKZvN+WxtlnnDnD9b2L8D
         LRn27uaxX+R+rYFbVrWjFF0aBcTVeCPiqJg9ZhuOt107MpCcOF6wgHso+ZYIQoYbVD/j
         HDkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ep2NTeFQHRtb1x7tniQeG2pd+DzpIaqpLIGDyxGNaak=;
        b=ERFecq8BvUNgsg/339cBRRLDOnSB65nJbffxk4+afFDeEFG9z3cmECCoFAaSOW9rmX
         1yV8M2AmOk19mo/GoAO3U8jNeHsAkqJm9XAP3GWpoTCRubHngSbbN1Ekm3PqcHgz6tly
         3kLXQAxhwJFf314SSKH7aLfBcV3EMIVhxidMmHtOVZeSDH1BgrDD78EJhxp7vy+S/ECb
         ErXrgJVwX87qnQOXGxQCrT4LZU7J1c7jV4iWcc9RoH+5xPuzTL+S8TJXJW3TVQHUZT56
         iceCEBF9PnQNjzZH6fLPbKhPI63NUc0AS3bNLkddVOkIX2jbBvJ8uFU1mIbma5TUeLIz
         orbg==
X-Gm-Message-State: AOAM530ez/DiWRrvatdlMfYmChxXXbYVtNnae54xNH2jxnP2xOxMgUe3
        WoQ9YL8BAFjiij1/wP+y9O2fp9x4XWs=
X-Google-Smtp-Source: ABdhPJxq8mVjnPJ20WpU44gAZn9NtxzZ4+sWrLWZuqNplD2biJyP84pZy1BiGUiTUN9ebm+egsfYYdatDyg=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:903:24c:b0:13f:2377:ef3a with SMTP id
 j12-20020a170903024c00b0013f2377ef3amr36514167plh.59.1635920917622; Tue, 02
 Nov 2021 23:28:37 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:25:18 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-27-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 26/28] KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
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

Add feature_config_ctrl for PTRAUTH, which is indicated in
ID_AA64ISAR1_EL1, to program configuration register to trap
guest's using the feature when it is not exposed to the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2d2263abac90..fd38b3574864 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -374,6 +374,30 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
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
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64ISAR1_EL1));
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
 enum vcpu_config_reg {
 	VCPU_HCR_EL2 = 1,
 	VCPU_MDCR_EL2,
@@ -478,6 +502,14 @@ static struct feature_config_ctrl ftr_ctrl_lor = {
 	.cfg_val = HCR_TLOR,
 };
 
+/* For SYS_ID_AA64ISAR1_EL1 */
+static struct feature_config_ctrl ftr_ctrl_ptrauth = {
+	.ftr_need_trap = vcpu_need_trap_ptrauth,
+	.cfg_reg = VCPU_HCR_EL2,
+	.cfg_mask = (HCR_API | HCR_APK),
+	.cfg_val = 0,
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -953,6 +985,10 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.init = init_id_aa64isar1_el1_info,
 	.validate = validate_id_aa64isar1_el1,
 	.get_reset_val = get_reset_id_aa64isar1_el1,
+	.trap_features = &(const struct feature_config_ctrl *[]) {
+		&ftr_ctrl_ptrauth,
+		NULL,
+	},
 };
 
 static struct id_reg_info id_aa64mmfr0_el1_info = {
-- 
2.33.1.1089.g2158813163f-goog

