Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174984D6503
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349786AbiCKPvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349649AbiCKPvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:51:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F9F51CBAB8
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647013811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xc/ODvBs4ahi/YUBp9hveSuWTL5SxZ2u6EliH0Mv57o=;
        b=Tfjl+WaYqzAOXiYPAT8pmJ9Q/Wn0x+wr6E4H6dqQzGysyskPJ7RIt/3OtQ1K/P/HCmBZne
        ElMsUBYf4zxieYK/RsL0DDfqaLKGRn0izQgi9dDasMRzhArn9i5+GrlSAosEd+zeeMFJ8K
        ZNCSibBsjFRAJi+Dej9wKrgaS68byLY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-g3FEoLYsNqmT_L-58hCU1A-1; Fri, 11 Mar 2022 10:50:06 -0500
X-MC-Unique: g3FEoLYsNqmT_L-58hCU1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5DF751DF;
        Fri, 11 Mar 2022 15:50:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87BB4785FD;
        Fri, 11 Mar 2022 15:50:02 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/31] KVM: x86: hyper-v: Don't use sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
Date:   Fri, 11 Mar 2022 16:49:18 +0100
Message-Id: <20220311154943.2299191-7-vkuznets@redhat.com>
In-Reply-To: <20220311154943.2299191-1-vkuznets@redhat.com>
References: <20220311154943.2299191-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
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

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 53eb9540494b..7efa34fb15ef 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1760,6 +1760,23 @@ static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
 	}
 }
 
+static bool hv_is_vp_in_sparse_set(u32 vp_id, u64 valid_bank_mask, u64 sparse_banks[])
+{
+	int bank, sbank = 0;
+
+	if (!test_bit(vp_id / 64, (unsigned long *)&valid_bank_mask))
+		return false;
+
+	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
+			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS) {
+		if (bank == vp_id / 64)
+			break;
+		sbank++;
+	}
+
+	return test_bit(vp_id % 64, (unsigned long *)&sparse_banks[sbank]);
+}
+
 struct kvm_hv_hcall {
 	u64 param;
 	u64 ingpa;
@@ -2085,8 +2102,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
 }
 
-static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
-				 unsigned long *vcpu_bitmap)
+static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
+				    u64 *sparse_banks, u64 valid_bank_mask)
 {
 	struct kvm_lapic_irq irq = {
 		.delivery_mode = APIC_DM_FIXED,
@@ -2096,7 +2113,10 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
 	unsigned long i;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
+		if (sparse_banks &&
+		    !hv_is_vp_in_sparse_set(kvm_hv_get_vpindex(vcpu),
+					    valid_bank_mask,
+					    sparse_banks))
 			continue;
 
 		/* We fail only when APIC is disabled */
@@ -2109,7 +2129,6 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
-	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	unsigned long valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
@@ -2171,13 +2190,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
2.35.1

