Return-Path: <kvm+bounces-44746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C8CAA0A4F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 13:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73FC316D3D8
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 11:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95A92C17AC;
	Tue, 29 Apr 2025 11:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DR+k33+j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C602D027F;
	Tue, 29 Apr 2025 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745926884; cv=none; b=Rb4ZatYIPSIxuWUf5kcl/4ff+tT6/pJzqj0MuwtmUMnSPuN1ITGMtqavUhtKxA/3fYKcr6lZCBoR+KxCroEThiycTYJlaem3j1ErhoZPj+AahstfKugtabp0sY2KNM4TXgsy9Hofk7QmSGQEOu6aizNmOLLuK1BLqNTfdB6zZqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745926884; c=relaxed/simple;
	bh=Pk4WX/VQ6r0BfN7MRXOMFVphZW9NidsGpywyMc+Scuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zyxe78Ugu2fKazAukBAP7NltI5xHDliifDr74trav1JtFof3ZZ2wHNJQ1PXa2GG0oEuYLFkfRNVarvjmd6GX5MLk201L4aSLtdbr6ooLkwUbXWKwCGOaWZFBtSumeogVG7X6OUm12Em1wF1O+ojNJTu9o7ex/kd/viGpshlZUxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DR+k33+j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAB5C4CEEF;
	Tue, 29 Apr 2025 11:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745926883;
	bh=Pk4WX/VQ6r0BfN7MRXOMFVphZW9NidsGpywyMc+Scuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DR+k33+jqAvaz9y6c+cN7D9lqRgJHjrPPeWPerRAI2F8O/omz5u4CxIe+hDKfCQC1
	 HtS9mOt7owGCJ184IMosP+DN31siHnl9ULRTElzSkV1VNEFjGY7YkfJQXO1iLOhZhG
	 BWVqbu9MQiRfFeD+tKM6iDr8OMLRkAeHqYrjJZgO/1PItL0sNEJ2MHfIEDbs36PF+/
	 SAUWrm4FXWACGZDA9Y+8hk7aJqpc3RusUuEAWaErCGwwSFdarXDmUVIcWJNVl5uTAi
	 JoH+YdO+7QBciOH2nIgluvj1SfQLVbTmhNWkDUEK0BgVEBAInCRM3QPUgoPY/u5dq0
	 /Q0ze7z3pl55Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u9jKz-009t0f-Ki;
	Tue, 29 Apr 2025 12:41:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 2/2] KVM: arm64: selftest: Don't try to disable AArch64 support
Date: Tue, 29 Apr 2025 12:41:17 +0100
Message-Id: <20250429114117.3618800-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250429114117.3618800-1-maz@kernel.org>
References: <20250429114117.3618800-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Trying to cut the branch you are sat on is pretty dumb. And so is
trying to disable the instruction set you are executing on.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 322b9d3b01255..57708de2075df 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -129,10 +129,10 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, DIT, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, SEL2, 0),
 	REG_FTR_BITS(FTR_EXACT, ID_AA64PFR0_EL1, GIC, 0),
-	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL3, 0),
-	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL2, 0),
-	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL1, 0),
-	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL0, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL3, 1),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL2, 1),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL1, 1),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL0, 1),
 	REG_FTR_END,
 };
 
-- 
2.39.2


