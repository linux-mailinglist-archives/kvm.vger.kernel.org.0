Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6AA42BF6D
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhJMMGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhJMMGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:06:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D681D60273;
        Wed, 13 Oct 2021 12:03:59 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maczG-00GTgY-1a; Wed, 13 Oct 2021 13:03:58 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com, tabba@google.com
Subject: [PATCH v9 12/22] KVM: arm64: Fix early exit ptrauth handling
Date:   Wed, 13 Oct 2021 13:03:36 +0100
Message-Id: <20211013120346.2926621-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The previous rework of the early exit code to provide an EC-based
decoding tree missed the fact that we have two trap paths for
ptrauth: the instructions (EC_PAC) and the sysregs (EC_SYS64).

Rework the handlers to call the ptrauth handling code on both
paths.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 481399bf9b94..4126926c3e06 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -282,14 +282,6 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 
 static inline bool esr_is_ptrauth_trap(u32 esr)
 {
-	u32 ec = ESR_ELx_EC(esr);
-
-	if (ec == ESR_ELx_EC_PAC)
-		return true;
-
-	if (ec != ESR_ELx_EC_SYS64)
-		return false;
-
 	switch (esr_sys64_to_sysreg(esr)) {
 	case SYS_APIAKEYLO_EL1:
 	case SYS_APIAKEYHI_EL1:
@@ -323,8 +315,7 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
 	struct kvm_cpu_context *ctxt;
 	u64 val;
 
-	if (!vcpu_has_ptrauth(vcpu) ||
-	    !esr_is_ptrauth_trap(kvm_vcpu_get_esr(vcpu)))
+	if (!vcpu_has_ptrauth(vcpu))
 		return false;
 
 	ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
@@ -353,6 +344,9 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
 		return true;
 
+	if (esr_is_ptrauth_trap(kvm_vcpu_get_esr(vcpu)))
+		return kvm_hyp_handle_ptrauth(vcpu, exit_code);
+
 	return false;
 }
 
-- 
2.30.2

