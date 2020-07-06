Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012542157C0
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 14:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgGFMzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 08:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbgGFMzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 08:55:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806C520722;
        Mon,  6 Jul 2020 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594040101;
        bh=Ny3h164gZIWU26G4ILDBmkFKlB2pQLuuQwMsv5oeflc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlAFn3bgh+s/J73zPeL5T2FWrMjeVWOyR93idajBpn9bBPovMzZNiH5Bm3rMmYsZW
         0jyChtXYhjC8Mcga4h+hEO0SEZ0z8wlvT/GOTQyLEo6Pd79yFOCoa+kvCsB4sG51pC
         We0w99ECx71QKx8yw0nPH/yaL0UdkM3K+KwbqwJs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsQeC-009SCo-3e; Mon, 06 Jul 2020 13:55:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 09/17] KVM: arm64: pauth: Use ctxt_sys_reg() instead of raw sys_regs access
Date:   Mon,  6 Jul 2020 13:54:17 +0100
Message-Id: <20200706125425.1671020-10-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706125425.1671020-1-maz@kernel.org>
References: <20200706125425.1671020-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, ascull@google.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
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

