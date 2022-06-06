Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F034153E36A
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 10:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiFFIiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 04:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiFFIht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 04:37:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B73F3201A0
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 01:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654504655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3E43Fzw+oCB39QSOxfacQFbXPw0r2XrLSWBUCQjkAUc=;
        b=YmHMFYzMbw9D6d0yISrbnmek/yT+alRzPABjqU3TdT5djebrcomjVWaB/yDrcYTezqqWeJ
        8gphAQWEtFCK+ysxxQOBTSrGPVRGBn9xLAHK30u3HXDuzunpJf9sHM+q6GY4ELpp2w1kDz
        dfQ+ZSmVbMt5pGExATBS6O11P0tno6w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-m4oNoppFMc64juUNLeLLuQ-1; Mon, 06 Jun 2022 04:37:32 -0400
X-MC-Unique: m4oNoppFMc64juUNLeLLuQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 554E93C19024;
        Mon,  6 Jun 2022 08:37:32 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BF0A1121314;
        Mon,  6 Jun 2022 08:37:30 +0000 (UTC)
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
Subject: [PATCH v6 14/38] KVM: nSVM: Keep track of Hyper-V hv_vm_id/hv_vp_id
Date:   Mon,  6 Jun 2022 10:36:31 +0200
Message-Id: <20220606083655.2014609-15-vkuznets@redhat.com>
In-Reply-To: <20220606083655.2014609-1-vkuznets@redhat.com>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to nSVM, KVM needs to know L2's VM_ID/VP_ID and Partition
assist page address to handle L2 TLB flush requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/hyperv.h | 16 ++++++++++++++++
 arch/x86/kvm/svm/nested.c |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 7d6d97968fb9..8cf702fed7e5 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -9,6 +9,7 @@
 #include <asm/mshyperv.h>
 
 #include "../hyperv.h"
+#include "svm.h"
 
 /*
  * Hyper-V uses the software reserved 32 bytes in VMCB
@@ -32,4 +33,19 @@ struct hv_enlightenments {
  */
 #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
 
+static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct hv_enlightenments *hve =
+		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!hv_vcpu)
+		return;
+
+	hv_vcpu->nested.pa_page_gpa = hve->partition_assist_page;
+	hv_vcpu->nested.vm_id = hve->hv_vm_id;
+	hv_vcpu->nested.vp_id = hve->hv_vp_id;
+}
+
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 88da8edbe1e1..e8908cc56e22 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -811,6 +811,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	if (kvm_vcpu_apicv_active(vcpu))
 		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 
+	nested_svm_hv_update_vm_vp_ids(vcpu);
+
 	return 0;
 }
 
-- 
2.35.3

