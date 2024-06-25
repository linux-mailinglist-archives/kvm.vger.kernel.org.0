Return-Path: <kvm+bounces-20484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C01DC916912
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CBE4289497
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CC516FF31;
	Tue, 25 Jun 2024 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pHy0NuGp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F17916C684;
	Tue, 25 Jun 2024 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322525; cv=none; b=M2vRN0C4jL0H3PNTiSQgUdFz10KjxhPuEfR27j4M3FaKkoqFS5ee7zO7w6v1QAGYpw0FLsyPsdOwgkAVmdtXoK6kDV8BmQ91SA8HGgM9lp5DyWgctU/nFICOSU6f45fF/H14ozAbeO7jvNGBqfbdWt5nb2EZiJlvGqn46qMmi0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322525; c=relaxed/simple;
	bh=de5Lj1pevoVMn753FTewXOjvi0z3RxqGLbk+fPFuegw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ro51co2Gqw/V3WJnFwzY7RE0oARCX5M1Oo+ZmCItYLDik29XW18jHCZOgKGmdYt94YWlLcmddSsGfOemAp08fRVU1vMeGf2RQrw0HFnhmAMriovcXOWJKEnezJEqGnnYaO4h1dGTgL+JxG85cjfzL8zi5Nfx1xWDADmFa7kVXZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pHy0NuGp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F82C4AF12;
	Tue, 25 Jun 2024 13:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322525;
	bh=de5Lj1pevoVMn753FTewXOjvi0z3RxqGLbk+fPFuegw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHy0NuGpJIYywB8F5GPKsPikRNpJ+kQLbRP9XVsB8251LDsBZdwqKr7xQ2B7azBil
	 FSgoyJWEDaku94x+lOfa3wZH/Z0s40MseiN6Zu2fp8KlbxmAdNPueaFgLxT6RdV1ni
	 mRTwiUyum5lKrx8WY2zLtzvmOv6dxprMKMjGUddg1p/44yJDGT63+5a7/XYmJyjFPO
	 IzLqRGtTT4JeQNdz9l0D9nJ/BC4Qb4o0Xwqxf6pnFErJacPq4o2aFTQVhhuoQIT320
	 JLeelokZLCADVFBLWDGBA0oJwBea/h3IOFTEaXP79mxMBVb4O0YG8w4bKzqJgWXc14
	 DMfb1zfqHwC5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KR-007A6l-DZ;
	Tue, 25 Jun 2024 14:35:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 09/12] KVM: arm64: nv: Make ps_to_output_size() generally available
Date: Tue, 25 Jun 2024 14:35:08 +0100
Message-Id: <20240625133508.259829-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make this helper visible to at.c, we are going to need it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 14 ++++++++++++++
 arch/arm64/kvm/nested.c             | 14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index b2fe759964d83..c7adbddbab33a 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -205,4 +205,18 @@ static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
 	return FIELD_PREP(KVM_NV_GUEST_MAP_SZ, trans->level);
 }
 
+static inline unsigned int ps_to_output_size(unsigned int ps)
+{
+	switch (ps) {
+	case 0: return 32;
+	case 1: return 36;
+	case 2: return 40;
+	case 3: return 42;
+	case 4: return 44;
+	case 5:
+	default:
+		return 48;
+	}
+}
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 73544e0e64dcb..a77b3181cd65d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -103,20 +103,6 @@ struct s2_walk_info {
 	bool	     be;
 };
 
-static unsigned int ps_to_output_size(unsigned int ps)
-{
-	switch (ps) {
-	case 0: return 32;
-	case 1: return 36;
-	case 2: return 40;
-	case 3: return 42;
-	case 4: return 44;
-	case 5:
-	default:
-		return 48;
-	}
-}
-
 static u32 compute_fsc(int level, u32 fsc)
 {
 	return fsc | (level & 0x3);
-- 
2.39.2


