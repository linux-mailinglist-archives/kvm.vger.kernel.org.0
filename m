Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A75D3794C8
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhEJRBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232102AbhEJRAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:00:51 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07889614A7;
        Mon, 10 May 2021 16:59:45 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg9Fv-000Uqg-AX; Mon, 10 May 2021 17:59:43 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v4 08/66] KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
Date:   Mon, 10 May 2021 17:58:22 +0100
Message-Id: <20210510165920.1913477-9-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

The VMPIDR_EL2 and VPIDR_EL2 are architecturally UNKNOWN at reset, but
let's be nice to a guest hypervisor behaving foolishly and reset these
to something reasonable anyway.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 68266eb139b7..912535c25615 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -622,7 +622,7 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
 }
 
-static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 compute_reset_mpidr(struct kvm_vcpu *vcpu)
 {
 	u64 mpidr;
 
@@ -636,7 +636,24 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
 	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
 	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
+	mpidr |= (1ULL << 31);
+
+	return mpidr;
+}
+
+static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, compute_reset_mpidr(vcpu), MPIDR_EL1);
+}
+
+static void reset_vmpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, compute_reset_mpidr(vcpu), VMPIDR_EL2);
+}
+
+static void reset_vpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, read_cpuid_id(), VPIDR_EL2);
 }
 
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
@@ -1801,8 +1818,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
 	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
 
-	{ SYS_DESC(SYS_VPIDR_EL2), access_rw, reset_val, VPIDR_EL2, 0 },
-	{ SYS_DESC(SYS_VMPIDR_EL2), access_rw, reset_val, VMPIDR_EL2, 0 },
+	{ SYS_DESC(SYS_VPIDR_EL2), access_rw, reset_vpidr, VPIDR_EL2 },
+	{ SYS_DESC(SYS_VMPIDR_EL2), access_rw, reset_vmpidr, VMPIDR_EL2 },
 
 	{ SYS_DESC(SYS_SCTLR_EL2), access_sctlr_el2, reset_val, SCTLR_EL2, SCTLR_EL2_RES1 },
 	{ SYS_DESC(SYS_ACTLR_EL2), access_rw, reset_val, ACTLR_EL2, 0 },
-- 
2.29.2

