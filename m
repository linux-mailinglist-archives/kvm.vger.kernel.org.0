Return-Path: <kvm+bounces-25167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C2C696120F
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9ACE1F23FAC
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282751CDA37;
	Tue, 27 Aug 2024 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4WskvL7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAB21C6F57;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772330; cv=none; b=Li6rrU3NBqKp3zqKxOIZsqZ0gsJ6iew8q0Z6TrKttOxchtTNt5bP337rtzk8kzoKu51NatZOnKCr1EBl5xUAtIASI2kpcBkYnDRyPfYfZIeZzkcQktl7116fYsVOupU/jwwEBbYhJD+56pw2GsQG0cDP/Ct0PKQQr276PnFd49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772330; c=relaxed/simple;
	bh=n+uSX4gg1kLlHGEZbM6hDJKdvB/dGQW4+8mseFDNQNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s08JWsAbOXYHadtTqYV+9oJgIF10qg61GaADsFyhtuDhXQ57SolKCsMm2tEMTVVCW/Mc0ICSzTav5Ik1DtJJm4Cw97tWH74Mk4D8HfgH5glbrFLlUn79AX3zsrfd+ga0RwbRJfV6Ixd+RrRUTF2eZrg0eK2qZJA2CENCw3kPoPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4WskvL7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C29DC4DDEE;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772330;
	bh=n+uSX4gg1kLlHGEZbM6hDJKdvB/dGQW4+8mseFDNQNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4WskvL7CcZMj0jaJmCy3G/hbUNQOsJrF3jSN+EWN9wJx3moZCIvLBZvR2uWwXigA
	 yYnug44VWNl4Qen933NRgy48WPY5ti3OB68m5kpvy1lJmflxF+c/mJzkX8J0HP+BDH
	 ym9v8VY5Kjlx6EAqEUKNh/LDfib3wGbGgSUCdFsaP1XNFhP8j+k38LADk2T2O/nQaB
	 zciW8s20sfTYtNj6WK0eM2hKKs0JVSMtO4ar5yDKITvci1LPcYPr2DY1CXCBaFTt/D
	 xqjij0VCsUkJtRYJXie0luH9yi5b47NglXGlhb9ZVYQBblHEUJ6La67D/jodW/2TVA
	 F0fLBBSjr4h9A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4W-007HOs-I4;
	Tue, 27 Aug 2024 16:25:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 06/11] KVM: arm64: Add ICH_HCR_EL2 to the vcpu state
Date: Tue, 27 Aug 2024 16:25:12 +0100
Message-Id: <20240827152517.3909653-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827152517.3909653-1-maz@kernel.org>
References: <20240827152517.3909653-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are about to describe the trap routing for ICH_HCR_EL2, add
the register to the vcpu state in its VNCR form, as well as reset

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/sys_regs.c         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..16cd59362b3d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -530,6 +530,8 @@ enum vcpu_sysreg {
 	VNCR(CNTP_CVAL_EL0),
 	VNCR(CNTP_CTL_EL0),
 
+	VNCR(ICH_HCR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e9d8e916e3af..a57374de6968 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2797,6 +2797,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
 
+	EL2_REG_VNCR(ICH_HCR_EL2, reset_val, 0),
+
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
 
-- 
2.39.2


