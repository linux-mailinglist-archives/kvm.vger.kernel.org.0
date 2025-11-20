Return-Path: <kvm+bounces-63962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A52C75BE4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 71E523194A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F39836D4E4;
	Thu, 20 Nov 2025 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evHYaDrH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A273AA1A3;
	Thu, 20 Nov 2025 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659567; cv=none; b=MkiJfTG4RBiSfvhSyTioi0n4ah8o0C28FJFZHPDB++lsAh6ulqkjtF+GGygwjaKUDPBJBQ/3D0cog4QEGml2pJEszXWm+Cj593Scm/5OZ7DILV+RVBtabzUjsdMMYUCXm3RTGUuixfUFFlnGQeedAueJG1Tr5sF9/1ALUz/TjTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659567; c=relaxed/simple;
	bh=p0S8x4v+kegTRAO2UPFjLUYT0DFokqnzouqr+mlsYFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlLJ3gSIdJMG99F4rRPkxqZCKIex5eoMpu+GiX6FmXRkd96gJbs6ZxSRBKhH+R3XMYdO/10vuJcwXSV9kmtLG6dakcEl+RcGcLHs3XgH9jSuT4wytRErel4Y/Ledu6b2hSZSzhJhzPYf9e0STE1rTqaUXYbPPuivxDEY9wx+U7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evHYaDrH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D8DC4CEF1;
	Thu, 20 Nov 2025 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659567;
	bh=p0S8x4v+kegTRAO2UPFjLUYT0DFokqnzouqr+mlsYFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evHYaDrHcmm/d4dBZ3lm7c3He6KtePkWodGbf6Nh9thv15uxcC6NwsPUTKIuGGzFM
	 Zt5a605aXqpmzc7aPAPneeLKZJzYbiEndwXMKzInB7MRxcKBA038JWIyUaCuCJiiyb
	 bV6dvRjfbhgvfdp8wAT33hp91ubpPHBBwkbwbTOua/MsLnfgBkWjGZp7yVkNFOcMBl
	 lXZhbiDGE2TLimVZDBGmoU0FlljHsVwh4aSH+71qAGrBMMekryvaN4yN6OCAhAUCb7
	 G8nkzrzsPpsrm0dEZ+BWQ02XeINQhUAGYcvTZ9bcjqTmopMXthsfRvNtYWqiPfQkAe
	 Qb6ubPu8EJmTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Q1-00000006y6g-2mSA;
	Thu, 20 Nov 2025 17:26:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 46/49] KVM: arm64: selftests: vgic_irq: Perform EOImode==1 deactivation in ack order
Date: Thu, 20 Nov 2025 17:25:36 +0000
Message-ID: <20251120172540.2267180-47-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When EOImode==1, perform the deactivation in the order of activation,
just to make things a bit worse for KVM. Yes, I'm nasty.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 9d4761f1a3204..72f7bb0d201e5 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -400,8 +400,18 @@ static void test_inject_preemption(struct test_args *args,
 			continue;
 
 		gic_set_eoi(intid);
-		if (args->eoi_split)
-			gic_set_dir(intid);
+	}
+
+	if (args->eoi_split) {
+		for (i = 0; i < num; i++) {
+			intid = i + first_intid;
+
+			if (exclude && test_bit(i, exclude))
+				continue;
+
+			if (args->eoi_split)
+				gic_set_dir(intid);
+		}
 	}
 
 	local_irq_enable();
-- 
2.47.3


