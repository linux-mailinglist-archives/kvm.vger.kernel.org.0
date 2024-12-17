Return-Path: <kvm+bounces-33953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E879F4D95
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B0F97A79B1
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE76C1F7573;
	Tue, 17 Dec 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZPAXWkb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1487D1F706B;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445409; cv=none; b=okjV4nK+bh6aIE7QyevZagwoOmxUycjNx8NcpIJLQ0zPWqFXhLIICQpBDyojpT5A2LkbkJbUkej2GIYJ26YQMDt9HQ0X+temMuMkFPDtClYm0c6z+hhqB0nm4s2Aw8cbhenYnvoxE1zF9nXfs16AwtK7uwkZ9qdKvk4i7PaThmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445409; c=relaxed/simple;
	bh=CoOnX/hzc+Zpn2UPDBxSfXiFz117lrAvmCt/lMNCmRg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n3rNXJK1S7E/6bLAj+OvOwGLv0b5J2BAUpP8Ao4o5e5t6xt1X+Y8VTvk1D3WH85rFmG9WksrwdW4Q5N6Cfx3zkc0RA2TytuXKh5BvFt4xGV3LTDF2V8f7hfuXWDbh8Lkos2EBIoCafMrW5xZZ5X+0qgyRHaCn1zOSTfCCl4uabQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZPAXWkb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFDFC4CED4;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445408;
	bh=CoOnX/hzc+Zpn2UPDBxSfXiFz117lrAvmCt/lMNCmRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZPAXWkbSBFQuCMgBFqorJPdTahFFMX9Z+MRxw2NU+voyytiovQ+UiT62So1iiEBB
	 b6ttrBTDZHsVRlEjgNnU6wjP7N+Y3zzTh8uDiYFjGE/daDQHIHsv/Eo2+L9QfGlJfw
	 TatkXhRtfnx1tZ5ggkrFuReO1BomD4KYG2ECLM8BKR6MYH1ndNjrjTK/fPdco8O8Xm
	 GEbtaQKqYsQ2FO7k/m2fkSGSDBGDEXA0fJD8PJ0NicIM2FBssW/O12LSWYhDRbHPVd
	 jJTQn7L4Ca7NdgJqwQGxhJNM797hnR5aJKuCHbAXL8I+TS/HcvG/vBfZRM8iWn3FIO
	 tCbiszQM1oDpw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTu-004aJx-IF;
	Tue, 17 Dec 2024 14:23:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 10/12] KVM: arm64: nv: Sanitise CNTHCTL_EL2
Date: Tue, 17 Dec 2024 14:23:18 +0000
Message-Id: <20241217142321.763801-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
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


