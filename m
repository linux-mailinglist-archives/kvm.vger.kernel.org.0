Return-Path: <kvm+bounces-37496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7ECA2ACFE
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98C837A4F74
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD7A246347;
	Thu,  6 Feb 2025 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdea+Bf8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73445236A8E;
	Thu,  6 Feb 2025 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856982; cv=none; b=RUi3w4XkSaRyW10UMcBugWLgIgK0uSsOS0yvt6YpGlIGWQdAAMSOfXO6Qryk6lmmyKcZvJAZscwzzqJkHDeEvaZRAa5SJ/KFAsPQj00/PZQO4RnRL7xnwH4XlxXH3aADlwqDqEEZupLSBwR4fB6YkNisS+HWcWg2UKBKJG089M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856982; c=relaxed/simple;
	bh=TX4ZWC4IzNLs2Q6yhHqyAajQlcWuav3rmfuKHrDQoK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B8VgRoSv/Fo3vxPPtFHrHSsdgl8yZG1Ug0ihIPNnBaRp0L6xIiuqQtcUTZDQAu/sOylNo/Vq/Esw8UGQMV80MEnpDfsUD5ouXTnNBHoAq5ntK0ysOYfLQcezh3O8Wv1oTeXgY8krUk25sTT97ZE2FryWhyAsZTQdYrLgroauyTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdea+Bf8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030ACC4CEDD;
	Thu,  6 Feb 2025 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856982;
	bh=TX4ZWC4IzNLs2Q6yhHqyAajQlcWuav3rmfuKHrDQoK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdea+Bf8O7Iho2/neN4Jvd6nZ5lfff3+obxOKsaRa04m/eRZi1IliMoedhVBy2eJl
	 mN/hFuIMQKps7x2f/d7wRGpUOFgKgj1IgZHIjBbfwEYWlKhW9Cet1k/cjKYIypaoL4
	 R4g8HvC8TO25c5Qq4v5nbmax9gD1C3d5wxp5Y5P8emjpoes6Q5ajDiE9CdRNhXEEmD
	 6OKnLIh1fGWIRHSkN/pXU7+Qel5cV3WKqUTvSCOxS+gewTMOiXfrN1GMB5wJwsONM8
	 ky2G6dmaA5ZiRzhtwnDGObLPs/Dv2sJoe6tg8iZ4XIXgf3BFMblck+KgvWDZS278cL
	 4XBLVPb50j+5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48K-001BOX-4B;
	Thu, 06 Feb 2025 15:49:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 05/16] KVM: arm64: nv: Add ICH_*_EL2 registers to vpcu_sysreg
Date: Thu,  6 Feb 2025 15:49:14 +0000
Message-Id: <20250206154925.1109065-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206154925.1109065-1-maz@kernel.org>
References: <20250206154925.1109065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_NV2 comes with a bunch of register-to-memory redirection
involving the ICH_*_EL2 registers (LRs, APRs, VMCR, HCR).

Adds them to the vcpu_sysreg enumeration.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e34..10b3211b0f115 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -557,7 +557,33 @@ enum vcpu_sysreg {
 	VNCR(CNTP_CVAL_EL0),
 	VNCR(CNTP_CTL_EL0),
 
+	VNCR(ICH_LR0_EL2),
+	VNCR(ICH_LR1_EL2),
+	VNCR(ICH_LR2_EL2),
+	VNCR(ICH_LR3_EL2),
+	VNCR(ICH_LR4_EL2),
+	VNCR(ICH_LR5_EL2),
+	VNCR(ICH_LR6_EL2),
+	VNCR(ICH_LR7_EL2),
+	VNCR(ICH_LR8_EL2),
+	VNCR(ICH_LR9_EL2),
+	VNCR(ICH_LR10_EL2),
+	VNCR(ICH_LR11_EL2),
+	VNCR(ICH_LR12_EL2),
+	VNCR(ICH_LR13_EL2),
+	VNCR(ICH_LR14_EL2),
+	VNCR(ICH_LR15_EL2),
+
+	VNCR(ICH_AP0R0_EL2),
+	VNCR(ICH_AP0R1_EL2),
+	VNCR(ICH_AP0R2_EL2),
+	VNCR(ICH_AP0R3_EL2),
+	VNCR(ICH_AP1R0_EL2),
+	VNCR(ICH_AP1R1_EL2),
+	VNCR(ICH_AP1R2_EL2),
+	VNCR(ICH_AP1R3_EL2),
 	VNCR(ICH_HCR_EL2),
+	VNCR(ICH_VMCR_EL2),
 
 	NR_SYS_REGS	/* Nothing after this line! */
 };
-- 
2.39.2


