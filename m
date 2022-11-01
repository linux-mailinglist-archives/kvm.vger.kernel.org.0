Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AA2614D56
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiKAO4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiKAO4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:56:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930C6AE4E
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1FyqbQPb+NKMohxGl/e71HYyJ8BN1cnd5gFTyOV/58o=;
        b=Wk947oeXwk8dUoX+ecM5a5k5nwd+CwWh4JiY6eXmsaMKXzclHsVqkvSMPRXt3GBhVvMmk4
        304UFyf0oNVjNNXa0/t5DiOz0YF8hDyMbbrMQyJjypBCsAyT7B/ycxcmrcXFU58ziCWM70
        DHIWKNJffA3v77ENz5jDUyoKuEVrpwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-x_GWChRUNzOLoAyEsJUxUA-1; Tue, 01 Nov 2022 10:55:13 -0400
X-MC-Unique: x_GWChRUNzOLoAyEsJUxUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 077B0101A52A;
        Tue,  1 Nov 2022 14:55:13 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D7C2C15BA5;
        Tue,  1 Nov 2022 14:55:10 +0000 (UTC)
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
Subject: [PATCH v13 16/48] KVM: x86: hyper-v: Don't use sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
Date:   Tue,  1 Nov 2022 15:53:54 +0100
Message-Id: <20221101145426.251680-17-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get rid of on-stack allocation of vcpu_mask and optimize kvm_hv_send_ipi()
for a smaller number of vCPUs in the request. When Hyper-V TLB flush
is in  use, HvSendSyntheticClusterIpi{,Ex} calls are not commonly used to
send IPIs to a large number of vCPUs (and are rarely used in general).

Introduce hv_is_vp_in_sparse_set() to directly check if the specified
VP_ID is present in sparse vCPU set.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2fceb85687c1..0bfa59838e0a 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1741,6 +1741,28 @@ static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
 	}
 }
 
+static bool hv_is_vp_in_sparse_set(u32 vp_id, u64 valid_bank_mask, u64 sparse_banks[])
+{
+	int valid_bit_nr = vp_id / HV_VCPUS_PER_SPARSE_BANK;
+	unsigned long sbank;
+
+	if (!test_bit(valid_bit_nr, (unsigned long *)&valid_bank_mask))
+		return false;
+
+	/*
+	 * The index into the sparse bank is the number of preceding bits in
+	 * the valid mask.  Optimize for VMs with <64 vCPUs by skipping the
+	 * fancy math if there can't possibly be preceding bits.
+	 */
+	if (valid_bit_nr)
+		sbank = hweight64(valid_bank_mask & GENMASK_ULL(valid_bit_nr - 1, 0));
+	else
+		sbank = 0;
+
+	return test_bit(vp_id % HV_VCPUS_PER_SPARSE_BANK,
+			(unsigned long *)&sparse_banks[sbank]);
+}
+
 struct kvm_hv_hcall {
 	u64 param;
 	u64 ingpa;
@@ -2035,8 +2057,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
 }
 
-static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
-				 unsigned long *vcpu_bitmap)
+static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
+				    u64 *sparse_banks, u64 valid_bank_mask)
 {
 	struct kvm_lapic_irq irq = {
 		.delivery_mode = APIC_DM_FIXED,
@@ -2046,7 +2068,9 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
 	unsigned long i;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
+		if (sparse_banks &&
+		    !hv_is_vp_in_sparse_set(kvm_hv_get_vpindex(vcpu),
+					    valid_bank_mask, sparse_banks))
 			continue;
 
 		/* We fail only when APIC is disabled */
@@ -2059,7 +2083,6 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
-	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
@@ -2121,13 +2144,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
-	if (all_cpus) {
-		kvm_send_ipi_to_many(kvm, vector, NULL);
-	} else {
-		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
-
-		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
-	}
+	if (all_cpus)
+		kvm_hv_send_ipi_to_many(kvm, vector, NULL, 0);
+	else
+		kvm_hv_send_ipi_to_many(kvm, vector, sparse_banks, valid_bank_mask);
 
 ret_success:
 	return HV_STATUS_SUCCESS;
-- 
2.37.3

