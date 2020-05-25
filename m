Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8A1E10B9
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403972AbgEYOlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:41:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403957AbgEYOlp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 10:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bgmHbS30sRzkaS9n8n+mozD2X8WFo480ZYarf0twk1E=;
        b=N0118wJ3e/lOz4/RfdnC+lAAUFygltrbilJaIBTixvkrY/bkXtXejE7xvjJOHy99SH3NPK
        InraFkD1yQtJWhXUynV5fGRh1qs97an2BLxVfORAbKmMa8YCGT1ZXgm1vpV0qhezneWC9K
        EmK5bnz8KzSnz06V6BUTQKSmnVDT5Dw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-8SJcSqdkMICKmR7H_dISUw-1; Mon, 25 May 2020 10:41:39 -0400
X-MC-Unique: 8SJcSqdkMICKmR7H_dISUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CF63107ACF9;
        Mon, 25 May 2020 14:41:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F8FF5D9C5;
        Mon, 25 May 2020 14:41:33 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/10] KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
Date:   Mon, 25 May 2020 16:41:17 +0200
Message-Id: <20200525144125.143875-3-vkuznets@redhat.com>
In-Reply-To: <20200525144125.143875-1-vkuznets@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, APF mechanism relies on the #PF abuse where the token is being
passed through CR2. If we switch to using interrupts to deliver page-ready
notifications we need a different way to pass the data. Extent the existing
'struct kvm_vcpu_pv_apf_data' with token information for page-ready
notifications.

While on it, rename 'reason' to 'flags'. This doesn't change the semantics
as we only have reasons '1' and '2' and these can be treated as bit flags
but KVM_PV_REASON_PAGE_READY is going away with interrupt based delivery
making 'reason' name misleading.

The newly introduced apf_put_user_ready() temporary puts both flags and
token information, this will be changed to put token only when we switch
to interrupt based notifications.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h      |  2 +-
 arch/x86/include/asm/kvm_para.h      |  4 ++--
 arch/x86/include/uapi/asm/kvm_para.h |  5 +++--
 arch/x86/kernel/kvm.c                | 16 ++++++++--------
 arch/x86/kvm/mmu/mmu.c               |  6 +++---
 arch/x86/kvm/svm/nested.c            |  2 +-
 arch/x86/kvm/svm/svm.c               |  3 ++-
 arch/x86/kvm/vmx/nested.c            |  2 +-
 arch/x86/kvm/vmx/vmx.c               |  5 +++--
 arch/x86/kvm/x86.c                   | 17 +++++++++++++----
 10 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0a6b35353fc7..c195f63c1086 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -767,7 +767,7 @@ struct kvm_vcpu_arch {
 		u64 msr_val;
 		u32 id;
 		bool send_user_only;
-		u32 host_apf_reason;
+		u32 host_apf_flags;
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
 	} apf;
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..2a3102fee189 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -90,7 +90,7 @@ unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
 void kvm_async_pf_task_wake(u32 token);
-u32 kvm_read_and_reset_pf_reason(void);
+u32 kvm_read_and_reset_apf_flags(void);
 extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
 
@@ -121,7 +121,7 @@ static inline unsigned int kvm_arch_para_hints(void)
 	return 0;
 }
 
-static inline u32 kvm_read_and_reset_pf_reason(void)
+static inline u32 kvm_read_and_reset_apf_flags(void)
 {
 	return 0;
 }
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..d1cd5c0f431a 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -112,8 +112,9 @@ struct kvm_mmu_op_release_pt {
 #define KVM_PV_REASON_PAGE_READY 2
 
 struct kvm_vcpu_pv_apf_data {
-	__u32 reason;
-	__u8 pad[60];
+	__u32 flags;
+	__u32 token; /* Used for page ready notification only */
+	__u8 pad[56];
 	__u32 enabled;
 };
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..340df5dab30d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -228,24 +228,24 @@ void kvm_async_pf_task_wake(u32 token)
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
 
-u32 kvm_read_and_reset_pf_reason(void)
+u32 kvm_read_and_reset_apf_flags(void)
 {
-	u32 reason = 0;
+	u32 flags = 0;
 
 	if (__this_cpu_read(apf_reason.enabled)) {
-		reason = __this_cpu_read(apf_reason.reason);
-		__this_cpu_write(apf_reason.reason, 0);
+		flags = __this_cpu_read(apf_reason.flags);
+		__this_cpu_write(apf_reason.flags, 0);
 	}
 
-	return reason;
+	return flags;
 }
-EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
-NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
+EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
+NOKPROBE_SYMBOL(kvm_read_and_reset_apf_flags);
 
 dotraplinkage void
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address)
 {
-	switch (kvm_read_and_reset_pf_reason()) {
+	switch (kvm_read_and_reset_apf_flags()) {
 	default:
 		do_page_fault(regs, error_code, address);
 		break;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8071952e9cf2..7fa5253237b2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4186,7 +4186,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 #endif
 
 	vcpu->arch.l1tf_flush_l1d = true;
-	switch (vcpu->arch.apf.host_apf_reason) {
+	switch (vcpu->arch.apf.host_apf_flags) {
 	default:
 		trace_kvm_page_fault(fault_address, error_code);
 
@@ -4196,13 +4196,13 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				insn_len);
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
-		vcpu->arch.apf.host_apf_reason = 0;
+		vcpu->arch.apf.host_apf_flags = 0;
 		local_irq_disable();
 		kvm_async_pf_task_wait(fault_address, 0);
 		local_irq_enable();
 		break;
 	case KVM_PV_REASON_PAGE_READY:
-		vcpu->arch.apf.host_apf_reason = 0;
+		vcpu->arch.apf.host_apf_flags = 0;
 		local_irq_disable();
 		kvm_async_pf_task_wake(fault_address);
 		local_irq_enable();
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9a2a62e5afeb..c04adbbdbd20 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -835,7 +835,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 		break;
 	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
 		/* When we're shadowing, trap PFs, but not async PF */
-		if (!npt_enabled && svm->vcpu.arch.apf.host_apf_reason == 0)
+		if (!npt_enabled && svm->vcpu.arch.apf.host_apf_flags == 0)
 			return NESTED_EXIT_HOST;
 		break;
 	default:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a862c768fd54..70d136e9e075 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3399,7 +3399,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/* if exit due to PF check for async PF */
 	if (svm->vmcb->control.exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR)
-		svm->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
+		svm->vcpu.arch.apf.host_apf_flags =
+			kvm_read_and_reset_apf_flags();
 
 	if (npt_enabled) {
 		vcpu->arch.regs_avail &= ~(1 << VCPU_EXREG_PDPTR);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e44f33c82332..c82d59070a9c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5582,7 +5582,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 		if (is_nmi(intr_info))
 			return false;
 		else if (is_page_fault(intr_info))
-			return !vmx->vcpu.arch.apf.host_apf_reason && enable_ept;
+			return !vmx->vcpu.arch.apf.host_apf_flags && enable_ept;
 		else if (is_debug(intr_info) &&
 			 vcpu->guest_debug &
 			 (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 89c766fad889..4a82319353f2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4662,7 +4662,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	if (is_page_fault(intr_info)) {
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
 		/* EPT won't cause page fault directly */
-		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_reason && enable_ept);
+		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_flags && enable_ept);
 		return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
 	}
 
@@ -6234,7 +6234,8 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(vmx->exit_intr_info)) {
-		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
+		vmx->vcpu.arch.apf.host_apf_flags =
+			kvm_read_and_reset_apf_flags();
 	/* Handle machine checks before interrupts are enabled */
 	} else if (is_machine_check(vmx->exit_intr_info)) {
 		kvm_machine_check();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e0bbe4f0d5b..a3102406102c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2654,7 +2654,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	}
 
 	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
-					sizeof(u32)))
+					sizeof(u64)))
 		return 1;
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
@@ -10357,8 +10357,17 @@ static void kvm_del_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 	}
 }
 
-static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
+static inline int apf_put_user_notpresent(struct kvm_vcpu *vcpu)
 {
+	u32 reason = KVM_PV_REASON_PAGE_NOT_PRESENT;
+
+	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &reason,
+				      sizeof(reason));
+}
+
+static inline int apf_put_user_ready(struct kvm_vcpu *vcpu, u32 token)
+{
+	u64 val = (u64)token << 32 | KVM_PV_REASON_PAGE_READY;
 
 	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &val,
 				      sizeof(val));
@@ -10403,7 +10412,7 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
 	if (kvm_can_deliver_async_pf(vcpu) &&
-	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
+	    !apf_put_user_notpresent(vcpu)) {
 		fault.vector = PF_VECTOR;
 		fault.error_code_valid = true;
 		fault.error_code = 0;
@@ -10436,7 +10445,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
 
 	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
-	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
+	    !apf_put_user_ready(vcpu, work->arch.token)) {
 			fault.vector = PF_VECTOR;
 			fault.error_code_valid = true;
 			fault.error_code = 0;
-- 
2.25.4

