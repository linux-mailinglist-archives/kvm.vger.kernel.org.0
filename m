Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CD140002F
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 15:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349439AbhICNJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 09:09:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36554 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349415AbhICNJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 09:09:29 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 446CB22607;
        Fri,  3 Sep 2021 13:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630674508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=531henkeyKgzuafmFRtk1EJ9wnW4Rv50hZV6A27T0HI=;
        b=Qy/2sCOAOrb8rm3d1boyR9vTCyET7wQkI0kmquEV2GkxBPbPNqjB6faCFsSk13E/uvdUqJ
        dZHcayzkEVbDy76it4uovvfWEQxuLKOoDnWqPhP70/CzaV+wZxfPukXed6oQNlbL237dgh
        7pB/Bw7Qm57YG75m4hoBmCJsMduNg/I=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id B6E9C137D4;
        Fri,  3 Sep 2021 13:08:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id qPQeK0seMmHYOAAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 13:08:27 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     maz@kernel.org, ehabkost@redhat.com,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 3/6] x86/kvm: introduce per cpu vcpu masks
Date:   Fri,  3 Sep 2021 15:08:04 +0200
Message-Id: <20210903130808.30142-4-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210903130808.30142-1-jgross@suse.com>
References: <20210903130808.30142-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to support high vcpu numbers per guest don't use on stack
vcpu bitmasks. As all those currently used bitmasks are not used in
functions subject to recursion it is fairly easy to replace them with
percpu bitmasks.

Disable preemption while such a bitmask is being used in order to
avoid double usage in case we'd switch cpus.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- use local_lock() instead of preempt_disable() (Paolo Bonzini)
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++++
 arch/x86/kvm/hyperv.c           | 25 ++++++++++++++++++-------
 arch/x86/kvm/irq_comm.c         |  9 +++++++--
 arch/x86/kvm/x86.c              | 22 +++++++++++++++++++++-
 4 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3513edee8e22..a809a9e4fa5c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -15,6 +15,7 @@
 #include <linux/cpumask.h>
 #include <linux/irq_work.h>
 #include <linux/irq.h>
+#include <linux/local_lock.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
@@ -1591,6 +1592,15 @@ extern bool kvm_has_bus_lock_exit;
 /* maximum vcpu-id */
 unsigned int kvm_max_vcpu_id(void);
 
+/* per cpu vcpu bitmasks, protected by kvm_pcpu_mask_lock */
+DECLARE_PER_CPU(local_lock_t, kvm_pcpu_mask_lock);
+extern unsigned long __percpu *kvm_pcpu_vcpu_mask;
+#define KVM_VCPU_MASK_SZ	\
+	(sizeof(*kvm_pcpu_vcpu_mask) * BITS_TO_LONGS(KVM_MAX_VCPUS))
+extern u64 __percpu *kvm_hv_vp_bitmap;
+#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
+#define KVM_HV_VPMAP_SZ		(sizeof(u64) * KVM_HV_MAX_SPARSE_VCPU_SET_BITS)
+
 extern u64 kvm_mce_cap_supported;
 
 /*
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 41d2a53c5dea..680743e43c5b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -41,7 +41,7 @@
 /* "Hv#1" signature */
 #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
 
-#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
+u64 __percpu *kvm_hv_vp_bitmap;
 
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 				bool vcpu_kick);
@@ -1701,8 +1701,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 	struct kvm_vcpu *vcpu;
 	int i, bank, sbank = 0;
 
-	memset(vp_bitmap, 0,
-	       KVM_HV_MAX_SPARSE_VCPU_SET_BITS * sizeof(*vp_bitmap));
+	memset(vp_bitmap, 0, KVM_HV_VPMAP_SZ);
 	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
 			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS)
 		vp_bitmap[bank] = sparse_banks[sbank++];
@@ -1740,8 +1739,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
-	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+	u64 *vp_bitmap;
+	unsigned long *vcpu_bitmap;
 	unsigned long *vcpu_mask;
 	u64 valid_bank_mask;
 	u64 sparse_banks[64];
@@ -1821,6 +1820,10 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 
 	cpumask_clear(&hv_vcpu->tlb_flush);
 
+	local_lock(&kvm_pcpu_mask_lock);
+	vcpu_bitmap = this_cpu_ptr(kvm_pcpu_vcpu_mask);
+	vp_bitmap = this_cpu_ptr(kvm_hv_vp_bitmap);
+
 	vcpu_mask = all_cpus ? NULL :
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
 					vp_bitmap, vcpu_bitmap);
@@ -1832,6 +1835,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
 				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
 
+	local_unlock(&kvm_pcpu_mask_lock);
+
 ret_success:
 	/* We always do full TLB flush, set 'Reps completed' = 'Rep Count' */
 	return (u64)HV_STATUS_SUCCESS |
@@ -1862,8 +1867,8 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
-	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+	u64 *vp_bitmap;
+	unsigned long *vcpu_bitmap;
 	unsigned long *vcpu_mask;
 	unsigned long valid_bank_mask;
 	u64 sparse_banks[64];
@@ -1920,12 +1925,18 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
+	local_lock(&kvm_pcpu_mask_lock);
+	vcpu_bitmap = this_cpu_ptr(kvm_pcpu_vcpu_mask);
+	vp_bitmap = this_cpu_ptr(kvm_hv_vp_bitmap);
+
 	vcpu_mask = all_cpus ? NULL :
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
 					vp_bitmap, vcpu_bitmap);
 
 	kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
 
+	local_unlock(&kvm_pcpu_mask_lock);
+
 ret_success:
 	return HV_STATUS_SUCCESS;
 }
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d5b72a08e566..c331204de007 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -47,7 +47,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 {
 	int i, r = -1;
 	struct kvm_vcpu *vcpu, *lowest = NULL;
-	unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
+	unsigned long *dest_vcpu_bitmap;
 	unsigned int dest_vcpus = 0;
 
 	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
@@ -59,7 +59,10 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		irq->delivery_mode = APIC_DM_FIXED;
 	}
 
-	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
+	local_lock(&kvm_pcpu_mask_lock);
+	dest_vcpu_bitmap = this_cpu_ptr(kvm_pcpu_vcpu_mask);
+
+	memset(dest_vcpu_bitmap, 0, KVM_VCPU_MASK_SZ);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!kvm_apic_present(vcpu))
@@ -93,6 +96,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		lowest = kvm_get_vcpu(kvm, idx);
 	}
 
+	local_unlock(&kvm_pcpu_mask_lock);
+
 	if (lowest)
 		r = kvm_apic_set_irq(lowest, irq, dest_map);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b6f38f0b617..fd19b72a5733 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -213,6 +213,10 @@ unsigned int kvm_max_vcpu_id(void)
 }
 EXPORT_SYMBOL_GPL(kvm_max_vcpu_id);
 
+DEFINE_PER_CPU(local_lock_t, kvm_pcpu_mask_lock) =
+	INIT_LOCAL_LOCK(kvm_pcpu_mask_lock);
+unsigned long __percpu *kvm_pcpu_vcpu_mask;
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -11029,9 +11033,18 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
+	kvm_pcpu_vcpu_mask = __alloc_percpu(KVM_VCPU_MASK_SZ,
+					    sizeof(unsigned long));
+	kvm_hv_vp_bitmap = __alloc_percpu(KVM_HV_VPMAP_SZ, sizeof(u64));
+
+	if (!kvm_pcpu_vcpu_mask || !kvm_hv_vp_bitmap) {
+		r = -ENOMEM;
+		goto err;
+	}
+
 	r = ops->hardware_setup();
 	if (r != 0)
-		return r;
+		goto err;
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
@@ -11059,11 +11072,18 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	kvm_init_msr_list();
 	return 0;
+
+ err:
+	free_percpu(kvm_pcpu_vcpu_mask);
+	free_percpu(kvm_hv_vp_bitmap);
+	return r;
 }
 
 void kvm_arch_hardware_unsetup(void)
 {
 	static_call(kvm_x86_hardware_unsetup)();
+	free_percpu(kvm_pcpu_vcpu_mask);
+	free_percpu(kvm_hv_vp_bitmap);
 }
 
 int kvm_arch_check_processor_compat(void *opaque)
-- 
2.26.2

