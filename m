Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659DA3CD4EA
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhGSL7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 07:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236968AbhGSL7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 07:59:01 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682DD61164;
        Mon, 19 Jul 2021 12:39:41 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m5SYd-00ED65-RO; Mon, 19 Jul 2021 13:39:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-team@android.com
Subject: [PATCH v2 4/4] KVM: arm64: Remove PMSWINC_EL0 shadow register
Date:   Mon, 19 Jul 2021 13:39:02 +0100
Message-Id: <20210719123902.1493805-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719123902.1493805-1-maz@kernel.org>
References: <20210719123902.1493805-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, drjones@redhat.com, linux@arm.linux.org.uk, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We keep an entry for the PMSWINC_EL0 register in the vcpu structure,
while *never* writing anything there outside of reset.

Given that the register is defined as write-only, that we always
trap when this register is accessed, there is little point in saving
anything anyway.

Get rid of the entry, and save a mighty 8 bytes per vcpu structure.

We still need to keep it exposed to userspace in order to preserve
backward compatibility with previously saved VMs. Since userspace
cannot expect any effect of writing to PMSWINC_EL0, treat the
register as RAZ/WI for the purpose of userspace access.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/sys_regs.c         | 21 ++++++++++++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..afc169630884 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -185,7 +185,6 @@ enum vcpu_sysreg {
 	PMCNTENSET_EL0,	/* Count Enable Set Register */
 	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
 	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
-	PMSWINC_EL0,	/* Software Increment Register */
 	PMUSERENR_EL0,	/* User Enable Register */
 
 	/* Pointer Authentication Registers in a strict increasing order. */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f22139658e48..a1f5101f49a3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1286,6 +1286,20 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return __set_id_reg(vcpu, rd, uaddr, true);
 }
 
+static int set_wi_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		      const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	int err;
+	u64 val;
+
+	/* Perform the access even if we are going to ignore the value */
+	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
 {
@@ -1629,8 +1643,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(SYS_PMOVSCLR_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
+	/*
+	 * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
+	 * previously (and pointlessly) advertised in the past...
+	 */
 	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
-	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
+	  .get_user = get_raz_id_reg, .set_user = set_wi_reg,
+	  .access = access_pmswinc, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMSELR_EL0),
 	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
 	{ PMU_SYS_REG(SYS_PMCEID0_EL0),
-- 
2.30.2

