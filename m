Return-Path: <kvm+bounces-69894-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IbpMYjwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69894-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E18CFD0431
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2EF64300B47D
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647163803EF;
	Mon,  2 Feb 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1JyTk6U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880DD2F363C;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057823; cv=none; b=qagNBRJon6tsA2MMfTHKGHIEOfgrQZwkhxUAlM3zD84xAy0HsBxp4++DMjOkS3yhYjvkOlrSuqhgIR5U/rzwpb7I6KTd8piSmdA2Pl96v+l6SOcguESeRvp3GeX+s9HKVlggiAQ751SjuT5wM8hFp62yYFSIcaOPsATyrwBOSDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057823; c=relaxed/simple;
	bh=Dz14TSpshifTs7bgDsWKmZsA4vb8qx2yLv+5O8xrkLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7aaW1LV6QeN6+7j2P/pv00DFQIhWb9rP9WeCG3GQ2F01fyXRvDmcO49TYiMAFcTM5ixMjqp2Xk2/PMJxSK2rg8dYqUP+OTP+z56H73RSIe8mZ8X+qsYAXzMRQ+hWAItaUuB2FNEXAJ7BosXfGTarwP24gb0203CHSQz03s2ljM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t1JyTk6U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569D3C2BCAF;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057823;
	bh=Dz14TSpshifTs7bgDsWKmZsA4vb8qx2yLv+5O8xrkLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1JyTk6UrnEKe88Z/FWYYIEAopVWGHvaxWO7WVSX4Pnfl0b62FsOgqJlot6Jih4WI
	 6pWYnJ16HnKsefbY+KYvgDwFbgND2qlOyKlWpeZXCRojVa3MbsESLWnjTGNQvN3Arn
	 opEARE+EDDhtMJ8ySCDssg2cpgCUCUzKgWxvfXd3PhtdgcsTEPe5Wv6jtxAbldOzxj
	 BTN/1yTId8IgNzTcvCZq0ya+TmbTXz2YwBUUgp5t4LbanPhx4MimndomUZs6/HG7Mf
	 4jmFX45qw2GJRzLtx4k5JOxwWkRp8/X9PN27OQzGph3DtLQwSDN26GD/VXQRLn1dwj
	 oKnaWfUvu3qEQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmyth-00000007sAy-1viU;
	Mon, 02 Feb 2026 18:43:41 +0000
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
Subject: [PATCH v2 12/20] KVM: arm64: Add RES1_WHEN_E2Hx constraints as configuration flags
Date: Mon,  2 Feb 2026 18:43:21 +0000
Message-ID: <20260202184329.2724080-13-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69894-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E18CFD0431
X-Rspamd-Action: no action

"Thanks" to VHE, SCTLR_EL2 radically changes shape depending on the
value of HCR_EL2.E2H, as a lot of the bits that didn't have much
meaning with E2H=0 start impacting EL0 with E2H=1.

This has a direct impact on the RESx behaviour of these bits, and
we need a way to express them.

For this purpose, introduce two new constaints that, when the
controlling feature is not present, force the field to RES1 depending
on the value of E2H. Note that RES0 is still implicit,

This allows diverging RESx values depending on the value of E2H,
something that is required by a bunch of SCTLR_EL2 bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 7d133954ae01b..7e8e42c1cee4a 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -26,6 +26,8 @@ struct reg_bits_to_feat_map {
 #define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bits */
 #define	AS_RES1		BIT(4)	/* RES1 when not supported */
 #define	REQUIRES_E2H1	BIT(5)	/* Add HCR_EL2.E2H RES1 as a pre-condition */
+#define	RES1_WHEN_E2H0	BIT(6)	/* RES1 when E2H=0 and not supported */
+#define	RES1_WHEN_E2H1	BIT(7)	/* RES1 when E2H=1 and not supported */
 
 	unsigned long	flags;
 
@@ -1297,10 +1299,14 @@ static struct resx compute_resx_bits(struct kvm *kvm,
 			match &= !e2h0;
 
 		if (!match) {
-			if (map[i].flags & AS_RES1)
- 				resx.res1 |= reg_feat_map_bits(&map[i]);
+			u64 bits = reg_feat_map_bits(&map[i]);
+
+			if ((map[i].flags & AS_RES1)			||
+			    (e2h0 && (map[i].flags & RES1_WHEN_E2H0))	||
+			    (!e2h0 && (map[i].flags & RES1_WHEN_E2H1)))
+				resx.res1 |= bits;
 			else
-				resx.res0 |= reg_feat_map_bits(&map[i]);
+				resx.res0 |= bits;
 		}
 	}
 
-- 
2.47.3


