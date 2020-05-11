Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6407B1CE0EA
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 18:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbgEKQso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 12:48:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35570 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730790AbgEKQso (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 12:48:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589215721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvPOgL7NqXN+z5XgpMm6Ybw6RKGKK37IWFotakDw6ck=;
        b=LvmrsXq/g9GIagljWIPZvkSsA6WgKDZvMPXgwh7djp+mlysyKEn1pmm7CK9WPJuiVm5PyW
        aCMzhjVCVvVbMz1Evz9RNT9Xe/DLDS+1uVpMn1mOZvCdxPdUga07BhLMbntDQR5pyTR9vn
        FWXvzYbg1TqK/0aw6JN2xCaLWPuhEo0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-U8dDfSR_OIeo6D2fdzoC2g-1; Mon, 11 May 2020 12:48:39 -0400
X-MC-Unique: U8dDfSR_OIeo6D2fdzoC2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B839107ACF5;
        Mon, 11 May 2020 16:48:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5896341FD;
        Mon, 11 May 2020 16:48:30 +0000 (UTC)
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
Subject: [PATCH 5/8] KVM: x86: acknowledgment mechanism for async pf page ready notifications
Date:   Mon, 11 May 2020 18:47:49 +0200
Message-Id: <20200511164752.2158645-6-vkuznets@redhat.com>
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
queue. Mandate using it for interrupt based type 2 APF event delivery.

As kvm_check_async_pf_completion() is going away from vcpu_run() we need
a way to communicate the fact that vcpu->async_pf.done queue has
transitioned from empty to non-empty state. Introduce
kvm_arch_async_page_present_queued() and KVM_REQ_APF_READY to do the job.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/msr.rst       | 18 +++++++++++++++---
 arch/s390/include/asm/kvm_host.h     |  2 ++
 arch/x86/include/asm/kvm_host.h      |  3 +++
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/x86.c                   | 26 ++++++++++++++++++++++----
 virt/kvm/async_pf.c                  | 10 ++++++++++
 6 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index f988a36f226a..3c7afbcd243f 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -230,9 +230,10 @@ data:
 	The content of these bytes is a token which was previously delivered as
 	type 1 event. The event indicates the page in now available. Guest is
 	supposed to write '0' to the location when it is done handling type 2
-	event so the next one can be delivered. MSR_KVM_ASYNC_PF_INT MSR
-	specifying the interrupt vector for type 2 APF delivery needs to be
-	written to before enabling APF mechanism in MSR_KVM_ASYNC_PF_EN.
+	event so the next one can be delivered. It is also supposed to write
+	'1' to MSR_KVM_ASYNC_PF_ACK every time after clearing the location,
+	this forces KVM to re-scan its queue and deliver next pending
+	notification.
 
 	Note, previously, type 2 (page present) events were delivered via the
 	same #PF exception as type 1 (page not present) events but this is
@@ -352,3 +353,14 @@ data:
 	Interrupt vector for asynchnonous page ready notifications delivery.
 	The vector has to be set up before asynchronous page fault mechanism
 	is enabled in MSR_KVM_ASYNC_PF_EN.
+
+MSR_KVM_ASYNC_PF_ACK:
+	0x4b564d07
+
+data:
+	Asynchronous page fault (APF) acknowledgment.
+
+	When the guest is done processing type 2 APF event and 'pageready_token'
+	field in 'struct kvm_vcpu_pv_apf_data' is cleared it is supposed to
+	write '1' to bit 0 of the MSR, this caused the host to re-scan its queue
+	and check if there are more notifications pending.
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index d6bcd34f3ec3..c9c5b8b71175 100644
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
index 4a72ba26a532..0eeeb98ed02a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -83,6 +83,7 @@
 #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
 #define KVM_REQ_APICV_UPDATE \
 	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_APF_READY		KVM_ARCH_REQ(26)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -771,6 +772,7 @@ struct kvm_vcpu_arch {
 		u32 host_apf_reason;
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
 bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu);
 extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index c55ffa2c40b6..941fdf4569a4 100644
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
index d1e9b072d279..d21adc23a99f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1243,7 +1243,7 @@ static const u32 emulated_msrs_all[] = {
 	HV_X64_MSR_TSC_EMULATION_STATUS,
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
-	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT,
+	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
@@ -2912,6 +2912,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3191,6 +3197,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KVM_ASYNC_PF_INT:
 		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
+	case MSR_KVM_ASYNC_PF_ACK:
+		msr_info->data = 0;
+		break;
 	case MSR_KVM_STEAL_TIME:
 		msr_info->data = vcpu->arch.st.msr_val;
 		break;
@@ -8336,6 +8345,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_hv_process_stimers(vcpu);
 		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
 			kvm_vcpu_update_apicv(vcpu);
+		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
+			kvm_check_async_pf_completion(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
@@ -8610,8 +8621,6 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			break;
 		}
 
-		kvm_check_async_pf_completion(vcpu);
-
 		if (signal_pending(current)) {
 			r = -EINTR;
 			vcpu->run->exit_reason = KVM_EXIT_INTR;
@@ -10489,13 +10498,22 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
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
 bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_pv_async_pf_enabled(vcpu))
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 15e5b037f92d..746d95cf98ad 100644
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

