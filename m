Return-Path: <kvm+bounces-57556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5682B578CD
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1E9B7B11F6
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058D0301489;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkiYy8nA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A432FD7CC;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936698; cv=none; b=HR0KwnzlQouEkzSzY9XQdNRed1auj1AMMo2zYgq0LTIJNEwNrbrrW3HRgk+Tp620TKD+Q1o6c5s1jUz6i06kg61NUc0Ms4Py+AS00eR/g4KYdhHiFGp+EedkcbhCl5bol5pjC54Wui7Xe3QYxR5WI23yd9ntMACNmAJuW3CS/GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936698; c=relaxed/simple;
	bh=4f/7HgkGl2yRcs7jxujS6YOzH5ZV7Vwa6Ec9AEQf0UY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nw1E0+Vc9ERvpmogsIhnIt9NdcO49yTpQXWj9bqgQuD0GNTR0pp3e1M2Ui3HI+1MJHf2G9sknqw5ToYbZmeggUYpjzNQgCJxz+qxr9TYLlSzhBR7mNj8zf97uJ7MQt6PjVw0ZRDn0A4P+d7Do3e1Lkxzo8DI3BnPi7rGjY2v2BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkiYy8nA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E75C4CEF7;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936697;
	bh=4f/7HgkGl2yRcs7jxujS6YOzH5ZV7Vwa6Ec9AEQf0UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkiYy8nACq+xrwP199WRd9BlmSkZDJ+TyFZI75YSUqvwWD07073ZGIoJNSXtAgEUj
	 5quJ+lBDneQdU7bU6NpGQ5OprxWE/O8JuagIGkzeTEoDgtc/SdHGDd0qeiYNTGOnz2
	 Rx8FLWd9P1WBXD9AE67DEfPd03w/L0p7xQ7afmzXf0EHWqLv/5wAradSfo4Mm3F0j/
	 zeKL2lYBkgGHHc1lfbQsQKeJhOhSmVJjbrYoKTaV6HKKfSHI7G4ZZP9DDe0+bV2p5x
	 v8hWlrkg64Y9cGcg+uSM8EBW9jwSjQYw35CiQ8z5wgD2zqOUsESrkjRgNLMn1v/DSz
	 6BjiRWKBBK+9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dg-00000006MDw-0QrQ;
	Mon, 15 Sep 2025 11:44:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 06/16] KVM: arm64: Compute shareability for LPA2
Date: Mon, 15 Sep 2025 12:44:41 +0100
Message-Id: <20250915114451.660351-7-maz@kernel.org>
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
index acf6a5d497773..952c02c57d7dd 100644
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


