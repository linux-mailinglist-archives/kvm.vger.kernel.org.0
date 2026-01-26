Return-Path: <kvm+bounces-69139-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CL/eE55bd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69139-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:18:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6AB881C6
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3344D302BDF1
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1122D33892D;
	Mon, 26 Jan 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUl0abXC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B371338594;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429857; cv=none; b=t8R5zLXZUkaFbTlLd0eSf/qSBvlBKXxZXdIob4CRZ8Sa/VhbMs0zu8IzkEnt5678yzvsAEg6zLPJJYKwpL8vNhxL+GXpPWSBrCg2qCAsg5DDITuRM7hooqcCfsRVnqzs/MyrS81PVM6yc2WKbfzdO/FrQDuurvTcq9hqqYJHM2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429857; c=relaxed/simple;
	bh=xlNMm973YUYr0KXNcgVj9AWk0zIimNd+U2AAd/Xm6Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufZdkD8Ce5M4VaRe770j0R/P8SEkpPf8Vo+ldCDGsLBT8S29rLai4mdq+Gw/s16PuI+PJmbx61EaoNXwI55N7H9LTeasJ9z1OMYiB027PsT+KhDjKNwxM5LE+dq3WybSzvfBKnnyr/nM4pKxosxx4zMjsQo/uPDE60GAikV3q9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUl0abXC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AABC19425;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429856;
	bh=xlNMm973YUYr0KXNcgVj9AWk0zIimNd+U2AAd/Xm6Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUl0abXC6EqroxahkpFF4kxZLsYhN2E4yfQ9ukN8qzMy7UTOgjqgDppPsD2EnKtrz
	 hA5YhMFTb0RvL3EhH9ixzSNVpfylaL6zwl/XbByyaqZrLoDUS2KpBLBANBm+0F5/OQ
	 HLHUwA5IrwGV2nE8z2OVBdfp+rdgacxVa8pd2W+ozBqvnbouCLemCEZjmctEpjV5hg
	 LAsXpQItY7eAm379/J05mJnGS/FU/y60r1HsIWV20aorQ7cz2QurMzYHQClc55QzHb
	 0wGnJfGiTCstd+0ioFZODONCzVThQCqr/9GhmSBAbZhryLCH8aD42B0AmINmd4laH/
	 odgE+fOFaBEig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXD-00000005hx6-0dL6;
	Mon, 26 Jan 2026 12:17:35 +0000
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
Subject: [PATCH 15/20] KVM: arm64: Get rid of FIXED_VALUE altogether
Date: Mon, 26 Jan 2026 12:16:49 +0000
Message-ID: <20260126121655.1641736-16-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69139-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BF6AB881C6
X-Rspamd-Action: no action

We have now killed every occurrences of FIXED_VALUE, and we can therefore
drop the whole infrastructure. Good riddance.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 187d047a9cf4a..28e534f2850ea 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -22,7 +22,7 @@ struct reg_bits_to_feat_map {
 
 #define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
 #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
-#define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
+#define	FORCE_RESx	BIT(2)	/* Unconditional RESx */
 #define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bits */
 #define	AS_RES1		BIT(4)	/* RES1 when not supported */
 #define	REQUIRES_E2H1	BIT(5)	/* Add HCR_EL2.E2H RES1 as a pre-condition */
@@ -30,7 +30,6 @@ struct reg_bits_to_feat_map {
 #define	RES0_WHEN_E2H1	BIT(7)	/* RES0 when E2H=1 and not supported */
 #define	RES1_WHEN_E2H0	BIT(8)	/* RES1 when E2H=0 and not supported */
 #define	RES1_WHEN_E2H1	BIT(9)	/* RES1 when E2H=1 and not supported */
-#define	FORCE_RESx	BIT(10)	/* Unconditional RESx */
 
 	unsigned long	flags;
 
@@ -43,7 +42,6 @@ struct reg_bits_to_feat_map {
 			s8	lo_lim;
 		};
 		bool	(*match)(struct kvm *);
-		bool	(*fval)(struct kvm *, struct resx *);
 	};
 };
 
@@ -76,13 +74,6 @@ struct reg_feat_map_desc {
 		.lo_lim	= id ##_## fld ##_## lim	\
 	}
 
-#define __NEEDS_FEAT_2(m, f, w, fun, dummy)		\
-	{						\
-		.w	= (m),				\
-		.flags = (f) | CALL_FUNC,		\
-		.fval = (fun),				\
-	}
-
 #define __NEEDS_FEAT_1(m, f, w, fun)			\
 	{						\
 		.w	= (m),				\
@@ -96,9 +87,6 @@ struct reg_feat_map_desc {
 #define NEEDS_FEAT_FLAG(m, f, ...)			\
 	__NEEDS_FEAT_FLAG(m, f, bits, __VA_ARGS__)
 
-#define NEEDS_FEAT_FIXED(m, ...)			\
-	__NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
-
 #define NEEDS_FEAT_MASKS(p, ...)				\
 	__NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
 
@@ -1306,16 +1294,10 @@ struct resx compute_resx_bits(struct kvm *kvm,
 		if (map[i].flags & exclude)
 			continue;
 
-		switch (map[i].flags & (CALL_FUNC | FIXED_VALUE)) {
-		case CALL_FUNC | FIXED_VALUE:
-			map[i].fval(kvm, &resx);
-			continue;
-		case CALL_FUNC:
+		if (map[i].flags & CALL_FUNC)
 			match = map[i].match(kvm);
-			break;
-		default:
+		else
 			match = idreg_feat_match(kvm, &map[i]);
-		}
 
 		if (map[i].flags & REQUIRES_E2H1)
 			match &= !e2h0;
-- 
2.47.3


