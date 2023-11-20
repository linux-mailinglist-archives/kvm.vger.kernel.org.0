Return-Path: <kvm+bounces-2072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 819147F13F4
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:11:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B32B41C2167B
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0B61B286;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5ne0VSO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C250919473;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F14C433C7;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485851;
	bh=xB6nlOUYcUdNAO8jPEpsFJ7ETGwhjsldpv34oIT8l1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5ne0VSOCvJhmzoPPD17b5SDRuLg2lfLOL672k2ydJCkdRsQj/RhUEzSAaLNTJxmc
	 6eNFz1QevQEhHtwcGBqwDNAPFO4HpH1VHUkriKSI02I0UPv4aIuVitsMCW0V9MxU7T
	 5Yz5UQlV+RkzYfZr3GE70YkY48fgSZhSAXwhd4t+ejMWyP/2wGIacHtD5bIMQd7Ors
	 vfA9pMJSb3W9gvHe9Jht1ROR/1Z26LYUzeA/fhzDMvuRlAH1WYf8xtvv0QqmMvkkhi
	 HwzOeu0vbGG6ZsJIDUxJiEu+Nv8EAHF/0B5gPG9hJqRpEkiWJ9JbB8z37w1wJvmeLK
	 aYBdPt3crdtrw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5437-00EjnU-7d;
	Mon, 20 Nov 2023 13:10:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 01/43] arm64: cpufeatures: Restrict NV support to FEAT_NV2
Date: Mon, 20 Nov 2023 13:09:45 +0000
Message-Id: <20231120131027.854038-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

To anyone who has played with FEAT_NV, it is obvious that the level
of performance is rather low due to the trap amplification that it
imposes on the host hypervisor. FEAT_NV2 solves a number of the
problems that FEAT_NV had.

It also turns out that all the existing hardware that has FEAT_NV
also has FEAT_NV2. Finally, it is now allowed by the architecture
to build FEAT_NV2 *only* (as denoted by ID_AA64MMFR4_EL1.NV_frac),
which effectively seals the fate of FEAT_NV.

Restrict the NV support to NV2, and be done with it. Nobody will
cry over the old crap.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 22 +++++++++++++++-------
 arch/arm64/tools/cpucaps       |  2 ++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7dcda39537f8..95a677cf8c04 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -439,6 +439,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
@@ -2080,12 +2081,8 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
 	if (kvm_get_mode() != KVM_MODE_NV)
 		return false;
 
-	if (!has_cpuid_feature(cap, scope)) {
-		pr_warn("unavailable: %s\n", cap->desc);
-		return false;
-	}
-
-	return true;
+	return (__system_matches_cap(ARM64_HAS_NV2) |
+		__system_matches_cap(ARM64_HAS_NV2_ONLY));
 }
 
 static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
@@ -2391,12 +2388,23 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = runs_at_el2,
 		.cpu_enable = cpu_copy_el2regs,
 	},
+	{
+		.capability = ARM64_HAS_NV2,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, NV, NV2)
+	},
+	{
+		.capability = ARM64_HAS_NV2_ONLY,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY)
+	},
 	{
 		.desc = "Nested Virtualization Support",
 		.capability = ARM64_HAS_NESTED_VIRT,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_nested_virt_support,
-		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, NV, IMP)
 	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index fea24bcd6252..480de648cd03 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -41,6 +41,8 @@ HAS_LSE_ATOMICS
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_NO_HW_PREFETCH
+HAS_NV2
+HAS_NV2_ONLY
 HAS_PAN
 HAS_S1PIE
 HAS_RAS_EXTN
-- 
2.39.2


