Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EB849F933
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348433AbiA1MUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348443AbiA1MUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48739C061749
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:20:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBBDC61B04
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB78C340E0;
        Fri, 28 Jan 2022 12:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372406;
        bh=Sxjb2vw/86FO48Hzsm2TRTwfi1YJpsquRJf2MWg/u44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFPOfBOhwddcdbwxae4tEQUmW+kpbYFMgMb7q7WsfCtFdXMkCIVBvH6njvDYtMFvE
         L7pFX92+oNm0ceCcdI2y8QoP+dyDC154Np0kLN2MOLr7c0+wuXa/JgwyoMo7Dsa1Az
         thqY5pUqjJpwTczndMDMpb7LpvGZZyoD0FOMK0/ucOrvOplCugw+SqVWaUYWRFZ6Ck
         fEi4ACcO0uZ/0BfStwhWiLBl+bNlBYX2XXv7imXMjDkXFTyXHgMcAPvXiYdNL5lVyC
         L0CnfyIMPkXH8fBZxoGZPvi13nJ7mBq0c3tPHUw3FjGgoBzFIVOMQ9uDPU6wcY7Ojc
         Rr4eipbFbEb+w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQE2-003njR-Ap; Fri, 28 Jan 2022 12:19:34 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 23/64] KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
Date:   Fri, 28 Jan 2022 12:18:31 +0000
Message-Id: <20220128121912.509006-24-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

Forward traps due to FP/ASIMD register accesses to the virtual EL2
if virtual CPTR_EL2.TFP is set (with HCR_EL2.E2H == 0) or
CPTR_EL2.FPEN is configure to do so (with HCR_EL2.E2h == 1).

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: account for HCR_EL2.E2H when testing for TFP/FPEN, with
 all the hard work actually being done by Chase Conklin]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    | 26 +++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c            | 16 +++++++++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  8 ++++++--
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 54e8eee413eb..ff8980a39ee8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -11,12 +11,14 @@
 #ifndef __ARM64_KVM_EMULATE_H__
 #define __ARM64_KVM_EMULATE_H__
 
+#include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
 #include <asm/virt.h>
@@ -324,6 +326,30 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 	return mode != PSR_MODE_EL0t;
 }
 
+static inline bool guest_hyp_fpsimd_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	val = vcpu_read_sys_reg(vcpu, CPTR_EL2);
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		return (val & CPTR_EL2_TFP);
+
+	switch (FIELD_GET(CPACR_EL1_FPEN, val)) {
+	case 0b00:
+	case 0b10:
+		return true;
+	case 0b01:
+		return vcpu_el2_tge_is_set(vcpu) && !vcpu_is_el2(vcpu);
+	case 0b11:
+	default:		/* GCC is dumb */
+		return false;
+	}
+}
+
 static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index a1b1bbf3d598..a5c698f188d6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -96,11 +96,19 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Guest access to FP/ASIMD registers are routed to this handler only
- * when the system doesn't support FP/ASIMD.
+ * This handles the cases where the system does not support FP/ASIMD or when
+ * we are running nested virtualization and the guest hypervisor is trapping
+ * FP/ASIMD accesses by its guest guest.
+ *
+ * All other handling of guest vs. host FP/ASIMD register state is handled in
+ * fixup_guest_exit().
  */
-static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
+static int kvm_handle_fpasimd(struct kvm_vcpu *vcpu)
 {
+	if (guest_hyp_fpsimd_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
+	/* This is the case when the system doesn't support FP/ASIMD. */
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -231,7 +239,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_BREAKPT_LOW]= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
-	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
+	[ESR_ELx_EC_FP_ASIMD]	= kvm_handle_fpasimd,
 	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
 };
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 49c3b9eb09d7..42c47731f64e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -166,8 +166,12 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	sve_guest = vcpu_has_sve(vcpu);
 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
 
-	/* Don't handle SVE traps for non-SVE vcpus here: */
-	if (!sve_guest && esr_ec != ESR_ELx_EC_FP_ASIMD)
+	/*
+	 * Don't handle SVE traps for non-SVE vcpus here. This
+	 * includes NV guests for the time being.
+	 */
+	if (!sve_guest && (esr_ec != ESR_ELx_EC_FP_ASIMD ||
+			   guest_hyp_fpsimd_traps_enabled(vcpu)))
 		return false;
 
 	/* Valid trap.  Switch the context: */
-- 
2.30.2

