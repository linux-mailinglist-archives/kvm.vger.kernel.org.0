Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6926149F019
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345267AbiA1AyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345064AbiA1Axy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:54 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29A8C0613E7
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:44 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id t69-20020a627848000000b004cb24c27d5aso2444025pfc.21
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=f3SP0dzXn4etNS8w8aGEW9D9Vtvc6iCjJjpem18829Y=;
        b=klQJTYmt+ACxt+Sl2MT+axJ9vVy3J3w50AAaF3tmE4qPW/7zSHvsyGdSy8gk14LRv/
         cMxpK6A3hexImycHsUHqiDhITmP3nsoo3/8pAqPJvaAB1QeyPZbwRSUhJ7r0DzdGPOCZ
         0CvLUnVrMN1qsmsui3HAyWjRigt/B2UH9q2KDW47vEUT5/Wpn/8DmWkfyvNVOGCxeTQf
         LV5f661Jshr3/QSFpbEHoyYrG80HU7ef5TLJxwYrlbgrCKwtvtIQYjP4gc8WegFUC53x
         XTVbztjeEMUhiQ64WvCH8bf8TRDAUKxZBsVmZ/DXo2fo0gz3naxX+7qprHDIGeSQYcH8
         g67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=f3SP0dzXn4etNS8w8aGEW9D9Vtvc6iCjJjpem18829Y=;
        b=72tnw9lq6ViGco04WvKDfu6oredvzIbWDJYtHy9NgSlBzJiVIHsvsQRiIKrc0R7P5J
         bpgxLjKmiJkGNStkRrZ9qZV/8WiMzB/GXFxCOS+DHU79SX+FyInAhu4eUfI0GpKbF7ju
         jpBil1qmFjg+WUi2mAVU5dVZTI586EvQqhphTvojUXGVZ8wp3F6ma3jp4/hMvsrPNmPe
         P/zMJZRrJ3PI2BjChkRB8HQdMW37PEqMd7I6A/ZjOTORawoOWBv4YsvG2NeTJaqUO8iY
         J6AIX/IX8qw7BTK2/GScM0W7XTeJHS32cB82gjcSknhJcEHgOEQdxB3SnjHna+Q0/5/1
         Jc8g==
X-Gm-Message-State: AOAM532Mmat7cSMbvCqlWTHuuHq1vWoi59ZlzZ8+Sl+0FY0nY4PdXoNW
        S8dtYvYke45cN86AFCcH6Am/hxg12Ck=
X-Google-Smtp-Source: ABdhPJwWkWroXpTYgyRjxVwOtoYqCKnXhSbA5OZTbO1lYtm7RELm4x2fgTjAjq6WFJP0XbRaM3EVumBm7RE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr1878319pjb.0.1643331223696; Thu, 27 Jan 2022 16:53:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:04 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 18/22] KVM: SVM: Rename AVIC helpers to use "avic" prefix
 instead of "svm"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use "avic" instead of "svm" for SVM's all of APICv hooks and make a few
additional funciton name tweaks so that the AVIC functions conform to
their associated kvm_x86_ops hooks.  This will allow using kvm-x86-ops.h
with a custom KVM_X86_APICV_OP() macro to fill all AVIC hooks in one fell
swoop.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 28 ++++++++++++++--------------
 arch/x86/kvm/svm/svm.c  | 18 +++++++++---------
 arch/x86/kvm/svm/svm.h  | 20 ++++++++++----------
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 90364d02f22a..99f907ec5aa8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -579,7 +579,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	return ret;
 }
 
-void avic_post_state_restore(struct kvm_vcpu *vcpu)
+void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
 	if (avic_handle_apic_id_update(vcpu) != 0)
 		return;
@@ -587,20 +587,20 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
 	return;
 }
 
-void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
+void avic_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 {
 }
 
-void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+void avic_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 }
 
-static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
+static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -632,7 +632,7 @@ static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 	return ret;
 }
 
-void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -649,7 +649,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		 * we need to check and update the AVIC logical APIC ID table
 		 * accordingly before re-activating.
 		 */
-		avic_post_state_restore(vcpu);
+		avic_apicv_post_state_restore(vcpu);
 		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 	} else {
 		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
@@ -661,10 +661,10 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	else
 		avic_vcpu_put(vcpu);
 
-	svm_set_pi_irte_mode(vcpu, activated);
+	avic_set_pi_irte_mode(vcpu, activated);
 }
 
-void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
+void avic_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 {
 	return;
 }
@@ -715,7 +715,7 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	return 0;
 }
 
-bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
+bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
@@ -817,7 +817,7 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 }
 
 /*
- * svm_update_pi_irte - set IRTE for Posted-Interrupts
+ * avic_pi_update_irte - set IRTE for Posted-Interrupts
  *
  * @kvm: kvm
  * @host_irq: host irq of the interrupt
@@ -825,8 +825,8 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
  * @set: set or unset PI
  * returns 0 on success, < 0 on failure
  */
-int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
-		       uint32_t guest_irq, bool set)
+int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
+			uint32_t guest_irq, bool set)
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
@@ -926,7 +926,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 	return ret;
 }
 
-bool svm_check_apicv_inhibit_reasons(ulong bit)
+bool avic_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 87e136b81991..a6ddc8b7c63b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4536,13 +4536,13 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
-	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
-	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
-	.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
-	.load_eoi_exitmap = svm_load_eoi_exitmap,
-	.hwapic_irr_update = svm_hwapic_irr_update,
-	.hwapic_isr_update = svm_hwapic_isr_update,
-	.apicv_post_state_restore = avic_post_state_restore,
+	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
+	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
+	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
+	.load_eoi_exitmap = avic_load_eoi_exitmap,
+	.hwapic_irr_update = avic_hwapic_irr_update,
+	.hwapic_isr_update = avic_hwapic_isr_update,
+	.apicv_post_state_restore = avic_apicv_post_state_restore,
 
 	.set_tss_addr = svm_set_tss_addr,
 	.set_identity_map_addr = svm_set_identity_map_addr,
@@ -4572,8 +4572,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_interrupt = svm_deliver_interrupt,
-	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
-	.pi_update_irte = svm_update_pi_irte,
+	.dy_apicv_has_pending_interrupt = avic_dy_apicv_has_pending_interrupt,
+	.pi_update_irte = avic_pi_update_irte,
 	.setup_mce = svm_setup_mce,
 
 	.smi_allowed = svm_smi_allowed,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 16ad5fa128f4..096abbf01969 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -575,17 +575,17 @@ int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
 int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
-void avic_post_state_restore(struct kvm_vcpu *vcpu);
-void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
-void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
-bool svm_check_apicv_inhibit_reasons(ulong bit);
-void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
-void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
-void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
+void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
+void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
+bool avic_check_apicv_inhibit_reasons(ulong bit);
+void avic_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
+void avic_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
+void avic_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
 int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
-bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
-int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
-		       uint32_t guest_irq, bool set);
+bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
+int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
+			uint32_t guest_irq, bool set);
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

