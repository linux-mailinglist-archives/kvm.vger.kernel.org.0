Return-Path: <kvm+bounces-69141-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gABREDhcd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69141-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:21:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9799988226
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CB69307C767
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A169333984E;
	Mon, 26 Jan 2026 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EKjAvM0a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22EB3358BF;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429857; cv=none; b=bqcVZbVTBkt0xIdesYeOFmBIt2E87cAXfU5cqTdEjOnEZKT50eVIeeiI06y3wz4NhG0+ko2igg+lncgWRxIwE7uz1b6N851OJX13NC4hlwEUVnnYlJSL7Pk3UMOVvndx0BpGOpOYJk2DSsaq1t9M4gX5JvKx5OYMwVJwTvweaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429857; c=relaxed/simple;
	bh=4TIqGuF2iyYVYwENN7mbjyH/PPVrIV5ghM/SJMxsDIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIu0/c+Txb/UkkKv+daXkA3+M1o+OJXlIVgkU8lb/xpzCTpTD5AwEmAe+R3oDcKPlaPiyyyXzbeG5082+YIXiNNuL28caKfRC1hEOWTE4K/Zwzv+NXucElMu1SlyBnX0Ao0N1q0oDpxMhqsylFlzzz908VgZHHnbXclBkuVQdEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EKjAvM0a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F83C116C6;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429857;
	bh=4TIqGuF2iyYVYwENN7mbjyH/PPVrIV5ghM/SJMxsDIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKjAvM0aK44YDcZtBZRR2l7YNBFXPbNHp0f59R2DXNPEmbp38NhexUHaiKwJNDMKZ
	 nW2RpqAL7KoQTpVUiw1eCMbQNnsYjjOgVxL13uyF2IAbfCPW/16ZcIzlif13Vg0i/R
	 8JLbOvP+CNvOCGeF1s4qWJfqHi2Fa30lSMxRGwaplm51YY3KVHG2OSDf8HwPHIu5sF
	 OhzmXOySsvekC/+1sVZ0OJTWcQ0vacR9WpMyGi1TSGfImTAzQTOiaztjNQ38ffhPMN
	 j96AP2Bh1y/stKP/fYxxPypvbVo8Dp+9XfRUZVDk/YVrnUCuGnMZI13C3dOf28A6OH
	 YdFu6x6iOwKWA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXD-00000005hx6-3P9t;
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
Subject: [PATCH 18/20] KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
Date: Mon, 26 Jan 2026 12:16:52 +0000
Message-ID: <20260126121655.1641736-19-maz@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69141-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 9799988226
X-Rspamd-Action: no action

MIOCNCE had the potential to eat your data, and also was never
implemented by anyone. It's been retrospectively removed from
the architecture, and we're happy to follow that lead.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 1 -
 arch/arm64/tools/sysreg | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index f892098b70c0b..eebafb90bcf62 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -944,7 +944,6 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 		   HCR_EL2_FMO		|
 		   HCR_EL2_ID		|
 		   HCR_EL2_IMO		|
-		   HCR_EL2_MIOCNCE	|
 		   HCR_EL2_PTW		|
 		   HCR_EL2_SWIO		|
 		   HCR_EL2_TACR		|
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 650d7d477087e..724e6ad966c20 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3834,8 +3834,7 @@ Field	43	NV1
 Field	42	NV
 Field	41	API
 Field	40	APK
-Res0	39
-Field	38	MIOCNCE
+Res0	39:38
 Field	37	TEA
 Field	36	TERR
 Field	35	TLOR
-- 
2.47.3


