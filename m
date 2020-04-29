Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF581BD862
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgD2Jg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 05:36:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38626 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726743AbgD2Jg4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 05:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588153013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bha0NZMOXL+yC6HujFOHuMMjUmIY0npufI6S+qauKAI=;
        b=EimTSpQQ0LC7VDEP76C7bOqORT/WlOjvPlsXBl2c3I07AOjmMjmiY3HYMRWTK/yUrTIRof
        4L07aHxFFN3r8og4RUlnQfRqotZAoAcBNA7Y9LcObdttccZVNMyxY7NcddDc4n2VvW69Fw
        xg35i75fBRg9PaDS7MIK7HCvMKbLAWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-Pq2qyGWKOUugNm5Gns0eJQ-1; Wed, 29 Apr 2020 05:36:52 -0400
X-MC-Unique: Pq2qyGWKOUugNm5Gns0eJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B1F41005510;
        Wed, 29 Apr 2020 09:36:50 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE74C5D9C9;
        Wed, 29 Apr 2020 09:36:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 3/6] KVM: x86: interrupt based APF page-ready event delivery
Date:   Wed, 29 Apr 2020 11:36:31 +0200
Message-Id: <20200429093634.1514902-4-vkuznets@redhat.com>
In-Reply-To: <20200429093634.1514902-1-vkuznets@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Concerns were expressed around APF delivery via synthetic #PF exception a=
s
in some cases such delivery may collide with real page fault. For type 2
(page ready) notifications we can easily switch to using an interrupt
instead. Introduce new MSR_KVM_ASYNC_PF2 mechanism.

One notable difference between the two mechanisms is that interrupt may n=
ot
get handled immediately so whenever we would like to deliver next event
(regardless of its type) we must be sure the guest had read and cleared
previous event in the slot.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/msr.rst       | 38 +++++++++++---
 arch/x86/include/asm/kvm_host.h      |  5 +-
 arch/x86/include/uapi/asm/kvm_para.h |  6 +++
 arch/x86/kvm/x86.c                   | 77 ++++++++++++++++++++++++++--
 4 files changed, 113 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.=
rst
index 33892036672d..7433e55f7184 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -203,14 +203,21 @@ data:
 	the hypervisor at the time of asynchronous page fault (APF)
 	injection to indicate type of asynchronous page fault. Value
 	of 1 means that the page referred to by the page fault is not
-	present. Value 2 means that the page is now available. Disabling
-	interrupt inhibits APFs. Guest must not enable interrupt
-	before the reason is read, or it may be overwritten by another
-	APF. Since APF uses the same exception vector as regular page
-	fault guest must reset the reason to 0 before it does
-	something that can generate normal page fault.  If during page
-	fault APF reason is 0 it means that this is regular page
-	fault.
+	present. Value 2 means that the page is now available.
+
+	Type 1 page (page missing) events are currently always delivered as
+	synthetic #PF exception. Type 2 (page ready) are either delivered
+	by #PF exception (when bit 3 of MSR_KVM_ASYNC_PF_EN is clear) or
+	via an APIC interrupt (when bit 3 set). APIC interrupt delivery is
+	controlled by MSR_KVM_ASYNC_PF2.
+
+	For #PF delivery, disabling interrupt inhibits APFs. Guest must
+	not enable interrupt before the reason is read, or it may be
+	overwritten by another APF. Since APF uses the same exception
+	vector as regular page fault guest must reset the reason to 0
+	before it does something that can generate normal page fault.
+	If during pagefault APF reason is 0 it means that this is regular
+	page fault.
=20
 	During delivery of type 1 APF cr2 contains a token that will
 	be used to notify a guest when missing page becomes
@@ -319,3 +326,18 @@ data:
=20
 	KVM guests can request the host not to poll on HLT, for example if
 	they are performing polling themselves.
+
+MSR_KVM_ASYNC_PF2:
+	0x4b564d06
+
+data:
+	Second asynchronous page fault control MSR.
+
+	Bits 0-7: APIC vector for interrupt based delivery of type 2 APF
+	events (page ready notification).
+        Bit 8: Interrupt based delivery of type 2 APF events is enabled
+        Bits 9-63: Reserved
+
+	To switch to interrupt based delivery of type 2 APF events guests
+	are supposed to enable asynchronous page faults and set bit 3 in
+	MSR_KVM_ASYNC_PF_EN first.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
index 42a2d0d3984a..6215f61450cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -763,12 +763,15 @@ struct kvm_vcpu_arch {
 		bool halted;
 		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
 		struct gfn_to_hva_cache data;
-		u64 msr_val;
+		u64 msr_val; /* MSR_KVM_ASYNC_PF_EN */
+		u64 msr2_val; /* MSR_KVM_ASYNC_PF2 */
+		u16 vec;
 		u32 id;
 		bool send_user_only;
 		u32 host_apf_reason;
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
+		bool delivery_as_int;
 	} apf;
=20
 	/* OSVW MSRs (AMD only) */
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi=
/asm/kvm_para.h
index df2ba34037a2..1bbb0b7e062f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -50,6 +50,7 @@
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_ASYNC_PF2	0x4b564d06
=20
 struct kvm_steal_time {
 	__u64 steal;
@@ -81,6 +82,11 @@ struct kvm_clock_pairing {
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
 #define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
+#define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
+
+#define KVM_ASYNC_PF2_VEC_MASK			GENMASK(7, 0)
+#define KVM_ASYNC_PF2_ENABLED			BIT(8)
+
=20
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c21c0cf0a33..861dce1e7cf5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1243,7 +1243,7 @@ static const u32 emulated_msrs_all[] =3D {
 	HV_X64_MSR_TSC_EMULATION_STATUS,
=20
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
-	MSR_KVM_PV_EOI_EN,
+	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF2,
=20
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
@@ -2649,8 +2649,8 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *=
vcpu, u64 data)
 {
 	gpa_t gpa =3D data & ~0x3f;
=20
-	/* Bits 3:5 are reserved, Should be zero */
-	if (data & 0x38)
+	/* Bits 4:5 are reserved, Should be zero */
+	if (data & 0x30)
 		return 1;
=20
 	vcpu->arch.apf.msr_val =3D data;
@@ -2667,7 +2667,35 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu =
*vcpu, u64 data)
=20
 	vcpu->arch.apf.send_user_only =3D !(data & KVM_ASYNC_PF_SEND_ALWAYS);
 	vcpu->arch.apf.delivery_as_pf_vmexit =3D data & KVM_ASYNC_PF_DELIVERY_A=
S_PF_VMEXIT;
-	kvm_async_pf_wakeup_all(vcpu);
+	vcpu->arch.apf.delivery_as_int =3D data & KVM_ASYNC_PF_DELIVERY_AS_INT;
+
+	/*
+	 * If delivery via interrupt is configured make sure MSR_KVM_ASYNC_PF2
+	 * was written to before sending 'wakeup all'.
+	 */
+	if (!vcpu->arch.apf.delivery_as_int ||
+	    vcpu->arch.apf.msr2_val & KVM_ASYNC_PF2_ENABLED)
+		kvm_async_pf_wakeup_all(vcpu);
+
+	return 0;
+}
+
+static int kvm_pv_enable_async_pf2(struct kvm_vcpu *vcpu, u64 data)
+{
+	/* Bits 9-63 are reserved */
+	if (data & ~0x1ff)
+		return 1;
+
+	if (!lapic_in_kernel(vcpu))
+		return 1;
+
+	vcpu->arch.apf.msr2_val =3D data;
+
+	vcpu->arch.apf.vec =3D data & KVM_ASYNC_PF2_VEC_MASK;
+
+	if (data & KVM_ASYNC_PF2_ENABLED)
+		kvm_async_pf_wakeup_all(vcpu);
+
 	return 0;
 }
=20
@@ -2883,6 +2911,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
+	case MSR_KVM_ASYNC_PF2:
+		if (kvm_pv_enable_async_pf2(vcpu, data))
+			return 1;
+		break;
 	case MSR_KVM_STEAL_TIME:
=20
 		if (unlikely(!sched_info_on()))
@@ -3159,6 +3191,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
 	case MSR_KVM_ASYNC_PF_EN:
 		msr_info->data =3D vcpu->arch.apf.msr_val;
 		break;
+	case MSR_KVM_ASYNC_PF2:
+		msr_info->data =3D vcpu->arch.apf.msr2_val;
+		break;
 	case MSR_KVM_STEAL_TIME:
 		msr_info->data =3D vcpu->arch.st.msr_val;
 		break;
@@ -10367,6 +10402,16 @@ static int apf_get_user(struct kvm_vcpu *vcpu, u=
32 *val)
 				      sizeof(u32));
 }
=20
+static bool apf_slot_free(struct kvm_vcpu *vcpu)
+{
+	u32 val;
+
+	if (apf_get_user(vcpu, &val))
+		return false;
+
+	return !val;
+}
+
 static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->arch.apf.delivery_as_pf_vmexit && is_guest_mode(vcpu))
@@ -10382,11 +10427,23 @@ static bool kvm_can_deliver_async_pf(struct kvm=
_vcpu *vcpu)
=20
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * TODO: when we are injecting a 'page present' event with an interrupt
+	 * we may ignore pending exceptions.
+	 */
 	if (unlikely(!lapic_in_kernel(vcpu) ||
 		     kvm_event_needs_reinjection(vcpu) ||
 		     vcpu->arch.exception.pending))
 		return false;
=20
+	/*'
+	 * Regardless of the type of event we're trying to deliver, we need to
+	 * check that the previous even was already consumed, this may not be
+	 * the case with interrupt based delivery.
+	 */
+	if (vcpu->arch.apf.delivery_as_int && !apf_slot_free(vcpu))
+		return false;
+
 	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
 		return false;
=20
@@ -10441,6 +10498,8 @@ void kvm_arch_async_page_present(struct kvm_vcpu =
*vcpu,
=20
 	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
 	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY, work->arch.token)) {
+		if (!vcpu->arch.apf.delivery_as_int) {
+			/* Page ready delivery via #PF */
 			fault.vector =3D PF_VECTOR;
 			fault.error_code_valid =3D true;
 			fault.error_code =3D 0;
@@ -10448,6 +10507,16 @@ void kvm_arch_async_page_present(struct kvm_vcpu=
 *vcpu,
 			fault.address =3D work->arch.token;
 			fault.async_page_fault =3D true;
 			kvm_inject_page_fault(vcpu, &fault);
+		} else if (vcpu->arch.apf.msr2_val & KVM_ASYNC_PF2_ENABLED) {
+			/* Page ready delivery via interrupt */
+			struct kvm_lapic_irq irq =3D {
+				.delivery_mode =3D APIC_DM_FIXED,
+				.vector =3D vcpu->arch.apf.vec
+			};
+
+			/* Assuming LAPIC is enabled */
+			kvm_apic_set_irq(vcpu, &irq, NULL);
+		}
 	}
 	vcpu->arch.apf.halted =3D false;
 	vcpu->arch.mp_state =3D KVM_MP_STATE_RUNNABLE;
--=20
2.25.3

