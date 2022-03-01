Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8654C83AF
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiCAGEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiCAGEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:48 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A62160D89
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:08 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id e23-20020a6b6917000000b006406b9433d6so10023774ioc.14
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+fpfdzqr9xU6NfmbrsCOkjMW9hL4umQ1wJKtm6Q5JZs=;
        b=no+Ibs3wsh0D+E70vs93/QjCl+k4DLHqPqYoFrhxs3xZhOG14n6XeWlDsS1ZUWeyie
         uOB3RuY0uXv8RcGkB9QDDKgQ7qmzM8fhKCZYK4ol03bdPeoCKWTafhXrXx5PSmTvXhSQ
         sLkK6g+mA+8CzffSrriaE/HhdOB3r4XZ3Qb4MDXsIhRQAZBm4jT2LYAuqg2yjbfKHbqH
         GVJ61mBGfhv1evMdrAk8/LDher2oDSkL2UsxkAXQmt4Yxif6YkiXNRTvaQ587JvchF24
         VVIh7wvi0+8ePz8Zf32z7sf5fb14HznrsYFdyjSSmWv2TcsMymMM6L8xMXhQ76S32BMU
         JK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+fpfdzqr9xU6NfmbrsCOkjMW9hL4umQ1wJKtm6Q5JZs=;
        b=rzpMHU4RM83lXiOps5eu5lrecTowjfk9cPP8lDFV6K0QcPWWViFqmPc3hMUeB8FQ1O
         3w4NnpBgkkVa/ypPximoR74g9X38PEvzx1zijSNqak0UfmG0wflslyTEpe4C5hkQ6QP1
         3C+NaXs8zim1cukWfLghaqMPYr+iJ2yz1z2BW/nExIiRLoifdRod2khLAxgjIgxxxF5b
         9La6ckpFhre4NLkv09gFcWhxItW023KYUAccYMAD9NRP8wDmKmF9y1TvyOm9YYl7vwO7
         nf+BiftAM8r1r0seBa9UE4h+x7xcwdsC9XDBXvKqYZ2IS2j/9xSOkGCFb1hhGfOZVfVe
         bJpA==
X-Gm-Message-State: AOAM530ylvJ6Mttq3ET/ALi1jEGjnfkx7DRnGMqJshZUUxFaiquUBHJF
        LqNaWrk/5uCz6ne5TJahjiFyOLlt4N1EOM9aHWQGb5h7evoV4+XfDEy0XSkwzqO7qP6ToZZl6XH
        gJYarvaXGsGU4XiFB2IIMaqOPTuM9Q7ehLEeDa78Nk2fhbNeWsATHPuznUA==
X-Google-Smtp-Source: ABdhPJxvEf4u6yFjoA+HIY8bQ+rp8oxkHIsWac2zz+fAUHyxtA9ycZdNZuTuQGY65105CO04FHV2AEy+a3M=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:e0d:b0:2bf:5556:4c4a with SMTP id
 a13-20020a056e020e0d00b002bf55564c4amr21252743ilk.31.1646114647819; Mon, 28
 Feb 2022 22:04:07 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:46 +0000
In-Reply-To: <20220301060351.442881-1-oupton@google.com>
Message-Id: <20220301060351.442881-4-oupton@google.com>
Mime-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 3/8] KVM: nVMX: Drop nested_vmx_pmu_refresh()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_vmx_pmu_refresh() is now unneeded, as the call to
nested_vmx_entry_exit_ctls_update() in vmx_vcpu_after_set_cpuid()
guarantees that the VM-{Entry,Exit} control MSR changes are applied
after setting CPUID. Drop all vestiges of nested_vmx_pmu_refresh().

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 22 ----------------------
 arch/x86/kvm/vmx/nested.h    |  2 --
 arch/x86/kvm/vmx/pmu_intel.c |  3 ---
 3 files changed, 27 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a13f8f4e3d82..dec45606ce0c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4806,28 +4806,6 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
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
index c92cea0b8ccc..14ad756aac46 100644
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
index 4e5b1eeeb77c..6433a1091333 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -541,9 +541,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	nested_vmx_pmu_refresh(vcpu,
-			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
-
 	if (intel_pmu_lbr_is_compatible(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
-- 
2.35.1.574.g5d30c73bfb-goog

