Return-Path: <kvm+bounces-32833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA029E09C0
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:23:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CB09162BAE
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D831DE2AB;
	Mon,  2 Dec 2024 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGABxW+N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C742C1DC734;
	Mon,  2 Dec 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160139; cv=none; b=KnzXxvbNKVnJJLQXa5TrsHLg2VerGXilbbzLmYcEGJ/lfUu4FT3bF6GoFZN9NtABTWAYInrkkTyZVHyI8tMIy3lM+A740zz2pkYL4x0ubUNW2Rkl2qqBLpvv60FrMXnOdkdo9SHwl9o6VohEYa3tUXd/pqr58w8kdiGpRvp/ANI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160139; c=relaxed/simple;
	bh=CoOnX/hzc+Zpn2UPDBxSfXiFz117lrAvmCt/lMNCmRg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SdEVu81Rj++SKvDIHwwPYAQaP339OzbA6TzteExZCviUXhwcPtHGFGJg7FkruKxJwTn9IIanWrwOdn8G5LTYZeHYGZOhzXyWJ9zU1jqYqJDyK98/NfwnrRGCoGGhU2LCmqWidjoPshuZ2hIyaHzeYRxegHMV4rarumI7bhAEz/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGABxW+N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34D9C4CED2;
	Mon,  2 Dec 2024 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733160139;
	bh=CoOnX/hzc+Zpn2UPDBxSfXiFz117lrAvmCt/lMNCmRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGABxW+N605E2ciLQQiog5+QuvAtrGCzd2SfGtkE0Tc0BLaySEI4yfnYnBjA3wrpH
	 p7ajh6/4aIo4GvRAhtkXKrYOwA7MqIN7wxCFnJjbD5IM1A9lO7cm56qtSuiDoXPDt3
	 fggfSgnGmuSTYw7LqeJsh7M66DkPiKPFDTeyOymvzpuUj2/xoN6Nd6REo1fKNBX6k0
	 e7yKA4cTzEujfNaMIjWEEllBpLPX+kdNE4LUnVgMubvLgEBV/y4Je9SZkkCIgorK34
	 TeQ36chZzTtIQoqnYzSY8jcMhzcqRrUBrn4ADXY9FwzPkk32gf6b9FpfLh5s9lg1Lz
	 s6Clu7b3lI6SA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIA7l-00HQcf-Nj;
	Mon, 02 Dec 2024 17:22:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 10/11] KVM: arm64: nv: Sanitise CNTHCTL_EL2
Date: Mon,  2 Dec 2024 17:21:33 +0000
Message-Id: <20241202172134.384923-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202172134.384923-1-maz@kernel.org>
References: <20241202172134.384923-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Inject some sanity in CNTHCTL_EL2, ensuring that we don't handle
more than we advertise to the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h    |  2 +-
 arch/arm64/kvm/nested.c              | 15 +++++++++++++++
 include/clocksource/arm_arch_timer.h |  2 ++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a4..cf571d41faa89 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -490,7 +490,6 @@ enum vcpu_sysreg {
 	VBAR_EL2,	/* Vector Base Address Register (EL2) */
 	RVBAR_EL2,	/* Reset Vector Base Address Register */
 	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
-	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	SP_EL2,		/* EL2 Stack Pointer */
 	CNTHP_CTL_EL2,
 	CNTHP_CVAL_EL2,
@@ -501,6 +500,7 @@ enum vcpu_sysreg {
 	MARKER(__SANITISED_REG_START__),
 	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
+	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 
 	/* Any VNCR-capable reg goes after this point */
 	MARKER(__VNCR_START__),
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9b36218b48def..9113c6025d6f3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1271,6 +1271,21 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= MDCR_EL2_EnSTEPOP;
 	set_sysreg_masks(kvm, MDCR_EL2, res0, res1);
 
+	/* CNTHCTL_EL2 */
+	res0 = GENMASK(63, 20);
+	res1 = 0;
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RME, IMP))
+		res0 |= CNTHCTL_CNTPMASK | CNTHCTL_CNTVMASK;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, ECV, CNTPOFF)) {
+		res0 |= CNTHCTL_ECV;
+		if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, ECV, IMP))
+			res0 |= (CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT |
+				 CNTHCTL_EL1NVPCT | CNTHCTL_EL1NVVCT);
+	}
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
+		res0 |= GENMASK(11, 8);
+	set_sysreg_masks(kvm, CNTHCTL_EL2, res0, res1);
+
 	return 0;
 }
 
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index c62811fb41309..ce6521ad04d12 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -26,6 +26,8 @@
 #define CNTHCTL_EL1TVCT			(1 << 14)
 #define CNTHCTL_EL1NVPCT		(1 << 15)
 #define CNTHCTL_EL1NVVCT		(1 << 16)
+#define CNTHCTL_CNTVMASK		(1 << 18)
+#define CNTHCTL_CNTPMASK		(1 << 19)
 
 enum arch_timer_reg {
 	ARCH_TIMER_REG_CTRL,
-- 
2.39.2


