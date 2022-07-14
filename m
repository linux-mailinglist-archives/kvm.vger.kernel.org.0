Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE50574FBE
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbiGNNua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 09:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239935AbiGNNuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:50:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D17B39BBA
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eVFFVBL+986rALWF8uFBwLMDDz33rPA2CriD+2LfnvY=;
        b=U9t4xFTLQ6ioGUmlcIOVxvCvlnzPE+Z2BVVRLEg4JFuRRJXl6Ui7KKRgQX2jbGy5vUKXd5
        vNvaJmP4eWwdGgvuQ32EJ264TpmHTV6Jfl+qbXMZ/epF+OK4QgyKkErMJmigqAJP2L66Rt
        pTKXZTiwnTyCDbxBEywgIw0NHcmI4eg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-EtV9f0BWMcare6S6aiI7lw-1; Thu, 14 Jul 2022 09:50:02 -0400
X-MC-Unique: EtV9f0BWMcare6S6aiI7lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7555B29DD988;
        Thu, 14 Jul 2022 13:50:01 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AECAE2166B2A;
        Thu, 14 Jul 2022 13:49:59 +0000 (UTC)
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
Subject: [PATCH v8 12/39] KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv' instead of on-stack 'sparse_banks'
Date:   Thu, 14 Jul 2022 15:49:02 +0200
Message-Id: <20220714134929.1125828-13-vkuznets@redhat.com>
In-Reply-To: <20220714134929.1125828-1-vkuznets@redhat.com>
References: <20220714134929.1125828-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make kvm_hv_flush_tlb() ready to handle L2 TLB flush requests, KVM needs
to allow for all 64 sparse vCPU banks regardless of KVM_MAX_VCPUs as L1
may use vCPU overcommit for L2. To avoid growing on-stack allocation, make
'sparse_banks' part of per-vCPU 'struct kvm_vcpu_hv' which is allocated
dynamically.

Note: sparse_set_to_vcpu_mask() can't currently be used to handle L2
requests as KVM does not keep L2 VM_ID -> L2 VCPU_ID -> L1 vCPU mappings,
i.e. its vp_bitmap array is still bounded by the number of L1 vCPUs and so
can remain an on-stack allocation.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/hyperv.c           | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8c23fd736526..228df43f75d3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -645,6 +645,9 @@ struct kvm_vcpu_hv {
 	} cpuid_cache;
 
 	struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo[HV_NR_TLB_FLUSH_FIFOS];
+
+	/* Preallocated buffer for handling hypercalls passing sparse vCPU set */
+	u64 sparse_banks[HV_MAX_SPARSE_VCPU_BANKS];
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index d1481d6e9b62..8cababe6df62 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1910,6 +1910,8 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 *sparse_banks = hv_vcpu->sparse_banks;
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
@@ -1923,7 +1925,6 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	u64 __tlb_flush_entries[KVM_HV_TLB_FLUSH_FIFO_SIZE - 1];
 	u64 *tlb_flush_entries;
 	u64 valid_bank_mask;
-	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	struct kvm_vcpu *v;
 	unsigned long i;
 	bool all_cpus;
@@ -2075,11 +2076,12 @@ static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
 
 static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 *sparse_banks = hv_vcpu->sparse_banks;
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
 	u64 valid_bank_mask;
-	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
 	bool all_cpus;
 
-- 
2.35.3

