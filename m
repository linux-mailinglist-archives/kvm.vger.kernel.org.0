Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1166947496A
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 18:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhLNR2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 12:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbhLNR2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 12:28:21 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841F7C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:28:21 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id x6-20020a056e021ca600b002a15324045fso18324038ill.12
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AHaXpoeYGJKTcAQ6Ud9mbrS81eJMXMtZFTk611Ztqc4=;
        b=c6W/nuae9oJxHgaXmzSGJgmKhJwSh2+LsAI2ukYUcpG4HInlgliXxM9uwDKAFF38/B
         K912gRJ6ueOjUFUKOnA+q16CwFcmxWyYOB419U2/AntSymTrHJDOb0qwqVl/KyhYwjKC
         ojtn1l0nx0gfyhB93Edm/2wv6LFgbx2uWhlEFNzQYVQZL8baoCrMEx/1b3YwXRSaP9hs
         IhFpTVQ1C1Egxkvv+xtzfvBLLVss081BpixM1thXE2EgGY13ZGtpTXkcOSU3JXUt7091
         P1nTeYPbbYQyXcrh0lcIR5FhOH1tl74uoblifx7psv3Ovc0vDXUWABszb2VZIQ775ec9
         qJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AHaXpoeYGJKTcAQ6Ud9mbrS81eJMXMtZFTk611Ztqc4=;
        b=jVqfOMzr9GDRlu1qQkkE2D8gvaEPNMUX3cYnUqL4wRz/gSHMd9k70THbCu8Od+tDBS
         skzvWwm/sc+a8F29zQn+o39pOyiaLr+uTrmvCF8N8bdEyzQ6lBURDDgU9Je7O84Nv+6V
         m7GsybUhx4Mpx0cxN64o+U3RmW5MO/VQiNkqXPl7n8eD6/7iNBdDMoD5vR2UakdX/khI
         cV8Xqs1/Ei0zrKb0P7KblBdFgXwgFfysFXZUPc7dNs+eo9OoFx+Yp6zjVUY/8/LGPcBr
         3sa9VGVfop19yRMczIXWXuA4P7A9FFpmrvZ0lcPcIGcsjZm+T2tPgKjfIUCF75rvGHMM
         BYUQ==
X-Gm-Message-State: AOAM532ROdERTPcvCt5YbNS9AvCU2ICWSQtMdcmyZMqCIw7C63p0n9Cb
        jEjYyTEvMdTGuezb+A1S4Moh6vKwOio=
X-Google-Smtp-Source: ABdhPJwgdXjrBk4yOm+tW/+RM2khejK62DN1txDRVsC8fkYX9XOzvSZ+GgcF2gHj6U1ZYY3NspcG+conVeU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:b:: with SMTP id
 z11mr3766250jao.801.1639502900958; Tue, 14 Dec 2021 09:28:20 -0800 (PST)
Date:   Tue, 14 Dec 2021 17:28:10 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-5-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 4/6] KVM: arm64: Emulate the OS Lock
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
index 53fc8a6eaf1c..e5a06ff1cba6 100644
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
index 5188a74095e3..50a6966aab1b 100644
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
2.34.1.173.g76aa8bc2d0-goog

