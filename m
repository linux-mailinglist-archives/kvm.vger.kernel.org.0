Return-Path: <kvm+bounces-69898-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GJOUM7HxgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69898-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:49:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3560DD04DB
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:49:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F642300EA8A
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698A938E5CC;
	Mon,  2 Feb 2026 18:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfE48p2o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906A438E12B;
	Mon,  2 Feb 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057824; cv=none; b=UGU5UV0naqqUd4KiaItdNXsCBy/XR9vaFvoVluJT1xIl1ua8HgVZMe1OafPPL/eT/FzFbXmf9/IBe8RQ7FMuKGejCudT++rNHgw9gU8NxfKlG7DjsxM37OVYNTZPXWvx099ccgt7vDZIyGJTOIgAYWnhtDWN92J3OnUV7EvA2DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057824; c=relaxed/simple;
	bh=flpwAOTJ4OOyVy4Gw7W9QK7+pIUWmW+MlDECJb84DtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGtmXkVhsvT+BBW/J9h6tylU9TffD5wWEnB6ZLauZtGGFcaFhp1ciAAw+Nd23BiUYVDAY+fHXiGUYX53Lb53B5HA5LB+Tq+0ftd70tcLBUNEbYgXNRs2hgkjP0QSGWHlXpUn6TkfnmsQpszYXGU9f8VziMlEopWfMp8n+Cxvig0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfE48p2o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A45C2BCB3;
	Mon,  2 Feb 2026 18:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057824;
	bh=flpwAOTJ4OOyVy4Gw7W9QK7+pIUWmW+MlDECJb84DtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfE48p2o7ScQ3aug//mIG05qV0SrsKUrVIvwjjGTKDUXJMFAnUlRHo+ee8vXVhsyp
	 aBZ+uiUasmhh+wubzuQqf7Zp/XB7WCITbnideD7OD8PMG5lpCUB7GqWFDXAUUlxN9H
	 QH5uUOEmD8ZuhXXxkRDuAKRCSzqqKrm+dmNr9pYfAV8Irh7vvk2fAPa08wDGk1IBCQ
	 6HXFRn+c6Q8cfdoodvBvau977U17gq75tVXUZrqAoqsJmLIJ7tNddcnaBYlSjtyOKK
	 iMhR2aPehuu83glEJ0RYl+XoXqk9p0x+VLdgPTJ8t0vEReE996FILFjrwEPahMsT+5
	 +jLMBIsw1BhUQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmyti-00000007sAy-1jkE;
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
Subject: [PATCH v2 16/20] KVM: arm64: Simplify handling of full register invalid constraint
Date: Mon,  2 Feb 2026 18:43:25 +0000
Message-ID: <20260202184329.2724080-17-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69898-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 3560DD04DB
X-Rspamd-Action: no action

Now that we embed the RESx bits in the register description, it becomes
easier to deal with registers that are simply not valid, as their
existence is not satisfied by the configuration (SCTLR2_ELx without
FEAT_SCTLR2, for example). Such registers essentially become RES0 for
any bit that wasn't already advertised as RESx.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 274ae049c4b33..b37b40744db94 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1321,7 +1321,7 @@ static struct resx compute_reg_resx_bits(struct kvm *kvm,
 					 unsigned long require,
 					 unsigned long exclude)
 {
-	struct resx resx, tmp;
+	struct resx resx;
 
 	resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
 				 require, exclude);
@@ -1331,11 +1331,14 @@ static struct resx compute_reg_resx_bits(struct kvm *kvm,
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


