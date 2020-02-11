Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819D41596D7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgBKRv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730345AbgBKRv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:58 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6857220661;
        Tue, 11 Feb 2020 17:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443516;
        bh=8yWpTF4iaTUbN9LOY7/rc6Dq7R5pIpQHT5f/RMVwKY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xnf9tvHBy1TruTl5Sm8GlHHWCjQ16Uyak6LpSO+GNv+TgH50Y1d4f2SZ6UHYfGhmU
         6LXT+c6DK7oMB137K/LHYYv/oVcxJw46sLGNCExd6D32Cxt7kQi9GRnoQ/EhfegG9A
         V032SwHm1rDg1IqKgyDWO8AIyDtYm7kqmP7lMVAk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgE-004O7k-TP; Tue, 11 Feb 2020 17:50:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 77/94] KVM: arm64: nv: Move sysreg reset check to boot time
Date:   Tue, 11 Feb 2020 17:49:21 +0000
Message-Id: <20200211174938.27809-78-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our sysreg reset check has become a bit silly, as it only checks whether
a reset callback actually exists for a given sysreg entry, and apply the
method if available. Doing the check at each vcpu reset is pretty dumb,
as the tables never change. It is thus perfectly possible to do the same
checks at boot time.

This also allows us to introduce a sparse sys_regs[] array, something
that will be required with ARMv8.4-NV.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 74 +++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 268829c73313..9d426304bfb3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3166,12 +3166,37 @@ static const struct sys_reg_desc cp15_64_regs[] = {
 	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
 };
 
+static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
+			      bool is_32)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++) {
+		if (!is_32 && table[i].reg && !table[i].reset) {
+			kvm_err("sys_reg table %p entry %d has lacks reset\n",
+				table, i);
+			return 1;
+		}
+
+		if (i && cmp_sys_reg(&table[i-1], &table[i]) >= 0) {
+			kvm_err("sys_reg table %p out of order (%d)\n", table, i - 1);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /* Target specific emulation tables */
 static struct kvm_sys_reg_target_table *target_tables[KVM_ARM_NUM_TARGETS];
 
 void kvm_register_target_sys_reg_table(unsigned int target,
 				       struct kvm_sys_reg_target_table *table)
 {
+	if (check_sysreg_table(table->table64.table, table->table64.num, false) ||
+	    check_sysreg_table(table->table32.table, table->table32.num, true))
+		return;
+
 	target_tables[target] = table;
 }
 
@@ -3483,19 +3508,13 @@ static int emulate_sys_instr(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
 }
 
 static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
-				const struct sys_reg_desc *table, size_t num,
-				unsigned long *bmap)
+				const struct sys_reg_desc *table, size_t num)
 {
 	unsigned long i;
 
 	for (i = 0; i < num; i++)
-		if (table[i].reset) {
-			int reg = table[i].reg;
-
+		if (table[i].reset)
 			table[i].reset(vcpu, &table[i]);
-			if (reg > 0 && reg < NR_SYS_REGS)
-				set_bit(reg, bmap);
-		}
 }
 
 /**
@@ -3958,33 +3977,19 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
-static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n)
-{
-	unsigned int i;
-
-	for (i = 1; i < n; i++) {
-		if (cmp_sys_reg(&table[i-1], &table[i]) >= 0) {
-			kvm_err("sys_reg table %p out of order (%d)\n", table, i - 1);
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
 void kvm_sys_reg_table_init(void)
 {
 	unsigned int i;
 	struct sys_reg_desc clidr;
 
 	/* Make sure tables are unique and in order. */
-	BUG_ON(check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs)));
-	BUG_ON(check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs)));
-	BUG_ON(check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs)));
-	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs)));
-	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs)));
-	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs)));
-	BUG_ON(check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs)));
+	BUG_ON(check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false));
+	BUG_ON(check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true));
+	BUG_ON(check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_regs), true));
+	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true));
+	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true));
+	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false));
+	BUG_ON(check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false));
 
 	/* We abuse the reset function to overwrite the table itself. */
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
@@ -4020,17 +4025,10 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
 	size_t num;
 	const struct sys_reg_desc *table;
-	DECLARE_BITMAP(bmap, NR_SYS_REGS) = { 0, };
 
 	/* Generic chip reset first (so target could override). */
-	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs), bmap);
+	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
 	table = get_target_table(vcpu->arch.target, true, &num);
-	reset_sys_reg_descs(vcpu, table, num, bmap);
-
-	for (num = 1; num < NR_SYS_REGS; num++) {
-		if (WARN(!test_bit(num, bmap),
-			 "Didn't reset __vcpu_sys_reg(%zi)\n", num))
-			break;
-	}
+	reset_sys_reg_descs(vcpu, table, num);
 }
-- 
2.20.1

