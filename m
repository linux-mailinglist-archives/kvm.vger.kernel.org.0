Return-Path: <kvm+bounces-63921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AFE2C75AB8
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:29:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id F22462C8AE
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A0D371A00;
	Thu, 20 Nov 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egfIydpb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360CF2E8DE3;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659557; cv=none; b=oZTBcjVgDCWkyfQyhvllzkS1CV5iiCWjo40yuKp5DkjTXiYktl6tWpXMshJmpiJQ+hMXQPNEj3HkLOGSqPH6GYepNF2D/MLaep9WdYE6sxJzFPKbTlrsT8knKaqqOXtJJEbaDkjdP+IdXj2lA/Y/Aln+CU6OCw74TmMXBzC/Er4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659557; c=relaxed/simple;
	bh=Earuil5WtmkVRYjuRYbwq4QLfgEPy3EZ1zKptjMuAoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9aJbmCKA86xdkKXybl86JUA6Yj7FaKfrR7kkwIYrXcki+xsydneoKrqco9eRVCGUFtzGbj/9/YdwE9DAfQ7ZQqpIFJaEFIsPt/vDbO1SiLGMv0EoRilZQDuVT7Yn3Jq+jsi+CrnHK1tAw/44UZg0kB9iCCQ1m9vn9W6T0ZXIfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egfIydpb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FAAC116C6;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659557;
	bh=Earuil5WtmkVRYjuRYbwq4QLfgEPy3EZ1zKptjMuAoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egfIydpbFHqW4n8S9oN56xIqgZLnbejulYZz7CLWsPWcZuQyDvYteCxP/ksm04fz8
	 QDBVf8la+65N3pP3fNInCjDp51SdnKMiQOlZAwS678qbCHL84hDH4PQxHG5DHW0Amr
	 q3ea8QUAM1anfUzzvH/8Z75Z0kV2iho7qxckz0Tw+c1FNNXD1M0xTUbfadyJFOoQz6
	 wgKwSRzyowUwF3LO69kxJ4NfaNislCoxYFtBgGOXPS1JXesbV4lv70vXrowLM1cyuX
	 g062T+0XATxPJi7/75/3rMqKRewI/3ZIHcWnpEFifDTgaan0fpCZxpFIRKWY3udgPY
	 joP6mOrzjUdVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pr-00000006y6g-0wZO;
	Thu, 20 Nov 2025 17:25:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 06/49] KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping
Date: Thu, 20 Nov 2025 17:24:56 +0000
Message-ID: <20251120172540.2267180-7-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

A long time ago, an unsuspecting architect forgot to add a trap
bit for ICV_DIR_EL1 in ICH_HCR_EL2. Which was unfortunate, but
what's a bit of spec between friends? Thankfully, this was fixed
in a later revision, and ARM "deprecates" the lack of trapping
ability.

Unfortuantely, a few (billion) CPUs went out with that defect,
anything ARMv8.0 from ARM, give or take. And on these CPUs,
you can't trap DIR on its own, full stop.

As the next best thing, we can trap everything in the common group,
which is a tad expensive, but hey ho, that's what you get. You can
otherwise recycle the HW in the neaby bin.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/virt.h  |  7 ++++-
 arch/arm64/kernel/cpufeature.c | 52 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/hyp-stub.S   |  5 ++++
 arch/arm64/kvm/vgic/vgic-v3.c  |  3 ++
 arch/arm64/tools/cpucaps       |  1 +
 5 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index aa280f356b96a..8eb63d3294974 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -40,8 +40,13 @@
  */
 #define HVC_FINALISE_EL2	3
 
+/*
+ * HVC_GET_ICH_VTR_EL2 - Retrieve the ICH_VTR_EL2 value
+ */
+#define HVC_GET_ICH_VTR_EL2	4
+
 /* Max number of HYP stub hypercalls */
-#define HVC_STUB_HCALL_NR 4
+#define HVC_STUB_HCALL_NR 5
 
 /* Error returned when an invalid stub number is passed into x0 */
 #define HVC_STUB_ERR	0xbadca11
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5ed401ff79e3e..5de51cb1b8fe2 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2303,6 +2303,49 @@ static bool has_gic_prio_relaxed_sync(const struct arm64_cpu_capabilities *entry
 }
 #endif
 
+static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
+				 int scope)
+{
+	static const struct midr_range has_vgic_v3[] = {
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
+		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
+		{},
+	};
+	struct arm_smccc_res res = {};
+
+	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV3_CPUIF);
+	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV5_LEGACY);
+	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) &&
+	    !is_midr_in_range_list(has_vgic_v3))
+		return false;
+
+	if (!is_hyp_mode_available())
+		return false;
+
+	if (cpus_have_cap(ARM64_HAS_GICV5_LEGACY))
+		return true;
+
+	if (is_kernel_in_hyp_mode())
+		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
+	else
+		arm_smccc_1_1_hvc(HVC_GET_ICH_VTR_EL2, &res);
+
+	if (res.a0 == HVC_STUB_ERR)
+		return false;
+
+	return res.a1 & ICH_VTR_EL2_TDS;
+}
+
 #ifdef CONFIG_ARM64_BTI
 static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 {
@@ -2814,6 +2857,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_gic_prio_relaxed_sync,
 	},
 #endif
+	{
+		/*
+		 * Depends on having GICv3
+		 */
+		.desc = "ICV_DIR_EL1 trapping",
+		.capability = ARM64_HAS_ICH_HCR_EL2_TDIR,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = can_trap_icv_dir_el1,
+	},
 #ifdef CONFIG_ARM64_E0PD
 	{
 		.desc = "E0PD",
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 36e2d26b54f5c..085bc9972f6bb 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -54,6 +54,11 @@ SYM_CODE_START_LOCAL(elx_sync)
 1:	cmp	x0, #HVC_FINALISE_EL2
 	b.eq	__finalise_el2
 
+	cmp	x0, #HVC_GET_ICH_VTR_EL2
+	b.ne	2f
+	mrs_s	x1, SYS_ICH_VTR_EL2
+	b	9f
+
 2:	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	3f
 	mov	x0, x2
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 8c14945086821..1b6c3071ec80f 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -648,6 +648,9 @@ void noinstr kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
 		dir_trap = true;
 	}
 
+	if (!cpus_have_cap(ARM64_HAS_ICH_HCR_EL2_TDIR))
+		common_trap = true;
+
 	if (group0_trap)
 		hcr |= ICH_HCR_EL2_TALL0;
 	if (group1_trap)
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 1b32c1232d28d..116d1a7b688cb 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -40,6 +40,7 @@ HAS_GICV5_CPUIF
 HAS_GICV5_LEGACY
 HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
+HAS_ICH_HCR_EL2_TDIR
 HAS_HCR_NV1
 HAS_HCX
 HAS_LDAPR
-- 
2.47.3


