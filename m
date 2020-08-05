Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E764923CF0C
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgHETMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728825AbgHES1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F06822CB3;
        Wed,  5 Aug 2020 18:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651958;
        bh=kQqWB9nR8C721TvBKL/d/pl9SOM/oXtaAvToHBb4mtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFyLINeTa3ODpWskXd3tK9TWPEwk94Gmw53gzZmMkotYkz93ocPZrFqn9lqaNt7Og
         jG26z0sWEvvSmROlZzij4WnmFbkce/8ja33vibXRDmaXD/U9yhClELKhaUnVBfxhiB
         7W2UwlStd1h9++sYXWw+F1fJ6I5N2Rfi4REhaWp8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3NfE-0004w9-Lu; Wed, 05 Aug 2020 18:57:20 +0100
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
Subject: [PATCH 10/56] KVM: arm64: Move ACTLR_EL1 emulation to the sys_reg_descs array
Date:   Wed,  5 Aug 2020 18:56:14 +0100
Message-Id: <20200805175700.62775-11-maz@kernel.org>
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

The only entry in the genericv8_sys_regs arrays is for emulation of
ACTLR_EL1. As all targets emulate this in the same way, move it to
sys_reg_descs[].

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200622113317.20477-4-james.morse@arm.com
---
 arch/arm64/kvm/sys_regs.c            | 28 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs_generic_v8.c | 30 ----------------------------
 2 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fb448bfc83ec..f8407cfa9032 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -242,6 +242,25 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_actlr(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
+
+	if (p->is_aarch32) {
+		if (r->Op2 & 2)
+			p->regval = upper_32_bits(p->regval);
+		else
+			p->regval = lower_32_bits(p->regval);
+	}
+
+	return true;
+}
+
 /*
  * Trap handler for the GICv3 SGI generation system register.
  * Forward the request to the VGIC emulation.
@@ -615,6 +634,12 @@ static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
 }
 
+static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 actlr = read_sysreg(actlr_el1);
+	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
+}
+
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 mpidr;
@@ -1518,6 +1543,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(7,7),
 
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
+	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -1957,6 +1983,8 @@ static const struct sys_reg_desc cp14_64_regs[] = {
 static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 0), Op2( 1), access_ctr },
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 0), access_vm_reg, NULL, c1_SCTLR },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 1), access_actlr },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 3), access_actlr },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR },
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index a82cc2ccfd44..a7e21e61beea 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -19,44 +19,14 @@
 
 #include "sys_regs.h"
 
-static bool access_actlr(struct kvm_vcpu *vcpu,
-			 struct sys_reg_params *p,
-			 const struct sys_reg_desc *r)
-{
-	if (p->is_write)
-		return ignore_write(vcpu, p);
-
-	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
-
-	if (p->is_aarch32) {
-		if (r->Op2 & 2)
-			p->regval = upper_32_bits(p->regval);
-		else
-			p->regval = lower_32_bits(p->regval);
-	}
-
-	return true;
-}
-
-static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-{
-	__vcpu_sys_reg(vcpu, ACTLR_EL1) = read_sysreg(actlr_el1);
-}
-
 /*
  * Implementation specific sys-reg registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
  */
 static const struct sys_reg_desc genericv8_sys_regs[] = {
-	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 };
 
 static const struct sys_reg_desc genericv8_cp15_regs[] = {
-	/* ACTLR */
-	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001),
-	  access_actlr },
-	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b011),
-	  access_actlr },
 };
 
 struct kvm_sys_reg_target_table genericv8_target_table = {
-- 
2.27.0

