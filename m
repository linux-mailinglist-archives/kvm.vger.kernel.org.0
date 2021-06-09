Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593F43A18A8
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhFIPLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:11:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235942AbhFIPL2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623251369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=124tuo5AwHCewOI3xtuEketWUcJ7rdZivpkSkrifopc=;
        b=fXqItI5cpz+oLvn0Z7hfY1tNBEAo7CZhNNVTNoNQKJTmvrhs8JZkGYJUx0n1RcpZrOpwOV
        zVyVwwKEWfdIddSTuJM6e6AJllsTPoEPjQCtOycVsDfmSTqQE5LPpQAO3mEozu5YZWAxqD
        cvzXxjxuJIZ1zvER6ackW/YrFJksIGY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-Ny_silFTNqK24--ImBdxnw-1; Wed, 09 Jun 2021 11:09:28 -0400
X-MC-Unique: Ny_silFTNqK24--ImBdxnw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3782F8030A0;
        Wed,  9 Jun 2021 15:09:27 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E3C6620DE;
        Wed,  9 Jun 2021 15:09:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in use
Date:   Wed,  9 Jun 2021 17:09:11 +0200
Message-Id: <20210609150911.1471882-5-vkuznets@redhat.com>
In-Reply-To: <20210609150911.1471882-1-vkuznets@redhat.com>
References: <20210609150911.1471882-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
however, possible to track whether the feature was actually used by the
guest and only inhibit APICv/AVIC when needed.

TLFS suggests a dedicated 'HV_DEPRECATING_AEOI_RECOMMENDED' flag to let
Windows know that AutoEOI feature should be avoided. While it's up to
KVM userspace to set the flag, KVM can help a bit by exposing global
APICv/AVIC enablement: in case APICv/AVIC usage is impossible, AutoEOI
is still preferred.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++
 arch/x86/kvm/hyperv.c           | 51 +++++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ed4e2aae13d1..01ee8f29d6e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -91,6 +91,8 @@
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_APICV_INPROGRESS \
+	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -936,8 +938,13 @@ struct kvm_hv {
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
 
+	/* How many SynICs use 'AutoEOI' feature */
+	atomic_t synic_auto_eoi_used;
+
 	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
+
+	struct work_struct apic_update_work;
 };
 
 struct msr_bitmap_range {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f00830e5202f..08cfc9ec1ef2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -84,9 +84,32 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
 	return false;
 }
 
+static void hv_apicv_update_work(struct work_struct *work)
+{
+	struct kvm_hv *hv = container_of(work, struct kvm_hv,
+					 apic_update_work);
+	struct kvm_arch *ka = container_of(hv, struct kvm_arch,
+					   hyperv);
+	struct kvm *kvm = container_of(ka, struct kvm, arch);
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	mutex_lock(&kvm->lock);
+	kvm_request_apicv_update(kvm, atomic_read(&hv->synic_auto_eoi_used) == 0,
+				 APICV_INHIBIT_REASON_HYPERV);
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_clear_request(KVM_REQ_APICV_INPROGRESS, vcpu);
+	mutex_unlock(&kvm->lock);
+}
+
 static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 				int vector)
 {
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
+	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
+	int auto_eoi_old, auto_eoi_new;
+	bool apicv_update_needed = false;
+
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
 		return;
 
@@ -95,10 +118,28 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	else
 		__clear_bit(vector, synic->vec_bitmap);
 
+	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
+
 	if (synic_has_vector_auto_eoi(synic, vector))
 		__set_bit(vector, synic->auto_eoi_bitmap);
 	else
 		__clear_bit(vector, synic->auto_eoi_bitmap);
+
+	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
+
+	/* Hyper-V SynIC auto EOI SINTs are not compatible with APICv */
+	if (!auto_eoi_old && auto_eoi_new) {
+		if (atomic_inc_return(&hv->synic_auto_eoi_used) == 1)
+			apicv_update_needed = true;
+	} else if (!auto_eoi_new && auto_eoi_old) {
+		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
+			apicv_update_needed = true;
+	}
+
+	if (apicv_update_needed) {
+		kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_APICV_INPROGRESS);
+		schedule_work(&hv->apic_update_work);
+	}
 }
 
 static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
@@ -931,12 +972,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 
 	synic = to_hv_synic(vcpu);
 
-	/*
-	 * Hyper-V SynIC auto EOI SINT's are
-	 * not compatible with APICV, so request
-	 * to deactivate APICV permanently.
-	 */
-	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
 	synic->active = true;
 	synic->dont_zero_synic_pages = dont_zero_synic_pages;
 	synic->control = HV_SYNIC_CONTROL_ENABLE;
@@ -2041,6 +2076,7 @@ void kvm_hv_init_vm(struct kvm *kvm)
 
 	mutex_init(&hv->hv_lock);
 	idr_init(&hv->conn_to_evt);
+	INIT_WORK(&hv->apic_update_work, hv_apicv_update_work);
 }
 
 void kvm_hv_destroy_vm(struct kvm *kvm)
@@ -2052,6 +2088,7 @@ void kvm_hv_destroy_vm(struct kvm *kvm)
 	idr_for_each_entry(&hv->conn_to_evt, eventfd, i)
 		eventfd_ctx_put(eventfd);
 	idr_destroy(&hv->conn_to_evt);
+	cancel_work_sync(&hv->apic_update_work);
 }
 
 static int kvm_hv_eventfd_assign(struct kvm *kvm, u32 conn_id, int fd)
@@ -2206,6 +2243,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 				ent->eax |= HV_X64_ENLIGHTENED_VMCS_RECOMMENDED;
 			if (!cpu_smt_possible())
 				ent->eax |= HV_X64_NO_NONARCH_CORESHARING;
+			if (enable_apicv)
+				ent->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
 			/*
 			 * Default number of spinlock retry attempts, matches
 			 * HyperV 2016.
-- 
2.31.1

