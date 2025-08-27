Return-Path: <kvm+bounces-55892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1748B3877B
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF0A0171F94
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2673E34AAEE;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3db69ax"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496FF33A01A;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311049; cv=none; b=AI70OQeDxDUIDkz8DdJKAEu4+t1HWnNvpXoNe3ganpchARcAwoDrhD39bCMpPYBCU2nuD0/IGvSSX856cXRLa97/L2i6eCvQwz5lLu2rAOXOrhvniV+jofSNjhSjT4HZvFE7afyjO61PLOLTudW8AgM7x2FupkzeyPcb6F0jT78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311049; c=relaxed/simple;
	bh=Wk9hG5HiVgiE9TXel5ejXn4rVyE8UKFRiiNzNYXg7z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZMvofnIPBnR/1u9Ca9GvdU8p7NWWO7i0qxn16Ddht1GuJOAGGubzoXgH/9fqdQ4R/9Y3RWLvLBwg+5mdv4gtfxG46hCrLb8JsFPP/ukDnM0oJbsKcU+OTG5TDILn+Sx19mduFAlqU5N3BXpy1ZKG29f+rLhXeVT4WxcA/1auJjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3db69ax; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2883AC4CEEB;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311049;
	bh=Wk9hG5HiVgiE9TXel5ejXn4rVyE8UKFRiiNzNYXg7z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3db69axiHxbFM/QS3KNN1DgG0Llsdr5+ix3g/uNtDzjTntzlexi5WILfNOhfVA/Y
	 qDhAj5VrpyX903UgRP5H5497t0kieGq2e6O9QHtHv3dIW6cWSzZlV+KXdApPGfMDYc
	 fXAE0i4UWutg+4jsbyWEIrStgn16dsYdD13glYRCvNFFnRPfsHTInG42nDHlNQTgrF
	 tTuofSm9XGkHuoy+xvzBhNI6aw1BXeyh09eN7ct16NQcURMwnfsdt9VrsOaYunNszL
	 eJ9wofpefMPVzQTXNeviC4DrnsEdNXRas6NRMhQf6G/Izv72mS5q+FOM9pVg66WqJM
	 75tx0sHPF8BKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjX-00000000yGc-1Jtg;
	Wed, 27 Aug 2025 16:10:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 04/16] KVM: arm64: Decouple output address from the PT descriptor
Date: Wed, 27 Aug 2025 17:10:26 +0100
Message-Id: <20250827161039.938958-5-maz@kernel.org>
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

Add a helper converting the descriptor into a nicely formed OA,
irrespective of the in-descriptor representation (< 52bit, LPA
or LPA2).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 36cee6021b2ae..4013d52e308bf 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -56,6 +56,29 @@ static bool has_52bit_pa(struct kvm_vcpu *vcpu, struct s1_walk_info *wi, u64 tcr
 	return (tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS));
 }
 
+static u64 desc_to_oa(struct s1_walk_info *wi, u64 desc)
+{
+	u64 addr;
+
+	if (!wi->pa52bit)
+		return desc & GENMASK_ULL(47, wi->pgshift);
+
+	switch (BIT(wi->pgshift)) {
+	case SZ_4K:
+	case SZ_16K:
+		addr = desc & GENMASK_ULL(49, wi->pgshift);
+		addr |= FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, desc) << 50;
+		break;
+	case SZ_64K:
+	default:	    /* IMPDEF: treat any other value as 64k */
+		addr = desc & GENMASK_ULL(47, wi->pgshift);
+		addr |= FIELD_GET(KVM_PTE_ADDR_51_48, desc) << 48;
+		break;
+	}
+
+	return addr;
+}
+
 /* Return the translation regime that applies to an AT instruction */
 static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 op)
 {
@@ -402,7 +425,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			wr->PXNTable |= FIELD_GET(PMD_TABLE_PXN, desc);
 		}
 
-		baddr = desc & GENMASK_ULL(47, wi->pgshift);
+		baddr = desc_to_oa(wi, desc);
 
 		/* Check for out-of-range OA */
 		if (check_output_size(baddr, wi))
@@ -431,7 +454,8 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			goto transfault;
 	}
 
-	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
+	baddr = desc_to_oa(wi, desc);
+	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
 		goto addrsz;
 
 	if (!(desc & PTE_AF)) {
@@ -444,7 +468,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wr->failed = false;
 	wr->level = level;
 	wr->desc = desc;
-	wr->pa = desc & GENMASK(47, va_bottom);
+	wr->pa = baddr & GENMASK(52, va_bottom);
 	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
 
 	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
-- 
2.39.2


