Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE7D2F5F64
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbhANK5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 05:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbhANK5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 05:57:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBFF223A53;
        Thu, 14 Jan 2021 10:56:52 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l00J9-007Tvz-7O; Thu, 14 Jan 2021 10:56:51 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 4/6] KVM: arm64: Refactor filtering of ID registers
Date:   Thu, 14 Jan 2021 10:56:31 +0000
Message-Id: <20210114105633.2558739-5-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114105633.2558739-1-maz@kernel.org>
References: <20210114105633.2558739-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our current ID register filtering is starting to be a mess of if()
statements, and isn't going to get any saner.

Let's turn it into a switch(), which has a chance of being more
readable, and introduce a FEATURE() macro that allows easy generation
of feature masks.

No functionnal change intended.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 51 +++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2bea0494b81d..dda16d60197b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -9,6 +9,7 @@
  *          Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/bsearch.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
@@ -1016,6 +1017,8 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
@@ -1024,36 +1027,38 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
 	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
 
-	if (id == SYS_ID_AA64PFR0_EL1) {
+	switch (id) {
+	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
-			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
-		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
-		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
-		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
-		val &= ~(0xfUL << ID_AA64PFR0_CSV3_SHIFT);
-		val |= ((u64)vcpu->kvm->arch.pfr0_csv3 << ID_AA64PFR0_CSV3_SHIFT);
-	} else if (id == SYS_ID_AA64PFR1_EL1) {
-		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
-	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
-		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
-			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
-			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
-			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
-	} else if (id == SYS_ID_AA64DFR0_EL1) {
-		u64 cap = 0;
-
+			val &= ~FEATURE(ID_AA64PFR0_SVE);
+		val &= ~FEATURE(ID_AA64PFR0_AMU);
+		val &= ~FEATURE(ID_AA64PFR0_CSV2);
+		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
+		val &= ~FEATURE(ID_AA64PFR0_CSV3);
+		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
+		break;
+	case SYS_ID_AA64PFR1_EL1:
+		val &= ~FEATURE(ID_AA64PFR1_MTE);
+		break;
+	case SYS_ID_AA64ISAR1_EL1:
+		if (!vcpu_has_ptrauth(vcpu))
+			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
+				 FEATURE(ID_AA64ISAR1_API) |
+				 FEATURE(ID_AA64ISAR1_GPA) |
+				 FEATURE(ID_AA64ISAR1_GPI));
+		break;
+	case SYS_ID_AA64DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.1 */
-		if (kvm_vcpu_has_pmu(vcpu))
-			cap = ID_AA64DFR0_PMUVER_8_1;
-
 		val = cpuid_feature_cap_perfmon_field(val,
-						ID_AA64DFR0_PMUVER_SHIFT,
-						cap);
-	} else if (id == SYS_ID_DFR0_EL1) {
+						      ID_AA64DFR0_PMUVER_SHIFT,
+						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
+		break;
+	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.1 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_DFR0_PERFMON_SHIFT,
 						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
+		break;
 	}
 
 	return val;
-- 
2.29.2

