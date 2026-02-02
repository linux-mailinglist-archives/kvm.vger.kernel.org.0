Return-Path: <kvm+bounces-69892-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iIC/LZDwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69892-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 366B6D0439
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 03F47304D1ED
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB252F39CE;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IufLkw0J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67038884E;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057822; cv=none; b=EmKxsbKi5LjBmVhIdFNcKN4FNRxXPB8G4KlY0TZG5bBlGMyumN8OKh9s/l2PR/KJlx7RwaOb9zEkgaPKSi31Zitn6n1wKrxVEQsoPI1IeGBEjGCjy9tf0PM5sENMJFyRb8a/Lgcl9qYoIi/GEp6822n/vjX8YqoONIA3u8YT7dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057822; c=relaxed/simple;
	bh=trPuFvSUNip1Vqpex0mF17jqqh+TkzJfJK6QnHwmIbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzu+b1tZ3kjX/yqo8Oqso1jBhLr5ESIAeELo1vDFdD4Mgm7GnEpcJXhDHuScc6N/RSqgo1aAJoy7I01D14dKqIeY59dYpE2se19Zzpz8yoUrvQBJorzzAdh4nBC7wLQuIleihf5dRWUufhfUepX4nGXwZkWfQRtzbIB9oBWMT08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IufLkw0J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0181C116C6;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057822;
	bh=trPuFvSUNip1Vqpex0mF17jqqh+TkzJfJK6QnHwmIbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IufLkw0J2bS/yOSDzssJUdl3Cl7IjeI86kpbZEJ3iq9PulRC/Hs64cti3oLl54+Wu
	 d2sBrz5myI1bxT7OSsYcFInFtxTFyzUts87VG/hUL5Zeqqy3j8dxk9+NT7qzwR6+0u
	 kUYYeL3F5uThCBfwoFgrSpl0RSkU9B6lgZJBW97beWafPZN92CqXF3vw9eAUi+dHbk
	 z+ubT8Gy8McjFIr9Cnl3EYyqkO9PwMZ4mZRnehID5uX2YjYbJn0aqecgn+x4voCE0w
	 NQ5btUhXDrEV1poU+qQIMVtm1orxOVKIIZmlhZnGV7i3gg6DI1+NKCdocZkQJocRpJ
	 XOncTEnvseBoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmyth-00000007sAy-01rE;
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
Subject: [PATCH v2 10/20] KVM: arm64: Simplify FIXED_VALUE handling
Date: Mon,  2 Feb 2026 18:43:19 +0000
Message-ID: <20260202184329.2724080-11-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69892-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 366B6D0439
X-Rspamd-Action: no action

The FIXED_VALUE qualifier (mostly used for HCR_EL2) is pointlessly
complicated, as it tries to piggy-back on the previous RES0 handling
while being done in a different phase, on different data.

Instead, make it an integral part of the RESx computation, and allow
it to directly set RESx bits. This is much easier to understand.

It also paves the way for some additional changes to that will allow
the full removal of the FIXED_VALUE handling.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 66 ++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index eefd2e6a38a1f..e41c2b83bc945 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -37,7 +37,7 @@ struct reg_bits_to_feat_map {
 			s8	lo_lim;
 		};
 		bool	(*match)(struct kvm *);
-		bool	(*fval)(struct kvm *, u64 *);
+		bool	(*fval)(struct kvm *, struct resx *);
 	};
 };
 
@@ -389,14 +389,12 @@ static bool feat_vmid16(struct kvm *kvm)
 	return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
 }
 
-static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
+static bool compute_hcr_e2h(struct kvm *kvm, struct resx *bits)
 {
-	if (bits) {
-		if (kvm_has_feat(kvm, FEAT_E2H0))
-			*bits &= ~HCR_EL2_E2H;
-		else
-			*bits |= HCR_EL2_E2H;
-	}
+	if (kvm_has_feat(kvm, FEAT_E2H0))
+		bits->res0 |= HCR_EL2_E2H;
+	else
+		bits->res1 |= HCR_EL2_E2H;
 
 	return true;
 }
@@ -1280,12 +1278,11 @@ static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map
 	}
 }
 
-static struct resx __compute_fixed_bits(struct kvm *kvm,
-					const struct reg_bits_to_feat_map *map,
-					int map_size,
-					u64 *fixed_bits,
-					unsigned long require,
-					unsigned long exclude)
+static struct resx compute_resx_bits(struct kvm *kvm,
+				     const struct reg_bits_to_feat_map *map,
+				     int map_size,
+				     unsigned long require,
+				     unsigned long exclude)
 {
 	struct resx resx = {};
 
@@ -1298,14 +1295,18 @@ static struct resx __compute_fixed_bits(struct kvm *kvm,
 		if (map[i].flags & exclude)
 			continue;
 
-		if (map[i].flags & CALL_FUNC)
-			match = (map[i].flags & FIXED_VALUE) ?
-				map[i].fval(kvm, fixed_bits) :
-				map[i].match(kvm);
-		else
+		switch (map[i].flags & (CALL_FUNC | FIXED_VALUE)) {
+		case CALL_FUNC | FIXED_VALUE:
+			map[i].fval(kvm, &resx);
+			continue;
+		case CALL_FUNC:
+			match = map[i].match(kvm);
+			break;
+		default:
 			match = idreg_feat_match(kvm, &map[i]);
+		}
 
-		if (!match || (map[i].flags & FIXED_VALUE)) {
+		if (!match) {
 			if (map[i].flags & AS_RES1)
  				resx.res1 |= reg_feat_map_bits(&map[i]);
 			else
@@ -1316,16 +1317,6 @@ static struct resx __compute_fixed_bits(struct kvm *kvm,
 	return resx;
 }
 
-static struct resx compute_resx_bits(struct kvm *kvm,
-				     const struct reg_bits_to_feat_map *map,
-				     int map_size,
-				     unsigned long require,
-				     unsigned long exclude)
-{
-	return __compute_fixed_bits(kvm, map, map_size, NULL,
-				    require, exclude | FIXED_VALUE);
-}
-
 static struct resx compute_reg_resx_bits(struct kvm *kvm,
 					 const struct reg_feat_map_desc *r,
 					 unsigned long require,
@@ -1366,16 +1357,6 @@ static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
 	return resx.res0 | resx.res1;
 }
 
-static struct resx compute_reg_fixed_bits(struct kvm *kvm,
-					  const struct reg_feat_map_desc *r,
-					  u64 *fixed_bits,
-					  unsigned long require,
-					  unsigned long exclude)
-{
-	return __compute_fixed_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
-				    fixed_bits, require | FIXED_VALUE, exclude);
-}
-
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 {
 	u64 val = 0;
@@ -1415,7 +1396,6 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 
 struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 {
-	u64 fixed = 0, mask;
 	struct resx resx;
 
 	switch (reg) {
@@ -1457,10 +1437,8 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 		resx.res1 |= __HCRX_EL2_RES1;
 		break;
 	case HCR_EL2:
-		mask = compute_reg_fixed_bits(kvm, &hcr_desc, &fixed, 0, 0).res0;
 		resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
-		resx.res0 |= (mask & ~fixed);
-		resx.res1 |= HCR_EL2_RES1 | (mask & fixed);
+		resx.res1 |= HCR_EL2_RES1;
 		break;
 	case SCTLR2_EL1:
 	case SCTLR2_EL2:
-- 
2.47.3


