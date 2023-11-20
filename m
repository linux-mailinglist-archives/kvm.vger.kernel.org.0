Return-Path: <kvm+bounces-2101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E74D67F1412
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B4B62836D8
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92F2720339;
	Mon, 20 Nov 2023 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qFrBT4RQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083621E538;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B6AC43391;
	Mon, 20 Nov 2023 13:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485858;
	bh=c8HK0+lh4IGr/ttPsbesbwN3qNM9yuGl+FcsuMpyCj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFrBT4RQbveLjjd0kn0k7dF4Iw6UCisXjBP9ksIcWj3bM9gW98u9gAympVMBEvXaj
	 v3qRcgOm6dLnSRsm1Y7cwpCLKONYrqKz2GAb7Qm4J6oC5ChdZ7OdnGYnqliD8TEZXx
	 gEStG2OWl0LqWmNUqdZw4SB8vVvBNjIMsBDUk+iKdlOeMB/jHIjpKmQDyQygGthILe
	 YNATHj/cUKL5n09feLv442g5t68fjd5qqg+K+p/ZNfEqmoxwLDy9QvQ0lTtOJ0vT/x
	 jmypj8skIGntWyrSRO37o43/rDBDWTUH6ukkpxtWHe/gmsjz5Jz7zcl/NPmJ5c7MyF
	 OcEACyH1yCujA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543E-00EjnU-PB;
	Mon, 20 Nov 2023 13:10:56 +0000
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
Subject: [PATCH v11 30/43] KVM: arm64: nv: Nested GICv3 Support
Date: Mon, 20 Nov 2023 13:10:14 +0000
Message-Id: <20231120131027.854038-31-maz@kernel.org>
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

When entering a nested VM, we set up the hypervisor control interface
based on what the guest hypervisor has set. Especially, we investigate
each list register written by the guest hypervisor whether HW bit is
set.  If so, we translate hw irq number from the guest's point of view
to the real hardware irq number if there is a mapping.

Co-developed-by: Jintack Lim <jintack@cs.columbia.edu>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
[Christoffer: Redesigned execution flow around vcpu load/put]
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: Rewritten to support GICv3 instead of GICv2, NV2 support]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h    |  43 ++++-
 arch/arm64/include/asm/kvm_hyp.h     |   2 +
 arch/arm64/include/asm/kvm_nested.h  |   1 +
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/arm.c                 |  11 ++
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |   6 +-
 arch/arm64/kvm/nested.c              |  16 ++
 arch/arm64/kvm/sys_regs.c            |  93 +++++++++-
 arch/arm64/kvm/vgic/vgic-init.c      |  35 ++++
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 253 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c        |  35 +++-
 arch/arm64/kvm/vgic/vgic.c           |  29 +++
 arch/arm64/kvm/vgic/vgic.h           |  10 ++
 include/kvm/arm_vgic.h               |  16 ++
 14 files changed, 537 insertions(+), 15 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index eb96fe9b686e..f96fc5a3dde0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,13 +44,14 @@
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
-#define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
-#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
-#define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
-#define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
-#define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
-#define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
+#define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(3)
+#define KVM_REQ_RELOAD_GICv4		KVM_ARCH_REQ(4)
+#define KVM_REQ_RELOAD_PMU		KVM_ARCH_REQ(5)
+#define KVM_REQ_SUSPEND			KVM_ARCH_REQ(6)
+#define KVM_REQ_RESYNC_PMU_EL0		KVM_ARCH_REQ(7)
+#define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(8)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
@@ -510,6 +511,34 @@ enum vcpu_sysreg {
 	VNCR(CNTP_CVAL_EL0),
 	VNCR(CNTP_CTL_EL0),
 
+	VNCR(ICH_LR0_EL2),
+	VNCR(ICH_LR1_EL2),
+	VNCR(ICH_LR2_EL2),
+	VNCR(ICH_LR3_EL2),
+	VNCR(ICH_LR4_EL2),
+	VNCR(ICH_LR5_EL2),
+	VNCR(ICH_LR6_EL2),
+	VNCR(ICH_LR7_EL2),
+	VNCR(ICH_LR8_EL2),
+	VNCR(ICH_LR9_EL2),
+	VNCR(ICH_LR10_EL2),
+	VNCR(ICH_LR11_EL2),
+	VNCR(ICH_LR12_EL2),
+	VNCR(ICH_LR13_EL2),
+	VNCR(ICH_LR14_EL2),
+	VNCR(ICH_LR15_EL2),
+
+	VNCR(ICH_AP0R0_EL2),
+	VNCR(ICH_AP0R1_EL2),
+	VNCR(ICH_AP0R2_EL2),
+	VNCR(ICH_AP0R3_EL2),
+	VNCR(ICH_AP1R0_EL2),
+	VNCR(ICH_AP1R1_EL2),
+	VNCR(ICH_AP1R2_EL2),
+	VNCR(ICH_AP1R3_EL2),
+	VNCR(ICH_HCR_EL2),
+	VNCR(ICH_VMCR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 145ce73fc16c..5b270f20b84f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -76,6 +76,8 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
+u64 __gic_v3_get_lr(unsigned int lr);
+
 void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 2f427348506a..4f94aef8a750 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -73,6 +73,7 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 						const union tlbi_info *));
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
+extern void check_nested_vcpu_requests(struct kvm_vcpu *vcpu);
 
 struct kvm_s2_trans {
 	phys_addr_t output;
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index c2717a8f12f5..4462bede5c60 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -20,7 +20,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o
+	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 683a2e6ec799..95760ed448bf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -681,6 +681,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		ret = kvm_init_nv_sysregs(vcpu->kvm);
 		if (ret)
 			return ret;
+
+		ret = kvm_vgic_vcpu_nv_init(vcpu);
+		if (ret)
+			return ret;
 	}
 
 	ret = kvm_timer_enable(vcpu);
@@ -881,6 +885,8 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
+
+		check_nested_vcpu_requests(vcpu);
 	}
 
 	return 1;
@@ -1018,6 +1024,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * preserved on VMID roll-over if the task was preempted,
 		 * making a thread's VMID inactive. So we need to call
 		 * kvm_arm_vmid_update() in non-premptible context.
+		 *
+		 * Note that this must happen after the check_vcpu_request()
+		 * call to pick the correct s2_mmu structure, as a pending
+		 * nested exception (IRQ, for example) can trigger a change
+		 * in translation regime.
 		 */
 		if (kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid) &&
 		    has_vhe())
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 6cb638b184b1..aaaea35099e5 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -18,7 +18,7 @@
 #define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
 #define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
 
-static u64 __gic_v3_get_lr(unsigned int lr)
+u64 __gic_v3_get_lr(unsigned int lr)
 {
 	switch (lr & 0xf) {
 	case 0:
@@ -484,7 +484,7 @@ static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
 static int __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu, u32 vmcr,
 					 u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
+	unsigned int used_lrs = kern_hyp_va(vcpu->arch.vgic_cpu.current_cpu_if)->used_lrs;
 	u8 priority = GICv3_IDLE_PRIORITY;
 	int i, lr = -1;
 
@@ -523,7 +523,7 @@ static int __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu, u32 vmcr,
 static int __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu, int intid,
 				    u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
+	unsigned int used_lrs = kern_hyp_va(vcpu->arch.vgic_cpu.current_cpu_if)->used_lrs;
 	int i;
 
 	for (i = 0; i < used_lrs; i++) {
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 61af8a42389d..ad1df851997d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -612,6 +612,22 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm_uninit_stage2_mmu(kvm);
 }
 
+bool vgic_state_is_nested(struct kvm_vcpu *vcpu)
+{
+	bool imo = __vcpu_sys_reg(vcpu, HCR_EL2) & HCR_IMO;
+	bool fmo = __vcpu_sys_reg(vcpu, HCR_EL2) & HCR_FMO;
+
+	WARN_ONCE(imo != fmo, "Separate virtual IRQ/FIQ settings not supported\n");
+
+	return vcpu_has_nv(vcpu) && imo && fmo && !is_hyp_ctxt(vcpu);
+}
+
+void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
+{
+	if (kvm_check_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu))
+		kvm_inject_nested_irq(vcpu);
+}
+
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a24feb4b2839..c9e55c7697d5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -17,6 +17,8 @@
 #include <linux/printk.h>
 #include <linux/uaccess.h>
 
+#include <linux/irqchip/arm-gic-v3.h>
+
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/debug-monitors.h>
@@ -522,7 +524,13 @@ static bool access_gic_sre(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
-	p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
+	if (p->Op1 == 4) {	/* ICC_SRE_EL2 */
+		p->regval = (ICC_SRE_EL2_ENABLE | ICC_SRE_EL2_SRE |
+			     ICC_SRE_EL1_DIB | ICC_SRE_EL1_DFB);
+	} else {		/* ICC_SRE_EL1 */
+		p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
+	}
+
 	return true;
 }
 
@@ -2338,6 +2346,54 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return __vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
+static bool access_gic_vtr(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = kvm_vgic_global_state.ich_vtr_el2;
+
+	return true;
+}
+
+static bool access_gic_misr(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_misr(vcpu);
+
+	return true;
+}
+
+static bool access_gic_eisr(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_eisr(vcpu);
+
+	return true;
+}
+
+static bool access_gic_elrsr(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_elrsr(vcpu);
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2874,6 +2930,41 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
 	{ SYS_DESC(SYS_VDISR_EL2), trap_undef },
 
+	EL2_REG_VNCR(ICH_AP0R0_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP0R1_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP0R2_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP0R3_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP1R0_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP1R1_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP1R2_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_AP1R3_EL2, reset_val, 0),
+
+	{ SYS_DESC(SYS_ICC_SRE_EL2), access_gic_sre },
+
+	EL2_REG_VNCR(ICH_HCR_EL2, reset_val, 0),
+	{ SYS_DESC(SYS_ICH_VTR_EL2), access_gic_vtr },
+	{ SYS_DESC(SYS_ICH_MISR_EL2), access_gic_misr },
+	{ SYS_DESC(SYS_ICH_EISR_EL2), access_gic_eisr },
+	{ SYS_DESC(SYS_ICH_ELRSR_EL2), access_gic_elrsr },
+	EL2_REG_VNCR(ICH_VMCR_EL2, reset_val, 0),
+
+	EL2_REG_VNCR(ICH_LR0_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR1_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR2_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR3_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR4_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR5_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR6_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR7_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR8_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR9_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR10_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR11_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR12_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR13_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR14_EL2, reset_val, 0),
+	EL2_REG_VNCR(ICH_LR15_EL2, reset_val, 0),
+
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index c8c3cb812783..9cc7809c9c5e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -6,10 +6,12 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
+#include <linux/irq.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include "vgic.h"
 
 /*
@@ -182,6 +184,18 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	return 0;
 }
 
+int kvm_vgic_vcpu_nv_init(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	/* Cope with vintage userspace. Maybe we should fail instead */
+	if (vcpu->kvm->arch.vgic.maint_irq == 0)
+		vcpu->kvm->arch.vgic.maint_irq = kvm_vgic_global_state.maint_irq;
+	ret = kvm_vgic_set_owner(vcpu, vcpu->kvm->arch.vgic.maint_irq, vcpu);
+
+	return ret;
+}
+
 /**
  * kvm_vgic_vcpu_init() - Initialize static VGIC VCPU data
  * structures and register VCPU-specific KVM iodevs
@@ -506,12 +520,23 @@ void kvm_vgic_cpu_down(void)
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 {
+	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)data;
+
 	/*
 	 * We cannot rely on the vgic maintenance interrupt to be
 	 * delivered synchronously. This means we can only use it to
 	 * exit the VM, and we perform the handling of EOIed
 	 * interrupts on the exit path (see vgic_fold_lr_state).
 	 */
+
+	/* If not nested, deactivate */
+	if (!vcpu || !vgic_state_is_nested(vcpu)) {
+		irq_set_irqchip_state(irq, IRQCHIP_STATE_ACTIVE, false);
+		return IRQ_HANDLED;
+	}
+
+	/* Assume nested from now */
+	vgic_v3_handle_nested_maint_irq(vcpu);
 	return IRQ_HANDLED;
 }
 
@@ -610,6 +635,16 @@ int kvm_vgic_hyp_init(void)
 		return ret;
 	}
 
+	if (has_mask) {
+		ret = irq_set_vcpu_affinity(kvm_vgic_global_state.maint_irq,
+					    kvm_get_running_vcpus());
+		if (ret) {
+			kvm_err("Error setting vcpu affinity\n");
+			free_percpu_irq(kvm_vgic_global_state.maint_irq, kvm_get_running_vcpus());
+			return ret;
+		}
+	}
+
 	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
 	return 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
new file mode 100644
index 000000000000..e4919cc82daf
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/cpu.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <linux/irqchip/arm-gic-v3.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+
+/*
+ * The shadow registers loaded to the hardware when running a L2 guest
+ * with the virtual IMO/FMO bits set.
+ */
+static DEFINE_PER_CPU(struct vgic_v3_cpu_if, shadow_cpuif);
+
+static inline struct vgic_v3_cpu_if *vcpu_shadow_if(struct kvm_vcpu *vcpu)
+{
+	return this_cpu_ptr(&shadow_cpuif);
+}
+
+static inline bool lr_triggers_eoi(u64 lr)
+{
+	return !(lr & (ICH_LR_STATE | ICH_LR_HW)) && (lr & ICH_LR_EOI);
+}
+
+u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu)
+{
+	u16 reg = 0;
+	int i;
+
+	if (vgic_state_is_nested(vcpu))
+		return read_sysreg_s(SYS_ICH_EISR_EL2);
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		if (lr_triggers_eoi(__vcpu_sys_reg(vcpu, ICH_LRN(i))))
+			reg |= BIT(i);
+	}
+
+	return reg;
+}
+
+u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu)
+{
+	u16 reg = 0;
+	int i;
+
+	if (vgic_state_is_nested(vcpu))
+		return read_sysreg_s(SYS_ICH_ELRSR_EL2);
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		if (!(__vcpu_sys_reg(vcpu, ICH_LRN(i)) & ICH_LR_STATE))
+			reg |= BIT(i);
+	}
+
+	return reg;
+}
+
+u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
+{
+	int nr_lr = kvm_vgic_global_state.nr_lr;
+	u64 reg = 0;
+
+	if (vgic_state_is_nested(vcpu))
+		return read_sysreg_s(SYS_ICH_MISR_EL2);
+
+	if (vgic_v3_get_eisr(vcpu))
+		reg |= ICH_MISR_EOI;
+
+	if (__vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_UIE) {
+		int used_lrs;
+
+		used_lrs = nr_lr - hweight16(vgic_v3_get_elrsr(vcpu));
+		if (used_lrs <= 1)
+			reg |= ICH_MISR_U;
+	}
+
+	/* TODO: Support remaining bits in this register */
+	return reg;
+}
+
+/*
+ * For LRs which have HW bit set such as timer interrupts, we modify them to
+ * have the host hardware interrupt number instead of the virtual one programmed
+ * by the guest hypervisor.
+ */
+static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	struct vgic_irq *irq;
+	int i, used_lrs = 0;
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		int l1_irq;
+
+		if (!(lr & ICH_LR_STATE))
+			lr = 0;
+
+		if (!(lr & ICH_LR_HW))
+			goto next;
+
+		/* We have the HW bit set */
+		l1_irq = (lr & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT;
+		irq = vgic_get_irq(vcpu->kvm, vcpu, l1_irq);
+
+		if (!irq || !irq->hw) {
+			/* There was no real mapping, so nuke the HW bit */
+			lr &= ~ICH_LR_HW;
+			if (irq)
+				vgic_put_irq(vcpu->kvm, irq);
+			goto next;
+		}
+
+		/* Translate the virtual mapping to the real one */
+		lr &= ~ICH_LR_EOI; /* Why? */
+		lr &= ~ICH_LR_PHYS_ID_MASK;
+		lr |= (u64)irq->hwintid << ICH_LR_PHYS_ID_SHIFT;
+		vgic_put_irq(vcpu->kvm, irq);
+
+next:
+		s_cpu_if->vgic_lr[i] = lr;
+		used_lrs = i + 1;
+	}
+
+	s_cpu_if->used_lrs = used_lrs;
+}
+
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	struct vgic_irq *irq;
+	int i;
+
+	for (i = 0; i < s_cpu_if->used_lrs; i++) {
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		int l1_irq;
+
+		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
+			continue;
+
+		/*
+		 * If we had a HW lr programmed by the guest hypervisor, we
+		 * need to emulate the HW effect between the guest hypervisor
+		 * and the nested guest.
+		 */
+		l1_irq = (lr & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT;
+		irq = vgic_get_irq(vcpu->kvm, vcpu, l1_irq);
+		if (!irq)
+			continue; /* oh well, the guest hyp is broken */
+
+		lr = __gic_v3_get_lr(i);
+		if (!(lr & ICH_LR_STATE))
+			irq->active = false;
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
+void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	struct vgic_v3_cpu_if *host_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	int i;
+
+	s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	s_cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
+	s_cpu_if->vgic_sre = host_if->vgic_sre;
+
+	for (i = 0; i < 4; i++) {
+		s_cpu_if->vgic_ap0r[i] = __vcpu_sys_reg(vcpu, ICH_AP0RN(i));
+		s_cpu_if->vgic_ap1r[i] = __vcpu_sys_reg(vcpu, ICH_AP1RN(i));
+	}
+
+	vgic_v3_create_shadow_lr(vcpu);
+
+	vcpu->arch.vgic_cpu.current_cpu_if = s_cpu_if;
+}
+
+void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
+{
+	struct vgic_irq *irq;
+	unsigned long flags;
+
+	__vgic_v3_restore_state(vcpu_shadow_if(vcpu));
+
+	irq = vgic_get_irq(vcpu->kvm, vcpu, vcpu->kvm->arch.vgic.maint_irq);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	if (irq->line_level || irq->active)
+		irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
+				      IRQCHIP_STATE_ACTIVE, true);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	vgic_put_irq(vcpu->kvm, irq);
+}
+
+void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	int i;
+
+	__vgic_v3_save_state(s_cpu_if);
+
+	/*
+	 * Translate the shadow state HW fields back to the virtual ones
+	 * before copying the shadow struct back to the nested one.
+	 */
+	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = s_cpu_if->vgic_hcr;
+	__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = s_cpu_if->vgic_vmcr;
+
+	for (i = 0; i < 4; i++) {
+		__vcpu_sys_reg(vcpu, ICH_AP0RN(i)) = s_cpu_if->vgic_ap0r[i];
+		__vcpu_sys_reg(vcpu, ICH_AP1RN(i)) = s_cpu_if->vgic_ap1r[i];
+	}
+
+	for (i = 0; i < s_cpu_if->used_lrs; i++) {
+		u64 val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+
+		val &= ~ICH_LR_STATE;
+		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
+
+		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
+		s_cpu_if->vgic_lr[i] = 0;
+	}
+
+	irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
+			      IRQCHIP_STATE_ACTIVE, false);
+}
+
+void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If we exit a nested VM with a pending maintenance interrupt from the
+	 * GIC, then we need to forward this to the guest hypervisor so that it
+	 * can re-sync the appropriate LRs and sample level triggered interrupts
+	 * again.
+	 */
+	if (vgic_state_is_nested(vcpu)) {
+		bool state;
+
+		state  = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EN;
+		state &= vgic_v3_get_misr(vcpu);
+
+		kvm_vgic_inject_irq(vcpu->kvm, vcpu,
+				    vcpu->kvm->arch.vgic.maint_irq, state, vcpu);
+	}
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9465d3706ab9..2a6a864c29ee 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -9,6 +9,7 @@
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/kvm_asm.h>
 
 #include "vgic.h"
@@ -721,6 +722,19 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	vcpu->arch.vgic_cpu.current_cpu_if = cpu_if;
+
+	/*
+	 * If the vgic is in nested state, populate the shadow state
+	 * from the guest's nested state. As vgic_v3_load_nested()
+	 * will only load LRs, let's deal with the rest of the state
+	 * here as if it was a non-nested state. Cunning.
+	 */
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_create_shadow_state(vcpu);
+		cpu_if = vcpu->arch.vgic_cpu.current_cpu_if;
+	}
+
 	/*
 	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
 	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
@@ -734,12 +748,15 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
 
-	WARN_ON(vgic_v4_load(vcpu));
+	if (vgic_state_is_nested(vcpu))
+		vgic_v3_load_nested(vcpu);
+	else
+		WARN_ON(vgic_v4_load(vcpu));
 }
 
 void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	struct vgic_v3_cpu_if *cpu_if = vcpu->arch.vgic_cpu.current_cpu_if;
 
 	if (likely(cpu_if->vgic_sre))
 		cpu_if->vgic_vmcr = kvm_call_hyp_ret(__vgic_v3_read_vmcr);
@@ -747,8 +764,14 @@ void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	struct vgic_v3_cpu_if *cpu_if = vcpu->arch.vgic_cpu.current_cpu_if;
 
+	/*
+	 * vgic_v4_put will do nothing if we were not resident. This
+	 * covers both the cases where we've blocked (we already have
+	 * done a vgic_v4_put) and when running a nested guest (the
+	 * vPE was never resident in order to generate a doorbell).
+	 */
 	WARN_ON(vgic_v4_put(vcpu));
 
 	vgic_v3_vmcr_sync(vcpu);
@@ -757,4 +780,10 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 
 	if (has_vhe())
 		__vgic_v3_deactivate_traps(cpu_if);
+
+	if (vgic_state_is_nested(vcpu))
+		vgic_v3_put_nested(vcpu);
+
+	/* Default back to the non-nested state for sanity */
+	vcpu->arch.vgic_cpu.current_cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index db2a95762b1b..b40b3c3694b3 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -876,6 +876,12 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	int used_lrs;
 
+	/* If nesting, emulate the HW effect from L0 to L1 */
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_sync_nested(vcpu);
+		return;
+	}
+
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
@@ -904,6 +910,29 @@ static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * If in a nested state, we must return early. Two possibilities:
+	 *
+	 * - If we have any pending IRQ for the guest and the guest
+	 *   expects IRQs to be handled in its virtual EL2 mode (the
+	 *   virtual IMO bit is set) and it is not already running in
+	 *   virtual EL2 mode, then we have to emulate an IRQ
+	 *   exception to virtual EL2.
+	 *
+	 *   We do that by placing a request to ourselves which will
+	 *   abort the entry procedure and inject the exception at the
+	 *   beginning of the run loop.
+	 *
+	 * - Otherwise, do exactly *NOTHING*. The guest state is
+	 *   already loaded, and we can carry on with running it.
+	 */
+	if (vgic_state_is_nested(vcpu)) {
+		if (kvm_vgic_vcpu_pending_irq(vcpu))
+			kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
+
+		return;
+	}
+
 	/*
 	 * If there are no virtual interrupts active or pending for this
 	 * VCPU, then there is no work to do and we can bail out without
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0ab09b0d4440..4e2624e2f3a8 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -342,4 +342,14 @@ void vgic_v4_configure_vsgis(struct kvm *kvm);
 void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
 int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq);
 
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu);
+void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
+
+#define ICH_LRN(n)	(ICH_LR0_EL2 + (n))
+#define ICH_AP0RN(n)	(ICH_AP0R0_EL2 + (n))
+#define ICH_AP1RN(n)	(ICH_AP1R0_EL2 + (n))
+
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8cc38e836f54..01da24d3d76c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -243,6 +243,9 @@ struct vgic_dist {
 
 	int			nr_spis;
 
+	/* The GIC maintenance IRQ for nested hypervisors. */
+	u32			maint_irq;
+
 	/* base addresses in guest physical address space: */
 	gpa_t			vgic_dist_base;		/* distributor */
 	union {
@@ -329,6 +332,12 @@ struct vgic_cpu {
 		struct vgic_v3_cpu_if	vgic_v3;
 	};
 
+	/*
+	 * Pointer to the live CPU vif state. Normally set to vgic_v3,
+	 * but will be set to the per-CPU state when running a L2 guest.
+	 */
+	struct vgic_v3_cpu_if	*current_cpu_if;
+
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
 	raw_spinlock_t ap_list_lock;	/* Protects the ap_list */
@@ -368,6 +377,7 @@ extern struct static_key_false vgic_v3_cpuif_trap;
 int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
 void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
+int kvm_vgic_vcpu_nv_init(struct kvm_vcpu *vcpu);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
@@ -389,6 +399,10 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
+u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu);
+u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu);
+u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
@@ -433,6 +447,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
 
+bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
+
 /* CPU HP callbacks */
 void kvm_vgic_cpu_up(void);
 void kvm_vgic_cpu_down(void);
-- 
2.39.2


