Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4420303F65
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405568AbhAZNzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:55:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405416AbhAZNuM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 08:50:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611668926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hESohk3cFsQ4XGRhfkUEZh1T4r7TwhsXBnB9mG+/Ork=;
        b=JqVikisFNcaSg6sXOgEtHqPn8qD+G8SkJdQga8AQwWkZlI1XQGDQEtdJ2QjjlEL76cNwCm
        tXTqUFCesJVoI3+WiLmOs4MdGzT8lLxp+mYLQCZQKDmdOX1BEbVyVFmY84CSCbi5fbLm/i
        9Yvl3JSiOyB/qRcdhMF1Xa6PuzSoUWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-FQPnZMaJNjiTvx8th1qHzQ-1; Tue, 26 Jan 2021 08:48:42 -0500
X-MC-Unique: FQPnZMaJNjiTvx8th1qHzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A3B7801AB0;
        Tue, 26 Jan 2021 13:48:41 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0A475D9DC;
        Tue, 26 Jan 2021 13:48:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 11/15] KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context
Date:   Tue, 26 Jan 2021 14:48:12 +0100
Message-Id: <20210126134816.1880136-12-vkuznets@redhat.com>
In-Reply-To: <20210126134816.1880136-1-vkuznets@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, Hyper-V context is part of 'struct kvm_vcpu_arch' and is always
available. As a preparation to allocating it dynamically, check that it is
not NULL at call sites which can normally proceed without it i.e. the
behavior is identical to the situation when Hyper-V emulation is not being
used by the guest.

When Hyper-V context for a particular vCPU is not allocated, we may still
need to get 'vp_index' from there. E.g. in a hypothetical situation when
Hyper-V emulation was enabled on one CPU and wasn't on another, Hyper-V
style send-IPI hypercall may still be used. Luckily, vp_index is always
initialized to kvm_vcpu_get_idx() and can only be changed when Hyper-V
context is present. Introduce vcpu_to_hv_vpindex() helper for
simplification.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c  | 17 ++++++++++-------
 arch/x86/kvm/hyperv.h  | 10 ++++++++++
 arch/x86/kvm/lapic.c   |  5 +++--
 arch/x86/kvm/vmx/vmx.c |  4 +---
 arch/x86/kvm/x86.c     |  7 +++++--
 5 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 18e00fb46b15..2823473c84a2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -141,10 +141,10 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct kvm *kvm, u32 vpidx)
 		return NULL;
 
 	vcpu = kvm_get_vcpu(kvm, vpidx);
-	if (vcpu && to_hv_vcpu(vcpu)->vp_index == vpidx)
+	if (vcpu && to_hv_vpindex(vcpu) == vpidx)
 		return vcpu;
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		if (to_hv_vcpu(vcpu)->vp_index == vpidx)
+		if (to_hv_vpindex(vcpu) == vpidx)
 			return vcpu;
 	return NULL;
 }
@@ -376,9 +376,7 @@ static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 		break;
 	}
 
-	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id,
-				    to_hv_vcpu(vcpu)->vp_index, msr,
-				    *pdata);
+	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id, to_hv_vpindex(vcpu), msr, *pdata);
 
 	return 0;
 }
@@ -805,6 +803,9 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu)
 	u64 time_now, exp_time;
 	int i;
 
+	if (!hv_vcpu)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		if (test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap)) {
 			stimer = &hv_vcpu->stimer[i];
@@ -841,6 +842,9 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
+	if (!hv_vcpu)
+		return false;
+
 	if (!(hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
 		return false;
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
@@ -1486,8 +1490,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 
 	bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (test_bit(to_hv_vcpu(vcpu)->vp_index,
-			     (unsigned long *)vp_bitmap))
+		if (test_bit(to_hv_vpindex(vcpu), (unsigned long *)vp_bitmap))
 			__set_bit(i, vcpu_bitmap);
 	}
 	return vcpu_bitmap;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index be1e3f5d1df6..2258bcc34ada 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -83,6 +83,13 @@ static inline struct kvm_hv_syndbg *to_hv_syndbg(struct kvm_vcpu *vcpu)
 	return &vcpu->kvm->arch.hyperv.hv_syndbg;
 }
 
+static inline u32 to_hv_vpindex(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	return hv_vcpu ? hv_vcpu->vp_index : kvm_vcpu_get_idx(vcpu);
+}
+
 int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host);
 int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host);
 
@@ -121,6 +128,9 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
+	if (!hv_vcpu)
+		return false;
+
 	return !bitmap_empty(hv_vcpu->stimer_pending_bitmap,
 			     HV_SYNIC_STIMER_COUNT);
 }
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 53bdea2d5a81..843ce1bc3e1a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1245,7 +1245,8 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
 
-	if (test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
+	if (to_hv_vcpu(apic->vcpu) &&
+	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
 		kvm_hv_synic_send_eoi(apic->vcpu, vector);
 
 	kvm_ioapic_send_eoi(apic, vector);
@@ -2512,7 +2513,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	 */
 
 	apic_clear_irr(vector, apic);
-	if (test_bit(vector, to_hv_synic(vcpu)->auto_eoi_bitmap)) {
+	if (to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->auto_eoi_bitmap)) {
 		/*
 		 * For auto-EOI interrupts, there might be another pending
 		 * interrupt above PPR, so check whether to raise another
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 443878dd775c..6c72331d6bdf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6734,12 +6734,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs)) {
-		struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-
 		current_evmcs->hv_clean_fields |=
 			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
-		current_evmcs->hv_vp_id = hv_vcpu->vp_index;
+		current_evmcs->hv_vp_id = to_hv_vpindex(vcpu);
 	}
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c2b1f4260c6..0d5d36134093 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8740,8 +8740,11 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
 		return;
 
-	bitmap_or((ulong *)eoi_exit_bitmap, vcpu->arch.ioapic_handled_vectors,
-		  to_hv_synic(vcpu)->vec_bitmap, 256);
+	if (to_hv_vcpu(vcpu))
+		bitmap_or((ulong *)eoi_exit_bitmap,
+			  vcpu->arch.ioapic_handled_vectors,
+			  to_hv_synic(vcpu)->vec_bitmap, 256);
+
 	kvm_x86_ops.load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
-- 
2.29.2

