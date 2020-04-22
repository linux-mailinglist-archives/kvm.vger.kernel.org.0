Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024601B44BF
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgDVMVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728430AbgDVMVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:21:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C5621582;
        Wed, 22 Apr 2020 12:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587558069;
        bh=7JcK0Rg6TlWwKG97FEPn+5O/0r9729K5HS42mRM3beg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfnHewqVeGeg2SPMVXnGUG0D0dKSfBzSG5AW/Y4S5hXCf5pE15cCOUekQ7Eptu6rM
         Opmp0XTRxz04c3F2SvuuzAhlPhD3K6zv7Dbsp6RnUB/BRyBeEEiSYpujHftFq1I8dw
         69TRA1zhTiHMrsh3D4DcgUzlF8/+NvB1oVDrdEGQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE40-005UI7-4c; Wed, 22 Apr 2020 13:01:12 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 18/26] KVM: arm64: Don't use empty structures as CPU reset state
Date:   Wed, 22 Apr 2020 13:00:42 +0100
Message-Id: <20200422120050.3693593-19-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Keeping empty structure as the vcpu state initializer is slightly
wasteful: we only want to set pstate, and zero everything else.
Just do that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 241db35a7ef4f..895d7d9ad1866 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -37,15 +37,11 @@ static u32 kvm_ipa_limit;
 /*
  * ARMv8 Reset Values
  */
-static const struct kvm_regs default_regs_reset = {
-	.regs.pstate = (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT |
-			PSR_F_BIT | PSR_D_BIT),
-};
+#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
 
-static const struct kvm_regs default_regs_reset32 = {
-	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
-			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
-};
+#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
+				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
 static bool cpu_has_32bit_el1(void)
 {
@@ -261,6 +257,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	const struct kvm_regs *cpu_reset;
 	int ret = -EINVAL;
 	bool loaded;
+	u32 pstate;
 
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
@@ -291,16 +288,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
 			if (!cpu_has_32bit_el1())
 				goto out;
-			cpu_reset = &default_regs_reset32;
+			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
-			cpu_reset = &default_regs_reset;
+			pstate = VCPU_RESET_PSTATE_EL1;
 		}
 
 		break;
 	}
 
 	/* Reset core registers */
-	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
+	memset(vcpu_gp_regs(vcpu), 0, sizeof(*cpu_reset));
+	vcpu_gp_regs(vcpu)->regs.pstate = pstate;
 
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
-- 
2.26.1

