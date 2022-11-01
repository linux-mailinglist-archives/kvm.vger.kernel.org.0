Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3879C614D48
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiKAO4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiKAO4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:56:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E8E645D
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5paYUy9LlEAduwP/Fv6SGrhNB2e83M3xoOVzQ/IVQT8=;
        b=V4UEn+nAkpxCubO0DHtPzz5XsO8ZMrmMtbLYgdFrQg4CzXN83pZToxaUqd5jTi+1Yik9eA
        fGWwKdalneWT+Gxkml7n7bhatzaruHjSzOWQM/GI9KvFmj4Tf0DD4KYVP7iu+mAEeACZNl
        SQvznQzJYSV38K6M5Qp+W/zHalkshM8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-M0LW5sdaPBCSnbpDirBZyA-1; Tue, 01 Nov 2022 10:54:55 -0400
X-MC-Unique: M0LW5sdaPBCSnbpDirBZyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19787185A78F;
        Tue,  1 Nov 2022 14:54:55 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2279CC15BA5;
        Tue,  1 Nov 2022 14:54:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 09/48] KVM: x86: hyper-v: Introduce TLB flush fifo
Date:   Tue,  1 Nov 2022 15:53:47 +0100
Message-Id: <20221101145426.251680-10-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To allow flushing individual GVAs instead of always flushing the whole
VPID a per-vCPU structure to pass the requests is needed. Use standard
'kfifo' to queue two types of entries: individual GVA (GFN + up to 4095
following GFNs in the lower 12 bits) and 'flush all'.

The size of the fifo is arbitrarily set to '16'.

Note, kvm_hv_flush_tlb() only queues 'flush all' entries for now and
kvm_hv_vcpu_flush_tlb() doesn't actually read the fifo just resets the
queue before returning -EOPNOTSUPP (which triggers full TLB flush) so
the functional change is very small but the infrastructure is prepared
to handle individual GVA flush requests.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 20 ++++++++++++++
 arch/x86/kvm/hyperv.c           | 47 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h           | 15 +++++++++++
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/x86.c              | 11 ++++++--
 5 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 05d90e11e535..f8ee72dd8660 100644
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
index 3c0f639f6a05..9d9a5ff2d54b 100644
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
 
@@ -1783,6 +1787,37 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
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
+	kfifo_in_spinlocked_noirqsave(&tlb_flush_fifo->entries, &flush_all_entry,
+				      1, &tlb_flush_fifo->write_lock);
+}
+
+int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!hv_vcpu)
+		return -EINVAL;
+
+	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
+
+	kfifo_reset_out(&tlb_flush_fifo->entries);
+
+	/* Precise flushing isn't implemented yet. */
+	return -EOPNOTSUPP;
+}
+
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1791,6 +1826,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
+	struct kvm_vcpu *v;
+	unsigned long i;
 	bool all_cpus;
 
 	/*
@@ -1870,10 +1907,20 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
index 1030b1b50552..f79edf9234cd 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -151,4 +151,19 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
 
+static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu)
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
+
+int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9210a8840224..25dc38a94fa0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3743,7 +3743,7 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
 	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
 	 */
-	kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	kvm_hv_vcpu_purge_flush_tlb(vcpu);
 
 	/*
 	 * Flush only the current ASID even if the TLB flush was invoked via
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf2aa77b7a2f..ed8b7802ba88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3422,7 +3422,7 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	 * Flushing all "guest" TLB is always a superset of Hyper-V's fine
 	 * grained flushing.
 	 */
-	kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	kvm_hv_vcpu_purge_flush_tlb(vcpu);
 }
 
 
@@ -10497,7 +10497,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		kvm_service_local_tlb_flush_requests(vcpu);
 
-		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+		/*
+		 * Fall back to a "full" guest flush if Hyper-V's precise
+		 * flushing fails.  Note, Hyper-V's flushing is per-vCPU, but
+		 * the flushes are considered "remote" and not "local" because
+		 * the requests can be initiated from other vCPUs.
+		 */
+		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu) &&
+		    kvm_hv_vcpu_flush_tlb(vcpu))
 			kvm_vcpu_flush_tlb_guest(vcpu);
 
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
-- 
2.37.3

