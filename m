Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBF93795F5
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhEJRcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233216AbhEJRaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:30:14 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C391B61481;
        Mon, 10 May 2021 17:29:09 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg9Go-000Uqg-Pj; Mon, 10 May 2021 18:00:38 +0100
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
Subject: [PATCH v4 60/66] KVM: arm64: Add ARMv8.4 Enhanced Nested Virt cpufeature
Date:   Mon, 10 May 2021 17:59:14 +0100
Message-Id: <20210510165920.1913477-61-maz@kernel.org>
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

Add the detection code for the ARMv8.4-NV feature.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpucaps.h    |  1 +
 arch/arm64/include/asm/kvm_nested.h |  6 ++++++
 arch/arm64/kernel/cpufeature.c      | 10 ++++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8d0cf022010f..45ff5c6aba15 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -17,6 +17,7 @@
 #define ARM64_WORKAROUND_834220			7
 #define ARM64_HAS_NO_HW_PREFETCH		8
 #define ARM64_HAS_NESTED_VIRT			9
+#define ARM64_HAS_ENHANCED_NESTED_VIRT		10
 #define ARM64_HAS_VIRT_HOST_EXTN		11
 #define ARM64_WORKAROUND_CAVIUM_27456		12
 #define ARM64_HAS_32BIT_EL0			13
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 36f2cd2c6fdf..c3c57eaa493a 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -14,6 +14,12 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
 }
 
+static inline bool enhanced_nested_virt_in_use(const struct kvm_vcpu *vcpu)
+{
+	return cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
+		nested_virt_in_use(vcpu);
+}
+
 /* Translation helpers from non-VHE EL2 to EL1 */
 static inline u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 056de86d7f6f..d26f1ff38aac 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1890,6 +1890,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64MMFR2_NV_SHIFT,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Nested Virtualization Support",
+		.capability = ARM64_HAS_ENHANCED_NESTED_VIRT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_nested_virt_support,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_NV_SHIFT,
+		.min_field_value = 2,
+	},
 	{
 		.desc = "32-bit EL0 Support",
 		.capability = ARM64_HAS_32BIT_EL0,
-- 
2.29.2

