Return-Path: <kvm+bounces-28339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40ACE99754F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CEBFEB267BB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954961E7C2A;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AiA0v/5n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12BA1E573D;
	Wed,  9 Oct 2024 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500448; cv=none; b=cla1YqnOXPfEIrA1Bf57/wRFC2VzuiLZs/GkOP08aLd7cyav2qtbafRHA2iNW0VsMUuuzOUXZt715O3ZML/oySvInhiGT+qLBUZC6jQxjAOXKcTQYLqroVtz+p7lryvy0MCGiTTyhs8ngJsqEYaPq4QjyBkbGw+8ROTaBTt2dDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500448; c=relaxed/simple;
	bh=HTGZPFP6wCgir0oPY+FWnF6tWlbS4B7GKmqbwbybkEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I8X3OwSUHW/DmkBgWwmR6+l7sclcN+oydzI5wANXpC24amtijs1UkZFkFzqHV37Rse57epEkswsELaOf4gweQz4xruNqaMtg8HE+PFEb0UcaVwzv3G7da97RCYBSpxKR13t4jmD1iZFnJBC1BlakVZJOqAyeS2XDOSSQj1hLaLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AiA0v/5n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A30C4CECF;
	Wed,  9 Oct 2024 19:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500448;
	bh=HTGZPFP6wCgir0oPY+FWnF6tWlbS4B7GKmqbwbybkEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AiA0v/5nH3i5CZ4JzZBTbPW2yhVKUZ5bsxKJ1xjXpwRN22tgQ05jh4BxiWcz19f/R
	 guIijjhpVNpJ8z81YoIs6jUTyK1b/088xZVmrrQJDoHdDbuHexyBxJJMZCJilbqmkq
	 FcO1/i/1AQsVWF1GvOCCtjTD8G70V5A5OxtHkMxJXMFgiaLjopTnEjgBc/ilJRfHG8
	 i9P2fPVQWS9m8AkTmfflVgNALU3Ttgucmz08ty/9KSmBV4TW8mdkigBQJTUpt0YVkF
	 WPjyKeQQ6y/2Repb2nYHgLWaJsFGIU1i0P1qyvntgttNqgjAyAWxgyuLZPnsR+gmEH
	 /UNKyPajN96+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvS-001wcY-Pq;
	Wed, 09 Oct 2024 20:00:46 +0100
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
Subject: [PATCH v4 29/36] KVM: arm64: Subject S1PIE/S1POE registers to HCR_EL2.{TVM,TRVM}
Date: Wed,  9 Oct 2024 20:00:12 +0100
Message-Id: <20241009190019.3222687-30-maz@kernel.org>
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

All the El0/EL1 S1PIE/S1POE system register are caught by the HCR_EL2
TCM and TRVM bits. Reflect this in the coarse grained trap table.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index ddcbaa983de36..0ab0905533545 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -704,6 +704,10 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_MAIR_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_AMAIR_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_CONTEXTIDR_EL1,	CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_PIR_EL1,		CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_PIRE0_EL1,		CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_POR_EL0,		CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_POR_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_TCR2_EL1,		CGT_HCR_TVM_TRVM_HCRX_TCR2En),
 	SR_TRAP(SYS_DC_ZVA,		CGT_HCR_TDZ),
 	SR_TRAP(SYS_DC_GVA,		CGT_HCR_TDZ),
-- 
2.39.2


