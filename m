Return-Path: <kvm+bounces-28327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0409F997543
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFE731F24E06
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA161E3DF9;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iw/oTGoK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6771E32C1;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500446; cv=none; b=jwBFs1TN8nkNxsbTwV1kckpsP8OT2m7bPfde8IQ7C/sXAbLP7ceP5RyLe1YOU93tVByTSBuE7jQvZk35J+oIUdpCcE7TwRfHBFvthl/F6zbT43Uu3fSPfejeTmGBj3TnU0RmDuX9w1AQsQZZ4LXvA2j+KRBCF46pKPcF42itqC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500446; c=relaxed/simple;
	bh=I8opGiuqFUxiSXZuaqA7KAMi/5a4PI7HF5UfCvQZp8M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cQvz+CjIVVNFy5zQxeKA1ml8CKgt5uDMaLu7eYu74cWDjFkVBlBfbQffyy5KjItRiYfYgsi3BJhGTfaquhDe2f2mQ782kt2SvwMQehDM/maboROIx0ML+ajoAgJunZ+j87EFbWVLwbSymqnm8b0OZBJKTQLXhemhnMuh0zV5nX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iw/oTGoK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDCAC4CECC;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500445;
	bh=I8opGiuqFUxiSXZuaqA7KAMi/5a4PI7HF5UfCvQZp8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw/oTGoKKNkrBlMbn7Jl8BsluKQVV6XTT6l4vsfGhAFXvfLrzphQq6ZA5LjincYGR
	 s2NHbA6XO/Dd136VUY7i3dMD5WzqUHZwVc10J0tXm0jPcqRCgmNANHzH0klfQT65LS
	 kUukM2zcqTSKsgBfFh/gOsLoiQ0f7tIZ+N55DSWSteDQUavGCHP4j9EOeZpyBoxXTk
	 T86+jC4q3cokNhc9NlpHFfoSo8ZBnCYIJgyEDvK01yqcMOX4rfTrEx1MkizbR0j/4O
	 j5Y+vpCzKYDhFmoOvfv3axoqjR8oW7W2WDCur1y0t6vSoOWU1Gzpz3li0deqG5K9PR
	 orF0yt9jmmQmA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvP-001wcY-NY;
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
Subject: [PATCH v4 15/36] KVM: arm64: Add save/restore for PIR{,E0}_EL2
Date: Wed,  9 Oct 2024 19:59:58 +0100
Message-Id: <20241009190019.3222687-16-maz@kernel.org>
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
index 5f69a1f713cfe..005175c10b4a9 100644
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
@@ -111,9 +117,14 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
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


