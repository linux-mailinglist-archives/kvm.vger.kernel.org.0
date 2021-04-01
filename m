Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58A0351AA1
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbhDASCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234866AbhDAR6T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IeSCqCBagWzFXJCY1w7HB1qDOO9KpHIs4Tyewq8aOvs=;
        b=bfDDatFi6U62JtAXbut2417zAPLhEld8fUfnXiiUDfijvOZSBc1SfbACLk9u7yRo2TtpTu
        lGz6W+j4UkwyzuBTS0fvCq67z1+R+4ICBH/Q7DY8RLJ2RSCLGIxltKaQMjZGc6Y6lgV21q
        dvuD2Av8YUO0/kvzkB/6VD6/UnTNe74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-tafvrKJ1O3-YC537vN-qRQ-1; Thu, 01 Apr 2021 09:57:12 -0400
X-MC-Unique: tafvrKJ1O3-YC537vN-qRQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 807611853020;
        Thu,  1 Apr 2021 13:57:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A617627DD;
        Thu,  1 Apr 2021 13:56:27 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org (open list),
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Will Deacon <will@kernel.org>,
        kvmarm@lists.cs.columbia.edu (open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 (KVM/arm64)), Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org (open list:S390),
        Heiko Carstens <hca@linux.ibm.com>,
        Kieran Bingham <kbingham@kernel.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-arm-kernel@lists.infradead.org (moderated list:KERNEL VIRTUAL
        MACHINE FOR ARM64 (KVM/arm64)), James Morse <james.morse@arm.com>
Subject: [PATCH v2 9/9] KVM: SVM: implement force_intercept_exceptions_mask
Date:   Thu,  1 Apr 2021 16:54:51 +0300
Message-Id: <20210401135451.1004564-10-mlevitsk@redhat.com>
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently #TS interception is only done once.
Also exception interception is not enabled for SEV guests.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/svm/svm.c          | 70 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |  6 ++-
 arch/x86/kvm/x86.c              |  5 ++-
 4 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c529ae9dbbe..d15ae64a2c4e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1574,6 +1574,8 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu);
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
+void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
+			     u32 error_code, unsigned long payload);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2aa951bc470c..de7fd7922ec7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -220,6 +220,8 @@ static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 #define MSRS_RANGE_SIZE 2048
 #define MSRS_IN_RANGE (MSRS_RANGE_SIZE * 8 / 2)
 
+static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code);
+
 u32 svm_msrpm_offset(u32 msr)
 {
 	u32 offset;
@@ -1113,6 +1115,22 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
 	}
 }
 
+static void svm_init_force_exceptions_intercepts(struct vcpu_svm *svm)
+{
+	int exc;
+
+	svm->force_intercept_exceptions_mask = force_intercept_exceptions_mask;
+	for (exc = 0 ; exc < 32 ; exc++) {
+		if (!(svm->force_intercept_exceptions_mask & (1 << exc)))
+			continue;
+
+		/* Those are defined to have undefined behavior in the SVM spec */
+		if (exc != 2 && exc != 9)
+			continue;
+		set_exception_intercept(svm, exc);
+	}
+}
+
 static void init_vmcb(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1288,6 +1306,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 
 	enable_gif(svm);
 
+	if (!sev_es_guest(vcpu->kvm))
+		svm_init_force_exceptions_intercepts(svm);
+
 }
 
 static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -1913,6 +1934,17 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
+	if ((svm->force_intercept_exceptions_mask & (1 << PF_VECTOR)))
+		if (npt_enabled && !vcpu->arch.apf.host_apf_flags) {
+			/* If the #PF was only intercepted for debug, inject
+			 * it directly to the guest, since the kvm's mmu code
+			 * is not ready to deal with such page faults.
+			 */
+			kvm_queue_exception_e_p(vcpu, PF_VECTOR,
+						error_code, fault_address);
+			return 1;
+		}
+
 	return kvm_handle_page_fault(vcpu, error_code, fault_address,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
@@ -1988,6 +2020,40 @@ static int ac_interception(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int gen_exc_interception(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Generic exception intercept handler which forwards a guest exception
+	 * as-is to the guest.
+	 * For exceptions that don't have a special intercept handler.
+	 *
+	 * Used only for 'force_intercept_exceptions_mask' KVM debug feature.
+	 */
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int exc = svm->vmcb->control.exit_code - SVM_EXIT_EXCP_BASE;
+
+	/* SVM doesn't provide us with an error code for the #DF */
+	u32 err_code = exc == DF_VECTOR ? 0 : svm->vmcb->control.exit_info_1;
+
+	if (!(svm->force_intercept_exceptions_mask & (1 << exc)))
+		return svm_handle_invalid_exit(vcpu, svm->vmcb->control.exit_code);
+
+	if (exc == TS_VECTOR) {
+		/*
+		 * SVM doesn't provide us with an error code to be able to
+		 * re-inject the #TS exception, so just disable its
+		 * intercept, and let the guest re-execute the instruction.
+		 */
+		vmcb_clr_intercept(&svm->vmcb01.ptr->control,
+				   INTERCEPT_EXCEPTION_OFFSET + TS_VECTOR);
+		recalc_intercepts(svm);
+	} else if (x86_exception_has_error_code(exc))
+		kvm_queue_exception_e(vcpu, exc, err_code);
+	else
+		kvm_queue_exception(vcpu, exc);
+	return 1;
+}
+
 static bool is_erratum_383(void)
 {
 	int err, i;
@@ -3051,6 +3117,10 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_WRITE_DR5]			= dr_interception,
 	[SVM_EXIT_WRITE_DR6]			= dr_interception,
 	[SVM_EXIT_WRITE_DR7]			= dr_interception,
+
+	[SVM_EXIT_EXCP_BASE ...
+	SVM_EXIT_EXCP_BASE + 31]		= gen_exc_interception,
+
 	[SVM_EXIT_EXCP_BASE + DB_VECTOR]	= db_interception,
 	[SVM_EXIT_EXCP_BASE + BP_VECTOR]	= bp_interception,
 	[SVM_EXIT_EXCP_BASE + UD_VECTOR]	= ud_interception,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8e276c4fb33d..79d0aea87753 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -183,6 +183,7 @@ struct vcpu_svm {
 	bool ghcb_sa_free;
 
 	bool guest_state_loaded;
+	u32 force_intercept_exceptions_mask;
 };
 
 struct svm_cpu_data {
@@ -333,8 +334,11 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	WARN_ON_ONCE(bit >= 32);
-	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
 
+	if ((1 << bit) & svm->force_intercept_exceptions_mask)
+		return;
+
+	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
 	recalc_intercepts(svm);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a51031d64d8..ae57816fe6d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -630,12 +630,13 @@ void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr,
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

