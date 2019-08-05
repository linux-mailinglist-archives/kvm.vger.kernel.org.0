Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02470818FA
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 14:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfHEMQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 08:16:20 -0400
Received: from foss.arm.com ([217.140.110.172]:47218 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728599AbfHEMQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 08:16:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D94B21597;
        Mon,  5 Aug 2019 05:16:19 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC6473F77D;
        Mon,  5 Aug 2019 05:16:18 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH 2/2] KVM: arm: Don't write junk to CP15 registers on reset
Date:   Mon,  5 Aug 2019 13:15:55 +0100
Message-Id: <20190805121555.130897-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805121555.130897-1-maz@kernel.org>
References: <20190805121555.130897-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment, the way we reset CP15 registers is mildly insane:
We write junk to them, call the reset functions, and then check that
we have something else in them.

The "fun" thing is that this can happen while the guest is running
(PSCI, for example). If anything in KVM has to evaluate the state
of a CP15 register while junk is in there, bad thing may happen.

Let's stop doing that. Instead, we track that we have called a
reset function for that register, and assume that the reset
function has done something.

In the end, the very need of this reset check is pretty dubious,
as it doesn't check everything (a lot of the CP15 reg leave outside
of the cp15_regs[] array). It may well be axed in the near future.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/kvm/coproc.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index d2806bcff8bb..07745ee022a1 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -651,13 +651,22 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
 }
 
 static void reset_coproc_regs(struct kvm_vcpu *vcpu,
-			      const struct coproc_reg *table, size_t num)
+			      const struct coproc_reg *table, size_t num,
+			      unsigned long *bmap)
 {
 	unsigned long i;
 
 	for (i = 0; i < num; i++)
-		if (table[i].reset)
+		if (table[i].reset) {
+			int reg = table[i].reg;
+
 			table[i].reset(vcpu, &table[i]);
+			if (reg > 0 && reg < NR_CP15_REGS) {
+				set_bit(reg, bmap);
+				if (table[i].is_64bit)
+					set_bit(reg + 1, bmap);
+			}
+		}
 }
 
 static struct coproc_params decode_32bit_hsr(struct kvm_vcpu *vcpu)
@@ -1432,17 +1441,15 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
 {
 	size_t num;
 	const struct coproc_reg *table;
-
-	/* Catch someone adding a register without putting in reset entry. */
-	memset(vcpu->arch.ctxt.cp15, 0x42, sizeof(vcpu->arch.ctxt.cp15));
+	DECLARE_BITMAP(bmap, NR_CP15_REGS) = { 0, };
 
 	/* Generic chip reset first (so target could override). */
-	reset_coproc_regs(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
+	reset_coproc_regs(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs), bmap);
 
 	table = get_target_table(vcpu->arch.target, &num);
-	reset_coproc_regs(vcpu, table, num);
+	reset_coproc_regs(vcpu, table, num, bmap);
 
 	for (num = 1; num < NR_CP15_REGS; num++)
-		WARN(vcpu_cp15(vcpu, num) == 0x42424242,
+		WARN(!test_bit(num, bmap),
 		     "Didn't reset vcpu_cp15(vcpu, %zi)", num);
 }
-- 
2.20.1

