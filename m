Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6250640D8C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiLBSju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiLBSjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:39:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52D8216
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670006252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RuMG0d33sEC7aE30jwx3bdY7txbQTuJrOEcspw8hQrc=;
        b=D06NSRPZihPXbCci3diY1xylfdmIB9GrIkhvTdNofmXVKeVCgea9eI655B+wpGH3tXSfr3
        yMPCrl6bHMSCCReykN6P5u2M6r+gNeNlTW7RMDBpQ99f9LFRerZei/7tplNGtyv8EcYCOf
        KABQNaEGE3zfUt4R4w27LrT6WMpnxzE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-c-bv2q4XNBuoVs_WvpVduA-1; Fri, 02 Dec 2022 13:37:28 -0500
X-MC-Unique: c-bv2q4XNBuoVs_WvpVduA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D85985A59D;
        Fri,  2 Dec 2022 18:37:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59E6040C845E;
        Fri,  2 Dec 2022 18:37:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Subject: [PATCH] KVM: x86: remove unnecessary exports
Date:   Fri,  2 Dec 2022 13:37:27 -0500
Message-Id: <20221202183727.1033906-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several symbols are not used by vendor modules but still exported.
Removing them ensures that new coupling between kvm.ko and kvm-*.ko
is noticed and reviewed.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/hyperv.c | 1 -
 arch/x86/kvm/irq.c    | 2 --
 arch/x86/kvm/lapic.c  | 3 ---
 arch/x86/kvm/x86.c    | 8 --------
 4 files changed, 14 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2c7f2a26421e..cc3e8c7d0850 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -898,7 +898,6 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 		return false;
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
-EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
 
 int kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index d8d50558f165..a70952eca905 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -31,7 +31,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 	return r;
 }
-EXPORT_SYMBOL(kvm_cpu_has_pending_timer);
 
 /*
  * check if there is a pending userspace external interrupt
@@ -150,7 +149,6 @@ void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 	if (kvm_xen_timer_enabled(vcpu))
 		kvm_xen_inject_timer_irqs(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_pending_timer_irqs);
 
 void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8224ac8b617a..4efdb4a4d72c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -160,7 +160,6 @@ bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
 		    kvm_can_post_timer_interrupt(vcpu));
 }
-EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
 
 static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
 {
@@ -1914,7 +1913,6 @@ bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
 
 	return vcpu->arch.apic->lapic_timer.hv_timer_in_use;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_hv_timer_in_use);
 
 static void cancel_hv_timer(struct kvm_lapic *apic)
 {
@@ -2432,7 +2430,6 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 152ea4993b76..4825773886f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -463,7 +463,6 @@ u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.apic_base;
 }
-EXPORT_SYMBOL_GPL(kvm_get_apic_base);
 
 enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
 {
@@ -491,7 +490,6 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
@@ -782,7 +780,6 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 		kvm_queue_exception_e_p(vcpu, PF_VECTOR, fault->error_code,
 					fault->address);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
 void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
@@ -811,7 +808,6 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 	atomic_inc(&vcpu->arch.nmi_queued);
 	kvm_make_request(KVM_REQ_NMI, vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_nmi);
 
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
@@ -836,7 +832,6 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 	kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 	return false;
 }
-EXPORT_SYMBOL_GPL(kvm_require_cpl);
 
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr)
 {
@@ -2069,7 +2064,6 @@ int kvm_emulate_as_nop(struct kvm_vcpu *vcpu)
 {
 	return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_as_nop);
 
 int kvm_emulate_invd(struct kvm_vcpu *vcpu)
 {
@@ -2515,7 +2509,6 @@ u64 kvm_scale_tsc(u64 tsc, u64 ratio)
 
 	return _tsc;
 }
-EXPORT_SYMBOL_GPL(kvm_scale_tsc);
 
 static u64 kvm_compute_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
@@ -12068,7 +12061,6 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
 
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
-- 
2.31.1

