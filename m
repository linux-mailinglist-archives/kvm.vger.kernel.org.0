Return-Path: <kvm+bounces-69889-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8L9qHHDxgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69889-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:48:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A49D04BE
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E7E8306B9FD
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B868238BF9C;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwPWw5v/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470383803EF;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057822; cv=none; b=uIm5mJU7UqvFsg5pL8ivDCEMMYWq/7BIM9CWUrjxL2PDFlTNXijdVduNwVmdqT8+QPlpp2rsf2ghfEDKOFEqFX/PcZwYiGrfjlqjJmTFz+/syGcP0tjmKkttSKHfAidxggtohiKf/l/cymTdfMnQLl5FvT2gSwemecpdCUiy0zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057822; c=relaxed/simple;
	bh=5WRJ9oOXrDJEL69hkNzTU0wxUvuUyWon3NrR6orDMyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqDv9NccFdIa/EzaVXfIeUWI+7CCorpjWDJKWqgFbeS/YlLwExCC5/9bX76krtfFZX7bBhj5QffgLED+FB1KAhqT6/Wgy+KEjDCnTOtLudSAtK9npB9rwtt69/GU1v0o4I/TeE6VAltx5RLHqyn4YF8iggnPzOc5csAlpEf7txE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwPWw5v/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2117FC2BC87;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057822;
	bh=5WRJ9oOXrDJEL69hkNzTU0wxUvuUyWon3NrR6orDMyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwPWw5v/fHMuZzVX/pKPNvaC5m6Hbp+9W88GsIZUeuGP97ac6sSDcK+JDUet49QQy
	 h039DI2NRxWyIg23TAtz6rbmk4NbtzWMCi/FODdLwh1ZOpy1wWb7fatOHX77QuQ7D9
	 PFExbJCeOQjsU8bxeiEyZn3MZvVpuvZ4RbFxLHkxXpznYy3RQbNTwNdjSeTgDoJ7fx
	 /Sn/aLaSoBw6FalnDyG2lPXa+42Vxiap8hhgnaLviISCI0A/jzH+Prbre6tjgU1Sps
	 wijzTb0Qd6sig9S5pNrZ5URrDXcKV3I9BsnBhR3xk1Q4GezG+dfvT/mdrBlBqI5wq/
	 4liuv3Hq4//3Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmytg-00000007sAy-1OCL;
	Mon, 02 Feb 2026 18:43:40 +0000
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
Subject: [PATCH v2 07/20] KVM: arm64: Allow RES1 bits to be inferred from configuration
Date: Mon,  2 Feb 2026 18:43:16 +0000
Message-ID: <20260202184329.2724080-8-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69889-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 62A49D04BE
X-Rspamd-Action: no action

So far, when a bit field is tied to an unsupported feature, we set
it as RES0. This is almost correct, but there are a few exceptions
where the bits become RES1.

Add a AS_RES1 qualifier that instruct the RESx computing code to
simply do that.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 9ad7eb5f4b981..bc8e6460c3fb1 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -24,6 +24,7 @@ struct reg_bits_to_feat_map {
 #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
 #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
 #define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bits */
+#define	AS_RES1		BIT(4)	/* RES1 when not supported */
 
 	unsigned long	flags;
 
@@ -1315,8 +1316,12 @@ static struct resx __compute_fixed_bits(struct kvm *kvm,
 		else
 			match = idreg_feat_match(kvm, &map[i]);
 
-		if (!match || (map[i].flags & FIXED_VALUE))
-			resx.res0 |= reg_feat_map_bits(&map[i]);
+		if (!match || (map[i].flags & FIXED_VALUE)) {
+			if (map[i].flags & AS_RES1)
+ 				resx.res1 |= reg_feat_map_bits(&map[i]);
+			else
+				resx.res0 |= reg_feat_map_bits(&map[i]);
+		}
 	}
 
 	return resx;
-- 
2.47.3


