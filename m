Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E34E298DFF
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 14:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780196AbgJZNfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 09:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1769388AbgJZNfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 09:35:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BA8124641;
        Mon, 26 Oct 2020 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603719305;
        bh=728XYeIVEe91tr8jUABFBLzP2IHWs5kpZFIXWOsVUaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvtp4GhnalvfJq8ktJ4Cr1h1RPF1l3SOH60kTwFmHjmnHmAyujJ0Ixw1McgG3vB4o
         f3IBK3c7wC8i1FN9sxE26VIuFrSbTMHNGVxLwWZrsow/iG9LCdktjcnV8aISBTvjSR
         U8uuupYw9p46zsArpR+sF7UXX0267PssLJxFSY9Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kX2eN-004Kjh-F0; Mon, 26 Oct 2020 13:35:03 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: [PATCH 04/11] KVM: arm64: Move PC rollback on SError to HYP
Date:   Mon, 26 Oct 2020 13:34:43 +0000
Message-Id: <20201026133450.73304-5-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026133450.73304-1-maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of handling the "PC rollback on SError during HVC" at EL1 (which
requires disclosing PC to a potentially untrusted kernel), let's move
this fixup to ... fixup_guest_exit(), which is where we do all fixups.

Isn't that neat?

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c            | 17 -----------------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d4e00a864ee6..f79137ee4274 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -241,23 +241,6 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 {
 	struct kvm_run *run = vcpu->run;
 
-	if (ARM_SERROR_PENDING(exception_index)) {
-		u8 esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
-
-		/*
-		 * HVC already have an adjusted PC, which we need to
-		 * correct in order to return to after having injected
-		 * the SError.
-		 *
-		 * SMC, on the other hand, is *trapped*, meaning its
-		 * preferred return address is the SMC itself.
-		 */
-		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
-			*vcpu_pc(vcpu) -= 4;
-
-		return 1;
-	}
-
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
 
 	switch (exception_index) {
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d687e574cde5..668f02c7b0b3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -411,6 +411,21 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
+	if (ARM_SERROR_PENDING(*exit_code)) {
+		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
+
+		/*
+		 * HVC already have an adjusted PC, which we need to
+		 * correct in order to return to after having injected
+		 * the SError.
+		 *
+		 * SMC, on the other hand, is *trapped*, meaning its
+		 * preferred return address is the SMC itself.
+		 */
+		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
+			*vcpu_pc(vcpu) -= 4;
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.28.0

