Return-Path: <kvm+bounces-64514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DEEC85DAC
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0BD5F4E7CB3
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C7BE1EA7CE;
	Tue, 25 Nov 2025 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIDaOA/V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F96168BD;
	Tue, 25 Nov 2025 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764086545; cv=none; b=cLgOyAAZ1AFU1dxFNp+fSA2hGkaeg6l8y6Lq5KPNLCeeOgGVAnJ/nIUiRidhNjqQZNqwYGVRY7HBsWrp5ZBcui/Fmd6Z0QRSiVNCRMPvpwO57kE7E7VzeSTo5EDzUYJcpHfUfZb+OsmLCGsgyjf7W3Q7An6ODItsI4FgUMTzL7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764086545; c=relaxed/simple;
	bh=5uKOvlafiq2x+XURvl8Zo9WIMRkudbGHaY/ohACMNKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qg1Rw3vmJC5AFZk0PzY5WYUQvnzIZNjZ0IxCmYe/tEe0bx5ofUaO58rvv0LTuWbI2klAsmusuExZIfFZTWAg6kMWiMXRITuWKl8k4qGO4QhPfgZWtibFTtZzkznQXxiXkSIcLcVKPAq1Pe3u3pXIdB7PPHlPriaYYkU3hYTtakw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIDaOA/V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96AEC116C6;
	Tue, 25 Nov 2025 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764086544;
	bh=5uKOvlafiq2x+XURvl8Zo9WIMRkudbGHaY/ohACMNKs=;
	h=From:To:Cc:Subject:Date:From;
	b=WIDaOA/VDK7fWVSiPxyn/lU3XEpuw6/AQXwVWlcLjAJroxd3JNn4nAakhxp824DpK
	 gc2hbsD0aVLiAHD0w06sPFUy/D5L8Q/LSTSTxFvpFWMgTgaSiAHaL2OD4hpzj8tJJt
	 2q4ykPBpM03ZJOoa8vGj9QypwZPtQGaEkPZjrwwlrfZ+LsiNO28qpNQpONlWjQpYgD
	 2IeC/iZDzFraAOWfVwWuDAwD5/rMXuIVC9x6dLspe/M+RbJha8+vUUm6hDKv3h4GU0
	 LmndmXxjY6nU7hMVD5HlEwhVTiAgBY5gJBO/4XldqjyE9XSxturPq4frbxsJWfv3O5
	 u1QcVK6m/2tkg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vNvUk-00000008Cm6-1qY2;
	Tue, 25 Nov 2025 16:02:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Convert ICH_HCR_EL2_TDIR cap to EARLY_LOCAL_CPU_FEATURE
Date: Tue, 25 Nov 2025 16:01:44 +0000
Message-ID: <20251125160144.1086511-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Suzuki notices that making the ICH_HCR_EL2_TDIR capability a system
one isn't a very good idea, should we end-up with CPUs that have
asymmetric TDIR support (somehow unlikely, but you never know what
level of stupidity vendors are up to). For this hypothetical setup,
making this an "EARLY_LOCAL_CPU_FEATURE" is a much better option.

This is actually consistent with what we already do with GICv5
legacy interface, so flip the capability over.

Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: 2a28810cbb8b2 ("KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping")
Link: https://lore.kerenl.org/r/5df713d4-8b79-4456-8fd1-707ca89a61b6@arm.com
---
 arch/arm64/kernel/cpufeature.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5de51cb1b8fe2..75fb9a0efcc8e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2325,14 +2325,14 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
 
 	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV3_CPUIF);
 	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV5_LEGACY);
-	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) &&
+	if (!this_cpu_has_cap(ARM64_HAS_GICV3_CPUIF) &&
 	    !is_midr_in_range_list(has_vgic_v3))
 		return false;
 
 	if (!is_hyp_mode_available())
 		return false;
 
-	if (cpus_have_cap(ARM64_HAS_GICV5_LEGACY))
+	if (this_cpu_has_cap(ARM64_HAS_GICV5_LEGACY))
 		return true;
 
 	if (is_kernel_in_hyp_mode())
@@ -2863,7 +2863,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		 */
 		.desc = "ICV_DIR_EL1 trapping",
 		.capability = ARM64_HAS_ICH_HCR_EL2_TDIR,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
 		.matches = can_trap_icv_dir_el1,
 	},
 #ifdef CONFIG_ARM64_E0PD
-- 
2.47.3


