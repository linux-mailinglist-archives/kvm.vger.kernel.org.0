Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF61BDCE1
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 13:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390918AbfIYLT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 07:19:57 -0400
Received: from foss.arm.com ([217.140.110.172]:46866 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfIYLT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 07:19:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F08381596;
        Wed, 25 Sep 2019 04:19:56 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7D5D3F694;
        Wed, 25 Sep 2019 04:19:55 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH 1/5] arm64: Add ARM64_WORKAROUND_1319367 for all A57 and A72 versions
Date:   Wed, 25 Sep 2019 12:19:37 +0100
Message-Id: <20190925111941.88103-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925111941.88103-1-maz@kernel.org>
References: <20190925111941.88103-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the EL2 vector hardening that is only selected for A57 and A72
so that the table can also be used for ARM64_WORKAROUND_1319367.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/kernel/cpu_errata.c   | 13 ++++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index f19fe4b9acc4..277e37b2a513 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -52,7 +52,8 @@
 #define ARM64_HAS_IRQ_PRIO_MASKING		42
 #define ARM64_HAS_DCPODP			43
 #define ARM64_WORKAROUND_1463225		44
+#define ARM64_WORKAROUND_1319367		45
 
-#define ARM64_NCAPS				45
+#define ARM64_NCAPS				46
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 1e43ba5c79b7..1640c988d5a1 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -623,9 +623,9 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	return (need_wa > 0);
 }
 
-#ifdef CONFIG_HARDEN_EL2_VECTORS
+#if defined(CONFIG_HARDEN_EL2_VECTORS) || defined(CONFIG_ARM64_ERRATUM_1319367)
 
-static const struct midr_range arm64_harden_el2_vectors[] = {
+static const struct midr_range ca57_a72[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 	{},
@@ -819,7 +819,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "EL2 vector hardening",
 		.capability = ARM64_HARDEN_EL2_VECTORS,
-		ERRATA_MIDR_RANGE_LIST(arm64_harden_el2_vectors),
+		ERRATA_MIDR_RANGE_LIST(ca57_a72),
 	},
 #endif
 	{
@@ -851,6 +851,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_cortex_a76_erratum_1463225,
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1319367
+	{
+		.desc = "ARM erratum 1319367",
+		.capability = ARM64_WORKAROUND_1319367,
+		ERRATA_MIDR_RANGE_LIST(ca57_a72),
+	},
 #endif
 	{
 	}
-- 
2.20.1

