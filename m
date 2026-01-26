Return-Path: <kvm+bounces-69135-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAFfDfVbd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69135-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABFE881F2
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FD9F3078F6E
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40973338597;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvtsIZeU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3D1337BA1;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429856; cv=none; b=BmHx5Kk8Oawaec9crKYHkG/BPaEjjy54tm2fXEgQjPf7/0IJwjuGj61NWKSFDoVfUu4/6n7CVB+B37rVeLkYCYuhyr1Ni3Z3uk0gB8rnh/PFMFP//PVe9yygsDDb6zbmVu3+3ANyMKdq75pyfI3bTgFBpYI4GD9tRUwOcHLdvSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429856; c=relaxed/simple;
	bh=tyIKkhm3K0P/fvjpxY/oYTkavJM8zjKv6f4KHx/szYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcB2X/OZfPNxPxU2uS+4FWM5rIhstSNIsAl4xD6clvuCjSRwKxqThHeQYCUgjaV1q5eh7J3tp1CfrrC/cEDYLRjnBvYa52p8q1vAlpDyzCYVqMO315rYR4yHPf4kwc6BBZKMEZ/zcc2DT6y4dzjU0663JUP0ulqZBH/IbTHZegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvtsIZeU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7DDC2BC9E;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429856;
	bh=tyIKkhm3K0P/fvjpxY/oYTkavJM8zjKv6f4KHx/szYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvtsIZeUVxLa+zWaNTZJbrP3MGSQDF+z16KPslzIfIH6rkK5FBuGyT16yW/bicshV
	 H8WwDySTBY9ydM+FksUJLi9YMK6ZyWlgtCrs/8kvYdO7YAoigT67QGedg7HY1t6G4y
	 uAFfsHVl7XqoIxPH0V/dVNJuZYGCowKRCC0JYhIGJsPfHRztxEmRRaGEa/4d3rFBEL
	 xePnLWnnRccGtYypuKxKza5jWbY5g8St4uYf28L6CQOJY89ZfZ+ANQjQIDYFwjwSKl
	 McodIyL5+Un7bJCBe4XEeOO/K38wHVqDS0pQ8ZguMeoceXtBwY+s9DanUrHeJeH/tl
	 wGMQ3majn/9IQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXC-00000005hx6-1x5S;
	Mon, 26 Jan 2026 12:17:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 12/20] KVM: arm64: Add RESx_WHEN_E2Hx constraints as configuration flags
Date: Mon, 26 Jan 2026 12:16:46 +0000
Message-ID: <20260126121655.1641736-13-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126121655.1641736-1-maz@kernel.org>
References: <20260126121655.1641736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69135-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9ABFE881F2
X-Rspamd-Action: no action

"Thanks" to VHE, SCTLR_EL2 radically changes shape depending on the
value of HCR_EL2.E2H, as a lot of the bits that didn't have much
meaning with E2H=0 start impacting EL0 with E2H=1.

This has a direct impact on the RESx behaviour of these bits, and
we need a way to express them.

For this purpose, introduce a set of 4 new constaints that, when
the controlling feature is not present, force the RESx value to
be either 0 or 1 depending on the value of E2H.

This allows diverging RESx values depending on the value of E2H,
something that is required by a bunch of SCTLR_EL2 bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1990cebc77c66..7063fffc22799 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -26,6 +26,10 @@ struct reg_bits_to_feat_map {
 #define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bits */
 #define	AS_RES1		BIT(4)	/* RES1 when not supported */
 #define	REQUIRES_E2H1	BIT(5)	/* Add HCR_EL2.E2H RES1 as a pre-condition */
+#define	RES0_WHEN_E2H0	BIT(6)	/* RES0 when E2H=0 and not supported */
+#define	RES0_WHEN_E2H1	BIT(7)	/* RES0 when E2H=1 and not supported */
+#define	RES1_WHEN_E2H0	BIT(8)	/* RES1 when E2H=0 and not supported */
+#define	RES1_WHEN_E2H1	BIT(9)	/* RES1 when E2H=1 and not supported */
 
 	unsigned long	flags;
 
@@ -1298,10 +1302,24 @@ struct resx compute_resx_bits(struct kvm *kvm,
 			match &= !e2h0;
 		
 		if (!match) {
+			u64 bits = reg_feat_map_bits(&map[i]);
+
+			if (e2h0) {
+				if      (map[i].flags & RES1_WHEN_E2H0)
+					resx.res1 |= bits;
+				else if (map[i].flags & RES0_WHEN_E2H0)
+					resx.res0 |= bits;
+			} else {
+				if      (map[i].flags & RES1_WHEN_E2H1)
+					resx.res1 |= bits;
+				else if (map[i].flags & RES0_WHEN_E2H1)
+					resx.res0 |= bits;
+			}
+
 			if (map[i].flags & AS_RES1)
- 				resx.res1 |= reg_feat_map_bits(&map[i]);
-			else
-				resx.res0 |= reg_feat_map_bits(&map[i]);
+				resx.res1 |= bits;
+			else if (!(resx.res1 & bits))
+				resx.res0 |= bits;
 		}
 	}
 
-- 
2.47.3


