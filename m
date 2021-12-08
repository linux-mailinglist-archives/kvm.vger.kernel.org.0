Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB09646DA8D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 18:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238346AbhLHR7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 12:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbhLHR7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 12:59:15 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A795C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 09:55:43 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x131so3071107pfc.12
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 09:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PY5TBHZp/bIRIBSkb5Uw7ua7H/s5lZ3qdeik+BTn1Pk=;
        b=im5vrrf4coG/n0X6MHkvMB8YVVtVOHu1Xl5XB5t0Z+hZlFyg5PB5EYJWHrIN9WHX52
         29p+h6QqHBhsrC5zl11na9z4Tdid2Vwqx/xNL9rQv38UHEMHGtc7Jh/r+VCASNN6E56r
         zjZLCH6EYmSiXEHq87ovu3vQqJNixqNcV7TCTFAkBTou6h3OGxjJymiSykntrXtGls9o
         HCd5/VPrpbcTkudz8HEaX4eKiL6bRtqURz5DeqE1+xlamuz9EUbWFVKeeNwUClwqda35
         0uVfFwTB4Dwvh0OxeL9KzP4K/X9Pyf0Q/UOKlBFWezr/uO/TdXLojyZEboOlSp7ml/Qq
         oTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PY5TBHZp/bIRIBSkb5Uw7ua7H/s5lZ3qdeik+BTn1Pk=;
        b=pmFv6dRVXuCY+Jp3iN3zBPLM/DbBDvZVQwQcBwyZXoMkLueByNc/3BUjB6I/SUJI98
         cqirmTzFJhPL8s4+oVB4A1EALzTkVr26NCavv0tzvNO/w8WKp7+SpdWUDYCeucq+ljzm
         OEBcolvDNSRJCSDRe8i9FLgLgfzFKZEKKZM8tCC04f9MUgA97R2Ys/LpxbECjnQABuou
         cPS8sJtyS+SlJvD9zWSkwhTYx00+FekkDr2AlGWxgbxqzM9hKYw/YlGBoyRdtVzOEUaj
         MUWHBourW9kuJ/LlrbodcefO00NfaBltYDML3VgteGxnkNJbEtwvJGEt/nNy+82bH+PY
         NHlA==
X-Gm-Message-State: AOAM531A4OwCJXWqn4mNetsb5mZkY8FqLHnV+usEQDCcrnjkDrhtCeb4
        9xUH9RNUrqD4Tpj7pU+PEktJgp5BQSBsWg==
X-Google-Smtp-Source: ABdhPJxQ8XmbACD9eu5oHnuSuA8GmP976u54/DX2Fvk4hfEr8qHh8Sh0jC/MyJA++H+oFEHwMJtUzQ==
X-Received: by 2002:a05:6a00:2405:b0:4a8:3294:743e with SMTP id z5-20020a056a00240500b004a83294743emr6846488pfh.61.1638986142904;
        Wed, 08 Dec 2021 09:55:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 130sm4112937pfu.13.2021.12.08.09.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 09:55:42 -0800 (PST)
Date:   Wed, 8 Dec 2021 17:55:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] KVM: x86: Export kvm_pmu_is_valid_msr() for nVMX
Message-ID: <YbDxmhm3iqIT6ROl@google.com>
References: <20211108111032.24457-1-likexu@tencent.com>
 <20211108111032.24457-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108111032.24457-2-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is doing more than exporting a function, the export isn't even the focal
point of the patch.

On Mon, Nov 08, 2021, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Let's export kvm_pmu_is_valid_msr() for nVMX,  instead of

Please wrap at ~75 chars.

> exporting all kvm_pmu_ops for this one case.

kvm_pmu_ops doesn't exist as of this patch, it comes later in the series.

> The reduced access scope will help to optimize the kvm_x86_ops.pmu_ops stuff
> later.

The changelog needs to explain why it's ok to add the msr_idx_to_pmc() check.

Something like:

  KVM: nVMX: Use kvm_pmu_is_valid_msr() to check for PERF_GLOBAL_CTRL support

  Use the generic kvm_pmu_is_valid_msr() helper when determining whether or not
  PERF_GLOBAL_CTRL is exposed to the guest and thus can be loaded on nested
  VM-Enter/VM-Exit.  The extra (indirect!) call to msr_idx_to_pmc() that comes
  with the helper is unnecessary, but harmless, as it's guaranteed to return
  false for MSR_CORE_PERF_GLOBAL_CTRL and this is a already a very slow path.

  Using the helper will allow future code to use static_call() for the PMU ops
  without having to export any static_call definitions.

  Export kvm_pmu_is_valid_msr() as necessary.

All that said, looking at this whole thing again, I think I'd prefer:


From d217914c9897d9a2cfd01073284a933ace4709b7 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 8 Dec 2021 09:48:20 -0800
Subject: [PATCH] KVM: nVMX: Refactor PMU refresh to avoid referencing
 kvm_x86_ops.pmu_ops

Refactor the nested VMX PMU refresh helper to pass it a flag stating
whether or not the vCPU has PERF_GLOBAL_CTRL instead of having the nVMX
helper query the information by bouncing through kvm_x86_ops.pmu_ops.
This will allow a future patch to use static_call() for the PMU ops
without having to export any static call definitions from common x86.

Alternatively, nVMX could call kvm_pmu_is_valid_msr() to indirectly use
kvm_x86_ops.pmu_ops, but that would exporting kvm_pmu_is_valid_msr() and
incurs an extra layer of indirection.

Opportunistically rename the helper to keep line lengths somewhat
reasonable, and to better capture its high-level role.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 5 +++--
 arch/x86/kvm/vmx/nested.h    | 3 ++-
 arch/x86/kvm/vmx/pmu_intel.c | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 08e785871985..c87a81071288 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4773,7 +4773,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	return 0;
 }
 
-void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
+void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
+			    bool vcpu_has_perf_global_ctrl)
 {
 	struct vcpu_vmx *vmx;
 
@@ -4781,7 +4782,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 		return;
 
 	vmx = to_vmx(vcpu);
-	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
+	if (vcpu_has_perf_global_ctrl) {
 		vmx->nested.msrs.entry_ctls_high |=
 				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 		vmx->nested.msrs.exit_ctls_high |=
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b69a80f43b37..c92cea0b8ccc 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -32,7 +32,8 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
-void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
+void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
+			    bool vcpu_has_perf_global_ctrl);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1b7456b2177b..7ca870d0249d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -529,7 +529,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
+	nested_vmx_pmu_refresh(vcpu,
+			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
 
 	if (intel_pmu_lbr_is_compatible(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
-- 
2.34.1.400.ga245620fadb-goog
