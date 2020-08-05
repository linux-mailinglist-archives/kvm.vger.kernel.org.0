Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA523CEFD
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgHETLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729237AbgHESaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:30:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39AB923102;
        Wed,  5 Aug 2020 18:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596652036;
        bh=9cdkyCniOTRlapX3WIYRab1QLrV3f/0FlJtUssjOw/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIX0gRYRP7zU0AFE/FOuLycuL45UZbtj9pkxLA1jgJiRoiPAjuU4C0EFB2inH5cqn
         rVjt2HPb/5PaKe3ZJEn+B8hkLHwM+3H+3VgZHX/0buCHpwW1ulBkwh3TgCdcCvk2/o
         j6GRLn27e1bZyBxs82vRmiD/FZCNkitsPLStyXgI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfG-0004w9-Bm; Wed, 05 Aug 2020 18:57:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 12/56] KVM: arm64: Remove the target table
Date:   Wed,  5 Aug 2020 18:56:16 +0100
Message-Id: <20200805175700.62775-13-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: James Morse <james.morse@arm.com>

Finally, remove the target table. Merge the code that checks the
tables into kvm_reset_sys_regs() as there is now only one table.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200622113317.20477-6-james.morse@arm.com
---
 arch/arm64/include/asm/kvm_coproc.h  |  7 ----
 arch/arm64/kvm/Makefile              |  2 +-
 arch/arm64/kvm/sys_regs.c            | 57 ++++++----------------------
 arch/arm64/kvm/sys_regs.h            |  2 -
 arch/arm64/kvm/sys_regs_generic_v8.c | 55 ---------------------------
 5 files changed, 12 insertions(+), 111 deletions(-)
 delete mode 100644 arch/arm64/kvm/sys_regs_generic_v8.c

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index 4bf0d6d05e0f..147f3a77e6a5 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -19,13 +19,6 @@ struct kvm_sys_reg_table {
 	size_t num;
 };
 
-struct kvm_sys_reg_target_table {
-	struct kvm_sys_reg_table table64;
-	struct kvm_sys_reg_table table32;
-};
-
-void kvm_check_target_sys_reg_table(struct kvm_sys_reg_target_table *table);
-
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 8d3d9513cbfe..48cda50aa225 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 $(KVM)/vfio.o $(KVM)/irqchip.o \
 	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
 	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
-	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
+	 guest.o debug.o reset.o sys_regs.o \
 	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 	 aarch32.o arch_timer.o \
 	 vgic/vgic.o vgic/vgic-init.o \
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 14333005b476..41a4d3d2a312 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2137,28 +2137,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 	return 0;
 }
 
-void kvm_check_target_sys_reg_table(struct kvm_sys_reg_target_table *table)
-{
-	BUG_ON(check_sysreg_table(table->table64.table, table->table64.num, false));
-	BUG_ON(check_sysreg_table(table->table32.table, table->table32.num, true));
-}
-
-/* Get specific register table for this target. */
-static const struct sys_reg_desc *get_target_table(unsigned target,
-						   bool mode_is_64,
-						   size_t *num)
-{
-	struct kvm_sys_reg_target_table *table = &genericv8_target_table;
-
-	if (mode_is_64) {
-		*num = table->table64.num;
-		return table->table64.table;
-	} else {
-		*num = table->table32.num;
-		return table->table32.table;
-	}
-}
-
 static int match_sys_reg(const void *key, const void *elt)
 {
 	const unsigned long pval = (unsigned long)key;
@@ -2393,14 +2371,20 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
-				const struct sys_reg_desc *table, size_t num)
+/**
+ * kvm_reset_sys_regs - sets system registers to reset value
+ * @vcpu: The VCPU pointer
+ *
+ * This function finds the right table above and sets the registers on the
+ * virtual CPU struct to their architecturally defined reset values.
+ */
+void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
 	unsigned long i;
 
-	for (i = 0; i < num; i++)
-		if (table[i].reset)
-			table[i].reset(vcpu, &table[i]);
+	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++)
+		if (sys_reg_descs[i].reset)
+			sys_reg_descs[i].reset(vcpu, &sys_reg_descs[i]);
 }
 
 /**
@@ -2869,22 +2853,3 @@ void kvm_sys_reg_table_init(void)
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
 }
-
-/**
- * kvm_reset_sys_regs - sets system registers to reset value
- * @vcpu: The VCPU pointer
- *
- * This function finds the right table above and sets the registers on the
- * virtual CPU struct to their architecturally defined reset values.
- */
-void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
-{
-	size_t num;
-	const struct sys_reg_desc *table;
-
-	/* Generic chip reset first (so target could override). */
-	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
-
-	table = get_target_table(vcpu->arch.target, true, &num);
-	reset_sys_reg_descs(vcpu, table, num);
-}
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 933609e883bf..5a6fc30f5989 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -165,6 +165,4 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
-extern struct kvm_sys_reg_target_table genericv8_target_table;
-
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
deleted file mode 100644
index a7e21e61beea..000000000000
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ /dev/null
@@ -1,55 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2012,2013 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * Based on arch/arm/kvm/coproc_a15.c:
- * Copyright (C) 2012 - Virtual Open Systems and Columbia University
- * Authors: Rusty Russell <rusty@rustcorp.au>
- *          Christoffer Dall <c.dall@virtualopensystems.com>
- */
-#include <linux/kvm_host.h>
-#include <asm/cputype.h>
-#include <asm/kvm_arm.h>
-#include <asm/kvm_asm.h>
-#include <asm/kvm_emulate.h>
-#include <asm/kvm_coproc.h>
-#include <asm/sysreg.h>
-#include <linux/init.h>
-
-#include "sys_regs.h"
-
-/*
- * Implementation specific sys-reg registers.
- * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
- */
-static const struct sys_reg_desc genericv8_sys_regs[] = {
-};
-
-static const struct sys_reg_desc genericv8_cp15_regs[] = {
-};
-
-struct kvm_sys_reg_target_table genericv8_target_table = {
-	.table64 = {
-		.table = genericv8_sys_regs,
-		.num = ARRAY_SIZE(genericv8_sys_regs),
-	},
-	.table32 = {
-		.table = genericv8_cp15_regs,
-		.num = ARRAY_SIZE(genericv8_cp15_regs),
-	},
-};
-
-static int __init sys_reg_genericv8_init(void)
-{
-	unsigned int i;
-
-	for (i = 1; i < ARRAY_SIZE(genericv8_sys_regs); i++)
-		BUG_ON(cmp_sys_reg(&genericv8_sys_regs[i-1],
-			       &genericv8_sys_regs[i]) >= 0);
-
-	kvm_check_target_sys_reg_table(&genericv8_target_table);
-
-	return 0;
-}
-late_initcall(sys_reg_genericv8_init);
-- 
2.27.0

