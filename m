Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEEA533925
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbiEYJCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbiEYJB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D648C7A818
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uqBm3igjiTkZoAEa3llRLTCNMOe2Jyrla567Yi0Bdc=;
        b=CtKewDcQlm4JR1+JrkunkL5lQjxrOYhIbfReR6xSVAYC2Y7IptOC+oHsTjQclxAHMdRajZ
        75YL16muY5qKeLoMPLTwZip7KaoVlZ/nzRQEQsiF5WLkOhnhbL7kMlmRfIjSJZUnWeEado
        YcdmHqVDSrR6IrTOc/2f9LFCkD3nQuE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-yn3vHqUlOcGik_o_HcWBZQ-1; Wed, 25 May 2022 05:01:48 -0400
X-MC-Unique: yn3vHqUlOcGik_o_HcWBZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B97913C10236;
        Wed, 25 May 2022 09:01:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B00F40CFD0A;
        Wed, 25 May 2022 09:01:45 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/37] KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Date:   Wed, 25 May 2022 11:01:01 +0200
Message-Id: <20220525090133.1264239-6-vkuznets@redhat.com>
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

Currently, HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls are handled
the exact same way as HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE{,EX}: by
flushing the whole VPID and this is sub-optimal. Switch to handling
these requests with 'flush_tlb_gva()' hooks instead. Use the newly
introduced TLB flush fifo to queue the requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 102 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 90 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 762b0b699fdf..576749973727 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1806,32 +1806,84 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
 				  sparse_banks, consumed_xmm_halves, offset);
 }
 
-static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
+static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
+					int consumed_xmm_halves, gpa_t offset)
+{
+	return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt,
+				  entries, consumed_xmm_halves, offset);
+}
+
+static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
 {
 	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	u64 entry = KVM_HV_TLB_FLUSHALL_ENTRY;
+	unsigned long flags;
 
 	if (!hv_vcpu)
 		return;
 
 	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
 
-	kfifo_in_spinlocked(&tlb_flush_fifo->entries, &entry, 1, &tlb_flush_fifo->write_lock);
+	spin_lock_irqsave(&tlb_flush_fifo->write_lock, flags);
+
+	/*
+	 * All entries should fit on the fifo leaving one free for 'flush all'
+	 * entry in case another request comes in. In case there's not enough
+	 * space, just put 'flush all' entry there.
+	 */
+	if (count && entries && count < kfifo_avail(&tlb_flush_fifo->entries)) {
+		WARN_ON(kfifo_in(&tlb_flush_fifo->entries, entries, count) != count);
+		goto out_unlock;
+	}
+
+	/*
+	 * Note: full fifo always contains 'flush all' entry, no need to check the
+	 * return value.
+	 */
+	kfifo_in(&tlb_flush_fifo->entries, &entry, 1);
+
+out_unlock:
+	spin_unlock_irqrestore(&tlb_flush_fifo->write_lock, flags);
 }
 
 void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 entries[KVM_HV_TLB_FLUSH_FIFO_SIZE];
+	int i, j, count;
+	gva_t gva;
 
-	kvm_vcpu_flush_tlb_guest(vcpu);
-
-	if (!hv_vcpu)
+	if (!tdp_enabled || !hv_vcpu) {
+		kvm_vcpu_flush_tlb_guest(vcpu);
 		return;
+	}
 
 	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
 
+	count = kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB_FLUSH_FIFO_SIZE);
+
+	for (i = 0; i < count; i++) {
+		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
+			goto out_flush_all;
+
+		/*
+		 * Lower 12 bits of 'address' encode the number of additional
+		 * pages to flush.
+		 */
+		gva = entries[i] & PAGE_MASK;
+		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
+			static_call(kvm_x86_flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
+
+		++vcpu->stat.tlb_flush;
+	}
+	goto out_empty_ring;
+
+out_flush_all:
+	kvm_vcpu_flush_tlb_guest(vcpu);
+
+out_empty_ring:
 	kfifo_reset_out(&tlb_flush_fifo->entries);
 }
 
@@ -1841,11 +1893,21 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
+	/*
+	 * Normally, there can be no more than 'KVM_HV_TLB_FLUSH_FIFO_SIZE'
+	 * entries on the TLB flush fifo. The last entry, however, needs to be
+	 * always left free for 'flush all' entry which gets placed when
+	 * there is not enough space to put all the requested entries.
+	 */
+	u64 __tlb_flush_entries[KVM_HV_TLB_FLUSH_FIFO_SIZE - 1];
+	u64 *tlb_flush_entries;
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	struct kvm_vcpu *v;
 	unsigned long i;
 	bool all_cpus;
+	int consumed_xmm_halves = 0;
+	gpa_t data_offset;
 
 	/*
 	 * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
@@ -1861,10 +1923,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1888,10 +1952,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1907,25 +1973,37 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
 		if (all_cpus)
-			goto do_flush;
+			goto read_flush_entries;
 
 		if (!hc->var_cnt)
 			goto ret_success;
 
-		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 2,
-					  offsetof(struct hv_tlb_flush_ex,
-						   hv_vp_set.bank_contents)))
+		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, consumed_xmm_halves,
+					  data_offset))
+			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
+		consumed_xmm_halves += hc->var_cnt;
+	}
+
+read_flush_entries:
+	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
+	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
+	    hc->rep_cnt > ARRAY_SIZE(__tlb_flush_entries)) {
+		tlb_flush_entries = NULL;
+	} else {
+		if (kvm_hv_get_tlb_flush_entries(kvm, hc, __tlb_flush_entries,
+						consumed_xmm_halves, data_offset))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
+		tlb_flush_entries = __tlb_flush_entries;
 	}
 
-do_flush:
 	/*
 	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
 	if (all_cpus) {
 		kvm_for_each_vcpu(i, v, kvm)
-			hv_tlb_flush_enqueue(v);
+			hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
 
 		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
 	} else {
@@ -1935,7 +2013,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			v = kvm_get_vcpu(kvm, i);
 			if (!v)
 				continue;
-			hv_tlb_flush_enqueue(v);
+			hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
 		}
 
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
-- 
2.35.3

