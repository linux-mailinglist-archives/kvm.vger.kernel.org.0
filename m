Return-Path: <kvm+bounces-2087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20CAC7F1403
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:12:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43EE11C215ED
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AE91DA45;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8SUiteX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480311C6A7;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03147C43397;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485855;
	bh=A/3P58oPBcovWy4Z5Ja4aFMzWweDAKbhCUn7wH6A5Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8SUiteXu4lA/vrRun8c9J0OMfESKqZV4I1w8vX/r7hkicsMrVyqXSOHc4i1EBxiX
	 ldAyzeI67XdM/NpRkp91Z4A3eKcjDDQeqSqg6XGuo1r1nKyzbtpG1bP1MMgS9Yh2Np
	 KPRbsMVcPYizLh++ipOmrI8SabwrhF+hfQH+bHToIKy4isruzMktJw50Vi9TBcTvyz
	 eF1rj/mvr+WFnQ4W3JePrYQvxLt5KKk/bPNxTL8ofPwq07VH79DUpRnzSV0mdpczAw
	 PCI4fQzPFkWzqJutc1Azw8FLfaQ9z73qU6Y31mtalS7MS+PTKr+t+5cDzBO3Y0T8zM
	 JLPaYzkn836IQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543B-00EjnU-2n;
	Mon, 20 Nov 2023 13:10:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 16/43] KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
Date: Mon, 20 Nov 2023 13:10:00 +0000
Message-Id: <20231120131027.854038-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the HCR_EL2 configuration for FEAT_NV2:

- when running a guest hypervisor, completely ignore the guest's
  HCR_EL2 (although this will eventually be relaxed as we improve
  the NV support)

- when running a L2 guest, fold in a limited number of the L1
  hypervisor's HCR_EL2 properties

Non-NV guests are completely unaffected by this.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h     |  1 +
 arch/arm64/include/asm/sysreg.h         |  1 +
 arch/arm64/kvm/emulate-nested.c         | 27 +++++++++++++
 arch/arm64/kvm/handle_exit.c            |  7 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 53 ++++++++++++++++++++++++-
 7 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 4882905357f4..aa085f2f1947 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -60,6 +60,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
+extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 3cb18c7a1ef0..a54464c415fc 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -498,6 +498,7 @@
 #define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
 #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
+#define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
 
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
 #define SYS_VNCR_EL2			sys_reg(3, 4, 2, 2, 0)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 06185216a297..61721f870be0 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1933,6 +1933,26 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	bool control_bit_set;
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	if (!vcpu_is_el2(vcpu) && control_bit_set) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return true;
+	}
+	return false;
+}
+
+bool forward_smc_trap(struct kvm_vcpu *vcpu)
+{
+	return forward_traps(vcpu, HCR_TSC);
+}
+
 static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 {
 	u64 mode = spsr & PSR_MODE_MASK;
@@ -1971,6 +1991,13 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	u64 spsr, elr, mode;
 	bool direct_eret;
 
+	/*
+	 * Forward this trap to the virtual EL2 if the virtual
+	 * HCR_EL2.NV bit is set and this is coming from !EL2.
+	 */
+	if (forward_traps(vcpu, HCR_NV))
+		return;
+
 	/*
 	 * Going through the whole put/load motions is a waste of time
 	 * if this is a VHE guest hypervisor returning to its own
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index aab052bed102..e7bc52047ff3 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -55,6 +55,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Forward this trapped smc instruction to the virtual EL2 if
+	 * the guest has asked for it.
+	 */
+	if (forward_smc_trap(vcpu))
+		return 1;
+
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 9a76f3a75a43..aed2ea35082c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -234,10 +234,8 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	__deactivate_traps_hfgxtr(vcpu);
 }
 
-static inline void ___activate_traps(struct kvm_vcpu *vcpu)
+static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 {
-	u64 hcr = vcpu->arch.hcr_el2;
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c50f8459e4fc..4103625e46c5 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -40,7 +40,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
-	___activate_traps(vcpu);
+	___activate_traps(vcpu, vcpu->arch.hcr_el2);
 	__activate_traps_common(vcpu);
 
 	val = vcpu->arch.cptr_el2;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..0926011deae7 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -33,11 +33,62 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+/*
+ * Common set of HCR_EL2 bits that we do not want to set while running
+ * a NV guest, irrespective of the context the guest is in.
+ */
+#define __HCR_GUEST_NV_FILTER					\
+	(HCR_TGE | HCR_ATA | HCR_API | HCR_APK | HCR_FIEN |	\
+	 HCR_BSU | HCR_NV | HCR_NV1 | HCR_NV2)
+
+/*
+ * Running as a host? Drop HCR_EL2 setting that should not affect the
+ * execution of EL2, or that are guaranteed to be enforced by the L0
+ * host anyway. For the time being, we don't allow anything. At all.
+ */
+#define HCR_GUEST_NV_INHOST_FILTER	(~(0U) | __HCR_GUEST_NV_FILTER)
+
+/*
+ * Running as a guest? Drop HCR_EL2 setting that should not affect the
+ * execution of EL0/EL1, or that are guaranteed to be enforced by the
+ * L0 host anyway.
+ */
+#define HCR_GUEST_NV_INGUEST_FILTER	__HCR_GUEST_NV_FILTER
+
+static u64 __compute_hcr(struct kvm_vcpu *vcpu)
+{
+	u64 hcr, vhcr_el2, mask;
+
+	hcr = vcpu->arch.hcr_el2;
+
+	if (!vcpu_has_nv(vcpu))
+		return hcr;
+
+	vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+	if (is_hyp_ctxt(vcpu)) {
+		hcr |= HCR_NV | HCR_NV2 | HCR_AT | HCR_TTLB;
+
+		if (!vcpu_el2_e2h_is_set(vcpu))
+			hcr |= HCR_NV1;
+
+		mask = HCR_GUEST_NV_INHOST_FILTER;
+
+		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
+	} else {
+		mask = HCR_GUEST_NV_INGUEST_FILTER;
+	}
+
+	hcr |= vhcr_el2 & ~mask;
+
+	return hcr;
+}
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
-	___activate_traps(vcpu);
+	___activate_traps(vcpu, __compute_hcr(vcpu));
 
 	if (has_cntpoff()) {
 		struct timer_map map;
-- 
2.39.2


