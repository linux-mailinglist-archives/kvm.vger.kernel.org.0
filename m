Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AFE159687
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbgBKRuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:50:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:52302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbgBKRt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:49:58 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E08DE2086A;
        Tue, 11 Feb 2020 17:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443398;
        bh=vZYuRZEYB65TB5BcmIONClbvBia5wiG+UbdUv2W2Gl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bidf3TOnosFS8mKox3Y7XNJQiv3wt2HAC43WhRps4CyrGo0e0auz4bpkSPeolSFfV
         rU60Gda2lcRS4mEdynFEKhC8vzdj4S87iE6LeWp3dReN/Z5s+mKxf1nrxXscQ+cJ4t
         CM8G0+YrndZeKSP1bIiQT+7F8nuvdXYV+DAoFEK8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZfY-004O7k-5R; Tue, 11 Feb 2020 17:49:56 +0000
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
Subject: [PATCH v2 04/94] KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
Date:   Tue, 11 Feb 2020 17:48:08 +0000
Message-Id: <20200211174938.27809-5-maz@kernel.org>
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

From: Christoffer Dall <christoffer.dall@arm.com>

Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
feature is enabled on the VCPU.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: rework register reset not to use empty data structures]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 30b7ea680f66..5c50df274239 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -28,6 +28,7 @@
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/virt.h>
 
 /* Maximum phys_shift supported for any VM on this host */
@@ -36,15 +37,14 @@ static u32 kvm_ipa_limit;
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
+#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
+#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
+				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
 static bool cpu_has_32bit_el1(void)
 {
@@ -260,6 +260,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	const struct kvm_regs *cpu_reset;
 	int ret = -EINVAL;
 	bool loaded;
+	u32 pstate;
 
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
@@ -288,18 +289,25 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			if (!cpu_has_32bit_el1())
+			/*
+			 * The CPU must support 32bit EL1, and 32bit
+			 * NV is just not a thing...
+			 */
+			if (!cpu_has_32bit_el1() || nested_virt_in_use(vcpu))
 				goto out;
-			cpu_reset = &default_regs_reset32;
+			pstate = VCPU_RESET_PSTATE_SVC;
+		} else if (nested_virt_in_use(vcpu)) {
+			pstate = VCPU_RESET_PSTATE_EL2;
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
2.20.1

