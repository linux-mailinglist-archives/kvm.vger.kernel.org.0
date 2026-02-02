Return-Path: <kvm+bounces-69897-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AjbIvbwgGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69897-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:46:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 437F8D047B
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ED5343045E13
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001C0374725;
	Mon,  2 Feb 2026 18:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Msu0h31e"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E13638E115;
	Mon,  2 Feb 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057824; cv=none; b=kusTDHzPmUw7rKUdtem3vC6DvF/Q+mI5MWzrbSW3LPlDDD7E5yB5332BtrW7eckby2E+7Z7UxkyEJu+pT3sw4aWto9SJd4vK9b+2A+AqYQhqPM/Xe3p//47YAGa2L53E/QM8iLy0HLHAtAIDMFcA9gbX0EuEKrewZRbbp4x8Gpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057824; c=relaxed/simple;
	bh=dkRNnZvotmXRB/vj0OlRDTCSt4bIScd43i7BNBYwMwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWDPgj10ntW+3ELw4IywgoAN1YiyJFgsP4EwcOYwlncD9H97Oq0+OamtPFkOrqHVCatDbcd1TAKn7ZOgSn3yqegEKfUBBTAI5FI7izZFW4IM4VXSfZuxvMzPd4rhOc74pOKupeKOEiJFOgNm0aOgz7/+d4F11BqrYmdNifr1Hu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Msu0h31e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A7FC2BC86;
	Mon,  2 Feb 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770057823;
	bh=dkRNnZvotmXRB/vj0OlRDTCSt4bIScd43i7BNBYwMwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Msu0h31e8XpNNom4YOWsQP8CdQpY2GxdLi0l9hkeEVElVUFyWWA0lP0FVGIko3y3F
	 FsP+e7R4yrXGrSLRNYYQuur/oFE+trrp+HIOAlxByxwKU74w8+pwgkKAehHt8d/LW6
	 wwiT3EekUJQB/69BLqFU7ofATQFnGzZPqODKWnOELiQgFl3tRrSb2kiYiYDA0l5ysA
	 FMI3j7MVgrdVxXa5P0T4aFb0UipajMS3GFq685BPi0+mjHdkUSZYE2K2wDWgb2YgbB
	 zWinAA4y76pbsIDvhHISWbWv7PdU3zAFBG4zncXIChrUC0HKdgJ2zdbUmPTFr7r4AF
	 WtoRM4daO14Kw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vmyth-00000007sAy-3pZl;
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
Subject: [PATCH v2 14/20] KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
Date: Mon,  2 Feb 2026 18:43:23 +0000
Message-ID: <20260202184329.2724080-15-maz@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69897-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 437F8D047B
X-Rspamd-Action: no action

Now that we can link the RESx behaviour with the value of HCR_EL2.E2H,
we can trivially express the tautological constraint that makes E2H
a reserved value at all times.

Fun, isn't it?

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 474d5c8038c24..ae72f3b8e50b1 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -388,16 +388,6 @@ static bool feat_vmid16(struct kvm *kvm)
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
@@ -1017,7 +1007,7 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_TWEDEL	|
 		   HCR_EL2_TWEDEn,
 		   FEAT_TWED),
-	NEEDS_FEAT_FIXED(HCR_EL2_E2H, compute_hcr_e2h),
+	NEEDS_FEAT_FLAG(HCR_EL2_E2H, RES1_WHEN_E2H1 | FORCE_RESx),
 	FORCE_RES0(HCR_EL2_RES0),
 	FORCE_RES1(HCR_EL2_RES1),
 };
-- 
2.47.3


