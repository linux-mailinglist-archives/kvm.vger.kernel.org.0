Return-Path: <kvm+bounces-25760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A64396A2F7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36C40283B04
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8920C18BC0F;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lu1jIily"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D328189BB7;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377922; cv=none; b=M3AOMx47n3Ntfp9HWYigPW98YSkCkiT+y5gqtm5IssPoded3q5mr/mk0RRsQRuu0V83U7pnWHpu48uVVZvym2N0ECHPHYlmUfhbTfsgqHsFZt73Zb72a4+JychTtgAm1s05Yk6q8zd4wlN/9+TlbhcjLZ3JXGl1m5AkA8hlF6fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377922; c=relaxed/simple;
	bh=ATetRkoABuojbU2sqycPOK9TZdZKTrv3E7DRvX/cAj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ayCHfYoqmIj2Ea4hERmuixQFnh5UMtRGeH6iEVKgrQaauUy8GS0eCl/KqBv7FRgLhjJplNy7LdOAhok3TxoWM6X5ZKIl+K6CD03sT/XtJk7edqS0wM3ulBW4MKpBFbScPzcb/Yo8gMFRBjx0N0ZAwgmibQ6s9GgVdJV9rBpAOec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lu1jIily; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4E1C4CECA;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377922;
	bh=ATetRkoABuojbU2sqycPOK9TZdZKTrv3E7DRvX/cAj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lu1jIilyb+zEowjgnRmiGxt0Mzm8h/F8HBb9rSM2anw7IBmj6axb7H8gf1t6m8cZt
	 KRfd9uIFvgt+WNv1KtSd81+38LDrU2171vQePRFBLWjfL+W4wEKKoeteZepHv/TsNZ
	 dlPnMV/VQQ1iIgvCgjUxAuIvFHSE4basp3SvIigOK6cfxeOk1x/dtQJ1o2+CLfhxhe
	 qbkzh4YN8VaruI/Mx+UFK1RicvFbDxGIf3wCL7CKU9rfWZ5hQbPvdmoEtWSOc+mr3I
	 TNEyUHqjCaiaOWnkCo36dVQnAhvmROdI1YJcrF2b9+CnT9O01CEPeOq69k9N7aNYrA
	 sS6mndFyDzanQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc8-009Hr9-3H;
	Tue, 03 Sep 2024 16:38:40 +0100
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
Subject: [PATCH v2 08/16] KVM: arm64: Add save/restore for PIR{,E0}_EL2
Date: Tue,  3 Sep 2024 16:38:26 +0100
Message-Id: <20240903153834.1909472-9-maz@kernel.org>
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

Like their EL1 equivalent, the EL2-specific FEAT_S1PIE registers
are context-switched. This is made conditional on both FEAT_TCRX
and FEAT_S1PIE being adversised.

Note that this change only makes sense if read together with the
issue D22677 contained in 102105_K.a_04_en.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 7099775cd505..01551037df08 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -51,9 +51,15 @@ static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
 		ctxt_sys_reg(ctxt, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
 		ctxt_sys_reg(ctxt, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
 
-		if (ctxt_has_tcrx(ctxt))
+		if (ctxt_has_tcrx(ctxt)) {
 			ctxt_sys_reg(ctxt, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
 
+			if (ctxt_has_s1pie(ctxt)) {
+				ctxt_sys_reg(ctxt, PIRE0_EL2) = read_sysreg_el1(SYS_PIRE0);
+				ctxt_sys_reg(ctxt, PIR_EL2) = read_sysreg_el1(SYS_PIR);
+			}
+		}
+
 		/*
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
@@ -111,9 +117,15 @@ static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_el1(val, SYS_TCR);
 	}
 
-	if (ctxt_has_tcrx(ctxt))
+	if (ctxt_has_tcrx(ctxt)) {
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR2_EL2), SYS_TCR2);
 
+		if (ctxt_has_s1pie(ctxt)) {
+			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL2),	SYS_PIR);
+			write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL2),	SYS_PIRE0);
+		}
+	}
+
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL2),	SYS_ESR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL2),	SYS_AFSR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL2),	SYS_AFSR1);
-- 
2.39.2


