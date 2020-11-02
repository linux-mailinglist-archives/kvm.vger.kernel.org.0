Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA402A2FFE
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgKBQlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbgKBQlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:41:07 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5229A222BA;
        Mon,  2 Nov 2020 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604335266;
        bh=LbFIUMvh/XxufxroOMxcM/bchWyuyq7+XF1PJEMLgS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RK3T0X4yVX6/eJyxwqJSid6WzMcZDAf3cmXcoKfJPi6NgeLJym0ciXpl2GqYmzX13
         frNKnTaiQu0EXja4bCZhUFXouIxZYLFGzNE4hzxFfHgRpS8A16fmbD3WV0vp95Kj32
         W9lTB8xqYXH+fIFxQH4BDAkqUSoG2b6/7QNcUVfY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kZctE-006jJf-IK; Mon, 02 Nov 2020 16:41:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: [PATCH v2 01/11] KVM: arm64: Don't adjust PC on SError during SMC trap
Date:   Mon,  2 Nov 2020 16:40:35 +0000
Message-Id: <20201102164045.264512-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164045.264512-1-maz@kernel.org>
References: <20201102164045.264512-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, mark.rutland@arm.com, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On SMC trap, the prefered return address is set to that of the SMC
instruction itself. It is thus wrong to try and roll it back when
an SError occurs while trapping on SMC. It is still necessary on
HVC though, as HVC doesn't cause a trap, and sets ELR to returning
*after* the HVC.

It also became apparent that there is no 16bit encoding for an AArch32
HVC instruction, meaning that the displacement is always 4 bytes,
no matter what the ISA is. Take this opportunity to simplify it.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5d690d60ccad..79a720657c47 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -245,15 +245,15 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		u8 esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
 
 		/*
-		 * HVC/SMC already have an adjusted PC, which we need
-		 * to correct in order to return to after having
-		 * injected the SError.
+		 * HVC already have an adjusted PC, which we need to
+		 * correct in order to return to after having injected
+		 * the SError.
+		 *
+		 * SMC, on the other hand, is *trapped*, meaning its
+		 * preferred return address is the SMC itself.
 		 */
-		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64 ||
-		    esr_ec == ESR_ELx_EC_SMC32 || esr_ec == ESR_ELx_EC_SMC64) {
-			u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
-			*vcpu_pc(vcpu) -= adj;
-		}
+		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
+			*vcpu_pc(vcpu) -= 4;
 
 		return 1;
 	}
-- 
2.28.0

