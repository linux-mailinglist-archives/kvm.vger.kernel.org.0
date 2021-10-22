Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2096D436F08
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 02:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhJVAv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 20:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbhJVAvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 20:51:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB45C061766
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y18-20020a25a092000000b005bddb39f160so2204373ybh.10
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GWNt5XJHgQ1LrHyVefEGSuq5UcWUA2qU9Pc3G0LHuLQ=;
        b=IrNvDlM7o36W8hkj0E1Sz84FxU1MsU6604rb0P8hXfDvtMqXOFwkyH7GC7kGZ/VfRr
         8tv0hwIBmZmTliP4ZEfpvHhFqi1x941rtVTYtdmBuYxA+DWApw64cK2knJOlJQY8BtNd
         qNGILXZ4wGFtkOkR3kdlTkI+0nv9WFdiyA0xjfDpWKqGUYRn6ISN2jiLwHVCvWlGDxmy
         UUURlLd0Rolk+QkSnn0feuKgEvg7e74n5HD16cUiKpWhI2fnwpsvGa4UErmzLdb/X8/S
         9IwfnAKmSfOi6mTl8qDOfvkoBHsoiRm/RuPdoMLqSRyIZgqmV/pcHp14RnLWd8TNAEqt
         //TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GWNt5XJHgQ1LrHyVefEGSuq5UcWUA2qU9Pc3G0LHuLQ=;
        b=O5aKTfAqgro5/ZhQSYpvKwuNNPvvifMqTfYqUtHrncvN4XRUjQgACnNycBVa4zRHm+
         QU15yZ8J4QTedzni5wxEKEk6UsHbjGLlYXZex5vPRWL9+QBvNqVRGO8YUD9d1tNAyFaL
         N2giVNHzRS1zAry7Ntk3f9hO2D0HEHDk+EWX7a18uW4NjJ9N9LMtRhl7xjwJ2h+UnM2z
         ZUq82wFYiQl2mNfyQBP4ysXUdNC4EGMTOkG/SBeHldxyu6bentBl9EPITV1USqKse88g
         gwe/UiHkZmZpvjasFoSV5+WThOX+kbqxvSt3AFoRXeQAb3YoDoi7lGPJcvN14lWJBcdQ
         JHPg==
X-Gm-Message-State: AOAM533FZVpb0Ilfix3FzZFdsQlaxoD7lHxIVCvgoeCIwWeJEmG4oKGM
        PJzKtuSzmbs6d3qu3B6HAMV0I+YQ4Mw=
X-Google-Smtp-Source: ABdhPJyv5hW8+u5bjJvcgyvqTxeKGD9QoJKYbI0kph000JMYzSuOTSA8qa6+Ymh0CBoGrX3ap3NKAySOPyc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a05:6902:124a:: with SMTP id
 t10mr10128666ybu.73.1634863776652; Thu, 21 Oct 2021 17:49:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 17:49:26 -0700
In-Reply-To: <20211022004927.1448382-1-seanjc@google.com>
Message-Id: <20211022004927.1448382-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211022004927.1448382-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 3/4] KVM: x86: Move apicv_active flag from vCPU to
 in-kernel local APIC
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move apicv_active from kvm_vcpu_arch to kvm_lapic as it's valid if and only
if the local APIC is emulated/virtualized by KVM.  This cleans up a handful
of ugly flows where KVM "blindly" dereferences vcpu->apic after checking
apicv_active.  This also resolves the discrepancy where existence of the
local APIC (in KVM) is checked by kvm_vcpu_apicv_active(), but rarely in
flows that open code access apicv_active.

Opportunistically convert kvm_vcpu_apicv_active() to use lapic_in_kernel()
to elide the conditional branch when all vCPUs have an in-kernel APIC.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/lapic.c            | 46 +++++++++++++--------------------
 arch/x86/kvm/lapic.h            |  5 ++--
 arch/x86/kvm/svm/avic.c         |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  4 +--
 arch/x86/kvm/x86.c              | 27 +++++++++----------
 6 files changed, 36 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d41699e89d1f..f64eef86391d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -629,7 +629,6 @@ struct kvm_vcpu_arch {
 	u64 efer;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
-	bool apicv_active;
 	bool load_eoi_exitmap_pending;
 	DECLARE_BITMAP(ioapic_handled_vectors, 256);
 	unsigned long apic_attention;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..1a2cf9c27d52 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -484,14 +484,10 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 
 static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 {
-	struct kvm_vcpu *vcpu;
-
-	vcpu = apic->vcpu;
-
-	if (unlikely(vcpu->arch.apicv_active)) {
+	if (unlikely(apic->apicv_active)) {
 		/* need to update RVI */
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
-		static_call(kvm_x86_hwapic_irr_update)(vcpu,
+		static_call(kvm_x86_hwapic_irr_update)(apic->vcpu,
 				apic_find_highest_irr(apic));
 	} else {
 		apic->irr_pending = false;
@@ -509,20 +505,16 @@ EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
 
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
-	struct kvm_vcpu *vcpu;
-
 	if (__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
 		return;
 
-	vcpu = apic->vcpu;
-
 	/*
 	 * With APIC virtualization enabled, all caching is disabled
 	 * because the processor can modify ISR under the hood.  Instead
 	 * just set SVI.
 	 */
-	if (unlikely(vcpu->arch.apicv_active))
-		static_call(kvm_x86_hwapic_isr_update)(vcpu, vec);
+	if (unlikely(apic->apicv_active))
+		static_call(kvm_x86_hwapic_isr_update)(apic->vcpu, vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -556,12 +548,9 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 
 static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 {
-	struct kvm_vcpu *vcpu;
 	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
 		return;
 
-	vcpu = apic->vcpu;
-
 	/*
 	 * We do get here for APIC virtualization enabled if the guest
 	 * uses the Hyper-V APIC enlightenment.  In this case we may need
@@ -569,8 +558,8 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * on the other hand isr_count and highest_isr_cache are unused
 	 * and must be left alone.
 	 */
-	if (unlikely(vcpu->arch.apicv_active))
-		static_call(kvm_x86_hwapic_isr_update)(vcpu,
+	if (unlikely(apic->apicv_active))
+		static_call(kvm_x86_hwapic_isr_update)(apic->vcpu,
 						apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
@@ -707,7 +696,7 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
 {
 	int highest_irr;
-	if (apic->vcpu->arch.apicv_active)
+	if (apic->apicv_active)
 		highest_irr = static_call(kvm_x86_sync_pir_to_irr)(apic->vcpu);
 	else
 		highest_irr = apic_find_highest_irr(apic);
@@ -1541,7 +1530,7 @@ static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
 		int vec = reg & APIC_VECTOR_MASK;
 		void *bitmap = apic->regs + APIC_ISR;
 
-		if (vcpu->arch.apicv_active)
+		if (apic->apicv_active)
 			bitmap = apic->regs + APIC_IRR;
 
 		if (apic_test_vector(vec, bitmap))
@@ -1658,7 +1647,7 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 
-	if (!from_timer_fn && vcpu->arch.apicv_active) {
+	if (!from_timer_fn && apic->apicv_active) {
 		WARN_ON(kvm_get_running_vcpu() != vcpu);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
@@ -2303,11 +2292,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		pr_warn_once("APIC base relocation is unsupported by KVM");
 }
 
-void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
+void kvm_apic_update_apicv(struct kvm_lapic *apic)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-
-	if (vcpu->arch.apicv_active) {
+	if (apic->apicv_active) {
 		/* irr_pending is always true when apicv is activated. */
 		apic->irr_pending = true;
 		apic->isr_count = 1;
@@ -2367,14 +2354,14 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
-	kvm_apic_update_apicv(vcpu);
+	kvm_apic_update_apicv(apic);
 	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
-	if (vcpu->arch.apicv_active) {
+	if (apic->apicv_active) {
 		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call(kvm_x86_hwapic_irr_update)(vcpu, -1);
 		static_call(kvm_x86_hwapic_isr_update)(vcpu, -1);
@@ -2484,6 +2471,9 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	static_branch_inc(&apic_sw_disabled.key); /* sw disabled at reset */
 	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
 
+	if (kvm_apicv_activated(vcpu->kvm))
+		apic->apicv_active = true;
+
 	return 0;
 nomem_free_apic:
 	kfree(apic);
@@ -2632,9 +2622,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	update_divide_count(apic);
 	__start_apic_timer(apic, APIC_TMCCT);
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
-	kvm_apic_update_apicv(vcpu);
+	kvm_apic_update_apicv(apic);
 	apic->highest_isr_cache = -1;
-	if (vcpu->arch.apicv_active) {
+	if (apic->apicv_active) {
 		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call(kvm_x86_hwapic_irr_update)(vcpu,
 				apic_find_highest_irr(apic));
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d7c25d0c1354..053815507921 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -49,6 +49,7 @@ struct kvm_lapic {
 	struct kvm_timer lapic_timer;
 	u32 divide_count;
 	struct kvm_vcpu *vcpu;
+	bool apicv_active;
 	bool sw_enabled;
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
@@ -98,7 +99,7 @@ void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map);
 int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
-void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
+void kvm_apic_update_apicv(struct kvm_lapic *apic);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
@@ -212,7 +213,7 @@ static inline int apic_x2apic_mode(struct kvm_lapic *apic)
 
 static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.apic && vcpu->arch.apicv_active;
+	return lapic_in_kernel(vcpu) && vcpu->arch.apic->apicv_active;
 }
 
 static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 8052d92069e0..e2da28fc5072 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -668,7 +668,7 @@ void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 
 int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 {
-	if (!vcpu->arch.apicv_active)
+	if (!kvm_vcpu_apicv_active(vcpu))
 		return -1;
 
 	kvm_lapic_set_irr(vec, vcpu->arch.apic);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2f677e72d864..014ce6ad8c9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4004,7 +4004,7 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (!r)
 		return 0;
 
-	if (!vcpu->arch.apicv_active)
+	if (!kvm_vcpu_apicv_active(vcpu))
 		return -1;
 
 	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
@@ -6316,7 +6316,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	int max_irr;
 	bool max_irr_updated;
 
-	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
+	if (KVM_BUG_ON(!kvm_vcpu_apicv_active(vcpu), vcpu->kvm))
 		return -EIO;
 
 	if (pi_test_on(&vmx->pi_desc)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b9c06a6b2a3..03103b69e8a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4361,7 +4361,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
-	if (vcpu->arch.apicv_active)
+	if (kvm_vcpu_apicv_active(vcpu))
 		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	return kvm_apic_get_state(vcpu, s);
@@ -8945,10 +8945,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	if (!kvm_x86_ops.update_cr8_intercept)
 		return;
 
-	if (!lapic_in_kernel(vcpu))
-		return;
-
-	if (vcpu->arch.apicv_active)
+	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
 	if (!vcpu->arch.apic->vapic_addr)
@@ -9399,6 +9396,7 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	bool activate;
 
 	if (!lapic_in_kernel(vcpu))
@@ -9407,11 +9405,11 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	mutex_lock(&vcpu->kvm->arch.apicv_update_lock);
 
 	activate = kvm_apicv_activated(vcpu->kvm);
-	if (vcpu->arch.apicv_active == activate)
+	if (apic->apicv_active == activate)
 		goto out;
 
-	vcpu->arch.apicv_active = activate;
-	kvm_apic_update_apicv(vcpu);
+	apic->apicv_active = activate;
+	kvm_apic_update_apicv(apic);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
 
 	/*
@@ -9420,7 +9418,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * still active when the interrupt got accepted. Make sure
 	 * inject_pending_event() is called to check for that.
 	 */
-	if (!vcpu->arch.apicv_active)
+	if (!activate)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 out:
@@ -9486,7 +9484,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	if (irqchip_split(vcpu->kvm))
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
 	else {
-		if (vcpu->arch.apicv_active)
+		if (kvm_vcpu_apicv_active(vcpu))
 			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 		if (ioapic_in_kernel(vcpu->kvm))
 			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
@@ -9758,7 +9756,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * This handles the case where a posted interrupt was
 	 * notified with kvm_vcpu_kick.
 	 */
-	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
+	if (kvm_lapic_enabled(vcpu) && kvm_vcpu_apicv_active(vcpu))
 		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	if (kvm_vcpu_exit_request(vcpu)) {
@@ -9808,7 +9806,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			break;
 		}
 
-		if (vcpu->arch.apicv_active)
+		if (kvm_vcpu_apicv_active(vcpu))
 			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
         }
 
@@ -10824,8 +10822,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
-		if (kvm_apicv_activated(vcpu->kvm))
-			vcpu->arch.apicv_active = true;
 	} else
 		static_branch_inc(&kvm_has_noapic_vcpu);
 
@@ -11821,7 +11817,8 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
+	if (kvm_vcpu_apicv_active(vcpu) &&
+	    static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
 		return true;
 
 	return false;
-- 
2.33.0.1079.g6e70778dc9-goog

