Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1847E298DFE
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 14:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780191AbgJZNfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 09:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780175AbgJZNfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 09:35:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6FC24640;
        Mon, 26 Oct 2020 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603719304;
        bh=Zk+9rifDD2h6bggaeko4iEuVhcMh0k/ThrXdWRImaY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5zhK/VR/Il05nSkyBh3fj5Az4H3h0PDVd7GE1awmvvGiX+HrYayzi8CxzgElPhbN
         /ZT6pyfIVKEfAp+bi922XKyb/UUqidlhinQp8xqjcaM5UNLWQCP2uIEJ8jsvC+uTtI
         0jHToOmYA4qKaWWN+d9Wo/rT02Cozi91iB/9OCp8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kX2eM-004Kjh-1H; Mon, 26 Oct 2020 13:35:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: [PATCH 03/11] KVM: arm64: Make kvm_skip_instr() and co private to HYP
Date:   Mon, 26 Oct 2020 13:34:42 +0000
Message-Id: <20201026133450.73304-4-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026133450.73304-1-maz@kernel.org>
References: <20201026133450.73304-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In an effort to remove the vcpu PC manipulations from EL1 on nVHE
systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
to increment PC post emulation is now signalled via a flag in the
vcpu structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h       | 27 +----------
 arch/arm64/include/asm/kvm_host.h          |  1 +
 arch/arm64/kvm/handle_exit.c               |  6 +--
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 56 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  2 +
 arch/arm64/kvm/hyp/nvhe/switch.c           |  3 ++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |  2 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c            |  2 +
 arch/arm64/kvm/hyp/vhe/switch.c            |  3 ++
 arch/arm64/kvm/mmio.c                      |  2 +-
 arch/arm64/kvm/mmu.c                       |  2 +-
 arch/arm64/kvm/sys_regs.c                  |  2 +-
 12 files changed, 77 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 0864f425547d..6d2b5d1aa7b3 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -472,32 +472,9 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
-static __always_inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
+static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_mode_is_32bit(vcpu)) {
-		kvm_skip_instr32(vcpu);
-	} else {
-		*vcpu_pc(vcpu) += 4;
-		*vcpu_cpsr(vcpu) &= ~PSR_BTYPE_MASK;
-	}
-
-	/* advance the singlestep state machine */
-	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
-}
-
-/*
- * Skip an instruction which has been emulated at hyp while most guest sysregs
- * are live.
- */
-static __always_inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
-{
-	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
-	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
-
-	kvm_skip_instr(vcpu);
-
-	write_sysreg_el2(vcpu_gp_regs(vcpu)->pstate, SYS_SPSR);
-	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
 }
 
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0aecbab6a7fb..9a75de3ad8da 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -406,6 +406,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
 #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
 #define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
+#define KVM_ARM64_INCREMENT_PC		(1 << 8) /* Increment PC */
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 30bf8e22df54..d4e00a864ee6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -61,7 +61,7 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	 * otherwise return to the same address...
 	 */
 	vcpu_set_reg(vcpu, 0, ~0UL);
-	kvm_skip_instr(vcpu);
+	kvm_incr_pc(vcpu);
 	return 1;
 }
 
@@ -100,7 +100,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
 
-	kvm_skip_instr(vcpu);
+	kvm_incr_pc(vcpu);
 
 	return 1;
 }
@@ -221,7 +221,7 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
 	 * that fail their condition code check"
 	 */
 	if (!kvm_condition_valid(vcpu)) {
-		kvm_skip_instr(vcpu);
+		kvm_incr_pc(vcpu);
 		handled = 1;
 	} else {
 		exit_handle_fn exit_handler;
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
new file mode 100644
index 000000000000..4ecaf5cb2633
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Guest PC manipulation helpers
+ *
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Copyright (C) 2020 - Google LLC
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#ifndef __ARM64_KVM_HYP_ADJUST_PC_H__
+#define __ARM64_KVM_HYP_ADJUST_PC_H__
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_host.h>
+
+static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_mode_is_32bit(vcpu)) {
+		kvm_skip_instr32(vcpu);
+	} else {
+		*vcpu_pc(vcpu) += 4;
+		*vcpu_cpsr(vcpu) &= ~PSR_BTYPE_MASK;
+	}
+
+	/* advance the singlestep state machine */
+	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
+}
+
+/*
+ * Skip an instruction which has been emulated at hyp while most guest sysregs
+ * are live.
+ */
+static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
+{
+	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
+	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
+
+	__kvm_skip_instr(vcpu);
+
+	write_sysreg_el2(vcpu_gp_regs(vcpu)->pstate, SYS_SPSR);
+	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+}
+
+/*
+ * Adjust the guest PC on entry, depending on flags provided by EL1
+ * for the purpose of emulation (MMIO, sysreg).
+ */
+static inline void __adjust_pc(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
+		kvm_skip_instr(vcpu);
+		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
+	}
+}
+
+#endif
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 313a8fa3c721..d687e574cde5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -7,6 +7,8 @@
 #ifndef __ARM64_KVM_HYP_SWITCH_H__
 #define __ARM64_KVM_HYP_SWITCH_H__
 
+#include <hyp/adjust_pc.h>
+
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
 #include <linux/types.h>
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index a457a0306e03..d918861e040b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -4,6 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
 
@@ -189,6 +190,8 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(host_ctxt);
 
+	__adjust_pc(vcpu);
+
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index bd1bab551d48..8f0585640241 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -4,6 +4,8 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <hyp/adjust_pc.h>
+
 #include <linux/compiler.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm_host.h>
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 452f4cacd674..80406f463c28 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -4,6 +4,8 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <hyp/adjust_pc.h>
+
 #include <linux/compiler.h>
 #include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kvm_host.h>
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index fe69de16dadc..2adfda918be2 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -4,6 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
 #include <linux/arm-smccc.h>
@@ -133,6 +134,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__load_guest_stage2(vcpu->arch.hw_mmu);
 	__activate_traps(vcpu);
 
+	__adjust_pc(vcpu);
+
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 7e8eb32ae7d2..3e2d8ba11a02 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -115,7 +115,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	 * The MMIO instruction is emulated and should not be re-executed
 	 * in the guest.
 	 */
-	kvm_skip_instr(vcpu);
+	kvm_incr_pc(vcpu);
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 080917c3f960..cc323d96c9d4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1001,7 +1001,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * cautious, and skip the instruction.
 		 */
 		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
-			kvm_skip_instr(vcpu);
+			kvm_incr_pc(vcpu);
 			ret = 1;
 			goto out_unlock;
 		}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 894e800d6c61..01f63027cf40 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2199,7 +2199,7 @@ static void perform_access(struct kvm_vcpu *vcpu,
 
 	/* Skip instruction if instructed so */
 	if (likely(r->access(vcpu, params, r)))
-		kvm_skip_instr(vcpu);
+		kvm_incr_pc(vcpu);
 }
 
 /*
-- 
2.28.0

