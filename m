Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B17A7159683
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgBKRt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728965AbgBKRt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:49:58 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB26206D6;
        Tue, 11 Feb 2020 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443396;
        bh=v75bdtDTtT7CfBGhCaWYCJiae6UIVY+xjVSdDNEavQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgZzRu0c36DUP47L4nJvqtGczn12oTEMkp9acNacaMpu7m5Ey/sdCLRRSBRpFwxoN
         Hjq9g40sSaKnQo8alQzAZSSLCOJKF8u05mzICDMsiNKSxwGnL8d1XXKhGK2i4S6dk9
         7ozN9ngGelnWdiJjVQKC1K0NlQ5erqz1jfhrOips=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZfX-004O7k-09; Tue, 11 Feb 2020 17:49:55 +0000
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
Subject: [PATCH v2 02/94] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
Date:   Tue, 11 Feb 2020 17:48:06 +0000
Message-Id: <20200211174938.27809-3-maz@kernel.org>
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

From: Jintack Lim <jintack.lim@linaro.org>

Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
CPU has the ARMv8.3 nested virtualization capability.

This will be used to support nested virtualization in KVM.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  4 +++
 arch/arm64/include/asm/cpucaps.h              |  3 ++-
 arch/arm64/include/asm/sysreg.h               |  1 +
 arch/arm64/kernel/cpufeature.c                | 26 +++++++++++++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index dbc22d684627..cb61ace641f1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2151,6 +2151,10 @@
 			[KVM,ARM] Allow use of GICv4 for direct injection of
 			LPIs.
 
+	kvm-arm.nested=
+			[KVM,ARM] Allow nested virtualization in KVM/ARM.
+			Default is 0 (disabled)
+
 	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
 			(virtualized MMU) support on capable Intel chips.
 			Default is 1 (enabled)
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 865e0253fc1e..21f0067d8d40 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -58,7 +58,8 @@
 #define ARM64_WORKAROUND_SPECULATIVE_AT_NVHE	48
 #define ARM64_HAS_E0PD				49
 #define ARM64_HAS_RNG				50
+#define ARM64_HAS_NESTED_VIRT			51
 
-#define ARM64_NCAPS				51
+#define ARM64_NCAPS				52
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b91570ff9db1..00b283d6d31a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -687,6 +687,7 @@
 #define ID_AA64MMFR2_E0PD_SHIFT		60
 #define ID_AA64MMFR2_FWB_SHIFT		40
 #define ID_AA64MMFR2_AT_SHIFT		32
+#define ID_AA64MMFR2_NV_SHIFT		24
 #define ID_AA64MMFR2_LVA_SHIFT		16
 #define ID_AA64MMFR2_IESB_SHIFT		12
 #define ID_AA64MMFR2_LSM_SHIFT		8
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0b6715625cf6..f0e58450eb16 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -243,6 +243,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_E0PD_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_FWB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_AT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_NV_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LVA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_IESB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LSM_SHIFT, 4, 0),
@@ -1241,6 +1242,21 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 	if (!alternative_is_applied(ARM64_HAS_VIRT_HOST_EXTN))
 		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
 }
+
+static bool nested_param;
+static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
+				    int scope)
+{
+	return has_cpuid_feature(cap, scope) &&
+		nested_param;
+}
+
+static int __init kvmarm_nested_cfg(char *buf)
+{
+	return strtobool(buf, &nested_param);
+}
+
+early_param("kvm-arm.nested", kvmarm_nested_cfg);
 #endif
 
 static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
@@ -1419,6 +1435,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = runs_at_el2,
 		.cpu_enable = cpu_copy_el2regs,
 	},
+	{
+		.desc = "Nested Virtualization Support",
+		.capability = ARM64_HAS_NESTED_VIRT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_nested_virt_support,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_NV_SHIFT,
+		.min_field_value = 1,
+	},
 #endif	/* CONFIG_ARM64_VHE */
 	{
 		.desc = "32-bit EL0 Support",
-- 
2.20.1

