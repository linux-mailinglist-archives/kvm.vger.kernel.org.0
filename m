Return-Path: <kvm+bounces-33954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2894E9F4D96
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:24:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 345181890200
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEACF1F7574;
	Tue, 17 Dec 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tbt4bZVA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148E41F706C;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445409; cv=none; b=HbpBg/yKhlwFzqHWmcODleaYXvsGB5qTvwO6Rl6HvmgTJQ4HnyPyFtc7vCor+slTn0bkyUheLOCDFXFQeDkhE6JdjrCsnju6blItbbtw1XtCwr2mTdwXyOHRx9cZFpmDhijZ4XidxxmT5Pa6+eQjZBmdy1kmn17x/AX/OjGcVto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445409; c=relaxed/simple;
	bh=RYA74l2sD117uDKoViBGCC9liyVddclXRZ7s7n7LQ/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q0P/aXrOhwg50yTRJa54VYrwHWzVSxVuXPfAvoJoVsnXQOuN9KRXMdTxdWSX70ONyAR5zjCGMpMuQORvRBBwxre3hq9GyHqgP1heJXfAZApscL5LcRsxPx6UIe1F3gHMESJ5Cyo2GXygSbX+hzIXRJK/QRD918jNyj3OjcUpvN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tbt4bZVA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96107C4CEDD;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445408;
	bh=RYA74l2sD117uDKoViBGCC9liyVddclXRZ7s7n7LQ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbt4bZVA5s6j1EytgVxOWU38wm2Yu5uZKLxLzWeMNcBsh5ByBAAPRdHg5D7ZrsJ+c
	 o7I6ToIDbJQB4Gx0TVAF0b4Q8oTfz5YFGsaWiIGmjCSpk8eIFXiFJFbffmMdGaIWew
	 46g29lqk1ixXXyVxx19Hyxa4kbk1siYZqWAjrpyarvDTD26PYZI/YwSlHq4cpDo7kb
	 zsyTOVoqwCYyhgxfjKqVK6Ilkz8l/+UQyijofHF1JFx5GPDvk2USnwhdLzl9+CimWL
	 4HogdbcFms0FY6qdYbI9IIfEkuFX9/OqMWyESmviiT3l/dhYLbCLsmA08kwE7rztzp
	 YnErOIFIg36pg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTu-004aJx-QH;
	Tue, 17 Dec 2024 14:23:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 11/12] KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity
Date: Tue, 17 Dec 2024 14:23:19 +0000
Message-Id: <20241217142321.763801-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It appears that on Qualcomm's x1e CPU, CNTVOFF_EL2 doesn't really
work, specially with HCR_EL2.E2H=1.

A non-zero offset results in a screaming virtual timer interrupt,
to the tune of a few 100k interrupts per second on a 4 vcpu VM.
This is also evidenced by this CPU's inability to correctly run
any of the timer selftests.

The only case this doesn't break is when this register is set to 0,
which breaks VM migration.

When HCR_EL2.E2H=0, the timer seems to behave normally, and does
not result in an interrupt storm.

As a workaround, use the fact that this CPU implements FEAT_ECV,
and trap all accesses to the virtual timer and counter, keeping
CNTVOFF_EL2 set to zero, and emulate accesses to CVAL/TVAL/CTL
and the counter itself, fixing up the timer to account for the
missing offset.

And if you think this is disgusting, you'd probably be right.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cputype.h   |  2 ++
 arch/arm64/kernel/cpu_errata.c     |  8 +++++
 arch/arm64/kernel/image-vars.h     |  3 ++
 arch/arm64/kvm/arch_timer.c        | 58 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 16 ++++++---
 arch/arm64/kvm/sys_regs.c          |  3 +-
 arch/arm64/tools/cpucaps           |  1 +
 include/kvm/arm_arch_timer.h       |  7 ++++
 8 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 488f8e7513495..6f3f4142e214f 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -122,6 +122,7 @@
 #define QCOM_CPU_PART_KRYO_3XX_SILVER	0x803
 #define QCOM_CPU_PART_KRYO_4XX_GOLD	0x804
 #define QCOM_CPU_PART_KRYO_4XX_SILVER	0x805
+#define QCOM_CPU_PART_ORYON_X1		0x001
 
 #define NVIDIA_CPU_PART_DENVER		0x003
 #define NVIDIA_CPU_PART_CARMEL		0x004
@@ -198,6 +199,7 @@
 #define MIDR_QCOM_KRYO_3XX_SILVER MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_KRYO_3XX_SILVER)
 #define MIDR_QCOM_KRYO_4XX_GOLD MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_KRYO_4XX_GOLD)
 #define MIDR_QCOM_KRYO_4XX_SILVER MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_KRYO_4XX_SILVER)
+#define MIDR_QCOM_ORYON_X1 MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_ORYON_X1)
 #define MIDR_NVIDIA_DENVER MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_DENVER)
 #define MIDR_NVIDIA_CARMEL MIDR_CPU_MODEL(ARM_CPU_IMP_NVIDIA, NVIDIA_CPU_PART_CARMEL)
 #define MIDR_FUJITSU_A64FX MIDR_CPU_MODEL(ARM_CPU_IMP_FUJITSU, FUJITSU_CPU_PART_A64FX)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a78f247029aec..7ce5558628951 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -786,6 +786,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
 	},
 #endif
+	{
+		.desc = "Broken CNTVOFF_EL2",
+		.capability = ARM64_WORKAROUND_QCOM_ORYON_CNTVOFF,
+		ERRATA_MIDR_RANGE_LIST(((const struct midr_range[]) {
+					MIDR_ALL_VERSIONS(MIDR_QCOM_ORYON_X1),
+					{}
+				})),
+	},
 	{
 	}
 };
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8f5422ed1b758..ef3a69cc398e5 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -105,6 +105,9 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
 KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
 
+/* Static key which is set if CNTVOFF_EL2 is unusable */
+KVM_NVHE_ALIAS(broken_cntvoff_key);
+
 /* EL2 exception handling */
 KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e5951e6eaf236..d3d243366536c 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -30,6 +30,7 @@ static u32 host_vtimer_irq_flags;
 static u32 host_ptimer_irq_flags;
 
 static DEFINE_STATIC_KEY_FALSE(has_gic_active_state);
+DEFINE_STATIC_KEY_FALSE(broken_cntvoff_key);
 
 static const u8 default_ppi[] = {
 	[TIMER_PTIMER]  = 30,
@@ -519,7 +520,12 @@ static void timer_save_state(struct arch_timer_context *ctx)
 	case TIMER_VTIMER:
 	case TIMER_HVTIMER:
 		timer_set_ctl(ctx, read_sysreg_el0(SYS_CNTV_CTL));
-		timer_set_cval(ctx, read_sysreg_el0(SYS_CNTV_CVAL));
+		cval = read_sysreg_el0(SYS_CNTV_CVAL);
+
+		if (has_broken_cntvoff())
+			cval -= timer_get_offset(ctx);
+
+		timer_set_cval(ctx, cval);
 
 		/* Disable the timer */
 		write_sysreg_el0(0, SYS_CNTV_CTL);
@@ -624,8 +630,15 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 
 	case TIMER_VTIMER:
 	case TIMER_HVTIMER:
-		set_cntvoff(timer_get_offset(ctx));
-		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTV_CVAL);
+		cval = timer_get_cval(ctx);
+		offset = timer_get_offset(ctx);
+		if (has_broken_cntvoff()) {
+			set_cntvoff(0);
+			cval += offset;
+		} else {
+			set_cntvoff(offset);
+		}
+		write_sysreg_el0(cval, SYS_CNTV_CVAL);
 		isb();
 		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
 		break;
@@ -820,6 +833,13 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	if (!has_cntpoff() && timer_get_offset(map->direct_ptimer))
 		tpt = tpc = true;
 
+	/*
+	 * For the poor sods that could not correctly substract one value
+	 * from another, trap the full virtual timer and counter.
+	 */
+	if (has_broken_cntvoff() && timer_get_offset(map->direct_vtimer))
+		tvt = tvc = true;
+
 	/*
 	 * Apply the enable bits that the guest hypervisor has requested for
 	 * its own guest. We can only add traps that wouldn't have been set
@@ -1450,6 +1470,37 @@ static int kvm_irq_init(struct arch_timer_kvm_info *info)
 	return 0;
 }
 
+static void kvm_timer_handle_errata(void)
+{
+	u64 mmfr0, mmfr1, mmfr4;
+
+	/*
+	 * CNTVOFF_EL2 is broken on some implementations. For those, we trap
+	 * all virtual timer/counter accesses, requiring FEAT_ECV.
+	 *
+	 * However, a hypervisor supporting nesting is likely to mitigate the
+	 * erratum at L0, and not require other levels to mitigate it (which
+	 * would otherwise be a terrible performance sink due to trap
+	 * amplification).
+	 *
+	 * Given that the affected HW implements both FEAT_VHE and FEAT_E2H0,
+	 * and that NV is likely not to (because of limitations of the
+	 * architecture), only enable the workaround when FEAT_VHE and
+	 * FEAT_E2H0 are both detected. Time will tell if this actually holds.
+	 */
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	mmfr4 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR4_EL1);
+	if (SYS_FIELD_GET(ID_AA64MMFR1_EL1, VH, mmfr1)		&&
+	    !SYS_FIELD_GET(ID_AA64MMFR4_EL1, E2H0, mmfr4)	&&
+	    SYS_FIELD_GET(ID_AA64MMFR0_EL1, ECV, mmfr0)		&&
+	    (has_vhe() || has_hvhe())				&&
+	    cpus_have_final_cap(ARM64_WORKAROUND_QCOM_ORYON_CNTVOFF)) {
+		static_branch_enable(&broken_cntvoff_key);
+		kvm_info("Broken CNTVOFF_EL2, trapping virtual timer\n");
+	}
+}
+
 int __init kvm_timer_hyp_init(bool has_gic)
 {
 	struct arch_timer_kvm_info *info;
@@ -1518,6 +1569,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
 		goto out_free_vtimer_irq;
 	}
 
+	kvm_timer_handle_errata();
 	return 0;
 
 out_free_ptimer_irq:
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 3aaab20ae5b47..ff176f4ce7deb 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -22,15 +22,16 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
  */
 void __timer_disable_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val, shift = 0;
+	u64 set, clr, shift = 0;
 
 	if (has_hvhe())
 		shift = 10;
 
 	/* Allow physical timer/counter access for the host */
-	val = read_sysreg(cnthctl_el2);
-	val |= (CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN) << shift;
-	write_sysreg(val, cnthctl_el2);
+	set = (CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN) << shift;
+	clr = CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
+
+	sysreg_clear_set(cnthctl_el2, clr, set);
 }
 
 /*
@@ -58,5 +59,12 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 		set <<= 10;
 	}
 
+	/*
+	 * Trap the virtual counter/timer if we have a broken cntvoff
+	 * implementation.
+	 */
+	if (has_broken_cntvoff())
+		set |= CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
+
 	sysreg_clear_set(cnthctl_el2, clr, set);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 986e63d4f9faa..d161d6c05707a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1721,7 +1721,8 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) |
 				 ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
-		if (!cpus_have_final_cap(ARM64_HAS_WFXT))
+		if (!cpus_have_final_cap(ARM64_HAS_WFXT) ||
+		    has_broken_cntvoff())
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		break;
 	case SYS_ID_AA64MMFR2_EL1:
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index eb17f59e543c4..1e65f2fb45bd1 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -105,6 +105,7 @@ WORKAROUND_CLEAN_CACHE
 WORKAROUND_DEVICE_LOAD_ACQUIRE
 WORKAROUND_NVIDIA_CARMEL_CNP
 WORKAROUND_QCOM_FALKOR_E1003
+WORKAROUND_QCOM_ORYON_CNTVOFF
 WORKAROUND_REPEAT_TLBI
 WORKAROUND_SPECULATIVE_AT
 WORKAROUND_SPECULATIVE_SSBS
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index c1ba31fab6f52..681cf0c8b9df4 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -151,6 +151,13 @@ void kvm_timer_cpu_down(void);
 /* CNTKCTL_EL1 valid bits as of DDI0487J.a */
 #define CNTKCTL_VALID_BITS	(BIT(17) | GENMASK_ULL(9, 0))
 
+DECLARE_STATIC_KEY_FALSE(broken_cntvoff_key);
+
+static inline bool has_broken_cntvoff(void)
+{
+	return static_branch_unlikely(&broken_cntvoff_key);
+}
+
 static inline bool has_cntpoff(void)
 {
 	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
-- 
2.39.2


