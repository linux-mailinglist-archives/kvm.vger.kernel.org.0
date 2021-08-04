Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172283DFD85
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhHDI7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbhHDI7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:59:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D9CC06179B
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso2258865ybq.10
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5F2XBId6Ml8d60ozFayhTnFPlnF21xMQYH0bLBzTlnY=;
        b=P/k5j1VS70sB8KLubXHq8/9bo8zjwK2ApmesXmWhSfReRNFGLt7FgvYu9pxbL6CMou
         jqHRyYf9SLnUjdLKJDC/uGZe+5hsYe27lfpfmoaEpKXJ0DV/3X4nK9CLFDBUyABhnYLK
         0Z44gI8AjTXpmoIvCKRNQDfMcuTKGA36vz7aezWaRVzygXDtNs0MdO82Vja0e+m9cry0
         BVMfsfEVyxRXREMb1Kyb9F5T0WGSTugrH4X2p9veldb6WExGhuBbstJKbJKsQrdZ1+C2
         CXxBgk3nuMutZaqFqkrD2cNUjfrbWvLYbbUJX+u9gb95Zb/lCrlxb2YcX179DIalG6bX
         kYow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5F2XBId6Ml8d60ozFayhTnFPlnF21xMQYH0bLBzTlnY=;
        b=NHZLWl3igLdGFTmQIFBdyLLAz96gKL8SflfAhuRj3bEFgqgClOMvgLXcNE9VHjj4za
         0vIs4CunqSGxMNcYSmF5WXnHQ57z4an0Q74ZvSiP02bmSoqR/8oT3BBkjR3SoPxONrNT
         lVB/ujjOs0lejEFvIPIwM3RTNvs05Q44KSWGT3MMhtcW5xN+4K2mfr4g/z/YRC41xgSu
         b85WH5yvJt6d0WrwGAVb8Zf+SGfsf/xrNT1IuPbr+DDHkzBIifQ2crdgg4rDOUEii4nr
         2xJRa7IyQ6hoQ1ium26b4VR8s3r6yKZ4Z9fN/iGkMNNS8maVCqqdMdnNbfz8UeLHtH89
         9VWA==
X-Gm-Message-State: AOAM530IiHEDY0XQxbFsD4+cggHBWtWMV1iZRZLn7zQOFvRwaXUfTMn8
        N6W9KYC0STAU8ZDB0f4nD/i6pr0XPrpINE5B33CuXLDdQ9m3xK1krth2yIegJs3YTIkPNcmwOfR
        HmOIWDtJXzk05PDLajBNe/G9JKCbzvX1MH8EHJ1YUh/uzYox5UbLi0esuXA==
X-Google-Smtp-Source: ABdhPJyliD4AsBjXCLBTaK2m63jx3rCYhGHEqJklXaxkWK0zm/UKQW1pH50RYWgtA27P4BN9OFdyiRL9jr0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:5844:: with SMTP id m65mr33677475ybb.199.1628067535625;
 Wed, 04 Aug 2021 01:58:55 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:17 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-20-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 19/21] KVM: arm64: Emulate physical counter offsetting on
 non-ECV systems
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
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unfortunately, ECV hasn't yet arrived in any tangible hardware. At the
same time, controlling the guest view of the physical counter-timer is
useful. Support guest counter-timer offsetting on non-ECV systems by
trapping guest accesses to the physical counter-timer. Emulate reads of
the physical counter in the fast exit path.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h         |  1 +
 arch/arm64/kvm/arch_timer.c             | 53 +++++++++++++++----------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 29 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 11 ++++-
 4 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index c34672aa65b9..e49790ae5da4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -505,6 +505,7 @@
 #define SYS_AMEVCNTR0_MEM_STALL		SYS_AMEVCNTR0_EL0(3)
 
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
+#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
 
 #define SYS_CNTP_TVAL_EL0		sys_reg(3, 3, 14, 2, 0)
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 9ead94aa867d..b7cb63acf2a0 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -51,7 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
-static void kvm_timer_enable_traps_vhe(void);
+static void kvm_timer_enable_traps_vhe(struct kvm_vcpu *vcpu);
 
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
@@ -175,6 +175,12 @@ static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
 	}
 }
 
+static bool ptimer_emulation_required(struct kvm_vcpu *vcpu)
+{
+	return timer_get_offset(vcpu_ptimer(vcpu)) &&
+			!cpus_have_const_cap(ARM64_ECV);
+}
+
 u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
@@ -184,8 +190,13 @@ static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
 	if (has_vhe()) {
 		map->direct_vtimer = vcpu_vtimer(vcpu);
-		map->direct_ptimer = vcpu_ptimer(vcpu);
-		map->emul_ptimer = NULL;
+		if (!ptimer_emulation_required(vcpu)) {
+			map->direct_ptimer = vcpu_ptimer(vcpu);
+			map->emul_ptimer = NULL;
+		} else {
+			map->direct_ptimer = NULL;
+			map->emul_ptimer = vcpu_ptimer(vcpu);
+		}
 	} else {
 		map->direct_vtimer = vcpu_vtimer(vcpu);
 		map->direct_ptimer = NULL;
@@ -671,7 +682,7 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 		timer_emulate(map.emul_ptimer);
 
 	if (has_vhe())
-		kvm_timer_enable_traps_vhe();
+		kvm_timer_enable_traps_vhe(vcpu);
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -1392,22 +1403,29 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
  * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
  * and this makes those bits have no effect for the host kernel execution.
  */
-static void kvm_timer_enable_traps_vhe(void)
+static void kvm_timer_enable_traps_vhe(struct kvm_vcpu *vcpu)
 {
 	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
 	u32 cnthctl_shift = 10;
-	u64 val;
+	u64 val, mask;
+
+	mask = CNTHCTL_EL1PCEN << cnthctl_shift;
+	mask |= CNTHCTL_EL1PCTEN << cnthctl_shift;
 
-	/*
-	 * VHE systems allow the guest direct access to the EL1 physical
-	 * timer/counter.
-	 */
 	val = read_sysreg(cnthctl_el2);
-	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
-	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
 
 	if (cpus_have_const_cap(ARM64_ECV))
 		val |= CNTHCTL_ECV;
+
+	/*
+	 * VHE systems allow the guest direct access to the EL1 physical
+	 * timer/counter if offsetting isn't requested on a non-ECV system.
+	 */
+	if (ptimer_emulation_required(vcpu))
+		val &= ~mask;
+	else
+		val |= mask;
+
 	write_sysreg(val, cnthctl_el2);
 }
 
@@ -1462,9 +1480,6 @@ static int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu,
 	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 	u64 offset;
 
-	if (!cpus_have_const_cap(ARM64_ECV))
-		return -ENXIO;
-
 	if (get_user(offset, uaddr))
 		return -EFAULT;
 
@@ -1513,9 +1528,6 @@ static int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu,
 	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 	u64 offset;
 
-	if (!cpus_have_const_cap(ARM64_ECV))
-		return -ENXIO;
-
 	offset = timer_get_offset(vcpu_ptimer(vcpu));
 	return put_user(offset, uaddr);
 }
@@ -1539,11 +1551,8 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
-		return 0;
 	case KVM_ARM_VCPU_TIMER_OFFSET:
-		if (cpus_have_const_cap(ARM64_ECV))
-			return 0;
-		break;
+		return 0;
 	}
 
 	return -ENXIO;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..abd3813a709e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -15,6 +15,7 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
+#include <kvm/arm_arch_timer.h>
 #include <kvm/arm_psci.h>
 
 #include <asm/barrier.h>
@@ -405,6 +406,31 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline u64 __timer_read_cntpct(struct kvm_vcpu *vcpu)
+{
+	return __arch_counter_get_cntpct() - vcpu_ptimer(vcpu)->host_offset;
+}
+
+static inline bool __hyp_handle_counter(struct kvm_vcpu *vcpu)
+{
+	u32 sysreg;
+	int rt;
+	u64 rv;
+
+	if (kvm_vcpu_trap_get_class(vcpu) != ESR_ELx_EC_SYS64)
+		return false;
+
+	sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	if (sysreg != SYS_CNTPCT_EL0)
+		return false;
+
+	rt = kvm_vcpu_sys_get_rt(vcpu);
+	rv = __timer_read_cntpct(vcpu);
+	vcpu_set_reg(vcpu, rt, rv);
+	__kvm_skip_instr(vcpu);
+	return true;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -439,6 +465,9 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (*exit_code != ARM_EXCEPTION_TRAP)
 		goto exit;
 
+	if (__hyp_handle_counter(vcpu))
+		goto guest;
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
 	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
 	    handle_tx2_tvm(vcpu))
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 5b8b4cd02506..67236c2e0ba7 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -44,10 +44,17 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 
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
+	 * requested on a non-ECV system.
+	 */
+	if (vcpu_ptimer(vcpu)->host_offset && !cpus_have_const_cap(ARM64_ECV))
+		val &= ~CNTHCTL_EL1PCTEN;
+	else
+		val |= CNTHCTL_EL1PCTEN;
 	write_sysreg(val, cnthctl_el2);
 }
-- 
2.32.0.605.g8dce9f2422-goog

