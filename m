Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7599607AFB
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiJUPg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiJUPgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:36:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615E1270224
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUVItlXjxakfMye5Xq9+8X/QaXU+hMzhyoz3EynPp4I=;
        b=UJdBizc5l8XciYPSxCgmDo8FZ17xnGuauJvUJQrI7C1HiI99TWO+cVPeyPeG6Yr3rxDZZl
        8ab0K40klp0ICzVM/TXoCgoHurYQnfvXOEpYQfEq5ozbQHVXmT3cPUDmnHh5rjJ2KvSwkm
        hakTXSQMUG8OdE3nKq8Ns9N+78xHJPw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-htw4P9mIMwuPC4_xwHZg3w-1; Fri, 21 Oct 2022 11:35:53 -0400
X-MC-Unique: htw4P9mIMwuPC4_xwHZg3w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE2751C0691B;
        Fri, 21 Oct 2022 15:35:52 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42059400EA8B;
        Fri, 21 Oct 2022 15:35:50 +0000 (UTC)
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
Subject: [PATCH v12 10/46] KVM: x86: hyper-v: Add helper to read hypercall data for array
Date:   Fri, 21 Oct 2022 17:34:45 +0200
Message-Id: <20221021153521.1216911-11-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Move the guts of kvm_get_sparse_vp_set() to a helper so that the code for
reading a guest-provided array can be reused in the future, e.g. for
getting a list of virtual addresses whose TLB entries need to be flushed.

Opportunisticaly swap the order of the data and XMM adjustment so that
the XMM/gpa offsets are bundled together.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 53 +++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 9d9a5ff2d54b..3ba7e2d2fbbd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1753,38 +1753,51 @@ struct kvm_hv_hcall {
 	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
 };
 
-static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
-				 int consumed_xmm_halves,
-				 u64 *sparse_banks, gpa_t offset)
-{
-	u16 var_cnt;
-	int i;
 
-	if (hc->var_cnt > 64)
-		return -EINVAL;
-
-	/* Ignore banks that cannot possibly contain a legal VP index. */
-	var_cnt = min_t(u16, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS);
+static int kvm_hv_get_hc_data(struct kvm *kvm, struct kvm_hv_hcall *hc,
+			      u16 orig_cnt, u16 cnt_cap, u64 *data,
+			      int consumed_xmm_halves, gpa_t offset)
+{
+	/*
+	 * Preserve the original count when ignoring entries via a "cap", KVM
+	 * still needs to validate the guest input (though the non-XMM path
+	 * punts on the checks).
+	 */
+	u16 cnt = min(orig_cnt, cnt_cap);
+	int i, j;
 
 	if (hc->fast) {
 		/*
 		 * Each XMM holds two sparse banks, but do not count halves that
 		 * have already been consumed for hypercall parameters.
 		 */
-		if (hc->var_cnt > 2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves)
+		if (orig_cnt > 2 * HV_HYPERCALL_MAX_XMM_REGISTERS - consumed_xmm_halves)
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
-		for (i = 0; i < var_cnt; i++) {
-			int j = i + consumed_xmm_halves;
+
+		for (i = 0; i < cnt; i++) {
+			j = i + consumed_xmm_halves;
 			if (j % 2)
-				sparse_banks[i] = sse128_hi(hc->xmm[j / 2]);
+				data[i] = sse128_hi(hc->xmm[j / 2]);
 			else
-				sparse_banks[i] = sse128_lo(hc->xmm[j / 2]);
+				data[i] = sse128_lo(hc->xmm[j / 2]);
 		}
 		return 0;
 	}
 
-	return kvm_read_guest(kvm, hc->ingpa + offset, sparse_banks,
-			      var_cnt * sizeof(*sparse_banks));
+	return kvm_read_guest(kvm, hc->ingpa + offset, data,
+			      cnt * sizeof(*data));
+}
+
+static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
+				 u64 *sparse_banks, int consumed_xmm_halves,
+				 gpa_t offset)
+{
+	if (hc->var_cnt > 64)
+		return -EINVAL;
+
+	/* Cap var_cnt to ignore banks that cannot contain a legal VP index. */
+	return kvm_hv_get_hc_data(kvm, hc, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS,
+				  sparse_banks, consumed_xmm_halves, offset);
 }
 
 static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
@@ -1895,7 +1908,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		if (!hc->var_cnt)
 			goto ret_success;
 
-		if (kvm_get_sparse_vp_set(kvm, hc, 2, sparse_banks,
+		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 2,
 					  offsetof(struct hv_tlb_flush_ex,
 						   hv_vp_set.bank_contents)))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
@@ -2006,7 +2019,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		if (!hc->var_cnt)
 			goto ret_success;
 
-		if (kvm_get_sparse_vp_set(kvm, hc, 1, sparse_banks,
+		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 1,
 					  offsetof(struct hv_send_ipi_ex,
 						   vp_set.bank_contents)))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
-- 
2.37.3

