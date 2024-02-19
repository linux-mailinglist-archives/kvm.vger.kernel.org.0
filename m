Return-Path: <kvm+bounces-9062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 188F1859F88
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D5B11C206AA
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E09828DB5;
	Mon, 19 Feb 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjFVLerW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C50125108;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334425; cv=none; b=nSsgVDASZWBR5ehh0hMLEdIZJY15UrZ0AFBEVqq04ahQ13E9+pNF1Q2mIOQKA3trF3lUxT2XxhgpdJHaB+sBtd8w9zxJ34wdTWFTKwFmRu9KxY8dk7hQtfFzX2E402QLcFhf4Js7cL2YWT+YZNRVI6VphsYxphhKKDCuCBYpH1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334425; c=relaxed/simple;
	bh=6zV0ogqAlCaFC/EIA74ric9obU6wunvsN+b/ySfTf2A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IrU1BgyIDWhyU19ROBo9JvMZDzgyUqY5TZQ7FqMGj+0lVu+wfrnKHSU6n3JyMbuM/65RwV5Et3VatYJGKTIXodVtGDw3g1iIe4eAo0mjypk7wr74mSFZzjEqGxDhH0leiJ0i2oaxLNuYd1dph0wJ0umAWXQv459qGJrcT1onPc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjFVLerW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8B7C4166C;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334425;
	bh=6zV0ogqAlCaFC/EIA74ric9obU6wunvsN+b/ySfTf2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjFVLerWRsI0g+l0XFMtUHlg9AXNpSgMw7CaXTEJD1x44UWJJVPhHT4lbzb7hKWWr
	 jvATm0dksC0O7pQr9lGTsvGHV3xdw6IPPW/yx9VJ/ORpiNw2so9rCMgcOGvsRnR8p9
	 gUd1xwbnxHOeok3yWmC065QXFtllPVcdnEM5/lUUK5WYKZwqvbUbAQXae1rESKCY04
	 qG4i7+wJ959r4sp7+Yj8//W2ERzV7KI8cL3z38Xt6X7mJIfcJiLpPmGSwLYA6zOIQi
	 n12UQNmeR5N/U33xmJgoAq85fda3xY+ZS2LiF0ceGZfyJ+fPiWQvkB9bFw2LJ+TKQQ
	 h8zFvy9DmgmOQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp1-004WBZ-H7;
	Mon, 19 Feb 2024 09:20:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 11/13] KVM: arm64: nv: Add emulation for ERETAx instructions
Date: Mon, 19 Feb 2024 09:20:12 +0000
Message-Id: <20240219092014.783809-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_NV has the interesting property of relying on ERET being
trapped. An added complexity is that it also traps ERETAA and
ERETAB, meaning that the Pointer Authentication aspect of these
instruction must be emulated.

Add an emulation of Pointer Authentication, limited to ERETAx
(always using SP_EL2 as the modifier and ELR_EL2 as the pointer),
using the Generic Authentication instructions.

The emulation, however small, is placed in its own compilation
unit so that it can be avoided if the configuration doesn't
include it (or the toolchan in not up to the task).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h    |  12 ++
 arch/arm64/include/asm/pgtable-hwdef.h |   1 +
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/pauth.c                 | 196 +++++++++++++++++++++++++
 4 files changed, 210 insertions(+)
 create mode 100644 arch/arm64/kvm/pauth.c

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index dbc4e3a67356..5e0ab0596246 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -64,4 +64,16 @@ extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
+#ifdef CONFIG_ARM64_PTR_AUTH
+bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr);
+#else
+static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
+{
+	/* We really should never execute this... */
+	WARN_ON_ONCE(1);
+	*elr = 0xbad9acc0debadbad;
+	return false;
+}
+#endif
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index e4944d517c99..bb88e9ef6296 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -277,6 +277,7 @@
 #define TCR_TBI1		(UL(1) << 38)
 #define TCR_HA			(UL(1) << 39)
 #define TCR_HD			(UL(1) << 40)
+#define TCR_TBID0		(UL(1) << 51)
 #define TCR_TBID1		(UL(1) << 52)
 #define TCR_NFD0		(UL(1) << 53)
 #define TCR_NFD1		(UL(1) << 54)
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index c0c050e53157..04882b577575 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,6 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
+kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 
 always-y := hyp_constants.h hyp-constants.s
 
diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
new file mode 100644
index 000000000000..33ef0a26eb35
--- /dev/null
+++ b/arch/arm64/kvm/pauth.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 - Google LLC
+ * Author: Marc Zyngier <maz@kernel.org>
+ *
+ * Primitive PAuth emulation for ERETAA/ERETAB.
+ *
+ * This code assumes that is is run from EL2, and that it is part of
+ * the emulation of ERETAx for a guest hypervisor. That's a lot of
+ * baked-in assumptions and shortcuts.
+ *
+ * Do no reuse for anything else!
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/pointer_auth.h>
+
+static u64 compute_pac(struct kvm_vcpu *vcpu, u64 ptr,
+		       struct ptrauth_key ikey)
+{
+	struct ptrauth_key gkey;
+	u64 mod, pac = 0;
+
+	preempt_disable();
+
+	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
+		mod = __vcpu_sys_reg(vcpu, SP_EL2);
+	else
+		mod = read_sysreg(sp_el1);
+
+	gkey.lo = read_sysreg_s(SYS_APGAKEYLO_EL1);
+	gkey.hi = read_sysreg_s(SYS_APGAKEYHI_EL1);
+
+	__ptrauth_key_install_nosync(APGA, ikey);
+	isb();
+
+	asm volatile(ARM64_ASM_PREAMBLE ".arch_extension pauth\n"
+		     "pacga %0, %1, %2" : "=r" (pac) : "r" (ptr), "r" (mod));
+	isb();
+
+	__ptrauth_key_install_nosync(APGA, gkey);
+
+	preempt_enable();
+
+	/* PAC in the top 32bits */
+	return pac;
+}
+
+static bool effective_tbi(struct kvm_vcpu *vcpu, bool bit55)
+{
+	u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
+	bool tbi, tbid;
+
+	/*
+	 * Since we are authenticating an instruction address, we have
+	 * to take TBID into account. If E2H==0, ignore VA[55], as
+	 * TCR_EL2 only has a single TBI/TBID. If VA[55] was set in
+	 * this case, this is likely a guest bug...
+	 */
+	if (!vcpu_el2_e2h_is_set(vcpu)) {
+		tbi = tcr & BIT(20);
+		tbid = tcr & BIT(29);
+	} else if (bit55) {
+		tbi = tcr & TCR_TBI1;
+		tbid = tcr & TCR_TBID1;
+	} else {
+		tbi = tcr & TCR_TBI0;
+		tbid = tcr & TCR_TBID0;
+	}
+
+	return tbi && !tbid;
+}
+
+static int compute_bottom_pac(struct kvm_vcpu *vcpu, bool bit55)
+{
+	static const int maxtxsz = 39; // Revisit these two values once
+	static const int mintxsz = 16; // (if) we support TTST/LVA/LVA2
+	u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
+	int txsz;
+
+	if (!vcpu_el2_e2h_is_set(vcpu) || !bit55)
+		txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
+	else
+		txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
+
+	return 64 - clamp(txsz, mintxsz, maxtxsz);
+}
+
+static u64 compute_pac_mask(struct kvm_vcpu *vcpu, bool bit55)
+{
+	int bottom_pac;
+	u64 mask;
+
+	bottom_pac = compute_bottom_pac(vcpu, bit55);
+
+	mask = GENMASK(54, bottom_pac);
+	if (!effective_tbi(vcpu, bit55))
+		mask |= GENMASK(63, 56);
+
+	return mask;
+}
+
+static u64 to_canonical_addr(struct kvm_vcpu *vcpu, u64 ptr, u64 mask)
+{
+	bool bit55 = !!(ptr & BIT(55));
+
+	if (bit55)
+		return ptr | mask;
+
+	return ptr & ~mask;
+}
+
+static u64 corrupt_addr(struct kvm_vcpu *vcpu, u64 ptr)
+{
+	bool bit55 = !!(ptr & BIT(55));
+	u64 mask, error_code;
+	int shift;
+
+	if (effective_tbi(vcpu, bit55)) {
+		mask = GENMASK(54, 53);
+		shift = 53;
+	} else {
+		mask = GENMASK(62, 61);
+		shift = 61;
+	}
+
+	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERETAB)
+		error_code = 2 << shift;
+	else
+		error_code = 1 << shift;
+
+	ptr &= ~mask;
+	ptr |= error_code;
+
+	return ptr;
+}
+
+/*
+ * Authenticate an ERETAA/ERETAB instruction, returning true if the
+ * authentication succeeded and false otherwise. In all cases, *elr
+ * contains the VA to ERET to. Potential exception injection is left
+ * to the caller.
+ */
+bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
+{
+	u64 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL2);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 ptr, cptr, pac, mask;
+	struct ptrauth_key ikey;
+
+	*elr = ptr = vcpu_read_sys_reg(vcpu, ELR_EL2);
+
+	/* We assume we're already in the context of an ERETAx */
+	if (esr & ESR_ELx_ERET_ISS_ERETAB ) {
+		if (!(sctlr & SCTLR_EL1_EnIB))
+			return true;
+
+		ikey.lo = __vcpu_sys_reg(vcpu, APIBKEYLO_EL1);
+		ikey.hi = __vcpu_sys_reg(vcpu, APIBKEYHI_EL1);
+	} else {
+		if (!(sctlr & SCTLR_EL1_EnIA))
+			return true;
+
+		ikey.lo = __vcpu_sys_reg(vcpu, APIAKEYLO_EL1);
+		ikey.hi = __vcpu_sys_reg(vcpu, APIAKEYHI_EL1);
+	}
+
+	mask = compute_pac_mask(vcpu, !!(ptr & BIT(55)));
+	cptr = to_canonical_addr(vcpu, ptr, mask);
+
+	pac = compute_pac(vcpu, cptr, ikey);
+
+	/*
+	 * Slightly deviate from the pseudocode: if we have a PAC
+	 * match with the signed pointer, then it must be good.
+	 * Anything after this point is pure error handling.
+	 */
+	if ((pac & mask) == (ptr & mask)) {
+		*elr = cptr;
+		return true;
+	}
+
+	/*
+	 * Authentication failed, corrupt the canonical address if
+	 * PAuth2 isn't implemented, or some XORing if it is.
+	 */
+	if (!kvm_has_pauth(vcpu->kvm, PAuth2))
+		cptr = corrupt_addr(vcpu, cptr);
+	else
+		cptr = ptr ^ (pac & mask);
+
+	*elr = cptr;
+	return false;
+}
-- 
2.39.2


