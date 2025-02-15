Return-Path: <kvm+bounces-38297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA1F7A36FCF
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EAA71703FA
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B891EDA0F;
	Sat, 15 Feb 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlgoqgP8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FFA2B9B4;
	Sat, 15 Feb 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641102; cv=none; b=hcV1cJF/Rxzx5Vpwqwj9H57yVfnbkRVYPSuEi+cLMmj/AlGfWzoJZgwMmiglKtyIQJ8j1PKdacIyLOY6etM/vhzBK2JlpeEapZReQsQB7llmXDQ0iFclg0cOqMiumzEEzKsOFehH1zji8xsKp+AMp9mX6+pko5oQHsu3PUjNtjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641102; c=relaxed/simple;
	bh=XymYMKvSscNoNyr9c1xKeKhz7KoZPOt8xd5DrF64n9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BGcjO4lyU2yJdgzoB4HFxUInd+jckhBaxwSuhC85gaV4MCZWWWoEmHakYJIugpcVdTsPTh3jSBjwPFHXwjpAXdBsd9TQqMUvzuly+IHGopr/xwFsagp0rXxqoYzUk+Rs9itVGeaCFlxEaicUpkLj9e7xRgIR4YMud/jwipgM4NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlgoqgP8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62494C4CEE2;
	Sat, 15 Feb 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641102;
	bh=XymYMKvSscNoNyr9c1xKeKhz7KoZPOt8xd5DrF64n9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlgoqgP8oGA2xyi/FZ9j07Armi+ZphS1EixA0//5+jEH1TlM8fNIXu5CfG4GzL7fm
	 3rkTxzRYzSfU06RYn6dGnVdjmdAU4LzlxSf8yJvKPEhLr6RUev/88VUsLN4Z5fHp0j
	 S9iZmQO65I5fzjgi5VBWmCTcHWZKnPtGpKoZeL6sDt4qMv9gpgUesM9ajoThcuVOtZ
	 pX5LpB5jK89OgSNfgAcRahlsjWSKMsSi1xvQZsjNA1nZNDPV+YN8NWBjg1nKgqKLLn
	 czp7yLZD0jsB5VmYOwh7bg3huPyUjATAEVRodZ43/hgDx2XmbTyQOJhBC/JfGCwVEN
	 gf6Dg+bC0qBmQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7Q-004Pqp-GC;
	Sat, 15 Feb 2025 17:38:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 01/14] arm64: cpufeature: Handle NV_frac as a synonym of NV2
Date: Sat, 15 Feb 2025 17:38:03 +0000
Message-Id: <20250215173816.3767330-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With ARMv9.5, an implementation supporting Nested Virtualization
is allowed to only support NV2, and to avoid supporting the old
(and useless) ARMv8.3 variant.

This is indicated by ID_AA64MMFR2_EL1.NV being 0 (as if NV wasn't
implemented) and ID_AA64MMDR4_EL1.NV_frac being 1 (indicating that
NV2 is actually supported).

Given that KVM only deals with NV2 and refuses to use the old NV,
detecting NV2 or NV_frac is what we need to enable it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 4eb7c6698ae43..94605e91f0e5f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -497,6 +497,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
@@ -2162,7 +2163,7 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
 	if (kvm_get_mode() != KVM_MODE_NV)
 		return false;
 
-	if (!has_cpuid_feature(cap, scope)) {
+	if (!cpucap_multi_entry_cap_matches(cap, scope)) {
 		pr_warn("unavailable: %s\n", cap->desc);
 		return false;
 	}
@@ -2519,7 +2520,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_NESTED_VIRT,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_nested_virt_support,
-		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, NV, NV2)
+		.match_list = (const struct arm64_cpu_capabilities []){
+			{
+				.matches = has_cpuid_feature,
+				ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, NV, NV2)
+			},
+			{
+				.matches = has_cpuid_feature,
+				ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY)
+			},
+			{ /* Sentinel */ }
+		},
 	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
-- 
2.39.2


