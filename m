Return-Path: <kvm+bounces-69137-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKrCHghcd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69137-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1101688208
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:20:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A6893086902
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74CF3385BE;
	Mon, 26 Jan 2026 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTAdc9Tz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AFC336EC9;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429856; cv=none; b=CtqZYgdwFsk+yLx+MAjUypAAuiNY2dhAPiyZXV9JOk2efwmlJ9gsBD0enKtR2BmXVGVPj0QjbNyWKw7yiYH8DMmgq2LHjHrERLYRFeVDfZedqkgMk+PtAbzP3L0jCOtV4mli1AmMWXwXHvor0pSojHcQqtmR8fX3GWjZPnzJfKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429856; c=relaxed/simple;
	bh=mUisdlIwx2NvdW2eeUH/yAqtU/GwtIf2QebGFR6FEio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4FR8nrYoYK191FRalzBQfAEyVzWofusCDapOlhygUGIE6P15WjUlznp5Ns0QsSLl5FZCWH0Jkbosa9mbK2x3m+M+uRDy111GHhjVYcOt7K4vHDLxnw+f1hMTDtmUtHEYdriqUEsFltLbCzq2z1GRlPWHo0EOiCmO3d14OtHVAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTAdc9Tz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E13C2BC9E;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429856;
	bh=mUisdlIwx2NvdW2eeUH/yAqtU/GwtIf2QebGFR6FEio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTAdc9TzjwpTXYOTaUy+HuSdSZVTp2/IDbgCm4ddtLb45RW5I9owFvIHKW8iEQazY
	 MOs+UIMku8aj1PUrRIq6hGJNF6ctDqC8RU8spSPgK52pa8xl66UyBraxViWxyOdEpP
	 sw1jl9AUjIraoe3VDHykts68HrxupSk7bfBsoQpJZKiOYr12idQpDtq5i8pAd9uKlT
	 pjpaod/8TNuW5zbI2gIwACcAgykOSJZEhnP3LX9vAFBYNrX7lpng4E2ElJUvfSnYIY
	 g+CYoFbswpNOa4CiYCNwUmdLVkc1kHpwVnUJHhwnqH2XEGKOfviVh+s9Esb3PV9+Mb
	 1jVXN83afteVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXC-00000005hx6-3uKQ;
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
Subject: [PATCH 14/20] KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
Date: Mon, 26 Jan 2026 12:16:48 +0000
Message-ID: <20260126121655.1641736-15-maz@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69137-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 1101688208
X-Rspamd-Action: no action

Now that we can link the RESx behaviour with the value of HCR_EL2.E2H,
we can trivially express the tautological constraint that makes E2H
a reserved value at all times.

Fun, isn't it?

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index d5871758f1fcc..187d047a9cf4a 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -394,16 +394,6 @@ static bool feat_vmid16(struct kvm *kvm)
 	return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
 }
 
-static bool compute_hcr_e2h(struct kvm *kvm, struct resx *bits)
-{
-	if (kvm_has_feat(kvm, FEAT_E2H0))
-		bits->res0 |= HCR_EL2_E2H;
-	else
-		bits->res1 |= HCR_EL2_E2H;
-
-	return true;
-}
-
 static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
 	NEEDS_FEAT(HFGRTR_EL2_nAMAIR2_EL1	|
 		   HFGRTR_EL2_nMAIR2_EL1,
@@ -1023,7 +1013,8 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_TWEDEL	|
 		   HCR_EL2_TWEDEn,
 		   FEAT_TWED),
-	NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
+	NEEDS_FEAT_FLAG(HCR_EL2_E2H, RES0_WHEN_E2H0 | RES1_WHEN_E2H1,
+			enforce_resx),
 	FORCE_RES0(HCR_EL2_RES0),
 	FORCE_RES1(HCR_EL2_RES1),
 };
-- 
2.47.3


