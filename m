Return-Path: <kvm+bounces-55898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0211B38781
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:11:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 581C75E24CC
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5279535A2A1;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxjaFNfO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF15350D75;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311050; cv=none; b=MEVIOL7YteG5PKNd40DmT8VhZ9Ji/D8mn81tEg0ogZNDJWEqDPW+8zuZFlfz+TXz515YeFPtlYK5pOE3t90xGawRWwOw/BBq6gU78foZoQMKYt1y56zchHPG8KHUAU9V3pQTVE39Ean5o9QsDQLmvkhI2GFbU3ByJlgJNNoF9+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311050; c=relaxed/simple;
	bh=lgdNfr9Ctbja/+iOstmhMjxKvrUxzqnUDnlTgWFyWRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KHra5FzfaNkQbCw9Jkym9QtRCDgR1LqPqY1XrQp4W9M1kZNDzaw8/S5A0fZ2od6dIN0Q+E3Wae0JeqBWJv4e4T86YeiAwWgealIjJcx/Ekz+Fqct+epoRZ1AZVvngutkSMs9gzRHo9Mw9Ki2h63Il8tIJrwL11Hbp/EURsZMCMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxjaFNfO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AFFC4CEF6;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311050;
	bh=lgdNfr9Ctbja/+iOstmhMjxKvrUxzqnUDnlTgWFyWRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxjaFNfOyfmwNuoVx2quiKdqClhQKFNqr6ZdAQtPl1313bNOaC2fB/e+a1m6e2qm8
	 LqQNLbh2QqnKZlg1/WLYk9Em5rz/y0C7Mr/YWDekEXEzUkIUntLQ31ZRdVNRwPc915
	 DHVn2L+j1Km4JpTmdjVIhyaDGiK+AeKzmOYn+hAf6UmeZ9brohtcFKI70N9l1Vg7oM
	 ADd6Jc5BvuCB9dj/6cgyYxHpftj7q5wzmICrb/RkcuHMDaHHdH3LAZOYa1MDSDYTQm
	 ImStEJrsGztKM03ESCMEJNbYtDMQwRI6A/vELFZH/giEON8lN1TIRbL4pqxjOnyaMF
	 1EzI2vW67rMEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjY-00000000yGc-0QiW;
	Wed, 27 Aug 2025 16:10:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 08/16] KVM: arm64: Expand valid block mappings to FEAT_LPA/LPA2 support
Date: Wed, 27 Aug 2025 17:10:30 +0100
Message-Id: <20250827161039.938958-9-maz@kernel.org>
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

With 52bit PAs, block mappings can exist at different levels (such
as level 0 for 4kB pages, or level 1 for 16kB and 64kB pages).

Account for this in walk_s1().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 4d97a734e0f50..f58dfbb4df891 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -448,11 +448,11 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 		switch (BIT(wi->pgshift)) {
 		case SZ_4K:
-			valid_block = level == 1 || level == 2;
+			valid_block = level == 1 || level == 2 || (wi->pa52bit && level == 0);
 			break;
 		case SZ_16K:
 		case SZ_64K:
-			valid_block = level == 2;
+			valid_block = level == 2 || (wi->pa52bit && level == 1);
 			break;
 		}
 
-- 
2.39.2


