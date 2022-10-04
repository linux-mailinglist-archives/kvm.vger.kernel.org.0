Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E0C5F4386
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 14:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiJDMu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 08:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJDMuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 08:50:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402015FDD2
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 05:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664887623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcLmf4WreUvIvvpPtaDC32YuYtyFtYkrgIUYKQrkhBc=;
        b=ERr09HWxll095ySbzIIWa7vUnL+uqjexmoo85cKev0t9lfH/rB1ti1ieCwIp40qoskMpwR
        eRCm8XyOCYYRDGBmHs1BEVNoD+5MKrGU2Aq+WgdtTb27Dr0IwMJLurKUSmtrOAJzpPbGJ1
        He0MiSfvP+VmN+qAJO9XBgNxP+xP4Mc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-F_Ie9UWGMDmBiL8USyi6pA-1; Tue, 04 Oct 2022 08:40:49 -0400
X-MC-Unique: F_Ie9UWGMDmBiL8USyi6pA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40FBD8027FE;
        Tue,  4 Oct 2022 12:40:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2445E7AE5;
        Tue,  4 Oct 2022 12:40:47 +0000 (UTC)
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
Subject: [PATCH v11 20/46] KVM: nSVM: Keep track of Hyper-V hv_vm_id/hv_vp_id
Date:   Tue,  4 Oct 2022 14:39:30 +0200
Message-Id: <20221004123956.188909-21-vkuznets@redhat.com>
In-Reply-To: <20221004123956.188909-1-vkuznets@redhat.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

