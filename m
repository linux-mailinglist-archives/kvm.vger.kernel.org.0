Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D6623CDFB
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 20:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgHESAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbgHER6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:58:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36E1722D04;
        Wed,  5 Aug 2020 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596650240;
        bh=7ArqvSK8VUGJgeX1OnhoTSQ+a7BydokvwxYLyhHIlMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7uMxOjz8gkR3xFfhtpD82P2khC6WFYs2XifyJqv9j8pemgssW4y6+fB58SANSeRP
         JQ77MaMaQlXFEK+d4DGnHaObDprDOQn/gb6w67MsmTJ7sTtzuZcgRbP8v8yaA1xICu
         VgM7p/Ls/izszv+/8S5ybw8tmp00XBEVrDma7XzA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfC-0004w9-LP; Wed, 05 Aug 2020 18:57:18 +0100
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
Subject: [PATCH 08/56] KVM: arm64: Drop the target_table[] indirection
Date:   Wed,  5 Aug 2020 18:56:12 +0100
Message-Id: <20200805175700.62775-9-maz@kernel.org>
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

KVM for 32bit arm had a get/set target mechanism to allow for
micro-architecture differences that are visible in system registers
to be described.

KVM's user-space can query the supported targets for a CPU, and
create vCPUs for that target. The target can override the handling
of system registers to provide different reset or RES0 behaviour.
On 32bit arm this was used to provide different ACTLR reset values
for A7 and A15.

On 64bit arm, the first few CPUs out of the gate used this mechanism,
before it was deemed redundant in commit bca556ac468a ("arm64/kvm:
Add generic v8 KVM target"). All future CPUs use the
KVM_ARM_TARGET_GENERIC_V8 target.

The 64bit target_table[] stuff exists to preserve the ABI to
user-space. As all targets registers genericv8_target_table, there
is no reason to look the target up.

Until we can merge genericv8_target_table with the main sys_regs
array, kvm_register_target_sys_reg_table() becomes
kvm_check_target_sys_reg_table(), which uses BUG_ON() in keeping
with the other callers in this file.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200622113317.20477-2-james.morse@arm.com
---
 arch/arm64/include/asm/kvm_coproc.h  |  3 +--
 arch/arm64/kvm/sys_regs.c            | 16 ++++------------
 arch/arm64/kvm/sys_regs.h            |  2 ++
 arch/arm64/kvm/sys_regs_generic_v8.c | 15 ++-------------
 4 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index 0185ee8b8b5e..4bf0d6d05e0f 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -24,8 +24,7 @@ struct kvm_sys_reg_target_table {
 	struct kvm_sys_reg_table table32;
 };
 
-void kvm_register_target_sys_reg_table(unsigned int target,
-				       struct kvm_sys_reg_target_table *table);
+void kvm_check_target_sys_reg_table(struct kvm_sys_reg_target_table *table);
 
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index baf5ce9225ce..6333a7cd92d3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2109,17 +2109,10 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 	return 0;
 }
 
-/* Target specific emulation tables */
-static struct kvm_sys_reg_target_table *target_tables[KVM_ARM_NUM_TARGETS];
-
-void kvm_register_target_sys_reg_table(unsigned int target,
-				       struct kvm_sys_reg_target_table *table)
+void kvm_check_target_sys_reg_table(struct kvm_sys_reg_target_table *table)
 {
-	if (check_sysreg_table(table->table64.table, table->table64.num, false) ||
-	    check_sysreg_table(table->table32.table, table->table32.num, true))
-		return;
-
-	target_tables[target] = table;
+	BUG_ON(check_sysreg_table(table->table64.table, table->table64.num, false));
+	BUG_ON(check_sysreg_table(table->table32.table, table->table32.num, true));
 }
 
 /* Get specific register table for this target. */
@@ -2127,9 +2120,8 @@ static const struct sys_reg_desc *get_target_table(unsigned target,
 						   bool mode_is_64,
 						   size_t *num)
 {
-	struct kvm_sys_reg_target_table *table;
+	struct kvm_sys_reg_target_table *table = &genericv8_target_table;
 
-	table = target_tables[target];
 	if (mode_is_64) {
 		*num = table->table64.num;
 		return table->table64.table;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 5a6fc30f5989..933609e883bf 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -165,4 +165,6 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
+extern struct kvm_sys_reg_target_table genericv8_target_table;
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index aa9d356451eb..a82cc2ccfd44 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -59,7 +59,7 @@ static const struct sys_reg_desc genericv8_cp15_regs[] = {
 	  access_actlr },
 };
 
-static struct kvm_sys_reg_target_table genericv8_target_table = {
+struct kvm_sys_reg_target_table genericv8_target_table = {
 	.table64 = {
 		.table = genericv8_sys_regs,
 		.num = ARRAY_SIZE(genericv8_sys_regs),
@@ -78,18 +78,7 @@ static int __init sys_reg_genericv8_init(void)
 		BUG_ON(cmp_sys_reg(&genericv8_sys_regs[i-1],
 			       &genericv8_sys_regs[i]) >= 0);
 
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_AEM_V8,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_FOUNDATION_V8,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_CORTEX_A53,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_CORTEX_A57,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_XGENE_POTENZA,
-					  &genericv8_target_table);
-	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_GENERIC_V8,
-					  &genericv8_target_table);
+	kvm_check_target_sys_reg_table(&genericv8_target_table);
 
 	return 0;
 }
-- 
2.27.0

