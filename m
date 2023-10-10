Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F37C0126
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbjJJQEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjJJQEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:04:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FD2F0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696953795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0PzOYNiEjMNfxgDoRNUukN0hkebqWs832TM4JCa3Qvo=;
        b=fnO2rigw78XELzQHTqVs2RQSIDzFYN6L9n7Al9tJTFb/jaLzUZQIZiGe8GNu6jCth9ti2P
        vGpxgE1EbPEbdny4R9FUbbH0vm2dF6wDzlyxL1kho5tsvkjDIpmmcXbNb0sNXJbpg7MvSO
        jHI4+l4RtJwKqGGJNxHzaISUbGRQ30Q=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-Vw-Xhwn5NZ23BnzXlR3Yqg-1; Tue, 10 Oct 2023 12:03:14 -0400
X-MC-Unique: Vw-Xhwn5NZ23BnzXlR3Yqg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEF4C2932486;
        Tue, 10 Oct 2023 16:03:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B848158;
        Tue, 10 Oct 2023 16:03:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH RFC 11/11] KVM: nSVM: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV
Date:   Tue, 10 Oct 2023 18:03:00 +0200
Message-ID: <20231010160300.1136799-12-vkuznets@redhat.com>
In-Reply-To: <20231010160300.1136799-1-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct hv_vmcb_enlightenments' in VMCB only make sense when either
CONFIG_KVM_HYPERV or CONFIG_HYPERV is enabled.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++++++------
 arch/x86/kvm/svm/svm.h    |  2 ++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4d8cd378a30b..5ae41a708005 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -187,7 +187,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
  */
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
-	struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
 	int i;
 
 	/*
@@ -198,11 +197,16 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	 * - Nested hypervisor (L1) is using Hyper-V emulation interface and
 	 * tells KVM (L0) there were no changes in MSR bitmap for L2.
 	 */
-	if (!svm->nested.force_msr_bitmap_recalc &&
-	    kvm_hv_hypercall_enabled(&svm->vcpu) &&
-	    hve->hv_enlightenments_control.msr_bitmap &&
-	    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
-		goto set_msrpm_base_pa;
+#ifdef CONFIG_KVM_HYPERV
+	if (!svm->nested.force_msr_bitmap_recalc) {
+		struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
+
+		if (kvm_hv_hypercall_enabled(&svm->vcpu) &&
+		    hve->hv_enlightenments_control.msr_bitmap &&
+		    (svm->nested.ctl.clean & BIT(HV_VMCB_NESTED_ENLIGHTENMENTS)))
+			goto set_msrpm_base_pa;
+	}
+#endif
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return true;
@@ -230,7 +234,9 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 
 	svm->nested.force_msr_bitmap_recalc = false;
 
+#ifdef CONFIG_KVM_HYPERV
 set_msrpm_base_pa:
+#endif
 	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
 
 	return true;
@@ -378,12 +384,14 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->msrpm_base_pa &= ~0x0fffULL;
 	to->iopm_base_pa  &= ~0x0fffULL;
 
+#ifdef CONFIG_KVM_HYPERV
 	/* Hyper-V extensions (Enlightened VMCB) */
 	if (kvm_hv_hypercall_enabled(vcpu)) {
 		to->clean = from->clean;
 		memcpy(&to->hv_enlightenments, &from->hv_enlightenments,
 		       sizeof(to->hv_enlightenments));
 	}
+#endif
 }
 
 void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be67ab7fdd10..59adff7bbf55 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -148,7 +148,9 @@ struct vmcb_ctrl_area_cached {
 	u64 virt_ext;
 	u32 clean;
 	union {
+#if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_KVM_HYPERV)
 		struct hv_vmcb_enlightenments hv_enlightenments;
+#endif
 		u8 reserved_sw[32];
 	};
 };
-- 
2.41.0

