Return-Path: <kvm+bounces-69891-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yI/lNXPwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69891-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B4DD041B
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DC8203008C9E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD7838E100;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gm7diUWV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26D0387573;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057822; cv=none; b=TXW9aCPxhtsjFkC1xp8kN/osPBuf/S4us5bKIbOxesM5vlA5bIGKlG+XH54f164aepQQCRMJcUNIXcL4uThERG4Qazn97Pjz4IkhQ55NC/egFJ8nTHZMBtIB3M6ASHAmW/jbG7RdDbEDuhfCIAJcdYqT1DYd3x9ZKdv0eKNoiOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057822; c=relaxed/simple;
	bh=QVby4YrVM8+eywzceY0v/F4G4GfR670N9gJEuqhI6FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVmXVThY9sd8Wv1wis0SlFSrXKTcNJDiywUzlINNJlfLONsuhKZp5nbCp9NNzKh7aYIuJke1HUVAAaNvYT34wSa/lfpG50lcYcmk20DETWBZ1JtItqAmnxO9FLI7K/oGiOI8FTszsn/Nqv8Out0vhihNQsjgK/re0tjO/LU4cuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gm7diUWV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F54BC19422;
	Mon,  2 Feb 2026 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057822;
	bh=QVby4YrVM8+eywzceY0v/F4G4GfR670N9gJEuqhI6FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm7diUWVnRxosP3YK6B4OanLrPZjUw0bLTc2zkeUhHd/ncmdFUYAQIb2nPQvCrTFa
	 N/GTrbcMZoG1+GUhtyWxyOmmW2SIFXSYy2QrPJC7e/4h7r0LK7YhlIU2vM9gfk0d1C
	 AtaHZ3JJ5LWsikNNq5P1sPPFAXVFHmu/pkNEgtaAlzI9XmwXnNaogHPYOutdqpOfRD
	 FYerzqpz1ZLkO9ayHVUKtv7SQ6CG1PGE59iLib5k9oNmDJktYIXP4lWOLp0/yAc1vY
	 Xswvqlnx5xvl0E4VVWpXRcGy4Fn7jAq0MWKCszh+/S1K9vMaqrbxH04r0pIFOQB6d5
	 y5tGxEQ5hRiyg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmytg-00000007sAy-3HxM;
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
Subject: [PATCH v2 09/20] KVM: arm64: Convert HCR_EL2.RW to AS_RES1
Date: Mon,  2 Feb 2026 18:43:18 +0000
Message-ID: <20260202184329.2724080-10-maz@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69891-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[hcr_el2.rw:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 01B4DD041B
X-Rspamd-Action: no action

Now that we have the AS_RES1 constraint, it becomes trivial to express
the HCR_EL2.RW behaviour.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 2ca85c986ff14..eefd2e6a38a1f 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -389,19 +389,6 @@ static bool feat_vmid16(struct kvm *kvm)
 	return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
 }
 
-static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
-{
-	/* This is purely academic: AArch32 and NV are mutually exclusive */
-	if (bits) {
-		if (kvm_has_feat(kvm, FEAT_AA32EL1))
-			*bits &= ~HCR_EL2_RW;
-		else
-			*bits |= HCR_EL2_RW;
-	}
-
-	return true;
-}
-
 static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
 {
 	if (bits) {
@@ -967,7 +954,7 @@ static const DECLARE_FEAT_MAP(hcrx_desc, __HCRX_EL2,
 
 static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_TID0, FEAT_AA32EL0),
-	NEEDS_FEAT_FIXED(HCR_EL2_RW, compute_hcr_rw),
+	NEEDS_FEAT_FLAG(HCR_EL2_RW, AS_RES1, FEAT_AA32EL1),
 	NEEDS_FEAT(HCR_EL2_HCD, not_feat_aa64el3),
 	NEEDS_FEAT(HCR_EL2_AMO		|
 		   HCR_EL2_BSU		|
-- 
2.47.3


