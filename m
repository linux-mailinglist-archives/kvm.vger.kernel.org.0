Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5352E5C0118
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiIUPZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiIUPY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:24:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F80C2A964
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663773893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ohqQoxcZ0UQSjxXC0U+9wm5bBqCfugP6+8i6XuSCqlU=;
        b=MSebS1qkcM7REVfHasK8IPCEXU466mCIchqlhbaNIoVYJtrtQeN4IlbRFjAQ9xRwHLYrU4
        KKC5a8LHcIb6301Y23VyAOBRxphOBm8zgY/B4llvg4A5j0NosDltUtXxrB0eIwUxkgjHRh
        cKk2DbyTt6Ue7yBx83us8XP6eOUkcHY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-WVLseelDP_Gxx3JSHKKlJg-1; Wed, 21 Sep 2022 11:24:50 -0400
X-MC-Unique: WVLseelDP_Gxx3JSHKKlJg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A3563C11732;
        Wed, 21 Sep 2022 15:24:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 499CE2166B2A;
        Wed, 21 Sep 2022 15:24:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 03/39] KVM: x86: hyper-v: Introduce TLB flush fifo
Date:   Wed, 21 Sep 2022 17:24:00 +0200
Message-Id: <20220921152436.3673454-4-vkuznets@redhat.com>
In-Reply-To: <20220921152436.3673454-1-vkuznets@redhat.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To allow flushing individual GVAs instead of always flushing the whole
VPID a per-vCPU structure to pass the requests is needed. Use standard
'kfifo' to queue two types of entries: individual GVA (GFN + up to 4095
following GFNs in the lower 12 bits) and 'flush all'.

The size of the fifo is arbitrary set to '16'.

Note, kvm_hv_flush_tlb() only queues 'flush all' entries for now and
kvm_hv_vcpu_flush_tlb() doesn't actually read the fifo just resets the
queue before doing full TLB flush so the functional change is very
small but the infrastructure is prepared to handle individual GVA
flush requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 20 ++++++++++++++
 arch/x86/kvm/hyperv.c           | 46 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h           | 16 ++++++++++++
 arch/x86/kvm/x86.c              |  8 +++---
 arch/x86/kvm/x86.h              |  1 +
 5 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 45c390c804f0..c97161436a9d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -25,6 +25,7 @@
 #include <linux/clocksource.h>
 #include <linux/irqbypass.h>
 #include <linux/hyperv.h>
+#include <linux/kfifo.h>
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -599,6 +600,23 @@ struct kvm_vcpu_hv_synic {
 	bool dont_zero_synic_pages;
 };
 
+/* The maximum number of entries on the TLB flush fifo. */
+#define KVM_HV_TLB_FLUSH_FIFO_SIZE (16)
+/*
+ * Note: the following 'magic' entry is made up by KVM to avoid putting
+ * anything besides GVA on the TLB flush fifo. It is theoretically possible
+ * to observe a request to flush 4095 PFNs starting from 0xfffffffffffff000
+ * which will look identical. KVM's action to 'flush everything' instead of
+ * flushing these particular addresses is, however, fully legitimate as
+ * flushing more than requested is always OK.
+ */
+#define KVM_HV_TLB_FLUSHALL_ENTRY  ((u64)-1)
+
+struct kvm_vcpu_hv_tlb_flush_fifo {
+	spinlock_t write_lock;
+	DECLARE_KFIFO(entries, u64, KVM_HV_TLB_FLUSH_FIFO_SIZE);
+};
+
 /* Hyper-V per vcpu emulation context */
 struct kvm_vcpu_hv {
 	struct kvm_vcpu *vcpu;
@@ -620,6 +638,8 @@ struct kvm_vcpu_hv {
 		u32 nested_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
 		u32 nested_ebx; /* HYPERV_CPUID_NESTED_FEATURES.EBX */
 	} cpuid_cache;
+
+	struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo;
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 3c0f639f6a05..b127b6bb84dd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -29,6 +29,7 @@
 #include <linux/kvm_host.h>
 #include <linux/highmem.h>
 #include <linux/sched/cputime.h>
+#include <linux/spinlock.h>
 #include <linux/eventfd.h>
 
 #include <asm/apicdef.h>
@@ -954,6 +955,9 @@ int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 
 	hv_vcpu->vp_index = vcpu->vcpu_idx;
 
+	INIT_KFIFO(hv_vcpu->tlb_flush_fifo.entries);
+	spin_lock_init(&hv_vcpu->tlb_flush_fifo.write_lock);
+
 	return 0;
 }
 
@@ -1783,6 +1787,36 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
 			      var_cnt * sizeof(*sparse_banks));
 }
 
+static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 flush_all_entry = KVM_HV_TLB_FLUSHALL_ENTRY;
+
+	if (!hv_vcpu)
+		return;
+
+	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
+
+	kfifo_in_spinlocked(&tlb_flush_fifo->entries, &flush_all_entry,
+			    1, &tlb_flush_fifo->write_lock);
+}
+
+void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	kvm_vcpu_flush_tlb_guest(vcpu);
+
+	if (!hv_vcpu)
+		return;
+
+	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
+
+	kfifo_reset_out(&tlb_flush_fifo->entries);
+}
+
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1791,6 +1825,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
+	struct kvm_vcpu *v;
+	unsigned long i;
 	bool all_cpus;
 
 	/*
@@ -1870,10 +1906,20 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
 	if (all_cpus) {
+		kvm_for_each_vcpu(i, v, kvm)
+			hv_tlb_flush_enqueue(v);
+
 		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
 	} else {
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
 
+		for_each_set_bit(i, vcpu_mask, KVM_MAX_VCPUS) {
+			v = kvm_get_vcpu(kvm, i);
+			if (!v)
+				continue;
+			hv_tlb_flush_enqueue(v);
+		}
+
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
 	}
 
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 1030b1b50552..ac30091ab346 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -151,4 +151,20 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
 
+
+static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!hv_vcpu || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+		return;
+
+	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
+
+	kfifo_reset_out(&tlb_flush_fifo->entries);
+}
+void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
+
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86504a8bfd9a..45c35c5467f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3385,7 +3385,7 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_flush_tlb_all)(vcpu);
 }
 
-static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
+void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
 
@@ -3420,14 +3420,14 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
 		kvm_vcpu_flush_tlb_current(vcpu);
-		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+		kvm_hv_vcpu_empty_flush_tlb(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
 		kvm_vcpu_flush_tlb_guest(vcpu);
-		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+		kvm_hv_vcpu_empty_flush_tlb(vcpu);
 	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
-		kvm_vcpu_flush_tlb_guest(vcpu);
+		kvm_hv_vcpu_flush_tlb(vcpu);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a784ff90740b..1ea28a7bdf2f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -79,6 +79,7 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 
 #define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
 
+void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu);
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
-- 
2.37.3

