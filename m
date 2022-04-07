Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE5A4F8441
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345379AbiDGP7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345345AbiDGP7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:59:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AC8DCFB89
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649347043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UgZCnuUz8GOt8d4s09b90a6eJ4Zyz42aVxM0q4I35ug=;
        b=eM8DYsYCLg+vq+p6tUC/6UUEKnQ+ghH1RePxisxNk7RJbC4monBN4r8Iz6o7qcBtjKSF3A
        Mg1ddQu2neHhJ+omL+G0j3arToOOwOdGG0ML2yOcc8Nuv4Az+troic3asT4Ebd86+dE2tv
        sfDZqzsjfyAtjioCsIRYByH12dnHIqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-p-sEjjuuPAGa3jNDiB_4RQ-1; Thu, 07 Apr 2022 11:57:17 -0400
X-MC-Unique: p-sEjjuuPAGa3jNDiB_4RQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DBB980B710;
        Thu,  7 Apr 2022 15:57:17 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5917E428EE1;
        Thu,  7 Apr 2022 15:57:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/31] KVM: x86: hyper-v: Direct TLB flush
Date:   Thu,  7 Apr 2022 17:56:27 +0200
Message-Id: <20220407155645.940890-14-vkuznets@redhat.com>
In-Reply-To: <20220407155645.940890-1-vkuznets@redhat.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle Direct TLB flush requests from L2 by going through all vCPUs
and checking whether there are vCPUs running the same VM_ID with a
VP_ID specified in the requests. Perform synthetic exit to L2 upon
finish.

Note, while checking VM_ID/VP_ID of running vCPUs seem to be a bit
racy, we count on the fact that KVM flushes the whole L2 VPID upon
transition. Also, KVM_REQ_HV_TLB_FLUSH request needs to be done upon
transition between L1 and L2 to make sure all pending requests are
always processed.

Note, while nVMX/nSVM code does not handle VMCALL/VMMCALL from L2 yet.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 65 ++++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/trace.h  | 21 ++++++++------
 2 files changed, 68 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 705c0b739c1b..2b12f1b5c992 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -34,6 +34,7 @@
 #include <linux/eventfd.h>
 
 #include <asm/apicdef.h>
+#include <asm/mshyperv.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
@@ -1849,8 +1850,8 @@ static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
 	return read_idx - write_idx - 1;
 }
 
-static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool flush_all,
-				      u64 *entries, int count)
+static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool direct,
+				      bool flush_all, u64 *entries, int count)
 {
 	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
@@ -1861,7 +1862,7 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool flush_all,
 	if (!hv_vcpu)
 		return;
 
-	tlb_flush_ring = &hv_vcpu->tlb_flush_ring[0];
+	tlb_flush_ring = direct ? &hv_vcpu->tlb_flush_ring[1] : &hv_vcpu->tlb_flush_ring[0];
 
 	spin_lock_irqsave(&tlb_flush_ring->write_lock, flags);
 
@@ -1996,7 +1997,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		}
 
 		trace_kvm_hv_flush_tlb(flush.processor_mask,
-				       flush.address_space, flush.flags);
+				       flush.address_space, flush.flags,
+				       is_guest_mode(vcpu));
 
 		valid_bank_mask = BIT_ULL(0);
 		sparse_banks[0] = flush.processor_mask;
@@ -2027,7 +2029,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
 					  flush_ex.hv_vp_set.format,
 					  flush_ex.address_space,
-					  flush_ex.flags);
+					  flush_ex.flags, is_guest_mode(vcpu));
 
 		valid_bank_mask = flush_ex.hv_vp_set.valid_bank_mask;
 		all_cpus = flush_ex.hv_vp_set.format !=
@@ -2066,19 +2068,45 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
-	if (all_cpus) {
+	if (all_cpus && !is_guest_mode(vcpu)) {
 		kvm_for_each_vcpu(i, v, kvm)
-			hv_tlb_flush_ring_enqueue(v, all_addr, entries, hc->rep_cnt);
+			hv_tlb_flush_ring_enqueue(v, false, all_addr, entries, hc->rep_cnt);
 
 		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
-	} else {
+	} else if (!is_guest_mode(vcpu)) {
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
 
 		for_each_set_bit(i, vcpu_mask, KVM_MAX_VCPUS) {
 			v = kvm_get_vcpu(kvm, i);
 			if (!v)
 				continue;
-			hv_tlb_flush_ring_enqueue(v, all_addr, entries, hc->rep_cnt);
+			hv_tlb_flush_ring_enqueue(v, false, all_addr, entries, hc->rep_cnt);
+		}
+
+		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
+	} else {
+		struct kvm_vcpu_hv *hv_v;
+
+		bitmap_zero(vcpu_mask, KVM_MAX_VCPUS);
+
+		kvm_for_each_vcpu(i, v, kvm) {
+			hv_v = to_hv_vcpu(v);
+
+			/*
+			 * TLB is fully flushed on L2 VM change: either by KVM
+			 * (on a eVMPTR switch) or by L1 hypervisor (in case it
+			 * re-purposes the active eVMCS for a different VM/VP).
+			 */
+			if (!hv_v || hv_v->nested.vm_id != hv_vcpu->nested.vm_id)
+				continue;
+
+			if (!all_cpus &&
+			    !hv_is_vp_in_sparse_set(hv_v->nested.vp_id, valid_bank_mask,
+						    sparse_banks))
+				continue;
+
+			__set_bit(i, vcpu_mask);
+			hv_tlb_flush_ring_enqueue(v, true, all_addr, entries, hc->rep_cnt);
 		}
 
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
@@ -2266,10 +2294,27 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 
 static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
 {
+	int ret;
+
 	trace_kvm_hv_hypercall_done(result);
 	kvm_hv_hypercall_set_result(vcpu, result);
 	++vcpu->stat.hypercalls;
-	return kvm_skip_emulated_instruction(vcpu);
+	ret = kvm_skip_emulated_instruction(vcpu);
+
+	if (unlikely(hv_result_success(result) && is_guest_mode(vcpu)
+		     && kvm_hv_is_tlb_flush_hcall(vcpu))) {
+		struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+		u32 tlb_lock_count;
+
+		if (unlikely(kvm_read_guest(vcpu->kvm, hv_vcpu->nested.pa_page_gpa,
+					    &tlb_lock_count, sizeof(tlb_lock_count))))
+			kvm_inject_gp(vcpu, 0);
+
+		if (tlb_lock_count)
+			kvm_x86_ops.nested_ops->post_hv_direct_flush(vcpu);
+	}
+
+	return ret;
 }
 
 static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e3a24b8f04be..4241b7c0245e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1479,38 +1479,41 @@ TRACE_EVENT(kvm_hv_timer_state,
  * Tracepoint for kvm_hv_flush_tlb.
  */
 TRACE_EVENT(kvm_hv_flush_tlb,
-	TP_PROTO(u64 processor_mask, u64 address_space, u64 flags),
-	TP_ARGS(processor_mask, address_space, flags),
+	TP_PROTO(u64 processor_mask, u64 address_space, u64 flags, bool direct),
+	TP_ARGS(processor_mask, address_space, flags, direct),
 
 	TP_STRUCT__entry(
 		__field(u64, processor_mask)
 		__field(u64, address_space)
 		__field(u64, flags)
+		__field(bool, direct)
 	),
 
 	TP_fast_assign(
 		__entry->processor_mask = processor_mask;
 		__entry->address_space = address_space;
 		__entry->flags = flags;
+		__entry->direct = direct;
 	),
 
-	TP_printk("processor_mask 0x%llx address_space 0x%llx flags 0x%llx",
+	TP_printk("processor_mask 0x%llx address_space 0x%llx flags 0x%llx %s",
 		  __entry->processor_mask, __entry->address_space,
-		  __entry->flags)
+		  __entry->flags, __entry->direct ? "(direct)" : "")
 );
 
 /*
  * Tracepoint for kvm_hv_flush_tlb_ex.
  */
 TRACE_EVENT(kvm_hv_flush_tlb_ex,
-	TP_PROTO(u64 valid_bank_mask, u64 format, u64 address_space, u64 flags),
-	TP_ARGS(valid_bank_mask, format, address_space, flags),
+	TP_PROTO(u64 valid_bank_mask, u64 format, u64 address_space, u64 flags, bool direct),
+	TP_ARGS(valid_bank_mask, format, address_space, flags, direct),
 
 	TP_STRUCT__entry(
 		__field(u64, valid_bank_mask)
 		__field(u64, format)
 		__field(u64, address_space)
 		__field(u64, flags)
+		__field(bool, direct)
 	),
 
 	TP_fast_assign(
@@ -1518,12 +1521,14 @@ TRACE_EVENT(kvm_hv_flush_tlb_ex,
 		__entry->format = format;
 		__entry->address_space = address_space;
 		__entry->flags = flags;
+		__entry->direct = direct;
 	),
 
 	TP_printk("valid_bank_mask 0x%llx format 0x%llx "
-		  "address_space 0x%llx flags 0x%llx",
+		  "address_space 0x%llx flags 0x%llx %s",
 		  __entry->valid_bank_mask, __entry->format,
-		  __entry->address_space, __entry->flags)
+		  __entry->address_space, __entry->flags,
+		  __entry->direct ? "(direct)" : "")
 );
 
 /*
-- 
2.35.1

