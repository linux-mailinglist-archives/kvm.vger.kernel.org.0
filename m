Return-Path: <kvm+bounces-55897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C26B3877E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2644F5E2128
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4135435A299;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bIMx1wfH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5562A350857;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311050; cv=none; b=d2FLOKv5/qjLlJDz/fhyCF5ETDzjG5lp3plaJRrAtaoVcYPbmMUiZ9GVgoqPqVXKJIF+tY/xpdckcj0Q3CYq4UTIzGhZ0thJGt9e1QY5ObvST9itEso5HT3So/YEZCWUYTGyvD8NHP5WclT/ed+PZEy7Pz/tQ08iSjdm/FJkIhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311050; c=relaxed/simple;
	bh=gHppliEY0y6/P8OeBVVGz1thwVeXvKiBpmZt9uamRz0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SILCGZkrgVYLS+VNJGV+PTuwLAkDgWrHq5PZ6ClPs/L1dWYIArABjNXOw6cPy9XKqpPw/szAzC7fi7WmMuL7oscDDSNjd5OjCVhHZx7mJe+c6LldIhbcn9c6+oplp5Lp6KlBc13Rvf7w5fQT7WKM8U/8m7748x6VjKlUvlhNoaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bIMx1wfH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57CDC4CEEB;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311049;
	bh=gHppliEY0y6/P8OeBVVGz1thwVeXvKiBpmZt9uamRz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIMx1wfH16+5WGE10JGaZXuJEj6afjd6aWOlULnrRciZOfwOB+bpe7tscNBG7+TL5
	 IpX4fXqVozziGe9bwY8q5VD72Pi9JdmJaHzl2I/6oDXC/GhP68zEsPd3YVDW4KkYy4
	 sZHsMajrHLIq5q/40waKOc9RtIIfCN0ly6t8ukOo4D7f5UiiAn8q/HfRay7bY5AlNY
	 42c4TivCfleSQj4nj0pJ5/PbNxsDOpuTxAKj82aFcfNbChtNzcuWCpBO2zrHVe2ff4
	 kZk8sphI2RmIBCqe3nS8Kot7NlosdiWQEYMUWHCZJ+VOCbmcxs3hDRqmk52JzajtiD
	 nLxT+2MaO5f9g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjX-00000000yGc-3ox6;
	Wed, 27 Aug 2025 16:10:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 07/16] KVM: arm64: Populate PAR_EL1 with 52bit addresses
Date: Wed, 27 Aug 2025 17:10:29 +0100
Message-Id: <20250827161039.938958-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Expand the output address populated in PAR_EL1 to 52bit addresses.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index c684325b954d3..4d97a734e0f50 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -844,7 +844,7 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	} else if (wr->level == S1_MMU_DISABLED) {
 		/* MMU off or HCR_EL2.DC == 1 */
 		par  = SYS_PAR_EL1_NSE;
-		par |= wr->pa & GENMASK_ULL(47, 12);
+		par |= wr->pa & GENMASK_ULL(52, 12);
 
 		if (wi->regime == TR_EL10 &&
 		    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
@@ -877,7 +877,7 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			mair = MEMATTR(NC, NC);
 
 		par |= FIELD_PREP(SYS_PAR_EL1_ATTR, mair);
-		par |= wr->pa & GENMASK_ULL(47, 12);
+		par |= wr->pa & GENMASK_ULL(52, 12);
 
 		sh = compute_s1_sh(wi, wr, mair);
 		par |= FIELD_PREP(SYS_PAR_EL1_SH, sh);
-- 
2.39.2


