Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA8A139C34
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 23:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgAMWLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 17:11:01 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:33321 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbgAMWLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 17:11:01 -0500
Received: by mail-pg1-f202.google.com with SMTP id s23so7238045pgg.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 14:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oNXTuZEEPOxvvJWf9w6Dwwhmjs7WBQSfN0wXaDn0P54=;
        b=KrBkp4Vm6/962Hh8vwtUiqeuYmOgI0Df89o9QWtAqyKf9wdc2iDejmkTArjVu7DZfu
         3sKQv7M0fDsgJgUJAgDMASNxNG2YRj6Qj0WOGv634fr/J3bwppK3c+yDXwxFRKfRMv0a
         2C1EH5lSp9IkKm495i1DRNyB7D6VPBiJWvM5KRNe4Q5SDM+VrEiSC/5z6PJqYaLaqpHa
         M+qkRXevDtS2HR1NXGX8pms07Phrh1uTi21hn3qQWeTMMNOnv5W8wDNKFtJTciNtKMfn
         wNkVieGFdDP3161pOluNCRydNTa5+SYr7FzNiiWhvgLvhrCJ2jQ8UaXDrBs/T7Ix2vcn
         NA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oNXTuZEEPOxvvJWf9w6Dwwhmjs7WBQSfN0wXaDn0P54=;
        b=rDXRDIWPrlivCPWPh8fMWlUMbrbI+tmxDfcXq+gQd5ZbWL3iIFXjoKUjYI7xv0UZ4A
         237XDEcgWuXZ7vSoUYl7bFF6GWm5N9h3rduJ5hZKml1auTy/+4SfYlZc46v/pQoiJLlB
         rpAJi/SC3Fh17rZrz5de2vvCBVUNGu6THrsx1sJ1g8OPritGABdv12b6LMyPiMCqlJMj
         07pYC6FuMCRNmXU3XZc4HRo9SelAsguRyovElMFJROOXs5zjQaj0fnYnF/brEkVCoDHR
         YfL2p3J724cGqu8htDz88F7mJa4NrpCOqbhcbHHrw/FGoPm3m+tIPWwiK0uOdLvwi/pm
         1mtA==
X-Gm-Message-State: APjAAAVHETTHeWeaAR6L/X2M91WaJCw2sz6MEgPeTcinoEz6b28gqC+P
        zp48geYVO3apM1VYV8cdlSpDEsqO4fKm52TsktSvryqyqEs4smSVv+FXnsnJtT4r5W80GcigII1
        ggEUXgsZqAq3L/rQZKgSTxG1wo/A5o/UXch6RwXo7hXkWqm6hs96kVPBGCA==
X-Google-Smtp-Source: APXvYqzYV2qHtOYe5nDUO0RqixnYpOHnA4RBJ8501ZaLgE2sQygje2GJyJ5bmPBl3uuVZYPmq2W9BmagDw4=
X-Received: by 2002:a65:4109:: with SMTP id w9mr22922880pgp.383.1578953460042;
 Mon, 13 Jan 2020 14:11:00 -0800 (PST)
Date:   Mon, 13 Jan 2020 14:10:52 -0800
In-Reply-To: <20200113221053.22053-1-oupton@google.com>
Message-Id: <20200113221053.22053-3-oupton@google.com>
Mime-Version: 1.0
References: <20200113221053.22053-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH 2/3] KVM: x86: Emulate MTF when performing instruction emulation
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 5f3d45e7f282 ("kvm/x86: add support for
MONITOR_TRAP_FLAG"), KVM has allowed an L1 guest to use the monitor trap
flag processor-based execution control for its L2 guest. KVM simply
forwards any MTF VM-exits to the L1 guest, which works for normal
instruction execution.

However, when KVM needs to emulate an instruction on the behalf of an L2
guest, the monitor trap flag is not emulated. Add the necessary logic to
kvm_skip_emulated_instruction() to synthesize an MTF VM-exit to L1 upon
instruction emulation for L2.

Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              |  5 +++++
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/nested.h       |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 19 +++++++++++++++++++
 arch/x86/kvm/x86.c              |  6 ++++++
 6 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4739ca11885d..89dcdc7201ae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1092,6 +1092,7 @@ struct kvm_x86_ops {
 	void (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*emulation_complete)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 16ded16af997..f21eec4443d5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -802,6 +802,10 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static void svm_emulation_complete(struct kvm_vcpu *vcpu)
+{
+}
+
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -7320,6 +7324,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.emulation_complete = svm_emulation_complete,
 	.set_interrupt_shadow = svm_set_interrupt_shadow,
 	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..ee26f2d10a09 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5578,7 +5578,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_MWAIT_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
 	case EXIT_REASON_MONITOR_TRAP_FLAG:
-		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
+		return nested_cpu_has_mtf(vmcs12);
 	case EXIT_REASON_MONITOR_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
 	case EXIT_REASON_PAUSE_INSTRUCTION:
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index fc874d4ead0f..901d2745bc93 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -238,6 +238,11 @@ static inline bool nested_cpu_has_save_preemption_timer(struct vmcs12 *vmcs12)
 	    VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
 }
 
+static inline bool nested_cpu_has_mtf(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
+}
+
 /*
  * In nested virtualization, check if L1 asked to exit on external interrupts.
  * For most existing hypervisors, this will always return true.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 148696199c88..8d3b693c3d3a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1595,6 +1595,24 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static void vmx_emulation_complete(struct kvm_vcpu *vcpu)
+{
+	if (!(is_guest_mode(vcpu) &&
+	      nested_cpu_has_mtf(get_vmcs12(vcpu))))
+		return;
+
+	/*
+	 * Per the SDM, MTF takes priority over debug-trap instructions. As
+	 * instruction emulation is completed (i.e. at the instruction
+	 * boundary), any #DB exception must be a trap. Emulate an MTF VM-exit
+	 * into L1 should there be a debug-trap exception pending or no
+	 * exception pending.
+	 */
+	if (!vcpu->arch.exception.pending ||
+	    vcpu->arch.exception.nr == DB_VECTOR)
+		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
+}
+
 static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -7831,6 +7849,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.emulation_complete = vmx_emulation_complete,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c14174c033e4..d3af7a8a3c4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6546,6 +6546,12 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(rflags & X86_EFLAGS_TF))
 		r = kvm_vcpu_do_singlestep(vcpu);
+	/*
+	 * Allow for vendor-specific handling of completed emulation before
+	 * returning.
+	 */
+	if (r)
+		kvm_x86_ops->emulation_complete(vcpu);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
-- 
2.25.0.rc1.283.g88dfdc4193-goog

