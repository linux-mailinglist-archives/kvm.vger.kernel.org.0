Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D461E10BF
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404019AbgEYOl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:41:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23319 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404021AbgEYOl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eymcXRh+FECXLH1BGRP7uC1amSHxnhc9Q/pJocauacg=;
        b=C8FN01BymiGW7rM2VOUBq1rytWXFO4GRrprJLAVh2hRa3sueZS/4L4k15S0+ECd1JnMIZf
        AU1FTTjQKGkusXSgjrJBFyLgZVzeTmH71EOd7mxAd9DK8t2dgKwUBNNeIw/AYq1uMGW8cC
        E44ql4yDrJqnPv3VKvyfOESbpyR/I2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-RpgLxdnqOTGXmfvQ90TawA-1; Mon, 25 May 2020 10:41:53 -0400
X-MC-Unique: RpgLxdnqOTGXmfvQ90TawA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DA8CEC1A1;
        Mon, 25 May 2020 14:41:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D9385D9C5;
        Mon, 25 May 2020 14:41:45 +0000 (UTC)
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
Subject: [PATCH v2 05/10] KVM: x86: interrupt based APF 'page ready' event delivery
Date:   Mon, 25 May 2020 16:41:20 +0200
Message-Id: <20200525144125.143875-6-vkuznets@redhat.com>
In-Reply-To: <20200525144125.143875-1-vkuznets@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Concerns were expressed around APF delivery via synthetic #PF exception as
in some cases such delivery may collide with real page fault. For 'page
ready' notifications we can easily switch to using an interrupt instead.
Introduce new MSR_KVM_ASYNC_PF_INT mechanism and deprecate the legacy one.

One notable difference between the two mechanisms is that interrupt may not
get handled immediately so whenever we would like to deliver next event
(regardless of its type) we must be sure the guest had read and cleared
previous event in the slot.

While on it, get rid on 'type 1/type 2' names for APF events in the
documentation as they are causing confusion. Use 'page not present'
and 'page ready' everywhere instead.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/msr.rst       | 102 +++++++++++++++++++--------
 arch/x86/include/asm/kvm_host.h      |   4 +-
 arch/x86/include/uapi/asm/kvm_para.h |  12 +++-
 arch/x86/kvm/x86.c                   |  93 +++++++++++++++++-------
 4 files changed, 152 insertions(+), 59 deletions(-)

diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index 33892036672d..be08df12f31a 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -190,41 +190,68 @@ MSR_KVM_ASYNC_PF_EN:
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
+		/* Used for 'page not present' events delivered via #PF */
+		__u32 flags;
+
+		/* Used for 'page ready' events delivered via interrupt notification */
+		__u32 token;
+
+		__u8 pad[56];
+		__u32 enabled;
+	  };
+
+	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
+	when asynchronous page faults are enabled on the vcpu, 0 when disabled.
+	Bit 1 is 1 if asynchronous page faults can be injected when vcpu is in
+	cpl == 0. Bit 2 is 1 if asynchronous page faults are delivered to L1 as
+	#PF vmexits.  Bit 2 can be set only if KVM_FEATURE_ASYNC_PF_VMEXIT is
+	present in CPUID. Bit 3 enables interrupt based delivery of 'page ready'
+	events.
+
+	'Page not present' events are currently always delivered as synthetic
+	#PF exception. During delivery of these events APF CR2 register contains
+	a token that will be used to notify the guest when missing page becomes
+	available. Also, to make it possible to distinguish between real #PF and
+	APF, first 4 bytes of 64 byte memory location ('flags') will be written
+	to by the hypervisor at the time of injection. Only first bit of 'flags'
+	is currently supported, when set, it indicates that the guest is dealing
+	with asynchronous 'page not present' event. If during a page fault APF
+	'flags' is '0' it means that this is regular page fault. Guest is
+	supposed to clear 'flags' when it is done handling #PF exception so the
+	next event can be delivered.
+
+	Note, since APF 'page not present' events use the same exception vector
+	as regular page fault, guest must reset 'flags' to '0' before it does
+	something that can generate normal page fault.
+
+	Bytes 5-7 of 64 byte memory location ('token') will be written to by the
+	hypervisor at the time of APF 'page ready' event injection. The content
+	of these bytes is a token which was previously delivered as 'page not
+	present' event. The event indicates the page in now available. Guest is
+	supposed to write '0' to 'token' when it is done handling 'page ready'
+	event so the next one can be delivered.
+
+	Note, MSR_KVM_ASYNC_PF_INT MSR specifying the interrupt vector for 'page
+	ready' APF delivery needs to be written to before enabling APF mechanism
+	in MSR_KVM_ASYNC_PF_EN or interrupt #0 can get injected.
+
+	Note, previously, 'page ready' events were delivered via the same #PF
+	exception as 'page not present' events but this is now deprecated. If
+	bit 3 (interrupt based delivery) is not set APF events are not delivered.
 
 	If APF is disabled while there are outstanding APFs, they will
 	not be delivered.
 
-	Currently type 2 APF will be always delivered on the same vcpu as
-	type 1 was, but guest should not rely on that.
+	Currently 'page ready' APF events will be always delivered on the
+	same vcpu as 'page not present' event was, but guest should not rely on
+	that.
 
 MSR_KVM_STEAL_TIME:
 	0x4b564d03
@@ -319,3 +346,16 @@ data:
 
 	KVM guests can request the host not to poll on HLT, for example if
 	they are performing polling themselves.
+
+MSR_KVM_ASYNC_PF_INT:
+	0x4b564d06
+
+data:
+	Second asynchronous page fault (APF) control MSR.
+
+	Bits 0-7: APIC vector for delivery of 'page ready' APF events.
+	Bits 8-63: Reserved
+
+	Interrupt vector for asynchnonous 'page ready' notifications delivery.
+	The vector has to be set up before asynchronous page fault mechanism
+	is enabled in MSR_KVM_ASYNC_PF_EN.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 459dc824b10b..c2a70e25a1f3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -764,7 +764,9 @@ struct kvm_vcpu_arch {
 		bool halted;
 		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
 		struct gfn_to_hva_cache data;
-		u64 msr_val;
+		u64 msr_en_val; /* MSR_KVM_ASYNC_PF_EN */
+		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
+		u16 vec;
 		u32 id;
 		bool send_user_only;
 		u32 host_apf_flags;
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index d1cd5c0f431a..1d37d616b1fc 100644
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
@@ -112,8 +118,12 @@ struct kvm_mmu_op_release_pt {
 #define KVM_PV_REASON_PAGE_READY 2
 
 struct kvm_vcpu_pv_apf_data {
+	/* Used for 'page not present' events delivered via #PF */
 	__u32 flags;
-	__u32 token; /* Used for page ready notification only */
+
+	/* Used for 'page ready' events delivered via interrupt notification */
+	__u32 token;
+
 	__u8 pad[56];
 	__u32 enabled;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bfa7e07fd6fd..99fd347849b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1235,7 +1235,7 @@ static const u32 emulated_msrs_all[] = {
 	HV_X64_MSR_TSC_EMULATION_STATUS,
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
-	MSR_KVM_PV_EOI_EN,
+	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT,
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
@@ -2637,17 +2637,24 @@ static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
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
@@ -2659,7 +2666,25 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 
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
 
@@ -2875,6 +2900,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_ASYNC_PF_INT:
+		if (kvm_pv_enable_async_pf_int(vcpu, data))
+			return 1;
+		break;
 	case MSR_KVM_STEAL_TIME:
 
 		if (unlikely(!sched_info_on()))
@@ -3149,7 +3178,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -9502,7 +9534,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.cr2 = 0;
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
-	vcpu->arch.apf.msr_val = 0;
+	vcpu->arch.apf.msr_en_val = 0;
+	vcpu->arch.apf.msr_int_val = 0;
 	vcpu->arch.st.msr_val = 0;
 
 	kvmclock_reset(vcpu);
@@ -10367,10 +10400,22 @@ static inline int apf_put_user_notpresent(struct kvm_vcpu *vcpu)
 
 static inline int apf_put_user_ready(struct kvm_vcpu *vcpu, u32 token)
 {
-	u64 val = (u64)token << 32 | KVM_PV_REASON_PAGE_READY;
+	unsigned int offset = offsetof(struct kvm_vcpu_pv_apf_data, token);
 
-	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &val,
-				      sizeof(val));
+	return kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.apf.data,
+					     &token, offset, sizeof(token));
+}
+
+static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
+{
+	unsigned int offset = offsetof(struct kvm_vcpu_pv_apf_data, token);
+	u32 val;
+
+	if (kvm_read_guest_offset_cached(vcpu->kvm, &vcpu->arch.apf.data,
+					 &val, offset, sizeof(val)))
+		return false;
+
+	return !val;
 }
 
 static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
@@ -10378,9 +10423,8 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
 		return false;
 
-	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
-	    (vcpu->arch.apf.send_user_only &&
-	     kvm_x86_ops.get_cpl(vcpu) == 0))
+	if (!kvm_pv_async_pf_enabled(vcpu) ||
+	    (vcpu->arch.apf.send_user_only && kvm_x86_ops.get_cpl(vcpu) == 0))
 		return false;
 
 	return true;
@@ -10436,7 +10480,10 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
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
@@ -10444,26 +10491,20 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
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
 
 bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
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

