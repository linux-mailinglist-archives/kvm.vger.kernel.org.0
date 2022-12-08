Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E758646CB3
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 11:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHK2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 05:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHK2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 05:28:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3D848401
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 02:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670495226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Rcw0nobjza3LFKftOLSGKGtb0s1UoIfEnKEaE42BZ0A=;
        b=JFFCXhZBa6Z7w6YXTvhCD2ZVZZff4HH2OH6NpgYO+yxp3BzMlxRCS5hFdIol+YpfPhV3BQ
        ovpOyViwt+LL0utTsFOXElEdVgCfjGPxHA3TOOl3lsrLzQYUG+Z1fjcWmWRu6A9+AcmOpm
        ZXA8qwdS98SNWb6YiTI3ESTC5/gYHj8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-LqtBgEMjMB6LO6reEDIxWw-1; Thu, 08 Dec 2022 05:27:03 -0500
X-MC-Unique: LqtBgEMjMB6LO6reEDIxWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 136B98339CA;
        Thu,  8 Dec 2022 10:27:03 +0000 (UTC)
Received: from ovpn-193-245.brq.redhat.com (ovpn-193-245.brq.redhat.com [10.40.193.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81A6340C6EC2;
        Thu,  8 Dec 2022 10:27:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     coverity-bot <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: hyper-v: Fix 'using uninitialized value' Coverity warning
Date:   Thu,  8 Dec 2022 11:27:00 +0100
Message-Id: <20221208102700.959630-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_hv_flush_tlb(), 'data_offset' and 'consumed_xmm_halves' variables
are used in a mutually exclusive way: in 'hc->fast' we count in 'XMM
halves' and increase 'data_offset' otherwise. Coverity discovered, that in
one case both variables are incremented unconditionally. This doesn't seem
to cause any issues as the only user of 'data_offset'/'consumed_xmm_halves'
data is kvm_hv_get_tlb_flush_entries() -> kvm_hv_get_hc_data() which also
takes into account 'hc->fast' but is still worth fixing.

To make things explicit, put 'data_offset' and 'consumed_xmm_halves' to
'struct kvm_hv_hcall' as a union and use at call sites. This allows to
remove explicit 'data_offset'/'consumed_xmm_halves' parameters from
kvm_hv_get_hc_data()/kvm_get_sparse_vp_set()/kvm_hv_get_tlb_flush_entries()
helpers.

Note: 'struct kvm_hv_hcall' is allocated on stack in kvm_hv_hypercall() and
is not zeroed, consumers are supposed to initialize the appropriate field
if needed.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527764 ("Uninitialized variables")
Fixes: 260970862c88 ("KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
Changes since v1:
- Shove 'data_offset'/'consumed_xmm_halves' into a union in 'struct
kvm_hv_hcall' to make things more explicit. [Sean]
---
 arch/x86/kvm/hyperv.c | 63 ++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2c7f2a26421e..e8296942a868 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1769,6 +1769,7 @@ static bool hv_is_vp_in_sparse_set(u32 vp_id, u64 valid_bank_mask, u64 sparse_ba
 }
 
 struct kvm_hv_hcall {
+	/* Hypercall input data */
 	u64 param;
 	u64 ingpa;
 	u64 outgpa;
@@ -1779,12 +1780,21 @@ struct kvm_hv_hcall {
 	bool fast;
 	bool rep;
 	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
+
+	/*
+	 * Current read offset when KVM reads hypercall input data gradually,
+	 * either offset in bytes from 'ingpa' for regular hypercalls or the
+	 * number of already consumed 'XMM halves' for 'fast' hypercalls.
+	 */
+	union {
+		gpa_t data_offset;
+		int consumed_xmm_halves;
+	};
 };
 
 
 static int kvm_hv_get_hc_data(struct kvm *kvm, struct kvm_hv_hcall *hc,
-			      u16 orig_cnt, u16 cnt_cap, u64 *data,
-			      int consumed_xmm_halves, gpa_t offset)
+			      u16 orig_cnt, u16 cnt_cap, u64 *data)
 {
 	/*
 	 * Preserve the original count when ignoring entries via a "cap", KVM
@@ -1799,11 +1809,11 @@ static int kvm_hv_get_hc_data(struct kvm *kvm, struct kvm_hv_hcall *hc,
 		 * Each XMM holds two sparse banks, but do not count halves that
 		 * have already been consumed for hypercall parameters.
 		 */
-		if (orig_cnt > 2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves)
+		if (orig_cnt > 2 * HV_HYPERCALL_MAX_XMM_REGISTERS - hc->consumed_xmm_halves)
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
 		for (i = 0; i < cnt; i++) {
-			j = i + consumed_xmm_halves;
+			j = i + hc->consumed_xmm_halves;
 			if (j % 2)
 				data[i] = sse128_hi(hc->xmm[j / 2]);
 			else
@@ -1812,27 +1822,24 @@ static int kvm_hv_get_hc_data(struct kvm *kvm, struct kvm_hv_hcall *hc,
 		return 0;
 	}
 
-	return kvm_read_guest(kvm, hc->ingpa + offset, data,
+	return kvm_read_guest(kvm, hc->ingpa + hc->data_offset, data,
 			      cnt * sizeof(*data));
 }
 
 static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
-				 u64 *sparse_banks, int consumed_xmm_halves,
-				 gpa_t offset)
+				 u64 *sparse_banks)
 {
 	if (hc->var_cnt > HV_MAX_SPARSE_VCPU_BANKS)
 		return -EINVAL;
 
 	/* Cap var_cnt to ignore banks that cannot contain a legal VP index. */
 	return kvm_hv_get_hc_data(kvm, hc, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS,
-				  sparse_banks, consumed_xmm_halves, offset);
+				  sparse_banks);
 }
 
-static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
-					int consumed_xmm_halves, gpa_t offset)
+static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[])
 {
-	return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt,
-				  entries, consumed_xmm_halves, offset);
+	return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt, entries);
 }
 
 static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu,
@@ -1926,8 +1933,6 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm_vcpu *v;
 	unsigned long i;
 	bool all_cpus;
-	int consumed_xmm_halves = 0;
-	gpa_t data_offset;
 
 	/*
 	 * The Hyper-V TLFS doesn't allow more than HV_MAX_SPARSE_VCPU_BANKS
@@ -1955,12 +1960,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			flush.address_space = hc->ingpa;
 			flush.flags = hc->outgpa;
 			flush.processor_mask = sse128_lo(hc->xmm[0]);
-			consumed_xmm_halves = 1;
+			hc->consumed_xmm_halves = 1;
 		} else {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa,
 						    &flush, sizeof(flush))))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
-			data_offset = sizeof(flush);
+			hc->data_offset = sizeof(flush);
 		}
 
 		trace_kvm_hv_flush_tlb(flush.processor_mask,
@@ -1985,12 +1990,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			flush_ex.flags = hc->outgpa;
 			memcpy(&flush_ex.hv_vp_set,
 			       &hc->xmm[0], sizeof(hc->xmm[0]));
-			consumed_xmm_halves = 2;
+			hc->consumed_xmm_halves = 2;
 		} else {
 			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
 						    sizeof(flush_ex))))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
-			data_offset = sizeof(flush_ex);
+			hc->data_offset = sizeof(flush_ex);
 		}
 
 		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
@@ -2009,8 +2014,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 			if (!hc->var_cnt)
 				goto ret_success;
 
-			if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks,
-						  consumed_xmm_halves, data_offset))
+			if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks))
 				return HV_STATUS_INVALID_HYPERCALL_INPUT;
 		}
 
@@ -2021,8 +2025,10 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		 * consumed_xmm_halves to make sure TLB flush entries are read
 		 * from the correct offset.
 		 */
-		data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
-		consumed_xmm_halves += hc->var_cnt;
+		if (hc->fast)
+			hc->consumed_xmm_halves += hc->var_cnt;
+		else
+			hc->data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
 	}
 
 	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
@@ -2030,8 +2036,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	    hc->rep_cnt > ARRAY_SIZE(__tlb_flush_entries)) {
 		tlb_flush_entries = NULL;
 	} else {
-		if (kvm_hv_get_tlb_flush_entries(kvm, hc, __tlb_flush_entries,
-						consumed_xmm_halves, data_offset))
+		if (kvm_hv_get_tlb_flush_entries(kvm, hc, __tlb_flush_entries))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 		tlb_flush_entries = __tlb_flush_entries;
 	}
@@ -2180,9 +2185,13 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		if (!hc->var_cnt)
 			goto ret_success;
 
-		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 1,
-					  offsetof(struct hv_send_ipi_ex,
-						   vp_set.bank_contents)))
+		if (!hc->fast)
+			hc->data_offset = offsetof(struct hv_send_ipi_ex,
+						   vp_set.bank_contents);
+		else
+			hc->consumed_xmm_halves = 1;
+
+		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 	}
 
-- 
2.38.1

