Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7104442AA9
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhKBJtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhKBJti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:49:38 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596E2C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 02:47:04 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id x15-20020a056602160f00b005e1888842d5so6210655iow.14
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 02:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uurkhpIbGOm6d0Vndzx4M8suePh/mfJb26pfAeTQQ2Q=;
        b=hfG5wU8dCHVF7dzzRdCErkdSpbwwJpZuXaQLMBh7ivg7UkdR7Q2EXzLbnT41pop135
         XCHRgVpXBLovwNMqy9DIRMmWmVsZ28tIM6cX3gNxKkrPynPaKlZhQ+8khbqNpw+EoGno
         9oGJnKnGefLQm0tEsiIyE3j3FutcPJhp1HNLgqHfFbcSrz1R0C1IWb9eW4kQmZzvK/C0
         PltELiax0LrjH9/UNYt+8l1Bs+UIeitFUh56258VomoZ8MR78MzMdJftxtD5GCXcXdhT
         cEH0Ki7u6Q2zMBKCNJchGI/GIhfrFO+/bowakv7b8AkGnKTiY1XXeU4m796IUaMR/Zcl
         cYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uurkhpIbGOm6d0Vndzx4M8suePh/mfJb26pfAeTQQ2Q=;
        b=KY+TPjdGhhuW1T4wCiXFZtx2X4rkwzdy6aYPw6+8oB7xSQlSZxQ+RqelmV0Iz0DaNf
         p4/qfeZm/49taLR+fRYcfoybPgguY4L/l95+NFhHsy5yZlwddh51pc2ucQJxWgsnXb/A
         rI5sOLAFoIKVPt/epBwWHUdWU+2zef3qFgupncBSxa2tfjOz4IiuVHSCihi1XnR/8uPm
         GO/FUbiXK8xNxXWbkAgNtqoizfurk7doqdJkfjQv3IB23z19agZ3izXDeZVNdh7C9nN8
         bJAsNVl/PE3xBHXLtsuDzfhmeqxy5EQD3xy2sv8UtaOx68E9lNjRrEMzpYtmU6bCJd64
         HiWA==
X-Gm-Message-State: AOAM533NP2nRVApkHJkWiugtnG0rRO4gqZQtF8xYkRJAg5xkks4MY+LH
        DllchVtjeGj+583paIdgpCKmhDWcBT0=
X-Google-Smtp-Source: ABdhPJzdE2f0jbKc/HrPBSVM0QUl30mxLU3ZJlUaX+L3AkUnjf0ehb/ooOshHnhNm9o1UfgzNO0sexgE6jQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:174d:: with SMTP id
 y13mr24331087ill.251.1635846423807; Tue, 02 Nov 2021 02:47:03 -0700 (PDT)
Date:   Tue,  2 Nov 2021 09:46:49 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-5-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 4/6] KVM: arm64: Emulate the OS Lock
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
 arch/arm64/kvm/debug.c            | 20 +++++++++++++++-----
 arch/arm64/kvm/handle_exit.c      |  8 ++++++++
 arch/arm64/kvm/sys_regs.c         |  6 +++---
 4 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c98f65c4a1f7..f13b8b79b06d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -724,6 +724,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
+
+#define kvm_vcpu_os_lock_enabled(vcpu)		\
+	(__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK)
+
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index db9361338b2a..5690a9c99c89 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -95,8 +95,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
 
-	/* Is the VM being debugged by userspace? */
-	if (vcpu->guest_debug)
+	/*
+	 * Check if the VM is being debugged by userspace or the guest has
+	 * enabled the OS lock.
+	 */
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu))
 		/* Route all software debug exceptions to EL2 */
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
 
@@ -160,8 +163,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 	kvm_arm_setup_mdcr_el2(vcpu);
 
-	/* Is Guest debugging in effect? */
-	if (vcpu->guest_debug) {
+	/*
+	 * Check if the guest is being debugged or if the guest has enabled the
+	 * OS lock.
+	 */
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
 
@@ -223,6 +229,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
 						&vcpu->arch.debug_ptr->dbg_wcr[0],
 						&vcpu->arch.debug_ptr->dbg_wvr[0]);
+		} else if (kvm_vcpu_os_lock_enabled(vcpu)) {
+			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
+			mdscr &= ~DBG_MDSCR_MDE;
+			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 	}
 
@@ -244,7 +254,7 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_arm_clear_debug(vcpu->guest_debug);
 
-	if (vcpu->guest_debug) {
+	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		restore_guest_debug_regs(vcpu);
 
 		/*
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..a7136888434d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -119,6 +119,14 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
+
+	if (!vcpu->guest_debug) {
+		WARN_ONCE(esr_ec != ESR_ELx_EC_BRK64 || esr_ec != ESR_ELx_EC_BKPT32,
+			  "Unexpected debug exception\n");
+		kvm_incr_pc(vcpu);
+		return 1;
+	}
 
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = esr;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index acd8aa2e5a44..d336e4c66870 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1446,9 +1446,9 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
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
2.33.1.1089.g2158813163f-goog

