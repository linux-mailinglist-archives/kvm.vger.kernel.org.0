Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00984F842D
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345265AbiDGP7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245277AbiDGP7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B864ACB00E
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649347016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WDdz9vnPwvuDCbN/2oAJaj3E/KcoVTXw8a72wWSfBBk=;
        b=Lds9M7dSz1aqKX8+JGyzMdAv8Gyuy2C6YfFdc9WaFUY7z9CUbXp3mXMF5YgD/o/jCgotXB
        3XyU4Y+g6S4OoBS8dChERpF5774T9iW5pTiSWOoK01k7gWhQ5JicL7ykkzFEWw6Qa+JnjA
        +A5/8lEvdaGmTuFJh1KYkP1nGtr8KTE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-klRQrOj_Nm28kvg7MqKZSg-1; Thu, 07 Apr 2022 11:56:53 -0400
X-MC-Unique: klRQrOj_Nm28kvg7MqKZSg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 463BB3801EDF;
        Thu,  7 Apr 2022 15:56:53 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C3BD427852;
        Thu,  7 Apr 2022 15:56:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/31] KVM: x86: hyper-v: Introduce TLB flush ring
Date:   Thu,  7 Apr 2022 17:56:16 +0200
Message-Id: <20220407155645.940890-3-vkuznets@redhat.com>
In-Reply-To: <20220407155645.940890-1-vkuznets@redhat.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To allow flushing individual GVAs instead of always flushing the whole
VPID a per-vCPU structure to pass the requests is needed. Introduce a
simple ring write-locked structure to hold two types of entries:
individual GVA (GFN + up to 4095 following GFNs in the lower 12 bits)
and 'flush all'.

The queuing rule is: if there's not enough space on the ring to put
the request and leave at least 1 entry for 'flush all' - put 'flush
all' entry.

The size of the ring is arbitrary set to '16'.

Note, kvm_hv_flush_tlb() only queues 'flush all' entries for now so
there's very small functional change but the infrastructure is
prepared to handle individual GVA flush requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 16 +++++++
 arch/x86/kvm/hyperv.c           | 74 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h           | 13 ++++++
 arch/x86/kvm/x86.c              |  7 ++--
 arch/x86/kvm/x86.h              |  1 +
 5 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 488934fadc3a..15d798fe280d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -583,6 +583,20 @@ struct kvm_vcpu_hv_synic {
 	bool dont_zero_synic_pages;
 };
 
+#define KVM_HV_TLB_FLUSH_RING_SIZE (16)
+
+struct kvm_vcpu_hv_tlbflush_entry {
+	u64 addr;
+	u64 flush_all:1;
+	u64 pad:63;
+};
+
+struct kvm_vcpu_hv_tlbflush_ring {
+	int read_idx, write_idx;
+	spinlock_t write_lock;
+	struct kvm_vcpu_hv_tlbflush_entry entries[KVM_HV_TLB_FLUSH_RING_SIZE];
+};
+
 /* Hyper-V per vcpu emulation context */
 struct kvm_vcpu_hv {
 	struct kvm_vcpu *vcpu;
@@ -602,6 +616,8 @@ struct kvm_vcpu_hv {
 		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
 		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
 	} cpuid_cache;
+
+	struct kvm_vcpu_hv_tlbflush_ring tlb_flush_ring;
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b60bad29caf8..81c44e0eadf9 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -29,6 +29,7 @@
 #include <linux/kvm_host.h>
 #include <linux/highmem.h>
 #include <linux/sched/cputime.h>
+#include <linux/spinlock.h>
 #include <linux/eventfd.h>
 
 #include <asm/apicdef.h>
@@ -954,6 +955,8 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 
 	hv_vcpu->vp_index = vcpu->vcpu_idx;
 
+	spin_lock_init(&hv_vcpu->tlb_flush_ring.write_lock);
+
 	return 0;
 }
 
@@ -1789,6 +1792,65 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
 			      var_cnt * sizeof(*sparse_banks));
 }
 
+static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
+					 int read_idx, int write_idx)
+{
+	if (write_idx >= read_idx)
+		return KVM_HV_TLB_FLUSH_RING_SIZE - (write_idx - read_idx) - 1;
+
+	return read_idx - write_idx - 1;
+}
+
+static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	int ring_free, write_idx, read_idx;
+	unsigned long flags;
+
+	if (!hv_vcpu)
+		return;
+
+	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
+
+	spin_lock_irqsave(&tlb_flush_ring->write_lock, flags);
+
+	read_idx = READ_ONCE(tlb_flush_ring->read_idx);
+	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
+
+	ring_free = hv_tlb_flush_ring_free(hv_vcpu, read_idx, write_idx);
+	/* Full ring always contains 'flush all' entry */
+	if (!ring_free)
+		goto out_unlock;
+
+	tlb_flush_ring->entries[write_idx].addr = 0;
+	tlb_flush_ring->entries[write_idx].flush_all = 1;
+	/*
+	 * Advance write index only after filling in the entry to
+	 * synchronize with lockless reader.
+	 */
+	smp_wmb();
+	tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
+
+out_unlock:
+	spin_unlock_irqrestore(&tlb_flush_ring->write_lock, flags);
+}
+
+void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	kvm_vcpu_flush_tlb_guest(vcpu);
+
+	if (!hv_vcpu)
+		return;
+
+	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
+
+	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
+}
+
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1797,6 +1859,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
+	struct kvm_vcpu *v;
+	unsigned long i;
 	bool all_cpus;
 
 	/*
@@ -1876,10 +1940,20 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
 	if (all_cpus) {
+		kvm_for_each_vcpu(i, v, kvm)
+			hv_tlb_flush_ring_enqueue(v);
+
 		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
 	} else {
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
 
+		for_each_set_bit(i, vcpu_mask, KVM_MAX_VCPUS) {
+			v = kvm_get_vcpu(kvm, i);
+			if (!v)
+				continue;
+			hv_tlb_flush_ring_enqueue(v);
+		}
+
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
 	}
 
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index da2737f2a956..6847caeaaf84 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -147,4 +147,17 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
 
+
+static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!hv_vcpu)
+		return;
+
+	hv_vcpu->tlb_flush_ring.read_idx = hv_vcpu->tlb_flush_ring.write_idx;
+}
+void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
+
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c54f6804b7b..2074d52b0666 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3305,7 +3305,7 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_flush_tlb_all)(vcpu);
 }
 
-static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
+void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
 
@@ -3343,11 +3343,12 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
 		kvm_vcpu_flush_tlb_guest(vcpu);
-		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+			kvm_hv_vcpu_empty_flush_tlb(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
-		kvm_vcpu_flush_tlb_guest(vcpu);
+		kvm_hv_vcpu_flush_tlb(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index aa86abad914d..ed5c67b5d086 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -58,6 +58,7 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 
 #define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
 
+void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu);
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
-- 
2.35.1

