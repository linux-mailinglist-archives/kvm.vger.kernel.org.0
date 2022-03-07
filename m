Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078BE4D01D4
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbiCGOvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241214AbiCGOvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:51:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 516EE85BDC
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646664638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1jAroNsrhL3r9phAeQSUbmvXAtwcUuaQ+ZMwbX7MzuE=;
        b=Z1kGRH9pbGElFromPpLjq0Nc192m5pV45vlCITg5YLYszKsw1QEM+JunsNsoyjvi6pF2vW
        K2UiiVKsT6l8SeWN0A0ge9b5vtPo+As9424KmcLsCzPX5t58Th7Qn/PxBvwy8hsXa0uuO2
        u/aISr4bJu+Dl2xPNTcG52XEAUeOwqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-TBpnn9ioNrWSI4oG46fGUA-1; Mon, 07 Mar 2022 09:50:36 -0500
X-MC-Unique: TBpnn9ioNrWSI4oG46fGUA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 628A3520E;
        Mon,  7 Mar 2022 14:50:35 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EB947F0D6;
        Mon,  7 Mar 2022 14:50:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 03/19] KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Date:   Mon,  7 Mar 2022 15:50:07 +0100
Message-Id: <20220307145023.1913205-4-vkuznets@redhat.com>
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

Currently, HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls are handled
the exact same way as HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE{,EX}: by
flushing the whole VPID and this is sub-optimal. Switch to handling
these requests with 'flush_tlb_gva()' hooks instead. Use the newly
introduced TLB flush ring to queue the requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 141 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 121 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bc7e41fa5cd3..4c8a37bce71e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1806,6 +1806,35 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
 			      var_cnt * sizeof(*sparse_banks));
 }
 
+static int kvm_hv_get_tlbflush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
+				       u32 data_offset, int consumed_xmm_halves)
+{
+	int i;
+
+	if (hc->fast) {
+		/*
+		 * Each XMM holds two entries, but do not count halves that
+		 * have already been consumed.
+		 */
+		if (hc->rep_cnt > (2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves))
+			return -EINVAL;
+
+		for (i = 0; i < hc->rep_cnt; i++) {
+			int j = i + consumed_xmm_halves;
+
+			if (j % 2)
+				entries[i] = sse128_hi(hc->xmm[j / 2]);
+			else
+				entries[i] = sse128_lo(hc->xmm[j / 2]);
+		}
+
+		return 0;
+	}
+
+	return kvm_read_guest(kvm, hc->ingpa + data_offset,
+			      entries, hc->rep_cnt * sizeof(entries[0]));
+}
+
 static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
 					 int read_idx, int write_idx)
 {
@@ -1815,12 +1844,14 @@ static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
 	return read_idx - write_idx - 1;
 }
 
-static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu)
+static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool flush_all,
+				      u64 *entries, int count)
 {
 	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	int ring_free, write_idx, read_idx;
 	unsigned long flags;
+	int i;
 
 	if (!hv_vcpu)
 		return;
@@ -1837,14 +1868,34 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu)
 	if (!ring_free)
 		goto out_unlock;
 
-	tlb_flush_ring->entries[write_idx].addr = 0;
-	tlb_flush_ring->entries[write_idx].flush_all = 1;
 	/*
-	 * Advance write index only after filling in the entry to
-	 * synchronize with lockless reader.
+	 * All entries should fit on the ring leaving one free for 'flush all'
+	 * entry in case another request comes in. In case there's not enough
+	 * space, just put 'flush all' entry there.
+	 */
+	if (!count || count >= ring_free - 1 || flush_all) {
+		tlb_flush_ring->entries[write_idx].addr = 0;
+		tlb_flush_ring->entries[write_idx].flush_all = 1;
+		/*
+		 * Advance write index only after filling in the entry to
+		 * synchronize with lockless reader.
+		 */
+		smp_wmb();
+		tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
+		goto out_unlock;
+	}
+
+	for (i = 0; i < count; i++) {
+		tlb_flush_ring->entries[write_idx].addr = entries[i];
+		tlb_flush_ring->entries[write_idx].flush_all = 0;
+		write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
+	}
+	/*
+	 * Advance write index only after filling in the entry to synchronize
+	 * with lockless reader.
 	 */
 	smp_wmb();
-	tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
+	tlb_flush_ring->write_idx = write_idx;
 
 out_unlock:
 	spin_unlock_irqrestore(&tlb_flush_ring->write_lock, flags);
@@ -1854,15 +1905,47 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-
-	kvm_vcpu_flush_tlb_guest(vcpu);
-
-	if (!hv_vcpu)
+	struct kvm_vcpu_hv_tlbflush_entry *entry;
+	int read_idx, write_idx;
+	u64 address;
+	u32 count;
+	int i, j;
+
+	if (!tdp_enabled || !hv_vcpu) {
+		kvm_vcpu_flush_tlb_guest(vcpu);
 		return;
+	}
 
 	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
+	read_idx = READ_ONCE(tlb_flush_ring->read_idx);
+	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
+
+	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
+	smp_rmb();
 
-	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
+	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
+		entry = &tlb_flush_ring->entries[i];
+
+		if (entry->flush_all)
+			goto out_flush_all;
+
+		/*
+		 * Lower 12 bits of 'address' encode the number of additional
+		 * pages to flush.
+		 */
+		address = entry->addr & PAGE_MASK;
+		count = (entry->addr & ~PAGE_MASK) + 1;
+		for (j = 0; j < count; j++)
+			static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
+	}
+	++vcpu->stat.tlb_flush;
+	goto out_empty_ring;
+
+out_flush_all:
+	kvm_vcpu_flush_tlb_guest(vcpu);
+
+out_empty_ring:
+	tlb_flush_ring->read_idx = write_idx;
 }
 
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
@@ -1871,12 +1954,13 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
+	u64 entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	struct kvm_vcpu *v;
 	unsigned long i;
-	bool all_cpus;
-
+	bool all_cpus, all_addr;
+	int data_offset = 0, consumed_xmm_halves = 0;
 	/*
 	 * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
 	 * valid mask is a u64.  Fail the build if KVM's max allowed number of
@@ -1891,10 +1975,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			flush.address_space = hc->ingpa;
 			flush.flags = hc->outgpa;
 			flush.processor_mask = sse128_lo(hc->xmm[0]);
+			consumed_xmm_halves = 1;
 		} else {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa,
 						    &flush, sizeof(flush))))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+			data_offset = sizeof(flush);
 		}
 
 		trace_kvm_hv_flush_tlb(flush.processor_mask,
@@ -1918,10 +2004,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			flush_ex.flags = hc->outgpa;
 			memcpy(&flush_ex.hv_vp_set,
 			       &hc->xmm[0], sizeof(hc->xmm[0]));
+			consumed_xmm_halves = 2;
 		} else {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
 						    sizeof(flush_ex))))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
+			data_offset = sizeof(flush_ex);
 		}
 
 		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
@@ -1937,25 +2025,38 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
 		if (all_cpus)
-			goto do_flush;
+			goto read_flush_entries;
 
 		if (!hc->var_cnt)
 			goto ret_success;
 
-		if (kvm_get_sparse_vp_set(kvm, hc, 2, sparse_banks,
-					  offsetof(struct hv_tlb_flush_ex,
-						   hv_vp_set.bank_contents)))
+		if (kvm_get_sparse_vp_set(kvm, hc, consumed_xmm_halves,
+					  sparse_banks, data_offset))
+			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
+		consumed_xmm_halves += hc->var_cnt;
+	}
+
+read_flush_entries:
+	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
+	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
+	    hc->rep_cnt > (KVM_HV_TLB_FLUSH_RING_SIZE - 2)) {
+		all_addr = true;
+	} else {
+		if (kvm_hv_get_tlbflush_entries(kvm, hc, entries,
+						data_offset, consumed_xmm_halves))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		all_addr = false;
 	}
 
-do_flush:
+
 	/*
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
 	if (all_cpus) {
 		kvm_for_each_vcpu(i, v, kvm)
-			hv_tlb_flush_ring_enqueue(v);
+			hv_tlb_flush_ring_enqueue(v, all_addr, entries, hc->rep_cnt);
 
 		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
 	} else {
@@ -1965,7 +2066,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			v = kvm_get_vcpu(kvm, i);
 			if (!v)
 				continue;
-			hv_tlb_flush_ring_enqueue(v);
+			hv_tlb_flush_ring_enqueue(v, all_addr, entries, hc->rep_cnt);
 		}
 
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
-- 
2.35.1

