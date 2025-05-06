Return-Path: <kvm+bounces-45614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E307AACB42
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 545854E4184
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CDC3284B5F;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXdBocBa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBF9283CBF;
	Tue,  6 May 2025 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549848; cv=none; b=LXMsEa4Z8nbyXqWpXVcR8oLkFTm/V85A283p/G11UidJk2fTWA2QGDgVjOPvQ7rYcWcj5Vg6c5TY7S77qsRXT4LHvpJBtQLNZalPE2oAnqVBE63TfDhcsBvQLQvM93AHlrY96CoI3ClSQ3t4zBz+aHBRCPcZ16X/8NGZspummi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549848; c=relaxed/simple;
	bh=7Vdiog1Yp+sWTxIrEPX+RwlsIaichWF0sK4N3/9NICs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=szslemH/ceXe/wpoDSswHxCKv0PueIenEWnvvNkH/MrIN1v+QtHfxu/oFCvt1/EQt2Pbkgi2gMJsgQOuayLPx5GqyGtSz7rViUP8d9y7Q7hBLVBYKMqWTHU2YcTWp1bWnpwX0V7+QgyV1FeMTst1Sz6xdZ3RvRsLDmLMfrZDVDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXdBocBa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5386AC4CEF1;
	Tue,  6 May 2025 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549848;
	bh=7Vdiog1Yp+sWTxIrEPX+RwlsIaichWF0sK4N3/9NICs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXdBocBa/gnLHPLZU+fccO0D0YgOs+tB1LOFdxt6PeFwxkObczXksGI7BhsYAMxQf
	 pIIfXbHjDLbcHyQh5tCsU+73iZFT7plYIZXsqyGrqHKAskn+iCs9RWXY1VUqpOjjVj
	 10ObiiB0VNcTAuJdp/spRT/3MI06duMyyltwhYZVNJw6Sko/O4K4nZbH1v8zgKgNgm
	 4bhEpcwOXirHEU8zf5GdALH1g1k2aJ8iVtBqzRQOvIZd3wKG8lKKHfufn9W4k78rHy
	 nXfRjLk5g3xNOCFDHMKiBTMLDoMInGm0kEJPIUp6yA/s2g1pVL+8flp5yuOUK623Xe
	 fyX92x4bawpKg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOo-00CJkN-Bx;
	Tue, 06 May 2025 17:44:06 +0100
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
Subject: [PATCH v4 02/43] arm64: sysreg: Update ID_AA64MMFR4_EL1 description
Date: Tue,  6 May 2025 17:43:07 +0100
Message-Id: <20250506164348.346001-3-maz@kernel.org>
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

Resync the ID_AA64MMFR4_EL1 with the architectue description.

This results in:

- the new PoPS field
- the new NV2P1 value for the NV_frac field
- the new RMEGDI field
- the new SRMASK field

These fields have been generated from the reference JSON file.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index e5da8848b66b5..fce8328c7c00b 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1946,12 +1946,21 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
-Res0	63:40
+Res0	63:48
+UnsignedEnum	47:44	SRMASK
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	43:40
 UnsignedEnum	39:36	E3DSE
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-Res0	35:28
+Res0	35:32
+UnsignedEnum	31:28	RMEGDI
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 SignedEnum	27:24	E2H0
 	0b0000	IMP
 	0b1110	NI_NV1
@@ -1960,6 +1969,7 @@ EndEnum
 UnsignedEnum	23:20	NV_frac
 	0b0000	NV_NV2
 	0b0001	NV2_ONLY
+	0b0010	NV2P1
 EndEnum
 UnsignedEnum	19:16	FGWTE3
 	0b0000	NI
@@ -1979,7 +1989,10 @@ SignedEnum	7:4	EIESB
 	0b0010	ToELx
 	0b1111	ANY
 EndEnum
-Res0	3:0
+UnsignedEnum	3:0	PoPS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 EndSysreg
 
 Sysreg	SCTLR_EL1	3	0	1	0	0
-- 
2.39.2


