Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AA863C8A6
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbiK2Tls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbiK2Tkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:40:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A202702
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OPg8L3jKUTetjU9lk920ZBLtdtJuDxmt2DbZj0atMtY=;
        b=NdDxUY1O8jh7Jw8D6ez+LALlr7+FQdXaClo7l8kVnDQe552941IwjcwoCSrQ0MaMpJwP29
        ryCeSRr8I4kNrgqZuHxzacUk2kRwu8nWt7BnrgBGXCWGDFrFW8J5bbTja22twHFGhoksTk
        NBXIF0eMAPAEmJ9jaw3cbsFXNbtUqaE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-qVt9wRf9OFS2X7LYDsPYVA-1; Tue, 29 Nov 2022 14:37:52 -0500
X-MC-Unique: qVt9wRf9OFS2X7LYDsPYVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A34A2800B23;
        Tue, 29 Nov 2022 19:37:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC7942027061;
        Tue, 29 Nov 2022 19:37:47 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection interface
Date:   Tue, 29 Nov 2022 21:37:13 +0200
Message-Id: <20221129193717.513824-8-mlevitsk@redhat.com>
In-Reply-To: <20221129193717.513824-1-mlevitsk@redhat.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds two new vendor callbacks:

- kvm_x86_get_hw_nmi_pending()
- kvm_x86_set_hw_nmi_pending()

Using those callbacks the KVM can take advantage of the
hardware's accelerated delayed NMI delivery (currently vNMI on SVM).

Once NMI is set to pending via this interface, it is assumed that
the hardware will deliver the NMI on its own to the guest once
all the x86 conditions for the NMI delivery are met.

Note that the 'kvm_x86_set_hw_nmi_pending()' callback is allowed
to fail, in which case a normal NMI injection will be attempted
when NMI can be delivered (possibly by using a NMI window).

With vNMI that can happen either if vNMI is already pending or
if a nested guest is running.

When the vNMI injection fails due to the 'vNMI is already pending'
condition, the new NMI will be dropped unless the new NMI can be
injected immediately, so no NMI window will be requested.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    | 15 ++++++++++++-
 arch/x86/kvm/x86.c                 | 36 ++++++++++++++++++++++++++----
 3 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index abccd51dcfca1b..9e2db6cf7cc041 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -67,6 +67,8 @@ KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
 KVM_X86_OP(inject_irq)
 KVM_X86_OP(inject_nmi)
+KVM_X86_OP_OPTIONAL_RET0(get_hw_nmi_pending)
+KVM_X86_OP_OPTIONAL_RET0(set_hw_nmi_pending)
 KVM_X86_OP(inject_exception)
 KVM_X86_OP(cancel_injection)
 KVM_X86_OP(interrupt_allowed)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 684a5519812fb2..46993ce61c92db 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -871,8 +871,13 @@ struct kvm_vcpu_arch {
 	u64 tsc_scaling_ratio; /* current scaling ratio */
 
 	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
-	unsigned nmi_pending; /* NMI queued after currently running handler */
+
+	unsigned int nmi_pending; /*
+				   * NMI queued after currently running handler
+				   * (not including a hardware pending NMI (e.g vNMI))
+				   */
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
+
 	bool smi_pending;    /* SMI queued after currently running handler */
 	u8 handling_intr_from_guest;
 
@@ -1602,6 +1607,13 @@ struct kvm_x86_ops {
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
+
+	/* returns true, if a NMI is pending injection on hardware level (e.g vNMI) */
+	bool (*get_hw_nmi_pending)(struct kvm_vcpu *vcpu);
+
+	/* attempts make a NMI pending via hardware interface (e.g vNMI) */
+	bool (*set_hw_nmi_pending)(struct kvm_vcpu *vcpu);
+
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
@@ -1964,6 +1976,7 @@ int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
+int kvm_get_total_nmi_pending(struct kvm_vcpu *vcpu);
 
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 85d2a12c214dda..3c30e3f1106f79 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5103,7 +5103,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
-	events->nmi.pending = vcpu->arch.nmi_pending != 0;
+	events->nmi.pending = kvm_get_total_nmi_pending(vcpu) != 0;
 	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
 
 	/* events->sipi_vector is never valid when reporting to user space */
@@ -5191,9 +5191,12 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.nmi_injected = events->nmi.injected;
 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
-		vcpu->arch.nmi_pending = events->nmi.pending;
+		atomic_add(events->nmi.pending, &vcpu->arch.nmi_queued);
+
 	static_call(kvm_x86_set_nmi_mask)(vcpu, events->nmi.masked);
 
+	process_nmi(vcpu);
+
 	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
 	    lapic_in_kernel(vcpu))
 		vcpu->arch.apic->sipi_vector = events->sipi_vector;
@@ -10008,6 +10011,10 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 static void process_nmi(struct kvm_vcpu *vcpu)
 {
 	unsigned limit = 2;
+	int nmi_to_queue = atomic_xchg(&vcpu->arch.nmi_queued, 0);
+
+	if (!nmi_to_queue)
+		return;
 
 	/*
 	 * x86 is limited to one NMI running, and one NMI pending after it.
@@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	 * Otherwise, allow two (and we'll inject the first one immediately).
 	 */
 	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
-		limit = 1;
+		limit--;
+
+	/* Also if there is already a NMI hardware queued to be injected,
+	 * decrease the limit again
+	 */
+	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
+		limit--;
 
-	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
+	if (limit <= 0)
+		return;
+
+	/* Attempt to use hardware NMI queueing */
+	if (static_call(kvm_x86_set_hw_nmi_pending)(vcpu)) {
+		limit--;
+		nmi_to_queue--;
+	}
+
+	vcpu->arch.nmi_pending += nmi_to_queue;
 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
+/* Return total number of NMIs pending injection to the VM */
+int kvm_get_total_nmi_pending(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.nmi_pending + static_call(kvm_x86_get_hw_nmi_pending)(vcpu);
+}
+
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap)
 {
-- 
2.26.3

