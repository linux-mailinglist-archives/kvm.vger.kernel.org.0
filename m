Return-Path: <kvm+bounces-69896-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8OJtHvHwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69896-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:46:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E4BD046D
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:46:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5ECC23063F58
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC81D38E139;
	Mon,  2 Feb 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cH1X2uTN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95F38E114;
	Mon,  2 Feb 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057824; cv=none; b=GW/7YrXgETFsSRpOqThrui01Rlc8XSCEpUCVcW8r/NllA13FuMrwojiHderqCJeX7HA+HVXF2zLQf9ykhNSSUgi8mUjhiRTRUD1XsVqMgsyomGwnkMsE5yM6MmGlba1dUAyRm5Oeq0MhUH2affTZLJu87iRTVKNRip1bxl1EFs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057824; c=relaxed/simple;
	bh=fr7um36i7FSrPooYd82g3BcIiUsju9J2xc0y7Xw8W7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvDj+DvNg+VZe9Vd7IVIFazFGJpl3YcLu/V8JyuwJ4Ri4GUSN9/YFy0bRgZfv6pSTT0KSpWpG4m+zw5lh+sqsEx0/kMB/ne1UfeNFj8bo+dGzh1VGBoB8MNYTjZhkrP2IHxD+80+IamUytTD3nAAQbEgrRGZ6czK1Mc0rarzxLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cH1X2uTN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0746C2BCB1;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057824;
	bh=fr7um36i7FSrPooYd82g3BcIiUsju9J2xc0y7Xw8W7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cH1X2uTN7atJ8JexA/Vzidx3Lin5iIV/S5xFbXlXxVNxxFaOYIUfWXk2hUhJxea3c
	 RHsVthAe8va6HDjQj7HD2o6YzzTA3iypubr5UiInBpFmDPfzYNaDqoUgyAgM+PDqcX
	 hBCu55m6irwdiHmowafLnaN/dgjalMmKkm3xTTBn4gsaz1Jr0ILV+3IomPv6/bwWuW
	 Lyv7w/i/reop2ZPQKgEldJSnKbm4Mm+dWliIcqZ+nT75LcVML3DZeoLLm6JiCHxpRb
	 FJi9FVrAtMACpa0pXHTdolZvdCg/3rDlbepteNsJOGMmq6CvsDpgeTBrLuCMDugzaN
	 HbwHLR+6hjfnw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmyti-00000007sAy-0iZ1;
	Mon, 02 Feb 2026 18:43:42 +0000
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
Subject: [PATCH v2 15/20] KVM: arm64: Get rid of FIXED_VALUE altogether
Date: Mon,  2 Feb 2026 18:43:24 +0000
Message-ID: <20260202184329.2724080-16-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202184329.2724080-1-maz@kernel.org>
References: <20260202184329.2724080-1-maz@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69896-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E5E4BD046D
X-Rspamd-Action: no action

We have now killed every occurrences of FIXED_VALUE, and we can therefore
drop the whole infrastructure. Good riddance.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index ae72f3b8e50b1..274ae049c4b33 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -22,13 +22,12 @@ struct reg_bits_to_feat_map {
 
 #define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
 #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
-#define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
+#define	FORCE_RESx	BIT(2)	/* Unconditional RESx */
 #define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bits */
 #define	AS_RES1		BIT(4)	/* RES1 when not supported */
 #define	REQUIRES_E2H1	BIT(5)	/* Add HCR_EL2.E2H RES1 as a pre-condition */
 #define	RES1_WHEN_E2H0	BIT(6)	/* RES1 when E2H=0 and not supported */
 #define	RES1_WHEN_E2H1	BIT(7)	/* RES1 when E2H=1 and not supported */
-#define	FORCE_RESx	BIT(8)	/* Unconditional RESx */
 
 	unsigned long	flags;
 
@@ -41,7 +40,6 @@ struct reg_bits_to_feat_map {
 			s8	lo_lim;
 		};
 		bool	(*match)(struct kvm *);
-		bool	(*fval)(struct kvm *, struct resx *);
 	};
 };
 
@@ -74,13 +72,6 @@ struct reg_feat_map_desc {
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
@@ -100,9 +91,6 @@ struct reg_feat_map_desc {
 #define NEEDS_FEAT_FLAG(m, f, ...)			\
 	__NEEDS_FEAT_FLAG(m, f, bits, __VA_ARGS__)
 
-#define NEEDS_FEAT_FIXED(m, ...)			\
-	__NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
-
 #define NEEDS_FEAT_MASKS(p, ...)				\
 	__NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
 
@@ -1303,19 +1291,12 @@ static struct resx compute_resx_bits(struct kvm *kvm,
 		if (map[i].flags & exclude)
 			continue;
 
-		switch (map[i].flags & (FORCE_RESx | CALL_FUNC | FIXED_VALUE)) {
-		case CALL_FUNC | FIXED_VALUE:
-			map[i].fval(kvm, &resx);
-			continue;
-		case CALL_FUNC:
-			match = map[i].match(kvm);
-			break;
-		case FORCE_RESx:
+		if (map[i].flags & FORCE_RESx)
 			match = false;
-			break;
-		default:
+		else if (map[i].flags & CALL_FUNC)
+			match = map[i].match(kvm);
+		else
 			match = idreg_feat_match(kvm, &map[i]);
-		}
 
 		if (map[i].flags & REQUIRES_E2H1)
 			match &= !e2h0;
-- 
2.47.3


