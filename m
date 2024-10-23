Return-Path: <kvm+bounces-29536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B341B9ACDEC
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 748BD283F35
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41D620403A;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="altMq01t"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3B02010E6;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695234; cv=none; b=fJQhnI7yIJRfEVM91yR/hS7ltolSnDaoYfvRfFHby3ae4A+tEDJT41hpYuOwtiHjxgGd15LZfM0lXBfGhIxeSnZaPa6Q3PuM47F8u//GXUa0paSohKrCztJPqDeGMbcUoQzQWFJiGShWY2BE7106XH58/fCqm6dYyv7ae7L0a6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695234; c=relaxed/simple;
	bh=Ndyhy4f9+aMJcCyUr5ZtLkREXt/9DAHPLPbNiHbLeqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O+2U3AubxWfLzhUiS11NlXLGLtnd56oBtIkvxyVaIVibw31bjqB8DiRSPjKvVFsAXQPPuT+DjUZVgd5VfNzNwARObVIujgT5cUT8gA/oovFber1hvVejtnzDKWphNmrDSuTLLd79/paLdfNdVj5Xbh28OPN5ybtC9HS9gBqOxM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=altMq01t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58224C4CEE6;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695234;
	bh=Ndyhy4f9+aMJcCyUr5ZtLkREXt/9DAHPLPbNiHbLeqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=altMq01t8W3+a5/1kF0TeDisedul4ml4EkD2IDcwMeeZILvwjj6kDyXaU+mLvOTyk
	 +CT3zmaNoQ3oKwJeKe2soY85lcYeUZbIPjpL8TEyjj+eTk8lUAXctD4jkLVJK55SDb
	 Ipi8mAGFK1ZvBM5N2mCLpwAx61EbgaNH0qXGoib20qBmTShP8zsMWGAYim8dWLCc7O
	 p0zBjgSkpuDVyQo9i8nAgX8mfwgcxKkzHT5jP7EBFb3lFhMUFwFQMEvNW+eKzIFpEJ
	 +iNKUopzzCeUNdpb4LAPwnXoifHuecWRu2CZ3OHG8FOT/ABRguG7NgvMkAq+8pc1tw
	 08UNnMhF7X3AQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckC-0068vz-Jn;
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
Subject: [PATCH v5 15/37] KVM: arm64: Add save/restore for PIR{,E0}_EL2
Date: Wed, 23 Oct 2024 15:53:23 +0100
Message-Id: <20241023145345.1613824-16-maz@kernel.org>
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

Like their EL1 equivalent, the EL2-specific FEAT_S1PIE registers
are context-switched. This is made conditional on both FEAT_TCRX
and FEAT_S1PIE being adversised.

Note that this change only makes sense if read together with the
issue D22677 contained in 102105_K.a_04_en.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index cdbf52bfc4833..a603966726f65 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -51,9 +51,15 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		__vcpu_sys_reg(vcpu, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
 		__vcpu_sys_reg(vcpu, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
 
-		if (ctxt_has_tcrx(&vcpu->arch.ctxt))
+		if (ctxt_has_tcrx(&vcpu->arch.ctxt)) {
 			__vcpu_sys_reg(vcpu, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
 
+			if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
+				__vcpu_sys_reg(vcpu, PIRE0_EL2) = read_sysreg_el1(SYS_PIRE0);
+				__vcpu_sys_reg(vcpu, PIR_EL2) = read_sysreg_el1(SYS_PIR);
+			}
+		}
+
 		/*
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
@@ -110,9 +116,14 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 		write_sysreg_el1(val, SYS_TCR);
 	}
 
-	if (ctxt_has_tcrx(&vcpu->arch.ctxt))
+	if (ctxt_has_tcrx(&vcpu->arch.ctxt)) {
 		write_sysreg_el1(__vcpu_sys_reg(vcpu, TCR2_EL2), SYS_TCR2);
 
+		if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
+			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIR_EL2), SYS_PIR);
+			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIRE0_EL2), SYS_PIRE0);
+		}
+	}
 
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, AFSR0_EL2),	SYS_AFSR0);
-- 
2.39.2


