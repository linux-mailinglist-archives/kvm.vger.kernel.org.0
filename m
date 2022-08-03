Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A75588D99
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiHCNqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbiHCNqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:46:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53C501E3CF
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qjUqc8Z8T19XOPMcEP/c8pE+F1iqS+njcRI7xxtc2ZE=;
        b=M6cgBGm5xkLndMQEH2HkgNMOvBl2aYmzeGly7pVzfeU34+ia5tB0IeklLtR9YNJCXxrxnx
        OwlqU3Qa2osxwx/jtK7Lc/fgi2GhTmdqy/0Vm/PJEfpITen/9AC/BPzCKHtDOYjOwTi76o
        fqBDAhy4QB+D3FDtxEuT7Ryjsrpe4Q0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-6wIaBsM5MhWEZDOHledYDg-1; Wed, 03 Aug 2022 09:46:04 -0400
X-MC-Unique: 6wIaBsM5MhWEZDOHledYDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E75E18039CB;
        Wed,  3 Aug 2022 13:46:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1FC72026D4C;
        Wed,  3 Aug 2022 13:46:01 +0000 (UTC)
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
Subject: [PATCH v9 18/40] KVM: x86: hyper-v: Introduce fast guest_hv_cpuid_has_l2_tlb_flush() check
Date:   Wed,  3 Aug 2022 15:46:00 +0200
Message-Id: <20220803134600.399296-1-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a helper to quickly check if KVM needs to handle VMCALL/VMMCALL
from L2 in L0 to process L2 TLB flush requests.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/hyperv.c           | 6 ++++++
 arch/x86/kvm/hyperv.h           | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 75b95598b9fc..55845ece64f2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -641,6 +641,7 @@ struct kvm_vcpu_hv {
 		u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
 		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
 		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
+		u32 nested_features_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
 	} cpuid_cache;
 
 	struct kvm_vcpu_hv_tlb_flush_fifo tlb_flush_fifo[HV_NR_TLB_FLUSH_FIFOS];
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index be25a8ddab9d..42498a9132a5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2229,6 +2229,12 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
 	else
 		hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
+
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_NESTED_FEATURES);
+	if (entry)
+		hv_vcpu->cpuid_cache.nested_features_eax = entry->eax;
+	else
+		hv_vcpu->cpuid_cache.nested_features_eax = 0;
 }
 
 int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 892c252b9bc3..0985c4beb69e 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -170,6 +170,13 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
 	kfifo_reset_out(&tlb_flush_fifo->entries);
 }
 
+static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	return hv_vcpu && (hv_vcpu->cpuid_cache.nested_features_eax & HV_X64_NESTED_DIRECT_FLUSH);
+}
+
 static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
-- 
2.35.3

