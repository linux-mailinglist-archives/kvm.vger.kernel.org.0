Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A89533921
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbiEYJBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbiEYJBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:01:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BE667090B
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MgIp+nU0cbHkkbgJcXaRLv57Q4w+bXbatv5BUiJMWzk=;
        b=Wv98Kh1WnCMltGH7Eb0vUfwklgvKlccCq72ivV/40n7HrXPTQQZ1lhfsRJf5/bRMGUXyYa
        bOiNIgyhAtGF3iokeqfxa9TgVpiDRX83rHbH9BaSDlov1JCAodwMlmu6QWaT41O301OLmF
        sAwVRf4bMO0znd6M/ccpEIJEgDs3x1g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-AhYExhMFNGuBhyWK4cuTLA-1; Wed, 25 May 2022 05:01:43 -0400
X-MC-Unique: AhYExhMFNGuBhyWK4cuTLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2828811E90;
        Wed, 25 May 2022 09:01:42 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C1A9405D4BF;
        Wed, 25 May 2022 09:01:40 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/37] KVM: x86: hyper-v: Introduce TLB flush fifo
Date:   Wed, 25 May 2022 11:00:59 +0200
Message-Id: <20220525090133.1264239-4-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

The size of the fifo is arbitrary set to '16'.

Note, kvm_hv_flush_tlb() only queues 'flush all' entries for now and
kvm_hv_vcpu_flush_tlb() doesn't actually read the fifo just resets the
queue before doing full TLB flush so the functional change is very
small but the infrastructure is prepared to handle individual GVA
flush requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 20 +++++++++++++++
 arch/x86/kvm/hyperv.c           | 45 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h           | 16 ++++++++++++
 arch/x86/kvm/x86.c              |  5 ++--
 arch/x86/kvm/x86.h              |  1 +
 5 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 92509ee6ae1b..31e87c5cbf1e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -25,6 +25,7 @@
 #include <linux/clocksource.h>
 #include <linux/irqbypass.h>
 #include <linux/hyperv.h>
+#include <linux/kfifo.h>
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -597,6 +598,23 @@ struct kvm_vcpu_hv_synic {
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
@@ -616,6 +634,8 @@ struct kvm_vcpu_hv {
 		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
 		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
 	} cpuid_cache;
+
+	struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo;
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b402ad059eb9..c8b22bf67577 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -29,6 +29,7 @@
 #include <linux/kvm_host.h>
 #include <linux/highmem.h>
 #include <linux/sched/cputime.h>
+#include <linux/spinlock.h>
 #include <linux/eventfd.h>
 
 #include <asm/apicdef.h>
@@ -954,6 +955,9 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 
 	hv_vcpu->vp_index = vcpu->vcpu_idx;
 
+	INIT_KFIFO(hv_vcpu->tlb_flush_fifo.entries);
+	spin_lock_init(&hv_vcpu->tlb_flush_fifo.write_lock);
+
 	return 0;
 }
 
@@ -1789,6 +1793,35 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
 			      var_cnt * sizeof(*sparse_banks));
 }
 
+static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 entry = KVM_HV_TLB_FLUSHALL_ENTRY;
+
+	if (!hv_vcpu)
+		return;
+
+	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
+
+	kfifo_in_spinlocked(&tlb_flush_fifo->entries, &entry, 1, &tlb_flush_fifo->write_lock);
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
@@ -1797,6 +1830,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
+	struct kvm_vcpu *v;
+	unsigned long i;
 	bool all_cpus;
 
 	/*
@@ -1876,10 +1911,20 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
index da2737f2a956..87d0a0152ad7 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -147,4 +147,20 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
 
+
+static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!hv_vcpu)
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
index f98503431f8d..ac0ed0cbd499 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3330,7 +3330,7 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_flush_tlb_all)(vcpu);
 }
 
-static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
+void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
 
@@ -3370,7 +3370,8 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
 		kvm_vcpu_flush_tlb_guest(vcpu);
-		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+			kvm_hv_vcpu_empty_flush_tlb(vcpu);
 	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
 		kvm_vcpu_flush_tlb_guest(vcpu);
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 588792f00334..2324f496c500 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -58,6 +58,7 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 
 #define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
 
+void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu);
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
 
-- 
2.35.3

