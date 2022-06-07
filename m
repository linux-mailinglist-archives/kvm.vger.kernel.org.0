Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F397542381
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443774AbiFHBAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382651AbiFGXjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:05 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D863E17067E
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id j15-20020a17090a738f00b001e345e429d2so9819702pjg.0
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=b2y6HIM0yFuupb/Asz+ocPiupQ2BH2KLPsPF8kzjrkw=;
        b=m9SlpsGTqZNrbbB28kCBcURN1oC2as0iS1/ePdYn+z9eVKChoC0y5YYloYFRM6viLn
         MwdmyILQveyGVDpO50TdB8AnQZapzqw9WtsZ9c6tol2WHl2eOmthABe6MA9jd0KVU++E
         uPc51dyF0P2g9keIN2hwDykX7XCJI5GZg1SfKPjrscBSw/U1/4swV3Tnn8MxFbdbocYw
         ifJr35+TuoVkg2KGklLjtR3nccuVqd2rieEm7huqqv6g82byL4uL2QqnZBFjmUr2Sh/8
         pioxGoHE/ToGuY4gzekI9l/Llte/+S1BNToib5RDZOD1haOfL7gcI/jvzaqTcHFgIcog
         /iTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=b2y6HIM0yFuupb/Asz+ocPiupQ2BH2KLPsPF8kzjrkw=;
        b=JDWm5ir2YqQlDRL5hyGWtz7xdaiTy2LkdaWAxNkU021oi30Tl221viV6nG6inH79OJ
         Ov6DQCRLgg+Fbgv4Ts5RnvlGSxgQTGjY3s1FnGq5L6YrzH7pSysrikLqbUcy3pG8L9Zv
         GHaAIZswrcBGrVOw6I3T9WHY1PEoOLbYzxpRVybPWwu6Kb1mt5HXnGK9FuA+FfI8G2MW
         fLNngTerFdrF8JpkEKbqHvy1VrPUhcstiuguk2CDATx9LG7YlSaYaDh3fo8L8Wks5aEq
         YdG/cyQdawPeTohsUGZphxZMQItBprwwDAIogQIBsFTfbeWY87Md1djNZeoF79SnQQWq
         TePg==
X-Gm-Message-State: AOAM532/Ne06mTcrcoE+BFG2/1zP2beKssd87uBzbSPgARog7KLQrSF2
        cvxgTGuA74Y7hv023U52zfJoydn0N0U=
X-Google-Smtp-Source: ABdhPJwgtT75q6YVsktniY/VHzibvVaHAIcTz9UivR7D0BpOChyXwBs/01A9v7fwrZCt9bFCGn2ylPNciYw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:8890:0:b0:51c:454f:c93f with SMTP id
 z16-20020aa78890000000b0051c454fc93fmr3586124pfe.35.1654637793364; Tue, 07
 Jun 2022 14:36:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:58 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 09/15] KVM: nVMX: Drop nested_vmx_pmu_refresh()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

nested_vmx_pmu_refresh() is now unneeded, as the call to
nested_vmx_entry_exit_ctls_update() in vmx_vcpu_after_set_cpuid()
guarantees that the VM-{Entry,Exit} control MSR changes are applied
after setting CPUID. Drop all vestiges of nested_vmx_pmu_refresh().

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 22 ----------------------
 arch/x86/kvm/vmx/nested.h    |  2 --
 arch/x86/kvm/vmx/pmu_intel.c |  3 ---
 3 files changed, 27 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d1c21d387716..4ba0e5540908 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4847,28 +4847,6 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	return 0;
 }
 
-void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
-			    bool vcpu_has_perf_global_ctrl)
-{
-	struct vcpu_vmx *vmx;
-
-	if (!nested_vmx_allowed(vcpu))
-		return;
-
-	vmx = to_vmx(vcpu);
-	if (vcpu_has_perf_global_ctrl) {
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
index 129ae4e01f7c..88b00a7359e4 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -32,8 +32,6 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
-void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
-			    bool vcpu_has_perf_global_ctrl);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6ce3b066f7d9..515ab6594333 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -597,9 +597,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	nested_vmx_pmu_refresh(vcpu,
-			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL, false));
-
 	if (cpuid_model_is_consistent(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
-- 
2.36.1.255.ge46751e96f-goog

