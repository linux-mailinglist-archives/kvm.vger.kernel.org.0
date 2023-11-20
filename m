Return-Path: <kvm+bounces-2075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4625B7F13F8
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BE11B21702
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86781BDC2;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DhIiOQXm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672CA1A72B;
	Mon, 20 Nov 2023 13:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D84C433CC;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485851;
	bh=bhfUaHgu4t4+KncMo/Gv9rIeXsH61TjQMcvVDZSjdXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhIiOQXmRQmo8Cck4TsVcGH3CaHLKUT23NCY5t9kSON62E26Cz/JK3U7+vgvEkYkp
	 +IcPMrZ/ub9ZfEwt8NaIGpemQsup1DjLtwmLuLtGf+WaqwgsIhx1Dc2+DvQ6dnNVjF
	 MrWckMHNbVAkTR+gfrTasCT449zsvQSw2PUzmf1P2Y5zNJNNXTlr7QjTg+Rgro/RXG
	 VZY/rEU5BDgJdb+AQK+LSaL0ORmg8GxZ9WltlPN0vXEBQTMOnmPyJuVC+SZhNeieGz
	 PWIMnD8Ekssuw/5Z8rdwgR9bym1u21TtJBpAs8QtispDVPrNnZFGdxsB/fri+SlFFf
	 Wi/1+h7iBzokg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5438-00EjnU-1B;
	Mon, 20 Nov 2023 13:10:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 04/43] KVM: arm64: nv: Drop EL12 register traps that are redirected to VNCR
Date: Mon, 20 Nov 2023 13:09:48 +0000
Message-Id: <20231120131027.854038-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With FEAT_NV2, a bunch of system register writes are turned into
memory writes. This is specially the fate of the EL12 registers
that the guest hypervisor manipulates out of context.

Remove the trap descriptors for those, as they are never going
to be used again.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4aacce494ee2..6405d9ebc28a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2577,21 +2577,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 
-	EL12_REG(SCTLR, access_vm_reg, reset_val, 0x00C50078),
-	EL12_REG(CPACR, access_rw, reset_val, 0),
-	EL12_REG(TTBR0, access_vm_reg, reset_unknown, 0),
-	EL12_REG(TTBR1, access_vm_reg, reset_unknown, 0),
-	EL12_REG(TCR, access_vm_reg, reset_val, 0),
-	{ SYS_DESC(SYS_SPSR_EL12), access_spsr},
-	{ SYS_DESC(SYS_ELR_EL12), access_elr},
-	EL12_REG(AFSR0, access_vm_reg, reset_unknown, 0),
-	EL12_REG(AFSR1, access_vm_reg, reset_unknown, 0),
-	EL12_REG(ESR, access_vm_reg, reset_unknown, 0),
-	EL12_REG(FAR, access_vm_reg, reset_unknown, 0),
-	EL12_REG(MAIR, access_vm_reg, reset_unknown, 0),
-	EL12_REG(AMAIR, access_vm_reg, reset_amair_el1, 0),
-	EL12_REG(VBAR, access_rw, reset_val, 0),
-	EL12_REG(CONTEXTIDR, access_vm_reg, reset_val, 0),
 	EL12_REG(CNTKCTL, access_rw, reset_val, 0),
 
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
-- 
2.39.2


