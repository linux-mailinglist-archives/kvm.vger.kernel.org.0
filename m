Return-Path: <kvm+bounces-29544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F219ACDF5
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4B691F232B8
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2692B2071E8;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o11ddARJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BF520408D;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695236; cv=none; b=Q5VNiz5oXXdKJnS9Hu7R6zjxEmcHRvL9fNJDs8oKpKVIQSL81HRi4cepxpw8NK5yI0sUH9SJnEiBu9g71zBLO8ctqb6J0cdlknk959iQYWsU5zS4N2FBN6ek59BYLe+tTdpgYwiYwl7WEHUA0pY3b4zHL+Y1KWfSE8eE72tfV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695236; c=relaxed/simple;
	bh=dHJ3KFc8Fd9R8bqsS2a+yer53TbR/Cd03c/AD97edWg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fwg9BtKIJ56CAyrNw/PWXNmWGChC+wxk6gh0M2IL0Ju/J2bAKOY6g07KJY2gFQAf6mE3NBWO2KWpOthYC6avns7G8P0w4/IqGKi5xQEKBM+RUPWYR2yrSSZed2zmUTxK/+QZqzWFn0losqoksR2BGFzKhoK5sewBPMZ9/r9G7uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o11ddARJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DB0C4CEC6;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695235;
	bh=dHJ3KFc8Fd9R8bqsS2a+yer53TbR/Cd03c/AD97edWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o11ddARJDnLBeEjJG+CyPpObqIDDpR0vqcQ4FGr/pdC+izcd9Dpas5K0cL6KayFx3
	 LyifpRU+qUeju5SN612Akgc5qw4LmSAYw5gE0MNdZuiwB9vZz8hqsEhO1YTPIO2YAY
	 jLQxcm5lSfsIumrkD3yOnl3Ha5oXaMJotq1LuXhX8wR9bZ8jlCwQgTFk0ZZInFCYNK
	 uxvp00wI3aY4s8/3XsjLTii0FD7ak7xLPVh9edJq0/vVuXv/8PIfSSR2Spl2yI5nDa
	 wq3S5QcpFbtgFJ1gX8FDpCQsU4CyqTpjA+KLbMRgjZGgU0nGHKHed13EOGggd+BPJE
	 Syr7eOkHWnYUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckE-0068vz-1v;
	Wed, 23 Oct 2024 15:53:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 22/37] KVM: arm64: Add a composite EL2 visibility helper
Date: Wed, 23 Oct 2024 15:53:30 +0100
Message-Id: <20241023145345.1613824-23-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We are starting to have a bunch of visibility helpers checking
for EL2 + something else, and we are going to add more.

Simplify things somehow by introducing a helper that implement
extractly that by taking a visibility helper as a parameter,
and convert the existing ones to that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9638541c0994..dfbfae40c53c5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2296,16 +2296,18 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return __vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
+static unsigned int __el2_visibility(const struct kvm_vcpu *vcpu,
+				     const struct sys_reg_desc *rd,
+				     unsigned int (*fn)(const struct kvm_vcpu *,
+							const struct sys_reg_desc *))
+{
+	return el2_visibility(vcpu, rd) ?: fn(vcpu, rd);
+}
+
 static unsigned int sve_el2_visibility(const struct kvm_vcpu *vcpu,
 				       const struct sys_reg_desc *rd)
 {
-	unsigned int r;
-
-	r = el2_visibility(vcpu, rd);
-	if (r)
-		return r;
-
-	return sve_visibility(vcpu, rd);
+	return __el2_visibility(vcpu, rd, sve_visibility);
 }
 
 static bool access_zcr_el2(struct kvm_vcpu *vcpu,
-- 
2.39.2


