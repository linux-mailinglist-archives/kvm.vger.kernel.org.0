Return-Path: <kvm+bounces-54123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE0AB1CA23
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 18:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DDF0565663
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 16:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFE629B8C7;
	Wed,  6 Aug 2025 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlOXsmI3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DC9293C4F;
	Wed,  6 Aug 2025 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499390; cv=none; b=MGzGdW7KPRE1vPq2sKRX9JtLOSO18cllctdWHrfTBRopoT7Ft98jC0+dCgNchRVpXslFV6tCaH6/vpZeHt3XcJoLAOS1vyYL+fmS43BTmKc+S7gjP5I5Fl0wLRrb30JMbGEk8YsAeSfzlAnyxj+lNpLuCYnPpPzwwaHq/262Sgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499390; c=relaxed/simple;
	bh=YEmVwPQjLOW9AhsCHd1XFPDOLKbGa7o1Hrl0pImw/FY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t2UDEs8x0j2sag9vqNvBGc0I3ukL8+dQizz35+DoyIwuqq53CwCrOMSiNtq2W5hqCSR69F4ItHGtOTMhjcPg0RzxMM+aZ3aI87trUpGPBRYOo0D2RkWk5ABf/ESuyfPuyjN35PxbKb3TfF0MwITR9Z3ScTu0fWAjOxHTxgsPJyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlOXsmI3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B95C4CEED;
	Wed,  6 Aug 2025 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754499390;
	bh=YEmVwPQjLOW9AhsCHd1XFPDOLKbGa7o1Hrl0pImw/FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlOXsmI3gQrqPekiSxttvvjw400qsbOlcDQL/puVxlrWh3INTzziK4RYPFAKzBkZl
	 kD8gEbZ3KED/S8+bWesqa39uEwQPqyRn+xp8kom42SYObQyjf4paLky9kt7w9e1rzB
	 rYLGoHgf8f4uiGp/BvcijTz+wciS818dDJuaC0zTlwf+HdQp9mwwzWvRbDPwrSPHot
	 525xwXVYLgcqXu6NGTpj5Q7mxOa4soGCrM6lXv6oRshMVm+LrG8XAT0frajVKNS/X0
	 wraZb4Ew4QzgXZTVOf3bWl97dthsDO1s4M9BihTnZHWIK9jB7M6o2Wzgc9qq2jUspG
	 6eTcppy4g3soA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ujhRD-004ZQV-Sh;
	Wed, 06 Aug 2025 17:56:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 1/5] arm64: Add capability denoting FEAT_RASv1p1
Date: Wed,  6 Aug 2025 17:56:11 +0100
Message-Id: <20250806165615.1513164-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806165615.1513164-1-maz@kernel.org>
References: <20250806165615.1513164-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Detecting FEAT_RASv1p1 is rather complicated, as there are two
ways for the architecture to advertise the same thing (always a
delight...).

Add a capability that will advertise this in a synthetic way to
the rest of the kernel.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 24 ++++++++++++++++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 25 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 4dece9ca68bc6..22a94e548362d 100644
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


