Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90334536534
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 17:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354061AbiE0P51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 11:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353494AbiE0P4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 11:56:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDB2D33A0C
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 08:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653666986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6niVywmrTWf1XLMtwpvpY11W7POl31a/PYJdHRUwV9A=;
        b=EVv44kt5Lehe51h77AlkiicGYAqxBRpSuo8sgJJtQEp74TSvxyuAZQFVXLK90dI1KKgSK4
        mbgck0qjVZ2uBzAgcgJB0TvaunHLihna9e4Yc7dofeS7dNlCnuzZ0r/k8rqHqDFnHzWs+J
        7MIsEo+np+RDhW8wKZ2ISjUoZ6Y3xzA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-xkYmRD5bOR2N1OdQrMkrlA-1; Fri, 27 May 2022 11:56:20 -0400
X-MC-Unique: xkYmRD5bOR2N1OdQrMkrlA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A4A43C92FCB;
        Fri, 27 May 2022 15:56:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36BE02166B26;
        Fri, 27 May 2022 15:56:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 11/37] KVM: x86: hyper-v: Create a separate fifo for L2 TLB flush
Date:   Fri, 27 May 2022 17:55:20 +0200
Message-Id: <20220527155546.1528910-12-vkuznets@redhat.com>
In-Reply-To: <20220527155546.1528910-1-vkuznets@redhat.com>
References: <20220527155546.1528910-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To handle L2 TLB flush requests, KVM needs to use a separate fifo from
regular (L1) Hyper-V TLB flush requests: e.g. when a request to flush
something in L2 is made, the target vCPU can transition from L2 to L1,
receive a request to flush a GVA for L1 and then try to enter L2 back.
The first request needs to be processed at this point. Similarly,
requests to flush GVAs in L1 must wait until L2 exits to L1.

No functional change as KVM doesn't handle L2 TLB flush requests from
L2 yet.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  8 +++++++-
 arch/x86/kvm/hyperv.c           | 11 +++++++----
 arch/x86/kvm/hyperv.h           | 17 ++++++++++++++---
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 422f1a34f09e..af58760d6414 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -613,6 +613,12 @@ struct kvm_vcpu_hv_synic {
  */
 #define KVM_HV_TLB_FLUSHALL_ENTRY  ((u64)-1)
 
+enum hv_tlb_flush_fifos {
+	HV_L1_TLB_FLUSH_FIFO,
+	HV_L2_TLB_FLUSH_FIFO,
+	HV_NR_TLB_FLUSH_FIFOS,
+};
+
 struct kvm_vcpu_hv_tlb_flush_fifo {
 	spinlock_t write_lock;
 	DECLARE_KFIFO(entries, u64, KVM_HV_TLB_FLUSH_FIFO_SIZE);
@@ -638,7 +644,7 @@ struct kvm_vcpu_hv {
 		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
 	} cpuid_cache;
 
-	struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo;
+	struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo[HV_NR_TLB_FLUSH_FIFOS];
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b347971b3924..32f223bbea6b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -956,8 +956,10 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 
 	hv_vcpu->vp_index = vcpu->vcpu_idx;
 
-	INIT_KFIFO(hv_vcpu->tlb_flush_fifo.entries);
-	spin_lock_init(&hv_vcpu->tlb_flush_fifo.write_lock);
+	for (i = 0; i < HV_NR_TLB_FLUSH_FIFOS; i++) {
+		INIT_KFIFO(hv_vcpu->tlb_flush_fifo[i].entries);
+		spin_lock_init(&hv_vcpu->tlb_flush_fifo[i].write_lock);
+	}
 
 	return 0;
 }
@@ -1843,7 +1845,8 @@ static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
 	if (!hv_vcpu)
 		return;
 
-	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
+	/* kvm_hv_flush_tlb() is not ready to handle requests for L2s yet */
+	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo[HV_L1_TLB_FLUSH_FIFO];
 
 	spin_lock_irqsave(&tlb_flush_fifo->write_lock, flags);
 
@@ -1880,7 +1883,7 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
+	tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu);
 
 	count = kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB_FLUSH_FIFO_SIZE);
 
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index e5b32266ff7d..207d24efdc5a 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -22,6 +22,7 @@
 #define __ARCH_X86_KVM_HYPERV_H__
 
 #include <linux/kvm_host.h>
+#include "x86.h"
 
 /*
  * The #defines related to the synthetic debugger are required by KDNet, but
@@ -147,16 +148,26 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
 
+static inline struct kvm_vcpu_hv_tlb_flush_fifo *kvm_hv_get_tlb_flush_fifo(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	int i = !is_guest_mode(vcpu) ? HV_L1_TLB_FLUSH_FIFO :
+				       HV_L2_TLB_FLUSH_FIFO;
+
+	/* KVM does not handle L2 TLB flush requests yet */
+	WARN_ON_ONCE(i != HV_L1_TLB_FLUSH_FIFO);
+
+	return &hv_vcpu->tlb_flush_fifo[i];
+}
 
 static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
-	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
-	if (!hv_vcpu || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+	if (!to_hv_vcpu(vcpu) || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
 		return;
 
-	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
+	tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu);
 
 	kfifo_reset_out(&tlb_flush_fifo->entries);
 }
-- 
2.35.3

