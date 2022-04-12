Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619854FE28A
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 15:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355913AbiDLNYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 09:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356339AbiDLNXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 09:23:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0B52601
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 06:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2058DB81D79
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDF8C385B3;
        Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769234;
        bh=XLnI3U5zZga9vGmdi6rlo1kNl6vQF/8E1bbAui24kME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiUBPmsrwEynJcwKFxX0fcFfOHlzOKmMMPyWCmsbFjOff1gs8Kw05TCNMt10oCCeY
         rZUTo351UpFWFQ1MWC3wSKXr2Wem/kajNKupEKT0TCNJWlNM6T+dOaIuMF34bqMbgj
         ZEGvFKRgZmj0kWFE97yGHPLqOEInRcEoAFjsDbsiEhlEdFdpX5zLURYRM1ACfG+M/I
         qN0P2YemZnNEHJ9wc6RFfFEM8ND0P0QlEXqkp4bEG2OhwYnGfCQMKEu7AXuu6eCwsJ
         3leaSZAf9EgzHtyYvt9mWRqrx/yn8m9HN8Trq3cStoauiUszjr3MslGbjEYCPVbUgS
         filWcWZbdoxcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1neGLA-003mvX-Dn; Tue, 12 Apr 2022 14:13:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 06/10] KVM: arm64: Offer early resume for non-blocking WFxT instructions
Date:   Tue, 12 Apr 2022 14:12:59 +0100
Message-Id: <20220412131303.504690-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For WFxT instructions used with very small delays, it is not
unlikely that the deadling is already expired by the time we
reach the WFx handling code.

Check for this condition as soon as possible, and return to the
guest immediately if we can.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 4260f2cd1971..87d9a36de860 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -80,17 +80,34 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
  *
  * @vcpu:	the vcpu pointer
  *
- * WFE: Yield the CPU and come back to this vcpu when the scheduler
+ * WFE[T]: Yield the CPU and come back to this vcpu when the scheduler
  * decides to.
  * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
  * world-switches and schedule other host processes until there is an
  * incoming IRQ or FIQ to the VM.
  * WFIT: Same as WFI, with a timed wakeup implemented as a background timer
+ *
+ * WF{I,E}T can immediately return if the deadline has already expired.
  */
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
 
+	if (esr & ESR_ELx_WFx_ISS_WFxT) {
+		if (esr & ESR_ELx_WFx_ISS_RV) {
+			u64 val, now;
+
+			now = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_TIMER_CNT);
+			val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
+
+			if (now >= val)
+				goto out;
+		} else {
+			/* Treat WFxT as WFx if RN is invalid */
+			esr &= ~ESR_ELx_WFx_ISS_WFxT;
+		}
+	}
+
 	if (esr & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
@@ -98,11 +115,13 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
-		if ((esr & (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT)) == (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT))
+
+		if (esr & ESR_ELx_WFx_ISS_WFxT)
 			vcpu->arch.flags |= KVM_ARM64_WFIT;
+
 		kvm_vcpu_wfi(vcpu);
 	}
-
+out:
 	kvm_incr_pc(vcpu);
 
 	return 1;
-- 
2.34.1

