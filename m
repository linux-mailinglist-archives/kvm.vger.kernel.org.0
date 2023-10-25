Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7FB7D70D9
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344981AbjJYP1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbjJYP0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:26:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EEB198
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JCE307w8DYtYzLu55wqwBWYbWWwCcRl3VdLWWJ4IDuA=;
        b=F1mE1K59dfqrvIPlJDr4yI2whYjQ4vfn1cq1QdGKMju4kirzitwbsWeUQXSjMCQP7Vj23K
        tyq1b13r4yqseYtMPkqBtMWQPA9yH+SaAZ6uXIq/4RyUjac6taHxYllEINyPA/V+DMZB7G
        XOTIuzPVm04QvxPADdRAMyquRmo0x8U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-HihJVEyBPzqMWpDA9xkrHg-1; Wed, 25 Oct 2023 11:24:24 -0400
X-MC-Unique: HihJVEyBPzqMWpDA9xkrHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47F6B185A789;
        Wed, 25 Oct 2023 15:24:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AAF82166B26;
        Wed, 25 Oct 2023 15:24:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] KVM: nSVM: hyper-v: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV
Date:   Wed, 25 Oct 2023 17:24:06 +0200
Message-ID: <20231025152406.1879274-15-vkuznets@redhat.com>
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct hv_vmcb_enlightenments' in VMCB only make sense when either
CONFIG_KVM_HYPERV or CONFIG_HYPERV is enabled.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++++++------
 arch/x86/kvm/svm/svm.h    |  2 ++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 74c04102ef01..20212aac050b 100644
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

