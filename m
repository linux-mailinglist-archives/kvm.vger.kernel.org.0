Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8CE159742
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgBKRx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730671AbgBKRx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:53:29 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C48C320661;
        Tue, 11 Feb 2020 17:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443608;
        bh=ptv/8iU8Wqw8wnzlKzqydigm6fuDVi4E7l30mG2CJdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QStCXeDMI1gz0CtwFQ8/YKjHo89QwI/dOb/y8EMMTyUlWC0FfVYBEpOdSoDR0YPy9
         LTkjoCu7emixnJ94yV8ouGu2olz46Rh5X97a6o2C44JtdElPDqV5ad6mjCBajXHI7f
         e/2k2F9kELFxrS6YkC9ANCaB+SjLtn/eZgXWweZY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zg5-004O7k-VT; Tue, 11 Feb 2020 17:50:30 +0000
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
Subject: [PATCH v2 62/94] arm64: Detect the ARMv8.4 TTL feature
Date:   Tue, 11 Feb 2020 17:49:06 +0000
Message-Id: <20200211174938.27809-63-maz@kernel.org>
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

In order to reduce the cost of TLB invalidation, the ARMv8.4 TTL
feature allows TLBs to be issued with a level allowing for quicker
invalidation.

Let's detect the feature for now. Further patches will implement
its actual usage.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/sysreg.h  |  1 +
 arch/arm64/kernel/cpufeature.c   | 11 +++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 21f0067d8d40..5736650cd0fb 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -59,7 +59,8 @@
 #define ARM64_HAS_E0PD				49
 #define ARM64_HAS_RNG				50
 #define ARM64_HAS_NESTED_VIRT			51
+#define ARM64_HAS_ARMv8_4_TTL			52
 
-#define ARM64_NCAPS				52
+#define ARM64_NCAPS				53
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 92c97a19369e..a402e762c51d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -804,6 +804,7 @@
 #define ID_AA64MMFR2_E0PD_SHIFT		60
 #define ID_AA64MMFR2_EVT_SHIFT		56
 #define ID_AA64MMFR2_BBM_SHIFT		52
+#define ID_AA64MMFR2_TTL_SHIFT		48
 #define ID_AA64MMFR2_FWB_SHIFT		40
 #define ID_AA64MMFR2_AT_SHIFT		32
 #define ID_AA64MMFR2_ST_SHIFT		28
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 157700590aa8..aada8c3eff1e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -249,6 +249,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_E0PD_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_TTL_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_FWB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_AT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_NV_SHIFT, 4, 0),
@@ -1557,6 +1558,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.cpu_enable = cpu_has_fwb,
 	},
+	{
+		.desc = "ARMv8.4 Translation Table Level",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_ARMv8_4_TTL,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_TTL_SHIFT,
+		.min_field_value = 1,
+		.matches = has_cpuid_feature,
+	},
 #ifdef CONFIG_ARM64_HW_AFDBM
 	{
 		/*
-- 
2.20.1

