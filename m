Return-Path: <kvm+bounces-20123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DFA9910D75
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33DB6285862
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7D61B29CF;
	Thu, 20 Jun 2024 16:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VmF6mshm"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B59C1AD9D5
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902033; cv=none; b=mHdZ6KUxJjLu6SiFF5iBoYxZjvX1qm2QeynJqXlEMVnKCvJox9ejSd+FRlc6Z2TVmSgKTKf8ndxxsPMNRFkna/I2rWlopDsDMy3+WfUU/E3/q8Jj/wZkq2heKSYuBAvREcEw/ElECYWmvcth3XZQ7YYpRaA/DnQJK8pMk3naJoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902033; c=relaxed/simple;
	bh=8F+cL1uAYf9JGVDeoFp8WvE/ix2DTBKwTTvZ3EaCKD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLWpZzdw76Z+IgQpr4dMm5r6TvtqpvvVOztRzfcsovsZsWE0yAf4UrRhpMNhIXJr8BzP0iaSYUyavdg+jEX3JA35SrqotoZfvYqeVMvYTH6AIfLn9bQW04eTQ50Qhomt6cP/SsbTxV1AVTCxfIYqM4ehkk167jtwf7ErYERhVVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VmF6mshm; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cRgjmZ9/UVonezZxApoYoSKYJAYeAK2PT3Zy3D03wwQ=;
	b=VmF6mshmzB67F73iqjv4kNAfje8VuxqK7ctdHZlT/HwkldBWf+0Wa3MsW15Zp9KwF2hqB5
	nJUoXhnD6GCqT4fsd5TqFKMlgLEM4L2+2H2EsGF6ZhteNJNRAA2tQGn9QqV+27pVS8aIYB
	5mYJMCV1iJYTa9u/nv+72jGdrKUE4A4=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
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
	Fuad Tabba <tabba@google.com>,
	Jintack Lim <jintack.lim@linaro.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 01/15] KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor
Date: Thu, 20 Jun 2024 16:46:38 +0000
Message-ID: <20240620164653.1130714-2-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
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
and base the trap decision solely on the VHE view of the register. The
in-memory value of CPTR_EL2 will always be up to date for the guest
hypervisor (more on that later), so just read it directly from memory.

Bury all of this behind a macro keyed off of the CPTR bitfield in
anticipation of supporting other traps (e.g. SVE).

[maz: account for HCR_EL2.E2H when testing for TFP/FPEN, with
 all the hard work actually being done by Chase Conklin]
[ oliver: translate nVHE->VHE format for testing traps; macro for reuse
 in other CPTR_EL2.xEN fields ]

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h    | 43 +++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c            | 16 ++++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 ++
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 501e3e019c93..c3c5a5999ed7 100644
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
+	u64 cptr = __vcpu_sys_reg(vcpu, CPTR_EL2);
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
2.45.2.741.gdbec12cfda-goog


