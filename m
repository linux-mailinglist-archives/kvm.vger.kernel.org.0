Return-Path: <kvm+bounces-64956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E434C94002
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 15:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C051E345881
	for <lists+kvm@lfdr.de>; Sat, 29 Nov 2025 14:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365C030FF2B;
	Sat, 29 Nov 2025 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EXIHmsqu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567CC30E839;
	Sat, 29 Nov 2025 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764427531; cv=none; b=hPyC0ozvQwpgH2S6bN3Q6UZydgr+cKKr+q7pwTKjG9bHgxz7DXV5kPch0lfrRlfGTAgZ2SXOaehvvlH1IDZMjwFPSLw1DkqKLCX0CUxCrAc6zbf/yDk76H87gNneV7CClfYzemJsnGNPaG52ub71EU/7i8hEDlKQWOm97QNXIxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764427531; c=relaxed/simple;
	bh=7wd18g8k60VD+IMvKxA7F/pIhCbSzp+S9rWe6qyOByY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWFb+MpMywoFRavC9shxhcLLm7KS5qz5BYXURg6hPv1oWMKDKPLGiIJYzKc88KHBgFzlLi4MUeRkv6Uo4btbafiiuOlvXWXhLdzYjia/UOLFKWwH/x70eQtY3eJkuwZBZ7KvnzShy/2a/mP011iw5lZNutAnPlLmrbtQi4LrNyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EXIHmsqu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82BDC19422;
	Sat, 29 Nov 2025 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764427531;
	bh=7wd18g8k60VD+IMvKxA7F/pIhCbSzp+S9rWe6qyOByY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXIHmsquwt5d5+fJ2KJCvKr0zaoPxINpzcVGW1uUA7jVuW0L+R+60h2geY23lmnkK
	 0kEms4IN+Y1trvJhO9USqjQ5oCsUbOoxzWUaxmX6sJus3JB7r6jzxBbU7SmxpZx1oT
	 orgm1NDDOdf09DUq1m0UJpmpkrePhwxN0ncEgv0pNK8mlfw+pqSUcecSZ4k3Vu6l3i
	 HdobJ+WiDkUyZJB+XkzpSDtgmymsCTlthdegZ/eC8SAjaI90wUFvhuHre3JN7fKPdK
	 5wksH3chKLhqOe74lgKcW6o90vOq0eAWU9Tnr9vkc96/zGCd/EUfgrhQkgTSXBT2kX
	 7XRpQNlfQEJCw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vPMCW-00000009HnQ-42nj;
	Sat, 29 Nov 2025 14:45:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 3/4] KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP()
Date: Sat, 29 Nov 2025 14:45:24 +0000
Message-ID: <20251129144525.2609207-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251129144525.2609207-1-maz@kernel.org>
References: <20251129144525.2609207-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

None of the registers we manage in the feature dependency infrastructure
so far has any RES1 bit. This is about to change, as VTCR_EL2 has
its bit 31 being RES1.

In order to not fail the consistency checks by not describing a bit,
add RES1 bits to the set of immutable bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 24bb3f36e9d59..a02c28d6a61c9 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -109,7 +109,8 @@ struct reg_feat_map_desc {
 #define DECLARE_FEAT_MAP(n, r, m, f)					\
 	struct reg_feat_map_desc n = {					\
 		.name			= #r,				\
-		.feat_map		= NEEDS_FEAT(~r##_RES0, f), 	\
+		.feat_map		= NEEDS_FEAT(~(r##_RES0 |	\
+						       r##_RES1), f),	\
 		.bit_feat_map		= m,				\
 		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
 	}
-- 
2.47.3


