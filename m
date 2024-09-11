Return-Path: <kvm+bounces-26530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF25B9754B9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55840B233F3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161B21AC429;
	Wed, 11 Sep 2024 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEzEej47"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD141AB6C7;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062722; cv=none; b=HJEwWPpQMKeG+PUqfuDFGNngIvo3b2SOh3au7y8LpmXgdVqgePiN238b6qw7XXLHK9QY8ZMFzlg3NoNl2Oxx3B0nii7kZpdWr0o1Hh+OzWTMBNZfGMfbOAgHQ044z0nNptOcYgSz1Hutkd9Dp/HYFk6aUhmwxui9obg/LjfzlbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062722; c=relaxed/simple;
	bh=kzQyDBL04M83PmlLuqMkdL8UeMfmwttAeKfacVKndok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MPaQ951v+QvmtTgcRAKPNDwRqf/aile9Ghb0fihEZbyGrpgQBFWYEcY4TK1Um2e1RA+JgcEoW094SIiTYJVPYO8BCiqxoFG0KbnZ7eTboxCGe9YP3WgF4utHQuq9iwxSyYn3ioRYde/ykYhBD+O+xTgEnR/fMCalvOFOxeUU7SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEzEej47; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1053BC4CEC5;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062722;
	bh=kzQyDBL04M83PmlLuqMkdL8UeMfmwttAeKfacVKndok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEzEej47iR3YkgDHBauu0GgBzrrrY8GGngoAqcg+ysbjHcfiKGO3H683N085vD1pw
	 XWn5p9VzY0Zd3Witrzyf0u2xSsDAcLEUSF7/F+XTa3nywwJ7KtDUnuxlYwEx/oiv2O
	 3IT6w4PPBC8UkS/Ji9yEGAlMxfCxryMBhRJrKxsyjkWUS09q20u6uzMjHFjYWGqkvC
	 5zS1WIZ6A972KDdtYpnm8OsRjE920Z5nfGtAB9z33+4EtK0QAQNosDQzYEKB05969y
	 +dAJ7vjZJ25eE4HvxOgXSr2vEshnV9YHUO0i+Bf+l/azOp4BWFrfDQNb7TNEz06WBW
	 om3ax1A9isVEw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlI-00C7tL-6Y;
	Wed, 11 Sep 2024 14:52:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 19/24] KVM: arm64: Disable hierarchical permissions when S1PIE is enabled
Date: Wed, 11 Sep 2024 14:51:46 +0100
Message-Id: <20240911135151.401193-20-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

S1PIE implicitly disables hierarchical permissions, as specified in
R_JHSVW, by making TCR_ELx.HPDn RES1.

Add a predicate for S1PIE being enabled for a given translation regime,
and emulate this behaviour by forcing the hpd field to true if S1PIE
is enabled for that translation regime.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index d6ee3a5c30bc2..9a922054d76cf 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -91,6 +91,23 @@ static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 o
 	}
 }
 
+static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+		return false;
+
+	switch (regime) {
+	case TR_EL2:
+	case TR_EL20:
+		return vcpu_read_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
+	case TR_EL10:
+		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
+			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1x_PIE);
+	default:
+		BUG();
+	}
+}
+
 static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
 			 struct s1_walk_result *wr, u64 va)
 {
@@ -184,6 +201,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
 		    (va55 ?
 		     FIELD_GET(TCR_HPD1, tcr) :
 		     FIELD_GET(TCR_HPD0, tcr)));
+	/* R_JHSVW */
+	wi->hpd |= s1pie_enabled(vcpu, wi->regime);
 
 	/* Someone was silly enough to encode TG0/TG1 differently */
 	if (va55) {
-- 
2.39.2


