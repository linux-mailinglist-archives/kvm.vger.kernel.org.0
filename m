Return-Path: <kvm+bounces-29535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8342E9ACDEB
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4475F283EFB
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE622038CC;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qoO4w8B9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AC8200CAD;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695234; cv=none; b=nkbFYCNvzUZV+QtdemU5n4vHMEpB1VEqkhZ8ac0LRZy5UzeyGvuueA3IctVvhv248xBz5JzNfgfD1AivYfwfJTjyyJ5AwFDhPffHE2mEN4vQDEi7slV3zCDSwdCt9iOppPKQpo3nHAI62uObzJSTSXKqC09AF+Ij1vmI2NrHxdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695234; c=relaxed/simple;
	bh=qefyqNxfTd06KWngVuTOytAcncJSMMCvufExwS1FNjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GX/MRoJysjSDJ7PHrVC/qgz3nS2dzIG33ecSeqD/OQ9aWcr+TWlaWkm64ctF7h5JwOdr8fRmxIgA4eFlcyuqMKfQq/lj3afUz55I9JN1tpMWuksYRwPGSvBvFwzRp733X09ZEdQJP9oyK9IP1NlVYZfm6CDl980u2bEc+DvNY0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qoO4w8B9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29927C4CEE7;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695234;
	bh=qefyqNxfTd06KWngVuTOytAcncJSMMCvufExwS1FNjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoO4w8B93+PB/KuOv09sRusKlqy9JlUyM1POjZX1JEqnsHql3OOfbRZoQxnhADHvo
	 WG8M4RG/t9jzbPSVG96l8AW4U1fJeJtTxvC495+QoPL2rnwxuDeez+TzDOzsR9XXmS
	 9XHs8/K67dcZb9YDZzplGaCj0VVeVCY7wvwsZ+S2HAHvX7QZwwATaxJBmAW5AvbnJ+
	 cBPC6N3HI07L11ImuMBYXahfmns+dFG5uWhHGKm0o+E4Uu8vn/Fj3n9CHQR8sbP5TS
	 BycVvcISaDBJCyT5POs4zq9qwN/8szOW17XYRJKatwJxY72m6OWllPXSEOt30qiuc1
	 VER3tpRzemx1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckC-0068vz-Dd;
	Wed, 23 Oct 2024 15:53:52 +0100
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
Subject: [PATCH v5 14/37] KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
Date: Wed, 23 Oct 2024 15:53:22 +0100
Message-Id: <20241023145345.1613824-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
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


