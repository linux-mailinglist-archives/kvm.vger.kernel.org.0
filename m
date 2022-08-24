Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F055E59F1AF
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiHXDDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiHXDDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:09 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5CD804AB
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:51 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x25-20020aa79199000000b005358eeebf49so6856457pfa.17
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=olbpL+NaVOYsI4Xr8BzcusB39cQfgNIDdbMwqWi7qQw=;
        b=iwYx+3djlFAdWRM2QG3eRWk3P1j82ZwGbYXW2NZ1tT0Edbe3wrG2hmx2yUNkGSLURu
         uynPd6lMTaz1P70c8hndMXZrxpww0JJRTiwYx9W6ScJCcNrw9QfIwZ0wA0jQgIoC10HJ
         QI8ST3vIVsg/997MG7c81ixPI9xBblYb30Sf/8v5L1hMMLdcfr8PZ4Ix66mDq4Rz7Q8k
         Z4ooaJMnDwYS6iX0QIFFGioADQfyeGackEIrQrWjXmZ65ItdqiWZIS7MzA21VzsTJDwD
         2XIz79y5QVQGujRRKIWS1sxZ1HgJTmzK78R6390+em/Bx+LmzJpf9d95RQVUtjMu94cc
         K33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=olbpL+NaVOYsI4Xr8BzcusB39cQfgNIDdbMwqWi7qQw=;
        b=oBNRkLtSK7Qw61qk2Nt8SrhnEJiWBITIX5zbDeXffwHMXAxu39t303m7vKmR/bInGz
         xNaJwrlXPW8QYPXMy9IeXDaqONTGt/S9ghYkjxGwfms/bRUj58ZqqYE4To7NOIQFGAQX
         Pa9GmzQVv7bv1ebqxB1RAUb2vXMdh+ZG95Q5/Zmoy9urT/wCLOOTvYJWHpRhyBUyYY5l
         Uz9hE833MrxcLkoS7XncWS+wB+ApME3Fbl9hVFM+/rBQeNjOfhWnxi4IAMxmAWKUPaAl
         95t46fKd/iRJoTJMiBCw0kEd+IBne5cpOlG9XuPsAVVRwCO2Rm0SqLg0HrjoUpkpJPih
         10rg==
X-Gm-Message-State: ACgBeo06lPlN/y0Cko/GJcSN1yX7Br5/epz3biYDYkB8mnK6FV7dXoGI
        yrkx1DSDzivS8dmepdjXvIHWiMvLBp0=
X-Google-Smtp-Source: AA6agR60xbhufI4JWtZWmaNKtgUaDbX1ylw6pFK6dxrsd0xru/iEvt8Brbyk7KF6CM6DEg7fjXMcUq/fl80=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:14c7:b0:52e:efb7:bd05 with SMTP id
 w7-20020a056a0014c700b0052eefb7bd05mr27311034pfu.24.1661310111354; Tue, 23
 Aug 2022 20:01:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:08 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 06/36] KVM: nVMX: Treat eVMCS as enabled for guest iff
 Hyper-V is also enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When querying whether or not eVMCS is enabled on behalf of the guest,
treat eVMCS as enable if and only if Hyper-V is enabled/exposed to the
guest.

Note, flows that come from the host, e.g. KVM_SET_NESTED_STATE, must NOT
check for Hyper-V being enabled as KVM doesn't require guest CPUID to be
set before most ioctls().

Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.37.1.595.g718a3a8f04-goog

