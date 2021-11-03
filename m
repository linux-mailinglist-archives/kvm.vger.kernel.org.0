Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62608443D1D
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhKCGab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhKCGaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:30:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C969C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:27:54 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p20-20020a63fe14000000b002cc2a31eaf6so1036545pgh.6
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=u0QM1MgzkdUdWU8ieGswYiMTZQIOeeUedN1E6eFAWdI=;
        b=r+j4V8yijGuSg95fkOuf7DHWbWDyHpFWYTbBIFFcfFjvzCuhLBLXdytqjYmCsld4Fk
         kr5O7mo6mf9wuHUngxXV66j8nhy03Jxi+Vi2OngmWuwVY2XJVT/uLvNgbjpRelhTpZa3
         D0Y44ckyfC9qyzhPoxK3tg83zyBk3ei/pDEFJuAR0QWBH9hn9sf3/clGz7RibFVKN/PQ
         2mfINOTyKZi0j9xUtBhuxJBF3cLqBwNHzUf8CRI4fuWDyVu/8ktj2ABADZGkxkglwTKK
         rc6L2sa2F4GGK/VPzn7GC4GP9MtGJbr94t8/nnhI8zROXYr4VlTbs3yTdqOhS5+I/gQo
         +Idw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=u0QM1MgzkdUdWU8ieGswYiMTZQIOeeUedN1E6eFAWdI=;
        b=vvr8pPgGEPPdbYCPgibafQN4IWjcHVNUV/WYLE3hsyQRbLYcjXosit/LXrMyKBw3yj
         PoR5Hlxk6VlnuLZuBGWHjk18WHUacFQIQDzAPtRaAXiAYEodsn8UW1wQdcx6gW72imoE
         5bOPjiG3W2kIH6/tmqjryv1RFzGbtdbNSP2HOVMQ2lvavKH1r8N9e6KmUTbLHlJprQow
         Rqu3MMLN9Hm8NdURXTHvD5ec/J08wF5irfRQ4a2vOABVbxUC163h9sMfmQbMnJ2twyWj
         xUd38//VeMgYwpd5N5E6eRyPWYWs0cu/ZFou+V8u1J2yWgzs5TcX8uQA97hocB4P7BEz
         440w==
X-Gm-Message-State: AOAM532b7f3WegmsHhjD2yM6UDOi/2ctfYj704t0Vngv21XNszDGo/MZ
        oq1RqksPV135DjbDbLrx/p24V+YylBw=
X-Google-Smtp-Source: ABdhPJym2Kc2LkDY/dBhiRC4pLXDFMk8yWTIRAYpw89oOYo/K9kB1jpbXdjQX8d0tFwgXqr1caSe6epQw7c=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:1190:: with SMTP id
 e16mr12369998pja.209.1635920872599; Tue, 02 Nov 2021 23:27:52 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:24:58 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-7-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 06/28] KVM: arm64: Make ID_AA64PFR1_EL1 writable
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

This patch adds id_reg_info for ID_AA64PFR1_EL1 to make it writable
by userspace.

Return an error if userspace tries to set MTE field of the register
to a value that conflicts with KVM_CAP_ARM_MTE configuration for
the guest.
Skip fractional feature fields validation at present and they will
be handled by the following patches.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kvm/sys_regs.c       | 50 ++++++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 5c4890cdc29b..e8acc3607590 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -793,6 +793,7 @@
 #define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_CSV2FRAC_SHIFT	32
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
 #define ID_AA64PFR1_RASFRAC_SHIFT	12
 #define ID_AA64PFR1_MTE_SHIFT		8
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8d31976414a..00ebf4dfc4f8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -422,6 +422,21 @@ static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+				    const struct id_reg_info *id_reg, u64 val)
+{
+	bool kvm_mte = kvm_has_mte(vcpu->kvm);
+	unsigned int mte;
+
+	mte = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR1_MTE_SHIFT);
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT. */
+	if (kvm_mte ^ (mte > 0))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -446,6 +461,12 @@ static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 	id_reg->vcpu_limit_val = limit;
 }
 
+static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
+{
+	if (!system_supports_mte())
+		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
+}
+
 static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 				     const struct id_reg_info *idr)
 {
@@ -454,6 +475,14 @@ static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR0_SVE)));
 }
 
+static u64 get_reset_id_aa64pfr1_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *idr)
+{
+	return kvm_has_mte(vcpu->kvm) ?
+	       idr->vcpu_limit_val :
+	       (idr->vcpu_limit_val & ~(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE)));
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
@@ -463,6 +492,16 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 	.get_reset_val = get_reset_id_aa64pfr0_el1,
 };
 
+static struct id_reg_info id_aa64pfr1_el1_info = {
+	.sys_reg = SYS_ID_AA64PFR1_EL1,
+	.ftr_check_types = U_FCT(ID_AA64PFR1_RASFRAC_SHIFT, FCT_IGNORE) |
+			   U_FCT(ID_AA64PFR1_MPAMFRAC_SHIFT, FCT_IGNORE) |
+			   U_FCT(ID_AA64PFR1_CSV2FRAC_SHIFT, FCT_IGNORE),
+	.init = init_id_aa64pfr1_el1_info,
+	.validate = validate_id_aa64pfr1_el1,
+	.get_reset_val = get_reset_id_aa64pfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -473,6 +512,7 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
@@ -1307,16 +1347,6 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
 
 	switch (id) {
-	case SYS_ID_AA64PFR1_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		if (kvm_has_mte(vcpu->kvm)) {
-			u64 pfr, mte;
-
-			pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
-			mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), mte);
-		}
-		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-- 
2.33.1.1089.g2158813163f-goog

