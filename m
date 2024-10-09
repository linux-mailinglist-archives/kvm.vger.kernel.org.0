Return-Path: <kvm+bounces-28326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9EE997542
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E50A01C21A3C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB66A1E3DDF;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WixtwlLo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0771E32B0;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500446; cv=none; b=Z2wasQKXh1NrQiyl96qWsi3O6EvLEyQARflXxOKT5UMzeCDs2C8b+bOJV7FAuJb0a3w+uL4MtrIkXJcjTcDQrORhBzbIBzWFtjY6rZO0+Mrn2sjktjOayfw+g+uaSbRhMwNQ7b/OHV3KvX5lhJ6E4ZrF7OGY1hk75nWT5d4vVZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500446; c=relaxed/simple;
	bh=FgQexBaZfsfQzAHeUxw7obYY6WYgogLcfZPAE0mj4tA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N62w0ruBFC/dJw/GPuOm60reTxMb0BlLmDkpThgQNp0goZnLtH1lvBpmSDbPvKPCZR7KgJ7pVwrobCGmrTy0afWlAtGJ8wnv4/arZkFnhi/mMXfU3UbAEsIOildvZHZJxdZn70gsVcFWeLUHji7VNZTSjDxn20GO9hMqrkY3oiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WixtwlLo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9B6C4CED4;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500445;
	bh=FgQexBaZfsfQzAHeUxw7obYY6WYgogLcfZPAE0mj4tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WixtwlLoWOQuDwtZZNW3zKconMpz4W68y2yM5+dYpRiNbwduf37lNfAk6fYsr8KX9
	 ybFBx+bDuqpR/W7piI3Su8ewDbvQi38Mzk88WM+ot49PDojQ7l4rrkpbsJ6xG37Zz5
	 /F0AEw0b9/ELTMPGuiTJCbqm3oY1NszchUuaSRHubR2os+TY+JfvPS5/oGlDLOEfTc
	 WfEopICYTEYV26TdgIFkTC/Ful/zWuAipkFeYX+XL6FN8xnLeD1p3OPjESzqp1VqA+
	 wWu3tnxbA5ZkZpQk6+Pskj9Zq4Prvci452G8GJwhwKi/mOVLBNYc7Q9NhpJz9JovkC
	 QF9REJbjSrs/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvQ-001wcY-42;
	Wed, 09 Oct 2024 20:00:44 +0100
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
Subject: [PATCH v4 17/36] KVM: arm64: Sanitise ID_AA64MMFR3_EL1
Date: Wed,  9 Oct 2024 20:00:00 +0100
Message-Id: <20241009190019.3222687-18-maz@kernel.org>
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


