Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8952149F913
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348398AbiA1MT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:19:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35920 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348384AbiA1MT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:19:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70DCF61B00
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA883C340E8;
        Fri, 28 Jan 2022 12:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372366;
        bh=mRq0cEGJpnpcmnI/+GMvmjaZ1sMuij1MML5SQ8awfC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsRi0AQ8dEdJI82Kn6FJ08gUSUvJMYJFJLkqdmLbfLCBdBLCNZB9w+FOwOgCddEXr
         ypeCG8Q7wZ828wHzOBvR/tns56Eg+NNTOHz0hdA5GiId00a91LagCb0Oe2K26fdBrg
         +XZ8x0wdcJwCkvhlQ3vnfDejZnjbqjYcr0xDZMYRAloVnEHhJ0BtrFeAaXRr78Lg7N
         4jTDFX3NSDzTlul37MKk9Fp21zwVwADlrbKHZur1ioG7VaVGkF/Q8gfApkSrLiaw15
         jmWoIBbdSrRH9nr91DcfWfY8hjjMGmlFaFiKDKqX8vqju0kcNZXuCLNYPNwYiIxDZe
         yZHxhi2nsyx3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDs-003njR-So; Fri, 28 Jan 2022 12:19:25 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 03/64] KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
Date:   Fri, 28 Jan 2022 12:18:11 +0000
Message-Id: <20220128121912.509006-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
feature is enabled on the VCPU.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: rework register reset not to use empty data structures]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ecc40c8cd6f6..d19a9aad2d85 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -27,6 +27,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/virt.h>
 
 /* Maximum phys_shift supported for any VM on this host */
@@ -38,6 +39,9 @@ static u32 kvm_ipa_limit;
 #define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
 				 PSR_F_BIT | PSR_D_BIT)
 
+#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
@@ -188,12 +192,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 	unsigned long i;
 
 	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
-	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
-		return false;
+	if (is32bit) {
+		/* The HW must obviously support AArch32 at EL1 */
+		if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
+			return false;
 
-	/* MTE is incompatible with AArch32 */
-	if (kvm_has_mte(vcpu->kvm) && is32bit)
-		return false;
+		/* MTE is incompatible with AArch32 */
+		if (kvm_has_mte(vcpu->kvm))
+			return false;
+
+		/* NV is incompatible with AArch32 */
+		if (vcpu_has_nv(vcpu))
+			return false;
+	}
 
 	/* Check that the vcpus are either all 32bit or all 64bit */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
@@ -265,10 +276,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
+	if (vcpu_has_nv(vcpu) &&
+	    vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
 			pstate = VCPU_RESET_PSTATE_SVC;
+		} else if (vcpu_has_nv(vcpu)) {
+			pstate = VCPU_RESET_PSTATE_EL2;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
 		}
-- 
2.30.2

