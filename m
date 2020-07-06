Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5262157B6
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgGFMyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 08:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbgGFMyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 08:54:54 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1119A20773;
        Mon,  6 Jul 2020 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594040094;
        bh=Agv7bQ4gapFdTRXC+6sPrSQZbIhD2trEiuy8eAXjAlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cf4YFDQo4ZpG5I52iTzsfckaNfgslsDQBU8+2s2GJwJAg/4a2bSgXiM2/bRSxUHWD
         jNEAELSl8BZBwI/U+sKGX63BSWbYUHHdv9AaWIBs1b7AFtPgxiYijHex4ZpaAqDe0n
         S5iF85Y7sI2VfKzk2Z5PvLNJATsf0y7eKUgGWBw8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsQe4-009SCo-Hj; Mon, 06 Jul 2020 13:54:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 02/17] arm64: Detect the ARMv8.4 TTL feature
Date:   Mon,  6 Jul 2020 13:54:10 +0100
Message-Id: <20200706125425.1671020-3-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706125425.1671020-1-maz@kernel.org>
References: <20200706125425.1671020-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, ascull@google.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
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

Reviewed-by : Suzuki K Polose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/sysreg.h  |  1 +
 arch/arm64/kernel/cpufeature.c   | 11 +++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index d7b3bb0cb180..d44ba903d11d 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -62,7 +62,8 @@
 #define ARM64_HAS_GENERIC_AUTH			52
 #define ARM64_HAS_32BIT_EL1			53
 #define ARM64_BTI				54
+#define ARM64_HAS_ARMv8_4_TTL			55
 
-#define ARM64_NCAPS				55
+#define ARM64_NCAPS				56
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 463175f80341..8c209aa17273 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -746,6 +746,7 @@
 
 /* id_aa64mmfr2 */
 #define ID_AA64MMFR2_E0PD_SHIFT		60
+#define ID_AA64MMFR2_TTL_SHIFT		48
 #define ID_AA64MMFR2_FWB_SHIFT		40
 #define ID_AA64MMFR2_AT_SHIFT		32
 #define ID_AA64MMFR2_LVA_SHIFT		16
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9f63053a63a9..e877f56ff1ab 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -323,6 +323,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_E0PD_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_TTL_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_FWB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_AT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LVA_SHIFT, 4, 0),
@@ -1882,6 +1883,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
2.27.0

