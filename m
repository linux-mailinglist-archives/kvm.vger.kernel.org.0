Return-Path: <kvm+bounces-39144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2950AA448BD
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D406A8863E4
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B136120DD79;
	Tue, 25 Feb 2025 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkywAXEH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A061A5BAC;
	Tue, 25 Feb 2025 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504586; cv=none; b=uIpkj8Bw9y/TXoKXrFd6ByJvqN5BdnIPjUbdlYk+ANzJuqZyoaDD1C9CW4gpr8NdIi4/btpG1r8zj162EtPHsUxe4x3dfKRGb/7l3UzVNLR3P5Ei6dCitYn47lLt3x7kKIDfmq2DJwCLlf4R7zMSmw4s6P1joLbrnNBbWgP4A4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504586; c=relaxed/simple;
	bh=yuFlDaL+lICxdp2tle8fmEhBUnWIS+5Z4d11toXNzuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W4bKO8iiVaJUyUtL8m7yF7e3GKJeA+5k1o1knngMS0rlPi4IwzpN5BrEmDMxkzIzAa+BiNONsoEFe8DU7B8fHRHFey6SzCpcr6AV4sgnRg97q7JKNWbTJuATK6AcanGicJB2hQrka9zX+OpYy8BtE6bHJSk354Qw9T5SvVxKCec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkywAXEH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7183FC4CEDD;
	Tue, 25 Feb 2025 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504586;
	bh=yuFlDaL+lICxdp2tle8fmEhBUnWIS+5Z4d11toXNzuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkywAXEHE+vXVsJO8cTN+uazJApsc5KRhQlVX7lPa2dFPqVNu2vGKtxcow1GVV5Cg
	 prluah5FAkTD1Th87m7x9ytzEp2g+xU7svlXR3yL2+8IeZoI7yH6yWkGO2sDFvFP9p
	 72I+4Qcoana3Svzygo+AvAWM/21DFs/eM9CLvX40uDgRJUAlCKy1IIi13vwieOCyL5
	 rMd0IetCSibR6N8Wop4r6mcgttuDenMAYreLL2gmmydC6h7vKKW3aXZz986fnVWW4l
	 raIoL6er8hEJRLf92GxwQBHujlihfgWfjadJpuUKJwfap9bcPjvmRHe8uLDmkwlnCc
	 6XYISfjL6DQaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tmyka-007rKs-B5;
	Tue, 25 Feb 2025 17:29:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 03/16] arm64: sysreg: Add layout for ICH_MISR_EL2
Date: Tue, 25 Feb 2025 17:29:17 +0000
Message-Id: <20250225172930.1850838-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250225172930.1850838-1-maz@kernel.org>
References: <20250225172930.1850838-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ICH_MISR_EL2-related macros are missing a number of status
bits that we are about to handle. Take this opportunity to fully
describe the layout of that register as part of the automatic
generation infrastructure.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h       |  5 -----
 arch/arm64/tools/sysreg               | 12 ++++++++++++
 tools/arch/arm64/include/asm/sysreg.h |  5 -----
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b59b2c680e977..9511f3faac462 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -562,7 +562,6 @@
 
 #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-#define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
 #define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
@@ -983,10 +982,6 @@
 #define SYS_MPIDR_SAFE_VAL	(BIT(31))
 
 /* GIC Hypervisor interface registers */
-/* ICH_MISR_EL2 bit definitions */
-#define ICH_MISR_EOI		(1 << 0)
-#define ICH_MISR_U		(1 << 1)
-
 /* ICH_LR*_EL2 bit definitions */
 #define ICH_LR_VIRTUAL_ID_MASK	((1ULL << 32) - 1)
 
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 3e82a072eb493..2c63662c1a489 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3071,6 +3071,18 @@ Res0	17:5
 Field	4:0	ListRegs
 EndSysreg
 
+Sysreg	ICH_MISR_EL2	3	4	12	11	2
+Res0	63:8
+Field	7	VGrp1D
+Field	6	VGrp1E
+Field	5	VGrp0D
+Field	4	VGrp0E
+Field	3	NP
+Field	2	LRENP
+Field	1	U
+Field	0	EOI
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 5d9d7e394b254..b6c5ece4fdee7 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -558,7 +558,6 @@
 
 #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-#define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
 #define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
@@ -979,10 +978,6 @@
 #define SYS_MPIDR_SAFE_VAL	(BIT(31))
 
 /* GIC Hypervisor interface registers */
-/* ICH_MISR_EL2 bit definitions */
-#define ICH_MISR_EOI		(1 << 0)
-#define ICH_MISR_U		(1 << 1)
-
 /* ICH_LR*_EL2 bit definitions */
 #define ICH_LR_VIRTUAL_ID_MASK	((1ULL << 32) - 1)
 
-- 
2.39.2


