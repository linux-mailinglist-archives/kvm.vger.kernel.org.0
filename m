Return-Path: <kvm+bounces-38281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E50A36EED
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A00C189469A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33B71E0DC3;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBLgBNiu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C28F151991;
	Sat, 15 Feb 2025 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631723; cv=none; b=e3u7ix7YdsfHSPNWtHpLbxR5oFYGmm8Aa+ns6zuT9K2L//4yKqCwuEyeh3cL4uSDiuGdaCXsAL5QOUYrFQD/uaYGdOyIxVgL1t3WauaQgCUDPHCfCwNbUtccUIwAkXN1Icl9pf8iWs18KORKl2d5HAxqWqJPvBTc4rYt6HZsCag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631723; c=relaxed/simple;
	bh=L6EHvmUXku+zPzqhvJf7wREo7z6WQPXzllEkBP1EVWU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=srFRhJMsNLlC+J/7h+AdOUYec5HeYxx6A38hTox+sOIqXOcmQxycrlwDux5ol154RxQXj419k5h6aSD0EKyIEBAPE4h51BzJzPpLFwKrgfRbZsjS2vqMLdAC6wp+2GuTBmOPUECPHYqeFNR7yKhj9DwHVgtDA40/GMykfkBIEcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBLgBNiu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F435C4CEE7;
	Sat, 15 Feb 2025 15:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631722;
	bh=L6EHvmUXku+zPzqhvJf7wREo7z6WQPXzllEkBP1EVWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBLgBNiuTLicbb+jpgK5xvLTiH6BdAdE4hReHFznoGu/xvUZMvCss1mnaZ9QtjIhl
	 eiiXFu85fT2oS92HgqnzGaRteEFiJKZcFTKSKIgQXWfi/k26JgvRnfrlkql/Psvy1U
	 ENfwRtKMY1GACFcXzhzH4MDR47+eHNRqARwqM22iB1gCchK6xrnuzYz9WFlOKrhR3K
	 HJs3Xdmkv6DFrBFawE86DT5Cbeo+k99A/1jZdNk2DOvFQ2nf6vk+8CPx7R5gt4Iu4h
	 FY6e4i8ErvlviAZrS/XwKsUiXAyiXVe+Wx39zWL3IqAZFHgbuQ2VPqArO3SBBKll8W
	 GO5jnR8cdexHg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJg8-004Nz6-D1;
	Sat, 15 Feb 2025 15:02:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 01/14] arm64: sysreg: Add layout for VNCR_EL2
Date: Sat, 15 Feb 2025 15:01:21 +0000
Message-Id: <20250215150134.3765791-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we're about to emulate VNCR_EL2, we need its full layout.
Add it to the sysreg file.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 1 -
 arch/arm64/tools/sysreg         | 6 ++++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 05ea5223d2d55..0a18279dc4dfe 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -521,7 +521,6 @@
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
-#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 762ee084b37c5..e8dd641e7625c 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2868,6 +2868,12 @@ Sysreg	SMCR_EL2	3	4	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+Sysreg	VNCR_EL2	3	4	2	2	0
+Field	63:57	RESS
+Field	56:12	BADDR
+Res0	11:0
+EndSysreg
+
 Sysreg	GCSCR_EL2	3	4	2	5	0
 Fields	GCSCR_ELx
 EndSysreg
-- 
2.39.2


