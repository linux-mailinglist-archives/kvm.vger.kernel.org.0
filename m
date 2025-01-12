Return-Path: <kvm+bounces-35234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0AEA0AB1D
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4142F1885EFB
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 676581C07FA;
	Sun, 12 Jan 2025 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlhOf7f8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860421BEF77;
	Sun, 12 Jan 2025 17:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701731; cv=none; b=eytL+zjsgtFRWx7oW9f91gPv854uPLqrf8rUF52l/5Z94jf2UW64snaEgYo1HRgvtDk9zFtWkX/U+hz2R1KzNRjbB0zkhORQ+8hj4dIRHs17K84ovnzJ24rwdPtIkTB4VJ/IIC/3UjmCfQr7GUfuG8ziHVbRHwzJWZpzs+xsm58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701731; c=relaxed/simple;
	bh=irvSisWdAInReDQ60ym0hyaAWo7RRhDjgjlmicXlLCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZZvL9Um91X2E7ftDKjbGuVlmd1jWM9nT/CLIQUU9jQd8c1xqltQScB0RP3lbs2OQ27FveP1bJf6iH2R8Yt8CDRNx4iMnAHO/R8i0fNL41CHflQfJNflwRuA/DN2y1BmxkTRATmwdc+G+pafxnjeP3v0JD4wgI+ccT3gDLDISI5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlhOf7f8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F28C4CEE0;
	Sun, 12 Jan 2025 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736701731;
	bh=irvSisWdAInReDQ60ym0hyaAWo7RRhDjgjlmicXlLCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlhOf7f8FK6GPUU7CsV5bWrCvZMjP+yQcTYqWH/rWUDAUVZLyduNLk5oB97a1Shxv
	 DVMENmBD3P7Kdq1A5fFFqjRwPgRZ5MSOo7yNA/ls892nAifR2KUfjAjmIi3QO2N3DV
	 5P6UyEs7LDEpfBunEtjJf/BvvOAAZGhjEqFmEkP/Mj58Jznq5jfcij8fzRD03q6P3i
	 DFc8yUD9s822glF3BAFo6V36iktGowieXyF7Uhs3Jpt1A5iY+h+cZ1iPby/UnSGyNU
	 hfi4TxpLQpLuEkcAN3nQHBqcfFDlhJiPiIrwjadcoZyMvO3Dvj0Ber2CvP4gxPrl3I
	 JrmDcgn7JVdgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1SD-00BNxR-6t;
	Sun, 12 Jan 2025 17:08:49 +0000
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
Subject: [PATCH v2 03/17] arm64: sysreg: Add layout for ICH_MISR_EL2
Date: Sun, 12 Jan 2025 17:08:31 +0000
Message-Id: <20250112170845.1181891-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250112170845.1181891-1-maz@kernel.org>
References: <20250112170845.1181891-1-maz@kernel.org>
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h       |  5 -----
 arch/arm64/tools/sysreg               | 12 ++++++++++++
 tools/arch/arm64/include/asm/sysreg.h |  5 -----
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index cf74ebcd46d95..815e9b0bdff27 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -561,7 +561,6 @@
 
 #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-#define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
 #define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
@@ -991,10 +990,6 @@
 #define TRFCR_ELx_E0TRE			BIT(0)
 
 /* GIC Hypervisor interface registers */
-/* ICH_MISR_EL2 bit definitions */
-#define ICH_MISR_EOI		(1 << 0)
-#define ICH_MISR_U		(1 << 1)
-
 /* ICH_LR*_EL2 bit definitions */
 #define ICH_LR_VIRTUAL_ID_MASK	((1ULL << 32) - 1)
 
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index f5927d345eea3..a601231a088d7 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2974,6 +2974,18 @@ Res0	17:5
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
index f43e303d31d25..0169bd3137caf 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -420,7 +420,6 @@
 
 #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-#define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
 #define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
@@ -634,10 +633,6 @@
 #define TRFCR_ELx_E0TRE			BIT(0)
 
 /* GIC Hypervisor interface registers */
-/* ICH_MISR_EL2 bit definitions */
-#define ICH_MISR_EOI		(1 << 0)
-#define ICH_MISR_U		(1 << 1)
-
 /* ICH_LR*_EL2 bit definitions */
 #define ICH_LR_VIRTUAL_ID_MASK	((1ULL << 32) - 1)
 
-- 
2.39.2


