Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19A32989CF
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 10:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768642AbgJZJvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 05:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1744058AbgJZJvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 05:51:35 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4FCD20704;
        Mon, 26 Oct 2020 09:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705894;
        bh=iXV3E2z/slo20WC0V3cblfjeTSEIcPapQ/Yewe0mKc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1G82dADv4qiv/PlTgluqvce2lhYajgrRhWQfxWhD26+qkPtCqwzh33Cc73ZH+YCj6
         1icoLD+Ym80cOYWI/1IrHzk+r7JImXTptGXnCWZH87gG4f3PpTYhtQqv9J6p2IcDn4
         HtCxe2n1WbXOemW4Zcm4kbI7w0PHNTRm45zUjsZA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kWzA4-004HZn-UP; Mon, 26 Oct 2020 09:51:33 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com
Subject: [PATCH 7/8] KVM: arm64: Simplify __kvm_enable_ssbs()
Date:   Mon, 26 Oct 2020 09:51:15 +0000
Message-Id: <20201026095116.72051-8-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026095116.72051-1-maz@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the setting of SSBS directly into the HVC handler, using
the C helpers rather than the inline asssembly code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h    |  2 --
 arch/arm64/include/asm/sysreg.h     |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c  |  6 +++++-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c | 11 -----------
 4 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 54387ccd1ab2..a542c422a036 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -189,8 +189,6 @@ extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
-extern void __kvm_enable_ssbs(void);
-
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
 extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d52c1b3ce589..c9423f36e05c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -461,6 +461,7 @@
 
 #define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
 
+#define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
 #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
 #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2af8a5e902af..5125e934da22 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -58,7 +58,11 @@ static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
 
 static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
 {
-	__kvm_enable_ssbs();
+	u64 tmp;
+
+	tmp = read_sysreg_el2(SYS_SCTLR);
+	tmp |= SCTLR_ELx_DSSBS;
+	write_sysreg_el2(tmp, SYS_SCTLR);
 }
 
 static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
index 88a25fc8fcd3..29305022bc04 100644
--- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -33,14 +33,3 @@ void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_user_state(ctxt);
 	__sysreg_restore_el2_return_state(ctxt);
 }
-
-void __kvm_enable_ssbs(void)
-{
-	u64 tmp;
-
-	asm volatile(
-	"mrs	%0, sctlr_el2\n"
-	"orr	%0, %0, %1\n"
-	"msr	sctlr_el2, %0"
-	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
-}
-- 
2.28.0

