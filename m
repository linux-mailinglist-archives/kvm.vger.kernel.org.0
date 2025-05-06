Return-Path: <kvm+bounces-45617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70735AACB4A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:45:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A99934A60AA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9947286402;
	Tue,  6 May 2025 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnnubCpb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430B2853EF;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549849; cv=none; b=UyXZTNE0DeiKtzk08nE7G52FWZAsTmJMd/4xLeTI4MWarC/oZsI5wa32rUcCd/GoPJhJni0oOeILBgi01NBMJJbFtFqvmdxoCv2jpNs7OCjnBpjWysPUAzLpi0gABxHj/BD1GeoK7v7gLB8TbphmEqI30Xo3mk+5QqpEx5SZYVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549849; c=relaxed/simple;
	bh=7nY2O1Ac4lZe+UD4phwzjft1fg8/7D3hGPRpx5JQGJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HEv7v/TMesJxpdGT2jG9BADrarsCzexUOTrsG892ufUGjKaYKIHs5oya1Mwo1l3fnbGSk7CPCL6qsiUZV0CieFsCpJLSZika+hq1eIcPNO3nO3e1H1LTcYPsjyXkDGooxOJaRQBtEy9nSgx8DoYZsViRUMSPYTOCBYZNAwKTZV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnnubCpb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D625C4CEF2;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549849;
	bh=7nY2O1Ac4lZe+UD4phwzjft1fg8/7D3hGPRpx5JQGJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnnubCpbG5bQvlD+N/T87gwcZDqSyytCKb1QcEHGwExBJ6M6u8VQ7064+zMysAIjk
	 H8KYRyvUFUk7M+NKu+D4ZCCuRGra/n/24XRpxo+VH8bFXeEyRSWMiZqOoMCpk7jxs2
	 5OYwYA7KetJwWbICVqO6Yg5e2l69fqSaJJsEIZFtO1++yVxTc573n2WWkhAIYl5NbM
	 CiH4r7cF5mnI/RtLjfGP0XMk7BCVWMNu9sKOhey3gk+POmARRYeEOU9TjWufPgD6mg
	 yIdv3VTl6+WCf194Y9jydg/bj9VTVK1KfphQ0DDz8GvwqpNGAkJbLW2VjbYZI6pFQr
	 0qTQeB8f/28UA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOp-00CJkN-As;
	Tue, 06 May 2025 17:44:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 06/43] arm64: sysreg: Update PMSIDR_EL1 description
Date: Tue,  6 May 2025 17:43:11 +0100
Message-Id: <20250506164348.346001-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the missing SME, ALTCLK, FPF, EFT. CRR and FDS fields.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 6c64fd7d84951..dbb96e15198aa 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2241,7 +2241,28 @@ Field	15:0	MINLAT
 EndSysreg
 
 Sysreg	PMSIDR_EL1	3	0	9	9	7
-Res0	63:25
+Res0	63:33
+UnsignedEnum	32	SME
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	31:28	ALTCLK
+	0b0000	NI
+	0b0001	IMP
+	0b1111	IMPDEF
+EndEnum
+UnsignedEnum	27	FPF
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	26	EFT
+	0b0	NI
+	0b1	IMP
+EndEnum
+UnsignedEnum	25	CRR
+	0b0	NI
+	0b1	IMP
+EndEnum
 Field	24	PBT
 Field	23:20	FORMAT
 Enum	19:16	COUNTSIZE
@@ -2259,7 +2280,10 @@ Enum	11:8	INTERVAL
 	0b0111	3072
 	0b1000	4096
 EndEnum
-Res0	7
+UnsignedEnum	7	FDS
+	0b0	NI
+	0b1	IMP
+EndEnum
 Field	6	FnE
 Field	5	ERND
 Field	4	LDS
-- 
2.39.2


