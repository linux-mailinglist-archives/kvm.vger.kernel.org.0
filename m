Return-Path: <kvm+bounces-28337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA5299754D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72F171C226CE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081C81E7C04;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQW3Y5Zb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4801E5700;
	Wed,  9 Oct 2024 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500448; cv=none; b=eGMtrjQUXuPREVqwnoPGFUQ/IFOMos4QRY8UgM9AGBSJUtlQdTEHsBbpOL9R+u1DV6+779L83jXKIwXIVWZ1UNIDGmU+RH46RxFgwfmS3bp3Mek4nzd6+MXi5HsZNenHPLkbroNfrcMoLBTV8EclHKSHatfQBpeaONxbhasBVGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500448; c=relaxed/simple;
	bh=x3OVdblfjzLAzOMuHusK8FnNF3oPWJdEbQW/T6p0YP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oqt+K+j7Ot7uRv1hFwp1lrbALn4E+MlSDb4fIaB8wra7QPqlnGbyfJY8w4NZmfmgXaSDaZtuOq5P0nd2Hu8lUBEvbOx8WGcfLDhXk31HZnZruPUVzy3mEPy8pez36iI1vmeAEzbWxWAR1CtgcTzYkHlpXV0HC40do6PCTaLbAYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQW3Y5Zb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38D4C4CECC;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500448;
	bh=x3OVdblfjzLAzOMuHusK8FnNF3oPWJdEbQW/T6p0YP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQW3Y5Zbd61Fkgi8xrMsT161HQ8XEoBtP8ascUB8xMTYmmWuS/kcWLCkjOkP52Lx4
	 aCfmFuwJXsChPloqxJdgm5gjNDzr+/b4t6LBQABtyaKmIZWH8lev1kxZuGPNdyv30m
	 LuJSJQ3M60jgQVlqi0QDI9ozH0Scc11VquvxhjbxUgAfqesRaM5bbNhm9VlPTJ3HhI
	 +iCTs9Ce4F8/BTLIkrzqd+IofGGd9/g8qZoDfQHjeowPNnkl7LJkBC1DZF4F87rKBx
	 sxznNWCSu7Sri9I4wFUpYvAcxnAT5t+Bh2+O/BhhVAQjkX9NIrdfz+IzRbt44HOQCY
	 5IwlsX49ro1Mg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvS-001wcY-5K;
	Wed, 09 Oct 2024 20:00:46 +0100
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
Subject: [PATCH v4 26/36] arm64: Add encoding for POR_EL2
Date: Wed,  9 Oct 2024 20:00:09 +0100
Message-Id: <20241009190019.3222687-27-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
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

POR_EL2 is the equivalent of POR_EL1 for the EL2&0 translation
regime, and it is sorely missing from the sysreg file.

Add the sucker.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8db4431093b26..a33136243bdf2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2907,6 +2907,10 @@ Sysreg	POR_EL1		3	0	10	2	4
 Fields	PIRx_ELx
 EndSysreg
 
+Sysreg	POR_EL2		3	4	10	2	4
+Fields	PIRx_ELx
+EndSysreg
+
 Sysreg	POR_EL12	3	5	10	2	4
 Fields	PIRx_ELx
 EndSysreg
-- 
2.39.2


