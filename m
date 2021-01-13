Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEAC2F4D54
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbhAMOjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:39:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726868AbhAMOjI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610548661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfNrpkKcMuKeMITHCt1E+wAp1t3V4G3JUZuVhHSG9Cw=;
        b=SSQde7VPY3P0zjld7dz3hmdoZGxheP6O5zgsWebYyPdfaL+5U2ccvN8eQoFrUPMkPiAs5+
        mjm+Sr2NZIbpRBT8vbU1B7gDS6IqF7AJ+RgQfnhJQu6jcRPjTldBwpE5FNSsBjrAIu3eAg
        dTmIxx7CrV0EBtEzY9wTZC3/ge1agOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-DPFeR_zFPN6s4ddo8Un6XA-1; Wed, 13 Jan 2021 09:37:38 -0500
X-MC-Unique: DPFeR_zFPN6s4ddo8Un6XA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A7B1107ACFC;
        Wed, 13 Jan 2021 14:37:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 843AD5C3E4;
        Wed, 13 Jan 2021 14:37:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 6/7] KVM: x86: hyper-v: Make Hyper-V emulation enablement conditional
Date:   Wed, 13 Jan 2021 15:37:20 +0100
Message-Id: <20210113143721.328594-7-vkuznets@redhat.com>
In-Reply-To: <20210113143721.328594-1-vkuznets@redhat.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V emulation is enabled in KVM unconditionally. This is bad at least
from security standpoint as it is an extra attack surface. Ideally, there
should be a per-VM capability explicitly enabled by VMM but currently it
is not the case and we can't mandate one without breaking backwards
compatibility. We can, however, check guest visible CPUIDs and only enable
Hyper-V emulation when "Hv#1" interface was exposed in
HYPERV_CPUID_INTERFACE.

Note, VMMs are free to act in any sequence they like, e.g. they can try
to set MSRs first and CPUIDs later so we still need to allow the host
to read/write Hyper-V specific MSRs unconditionally.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++++----
 arch/x86/kvm/hyperv.h           |  3 ++-
 arch/x86/kvm/x86.c              |  2 +-
 5 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 94d00926b7ad..c27cbe3baccc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -718,6 +718,7 @@ struct kvm_vcpu_arch {
 	/* used for guest single stepping over the given code position */
 	unsigned long singlestep_rip;
 
+	bool hyperv_enabled;
 	struct kvm_vcpu_hv *hyperv;
 
 	cpumask_var_t wbinvd_dirty_mask;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 13036cf0b912..3768491ee67d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -181,6 +181,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
+	kvm_hv_set_cpuid(vcpu);
+
 	/* Invoke the vendor callback only after the above state is updated. */
 	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 }
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index df7101b721e7..81166401c353 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -36,6 +36,9 @@
 #include "trace.h"
 #include "irq.h"
 
+/* "Hv#1" signature */
+#define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
+
 #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
 
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
@@ -1457,6 +1460,9 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
 
 int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
+	if (!host && !vcpu->arch.hyperv_enabled)
+		return 1;
+
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
 
@@ -1470,6 +1476,9 @@ int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 
 int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 {
+	if (!host && !vcpu->arch.hyperv_enabled)
+		return 1;
+
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
 
@@ -1684,9 +1693,20 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 	return HV_STATUS_SUCCESS;
 }
 
-bool kvm_hv_hypercall_enabled(struct kvm *kvm)
+void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_INTERFACE, 0);
+	if (entry && entry->eax == HYPERV_CPUID_SIGNATURE_EAX)
+		vcpu->arch.hyperv_enabled = true;
+	else
+		vcpu->arch.hyperv_enabled = false;
+}
+
+bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu)
 {
-	return READ_ONCE(kvm->arch.hyperv.hv_guest_os_id) != 0;
+	return vcpu->arch.hyperv_enabled && vcpu->kvm->arch.hyperv.hv_guest_os_id;
 }
 
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
@@ -2015,8 +2035,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			break;
 
 		case HYPERV_CPUID_INTERFACE:
-			memcpy(signature, "Hv#1\0\0\0\0\0\0\0\0", 12);
-			ent->eax = signature[0];
+			ent->eax = HYPERV_CPUID_SIGNATURE_EAX;
 			break;
 
 		case HYPERV_CPUID_VERSION:
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index a19e298463d0..070a301738ec 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -87,7 +87,7 @@ static inline u32 vcpu_to_hv_vpindex(struct kvm_vcpu *vcpu)
 int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host);
 int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host);
 
-bool kvm_hv_hypercall_enabled(struct kvm *kvm);
+bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu);
 int kvm_hv_hypercall(struct kvm_vcpu *vcpu);
 
 void kvm_hv_irq_routing_update(struct kvm *kvm);
@@ -136,6 +136,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
+void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e08209f570f0..58dd98b3c95c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8088,7 +8088,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
 
-	if (kvm_hv_hypercall_enabled(vcpu->kvm))
+	if (kvm_hv_hypercall_enabled(vcpu))
 		return kvm_hv_hypercall(vcpu);
 
 	nr = kvm_rax_read(vcpu);
-- 
2.29.2

