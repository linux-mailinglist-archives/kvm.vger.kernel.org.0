Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2819E4D01F1
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243533AbiCGOw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243554AbiCGOwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6D548F9B7
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646664663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XOcWusSZxfVAQxi+6yy4OU0x+iluiqnnS/j7sPesIOk=;
        b=N5leXtBKXM5cusyrFRL24uMgsvmXfyZlnHJ3AtS+T3Upsr3rgA4Vs0EhV0Kk+tzxlY0WRc
        PIEWimDsEnvt7E6eZOVa0l0jDfcpEEmdvku5J38Lucm5X34eYSN+AZgGRBo/9+kR3JIB6z
        wEhM0i6RAKP1A8QRFoaOdcw9HvkK5tM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-j49EC63zOcuRtsgnXx9_OA-1; Mon, 07 Mar 2022 09:51:00 -0500
X-MC-Unique: j49EC63zOcuRtsgnXx9_OA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 749FB824FA8;
        Mon,  7 Mar 2022 14:50:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D11A7F0D6;
        Mon,  7 Mar 2022 14:50:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 11/19] KVM: x86: Introduce .post_hv_direct_flush() nested hook
Date:   Mon,  7 Mar 2022 15:50:15 +0100
Message-Id: <20220307145023.1913205-12-vkuznets@redhat.com>
In-Reply-To: <20220307145023.1913205-1-vkuznets@redhat.com>
References: <20220307145023.1913205-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Hyper-V supports injecting synthetic L2->L1 exit after performing
Direct TLB flush operation but the procedure is vendor
specific. Introduce .post_hv_direct_flush() nested hook for it.

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
index 21b502aa9655..45ee05f4f1a0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1538,6 +1538,7 @@ struct kvm_x86_nested_ops {
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
 			    uint16_t *vmcs_version);
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
+	void (*post_hv_direct_flush)(struct kvm_vcpu *vcpu);
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
index 000000000000..0142fde34738
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
+void svm_post_hv_direct_flush(struct kvm_vcpu *vcpu)
+{
+}
diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 27479469f672..478db6f61d69 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -47,4 +47,6 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
 	hv_vcpu->nested.vp_id = hve->hv_vp_id;
 }
 
+void svm_post_hv_direct_flush(struct kvm_vcpu *vcpu);
+
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f47570fa503e..46ea234363cf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1573,4 +1573,5 @@ struct kvm_x86_nested_ops svm_nested_ops = {
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
 	.set_state = svm_set_nested_state,
+	.post_hv_direct_flush = svm_post_hv_direct_flush,
 };
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 87e3dc10edf4..1705c4973636 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -437,3 +437,7 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+void vmx_post_hv_direct_flush(struct kvm_vcpu *vcpu)
+{
+}
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 8d70f9aea94b..8862692a4c5d 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -244,5 +244,6 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
 void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
+void vmx_post_hv_direct_flush(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index dd3054c3291c..a9fb6c63f849 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6828,4 +6828,5 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
+	.post_hv_direct_flush = vmx_post_hv_direct_flush,
 };
-- 
2.35.1

