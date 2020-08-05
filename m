Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A193023CEE9
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgHETJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgHES4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:56:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 655E922D70;
        Wed,  5 Aug 2020 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651998;
        bh=Ny3h164gZIWU26G4ILDBmkFKlB2pQLuuQwMsv5oeflc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxRnUjuCn6b3j0pO049V01Nf/Nqcs1NWF0Vh/PyXpbCLb/lRolXTP8O8K/QFiXJO9
         ewaAe88MxH68aTj7jWkqKUcmgmvSUz2MeJWRWj8mBQR+qcSVVTD0TQlJo20NmPMx/7
         7buafw+XagAHoMt3J4Mp5E5xxETFisQL9fU4Q1VQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfp-0004w9-Eq; Wed, 05 Aug 2020 18:57:57 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 39/56] KVM: arm64: pauth: Use ctxt_sys_reg() instead of raw sys_regs access
Date:   Wed,  5 Aug 2020 18:56:43 +0100
Message-Id: <20200805175700.62775-40-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
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
 arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 7cf14e4f9f77..70367699d69a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -364,11 +364,14 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
 	return false;
 }
 
-#define __ptrauth_save_key(regs, key)						\
-({										\
-	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
-	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
-})
+#define __ptrauth_save_key(ctxt, key)					\
+	do {								\
+	u64 __val;                                                      \
+	__val = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);                \
+	ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = __val;                   \
+	__val = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);                \
+	ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = __val;                   \
+} while(0)
 
 static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
@@ -380,11 +383,11 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 		return false;
 
 	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
-	__ptrauth_save_key(ctxt->sys_regs, APIA);
-	__ptrauth_save_key(ctxt->sys_regs, APIB);
-	__ptrauth_save_key(ctxt->sys_regs, APDA);
-	__ptrauth_save_key(ctxt->sys_regs, APDB);
-	__ptrauth_save_key(ctxt->sys_regs, APGA);
+	__ptrauth_save_key(ctxt, APIA);
+	__ptrauth_save_key(ctxt, APIB);
+	__ptrauth_save_key(ctxt, APDA);
+	__ptrauth_save_key(ctxt, APDB);
+	__ptrauth_save_key(ctxt, APGA);
 
 	vcpu_ptrauth_enable(vcpu);
 
-- 
2.27.0

