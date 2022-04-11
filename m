Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC23A4FB967
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345362AbiDKKYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345521AbiDKKWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:55 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8172B3F89E;
        Mon, 11 Apr 2022 03:20:41 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k14so13819171pga.0;
        Mon, 11 Apr 2022 03:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vJaHaz0KFGmDsC5Hs4aNvrwMBMAGrIjrYVANwcH2Ay4=;
        b=lqKt4ake3F4700E71NnCaowOthLiFwaZqqbahm936uui8RL5RFbWALOhEpjByZGyF3
         c2uKu6OqoJK3cBNVdjC0STJAyu4sfNqsc4OrV8rA8pWejJ/ocRfKKQvcntR2cp/E3Vrk
         e+AnCXqPERfJibH0DOwkmCACTtm1Dfe1Q/WFemb9BMQPFoUIn/E8QdwCPmZLWoOEpItk
         1DypE2JzEXiGvSa9LUIRHTTNUKEcqemJcpbvDRPbUQVfmJIF5wYdHQ0ki2FetK+d29Zk
         iarRsGPDLXQlUM3BzHDShOIja+Aij8H1BUpRIKEncY2n+JSP07jdZhkRHLDRGg5iXHzd
         qYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vJaHaz0KFGmDsC5Hs4aNvrwMBMAGrIjrYVANwcH2Ay4=;
        b=S21fp3eKjOfCJ6VCNJoNZlwNKQnJ21Ls5EpsvzTu0+O349wx6zajLfDJcQs+HKdmxv
         EuBCIRcg57n/BQRlhbU7aVBq0Tj/SxUqcCEo0vzWU51XR4XBACmY0YG/4bfOL9NYpyCI
         5u9E+tC4iR23s8SV3GgazdfBN1hnG9I+4mTgC+GboV65Lm2ZxsASaCw1kePWE+IvEQlE
         udO4nIJ4qQuC1swOFr9yL009v5wVH1ncOg0KPpkmYqjkn3V3f1w7TfdAcC7FZtY57/T6
         bDdI/hCgdRESaxf/NOgkmMIum/nb+EC+CVgwD7veBciSxZeFx7uG1a4R/IHdYf937ag1
         N3mg==
X-Gm-Message-State: AOAM531wBQ3DlCa3eDHiRfMDU8NJUbYHfc8b83p1Dtm3rvCgGMs/WR2x
        WITHsX5ydCkpmOWEAg4U+Qg=
X-Google-Smtp-Source: ABdhPJw3jaBb29N1ugVFM8tRPizhnJ+doDoiTtXwSP8r0pdh0ox3OlPYZMiv0tQn1P40X5a/TN42Qg==
X-Received: by 2002:aa7:8049:0:b0:4fd:bfde:45eb with SMTP id y9-20020aa78049000000b004fdbfde45ebmr32226488pfm.76.1649672441038;
        Mon, 11 Apr 2022 03:20:41 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:40 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 16/17] KVM: x86/cpuid: Refactor host/guest CPU model consistency check
Date:   Mon, 11 Apr 2022 18:19:45 +0800
Message-Id: <20220411101946.20262-17-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

For the same purpose, the leagcy intel_pmu_lbr_is_compatible() can be
renamed for reuse by more callers, and remove the comment about LBR
use case can be deleted by the way.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/cpuid.h         |  5 +++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 +-----------
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 arch/x86/kvm/vmx/vmx.h       |  1 -
 4 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 8a770b481d9d..ac72aabba981 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -145,6 +145,11 @@ static inline int guest_cpuid_model(struct kvm_vcpu *vcpu)
 	return x86_model(best->eax);
 }
 
+static inline bool cpuid_model_is_consistent(struct kvm_vcpu *vcpu)
+{
+	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
+}
+
 static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f2c94e9dfa4b..84b326c4dce9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -167,16 +167,6 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * As a first step, a guest could only enable LBR feature if its
-	 * cpu model is the same as the host because the LBR registers
-	 * would be pass-through to the guest and they're model specific.
-	 */
-	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
-}
-
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 {
 	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
@@ -599,7 +589,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	nested_vmx_pmu_refresh(vcpu,
 			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
 
-	if (intel_pmu_lbr_is_compatible(vcpu))
+	if (cpuid_model_is_consistent(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8d768592c8c..945d169eb07f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2237,7 +2237,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PMU_CAP_LBR_FMT) !=
 			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
 				return 1;
-			if (!intel_pmu_lbr_is_compatible(vcpu))
+			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9d890e600d27..ef2a2aeccb19 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -95,7 +95,6 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
-- 
2.35.1

