Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E949F15970A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgBKRwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:52:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbgBKRwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:52:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06173206D7;
        Tue, 11 Feb 2020 17:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443560;
        bh=hU+8ZXqCJKxOobeRNU4DXaABOcyKqWOi8gVrtQCKmB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdhZW7l3r9pBPITz5bqtPd1CMIS/aQIr6rlitozY7j+K2VybQepugwb24fh8UVjmE
         0IKsMPOBpFsJi0tuRE/Li5AFMw54PwX/ED9WfADaS8YXOe/U39Wwb8HizuHHsiZjgY
         c1f1w5mTgRnPnA1rb0405qetcy0+BVl1Ce+jMb80=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zg4-004O7k-2O; Tue, 11 Feb 2020 17:50:28 +0000
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
Subject: [PATCH v2 59/94] arm64: KVM: nv: Handle SCTLR_EL2 RES0/RES1 bits
Date:   Tue, 11 Feb 2020 17:49:03 +0000
Message-Id: <20200211174938.27809-60-maz@kernel.org>
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

Depending on the HCR_EL2.{E2H,TGE} values, SCTLR_EL2 has different
RES0/RES1 constraints.

Let's handle that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c62080d7742c..121b3f28cae2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -443,6 +443,37 @@ static bool access_vbar_el1(struct kvm_vcpu *vcpu,
 	return access_rw(vcpu, p, r);
 }
 
+static bool access_sctlr_el2(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
+	if (p->is_write) {
+		u64 val = p->regval;
+
+		if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) {
+			val &= ~(GENMASK_ULL(63,45) | GENMASK_ULL(34, 32) |
+				 BIT_ULL(17));
+			val |=  SCTLR_EL1_RES1;
+		} else {
+			val &= ~(GENMASK_ULL(63,45) | BIT_ULL(42) |
+				 GENMASK_ULL(39, 38) | GENMASK_ULL(35, 32) |
+				 BIT_ULL(26) | BIT_ULL(24) | BIT_ULL(20) |
+				 BIT_ULL(17) | GENMASK_ULL(15, 14) |
+				 GENMASK(10, 7));
+			val |=  SCTLR_EL2_RES1;
+		}
+
+		vcpu_write_sys_reg(vcpu, val, r->reg);
+	} else {
+		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+	}
+
+	return true;
+}
+
 /*
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
@@ -2254,7 +2285,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_VPIDR_EL2), access_rw, reset_vpidr, VPIDR_EL2 },
 	{ SYS_DESC(SYS_VMPIDR_EL2), access_rw, reset_vmpidr, VMPIDR_EL2 },
 
-	{ SYS_DESC(SYS_SCTLR_EL2), access_rw, reset_val, SCTLR_EL2, 0 },
+	{ SYS_DESC(SYS_SCTLR_EL2), access_sctlr_el2, reset_val, SCTLR_EL2, SCTLR_EL2_RES1 },
 	{ SYS_DESC(SYS_ACTLR_EL2), access_rw, reset_val, ACTLR_EL2, 0 },
 	{ SYS_DESC(SYS_HCR_EL2), access_rw, reset_val, HCR_EL2, 0 },
 	{ SYS_DESC(SYS_MDCR_EL2), access_rw, reset_val, MDCR_EL2, 0 },
-- 
2.20.1

