Return-Path: <kvm+bounces-57562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 638D9B578DC
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:47:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52D3744584F
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06F430216F;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IU+xPNqk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C80301021;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936699; cv=none; b=d/PgIcdSJxnG+mqzqDvmLTlLMF70Jm3Ugi4Hgnn/2DqqgAJZA11ffGtjLfoiPJbV3s8fvXQ383eMYIB0L137tvGEyLz3xMQyPhH1A1ISmQXW3BENn2ANZRr4hS1jve0vRhFltKYixGfiYniaEDiFe/MxGhZmDJ9zzYowBxVNq9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936699; c=relaxed/simple;
	bh=cuS9SHuGG3F79ODO0qmZswZFWO7i6E8RahYMo63RrsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RwDMn4hRkud4JwZadpBZnc+vROxZBIEAughau8U5KZdlmbqOSFVNSioMbwDM2n3ckeLyMaIg2KoUg/AOOv+lDeTm/GvwMuTikS1IZC/XlRJ1eQM6sWhEu27Evs8ZFp6kUzN+PJt+XY0fnlnedZOYlCGJZt3xM7yrNkEmJo2bW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IU+xPNqk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B914C4CEFB;
	Mon, 15 Sep 2025 11:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936699;
	bh=cuS9SHuGG3F79ODO0qmZswZFWO7i6E8RahYMo63RrsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IU+xPNqkSPTmBziaDo6mj2aQO/ljEmiikR7hLb3dKcb0N19BV2Lkuzg9t+OgX3BZk
	 afTzQzfXmFeqAhjNeUmSW1NS7Uv2kaTkkXTQVutCw73pSm0UqUtemQ6WhSAnWPfTJn
	 4BDGpcSb5xYE4WI+iY6OuOHMw7jVNQVten4M1dj9KyewHChIxNr81bsVJ618QY+OI3
	 4nlFzP+jH7uANi8S3KyhSAUK8VSrTilVmhYCckU16/wbTj735LYT15OeGNCoDgVo00
	 eHIh7Iglw7UPoB25PTPIOjKpSXLWb6vEb5msges14zSYneMesOP3N7OwLIz+X/dAkI
	 zQiPCDV7g/rPg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dh-00000006MDw-32D7;
	Mon, 15 Sep 2025 11:44:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 14/16] KVM: arm64: Add S1 IPA to page table level walker
Date: Mon, 15 Sep 2025 12:44:49 +0100
Message-Id: <20250915114451.660351-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Use the filtering hook infrastructure to implement a new walker
that, for a given VA and an IPA, returns the level of the first
occurence of this IPA in the walk from that VA.

This will be used to improve our SEA syndrome reporting.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +
 arch/arm64/kvm/at.c                 | 65 +++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index cce0e4cb54484..2be6c3de74e3d 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -353,6 +353,8 @@ struct s1_walk_result {
 
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		       struct s1_walk_result *wr, u64 va);
+int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
+			     int *level);
 
 /* VNCR management */
 int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index c099bab30cb0d..117ce1ff5e767 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1578,3 +1578,68 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	return 0;
 }
+
+struct desc_match {
+	u64	ipa;
+	int	level;
+};
+
+static int match_s1_desc(struct s1_walk_context *ctxt, void *priv)
+{
+	struct desc_match *dm = priv;
+	u64 ipa = dm->ipa;
+
+	/* Use S1 granule alignment */
+	ipa &= GENMASK(52, ctxt->wi->pgshift);
+
+	/* Not the IPA we're looking for? Continue. */
+	if (ipa != ctxt->table_ipa)
+		return 0;
+
+	/* Note the level and interrupt the walk */
+	dm->level = ctxt->level;
+	return -EINTR;
+}
+
+int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
+{
+	struct desc_match dm = {
+		.ipa	= ipa,
+	};
+	struct s1_walk_info wi = {
+		.filter	= &(struct s1_walk_filter){
+			.fn	= match_s1_desc,
+			.priv	= &dm,
+		},
+		.regime	= TR_EL10,
+		.as_el0	= false,
+		.pan	= false,
+	};
+	struct s1_walk_result wr = {};
+	int ret;
+
+	ret = setup_s1_walk(vcpu, &wi, &wr, va);
+	if (ret)
+		return ret;
+
+	/* We really expect the S1 MMU to be on here... */
+	if (WARN_ON_ONCE(wr.level == S1_MMU_DISABLED)) {
+		*level = 0;
+		return 0;
+	}
+
+	/* Walk the guest's PT, looking for a match along the way */
+	ret = walk_s1(vcpu, &wi, &wr, va);
+	switch (ret) {
+	case -EINTR:
+		/* We interrupted the walk on a match, return the level */
+		*level = dm.level;
+		return 0;
+	case 0:
+		/* The walk completed, we failed to find the entry */
+		return -ENOENT;
+	default:
+		/* Any other error... */
+		return ret;
+	}
+}
-- 
2.39.2


