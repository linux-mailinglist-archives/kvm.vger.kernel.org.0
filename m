Return-Path: <kvm+bounces-45627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB9FAACB4E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF2673BD762
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F422868B6;
	Tue,  6 May 2025 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIIwlq62"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA8428642F;
	Tue,  6 May 2025 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549851; cv=none; b=uRygPXclO3gTogp4nXfkAj5EyzayX16NCXKf14sdoqcW/pDBdzoINwTz6WvHgNOqUvEcwToBWBOA1a7YCajysA1hpZtC2KyG0JLSOOi6c08qvWpVqAwPdqzFPV91RSgHX7DU40RGPwE7YWcwOMzAcsgQRPpiUotlGgyu3v+uQCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549851; c=relaxed/simple;
	bh=Bpk6RKCUS8mCcn0z7DGT1SGuzw/M+c16uxJw8Nsfl3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YorcnvzKdoz6vrjIjvn0TvDUW4Ik4V91EfJ5qB4RgXyYS+gZsFBqCUq5u7V0RfjVYyTrIWR4L5xuuy0+jnBxEPqF16+LXXfl6UoY2adph4GZG4Aq21yBX6KR9d95mTQvlT3SShbEN+i/ktfI/O13+U8HfEV9ssydSVUeCW2yELE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIIwlq62; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6ABC4CEF1;
	Tue,  6 May 2025 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549851;
	bh=Bpk6RKCUS8mCcn0z7DGT1SGuzw/M+c16uxJw8Nsfl3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIIwlq62n7y9FTsT1zanNfv9ie0R7UBN4sc1bHE533TnMpQv+r+cFonbkotn4zKMP
	 0vtzE9SXDk3LVuQhHRWsKJPq6+KdfuW+N4/S9yryc4/RL67a3Uvyrch9hZDMsWzEtK
	 EUwK0Cs1e7Fkh0XlEX96+wFRYcYt9CZSLYKmzdoiPBRjcnCf+cZRLgehL+bWc0kHIw
	 5BrWijnMPhJ4PKLYW+MkkrKHhUdo5EpW2i8JtI84iDFMOtoTJt59tikauJ5Zp1DSpt
	 i0W3WhL6AO715f1348AD8Eq8DQc4SrfpaIGrYhs997adlSC8bwa5w4uRrCpSyH6il9
	 gjkfY1DviUULg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOr-00CJkN-Ez;
	Tue, 06 May 2025 17:44:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 15/43] arm64: Add FEAT_FGT2 capability
Date: Tue,  6 May 2025 17:43:20 +0100
Message-Id: <20250506164348.346001-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we will eventually have to context-switch the FEAT_FGT2 registers
in KVM (something that has been completely ignored so far), add
a new cap that we will be able to check for.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9c4d6d552b25c..bb6058c7d144c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2876,6 +2876,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, IMP)
 	},
+	{
+		.desc = "Fine Grained Traps 2",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_FGT2,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 772c1b008e437..39b154d2198fb 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -28,6 +28,7 @@ HAS_EPAN
 HAS_EVT
 HAS_FPMR
 HAS_FGT
+HAS_FGT2
 HAS_FPSIMD
 HAS_GCS
 HAS_GENERIC_AUTH
-- 
2.39.2


