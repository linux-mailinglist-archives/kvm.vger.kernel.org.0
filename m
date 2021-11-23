Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B5A45ADC3
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 22:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhKWVEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 16:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhKWVE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 16:04:29 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9794C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:20 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id x16-20020a25b910000000b005b6b7f2f91cso682644ybj.1
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ByP/I/N2qYqIP4+oWxcahvl0Co8ItsSKbQVT3k4Rcn4=;
        b=W7bbxxvsbd9U3ljuITR9++6jknbKsC92W11PsOKC0/tGu/UsrByddL9EQ+5Bhh5W9Q
         KlZj9qc4Nd+z7U/9T4RqKH+AMDMZK0wnVYSo9y0urh+qzL5Dopuw/CKOttoSfGt8QALX
         Fi516X28Kq79dT4ygbGadRLXMjcV1QRXWfB0qbjA3t6Q0RPNwR53ZMrsfDbhlnMStNxm
         GULkiuwhesEqjEqt/PJceU8wJaQ/u2oQS8bveS769DCn2JowQKKIuvfQY3XJTNM9OgiC
         0JYqLN16Wgu40uUcoiyPAn1rTuAxp7lowRAyAjtOCwLF4D5QA4X7SQfHuXqutA2GUNoY
         iXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ByP/I/N2qYqIP4+oWxcahvl0Co8ItsSKbQVT3k4Rcn4=;
        b=DAbjT44wqp+mMqHL6N6MOqyhwbBhx5ejRFyFhYwrZ5e0mleROWIzw0/J0DJeMKUQ2Q
         dsRWBAMWLkfZUoSUYkca9WdSV/13O9Al6Kmq2pojB0H6UwcBSQ0mYDY1/PDSKQLbAS9M
         UsKfzgsEJH9oKaBJW10TJ4kVbvSE7qSto3O8aYheu9dwUcbGQmGcJL1J1YKR0qo2A4Xf
         Ye5+fiQtwaLfd4v7q7HXDAeAXftzKVa1js6ld6o9xJgvTxJfULyUYJh5yctreKsL+eku
         6nRfsJNRyN13ywRS19URtoj2hkewD54LUZQPEHgU/BYc11wMpL18IwRvit4QaMiNXPAY
         03iw==
X-Gm-Message-State: AOAM530wEubNByNA4TbimWG5tai9wvxOkfX7WIsQRandFFeJea71x3eD
        Ejx5/FCvgUf3AB6NLzUZY7aEe68LgGU=
X-Google-Smtp-Source: ABdhPJzT8/fpf0OeUjKwQSdIU9dd+uNdcajbMkZ9EYM7lHyXy/n3vbwioTrguxRlVGlBfdAjqYGQ0sxxmTQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:c6cd:: with SMTP id k196mr9724031ybf.411.1637701279952;
 Tue, 23 Nov 2021 13:01:19 -0800 (PST)
Date:   Tue, 23 Nov 2021 21:01:07 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-5-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 4/6] KVM: arm64: Emulate the OS Lock
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
blocking all but software breakpoint instructions. To handle breakpoint
instructions, trap debug exceptions to EL2 and skip the instruction.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/debug.c            | 27 +++++++++++++++++++++++----
 arch/arm64/kvm/sys_regs.c         |  6 +++---
 3 files changed, 30 insertions(+), 7 deletions(-)

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
index db9361338b2a..7835c76347ce 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -53,6 +53,14 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 				vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
+/*
+ * Returns true if the host needs to use the debug registers.
+ */
+static inline bool host_using_debug_regs(struct kvm_vcpu *vcpu)
+{
+	return vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu);
+}
+
 /**
  * kvm_arm_init_debug - grab what we need for debug
  *
@@ -105,9 +113,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
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
@@ -160,8 +170,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 	kvm_arm_setup_mdcr_el2(vcpu);
 
-	/* Is Guest debugging in effect? */
-	if (vcpu->guest_debug) {
+	/*
+	 * Check if we need to use the debug registers.
+	 */
+	if (host_using_debug_regs(vcpu)) {
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
 
@@ -223,6 +235,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
 						&vcpu->arch.debug_ptr->dbg_wcr[0],
 						&vcpu->arch.debug_ptr->dbg_wvr[0]);
+		} else if (kvm_vcpu_os_lock_enabled(vcpu)) {
+			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
+			mdscr &= ~DBG_MDSCR_MDE;
+			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 	}
 
@@ -244,7 +260,10 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_arm_clear_debug(vcpu->guest_debug);
 
-	if (vcpu->guest_debug) {
+	/*
+	 * Restore the guest's debug registers if we were using them.
+	 */
+	if (host_using_debug_regs(vcpu)) {
 		restore_guest_debug_regs(vcpu);
 
 		/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5dbdb45d6d44..1346906f5c46 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1453,9 +1453,9 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
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
2.34.0.rc2.393.gf8c9666880-goog

