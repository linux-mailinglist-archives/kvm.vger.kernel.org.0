Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA2C159710
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgBKRws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730560AbgBKRwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:52:46 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C1D20661;
        Tue, 11 Feb 2020 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443565;
        bh=UoVrt09wjYGMlc6RAiUdRunAn2VHL7X7dd7By3r8axA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4uMU9VbThl1fcl4HvyyvSDn5PRdej1bQJb9B8X9dpWbnWV0QUsKHESUvQk9tIc5L
         g8XB1TGSBanxkRF3vPtgBiKIlmW71CiX/Wzyv8kn+hA6QKWxnPOq6KS8IitCtq1vls
         PtzGWPAoKwKc/LNLrxOqxQ2BOyMi7pcV2BrucIIg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgD-004O7k-57; Tue, 11 Feb 2020 17:50:37 +0000
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
Subject: [PATCH v2 74/94] KVM: arm64: pauth: Use ctxt_sys_reg() instead of raw sys_regs access
Date:   Tue, 11 Feb 2020 17:49:18 +0000
Message-Id: <20200211174938.27809-75-maz@kernel.org>
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

Now that we have a wrapper for the sysreg accesses, let's use that
consistently.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 10f13bd2e319..9678e2389c2f 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -217,10 +217,11 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-#define __ptrauth_save_key(regs, key)						\
+
+#define __ptrauth_save_key(ctxt, key)						\
 ({										\
-	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
-	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+	ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = read_sysreg_s(SYS_ ## key ## KEYLO_EL1); \
+	ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
 })
 
 /*
@@ -234,11 +235,11 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
 	if (vcpu_has_ptrauth(vcpu)) {
 		vcpu_ptrauth_enable(vcpu);
 		ctxt = vcpu->arch.host_cpu_context;
-		__ptrauth_save_key(ctxt->sys_regs, APIA);
-		__ptrauth_save_key(ctxt->sys_regs, APIB);
-		__ptrauth_save_key(ctxt->sys_regs, APDA);
-		__ptrauth_save_key(ctxt->sys_regs, APDB);
-		__ptrauth_save_key(ctxt->sys_regs, APGA);
+		__ptrauth_save_key(ctxt, APIA);
+		__ptrauth_save_key(ctxt, APIB);
+		__ptrauth_save_key(ctxt, APDA);
+		__ptrauth_save_key(ctxt, APDB);
+		__ptrauth_save_key(ctxt, APGA);
 	} else {
 		kvm_inject_undefined(vcpu);
 	}
-- 
2.20.1

