Return-Path: <kvm+bounces-24635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D51629587B9
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13FBE1C21D13
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30C71917FB;
	Tue, 20 Aug 2024 13:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgwyPb05"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C963B19146E;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159889; cv=none; b=Zit/djd8kpfWJC1O1A2v6lLtsFPpZueAedMz14qcmk5aR9a4ZyJQlCzgUV0gegF7eE4s2koOMyJnpxdvAbEjA1pCmj1ZpoB8psejRNi01CUQ7vDIZQSZLvl3mQCViUxUQdfG4mentCAzl9RrYw/D6tuZUKWrPlgJ8Xt/KaoDCMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159889; c=relaxed/simple;
	bh=cFqreJ/QbxIcyFcklwuEN/SmjI5Xc8eDvAlus4TNHLI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R7W85rM+jWCHzMWR3r+4eWFsJmiwLRIlJwvx382oSmptCwct0ghfSMkSZhZ/nZ3uJLf9IYIsoVrQLSnzuUV+Gda50Pw7s90iUOXGo4CZruMrI+PyfYGE77Ljpp3gcapU83+Rng6tddCd0zf3Dhi/8TYYPZV6EOFwnzmdNGgIeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgwyPb05; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77A2C4AF0C;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724159889;
	bh=cFqreJ/QbxIcyFcklwuEN/SmjI5Xc8eDvAlus4TNHLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgwyPb05YoSan4ON9gfuNdapsHaPM9npzM3H0ZH/m4O3KRnEyoadshkDtB233ebIR
	 l8V7iQC8GkUeYUCnbJ/x00WH1UH0qhlfoyGn2pSbQz6vTZRgb0+U/WpCMfb90TdY74
	 s4enKzKZsyx379Sg9G8wFo80Zp9Y405/VkTj6FQjpRkn+Q41YWpSk6AUuk6JWAzH1+
	 CN5ArTvsAtQGA6P1SdbY9OvtutMj9psdlP64RYs/80c+OEaIvYA3HSuvuI3cUYOzeb
	 X+ZNOyhLWsega/HYmQu3vOu2ZwFlGJnbJMEVBTrfUbJUAc2h906YLJ5rL+oF8F6ouc
	 sDGyG6V9ZOVDQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgOkR-005HMQ-Jr;
	Tue, 20 Aug 2024 14:18:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 8/8] KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests
Date: Tue, 20 Aug 2024 14:18:02 +0100
Message-Id: <20240820131802.3547589-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820131802.3547589-1-maz@kernel.org>
References: <20240820131802.3547589-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Everything is now in place for a guest to "enjoy" FP8 support.
Expose ID_AA64PFR2_EL1 to both userspace and guests, with the
explicit restriction of only being able to clear FPMR.

All other features (MTE* at the time of writing) are hidden
and not writable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 51627add0a72..2d1e45178422 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1539,6 +1539,10 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
 		break;
+	case SYS_ID_AA64PFR2_EL1:
+		/* We only expose FPMR */
+		val &= ID_AA64PFR2_EL1_FPMR;
+		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA) |
@@ -2381,7 +2385,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
-	ID_UNALLOCATED(4,2),
+	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
-- 
2.39.2


