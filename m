Return-Path: <kvm+bounces-18558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B50258D6CC2
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 285E71F23943
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FA982C60;
	Fri, 31 May 2024 23:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OBkANC0x"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A1F81AA5
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197260; cv=none; b=VmN8PYFjYTp4/nvpt+5eAU2y7am1l61BxdTUEcJvT2CGagW4gnkhZSr/iQ7O9XNEA3L8ckK0yU8zGKr35Tf8pyxViwjmSJcc6Gb7gj76VM4fkMLJ5e22z7K+wDccQcTNfmKxPT1ZozPm6N6zJWV4OYiGwqN2wXvhg1Ua8OH2N74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197260; c=relaxed/simple;
	bh=pFJHD9o++yzJwyBYFGBKxT1cNifApXrmtEGZMw3XLtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIlTmzMIns3pUSfiIIoZhFhUx6OBgLadGdbcPTchRRgmTLMi32ZIBbG+6iSFLLd3+waO7bmzgn+NmCQGmYh7yoUmGqFvPS/3lNmeLxZpSmVRjpfD9/DmRThWv4qqspPdwGbydL1vjzVEVI5RBuRMZK235TA91fprnjLIFao9S+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OBkANC0x; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MugG1lpmPkesneX/x1COnHlwfCvxyqNLT6mwBb/PS14=;
	b=OBkANC0x0WK+ObbFrkVUOmiLTXp2ddbKuzNNHv3G5Vg1/yVqby7qRpQ7GMVjAZQOriVscO
	6haV3VJ8DFd6hfTP27k5wfLO2ubqZnGgMQz6l6RkCRhjCB/XMFdG6YnTGrGkXit0aEKPYy
	ji6Vv34llI754DPefCc57+Q9Xvqs4vY=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: jintack.lim@linaro.org
X-Envelope-To: christoffer.dall@arm.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Jintack Lim <jintack.lim@linaro.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 01/11] KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor
Date: Fri, 31 May 2024 23:13:48 +0000
Message-ID: <20240531231358.1000039-2-oliver.upton@linux.dev>
In-Reply-To: <20240531231358.1000039-1-oliver.upton@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jintack Lim <jintack.lim@linaro.org>

Give precedence to the guest hypervisor's trap configuration when
routing an FP/ASIMD trap taken to EL2. Take advantage of the
infrastructure for translating CPTR_EL2 into the VHE (i.e. EL1) format
and base the trap decision solely on the VHE view of the register.

Bury all of this behind a macro keyed off of the CPTR bitfield in
anticipation of supporting other traps (e.g. SVE).

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: account for HCR_EL2.E2H when testing for TFP/FPEN, with
 all the hard work actually being done by Chase Conklin]
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ oliver: translate nVHE->VHE format for testing traps; macro for reuse
 in other CPTR_EL2.xEN fields ]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h    | 43 +++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_nested.h     |  1 -
 arch/arm64/kvm/handle_exit.c            | 16 ++++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 ++
 4 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 501e3e019c93..3dd2d80d0cfb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -11,6 +11,7 @@
 #ifndef __ARM64_KVM_EMULATE_H__
 #define __ARM64_KVM_EMULATE_H__
 
+#include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 
 #include <asm/debug-monitors.h>
@@ -599,4 +600,46 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 
 	kvm_write_cptr_el2(val);
 }
+
+/*
+ * Returns a 'sanitised' view of CPTR_EL2, translating from nVHE to the VHE
+ * format if E2H isn't set.
+ */
+static inline u64 vcpu_sanitised_cptr_el2(const struct kvm_vcpu *vcpu)
+{
+	u64 cptr = vcpu_read_sys_reg(vcpu, CPTR_EL2);
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		cptr = translate_cptr_el2_to_cpacr_el1(cptr);
+
+	return cptr;
+}
+
+static inline bool ____cptr_xen_trap_enabled(const struct kvm_vcpu *vcpu,
+					     unsigned int xen)
+{
+	switch (xen) {
+	case 0b00:
+	case 0b10:
+		return true;
+	case 0b01:
+		return vcpu_el2_tge_is_set(vcpu) && !vcpu_is_el2(vcpu);
+	case 0b11:
+	default:
+		return false;
+	}
+}
+
+#define __guest_hyp_cptr_xen_trap_enabled(vcpu, xen)				\
+	(!vcpu_has_nv(vcpu) ? false :						\
+	 ____cptr_xen_trap_enabled(vcpu,					\
+				   SYS_FIELD_GET(CPACR_ELx, xen,		\
+						 vcpu_sanitised_cptr_el2(vcpu))))
+
+static inline bool guest_hyp_fpsimd_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	return __guest_hyp_cptr_xen_trap_enabled(vcpu, FPEN);
+}
+
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5e0ab0596246..5d55f76254c3 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -75,5 +75,4 @@ static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
 	return false;
 }
 #endif
-
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b037f0a0e27e..59fe9b10a87a 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -94,11 +94,19 @@ static int handle_smc(struct kvm_vcpu *vcpu)
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
@@ -304,7 +312,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_BREAKPT_LOW]= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
-	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
+	[ESR_ELx_EC_FP_ASIMD]	= kvm_handle_fpasimd,
 	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
 };
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a92566f36022..b302d32f8326 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -341,6 +341,9 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	/* Only handle traps the vCPU can support here: */
 	switch (esr_ec) {
 	case ESR_ELx_EC_FP_ASIMD:
+		/* Forward traps to the guest hypervisor as required */
+		if (guest_hyp_fpsimd_traps_enabled(vcpu))
+			return false;
 		break;
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)
-- 
2.45.1.288.g0e0cd299f1-goog


