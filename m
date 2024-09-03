Return-Path: <kvm+bounces-25759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 888A496A2FA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C5F7B266A4
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AB918BC0A;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t59mwIQ0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C35189B88;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377922; cv=none; b=jNyza7vTi8UlJ56XxLUF1TseTEj/amLXM3IyuYhtMEOceMCbT9bwEba8h9oJpdbCBjm+ZVTDzZJgYV9Ibg0W+rYWII9WXqOuVESGngEO3LQo3m6KnctD+OPVzm/j/aZfPC84WMfdCpFVS/rhGUIWbPQobSGNiNNVSLJ+/LZjcVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377922; c=relaxed/simple;
	bh=gWUfxT4H7N3nyM/fDaVuQppiX/holJhsvKWB8A/mp8M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g/X/rrYkwFymdTUVitennttzHFppS9FKlJwZvykTWptF8SpmGdyTPPfUI0XbVkSxK11mGfzXbhR6GU7eejM39AaA0CFFOevYrV5pd2CMv4ScexO9KYZ4y31AfLC6CQ4ayIpoFGYY8rlt0m0xVeyz251KXB60u+yeft2jUbWkxvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t59mwIQ0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB64C4CEC4;
	Tue,  3 Sep 2024 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377921;
	bh=gWUfxT4H7N3nyM/fDaVuQppiX/holJhsvKWB8A/mp8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t59mwIQ0bjRXZqCxs8uzQ9l0v/+t6JdA7oLZYZeVHZZ98Wji8+hHR52yLHiPKlWYT
	 68I6xzrPPkT1fVwbU9fmGF4biklNLItHVN5PXrxaPNh1X4IE048xe0WxMDzyKmC+DJ
	 tsTGEX7RH1nEDCy7tc1s51nUMviE8PHprdYfJw5KIiWrKmJ64Se3GNYDd8R8at5Huz
	 Sgm6xoYNFI09PMx9q35247TpNmu4h71g77vhdCmH0oJvT/GUNOQ2jcksnsJ0xvQbno
	 zNlkAtupQRM+yTdMim7Dz6cIJ1v2qM5BoQI4KsNxCmkwmt6XNcELlp21zT2H7m982+
	 xEyGNsdooI5pw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc7-009Hr9-TP;
	Tue, 03 Sep 2024 16:38:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 07/16] KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
Date: Tue,  3 Sep 2024 16:38:25 +0100
Message-Id: <20240903153834.1909472-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240903153834.1909472-1-maz@kernel.org>
References: <20240903153834.1909472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the FEAT_S1PIE EL2 registers to the per-vcpu sysreg register
array.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5a9e0ad35580..ab4c675b491d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -463,6 +463,8 @@ enum vcpu_sysreg {
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
 	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
+	PIRE0_EL2,	/* Permission Indirection Register 0 (EL2) */
+	PIR_EL2,	/* Permission Indirection Register 1 (EL2) */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
-- 
2.39.2


