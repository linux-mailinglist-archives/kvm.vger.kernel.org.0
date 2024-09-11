Return-Path: <kvm+bounces-26527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F083A9754B5
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A78221F227C7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD65B1ABEAA;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGVEJYn1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44671AAE1D;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062721; cv=none; b=PMAbgAcB11m5z1UD63wgLmnJ7r56qIx1B3jf7en4U72VpL90NPdc7eGkEyqoRLKjxGgNjhCnn3WIfO6UQaZ+T7boaQ7mfZ63dhywjyedH+qCvCo5vfQ6scVgn37B8vl4Jks+zTpZVmJWMV5C4xdc0KjxxDFOvti35X8dxRbfYk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062721; c=relaxed/simple;
	bh=23RumrTTF0ykVayi19wKstFogCryWQmJdkfYHBegvkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k7Ts4HBgUqFAtdhpUPwCjbscU9vi3QHf12aY33iINlBhi15gNl/vPGKOEOHHfUIfN2ma6AuW2UiGn68P1MR3P7ZEVuRML28hNLjDDwp4XhfJsDfiV3IrA3ciADORleBiONIHD+ysNxORE0XAqpW1SebhZW5ZeLqwJJtoRzlg+x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGVEJYn1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894C6C4CECD;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062721;
	bh=23RumrTTF0ykVayi19wKstFogCryWQmJdkfYHBegvkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGVEJYn10u7PVEWp142080pb6EhwAnLDpEqS5K8L4jE2MgEhLjJdYwqd8mqYLONiI
	 FFKBYnxTC+PkQcHbLl8CvsiwsSEN/EqWYsMXeC3CLW9W5qJPohzi9R8u6GnMTYwrhO
	 Mc6K6Vw2Y8ZnYLcoXQgqtzhMl6NSSN4HyR2mne1MJKf+YeCfNLGluqtxEuH/Vqouiw
	 ECtdRVu0RDX0P5ZJ6pgRgn46oMs1KQnKHz0HFppXGh8ABnLvaEclhDt5UKmLUCBVoH
	 /C6bnJA5Pox3QYi9aj2+Bg5oKZTQGnZgGNTWJIx0nBMRdlYHf+F0qG6pC/PofXVetO
	 lUMe1aGwDfooA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlH-00C7tL-Gy;
	Wed, 11 Sep 2024 14:51:59 +0100
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
Subject: [PATCH v3 16/24] KVM: arm64: Sanitise ID_AA64MMFR3_EL1
Date: Wed, 11 Sep 2024 14:51:43 +0100
Message-Id: <20240911135151.401193-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
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

Add the missing sanitisation of ID_AA64MMFR3_EL1, making sure we
solely expose S1PIE and TCRX (we currently don't support anything
else).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 81c7099a7a825..ffffcbaf80da4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1623,6 +1623,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 	case SYS_ID_AA64MMFR2_EL1:
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
 		break;
+	case SYS_ID_AA64MMFR3_EL1:
+		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1PIE;
+		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
 		break;
@@ -2485,7 +2488,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR2_EL1_IDS |
 					ID_AA64MMFR2_EL1_NV |
 					ID_AA64MMFR2_EL1_CCIDX)),
-	ID_SANITISED(ID_AA64MMFR3_EL1),
+	ID_WRITABLE(ID_AA64MMFR3_EL1, (ID_AA64MMFR3_EL1_TCRX	|
+				       ID_AA64MMFR3_EL1_S1PIE)),
 	ID_SANITISED(ID_AA64MMFR4_EL1),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.39.2


