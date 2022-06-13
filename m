Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE53549ADC
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245740AbiFMR7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 13:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243831AbiFMRz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 13:55:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB2A7B4A7
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 06:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655127620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4RHtZYmh1/hSKAF7EcOWsrPLAw2WLQLmCnsabCdCID4=;
        b=iKx18k2VZJEwzuF9jxshEukoCZ620wCDQPjPPsVAjYTEGP72EDAodXskJyrsDE1XyPyOAr
        xhl7b3Y95CrNc+e7rsQBZRcvz/gJeiCOiYxnAUChxkRbYDQohkRQvs5SCPW/ne2Xd7s0TN
        mF+4jJJscn0hzrkzeNLPQHGWyxfhExQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-XfCMtZhxN2ev4gC8DedSmA-1; Mon, 13 Jun 2022 09:40:09 -0400
X-MC-Unique: XfCMtZhxN2ev4gC8DedSmA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE3C2101E985;
        Mon, 13 Jun 2022 13:40:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C52BF492CA2;
        Mon, 13 Jun 2022 13:40:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 15/39] KVM: x86: Introduce .hv_inject_synthetic_vmexit_post_tlb_flush() nested hook
Date:   Mon, 13 Jun 2022 15:38:58 +0200
Message-Id: <20220613133922.2875594-16-vkuznets@redhat.com>
In-Reply-To: <20220613133922.2875594-1-vkuznets@redhat.com>
References: <20220613133922.2875594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V supports injecting synthetic L2->L1 exit after performing
L2 TLB flush operation but the procedure is vendor specific. Introduce
.hv_inject_synthetic_vmexit_post_tlb_flush nested hook for it.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Makefile           |  3 ++-
 arch/x86/kvm/svm/hyperv.c       | 11 +++++++++++
 arch/x86/kvm/svm/hyperv.h       |  2 ++
 arch/x86/kvm/svm/nested.c       |  1 +
 arch/x86/kvm/vmx/evmcs.c        |  4 ++++
 arch/x86/kvm/vmx/evmcs.h        |  1 +
 arch/x86/kvm/vmx/nested.c       |  1 +
 8 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/svm/hyperv.c

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 915078a6c4be..d4a2cf4b4ff5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1669,6 +1669,7 @@ struct kvm_x86_nested_ops {
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
 			    uint16_t *vmcs_version);
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
+	void (*hv_inject_synthetic_vmexit_post_tlb_flush)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 30f244b64523..b6d53b045692 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -25,7 +25,8 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 
-kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
+kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
+			   svm/sev.o svm/hyperv.o
 
 ifdef CONFIG_HYPERV
 kvm-amd-y		+= svm/svm_onhyperv.o
diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
new file mode 100644
index 000000000000..911f51021af1
--- /dev/null
+++ b/arch/x86/kvm/svm/hyperv.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD SVM specific code for Hyper-V on KVM.
+ *
+ * Copyright 2022 Red Hat, Inc. and/or its affiliates.
+ */
+#include "hyperv.h"
+
+void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
+{
+}
diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 8cf702fed7e5..dd2e393f84a0 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -48,4 +48,6 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
 	hv_vcpu->nested.vp_id = hve->hv_vp_id;
 }
 
+void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
+
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1c1fa4fdea17..c43ba5b39288 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1721,4 +1721,5 @@ struct kvm_x86_nested_ops svm_nested_ops = {
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
 	.set_state = svm_set_nested_state,
+	.hv_inject_synthetic_vmexit_post_tlb_flush = svm_hv_inject_synthetic_vmexit_post_tlb_flush,
 };
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 6a61b1ae7942..805afc170b5b 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -439,3 +439,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
+{
+}
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index f886a8ff0342..584741b85eb6 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -245,5 +245,6 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
+void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6e264a7f205b..4a827b3d929a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6863,4 +6863,5 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
+	.hv_inject_synthetic_vmexit_post_tlb_flush = vmx_hv_inject_synthetic_vmexit_post_tlb_flush,
 };
-- 
2.35.3

