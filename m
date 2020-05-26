Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAB21B24E3
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 13:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgDULUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 07:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbgDULUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 07:20:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB06C061A0F;
        Tue, 21 Apr 2020 04:20:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id r14so6475813pfg.2;
        Tue, 21 Apr 2020 04:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QbG6biHp7POKFANtSjyG5DgTEjhmjx/tR45VHaH/c6o=;
        b=dbvR1S1tnGDSR0EE8JeQjF1WfQcA3v9bN4+8IUeK0EFp1ih+yixTZu+w60i6g1AOcv
         XaM7n9loE28Tx9k6nfwirXh+HutG+Qr/VzyZcIvkg1sqg7+7iND1XKQOr7qVBEf4E9v+
         0mWm3movjv1Mvrgsxn+U1bnV9Cq6NVHxsFAQA8epmOlr32cut9wRQggoWYYM9pBsOlPV
         ckZ6XjC89O1lZ0du/uOHR2VhQm8zpheuAebT6OrDpRYflQDxDdXtlR4OmImHyG/XFsXf
         nvFNV5l9tv6jk41tdjGYGp/N4r7Y+SLzcgD+Nni/Ex2VC8mB6LG0uNgOb9ZsyJVFCnqk
         6HVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QbG6biHp7POKFANtSjyG5DgTEjhmjx/tR45VHaH/c6o=;
        b=BDNrvZEiWk2WNFPrycawlylrdyyWpCHyIddDMg5C9T0flref92yuqg9vfHPZOKpFb9
         0fFyF/JoiwguCN7+0ltDLfjn1LquQjwt52KBFIFNAEh7WJ94b3C2EXQUWXS76rAXEw8G
         Yj4W4BIjxO13KLQNbKnQjAI99C9HfYK2s62UP2ON0svssnbEj1DEkqJb7BW2WzKbxeDR
         HuuE6Pf4vnH7xy5huNwTEFI/bvMgWd/aZ3TwzHScEzUYjiYpte5jdWX5VL/VjwC4VdyK
         TWwja9RVLzdqHDs2V3JqfgyI8GzvTRw8daluiiax2Awa0hZR61aHAl1aoMyW+H2gleAi
         fKOw==
X-Gm-Message-State: AGi0PuYfXEDhxs+dNlBztgDGdgWm5l2B3x/gyiwWx2uSaUgGtiuPxwv/
        RxltP9+cWu13kh0GFlaztse91SgT
X-Google-Smtp-Source: APiQypJmxhDbseGNrk49snh8EeA5KO89I4RjsXTpuzNfM1jl4yk99QASc7AI5sQmwCtXfMyRS21uHg==
X-Received: by 2002:a62:8746:: with SMTP id i67mr7003745pfe.9.1587468039044;
        Tue, 21 Apr 2020 04:20:39 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id f74sm8643176pje.3.2020.04.21.04.20.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2020 04:20:38 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH 1/2] KVM: X86: TSCDEADLINE MSR emulation fastpath
Date:   Tue, 21 Apr 2020 19:20:25 +0800
Message-Id: <1587468026-15753-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
References: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements tscdealine msr emulation fastpath, after wrmsr 
tscdeadline vmexit, handle it as soon as possible and vmentry immediately 
without checking various kvm stuff when possible.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/lapic.c            | 20 +++-----------
 arch/x86/kvm/lapic.h            | 16 +++++++++++
 arch/x86/kvm/vmx/vmx.c          | 60 +++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c              | 55 ++++++++++++++++++++++++++++++++-----
 5 files changed, 126 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f26df2c..1626ce3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -188,6 +188,7 @@ enum {
 enum exit_fastpath_completion {
 	EXIT_FASTPATH_NONE,
 	EXIT_FASTPATH_SKIP_EMUL_INS,
+	EXIT_FASTPATH_CONT_RUN,
 };
 
 struct x86_emulate_ctxt;
@@ -1265,6 +1266,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+	void (*fast_deliver_interrupt)(struct kvm_vcpu *vcpu);
+	bool (*event_needs_reinjection)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 38f7dc9..9e54301 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -91,6 +91,7 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 }
 
 struct static_key_deferred apic_hw_disabled __read_mostly;
+EXPORT_SYMBOL_GPL(apic_hw_disabled);
 struct static_key_deferred apic_sw_disabled __read_mostly;
 
 static inline int apic_enabled(struct kvm_lapic *apic)
@@ -311,21 +312,6 @@ static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
 	return !(kvm_lapic_get_reg(apic, lvt_type) & APIC_LVT_MASKED);
 }
 
-static inline int apic_lvtt_oneshot(struct kvm_lapic *apic)
-{
-	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_ONESHOT;
-}
-
-static inline int apic_lvtt_period(struct kvm_lapic *apic)
-{
-	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_PERIODIC;
-}
-
-static inline int apic_lvtt_tscdeadline(struct kvm_lapic *apic)
-{
-	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_TSCDEADLINE;
-}
-
 static inline int apic_lvt_nmi_mode(u32 lvt_val)
 {
 	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
@@ -1781,7 +1767,7 @@ static void cancel_hv_timer(struct kvm_lapic *apic)
 	apic->lapic_timer.hv_timer_in_use = false;
 }
 
-static bool start_hv_timer(struct kvm_lapic *apic)
+bool kvm_start_hv_timer(struct kvm_lapic *apic)
 {
 	struct kvm_timer *ktimer = &apic->lapic_timer;
 	struct kvm_vcpu *vcpu = apic->vcpu;
@@ -1847,7 +1833,7 @@ static void restart_apic_timer(struct kvm_lapic *apic)
 	if (!apic_lvtt_period(apic) && atomic_read(&apic->lapic_timer.pending))
 		goto out;
 
-	if (!start_hv_timer(apic))
+	if (!kvm_start_hv_timer(apic))
 		start_sw_timer(apic);
 out:
 	preempt_enable();
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7f15f9e..4c917fd 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -251,6 +251,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu);
+bool kvm_start_hv_timer(struct kvm_lapic *apic);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
@@ -262,4 +263,19 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
 
+static inline int apic_lvtt_oneshot(struct kvm_lapic *apic)
+{
+	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_ONESHOT;
+}
+
+static inline int apic_lvtt_period(struct kvm_lapic *apic)
+{
+	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_PERIODIC;
+}
+
+static inline int apic_lvtt_tscdeadline(struct kvm_lapic *apic)
+{
+	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_TSCDEADLINE;
+}
+
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 766303b..7688e40 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6559,6 +6559,54 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+static bool vmx_event_needs_reinjection(struct kvm_vcpu *vcpu)
+{
+	return (to_vmx(vcpu)->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
+		kvm_event_needs_reinjection(vcpu);
+}
+
+static void vmx_fast_deliver_interrupt(struct kvm_vcpu *vcpu)
+{
+	u32 reg;
+	int vector;
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	if (kvm_apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
+		vector = reg & APIC_VECTOR_MASK;
+		kvm_lapic_clear_vector(vector, apic->regs + APIC_TMR);
+
+		if (vcpu->arch.apicv_active) {
+			if (pi_test_and_set_pir(vector, &vmx->pi_desc))
+				return;
+
+			if (pi_test_and_set_on(&vmx->pi_desc))
+				return;
+
+			vmx_sync_pir_to_irr(vcpu);
+		} else {
+			kvm_lapic_set_irr(vector, apic);
+			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
+			vmx_inject_irq(vcpu);
+		}
+	}
+}
+
+static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	if (!is_guest_mode(vcpu)) {
+		switch (to_vmx(vcpu)->exit_reason) {
+		case EXIT_REASON_MSR_WRITE:
+			return handle_fastpath_set_msr_irqoff(vcpu);
+		default:
+			return EXIT_FASTPATH_NONE;
+		}
+	}
+
+	return EXIT_FASTPATH_NONE;
+}
+
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
 static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
@@ -6566,6 +6614,7 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	enum exit_fastpath_completion exit_fastpath;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
+continue_vmx_vcpu_run:
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -6733,17 +6782,16 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return EXIT_FASTPATH_NONE;
 
-	if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
-		exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
-	else
-		exit_fastpath = EXIT_FASTPATH_NONE;
-
 	vmx->loaded_vmcs->launched = 1;
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
+	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
+	if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
+		goto continue_vmx_vcpu_run;
+
 	return exit_fastpath;
 }
 
@@ -7885,6 +7933,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.fast_deliver_interrupt = vmx_fast_deliver_interrupt,
+	.event_needs_reinjection = vmx_event_needs_reinjection,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59958ce..9c6733d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1609,27 +1609,70 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	return 1;
 }
 
+static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
+			apic_lvtt_period(apic))
+		return 0;
+
+	if (!kvm_x86_ops.set_hv_timer ||
+		kvm_mwait_in_guest(vcpu->kvm) ||
+		kvm_can_post_timer_interrupt(vcpu))
+		return 1;
+
+	hrtimer_cancel(&apic->lapic_timer.timer);
+	apic->lapic_timer.tscdeadline = data;
+	atomic_set(&apic->lapic_timer.pending, 0);
+
+	if (kvm_start_hv_timer(apic)) {
+		if (kvm_check_request(KVM_REQ_PENDING_TIMER, vcpu)) {
+			if (kvm_x86_ops.interrupt_allowed(vcpu)) {
+				kvm_clear_request(KVM_REQ_PENDING_TIMER, vcpu);
+				kvm_x86_ops.fast_deliver_interrupt(vcpu);
+				atomic_set(&apic->lapic_timer.pending, 0);
+				apic->lapic_timer.tscdeadline = 0;
+				return 0;
+			}
+			return 1;
+		}
+		return 0;
+	}
+
+	return 1;
+}
+
 enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
-	int ret = 0;
+	int ret = EXIT_FASTPATH_NONE;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		data = kvm_read_edx_eax(vcpu);
-		ret = handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
+		if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data))
+			ret = EXIT_FASTPATH_SKIP_EMUL_INS;
+		break;
+	case MSR_IA32_TSCDEADLINE:
+		if (!kvm_x86_ops.event_needs_reinjection(vcpu)) {
+			data = kvm_read_edx_eax(vcpu);
+			if (!handle_fastpath_set_tscdeadline(vcpu, data))
+				ret = EXIT_FASTPATH_CONT_RUN;
+		}
 		break;
 	default:
-		return EXIT_FASTPATH_NONE;
+		ret = EXIT_FASTPATH_NONE;
 	}
 
-	if (!ret) {
+	if (ret != EXIT_FASTPATH_NONE) {
 		trace_kvm_msr_write(msr, data);
-		return EXIT_FASTPATH_SKIP_EMUL_INS;
+		if (ret == EXIT_FASTPATH_CONT_RUN)
+			kvm_skip_emulated_instruction(vcpu);
 	}
 
-	return EXIT_FASTPATH_NONE;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
-- 
2.7.4

