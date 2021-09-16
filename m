Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A70540EA67
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244100AbhIPS5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245420AbhIPS52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:28 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC568C04A14F
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:32 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h7-20020a37b707000000b003fa4d25d9d0so44667704qkf.17
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=A0zcWhYnFXgM2Yz5qdLIdnhrCI0/H5A1ERXqkcBiVfM=;
        b=qyKCwyk28EPcoPL5VPZ2Qnasv1FrtC00q+EiyYviFT82Uds5oI/JKh7Quuv9RkfV2J
         Cpm/qj+cbgrgOXY5nxxkzO/rclGw6FX/9qqVNTnF6/l89/T4aY8d8H0KSvRpfJzLnfTy
         1YEc4FgwXKVE5xYDpHASoidAgDhUTlpyr86f3Ueitw3X7LZTAQNZrdgP2Ll1S0zH31yp
         vldAgUp7KfnVItwArTR+GL5ZlepA8YuipZAxbDG1vLsVuc6Homy9fLqlGWZ6susoQenP
         XM21BnFagBOqtDDLNuKC9+LCN8/T+mxTFDiZ3izj8gr9Zaw8cv59X5MG5mJ42bt2eX+5
         4K4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=A0zcWhYnFXgM2Yz5qdLIdnhrCI0/H5A1ERXqkcBiVfM=;
        b=c9XcjGH3ZFUYvearlnEdM0JqcJBxKKfbBeyb6i+oUKil0rSwozNGiLX/gJXXawqp9x
         Xfv7zgSmc5uRqDhMCXJePDzSHjoHlI/gxnkdxER4LIxYo19Nem51fGH1yw1EPcZrAqVa
         c5dHfVHy8Zn7kiEUqKnw8FbQgng5G86ceTFo4TpwOqeS4UhY+ypzfgCOFWwTrX+24ME2
         cWoRle5hELWQ+xXMmAsVJPrK9NW6qTQHqL7/G/P05q6RnGEVoPZ2v7p9qJgOLgb4MYFj
         f0WV3gzejtHBIFTG6miSpgjpiy+zk5wqaZergR9Lr7gx03gUHqIDxV/KJgzjhkkBx77q
         UXTA==
X-Gm-Message-State: AOAM532XaEp743aDOKO0euCMOARMaLt3FVIha+kw/yJf16c4UHpmGVS4
        TAn73AmVFyp3QzCtTdQ0XbmpVpCJsnmXD0yJoY7x3ckzCyiADE9SZY71YOxwKieMwoNgqbKw8sG
        CZ/JccI2IoPhHXkcMPr0NIzAHKKLSzMyWMOu+a71RGPG6hVR1WL7kpR7V2w==
X-Google-Smtp-Source: ABdhPJz89q3cQse2sxyQIvdV21JvVAjzcBgpnxgOtU4wDBghMmmYVYVlOAEgFfu+/BtI6YOHK1ap8JRHpA8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:12ad:: with SMTP id
 w13mr6780738qvu.13.1631816131983; Thu, 16 Sep 2021 11:15:31 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:10 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-9-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 8/8] KVM: arm64: Emulate physical counter offsetting on
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/sysreg.h         |  2 ++
 arch/arm64/kvm/arch_timer.c             | 47 +++++++++++++------------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 11 ++++--
 include/kvm/arm_arch_timer.h            |  3 ++
 5 files changed, 71 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d5a686dff57e..cb9f72ebd6ec 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -506,6 +506,8 @@
 #define SYS_AMEVCNTR0_MEM_STALL		SYS_AMEVCNTR0_EL0(3)
 
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
+#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
+#define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
 
 #define SYS_CNTP_TVAL_EL0		sys_reg(3, 3, 14, 2, 0)
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 68fb5ddb9e7a..2280a99ab98b 100644
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
@@ -179,8 +179,13 @@ static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
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
@@ -666,7 +671,7 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 		timer_emulate(map.emul_ptimer);
 
 	if (has_vhe())
-		kvm_timer_enable_traps_vhe();
+		kvm_timer_enable_traps_vhe(vcpu);
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -1364,22 +1369,29 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
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
 
 	if (cpus_have_final_cap(ARM64_HAS_ECV2))
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
 
@@ -1434,9 +1446,6 @@ static int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu,
 	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 	u64 offset;
 
-	if (!kvm_timer_physical_offset_allowed())
-		return -ENXIO;
-
 	if (get_user(offset, uaddr))
 		return -EFAULT;
 
@@ -1485,9 +1494,6 @@ static int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu,
 	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 	u64 offset;
 
-	if (!kvm_timer_physical_offset_allowed())
-		return -ENXIO;
-
 	offset = timer_get_offset(vcpu_ptimer(vcpu));
 	return put_user(offset, uaddr);
 }
@@ -1511,11 +1517,8 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
-		return 0;
 	case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
-		if (kvm_timer_physical_offset_allowed())
-			return 0;
-		break;
+		return 0;
 	}
 
 	return -ENXIO;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0e78a6027be..9c42a299957c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -15,6 +15,7 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
+#include <kvm/arm_arch_timer.h>
 #include <kvm/arm_psci.h>
 
 #include <asm/barrier.h>
@@ -409,6 +410,34 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
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
+	if (kvm_timer_physical_offset_allowed())
+		return false;
+
+	if (kvm_vcpu_trap_get_class(vcpu) != ESR_ELx_EC_SYS64)
+		return false;
+
+	sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	if (sysreg != SYS_CNTPCT_EL0 && sysreg != SYS_CNTPCTSS_EL0)
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
@@ -443,6 +472,9 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (*exit_code != ARM_EXCEPTION_TRAP)
 		goto exit;
 
+	if (__hyp_handle_counter(vcpu))
+		goto guest;
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
 	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
 	    handle_tx2_tvm(vcpu))
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..6c0834421eae 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -39,10 +39,17 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 
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
+	if (ptimer_emulation_required(vcpu))
+		val &= ~CNTHCTL_EL1PCTEN;
+	else
+		val |= CNTHCTL_EL1PCTEN;
 	write_sysreg(val, cnthctl_el2);
 }
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index d06294aa356e..252c012db505 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -96,6 +96,9 @@ bool kvm_arch_timer_get_input_level(int vintid);
 
 #define arch_timer_ctx_index(ctx)	((ctx) - vcpu_timer((ctx)->vcpu)->timers)
 
+#define ptimer_emulation_required(v)	\
+	(!cpus_have_final_cap(ARM64_HAS_ECV2) && vcpu_ptimer(v)->host_offset)
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
-- 
2.33.0.309.g3052b89438-goog

