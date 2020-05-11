Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CE71CE0E9
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 18:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgEKQsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 12:48:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24330 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730776AbgEKQsg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 12:48:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589215713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qhXJffBlhNDtE9tkMyyMOsHY6u+h1PyLE3ZgipjNapM=;
        b=hltURitXt+hgbuhqRLfvvN7wBf4Wi6rtflTvOdKsBS6BoplI3cHZBTf7R26ktEGjS8GfZI
        LGNWHwn8aF0jGYfQTM/GECERsaKpH99eF1pa/sCMcCmv7VvAX7VWbK7/Ep6O7YddWd3O9D
        uC11oNAEsTPSjeD7QRQaD8vgmIi6Gfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-awtjyMfdMXWo6417ud49_A-1; Mon, 11 May 2020 12:48:31 -0400
X-MC-Unique: awtjyMfdMXWo6417ud49_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2886B107ACF4;
        Mon, 11 May 2020 16:48:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB5E547348;
        Mon, 11 May 2020 16:48:24 +0000 (UTC)
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
Subject: [PATCH 4/8] KVM: x86: interrupt based APF page-ready event delivery
Date:   Mon, 11 May 2020 18:47:48 +0200
Message-Id: <20200511164752.2158645-5-vkuznets@redhat.com>
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Concerns were expressed around APF delivery via synthetic #PF exception as
in some cases such delivery may collide with real page fault. For type 2
(page ready) notifications we can easily switch to using an interrupt
instead. Introduce new MSR_KVM_ASYNC_PF_INT mechanism and deprecate the
legacy one.

One notable difference between the two mechanisms is that interrupt may not
get handled immediately so whenever we would like to deliver next event
(regardless of its type) we must be sure the guest had read and cleared
previous event in the slot.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/msr.rst       | 91 +++++++++++++++++---------
 arch/x86/include/asm/kvm_host.h      |  4 +-
 arch/x86/include/uapi/asm/kvm_para.h |  6 ++
 arch/x86/kvm/x86.c                   | 95 ++++++++++++++++++++--------
 4 files changed, 140 insertions(+), 56 deletions(-)

diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index 33892036672d..f988a36f226a 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -190,35 +190,54 @@ MSR_KVM_ASYNC_PF_EN:
 	0x4b564d02
 
 data:
-	Bits 63-6 hold 64-byte aligned physical address of a
-	64 byte memory area which must be in guest RAM and must be
-	zeroed. Bits 5-3 are reserved and should be zero. Bit 0 is 1
-	when asynchronous page faults are enabled on the vcpu 0 when
-	disabled. Bit 1 is 1 if asynchronous page faults can be injected
-	when vcpu is in cpl == 0. Bit 2 is 1 if asynchronous page faults
-	are delivered to L1 as #PF vmexits.  Bit 2 can be set only if
-	KVM_FEATURE_ASYNC_PF_VMEXIT is present in CPUID.
-
-	First 4 byte of 64 byte memory location will be written to by
-	the hypervisor at the time of asynchronous page fault (APF)
-	injection to indicate type of asynchronous page fault. Value
-	of 1 means that the page referred to by the page fault is not
-	present. Value 2 means that the page is now available. Disabling
-	interrupt inhibits APFs. Guest must not enable interrupt
-	before the reason is read, or it may be overwritten by another
-	APF. Since APF uses the same exception vector as regular page
-	fault guest must reset the reason to 0 before it does
-	something that can generate normal page fault.  If during page
-	fault APF reason is 0 it means that this is regular page
-	fault.
-
-	During delivery of type 1 APF cr2 contains a token that will
-	be used to notify a guest when missing page becomes
-	available. When page becomes available type 2 APF is sent with
-	cr2 set to the token associated with the page. There is special
-	kind of token 0xffffffff which tells vcpu that it should wake
-	up all processes waiting for APFs and no individual type 2 APFs
-	will be sent.
+	Asynchronous page fault (APF) control MSR.
+
+	Bits 63-6 hold 64-byte aligned physical address of a 64 byte memory area
+	which must be in guest RAM and must be zeroed. This memory is expected
+	to hold a copy of the following structure::
+
+	  struct kvm_vcpu_pv_apf_data {
+		__u32 reason;
+		__u32 pageready_token;
+		__u8 pad[56];
+		__u32 enabled;
+	  };
+
+	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
+	when asynchronous page faults are enabled on the vcpu, 0 when disabled.
+	Bit 1 is 1 if asynchronous page faults can be injected when vcpu is in
+	cpl == 0. Bit 2 is 1 if asynchronous page faults are delivered to L1 as
+	#PF vmexits.  Bit 2 can be set only if KVM_FEATURE_ASYNC_PF_VMEXIT is
+	present in CPUID. Bit 3 enables interrupt based delivery of type 2
+	(page present) events.
+
+	First 4 byte of 64 byte memory location ('reason') will be written to
+	by the hypervisor at the time APF type 1 (page not present) injection.
+	The only possible values are '0' and '1'. Type 1 events are currently
+	always delivered as synthetic #PF exception. During delivery of type 1
+	APF CR2 register contains a token that will be used to notify the guest
+	when missing page becomes available. Guest is supposed to write '0' to
+	the location when it is done handling type 1 event so the next one can
+	be delivered.
+
+	Note, since APF type 1 uses the same exception vector as regular page
+	fault, guest must reset the reason to '0' before it does something that
+	can generate normal page fault. If during a page fault APF reason is '0'
+	it means that this is regular page fault.
+
+	Bytes 5-7 of 64 byte memory location ('pageready_token') will be written
+	to by the hypervisor at the time of type 2 (page ready) event injection.
+	The content of these bytes is a token which was previously delivered as
+	type 1 event. The event indicates the page in now available. Guest is
+	supposed to write '0' to the location when it is done handling type 2
+	event so the next one can be delivered. MSR_KVM_ASYNC_PF_INT MSR
+	specifying the interrupt vector for type 2 APF delivery needs to be
+	written to before enabling APF mechanism in MSR_KVM_ASYNC_PF_EN.
+
+	Note, previously, type 2 (page present) events were delivered via the
+	same #PF exception as type 1 (page not present) events but this is
+	now deprecated. If bit 3 (interrupt based delivery) is not set APF
+	events are not delivered.
 
 	If APF is disabled while there are outstanding APFs, they will
 	not be delivered.
@@ -319,3 +338,17 @@ data:
 
 	KVM guests can request the host not to poll on HLT, for example if
 	they are performing polling themselves.
+
+MSR_KVM_ASYNC_PF_INT:
+	0x4b564d06
+
+data:
+	Second asynchronous page fault (APF) control MSR.
+
+	Bits 0-7: APIC vector for delivery of type 2 APF events (page ready
+	notifications).
+	Bits 8-63: Reserved
+
+	Interrupt vector for asynchnonous page ready notifications delivery.
+	The vector has to be set up before asynchronous page fault mechanism
+	is enabled in MSR_KVM_ASYNC_PF_EN.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..4a72ba26a532 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -763,7 +763,9 @@ struct kvm_vcpu_arch {
 		bool halted;
 		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
 		struct gfn_to_hva_cache data;
-		u64 msr_val;
+		u64 msr_en_val; /* MSR_KVM_ASYNC_PF_EN */
+		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
+		u16 vec;
 		u32 id;
 		bool send_user_only;
 		u32 host_apf_reason;
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index e3602a1de136..c55ffa2c40b6 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -50,6 +50,7 @@
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -81,6 +82,11 @@ struct kvm_clock_pairing {
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
 #define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
+#define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
+
+/* MSR_KVM_ASYNC_PF_INT */
+#define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
+
 
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28868cc16e4d..d1e9b072d279 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1243,7 +1243,7 @@ static const u32 emulated_msrs_all[] = {
 	HV_X64_MSR_TSC_EMULATION_STATUS,
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
-	MSR_KVM_PV_EOI_EN,
+	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT,
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
@@ -2645,17 +2645,24 @@ static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
 	return r;
 }
 
+static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
+{
+	u64 mask = KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
+
+	return (vcpu->arch.apf.msr_en_val & mask) == mask;
+}
+
 static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 {
 	gpa_t gpa = data & ~0x3f;
 
-	/* Bits 3:5 are reserved, Should be zero */
-	if (data & 0x38)
+	/* Bits 4:5 are reserved, Should be zero */
+	if (data & 0x30)
 		return 1;
 
-	vcpu->arch.apf.msr_val = data;
+	vcpu->arch.apf.msr_en_val = data;
 
-	if (!(data & KVM_ASYNC_PF_ENABLED)) {
+	if (!kvm_pv_async_pf_enabled(vcpu)) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
 		return 0;
@@ -2667,7 +2674,25 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
 	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
+
 	kvm_async_pf_wakeup_all(vcpu);
+
+	return 0;
+}
+
+static int kvm_pv_enable_async_pf_int(struct kvm_vcpu *vcpu, u64 data)
+{
+	/* Bits 8-63 are reserved */
+	if (data >> 8)
+		return 1;
+
+	if (!lapic_in_kernel(vcpu))
+		return 1;
+
+	vcpu->arch.apf.msr_int_val = data;
+
+	vcpu->arch.apf.vec = data & KVM_ASYNC_PF_VEC_MASK;
+
 	return 0;
 }
 
@@ -2883,6 +2908,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_ASYNC_PF_INT:
+		if (kvm_pv_enable_async_pf_int(vcpu, data))
+			return 1;
+		break;
 	case MSR_KVM_STEAL_TIME:
 
 		if (unlikely(!sched_info_on()))
@@ -3157,7 +3186,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.time;
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
-		msr_info->data = vcpu->arch.apf.msr_val;
+		msr_info->data = vcpu->arch.apf.msr_en_val;
+		break;
+	case MSR_KVM_ASYNC_PF_INT:
+		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
 	case MSR_KVM_STEAL_TIME:
 		msr_info->data = vcpu->arch.st.msr_val;
@@ -9500,7 +9532,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.cr2 = 0;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
-	vcpu->arch.apf.msr_val = 0;
+	vcpu->arch.apf.msr_en_val = 0;
+	vcpu->arch.apf.msr_int_val = 0;
 	vcpu->arch.st.msr_val = 0;
 
 	kvmclock_reset(vcpu);
@@ -10362,10 +10395,24 @@ static inline int apf_put_user_notpresent(struct kvm_vcpu *vcpu)
 
 static inline int apf_put_user_ready(struct kvm_vcpu *vcpu, u32 token)
 {
-	u64 val = (u64)token << 32 | KVM_PV_REASON_PAGE_READY;
+	unsigned int offset = offsetof(struct kvm_vcpu_pv_apf_data,
+				       pageready_token);
 
-	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &val,
-				      sizeof(val));
+	return kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.apf.data,
+					     &token, offset, sizeof(token));
+}
+
+static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
+{
+	unsigned int offset = offsetof(struct kvm_vcpu_pv_apf_data,
+				       pageready_token);
+	u32 val;
+
+	if (kvm_read_guest_offset_cached(vcpu->kvm, &vcpu->arch.apf.data,
+					 &val, offset, sizeof(val)))
+		return false;
+
+	return !val;
 }
 
 static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
@@ -10373,9 +10420,8 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
 		return false;
 
-	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
-	    (vcpu->arch.apf.send_user_only &&
-	     kvm_x86_ops.get_cpl(vcpu) == 0))
+	if (!kvm_pv_async_pf_enabled(vcpu) ||
+	    (vcpu->arch.apf.send_user_only && kvm_x86_ops.get_cpl(vcpu) == 0))
 		return false;
 
 	return true;
@@ -10431,7 +10477,10 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work)
 {
-	struct x86_exception fault;
+	struct kvm_lapic_irq irq = {
+		.delivery_mode = APIC_DM_FIXED,
+		.vector = vcpu->arch.apf.vec
+	};
 
 	if (work->wakeup_all)
 		work->arch.token = ~0; /* broadcast wakeup */
@@ -10439,26 +10488,20 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
 
-	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
-	    !apf_put_user_ready(vcpu, work->arch.token)) {
-			fault.vector = PF_VECTOR;
-			fault.error_code_valid = true;
-			fault.error_code = 0;
-			fault.nested_page_fault = false;
-			fault.address = work->arch.token;
-			fault.async_page_fault = true;
-			kvm_inject_page_fault(vcpu, &fault);
-	}
+	if (kvm_pv_async_pf_enabled(vcpu) &&
+	    !apf_put_user_ready(vcpu, work->arch.token))
+		kvm_apic_set_irq(vcpu, &irq, NULL);
+
 	vcpu->arch.apf.halted = false;
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 }
 
 bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
 {
-	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
+	if (!kvm_pv_async_pf_enabled(vcpu))
 		return true;
 	else
-		return kvm_can_do_async_pf(vcpu);
+		return apf_pageready_slot_free(vcpu);
 }
 
 void kvm_arch_start_assignment(struct kvm *kvm)
-- 
2.25.4

