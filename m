Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149AC1E10C2
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404053AbgEYOmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:42:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47110 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404002AbgEYOmB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 10:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NAnvubXx9UM8oJdsI/0D4DVgLkVYkdl/RmpRfFhywk=;
        b=CFPaRvL/kA8j/sTdEKrkGMtQ7LuiA9gtqBSrI3IEGtNSWIPaJo7kfbhHrsk7BBiol7CUIl
        rh3DCwGViwtV9BprIDzJd+C4D9udYbbzoI3bR0b/QDaVXwLo/jMmYffw1Ls5j9rczxUOlJ
        8QMxVfbx/QBLRgdqtLlBdB4QGWLV4H8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-myZG4OGOOwGgAlOVWIPzBw-1; Mon, 25 May 2020 10:41:57 -0400
X-MC-Unique: myZG4OGOOwGgAlOVWIPzBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56C0380183C;
        Mon, 25 May 2020 14:41:55 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 075CB5D9C5;
        Mon, 25 May 2020 14:41:51 +0000 (UTC)
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
Subject: [PATCH v2 06/10] KVM: x86: acknowledgment mechanism for async pf page ready notifications
Date:   Mon, 25 May 2020 16:41:21 +0200
Message-Id: <20200525144125.143875-7-vkuznets@redhat.com>
In-Reply-To: <20200525144125.143875-1-vkuznets@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If two page ready notifications happen back to back the second one is not
delivered and the only mechanism we currently have is
kvm_check_async_pf_completion() check in vcpu_run() loop. The check will
only be performed with the next vmexit when it happens and in some cases
it may take a while. With interrupt based page ready notification delivery
the situation is even worse: unlike exceptions, interrupts are not handled
immediately so we must check if the slot is empty. This is slow and
unnecessary. Introduce dedicated MSR_KVM_ASYNC_PF_ACK MSR to communicate
the fact that the slot is free and host should check its notification
queue. Mandate using it for interrupt based 'page ready' APF event
delivery.

As kvm_check_async_pf_completion() is going away from vcpu_run() we need
a way to communicate the fact that vcpu->async_pf.done queue has
transitioned from empty to non-empty state. Introduce
kvm_arch_async_page_present_queued() and KVM_REQ_APF_READY to do the job.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/msr.rst       | 16 +++++++++++++++-
 arch/s390/include/asm/kvm_host.h     |  2 ++
 arch/x86/include/asm/kvm_host.h      |  3 +++
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/x86.c                   | 26 ++++++++++++++++++++++----
 virt/kvm/async_pf.c                  | 10 ++++++++++
 6 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index be08df12f31a..8ea3fbcc67fd 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -236,7 +236,10 @@ data:
 	of these bytes is a token which was previously delivered as 'page not
 	present' event. The event indicates the page in now available. Guest is
 	supposed to write '0' to 'token' when it is done handling 'page ready'
-	event so the next one can be delivered.
+	event so the next one can be delivered.  It is also supposed to write
+	'1' to MSR_KVM_ASYNC_PF_ACK every time after clearing the location,
+	this forces KVM to re-scan its queue and deliver next pending
+	notification.
 
 	Note, MSR_KVM_ASYNC_PF_INT MSR specifying the interrupt vector for 'page
 	ready' APF delivery needs to be written to before enabling APF mechanism
@@ -359,3 +362,14 @@ data:
 	Interrupt vector for asynchnonous 'page ready' notifications delivery.
 	The vector has to be set up before asynchronous page fault mechanism
 	is enabled in MSR_KVM_ASYNC_PF_EN.
+
+MSR_KVM_ASYNC_PF_ACK:
+	0x4b564d07
+
+data:
+	Asynchronous page fault (APF) acknowledgment.
+
+	When the guest is done processing 'page ready' APF event and 'token'
+	field in 'struct kvm_vcpu_pv_apf_data' is cleared it is supposed to
+	write '1' to bit 0 of the MSR, this caused the host to re-scan its queue
+	and check if there are more notifications pending.
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 5ba9968c3436..bb1ede017b7e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -982,6 +982,8 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work);
 
+static inline void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu) {}
+
 void kvm_arch_crypto_clear_masks(struct kvm *kvm);
 void kvm_arch_crypto_set_masks(struct kvm *kvm, unsigned long *apm,
 			       unsigned long *aqm, unsigned long *adm);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c2a70e25a1f3..356c02bfa587 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -83,6 +83,7 @@
 #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
 #define KVM_REQ_APICV_UPDATE \
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_APF_READY		KVM_ARCH_REQ(26)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -772,6 +773,7 @@ struct kvm_vcpu_arch {
 		u32 host_apf_flags;
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
+		bool pageready_pending;
 	} apf;
 
 	/* OSVW MSRs (AMD only) */
@@ -1643,6 +1645,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work);
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
+void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu);
 bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
 extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 1d37d616b1fc..7ac20df80ba8 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -51,6 +51,7 @@
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
+#define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99fd347849b2..ffe1497b7beb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1235,7 +1235,7 @@ static const u32 emulated_msrs_all[] = {
 	HV_X64_MSR_TSC_EMULATION_STATUS,
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
-	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT,
+	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
@@ -2904,6 +2904,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_pv_enable_async_pf_int(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_ASYNC_PF_ACK:
+		if (data & 0x1) {
+			vcpu->arch.apf.pageready_pending = false;
+			kvm_check_async_pf_completion(vcpu);
+		}
+		break;
 	case MSR_KVM_STEAL_TIME:
 
 		if (unlikely(!sched_info_on()))
@@ -3183,6 +3189,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KVM_ASYNC_PF_INT:
 		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
+	case MSR_KVM_ASYNC_PF_ACK:
+		msr_info->data = 0;
+		break;
 	case MSR_KVM_STEAL_TIME:
 		msr_info->data = vcpu->arch.st.msr_val;
 		break;
@@ -8340,6 +8349,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_hv_process_stimers(vcpu);
 		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
 			kvm_vcpu_update_apicv(vcpu);
+		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
+			kvm_check_async_pf_completion(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
@@ -8613,8 +8624,6 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			break;
 		}
 
-		kvm_check_async_pf_completion(vcpu);
-
 		if (signal_pending(current)) {
 			r = -EINTR;
 			vcpu->run->exit_reason = KVM_EXIT_INTR;
@@ -10492,13 +10501,22 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
 
 	if (kvm_pv_async_pf_enabled(vcpu) &&
-	    !apf_put_user_ready(vcpu, work->arch.token))
+	    !apf_put_user_ready(vcpu, work->arch.token)) {
+		vcpu->arch.apf.pageready_pending = true;
 		kvm_apic_set_irq(vcpu, &irq, NULL);
+	}
 
 	vcpu->arch.apf.halted = false;
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 }
 
+void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
+{
+	kvm_make_request(KVM_REQ_APF_READY, vcpu);
+	if (!vcpu->arch.apf.pageready_pending)
+		kvm_vcpu_kick(vcpu);
+}
+
 bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_pv_async_pf_enabled(vcpu))
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 8a8770c7c889..5660bbc831bf 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -51,6 +51,7 @@ static void async_pf_execute(struct work_struct *work)
 	unsigned long addr = apf->addr;
 	gpa_t cr2_or_gpa = apf->cr2_or_gpa;
 	int locked = 1;
+	bool first;
 
 	might_sleep();
 
@@ -69,10 +70,14 @@ static void async_pf_execute(struct work_struct *work)
 		kvm_arch_async_page_present(vcpu, apf);
 
 	spin_lock(&vcpu->async_pf.lock);
+	first = list_empty(&vcpu->async_pf.done);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
 	apf->vcpu = NULL;
 	spin_unlock(&vcpu->async_pf.lock);
 
+	if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC) && first)
+		kvm_arch_async_page_present_queued(vcpu);
+
 	/*
 	 * apf may be freed by kvm_check_async_pf_completion() after
 	 * this point
@@ -202,6 +207,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
+	bool first;
 
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return 0;
@@ -214,9 +220,13 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
 
 	spin_lock(&vcpu->async_pf.lock);
+	first = list_empty(&vcpu->async_pf.done);
 	list_add_tail(&work->link, &vcpu->async_pf.done);
 	spin_unlock(&vcpu->async_pf.lock);
 
+	if (!IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC) && first)
+		kvm_arch_async_page_present_queued(vcpu);
+
 	vcpu->async_pf.queued++;
 	return 0;
 }
-- 
2.25.4

