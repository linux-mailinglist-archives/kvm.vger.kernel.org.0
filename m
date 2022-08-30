Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2635A6505
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiH3Nic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiH3NiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F479E7279
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZuyXBgJ7ZSGVJbH5YvhLNIwOw2OQmbmprSDoPPPs2I=;
        b=USRMLyqISzsG3Wll5pArXp9Stl7WoNLy/F7XQHENWHJWCEmMGom37LgvTjwidD4hE2Qg1k
        d9tBcsvF9WYp//H2FYQEUtc2ARq9dvMTwrv0yfCSijwcGm2znfuZd5EqQmDVeCBFESLOST
        2JXPDqtSjqlDKlYQLA3mQc+GMVL7rOE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-kGyDQ548O52yG2sDMeOI7w-1; Tue, 30 Aug 2022 09:37:55 -0400
X-MC-Unique: kGyDQ548O52yG2sDMeOI7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1998A3C0D855;
        Tue, 30 Aug 2022 13:37:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B94942166B26;
        Tue, 30 Aug 2022 13:37:52 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/33] KVM: nVMX: Treat eVMCS as enabled for guest iff Hyper-V is also enabled
Date:   Tue, 30 Aug 2022 15:37:10 +0200
Message-Id: <20220830133737.1539624-7-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

When querying whether or not eVMCS is enabled on behalf of the guest,
treat eVMCS as enable if and only if Hyper-V is enabled/exposed to the
guest.

Note, flows that come from the host, e.g. KVM_SET_NESTED_STATE, must NOT
check for Hyper-V being enabled as KVM doesn't require guest CPUID to be
set before most ioctls().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c  |  3 +++
 arch/x86/kvm/vmx/nested.c |  8 ++++----
 arch/x86/kvm/vmx/vmx.c    |  3 +--
 arch/x86/kvm/vmx/vmx.h    | 10 ++++++++++
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 6a61b1ae7942..9139c70b6008 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -334,6 +334,9 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 	 * versions: lower 8 bits is the minimal version, higher 8 bits is the
 	 * maximum supported version. KVM supports versions from 1 to
 	 * KVM_EVMCS_VERSION.
+	 *
+	 * Note, do not check the Hyper-V is fully enabled in guest CPUID, this
+	 * helper is used to _get_ the vCPU's supported CPUID.
 	 */
 	if (kvm_cpu_cap_get(X86_FEATURE_VMX) &&
 	    (!vcpu || to_vmx(vcpu)->nested.enlightened_vmcs_enabled))
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..28f9d64851b3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1982,7 +1982,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	bool evmcs_gpa_changed = false;
 	u64 evmcs_gpa;
 
-	if (likely(!vmx->nested.enlightened_vmcs_enabled))
+	if (likely(!guest_cpuid_has_evmcs(vcpu)))
 		return EVMPTRLD_DISABLED;
 
 	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa)) {
@@ -2863,7 +2863,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 	    nested_check_vm_entry_controls(vcpu, vmcs12))
 		return -EINVAL;
 
-	if (to_vmx(vcpu)->nested.enlightened_vmcs_enabled)
+	if (guest_cpuid_has_evmcs(vcpu))
 		return nested_evmcs_check_controls(vmcs12);
 
 	return 0;
@@ -3145,7 +3145,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 	 * L2 was running), map it here to make sure vmcs12 changes are
 	 * properly reflected.
 	 */
-	if (vmx->nested.enlightened_vmcs_enabled &&
+	if (guest_cpuid_has_evmcs(vcpu) &&
 	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
 		enum nested_evmptrld_status evmptrld_status =
 			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
@@ -5067,7 +5067,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	 * state. It is possible that the area will stay mapped as
 	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
 	 */
-	if (likely(!vmx->nested.enlightened_vmcs_enabled ||
+	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
 		   !nested_enlightened_vmentry(vcpu, &evmcs_gpa))) {
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..d4ed802947d7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1930,8 +1930,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * sanity checking and refuse to boot. Filter all unsupported
 		 * features out.
 		 */
-		if (!msr_info->host_initiated &&
-		    vmx->nested.enlightened_vmcs_enabled)
+		if (!msr_info->host_initiated && guest_cpuid_has_evmcs(vcpu))
 			nested_evmcs_filter_control_msr(msr_info->index,
 							&msr_info->data);
 		break;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 24d58c2ffaa3..35c7e6aef301 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -626,4 +626,14 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
 	return  lapic_in_kernel(vcpu) && enable_ipiv;
 }
 
+static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
+	 * eVMCS has been explicitly enabled by userspace.
+	 */
+	return vcpu->arch.hyperv_enabled &&
+	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
+}
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.37.2

