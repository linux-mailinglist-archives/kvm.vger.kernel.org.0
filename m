Return-Path: <kvm+bounces-22817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5F0943699
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A45CD1F21EB1
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DB816CD2F;
	Wed, 31 Jul 2024 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRGme0z4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6633316C69C;
	Wed, 31 Jul 2024 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454857; cv=none; b=ALVlr0jSNrY/Wsk4wNePZD3N4re/LhESe5R1/geN3wZyOooL7MHjAY9jER26LJWfB0E3MfFsMVGkS+6id4GYkVx+GWTPYSO8JHNFZBnyz84RtmkEV3r7DtWlbz4pxUHf8lTQ0qcRo+vLBKBLtLwkv9d5GMzSHOAuCkn7V4196WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454857; c=relaxed/simple;
	bh=anTP4GOgAa7/16Fbft5Apd2q5jNqO8ce2tAPvR+UTQA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GB6hDqHBMYajL+7OzZB/FqW53kwQnvA4nP2hQM77/27ZDNSImIb/RZ03+kFAaM8ZbJslfcSIL82gKDgJ7H91A/x8wHxkbJ0fVWFn3xgzzdYupWlGlLv1vBrWQlvRcDw73o6EtMAKj6QmA9npKdmmfUjL1g/J3g0J2RPrle/95yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRGme0z4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BF8C4AF0B;
	Wed, 31 Jul 2024 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454857;
	bh=anTP4GOgAa7/16Fbft5Apd2q5jNqO8ce2tAPvR+UTQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRGme0z4j5sVnaJ/9S4tPTS7bNmCNoIWdqV2dK5sYm7/F4bd9WMa8Sq+v0rugHlc8
	 BdduxbF+hRuryV/zLYvtTyj0epmu8OhB2a/xSxKCBBB0o8kb/ctdmCj6GddUhGIZTI
	 Rcdi6rNOeL54qgO3v76YPPEf4zOvU9219rpRX93oBUng9dlXvzD1quk/wwLdAplAcJ
	 kE66tONTTbKdXeXDMZStvw0LulSuQduVnfPE+v1viaMR50vnq3Zlge5OClC7LftSvT
	 A4Shnkfy6kSrEr0s5rcgfHdV1a8YuzQYXqScRTTEcrLqBkBEXMZoaeQ7IB8Oqi/Bjr
	 Xzg43fmfknOGQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBv-00H6Gh-HY;
	Wed, 31 Jul 2024 20:40:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 12/17] KVM: arm64: nv: Make ps_to_output_size() generally available
Date: Wed, 31 Jul 2024 20:40:25 +0100
Message-Id: <20240731194030.1991237-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make this helper visible to at.c, we are going to need it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 14 ++++++++++++++
 arch/arm64/kvm/nested.c             | 14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index b2fe759964d8..c7adbddbab33 100644
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
index 3259f4fccdcd..695a1b774250 100644
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


