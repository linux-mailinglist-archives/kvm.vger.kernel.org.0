Return-Path: <kvm+bounces-15241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FDE78AACDD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBA801F220C2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F9082D9C;
	Fri, 19 Apr 2024 10:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnFqITqc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74FA8173B;
	Fri, 19 Apr 2024 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522594; cv=none; b=tpQQ+ssEEb+Zi9jMV7GptYWsYP761+gIl4VDCze3NyqXpzadpyXEABjAjuLo9o7X40Tr+/y09OIllw0yxYJcddlePVLjxa9x2FRXQRapkUKJPqWmcPxIhr0bHdzYQ/EUXZdMRh7022gwNpo93nGa1yz6wyMIjl5TO1F8cjbE7mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522594; c=relaxed/simple;
	bh=Hh3LGeFs0C9lT4zyX7DVL1Zu42po1QdwGeQYaOoBnag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=um4pC7ekZYoTZOExL1oRq+IIwyn0croCgW1gmnU4y4biXr7EO5DDj/ucETZZPcfxjdjLncWndtxnrTbXo+aDwSzk3JPM1Lu1KCyo+fOHdWAS/h8dU7h7gx5u+DucLjwiuHP/6Baq2yLiYsRTIxxgjfiiGtvO5nhFSMjcCfnYqno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnFqITqc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA0CC32782;
	Fri, 19 Apr 2024 10:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522594;
	bh=Hh3LGeFs0C9lT4zyX7DVL1Zu42po1QdwGeQYaOoBnag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnFqITqccD2AJ3OwYxDy91yVUDodBAhWX+3+As2wPLzJdr4byMeKZeD52EsGKQwN6
	 /iJ/IXddu+dyCIIX+Aqw3rbdWHZkFkZn2OjUJbpHBfBRPFhEEFp14yPAnrTSUND2tO
	 p5q90R/NFocSAX9b9cEgJJKQH0VRY2E7EnCLw5JxrojOblqVl/26GILam3gPn/Ws+k
	 wYbLi6ENdnwXfDarmTcdDHesycfUc+ZV6z7AP2A9nUQvDB9zqT2YlNgpnMV6uW6Z/o
	 dmLVDHBGq1jmrAwmtnAH6wnfq86uCa5mNYXDuoIOAw4GimZilIaMeMoIE1Mgftuzsv
	 yV8LYa8NHUjSQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlVA-00636W-B5;
	Fri, 19 Apr 2024 11:29:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 15/15] KVM: arm64: Drop trapping of PAuth instructions/keys
Date: Fri, 19 Apr 2024 11:29:35 +0100
Message-Id: <20240419102935.1935571-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently insist on disabling PAuth on vcpu_load(), and get to
enable it on first guest use of an instruction or a key (ignoring
the NV case for now).

It isn't clear at all what this is trying to achieve: guests tend
to use PAuth when available, and nothing forces you to expose it
to the guest if you don't want to. This also isn't totally free:
we take a full GPR save/restore between host and guest, only to
write ten 64bit registers. The "value proposition" escapes me.

So let's forget this stuff and enable PAuth eagerly if exposed to
the guest. This results in much simpler code. Performance wise,
that's not bad either (tested on M2 Pro running a fully automated
Debian installer as the workload):

- On a non-NV guest, I can see reduction of 0.24% in the number
  of cycles (measured with perf over 10 consecutive runs)

- On a NV guest (L2), I see a 2% reduction in wall-clock time
  (measured with 'time', as M2 doesn't have a PMUv3 and NV
  doesn't support it either)

So overall, a much reduced complexity and a (small) performance
improvement.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h    |  5 --
 arch/arm64/include/asm/kvm_ptrauth.h    | 21 +++++++
 arch/arm64/kvm/arm.c                    | 45 +++++++++++++-
 arch/arm64/kvm/handle_exit.c            | 10 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 80 +------------------------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 -
 arch/arm64/kvm/hyp/vhe/switch.c         |  6 +-
 7 files changed, 70 insertions(+), 99 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 87f2c31f3206..382164d791f4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -125,11 +125,6 @@ static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 |= HCR_TWI;
 }
 
-static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
-}
-
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.vsesr_el2;
diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
index 0cd0965255d2..d81bac256abc 100644
--- a/arch/arm64/include/asm/kvm_ptrauth.h
+++ b/arch/arm64/include/asm/kvm_ptrauth.h
@@ -99,5 +99,26 @@ alternative_else_nop_endif
 .macro ptrauth_switch_to_hyp g_ctxt, h_ctxt, reg1, reg2, reg3
 .endm
 #endif /* CONFIG_ARM64_PTR_AUTH */
+
+#else  /* !__ASSEMBLY */
+
+#define __ptrauth_save_key(ctxt, key)					\
+	do {								\
+		u64 __val;                                              \
+		__val = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+		ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = __val;		\
+		__val = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+		ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = __val;		\
+	} while(0)
+
+#define ptrauth_save_keys(ctxt)						\
+	do {								\
+		__ptrauth_save_key(ctxt, APIA);				\
+		__ptrauth_save_key(ctxt, APIB);				\
+		__ptrauth_save_key(ctxt, APDA);				\
+		__ptrauth_save_key(ctxt, APDB);				\
+		__ptrauth_save_key(ctxt, APGA);				\
+	} while(0)
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_KVM_PTRAUTH_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a7178af1ab0c..c5850cb8b1fa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -35,10 +35,11 @@
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
-#include <asm/kvm_emulate.h>
+#include <asm/kvm_ptrauth.h>
 #include <asm/sections.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -462,6 +463,44 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 }
 
+static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_has_ptrauth(vcpu)) {
+		/*
+		 * Either we're running running an L2 guest, and the API/APK
+		 * bits come from L1's HCR_EL2, or API/APK are both set.
+		 */
+		if (unlikely(vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))) {
+			u64 val;
+
+			val = __vcpu_sys_reg(vcpu, HCR_EL2);
+			val &= (HCR_API | HCR_APK);
+			vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
+			vcpu->arch.hcr_el2 |= val;
+		} else {
+			vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+		}
+
+		/*
+		 * Save the host keys if there is any chance for the guest
+		 * to use pauth, as the entry code will reload the guest
+		 * keys in that case.
+		 * Protected mode is the exception to that rule, as the
+		 * entry into the EL2 code eagerly switch back and forth
+		 * between host and hyp keys (and kvm_hyp_ctxt is out of
+		 * reach anyway).
+		 */
+		if (is_protected_kvm_enabled())
+			return;
+
+		if (vcpu->arch.hcr_el2 & (HCR_API | HCR_APK)) {
+			struct kvm_cpu_context *ctxt;
+			ctxt = this_cpu_ptr_hyp_sym(kvm_hyp_ctxt);
+			ptrauth_save_keys(ctxt);
+		}
+	}
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_s2_mmu *mmu;
@@ -500,8 +539,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu_set_wfx_traps(vcpu);
 
-	if (vcpu_has_ptrauth(vcpu))
-		vcpu_ptrauth_disable(vcpu);
+	vcpu_set_pauth_traps(vcpu);
+
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
 
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 407bdfbb572b..b037f0a0e27e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -217,14 +217,12 @@ static int handle_sve(struct kvm_vcpu *vcpu)
  * Two possibilities to handle a trapping ptrauth instruction:
  *
  * - Guest usage of a ptrauth instruction (which the guest EL1 did not
- *   turn into a NOP). If we get here, it is that we didn't fixup
- *   ptrauth on exit, and all that we can do is give the guest an
- *   UNDEF (as the guest isn't supposed to use ptrauth without being
- *   told it could).
+ *   turn into a NOP). If we get here, it is because we didn't enable
+ *   ptrauth for the guest. This results in an UNDEF, as it isn't
+ *   supposed to use ptrauth without being told it could.
  *
  * - Running an L2 NV guest while L1 has left HCR_EL2.API==0, and for
- *   which we reinject the exception into L1. API==1 is handled as a
- *   fixup so the only way to get here is when API==0.
+ *   which we reinject the exception into L1.
  *
  * Anything else is an emulation bug (hence the WARN_ON + UNDEF).
  */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0908d7a8f56..7c733decbe43 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -27,6 +27,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_ptrauth.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
@@ -447,82 +448,6 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static inline bool esr_is_ptrauth_trap(u64 esr)
-{
-	switch (esr_sys64_to_sysreg(esr)) {
-	case SYS_APIAKEYLO_EL1:
-	case SYS_APIAKEYHI_EL1:
-	case SYS_APIBKEYLO_EL1:
-	case SYS_APIBKEYHI_EL1:
-	case SYS_APDAKEYLO_EL1:
-	case SYS_APDAKEYHI_EL1:
-	case SYS_APDBKEYLO_EL1:
-	case SYS_APDBKEYHI_EL1:
-	case SYS_APGAKEYLO_EL1:
-	case SYS_APGAKEYHI_EL1:
-		return true;
-	}
-
-	return false;
-}
-
-#define __ptrauth_save_key(ctxt, key)					\
-	do {								\
-	u64 __val;                                                      \
-	__val = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);                \
-	ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = __val;                   \
-	__val = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);                \
-	ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = __val;                   \
-} while(0)
-
-DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
-
-static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
-{
-	struct kvm_cpu_context *ctxt;
-	u64 enable = 0;
-
-	if (!vcpu_has_ptrauth(vcpu))
-		return false;
-
-	/*
-	 * NV requires us to handle API and APK independently, just in
-	 * case the hypervisor is totally nuts. Please barf >here<.
-	 */
-	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
-		switch (ESR_ELx_EC(kvm_vcpu_get_esr(vcpu))) {
-		case ESR_ELx_EC_PAC:
-			if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_API))
-				return false;
-
-			enable |= HCR_API;
-			break;
-
-		case ESR_ELx_EC_SYS64:
-			if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_APK))
-				return false;
-
-			enable |= HCR_APK;
-			break;
-		}
-	} else {
-		enable = HCR_API | HCR_APK;
-	}
-
-	ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
-	__ptrauth_save_key(ctxt, APIA);
-	__ptrauth_save_key(ctxt, APIB);
-	__ptrauth_save_key(ctxt, APDA);
-	__ptrauth_save_key(ctxt, APDB);
-	__ptrauth_save_key(ctxt, APGA);
-
-
-	vcpu->arch.hcr_el2 |= enable;
-	sysreg_clear_set(hcr_el2, 0, enable);
-
-	return true;
-}
-
 static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *ctxt;
@@ -610,9 +535,6 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
 		return true;
 
-	if (esr_is_ptrauth_trap(kvm_vcpu_get_esr(vcpu)))
-		return kvm_hyp_handle_ptrauth(vcpu, exit_code);
-
 	if (kvm_hyp_handle_cntpct(vcpu))
 		return true;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 4103625e46c5..9dfe704bdb69 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -191,7 +191,6 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
 	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
-	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
 };
 
@@ -203,7 +202,6 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
 	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
-	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
 };
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 8e1d98b691c1..f374bcdab4d4 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -41,9 +41,8 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
  * - TGE: we want the guest to use EL1, which is incompatible with
  *   this bit being set
  *
- * - API/APK: for hysterical raisins, we enable PAuth lazily, which
- *   means that the guest's bits cannot be directly applied (we really
- *   want to see the traps). Revisit this at some point.
+ * - API/APK: they are already accounted for by vcpu_load(), and can
+ *   only take effect across a load/put cycle (such as ERET)
  */
 #define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK)
 
@@ -268,7 +267,6 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
 	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
-	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 	[ESR_ELx_EC_ERET]		= kvm_hyp_handle_eret,
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
 };
-- 
2.39.2


