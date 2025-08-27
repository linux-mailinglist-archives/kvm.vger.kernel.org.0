Return-Path: <kvm+bounces-55896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9F0B38780
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:11:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C2101BA7DF2
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F34A35A298;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2w3Cblf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B5342C89;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311049; cv=none; b=DWJ2CG1dNJFJw8G0EU2MRs4+HcjOb0LJQ40wQy0D2fBOpyrxobVGBLo1mOQmhtcdwaYs89NTrbs5EXKgbUA2nMcC13JT5gWFcn9jGHuoCJ5UYS2MTzhZBnQkXFgwuaR1jS/L2CK8dcNTIeZ8DGTTEjPzGMyANIJKhZ3/RlrP1II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311049; c=relaxed/simple;
	bh=tmEM96C2TC0zXIOl9E5p1YhX5LWEHFaDzYtjcvT2phY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BdUr4XoFyrG3anDQmwnBSeU/XQXwZadnY0kAUTywwgfhJ2ReFcPWNvKbEUedoeWetI59YRveuCAj2rGSiXK4/TS+6YXmWmmmx2+Yu2OfhQN5pXgIA9kqgebZ3x+5tLMPr1m7qIJkQ8r2QcGB14kpvdhxuEFl+HaAWsZjN6VBP7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2w3Cblf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33131C4CEF0;
	Wed, 27 Aug 2025 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311049;
	bh=tmEM96C2TC0zXIOl9E5p1YhX5LWEHFaDzYtjcvT2phY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2w3Cblf3lxPOpGNnPh1nppii6f7VZVk2Z4PCoYKlDtKiVpZ4rdYNqaLhb8MBRgl8
	 TzbcEm99yP6bm/ysbcg4SYF5qsYIbrXoBPcrFPi+Hwop8GVzZijAr99pxPXuh2POIu
	 lHMTCrOcLcFoP9BNhr4dXfvs9WNxHgmkUFdkxRL1jGeLN/SjtZWDLW4NjTZ5mxHoTg
	 CcKpY9nZTI38POnt0ES44pXEVPElUpWI59aU15RcZmMm/IFJPeGT1aJ+eSOInH0QEf
	 z7XE3He7SqPaZF3N108upgMpOdrLjlt7uTBAJHhBc3d3UNB+T9DuUlOgkVEx+CMwQL
	 IuQ7zHM+wpupQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjX-00000000yGc-0Sax;
	Wed, 27 Aug 2025 16:10:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 03/16] KVM: arm64: Compute 52bit TTBR address and alignment
Date: Wed, 27 Aug 2025 17:10:25 +0100
Message-Id: <20250827161039.938958-4-maz@kernel.org>
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

52bit addresses from TTBR need extra adjustment and alignment
checks. Implement the requirements of the architecture.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 04b7ff4426303..36cee6021b2ae 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -28,6 +28,8 @@ static int get_ia_size(struct s1_walk_info *wi)
 /* Return true if the IPA is out of the OA range */
 static bool check_output_size(u64 ipa, struct s1_walk_info *wi)
 {
+	if (wi->pa52bit)
+		return wi->max_oa_bits < 52 && (ipa & GENMASK_ULL(51, wi->max_oa_bits));
 	return wi->max_oa_bits < 48 && (ipa & GENMASK_ULL(47, wi->max_oa_bits));
 }
 
@@ -301,6 +303,16 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	x = 3 + ia_bits - ((3 - wi->sl) * stride + wi->pgshift);
 
 	wi->baddr = ttbr & TTBRx_EL1_BADDR;
+	if (wi->pa52bit) {
+		/*
+		 * Force the alignment on 64 bytes for top-level tables
+		 * smaller than 8 entries, since TTBR.BADDR[5:2] are used to
+		 * store bits [51:48] of the first level of lookup.
+		 */
+		x = max(x, 6);
+
+		wi->baddr |= FIELD_GET(GENMASK_ULL(5, 2), ttbr) << 48;
+	}
 
 	/* R_VPBBF */
 	if (check_output_size(wi->baddr, wi))
-- 
2.39.2


