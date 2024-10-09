Return-Path: <kvm+bounces-28325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC86997541
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDECE1F25413
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584311E1A30;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNRhx0jY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1391E2821;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500445; cv=none; b=BWuen4jm201ILgymRnmH5w5niD140I/Ii9H0DqDjJQPYDkftXX5Qx4TBpQHQ8FEMaOygXrkJVw4xz7hQaaVnB12b+m8cqIBmdJap1u+oqpwlwoSzhJPWxZL4xdRrM1C4epPsd0SQeyRaKY9YhnJEC1vHYCfCPauc2jTgIi0RD+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500445; c=relaxed/simple;
	bh=qefyqNxfTd06KWngVuTOytAcncJSMMCvufExwS1FNjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J0NnisERAfYTiPipknpR4audLC6DHc9dFSZSzQIQ+osvSpNU5znFugLDm6d/jcpzLOOiANitQbETjI3Od2ykgDD4er5FSDpaPskiMDM37TT/QHLnmA52cGb6zLuer++xK0mQUYfoPharJgrWNgQL2s9ekdn979vu2gdXCAfQbxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNRhx0jY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D50AC4CECC;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500445;
	bh=qefyqNxfTd06KWngVuTOytAcncJSMMCvufExwS1FNjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNRhx0jYV20+lsfdRI3o/0Jp0pwfJ3ueXI973tTb/C82m7oGbLjYM2O963zoe2cI9
	 1x0iaRnqV9bdjwJ0MOw8mzN++QaAY3vhh9MPGvllPMx6PiCJe3vE6iQ2OO3IjeFHOB
	 spgwcVM07hRl90KTfgN99v52ONr2pDq53mWuj7005x2kGDDyIs/Uj6P8sIodXytsmI
	 bwEs3fbBQ8ySl84itzvA8RYBJcliFhQCV+RKq352Z9xyljt+aGFxPqzxuWFdaFtlkR
	 u2kU6mjAsMP3s3Onn22ZGugcNwp+O3RIGrnfMiNJ1atcgG5oG6y9yC8VtK0/1FQCqe
	 3A/bUzmdCgsbQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvP-001wcY-HA;
	Wed, 09 Oct 2024 20:00:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 14/36] KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
Date: Wed,  9 Oct 2024 19:59:57 +0100
Message-Id: <20241009190019.3222687-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the FEAT_S1PIE EL2 registers to the per-vcpu sysreg register
array.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/sys_regs.c         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ca064af6cac21..1a5477181447c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -471,6 +471,8 @@ enum vcpu_sysreg {
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
+	PIRE0_EL2,	/* Permission Indirection Register 0 (EL2) */
+	PIR_EL2,	/* Permission Indirection Register 1 (EL2) */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 514b016d09764..a85f62baebfba 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -135,6 +135,8 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		MAPPED_EL2_SYSREG(FAR_EL2,     FAR_EL1,     NULL	     );
 		MAPPED_EL2_SYSREG(MAIR_EL2,    MAIR_EL1,    NULL	     );
 		MAPPED_EL2_SYSREG(TCR2_EL2,    TCR2_EL1,    NULL	     );
+		MAPPED_EL2_SYSREG(PIR_EL2,     PIR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(PIRE0_EL2,   PIRE0_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
-- 
2.39.2


