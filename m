Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10A0303265
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 04:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbhAYM4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 07:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbhAYMxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 07:53:50 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BF5D22DFB;
        Mon, 25 Jan 2021 12:26:44 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l40x8-009sBu-UM; Mon, 25 Jan 2021 12:26:43 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH v2 3/7] KVM: arm64: Add handling of AArch32 PCMEID{2,3} PMUv3 registers
Date:   Mon, 25 Jan 2021 12:26:34 +0000
Message-Id: <20210125122638.2947058-4-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210125122638.2947058-1-maz@kernel.org>
References: <20210125122638.2947058-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Despite advertising support for AArch32 PMUv3p1, we fail to handle
the PMCEID{2,3} registers, which conveniently alias with the top
bits of PMCEID{0,1}_EL1.

Implement these registers with the usual AA32(HI/LO) aliasing
mechanism.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ce08d28ab15c..2bea0494b81d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -685,14 +685,18 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 pmceid;
+	u64 pmceid, mask, shift;
 
 	BUG_ON(p->is_write);
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
+	get_access_mask(r, &mask, &shift);
+
 	pmceid = kvm_pmu_get_pmceid(vcpu, (p->Op2 & 1));
+	pmceid &= mask;
+	pmceid >>= shift;
 
 	p->regval = pmceid;
 
@@ -1895,8 +1899,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmswinc },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
+	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
+	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
@@ -1904,6 +1908,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
+	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 4), access_pmceid },
+	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 5), access_pmceid },
 
 	/* PRRR/MAIR0 */
 	{ AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },
-- 
2.29.2

