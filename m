Return-Path: <kvm+bounces-24252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB5C952EA3
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 440BD1F21BFC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1710619F482;
	Thu, 15 Aug 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFUShYj9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B3A19D8B5;
	Thu, 15 Aug 2024 13:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726805; cv=none; b=rluAOizOr7kh2kpgxP7Pxv3m1SVUKZrMZAGd9sqDmzu8+gliGERXu3lia/Y9axyRfyFn1/tLdvdYLyqq8PkWcQYZjh1p+6Expk48E5t18I9Syh1dxhvK/23u+DZwkZPUX5IjXF8VhIGMwLG8jofhPWuQSM9kTtEnaQq/C8ra/gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726805; c=relaxed/simple;
	bh=HG45eYtHH12sqQC97/SWs8xCRMEbpDiQ1tJj7NKCsls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OIQhsVig0/wg6t9JunrSVTuazyHATDnI/Rzjdx2GHVuEcu3HRsLSrVH940vLrPTnncRNlo3fW8yP5YxD19v7yyRa6TbTlyMAnagiAyXLyZTzoZafu5iWBSddP2mSWGfip9La3varx0RU3D/+Redo8/h0AOiF83TGEM9/P8/2mF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFUShYj9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64D5C4AF0B;
	Thu, 15 Aug 2024 13:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726804;
	bh=HG45eYtHH12sqQC97/SWs8xCRMEbpDiQ1tJj7NKCsls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFUShYj9z2wvrBjmP4YZ62S/jHHk2FTvroICQn7SOrrbH0glXh6fxDOvhDMhMHZSc
	 teefCeKMIqiySnOXp4NIME0Jv4WQxMLwAEHZXrPFDOiIJSkVc8Jag6PeG3bp71cUXR
	 1+QPg/DxgYEFj5QzjsSVEvSsPnz3ll1BXKK1ZWdQ+2oHphwPlA5hou3fX11bfsrB3u
	 vUE1y+mKEGj8jwakbcpWkJwg8N6nQANiAoLsNAc+WVt9ogERLsVtfSaAcm1ylCLRJb
	 TYpx4+KrdEXFZeLmqDPKDnJimvUHJiG/4TJilowO7eFH5uzri1ufBMGU2pH73i7w3t
	 1jwFvIlB9lMOw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5C-003xld-Rg;
	Thu, 15 Aug 2024 14:00:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 01/11] arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature consumers
Date: Thu, 15 Aug 2024 13:59:49 +0100
Message-Id: <20240815125959.2097734-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240815125959.2097734-1-maz@kernel.org>
References: <20240815125959.2097734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite KVM now being able to deal with XS-tagged TLBIs, we still don't
expose these feature bits to KVM.

Plumb in the feature in ID_AA64ISAR1_EL1.

Fixes: 0feec7769a63 ("KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 646ecd3069fd..4901daace5a3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -228,6 +228,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_XS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_I8MM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_DGH_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_BF16_SHIFT, 4, 0),
-- 
2.39.2


