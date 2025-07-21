Return-Path: <kvm+bounces-52959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5AECB0C125
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D12F418C09E0
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 10:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CF528DF4B;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEOJeD/Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C40286D77;
	Mon, 21 Jul 2025 10:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753093207; cv=none; b=glu+SZDH6KSfV2NgsnO7/TWljUXVsJ2V36xQGNJGh/57zQRyTCFNeBdQEKP85FwyMuBWzw9sJ/h+9TzhAsSCyIhs8zEkVp/2kD4seTTDmVMiLO7ng2Zqw+bBRLBLIBotbHzQGWvSSBjInqwsypA/KBI0aW0rBXHPoL6JD2MhLjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753093207; c=relaxed/simple;
	bh=+398xTfyPjG6r7g/gjMZKa7+vZ8AGhHVgFuqAGzWumw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B2UGIefSHU9VNS+yHvrXHpKKU3t40I+cj3LD409dyRSUnDxgO1AvRW434WMS+eKCNoKZEOO1gnFvLZQ3WplPG1/Fh/OplTAKeCw3mn3K+4m/PI0o3ZuLVDxu8G57gGNgvbKxVYMd89T8o6NkvDR2iaoXavfrl6cCj7nBqDHCOwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEOJeD/Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812B0C4CEF1;
	Mon, 21 Jul 2025 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753093207;
	bh=+398xTfyPjG6r7g/gjMZKa7+vZ8AGhHVgFuqAGzWumw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEOJeD/Z6p+mVFRTLhivCVVNclshHZDejVkOPJiUrqRSTopxjFZQQXK9bcKWbkFjw
	 EeaNr23QfwjkmdFdz+spyjEn9gpiD5pJxk58sLzAmKruTydIk3zSPvhK1ejocP1qAi
	 Xzd/qEjm5Rjp0kM8lwEeZZCS4/I3jbFyRt9TP6BJ9WOuZV7mfFVS4YWE20AMnixgpY
	 vXAiiaSn18qonsF0sQ7Sl8CHFtuh3G7mWBjud/QhSADDkf1zDcnzt4r4f7PPSQZa9j
	 xhAfn5YsgDGHFsR+CIK85+Xv7vdvxJ00ZWhd60p6N1FG2UY4g8GJOwYpC5/XyZwFsJ
	 RR8ofAdBOxKvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udncr-00HZDF-KA;
	Mon, 21 Jul 2025 11:20:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 1/7] arm64: Add capability denoting FEAT_RASv1p1
Date: Mon, 21 Jul 2025 11:19:49 +0100
Message-Id: <20250721101955.535159-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250721101955.535159-1-maz@kernel.org>
References: <20250721101955.535159-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Detecting FEAT_RASv1p1 is rather complicated, as there are two
ways for the architecture to advertise the same thing (always a
delight...).

Add a capability that will advertise this in a synthetic way to
the rest of the kernel.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 24 ++++++++++++++++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 25 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a40b94f8e14e1..2da246b593ff7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2235,6 +2235,24 @@ static void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused)
 	/* Firmware may have left a deferred SError in this register. */
 	write_sysreg_s(0, SYS_DISR_EL1);
 }
+static bool has_rasv1p1(const struct arm64_cpu_capabilities *__unused, int scope)
+{
+	const struct arm64_cpu_capabilities rasv1p1_caps[] = {
+		{
+			ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, RAS, V1P1)
+		},
+		{
+			ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, RAS, IMP)
+		},
+		{
+			ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, RAS_frac, RASv1p1)
+		},
+	};
+
+	return (has_cpuid_feature(&rasv1p1_caps[0], scope) ||
+		(has_cpuid_feature(&rasv1p1_caps[1], scope) &&
+		 has_cpuid_feature(&rasv1p1_caps[2], scope)));
+}
 #endif /* CONFIG_ARM64_RAS_EXTN */
 
 #ifdef CONFIG_ARM64_PTR_AUTH
@@ -2653,6 +2671,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_clear_disr,
 		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, RAS, IMP)
 	},
+	{
+		.desc = "RASv1p1 Extension Support",
+		.capability = ARM64_HAS_RASV1P1_EXTN,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_rasv1p1,
+	},
 #endif /* CONFIG_ARM64_RAS_EXTN */
 #ifdef CONFIG_ARM64_AMU_EXTN
 	{
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 115161dd9a24d..eb7f1f5622a8f 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -52,6 +52,7 @@ HAS_S1PIE
 HAS_S1POE
 HAS_SCTLR2
 HAS_RAS_EXTN
+HAS_RASV1P1_EXTN
 HAS_RNG
 HAS_SB
 HAS_STAGE2_FWB
-- 
2.39.2


