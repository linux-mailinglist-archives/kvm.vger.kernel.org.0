Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7678E4A8A5F
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353008AbiBCRmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352996AbiBCRmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:42:07 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93909C061714
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:42:07 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id a18-20020a923312000000b002b384dccc91so2194463ilf.1
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Nr8Z5OJ29ROTcrYqtf+ESfxb+ZGc4axhNqbKIHGyx48=;
        b=Zsmt6apLHIOrBX2WT/vEH+Cx5ozwlrkyIKXHn1hHeEEE8fib7VyrQFw+64K33mlo4Z
         fKUvhi393LhKtsn0GRp2uUfGOVxAsGxCBjRJM7yN8Y9+WLbgvoN5wCmKqh6kCq/UJOAL
         vjoe9AVESUQJhGxjbxHPCrwUwwM92RQKsK3vbxKrMyJV/p7MghbYHLe4x/VmHq9z4pZa
         KMKANvjA3mPuRaxs0Wq2zJMymU36GpQ7HlmIHT+eza9nhM8pRxerwWnuaNtP+EuoWuQ0
         0mrlcZhcXPaDJjPprgQTJQk7vwIoTBQLndrmGxCML+1AG77OAz3qSPsXarnS5G8nQyz1
         qpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Nr8Z5OJ29ROTcrYqtf+ESfxb+ZGc4axhNqbKIHGyx48=;
        b=j+Izz/S56Ylh5+5j28y4fUD5WaH5rADV9heqpS4kBRnIQAlYWiFmPpNAWR09vBMiG7
         FdjbErFkseMbwM6Gpa+3glbMEP0iRy9B9fmTT/M16LYTwtvvNzxXA/hu9J0xjHbx2PX0
         ohQz1iyXQrP4pNK1fVvL02ILNSwof+wybjHNCD0HO7xKn2ssQvllzQESza0Y1k/sCSA9
         6rlrtEME59MmlhhEeVgJd+FcTgg0SAs7md/upTSdn981cCEmsD9O4BHH75uLklgZPvrX
         RFpdBcyWZEqnxPdY9iDyupM0b56V7KgjK2+WAf7MZuEOQci9y2ieVjnQ0n6eE5GF8f0Y
         Ab1Q==
X-Gm-Message-State: AOAM5333GQR0y3B770iFRYfq9iLd4RKK1KkdVfho3L2svs50wqZRGyY2
        4XZl9Rz7N/3fkQWAxCWKNtcI4rP+s4o=
X-Google-Smtp-Source: ABdhPJyPjx/GoLIMEP3S5DYF0m7WONfmTl73rjwA7Ukvp8YcT5Olh4b/zTsPduICjWXRqbtnZGNz7XZiRHs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:ba14:: with SMTP id z20mr11969165jan.102.1643910127009;
 Thu, 03 Feb 2022 09:42:07 -0800 (PST)
Date:   Thu,  3 Feb 2022 17:41:57 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-5-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 4/6] KVM: arm64: Emulate the OS Lock
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The OS lock blocks all debug exceptions at every EL. To date, KVM has
not implemented the OS lock for its guests, despite the fact that it is
mandatory per the architecture. Simple context switching between the
guest and host is not appropriate, as its effects are not constrained to
the guest context.

Emulate the OS Lock by clearing MDE and SS in MDSCR_EL1, thereby
blocking all but software breakpoint instructions.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/debug.c            | 26 ++++++++++++++++++++++----
 arch/arm64/kvm/sys_regs.c         |  6 +++---
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cc1cc40d89f0..3c73e4de4229 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -726,6 +726,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
+
+#define kvm_vcpu_os_lock_enabled(vcpu)		\
+	(!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK))
+
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index db9361338b2a..4fd5c216c4bb 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -105,9 +105,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 *  - Userspace is using the hardware to debug the guest
 	 *  (KVM_GUESTDBG_USE_HW is set).
 	 *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
+	 *  - The guest has enabled the OS Lock (debug exceptions are blocked).
 	 */
 	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
-	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY) ||
+	    kvm_vcpu_os_lock_enabled(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 
 	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
@@ -160,8 +162,8 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 	kvm_arm_setup_mdcr_el2(vcpu);
 
-	/* Is Guest debugging in effect? */
-	if (vcpu->guest_debug) {
+	/* Check if we need to use the debug registers. */
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
 
@@ -223,6 +225,19 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
 						&vcpu->arch.debug_ptr->dbg_wcr[0],
 						&vcpu->arch.debug_ptr->dbg_wvr[0]);
+
+		/*
+		 * The OS Lock blocks debug exceptions in all ELs when it is
+		 * enabled. If the guest has enabled the OS Lock, constrain its
+		 * effects to the guest. Emulate the behavior by clearing
+		 * MDSCR_EL1.MDE. In so doing, we ensure that host debug
+		 * exceptions are unaffected by guest configuration of the OS
+		 * Lock.
+		 */
+		} else if (kvm_vcpu_os_lock_enabled(vcpu)) {
+			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
+			mdscr &= ~DBG_MDSCR_MDE;
+			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 	}
 
@@ -244,7 +259,10 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_arm_clear_debug(vcpu->guest_debug);
 
-	if (vcpu->guest_debug) {
+	/*
+	 * Restore the guest's debug registers if we were using them.
+	 */
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		restore_guest_debug_regs(vcpu);
 
 		/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b0d7240ef49f..dd34b5ab51d4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1457,9 +1457,9 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
  * Debug handling: We do trap most, if not all debug related system
  * registers. The implementation is good enough to ensure that a guest
  * can use these with minimal performance degradation. The drawback is
- * that we don't implement any of the external debug, none of the
- * OSlock protocol. This should be revisited if we ever encounter a
- * more demanding guest...
+ * that we don't implement any of the external debug architecture.
+ * This should be revisited if we ever encounter a more demanding
+ * guest...
  */
 static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
-- 
2.35.0.263.gb82422642f-goog

