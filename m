Return-Path: <kvm+bounces-12419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA11C885CB9
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E76A285BDD
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DCD12C7FF;
	Thu, 21 Mar 2024 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TQ9Lhmp6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0570D12C7E6;
	Thu, 21 Mar 2024 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036475; cv=none; b=TrrOdfDc3+UKSHiSP2txfYOLpSpLIwddi10BjPMnJy9WX24wxoVeGc7zJfX3J7LhGB6svTNd5PTJiQAi41mej/Ett6ybWJgX9zf8cshBm+sttcJsvph3Z2MMCkIo+Ur7VMRmzoMaT9DBiI06WgI/3slTooQnfDMSfYBFzdvMdnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036475; c=relaxed/simple;
	bh=XnByOARuk3+kytna6uwym+WKJJX36/EczXp/jZ5GP64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o0cevlC0BRVsDhT9fMrcLHM8+/p/XodLMJan6n+TgLI66dhx/W11eKDWpQ7yMxHepk2ytzD1czjFJu2NUMvnAoqUpv6zjkgrEgRxuq3NILIrNW410uPf6LyVwPEaAUzDThpNPSSnVQ5Me0nZdzgpl/wxJbaMFplThVLZYJlRjT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TQ9Lhmp6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637CCC43394;
	Thu, 21 Mar 2024 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036474;
	bh=XnByOARuk3+kytna6uwym+WKJJX36/EczXp/jZ5GP64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQ9Lhmp6HVgmqqLspsoZX60JEMiIV+IMRZOhZDMlPl4aR3qBpmm6jWeUqCl7k6iDv
	 eE6MIX366w5Mjcqs/u8eiVopMCOxdIp1Hta16D4THlCE1pQ/pMgMMf8rcW31Zzl1Z1
	 9rGOEnNUna02yK9G8pFrOn0bPRjfTB+OrlAHMu0T7kma9VJeqD/XHoyszZhnW49aDI
	 nDvn0PXhMntdFMKemR72ZFAtftzphChy0iwlBWT+BcL0OfqFRZDtrbw9FDRYoiZhVV
	 25jbjQwQ5F80IyH/HLuquY0ijGcan8k1hWhP/c8w3ejP6zjC2IKWzJb39zpwIn021t
	 i8K3Tbvtejh3Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkS-00EEqz-Hn;
	Thu, 21 Mar 2024 15:54:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 15/15] KVM: arm64: Drop trapping of PAuth instructions/keys
Date: Thu, 21 Mar 2024 15:53:56 +0000
Message-Id: <20240321155356.3236459-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240321155356.3236459-1-maz@kernel.org>
References: <20240321155356.3236459-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
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

It also removes an unnecessary overhead on pKVM, where the EL2
code would always save the keys on trap, which is pretty pointess
as they are pre-populated in kvm_hyp_ctxt.

Overall, a reduced complexity and a (small) performance improvement.

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
index d2177bc77844..f4f10d36d12e 100644
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
index 49d36666040e..23b484b26f1a 100644
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


