Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A36439F8AA
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhFHOOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:46 -0400
Received: from mail-wm1-f73.google.com ([209.85.128.73]:63402 "EHLO
        mail-wm1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhFHOOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:45 -0400
Received: by mail-wm1-f73.google.com with SMTP id u17-20020a05600c19d1b02901af4c4deac5so798038wmq.7
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mYJp8oqaFP1tw/e1e8xhgZdQDpTaxWSTQf7vhWvZlRk=;
        b=JII0PeJUu8PAh/PyVJBslJQKxdeEv1a+WOZi7UZ9spEQuZXhNbhGb+3po/ZODzF8hD
         CYK1B4e7mV4xS9O6WCFE3id/YbscMVHVHJ6pWgUB3XBEEqFGuX2o4j2uzgNEUHCLtVFs
         wQaSLZNq+DjZOChuv01kIqzkU1cDmtw7v6UXtlC11vpaJi8sRjFJao1K7jPFHf2qo1TN
         mLeeV/4tmW9eJjF9zWy8lUT+JzTnZq3ObKDfeaMg4zruL25ViM3/qAZYy5Yi3B3WGarU
         sgZ66C4nfr2AvIBmSO6zueSe0eeub9mCt34RD9Ysh3lCHwJK1K8unhMi9z/Y7hx9HNQA
         u6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mYJp8oqaFP1tw/e1e8xhgZdQDpTaxWSTQf7vhWvZlRk=;
        b=hPeIBTAelzHoklf7AXCLmPHz7tLool1PTeITuktYrXQ1+lpRUzLjZq4TgMcoWH/ynM
         wrbS06rE2VxWPfypQqd7CHrcVz+0VUiVpuDMG2oKemOYDIlyG4ys5+hAqPITlem4cI5d
         DvJvaQp5we6C/fZ6BW/N6t0jfVkB/aPKR6quEbY6uwBV4tN6fAygGrrrGxJqVEAeCPpl
         94r8/ySrVjIcRNFf4jZcD7N1WqLUxwMCZOtRBMcsqUG5BEg1VJOhqG8K9fmX19aK2tQ9
         1dZCoWMtjD9dXjt8gnuREF0YcnVe+kiMZtl84QaBbL1cBwOU+miMFMLhT31MeRI0Vita
         hEeA==
X-Gm-Message-State: AOAM530wvyfvMB6Iw2peB+Mdjxvr0TpytEfESf1T1SWYIOLTE/E+rzka
        CPlsvEAh1N4LpxgH8Sw8XnOfH935KQ==
X-Google-Smtp-Source: ABdhPJwlYYs9UJlk3Gi3h7/UJjzlQekZLO0A26eAJYu75ALrpkkTVW0FUgQSFVBzES8tKL3Ir9H9jvyzog==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:6042:: with SMTP id u63mr21861385wmb.112.1623161511477;
 Tue, 08 Jun 2021 07:11:51 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:32 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-5-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 04/13] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor sys_regs.h and sys_regs.c to make it easier to reuse
common code. It will be used in nVHE in a later patch.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 58 ++++++++++-----------------------------
 arch/arm64/kvm/sys_regs.h | 35 +++++++++++++++++++++++
 2 files changed, 50 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 15c247fc9f0c..73d09bbd173c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,10 +44,6 @@
  * 64bit interface.
  */
 
-#define reg_to_encoding(x)						\
-	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
-		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
-
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
 				 struct sys_reg_params *params,
 				 const struct sys_reg_desc *r)
@@ -1026,8 +1022,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
-
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
@@ -1038,33 +1032,33 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
-			val &= ~FEATURE(ID_AA64PFR0_SVE);
-		val &= ~FEATURE(ID_AA64PFR0_AMU);
-		val &= ~FEATURE(ID_AA64PFR0_CSV2);
-		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~FEATURE(ID_AA64PFR0_CSV3);
-		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
+			val &= ~SYS_FEATURE(ID_AA64PFR0_SVE);
+		val &= ~SYS_FEATURE(ID_AA64PFR0_AMU);
+		val &= ~SYS_FEATURE(ID_AA64PFR0_CSV2);
+		val |= FIELD_PREP(SYS_FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
+		val &= ~SYS_FEATURE(ID_AA64PFR0_CSV3);
+		val |= FIELD_PREP(SYS_FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
 		break;
 	case SYS_ID_AA64PFR1_EL1:
-		val &= ~FEATURE(ID_AA64PFR1_MTE);
+		val &= ~SYS_FEATURE(ID_AA64PFR1_MTE);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
-				 FEATURE(ID_AA64ISAR1_API) |
-				 FEATURE(ID_AA64ISAR1_GPA) |
-				 FEATURE(ID_AA64ISAR1_GPI));
+			val &= ~(SYS_FEATURE(ID_AA64ISAR1_APA) |
+				 SYS_FEATURE(ID_AA64ISAR1_API) |
+				 SYS_FEATURE(ID_AA64ISAR1_GPA) |
+				 SYS_FEATURE(ID_AA64ISAR1_GPI));
 		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
-		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
-		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
+		val &= ~SYS_FEATURE(ID_AA64DFR0_DEBUGVER);
+		val |= FIELD_PREP(SYS_FEATURE(ID_AA64DFR0_DEBUGVER), 6);
 		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_AA64DFR0_PMUVER_SHIFT,
 						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
 		/* Hide SPE from guests */
-		val &= ~FEATURE(ID_AA64DFR0_PMSVER);
+		val &= ~SYS_FEATURE(ID_AA64DFR0_PMSVER);
 		break;
 	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.4 */
@@ -2082,23 +2076,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 	return 0;
 }
 
-static int match_sys_reg(const void *key, const void *elt)
-{
-	const unsigned long pval = (unsigned long)key;
-	const struct sys_reg_desc *r = elt;
-
-	return pval - reg_to_encoding(r);
-}
-
-static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
-					 const struct sys_reg_desc table[],
-					 unsigned int num)
-{
-	unsigned long pval = reg_to_encoding(params);
-
-	return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
-}
-
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 {
 	kvm_inject_undefined(vcpu);
@@ -2341,13 +2318,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
 	trace_kvm_handle_sys_reg(esr);
 
-	params.Op0 = (esr >> 20) & 3;
-	params.Op1 = (esr >> 14) & 0x7;
-	params.CRn = (esr >> 10) & 0xf;
-	params.CRm = (esr >> 1) & 0xf;
-	params.Op2 = (esr >> 17) & 0x7;
+	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
-	params.is_write = !(esr & 1);
 
 	ret = emulate_sys_reg(vcpu, &params);
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 9d0621417c2a..f7cde4436f32 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -11,6 +11,12 @@
 #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
 #define __ARM64_KVM_SYS_REGS_LOCAL_H__
 
+#include <linux/bsearch.h>
+
+#define reg_to_encoding(x)						\
+	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
+		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
+
 struct sys_reg_params {
 	u8	Op0;
 	u8	Op1;
@@ -21,6 +27,14 @@ struct sys_reg_params {
 	bool	is_write;
 };
 
+#define esr_sys64_to_params(esr)                                               \
+	((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
+				  .Op1 = ((esr) >> 14) & 0x7,                  \
+				  .CRn = ((esr) >> 10) & 0xf,                  \
+				  .CRm = ((esr) >> 1) & 0xf,                   \
+				  .Op2 = ((esr) >> 17) & 0x7,                  \
+				  .is_write = !((esr)&1) })
+
 struct sys_reg_desc {
 	/* Sysreg string for debug */
 	const char *name;
@@ -152,6 +166,24 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 	return i1->Op2 - i2->Op2;
 }
 
+static inline int match_sys_reg(const void *key, const void *elt)
+{
+	const unsigned long pval = (unsigned long)key;
+	const struct sys_reg_desc *r = elt;
+
+	return pval - reg_to_encoding(r);
+}
+
+static inline const struct sys_reg_desc *
+find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
+	 unsigned int num)
+{
+	unsigned long pval = reg_to_encoding(params);
+
+	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]),
+				match_sys_reg);
+}
+
 const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  struct sys_reg_params *params,
 					  const struct sys_reg_desc table[],
@@ -170,4 +202,7 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
+/* Extract the feature specified from the feature id register. */
+#define SYS_FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.32.0.rc1.229.g3e70b5a671-goog

