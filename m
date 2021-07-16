Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F773CBE96
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbhGPV3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 17:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbhGPV3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 17:29:47 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BDCC061767
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:50 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id a15-20020a927f0f0000b02901ac2bdd733dso6142470ild.22
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XbTtxhZ4ROyo17V7q+xHcBeN3BFqrITDBTCQhNqMurw=;
        b=BAD5EG/FARsvUlfJo9jxJQm07diGtiugOw+Nnj7Il1fvTjIe1u7En0TVK+zlQMxOE7
         OqNjQfourhwhvBPsx88wcNFp8sNWYX+h1k7Bcm3iSHaJQfnLtEu9tZo6Pd61N+mR6uuo
         wzRVhtyYvXKdCdOcfE7tR+pEBwvjkiM/AVW9H59tpzIITNyXNAkUn3xsrtONbOL19b6C
         cWkm2GaR1/ISzJklDoO3Y4u8ETemxqA/LmBs5P/ASYgTfDJImSD81uriAIb05a4TvVGq
         tNb8R3dzWDsesSkNSAdI5SBq8K/Fv+b61IEBWcAoF27uS+nBs0OZ54FclVuDgGmHs8v4
         qhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XbTtxhZ4ROyo17V7q+xHcBeN3BFqrITDBTCQhNqMurw=;
        b=jEKRV83S++7KOJKOuGhYHOfA+82oH/wvBslnglZVYx8vbG8QjLqGThD1Gi+ApCo2HC
         PzXG7GjiKbqGAvtPAwvUmTSsTD6gosiKuYNIy2L17EFe7pXe3Wstl/wCcAuJg/pzv9n2
         JMJt+kIMnmw89oGI5euKakA61gaZex2c85UocFW45/RJHdxAqIFtmekamNdEuPJRTG1k
         o3CIyHhDQQCyM3SeXVEEq+HzwaawPmHN2xjY4fLAT3CM+zp1MdgBBj9PkcjOi2F14ED/
         eV4D7ySr7Qaqu83HvKh+6B/h81uLy+Xze9KUgHghVgoqgy1WxqiSbpXttBwbDZP/aKUs
         JaGQ==
X-Gm-Message-State: AOAM532NYDWK966kqmpodpfrPCPOLiCvK8ahZW9I34XygxoTz042qSkQ
        fx4Og5gjEMUjMWElQO4UYgdMEbYjvXZ96gk3LD1EBn2Y4srOsXDXMpO4RMZXJiOTNVbNJG6SWZx
        GPzust8LHau0Ib2xDVl3k/CbExhN5O7zzOgiASC9bUbPs9z7IC6bh59nFSQ==
X-Google-Smtp-Source: ABdhPJzrLwoLK3b1Cv6NPy2HjwvQxnldo54jBH5NTNwPpqTIwdi6o4Bn+8pBZE2ZRJbKUcNVCJwRjsTJ2VE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:8783:: with SMTP id t3mr10540629jai.45.1626470809588;
 Fri, 16 Jul 2021 14:26:49 -0700 (PDT)
Date:   Fri, 16 Jul 2021 21:26:27 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-11-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 10/12] KVM: arm64: Provide userspace access to the physical
 counter offset
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presently, KVM provides no facilities for correctly migrating a guest
that depends on the physical counter-timer. While most guests (barring
NV, of course) should not depend on the physical counter-timer, an
operator may still wish to provide a consistent view of the physical
counter-timer across migrations.

Provide userspace with a new vCPU attribute to modify the guest physical
counter-timer offset. Since the base architecture doesn't provide a
physical counter-timer offset register, emulate the correct behavior by
trapping accesses to the physical counter-timer whenever the offset
value is non-zero.

Uphold the same behavior as CNTVOFF_EL2 and broadcast the physical
offset to all vCPUs whenever written. This guarantees that the
counter-timer we provide the guest remains architectural, wherein all
views of the counter-timer are consistent across vCPUs. Reconfigure
timer traps for VHE on every guest entry, as different VMs will now have
different traps enabled. Enable physical counter traps for nVHE whenever
the offset is nonzero (we already trap physical timer registers in
nVHE).

FEAT_ECV provides a guest physical counter-timer offset register
(CNTPOFF_EL2), but ECV-enabled hardware is nonexistent at the time of
writing so support for it was elided for the sake of the author :)

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h         |  1 +
 arch/arm64/include/asm/kvm_hyp.h          |  2 -
 arch/arm64/include/asm/sysreg.h           |  1 +
 arch/arm64/include/uapi/asm/kvm.h         |  1 +
 arch/arm64/kvm/arch_timer.c               | 50 ++++++++++++++++++++---
 arch/arm64/kvm/arm.c                      |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   | 23 +++++++++++
 arch/arm64/kvm/hyp/include/hyp/timer-sr.h | 26 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c          |  2 -
 arch/arm64/kvm/hyp/nvhe/timer-sr.c        | 21 +++++-----
 arch/arm64/kvm/hyp/vhe/timer-sr.c         | 27 ++++++++++++
 include/kvm/arm_arch_timer.h              |  2 -
 12 files changed, 136 insertions(+), 24 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/timer-sr.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..de92fa678924 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -204,6 +204,7 @@ enum vcpu_sysreg {
 	SP_EL1,
 	SPSR_EL1,
 
+	CNTPOFF_EL2,
 	CNTVOFF_EL2,
 	CNTV_CVAL_EL0,
 	CNTV_CTL_EL0,
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9d60b3006efc..01eb3864e50f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -65,10 +65,8 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
-#ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
-#endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 347ccac2341e..243e36c088e7 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -505,6 +505,7 @@
 #define SYS_AMEVCNTR0_MEM_STALL		SYS_AMEVCNTR0_EL0(3)
 
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
+#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
 
 #define SYS_CNTP_TVAL_EL0		sys_reg(3, 3, 14, 2, 0)
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 008d0518d2b1..3e42c72d4c68 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -366,6 +366,7 @@ struct kvm_arm_copy_mte_tags {
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 #define   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER	2
+#define   KVM_ARM_VCPU_TIMER_OFFSET_PTIMER	3
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index d2b1b13af658..05ec385e26b5 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -89,7 +89,10 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
 		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
+	case TIMER_PTIMER:
+		return __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
 	default:
+		WARN_ONCE(1, "unrecognized timer index %ld", arch_timer_ctx_index(ctxt));
 		return 0;
 	}
 }
@@ -134,6 +137,9 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 	case TIMER_VTIMER:
 		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
 		break;
+	case TIMER_PTIMER:
+		__vcpu_sys_reg(vcpu, CNTPOFF_EL2) = offset;
+		break;
 	default:
 		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
 	}
@@ -144,9 +150,24 @@ u64 kvm_phys_timer_read(void)
 	return timecounter->cc->read(timecounter->cc);
 }
 
+static bool timer_emulation_required(struct arch_timer_context *ctx)
+{
+	enum kvm_arch_timers timer = arch_timer_ctx_index(ctx);
+
+	switch (timer) {
+	case TIMER_VTIMER:
+		return false;
+	case TIMER_PTIMER:
+		return timer_get_offset(ctx);
+	default:
+		WARN_ONCE(1, "unrecognized timer index %ld\n", timer);
+		return false;
+	}
+}
+
 static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
-	if (has_vhe()) {
+	if (has_vhe() && !timer_emulation_required(vcpu_ptimer(vcpu))) {
 		map->direct_vtimer = vcpu_vtimer(vcpu);
 		map->direct_ptimer = vcpu_ptimer(vcpu);
 		map->emul_ptimer = NULL;
@@ -747,8 +768,9 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-/* Make the updates of cntvoff for all vtimer contexts atomic */
-static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
+/* Make the updates of offset for all timer contexts atomic */
+static void update_timer_offset(struct kvm_vcpu *vcpu,
+				enum kvm_arch_timers timer, u64 offset)
 {
 	int i;
 	struct kvm *kvm = vcpu->kvm;
@@ -756,16 +778,26 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 
 	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, tmp, kvm)
-		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
+		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
 
 	/*
 	 * When called from the vcpu create path, the CPU being created is not
 	 * included in the loop above, so we just set it here as well.
 	 */
-	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
+	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
 	mutex_unlock(&kvm->lock);
 }
 
+static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
+{
+	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
+}
+
+static void update_ptimer_cntpoff(struct kvm_vcpu *vcpu, u64 cntpoff)
+{
+	update_timer_offset(vcpu, TIMER_PTIMER, cntpoff);
+}
+
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -1350,6 +1382,9 @@ int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr
 	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
 		update_vtimer_cntvoff(vcpu, offset);
 		break;
+	case KVM_ARM_VCPU_TIMER_OFFSET_PTIMER:
+		update_ptimer_cntpoff(vcpu, offset);
+		break;
 	default:
 		return -ENXIO;
 	}
@@ -1364,6 +1399,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
 		return kvm_arm_timer_set_attr_irq(vcpu, attr);
 	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+	case KVM_ARM_VCPU_TIMER_OFFSET_PTIMER:
 		return kvm_arm_timer_set_attr_offset(vcpu, attr);
 	}
 
@@ -1400,6 +1436,8 @@ int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
 		timer = vcpu_vtimer(vcpu);
+	case KVM_ARM_VCPU_TIMER_OFFSET_PTIMER:
+		timer = vcpu_ptimer(vcpu);
 		break;
 	default:
 		return -ENXIO;
@@ -1416,6 +1454,7 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
 		return kvm_arm_timer_get_attr_irq(vcpu, attr);
 	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+	case KVM_ARM_VCPU_TIMER_OFFSET_PTIMER:
 		return kvm_arm_timer_get_attr_offset(vcpu, attr);
 	}
 
@@ -1428,6 +1467,7 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
 	case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
+	case KVM_ARM_VCPU_TIMER_OFFSET_PTIMER:
 		return 0;
 	}
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e0b81870ff2a..217f4c6038e8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1549,9 +1549,7 @@ static void cpu_hyp_reinit(void)
 
 	cpu_hyp_reset();
 
-	if (is_kernel_in_hyp_mode())
-		kvm_timer_init_vhe();
-	else
+	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 
 	cpu_set_hyp_vector();
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..c3ae1e0614a2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -8,6 +8,7 @@
 #define __ARM64_KVM_HYP_SWITCH_H__
 
 #include <hyp/adjust_pc.h>
+#include <hyp/timer-sr.h>
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
@@ -113,6 +114,8 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
+
+	__timer_enable_traps(vcpu);
 }
 
 static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
@@ -127,6 +130,8 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 &= ~HCR_VSE;
 		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
+
+	__timer_disable_traps(vcpu);
 }
 
 static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
@@ -405,6 +410,21 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline bool __hyp_handle_counter(struct kvm_vcpu *vcpu)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	int rt = kvm_vcpu_sys_get_rt(vcpu);
+	u64 rv;
+
+	if (sysreg != SYS_CNTPCT_EL0)
+		return false;
+
+	rv = __timer_read_cntpct(vcpu);
+	vcpu_set_reg(vcpu, rt, rv);
+	__kvm_skip_instr(vcpu);
+	return true;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -439,6 +459,9 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (*exit_code != ARM_EXCEPTION_TRAP)
 		goto exit;
 
+	if (__hyp_handle_counter(vcpu))
+		goto guest;
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
 	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
 	    handle_tx2_tvm(vcpu))
diff --git a/arch/arm64/kvm/hyp/include/hyp/timer-sr.h b/arch/arm64/kvm/hyp/include/hyp/timer-sr.h
new file mode 100644
index 000000000000..c91fbf9e5170
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/timer-sr.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Google LLC
+ * Author: Oliver Upton <oupton@google.com>
+ */
+
+#ifndef __ARM64_KVM_HYP_TIMER_SR_H__
+#define __ARM64_KVM_HYP_TIMER_SR_H__
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+
+static inline bool __timer_physical_emulation_required(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
+}
+
+static inline u64 __timer_read_cntpct(struct kvm_vcpu *vcpu)
+{
+	return read_sysreg(cntpct_el0) - __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
+}
+
+#endif /* __ARM64_KVM_HYP_TIMER_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..4a190c932f8c 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -217,7 +217,6 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
-	__timer_enable_traps(vcpu);
 
 	__debug_switch_to_guest(vcpu);
 
@@ -230,7 +229,6 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..ebc3f0d0908d 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -9,16 +9,13 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_hyp.h>
+#include <hyp/timer-sr.h>
 
 void __kvm_timer_set_cntvoff(u64 cntvoff)
 {
 	write_sysreg(cntvoff, cntvoff_el2);
 }
 
-/*
- * Should only be called on non-VHE systems.
- * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
- */
 void __timer_disable_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
@@ -29,20 +26,24 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(val, cnthctl_el2);
 }
 
-/*
- * Should only be called on non-VHE systems.
- * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
- */
 void __timer_enable_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	/*
 	 * Disallow physical timer access for the guest
-	 * Physical counter access is allowed
 	 */
 	val = read_sysreg(cnthctl_el2);
 	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
+
+	/*
+	 * Disallow physical counter access for the guest if offsetting is
+	 * requested.
+	 */
+	if (__timer_physical_emulation_required(vcpu))
+		val &= ~CNTHCTL_EL1PCTEN;
+	else
+		val |= CNTHCTL_EL1PCTEN;
+
 	write_sysreg(val, cnthctl_el2);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/timer-sr.c b/arch/arm64/kvm/hyp/vhe/timer-sr.c
index 4cda674a8be6..10506f3ce8a1 100644
--- a/arch/arm64/kvm/hyp/vhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/timer-sr.c
@@ -4,9 +4,36 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <asm/kvm_host.h>
 #include <asm/kvm_hyp.h>
+#include <hyp/timer-sr.h>
 
 void __kvm_timer_set_cntvoff(u64 cntvoff)
 {
 	write_sysreg(cntvoff, cntvoff_el2);
 }
+
+void __timer_enable_traps(struct kvm_vcpu *vcpu)
+{
+	/* When HCR_EL2.E2H == 1, EL1PCEN nad EL1PCTEN are shifted by 10 */
+	u32 cnthctl_shift = 10;
+	u64 val, mask;
+
+	mask = CNTHCTL_EL1PCEN << cnthctl_shift;
+	mask |= CNTHCTL_EL1PCTEN << cnthctl_shift;
+
+	val = read_sysreg(cnthctl_el2);
+
+	/*
+	 * VHE systems allow the guest direct access to the EL1 physical
+	 * timer/counter if offsetting isn't requested.
+	 */
+	if (__timer_physical_emulation_required(vcpu))
+		val &= ~mask;
+	else
+		val |= mask;
+
+	write_sysreg(val, cnthctl_el2);
+}
+
+void __timer_disable_traps(struct kvm_vcpu *vcpu) {}
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 51c19381108c..f24fc435c401 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -83,8 +83,6 @@ u64 kvm_phys_timer_read(void);
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
-void kvm_timer_init_vhe(void);
-
 bool kvm_arch_timer_get_input_level(int vintid);
 
 #define vcpu_timer(v)	(&(v)->arch.timer_cpu)
-- 
2.32.0.402.g57bb445576-goog

