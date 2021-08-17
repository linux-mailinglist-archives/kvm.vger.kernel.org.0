Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20653EE819
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbhHQIMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbhHQIMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:21 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BE7C0613C1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:48 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id 10-20020a05600c024a00b002e6bf2ee820so685568wmj.6
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5N9sL5FNi9qrbBCH60+h/5aGjehNQlmcB8JtRn+LK/Y=;
        b=Y9gCxjQgu8WBnIwLq0UnpoEyfcwWFnZk9EOwZk5QUmzoT9Svlr1th34g/QjJoDB+ab
         zZpl5TBx3FL7mnwXSLgADzhf+2CGRAZKZPKiRZG8VEUibVmKP6KFg43r/Zuk9kLL9/b8
         7HgYGzFNzdIWRuNIiIEYlCrw/dyiXXnwehzp+vdn8LEVLVirVyBVfp6PWmmHWXvpzbIk
         5qhABEIRo/VBXLlpfwYDVise2mty3JtejTP/fFRusuZFO+fWkOh+g0d9z64EQvhG/bOn
         LnGLykAU1b2fZ75hPyAVrZwKB3SovLgzHvEaY0MjwGovwohFLcZHWhiOd53DkJ6y7GaK
         0gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5N9sL5FNi9qrbBCH60+h/5aGjehNQlmcB8JtRn+LK/Y=;
        b=saYTfjUMWO95mxMveKtH27g1X0kTazjSkrNhzL0VXhKLzo8ZHiKqibwN0auw0R+vap
         EVWP9sItPXuNjTTF0RmD+uhF+5lioAFG+CcfxrQJ4yFoZyPpwkL+tl4mKLv2N2ODdI5e
         5b5/vCsIIfXuiRlR8ASfQf9hqIG7BEx8l2efH6tLPiSxk4XJQuMxksccm3xBxGFxBAkf
         ogdR5rqAOJ0hNw4cujR0TqEexeaPmTDg7VG7sPAlubKceAWtiIJubNkbQeJn09P7tT+A
         G4Q3jR0Bb1X96g3QVwH0eEAjnlgi44KirOtOHzoO8gA1/vS/cJau/gXxRDm7kq3c/b+C
         6o2w==
X-Gm-Message-State: AOAM530SBzs52JqsrTpGzsx0RzBJAUwUWbhJrqB0zwTBYhPVVLxnLmH0
        gY8GduLMqeg4RXLbYvseZCquA7vVfQ==
X-Google-Smtp-Source: ABdhPJzt7u4Sk+ACYI0cSDXGAWDWaXIZ7nNJ6bvJ191RPxt+qLvQzW+ZQUSMtv7dbzAVAyk+72BhiULwOQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:5116:: with SMTP id
 o22mr227600wms.0.1629187906624; Tue, 17 Aug 2021 01:11:46 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:24 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-6-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor sys_regs.h and sys_regs.c to make it easier to reuse
common code. It will be used in nVHE in a later patch.

Note that the refactored code uses __inline_bsearch for find_reg
instead of bsearch to avoid copying the bsearch code for nVHE.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h |  5 +++
 arch/arm64/kvm/sys_regs.c       | 60 +++++++++------------------------
 arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++
 3 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7b9c3acba684..53a93a9c5253 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1153,6 +1153,11 @@
 #define ICH_VTR_A3V_SHIFT	21
 #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
 
+#define ARM64_FEATURE_FIELD_BITS	4
+
+/* Create a mask for the feature bits of the specified feature. */
+#define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
+
 #ifdef __ASSEMBLY__
 
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 80a6e41cadad..b6a2f8e890db 100644
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
@@ -1038,40 +1032,40 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
-			val &= ~FEATURE(ID_AA64PFR0_SVE);
-		val &= ~FEATURE(ID_AA64PFR0_AMU);
-		val &= ~FEATURE(ID_AA64PFR0_CSV2);
-		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~FEATURE(ID_AA64PFR0_CSV3);
-		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
 		break;
 	case SYS_ID_AA64PFR1_EL1:
-		val &= ~FEATURE(ID_AA64PFR1_MTE);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 		if (kvm_has_mte(vcpu->kvm)) {
 			u64 pfr, mte;
 
 			pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 			mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
-			val |= FIELD_PREP(FEATURE(ID_AA64PFR1_MTE), mte);
+			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), mte);
 		}
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
-				 FEATURE(ID_AA64ISAR1_API) |
-				 FEATURE(ID_AA64ISAR1_GPA) |
-				 FEATURE(ID_AA64ISAR1_GPI));
+			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |
+				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
 		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
-		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
-		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
 		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_AA64DFR0_PMUVER_SHIFT,
 						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
 		/* Hide SPE from guests */
-		val &= ~FEATURE(ID_AA64DFR0_PMSVER);
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
 		break;
 	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.4 */
@@ -2106,23 +2100,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
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
@@ -2365,13 +2342,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
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
index 9d0621417c2a..cc0cc95a0280 100644
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
+				  .is_write = !((esr) & 1) })
+
 struct sys_reg_desc {
 	/* Sysreg string for debug */
 	const char *name;
@@ -152,6 +166,23 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
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
+	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
+}
+
 const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  struct sys_reg_params *params,
 					  const struct sys_reg_desc table[],
-- 
2.33.0.rc1.237.g0d66db33f3-goog

