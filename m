Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39AF4D01E4
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbiCGOv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243485AbiCGOvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:51:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24BA490249
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646664649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rlVYgUkdWRyYsMOIFcOnRDf5aAd17ft9dtYdjY2xq6w=;
        b=R4ZFRrZI978HoBSs5pinTPa4Y/F/ZnsTJFl71MPTQe6ZbsT/vnyL4A2yzjQzhHpLhpum3X
        HiDGXweTr9a5N9rTXBgBbS8KTAsnY79xhJ0Nfsww7R/2MNWlZPg2peTVCJH7CLhjqF3GmN
        JanVzf+J5Qiv5xXPLxY0Yr+7uVwcpM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-pFf_aL_KPBiuFik1sJZDbQ-1; Mon, 07 Mar 2022 09:50:48 -0500
X-MC-Unique: pFf_aL_KPBiuFik1sJZDbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6DCC1091DA0;
        Mon,  7 Mar 2022 14:50:45 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BC897F0D6;
        Mon,  7 Mar 2022 14:50:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 07/19] KVM: x86: hyper-v: Create a separate ring for Direct TLB flush
Date:   Mon,  7 Mar 2022 15:50:11 +0100
Message-Id: <20220307145023.1913205-8-vkuznets@redhat.com>
In-Reply-To: <20220307145023.1913205-1-vkuznets@redhat.com>
References: <20220307145023.1913205-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

