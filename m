Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D074D650F
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349831AbiCKPvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349772AbiCKPvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:51:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 738251CC7C9
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647013812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rlVYgUkdWRyYsMOIFcOnRDf5aAd17ft9dtYdjY2xq6w=;
        b=PCT/1HGrTFfacPdCYJQPO56SEogVv3PlR3xl+4ETs75DaLDPkML/JUrBZuczgkauR2ucN7
        aG3zrnvAz+vvGxWPqHOfwgOQHDlDMH4nczV9ul+QdoHPIlLkmNlXWMgfnInkDvdDy4/S1a
        QjpOdsLnIsgmAJmqp2wGSJTFodoBds8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-kIFTeHXrNACzbZIpYcbKiQ-1; Fri, 11 Mar 2022 10:50:09 -0500
X-MC-Unique: kIFTeHXrNACzbZIpYcbKiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5EA51091DA0;
        Fri, 11 Mar 2022 15:50:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51745785FD;
        Fri, 11 Mar 2022 15:50:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/31] KVM: x86: hyper-v: Create a separate ring for Direct TLB flush
Date:   Fri, 11 Mar 2022 16:49:19 +0100
Message-Id: <20220311154943.2299191-8-vkuznets@redhat.com>
In-Reply-To: <20220311154943.2299191-1-vkuznets@redhat.com>
References: <20220311154943.2299191-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To handle Direct TLB flush requests from L2 KVM needs to use a
separate ring from regular Hyper-V TLB flush requests: e.g. when a
request to flush something in L2 is made, the target vCPU can
transition from L2 to L1, receive a request to flush a GVA for L1 and
then try to enter L2 back. The first request needs to be processed
then. Similarly, requests to flush GVAs in L1 must wait until L2
exits to L1.

No functional change yet as KVM doesn't handle Direct TLB flush
requests from L2 yet.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/hyperv.c           |  7 ++++---
 arch/x86/kvm/hyperv.h           | 17 ++++++++++++++---
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 299f73d06680..750ac4055d0c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -613,7 +613,8 @@ struct kvm_vcpu_hv {
 		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
 	} cpuid_cache;
 
-	struct kvm_vcpu_hv_tlbflush_ring tlb_flush_ring;
+	/* Two rings for regular Hyper-V TLB flush and Direct TLB flush */
+	struct kvm_vcpu_hv_tlbflush_ring tlb_flush_ring[2];
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7efa34fb15ef..9dfc122d5eca 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -946,7 +946,8 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 
 	hv_vcpu->vp_index = vcpu->vcpu_idx;
 
-	spin_lock_init(&hv_vcpu->tlb_flush_ring.write_lock);
+	spin_lock_init(&hv_vcpu->tlb_flush_ring[0].write_lock);
+	spin_lock_init(&hv_vcpu->tlb_flush_ring[1].write_lock);
 
 	return 0;
 }
@@ -1874,7 +1875,7 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool flush_all,
 	if (!hv_vcpu)
 		return;
 
-	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
+	tlb_flush_ring = &hv_vcpu->tlb_flush_ring[0];
 
 	spin_lock_irqsave(&tlb_flush_ring->write_lock, flags);
 
@@ -1934,7 +1935,7 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
+	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
 	read_idx = READ_ONCE(tlb_flush_ring->read_idx);
 	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
 
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 83960d1bdb1f..137f906eb8c3 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -22,6 +22,7 @@
 #define __ARCH_X86_KVM_HYPERV_H__
 
 #include <linux/kvm_host.h>
+#include "x86.h"
 
 /*
  * The #defines related to the synthetic debugger are required by KDNet, but
@@ -147,15 +148,25 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
 
+static inline struct kvm_vcpu_hv_tlbflush_ring *kvm_hv_get_tlb_flush_ring(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!is_guest_mode(vcpu))
+		return &hv_vcpu->tlb_flush_ring[0];
+
+	return &hv_vcpu->tlb_flush_ring[1];
+}
 
 static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
 
-	if (!hv_vcpu)
+	if (!to_hv_vcpu(vcpu))
 		return;
 
-	hv_vcpu->tlb_flush_ring.read_idx = hv_vcpu->tlb_flush_ring.write_idx;
+	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
+	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
 }
 void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
 
-- 
2.35.1

