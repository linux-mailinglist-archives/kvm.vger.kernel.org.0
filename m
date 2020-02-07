Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2981555E1
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 11:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgBGKgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 05:36:38 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:40662 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgBGKgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 05:36:38 -0500
Received: by mail-pl1-f201.google.com with SMTP id y2so1064425plt.7
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 02:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jDXvVWSrS9mz8kI8Ow4xbDhWn2NTLmsDo4fcKVe11AY=;
        b=t20V/ONZ3f9oQXpDG9DGKcSm/lcOV108bIStnYgFL10aWxMB6v54O0u18ayvd/dcBr
         9GQt0W6WSPv3eSqtlp1dRsQvtng+RdruBHeStyIVMp33ERa0WTO3L7LRYLHjgrZFf05T
         k62+7E+V0Uby6AuxdGfiBiNwz7AkHqNXiQSkJxDbS81zTG+Kzkjn+qw+vg6D0Qc8ybV/
         IpNjSzJVdvuHwBFJOc59g6mv8zwOP3mm8+XYkngyKO4Pz7+Tm0jZUz+clkmJGNV6Nf9a
         uETbLKJeg3YnffkdWiDTptC9y36eP3b4k+PsM89ZmCrgWKsD+ksJOGv1c9CxEUjju0tN
         XSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jDXvVWSrS9mz8kI8Ow4xbDhWn2NTLmsDo4fcKVe11AY=;
        b=uEaqnYLtB9zwtqu8vzF/1JfLkg0jXJQkYgUZaWDHsldCqeiQTbeoYwZJLAb/4hO4P1
         XuADsDLLYDKLw7TIMngHWlZbycG9Rdou6GmAFVnVUs9aT3wpV2r6Bvfe9Ry03eGuOccC
         4STFUgW7gELo1rlnoM3tFWMRdfPyisTdahTtY12BxxhStJmZOWMChlPJRIRHmqq99Pqi
         QtOLq35vD//VTR31z2Dd3+5GfAnrKk0PG7amTPBn7NA0rpon6+ZSXsgt1Mn1RHRBDnnx
         XRgkcgY+8VWIeUWxII1SbBJRrsuXnmvFyymtUpPEUNLzFR9gh87RnQu9lnF1tBK/o2Ln
         J0FQ==
X-Gm-Message-State: APjAAAWed0VnELO/Mhi5YnsxoSGBgTBWFZ6aFBO88uOv4TKGsQP3iyV2
        /38ItmMcTuRY1S4R97KrkRlx5hH5OO7+N9bmiwMD9UalJPtbG/9mdvtRYnf1klmO2sTgq5NhRO8
        +29uYrIwsYT8jE2ocOwP05j03faOWu27losjTULlxh7uVucy7JQYBMWMFCg==
X-Google-Smtp-Source: APXvYqwOGd9sieaZMt7EcgmZY/su4J1HvM5ACsGZZKsVVFcGwcE6iXZsCHedNxnAJ28ijvuqeKV7tXNWSRs=
X-Received: by 2002:a63:7d46:: with SMTP id m6mr8448073pgn.38.1581071797057;
 Fri, 07 Feb 2020 02:36:37 -0800 (PST)
Date:   Fri,  7 Feb 2020 02:36:07 -0800
In-Reply-To: <20200207103608.110305-1-oupton@google.com>
Message-Id: <20200207103608.110305-5-oupton@google.com>
Mime-Version: 1.0
References: <20200207103608.110305-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v3 4/5] KVM: nVMX: Emulate MTF when performing instruction emulation
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
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
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm.c              |  1 +
 arch/x86/kvm/vmx/nested.c       | 35 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/nested.h       |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 37 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  3 +++
 arch/x86/kvm/x86.c              |  2 ++
 8 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4dffbc10d3f8..b930c548674c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1112,6 +1112,7 @@ struct kvm_x86_ops {
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*update_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 503d3f42da16..3f3f780c8c65 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -390,6 +390,7 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
+#define KVM_STATE_NESTED_MTF_PENDING	0x00000008
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a3e32d61d60c..fa923b5f8158 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7433,6 +7433,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.update_emulated_instruction = NULL,
 	.set_interrupt_shadow = svm_set_interrupt_shadow,
 	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1586aaae3a6f..93441821b24e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3608,8 +3608,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
+	bool mtf_pending = vmx->nested.mtf_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
+	/*
+	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
+	 * this state is discarded.
+	 */
+	vmx->nested.mtf_pending = false;
+
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
@@ -3620,8 +3627,28 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 		return 0;
 	}
 
+	/*
+	 * Process any exceptions that are not debug traps before MTF.
+	 */
+	if (vcpu->arch.exception.pending &&
+	    !vmx_pending_dbg_trap(vcpu) &&
+	    nested_vmx_check_exception(vcpu, &exit_qual)) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
+		return 0;
+	}
+
+	if (mtf_pending) {
+		if (block_nested_events)
+			return -EBUSY;
+		nested_vmx_update_pending_dbg(vcpu);
+		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
+		return 0;
+	}
+
 	if (vcpu->arch.exception.pending &&
-		nested_vmx_check_exception(vcpu, &exit_qual)) {
+	    nested_vmx_check_exception(vcpu, &exit_qual)) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
@@ -5711,6 +5738,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 
 			if (vmx->nested.nested_run_pending)
 				kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
+
+			if (vmx->nested.mtf_pending)
+				kvm_state.flags |= KVM_STATE_NESTED_MTF_PENDING;
 		}
 	}
 
@@ -5891,6 +5921,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	vmx->nested.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
+	vmx->nested.mtf_pending =
+		!!(kvm_state->flags & KVM_STATE_NESTED_MTF_PENDING);
+
 	ret = -EINVAL;
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
 	    vmcs12->vmcs_link_pointer != -1ull) {
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index fc874d4ead0f..e12461776151 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -175,6 +175,11 @@ static inline bool nested_cpu_has_virtual_nmis(struct vmcs12 *vmcs12)
 	return vmcs12->pin_based_vm_exec_control & PIN_BASED_VIRTUAL_NMIS;
 }
 
+static inline int nested_cpu_has_mtf(struct vmcs12 *vmcs12)
+{
+	return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
+}
+
 static inline int nested_cpu_has_ept(struct vmcs12 *vmcs12)
 {
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_EPT);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a6664886f2e..90102830eeb3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1599,6 +1599,40 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+
+/*
+ * Recognizes a pending MTF VM-exit and records the nested state for later
+ * delivery.
+ */
+static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!is_guest_mode(vcpu))
+		return;
+
+	/*
+	 * Per the SDM, MTF takes priority over debug-trap exceptions besides
+	 * T-bit traps. As instruction emulation is completed (i.e. at the
+	 * instruction boundary), any #DB exception pending delivery must be a
+	 * debug-trap. Record the pending MTF state to be delivered in
+	 * vmx_check_nested_events().
+	 */
+	if (nested_cpu_has_mtf(vmcs12) &&
+	    (!vcpu->arch.exception.pending ||
+	     vcpu->arch.exception.nr == DB_VECTOR))
+		vmx->nested.mtf_pending = true;
+	else
+		vmx->nested.mtf_pending = false;
+}
+
+static void vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	vmx_update_emulated_instruction(vcpu);
+	return skip_emulated_instruction(vcpu);
+}
+
 static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -7783,7 +7817,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = skip_emulated_instruction,
+	.skip_emulated_instruction = vmx_skip_emulated_instruction,
+	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f42cf3dcd70..e64da06c7009 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -150,6 +150,9 @@ struct nested_vmx {
 	/* L2 must run next, and mustn't decide to exit to L1. */
 	bool nested_run_pending;
 
+	/* Pending MTF VM-exit into L1.  */
+	bool mtf_pending;
+
 	struct loaded_vmcs vmcs02;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4d3310df1758..7dbe48072c54 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6891,6 +6891,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && ctxt->tf)
 				r = kvm_vcpu_do_singlestep(vcpu);
+			if (kvm_x86_ops->update_emulated_instruction)
+				kvm_x86_ops->update_emulated_instruction(vcpu);
 			__kvm_set_rflags(vcpu, ctxt->eflags);
 		}
 
-- 
2.25.0.341.g760bfbb309-goog

