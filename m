Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42314F842F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345288AbiDGP7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345252AbiDGP7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F493CD641
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649347019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+H4iVJQ46RBLAasp1THDtEtJrAkCdUriLAAM9tqnxE=;
        b=UODHB4E8A1z/GrUhFMaqX9QtSjwu/o+4jnks8mBNhlQc+qBXFyCknZ0aK93zx0baQrn2f3
        H0lSV/X9yM69KP6zmEKzOZHIIYriOH/2+0NntgAEg6j3SEfn4OuayN0HawNTVUorJecopM
        WeqJ6k7vMIY6aKfPml3OTuy2QBjcpKk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-mjwPVuolMtKwagUG2w1G1g-1; Thu, 07 Apr 2022 11:56:56 -0400
X-MC-Unique: mjwPVuolMtKwagUG2w1G1g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D86785A5A8;
        Thu,  7 Apr 2022 15:56:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 873FD54AC84;
        Thu,  7 Apr 2022 15:56:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/31] KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Date:   Thu,  7 Apr 2022 17:56:17 +0200
Message-Id: <20220407155645.940890-4-vkuznets@redhat.com>
In-Reply-To: <20220407155645.940890-1-vkuznets@redhat.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
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
index 81c44e0eadf9..a54d41656f30 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1792,6 +1792,35 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
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
@@ -1801,12 +1830,14 @@ static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
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
@@ -1823,14 +1854,34 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu)
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
@@ -1840,15 +1891,47 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
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
@@ -1857,12 +1940,13 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1877,10 +1961,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1904,10 +1990,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1923,25 +2011,38 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1951,7 +2052,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			v = kvm_get_vcpu(kvm, i);
 			if (!v)
 				continue;
-			hv_tlb_flush_ring_enqueue(v);
+			hv_tlb_flush_ring_enqueue(v, all_addr, entries, hc->rep_cnt);
 		}
 
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
-- 
2.35.1

