Return-Path: <kvm+bounces-69138-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCjEIx1cd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69138-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E52B788217
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3B22730B450E
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1191C338934;
	Mon, 26 Jan 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ire3hi/h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB9C338593;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429857; cv=none; b=B42UDCEjciXCjFVU4oAe6t/nZ7ww1l/FlZZ9io877rVNkeGEdR6VSdbyU7z4Xfi6IJO3D+enQ1RiZy0P1p3izCm3/2Py+hLhbuJ6ZBSyCrOw3qFACzv+a+9JPtmurVQs2PAI9YDjJ/oEAkqc+Gfo+OM7pTZwabMUOtWCkV260uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429857; c=relaxed/simple;
	bh=T/aXPl0EJXP+3NGbLsvmVd6rADMrOniMqL+ixtsc2Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNswI2TmmHUF/nX5NBJvLhFpVx2dqomTXUwjVe1tHeLqKoAiLeWsCaA4jEOA7D5bjRDWYiqZzRa8GpeMxuk6P/b4QoggkksRTwc4fx2JkU69vfHBe76YaLmBpL4PFKUJhvN58XUXAbAqXCqL2TUk/f3aUUnhBmVVSiF5es38qq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ire3hi/h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1E5C116C6;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429857;
	bh=T/aXPl0EJXP+3NGbLsvmVd6rADMrOniMqL+ixtsc2Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ire3hi/hUEgNatqj4helxMy+UiaMU0SN6TVGNlD/hy6TN9OPIsTAK8FLg65ALE+s0
	 9Wupdn7YI4VkdaVRehdoR1g/zqj7K0I63M7q0UOrvWSFfoPAZNXE406g/yVgTrF1tD
	 Jmc6cYuFU+i7XD6jhPaB1SZKiCstZ8ICTGyKJkN/xHVtHQHa6J4NicE2d00IRRi70H
	 Kn+yClVeJN15PZHufT60Kl6+c7AUUPB4hvVJ1BIsNN0QSz8mKZ8EBXUm+4I00USXhx
	 FCXC9uHRCs7evfhYaW5wqvhAoRj8wy6Qy0krpFj6MUU4ZStvucH7KxpVmxXSwuGABb
	 YqfAdxPYP62jA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXD-00000005hx6-1YtQ;
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
Subject: [PATCH 16/20] KVM: arm64: Simplify handling of full register invalid constraint
Date: Mon, 26 Jan 2026 12:16:50 +0000
Message-ID: <20260126121655.1641736-17-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69138-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E52B788217
X-Rspamd-Action: no action

Now that we embed the RESx bits in the register description, it becomes
easier to deal with registers that are simply not valid, as their
existence is not satisfied by the configuration (SCTLR2_ELx without
FEAT_SCTLR2, for example). Such registers essentially become RES0 for
any bit that wasn't already advertised as RESx.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 28e534f2850ea..0c037742215ac 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1332,7 +1332,7 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
 				 const struct reg_feat_map_desc *r,
 				 unsigned long require, unsigned long exclude)
 {
-	struct resx resx, tmp;
+	struct resx resx;
 
 	resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
 				 require, exclude);
@@ -1342,11 +1342,14 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
 		resx.res1 |= r->feat_map.masks->res1;
 	}
 
-	tmp = compute_resx_bits(kvm, &r->feat_map, 1, require, exclude);
-
-	resx.res0 |= tmp.res0;
-	resx.res0 |= ~reg_feat_map_bits(&r->feat_map);
-	resx.res1 |= tmp.res1;
+	/*
+	 * If the register itself was not valid, all the non-RESx bits are
+	 * now considered RES0 (this matches the behaviour of registers such
+	 * as SCTLR2 and TCR2). Weed out any potential (though unlikely)
+	 * overlap with RES1 bits coming from the previous computation.
+	 */
+	resx.res0 |= compute_resx_bits(kvm, &r->feat_map, 1, require, exclude).res0;
+	resx.res1 &= ~resx.res0;
 
 	return resx;
 }
-- 
2.47.3


