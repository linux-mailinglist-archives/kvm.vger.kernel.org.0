Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583715010D3
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbiDNNhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 09:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244725AbiDNN2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 09:28:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C00D5986C9
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 06:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649942448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkqFYsX1GJuFAgE9Tv1saFsZGgkMsmfzA+EnM1j3Wsg=;
        b=NiJ8W3kXU7WnhNY6C2nHXzpqw66Z0T61sh8DHjZvR/NQHVjms3l0+appcJuWo+HF03uTJ+
        raiXx2bM5p3+5Prw3MmRTvf6pYwgJ3zdNgHWDLzo+0FXRxRe/uyDfvLpFsSJUGt1BHQXgt
        N48ay88ZgF2bsGLbantprZdDYU8ToMg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-lrklUccCObKvXmg8uFSZ6Q-1; Thu, 14 Apr 2022 09:20:45 -0400
X-MC-Unique: lrklUccCObKvXmg8uFSZ6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A86331C10468;
        Thu, 14 Apr 2022 13:20:39 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99A6B814B;
        Thu, 14 Apr 2022 13:20:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/34] KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv' instead of on-stack 'sparse_banks'
Date:   Thu, 14 Apr 2022 15:19:50 +0200
Message-Id: <20220414132013.1588929-12-vkuznets@redhat.com>
In-Reply-To: <20220414132013.1588929-1-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Note: sparse_set_to_vcpu_mask() keeps using on-stack allocation as it
won't be used to handle L2 TLB flush requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/hyperv.c           | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 058061621872..837c07e213de 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -619,6 +619,9 @@ struct kvm_vcpu_hv {
 	} cpuid_cache;
 
 	struct kvm_vcpu_hv_tlb_flush_ring tlb_flush_ring[HV_NR_TLB_FLUSH_RINGS];
+
+	/* Preallocated buffer for handling hypercalls passing sparse vCPU set */
+	u64 sparse_banks[64];
 };
 
 /* Xen HVM per vcpu emulation context */
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1cef2b8f7001..e9793d36acca 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1968,6 +1968,8 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 {
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	u64 *sparse_banks = hv_vcpu->sparse_banks;
 	struct kvm *kvm = vcpu->kvm;
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
@@ -1982,7 +1984,6 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	u64 __tlb_flush_entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];
 	u64 *tlb_flush_entries;
 	u64 valid_bank_mask;
-	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	struct kvm_vcpu *v;
 	unsigned long i;
 	bool all_cpus;
@@ -2134,11 +2135,12 @@ static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
 
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

