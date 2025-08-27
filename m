Return-Path: <kvm+bounces-55895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EEFC4B3877F
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9003188C583
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F2DB3570D4;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVb8Enl6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB5A3451CB;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311049; cv=none; b=CQATCGjykZR7HiIqnha0d/OdoCpuRsn+4QycACjy32Q/iZnFWBNmfuHtkAfj3KQSX7xBw6V/LrxgSiGgbttsbTQpOun6hzHzTudBXzb6JrQ2G8QFlRfScf4xIkENF9aa5aEoKgKb88z97XCZrZ9ZOngBOEcgK7wWYQPTz6XsVOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311049; c=relaxed/simple;
	bh=BGvF4emJCZt66ab5olKluKN7eyjKva27Qgxm5D/ag18=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pfr38XqPj+4/V1ry4zngHEi36W+/TN48QjKz66TF7xOoFh5sX0UYT2nJx1CUzkAvmJmdvRJpnK3CAkGhx28VqI9c7IeXiaxMHrnmOexNDjdAE+4QCYG+x//TodL0GUcjqZsAfisVBkm1X9wGzjZ0Jwl0wArODyzCyeK67FnmvcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVb8Enl6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBCBC4CEF5;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311049;
	bh=BGvF4emJCZt66ab5olKluKN7eyjKva27Qgxm5D/ag18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVb8Enl6F9/HBRQiHPkuQkdkU1q6YK4mFFrWtJKZM4j+NjrpATGhdLEBtS7Z8uqgp
	 7s3/th7lYMYcFJTNxqK45KoK3APQgI22HHhK76gUHL0a040UL0G24x90QmpOLqFBYc
	 vn7TjXscnZ0jU+veQB4HcDTcIadACVguoi7hPrIBNEMZbHomjPJ9mh0mKi2vvlylBe
	 Qv3MMMbQDmoujfOCwiltSkYxbwUus/w0O2ozC+0kDDvMHGMVI5qaD/hvCE221wXEOo
	 w5rjb8Br5cVWG62RJB5DcFTvZcr7IHBRQEaYuksi7/vEaxCZsVhyGshSafOQOZsIRE
	 HC30otkfmBKcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjX-00000000yGc-32L2;
	Wed, 27 Aug 2025 16:10:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 06/16] KVM: arm64: Compute shareability for LPA2
Date: Wed, 27 Aug 2025 17:10:28 +0100
Message-Id: <20250827161039.938958-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
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

LPA2 gets the memory access shareability from TCR_ELx instead of
getting it form the descriptors. Store it in the walk info struct
so that it is passed around and evaluated as required.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/at.c                 | 37 +++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 1a03095b03c5b..f3135ded47b7d 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -295,6 +295,7 @@ struct s1_walk_info {
 	unsigned int		pgshift;
 	unsigned int		txsz;
 	int 	     		sl;
+	u8			sh;
 	bool			as_el0;
 	bool	     		hpd;
 	bool			e0poe;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index ea94710335652..c684325b954d3 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -188,6 +188,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (!tbi && (u64)sign_extend64(va, 55) != va)
 		goto addrsz;
 
+	wi->sh = (wi->regime == TR_EL2 ?
+		  FIELD_GET(TCR_EL2_SH0_MASK, tcr) :
+		  (va55 ?
+		   FIELD_GET(TCR_SH1_MASK, tcr) :
+		   FIELD_GET(TCR_SH0_MASK, tcr)));
+
 	va = (u64)sign_extend64(va, 55);
 
 	/* Let's put the MMU disabled case aside immediately */
@@ -697,21 +703,36 @@ static u8 combine_s1_s2_attr(u8 s1, u8 s2)
 #define ATTR_OSH	0b10
 #define ATTR_ISH	0b11
 
-static u8 compute_sh(u8 attr, u64 desc)
+static u8 compute_final_sh(u8 attr, u8 sh)
 {
-	u8 sh;
-
 	/* Any form of device, as well as NC has SH[1:0]=0b10 */
 	if (MEMATTR_IS_DEVICE(attr) || attr == MEMATTR(NC, NC))
 		return ATTR_OSH;
 
-	sh = FIELD_GET(PTE_SHARED, desc);
 	if (sh == ATTR_RSV)		/* Reserved, mapped to NSH */
 		sh = ATTR_NSH;
 
 	return sh;
 }
 
+static u8 compute_s1_sh(struct s1_walk_info *wi, struct s1_walk_result *wr,
+			u8 attr)
+{
+	u8 sh;
+
+	/*
+	 * non-52bit and LPA have their basic shareability described in the
+	 * descriptor. LPA2 gets it from the corresponding field in TCR,
+	 * conveniently recorded in the walk info.
+	 */
+	if (!wi->pa52bit || BIT(wi->pgshift) == SZ_64K)
+		sh = FIELD_GET(PTE_SHARED, wr->desc);
+	else
+		sh = wi->sh;
+
+	return compute_final_sh(attr, sh);
+}
+
 static u8 combine_sh(u8 s1_sh, u8 s2_sh)
 {
 	if (s1_sh == ATTR_OSH || s2_sh == ATTR_OSH)
@@ -725,7 +746,7 @@ static u8 combine_sh(u8 s1_sh, u8 s2_sh)
 static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
 			   struct kvm_s2_trans *tr)
 {
-	u8 s1_parattr, s2_memattr, final_attr;
+	u8 s1_parattr, s2_memattr, final_attr, s2_sh;
 	u64 par;
 
 	/* If S2 has failed to translate, report the damage */
@@ -798,11 +819,13 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
 	    !MEMATTR_IS_DEVICE(final_attr))
 		final_attr = MEMATTR(NC, NC);
 
+	s2_sh = FIELD_GET(PTE_SHARED, tr->desc);
+
 	par  = FIELD_PREP(SYS_PAR_EL1_ATTR, final_attr);
 	par |= tr->output & GENMASK(47, 12);
 	par |= FIELD_PREP(SYS_PAR_EL1_SH,
 			  combine_sh(FIELD_GET(SYS_PAR_EL1_SH, s1_par),
-				     compute_sh(final_attr, tr->desc)));
+				     compute_final_sh(final_attr, s2_sh)));
 
 	return par;
 }
@@ -856,7 +879,7 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		par |= FIELD_PREP(SYS_PAR_EL1_ATTR, mair);
 		par |= wr->pa & GENMASK_ULL(47, 12);
 
-		sh = compute_sh(mair, wr->desc);
+		sh = compute_s1_sh(wi, wr, mair);
 		par |= FIELD_PREP(SYS_PAR_EL1_SH, sh);
 	}
 
-- 
2.39.2


