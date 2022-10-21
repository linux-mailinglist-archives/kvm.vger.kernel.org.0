Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49BD607B06
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJUPhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiJUPgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:36:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4DB26FFA3
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcLmf4WreUvIvvpPtaDC32YuYtyFtYkrgIUYKQrkhBc=;
        b=FyPCi+Vk5wt+T5yIpTYBDil2epOs33Cw3BIhkI7Aa6+OtgF8cPZvGKErvvrJ7HcKyOhxe+
        UlsTNcLy26noBUTD2eNO9nNmjcF+1o90rt6Gz8loe1FxHPg616qXj1OhzBORWHn0sbeSCY
        DtCMLQs8k1cyGZoDpzvzT85Zx/mnDEg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-LoMbqfi5PVWEvfVrrhZSVw-1; Fri, 21 Oct 2022 11:36:18 -0400
X-MC-Unique: LoMbqfi5PVWEvfVrrhZSVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5023A886462;
        Fri, 21 Oct 2022 15:36:15 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1898E40CA41F;
        Fri, 21 Oct 2022 15:36:12 +0000 (UTC)
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
Subject: [PATCH v12 20/46] KVM: nSVM: Keep track of Hyper-V hv_vm_id/hv_vp_id
Date:   Fri, 21 Oct 2022 17:34:55 +0200
Message-Id: <20221021153521.1216911-21-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to nSVM, KVM needs to know L2's VM_ID/VP_ID and Partition
assist page address to handle L2 TLB flush requests.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/hyperv.h | 15 +++++++++++++++
 arch/x86/kvm/svm/nested.c |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index c59544cdf03b..e97d80974e72 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -9,5 +9,20 @@
 #include <asm/mshyperv.h>
 
 #include "../hyperv.h"
+#include "svm.h"
+
+static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!hv_vcpu)
+		return;
+
+	hv_vcpu->nested.pa_page_gpa = hve->partition_assist_page;
+	hv_vcpu->nested.vm_id = hve->hv_vm_id;
+	hv_vcpu->nested.vp_id = hve->hv_vp_id;
+}
 
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c2a49aa50a58..45bab740f3f0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -799,6 +799,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	if (kvm_vcpu_apicv_active(vcpu))
 		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 
+	nested_svm_hv_update_vm_vp_ids(vcpu);
+
 	return 0;
 }
 
-- 
2.37.3

