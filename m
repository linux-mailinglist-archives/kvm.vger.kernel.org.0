Return-Path: <kvm+bounces-57554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6A1B578D2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DD9B3AFA10
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F9130149B;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbjCcx7+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952F43002AE;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936698; cv=none; b=YwaSH5BfFWf4MJhTQtw1295FWxy0WfHFbZY1F64y7hSO+2CydLRIo4R10BeejYJhe4zL+LgNeqSHM/xdfQCoIcPGEFCTmTyyFRwr7NkIVtZyC4c35fF0ZTXF/SxcDasn4GIxCrkscgrMBpfABPNYmiKchuisC57egIgKD0LGVJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936698; c=relaxed/simple;
	bh=fJ3VtTH//ia4F0gvgRNZ5Yn1DvuD73TXLhC3+A2vWzs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GuxRC17uiL1LFM/L8eUoDUBVB5mnDQ92F4wtSEDCH2jj/p1hqbD97Dww308TE2DUG9/IbfM1M+R3dvsoAUoy5Oy9qUfFyG+hUi1UhhkMWvOhxCRhJVeBjWTAVyVZQ2kKnZSvSCpT7wOdZrEnd4gvAbdy8zMgXMQEm2ja2fLAngI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbjCcx7+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214F8C4CEFB;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936698;
	bh=fJ3VtTH//ia4F0gvgRNZ5Yn1DvuD73TXLhC3+A2vWzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbjCcx7+pwb99RPy0mY+rzKaVVubUTmks4kfxcbAhJoxSA6U/1IqatL+56lZl5zWR
	 WBfcfmz3GcDm3dPy6XffaRKCOUF5KnsVC3+VDdD2MF1moX9sHqkDALOoC+Uw4vCd0M
	 r2seEO2xbxftqO0s8QgZuQ2tLWc389D0v1lN8WDypwDBbhjCyoTzpG1Lgc9xT1P0lW
	 xvnzskW+PzamIC6RMx/Oh49v0ooeJwfBRITqFA6deKT0pDe3XuWF5jLBReISvsvd3A
	 BOc1Z2m0hP/BqmxP4WifBrlPHHCchEZFx1ZxfZ92Lgv1EKTAp5JSwsNWUvOiDYDj8S
	 1NbVpi1a5NTsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dg-00000006MDw-1GD1;
	Mon, 15 Sep 2025 11:44:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 07/16] KVM: arm64: Populate PAR_EL1 with 52bit addresses
Date: Mon, 15 Sep 2025 12:44:42 +0100
Message-Id: <20250915114451.660351-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
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
index 952c02c57d7dd..1c2f7719b6cbb 100644
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


