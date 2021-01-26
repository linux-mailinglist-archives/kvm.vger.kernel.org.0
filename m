Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85505303F62
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405448AbhAZNzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:55:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405368AbhAZNuB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GaCFbLTM7fw2zqOB3QeGefJan4EFCDu3Rwcrtle+qUo=;
        b=SsF/QSFOzANpjGkr4rmxkQyTlpekxWh+RA0WVqpZBTztgn4mQ/WMOo9WZcCkmcQVvplEYV
        O2houl/BGYi0uyOiqQ8SVTKqfnGwYcLruJe8UHfcRB41m5wl+Uns1Ate9DMfR/PJgpO9NK
        Uld4QBfXOXWhWLbzzHmQ8A9l0jGE57w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-Ilz1zf5lMhKapaZcFanGjA-1; Tue, 26 Jan 2021 08:48:30 -0500
X-MC-Unique: Ilz1zf5lMhKapaZcFanGjA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 031B115721;
        Tue, 26 Jan 2021 13:48:29 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 964105D9C2;
        Tue, 26 Jan 2021 13:48:27 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 05/15] KVM: x86: hyper-v: Rename vcpu_to_synic()/synic_to_vcpu()
Date:   Tue, 26 Jan 2021 14:48:06 +0100
Message-Id: <20210126134816.1880136-6-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu_to_synic()'s argument is almost always 'vcpu' so there's no need to
have an additional prefix. Also, as this is used outside of hyper-v
emulation code, add '_hv_' part to make it clear what this s. This makes
the naming more consistent with to_hv_vcpu().

Rename synic_to_vcpu() to hv_synic_to_vcpu() for consistency.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 30 +++++++++++++++---------------
 arch/x86/kvm/hyperv.h |  4 ++--
 arch/x86/kvm/lapic.c  |  4 ++--
 arch/x86/kvm/x86.c    |  2 +-
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1a3bac5de897..5679dca610a5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -128,7 +128,7 @@ static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
 	synic_update_vector(synic, vector);
 
 	/* Load SynIC vectors into EOI exit bitmap */
-	kvm_make_request(KVM_REQ_SCAN_IOAPIC, synic_to_vcpu(synic));
+	kvm_make_request(KVM_REQ_SCAN_IOAPIC, hv_synic_to_vcpu(synic));
 	return 0;
 }
 
@@ -157,14 +157,14 @@ static struct kvm_vcpu_hv_synic *synic_get(struct kvm *kvm, u32 vpidx)
 	vcpu = get_vcpu_by_vpidx(kvm, vpidx);
 	if (!vcpu)
 		return NULL;
-	synic = vcpu_to_synic(vcpu);
+	synic = to_hv_synic(vcpu);
 	return (synic->active) ? synic : NULL;
 }
 
 static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct kvm_vcpu_hv_stimer *stimer;
 	int gsi, idx;
@@ -189,7 +189,7 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
 
 static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
 {
-	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
 
 	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNIC;
@@ -204,7 +204,7 @@ static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
 static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 			 u32 msr, u64 data, bool host)
 {
-	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	int ret;
 
 	if (!synic->active && !host)
@@ -421,7 +421,7 @@ static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
 
 static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 {
-	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	struct kvm_lapic_irq irq;
 	int ret, vector;
 
@@ -457,7 +457,7 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vpidx, u32 sint)
 
 void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector)
 {
-	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 	int i;
 
 	trace_kvm_hv_synic_send_eoi(vcpu->vcpu_id, vector);
@@ -634,7 +634,7 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 	union hv_stimer_config new_config = {.as_uint64 = config},
 		old_config = {.as_uint64 = stimer->config.as_uint64};
 	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
-	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
 	if (!synic->active && !host)
 		return 1;
@@ -658,7 +658,7 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 			    bool host)
 {
 	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
-	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
 	if (!synic->active && !host)
 		return 1;
@@ -694,7 +694,7 @@ static int stimer_get_count(struct kvm_vcpu_hv_stimer *stimer, u64 *pcount)
 static int synic_deliver_msg(struct kvm_vcpu_hv_synic *synic, u32 sint,
 			     struct hv_message *src_msg, bool no_retry)
 {
-	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	int msg_off = offsetof(struct hv_message_page, sint_message[sint]);
 	gfn_t msg_page_gfn;
 	struct hv_message_header hv_hdr;
@@ -763,7 +763,7 @@ static int stimer_send_msg(struct kvm_vcpu_hv_stimer *stimer)
 
 	payload->expiration_time = stimer->exp_time;
 	payload->delivery_time = get_time_ref_counter(vcpu->kvm);
-	return synic_deliver_msg(vcpu_to_synic(vcpu),
+	return synic_deliver_msg(to_hv_synic(vcpu),
 				 stimer->config.sintx, msg,
 				 no_retry);
 }
@@ -901,7 +901,7 @@ void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 {
-	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+	struct kvm_vcpu_hv_synic *synic = to_hv_synic(vcpu);
 
 	/*
 	 * Hyper-V SynIC auto EOI SINT's are
@@ -1291,7 +1291,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	case HV_X64_MSR_SIMP:
 	case HV_X64_MSR_EOM:
 	case HV_X64_MSR_SINT0 ... HV_X64_MSR_SINT15:
-		return synic_set_msr(vcpu_to_synic(vcpu), msr, data, host);
+		return synic_set_msr(to_hv_synic(vcpu), msr, data, host);
 	case HV_X64_MSR_STIMER0_CONFIG:
 	case HV_X64_MSR_STIMER1_CONFIG:
 	case HV_X64_MSR_STIMER2_CONFIG:
@@ -1403,7 +1403,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 	case HV_X64_MSR_SIMP:
 	case HV_X64_MSR_EOM:
 	case HV_X64_MSR_SINT0 ... HV_X64_MSR_SINT15:
-		return synic_get_msr(vcpu_to_synic(vcpu), msr, pdata, host);
+		return synic_get_msr(to_hv_synic(vcpu), msr, pdata, host);
 	case HV_X64_MSR_STIMER0_CONFIG:
 	case HV_X64_MSR_STIMER1_CONFIG:
 	case HV_X64_MSR_STIMER2_CONFIG:
@@ -1793,7 +1793,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		fallthrough;	/* maybe userspace knows this conn_id */
 	case HVCALL_POST_MESSAGE:
 		/* don't bother userspace if it has no way to handle it */
-		if (unlikely(rep || !vcpu_to_synic(vcpu)->active)) {
+		if (unlikely(rep || !to_hv_synic(vcpu)->active)) {
 			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
 			break;
 		}
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index f5e0d3d1d54a..d47b3f045a25 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -63,12 +63,12 @@ static inline struct kvm_vcpu *hv_vcpu_to_vcpu(struct kvm_vcpu_hv *hv_vcpu)
 	return container_of(arch, struct kvm_vcpu, arch);
 }
 
-static inline struct kvm_vcpu_hv_synic *vcpu_to_synic(struct kvm_vcpu *vcpu)
+static inline struct kvm_vcpu_hv_synic *to_hv_synic(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.hyperv.synic;
 }
 
-static inline struct kvm_vcpu *synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
+static inline struct kvm_vcpu *hv_synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
 {
 	return hv_vcpu_to_vcpu(container_of(synic, struct kvm_vcpu_hv, synic));
 }
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 43cceadd073e..53bdea2d5a81 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1245,7 +1245,7 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
 
-	if (test_bit(vector, vcpu_to_synic(apic->vcpu)->vec_bitmap))
+	if (test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
 		kvm_hv_synic_send_eoi(apic->vcpu, vector);
 
 	kvm_ioapic_send_eoi(apic, vector);
@@ -2512,7 +2512,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	 */
 
 	apic_clear_irr(vector, apic);
-	if (test_bit(vector, vcpu_to_synic(vcpu)->auto_eoi_bitmap)) {
+	if (test_bit(vector, to_hv_synic(vcpu)->auto_eoi_bitmap)) {
 		/*
 		 * For auto-EOI interrupts, there might be another pending
 		 * interrupt above PPR, so check whether to raise another
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..0bf0672d4811 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8741,7 +8741,7 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 		return;
 
 	bitmap_or((ulong *)eoi_exit_bitmap, vcpu->arch.ioapic_handled_vectors,
-		  vcpu_to_synic(vcpu)->vec_bitmap, 256);
+		  to_hv_synic(vcpu)->vec_bitmap, 256);
 	kvm_x86_ops.load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
-- 
2.29.2

