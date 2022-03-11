Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01E04D6502
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 16:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349789AbiCKPvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 10:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349810AbiCKPvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 10:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2333A1CAF26
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 07:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647013821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hURzgvRKcr/batMnM0awJ6HNtSiG3Y83/511GoAYwDE=;
        b=T3asNBPlmMjoXeXkl9TPtzQVLIivrwCf/9/JDMtINLlJfvueWpWm+RZ7EH/e6y2URguvMd
        47gqmmMaQVC0LcmpCliK150Rtau67n9tRDYA4ZenLU4H53ZzqdQM+CW0RFO429KOeeK0vN
        OC9J16yp7Bn+44D8wQ4tcpfZ3hk01PY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-WIooUC8jOg66e011EQN3zQ-1; Fri, 11 Mar 2022 10:50:18 -0500
X-MC-Unique: WIooUC8jOg66e011EQN3zQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 649731006AA6;
        Fri, 11 Mar 2022 15:50:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4432866C1;
        Fri, 11 Mar 2022 15:50:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/31] KVM: nSVM: Keep track of Hyper-V hv_vm_id/hv_vp_id
Date:   Fri, 11 Mar 2022 16:49:22 +0100
Message-Id: <20220311154943.2299191-11-vkuznets@redhat.com>
In-Reply-To: <20220311154943.2299191-1-vkuznets@redhat.com>
References: <20220311154943.2299191-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to nSVM, KVM needs to know L2's VM_ID/VP_ID and Partition
assist page address to handle Direct TLB flush requests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/hyperv.h | 15 +++++++++++++++
 arch/x86/kvm/svm/nested.c |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 7d6d97968fb9..27479469f672 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -32,4 +32,19 @@ struct hv_enlightenments {
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
index 96bab464967f..f47570fa503e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -752,6 +752,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	svm->nested.nested_run_pending = 1;
 
+	nested_svm_hv_update_vm_vp_ids(vcpu);
+
 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
 
-- 
2.35.1

