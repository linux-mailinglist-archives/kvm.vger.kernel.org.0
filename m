Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1320B2F4D52
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbhAMOjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:39:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbhAMOjC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:39:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610548655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zFegbZ8VIySHLMToNbdDNoKbdi76V3o4oYA5DypWYlw=;
        b=Da35mXV/PUUXWF6+EUdfwXqePBgP2JREqPrk4g73hWJ4+lAZFFjYlo+KfwG2Qotkv+Ca5+
        cR6jzLRWsPDIG0Yq/5VGqFDq9ApNuHzw93Ta+Ntwm6LSfSkLg8OnIuUxfrVAOKYSq9SUwf
        EJEBCA6j7EIDnM5pf4KD1AV5HgUzS7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-edAREljXOv2fTcYG-QUMPA-1; Wed, 13 Jan 2021 09:37:34 -0500
X-MC-Unique: edAREljXOv2fTcYG-QUMPA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA2B080A5C8;
        Wed, 13 Jan 2021 14:37:32 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66D565C730;
        Wed, 13 Jan 2021 14:37:31 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 4/7] KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context
Date:   Wed, 13 Jan 2021 15:37:18 +0100
Message-Id: <20210113143721.328594-5-vkuznets@redhat.com>
In-Reply-To: <20210113143721.328594-1-vkuznets@redhat.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 arch/x86/kvm/hyperv.c  | 18 +++++++++++-------
 arch/x86/kvm/hyperv.h  | 10 ++++++++++
 arch/x86/kvm/lapic.c   |  6 ++++--
 arch/x86/kvm/vmx/vmx.c |  4 +---
 arch/x86/kvm/x86.c     |  7 +++++--
 5 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 82f51346118f..77deaadb8575 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -141,10 +141,10 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct kvm *kvm, u32 vpidx)
 		return NULL;
 
 	vcpu = kvm_get_vcpu(kvm, vpidx);
-	if (vcpu && vcpu_to_hv_vcpu(vcpu)->vp_index == vpidx)
+	if (vcpu && vcpu_to_hv_vpindex(vcpu) == vpidx)
 		return vcpu;
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		if (vcpu_to_hv_vcpu(vcpu)->vp_index == vpidx)
+		if (vcpu_to_hv_vpindex(vcpu) == vpidx)
 			return vcpu;
 	return NULL;
 }
@@ -377,9 +377,8 @@ static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 		break;
 	}
 
-	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id,
-				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr,
-				    *pdata);
+	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id, vcpu_to_hv_vpindex(vcpu),
+				    msr, *pdata);
 
 	return 0;
 }
@@ -806,6 +805,9 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu)
 	u64 time_now, exp_time;
 	int i;
 
+	if (!hv_vcpu)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
 		if (test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap)) {
 			stimer = &hv_vcpu->stimer[i];
@@ -842,6 +844,9 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
 
+	if (!hv_vcpu)
+		return false;
+
 	if (!(hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
 		return false;
 	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
@@ -1485,8 +1490,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 
 	bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (test_bit(vcpu_to_hv_vcpu(vcpu)->vp_index,
-			     (unsigned long *)vp_bitmap))
+		if (test_bit(vcpu_to_hv_vpindex(vcpu), (unsigned long *)vp_bitmap))
 			__set_bit(i, vcpu_bitmap);
 	}
 	return vcpu_bitmap;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 6300038e7a52..9ec7d686145a 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -78,6 +78,13 @@ static inline struct kvm_hv_syndbg *vcpu_to_hv_syndbg(struct kvm_vcpu *vcpu)
 	return &vcpu->kvm->arch.hyperv.hv_syndbg;
 }
 
+static inline u32 vcpu_to_hv_vpindex(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
+
+	return hv_vcpu ? hv_vcpu->vp_index : kvm_vcpu_get_idx(vcpu);
+}
+
 int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host);
 int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host);
 
@@ -116,6 +123,9 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
 
+	if (!hv_vcpu)
+		return false;
+
 	return !bitmap_empty(hv_vcpu->stimer_pending_bitmap,
 			     HV_SYNIC_STIMER_COUNT);
 }
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3136e05831cf..473c187263ca 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1245,7 +1245,8 @@ static int apic_set_eoi(struct kvm_lapic *apic)
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
 
-	if (test_bit(vector, vcpu_to_synic(apic->vcpu)->vec_bitmap))
+	if (vcpu_to_hv_vcpu(apic->vcpu) &&
+	    test_bit(vector, vcpu_to_synic(apic->vcpu)->vec_bitmap))
 		kvm_hv_synic_send_eoi(apic->vcpu, vector);
 
 	kvm_ioapic_send_eoi(apic, vector);
@@ -2512,7 +2513,8 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	 */
 
 	apic_clear_irr(vector, apic);
-	if (test_bit(vector, vcpu_to_synic(vcpu)->auto_eoi_bitmap)) {
+	if (vcpu_to_hv_vcpu(vcpu) &&
+	    test_bit(vector, vcpu_to_synic(vcpu)->auto_eoi_bitmap)) {
 		/*
 		 * For auto-EOI interrupts, there might be another pending
 		 * interrupt above PPR, so check whether to raise another
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7fe09b69a465..c19673a5b1bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6734,12 +6734,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs)) {
-		struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
-
 		current_evmcs->hv_clean_fields |=
 			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
-		current_evmcs->hv_vp_id = hv_vcpu->vp_index;
+		current_evmcs->hv_vp_id = vcpu_to_hv_vpindex(vcpu);
 	}
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 30fbbf53ff1e..fa077b47c0ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8727,8 +8727,11 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
 		return;
 
-	bitmap_or((ulong *)eoi_exit_bitmap, vcpu->arch.ioapic_handled_vectors,
-		  vcpu_to_synic(vcpu)->vec_bitmap, 256);
+	if (vcpu_to_hv_vcpu(vcpu))
+		bitmap_or((ulong *)eoi_exit_bitmap,
+			  vcpu->arch.ioapic_handled_vectors,
+			  vcpu_to_synic(vcpu)->vec_bitmap, 256);
+
 	kvm_x86_ops.load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
-- 
2.29.2

