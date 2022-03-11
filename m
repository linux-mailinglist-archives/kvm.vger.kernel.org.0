Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F214D59AA
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346364AbiCKEgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346344AbiCKEg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:36:27 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E30A1A617D
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:35:23 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e13-20020a17090301cd00b00150145346f9so3884347plh.23
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rElojjO9wtOKkUJFhLoQ3fdEIDVTPTX23a5LuSKdRPk=;
        b=p//7KiL6MwJom0iJgtiZjaY8HIbRESAhqvn1T+w/JgdZbzqloNsNQN8GtU9cNLT1fn
         ACle9TcWYMST1f69v70dUqKdfttpQgXAjTR8OSdK963+F1wpJ/bfDWuKoO5e3vNmJXjG
         Xzr5Eb0tHyLPy8bI9WkiSGDt8OOhA4c8MhUZ7nFYbFAtA/P2bblFxeJJaLLBFcWJUKbf
         gisCKhl73J6kqN9TaVCOMFjfMmH/CQXWTYEvDYLalQEUsOBRwkCG+/MfRRbNkeMWL84K
         voMtJ77ve1kvYFCiJ5DY11uvGAljdxBveF7r2NiYCU2ObxmePQM2A6Kz5A5qzUJtT/ha
         VipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rElojjO9wtOKkUJFhLoQ3fdEIDVTPTX23a5LuSKdRPk=;
        b=Q95v8QOBPsP1QRWy2iuxoW3Mrhob/aQ049DaTZi6f3f35pdfHLDkiadmlPhR26oybq
         56oFgxoE+7nUyLuoXtK5nTeGzpU9YZ+0WKBnrpG1lJV6gzTO9qkh82L7RliVNsJKE82z
         mOOiOj/64zBs2KiKp5BzbBrf1EOjvitZgjMNjeh6WIyKDBX670LoBRKlroWTROF7BS7m
         /uliELjCLDfoSEoMcBe2iRxef+gWVsoQK0+GkyVLzA5lbvCWIKS6IsrrW2nPYQLjmuSI
         H1aYvf30BEJ62FeRr4hGWDaaKHCKcyTon0UwphY+RUa1SQQpydkWKCm+kskmhgV9dkxC
         eCtw==
X-Gm-Message-State: AOAM53027QmRywnYA9bvS3cdkvDo24vJ5P5ekGZ8UVO6+a9iKGB4tn3E
        qvwkZjEUke0OIF9ryhfrKtYQQ+/ioWk=
X-Google-Smtp-Source: ABdhPJyw12AOmfiB/1wupY4ZG+BUfQQpWDGifYq99wnD5EsqZ8FcgXbfxG/4DzZZGhKilN4gSSIIw/kH+Jw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:124e:b0:4f7:6d35:c1d5 with SMTP id
 u14-20020a056a00124e00b004f76d35c1d5mr7528582pfi.83.1646973322917; Thu, 10
 Mar 2022 20:35:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 04:35:16 +0000
In-Reply-To: <20220311043517.17027-1-seanjc@google.com>
Message-Id: <20220311043517.17027-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220311043517.17027-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 2/3] KVM: x86: Add wrappers for setting/clearing APICv inhibits
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add set/clear wrappers for toggling APICv inhibits to make the call sites
more readable, and opportunistically rename the inner helpers to align
with the new wrappers and to make them more readable as well.  Invert the
flag from "activate" to "set"; activate is painfully ambiguous as it's
not obvious if the inhibit is being activated, or if APICv is being
activated, in which case the inhibit is being deactivated.

For the functions that take @set, swap the order of the inhibit reason
and @set so that the call sites are visually similar to those that bounce
through the wrapper.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 20 ++++++++++++++++----
 arch/x86/kvm/hyperv.c           | 10 +++++++---
 arch/x86/kvm/i8254.c            |  6 ++----
 arch/x86/kvm/svm/svm.c          | 11 +++++------
 arch/x86/kvm/trace.h            |  8 ++++----
 arch/x86/kvm/x86.c              | 30 +++++++++++++++---------------
 6 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16f46faa7f80..2b59a5e485ba 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1804,10 +1804,22 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 
 bool kvm_apicv_activated(struct kvm *kvm);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
-void kvm_request_apicv_update(struct kvm *kvm, bool activate,
-			      enum kvm_apicv_inhibit reason);
-void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
-				enum kvm_apicv_inhibit reason);
+void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
+				      enum kvm_apicv_inhibit reason, bool set);
+void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
+				    enum kvm_apicv_inhibit reason, bool set);
+
+static inline void kvm_set_apicv_inhibit(struct kvm *kvm,
+					 enum kvm_apicv_inhibit reason)
+{
+	kvm_set_or_clear_apicv_inhibit(kvm, reason, true);
+}
+
+static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
+					   enum kvm_apicv_inhibit reason)
+{
+	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
+}
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a32f54ab84a2..7480e3562d30 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -122,9 +122,13 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	else
 		hv->synic_auto_eoi_used--;
 
-	__kvm_request_apicv_update(vcpu->kvm,
-				   !hv->synic_auto_eoi_used,
-				   APICV_INHIBIT_REASON_HYPERV);
+	/*
+	 * Inhibit APICv if any vCPU is using SynIC's AutoEOI, which relies on
+	 * the hypervisor to manually inject IRQs.
+	 */
+	__kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
+					 APICV_INHIBIT_REASON_HYPERV,
+					 !!hv->synic_auto_eoi_used);
 
 	up_write(&vcpu->kvm->arch.apicv_update_lock);
 }
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 0b65a764ed3a..1c83076091af 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -305,15 +305,13 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
 	 * So, deactivate APICv when PIT is in reinject mode.
 	 */
 	if (reinject) {
-		kvm_request_apicv_update(kvm, false,
-					 APICV_INHIBIT_REASON_PIT_REINJ);
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PIT_REINJ);
 		/* The initial state is preserved while ps->reinject == 0. */
 		kvm_pit_reset_reinject(pit);
 		kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	} else {
-		kvm_request_apicv_update(kvm, true,
-					 APICV_INHIBIT_REASON_PIT_REINJ);
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PIT_REINJ);
 		kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b069493ad5c7..75feba3539e8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2923,7 +2923,7 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	 * In this case AVIC was temporarily disabled for
 	 * requesting the IRQ window and we have to re-enable it.
 	 */
-	kvm_request_apicv_update(vcpu->kvm, true, APICV_INHIBIT_REASON_IRQWIN);
+	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
 
 	++vcpu->stat.irq_window_exits;
 	return 1;
@@ -3521,7 +3521,7 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 		 * via AVIC. In such case, we need to temporarily disable AVIC,
 		 * and fallback to injecting IRQ via V_IRQ.
 		 */
-		kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_IRQWIN);
+		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
 		svm_set_vintr(svm);
 	}
 }
@@ -3948,6 +3948,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_cpuid_entry2 *best;
+	struct kvm *kvm = vcpu->kvm;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -3976,16 +3977,14 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		 * is exposed to the guest, disable AVIC.
 		 */
 		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
-			kvm_request_apicv_update(vcpu->kvm, false,
-						 APICV_INHIBIT_REASON_X2APIC);
+			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_X2APIC);
 
 		/*
 		 * Currently, AVIC does not work with nested virtualization.
 		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
 		 */
 		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-			kvm_request_apicv_update(vcpu->kvm, false,
-						 APICV_INHIBIT_REASON_NESTED);
+			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_NESTED);
 	}
 	init_vmcb_after_set_cpuid(vcpu);
 }
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index cf3e4838c86a..105037a251b5 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1340,17 +1340,17 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
 );
 
 TRACE_EVENT(kvm_apicv_update_request,
-	    TP_PROTO(bool activate, int reason),
-	    TP_ARGS(activate, reason),
+	    TP_PROTO(int reason, bool activate),
+	    TP_ARGS(reason, activate),
 
 	TP_STRUCT__entry(
-		__field(bool, activate)
 		__field(int, reason)
+		__field(bool, activate)
 	),
 
 	TP_fast_assign(
-		__entry->activate = activate;
 		__entry->reason = reason;
+		__entry->activate = activate;
 	),
 
 	TP_printk("%s reason=%u",
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f295db4580a7..965688aa6b45 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5930,7 +5930,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		smp_wmb();
 		kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
 		kvm->arch.nr_reserved_ioapic_pins = cap->args[0];
-		kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_ABSENT);
 		r = 0;
 split_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
@@ -6327,7 +6327,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
 		smp_wmb();
 		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
-		kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_ABSENT);
 	create_irqchip_unlock:
 		mutex_unlock(&kvm->lock);
 		break;
@@ -9735,8 +9735,8 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
 
-void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
-				enum kvm_apicv_inhibit reason)
+void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
+				      enum kvm_apicv_inhibit reason, bool set)
 {
 	unsigned long old, new;
 
@@ -9747,13 +9747,13 @@ void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
 
-	if (activate)
-		__clear_bit(reason, &new);
-	else
+	if (set)
 		__set_bit(reason, &new);
+	else
+		__clear_bit(reason, &new);
 
 	if (!!old != !!new) {
-		trace_kvm_apicv_update_request(activate, reason);
+		trace_kvm_apicv_update_request(reason, !set);
 		/*
 		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
 		 * false positives in the sanity check WARN in svm_vcpu_run().
@@ -9777,17 +9777,17 @@ void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
 	}
 }
 
-void kvm_request_apicv_update(struct kvm *kvm, bool activate,
-			      enum kvm_apicv_inhibit reason)
+void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
+				    enum kvm_apicv_inhibit reason, bool set)
 {
 	if (!enable_apicv)
 		return;
 
 	down_write(&kvm->arch.apicv_update_lock);
-	__kvm_request_apicv_update(kvm, activate, reason);
+	__kvm_set_or_clear_apicv_inhibit(kvm, reason, set);
 	up_write(&kvm->arch.apicv_update_lock);
 }
-EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
+EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
 
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
@@ -10938,7 +10938,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
 {
-	bool inhibit = false;
+	bool set = false;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
@@ -10946,11 +10946,11 @@ static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
-			inhibit = true;
+			set = true;
 			break;
 		}
 	}
-	__kvm_request_apicv_update(kvm, !inhibit, APICV_INHIBIT_REASON_BLOCKIRQ);
+	__kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_BLOCKIRQ, set);
 	up_write(&kvm->arch.apicv_update_lock);
 }
 
-- 
2.35.1.723.g4982287a31-goog

