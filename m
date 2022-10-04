Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6424D5F4330
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiJDMmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJDMlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A325C9E7
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GUB4dXPGX7Iuzwn9dyuMxPgV5pDIUa/WCqcbV5e25Gg=;
        b=LLIzaXA1xzmoa4mDxY/Tt6Ao4bnnkdT1fA32jgBbsgWgZmxUDLGYJi5L3GcRZTrjpCNvUJ
        QMMdm1YhZzwpwPQ2qe1dF74EO+FXjrtqDOdrdOLk9w+vfXkbFr9Awz8Tpe2c0mYVsuC2q4
        bOBkyTJTtpITXzU47iQ56DbFF5ahZuQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-C6t3jP_bMVeZupluBWfBkw-1; Tue, 04 Oct 2022 08:40:28 -0400
X-MC-Unique: C6t3jP_bMVeZupluBWfBkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ED47101245F;
        Tue,  4 Oct 2022 12:40:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DC9523177;
        Tue,  4 Oct 2022 12:40:25 +0000 (UTC)
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
Subject: [PATCH v11 11/46] KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Date:   Tue,  4 Oct 2022 14:39:21 +0200
Message-Id: <20221004123956.188909-12-vkuznets@redhat.com>
In-Reply-To: <20221004123956.188909-1-vkuznets@redhat.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 arch/x86/kvm/hyperv.c | 100 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 3ba7e2d2fbbd..2119f6116766 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1800,7 +1800,14 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
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
@@ -1811,24 +1818,65 @@ static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
 
 	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
 
-	kfifo_in_spinlocked_noirqsave(&tlb_flush_fifo->entries, &flush_all_entry,
-				      1, &tlb_flush_fifo->write_lock);
+	spin_lock(&tlb_flush_fifo->write_lock);
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
+	kfifo_in(&tlb_flush_fifo->entries, &flush_all_entry, 1);
+
+out_unlock:
+	spin_unlock(&tlb_flush_fifo->write_lock);
 }
 
 int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 entries[KVM_HV_TLB_FLUSH_FIFO_SIZE];
+	int i, j, count;
+	gva_t gva;
 
-	if (!hv_vcpu)
+	if (!tdp_enabled || !hv_vcpu)
 		return -EINVAL;
 
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
+	return 0;
+
+out_flush_all:
+	kvm_vcpu_flush_tlb_guest(vcpu);
 	kfifo_reset_out(&tlb_flush_fifo->entries);
 
-	/* Precise flushing isn't implemented yet. */
-	return -EOPNOTSUPP;
+	/* Fall back to full flush. */
+	return -ENOSPC;
 }
 
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
@@ -1837,11 +1885,21 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1857,10 +1915,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1884,10 +1944,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1903,25 +1965,37 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
@@ -1931,7 +2005,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			v = kvm_get_vcpu(kvm, i);
 			if (!v)
 				continue;
-			hv_tlb_flush_enqueue(v);
+			hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
 		}
 
 		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
-- 
2.37.3

