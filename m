Return-Path: <kvm+bounces-44415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C419CA9DA8E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 128931BA6AB2
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3355B2356CD;
	Sat, 26 Apr 2025 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X10HUAxq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561E922FDEA;
	Sat, 26 Apr 2025 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670531; cv=none; b=pKeBn4CxXgkuynV20BgxpiKEAFPXJvfir49bg41Sg49mkhB2GCEq8on0fH0PH/9g2kRUxKBoeOKqGnH/TU7BFNlEO7OWowl4Qq1MXoyA3zK6RgmVslB6iS5eHFDI/Wc/uUzqPsmf/cIO/BjQIMMj7NE2Ck/VP8qbCaNjR2JPcHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670531; c=relaxed/simple;
	bh=SWE9gSmuNSZa/bBGdZNKJvtdTSw2W9hfegwyfvxdpf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fAB1aOs3C/JzVQZ6s1FrtmXS8prY7SpV4d18qRixXXSANnJV3y+P1EIXlld2ZgfUqI0mxyY+8aY6D2uzG+rs76jrDd/p+z7snkZexKkS1jL/NW4oDlcfWdl5umFKUuBKgUmrnS7C/shQ0+W7k+XGfr8MNq3UeC0dYBR/G8d984w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X10HUAxq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE556C4CEEC;
	Sat, 26 Apr 2025 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670530;
	bh=SWE9gSmuNSZa/bBGdZNKJvtdTSw2W9hfegwyfvxdpf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X10HUAxqJ6UiMUaXTEjTeyplhg9UrS2xZojSUXZ8EDzcTD182GPt4PcgtF7nMV/dn
	 jFVUBTTJWHkd4Y1IqjhfrMKYL4bBWUUi2FzqaIRP3n5ltlkegdayZxNCegAydVYjWy
	 HJsNlsqgOFK9h5/s27PCWgvXDDmTHFSrQ6wQTDpH7zjq05CbWwoHjXrOVN5bh9Mxx6
	 2FiqFCPyb3ujbzuANJ8bUWjHRv7XLtK4L9tiUr84tBy40ULdN2EU9AWq6R2lICEzL1
	 FzfsN3m8SyBpQotCDaEL/HS5xgjSa+FXoSeSUxe9IFmFaT3rLMYMaUDzeNwElThgfE
	 QJWDGdH626K7Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeG-0092VH-Hl;
	Sat, 26 Apr 2025 13:28:48 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 02/42] arm64: sysreg: Update ID_AA64MMFR4_EL1 description
Date: Sat, 26 Apr 2025 13:27:56 +0100
Message-Id: <20250426122836.3341523-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Resync the ID_AA64MMFR4_EL1 with the architectue description.

This results in:

- the new PoPS field
- the new NV2P1 value for the NV_frac field
- the new RMEGDI field
- the new SRMASK field

These fields have been generated from the reference JSON file.

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


