Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C3E4AA159
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238117AbiBDUrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbiBDUrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:47:14 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2B7C06173D
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:47:13 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id z11-20020a056e0217cb00b002bab54d8254so4839195ilu.18
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t3bi6FbPBwbvFSpb5eud1+ec03s+bf56QCIyPFsES0U=;
        b=mpqMxckHGLPsT+uHuy09F7pFKbqRjBmE6sLIY6YD6HPx9DYJtDSyziIxfisKAIkFAF
         uUd3OLCFvbDgF9C1aAxkAJGDkUDZ73wRroRNoEWXz/waip1Fbx9xk54+ovf9+JRQGjgU
         nS50h1LsenI+hdnImHkLJiXUTNyiNKLLcTvTDpAi64jhKD3Ki5CZg4pOHImaGHEIaWFw
         RL3AZejhcKyZMeyshJ2kWNwuCd0CaGXyrsop7JUyxra7LlH+AcGnjZwLebjckjEMkNvg
         Q8Pq4xZ2LZf7hVXFaO+maWq6H8Kmqhpd+FGn6J9GG1S1ZnQCv470UAP1D9liQv/hasxf
         R+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t3bi6FbPBwbvFSpb5eud1+ec03s+bf56QCIyPFsES0U=;
        b=Lway4v5wti8NoPfFksXpBk6mmviG8OlGmc4d+YYkP3FCmrZ8rmuH7kSxQN8V42GrKS
         jgo2oDhxfQJVarxmp4q8VjDKeHSSHcSvfprrDyPo2He10oe/uKKmPq0b7uxvmm9evRII
         zxowry/2/huL5TYkQ6N1jEkJvedL0eKLo1e6AoT7Ttch+U+TZk6dU0l1af7r5B0jNLw5
         gSWq6VUJDddwlkcfR3g/GFj9/iMBkT55fA5/YRavGuyYV5n+6FOHrpeXZs9EivyaVuQd
         vIVfSRYM9Q0wXsu+k7I7vgmMFMjJGf22p0CHvzWBU1z7Wmz0Gj3V1fmI730AtrHHqCEf
         kEDQ==
X-Gm-Message-State: AOAM532CRgBlKSq3sEUw8HQJLrG26P9Z3ywuolFUCziE99DwlVQB8H5X
        QKPBwjRl8tyB/JeCZESEWFmrKegL3znkkDUzk1fztmD34COzGuZuQbxVh6+FRWRmeRilUWqQP6V
        CUFz05Skn+tzVym0GwwtGO3i8/7GXZpBHU9IBxnDC4puy/HJX111YzFTooQ==
X-Google-Smtp-Source: ABdhPJz68v1EL2eR2+Ct0VcHGf11IEXNE7eQ64dRIRCyEsK2OO17lW5RuOO6z5DFi5ACny/1AYQacP4PDek=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1407:: with SMTP id
 t7mr407600iov.82.1644007632693; Fri, 04 Feb 2022 12:47:12 -0800 (PST)
Date:   Fri,  4 Feb 2022 20:47:01 +0000
In-Reply-To: <20220204204705.3538240-1-oupton@google.com>
Message-Id: <20220204204705.3538240-4-oupton@google.com>
Mime-Version: 1.0
References: <20220204204705.3538240-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v2 3/7] KVM: nVMX: Roll all entry/exit ctl updates into a
 single helper
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_vmx_pmu_entry_exit_ctls_update() is no longer useful; updating
the entry/exit ctrl bits in the vendor vcpu_after_set_cpuid() hook is
sufficient as KVM has already recalculated the vPMU version.

Keep all of KVM's bad behavior with regards to the VMX entry/exit
control MSRs in one place. Remove all traces of the PMU helper and
inline the bit twiddling to nested_vmx_entry_exit_ctls_update().

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 21 ---------------------
 arch/x86/kvm/vmx/nested.h    |  1 -
 arch/x86/kvm/vmx/pmu_intel.c |  2 --
 arch/x86/kvm/vmx/vmx.c       |  8 +++++++-
 4 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 59164394569f..2e8facff93f8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4806,27 +4806,6 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	return 0;
 }
 
-void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx;
-
-	if (!nested_vmx_allowed(vcpu))
-		return;
-
-	vmx = to_vmx(vcpu);
-	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
-		vmx->nested.msrs.entry_ctls_high |=
-				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-		vmx->nested.msrs.exit_ctls_high |=
-				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-	} else {
-		vmx->nested.msrs.entry_ctls_high &=
-				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-		vmx->nested.msrs.exit_ctls_high &=
-				~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-	}
-}
-
 static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
 				int *ret)
 {
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b69a80f43b37..14ad756aac46 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -32,7 +32,6 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
-void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18fc0c5d..ad1adbaa7d9e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -541,8 +541,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
-
 	if (intel_pmu_lbr_is_compatible(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 54ac382a0b73..395787b7e7ac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7243,7 +7243,13 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
+	if (kvm_pmu_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
+		vmx->nested.msrs.entry_ctls_high |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	} else {
+		vmx->nested.msrs.entry_ctls_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	}
 }
 
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
-- 
2.35.0.263.gb82422642f-goog

