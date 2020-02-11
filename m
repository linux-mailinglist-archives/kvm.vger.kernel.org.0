Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD09F1596CC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgBKRvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgBKRvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:46 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E71120661;
        Tue, 11 Feb 2020 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443505;
        bh=/f2Xo9z6ABnZFrjbNY2DUZXX0BqaADfqp97+fkRaLFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6XlXcVElAGuLukxHE8s/3/xKQky48ltUFJ+DGNxA5rgyeI1FJFCRokoQ+cgmGnUh
         tah2TFs5vNMX/sFquSH4qKSv0Coe4Uc8YkOCe/tuVGlAbm/3STT8g7RUMTKaKpfaI9
         /28iyb2Cf8IRNq+3Fi5u95UkPbOk5uhbLmPebnIs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgA-004O7k-Os; Tue, 11 Feb 2020 17:50:34 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 70/94] arm64: KVM: nv: Add include containing the VNCR_EL2 offsets
Date:   Tue, 11 Feb 2020 17:49:14 +0000
Message-Id: <20200211174938.27809-71-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNCR_EL2 points to a page containing a number of system registers
accessed by a guest hypervisor when ARMv8.4-NV is enabled.

Let's document the offsets in that page, as we are going to use
this layout.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/vncr_mapping.h | 73 +++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h

diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
new file mode 100644
index 000000000000..64c46d658fc8
--- /dev/null
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * System register offsets in the VNCR page
+ * All offsets are *byte* displacements!
+ */
+
+#ifndef __ARM64_VNCR_MAPPING_H__
+#define __ARM64_VNCR_MAPPING_H__
+
+#define VNCR_VTTBR_EL2          0x020
+#define VNCR_VTCR_EL2           0x040
+#define VNCR_VMPIDR_EL2         0x050
+#define VNCR_CNTVOFF_EL2        0x060
+#define VNCR_HCR_EL2            0x078
+#define VNCR_HSTR_EL2           0x080
+#define VNCR_VPIDR_EL2          0x088
+#define VNCR_TPIDR_EL2          0x090
+#define VNCR_VNCR_EL2           0x0B0
+#define VNCR_CPACR_EL1          0x100
+#define VNCR_CONTEXTIDR_EL1     0x108
+#define VNCR_SCTLR_EL1          0x110
+#define VNCR_ACTLR_EL1          0x118
+#define VNCR_TCR_EL1            0x120
+#define VNCR_AFSR0_EL1          0x128
+#define VNCR_AFSR1_EL1          0x130
+#define VNCR_ESR_EL1            0x138
+#define VNCR_MAIR_EL1           0x140
+#define VNCR_AMAIR_EL1          0x148
+#define VNCR_MDSCR_EL1          0x158
+#define VNCR_SPSR_EL1           0x160
+#define VNCR_CNTV_CVAL_EL0      0x168
+#define VNCR_CNTV_CTL_EL0       0x170
+#define VNCR_CNTP_CVAL_EL0      0x178
+#define VNCR_CNTP_CTL_EL0       0x180
+#define VNCR_SCXTNUM_EL1        0x188
+#define VNCR_ZCR_EL1            0x1E0
+#define VNCR_TTBR0_EL1          0x200
+#define VNCR_TTBR1_EL1          0x210
+#define VNCR_FAR_EL1            0x220
+#define VNCR_ELR_EL1            0x230
+#define VNCR_SP_EL1             0x240
+#define VNCR_VBAR_EL1           0x250
+#define VNCR_ICH_LR0_EL2        0x400
+//      VNCR_ICH_LRN_EL2(n)     VNCR_ICH_LR0_EL2+8*((n) & 7)
+#define VNCR_ICH_AP0R0_EL2      0x480
+//      VNCR_ICH_AP0RN_EL2(n)   VNCR_ICH_AP0R0_EL2+8*((n) & 3)
+#define VNCR_ICH_AP1R0_EL2      0x4A0
+//      VNCR_ICH_AP1RN_EL2(n)   VNCR_ICH_AP1R0_EL2+8*((n) & 3)
+#define VNCR_ICH_HCR_EL2        0x4C0
+#define VNCR_ICH_VMCR_EL2       0x4C8
+#define VNCR_VDISR_EL2          0x500
+#define VNCR_PMBLIMITR_EL1      0x800
+#define VNCR_PMBPTR_EL1         0x810
+#define VNCR_PMBSR_EL1          0x820
+#define VNCR_PMSCR_EL1          0x828
+#define VNCR_PMSEVFR_EL1        0x830
+#define VNCR_PMSICR_EL1         0x838
+#define VNCR_PMSIRR_EL1         0x840
+#define VNCR_PMSLATFR_EL1       0x848
+#define VNCR_TRFCR_EL1          0x880
+#define VNCR_MPAM1_EL1          0x900
+#define VNCR_MPAMHCR_EL2        0x930
+#define VNCR_MPAMVPMV_EL2       0x938
+#define VNCR_MPAMVPM0_EL2       0x940
+#define VNCR_MPAMVPM1_EL2       0x948
+#define VNCR_MPAMVPM2_EL2       0x950
+#define VNCR_MPAMVPM3_EL2       0x958
+#define VNCR_MPAMVPM4_EL2       0x960
+#define VNCR_MPAMVPM5_EL2       0x968
+#define VNCR_MPAMVPM6_EL2       0x970
+#define VNCR_MPAMVPM7_EL2       0x978
+
+#endif /* __ARM64_VNCR_MAPPING_H__ */
-- 
2.20.1

