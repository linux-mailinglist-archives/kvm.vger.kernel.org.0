Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5086D33417B
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 16:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhCJP1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 10:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhCJP1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 10:27:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5CA164F77;
        Wed, 10 Mar 2021 15:27:11 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lK0jt-000n3G-WC; Wed, 10 Mar 2021 15:27:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, qperret@google.com,
        kernel-team@android.com
Subject: [PATCH 2/4] KVM: arm64: Use INIT_SCTLR_EL2_MMU_OFF to disable the MMU on KVM teardown
Date:   Wed, 10 Mar 2021 15:26:54 +0000
Message-Id: <20210310152656.3821253-3-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310152656.3821253-1-maz@kernel.org>
References: <20210310152656.3821253-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, will@kernel.org, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of doing a RMW on SCTLR_EL2 to disable the MMU, use the
existing define that loads the right set of bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index c631e29fb001..4eb584ae13d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -221,9 +221,7 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
 	mov	x0, xzr
 reset:
 	/* Reset kvm back to the hyp stub. */
-	mrs	x5, sctlr_el2
-	mov_q	x6, SCTLR_ELx_FLAGS
-	bic	x5, x5, x6		// Clear SCTL_M and etc
+	mov_q	x5, INIT_SCTLR_EL2_MMU_OFF
 	pre_disable_mmu_workaround
 	msr	sctlr_el2, x5
 	isb
-- 
2.29.2

