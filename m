Return-Path: <kvm+bounces-29537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F34B9ACDF2
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 208CEB25F2B
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E81205ACC;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/4QZ5Ao"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79DD2010EA;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695234; cv=none; b=ikLaVioXALIUxDOySQUUiDmxFNJr8nnR/RGJS1JLKZCXfAEQOz/SPvnfZqRrDWytm7xeZuIoa1CwotsXZk4Ez160Jqq82IMTBqq88s7UPoUQ+pQEX3JxrXth9VZn8HCjZoEOGyJTNY+FRHjlOU6q5DGUG1Jw3ZOuIQZY+Jha0+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695234; c=relaxed/simple;
	bh=FgQexBaZfsfQzAHeUxw7obYY6WYgogLcfZPAE0mj4tA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pHcxUyig4LHfGkeN1ESsSMHzAyt+eTNhVU6CVcEawhU321hRZ9PsrsmG4UE+Ex2z8xPOempeaq+mchAmsoMdy3JGqRnTC/TPqqbE2x6COIxY8Jk7bWLdfZBDgNW5kMvoObxvzFZCGxWgZKbD0iNMZLpPF4lFyWSxroGYMR8E+C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/4QZ5Ao; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78D0C4CEE4;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695234;
	bh=FgQexBaZfsfQzAHeUxw7obYY6WYgogLcfZPAE0mj4tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/4QZ5AojyBtIzSbM+qEhDnkkrndAWGJrZmkJ6fbzM+gaJ4BB39nZqky7sF4ZqqIk
	 UVenPPvhvOXtk6BXtBZ1UlS0vnPHN28OiYuUpS6HJ/BjUZ2KjkP0d25DfRdSa32PVt
	 S+TgVYCDmxKwMRcUCf5CSlFVPT6q+v8DX5jL+bcny3SgYD3pHTvlASWf7TY3X8HBvM
	 KiR+WdL3m02pVH7HRZP1gQSEGX07SipnYT2i0JOtM7pkxjs5u0n8m+NRUSU5N9e+2Z
	 Kv28BF2GEppN3cb+XzCRUf0eB5z2W1wqLM92rjN15uXK35p/4xX4KpFjGEPlO0nyyl
	 xCPBF+z0UzzPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckD-0068vz-0d;
	Wed, 23 Oct 2024 15:53:53 +0100
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
Subject: [PATCH v5 17/37] KVM: arm64: Sanitise ID_AA64MMFR3_EL1
Date: Wed, 23 Oct 2024 15:53:25 +0100
Message-Id: <20241023145345.1613824-18-maz@kernel.org>
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

Add the missing sanitisation of ID_AA64MMFR3_EL1, making sure we
solely expose S1PIE and TCRX (we currently don't support anything
else).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c42f09a67a7c9..c9638541c0994 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1617,7 +1617,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
 		break;
 	case SYS_ID_AA64MMFR3_EL1:
-		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE;
+
+		val &= ID_AA64MMFR3_EL1_TCRX | ID_AA64MMFR3_EL1_S1POE |
+		       ID_AA64MMFR3_EL1_S1PIE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_EL1_CCIDX);
@@ -2500,7 +2502,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64MMFR2_EL1_NV |
 					ID_AA64MMFR2_EL1_CCIDX)),
 	ID_WRITABLE(ID_AA64MMFR3_EL1, (ID_AA64MMFR3_EL1_TCRX	|
-				       ID_AA64MMFR3_EL1_S1POE)),
+				       ID_AA64MMFR3_EL1_S1POE	|
+				       ID_AA64MMFR3_EL1_S1PIE)),
 	ID_SANITISED(ID_AA64MMFR4_EL1),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
-- 
2.39.2


