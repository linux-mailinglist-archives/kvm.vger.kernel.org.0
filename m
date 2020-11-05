Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA4B2A8497
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 18:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731722AbgKERPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 12:15:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731203AbgKERPb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 12:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604596529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XlrP5n7QxEFVD/JR9/hAdOLwk4W0dChMzmUp+37EWd8=;
        b=XY6ig+zGHdv57GMO62N3dmYuKO2EZ+Vfb0PQMKMNIryMlbA8mXo4gCiIewKjudMueQLe0P
        gzY6FdUwXBo0oH6NqnrRPnRGEppM38Fa/BW8Qts1c/r17o67QkkSdKP5h2sW1P5US6Cclu
        kVqpVKJHq+OcXT92sud4azpyXS0QETY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-GhFDIG70Ojqr3Dcriv9n6w-1; Thu, 05 Nov 2020 12:15:26 -0500
X-MC-Unique: GhFDIG70Ojqr3Dcriv9n6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4A821891E84;
        Thu,  5 Nov 2020 17:15:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 757296CE4F;
        Thu,  5 Nov 2020 17:15:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     yadong.qi@intel.com
Subject: [PATCH 1/2] KVM: x86: fix apic_accept_events vs check_nested_events
Date:   Thu,  5 Nov 2020 12:15:23 -0500
Message-Id: <20201105171524.650693-2-pbonzini@redhat.com>
In-Reply-To: <20201105171524.650693-1-pbonzini@redhat.com>
References: <20201105171524.650693-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_apic_init_signal_blocked is buggy in that it returns true
even in VMX non-root mode.  In non-root mode, however, INITs
are not latched, they just cause a vmexit.  Previously,
KVM was waiting for them to be processed when kvm_apic_accept_events
and in the meanwhile it ate the SIPIs that the processor received.

However, in order to implement the wait-for-SIPI activity state,
KVM will have to process KVM_APIC_SIPI in vmx_check_nested_events,
and it will not be possible anymore to disregard SIPIs in non-root
mode as the code is currently doing.

By calling kvm_x86_ops.nested_ops->check_events, we can force a vmexit
(with the side-effect of latching INITs) before incorrectly injecting
an INIT or SIPI in a guest, and therefore vmx_apic_init_signal_blocked
can do the right thing.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c   | 30 ++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c |  2 +-
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 105e7859d1f2..e3ee597ff540 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2843,14 +2843,35 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u8 sipi_vector;
+	int r;
 	unsigned long pe;
 
-	if (!lapic_in_kernel(vcpu) || !apic->pending_events)
+	if (!lapic_in_kernel(vcpu))
+		return;
+
+	/*
+	 * Read pending events before calling the check_events
+	 * callback.
+	 */
+	pe = smp_load_acquire(&apic->pending_events);
+	if (!pe)
 		return;
 
+	if (is_guest_mode(vcpu)) {
+		r = kvm_x86_ops.nested_ops->check_events(vcpu);
+		if (r < 0)
+			return;
+		/*
+		 * If an event has happened and caused a vmexit,
+		 * we know INITs are latched and therefore
+		 * we will not incorrectly deliver an APIC
+		 * event instead of a vmexit.
+		 */
+	}
+
 	/*
 	 * INITs are latched while CPU is in specific states
-	 * (SMM, VMX non-root mode, SVM with GIF=0).
+	 * (SMM, VMX root mode, SVM with GIF=0).
 	 * Because a CPU cannot be in these states immediately
 	 * after it has processed an INIT signal (and thus in
 	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
@@ -2858,13 +2879,13 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_vcpu_latch_init(vcpu)) {
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
-		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
+		if (test_bit(KVM_APIC_SIPI, &pe))
 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
 		return;
 	}
 
-	pe = xchg(&apic->pending_events, 0);
 	if (test_bit(KVM_APIC_INIT, &pe)) {
+		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		kvm_vcpu_reset(vcpu, true);
 		if (kvm_vcpu_is_bsp(apic->vcpu))
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
@@ -2873,6 +2894,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	}
 	if (test_bit(KVM_APIC_SIPI, &pe) &&
 	    vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
+		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
 		/* evaluate pending_events before reading the vector */
 		smp_rmb();
 		sipi_vector = apic->sipi_vector;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..64339121a4f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7558,7 +7558,7 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)
 
 static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
-	return to_vmx(vcpu)->nested.vmxon;
+	return to_vmx(vcpu)->nested.vmxon && !is_guest_mode(vcpu);
 }
 
 static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
-- 
2.26.2


