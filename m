Return-Path: <kvm+bounces-44426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4859A9DA99
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED18A1BA73C8
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344AC252284;
	Sat, 26 Apr 2025 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOfE/T3o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E35250C1F;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670534; cv=none; b=kaJvAkxdK7UVzQ5/ejNx4CWiuTFcFtlkXO682KijNFUYoAL6R+6VHQQC9g395srrioIUGbnLdrJZPoN8bqR2Aj7JtsjX6fI0AU68pkFhu1Uize/37K0749w+OdwxoI5CtOARUyOM5+5GAp29eVkW5MD82JDF29RL6P+jR4dv75s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670534; c=relaxed/simple;
	bh=Bpk6RKCUS8mCcn0z7DGT1SGuzw/M+c16uxJw8Nsfl3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W7mC9CfIi6dFNZBoP7wFJ3JcGZ6Uz6HrQzYGpPMRB1QTUGP+Kie+SSkEd4CMCpG41GgcKAZ5tOUy33gkj6ngD6tThu0o987Mzq2UuAUUUPTa3Ertd9cfAebFXTZEpB9Lq5KyOMEulNpVhh6lXgI5XH1wDMkSdXYwQmfzDKvBWx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hOfE/T3o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EED3C4CEEB;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670534;
	bh=Bpk6RKCUS8mCcn0z7DGT1SGuzw/M+c16uxJw8Nsfl3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOfE/T3oqYgwp07Vjl8Xm1oyVvMer6w0TMVbNitcezajYzRrZ6gJfEml7LejolVXz
	 qBBGjpO81EYj5q9T37ikEVEyjjto8q3KDETtfS5haBZnrMXDXS5teDTEmrSACLMqig
	 lKjFrIyiyhwGgI2nt/7OYxthdmbHHxM0fYPB1XYHn4lcUrXBhCUFfzMIKsKTrlI8XC
	 E55bxiQeezJ+ig7Z0XIQtzWEwmXzLBWrBCDnL9yCUEURIB79sWTIqZ/wuMSIPGmOFl
	 7Cx0tcyklZEbji4ON7QoL9+eOV/tloz4M1N6blKZEU0tXSLL9/TID3nc5AX9yvEc7D
	 gHPkVdd2N1wyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeK-0092VH-9v;
	Sat, 26 Apr 2025 13:28:52 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 14/42] arm64: Add FEAT_FGT2 capability
Date: Sat, 26 Apr 2025 13:28:08 +0100
Message-Id: <20250426122836.3341523-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
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


