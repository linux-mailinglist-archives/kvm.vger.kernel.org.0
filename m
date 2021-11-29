Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8F6462159
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349891AbhK2UHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:07:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49344 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhK2UFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:05:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF0F0CE13F9
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AFBC53FCF;
        Mon, 29 Nov 2021 20:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216131;
        bh=JIlqAddKl/85lpIm3FWWCZ7fbOCEiWhQkqCIpNen/Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKxRWBZJtPq2mZZ7uVYc9BHyGwFM+Ms9WGiTI6X+o1PyFZuKEM7EOcPRpoGYrZMXI
         hGM0gaXx+DI+R7M4kHe4k8jamiJW3CIPx/E547crz5BcBbRXTJWsxQLUbM84V1LweL
         +G0y21TZBbM5qxOP3ltoq7t+kybNiduAEwQ9zlYMeA9a3ORuZWp6rhzyfoUm5vomLC
         cRO4e0G+lsFAGsK4gYVHlyzvBNruz4fVoJ8ZGAl6sy+1YrOW7rg4GysCKWW32CUB0i
         A2tA1dYznbyRPePw435Eeg/a55ldEr9Ym9N08fTUJHoQOoOtq7oVoler4/CJ2NtkUA
         kzhasaUXuYyeg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqo-008gvR-2h; Mon, 29 Nov 2021 20:02:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 03/69] KVM: arm64: Add minimal handling for the ARMv8.7 PMU
Date:   Mon, 29 Nov 2021 20:00:44 +0000
Message-Id: <20211129200150.351436-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running a KVM guest hosted on an ARMv8.7 machine, the host
kernel complains that it doesn't know about the architected number
of events.

Fix it by adding the PMUver code corresponding to PMUv3 for ARMv8.7.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211126115533.217903-1-maz@kernel.org
---
 arch/arm64/include/asm/sysreg.h | 1 +
 arch/arm64/kvm/pmu-emul.c       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 16b3f1a1d468..615dd6278f8b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -937,6 +937,7 @@
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

