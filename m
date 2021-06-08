Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C143A0663
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhFHVuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhFHVuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:50:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C91C061574
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:48:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v28-20020a25fc1c0000b0290547fac9371fso6251273ybd.14
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jq/+BcyiAwtDYy8ThiCBLyJ5XHWSBXaMbOIVg/4GVn8=;
        b=ckg85lAIZmxZUdlRzWIhhAAZPBFTL/aTLpCURVBL7uHEuwqOX3JpYbHy9HaqxL4Sxk
         kyJfoHbNbjYa25k4xE4ZcoWNEm+xHOVn2T25WNbTZwuTYvkJngvHV3psTiIQI0dyHjEv
         3dYmyHYF1988m9d9TNyHVt+Xc+eVFMTlmDqbnstCfX/jej21f6y9fr1RISeEQ3tEMbzj
         BHuvoJ/MoF+kgt/iAr00V7FbpAB9uUuTv8XmPE2YkHGb3AghryYgDg6jdzdcKm9MVWoQ
         Wve0yu6vB4RJOnFydwlIqFTxHelNRU1hzhatay/6Hqw9HWcnZTiIk9vstjboyEkTORuk
         wa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jq/+BcyiAwtDYy8ThiCBLyJ5XHWSBXaMbOIVg/4GVn8=;
        b=EM8fg3Fa0Iy7/pMRyG02Vts3qabIUFHviobzRzxgK5fi34cZaoETiqSli/sWIRpiKP
         ZP56Ed8w6GEaWxkVReffEb7FWieohMJMPq5WS5scObof7qUyCOczIY+higL/+GlEPq11
         FNZ0vDbGx3UgSR/YHbmtd6BYRo8lbDAuaw4fi52pel6YCoSnQ6kR9RDB1YMgRA1dYmxX
         WFWcWjnKWo4Ku3NJDB12+UJ4Kfz6xYAJDLOFgkGiodFurVKGzzRIB2mVwEZ+aC8Sk8Oh
         kp6JdHgMa5EhvrObPBLB9hLnRyPcGoaAAW3ZDplxYC8fy4o/qXx7eodXqeqUYAJBrxDM
         eGtQ==
X-Gm-Message-State: AOAM532HZbQN1veMe5icIv6pMk43zb1xUCkMZcuioIb5Ge0SR0L82g8O
        cia4BXgp043YPUIHMIYsp/T5mmAYhDU5FCNZHQXU1dv4yk2NtAw/8KQpcjgInwpHHzvP5YCBidt
        0LLV510jtnVql4EwYe49aXSvkO0P6kLE6qUDyryjYWPeZTB7nVurMlWG0HA==
X-Google-Smtp-Source: ABdhPJzajH43W3nB1u/QnWpuQy2rJw6clRNnWk4ESe01ais70W6jI3PIWW8SpRyxIKWNG40paVp6mpQJOVc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5b:303:: with SMTP id j3mr33062599ybp.433.1623188894702;
 Tue, 08 Jun 2021 14:48:14 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:36 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-5-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 04/10] KVM: arm64: Add userspace control of the guest's
 physical counter
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARMv8.6 adds an extension to the architecture providing hypervisors with
more extensive controls of the guest's counters. A particularly
interesting control is CNTPOFF_EL2, a fixed offset subtracted from the
physical counter value to derive the guest's value. VMMs that live
migrate their guests may be particularly interested in this feature in
order to provide a consistent view of the physical counter across live
migrations.

In the interim, KVM can emulate this behavior by simply enabling traps
on CNTPCT_EL0 and subtracting an offset.

Add a new field to kvm_system_counter_state allowing a VMM to request an
offset to the physical counter. If this offset is nonzero, enable traps
on CNTPCT_EL0. Emulate guest reads to the register in the fast path to
keep counter reads reasonably performant, avoiding a full exit from the
guest.

Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/include/asm/sysreg.h         |  1 +
 arch/arm64/include/uapi/asm/kvm.h       |  9 +++-
 arch/arm64/kvm/arch_timer.c             | 66 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 31 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 16 ++++--
 6 files changed, 117 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 31107d5e61af..a3abafcea328 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -200,6 +200,7 @@ enum vcpu_sysreg {
 	SP_EL1,
 	SPSR_EL1,
 
+	CNTPOFF_EL2,
 	CNTVOFF_EL2,
 	CNTV_CVAL_EL0,
 	CNTV_CTL_EL0,
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 65d15700a168..193da426690a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -505,6 +505,7 @@
 #define SYS_AMEVCNTR0_MEM_STALL		SYS_AMEVCNTR0_EL0(3)
 
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
+#define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
 
 #define SYS_CNTP_TVAL_EL0		sys_reg(3, 3, 14, 2, 0)
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d3987089c524..ee709e2f0292 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -184,6 +184,8 @@ struct kvm_vcpu_events {
 	__u32 reserved[12];
 };
 
+#define KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET	(1ul << 0)
+
 /* for KVM_{GET,SET}_SYSTEM_COUNTER_STATE */
 struct kvm_system_counter_state {
 	/* indicates what fields are valid in the structure */
@@ -191,7 +193,12 @@ struct kvm_system_counter_state {
 	__u32 pad;
 	/* guest counter-timer offset, relative to host cntpct_el0 */
 	__u64 cntvoff;
-	__u64 rsvd[7];
+	/*
+	 * Guest physical counter-timer offset, relative to host cntpct_el0.
+	 * Valid when KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET is set.
+	 */
+	__u64 cntpoff;
+	__u64 rsvd[6];
 };
 
 /* If you need to interpret the index values, here is the key: */
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 955a7a183362..a74642d1515f 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -50,6 +50,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
+static bool kvm_timer_emulation_required(struct arch_timer_context *ctx);
 
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
@@ -86,6 +87,8 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
 	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_PTIMER:
+		return __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
 	case TIMER_VTIMER:
 		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
 	default:
@@ -130,6 +133,9 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
 	switch(arch_timer_ctx_index(ctxt)) {
+	case TIMER_PTIMER:
+		__vcpu_sys_reg(vcpu, CNTPOFF_EL2) = offset;
+		break;
 	case TIMER_VTIMER:
 		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
 		break;
@@ -145,7 +151,7 @@ u64 kvm_phys_timer_read(void)
 
 static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
 {
-	if (has_vhe()) {
+	if (has_vhe() && !kvm_timer_emulation_required(vcpu_ptimer(vcpu))) {
 		map->direct_vtimer = vcpu_vtimer(vcpu);
 		map->direct_ptimer = vcpu_ptimer(vcpu);
 		map->emul_ptimer = NULL;
@@ -746,6 +752,30 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+bool kvm_timer_emulation_required(struct arch_timer_context *ctx)
+{
+	int idx = arch_timer_ctx_index(ctx);
+
+	switch (idx) {
+	/*
+	 * hardware doesn't support offsetting of the physical counter/timer.
+	 * If offsetting is requested, enable emulation of the physical
+	 * counter/timer.
+	 */
+	case TIMER_PTIMER:
+		return timer_get_offset(ctx);
+	/*
+	 * Conversely, hardware does support offsetting of the virtual
+	 * counter/timer.
+	 */
+	case TIMER_VTIMER:
+		return false;
+	default:
+		WARN_ON(1);
+		return false;
+	}
+}
+
 /* Make the updates of cntvoff for all vtimer contexts atomic */
 static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 {
@@ -1184,6 +1214,24 @@ void kvm_timer_init_vhe(void)
 	write_sysreg(val, cnthctl_el2);
 }
 
+static void kvm_timer_update_traps_vhe(struct kvm_vcpu *vcpu)
+{
+	u32 cnthctl_shift = 10;
+	u64 val;
+
+	if (!kvm_timer_emulation_required(vcpu_ptimer(vcpu)))
+		return;
+
+	/*
+	 * We must trap accesses to the physical counter/timer to emulate the
+	 * nonzero offset.
+	 */
+	val = read_sysreg(cnthctl_el2);
+	val &= ~(CNTHCTL_EL1PCEN << cnthctl_shift);
+	val &= ~(CNTHCTL_EL1PCTEN << cnthctl_shift);
+	write_sysreg(val, cnthctl_el2);
+}
+
 static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 {
 	struct kvm_vcpu *vcpu;
@@ -1260,24 +1308,36 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	return -ENXIO;
 }
 
+#define KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS	\
+		(KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
+
 int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
 					  struct kvm_system_counter_state *state)
 {
-	if (state->flags)
+	if (state->flags & ~KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS)
 		return -EINVAL;
 
 	state->cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
 
+	if (state->flags & KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
+		state->cntpoff = timer_get_offset(vcpu_ptimer(vcpu));
+
 	return 0;
 }
 
 int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
 					  struct kvm_system_counter_state *state)
 {
-	if (state->flags)
+	if (state->flags & ~KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS)
 		return -EINVAL;
 
 	timer_set_offset(vcpu_vtimer(vcpu), state->cntvoff);
 
+	if (state->flags & KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
+		timer_set_offset(vcpu_ptimer(vcpu), state->cntpoff);
+
+	if (has_vhe())
+		kvm_timer_update_traps_vhe(vcpu);
+
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..12ada31e12e2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -287,6 +287,30 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline u64 __hyp_read_cntpct(struct kvm_vcpu *vcpu)
+{
+	return read_sysreg(cntpct_el0) - __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
+}
+
+static inline bool __hyp_handle_counter(struct kvm_vcpu *vcpu)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+	int rt = kvm_vcpu_sys_get_rt(vcpu);
+	u64 rv;
+
+	switch (sysreg) {
+	case SYS_CNTPCT_EL0:
+		rv = __hyp_read_cntpct(vcpu);
+		break;
+	default:
+		return false;
+	}
+
+	vcpu_set_reg(vcpu, rt, rv);
+	__kvm_skip_instr(vcpu);
+	return true;
+}
+
 static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 {
 	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
@@ -439,6 +463,13 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (*exit_code != ARM_EXCEPTION_TRAP)
 		goto exit;
 
+	/*
+	 * We trap acesses to the physical counter value register (CNTPCT_EL0)
+	 * if userspace has requested a physical counter offset.
+	 */
+	if (__hyp_handle_counter(vcpu))
+		goto guest;
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
 	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
 	    handle_tx2_tvm(vcpu))
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..1b8e6e47a4ea 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -35,14 +35,24 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
  */
 void __timer_enable_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val, cntpoff;
+
+	cntpoff = __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
 
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
+	if (cntpoff)
+		val &= ~CNTHCTL_EL1PCTEN;
+	else
+		val |= CNTHCTL_EL1PCTEN;
+
 	write_sysreg(val, cnthctl_el2);
 }
-- 
2.32.0.rc1.229.g3e70b5a671-goog

