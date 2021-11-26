Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017DC45ED30
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 12:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377198AbhKZMAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346217AbhKZL6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 06:58:53 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAE6E61107;
        Fri, 26 Nov 2021 11:55:40 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mqZpK-00818T-FY; Fri, 26 Nov 2021 11:55:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH] KVM: arm64: Add minimal handling for the ARMv8.7 PMU
Date:   Fri, 26 Nov 2021 11:55:33 +0000
Message-Id: <20211126115533.217903-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running a KVM guest hosted on an ARMv8.7 machine, the host
kernel complains that it doesn't know about the architected number
of events.

Fix it by adding the PMUver code corresponding to PMUv3 for ARMv8.7.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 1 +
 arch/arm64/kvm/pmu-emul.c       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index cdb590840b3f..5de90138d0a4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1036,6 +1036,7 @@
 #define ID_AA64DFR0_PMUVER_8_1		0x4
 #define ID_AA64DFR0_PMUVER_8_4		0x5
 #define ID_AA64DFR0_PMUVER_8_5		0x6
+#define ID_AA64DFR0_PMUVER_8_7		0x7
 #define ID_AA64DFR0_PMUVER_IMP_DEF	0xf
 
 #define ID_AA64DFR0_PMSVER_8_2		0x1
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a5e4bbf5e68f..ca92cc5c71c6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -28,6 +28,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	case ID_AA64DFR0_PMUVER_8_1:
 	case ID_AA64DFR0_PMUVER_8_4:
 	case ID_AA64DFR0_PMUVER_8_5:
+	case ID_AA64DFR0_PMUVER_8_7:
 		return GENMASK(15, 0);
 	default:		/* Shouldn't be here, just for sanity */
 		WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
-- 
2.30.2

