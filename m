Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23723533929
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbiEYJDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240694AbiEYJCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:02:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB8908CCE7
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FWs48XDz3Tvdn0Qygo9yW9hxcaZtTOfYZ3U55MH86YA=;
        b=XadV0a6h7MvrzhjqoVbCDTeNzh5Z2NabgSmLUOpfrVl+Qf1ACEpLfwsnk0VWWPeTni8ZDN
        UkeyxRndFQsJBIj3CpPH3T5CQ1bmmtrYPVcKmEmAGM/u6y9RatapO72ttFhpHCl1zGnJxt
        0sIDhunGHbLCtM9jxCceib23bFY4+4s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-NuZLJjJpM_uqyvRaFYgmPg-1; Wed, 25 May 2022 05:02:09 -0400
X-MC-Unique: NuZLJjJpM_uqyvRaFYgmPg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A40178219B2;
        Wed, 25 May 2022 09:02:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF66E40CF8EF;
        Wed, 25 May 2022 09:02:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 15/37] KVM: x86: Introduce .hv_inject_synthetic_vmexit_post_tlb_flush() nested hook
Date:   Wed, 25 May 2022 11:01:11 +0200
Message-Id: <20220525090133.1264239-16-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8bb224dac57f..19b62589bb2c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1593,6 +1593,7 @@ struct kvm_x86_nested_ops {
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
index 91174f0120a2..3b243abe0121 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1665,4 +1665,5 @@ struct kvm_x86_nested_ops svm_nested_ops = {
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
index ee88921c6156..c18495098834 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6850,4 +6850,5 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
+	.hv_inject_synthetic_vmexit_post_tlb_flush = vmx_hv_inject_synthetic_vmexit_post_tlb_flush,
 };
-- 
2.35.3

