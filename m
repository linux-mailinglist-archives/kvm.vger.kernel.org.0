Return-Path: <kvm+bounces-39146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C134A44881
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:39:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E67F51896C3B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5956420E6FD;
	Tue, 25 Feb 2025 17:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDnRM3Ix"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D27199FD0;
	Tue, 25 Feb 2025 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504587; cv=none; b=Fmxm7NbL4KBq+G0Pwm+2FhjcT16hE1WGgEv5xe8GKFvWo87HMy7EQ9KuFt9guZFSV9wDmljVz8m6jMy6eioSfJkmJ/Q5c/eF6BgPJywbGZb5gcqQhNHbBpi+ATQ21j2XSU+Nzw/OI6lpCMUu4yfB+Qffy42Gvs2bIdnNTahQqMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504587; c=relaxed/simple;
	bh=xRpO2zj0gHFpycFMnNKG7Uh812YDKZ2YV9mcceXqpxY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uTqUtMsCA50l9xCX0C25lQC+EbnSqudU52CziMqIU5Z1DpmhkA8wxu/TL8qGwoLvMb8iAV3Yy3JlgVPn5+w4voTXSZnkbRoL7YxSjkK26K91bdFTZQsdXpD/w6jIIJ1J8Of6css1dUdmtzGD4lDZ8Cv51u7FIqcon6gRvze681s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDnRM3Ix; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F384C4CEEB;
	Tue, 25 Feb 2025 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504586;
	bh=xRpO2zj0gHFpycFMnNKG7Uh812YDKZ2YV9mcceXqpxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDnRM3IxjEJkeVQOBdCG4E8RMlRe1FBA8A71/YjD77XhbNWeYmpnhEksILDooMi7o
	 prlzTkZTndR3SXYKZZIiHty2XCUGV12rvNJSCT4WtL8mPK7fhsRXfwj7easx/UKoXG
	 p0wOx9Z4jdIigb3ACJrIsYX86gnLDltRp9qPwS7M5u+7/wcaHQTwNTg5OOlQ79EgPX
	 sD/CwrP74cyve3HYKvzSBrd/bT2Q1wts/7PzopMbtbkmrA/fO/AiY/bC/VuMd15Fni
	 For6uW8jAHc2QT1ZCypsLhT9urRSzGWJ4LEAdHbE8EllsQi0tNdzWvjhMJb+rK+QnF
	 KmznHTwFMbJKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tmyka-007rKs-N5;
	Tue, 25 Feb 2025 17:29:44 +0000
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
Subject: [PATCH v4 05/16] KVM: arm64: nv: Add ICH_*_EL2 registers to vpcu_sysreg
Date: Tue, 25 Feb 2025 17:29:19 +0000
Message-Id: <20250225172930.1850838-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250225172930.1850838-1-maz@kernel.org>
References: <20250225172930.1850838-1-maz@kernel.org>
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
index 3a7ec98ef1238..7e0dc6b4cb99e 100644
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


