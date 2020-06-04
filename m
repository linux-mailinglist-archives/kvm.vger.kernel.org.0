Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824A11EE572
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 15:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgFDNeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 09:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728629AbgFDNeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 09:34:07 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAD8F20829;
        Thu,  4 Jun 2020 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591277647;
        bh=rotJuRrjsUR85tXo2BdW5+A/L5Ugu4nDYunoj5XseZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCGPpRD9IJ9+GPQ3TWSKTU05OHcM/VphXHokwWzbhrdpLFx/eDNRYwqji0n/HGzVV
         cMjCXN35g+TBwjZkQS/5sIya4Vp88R2C6w6htT97ukxGsKKmGjhQTipyHOHCIqkaQh
         pKPoUb5LNgL6imf5v3AJpUNMyapbYKQ0Erphzs/o=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jgq0T-000G3O-Er; Thu, 04 Jun 2020 14:34:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: [PATCH 3/3] KVM: arm64: Enforce PtrAuth being disabled if not advertized
Date:   Thu,  4 Jun 2020 14:33:54 +0100
Message-Id: <20200604133354.1279412-4-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200604133354.1279412-1-maz@kernel.org>
References: <20200604133354.1279412-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even if we don't expose PtrAuth to a guest, the guest can still
write to its SCTIRLE_1 register and set the En{I,D}{A,B} bits
and execute PtrAuth instructions from the NOP space. This has
the effect of trapping to EL2, and we currently inject an UNDEF.
This is definitely the wrong thing to do, as the architecture says
that these instructions should behave as NOPs.

Instead, we can simply reset the offending SCTLR_EL1 bits to
zero, and resume the guest. It can still observe the SCTLR bits
being set and then being cleared by magic, but that's much better
than delivering an unexpected extension.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 12 ------------
 arch/arm64/kvm/hyp/switch.c  | 18 ++++++++++++++++--
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5a02d4c90559..98d8adf6f865 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -162,17 +162,6 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-/*
- * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
- * a NOP). If we get here, it is that we didn't fixup ptrauth on exit, and all
- * that we can do is give the guest an UNDEF.
- */
-static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	kvm_inject_undefined(vcpu);
-	return 1;
-}
-
 static exit_handle_fn arm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
@@ -195,7 +184,6 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
-	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
 };
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 2a50b3771c3b..fc09c3dfa466 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -503,8 +503,22 @@ static bool __hyp_text __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *ctxt;
 	u64 val;
 
-	if (!vcpu_has_ptrauth(vcpu))
-		return false;
+	if (!vcpu_has_ptrauth(vcpu)) {
+		if (ec != ESR_ELx_EC_PAC)
+			return false;
+
+		/*
+		 * Interesting situation: the guest has enabled PtrAuth,
+		 * despite KVM not advertising it. Fix SCTLR_El1 on behalf
+		 * of the guest (the bits should behave as RES0 anyway).
+		 */
+		val = read_sysreg_el1(SYS_SCTLR);
+		val &= ~(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB |
+			 SCTLR_ELx_ENDA | SCTLR_ELx_ENDB);
+		write_sysreg_el1(val, SYS_SCTLR);
+
+		return true;
+	}
 
 	switch (ec) {
 	case ESR_ELx_EC_PAC:
-- 
2.26.2

