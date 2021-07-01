Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E154E3B942D
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 17:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhGAPno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 11:43:44 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33432 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhGAPnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 11:43:41 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4F4421FD4D;
        Thu,  1 Jul 2021 15:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=st/JMu2exWb513R8q97lbMHUEjIX1u+rpFKOi8ANmmY=;
        b=ACaONt7QGkrrNovBmtb05ZnlMp0u80vR3os8e2TmVLBLE/niDF59AD/tLfa1duOPCgVLk+
        NK9PaAP/R2joLoZgbmjTHqzQRuAEwSdHz2ZIBnB5JvVXuLa2oUP23kmL133kcx3fSohjEb
        u4AtPdUIzXb605BaKKvt4pCezb1YR90=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id E706211CD5;
        Thu,  1 Jul 2021 15:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=st/JMu2exWb513R8q97lbMHUEjIX1u+rpFKOi8ANmmY=;
        b=ACaONt7QGkrrNovBmtb05ZnlMp0u80vR3os8e2TmVLBLE/niDF59AD/tLfa1duOPCgVLk+
        NK9PaAP/R2joLoZgbmjTHqzQRuAEwSdHz2ZIBnB5JvVXuLa2oUP23kmL133kcx3fSohjEb
        u4AtPdUIzXb605BaKKvt4pCezb1YR90=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 8LUdNxXi3WAOFwAALh3uQQ
        (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:09 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/6] x86/kvm: introduce per cpu vcpu masks
Date:   Thu,  1 Jul 2021 17:41:03 +0200
Message-Id: <20210701154105.23215-5-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
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
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/hyperv.c           | 25 ++++++++++++++++++-------
 arch/x86/kvm/irq_comm.c         |  9 +++++++--
 arch/x86/kvm/x86.c              | 20 +++++++++++++++++++-
 4 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88b1ff898fb9..79138c91f83d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1514,6 +1514,13 @@ extern u64  kvm_default_tsc_scaling_ratio;
 extern bool kvm_has_bus_lock_exit;
 /* maximum vcpu-id */
 extern unsigned int max_vcpu_id;
+/* per cpu vcpu bitmasks (disable preemption during usage) */
+extern unsigned long __percpu *kvm_pcpu_vcpu_mask;
+#define KVM_VCPU_MASK_SZ	\
+	(sizeof(*kvm_pcpu_vcpu_mask) * BITS_TO_LONGS(KVM_MAX_VCPUS))
+extern u64 __percpu *kvm_hv_vp_bitmap;
+#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
+#define KVM_HV_VPMAP_SZ		(sizeof(u64) * KVM_HV_MAX_SPARSE_VCPU_SET_BITS)
 
 extern u64 kvm_mce_cap_supported;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f00830e5202f..32d31a7334fa 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -40,7 +40,7 @@
 /* "Hv#1" signature */
 #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
 
-#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
+u64 __percpu *kvm_hv_vp_bitmap;
 
 static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
 				bool vcpu_kick);
@@ -1612,8 +1612,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 	struct kvm_vcpu *vcpu;
 	int i, bank, sbank = 0;
 
-	memset(vp_bitmap, 0,
-	       KVM_HV_MAX_SPARSE_VCPU_SET_BITS * sizeof(*vp_bitmap));
+	memset(vp_bitmap, 0, KVM_HV_VPMAP_SZ);
 	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
 			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS)
 		vp_bitmap[bank] = sparse_banks[sbank++];
@@ -1637,8 +1636,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
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
@@ -1696,6 +1695,10 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
 
 	cpumask_clear(&hv_vcpu->tlb_flush);
 
+	preempt_disable();
+	vcpu_bitmap = this_cpu_ptr(kvm_pcpu_vcpu_mask);
+	vp_bitmap = this_cpu_ptr(kvm_hv_vp_bitmap);
+
 	vcpu_mask = all_cpus ? NULL :
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
 					vp_bitmap, vcpu_bitmap);
@@ -1707,6 +1710,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool
 	kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH,
 				    NULL, vcpu_mask, &hv_vcpu->tlb_flush);
 
+	preempt_enable();
+
 ret_success:
 	/* We always do full TLB flush, set rep_done = rep_cnt. */
 	return (u64)HV_STATUS_SUCCESS |
@@ -1738,8 +1743,8 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
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
@@ -1796,12 +1801,18 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
+	preempt_disable();
+	vcpu_bitmap = this_cpu_ptr(kvm_pcpu_vcpu_mask);
+	vp_bitmap = this_cpu_ptr(kvm_hv_vp_bitmap);
+
 	vcpu_mask = all_cpus ? NULL :
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
 					vp_bitmap, vcpu_bitmap);
 
 	kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
 
+	preempt_enable();
+
 ret_success:
 	return HV_STATUS_SUCCESS;
 }
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d5b72a08e566..be4424ddcd8f 100644
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
+	preempt_disable();
+	dest_vcpu_bitmap = this_cpu_ptr(kvm_pcpu_vcpu_mask);
+
+	memset(dest_vcpu_bitmap, 0, KVM_VCPU_MASK_SZ);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!kvm_apic_present(vcpu))
@@ -93,6 +96,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		lowest = kvm_get_vcpu(kvm, idx);
 	}
 
+	preempt_enable();
+
 	if (lowest)
 		r = kvm_apic_set_irq(lowest, irq, dest_map);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0390d90fd360..3af398ef1fc9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -180,6 +180,8 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 unsigned int __read_mostly max_vcpu_id = KVM_DEFAULT_MAX_VCPU_ID;
 module_param(max_vcpu_id, uint, S_IRUGO);
 
+unsigned long __percpu *kvm_pcpu_vcpu_mask;
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -10646,9 +10648,18 @@ int kvm_arch_hardware_setup(void *opaque)
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
@@ -10676,11 +10687,18 @@ int kvm_arch_hardware_setup(void *opaque)
 
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

