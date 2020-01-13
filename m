Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D43139C33
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 23:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgAMWLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 17:11:00 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:44194 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbgAMWK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 17:10:59 -0500
Received: by mail-pj1-f74.google.com with SMTP id c31so7550322pje.9
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 14:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m/qOsq+wdtuQutrd4owz9XAVpuoAS5ct18Ghp0jkcFg=;
        b=cIhcoFTduW7s3DvTZHusTuz8xxLfFLk/Olb5FJxQOUrbd3nb2CYZrB/IhHQFlPSqKW
         FE06w0x6T4R/9stBfD09QDSgAIIJA7el+2Q0mhrjdZO9//IQi//Ye8TiDKXeCc4tfvNP
         gdUtv0LHa0itmn9QZjr5MogldoqqyaOEhMAHJ25hIBpK1/T5mT95zKfMVDQiPanjzbDV
         ee7XSByDxZsgoh/67ZCkC3Xr68Y5sNVJHK//uDhs57/y5yRAEzgwiw8k12YrCO+yAgns
         Fc/AaddyQbYl2vVcJwpGuoKHzD6GoB2P1qJs6pDdmWp+P26ozUF+uO17Ha8yZCO0rvGy
         Csiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m/qOsq+wdtuQutrd4owz9XAVpuoAS5ct18Ghp0jkcFg=;
        b=txV2x8DKZxNFrMsDmYj51PDlDMh9Z6cxyZZsWUH+nuYR3CYYyuBRyVsfajwS6bLRal
         ACr0LVclVgtIDr8OOGgw3OoJKfL/Kg960giJMpLJQXX7DluFo9Pl3lBNgJklCrJgTE2f
         x8GiqHXwGqNp8xEnzKa//NXe+66FV8dt8phLQc0xuNC6BX/WCSBrrYBvXpwrnBfqGB+R
         YFI74I+fWaRLRHNeKT83L21yPO/pMQasDJVxEkgc0/vM64m9k9hgr53LrWuQGgqBZKGj
         qPZqXFX4/oMxV0BJNcZ5FW7X/qcP51FFhI/gYftmHlpQJEXAEXDtiI+BeoO326cYkFlR
         3OnA==
X-Gm-Message-State: APjAAAWdd2gj7z82HhLZBgJe/B+HWfnB38XsCGVdUife+QWdDi81kk4D
        ptRcAh9lU+stBV7g/YZhQVqkFDcjexHQj9UZXoqFbafyfTGBP2HjlhpRijg3cmNX1QBcgWDcyot
        itPt8jHLbTkFafiBKmzXni0zWfWtGR1dVzhHyqmw+dj9Zu9cKs4HpfEZnuw==
X-Google-Smtp-Source: APXvYqyJITlnAOKB0VRr6bEvGfITZUgjTa7u1NdRTLHuDGLsl3FrgSiC04j3UHkZcmm1Q8ZVS/TnsSgPF8k=
X-Received: by 2002:a63:de4a:: with SMTP id y10mr23244878pgi.367.1578953458112;
 Mon, 13 Jan 2020 14:10:58 -0800 (PST)
Date:   Mon, 13 Jan 2020 14:10:51 -0800
In-Reply-To: <20200113221053.22053-1-oupton@google.com>
Message-Id: <20200113221053.22053-2-oupton@google.com>
Mime-Version: 1.0
References: <20200113221053.22053-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH 1/3] KVM: x86: Add vendor-specific #DB payload delivery
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

VMX and SVM differ slightly in the handling of #DB debug-trap exceptions
upon VM-entry. VMX defines the 'pending debug exceptions' field in the
VMCS for hardware to inject the event and update debug register state
upon VM-entry.

SVM provides no such mechanism for maintaining the state of a pending
debug exception, as the debug register state is updated before delivery
of #VMEXIT.

Lastly, while KVM defines the exception payload for debug-trap
exceptions as compatible with the 'pending debug exceptions' VMCS field,
it is not compatible with the DR6 register across both vendors.

Split the #DB payload delivery between SVM and VMX to capture the
nuanced differences in instruction emulation. Utilize the 'pending debug
exceptions' field on VMX to deliver the payload. On SVM, directly update
register state with the appropriate requested bits from the exception
payload.

Fixes: f10c729ff965 ("kvm: vmx: Defer setting of DR6 until #DB delivery")

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 20 +++++++++++++++++++-
 arch/x86/kvm/x86.c              | 21 +--------------------
 4 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6aa4075..4739ca11885d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1100,6 +1100,7 @@ struct kvm_x86_ops {
 	void (*set_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
+	void (*deliver_db_payload)(struct kvm_vcpu *vcpu,
+				   unsigned long payload);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu);
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..16ded16af997 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5615,6 +5615,25 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
+static void svm_deliver_db_payload(struct kvm_vcpu *vcpu, unsigned long payload)
+{
+	/*
+	 * The exception payload is defined as compatible with the 'pending
+	 * debug exceptions' field in VMX, not the DR6 register. Clear bit 12
+	 * (enabled breakpoint) in the payload, which is reserved MBZ in DR6.
+	 */
+	payload &= ~BIT(12);
+
+	/*
+	 * The processor updates bits 3:0 according to the matched breakpoint
+	 * conditions on every debug breakpoint or general-detect condition.
+	 * Hardware will not clear any other bits in DR6. Clear bits 3:0 and set
+	 * the bits requested in the exception payload.
+	 */
+	vcpu->arch.dr6 &= ~DR_TRAP_BITS;
+	vcpu->arch.dr6 |= payload;
+}
+
 static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -7308,6 +7327,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.set_nmi = svm_inject_nmi,
 	.queue_exception = svm_queue_exception,
 	.cancel_injection = svm_cancel_injection,
+	.deliver_db_payload = svm_deliver_db_payload,
 	.interrupt_allowed = svm_interrupt_allowed,
 	.nmi_allowed = svm_nmi_allowed,
 	.get_nmi_mask = svm_get_nmi_mask,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..148696199c88 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1613,6 +1613,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned nr = vcpu->arch.exception.nr;
 	bool has_error_code = vcpu->arch.exception.has_error_code;
+	bool has_payload = vcpu->arch.exception.has_payload;
 	u32 error_code = vcpu->arch.exception.error_code;
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
@@ -1640,7 +1641,13 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	} else
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
 
-	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
+	/*
+	 * Debug-trap exceptions are injected into the guest via the 'pending
+	 * debug exceptions' vmcs field and thus should not be injected into the
+	 * guest using the general event injection mechanism.
+	 */
+	if (nr != DB_VECTOR || !has_payload)
+		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
 	vmx_clear_hlt(vcpu);
 }
@@ -6398,6 +6405,16 @@ static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
 }
 
+static void vmx_deliver_db_payload(struct kvm_vcpu *vcpu, unsigned long payload)
+{
+	/*
+	 * Synthesized debug exceptions that have an associated payload must be
+	 * traps, and thus the 'pending debug exceptions' field can be used to
+	 * allow hardware to inject the event upon VM-entry.
+	 */
+	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, payload);
+}
+
 static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 {
 	int i, nr_msrs;
@@ -7821,6 +7838,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_nmi = vmx_inject_nmi,
 	.queue_exception = vmx_queue_exception,
 	.cancel_injection = vmx_cancel_injection,
+	.deliver_db_payload = vmx_deliver_db_payload,
 	.interrupt_allowed = vmx_interrupt_allowed,
 	.nmi_allowed = vmx_nmi_allowed,
 	.get_nmi_mask = vmx_get_nmi_mask,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf917139de6b..c14174c033e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -415,26 +415,7 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
 
 	switch (nr) {
 	case DB_VECTOR:
-		/*
-		 * "Certain debug exceptions may clear bit 0-3.  The
-		 * remaining contents of the DR6 register are never
-		 * cleared by the processor".
-		 */
-		vcpu->arch.dr6 &= ~DR_TRAP_BITS;
-		/*
-		 * DR6.RTM is set by all #DB exceptions that don't clear it.
-		 */
-		vcpu->arch.dr6 |= DR6_RTM;
-		vcpu->arch.dr6 |= payload;
-		/*
-		 * Bit 16 should be set in the payload whenever the #DB
-		 * exception should clear DR6.RTM. This makes the payload
-		 * compatible with the pending debug exceptions under VMX.
-		 * Though not currently documented in the SDM, this also
-		 * makes the payload compatible with the exit qualification
-		 * for #DB exceptions under VMX.
-		 */
-		vcpu->arch.dr6 ^= payload & DR6_RTM;
+		kvm_x86_ops->deliver_db_payload(vcpu, payload);
 		break;
 	case PF_VECTOR:
 		vcpu->arch.cr2 = payload;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

