Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8DF54BE21
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357981AbiFNXGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358053AbiFNXF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:05:59 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FAE53708
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:05:58 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d129-20020a621d87000000b005228d4cbcc4so2558394pfd.12
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KWr09iwAJ/KttgqIlP4t5XmU0ORDiZrVc0OMsoock5w=;
        b=DHObAgnnQHwa+00TuGwYe7H4vaPoWsux/hV/LYPQtLGYVUQ1+RhtX8gV9ntqANAuq9
         G4FNduqGphohOqWcpzK8skDDkHEh0eV1NoVEgTg5NfChJpwmj/r9Bg0h64nUvmwho70J
         xWL8yHesixCPMH9hG1Gl0ODmE/4rKOuFXH5rRCsfCdJRBEbTxz4LG+vE4FMm1okVmuFg
         6UmyoOn+6ot8qPh1HkPqkUxeptz4rlSg89UHhxJRZ6KlwaHjS3v0cb1+2MZyutM7oxMx
         ttpc1Sc9ejsbJCK3teeJxCXsHzBcOp86wQaxBsPsMZDvehZKyX5L2z/kAUs7e2L7JPpV
         TL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KWr09iwAJ/KttgqIlP4t5XmU0ORDiZrVc0OMsoock5w=;
        b=NTYe6CK0Vk1KQfkeiYGXlBn0NLfrwvXzdBTAOKXT0UiLO01ZOPrGmf2vtNsWTQX/HG
         zKW3fZuspkr/5C12qG15r+vIyZy4BsllVjb7AF+CbuaBWz+SrXqlxeNALexS9CXShQ+N
         LHiTAvcAGGtZ5y0+pD9jjKH0tOXZ8zl6dJRFPnqXIW/u5STxRoRSzid1pArS7dR747x+
         3cuCKcyNy6VoJJClPikmtCNt4vQtfSSWz941gaQEmGYB/OJMmr8vkkyMRGVuBHNvhMPr
         Yf+2htNHZ4Ae7CHxqAh8VIA47gIhpJmYfhg1hZnVL0IIsaQXJD+3swuIzD2SayQaPrLr
         xIwg==
X-Gm-Message-State: AOAM531tELYfb4A/RmguYUErFY2YD0o+Vv1tQ5JcHBU+KU8OgkQ9BSDR
        qIQuOMH8YgYbjh1ykUUMV4bBo57/SGc=
X-Google-Smtp-Source: ABdhPJy1xXw/IzHpxrHsb7SF+iyYh7z6yjUME6vryiFL9y5RInArNreeD7KczVr92OuPX+k8YMIa4Ii5icA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec83:b0:168:e5ad:8071 with SMTP id
 x3-20020a170902ec8300b00168e5ad8071mr6446332plg.102.1655247957748; Tue, 14
 Jun 2022 16:05:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:05:47 +0000
In-Reply-To: <20220614230548.3852141-1-seanjc@google.com>
Message-Id: <20220614230548.3852141-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220614230548.3852141-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 4/5] KVM: x86: Move "apicv_active" into "struct kvm_lapic"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the per-vCPU apicv_active flag into KVM's local APIC instance.
APICv is fully dependent on an in-kernel local APIC, but that's not at
all clear when reading the current code due to the flag being stored in
the generic kvm_vcpu_arch struct.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/lapic.c            | 30 ++++++++++--------------------
 arch/x86/kvm/lapic.h            |  3 ++-
 arch/x86/kvm/svm/svm.c          |  5 +++--
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              | 11 ++++++-----
 6 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16acc54d49a7..1038ccb7056a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -663,7 +663,6 @@ struct kvm_vcpu_arch {
 	u64 efer;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
-	bool apicv_active;
 	bool load_eoi_exitmap_pending;
 	DECLARE_BITMAP(ioapic_handled_vectors, 256);
 	unsigned long apic_attention;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cc0da5671eb9..43c42a580295 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -519,14 +519,11 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 
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
-		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
+		static_call_cond(kvm_x86_hwapic_irr_update)(apic->vcpu,
+							    apic_find_highest_irr(apic));
 	} else {
 		apic->irr_pending = false;
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
@@ -543,19 +540,15 @@ EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
 
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
+	if (unlikely(apic->apicv_active))
 		static_call_cond(kvm_x86_hwapic_isr_update)(vec);
 	else {
 		++apic->isr_count;
@@ -590,12 +583,9 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 
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
@@ -603,7 +593,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * on the other hand isr_count and highest_isr_cache are unused
 	 * and must be left alone.
 	 */
-	if (unlikely(vcpu->arch.apicv_active))
+	if (unlikely(apic->apicv_active))
 		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
@@ -1584,7 +1574,7 @@ static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
 		int vec = reg & APIC_VECTOR_MASK;
 		void *bitmap = apic->regs + APIC_ISR;
 
-		if (vcpu->arch.apicv_active)
+		if (apic->apicv_active)
 			bitmap = apic->regs + APIC_IRR;
 
 		if (apic_test_vector(vec, bitmap))
@@ -1701,7 +1691,7 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
 		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 
-	if (!from_timer_fn && vcpu->arch.apicv_active) {
+	if (!from_timer_fn && apic->apicv_active) {
 		WARN_ON(kvm_get_running_vcpu() != vcpu);
 		kvm_apic_inject_pending_timer_irqs(apic);
 		return;
@@ -2379,7 +2369,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (vcpu->arch.apicv_active) {
+	if (apic->apicv_active) {
 		/* irr_pending is always true when apicv is activated. */
 		apic->irr_pending = true;
 		apic->isr_count = 1;
@@ -2454,7 +2444,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
-	if (vcpu->arch.apicv_active) {
+	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, -1);
 		static_call_cond(kvm_x86_hwapic_isr_update)(-1);
@@ -2734,7 +2724,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache = -1;
-	if (vcpu->arch.apicv_active) {
+	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
 		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 65bb2a8cf145..e09ad97f3250 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -48,6 +48,7 @@ struct kvm_lapic {
 	struct kvm_timer lapic_timer;
 	u32 divide_count;
 	struct kvm_vcpu *vcpu;
+	bool apicv_active;
 	bool sw_enabled;
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
@@ -204,7 +205,7 @@ static inline int apic_x2apic_mode(struct kvm_lapic *apic)
 
 static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.apic && vcpu->arch.apicv_active;
+	return vcpu->arch.apic && vcpu->arch.apic->apicv_active;
 }
 
 static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c6cca0ce127b..255f5c6f3aab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3465,12 +3465,13 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vector)
 {
 	/*
-	 * vcpu->arch.apicv_active must be read after vcpu->mode.
+	 * apic->apicv_active must be read after vcpu->mode.
 	 * Pairs with smp_store_release in vcpu_enter_guest.
 	 */
 	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
 
-	if (!READ_ONCE(vcpu->arch.apicv_active)) {
+	/* Note, this is called iff the local APIC is in-kernel. */
+	if (!READ_ONCE(vcpu->arch.apic->apicv_active)) {
 		/* Process the interrupt via inject_pending_event */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_vcpu_kick(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42f8924a90f4..0e24f2cc3177 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4089,7 +4089,8 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (!r)
 		return 0;
 
-	if (!vcpu->arch.apicv_active)
+	/* Note, this is called iff the local APIC is in-kernel. */
+	if (!vcpu->arch.apic->apicv_active)
 		return -1;
 
 	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd554a62eb0f..9cea051ca62e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9440,7 +9440,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	if (!lapic_in_kernel(vcpu))
 		return;
 
-	if (vcpu->arch.apicv_active)
+	if (vcpu->arch.apic->apicv_active)
 		return;
 
 	if (!vcpu->arch.apic->vapic_addr)
@@ -9893,6 +9893,7 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	bool activate;
 
 	if (!lapic_in_kernel(vcpu))
@@ -9903,10 +9904,10 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 
 	activate = kvm_vcpu_apicv_activated(vcpu);
 
-	if (vcpu->arch.apicv_active == activate)
+	if (apic->apicv_active == activate)
 		goto out;
 
-	vcpu->arch.apicv_active = activate;
+	apic->apicv_active = activate;
 	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
 
@@ -9916,7 +9917,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * still active when the interrupt got accepted. Make sure
 	 * inject_pending_event() is called to check for that.
 	 */
-	if (!vcpu->arch.apicv_active)
+	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 out:
@@ -11359,7 +11360,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		 * will ensure the vCPU gets the correct state before VM-Entry.
 		 */
 		if (enable_apicv) {
-			vcpu->arch.apicv_active = true;
+			vcpu->arch.apic->apicv_active = true;
 			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 		}
 	} else
-- 
2.36.1.476.g0c4daa206d-goog

