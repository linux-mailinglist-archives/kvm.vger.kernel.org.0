Return-Path: <kvm+bounces-25754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC15F96A2F3
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8895328818F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344F018953E;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjpYZ6sl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54234188913;
	Tue,  3 Sep 2024 15:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377921; cv=none; b=c2sba9c7xC5wDqsquLTp27QpUElW241PQwxoXW0+BXe9gRvUo2CEAzg3bG3u46L6G6vLvcZGQ4mOfVrd2eN1m9VOVzVML8bAZbDVWwacbPvIvNDxZFMVErFcnNcj8Q3QTOp/pHToT9HOPj0cn9wlIANWG6Z23gv1V81WqacpYq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377921; c=relaxed/simple;
	bh=hMvaTIIDsws2gWarUwjsfFWKccw4pmnymZDpQdb9O2M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RoxcpzUZVQ0Er4afXVbAxUzj1IRG8XPl/zrJ/bP5tkJK/YGmpZjkwqtArw/FU7sRNL0ZEP9MjBgvsZNJJvwMM/GKZuMa8BBxZmlA4ZTwrPxTF4ROL+QUT2kiLSKZVmvjpaihq7CdyisPgBL1dlQ85zFpJbawCBKZDOC+uAi+63c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjpYZ6sl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6E5C4CECC;
	Tue,  3 Sep 2024 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377921;
	bh=hMvaTIIDsws2gWarUwjsfFWKccw4pmnymZDpQdb9O2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjpYZ6slol+9VfNwO6rPRZiYOL/64/KIYwCGuemSAsBOhjgA6wT2MMMkNBkHx4m2T
	 i2X0QCnmSFCdDkz1xiXp8uLNnoEenGzWk0a7bZSRuZdh6fgfDOLtWPbGeD1VkVfbxn
	 P3RDdJ9hm3ey2IV58IXkCfK156BMXCsAEV5FmdnnRcvUVJf1cbqEi3c3hVTPj2WHVQ
	 n/tTENdtUgp6thZO/eKk8g0sHGjDcJj9gjEcnUkkV3JWnx/CQdzU+PwO+eobSj52xn
	 UFWnO2I04SoUeNLeQoJYoTmiJ79H1/LS/JO6URoI/ah1QpZjZhJHF0Qln58kRONQXk
	 DGNcOLbpPCMrA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc7-009Hr9-9h;
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
Subject: [PATCH v2 04/16] KVM: arm64: Add save/restore for TCR2_EL2
Date: Tue,  3 Sep 2024 16:38:22 +0100
Message-Id: <20240903153834.1909472-5-maz@kernel.org>
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

Like its EL1 equivalent, TCR2_EL2 gets context-switched.
This is made conditional on FEAT_TCRX being adversised.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 6db5b4d0f3a4..7099775cd505 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -51,6 +51,9 @@ static void __sysreg_save_vel2_state(struct kvm_cpu_context *ctxt)
 		ctxt_sys_reg(ctxt, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
 		ctxt_sys_reg(ctxt, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
 
+		if (ctxt_has_tcrx(ctxt))
+			ctxt_sys_reg(ctxt, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
+
 		/*
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
@@ -108,6 +111,9 @@ static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_el1(val, SYS_TCR);
 	}
 
+	if (ctxt_has_tcrx(ctxt))
+		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR2_EL2), SYS_TCR2);
+
 	write_sysreg_el1(ctxt_sys_reg(ctxt, ESR_EL2),	SYS_ESR);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR0_EL2),	SYS_AFSR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, AFSR1_EL2),	SYS_AFSR1);
-- 
2.39.2


