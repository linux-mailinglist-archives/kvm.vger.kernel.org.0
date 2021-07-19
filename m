Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270CF3CE52F
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347450AbhGSPsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350278AbhGSPpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:47 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9866EC0ABCA3
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:15 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id h22-20020a7bc9360000b0290215b0f3da63so2005682wml.3
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GDqskojL7dyXpCREyAWDqO7MHA/WU9T+kxKaEf44dB0=;
        b=rZVHJk2Z0+nWKmBUX0mm3cqH9vYGulzcqpX9aqYyTTQT1WF91Ke37EurEKLmcF2DCL
         keDGWcvL5Eov7/qcjCIs3tIX0eIw8v47J+bkm4uBrX21ondXLKbqPPfETvkh3JmN2HF3
         lVQvFfjfEGWwWt7c6h7aJLYmb3uDiLRE8iD5Lu8vDIP0tbA4RgerBAn2zoxcd7EWdCIv
         EwgRukwaJ1agHHeJR5GyAzTxZG9ktl2QwQ7WvZqtSwsT0XTiFq6A1FQTVpebID91Ae9Z
         sQahfVdSSjsOIgNUF51cL7t1EEcrRajBDHGZl5vxsF1EMfXHD5Sn6PPayoPHy/NhT5zZ
         nEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GDqskojL7dyXpCREyAWDqO7MHA/WU9T+kxKaEf44dB0=;
        b=sHpk2S7DZ3jsfvpvptSzne78eIMHvS60Dey+qzTA2rEpe6QeCt5smGKXYar7tjFgXz
         NbeCkWRXmPcLPl6nlc809aWc7AALeWNIZsAko20Y2dAxFxH6d4cAohSoyiZC1Ap8/AYv
         5XCJtmZcpbaMc6fHHdi+oxib50Uw39kzKhxAJQedz4oqp8ywEvIrbJY5UqPqf4hhGwHP
         27pfX13lOE1XMTi8DGZvB4Q6me+7h6532ib+PkJ6r1U6zjlZyUwdt4QTMgBW5vOqBuWx
         doe8nfEK73yiS7U/Ajd+ef3xHGTIMGuYH3pV0kxQTkNhVV9al1WIr1nU2RgBcasq/TKB
         3kzA==
X-Gm-Message-State: AOAM530E47Y+6VQ32KGD1ZhC//dHewaqSfi1jKs7r+wqpfAM87C8Bwlp
        IpDIWzDyf5uenYStHDC21JfteZjogA==
X-Google-Smtp-Source: ABdhPJwp/L7WERVfHFTFWu/xpgqq2mIayL4vupqwygWgiPvc5ZG2Z0+cqTWmTKkJweVf7nAnOAngrv1AQg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:35c2:: with SMTP id c185mr19332555wma.73.1626710638515;
 Mon, 19 Jul 2021 09:03:58 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:36 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-6-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor sys_regs.h and sys_regs.c to make it easier to reuse
common code. It will be used in nVHE in a later patch.

Note that the refactored code uses __inline_bsearch for find_reg
instead of bsearch to avoid copying the bsearch code for nVHE.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h |  3 +++
 arch/arm64/kvm/sys_regs.c       | 30 +-----------------------------
 arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7b9c3acba684..326f49e7bd42 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1153,6 +1153,9 @@
 #define ICH_VTR_A3V_SHIFT	21
 #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
 
+/* Extract the feature specified from the feature id register. */
+#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
+
 #ifdef __ASSEMBLY__
 
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 80a6e41cadad..1a939c464858 100644
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
2.32.0.402.g57bb445576-goog

