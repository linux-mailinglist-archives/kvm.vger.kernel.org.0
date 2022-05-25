Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D42533916
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbiEYJCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238576AbiEYJCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:02:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 686128B081
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HoOAusWmUMY8Nd0DAMfN6GftY7vo4orAj4jzmtrXqh4=;
        b=bR1nEK9x1cRTXhd5zEYfpbD3ecX4+0mvi3I76M+Y/xZ0shkSQrw2QLI3LQGAE2a7d2fbeT
        TEZL+5iMGHnT3DCxoEnMuEYff66Cz1nxSJUXICkVcl70WY/gpIzozpQcwL3KhwKl+uHUpd
        sj9TRpi57IMJmsBcWR2sqxrUEllBLaQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-8BvxXyzcNTWV3T6S8_zv-A-1; Wed, 25 May 2022 05:01:58 -0400
X-MC-Unique: 8BvxXyzcNTWV3T6S8_zv-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA0FD804191;
        Wed, 25 May 2022 09:01:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35CBF405D4BF;
        Wed, 25 May 2022 09:01:56 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/37] KVM: x86: hyper-v: Don't use sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
Date:   Wed, 25 May 2022 11:01:06 +0200
Message-Id: <20220525090133.1264239-11-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 287eaca4db3c..dbefb492aa35 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1747,6 +1747,25 @@ static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
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
@@ -2031,8 +2050,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
 }
 
-static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
-				 unsigned long *vcpu_bitmap)
+static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
+				    u64 *sparse_banks, u64 valid_bank_mask)
 {
 	struct kvm_lapic_irq irq = {
 		.delivery_mode = APIC_DM_FIXED,
@@ -2042,7 +2061,10 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
 	unsigned long i;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
+		if (sparse_banks &&
+		    !hv_is_vp_in_sparse_set(kvm_hv_get_vpindex(vcpu),
+					    valid_bank_mask,
+					    sparse_banks))
 			continue;
 
 		/* We fail only when APIC is disabled */
@@ -2055,7 +2077,6 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
-	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	unsigned long valid_bank_mask;
 	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
@@ -2117,13 +2138,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
2.35.3

