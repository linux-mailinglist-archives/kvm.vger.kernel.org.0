Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB915C0139
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiIUP0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiIUPZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:25:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EC0792F1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663773914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tq0tjmwVjRCUIF1TVaYq5UQHOZeIIptzYa0L52ssTM0=;
        b=R+IwKyxZJadizFYT+fUR7GkKkiTg+3B4QcLVcoj5vDxb6S391f2sGgwHsMUG5mrt5vGFpS
        497Cn6e4IGWiZ3OiafM7PXP7IRJClhEENin/Wx/uDyDWG6yqrI96k5KCM01fSeqobeUJzs
        WIHBf7u1/0WlsigkhhO2fpuTWFYxfmQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-5Zoz9E7FMri6LVcd8fwVHw-1; Wed, 21 Sep 2022 11:25:09 -0400
X-MC-Unique: 5Zoz9E7FMri6LVcd8fwVHw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADCB9381A72C;
        Wed, 21 Sep 2022 15:25:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 683A92166B2A;
        Wed, 21 Sep 2022 15:25:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 10/39] KVM: x86: hyper-v: Don't use sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
Date:   Wed, 21 Sep 2022 17:24:07 +0200
Message-Id: <20220921152436.3673454-11-vkuznets@redhat.com>
In-Reply-To: <20220921152436.3673454-1-vkuznets@redhat.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 69891c48c12a..9764ebb7fd5f 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1741,6 +1741,25 @@ static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
 	}
 }
 
+static bool hv_is_vp_in_sparse_set(u32 vp_id, u64 valid_bank_mask, u64 sparse_banks[])
+{
+	int bank, sbank = 0;
+
+	if (!test_bit(vp_id / HV_VCPUS_PER_SPARSE_BANK,
+		      (unsigned long *)&valid_bank_mask))
+		return false;
+
+	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
+			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS) {
+		if (bank == vp_id / HV_VCPUS_PER_SPARSE_BANK)
+			break;
+		sbank++;
+	}
+
+	return test_bit(vp_id % HV_VCPUS_PER_SPARSE_BANK,
+			(unsigned long *)&sparse_banks[sbank]);
+}
+
 struct kvm_hv_hcall {
 	u64 param;
 	u64 ingpa;
@@ -2023,8 +2042,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
 }
 
-static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
-				 unsigned long *vcpu_bitmap)
+static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
+				    u64 *sparse_banks, u64 valid_bank_mask)
 {
 	struct kvm_lapic_irq irq = {
 		.delivery_mode = APIC_DM_FIXED,
@@ -2034,7 +2053,10 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
 	unsigned long i;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
+		if (sparse_banks &&
+		    !hv_is_vp_in_sparse_set(kvm_hv_get_vpindex(vcpu),
+					    valid_bank_mask,
+					    sparse_banks))
 			continue;
 
 		/* We fail only when APIC is disabled */
@@ -2047,7 +2069,6 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
-	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
@@ -2109,13 +2130,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
 		return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
-	if (all_cpus) {
-		kvm_send_ipi_to_many(kvm, vector, NULL);
-	} else {
-		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
-
-		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
-	}
+	kvm_hv_send_ipi_to_many(kvm, vector, all_cpus ? NULL : sparse_banks, valid_bank_mask);
 
 ret_success:
 	return HV_STATUS_SUCCESS;
-- 
2.37.3

