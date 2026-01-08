Return-Path: <kvm+bounces-67425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 79603D052BD
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9ED2B3042D06
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54E12DC792;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOW2YZAn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC7522A4E8;
	Thu,  8 Jan 2026 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893559; cv=none; b=ucVMoPauASZxTXgX4vAfpgp6QaPGT2n01CEkL5hE1Z7UWqgo5R658vVdiBvmX7ph3arWgfrt+E4b+JmRi0/2eEbs+E44ebowRa+5jahbmWoZR/mc68lwXiWOruX9RoB3F9wHV8cSGdAp4IKETUlXXB/zNc2kVlmZGmnvFrk1gJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893559; c=relaxed/simple;
	bh=/JUEeryixnEw0K58Sa0URLCommZX+4qzbGxWFFq18eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKXAR13Ngez9ZWtLb3X0Iuv4T+In8KbRjT5bwkGYn4GkAZKVuBdum086yV9VnBl2N5YimBds67KYUeNEFjecetg5kUZKFYIiDIfACjqu8tfiSrL8S8WdZ5SM0IVbtX8iyY2rT0rQcz+2A2jn5AlAfRP2SefkumNAGWD0avyeu54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOW2YZAn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28B9C116C6;
	Thu,  8 Jan 2026 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767893558;
	bh=/JUEeryixnEw0K58Sa0URLCommZX+4qzbGxWFFq18eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOW2YZAnkGUMbtnuNKI1vh2waYI6Abc/4RlyqLutWI1o3SoJQbxIjCED3B4apcORD
	 w+NeVHLgUCifDz0LD6g2Laa8qv73U2U+d/iHCIZyWOVMumjyOm6tgbxcL+yDkIpFzE
	 KmY2tw8b+1zoaVqCZw2sIVLY6ExBg1jmfHz73M6idPZl/cE3bCq39FVsC5cxNLzqnc
	 K6Le7tNT5y//gEgks0mCFtvcTtMUa6mL31WIDYtnB/w5RRjz4bX0r1htduwPvqltl0
	 kSXYvVCOWFYrJHoJVmciGkgp2Z3zSEJBrH0DLhMFXWLsAZ9ZkKRXsrJ++3hZsGiJ6U
	 41XU1XTLR+y/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdtsC-00000000W9F-2TZj;
	Thu, 08 Jan 2026 17:32:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v4 1/9] arm64: Repaint ID_AA64MMFR2_EL1.IDS description
Date: Thu,  8 Jan 2026 17:32:25 +0000
Message-ID: <20260108173233.2911955-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108173233.2911955-1-maz@kernel.org>
References: <20260108173233.2911955-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_AA64MMFR2_EL1.IDS, as described in the sysreg file, is pretty horrible
as it diesctly give the ESR value. Repaint it using the usual NI/IMP
identifiers to describe the absence/presence of FEAT_IDST.

Also add the new EL3 routing feature, even if we really don't care about it.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
 arch/arm64/tools/sysreg            | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 3108b5185c204..4db0562f5bfa4 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -134,7 +134,7 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
 	MAX_FEAT(ID_AA64MMFR2_EL1, UAO, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, IESB, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, AT, IMP),
-	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, 0x18),
+	MAX_FEAT(ID_AA64MMFR2_EL1, IDS, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, TTL, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, BBM, 2),
 	MAX_FEAT(ID_AA64MMFR2_EL1, E0PD, IMP),
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8921b51866d64..d0ddfd572b899 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2256,9 +2256,10 @@ UnsignedEnum	43:40	FWB
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-Enum	39:36	IDS
-	0b0000	0x0
-	0b0001	0x18
+UnsignedEnum	39:36	IDS
+	0b0000	NI
+	0b0001	IMP
+	0b0010	EL3
 EndEnum
 UnsignedEnum	35:32	AT
 	0b0000	NI
-- 
2.47.3


