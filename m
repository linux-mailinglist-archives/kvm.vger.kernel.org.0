Return-Path: <kvm+bounces-29552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F28D9ACDFC
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE01A1C24532
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD5A209F20;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tL70LC6q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4B120898A;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695237; cv=none; b=gfxDlfuPFKmKbxmgMuHBVQqEbJdzN4+RfhYV7WzdAqtqVO7T/wEaDtLoVQZ/JCGk4cGBhLJ1uSVR+cKXeVd+xaool2Y5peSb6pYniK7jlTOj9UOSpxScRXP+R0DF+PsAzv9J/38jqiYxMKWwDEqgJuOdtPC42TYWzry+psrDCpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695237; c=relaxed/simple;
	bh=8W7GYB/MhzBoRpu54iRYPqYWO2XTNA2bzwt8/xeYfm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CvteCoMeiz5ADRbCINmZoQraBkIPKqUQXTOpq/Sjoim6m4xzZqu1ItpuZiCSgl08LDrNs+lNO0xchChlkjdsoa5pzyfr0+7RpWv2xIwStU5KB2hu1GTnr+EIwcXmyMrQjeTQ3fIZCmLs202shZ3gI1fGjwKjY+fADlaYJD4r1Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tL70LC6q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C03C4CEE5;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695237;
	bh=8W7GYB/MhzBoRpu54iRYPqYWO2XTNA2bzwt8/xeYfm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tL70LC6q+hfZ1ZCsbZDoNUEx6vC4AHrvNEK8/SGns1Zr6m6XDh5jQlplKNDEwgoi3
	 Cpq5C0PqreY2vyYsw3Djk1suX0tO4cIhj0Cm1w0GlOqQoWiTI9Vs1cVNQK3OvppHyj
	 c+qTLqcej10icZOeTb+J4K9OHtLnISqbxRMMXmVxSFX/Rc0BRsYpQpGDjT207aA4CL
	 ElCmpCQa9mio2n3rcm5pVzGRjo6osW5KO7btXy6XH0RxuZJbdGq2KR+vYhXkSnpkgJ
	 iL/hCG/rmxLsKtPclWynYEyZx9w0KoV5bUhsx45p8qcCWTLV0xzaQaIOEXhyX1GLP0
	 gqybFiu/jNUaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckF-0068vz-I6;
	Wed, 23 Oct 2024 15:53:55 +0100
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
Subject: [PATCH v5 29/37] KVM: arm64: Subject S1PIE/S1POE registers to HCR_EL2.{TVM,TRVM}
Date: Wed, 23 Oct 2024 15:53:37 +0100
Message-Id: <20241023145345.1613824-30-maz@kernel.org>
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

All the El0/EL1 S1PIE/S1POE system register are caught by the HCR_EL2
TVM and TRVM bits. Reflect this in the coarse grained trap table.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index ddcbaa983de36..0ab0905533545 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -704,6 +704,10 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_MAIR_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_AMAIR_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_CONTEXTIDR_EL1,	CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_PIR_EL1,		CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_PIRE0_EL1,		CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_POR_EL0,		CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_POR_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_TCR2_EL1,		CGT_HCR_TVM_TRVM_HCRX_TCR2En),
 	SR_TRAP(SYS_DC_ZVA,		CGT_HCR_TDZ),
 	SR_TRAP(SYS_DC_GVA,		CGT_HCR_TDZ),
-- 
2.39.2


