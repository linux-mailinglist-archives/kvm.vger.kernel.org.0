Return-Path: <kvm+bounces-24594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46996958396
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F54A1C2422D
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3A518DF78;
	Tue, 20 Aug 2024 10:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxODEaQf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338C018CC16;
	Tue, 20 Aug 2024 10:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148374; cv=none; b=D2QAe6/tOyV8iiVx9yz0HVX1oIUtp5iKnjoRimXKR8Fpo4AMeHyep6FSP90rhZ1wNG+iP3DZt06F6F6okYT60RYiznvk1gFJtUwyldLif0/96WXaaWYcXOga+uYy+5SvKWiP+KlO0Xo8SuYAxjqWLed2hJCzsCc/Bu1Jd97uZIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148374; c=relaxed/simple;
	bh=qHwFNQ8dKApmlAFsslahYxWMFTOJcOgUzm2R88iPdFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mEwf5holn3D6bxNtWS73Fdag+UthJ8VdePiW01EJDSugucSRujHDAQ/tw1cxyGvYMtW6uqDp8Lo3A9D/zyH9C4ca2TuA9ZA5dVSy4Q5A4JqAbPmn2FGz8VloyygxMip/oMKXJgx7qY8Jgmd5g8lreBFfocAJEXYuKkID6tWtNHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qxODEaQf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B08C4AF10;
	Tue, 20 Aug 2024 10:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148374;
	bh=qHwFNQ8dKApmlAFsslahYxWMFTOJcOgUzm2R88iPdFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxODEaQflJmqd5mLJ9uPBiR6V7mTn4FtVUMWalpsJ3wmpwOSI4MOUBiOdX/N8CRx6
	 0DWmaHFucUXg7GaRZxpCUpyeuGshSlLTGb9sfVilsxArXa8PVhTl27q0TQQi29svGH
	 38rTJPF3sDl2s5yoH5NYFF21XdI6DeKsssQHOrTx4E66JMYxjRO4mMVRYuleJpwh4a
	 EraJYY4hzwW1sFCb4Q+SmEMPe404MTakZ4H2HDdPr/XeDxoIPivPRV9wrLabmnic2F
	 H/JoD0UDK0bhIzNQRlr1C/jXHcAOkLHxGOlXdkGVlxAT+vD4LnMA8xzYJGHWn5B1NW
	 q2dFkQifTWeiw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLki-005Dk2-B6;
	Tue, 20 Aug 2024 11:06:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 07/12] KVM: arm64: Add ICH_HCR_EL2 to the vcpu state
Date: Tue, 20 Aug 2024 11:03:44 +0100
Message-Id: <20240820100349.3544850-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820100349.3544850-1-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org>
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
index 7d00d7e359e1..c14fea3abc1b 100644
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


