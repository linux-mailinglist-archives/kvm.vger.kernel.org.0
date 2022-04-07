Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87904F8434
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 17:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345329AbiDGP7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 11:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345300AbiDGP7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 11:59:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 351E8CD640
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 08:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649347030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JsGxPCeIKZDyWRW8Nmrbrjsq1oZ7q4hh+cS1qsUvDXw=;
        b=O7nAmb0Wk4p2yudLl9e008yOCTbWfhspn//9dRmaLMJDPKmYpV8KDgM8L2D93abmds0/lA
        TQ+fHr2vf8PX+rfA8ztF/WUNO69CtiYry4lMQv1MclBdAFnQwMfBAxGd85T25gO7w17Jdh
        JJQ2K2te2MnFPKdYgq7+57KA4303i9w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-ZUrpylJGMfajW00zfj-9ew-1; Thu, 07 Apr 2022 11:57:07 -0400
X-MC-Unique: ZUrpylJGMfajW00zfj-9ew-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AB07811E83;
        Thu,  7 Apr 2022 15:57:06 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73320427852;
        Thu,  7 Apr 2022 15:57:04 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/31] KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv' instead of on-stack 'sparse_banks'
Date:   Thu,  7 Apr 2022 17:56:22 +0200
Message-Id: <20220407155645.940890-9-vkuznets@redhat.com>
In-Reply-To: <20220407155645.940890-1-vkuznets@redhat.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make kvm_hv_flush_tlb() ready to handle Direct TLB flush request
KVM needs to allow for all 64 sparse vCPU banks regardless of KVM_MAX_VCPUs
as L1 may use vCPU overcommit for L2. To avoid growing on-stack allocation,
make 'sparse_banks' part of per-vCPU 'struct kvm_vcpu_hv' which is
allocated dynamically.

Note: sparse_set_to_vcpu_mask() keeps using on-stack allocation as it
won't be used to handle Direct TLB flush requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/hyperv.c           | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b8d7c1422da6..4458abc1d41d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -619,6 +619,9 @@ struct kvm_vcpu_hv {
 
 	/* Two rings for regular Hyper-V TLB flush and Direct TLB flush */
 	struct kvm_vcpu_hv_tlbflush_ring tlb_flush_ring[2];
+
+	/* Preallocated buffer for handling hypercalls passing sparse vCPU set */
+	u64 sparse_banks[64];
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 16cbf41b5b7b..705c0b739c1b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1955,13 +1955,14 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 *sparse_banks = hv_vcpu->sparse_banks;
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
 	u64 entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];
 	u64 valid_bank_mask;
-	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	struct kvm_vcpu *v;
 	unsigned long i;
 	bool all_cpus, all_addr;
@@ -2113,11 +2114,12 @@ static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
 
 static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 *sparse_banks = hv_vcpu->sparse_banks;
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_send_ipi_ex send_ipi_ex;
 	struct hv_send_ipi send_ipi;
 	unsigned long valid_bank_mask;
-	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
 	bool all_cpus;
 
-- 
2.35.1

