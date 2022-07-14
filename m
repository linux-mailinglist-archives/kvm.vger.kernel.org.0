Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93139574FDE
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 15:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbiGNNvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 09:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240039AbiGNNuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:50:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 996D361D51
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UKcSfbCOiqiRPuxMtPr6RZso+xEbgRL4c9vb1+dYMeU=;
        b=Mu1xoMXtO3YAxs3h5P6Mp5hUXNnFHmlO635T4DfFQeaT06dXHxbq2g7v7Viux0j4izZbge
        O8BcgjwFUAlImZXmCM4QUsuNoZQP918j8nn3GPHRQvhLL7TnNCXdFstxoagiomAu8+fiTB
        pNjJM0iHROwXon9Z5eaGMCXcIUc9PLQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-vX5OMiJ4MOmG2fmS2t7LlA-1; Thu, 14 Jul 2022 09:50:20 -0400
X-MC-Unique: vX5OMiJ4MOmG2fmS2t7LlA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DADE4823F10;
        Thu, 14 Jul 2022 13:50:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 045AA2166B26;
        Thu, 14 Jul 2022 13:50:17 +0000 (UTC)
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
Subject: [PATCH v8 20/39] KVM: nVMX: hyper-v: Cache VP assist page in 'struct kvm_vcpu_hv'
Date:   Thu, 14 Jul 2022 15:49:10 +0200
Message-Id: <20220714134929.1125828-21-vkuznets@redhat.com>
In-Reply-To: <20220714134929.1125828-1-vkuznets@redhat.com>
References: <20220714134929.1125828-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to enabling L2 TLB flush, cache VP assist page in
'struct kvm_vcpu_hv'. While on it, rename nested_enlightened_vmentry()
to nested_get_evmptr() and make it return eVMCS GPA directly.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/hyperv.c           | 10 ++++++----
 arch/x86/kvm/hyperv.h           |  3 +--
 arch/x86/kvm/vmx/evmcs.c        | 21 +++++++--------------
 arch/x86/kvm/vmx/evmcs.h        |  2 +-
 arch/x86/kvm/vmx/nested.c       |  6 +++---
 6 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 58d1edd7ae8b..b2d595549af0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -650,6 +650,8 @@ struct kvm_vcpu_hv {
 	/* Preallocated buffer for handling hypercalls passing sparse vCPU set */
 	u64 sparse_banks[HV_MAX_SPARSE_VCPU_BANKS];
 
+	struct hv_vp_assist_page vp_assist_page;
+
 	struct {
 		u64 pa_page_gpa;
 		u64 vm_id;
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4ddf1a71ea43..edb042413bb4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -903,13 +903,15 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
 
-bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
-			    struct hv_vp_assist_page *assist_page)
+bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_hv_assist_page_enabled(vcpu))
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!hv_vcpu || !kvm_hv_assist_page_enabled(vcpu))
 		return false;
+
 	return !kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data,
-				      assist_page, sizeof(*assist_page));
+				      &hv_vcpu->vp_assist_page, sizeof(struct hv_vp_assist_page));
 }
 EXPORT_SYMBOL_GPL(kvm_hv_get_assist_page);
 
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 0985c4beb69e..cc5be1dcb6a1 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -105,8 +105,7 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu);
-bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
-			    struct hv_vp_assist_page *assist_page);
+bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu);
 
 static inline struct kvm_vcpu_hv_stimer *to_hv_stimer(struct kvm_vcpu *vcpu,
 						      int timer_index)
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 805afc170b5b..7cd7b16942c6 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -307,24 +307,17 @@ __init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 }
 #endif
 
-bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa)
+u64 nested_get_evmptr(struct kvm_vcpu *vcpu)
 {
-	struct hv_vp_assist_page assist_page;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 
-	*evmcs_gpa = -1ull;
+	if (unlikely(!kvm_hv_get_assist_page(vcpu)))
+		return EVMPTR_INVALID;
 
-	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
-		return false;
+	if (unlikely(!hv_vcpu->vp_assist_page.enlighten_vmentry))
+		return EVMPTR_INVALID;
 
-	if (unlikely(!assist_page.enlighten_vmentry))
-		return false;
-
-	if (unlikely(!evmptr_is_valid(assist_page.current_nested_vmcs)))
-		return false;
-
-	*evmcs_gpa = assist_page.current_nested_vmcs;
-
-	return true;
+	return hv_vcpu->vp_assist_page.current_nested_vmcs;
 }
 
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 584741b85eb6..22d238b36238 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -239,7 +239,7 @@ enum nested_evmptrld_status {
 	EVMPTRLD_ERROR,
 };
 
-bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
+u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5df0a2274a5c..b3ebb18375e3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1996,7 +1996,8 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	if (likely(!vmx->nested.enlightened_vmcs_enabled))
 		return EVMPTRLD_DISABLED;
 
-	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa)) {
+	evmcs_gpa = nested_get_evmptr(vcpu);
+	if (!evmptr_is_valid(evmcs_gpa)) {
 		nested_release_evmcs(vcpu);
 		return EVMPTRLD_DISABLED;
 	}
@@ -5069,7 +5070,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 zero = 0;
 	gpa_t vmptr;
-	u64 evmcs_gpa;
 	int r;
 
 	if (!nested_vmx_check_permission(vcpu))
@@ -5095,7 +5095,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
 	 */
 	if (likely(!vmx->nested.enlightened_vmcs_enabled ||
-		   !nested_enlightened_vmentry(vcpu, &evmcs_gpa))) {
+		   !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
 
-- 
2.35.3

