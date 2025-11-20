Return-Path: <kvm+bounces-63915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC9CC75B3C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E2918344DBF
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5419E3242BA;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFe5qtmI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FF13751B8;
	Thu, 20 Nov 2025 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659556; cv=none; b=DzkGZr/Wtk8yzoGsz3qM6qgdP8m1LEP3ViDCPJPazaVlZ7CjUnPC8TzX2a6crBX716Z4o1XDdwz2dkAsF4lrCNrBUmVzPso+GLwpmep9BZ3TZQp8b1AZrhguDzplLOPwsGwgFahJEjoiyk4c2RRizuihmcm/fTyAF3SjWTvU2XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659556; c=relaxed/simple;
	bh=k4X+SvMugMHhrjX6NQq/vIrlSTaNkooCR283WJN59gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEYmOT/YZzRtbRYuFHQLw0lBKMSwDkbXPHLJhUnH3jq3CfM/I7scT0a4/1JhZWADeI/ObeMdoMY6KCxLk+Cu51NHAixlm3RA6r1eqBsGZtkxNPQFiE4PiPD0yYtZmk/tJyNY+VESmuqqAHc+iO/L+q69pkitLOo4VL5oz+NTLjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFe5qtmI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB448C116C6;
	Thu, 20 Nov 2025 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659555;
	bh=k4X+SvMugMHhrjX6NQq/vIrlSTaNkooCR283WJN59gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFe5qtmIB6iZmy4rPe4CmVG9smUvAoshAWBEt8t4AIFgy5FTsoMtt0EqAZmFem/2k
	 lzq7Z/FeMvyIoq86S1Fn26vumBuu6gz21xiy/+JrGwQ5sfxvVwVnIU3B0V5UTLh6ke
	 +39wUxLyGi6nWiPcp4z2aM3/CxGsU879FV4dgq+K3FQBQTDiQBVYrISKozBcLbPbtZ
	 PPVKABStkkWB+lqtB8WImLou/fTKpmqVQh5QMiC1PRFwvDZqhMJjBA5HFDn7fDPXcB
	 kXTVIv8WT4jP58s+U+Vgm4ccIOwGcRgtvjICzppHOpE/X+X5XOi3xZcWD4nbUMlR3Y
	 MMUpd6Qxm3lGA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pq-00000006y6g-02qS;
	Thu, 20 Nov 2025 17:25:54 +0000
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
Subject: [PATCH v4 01/49] irqchip/gic: Add missing GICH_HCR control bits
Date: Thu, 20 Nov 2025 17:24:51 +0000
Message-ID: <20251120172540.2267180-2-maz@kernel.org>
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

The GICH_HCR description is missing a bunch of control bits that
control the maintenance interrupt. Add them.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/irqchip/arm-gic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 2223f95079ce8..d45fa19f9e470 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -86,7 +86,13 @@
 
 #define GICH_HCR_EN			(1 << 0)
 #define GICH_HCR_UIE			(1 << 1)
+#define GICH_HCR_LRENPIE		(1 << 2)
 #define GICH_HCR_NPIE			(1 << 3)
+#define GICH_HCR_VGrp0EIE		(1 << 4)
+#define GICH_HCR_VGrp0DIE		(1 << 5)
+#define GICH_HCR_VGrp1EIE		(1 << 6)
+#define GICH_HCR_VGrp1DIE		(1 << 7)
+#define GICH_HCR_EOICOUNT		GENMASK(31, 27)
 
 #define GICH_LR_VIRTUALID		(0x3ff << 0)
 #define GICH_LR_PHYSID_CPUID_SHIFT	(10)
-- 
2.47.3


