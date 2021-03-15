Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7290633C925
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhCOWLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:11:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232605AbhCOWKz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 18:10:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615846255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AoArXX9WPpL4SnAa/Ge0fyAJqtNqRN2jjUvZKB7Oaa0=;
        b=XFz/zrA2py5zpBvuH8+EO6Ww9km+/fuwui0p7eLeLG7E6ZNRL9G4Wr8WvJN3aAq3kK59eS
        OIXC3VJQbdczxAnZ/TpvK6OOvJaPv/Fv7I+Jh2O4nh/l8BVWTRcalYtEB9dfQpkqI+Nr/l
        vnFdBFNPO4z29/QXT4uhRbxb2Zmdf54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-o7X9-GtpMoyv7NehMQKMfQ-1; Mon, 15 Mar 2021 18:10:53 -0400
X-MC-Unique: o7X9-GtpMoyv7NehMQKMfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB8DA107ACCA;
        Mon, 15 Mar 2021 22:10:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 960D45C261;
        Mon, 15 Mar 2021 22:10:38 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for debug
Date:   Tue, 16 Mar 2021 00:10:20 +0200
Message-Id: <20210315221020.661693-4-mlevitsk@redhat.com>
In-Reply-To: <20210315221020.661693-1-mlevitsk@redhat.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new debug module param 'debug_intercept_exceptions' which will allow the
KVM to intercept any guest exception, and forward it to the guest.

This can be very useful for guest debugging and/or KVM debugging with kvm trace.
This is not intended to be used on production systems.

This is based on an idea first shown here:
https://patchwork.kernel.org/project/kvm/patch/20160301192822.GD22677@pd.tnic/

CC: Borislav Petkov <bp@suse.de>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/svm/svm.c          | 77 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h          |  5 ++-
 arch/x86/kvm/x86.c              |  5 ++-
 4 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a52f973bdff6d..c8f44a88b3153 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1564,6 +1564,8 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu);
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
+void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
+			     u32 error_code, unsigned long payload);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271196400495f..94156a367a663 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -197,6 +197,9 @@ module_param(sev_es, int, 0444);
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
+uint debug_intercept_exceptions;
+module_param(debug_intercept_exceptions, uint, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -220,6 +223,8 @@ static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 #define MSRS_RANGE_SIZE 2048
 #define MSRS_IN_RANGE (MSRS_RANGE_SIZE * 8 / 2)
 
+static void init_debug_exceptions_intercept(struct vcpu_svm *svm);
+
 u32 svm_msrpm_offset(u32 msr)
 {
 	u32 offset;
@@ -1137,6 +1142,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	set_exception_intercept(svm, MC_VECTOR);
 	set_exception_intercept(svm, AC_VECTOR);
 	set_exception_intercept(svm, DB_VECTOR);
+
+	init_debug_exceptions_intercept(svm);
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -1913,6 +1920,17 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	if ((debug_intercept_exceptions & (1 << PF_VECTOR)))
+		if (npt_enabled && !vcpu->arch.apf.host_apf_flags) {
+			/* If #PF was only intercepted for debug, inject
+			 * it directly to the guest, since the mmu code
+			 * is not ready to deal with such page faults
+			 */
+			kvm_queue_exception_e_p(vcpu, PF_VECTOR,
+						error_code, fault_address);
+			return 1;
+		}
+
 	return kvm_handle_page_fault(vcpu, error_code, fault_address,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
@@ -3025,7 +3043,7 @@ static int invpcid_interception(struct kvm_vcpu *vcpu)
 	return kvm_handle_invpcid(vcpu, type, gva);
 }
 
-static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
+static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
 	[SVM_EXIT_READ_CR4]			= cr_interception,
@@ -3099,6 +3117,63 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
 };
 
+static int generic_exception_interception(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Generic exception handler which forwards a guest exception
+	 * as-is to the guest.
+	 * For exceptions that don't have a special intercept handler.
+	 *
+	 * Used for 'debug_intercept_exceptions' KVM debug feature only.
+	 */
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int exc = svm->vmcb->control.exit_code - SVM_EXIT_EXCP_BASE;
+
+	WARN_ON(exc < 0 || exc > 31);
+
+	if (exc == TS_VECTOR) {
+		/*
+		 * SVM doesn't provide us with an error code to be able to
+		 * re-inject the #TS exception, so just disable its
+		 * interception, and let the guest re-execute the instruction.
+		 */
+		vmcb_clr_intercept(&svm->vmcb01.ptr->control,
+				   INTERCEPT_EXCEPTION_OFFSET + TS_VECTOR);
+		recalc_intercepts(svm);
+		return 1;
+	} else if (exc == DF_VECTOR) {
+		/* SVM doesn't provide us with an error code for the #DF */
+		kvm_queue_exception_e(vcpu, exc, 0);
+		return 1;
+	}
+
+	if (x86_exception_has_error_code(exc))
+		kvm_queue_exception_e(vcpu, exc, svm->vmcb->control.exit_info_1);
+	else
+		kvm_queue_exception(vcpu, exc);
+	return 1;
+}
+
+static void init_debug_exceptions_intercept(struct vcpu_svm *svm)
+{
+	int exc;
+
+	for (exc = 0 ; exc < 32 ; exc++) {
+		if (!(debug_intercept_exceptions & (1 << exc)))
+			continue;
+
+		/* Those are defined to have undefined behavior in the SVM spec */
+		if (exc == 2 || exc == 9)
+			continue;
+
+		set_exception_intercept(svm, exc);
+
+		if (!svm_exit_handlers[SVM_EXIT_EXCP_BASE + exc])
+			svm_exit_handlers[SVM_EXIT_EXCP_BASE + exc] =
+					generic_exception_interception;
+	}
+}
+
 static void dump_vmcb(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8e276c4fb33df..e0ff9ca996df8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -32,6 +32,7 @@ static const u32 host_save_user_msrs[] = {
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
+extern uint debug_intercept_exceptions;
 
 enum {
 	VMCB_INTERCEPTS, /* Intercept vectors, TSC offset,
@@ -333,7 +334,9 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	WARN_ON_ONCE(bit >= 32);
-	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
+
+	if (!((1 << bit) & debug_intercept_exceptions))
+		vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
 
 	recalc_intercepts(svm);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b75d990fcf12b..be509944622bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -627,12 +627,13 @@ void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr,
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception_p);
 
-static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
-				    u32 error_code, unsigned long payload)
+void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
+			     u32 error_code, unsigned long payload)
 {
 	kvm_multiple_exception(vcpu, nr, true, error_code,
 			       true, payload, false);
 }
+EXPORT_SYMBOL_GPL(kvm_queue_exception_e_p);
 
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err)
 {
-- 
2.26.2

